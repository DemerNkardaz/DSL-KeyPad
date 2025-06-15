Class MyRecipes {

	static file := "CustomRecipes.ini"
	static filePath := App.paths.profile "\" this.file
	static attachments := App.paths.profile "\Attachments.txt"
	static autoimport := { linux: App.paths.profile "\Autoimport.linux", ini: App.paths.profile "\Autoimport.ini" }
	static editorTitle := App.Title("+status+version") " — " Locale.Read("gui_recipes_create")
	static sectionValidator := "^[A-Za-z_][A-Za-z0-9_]*$"

	static defaulRecipes := [
		"kanji_yoshi", {
			name: "ru:Кандзи «Ёси»|en:Kanji “Yoshi”",
			recipe: "ёси|yoshi",
			result: Chr(0x7FA9),
		},
		"html_template", {
			name: "ru:Шаблон HTML|en:HTML Template",
			recipe: "html",
			result: '<!DOCTYPE html>\n<html lang="en">\n\t<head>\n\t\t<meta charset="UTF-8">\n\t\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t\t\n\t\t<meta name="date" content="">\n\t\t<meta name="subject" content="">\n\t\t<meta name="rating" content="">\n\t\t<meta name="theme-color" content="">\n\n\t\t<base href="/" />\n\n\t\t<meta name="referrer" content="origin">\n\t\t<meta name="referrer" content="origin-when-cross-origin">\n\t\t<meta name="referrer" content="no-referrer-when-downgrade">\n\n\t\t<meta property="og:type" content="website">\n\t\t<meta property="og:title" content=">\n\t\t<meta property="og:url" content="">\n\t\t<meta property="og:description" content="">\n\t\t<meta property="og:image" content="">\n\t\t<meta property="og:locale" content="">\n\n\t\t<meta name="twitter:card" content="summary_large_image">\n\t\t<meta property="twitter:domain" content="">\n\t\t<meta property="twitter:url" content="">\n\t\t<meta name="twitter:title" content="">\n\t\t<meta name="twitter:description" content="">\n\t\t<meta name="twitter:image" content="">\n\t\t<meta name="twitter:creator" content="">\n\n\t\t<meta http-equiv="Cache-Control" content="public">\n\t\t<meta http-equiv="X-UA-Compatible" content="ie=edge">\n\t\t<meta name="renderer" content="webkit|ie-comp|ie-stand">\n\t\t<meta name="author" content="">\n\t\t<meta content="" name="description">\n\t\t<link rel="manifest" href="/manifest.webmanifest">\n\n\t\t<title>Index</title>\n\t\n\t\t<link rel="icon" href="/favicon.ico" type="image/x-icon">\n\t\t<link rel="stylesheet" href="/index.css" />\n\n\t\t<meta name="robots" content="index, follow">\n\t\t<meta name="revisit-after" content="7 days">\n\n\t\t<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin="use-credentials">\n\t\t<link rel="preconnect" href="https://fonts.gstatic.com">\n\t</head>\n\t<body>\n\t\t<main>\n\t\t\n\t\t</main>\n\t\t<script src="/index.js"></script>\n\t</body>\n</html>',
		},
		"kbd", {
			name: "ru:Элемент ввода с клавиатуры|en:Keyboard Input element",
			recipe: "kbd",
			result: "<kbd></kbd>",
		},
		"emoji_ice", {
			name: "ru:Лёд|en:Ice",
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
		if !FileExist(this.filePath) {
			for i, key in this.defaulRecipes {
				if Mod(i, 2) == 1 {
					value := this.defaulRecipes[i + 1]
					this.AddEdit(key, { name: value.name, recipe: value.recipe, result: value.result, tags: "", previousSection: key }, True)
				}
			}
		}

		if !FileExist(this.attachments) {
			FileAppend("", this.attachments, "UTF-8")
		}

		for key, value in this.autoimport.OwnProps() {
			if !DirExist(value)
				DirCreate(value)
		}

		if !FileExist(App.paths.profile "\Autoimport.linux\demo.XCompose")
			FileAppend('<Multi_key> <0> <0> : "' Chr(0x221E) '"', App.paths.profile "\Autoimport.linux\demo.XCompose", "UTF-8")

		this.Update()
	}

	static EditorGUI := Gui()

	static Editor(sectionName := [], recipesLV?) {

		Constructor() {
			this.editorTitle := App.Title("+status+version") " — " Locale.Read("gui_recipes_create")
			data := {
				section: "",
				name: "",
				recipe: "",
				result: "",
				row: 0,
				filePath: "",
				tags: "",
				previousSection: "",
			}

			totalLen := Util.StrDigitFormat(StrLen(data.result))
			pages := Util.StrPagesCalc(data.result)

			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := 300
			windowHeight := 500

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
			sectionEdit := recipeCreator.AddEdit("vSectionEdit x" commonX() " y" commonY(20) " w250 Limit48 -Multi", sectionName.Length > 0 ? sectionName[4] : "")

			nameLabel := recipeCreator.AddText("vNameLabel x" commonX() " y" commonY(55) " w150 BackgroundTrans", Locale.Read("gui_recipes_create_name"))
			nameEdit := recipeCreator.AddEdit("vNameEdit x" commonX() " y" commonY(55 + 20) " w250 -Multi", sectionName.Length > 0 ? MyRecipes.Get(sectionName[4]).name : "")

			recipeLabel := recipeCreator.AddText("vRecipeLabel x" commonX() " y" commonY(110) " w150 BackgroundTrans", Locale.Read("gui_recipes_create_recipe"))
			recipeEdit := recipeCreator.AddEdit("vRecipeEdit x" commonX() " y" commonY(110 + 20) " w250 -Multi", sectionName.Length > 0 ? MyRecipes.Get(sectionName[4]).recipe : "")

			tagsLabel := recipeCreator.AddText("vTagsLabel x" commonX() " y" commonY(165) " w150 BackgroundTrans", Locale.Read("gui_recipes_create_tags"))
			tagsEdit := recipeCreator.AddEdit("vTagsEdit x" commonX() " y" commonY(165 + 20) " w250 -Multi", sectionName.Length > 0 ? MyRecipes.Get(sectionName[4]).tags : "")

			resultLabel := recipeCreator.AddText("vResultLabel x" commonX() " y" commonY(165 + 55) " w250 BackgroundTrans")
			resultEdit := recipeCreator.AddEdit("vResultEdit x" commonX() " y" commonY((165 + 55) + 20) " w250 h100 Multi WantTab", sectionName.Length > 0 ? this.FormatResult(MyRecipes.Get(sectionName[4]).result, True) : "")

			if sectionName.Length > 0 {
				data.section := sectionName[4]
				data.name := MyRecipes.Get(sectionName[4]).name
				data.recipe := MyRecipes.Get(sectionName[4]).recipe
				data.result := MyRecipes.Get(sectionName[4]).result
				data.row := sectionName[5]
				data.filePath := sectionName[6]
				data.tags := MyRecipes.Get(sectionName[4]).tags
				data.previousSection := sectionName[4]
			}

			totalLen := Util.StrDigitFormat(StrLen(data.result))
			pages := Util.StrPagesCalc(data.result)
			resultLabel.Text := getResultLabel()

			saveBtn := recipeCreator.AddButton("vSaveButton x" commonX() " y" (boxCommonH) - 32 " w100 h32", Locale.Read("gui_save"))
			cancelBtn := recipeCreator.AddButton("vCancelButton x" commonX(100) " y" (boxCommonH) - 32 " w100 h32", Locale.Read("gui_cancel"))

			sectionEdit.OnEvent("Change", (CB, Zero) => setData(CB, "section"))
			nameEdit.OnEvent("Change", (CB, Zero) => setData(CB, "name"))
			recipeEdit.OnEvent("Change", (CB, Zero) => setData(CB, "recipe"))
			tagsEdit.OnEvent("Change", (CB, Zero) => setData(CB, "tags"))
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
				guiObj["TagsEdit"].Move(, , w - 50)
				guiObj["ResultEdit"].Move(, , w - 50, h - 350)
				guiObj["SaveButton"].Move(, (h - 20) - 32)
				guiObj["CancelButton"].Move(, (h - 20) - 32)
			}

			setData(CB, key) {
				data.%key% := CB.Text
				if key = "result" {
					totalLen := Util.StrDigitFormat(StrLen(data.result))
					pages := Util.StrPagesCalc(data.result)
					resultLabel.Text := getResultLabel()
				}
			}

			getResultLabel() {
				return Locale.Read("gui_recipes_create_result") ": " Util.StrVarsInject(Locale.Read("tooltip_compose_overflow_properties"), totalLen, pages)
			}

			saveRecipe(data) {
				recipesListExists := WinExist(Cfg.EditorSubGUIs.recipesTitle)
				existingEntry := ChrLib.GetEntry(data.section)
				if RegExMatch(data.section, this.sectionValidator) {
					if InStr(data.section, "xcompose") {
						RegExMatch(data.section, "\[(.*)\]", &match)
						MsgBox(Locale.Read("gui_recipes_xcompose_break") "`n`n" Chr(0x2026) "\User\profile-" App.profileName "\" match[1], App.Title("+status+version"))
						return
					} else if StrLen(data.section) > 0 && StrLen(data.name) > 0 && StrLen(data.recipe) > 0 && StrLen(data.result) > 0 {
						if recipesListExists && data.row > 0 {
							title := this.HandleTitles(data.name)
							title := title ? title : data.name

							recipesLV.Modify(data.row, "-Focus -Select",
								title,
								RegExReplace(ChrRecipeHandler.MakeStr(data.recipe), "\|", ", "),
								Util.StrFormattedReduce(this.FormatResult(data.result, , True), 20),
								data.section
							)
						} else if IsGuiOpen(Cfg.EditorSubGUIs.recipesTitle) && data.row = 0 {
							if this.Check(data.section) {
								MsgBox(Locale.ReadInject("gui_recipes_create_exists", [data.section]), App.Title("+status+version"))
								return
							} else if existingEntry && !existingEntry.groups.HasValue("Custom Composes") {
								MsgBox(Locale.ReadInject("gui_recipes_create_exists_internal", [data.section]), App.Title("+status+version"))
								return
							}
							lastMatchIndex := 0
							targetPath := Util.StrTrimPath(this.filePath)

							Loop recipesLV.GetCount() {
								rowIndex := A_Index
								path := recipesLV.GetText(rowIndex, 5)
								if (path = targetPath)
									lastMatchIndex := rowIndex
							}

							title := this.HandleTitles(data.name)
							title := title ? title : data.name

							params := [
								title,
								RegExReplace(ChrRecipeHandler.MakeStr(data.recipe), "\|", ", "),
								Util.StrFormattedReduce(this.FormatResult(data.result, , True), 20),
								data.section,
								targetPath
							]

							if (lastMatchIndex = 0)
								recipesLV.Add(, params*)
							else
								recipesLV.Insert(lastMatchIndex + 1, , params*)
						}

						existingEntry := ChrLib.GetEntry(data.previousSection)

						if (existingEntry && existingEntry.groups.HasValue("Custom Composes")) && (data.previousSection != data.section)
							ChrLib.RemoveEntry(data.previousSection)

						this.AddEdit(data.section, data, , True)
						data.previousSection := data.section
					}
				} else {
					MsgBox(Locale.Read("gui_recipes_create_invalid_section_name"), App.Title("+status+version"))
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

	static AddEdit(sectionName, params, noUpdate := False, singleSectionName := False) {
		if RegExMatch(sectionName, this.sectionValidator) {
			params.result := this.FormatResult(params.result)

			if sectionName != params.previousSection {
				FileCopy(this.filePath, this.filePath ".bak", 1)
				Util.INIRenameSection(this.filePath, params.previousSection, sectionName)
			}

			IniWrite(params.name, this.filePath, sectionName, "name")
			IniWrite(params.recipe, this.filePath, sectionName, "recipe")
			IniWrite(params.result, this.filePath, sectionName, "result")
			if StrLen(params.tags) > 0
				IniWrite(params.tags, this.filePath, sectionName, "tags")
			else
				try
					IniDelete(this.filePath, sectionName, "tags")

			if !noUpdate
				this.Update(singleSectionName ? [sectionName] : [])
		} else
			MsgBox(Locale.Read("gui_recipes_create_invalid_section_name"), App.Title("+status+version"))

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

	static Get(sectionName, make := False) {
		output := {}

		output.name := IniRead(this.filePath, sectionName, "name")
		output.recipe := IniRead(this.filePath, sectionName, "recipe")
		output.result := IniRead(this.filePath, sectionName, "result")
		output.tags := IniRead(this.filePath, sectionName, "tags", "")

		if make {
			output.recipe := ChrRecipeHandler.MakeStr(output.recipe)
			output.result := ChrRecipeHandler.MakeStr(output.result)
		}
		return output
	}

	static Remove(sectionName) {
		filePath := this.filePath
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

		existingEntry := ChrLib.GetEntry(sectionName)
		if existingEntry && existingEntry.groups.HasValue("Custom Composes")
			ChrLib.RemoveEntry(sectionName)

		ChrLib.CountOfUpdate()
		return True
	}

	static Read(updateOnCatch := False, readOnlyInitialized := False) {
		output := []

		pushRecipes(filePath := this.filePath, postfix := "") {
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

				if (readOnlyInitialized && !ChrLib.entries.HasOwnProp(section))
					continue

				try {
					name := IniRead(filePath, section, "name")
					recipe := IniRead(filePath, section, "recipe")
					result := IniRead(filePath, section, "result")

					tags := IniRead(filePath, section, "tags", "")
					tags := StrLen(tags) > 0 ? StrSplit(tags, "|") : []

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
							if InStr(options.recipePrefix, "|") {
								splittedPrefix := StrSplit(options.recipePrefix, "|")

								recipe := splittedPrefix[1] (
									options.noWhitespace
									|| StrLen(splittedPrefix[1]) == 0
										? "" : " "
								) recipe
							}
						}
					} catch as e {
						if True {
							throw e.Message
						}
						MsgBox(Format(Locale.Read("gui_recipes_read_error" (updateOnCatch ? "_reinit" : "")), section, recipe))
						if updateOnCatch {
							this.Update()
							return this.Read()
						}
					}
					output.Push({
						section: section postfix,
						name: name,
						tags: tags,
						recipe: recipe,
						result: result,
						filePath: Util.TrimBasePath(filePath)
					})
				} catch
					continue
			}
		}

		try {
			pushRecipes()
			for attachment in this.ReadAttachmentList() {
				try {
					pushRecipes(App.paths.profile "\" attachment)
				}
			}

			Loop Files this.autoimport.ini "\*.ini" {
				try {
					pushRecipes(A_LoopFileDir "\" A_LoopFileName)
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
		FileAppend(attachment "`n", this.attachments, "UTF-8")
	}

	static ReadAttachmentList() {
		attachments := []

		content := FileRead(this.attachments, "UTF-8")

		for line in StrSplit(content, "`n") {
			if StrLen(line) == 0
				continue
			attachments.Push(Trim(line))
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
								inter := cutMatch
								if RegExMatch(inter, "U([0-9A-Fa-f]{1,6})", &uniMatch)
									inter := StrReplace(inter, uniMatch[0], Chr(Number("0x" uniMatch[1])))

								recipe .= inter
							}
						}
					}


					recipe := (Cfg.Get("XCompose_Add_Recipe_Prefix", , False, "bool") ? ">xc " : "") recipe

					output.Push({
						section: "xcompose_" Ord(recipe) Ord(result[1]) (StrLen(fileNameNoExt) == 0 ? "" : "__file_" fileNameNoExt),
						name: "XCompose: [" result[1] "]",
						recipe: recipe,
						tags: [],
						result: result[1],
						filePath: Util.TrimBasePath(filePath),
					})
				}
			}
		} else {
			MsgBox(Locale.Read("gui_recipes_create_invalid_xcompose_name"), App.Title("+status+version"))
		}

		return output
	}

	static Update(strictToNames := []) {

		recipeSections := this.Read()
		rawCustomEntries := []

		try {

			for section in recipeSections {
				if (strictToNames.Length > 0 && !strictToNames.HasValue(section.section)) {
					continue
				}

				try {

					if InStr(section.recipe, "|") {
						section.recipe := StrSplit(section.recipe, "|")
					}

					if !IsObject(section.recipe) {
						section.recipe := [section.recipe]
					}

					if section.tags.Length = 0 && !(section.section ~= "i)^xcompose_") {
						section.tags := this.HandleTitles(section.name, [])
					}

					section.result := this.FormatResult(section.result, True)

					existingEntry := ChrLib.GetEntry(section.section)

					if existingEntry && existingEntry.groups.HasValue("Custom Composes")
						ChrLib.RemoveEntry(section.section)

					existingEntry := ChrLib.GetEntry(section.section)
					title := !(section.section ~= "i)^xcompose") ? this.HandleTitles(section.name) : section.name

					if !existingEntry {
						rawCustomEntries.Push(
							section.section, ChrEntry().Get({
								result: [section.result],
								titles: title ? title : section.name,
								tags: section.tags ? section.tags : [],
								recipe: section.recipe,
								groups: ["Custom Composes"],
								isXCompose: section.section ~= "i)^xcompose" ? True : False,
							}),
						)
					} else
						MsgBox(Locale.ReadInject("gui_recipes_create_exists_internal", [section.section]), App.Title("+status+version"))
				} catch {
					MsgBox("[" section.section "]`n" Locale.ReadInject("gui_recipes_create_invalid_recipe", [section.recipe is Array ? section.recipe.ToString("") : section.recipe, section.result is Array ? section.result.ToString("") : section.result]), App.Title("+status+version"))
				}
			}
			ChrReg(rawCustomEntries, "Custom")
			if ChrLib.duplicatesList.Length > 0
				TrayTip(Locale.ReadInject("warning_duplicate_recipe", [ChrLib.duplicatesList.ToString()]), App.Title("+status+version"), "Icon! Mute")
		}
		ChrLib.CountOfUpdate()
	}

	static HandleResult(resultIn) {
		if resultIn is Array
			resultIn := resultIn.ToString("")
		/*
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
		*/
		return ["%RAWTEXT%" resultIn]
	}

	static FormatResult(result, revert := False, formatRecipe := False) {
		if formatRecipe
			result := ChrRecipeHandler.MakeStr(result)
		if revert {
			result := RegExReplace(result, "\\n(?![^$]*\})", "`n")
			result := RegExReplace(result, "\\t(?![^$]*\})", "`t")
		} else {
			result := StrReplace(result, "`r`n", "\n")
			result := StrReplace(result, "`n", "\n")
			result := StrReplace(result, "`t", "\t")
		}
		return result
	}

	static HandleTitles(sectionName, asType := "") {
		supportedLanguages := Language.GetSupported()
		userLanguage := Language.Get()

		try {

			titles := Map()
			for lang in supportedLanguages {
				titles.Set(lang, sectionName)
			}

			if InStr(sectionName, "|") {
				titleVariants := StrSplit(sectionName, "|")

				for variant in titleVariants {
					RegExMatch(variant, "^(.*?):(.*)$", &match)
					inSupportedENRU := supportedLanguages.HasRegEx("i)^" match[1] "\-(US|RU)", &i)
					inSupportedNoENRU := supportedLanguages.HasRegEx("i)^" match[1] "\-(?!US|RU)", &j)
					if inSupportedENRU {
						titles.Set(supportedLanguages[i], match[2])
					} else if inSupportedNoENRU {
						titles.Set(supportedLanguages[j], match[2])
					}
				}
			}

			return asType is String ? titles.Get(userLanguage) : asType is Array ? titles.Values() : titles
		} catch {
			MsgBox(Locale.ReadInject("gui_recipes_error_titles", [sectionName]), App.Title("+status+version"))
			return False
		}
	}
}