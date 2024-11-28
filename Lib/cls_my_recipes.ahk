Class MyRecipes {

	static file := App.paths.user "\CustomCompose.ini"
	static editorTitle := App.winTitle " — " ReadLocale("gui_recipes_create")

	static defaulRecipes := [
		"kanji_yoshi", {
			name: "Символ кандзи «Ёси»",
			recipe: "ёси|yoshi",
			result: Chr(0x7FA9),
		},
		"html_template", {
			name: "HTML Template",
			recipe: "html",
			result: '<!DOCTYPE html>\n<html lang="en">\n\t<head>\n\t\t<meta charset="UTF-8">\n\t\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t\t\n\t\t<meta name="date" content="">\n\t\t<meta name="subject" content="">\n\t\t<meta name="rating" content="">\n\t\t<meta name="theme-color" content="">\n\n\t\t<base href="/" />\n\n\t\t<meta name="referrer" content="origin">\n\t\t<meta name="referrer" content="origin-when-cross-origin">\n\t\t<meta name="referrer" content="no-referrer-when-downgrade">\n\n\t\t<meta property="og:type" content="website">\n\t\t<meta property="og:title" content=">\n\t\t<meta property="og:url" content="">\n\t\t<meta property="og:description" content="">\n\t\t<meta property="og:image" content="">\n\t\t<meta property="og:locale" content="">\n\n\t\t<meta name="twitter:card" content="summary_large_image">\n\t\t<meta property="twitter:domain" content="">\n\t\t<meta property="twitter:url" content="">\n\t\t<meta name="twitter:title" content="">\n\t\t<meta name="twitter:description" content="">\n\t\t<meta name="twitter:image" content="">\n\t\t<meta name="twitter:creator" content="">\n\n\t\t<meta http-equiv="Cache-Control" content="public">\n\t\t<meta http-equiv="X-UA-Compatible" content="ie=edge">\n\t\t<meta name="renderer" content="webkit|ie-comp|ie-stand">\n\t\t<meta name="author" content="">\n\t\t<meta content=">" name="description">\n\t\t<link rel="manifest" href="/manifest.webmanifest">\n\n\t\t<title>Index</title>\n\t\n\t\t<link rel="icon" href="/favicon.ico" type="image/x-icon">\n\t\t<link rel="stylesheet" href="/index.css" />\n\n\t\t<meta name="robots" content="index, follow">\n\t\t<meta name="revisit-after" content="7 days">\n\n\t\t<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin="use-credentials">\n\t\t<link rel="preconnect" href="https://fonts.gstatic.com">\n\t</head>\n\t<body>\n\t\t<main>\n\t\t\n\t\t</main>\n\t\t<script src="/index.js"></script>\n\t</body>\n</html>',
		},
		"kbd", {
			name: "Keyboard Input Tag",
			recipe: "kbd",
			result: "<kbd></kbd>",
		},
		"emoji_ice", {
			name: "Ice",
			recipe: "лёд|ice",
			result: Chr(0x1F9CA),
		},
	]

	static __New() {
		if !FileExist(MyRecipes.file) {
			for i, key in this.defaulRecipes {
				if Mod(i, 2) == 1 {
					value := this.defaulRecipes[i + 1]
					this.AddEdit(key, { name: value.name, recipe: value.recipe, result: value.result })
				}
			}
		}

		if !FileExist(App.paths.user "\demo.XCompose") {
			FileAppend('<Multi_key> <0> <0> : "' Chr(0x221E) '"', App.paths.user "\demo.XCompose", "UTF-8")
		}


		SetTimer((*) => this.UpdateMap(), -5000)
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
			resultEdit := recipeCreator.AddEdit("vResultEdit x" commonX() " y" commonY((110 + 55) + 20) " w250 h150 Multi", sectionName.Length > 0 ? this.FormatResult(MyRecipes.Get(sectionName[4]).result, True) : "")

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
				if InStr(data.section, "xcompose") {
					MsgBox(ReadLocale("gui_recipes_xcompose_break"), App.winTitle)
					return
				} else if StrLen(data.section) > 0 && StrLen(data.name) > 0 && StrLen(data.recipe) > 0 && StrLen(data.result) > 0 {
					if IsGuiOpen(Cfg.EditorSubGUIs.recipesTitle) && data.row > 0 {
						recipesLV.Modify(data.row, , data.name, data.recipe, Util.StrFormattedReduce(this.FormatResult(data.result), 24))

					} else if IsGuiOpen(Cfg.EditorSubGUIs.recipesTitle) && data.row = 0 {
						if this.Check(data.section) {
							MsgBox(ReadLocale("gui_recipes_create_exists"), App.winTitle)
							return
						}
						recipesLV.Add(, data.name, data.recipe, Util.StrFormattedReduce(this.FormatResult(data.result), 24), data.section)
					}

					this.AddEdit(data.section, data)
					this.UpdateMap()
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

	static FormatResult(result, revert := False) {
		if revert {
			result := StrReplace(result, "\n", "`n")
			result := StrReplace(result, "\t", "`t")
		} else {
			result := StrReplace(result, "`r`n", "\n")
			result := StrReplace(result, "`n", "\n")
			result := StrReplace(result, "`t", "\t")
		}
		return result
	}

	static AddEdit(sectionName, params) {
		params.result := this.FormatResult(params.result)

		IniWrite(params.name, this.file, sectionName, "name")
		IniWrite(params.recipe, this.file, sectionName, "recipe")
		IniWrite(params.result, this.file, sectionName, "result")
		return
	}

	static Check(sectionName) {
		content := FileRead(this.file, "UTF-16")

		if InStr(content, sectionName) {
			return True
		}

		return False
	}

	static Get(sectionName) {
		output := {}

		output.name := IniRead(this.file, sectionName, "name")
		output.recipe := IniRead(this.file, sectionName, "recipe")
		output.result := IniRead(this.file, sectionName, "result")

		return output
	}

	static Remove(sectionName) {
		global Characters
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

		characterEntry := GetCharacterEntry(sectionName, True)

		if characterEntry {
			Characters.Delete(characterEntry)
		}

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

			Loop Files App.paths.user "\*.XCompose" {
				try {
					output := ArrayMerge(output, this.XComposeRead(A_LoopFilePath, A_LoopFileName))
				}
			}
		} catch {
			return output
		}

		return output
	}

	static XComposeRead(filePath, fileName) {
		content := FileRead(filePath, "UTF-8")
		splitContent := StrSplit(content, "`n")

		output := []

		for i, line in splitContent {
			RegExMatch(line, "^\s*<.+>\s+<(.+?)>\s+<(.+?)>\s*:\s*`"(.+?)`"", &match)

			output.Push({
				section: "xcompose_" Ord(match[3]) "[" StrLower(fileName) "]",
				name: "XCompose: [" match[3] "]",
				recipe: match[1] match[2],
				result: match[3]
			})
		}

		return output
	}

	static UpdateMap() {
		global Characters, CharactersCount

		recipeSections := this.Read()
		try {
			for section in recipeSections {
				if InStr(section.recipe, "|") {
					section.recipe := StrSplit(section.recipe, "|")
				}

				section.result := this.FormatResult(section.result, True)

				resultToUnicode := []
				i := 1
				while (i <= StrLen(section.result)) {
					char := SubStr(section.result, i, 1)
					code := Ord(char)

					if (code >= 0xD800 && code <= 0xDBFF) {
						nextChar := SubStr(section.result, i + 1, 1)
						char .= nextChar
						i += 1
					}

					resultToUnicode.Push("{U+" GetCharacterUnicode(char) "}")
					i += 1
				}

				characterEntry := GetCharacterEntry(section.section, True)

				if characterEntry {
					Characters[characterEntry].unicode = resultToUnicode[1]
					Characters[characterEntry].uniSequence = resultToUnicode
					Characters[characterEntry].recipe = section.recipe
					Characters[characterEntry].titles = Map("ru", section.name, "en", section.name)

				} else {
					MapInsert(Characters,
						section.section, {
							unicode: resultToUnicode[1],
							uniSequence: resultToUnicode,
							titles: Map("ru", section.name, "en", section.name),
							recipe: section.recipe,
							group: ["Custom Composes"],
						},
					)
				}
			}
		} finally {
			CharactersCount := GetCountDifference()
			ProcessMapAfter("Custom Composes")
			UpdateRecipeValidator()
		}
	}

}