/*
\\	App’s configuration class
*/

Class Cfg {
	static ini := App.paths.dir "\DSLKeyPad.configtest.ini"
	static sections := [
		"Settings", [
			"Character_Web_Resource", "SymblCC",
			"Input_Mode", "Default",
			"LaTeX_Mode", "Default",
			"Input_Script", "Default",
			"Layout_Latin", "QWERTY",
			"Layout_Cyrillic", "ЙЦУКЕН",
			"Mode_Fast_Keys", "False",
			"Skip_Group_Messages", "False",
			"User_Language", "",
			"F13F24", "False",
		],
		"Compose", [],
		"ScriptProcessor", [
			"Advanced_Mode", "False",
			"Auto_Diacritics", "True",
		],
		"TemperatureCalc", [
			"Dedicated_Unicode_Chars", "True",
			"Format_Extended", "True",
			"Format_Min_At", 4,
			"Round_Value_To", 2,
			"Num_Space_Type", "narrow_no_break_space",
			"Deg_Space_Type", "thinspace",
		],
		"CustomRules", [
			"Paragraph_Beginning", "",
			"Paragraph_After_Start_Emdash", "",
			"GREP_Dialog_Attribution", "",
			"GREP_ThisEmdash", "",
			"GREP_Initials", "",
			"GREP_Initials", "",
		],
		"LatestPrompts", [
			"LaTeX", "",
			"Unicode", "",
			"Altcode", "",
			"Search", "",
			"Ligature", "",
			"Roman_Numeral", "",
		],
		"ServiceFields", [
			"Prev_Layout", "",
		],
	]

	static __New() {
		this.Init()
	}

	static optionsTitle := App.winTitle " — " ReadLocale("gui_options")

	static EditorGUI := Gui()
	static EditorSubGUIs := {
		recipesTitle: App.winTitle " — " ReadLocale("gui_recipes"),
		recipes: Gui(),
	}

	static Editor() {
		this.optionsTitle := App.winTitle " — " ReadLocale("gui_options")

		Constructor() {
			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := 450
			windowHeight := 720

			xPos := (screenWidth - windowWidth) / 2
			yPos := screenHeight - windowHeight - 92

			optionsPanel := Gui()
			optionsPanel.title := this.optionsTitle

			defaultSizes := { groupBoxW: 420, groupBoxX: (windowWidth - 420) / 2 }

			optionsCommonY := 10
			optionsCommonH := 200
			optionsCommon := (h := optionsCommonH, y := optionsCommonY) => "x" defaultSizes.groupBoxX " y" y " w" defaultSizes.groupBoxW " h" h

			optionsPanel.AddGroupBox("vGroupCommon " optionsCommon())

			optionsLanguages := Map(
				"en", "English",
				"ru", "Русский",
			)
			languageSelectorY := (add := 0) => optionsCommonY + 35 + add
			languageSelectorX := (add := 0) => 25 + add

			optionsPanel.AddText("vLanguageLabel x" languageSelectorX() " y" languageSelectorY(-17) " w80 BackgroundTrans", ReadLocale("gui_options_language"))

			languageSelector := optionsPanel.AddDropDownList("vLanguage x" languageSelectorX() " w80 y" languageSelectorY(), [optionsLanguages["en"], optionsLanguages["ru"]])
			PostMessage(0x0153, -1, 15, languageSelector)

			languageSelector.Text := optionsLanguages[Language.Get()]
			languageSelector.OnEvent("Change", (CB, Zero) => Options.SwitchLanguage(CB))

			layouSelectorTextY := 32
			layouSelectorY := (add := 1) => layouSelectorTextY + (16 + add)

			optionsPanel.AddText("vLayoutLabel x" languageSelectorX() " y" languageSelectorY(layouSelectorTextY) " w80 BackgroundTrans", ReadLocale("gui_options_layout"))

			layoutLatinSelector := optionsPanel.AddDropDownList("vLatinLayout x" languageSelectorX() " w80 y" languageSelectorY(layouSelectorY()), GetLayoutsList)
			PostMessage(0x0153, -1, 15, layoutLatinSelector)
			layoutLatinSelector.Text := Cfg.Get("Layout_Latin")
			layoutLatinSelector.OnEvent("Change", (CB, Zero) => Options.SwitchVirualLayout(CB, "Latin"))

			layoutCyrillicSelector := optionsPanel.AddDropDownList("vCyrillicLayout x" languageSelectorX() " w80 y" languageSelectorY(layouSelectorY(23)), CyrillicLayoutsList)
			PostMessage(0x0153, -1, 15, layoutCyrillicSelector)
			layoutCyrillicSelector.Text := Cfg.Get("Layout_Cyrillic")
			layoutCyrillicSelector.OnEvent("Change", (CB, Zero) => Options.SwitchVirualLayout(CB, "Cyrillic"))


			optionsPanel.AddGroupBox("vGroupUpdates " optionsCommon(55, (optionsCommonY + optionsCommonH) + 10), ReadLocale("gui_options_updates"))

			if UpdateAvailable {

			} else {

				optionsPanel.AddText("vUpdateAbsent x" (windowWidth - 256) / 2 " y" (optionsCommonH + optionsCommonY + 35) " w256 Center BackgroundTrans", ReadLocale("update_absent"))
			}

			optionsPanel.AddGroupBox(optionsCommon(55, (windowHeight - 65)))

			iniFilesY := windowHeight - 50
			iniFilesX := (add := 0, reverse := False) => reverse ? (defaultSizes.groupBoxW - 27 - add) : (25 + add)

			recipesPanelBtn := optionsPanel.AddButton("x" iniFilesX() " y" iniFilesY " w32 h32")
			recipesPanelBtn.OnEvent("Click", (*) => OpenRecipesPanel())
			GuiButtonIcon(recipesPanelBtn, ImageRes, 188)

			configFileBtn := optionsPanel.AddButton("x" iniFilesX(32) " y" iniFilesY " w32 h32")
			configFileBtn.OnEvent("Click", (*) => OpenConfigFile())
			GuiButtonIcon(configFileBtn, ImageRes, 065)

			localesFileBtn := optionsPanel.AddButton("x" iniFilesX(32 * 2) " y" iniFilesY " w32 h32")
			localesFileBtn.OnEvent("Click", (*) => OpenLocalesFile())
			GuiButtonIcon(localesFileBtn, ImageRes, 015)


			openFolderBtn := optionsPanel.AddButton("x" iniFilesX(, True) " y" iniFilesY " w32 h32")
			openFolderBtn.OnEvent("Click", (*) => Run(A_ScriptDir))
			GuiButtonIcon(openFolderBtn, ImageRes, 180)


			autoloadBtn := optionsPanel.AddButton("vAutoload x" (windowWidth - 150) / 2 " y" iniFilesY " w150 h32", ReadLocale("autoload_add"))
			autoloadBtn.OnEvent("Click", AddScriptToAutoload)

			optionsPanel.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)
			return optionsPanel


			OpenRecipesPanel() {
				if IsGuiOpen(this.EditorSubGUIs.recipesTitle) {
					WinActivate(this.EditorSubGUIs.recipesTitle)
				} else {
					this.EditorSubGUIs.recipes := this.SubGUIs("Recipes")
					this.EditorSubGUIs.recipes.Show()
				}
			}
		}


		if IsGuiOpen(this.optionsTitle) {
			WinActivate(this.optionsTitle)
		} else {
			this.EditorGUI := Constructor()
			this.EditorGUI.Show()
		}
	}

	static SubGUIs(guiName) {

		RecipesConstructor() {
			this.EditorSubGUIs.recipesTitle := App.winTitle " — " ReadLocale("gui_recipes"),
			currentRecipe := []

			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := 450
			windowHeight := 450

			xPos := (screenWidth - windowWidth) / 2
			yPos := screenHeight - windowHeight - 92

			if IsGuiOpen(this.optionsTitle) && WinActive(this.optionsTitle) {
				WinGetPos(&optx, &opty, &optw, &opth)

				xPos := xPos - optw
			}

			recipesPanel := Gui()
			recipesPanel.title := this.EditorSubGUIs.recipesTitle


			defaultSizes := { groupBoxW: 420, groupBoxX: (windowWidth - 420) / 2 }

			optionsCommonY := 10
			optionsCommonH := 370
			optionsCommon := (h := optionsCommonH, y := optionsCommonY) => "x" defaultSizes.groupBoxX " y" y " w" defaultSizes.groupBoxW " h" h

			listViewCols := [ReadLocale("col_name"), ReadLocale("col_recipe"), ReadLocale("col_result"), ReadLocale("col_entry_title")]

			recipesLVStyles := "x" defaultSizes.groupBoxX " y" optionsCommonY " w" defaultSizes.groupBoxW " h" optionsCommonH " +NoSort -Multi"
			recipesLV := recipesPanel.AddListView(recipesLVStyles, listViewCols)
			recipesLV.ModifyCol(1, 158)
			recipesLV.ModifyCol(2, 98)
			recipesLV.ModifyCol(3, 158)
			recipesLV.ModifyCol(4, 0)
			recipesLV.OnEvent("ItemFocus", (LV, RowNumber) => setSelected(LV, RowNumber))
			recipesLV.OnEvent("DoubleClick", (*) => createEditRecipe(currentRecipe))

			recipesArray := MyRecipes.Read()

			for recipeEntry in recipesArray {
				recipesLV.Add(, recipeEntry.name, RegExReplace(recipeEntry.recipe, "\|", ", "), Util.StrFormattedReduce(recipeEntry.result, 24), recipeEntry.section)
			}


			recipesPanel.AddGroupBox(optionsCommon(55, (windowHeight - 65)))

			addRemY := windowHeight - 50
			addRemX := (add := 0) => 25 + add

			addRecipeBtn := recipesPanel.AddButton("x" addRemX() " y" addRemY " w64 h32", "+")
			addRecipeBtn.SetFont("s16")
			addRecipeBtn.OnEvent("Click", (*) => createEditRecipe())

			removeRecipeBtn := recipesPanel.AddButton("x" addRemX(64) " y" addRemY " w64 h32", Chr(0x2212))
			removeRecipeBtn.SetFont("s16")
			removeRecipeBtn.OnEvent("Click", (*) => removeSelected(currentRecipe))

			recipesPanel.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)
			return recipesPanel

			setSelected(LV, rowNumber) {
				currentRecipe := [
					LV.GetText(RowNumber, 1),
					LV.GetText(RowNumber, 2),
					LV.GetText(RowNumber, 3),
					LV.GetText(RowNumber, 4),
					rowNumber
				]
				return
			}

			createEditRecipe(recipeArray?) {
				if IsSet(recipeArray) && recipeArray.Length > 0 && InStr(recipeArray[4], "xcompose") {
					RegExMatch(recipeArray[4], "\[(.*)\]", &match)
					MsgBox(ReadLocale("gui_recipes_xcompose_break") "`n`n" Chr(0x2026) "\User\" match[1], App.winTitle)
					return
				} else {
					MyRecipes.Editor(recipeArray?, recipesLV)
				}
			}

			removeSelected(recipeArray) {
				if recipeArray.Length > 0 {
					if InStr(recipeArray[4], "xcompose") {
						RegExMatch(recipeArray[4], "\[(.*)\]", &match)
						MsgBox(ReadLocale("gui_recipes_xcompose_break") "`n`n" Chr(0x2026) "\User\" match[1], App.winTitle)
						return
					} else {
						message := SetStringVars(ReadLocale("gui_recipes_remove_confirm"), recipeArray[1])
						confirBox := MsgBox(message, App.title, 4)
						if confirBox = "No" {
							return
						} else if confirBox = "Yes" {
							MyRecipes.Remove(recipeArray[4])
							recipesLV.Delete(recipeArray[5])
						}
					}
				}
			}
		}

		return %guiName%Constructor()
	}

	static Init() {
		for i, section in this.sections {
			if Mod(i, 2) == 1 {
				entries := this.sections[i + 1]
				for j, entry in entries {
					if Mod(j, 2) == 1 && !this.Get(entry, section) {
						value := entries[j + 1]

						this.Set(value, entry, section)
					}
				}
			}
		}
	}

	static BindedVars() {
		return [
			"FastKeysOn", this.Get("Mode_Fast_Keys", "Settings", False, "bool"),
			"InputMode", this.Get("Input_Mode", "Settings", "Default"),
			"LaTeXMode", this.Get("LaTeX_Mode", "Settings", "Default"),
			"SkipGroupMessage", this.Get("Skip_Group_Messages", "Settings", False, "bool"),
		]
	}

	static Set(value, entry, section := "Settings", options := "") {
		if this.sections.HasValue(section) {
			this.OptionsHandler(value, options, &value)

			IniWrite(value, this.ini, section, entry)

			this.BindedVarsHandler()
		} else {
			throw Error("Unknown config section: " section)
		}
	}

	static Get(entry, section := "Settings", default := "", options := "") {
		if this.sections.HasValue(section) {
			value := IniRead(this.ini, section, entry, default)

			this.OptionsHandler(value, options, &value)
		} else {
			throw Error("Unknown config section: " section)
		}
		return value
	}

	static SwitchSet(valuesVariants, entry, section := "Settings", options := "") {
		currentValue := this.Get(entry, section)
		found := false

		for i, value in valuesVariants {
			if (value = currentValue) {
				nextIndex := (i = valuesVariants.MaxIndex()) ? 1 : i + 1
				this.Set(valuesVariants[nextIndex], entry, section, options)
				found := true
				break
			}
		}

		if (!found) {
			this.Set(valuesVariants[1], entry, section, options)
		}
	}

	static OptionsHandler(value, options := "", &output := value) {
		if InStr(options, "toHex")
			value := ConvertToHexaDecimal(value)
		if InStr(options, "fromHex")
			value := ConvertFromHexaDecimal(value)
		if InStr(options, "bool")
			value := (value = "True")
		if InStr(options, "int")
			value := Integer(value)

		output := value
	}

	static BindedVarsHandler() {
		bindedVars := this.BindedVars()

		for i, variable in bindedVars {
			if Mod(i, 2) == 1 {
				value := bindedVars[i + 1]
				if InStr(variable, ".") {
					variableEntry := StrSplit(variable, ".")

					try {
						variableLink := %variableEntry[1]%

						for j, entry in variableEntry {
							if j > 1 {
								variableLink := variableLink.%entry%
							}
						}
						variableLink := value
					} catch {
						continue
					}
				} else {
					try {
						if IsSet(%variable%)
							%variable% := value
						else {
							Cfg.%variable% := value
						}
					} catch {
						continue
					}
				}
			}
		}
	}
}


Class Options {
	static SwitchLanguage(CB) {
		locales := Map(
			"en", ["English", "Английский"],
			"ru", ["Russian", "Русский"],
		)

		for key, value in locales {
			if value.HasValue(CB.Text) || key = CB.Text {
				Cfg.Set(key, "User_Language")
				break
			}
		}

		pastOptionsTitle := Cfg.optionsTitle
		pastRecipesTitle := Cfg.EditorSubGUIs.recipesTitle
		pastRecipesEditorTitle := MyRecipes.editorTitle


		Cfg.optionsTitle := App.winTitle " — " ReadLocale("gui_options")
		Cfg.EditorSubGUIs.recipesTitle := App.winTitle " — " ReadLocale("gui_recipes")

		MyRecipes.editorTitle := App.winTitle " — " ReadLocale("gui_recipes_create")

		if IsGuiOpen(pastOptionsTitle) {
			Cfg.EditorGUI.Title := Cfg.optionsTitle
			Cfg.EditorGUI["GroupUpdates"].Text := ReadLocale("gui_options_updates")

			Cfg.EditorGUI["LanguageLabel"].Text := ReadLocale("gui_options_language")
			Cfg.EditorGUI["LayoutLabel"].Text := ReadLocale("gui_options_layout")
			Cfg.EditorGUI["Autoload"].Text := ReadLocale("autoload_add")

			try {
				Cfg.EditorGUI["UpdateAbsent"].Text := ReadLocale("update_absent")
			}
		}

		if IsGuiOpen(pastRecipesTitle) {
			Cfg.EditorSubGUIs.recipes.Title := Cfg.EditorSubGUIs.recipesTitle
		}

		if IsGuiOpen(pastRecipesEditorTitle) {
			MyRecipes.EditorGUI.Title := MyRecipes.editorTitle
			MyRecipes.EditorGUI["SectionLabel"].Text := ReadLocale("gui_recipes_create_section")
			MyRecipes.EditorGUI["NameLabel"].Text := ReadLocale("gui_recipes_create_name")
			MyRecipes.EditorGUI["RecipeLabel"].Text := ReadLocale("gui_recipes_create_recipe")
			MyRecipes.EditorGUI["ResultLabel"].Text := ReadLocale("gui_recipes_create_result")
			MyRecipes.EditorGUI["SaveButton"].Text := ReadLocale("gui_save")
			MyRecipes.EditorGUI["CancelButton"].Text := ReadLocale("gui_cancel")
		}


		ManageTrayItems()
	}

	static SwitchVirualLayout(CB, category) {
		if category = "Cyrillic" {
			Cfg.Set(CB.Text, "Layout_Cyrillic")
		} else if category = "Latin" {
			Cfg.Set(CB.Text, "Layout_Latin")
		}
	}
}

>^F9:: Cfg.Editor()