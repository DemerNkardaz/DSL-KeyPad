Class MyRecipesStore {
	static storedData := Map()
	static lastIndexAdded := -1

	static GetAll(rule := "") {
		if this.storedData.Count = 0
			return False

		if InStr(rule, "IndexList") {
			local output := Map()

			for recipeName, recipeEntry in this.storedData
				output.Set(this.storedData[recipeName]["index"], recipeName)

			if InStr(rule, "AsArray") {
				local interOutput := []
				for index, recipeName in output {
					local recipeEntry := this.Get(recipeName).Clone()
					if RegExMatch(rule, "File:(.*)$", &fileMatch) {
						if recipeEntry["filePath"] = fileMatch[1]
							interOutput.Push(recipeName, recipeEntry)
					} else
						interOutput.Push(recipeName, recipeEntry)
				}

				return interOutput
			}

			return output
		} else
			return this.storedData
	}

	static DumpDefault() {
		local recipesFile := MyRecipes.filePath
		local outputData := this.GetAll(Format("IndexList AsArray File:{}", MyRecipes.file))
		local whitelist := ["name", "recipeRaw", "result", "tagsRaw"]

		Loop outputData.Length // 2 {
			local index := A_Index * 2 - 1
			local recipeName := outputData[index]
			local recipeEntry := outputData[index + 1]

			local keysToDelete := []
			for key, value in recipeEntry {
				if !whitelist.HasValue(key) || value is String && value = ""
					keysToDelete.Push(key)
			}

			for _, key in keysToDelete {
				recipeEntry.Delete(key)
			}

			for key, value in recipeEntry {
				if key ~= "Raw$" {
					local valueCopy := value
					local newKey := StrReplace(key, "Raw")
					recipeEntry.Delete(key)
					if valueCopy != ""
						recipeEntry.Set(newKey, valueCopy)
				}
			}

			if InStr(recipeEntry["result"][1], "`n") {
				local dividedStrings := []
				local split := StrSplit(recipeEntry["result"][1], "`n", "`r")

				for i, splitString in split {
					if i = split.Length && splitString = ""
						break
					else
						dividedStrings.Push(splitString (i < split.Length ? "`n" : ""))
				}

				recipeEntry["result"] := dividedStrings
			}
		}

		FileCopy(recipesFile, recipesFile ".bak", 1)
		JSONExt.DumpFile(outputData, recipesFile, 1, "UTF-8-RAW")
		return
	}

	static Get(name) {
		return this.storedData.Has(name) ? this.storedData.Get(name) : False
	}

	static Set(name, value) {
		if !this.storedData.Has(name) {
			this.lastIndexAdded++
			value["index"] := this.lastIndexAdded
			local filePath := value.Get("filePath")
			if filePath != MyRecipes.file
				value["index"] += (filePath ~= "i)XCompose" ? 10000 : 5000)
		} else {
			local indexCopy := this.storedData[name].Get("index")
			value["index"] := indexCopy
		}

		this.storedData.Set(name, value)
		return
	}

	static Has(name) {
		return this.storedData.Has(name)
	}

	static Rename(name, newName) {
		this.storedData.Set(newName, this.storedData.Get(name))
		this.storedData.Delete(name)
		return
	}

	static Delete(name) {
		this.storedData.Delete(name)
		return
	}

	static Clear() {
		local count := this.storedData.Count
		local entryNames := this.storedData.Keys()

		this.storedData := Map()

		lastIndexAdded := -1
		ChrLib.lastIndexAdded -= count

		for entryName in entryNames
			if ChrLib.HasOwnProp(entryName)
				ChrLib.DeleteProp(entryName)

		return
	}
}