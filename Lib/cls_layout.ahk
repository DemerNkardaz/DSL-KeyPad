Class KeyboardBinder {

	static layouts := {
		winDefault: Map(
			"Space", "SC039",
			"Tab", "SC00F",
			"Numpad0", "SC052",
			"Numpad1", "SC04F",
			"Numpad2", "SC050",
			"Numpad3", "SC051",
			"Numpad4", "SC04B",
			"Numpad5", "SC04C",
			"Numpad6", "SC04D",
			"Numpad7", "SC047",
			"Numpad8", "SC048",
			"Numpad9", "SC049",
			"NumpadMult", "SC037",
			"NumpadAdd", "SC04E",
			"NumpadSub", "SC04A",
			"NumpadDot", "SC053",
			"NumpadDiv", "SC135",
			"NumpadEnter", "SC11C",
			"PgUp", "SC149",
			"PgDn", "SC151",
			"End", "SC14F",
			"Home", "SC147",
			"Ins", "SC152",
			"Del", "SC153",
			"Shift", "SC02A",
			"Ctrl", "SC01D",
			"Alt", "SC038",
			"LShift", "SC02A",
			"RShift", "SC036",
			"LCtrl", "SC01D",
			"RCtrl", "SC11D",
			"RAlt", "SC138",
			"Backspace", "SC00E",
			"Enter", "SC01C",
			"ArrLeft", "SC14B",
			"ArrUp", "SC148",
			"ArrRight", "SC14D",
			"ArrDown", "SC150",
			"F1", "SC03B",
			"F2", "SC03C",
			"F3", "SC03D",
			"F4", "SC03E",
			"F5", "SC03F",
			"F6", "SC040",
			"F7", "SC041",
			"F8", "SC042",
			"F9", "SC043",
			"F10", "SC044",
			"F11", "SC057",
			"F12", "SC058",
			;
			"0", "SC00B",
			"1", "SC002",
			"2", "SC003",
			"3", "SC004",
			"4", "SC005",
			"5", "SC006",
			"6", "SC007",
			"7", "SC008",
			"8", "SC009",
			"9", "SC00A",
		),
		latin: Map(
			"QWERTY", Map(
				"Semicolon", "SC027",
				"Apostrophe", "SC028",
				"LSquareBracket", "SC01A",
				"RSquareBracket", "SC01B",
				"Tilde", "SC029",
				"Minus", "SC00C",
				"Equals", "SC00D",
				"Comma", "SC033",
				"Dot", "SC034",
				"Slash", "SC035",
				"Backslash", "SC02B",
				"A", "SC01E",
				"B", "SC030",
				"C", "SC02E",
				"D", "SC020",
				"E", "SC012",
				"F", "SC021",
				"G", "SC022",
				"H", "SC023",
				"I", "SC017",
				"J", "SC024",
				"K", "SC025",
				"L", "SC026",
				"M", "SC032",
				"N", "SC031",
				"O", "SC018",
				"P", "SC019",
				"Q", "SC010",
				"R", "SC013",
				"S", "SC01F",
				"T", "SC014",
				"U", "SC016",
				"V", "SC02F",
				"W", "SC011",
				"X", "SC02D",
				"Y", "SC015",
				"Z", "SC02C",
			),
			"Dvorak", Map(
				"Semicolon", "SC02C",
				"Apostrophe", "SC010",
				"LSquareBracket", "SC00C",
				"RSquareBracket", "SC00D",
				"Tilde", "SC029",
				"Minus", "SC028",
				"Equals", "SC01B",
				"Comma", "SC011",
				"Dot", "SC012",
				"Slash", "SC01A",
				"Backslash", "SC02B",
				"A", "SC01E",
				"B", "SC031",
				"C", "SC017",
				"D", "SC023",
				"E", "SC020",
				"F", "SC015",
				"G", "SC016",
				"H", "SC024",
				"I", "SC022",
				"J", "SC02E",
				"K", "SC02F",
				"L", "SC019",
				"M", "SC032",
				"N", "SC026",
				"O", "SC01F",
				"P", "SC013",
				"Q", "SC02D",
				"R", "SC018",
				"S", "SC027",
				"T", "SC025",
				"U", "SC021",
				"V", "SC034",
				"W", "SC033",
				"X", "SC030",
				"Y", "SC014",
				"Z", "SC035",
			),
			"Colemak", Map(
				"Semicolon", "SC019",
				"Apostrophe", "SC028",
				"LSquareBracket", "SC01A",
				"RSquareBracket", "SC01B",
				"Tilde", "SC029",
				"Hyphen-minus", "SC00C",
				"Equals", "SC00D",
				"Comma", "SC033",
				"Dot", "SC034",
				"Slash", "SC035",
				"Backslash", "SC02B",
				"A", "SC01E",
				"B", "SC030",
				"C", "SC02E",
				"D", "SC022",
				"E", "SC025",
				"F", "SC012",
				"G", "SC014",
				"H", "SC023",
				"I", "SC026",
				"J", "SC015",
				"K", "SC031",
				"L", "SC016",
				"M", "SC032",
				"N", "SC024",
				"O", "SC027",
				"P", "SC013",
				"Q", "SC010",
				"R", "SC01F",
				"S", "SC020",
				"T", "SC021",
				"U", "SC017",
				"V", "SC02F",
				"W", "SC011",
				"X", "SC02D",
				"Y", "SC018",
				"Z", "SC02C",
			),
		),
		cyrillic: Map(
			"ЙЦУКЕН", Map(
				"Ж", "SC027",
				"Э", "SC028",
				"Х", "SC01A",
				"Ъ", "SC01B",
				"Ё", "SC029",
				"Минус", "SC00C",
				"Равно", "SC00D",
				"Б", "SC033",
				"Ю", "SC034",
				"Точка", "SC035",
				"Обратный слэш", "SC02B",
				"Ф", "SC01E",
				"И", "SC030",
				"С", "SC02E",
				"В", "SC020",
				"У", "SC012",
				"А", "SC021",
				"П", "SC022",
				"Р", "SC023",
				"Ш", "SC017",
				"О", "SC024",
				"Л", "SC025",
				"Д", "SC026",
				"Ь", "SC032",
				"Т", "SC031",
				"Щ", "SC018",
				"З", "SC019",
				"Й", "SC010",
				"К", "SC013",
				"Ы", "SC01F",
				"Е", "SC014",
				"Г", "SC016",
				"М", "SC02F",
				"Ц", "SC011",
				"Ч", "SC02D",
				"Н", "SC015",
				"Я", "SC02C",
			),
			"Диктор", Map(),
			"ЙІУКЕН (1907)", Map(),
		),
	}

	static modifiers := [
		"!", "<!", ">!",
		"+", "<+", ">+",
		"^", "<^", ">^",
		"#", "<#", ">#",
		"^!", "<^>!", ">^>!", "<^<!", ">^<!",
		"^+", "<^>+", ">^>+", "<^<+", ">^<+",
		"^#", "<^>#", ">^>#", "<^<#", ">^<#",
		"<^>^", ">^<^", "<^<^", ">^<^",
		"<+>+", ">+<+", "<+<+", ">+<+",
		"^!+", "<^>!+", ">^>!+", "<^<!+", ">^<!+",
		"<^>!<+", ">^>!<+", "<^<!<+", ">^<!<+",
		"<^>!>+", ">^>!>+", "<^<!>+", ">^<!>+",
		"<^>!<+>+", ">^>!<+>+", "<^<!<+>+", ">^<!<+>+",
		"<^>!<!<+", ">^>!<!<+", "<^<!<!<+", ">^<!<!<+",
		"<^>!<!>+", ">^>!<!>+", "<^<!<!>+", ">^<!<!>+",
		"<^>!<!<+>+", ">^>!<!<+>+", "<^<!<!<+>+", ">^<!<!<+>+",
	]


	static __New() {
		this.Registration(importantBindsMap.mapping, True)
		this.Registration(defaultBinds.mapping, Cfg.FastKeysOn)

	}

	static GetCurrentLayoutMap() {
		layout := Map()
		latinLayout := Cfg.Get("Layout_Latin")
		cyrillicLayout := Cfg.Get("Layout_Cyrillic")

		latinLayout := KeyboardBinder.layouts.latin.Has(latinLayout) ? latinLayout : "QWERTY"
		cyrillicLayout := KeyboardBinder.layouts.cyrillic.Has(cyrillicLayout) ? cyrillicLayout : "ЙЦУКЕН"

		latinLayout := KeyboardBinder.layouts.latin[latinLayout]
		cyrillicLayout := KeyboardBinder.layouts.cyrillic[cyrillicLayout]


		for key, scanCode in KeyboardBinder.layouts.winDefault {
			layout[scanCode] := [key]
		}

		for keySet in [latinLayout, cyrillicLayout] {
			for key, scanCode in keySet {
				if !layout.Has(scanCode) {
					layout[scanCode] := [key]
				} else {
					layout[scanCode].Push(key)
				}
			}
		}
		return layout
	}

	static CompileBinds(bindingsMap := Map()) {
		bindings := this.FormatBindings(bindingsMap)
		processed := Map()

		for combo, value in bindings {
			this.CompileBridge(combo, value, processed)
		}

		return processed
	}

	static CompileBridge(combo, bind, targetMap) {
		if bind.Length == 1 && Util.IsString(bind[1]) {
			targetMap.Set(combo, (K) => BindHandler.Send(K, bind[1]))
		} else if (bind.Length = 1 && Util.IsArray(bind[1])) ||
			(bind.Length == 2 Util.IsArray(bind[1]) && Util.IsBool(bind[2])) {
			reverse := bind.Length == 2 ? bind[2] : False
			targetMap.Set(combo, (K) => BindHandler.CapsSend(K, bind[1], reverse))
		} else if bind.Length >= 2 {
			reverse := bind.Length == 3 ? bind[3] : { en: False, ru: False }
			targetMap.Set(combo, (K) => BindHandler.LangSend(K, { en: bind[1], ru: bind[2], }, reverse))
		} else if Util.IsFunc(bind[1]) {
			targetMap.Set(combo, bind[1])
		} else {
			valueStr := (Util.IsArray(bind) && !Util.IsFunc(bind[1])) ? bind.ToString() : (Util.IsFunc(bind[1]) ? "<Function>" : "<Unknown>")
			MsgBox("Invalid binding format for combo: " combo " with value: " valueStr)
		}
	}

	static FormatBindings(bindingsMap := Map()) {
		layout := this.GetCurrentLayoutMap()
		output := Map()

		if bindingsMap.Count > 0 {
			for combo, binds in bindingsMap {
				for scanCode, keyNamesArray in layout {
					if RegExMatch(combo, "(?:\[(?<modKey>[a-zA-Zа-яА-ЯёЁ0-9]+)\]|(?<key>[a-zA-Zа-яА-ЯёЁ0-9]+))", &match) {
						keyLetter := match["modKey"] != "" ? match["modKey"] : match["key"]
						if keyNamesArray.HasValue(keyLetter) {
							rules := Map(
								"Caps", [binds],
								"Lang", [binds, ["", ""]],
							)

							ruledBinds := rules["Lang"]
							rule := "Lang"
							if RegExMatch(combo, "\:(.*?)$", &ruleMatch) && rules.Has(ruleMatch[1]) {
								ruledBinds := rules[ruleMatch[1]]
								rule := ruleMatch[1]
							}

							interCombo := RegExReplace(combo, keyLetter, scanCode)
							interCombo := RegExReplace(interCombo, "\[(.*?)\]", "$1")
							interCombo := RegExReplace(interCombo, "\:(.*?)$", "")
							if !output.Has(interCombo) {
								output.Set(interCombo, Util.IsString(binds) || Util.IsFunc(binds) ? [binds] : ruledBinds)
							} else {
								if rule = "Lang"
									output[interCombo].RemoveAt(2)
								output[interCombo].Push(binds)
							}
						}
					}
				}
			}
		}

		return output
	}

	static Registration(bindingsMap := Map(), rule := True) {
		bindingsMap := this.CompileBinds(bindingsMap)

		if bindingsMap.Count > 0 {
			for combo, action in bindingsMap {
				try {
					HotKey(combo, action, rule ? "On" : "Off")
				} catch {
					MsgBox("Failed to register HotKey: " combo)
				}
			}
		}
	}

	static UnregisterAll() {
		layout := this.GetCurrentLayoutMap()

		for scanCode, keyNamesArray in layout {
			HotKey(scanCode, (*) => False, "Off")

			for modifier in this.modifiers {
				HotKey(modifier scanCode, (*) => False, "Off")
			}
		}
	}

	static ToggleDefaultMode() {
		this.UnregisterAll()

		modeActive := Cfg.Get("Mode_Fast_Keys", , False, "bool")
		Cfg.Set(modeActive, "Mode_Fast_Keys", , "bool")

		MsgBox(Locale.Read("message_fastkeys_" (!modeActive ? "de" : "") "activated"), "FastKeys", 0x40)


		this.Registration(importantBindsMap.mapping, True)
		this.Registration(defaultBinds.mapping, Cfg.FastKeysOn)

	}
}

Class BindHandler {

	static Send(combo := "", characterNames*) {
		Keyboard.CheckLayout(&lang)
		if Language.Validate(lang, "bindings") {
			output := ""

			for _, character in characterNames {
				if ChrLib.entries.HasOwnProp(character) {
					output .= ChrLib.Get(character, True, Cfg.Get("Input_Mode"))
				} else {
					output .= GetCharacterSequence(character)
				}
			}

			keysValidation := "SC(14B|148|14D|150|04A)"
			chrValidation := "(" Chr(0x00AE) ")"

			InputType := (RegExMatch(combo, keysValidation) || RegExMatch(output, chrValidation) || Cfg.Get("Input_Mode") != "Unicode") ? "Text" : "Input"

			Send%inputType%(output)
		}
	}

	static CapsSend(combo := "", charactersPair := [], reverse := False) {
		capsOn := reverse ? !GetKeyState("CapsLock", "T") : GetKeyState("CapsLock", "T")
		this.Send(combo, charactersPair[capsOn ? 1 : 2])
	}

	static LangSend(combo := "", charactersObj := { en: "", ru: "" }, reverse := { ru: False, en: False }) {
		Keyboard.CheckLayout(&lang)

		if Language.Validate(lang, "bindings") {
			if charactersObj.HasOwnProp(lang) {
				if Util.IsArray(charactersObj.%lang%) {
					this.CapsSend(combo, charactersObj.%lang%, reverse.%lang%)
				} else {
					this.Send(combo, charactersObj)
				}
			}
		}
	}
}


;*	Реализовать возможность создавать кастомные раскладки через создание .ini файлов в «Layouts\» директории
;*	[Setup]
;*	Title=Тестовая раскладка
;*	Type=Cyrillic
;*	[Keys]
;*	А=SC016
;*	Ф=SC02C
;*	...
