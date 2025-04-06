Class MyRecipes {

	static file := App.paths.user "\CustomRecipes.ini"
	static attachments := App.paths.user "\Attachments.ini"
	static autoimport := { linux: App.paths.user "\Autoimport.linux", ini: App.paths.user "\Autoimport.ini" }
	static editorTitle := App.winTitle " — " Locale.Read("gui_recipes_create")
	static sectionValidator := "^[A-Za-z_][A-Za-z0-9_]*$"

	static defaulRecipes := [
		"kanji_yoshi", {
			name: "Символ кандзи «Ёси»",
			recipe: "ёси|yoshi",
			result: Chr(0x7FA9),
		},
		"html_template", {
			name: "HTML Template",
			recipe: "html",
			result: '<!DOCTYPE html>\n<html lang="en">\n\t<head>\n\t\t<meta charset="UTF-8">\n\t\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t\t\n\t\t<meta name="date" content="">\n\t\t<meta name="subject" content="">\n\t\t<meta name="rating" content="">\n\t\t<meta name="theme-color" content="">\n\n\t\t<base href="/" />\n\n\t\t<meta name="referrer" content="origin">\n\t\t<meta name="referrer" content="origin-when-cross-origin">\n\t\t<meta name="referrer" content="no-referrer-when-downgrade">\n\n\t\t<meta property="og:type" content="website">\n\t\t<meta property="og:title" content=">\n\t\t<meta property="og:url" content="">\n\t\t<meta property="og:description" content="">\n\t\t<meta property="og:image" content="">\n\t\t<meta property="og:locale" content="">\n\n\t\t<meta name="twitter:card" content="summary_large_image">\n\t\t<meta property="twitter:domain" content="">\n\t\t<meta property="twitter:url" content="">\n\t\t<meta name="twitter:title" content="">\n\t\t<meta name="twitter:description" content="">\n\t\t<meta name="twitter:image" content="">\n\t\t<meta name="twitter:creator" content="">\n\n\t\t<meta http-equiv="Cache-Control" content="public">\n\t\t<meta http-equiv="X-UA-Compatible" content="ie=edge">\n\t\t<meta name="renderer" content="webkit|ie-comp|ie-stand">\n\t\t<meta name="author" content="">\n\t\t<meta content="" name="description">\n\t\t<link rel="manifest" href="/manifest.webmanifest">\n\n\t\t<title>Index</title>\n\t\n\t\t<link rel="icon" href="/favicon.ico" type="image/x-icon">\n\t\t<link rel="stylesheet" href="/index.css" />\n\n\t\t<meta name="robots" content="index, follow">\n\t\t<meta name="revisit-after" content="7 days">\n\n\t\t<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin="use-credentials">\n\t\t<link rel="preconnect" href="https://fonts.gstatic.com">\n\t</head>\n\t<body>\n\t\t<main>\n\t\t\n\t\t</main>\n\t\t<script src="/index.js"></script>\n\t</body>\n</html>',
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

	static XComposePairs := [
		"at", Chr(0x0040),
		"minus", Chr(0x002D),
		"plus", Chr(0x002B),
		"equal", Chr(0x003D),
		"underscore", Chr(0x005F),
		"asterisk", Chr(0x002A),
		"ampersand", Chr(0x0026),
		"sterling", Chr(0x00A3),
		"dollar", Chr(0x0024),
		"EuroSign", Chr(0x20AC),
		"yen", Chr(0x00A5),
		"currency", Chr(0x00A4),
		"exclam", Chr(0x0021),
		"exclamdown", Chr(0x00A1),
		"onesuperior", Chr(0x00B9),
		"twosuperior", Chr(0x00B2),
		"numbersign", Chr(0x0023),
		"threesuperior", Chr(0x00B3),
		"percent", Chr(0x0025),
		"onequarter", Chr(0x00BC),
		"onehalf", Chr(0x00BD),
		"threequarters", Chr(0x00BE),
		"parenleft", Chr(0x0028),
		"leftsinglequotemark", Chr(0x2018),
		"parenright", Chr(0x0029),
		"rightsinglequotemark", Chr(0x2019),
		"multiply", Chr(0x00D7),
		"division", Chr(0x00F7),
		"bracketleft", Chr(0x005B),
		"bracketright", Chr(0x005D),
		"braceleft", Chr(0x007B),
		"braceright", Chr(0x007D),
		"guillemotleft", Chr(0x00AB),
		"guillemotright", Chr(0x00BB),
		"acute", Chr(0x00B4),
		"diaeresis", Chr(0x00A8),
		"backslash", Chr(0x005C),
		"bar", Chr(0x007C),
		"notsign", Chr(0x00AC),
		"brokenbar", Chr(0x00A6),
		"semicolon", Chr(0x003B),
		"colon", Chr(0x003A),
		"paragraph", Chr(0x00B6),
		"degree", Chr(0x00B0),
		"comma", Chr(0x002C),
		"period", Chr(0x002E),
		"less", Chr(0x003C),
		"greater", Chr(0x003E),
		"slash", Chr(0x002F),
		"question", Chr(0x003F),
		"questiondown", Chr(0x00BF),
		"space", Chr(0x0020),
		"Multi_key", "",
		"Compose", "",
	]

	static __New() {
		if !FileExist(this.file) {
			for i, key in this.defaulRecipes {
				if Mod(i, 2) == 1 {
					value := this.defaulRecipes[i + 1]
					this.AddEdit(key, { name: value.name, recipe: value.recipe, result: value.result }, True)
				}
			}
		}

		if !FileExist(this.attachments) {
			FileAppend("[attach]", this.attachments, "UTF-16")
		}

		for key, value in this.autoimport.OwnProps() {
			if !DirExist(value)
				DirCreate(value)
		}

		if !FileExist(App.paths.user "\Autoimport.linux\demo.XCompose")
			FileAppend('<Multi_key> <0> <0> : "' Chr(0x221E) '"', App.paths.user "\Autoimport.linux\demo.XCompose", "UTF-8")


		SetTimer((*) => this.UpdateChrLib(), -2000)
	}

	static EditorGUI := Gui()

	static Editor(sectionName := [], recipesLV?) {

		Constructor() {
			this.editorTitle := App.winTitle " — " Locale.Read("gui_recipes_create")
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
			recipeCreator.Opt("+Resize +MinSize" windowWidth "x" windowHeight)
			recipeCreator.title := this.editorTitle

			recipeCreator.OnEvent("Size", panelResize)

			defaultSizes := { groupBoxW: 280, groupBoxX: (windowWidth - 280) / 2 }

			boxCommonY := 10
			boxCommonH := windowHeight - 20

			commonX := (add := 0) => (defaultSizes.groupBoxX) + 15 + add
			commonY := (add := 0) => (boxCommonY) + 20 + add

			recipeCreator.AddGroupBox("vGroupCommon " "x" defaultSizes.groupBoxX " y" boxCommonY " w" defaultSizes.groupBoxW " h" boxCommonH)

			sectionLabel := recipeCreator.AddText("vSectionLabel x" commonX() " y" commonY() " w150 BackgroundTrans", Locale.Read("gui_recipes_create_section"))
			sectionEdit := recipeCreator.AddEdit("vSectionEdit x" commonX() " y" commonY(20) " w250 Limit48 -Multi" (sectionName.Length > 0 ? " ReadOnly" : ""), sectionName.Length > 0 ? sectionName[4] : "")

			nameLabel := recipeCreator.AddText("vNameLabel x" commonX() " y" commonY(55) " w150 BackgroundTrans", Locale.Read("gui_recipes_create_name"))
			nameEdit := recipeCreator.AddEdit("vNameEdit x" commonX() " y" commonY(55 + 20) " w250 -Multi", sectionName.Length > 0 ? MyRecipes.Get(sectionName[4]).name : "")

			recipeLabel := recipeCreator.AddText("vRecipeLabel x" commonX() " y" commonY(110) " w150 BackgroundTrans", Locale.Read("gui_recipes_create_recipe"))
			recipeEdit := recipeCreator.AddEdit("vRecipeEdit x" commonX() " y" commonY(110 + 20) " w250 -Multi", sectionName.Length > 0 ? MyRecipes.Get(sectionName[4]).recipe : "")

			resultLabel := recipeCreator.AddText("vResultLabel x" commonX() " y" commonY(110 + 55) " w150 BackgroundTrans", Locale.Read("gui_recipes_create_result"))
			resultEdit := recipeCreator.AddEdit("vResultEdit x" commonX() " y" commonY((110 + 55) + 20) " w250 h150 Multi WantTab", sectionName.Length > 0 ? this.FormatResult(MyRecipes.Get(sectionName[4]).result, True) : "")

			if sectionName.Length > 0 {
				data.section := sectionName[4]
				data.name := MyRecipes.Get(sectionName[4]).name
				data.recipe := MyRecipes.Get(sectionName[4]).recipe
				data.result := MyRecipes.Get(sectionName[4]).result
				data.row := sectionName[5]
			}

			saveBtn := recipeCreator.AddButton("vSaveButton x" commonX() " y" (boxCommonH) - 32 " w100 h32", Locale.Read("gui_save"))
			cancelBtn := recipeCreator.AddButton("vCancelButton x" commonX(100) " y" (boxCommonH) - 32 " w100 h32", Locale.Read("gui_cancel"))

			sectionEdit.OnEvent("Change", (CB, Zero) => setData(CB, "section"))
			nameEdit.OnEvent("Change", (CB, Zero) => setData(CB, "name"))
			recipeEdit.OnEvent("Change", (CB, Zero) => setData(CB, "recipe"))
			resultEdit.OnEvent("Change", (CB, Zero) => setData(CB, "result"))

			saveBtn.OnEvent("Click", (*) => saveRecipe(data))
			cancelBtn.OnEvent("Click", (*) => WinClose(this.editorTitle))

			recipeCreator.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)
			return recipeCreator

			panelResize(guiObj, minMax, w, h) {
				guiObj["GroupCommon"].Move(, , w - 20, h - 20)
				guiObj["SectionEdit"].Move(, , w - 50)
				guiObj["NameEdit"].Move(, , w - 50)
				guiObj["RecipeEdit"].Move(, , w - 50)
				guiObj["ResultEdit"].Move(, , w - 50, h - 300)
				guiObj["SaveButton"].Move(, (h - 20) - 32)
				guiObj["CancelButton"].Move(, (h - 20) - 32)
			}

			setData(CB, key) {
				data.%key% := CB.Text
			}

			saveRecipe(data) {
				if RegExMatch(data.section, this.sectionValidator) {
					if InStr(data.section, "xcompose") {
						RegExMatch(data.section, "\[(.*)\]", &match)
						MsgBox(Locale.Read("gui_recipes_xcompose_break") "`n`n" Chr(0x2026) "\User\" match[1], App.winTitle)
						return
					} else if StrLen(data.section) > 0 && StrLen(data.name) > 0 && StrLen(data.recipe) > 0 && StrLen(data.result) > 0 {
						if IsGuiOpen(Cfg.EditorSubGUIs.recipesTitle) && data.row > 0 {
							recipesLV.Modify(data.row, , data.name, data.recipe, Util.StrFormattedReduce(this.FormatResult(data.result), 24))

						} else if IsGuiOpen(Cfg.EditorSubGUIs.recipesTitle) && data.row = 0 {
							if this.Check(data.section) {
								MsgBox(Locale.Read("gui_recipes_create_exists"), App.winTitle)
								return
							}
							recipesLV.Add(, data.name, data.recipe, Util.StrFormattedReduce(this.FormatResult(data.result), 24), data.section)
						}

						this.AddEdit(data.section, data)
					}
				} else {
					MsgBox(Locale.Read("gui_recipes_create_invalid_section_name"), App.winTitle)
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

	static AddEdit(sectionName, params, noUpdate := False) {
		if RegExMatch(sectionName, this.sectionValidator) {
			params.result := this.FormatResult(params.result)

			IniWrite(params.name, this.file, sectionName, "name")
			IniWrite(params.recipe, this.file, sectionName, "recipe")
			IniWrite(params.result, this.file, sectionName, "result")

			if !noUpdate {
				this.UpdateChrLib()
			}
		} else {
			MsgBox(Locale.Read("gui_recipes_create_invalid_section_name"), App.winTitle)
		}

		return
	}

	static Check(sectionName) {
		content := FileRead(this.file, "UTF-16")

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

	static Get(sectionName, make := False) {
		output := {}

		output.name := IniRead(this.file, sectionName, "name")
		output.recipe := IniRead(this.file, sectionName, "recipe")
		output.result := IniRead(this.file, sectionName, "result")

		if make {
			output.recipe := ChrRecipeHandler.MakeStr(output.recipe)
			output.result := ChrRecipeHandler.MakeStr(output.result)
		}
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

		if ChrLib.GetEntry(sectionName)
			ChrLib.RemoveEntry(sectionName)

		return True
	}

	static Read() {
		output := []

		try {
			pushRecipes(filePath := this.file, postfix := "") {
				content := FileRead(filePath, "UTF-16")
				options := {
					recipePrefix: "",
					noWhitespace: 0,
				}

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
					if section = "options" {
						options.recipePrefix := IniRead(filePath, section, "prefix", "")
						options.noWhitespace := Integer(IniRead(filePath, section, "no_whitespace", "0"))
						continue
					}
					try {
						name := IniRead(filePath, section, "name")
						recipe := IniRead(filePath, section, "recipe")
						result := IniRead(filePath, section, "result")

						try {
							if InStr(recipe, "|") && StrLen(options.recipePrefix) > 0 {
								splittedRecipe := StrSplit(recipe, "|")
								splittedPrefix := StrSplit(options.recipePrefix, "|")

								for i, r in splittedRecipe {
									if splittedPrefix.Length = splittedRecipe.Length {
										splittedRecipe[i] := splittedPrefix[i] (
											options.noWhitespace
											|| StrLen(splittedPrefix[i]) == 0
												? "" : " "
										) r
									} else {
										splittedRecipe[i] := splittedPrefix[1] (
											options.noWhitespace
											|| StrLen(splittedPrefix[1]) == 0
												? "" : " "
										) r
									}
								}

								recipe := splittedRecipe.ToString("|")
							} else {
								if InStr(options.recipePrefix, "|")
									options.recipePrefix := StrSplit(options.recipePrefix, "|")

								recipe := (
									Util.IsArray(options.recipePrefix)
										? options.recipePrefix[1]
									: options.recipePrefix
								) (
									options.noWhitespace
									|| Util.IsString(options.recipePrefix) && StrLen(options.recipePrefix) == 0
									|| Util.IsArray(options.recipePrefix) && options.recipePrefix.Length == 1
										? "" : " "
								) recipe
							}
						} catch {
							throw "Error with recipe: " recipe " of section: " section
						}
						output.Push({
							section: section postfix,
							name: name,
							recipe: recipe,
							result: result,
							filePath: Util.TrimBasePath(filePath)
						})
					} catch {
						continue
					}
				}
			}

			pushRecipes()

			for attachment in this.ReadAttachmentList() {
				try {
					pushRecipes(App.paths.user "\" attachment, "__attachment_from__" Util.EscapePathChars(attachment))
				}
			}

			Loop Files this.autoimport.ini "\*.ini" {
				try {
					pushRecipes(A_LoopFileDir "\" A_LoopFileName, "__attachment_from__Autoimport_ini____" A_LoopFileName)
				}
			}

			Loop Files this.autoimport.linux "\*.XCompose" {
				try {
					output := ArrayMerge(output, this.XComposeRead(A_LoopFilePath, A_LoopFileName))
				}
			}
		} catch {
			return output
		}

		return output
	}

	static AddAttachment(attachment) {
		IniWrite(attachment, this.attachments, "attach", Util.EscapePathChars(attachment))
	}

	static ReadAttachmentList() {
		attachments := []

		content := FileRead(this.attachments, "UTF-16")
		splitContent := StrSplit(content, "`n")

		for i, line in splitContent {
			line := Trim(line)
			if (line = "" || SubStr(line, 1, 1) = ";" || (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]"))
				continue

			if (RegExMatch(line, "^[^=]*=(.*)$", &result))
				attachments.Push(Trim(result[1]))
		}

		return attachments
	}

	static XComposeRead(filePath, fileName) {
		content := FileRead(filePath, "UTF-8")
		splitContent := StrSplit(content, "`n")
		fileNameNoExt := StrReplace(fileName, ".XCompose", "")

		output := []
		if RegExMatch(fileNameNoExt, this.sectionValidator) || StrLen(fileNameNoExt) == 0 {
			for i, line in splitContent {
				try {
					RegExMatch(line, "^(.+?)\s*:", &recipeList)
					RegExMatch(line, "^.+:\s*`"(.+?)`"", &result)

					recipe := ""
					matches := StrSplit(recipeList[1], ">")

					for i, match in matches {
						if StrLen(match) > 0 {
							cutMatch := RegExReplace(match, "(\<|\s)", "")
							if this.XComposePairs.HasValue(cutMatch, &index) {
								recipe .= this.XComposePairs[index + 1]
							} else {
								recipe .= cutMatch
							}
						}
					}

					recipe := (Cfg.Get("XCompose_Add_Recipe_Prefix", , False, "bool") ? ">xc " : "") recipe

					output.Push({
						section: "xcompose_" Ord(recipe) Ord(result[1]) (StrLen(fileNameNoExt) == 0 ? "" : "__file_" fileNameNoExt),
						name: "XCompose: [" result[1] "]",
						recipe: recipe,
						result: result[1],
						filePath: Util.TrimBasePath(filePath)
					})
				}
			}
		} else {
			MsgBox(Locale.Read("gui_recipes_create_invalid_xcompose_name"), App.winTitle)
		}

		return output
	}

	static UpdateChrLib() {
		recipeSections := this.Read()
		try {

			for section in recipeSections {
				try {

					if InStr(section.recipe, "|") {
						section.recipe := StrSplit(section.recipe, "|")
					}

					if !IsObject(section.recipe) {
						section.recipe := [section.recipe]
					}

					section.result := this.FormatResult(section.result, True)

					if ChrLib.GetEntry(section.section)
						ChrLib.RemoveEntry(section.section)

					ChrLib.AddEntry(
						section.section, ChrEntry({
							result: [section.result],
							titles: this.HandleTitles(section.name),
							recipe: section.recipe,
							groups: ["Custom Composes"],
						}),
					)
				} catch {
					MsgBox("[" section.section "]`n" Util.StrVarsInject(Locale.Read("gui_recipes_create_invalid_recipe"), Util.IsArray(section.recipe) ? section.recipe.ToString("") : section.recipe, Util.IsArray(section.result) ? section.result.ToString("") : section.result), App.winTitle)
				}
			}
		}
	}

	static HandleResult(resultIn) {
		if Util.IsArray(resultIn)
			resultIn := resultIn.ToString("")
		output := []
		i := 1
		while (i <= StrLen(resultIn)) {
			char := SubStr(resultIn, i, 1)
			code := Ord(char)

			if (code >= 0xD800 && code <= 0xDBFF) {
				nextChar := SubStr(resultIn, i + 1, 1)
				char .= nextChar
				i += 1
			}

			output.Push("{U+" GetCharacterUnicode(char) "}")
			i += 1
		}
		return output
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

	static HandleTitles(sectionName, asString := False) {
		supportedLanguages := Language.GetSupported()
		userLanguage := Language.Get()

		titles := Map()
		for lang in supportedLanguages {
			titles.Set(lang, sectionName)
		}

		if InStr(sectionName, "|") {
			titleVariants := StrSplit(sectionName, "|")

			for variant in titleVariants {
				RegExMatch(variant, "^(.*?):(.*)$", &match)
				if supportedLanguages.HasValue(match[1]) {
					titles.Set(match[1], match[2])
				}
			}
		}

		return asString ? titles.Get(userLanguage) : titles
	}
}

MyRecipes.ReadAttachmentList()