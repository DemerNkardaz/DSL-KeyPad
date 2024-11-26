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