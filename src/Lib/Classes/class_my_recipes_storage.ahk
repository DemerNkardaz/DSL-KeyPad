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
					local recipeEntry := this.Get(recipeName)
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

	static Get(name) {
		return this.storedData.Has(name) ? this.storedData.Get(name) : False
	}

	static Set(name, value) {
		if !this.storedData.Has(name)
			this.lastIndexAdded++
		this.storedData.Set(name, value)
		return
	}

	static ProcessData(data) {

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