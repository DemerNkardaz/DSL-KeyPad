Class MyRecipes {

	static file := App.paths.dir "\CustomCompose.ini"
	static editorTitle := App.winTitle " — " ReadLocale("gui_recipes_create")

	static __New() {

	}

	static EditorGUI := Gui()

	static Editor(sectionName := [], recipesLV?) {

		Constructor() {
			this.editorTitle := App.winTitle " — " ReadLocale("gui_recipes_create")
			data := {
				section: "",
				name: "",
				recipe: "",
				result: "",
				row: 0,
			}

			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := 300
			windowHeight := 450

			xPos := (screenWidth - windowWidth) / 2
			yPos := screenHeight - windowHeight - 92

			recipeCreator := Gui()
			recipeCreator.title := this.editorTitle

			defaultSizes := { groupBoxW: 280, groupBoxX: (windowWidth - 280) / 2 }

			boxCommonY := 10
			boxCommonH := windowHeight - 20

			commonX := (add := 0) => (defaultSizes.groupBoxX) + 15 + add
			commonY := (add := 0) => (boxCommonY) + 20 + add

			recipeCreator.AddGroupBox("vGroupCommon " "x" defaultSizes.groupBoxX " y" boxCommonY " w" defaultSizes.groupBoxW " h" boxCommonH)

			sectionLabel := recipeCreator.AddText("vSectionLabel x" commonX() " y" commonY() " w150 BackgroundTrans", ReadLocale("gui_recipes_create_section"))
			sectionEdit := recipeCreator.AddEdit("vSectionEdit x" commonX() " y" commonY(20) " w250 Limit48 -Multi" (sectionName.Length > 0 ? " ReadOnly" : ""), sectionName.Length > 0 ? sectionName[4] : "")

			nameLabel := recipeCreator.AddText("vNameLabel x" commonX() " y" commonY(55) " w150 BackgroundTrans", ReadLocale("gui_recipes_create_name"))
			nameEdit := recipeCreator.AddEdit("vNameEdit x" commonX() " y" commonY(55 + 20) " w250 -Multi", sectionName.Length > 0 ? MyRecipes.Get(sectionName[4]).name : "")

			recipeLabel := recipeCreator.AddText("vRecipeLabel x" commonX() " y" commonY(110) " w150 BackgroundTrans", ReadLocale("gui_recipes_create_recipe"))
			recipeEdit := recipeCreator.AddEdit("vRecipeEdit x" commonX() " y" commonY(110 + 20) " w250 -Multi", sectionName.Length > 0 ? MyRecipes.Get(sectionName[4]).recipe : "")

			resultLabel := recipeCreator.AddText("vResultLabel x" commonX() " y" commonY(110 + 55) " w150 BackgroundTrans", ReadLocale("gui_recipes_create_result"))
			resultEdit := recipeCreator.AddEdit("vResultEdit x" commonX() " y" commonY((110 + 55) + 20) " w250 h150 Multi", sectionName.Length > 0 ? RegExReplace(MyRecipes.Get(sectionName[4]).result, "\\n", "`n") : "")

			if sectionName.Length > 0 {
				data.section := sectionName[4]
				data.name := MyRecipes.Get(sectionName[4]).name
				data.recipe := MyRecipes.Get(sectionName[4]).recipe
				data.result := MyRecipes.Get(sectionName[4]).result
				data.row := sectionName[5]
			}

			saveBtn := recipeCreator.AddButton("vSaveButton x" commonX() " y" (boxCommonH) - 32 " w100 h32", ReadLocale("gui_save"))
			cancelBtn := recipeCreator.AddButton("vCancelButton x" commonX(100) " y" (boxCommonH) - 32 " w100 h32", ReadLocale("gui_cancel"))

			sectionEdit.OnEvent("Change", (CB, Zero) => setData(CB, "section"))
			nameEdit.OnEvent("Change", (CB, Zero) => setData(CB, "name"))
			recipeEdit.OnEvent("Change", (CB, Zero) => setData(CB, "recipe"))
			resultEdit.OnEvent("Change", (CB, Zero) => setData(CB, "result"))

			saveBtn.OnEvent("Click", (*) => saveRecipe(data))
			cancelBtn.OnEvent("Click", (*) => WinClose(this.editorTitle))

			recipeCreator.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)
			return recipeCreator

			setData(CB, key) {
				data.%key% := CB.Text
			}

			saveRecipe(data) {
				if StrLen(data.section) > 0 && StrLen(data.name) > 0 && StrLen(data.recipe) > 0 && StrLen(data.result) > 0 {
					MyRecipes.AddEdit(data.section, data)
					if IsGuiOpen(Cfg.EditorSubGUIs.recipesTitle) && data.row > 0 {
						recipesLV.Modify(data.row, , data.name, data.recipe, data.result)

					} else if IsGuiOpen(Cfg.EditorSubGUIs.recipesTitle) && data.row = 0 {
						recipesLV.Add(, data.name, data.recipe, data.result, data.section)
					}
				}
			}
		}

		if IsGuiOpen(this.editorTitle) {
			WinActivate(this.editorTitle)
		} else {
			this.EditorGUI := Constructor()
			this.EditorGUI.Show()
		}
	}

	static AddEdit(sectionName, params) {
		IniWrite(params.name, this.file, sectionName, "name")
		IniWrite(params.recipe, this.file, sectionName, "recipe")
		IniWrite(params.result, this.file, sectionName, "result")
		UpdateCustomRecipes()
		return
	}

	static Get(sectionName) {
		output := {}

		output.name := IniRead(this.file, sectionName, "name")
		output.recipe := IniRead(this.file, sectionName, "recipe")
		output.result := IniRead(this.file, sectionName, "result")

		return output
	}

	static Remove(sectionName) {
		filePath := this.file
		content := FileRead(filePath, "UTF-16")

		if !content {
			return False
		}

		regex := "\[" sectionName "\]\R(?:[^\[\r\n]*\R)*"

		newContent := RegExReplace(content, regex)

		if (newContent == content) {
			return False
		}

		FileDelete(filePath)
		FileAppend(newContent, filePath, "UTF-16")

		UpdateCustomRecipes()
		return True
	}

	static Read() {
		output := []

		try {
			content := FileRead(this.file, "UTF-16")
			if !content {
				return output
			}

			sections := []
			for line in StrSplit(content, "`n") {
				if RegExMatch(line, "^\[(.*)\]$", &match) {
					sections.Push(match[1])
				}
			}

			for section in sections {
				try {
					name := IniRead(this.file, section, "name")
					recipe := IniRead(this.file, section, "recipe")
					result := IniRead(this.file, section, "result")

					output.Push({
						section: section,
						name: name,
						recipe: recipe,
						result: result
					})
				} catch {
					continue
				}
			}
		} catch {
			return output
		}

		return output
	}

}