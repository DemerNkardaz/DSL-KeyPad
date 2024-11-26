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

	static optionsTitle := App.title " — " App.versionText " — " ReadLocale("gui_options")

	static EditorGUI := Gui()

	static Editor() {
		this.optionsTitle := App.title " — " App.versionText " — " ReadLocale("gui_options")

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
			optionsCommon := (h := 300, y := optionsCommonY) => "x" defaultSizes.groupBoxX " y" y " w" defaultSizes.groupBoxW " h" h

			optionsPanel.AddGroupBox("vGroupCommon " optionsCommon(), ReadLocale("gui_options_common"))

			optionsLanguages := Map(
				"en", "English",
				"ru", "Русский",
			)
			languageSelectorY := optionsCommonY + 25
			languageSelectorX := 25
			languageSelectorTextY := languageSelectorY + 4
			languageSelectorTextX := languageSelectorX + 80

			optionsPanel.AddText("vLanguageLabel x" languageSelectorTextX " y" languageSelectorTextY " w80", ReadLocale("gui_options_language"))

			languageSelector := optionsPanel.AddDropDownList("vLanguage x" languageSelectorX " w74 y" languageSelectorY, [optionsLanguages["en"], optionsLanguages["ru"]])
			PostMessage(0x0153, -1, 15, languageSelector)

			languageSelector.Text := optionsLanguages[Language.Get()]
			languageSelector.OnEvent("Change", (CB, Zero) => Options.SwitchLanguage(CB))


			optionsPanel.AddGroupBox(optionsCommon(55, (windowHeight - 65)))

			iniFilesY := windowHeight - 50
			iniFilesX := (add := 0) => 25 + add

			configFileBtn := optionsPanel.Add("Button", "x" iniFilesX() " y" iniFilesY " w32 h32")
			configFileBtn.OnEvent("Click", (*) => OpenConfigFile())
			GuiButtonIcon(configFileBtn, ImageRes, 065)

			localesFileBtn := optionsPanel.Add("Button", "x" iniFilesX(32) " y" iniFilesY " w32 h32")
			localesFileBtn.OnEvent("Click", (*) => OpenLocalesFile())
			GuiButtonIcon(localesFileBtn, ImageRes, 015)

			optionsPanel.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)
			return optionsPanel
		}

		this.EditorGUI := Constructor()

		if IsGuiOpen(this.optionsTitle) {
			WinActivate(this.optionsTitle)
		} else {
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
	static SwitchLanguage(language) {
		locales := Map(
			"en", ["English", "Английский"],
			"ru", ["Russian", "Русский"],
		)

		for key, value in locales {
			if value.HasValue(language.Text) || key = language.Text {
				Cfg.Set(key, "User_Language")
				break
			}
		}

		pastOptionsTitle := Cfg.optionsTitle
		Cfg.optionsTitle := App.title " — " App.versionText " — " ReadLocale("gui_options")

		if IsGuiOpen(pastOptionsTitle) {
			Cfg.EditorGUI.Title := Cfg.optionsTitle
			Cfg.EditorGUI["GroupCommon"].Text := ReadLocale("gui_options_common")
			Cfg.EditorGUI["LanguageLabel"].Text := ReadLocale("gui_options_language")
		}
		ManageTrayItems()
	}
}

>^F9:: Cfg.Editor()