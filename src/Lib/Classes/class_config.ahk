Class Cfg {
	static sections := [
		"Settings", [
			"User_Language", "",
			"Validate_With_CaretPos", "True",
			"Turn_Off_Autocheck_Update", "False",
			"Mode_Fast_Keys", "True",
			"Mode_Fast_Keys_Over", "",
			"LaTeX_Mode", "Text",
			"LaTeX_Hotstrings", "True",
			"HTML_Mode", "Decimal",
			"Layout_Latin", "QWERTY",
			"Layout_Cyrillic", "ЙЦУКЕН",
			"Layout_Hellenic", "ϞϜΕΡΤΥ",
			"Layout_Remapping", "False",
			"Active_User_Bindings", "None",
			"Alt_Input_Autoactivation", "True",
			"Binds_Autodisable_Timer", "1",
			"Binds_Autodisable_Type", "hour",
			"XCompose_Add_Recipe_Prefix", "False",
			"F13F24", "False",
			"Bind_Register_Tooltip_Progress_Bar", "True",
			"Unicode_Web_Resource", "SymblCC",
			"Unicode_Web_Resource_Use_System_Language", "False",
			"First_Message", "True",
		],
		"IPA", [
			"Referencing_Rule_Latin", "False",
		],
		"PanelGUI", [
			"List_Items_Font_Size", "",
			"Preview_Font_Family", "",
			"Filter_RegEx", "True",
			"Filter_Mode", "Names",
			"Filter_Case_Sensitive", "True",
		],
		"UI", [
			"Scripter_Selector_Max_Items", 24,
			"Scripter_Selector_Max_Items_Glyph", 32,
			"Scripter_Selector_Max_Columns", 4,
			"Scripter_Selector_Max_Columns_Threshold", 24,
			"Scripter_Selector_Max_Columns_Threshold_Glyph", 32,
			"Scripter_Selector_Use_Number_Keys", "False",
		],
		"Compose", [
			"Font_Size", 10,
			"Font_Name", Fonts.Get("Sans-Serif"),
			"Background_Color", "White",
			"Font_Color", "333333",
			"Suggestions_Line_Max_Length", 80,
			"Suggestions_Limiter", 80,
			"Suggestions_Limiter_Multiplier", 8,
			"Show_Suggestions", "True",
			"Show_Favorites", "True",
			"Show_Alt_Recipes", "False",
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
		"Dev", [
			"Git_Path", "",
		],
	]

	static sessionSettings := Map(
		"Input_Mode", "Unicode",
	)

	static ini := App.PATHS.PROFILE "\Config.ini"

	static __New() {
		this.Init()
		return
	}

	static optionsTitle := App.Title("+status+version") " — " Locale.Read("gui.options")

	static EditorGUI := Gui()

	static OpenFile(*) {
		Run(this.ini)
	}

	static Editor(xPos := 0, yPos := 0) {
		autocheckOff := Cfg.Get("Turn_Off_Autocheck_Update", , False, "bool")
		if !autocheckOff
			Update.Check(, False)

		if Update.available {
			TrayMenu.SetTrayItems()
		}

		this.optionsTitle := App.Title("+status+version") " — " Locale.Read("gui.options")

		Constructor() {
			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := 450
			windowHeight := 770

			xPos := xPos = 0 ? (screenWidth - windowWidth) / 2 : xPos
			yPos := yPos = 0 ? screenHeight - windowHeight - 92 : yPos

			local optionsPanel := Gui()
			optionsPanel.title := this.optionsTitle

			local defaultSizes := { groupBoxW: 420, groupBoxX: (windowWidth - 420) / 2 }

			local optionsCommonY := 10
			local optionsCommonH := 230
			local optionsCommon := (h := optionsCommonH, y := optionsCommonY, addW := 0) => "x" defaultSizes.groupBoxX " y" y " w" defaultSizes.groupBoxW + addW " h" h

			optionsPanel.AddGroupBox("vGroupCommon " optionsCommon())

			local optionsLanguages := Language.GetSupported(, "title")
			local languageSelectorY := (add := 0) => optionsCommonY + 35 + add
			local languageSelectorX := (add := 0) => 25 + add

			optionsPanel.AddText("vLanguageLabel x" languageSelectorX() " y" languageSelectorY(-17) " w128 BackgroundTrans", Locale.Read("dictionary.language"))

			local languageSelector := optionsPanel.AddDropDownList("vLanguage x" languageSelectorX() " w128 y" languageSelectorY(), optionsLanguages)
			PostMessage(0x0153, -1, 15, languageSelector)

			languageSelector.Text := Language.Get(, True)
			languageSelector.OnEvent("Change", (CB, Zero) => (
				Options.SwitchLanguage(CB),
				this.EditorGUI.GetPos(&X, &Y, &W, &H),
				this.EditorGUI.Destroy(),
				this.Editor(X, Y)
			))

			local layouSelectorTextY := 32
			local layouSelectorY := (add := 1) => layouSelectorTextY + (16 + add)

			optionsPanel.AddText("vLayoutLabel x" languageSelectorX() " y" languageSelectorY(layouSelectorTextY) " w128 BackgroundTrans", Locale.Read("dictionary.layout"))

			local remappingCheckbox := optionsPanel.AddCheckBox("vLayoutRemapping x" languageSelectorX() " y" languageSelectorY(layouSelectorY(4)) " w128", Locale.Read("gui.options.remapping"))
			remappingCheckbox.Value := Cfg.Get("Layout_Remapping", , False, "bool")
			remappingCheckbox.OnEvent("Click", (CB, Zero) => SetRemapping(CB.Value))

			local layoutist := {
				latin: KbdLayoutReg.storedData["latin"].Keys(),
				cyrillic: KbdLayoutReg.storedData["cyrillic"].Keys()
			}

			local layoutLatinSelector := optionsPanel.AddDropDownList("vLatinLayout x" languageSelectorX() " w128 y" languageSelectorY(layouSelectorY(23)), layoutist.latin)
			PostMessage(0x0153, -1, 15, layoutLatinSelector)
			layoutLatinSelector.Text := Cfg.Get("Layout_Latin")
			layoutLatinSelector.OnEvent("Change", (CB, Zero) => KbdBinder.SetLayout(CB.Text))

			local layoutCyrillicSelector := optionsPanel.AddDropDownList("vCyrillicLayout x" languageSelectorX() " w128 y" languageSelectorY(layouSelectorY(23 * 2)), layoutist.cyrillic)
			PostMessage(0x0153, -1, 15, layoutCyrillicSelector)
			layoutCyrillicSelector.Text := Cfg.Get("Layout_Cyrillic")
			layoutCyrillicSelector.OnEvent("Change", (CB, Zero) => KbdBinder.SetLayout(CB.Text))

			local layoutUpdate := optionsPanel.AddButton("vLayoutUpdate x" languageSelectorX(130) " w28 y" languageSelectorY(layouSelectorY(23) - 1))
			GuiButtonIcon(layoutUpdate, App.ICONS_DLL, App.indexIcos["reload_flat"])
			layoutUpdate.OnEvent("Click", (*) => (
				KbdLayoutUserDefined.Update(),
				this.EditorGUI.GetPos(&X, &Y, &W, &H),
				this.EditorGUI.Destroy(),
				this.Editor(X, Y)
			))

			local bindingsList := BindReg.userBindings.Clone()
			bindingsList.InsertAt(1, Locale.Read("dictionary.bindings_none"))
			local currentBindings := Cfg.Get("Active_User_Bindings", , "None")
			currentBindings := currentBindings = "None" ? Locale.Read("dictionary.bindings_none") : currentBindings

			optionsPanel.AddText("vBindingsLabel x" languageSelectorX() " y" languageSelectorY(layouSelectorY(50 + 26)) " w128 BackgroundTrans", Locale.Read("dictionary.bindings"))

			local bindingsSelector := optionsPanel.AddDropDownList("vBindings x" languageSelectorX() " w128 y" languageSelectorY(layouSelectorY(32 * 3)), bindingsList)
			PostMessage(0x0153, -1, 15, bindingsSelector)
			bindingsSelector.Text := currentBindings
			bindingsSelector.OnEvent("Change", (CB, Zero) => KbdBinder.SetBinds(CB.Text))

			local bindingsUpdate := optionsPanel.AddButton("vBindingsUpdate x" languageSelectorX(130) " w28 y" languageSelectorY(layouSelectorY(32 * 3) - 1))
			GuiButtonIcon(bindingsUpdate, App.ICONS_DLL, App.indexIcos["reload_flat"])
			bindingsUpdate.OnEvent("Click", (*) => (
				BindingUserDefined.Update(),
				this.EditorGUI.GetPos(&X, &Y, &W, &H),
				this.EditorGUI.Destroy(),
				this.Editor(X, Y)
			))

			optionsPanel.AddText("vProfileLabel x" languageSelectorX(256 + 16) " y" languageSelectorY(-17) " w128 BackgroundTrans", Locale.Read("profile"))

			local profiles := ArrayMerge(App.profileList, [Locale.Read("profile.new")])
			profiles.RemoveAt(1)
			profiles.InsertAt(1, Locale.Read("profile.default"))

			local profileSelector := optionsPanel.AddDropDownList("vProfile x" languageSelectorX(256 + 16) " w128 y" languageSelectorY(), profiles)
			PostMessage(0x0153, -1, 15, profileSelector)

			profileSelector.Text := App.GetProfile()
			profileSelector.OnEvent("Change", (CB, Zero) => SetProfile(CB.Text))

			optionsPanel.AddText("vUnicodeResourceLabel x" languageSelectorX(256 + 16) " y" languageSelectorY(layouSelectorY((32 * 3) - 17)) " w128 BackgroundTrans", Locale.Read("dictionary.unicode_resource"))

			local resourcesList := UnicodeWebResource.resources.Keys()
			local currentResource := Cfg.Get("Unicode_Web_Resource", , "SymblCC")

			local unicodeResourceSelector := optionsPanel.AddDropDownList("vUnicodeResource x" languageSelectorX(256 + 16) " w128 y" languageSelectorY(layouSelectorY(32 * 3)), resourcesList)
			PostMessage(0x0153, -1, 15, unicodeResourceSelector)
			unicodeResourceSelector.Text := currentResource
			unicodeResourceSelector.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Text, "Unicode_Web_Resource"))

			local unicodeResourceLanguage := optionsPanel.AddCheckBox("vUnicodeResourceLanguage x" languageSelectorX(256 + 16) " y" languageSelectorY(layouSelectorY((32 * 3) + 28)) " w128", Locale.Read("dictionary.system_language"))
			unicodeResourceLanguage.Value := Cfg.Get("Unicode_Web_Resource_Use_System_Language", , False, "bool")
			unicodeResourceLanguage.OnEvent("Click", (CB, Zero) => Cfg.Set(CB.Value, "Unicode_Web_Resource_Use_System_Language", , "bool"))

			optionsPanel.AddGroupBox("vGroupUpdates " optionsCommon(84, (optionsCommonY + optionsCommonH) + 10), Locale.Read("dictionary.updates"))

			local autocheckUpdatesOff := optionsPanel.AddCheckBox("vAutocheckUpdates x" languageSelectorX() " y" languageSelectorY(layouSelectorY((optionsCommonY + optionsCommonH) - 22)) " w384", Locale.Read("gui.options.turn_off_autocheck_updates"))
			autocheckUpdatesOff.Value := Cfg.Get("Turn_Off_Autocheck_Update", , False, "bool")
			autocheckUpdatesOff.OnEvent("Click", (CB, Zero) => Cfg.Set(CB.Value, "Turn_Off_Autocheck_Update", , "bool"))

			if Update.available || autocheckOff {
				updateBtn := optionsPanel.AddButton("vUpdateButton x" (windowWidth - 256) / 2 " y" (optionsCommonH + optionsCommonY + 24) " w256 h32", Locale.ReadInject((autocheckOff ? "gui.options.update_check" : "gui.options.update_get"), [Update.availableVersion]))
				updateBtn.OnEvent("Click", (*) => Update.Check(True))

			} else {
				optionsPanel.AddText("vUpdateAbsent x" (windowWidth - 256) / 2 " y" (optionsCommonH + optionsCommonY + 35) " w256 Center BackgroundTrans", Locale.Read("gui.options.update_absent"))
			}

			local repairBtn := optionsPanel.AddButton(" x" (windowWidth - 32) - 24 " y" (optionsCommonH + optionsCommonY + 24) " w32 h32", Chrs(0x1F6E0, 0xFE0F))
			repairBtn.SetFont("s16")
			repairBtn.OnEvent("Click", (*) => Update.Get(True))

			local tabLabelChars := Locale.Read("gui.options.base")
			local tabIPA := Locale.Read("script_labels.ipa.short")
			local tabUIOptions := Locale.Read("gui.options.UI")
			local tabComposeOptions := Locale.Read("gui.options.compose")
			local tabCache := Locale.Read("dictionary.cache")
			local tabLabels := [tabLabelChars, tabIPA, tabUIOptions, tabComposeOptions, tabCache]


			; TODO: Добавить:
			; * Toggle для включения и отключения кэширования библиотеки символов
			; * Кнопку очистки кэша
			; * Кэш должен быть версиезависимым, т.е. в директории кэша — под-директория текущей версии для её кэша
			; * Кэш остальных версия по умолчанию удаляется

			local optionsTabs := optionsPanel.AddTab3("vOptionsTabs " optionsCommon(250, (optionsCommonY + optionsCommonH) + (84 + 25), 3), tabLabels)

			optionsTabs.UseTab(tabLabelChars)

			local letterI_labels := [
				Locale.Read("dictionary.default") " — Ii",
				Locale.Read("dictionary.separated") " — " Chr(0x0130) "i, LShift I" Chr(0x0131),
				Locale.Read("dictionary.hybrid") " — Ii, LShift " Chr(0x0130) Chr(0x0131),
			]

			optionsPanel.AddText("vLetterI_Option x" languageSelectorX() " y" languageSelectorY(300 + 30) " w80 BackgroundTrans", Locale.Read("gui.options.letterI"))

			letterI_selector := optionsPanel.AddDropDownList("vLetterI_selector x" languageSelectorX() " w128 y" languageSelectorY(300 + 30 + 18), letterI_labels)
			PostMessage(0x0153, -1, 15, letterI_selector)

			letterI_savedOption := Cfg.Get("I_Dot_Shift_I_Dotless", "Characters")
			letterI_selector.Text := letterI_savedOption = "Separated" ? letterI_labels[2] : letterI_savedOption = "Hybrid" ? letterI_labels[3] : letterI_labels[1]
			letterI_selector.OnEvent("Change", (CB, Zero) => Options.CharacterOption(CB, "I"))

			local LaTeXOptionsList := {
				Text: Locale.Read("gui.options.LaTeX.modes.text"),
				Math: Locale.Read("gui.options.LaTeX.modes.math"),
			}

			optionsPanel.AddText("vLaTeXMode x" languageSelectorX(256 + 16) " y" languageSelectorY(300 + 30) " w128 BackgroundTrans", Locale.Read("gui.options.LaTeX.modes"))

			LaTeXModeSelector := optionsPanel.AddDropDownList("vLaTeXModeSelector x" languageSelectorX(256 + 16) " w128 y" languageSelectorY(300 + 30 + 18), [LaTeXOptionsList.Text, LaTeXOptionsList.Math])
			PostMessage(0x0153, -1, 15, LaTeXModeSelector)

			local LaTeXOption := Cfg.Get("LaTeX_Mode", , "Text")
			LaTeXModeSelector.Text := LaTeXOptionsList.HasOwnProp(LaTeXOption) ? LaTeXOptionsList.%LaTeXOption% : LaTeXOptionsList.Text
			LaTeXModeSelector.OnEvent("Change", (CB, Zero) => Options.SetLocalisedOption(CB.Text, LaTeXOptionsList, "LaTeX_Mode"))

			HTMLOptionsList := {
				Decimal: Locale.Read("gui.options.HTML.modes.decimal"),
				Hexadecimal: Locale.Read("gui.options.HTML.modes.hexadecimal"),
			}

			optionsPanel.AddText("vHTMLMode x" languageSelectorX(256 + 16) " y" languageSelectorY(300 + 30 + 50) " w128 BackgroundTrans", Locale.Read("gui.options.HTML.modes"))

			local HTMLModeSelector := optionsPanel.AddDropDownList("vHTMLModeSelector x" languageSelectorX(256 + 16) " w128 y" languageSelectorY(300 + 30 + 18 + 50), [HTMLOptionsList.Decimal, HTMLOptionsList.Hexadecimal])
			PostMessage(0x0153, -1, 15, HTMLModeSelector)

			local HTMLOption := Cfg.Get("HTML_Mode", , "Decimal")
			HTMLModeSelector.Text := HTMLOptionsList.HasOwnProp(HTMLOption) ? HTMLOptionsList.%HTMLOption% : HTMLOptionsList.Decimal
			HTMLModeSelector.OnEvent("Change", (CB, Zero) => Options.SetLocalisedOption(CB.Text, HTMLOptionsList, "HTML_Mode"))

			local LaTeXHotStringsCheckbox := optionsPanel.AddCheckBox("vLaTeXHotstrings x" languageSelectorX() " y" languageSelectorY(300 + 225) " w320", Locale.Read("gui.options.LaTeX.hotstrings"))
			LaTeXHotStringsCheckbox.Value := Cfg.Get("LaTeX_Hotstrings", , False, "bool")
			LaTeXHotStringsCheckbox.OnEvent("Click", (CB, Zero) => LaTeXHotstrings(CB.Value))

			optionsTabs.UseTab(tabIPA)

			local referencingMode := optionsPanel.AddCheckbox("vReferencingMode x" languageSelectorX() " w320 y" languageSelectorY(300 + 30 + 5), Locale.Read("gui.options.IPA.use_latin_instead_greek"))
			referencingMode.Value := Cfg.Get("Referencing_Rule_Latin", "IPA", False, "bool")
			referencingMode.OnEvent("Click", (CB, Zero) => Cfg.Set(CB.Value, "Referencing_Rule_Latin", "IPA", "bool"))

			optionsTabs.UseTab(tabUIOptions)

			local scripterSelectorTitle := optionsPanel.AddText("vScripterSelectorTitle x" languageSelectorX() " y" languageSelectorY(300 + 30) " w256 BackgroundTrans", Locale.Read("gui.options.UI.scripter.selector"))

			local ssMaxItemsPerPage := Cfg.Get("Scripter_Selector_Max_Items", "UI", 24, "int")
			local ssMaxColumns := Cfg.Get("Scripter_Selector_Max_Columns", "UI", 4, "int")
			local ssMaxColumnsThreshold := Cfg.Get("Scripter_Selector_Max_Columns_Threshold", "UI", 24, "int")
			local ssUseNumberKeys := Cfg.Get("Scripter_Selector_Use_Number_Keys", "UI", False, "bool")

			; Max Items
			local ssMaxItemsEdit := optionsPanel.AddEdit("vScripterSelectorMaxItemsEdit Number -VScroll -HScroll x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + 18))
			local ssMaxItemsUpDown := optionsPanel.AddUpDown("vScripterSelectorMaxItemsUpDown Range1-47", ssMaxItemsPerPage)
			ssMaxItemsEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Scripter_Selector_Max_Items", "UI", "int"))
			local ssMaxItemsTitle := optionsPanel.AddText("vScripterSelectorMaxItemsTitle x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + 20) " w256 BackgroundTrans", Locale.Read("gui.options.UI.scripter.selector.max_items"))

			; Columns
			local ssColumnsEdit := optionsPanel.AddEdit("vScripterSelectorMaxColumnsEdit Number -VScroll -HScroll x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + 18 + 28))
			local ssColumnsUpDown := optionsPanel.AddUpDown("vScripterSelectorMaxColumnsUpDown Range4-12", ssMaxColumns)
			ssColumnsEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Scripter_Selector_Max_Columns", "UI", "int"))
			local ssColumnsTitle := optionsPanel.AddText("vScripterSelectorMaxColumnsTitle x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + 20 + 28) " w256 BackgroundTrans", Locale.Read("gui.options.UI.scripter.selector.max_columns"))

			; Columns Threshold
			local ssThresholdEdit := optionsPanel.AddEdit("vScripterSelectorMaxColumnsThresholdEdit Number -VScroll -HScroll x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + 18 + 56))
			local ssThresholdUpDown := optionsPanel.AddUpDown("vScripterSelectorMaxColumnsThresholdUpDown Range1-47", ssMaxColumnsThreshold)
			ssThresholdEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Scripter_Selector_Max_Columns_Threshold", "UI", "int"))
			local ssThresholdTitle := optionsPanel.AddText("vScripterSelectorMaxColumnsThresholdTitle x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + 20 + 56) " w256 BackgroundTrans", Locale.Read("gui.options.UI.scripter.selector.max_columns_threshold"))

			; Use Number Keys
			local ssUseNumberKeysCheckBox := optionsPanel.AddCheckBox("vScripterSelectorUseNumberKeysCheckbox x" languageSelectorX() " y" languageSelectorY(300 + 30 + 18 + 84) " w320", Locale.Read("gui.options.UI.scripter.selector.use_number_keys"))
			ssUseNumberKeysCheckBox.Value := ssUseNumberKeys
			ssUseNumberKeysCheckBox.OnEvent("Click", (CB, Zero) => Cfg.Set(CB.Value, "Scripter_Selector_Use_Number_Keys", "UI", "bool"))

			optionsTabs.UseTab(tabComposeOptions)

			local composeTitle := optionsPanel.AddText("vComposeTitle x" languageSelectorX() " y" languageSelectorY(300 + 30) " w256 BackgroundTrans", Locale.Read("gui.options.compose.title"))

			local composeShowSuggestionsCheckBox := optionsPanel.AddCheckBox("vComposeShowSuggestionsCheckbox x" languageSelectorX() " y" languageSelectorY(300 + 30 + 18) " w200", Locale.Read("gui.options.compose.show_suggestions"))
			composeShowSuggestionsCheckBox.Value := Cfg.Get("Show_Suggestions", "Compose", True, "bool")
			composeShowSuggestionsCheckBox.OnEvent("Click", (CB, Zero) => Cfg.Set(CB.Value, "Show_Suggestions", "Compose", "bool"))

			local composeShowFavoritesCheckBox := optionsPanel.AddCheckBox("vComposeShowFavoritesCheckbox x" languageSelectorX() " y" languageSelectorY(300 + 30 + (18 * 2)) " w200", Locale.Read("gui.options.compose.show_favorites"))
			composeShowFavoritesCheckBox.Value := Cfg.Get("Show_Favorites", "Compose", True, "bool")
			composeShowFavoritesCheckBox.OnEvent("Click", (CB, Zero) => Cfg.Set(CB.Value, "Show_Favorites", "Compose", "bool"))

			local composeFontSizeEdit := optionsPanel.AddEdit("vComposeFontSizeEdit Number -VScroll -HScroll x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + (18 * 3) + 3))
			local composeFontSizeUpDown := optionsPanel.AddUpDown("vComposeFontSizeUpDown Range8-96", Cfg.Get("Font_Size", "Compose", 12, "int"))
			composeFontSizeEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Font_Size", "Compose", "int"))
			local composeFontSizeTitle := optionsPanel.AddText("vComposeFontSizeTitle x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + (18 * 3) + 5) " w256 BackgroundTrans", Locale.Read("gui.options.compose.font_size"))

			local composeFontNameEdit := optionsPanel.AddEdit("vComposeFontNameEdit x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + (18 * 4) + 10 + 3))
			composeFontNameEdit.Value := Cfg.Get("Font_Name", "Compose", "Noto Sans")
			composeFontNameEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Font_Name", "Compose"))
			local composeFontNameTitle := optionsPanel.AddText("vComposeFontNameTitle x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + (18 * 4) + 10 + 5) " w256 BackgroundTrans", Locale.Read("gui.options.compose.font_name"))

			; Background Color
			local composeBackgroundColorEdit := optionsPanel.AddEdit("vComposeBackgroundColorEdit x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + (18 * 5) + 20 + 3))
			composeBackgroundColorEdit.Value := Cfg.Get("Background_Color", "Compose", "White")
			composeBackgroundColorEdit.OnEvent("Change", (CB, Zero) => ChangeSampleColor(composeBackgroundColorSample, CB.Value, "Background_Color"))

			local composeBackgroundColorSample := optionsPanel.AddProgress("vComposeBackgroundColorSample x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + (18 * 5) + 20 + 3.5) " w20 h20 BackgroundWhite +Border")
			composeBackgroundColorSample.Value := 100
			try
				composeBackgroundColorSample.Opt("c" composeBackgroundColorEdit.Value)

			local composeBackgroundColorTitle := optionsPanel.AddText("vComposeBackgroundColorTitle x" languageSelectorX(64 + 5 + 25) " y" languageSelectorY(300 + 30 + (18 * 5) + 20 + 5) " w256 BackgroundTrans", Locale.Read("gui.options.compose.background_color"))


			; Font Color
			local composeFontColorEdit := optionsPanel.AddEdit("vComposeFontColorEdit x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + (18 * 6) + 30 + 3))
			composeFontColorEdit.Value := Cfg.Get("Font_Color", "Compose", "Black")
			composeFontColorEdit.OnEvent("Change", (CB, Zero) => ChangeSampleColor(composeFontColorSample, CB.Value, "Font_Color"))

			local composeFontColorSample := optionsPanel.AddProgress("vComposeFontColorSample x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + (18 * 6) + 30 + 3.5) " w20 h20 BackgroundWhite +Border")
			composeFontColorSample.Value := 100
			try
				composeFontColorSample.Opt("c" composeFontColorEdit.Value)

			local composeFontColorTitle := optionsPanel.AddText("vComposeFontColorTitle x" languageSelectorX(64 + 5 + 25) " y" languageSelectorY(300 + 30 + (18 * 6) + 30 + 5) " w256 BackgroundTrans", Locale.Read("gui.options.compose.font_color"))


			;

			local composeMaxLineLengthEdit := optionsPanel.AddEdit("vComposeMaxLineLengthEdit Number -VScroll -HScroll x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + (18 * 7) + 40 + 3))
			local composeMaxLineLengthUpDown := optionsPanel.AddUpDown("vComposeMaxLineLengthUpDown Range32-512", Cfg.Get("Suggestions_Line_Max_Length", "Compose", 80, "int"))
			composeMaxLineLengthEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Suggestions_Line_Max_Length", "Compose", "int"))
			local composeMaxLineLengthTitle := optionsPanel.AddText("vComposeMaxLineLengthTitle x" languageSelectorX(64 + 5) " y" languageSelectorY(300 + 30 + (18 * 7) + 40 + 5) " w256 BackgroundTrans", Locale.Read("gui.options.compose.max_line_length"))

			local composeMaxLimiterEdit := optionsPanel.AddEdit("vComposeMaxLimiterEdit Number -VScroll -HScroll x" languageSelectorX() " w64 h20 y" languageSelectorY(300 + 30 + (18 * 8) + 50 + 3))
			local composeMaxLimiterUpDown := optionsPanel.AddUpDown("vComposeMaxLimiterUpDown Range32-512", Cfg.Get("Suggestions_Limiter", "Compose", 80, "int"))
			composeMaxLimiterEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Suggestions_Limiter", "Compose", "int"))
			local composeMaxLimiterMultiplierMark := optionsPanel.AddText("vComposeMaxLimiterMultiplierMark x" languageSelectorX(64 + 2.5) " y" languageSelectorY(300 + 30 + (18 * 8) + 50 + 5) " w16 BackgroundTrans Center", Chr(0x00D7))

			local caomposeMaxLimiterMultiplierEdit := optionsPanel.AddEdit("vComposeMaxLimiterMultiplierEdit Number -VScroll -HScroll x" languageSelectorX(64 + 5 + 16) " w32 h20 y" languageSelectorY(300 + 30 + (18 * 8) + 50 + 3))
			local composeMaxLimiterMultiplierUpDown := optionsPanel.AddUpDown("vComposeMaxLimiterMultiplierUpDown Range1-96", Cfg.Get("Suggestions_Limiter_Multiplier", "Compose", 2, "int"))
			caomposeMaxLimiterMultiplierEdit.OnEvent("Change", (CB, Zero) => Cfg.Set(CB.Value, "Suggestions_Limiter_Multiplier", "Compose", "int"))

			local composeMaxLimiterTitle := optionsPanel.AddText("vComposeMaxLimiterTitle x" languageSelectorX(64 + 5 + 16 + 38) " y" languageSelectorY(300 + 30 + (18 * 8) + 50 + 5) " w256 BackgroundTrans", Locale.Read("gui.options.compose.max_length"))


			; Right col

			local composeShowAltRecipesCheckBox := optionsPanel.AddCheckBox("vComposeShowAltRecipesCheckbox x" languageSelectorX(210) " y" languageSelectorY(300 + 30 + 18) " w200", Locale.Read("gui.options.compose.show_alt_recipes"))
			composeShowAltRecipesCheckBox.Value := Cfg.Get("Show_Alt_Recipes", "Compose", True, "bool")
			composeShowAltRecipesCheckBox.OnEvent("Click", (CB, Zero) => Cfg.Set(CB.Value, "Show_Alt_Recipes", "Compose", "bool"))


			optionsTabs.UseTab()


			local resourcesTabLabels := [
				Locale.Read("gui.options.resources")
			]

			local resourcesTabs := optionsPanel.AddTab3("vResourcesTabs " optionsCommon(100, (optionsCommonY + optionsCommonH + 250) + (84 + 25), 3), resourcesTabLabels)

			resourcesTabs.UseTab(resourcesTabLabels[1])

			local resourcesUrls := JSON.LoadFile(App.PATHS.DATA "\settings_resources_urls.json", "UTF-8")

			local layoutsWikiLabel := optionsPanel.AddLink("x" languageSelectorX() " y" languageSelectorY((205) + 300 + 30 + 20 + 28) " w" defaultSizes.groupBoxW - 10 " h80", resourcesUrls.ToString(Chr(0x2003)))

			resourcesTabs.UseTab()

			optionsPanel.AddGroupBox(optionsCommon(55, (windowHeight - 65)))

			local iniFilesY := windowHeight - 50
			local iniFilesX := (add := 0, reverse := False) => reverse ? (defaultSizes.groupBoxW - 27 - add) : (25 + add)

			local recipesPanelBtn := optionsPanel.AddButton("x" iniFilesX() " y" iniFilesY " w32 h32")
			recipesPanelBtn.OnEvent("Click", (*) => globalInstances.MyRecipesGUI.Show())
			GuiButtonIcon(recipesPanelBtn, App.ICONS_DLL, App.indexIcos["my_recipes_flat"])

			local configFileBtn := optionsPanel.AddButton("x" iniFilesX(32) " y" iniFilesY " w32 h32")
			configFileBtn.OnEvent("Click", (*) => Cfg.OpenFile())
			GuiButtonIcon(configFileBtn, ImageRes, 065)

			local localesFileBtn := optionsPanel.AddButton("x" iniFilesX(32 * 2) " y" iniFilesY " w32 h32")
			localesFileBtn.OnEvent("Click", (*) => Locale.OpenDir())
			GuiButtonIcon(localesFileBtn, ImageRes, 015)


			local openFolderBtn := optionsPanel.AddButton("x" iniFilesX(, True) " y" iniFilesY " w32 h32")
			openFolderBtn.OnEvent("Click", (*) => Run(A_ScriptDir))
			GuiButtonIcon(openFolderBtn, ImageRes, 180)


			local autoloadBtn := optionsPanel.AddButton("vAutoload x" (windowWidth - 150) / 2 " y" iniFilesY " w150 h32", Locale.Read("gui.options.system_startup.add"))
			autoloadBtn.OnEvent("Click", (*) => Options.SetAutoload())

			optionsPanel.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)
			return optionsPanel

			SetProfile(profileName) {
				if profileName = Locale.Read("profile.new") {
					IB := InputBox(Locale.Read("profile.new_name"), Locale.Read("profile.creation"), "w256 h92")
					if IB.Result = "Cancel" || IB.Value = "" {
						this.EditorGUI["Profile"].Text := App.GetProfile()
						return
					}

					profileName := IB.Value
					App.SetProfile(profileName)
				} else {
					App.SetProfile(profileName)
				}
			}

			SetRemapping(remapping) {
				if remapping {
					MB := MsgBox(Locale.Read("gui.options.remapping.description"), App.Title(), "YesNo")
					if MB = "No" || MB = "Cancel" {
						this.EditorGUI["LayoutRemapping"].Value := False
						return
					}
				}
				Cfg.Set(remapping, "Layout_Remapping", , "bool")
				KbdBinder.RebuildBinds()
			}

			ChangeSampleColor(guiControl, color, option) {
				try {
					guiControl.Opt("c" color)
					guiControl.Redraw()
					Cfg.Set(color, option, "Compose")
				}
				return
			}
		}


		if WinExist(this.optionsTitle) {
			WinActivate(this.optionsTitle)
		} else {
			this.EditorGUI := Constructor()
			this.EditorGUI.Show()
		}
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

		if this.Get("First_Message", , True, "bool") {
			MsgBox(Locale.Read("first_launch.message"), App.Title())
			this.Set("False", "First_Message")
		}
	}

	static BindedVars() {
		return [
			"FastKeysOn", this.Get("Mode_Fast_Keys", "Settings", False, "bool"),
			"FastKeysOver", this.Get("Mode_Fast_Keys_Over", "Settings", ""),
			"HTMLMode", this.Get("HTML_Mode", "Settings", "Decimal"),
			"LaTeXMode", this.Get("LaTeX_Mode", "Settings", "Text"),
		]
	}

	static Set(value, entry, section := "Settings", options := "", filePath := this.ini) {
		if this.sections.HasValue(section) {
			if InStr(options, "bool")
				value := (value = True || value = "True" || value = 1 || value = "1") ? "True" : "False"
			else
				this.OptionsHandler(value, options, &value)

			IniWrite(value, filePath, section, entry)
			if InStr(value, "_Over") {
				MsgBox(value)
			}

			this.BindedVarsHandler()
		} else {
			throw Error("Unknown config section: " section)
		}
	}

	static Get(entry, section := "Settings", default := "", options := "", filePath := this.ini) {
		if this.sections.HasValue(section) {
			value := IniRead(filePath, section, entry, default)
			value := value = "" ? default : value

			this.OptionsHandler(value, options, &value)
		} else {
			throw Error("Unknown config section: " section)
		}
		return value
	}

	static SwitchSet(valuesVariants, entry, section := "Settings", options := "", filePath := this.ini) {
		local currentValue := this.Get(entry, section)
		local found := False

		for i, value in valuesVariants {
			if (value = currentValue) {
				nextIndex := (i = valuesVariants.MaxIndex()) ? 1 : i + 1
				this.Set(valuesVariants[nextIndex], entry, section, options, filePath)
				found := True
				break
			}
		}

		if (!found) {
			this.Set(valuesVariants[1], entry, section, options, filePath)
		}
	}

	static SessionSet(value, entry) {
		this.sessionSettings.Set(value, entry)
		return
	}

	static SessionGet(entry) {
		return this.sessionSettings.Get(entry)
	}

	static SessionSwitchSet(valuesVariants, entry) {
		local currentValue := this.sessionSettings.Get(entry)
		local found := False

		for i, value in valuesVariants {
			if (value = currentValue) {
				nextIndex := (i = valuesVariants.MaxIndex()) ? 1 : i + 1
				this.sessionSettings.Set(entry, valuesVariants[nextIndex])
				found := True
				break
			}
		}

		if (!found) {
			this.sessionSettings.Set(entry, valuesVariants[1])
		}
	}

	static OptionsHandler(value, options := "", &output := value) {
		if value = ""
			return
		if InStr(options, "toHex")
			output := UnicodeUtils.GetCodePoint(value, "Hex4")
		if InStr(options, "fromHex")
			output := UnicodeUtils.GetSymbol(value)
		if InStr(options, "bool")
			output := (value = "True" || value = 1 || value = "1")
		if InStr(options, "int")
			output := Integer(value)
		if InStr(options, "num")
			output := Number(value)
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
		; local isLanguageWasChanged := False

		for key, value in Language.supported {
			if value["title"] = CB.Text {
				Cfg.Set(key, "User_Language")
				return Event.Trigger("UI Language", "Switched", value)
			}
		}

		; if !isLanguageWasChanged
		; 	return

		return
	}

	static SwitchVirualLayout(CB, category) {
		if category = "Cyrillic" {
			Cfg.Set(CB is String ? CB : CB.Text, "Layout_Cyrillic")
		} else if category = "Latin" {
			Cfg.Set(CB is String ? CB : CB.Text, "Layout_Latin")
		} else if category = "Hellenic" {
			Cfg.Set(CB is String ? CB : CB.Text, "Layout_Hellenic")
		} else {
			throw Error("Unknown layout category: " category)
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

		KbdBinder.RebuildBinds()
	}

	static SetLocalisedOption(title, options, entry) {
		for key, value in options.OwnProps()
			if value = title
				Cfg.Set(key, entry)
	}

	static SetAutoload() {
		currentScriptPath := A_ScriptDir "\DSLKeyPad.exe"
		autoloadFolder := A_StartMenu "\Programs\Startup"
		shortcutPath := autoloadFolder "\DSLKeyPad.lnk"

		if (FileExist(shortcutPath))
			FileDelete(shortcutPath)

		iconIndex := 0
		command := "powershell -command " "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut('" shortcutPath "'); $shortcut.TargetPath = '" currentScriptPath "'; $shortcut.WorkingDirectory = '" A_ScriptDir "'; $shortcut.IconLocation = '" App.ICONS_DLL "," iconIndex "'; $shortcut.Description = 'DSLKeyPad AutoHotkey Script'; $shortcut.Save()"
		RunWait(command, , "Hide")

		MsgBox(Locale.Read("gui.options.system_startup.shortcut_created_or_updated"), App.Title(), 0x40)
		return
	}

	static ToggleInputMode() {
		Cfg.SessionSwitchSet(["Unicode", "HTML", "LaTeX"], "Input_Mode")
		MsgBox(Locale.ReadInject("messages.input_mode_changed", [Locale.Read("messages.input_mode_changed_" StrLower(Cfg.SessionGet("Input_Mode")))]), App.Title(), 0x40)
		return Event.Trigger("Input Mode", "Changed", Cfg.SessionGet("Input_Mode"))
	}
}

>^F9:: Cfg.Editor()