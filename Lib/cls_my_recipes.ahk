Class MyRecipes {

	static file := App.paths.dir "\CustomCompose.ini"
	static editorTitle := App.title " — " App.versionText " — " ReadLocale("gui_recipes_edit")

	static __New() {

	}


	static EditorGUI := Gui()

	static Editor() {
	}

	static AddEdit(sectionName, params) {
		IniWrite(params.name, this.file, sectionName, "name")
		IniWrite(params.recipe, this.file, sectionName, "recipe")
		IniWrite(params.result, this.file, sectionName, "result")
		UpdateCustomRecipes()
		return
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