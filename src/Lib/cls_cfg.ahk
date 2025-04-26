/*
\\	App’s configuration class
*/

Class Cfg {

	static sections := [
		"Settings", [
			"Character_Web_Resource", "SymblCC",
			"LaTeX_Mode", "Default",
			"Input_Script", "Default",
			"Layout_Latin", "QWERTY",
			"Layout_Cyrillic", "ЙЦУКЕН",
			"Active_User_Bindings", "None",
			"Mode_Fast_Keys", "False",
			"Binds_Autodisable_Timer", "1",
			"Binds_Autodisable_Type", "hour",
			"Skip_Group_Messages", "False",
			"XCompose_Add_Recipe_Prefix", "False",
			"User_Language", "",
			"Validate_With_CaretPos", "True",
			"F13F24", "False",
		],
		"Compose", [],
		"ScriptProcessor", [
			"Advanced_Mode", "False",
			"Auto_Diacritics", "True",
		],
		"Characters", [
			"I_Dot_Shift_I_Dotless", "Default",
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

	static ini := App.paths.profile "\Config.ini"

	static __New() {
		this.Init()
	}

	static optionsTitle := App.winTitle " — " Locale.Read("gui_options")

	static EditorGUI := Gui()
	static EditorSubGUIs := {
		recipesTitle: App.winTitle " — " Locale.Read("gui_recipes"),
		recipes: Gui(),
	}

	static OpenFile(*) {
		Run(this.ini)
	}

	static Editor() {
		Update.CheckUpdate()

		if Update.available {
			ManageTrayItems()
		}

		this.optionsTitle := App.winTitle " — " Locale.Read("gui_options")

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

			optionsPanel.AddText("vLanguageLabel x" languageSelectorX() " y" languageSelectorY(-17) " w128 BackgroundTrans", Locale.Read("gui_options_language"))

			languageSelector := optionsPanel.AddDropDownList("vLanguage x" languageSelectorX() " w128 y" languageSelectorY(), [optionsLanguages["en"], optionsLanguages["ru"]])
			PostMessage(0x0153, -1, 15, languageSelector)

			languageSelector.Text := optionsLanguages[Language.Get()]
			languageSelector.OnEvent("Change", (CB, Zero) => Options.SwitchLanguage(CB))

			layouSelectorTextY := 32
			layouSelectorY := (add := 1) => layouSelectorTextY + (16 + add)

			optionsPanel.AddText("vLayoutLabel x" languageSelectorX() " y" languageSelectorY(layouSelectorTextY) " w128 BackgroundTrans", Locale.Read("gui_options_layout"))

			layoutist := {
				latin: KeyboardBinder.layouts.latin.Keys(),
				cyrillic: KeyboardBinder.layouts.cyrillic.Keys()
			}

			layoutLatinSelector := optionsPanel.AddDropDownList("vLatinLayout x" languageSelectorX() " w128 y" languageSelectorY(layouSelectorY()), layoutist.latin)
			PostMessage(0x0153, -1, 15, layoutLatinSelector)
			layoutLatinSelector.Text := Cfg.Get("Layout_Latin")
			layoutLatinSelector.OnEvent("Change", (CB, Zero) => KeyboardBinder.SetLayout(CB.Text))

			layoutCyrillicSelector := optionsPanel.AddDropDownList("vCyrillicLayout x" languageSelectorX() " w128 y" languageSelectorY(layouSelectorY(23)), layoutist.cyrillic)
			PostMessage(0x0153, -1, 15, layoutCyrillicSelector)
			layoutCyrillicSelector.Text := Cfg.Get("Layout_Cyrillic")
			layoutCyrillicSelector.OnEvent("Change", (CB, Zero) => KeyboardBinder.SetLayout(CB.Text))

			bindingsList := KeyboardBinder.userBindings.Clone()
			bindingsList.InsertAt(1, Locale.Read("gui_options_bindings_none"))
			currentBindings := Cfg.Get("Active_User_Bindings", , "None")
			currentBindings := currentBindings = "None" ? Locale.Read("gui_options_bindings_none") : currentBindings

			optionsPanel.AddText("vBindingsLabel x" languageSelectorX() " y" languageSelectorY(layouSelectorY(50)) " w128 BackgroundTrans", Locale.Read("gui_options_bindings"))

			bindingsSelector := optionsPanel.AddDropDownList("vBindings x" languageSelectorX() " w128 y" languageSelectorY(layouSelectorY(66)), bindingsList)
			PostMessage(0x0153, -1, 15, bindingsSelector)
			bindingsSelector.Text := currentBindings
			bindingsSelector.OnEvent("Change", (CB, Zero) => KeyboardBinder.SetBinds(CB.Text))

			optionsPanel.AddGroupBox("vGroupUpdates " optionsCommon(55, (optionsCommonY + optionsCommonH) + 10), Locale.Read("gui_options_updates"))

			if Update.available {
				updateBtn := optionsPanel.AddButton("vUpdateButton x" (windowWidth - 256) / 2 " y" (optionsCommonH + optionsCommonY + 24) " w256 h32", Util.StrVarsInject(Locale.Read("update_available"), Update.availableVersion))
				updateBtn.OnEvent("Click", (*) => Update.Get())

			} else {
				optionsPanel.AddText("vUpdateAbsent x" (windowWidth - 256) / 2 " y" (optionsCommonH + optionsCommonY + 35) " w256 Center BackgroundTrans", Locale.Read("update_absent"))
			}

			repairBtn := optionsPanel.AddButton(" x" (windowWidth - 32) - 24 " y" (optionsCommonH + optionsCommonY + 24) " w32 h32", Chrs(0x1F6E0, 0xFE0F))
			repairBtn.SetFont("s16")
			repairBtn.OnEvent("Click", (*) => Update.Get(True))

			tabLabelChars := Locale.Read("gui_options_tab_characters")
			tabLabels := [tabLabelChars]

			optionsTabs := optionsPanel.AddTab3("vOptionsTabs " optionsCommon(250, (optionsCommonY + optionsCommonH) + 75), tabLabels)

			optionsTabs.UseTab(tabLabelChars)

			letterI_labels := [
				Locale.Read("gui_options_default") " — Ii",
				Locale.Read("gui_options_separated") " — " Chr(0x0130) "i, LShift I" Chr(0x0131),
				Locale.Read("gui_options_hybrid") " — Ii, LShift " Chr(0x0130) Chr(0x0131),
			]

			optionsPanel.AddText("vLetterI_Option x" languageSelectorX() " y" languageSelectorY(290 - 17) " w80 BackgroundTrans", Locale.Read("gui_options_letterI"))

			letterI_selector := optionsPanel.AddDropDownList("vLetterI_selector x" languageSelectorX() " w128 y" languageSelectorY(290), letterI_labels)
			PostMessage(0x0153, -1, 15, letterI_selector)

			letterI_savedOption := Cfg.Get("I_Dot_Shift_I_Dotless", "Characters")
			letterI_selector.Text := letterI_savedOption = "Separated" ? letterI_labels[2] : letterI_savedOption = "Hybrid" ? letterI_labels[3] : letterI_labels[1]
			letterI_selector.OnEvent("Change", (CB, Zero) => Options.CharacterOption(CB, "I"))

			optionsTabs.UseTab()

			optionsPanel.AddGroupBox(optionsCommon(55, (windowHeight - 65)))

			iniFilesY := windowHeight - 50
			iniFilesX := (add := 0, reverse := False) => reverse ? (defaultSizes.groupBoxW - 27 - add) : (25 + add)

			recipesPanelBtn := optionsPanel.AddButton("x" iniFilesX() " y" iniFilesY " w32 h32")
			recipesPanelBtn.OnEvent("Click", (*) => OpenRecipesPanel())
			GuiButtonIcon(recipesPanelBtn, ImageRes, 188)

			configFileBtn := optionsPanel.AddButton("x" iniFilesX(32) " y" iniFilesY " w32 h32")
			configFileBtn.OnEvent("Click", (*) => Cfg.OpenFile())
			GuiButtonIcon(configFileBtn, ImageRes, 065)

			localesFileBtn := optionsPanel.AddButton("x" iniFilesX(32 * 2) " y" iniFilesY " w32 h32")
			localesFileBtn.OnEvent("Click", (*) => Locale.OpenDir())
			GuiButtonIcon(localesFileBtn, ImageRes, 015)


			openFolderBtn := optionsPanel.AddButton("x" iniFilesX(, True) " y" iniFilesY " w32 h32")
			openFolderBtn.OnEvent("Click", (*) => Run(A_ScriptDir))
			GuiButtonIcon(openFolderBtn, ImageRes, 180)


			autoloadBtn := optionsPanel.AddButton("vAutoload x" (windowWidth - 150) / 2 " y" iniFilesY " w150 h32", Locale.Read("autoload_add"))
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
			this.EditorSubGUIs.recipesTitle := App.winTitle " — " Locale.Read("gui_recipes"),
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

			listViewCols := [Locale.Read("col_name"), Locale.Read("col_recipe"), Locale.Read("col_result"), Locale.Read("col_entry_title"), ""]

			recipesLVStyles := "x" defaultSizes.groupBoxX " y" optionsCommonY " w" defaultSizes.groupBoxW " h" optionsCommonH " -Multi"
			recipesLV := recipesPanel.AddListView(recipesLVStyles, listViewCols)
			recipesLV.ModifyCol(1, 158)
			recipesLV.ModifyCol(2, 98)
			recipesLV.ModifyCol(3, 158)
			recipesLV.ModifyCol(4, 0)
			recipesLV.ModifyCol(5, 0)
			recipesLV.OnEvent("ItemFocus", (LV, RowNumber) => setSelected(LV, RowNumber))
			recipesLV.OnEvent("DoubleClick", (*) => createEditRecipe(currentRecipe))

			recipesArray := MyRecipes.Read()

			for recipeEntry in recipesArray {
				recipeFilePath := recipeEntry.HasOwnProp("filePath") ? recipeEntry.filePath : ""
				recipesLV.Add(,
					MyRecipes.HandleTitles(recipeEntry.name, True),
					RegExReplace(ChrRecipeHandler.MakeStr(recipeEntry.recipe), "\|", ", "),
					Util.StrFormattedReduce(ChrRecipeHandler.MakeStr(recipeEntry.result), 24),
					recipeEntry.section, recipeFilePath)
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

			attachRecipesListBtn := recipesPanel.AddButton("x" addRemX(128) " y" addRemY " w128 h32", Locale.Read("gui_recipes_attach_list"))
			attachRecipesListBtn.SetFont("s9")
			attachRecipesListBtn.OnEvent("Click", (*) => attachList())

			attachListBtn := recipesPanel.AddButton("x" addRemX(256) " y" addRemY " w32 h32", Chr(0x1F5D2))
			attachListBtn.SetFont("s16")
			attachListBtn.OnEvent("Click", (*) => Run(App.paths.profile "\Attachments.ini"))

			recipesPanel.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)
			return recipesPanel

			attachList() {
				attachmentFiles := FileSelect("M", App.paths.profile, Locale.Read("gui_recipes_attach_list"), "*.ini")

				if (!attachmentFiles)
					return []

				trimmedFiles := []
				basePath := App.paths.profile "\"

				for filePath in attachmentFiles {
					trimmedPath := Util.TrimBasePath(filePath)
					if (trimmedPath != filePath) {
						trimmedFiles.Push(trimmedPath)
					}
				}

				if trimmedFiles.Length == 0 {
					return
				}

				for trimmedFile in trimmedFiles {
					MyRecipes.AddAttachment(trimmedFile)
				}

				MyRecipes.UpdateChrLib()
			}

			setSelected(LV, rowNumber) {
				currentRecipe := [
					LV.GetText(RowNumber, 1),
					LV.GetText(RowNumber, 2),
					LV.GetText(RowNumber, 3),
					LV.GetText(RowNumber, 4),
					rowNumber,
					LV.GetText(RowNumber, 5),
				]
				return
			}

			createEditRecipe(recipeArray?) {
				if IsSet(recipeArray) && recipeArray.Length > 0 && (InStr(recipeArray[4], "xcompose") || InStr(recipeArray[4], "__attachment_from__")) {
					attachmentName := StrLen(recipeArray[6]) > 0 ? recipeArray[6] : ""
					MsgBox(Locale.Read("gui_recipes_" (InStr(recipeArray[4], "xcompose") ? "xcompose_break" : "attach_edit_unable")) "`n`n" Chr(0x2026) "\User\profile-" App.profileName "\" attachmentName, App.winTitle)
					return
				} else {
					MyRecipes.Editor(recipeArray?, recipesLV)
				}
			}

			removeSelected(recipeArray) {
				if recipeArray.Length > 0 {
					if (InStr(recipeArray[4], "xcompose") || InStr(recipeArray[4], "__attachment_from__")) {
						attachmentName := StrLen(recipeArray[6]) > 0 ? recipeArray[6] : ""
						MsgBox(Locale.Read("gui_recipes_" (InStr(recipeArray[4], "xcompose") ? "xcompose_break" : "attach_edit_unable")) "`n`n" Chr(0x2026) "\User\profile-" App.profileName "\" attachmentName, App.winTitle)
						return
					} else {
						message := Util.StrVarsInject(Locale.Read("gui_recipes_remove_confirm"), recipeArray[1])
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
			"LaTeXMode", this.Get("LaTeX_Mode", "Settings", "Default"),
			"SkipGroupMessage", this.Get("Skip_Group_Messages", "Settings", False, "bool"),
		]
	}

	static Set(value, entry, section := "Settings", options := "") {
		if this.sections.HasValue(section) {
			if InStr(options, "bool")
				value := value ? "False" : "True"
			else
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
			value := (value = "True" || value = 1)
		if InStr(options, "int")
			value := Integer(value)
		if InStr(options, "num")
			value := Number(value)
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


		Cfg.optionsTitle := App.winTitle " — " Locale.Read("gui_options")
		Cfg.EditorSubGUIs.recipesTitle := App.winTitle " — " Locale.Read("gui_recipes")

		MyRecipes.editorTitle := App.winTitle " — " Locale.Read("gui_recipes_create")

		if IsGuiOpen(pastOptionsTitle) {
			Cfg.EditorGUI.Title := Cfg.optionsTitle
			Cfg.EditorGUI["GroupUpdates"].Text := Locale.Read("gui_options_updates")

			Cfg.EditorGUI["LanguageLabel"].Text := Locale.Read("gui_options_language")
			Cfg.EditorGUI["LayoutLabel"].Text := Locale.Read("gui_options_layout")
			Cfg.EditorGUI["BindingsLabel"].Text := Locale.Read("gui_options_bindings")
			Cfg.EditorGUI["Autoload"].Text := Locale.Read("autoload_add")

			try {
				Cfg.EditorGUI["UpdateAbsent"].Text := Locale.Read("update_absent")
			}
		}

		if IsGuiOpen(pastRecipesTitle) {
			Cfg.EditorSubGUIs.recipes.Title := Cfg.EditorSubGUIs.recipesTitle
		}

		if IsGuiOpen(pastRecipesEditorTitle) {
			MyRecipes.EditorGUI.Title := MyRecipes.editorTitle
			MyRecipes.EditorGUI["SectionLabel"].Text := Locale.Read("gui_recipes_create_section")
			MyRecipes.EditorGUI["NameLabel"].Text := Locale.Read("gui_recipes_create_name")
			MyRecipes.EditorGUI["RecipeLabel"].Text := Locale.Read("gui_recipes_create_recipe")
			MyRecipes.EditorGUI["ResultLabel"].Text := Locale.Read("gui_recipes_create_result")
			MyRecipes.EditorGUI["SaveButton"].Text := Locale.Read("gui_save")
			MyRecipes.EditorGUI["CancelButton"].Text := Locale.Read("gui_cancel")
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

	static CharacterOption(CB, letter) {
		if letter = "I" {
			if InStr(CB.Text, Chr(0x0130) Chr(0x0131), True) {
				Cfg.Set("Hybrid", "I_Dot_Shift_I_Dotless", "Characters")
			} else if InStr(CB.Text, Chr(0x0130) "i", True) {
				Cfg.Set("Separated", "I_Dot_Shift_I_Dotless", "Characters")
			} else {
				Cfg.Set("Default", "I_Dot_Shift_I_Dotless", "Characters")
			}
		}

		KeyboardBinder.RebuilBinds()
	}
}

>^F9:: Cfg.Editor()