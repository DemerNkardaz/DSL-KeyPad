Class MyRecipesReg {
	__New(filePath) {
		SplitPath(filePath, &fileName, , &ext, &nameNoExt)
		this.filePath := filePath
		this.fileName := fileName
		this.nameNoExt := nameNoExt
		this.ext := ext
		this.supportedLanguages := Language.GetSupported()
		this.LoadData()
		this.Reg()
		return
	}

	LoadData() {
		if this.fileName ~= "i)XCompose" && !(this.ext ~= "i)(ini|json)")
			this.content := XComposeToEntriesParser(this.filePath).output
		else if this.ext = "ini"
			this.content := Util.INIToArray(this.filePath)
		else
			this.content := JSON.LoadFile(this.filePath, "UTF-8")
		return
	}

	Reg() {
		local optionsData := Map("prefix", [], "no_whitespace", 0)

		Loop this.content.Length // 2 {
			local index := A_Index * 2 - 1
			local recipeName := this.content[index]
			local recipeData := this.content[index + 1]

			if !(recipeName is String) || !(recipeData is Map) {
				MsgBox(Locale.ReadInject("warnings.user_defined_recipes.recipe_format_is_invalid", [recipeName is String ? recipeName : Type(recipeName), this.filePath]), App.Title(), "Iconx")
				continue
			} else if recipeName != "options" && (
				!recipeData.Has("recipe") || recipeData["recipe"] = "" ||
				!recipeData.Has("result") || recipeData["result"] = ""
			) {
				MsgBox(Locale.ReadInject("warnings.user_defined_recipes.recipe_or_result_has_empty_value", [recipeName, this.filePath]), App.Title(), "Icon!")
				continue
			}

			if recipeName = "options" {
				this.ProcessOptions(&recipeData, &optionsData)
				continue
			}

			this.ProcessData(&recipeData, &optionsData)
			MyRecipesStore.Set(recipeName, recipeData)
		}
		return
	}

	ProcessOptions(&recipeData, &optionsData) {
		for key, value in recipeData {
			if key = "prefix" && value is String && value ~= ".*|.*"
				optionsData[key] := StrSplit(value, "|")
			else
				optionsData.Set(key, value)
		}
		return
	}

	ProcessData(&recipeData, &optionsData) {
		if recipeData.Has("name") && recipeData["name"] ~= ".*|.*" {
			local names := StrSplit(recipeData["name"], "|")

			recipeData.Set("titles", Map())

			for name in names
				if (RegExMatch(name, '^(?<languageCode>.*):(?<title>.*)', &match))
					if this.supportedLanguages.HasValue(match["languageCode"], &i) || this.supportedLanguages.HasRegEx("^" match["languageCode"], &i)
						recipeData["titles"].Set(this.supportedLanguages[i], match["title"])
		}

		if !recipeData.Has("tags")
			recipeData["tags"] := []
		if !recipeData.Has("filePath")
			recipeData["filePath"] := this.filePath

		if recipeData["recipe"] is String
			recipeData["recipe"] := StrSplit(recipeData["recipe"], "|")

		if recipeData["result"] is Array && recipeData["result"].Length > 1
			recipeData["result"] := [recipeData["result"].ToString("")]

		if recipeData["result"] is String
			recipeData["result"] := StrSplit(recipeData["result"], "|")

		if recipeData["tags"] is String
			recipeData["tags"] := StrSplit(recipeData["tags"], "|")

		if !recipeData.Has("groups")
			recipeData["groups"] := ["Custom Composes", "User Composes"]

		if optionsData["prefix"].Length > 0
			for i, recipe in recipeData["recipe"]
				recipeData["recipe"][i] := optionsData["prefix"][i < optionsData["prefix"].Length ? i : 1] (optionsData["no_whitespace"] ? "" : " ") recipe


		MyRecipesStore.lastIndexAdded++
		recipeData["index"] := MyRecipesStore.lastIndexAdded
		return
	}
}