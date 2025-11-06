Class MyRecipes {
	static file := "CustomRecipes.json"
	static filePath := App.PATHS.PROFILE "\" this.file
	static sampleFile := App.PATHS.DATA "\user_defined_recipes_sample.json"
	static autoimport := { xcompose: App.PATHS.PROFILE "\XCompose", CustomRecipes: App.PATHS.PROFILE "\CustomRecipes" }
	static sectionValidator := "^[A-Za-z_][A-Za-z0-9_]*$"

	static __New() {
		this.Init()
		return
	}

	static Init() {
		for key, value in this.autoimport.OwnProps()
			if !DirExist(value)
				DirCreate(value)

		if !FileExist(this.filePath)
			FileCopy(this.sampleFile, this.filePath)

		if !FileExist(this.autoimport.xcompose "\demo.XCompose")
			FileAppend('<Multi_key> <0> <0> : "' Chr(0x221E) '" # U+221E INFINITY', this.autoimport.xcompose "\demo.XCompose", "UTF-8")

		MyRecipesReg(this.filePath)

		Loop Files this.autoimport.CustomRecipes "\*", "FR"
			if A_LoopFileFullPath ~= "i)\.(ini|json)$"
				MyRecipesReg(A_LoopFileFullPath)

		Loop Files this.autoimport.xcompose "\*", "FR"
			if A_LoopFileFullPath ~= "i)(XCompose)$"
				MyRecipesReg(A_LoopFileFullPath)

		local registeredRecipesData := MyRecipesStore.GetAll("IndexList AsArray")
		ChrReg(registeredRecipesData, "Custom")
		return
	}


	static Check(sectionName) {
		content := FileRead(this.filePath, "UTF-16")

		sections := []
		for line in StrSplit(content, "`n") {
			if RegExMatch(line, "^\[(.*)\]$", &match) {
				sections.Push(match[1])
			}
		}

		if sections.HasValue(sectionName) {
			return True
		}

		return False
	}

	static Update() {
		for key, value in this.autoimport.OwnProps()
			if !DirExist(value)
				DirCreate(value)

		if !FileExist(this.filePath)
			FileCopy(this.sampleFile, this.filePath)

		MyRecipesStore.Clear()

		MyRecipesReg(this.filePath)

		Loop Files this.autoimport.CustomRecipes "\*", "FR"
			if A_LoopFileFullPath ~= "i)\.(ini|json)$"
				MyRecipesReg(A_LoopFileFullPath)

		Loop Files this.autoimport.xcompose "\*", "FR"
			if A_LoopFileFullPath ~= "i)(XCompose)$"
				MyRecipesReg(A_LoopFileFullPath)

		local registeredRecipesData := MyRecipesStore.GetAll("IndexList AsArray")
		ChrReg(registeredRecipesData, "Custom")

		DottedProgressTooltip(, &triggerEnds := False)
		ChrLib.CountOfUpdate()
		triggerEnds := True
		return
	}
}