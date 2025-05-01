Class LayoutList {
	default := Map(
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
		"Left", "SC14B",
		"Up", "SC148",
		"Right", "SC14D",
		"Down", "SC150",
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
	)
	latin := Map(
		"Semicolon", "SC027",
		"Apostrophe", "SC028",
		"LeftBracket", "SC01A",
		"RightBracket", "SC01B",
		"Tilde", "SC029",
		"HyphenMinus", "SC00C",
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
	)
	cyrillic := Map(
		"Ж", "SC027",
		"Э", "SC028",
		"Х", "SC01A",
		"Ъ", "SC01B",
		"Ё", "SC029",
		"ДефисоМинус", "SC00C",
		"Равно", "SC00D",
		"Б", "SC033",
		"Ю", "SC034",
		"Точка", "SC035",
		"ОбратныйСлэш", "SC02B",
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
		"І", "",
		"Ѣ", "",
	)
	layout := Map()

	__New(base, input := Map()) {
		this.layout := Map()

		for key, scanCode in this.default {
			this.layout.Set(key, scanCode)
		}

		for key, scanCode in this.%base% {
			this.layout.Set(key, scanCode)
		}

		if input.Count > 0 {
			for key, scanCode in input {
				for subKey, subScanCode in this.layout {
					if subScanCode = scanCode {
						this.layout.Delete(subKey)
					}
				}
				this.layout.Set(key, scanCode)
			}
		}

		return this
	}
}

Class KeyboardBinder {
	static layouts := {
		latin: Map(
			"QWERTY", LayoutList("latin"),
			"Dvorak", LayoutList("latin", Map(
				"Semicolon", "SC02C",
				"Apostrophe", "SC010",
				"Left_Bracket", "SC00C",
				"Right_Bracket", "SC00D",
				"Tilde", "SC029",
				"HyphenMinus", "SC028",
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
			)),
			"Colemak", LayoutList("latin", Map(
				"Semicolon", "SC019",
				"Apostrophe", "SC028",
				"Left_Bracket", "SC01A",
				"Right_Bracket", "SC01B",
				"Tilde", "SC029",
				"HyphenMinus", "SC00C",
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
			)),
		),
		cyrillic: Map(
			"ЙЦУКЕН", LayoutList("cyrillic"),
			"Диктор", LayoutList("cyrillic", Map(
				"Р", "SC027",
				"Й", "SC028",
				"Ш", "SC01A",
				"Щ", "SC01B",
				"Ё", "SC029",
				"ДефисоМинус", "SC00C",
				"Равно", "SC00D",
				"П", "SC033",
				"Г", "SC034",
				"Ж", "SC035",
				"ОбратныйСлэш", "SC02B",
				"У", "SC01E",
				"Ю", "SC030",
				"Х", "SC02E",
				"Е", "SC020",
				"Я", "SC012",
				"О", "SC021",
				"А", "SC022",
				"Л", "SC023",
				"К", "SC017",
				"Н", "SC024",
				"Т", "SC025",
				"С", "SC026",
				"М", "SC032",
				"Б", "SC031",
				"Д", "SC018",
				"Ч", "SC019",
				"Ц", "SC010",
				"Запятая", "SC013",
				"И", "SC01F",
				"Точка", "SC014",
				"В", "SC016",
				"Ы", "SC02F",
				"Ь", "SC011",
				"Э", "SC02D",
				"З", "SC015",
				"Ф", "SC02C",
			)),
			"ЙІУКЕН (1907)", LayoutList("cyrillic", Map(
				"Ж", "SC028",
				"Э", "SC00D",
				"Х", "SC01A",
				"Ъ", "SC021",
				"Ё", "SC029",
				"ДефисоМинус", "SC01B",
				"Равно", "SC02B",
				"Б", "SC034",
				"Ю", "SC035",
				"Точка", "",
				"ОбратныйСлэш", "",
				"Ф", "SC01E",
				"И", "SC031",
				"С", "SC02F",
				"В", "SC020",
				"У", "SC012",
				"А", "SC022",
				"П", "SC023",
				"Р", "SC024",
				"Ш", "SC017",
				"О", "SC025",
				"Л", "SC026",
				"Д", "SC027",
				"Ь", "SC033",
				"Т", "SC032",
				"Щ", "SC018",
				"З", "SC019",
				"Й", "SC010",
				"К", "SC013",
				"Ы", "SC01F",
				"Е", "SC014",
				"Г", "SC016",
				"М", "SC030",
				"Ц", "SC00C",
				"Ч", "SC02D",
				"Н", "SC015",
				"Я", "SC02C",
				"І", "SC011",
				"Ѣ", "SC02E",
			)),
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
		"<#<!", "<#>!",
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

	static autoimport := {
		layouts: App.paths.profile "\CustomLayouts",
		binds: App.paths.profile "\CustomBindings",
	}

	static disabledByMonitor := False
	static disabledByUser := False
	static ligaturedBinds := False
	static numStyle := ""
	static userLayoutsNames := []
	static userBindings := []

	static __New() {
		this.Init()
		SetTimer((*) => SetTimer((*) => this.Monitor(), 2000), -10000)
	}

	static Init() {
		for key, path in this.autoimport.OwnProps() {
			if !DirExist(path)
				DirCreate(path)
		}

		this.UserLayouts()
		this.UserBinds()
		this.RebuilBinds()
	}

	static Monitor() {
		isLanguageLayoutValid := Language.Validate(Keyboard.CurrentLayout(), "bindings")
		disableTimer := Cfg.Get("Binds_Autodisable_Timer", , 1, "int")
		disableType := Cfg.Get("Binds_Autodisable_Type", , "hour")
		try {
			disableType := %disableType%
		} catch {
			disableType := hour
		}

		if !this.disabledByUser
			this.MonitorToggler(isLanguageLayoutValid && A_TimeIdle <= disableTimer * disableType)
	}

	static MonitorToggler(enable := True, rule := "Monitor", addRule := "User") {
		if enable && !this.disabledBy%addRule% {
			if this.disabledBy%rule% {
				this.disabledBy%rule% := False
				this.RebuilBinds()
			}
		} else if !this.disabledBy%rule% && !this.disabledBy%addRule% {
			this.disabledBy%rule% := True
			this.UnregisterAll()
		}

		ManageTrayItems()
	}

	static SetLayout(layout) {
		layoutType := this.layouts.latin.Has(layout) ? "Latin" : this.layouts.cyrillic.Has(layout) ? "Cyrillic" : ""

		if StrLen(layoutType) > 0 {
			Cfg.Set(layout, "Layout_" layoutType)
			this.RebuilBinds()
		} else {
			MsgBox("Wrong layout: " layout)
		}
	}

	static SwitchLayout(scriptType := "Latin") {
		scriptType := StrLower(scriptType)
		nextLayout := False

		if this.layouts.HasOwnProp(scriptType) {
			keys := this.layouts.%scriptType%.Keys()
			current := Cfg.Get("Layout_" scriptType)

			Loop keys.Length {
				if keys[A_Index] == current {
					nextLayout := keys[A_Index + 1 > keys.Length ? 1 : A_Index + 1]
					break
				}
			}
			if nextLayout
				this.SetLayout(nextLayout)
		} else {
			MsgBox("Wrong script type: " scriptType)
		}
	}

	static CurrentLayouts(&latin?, &cyrillic?) {
		latin := Cfg.Get("Layout_Latin")
		cyrillic := Cfg.Get("Layout_Cyrillic")
	}

	static GetCurrentLayoutMap() {
		layout := Map()
		this.CurrentLayouts(&latinLayout, &cyrillicLayout)

		latinLayout := KeyboardBinder.layouts.latin.Has(latinLayout) ? latinLayout : "QWERTY"
		cyrillicLayout := KeyboardBinder.layouts.cyrillic.Has(cyrillicLayout) ? cyrillicLayout : "ЙЦУКЕН"

		latinLayout := KeyboardBinder.layouts.latin[latinLayout]
		cyrillicLayout := KeyboardBinder.layouts.cyrillic[cyrillicLayout]

		for keySet in [latinLayout, cyrillicLayout] {
			for key, scanCode in keySet.layout {
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
		if bind.Length == 1 && bind[1] is String {
			targetMap.Set(combo, (K) => BindHandler.Send(K, bind[1]))
		} else if (bind.Length = 1 && bind[1] is Array) ||
			(bind.Length == 2 && bind[1] is Array && Util.IsBool(bind[2])) {
			reverse := bind.Length == 2 ? bind[2] : False
			targetMap.Set(combo, (K) => BindHandler.CapsSend(K, bind[1], reverse))
		} else if bind.Length >= 2 {
			reverse := bind.Length == 3 ? bind[3] : { en: False, ru: False }
			targetMap.Set(combo, (K) => BindHandler.LangSend(K, { en: bind[1], ru: bind[2], }, reverse))
		} else if bind[1] is Func {
			targetMap.Set(combo, bind[1])
		} else {
			valueStr := (bind is Array && !(bind[1] is Func)) ? bind.ToString() : (bind[1] is Func ? "<Function>" : "<Unknown>")
			MsgBox("Invalid binding format for combo: " combo " with value: " valueStr)
		}
	}

	static FormatBindings(bindingsMap := Map()) {
		static matchRu := "(?!.*[a-zA-Z])[а-яА-ЯёЁѣѢіІ]+"
		static matchEn := "(?!.*[а-яА-ЯёЁѣѢіІ])[a-zA-Z]+"
		layout := this.GetCurrentLayoutMap()
		output := Map()

		if bindingsMap.Count > 0 {
			for combo, binds in bindingsMap {
				for scanCode, keyNamesArray in layout {
					if RegExMatch(combo, "(?:\[(?<modKey>[a-zA-Zа-яА-ЯёЁѣѢіІ0-9\-]+)(?=:)?\]|(?<key>[a-zA-Zа-яА-ЯёЁѣѢіІ0-9\-]+)(?=:)?)(?=[:\]]|$)", &match) {
						keyLetter := match["modKey"] != "" ? match["modKey"] : match["key"]
						if keyNamesArray.HasValue(keyLetter) {
							isCyrillicKey := RegExMatch(keyLetter, matchRu)

							rules := Map(
								"Caps", [binds],
								"ReverseCase", [binds, True],
								"Lang", isCyrillicKey ? [["", ""], binds] : [binds, ["", ""]],
								"LangReverseCase", isCyrillicKey ? [["", ""], binds, True] : [binds, ["", ""], True],
								"LangFlat", binds is Array && binds.Length == 2 ? [binds[1], binds[2]] : [binds],
							)

							rule := binds is Array ? "Lang" : ""
							if RegExMatch(combo, ":(.*?)$", &ruleMatch)
								rule := ruleMatch[1]


							interCombo := RegExReplace(combo, ":" rule "$", "")
							interCombo := RegExReplace(interCombo, keyLetter, scanCode)
							interCombo := RegExReplace(interCombo, "\[(.*?)\]", "$1")


							if !output.Has(interCombo) {
								output.Set(interCombo,
									binds is String || binds is Func ? [binds] :
									rules[rule]
								)
							} else {
								if output.Get(interCombo).Length == 2 {
									if output[interCombo] is Func {
										interArr := [[], []]
										interArr[isCyrillicKey ? 1 : 2] := output[interCombo]
										output[interCombo] := interArr
									}
									output[interCombo][isCyrillicKey ? 2 : 1] := binds
								} else {
									output[interCombo].Push(binds)
								}
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
					if RegExMatch(combo, "^\<\^\>\!")
						HotKey(SubStr(combo, 3), action, rule ? "On" : "Off")
				} catch {
					if StrLen(combo) > 0
						MsgBox("Failed to register HotKey: " combo)
				}
			}
		}
	}

	static UnregisterAll() {
		layout := this.GetCurrentLayoutMap()

		for scanCode, keyNamesArray in layout {
			if StrLen(scanCode) > 0 RegExMatch(scanCode, "i)^SC[0-9A-F]{3}$") {
				HotKey(scanCode, (*) => False, "Off")

				for modifier in this.modifiers {
					HotKey(modifier scanCode, (*) => False, "Off")
				}
			}
		}
	}

	static RebuilBinds() {
		this.UnregisterAll()
		this.CurrentLayouts(&latin, &cyrillic)
		if Cfg.Get("Layout_Remapping", , False, "bool") && (latin != "QWERTY" || cyrillic != "ЙЦУКЕН")
			this.Registration(BindList.Get("Keyboard Default"), True)

		this.Registration(BindList.Get("Important"), True)
		this.Registration(BindList.Get("Common"), Cfg.FastKeysOn)

		userBindings := Cfg.Get("Active_User_Bindings", , "None")
		if userBindings != "None" && Cfg.FastKeysOn {
			this.Registration(BindList.Get(userBindings, "User"), Cfg.FastKeysOn)
		}

		if StrLen(this.numStyle) > 0
			this.ToggleNumStyle(this.numStyle, True)
	}


	static ToggleLigaturedMode() {
		this.ligaturedBinds := !this.ligaturedBinds
		this.RebuilBinds()
	}

	static ToggleDefaultMode() {
		modeActive := Cfg.Get("Mode_Fast_Keys", , False, "bool")
		Cfg.Set(modeActive, "Mode_Fast_Keys", , "bool")

		MsgBox(Locale.Read("message_fastkeys_" (modeActive ? "de" : "") "activated"), "FastKeys", 0x40)

		this.RebuilBinds()
	}

	static ToggleNumStyle(style := "Superscript", force := False) {
		this.numStyle := (style = this.numStyle && !force) ? "" : style
		this.Registration(BindList.Get(style " Digits"), force ? force : StrLen(this.numStyle) > 0)

		if StrLen(this.numStyle) == 0 {
			this.RebuilBinds()
		}
	}

	static UserLayouts() {
		Loop Files this.autoimport.layouts "\*.ini" {
			scriptName := IniRead(A_LoopFileFullPath, "info", "name", "")
			scriptType := IniRead(A_LoopFileFullPath, "info", "type", "")
			layoutMap := Util.INIToMap(A_LoopFileFullPath)

			if StrLen(scriptName) > 0 && StrLen(scriptType) > 0 && this.layouts.HasOwnProp(scriptType) && layoutMap.Has("keys") {
				scriptType := StrLower(scriptType)
				layoutBase := LayoutList(scriptType)
				outputLayout := Map()

				for key, value in layoutMap["keys"] {
					outputLayout[key] := RegExMatch(value, "i)^SC[0-9A-F]{3}$") ? value : layoutBase.layout[value]
				}

				this.layouts.%scriptType%.Set(scriptName, LayoutList(scriptType, outputLayout))
				this.userLayoutsNames.Push(scriptName)
			} else {
				MsgBox("Invalid layout file: " A_LoopFileFullPath)
			}
		}
	}

	static SetBinds(name := Locale.Read("gui_options_bindings_none")) {
		Cfg.Set(name = Locale.Read("gui_options_bindings_none") ? "None" : name, "Active_User_Bindings")
		this.RebuilBinds()
	}

	static UserBinds() {
		Loop Files this.autoimport.binds "\*.ini" {
			name := IniRead(A_LoopFileFullPath, "info", "name", "")
			bindsMap := Util.INIToMap(A_LoopFileFullPath)

			if StrLen(name) > 0 && bindsMap.Has("binds") {
				if !this.userBindings.HasValue(name)
					this.userBindings.Push(name)
				this.UserBindsHandler(bindsMap["binds"], name)
			}
		}

		currentBindings := Cfg.Get("Active_User_Bindings", , "None")
		if !this.userBindings.Has(currentBindings) && currentBindings != "None" {
			Cfg.Set("None", "Active_User_Bindings")
		}
	}

	static UserBindsHandler(bindsMap := Map(), name := "") {
		if bindsMap.Count > 0 && StrLen(name) > 0 {
			interMap := Map("Flat", Map(), "Moded", Map())
			for combo, reference in bindsMap {
				Util.StrBind(combo, &keyRef, &modRef, &rulRef)
				interRef := reference

				if RegExMatch(reference, "^\[(.*?)\]$", &arrRefMatch) {
					interRef := StrSplit(Util.StrTrim(arrRefMatch[1]), ",")
				}

				if StrLen(modRef) > 0 {
					if !interMap["Moded"].Has(keyRef) {
						interMap["Moded"][keyRef] := Map()
					}

					interMap["Moded"][keyRef].Set(modRef rulRef, interRef)
				} else {
					interMap["Flat"].Set(keyRef rulRef, interRef)
				}

			}
			bindingMaps["User"].Set(name, interMap)

		}
	}
}

Class Scripter {

}

Class BindHandler {
	static waitTimeSend := False

	static Send(combo := "", characterNames*) {
		Keyboard.CheckLayout(&lang)

		if Language.Validate(lang, "bindings") {
			output := ""
			inputType := ""

			for _, character in characterNames {
				if character is Func {
					character(combo)
				} else {
					alt := AlterationActiveName
					if RegExMatch(character, "\:\:(.*?)$", &alterationMatch) {
						alt := ChrLib.ValidateAlt(alterationMatch[1])
						character := RegExReplace(character, "\:\:.*$", "")
					}

					if ChrLib.entries.HasOwnProp(character) {
						output .= ChrLib.Get(character, True, Auxiliary.inputMode, alt)

						chrSendOption := ChrLib.GetValue(character, "options").send

						if StrLen(chrSendOption) > 0
							inputType := chrSendOption
					} else {
						output .= GetCharacterSequence(character)
					}
				}
			}

			keysValidation := "SC(14B|148|14D|150|04A)"
			chrValidation := "(\" Chr(0x00AE) "|\" Chr(0x2122) "|\" Chr(0x00A9) "|\" Chr(0x2022) "|\" Chr(0x25B6) "|\" Chr(0x25C0) "|\" Chr(0x0021) "|\" Chr(0x002B) "|\" Chr(0x005E) "|\" Chr(0x0023) "|\" Chr(0x007B) "|\" Chr(0x007D) "|\" Chr(0x0060) "|\" Chr(0x007E) "|\" Chr(0x0025) "|\" Chr(0x0009) "|\" Chr(0x000A) "|\" Chr(0x000D) ")"

			if StrLen(inputType) == 0
				inputType := (RegExMatch(combo, keysValidation) || RegExMatch(output, chrValidation) || Auxiliary.inputMode != "Unicode" || StrLen(output) > 10) ? "Text" : ""

			if StrLen(output) > 20
				ClipSend(output)
			else
				Send%inputType%(output)
		} else {
			this.SendDefault(combo)
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
				if charactersObj.%lang% is Array && charactersObj.%lang%.Length == 2 {
					this.CapsSend(combo, charactersObj.%lang%, reverse.%lang%)
				} else {
					this.Send(combo, charactersObj.%lang% is Array ? charactersObj.%lang%[1] : charactersObj.%lang%)
				}
			}
		}
	}

	static TimeSend(combo := "", secondKeysActions := Map(), DefaultAction := False, timeLimit := "0.1") {
		if this.waitTimeSend {
			this.SendDefault(combo)
			return
		}
		this.waitTimeSend := True

		Util.StrBind(combo, &keyRef, &modRef, &rulRef)
		layoutMap := KeyboardBinder.GetCurrentLayoutMap()
		keyRefScanCode := ""

		for scanCode, keyNamesArray in layoutMap {
			if keyNamesArray.HasValue(keyRef) {
				keyRefScanCode := scanCode
				break
			}
		}

		IH := InputHook("L1 M T" timeLimit)
		IH.VisibleNonText := False
		IH.KeyOpt("{All}", "E")
		IH.KeyOpt("{LShift}{RShift}{LControl}{RControl}{LAlt}{RAlt}", "-E")
		IH.Start()
		IH.Wait()

		keyPressed := StrLen(IH.Input) > 0 ? StrUpper(IH.Input) : StrLen(IH.EndKey) > 0 ? IH.EndKey : ""

		report .= "`n" keyPressed

		if StrLen(keyPressed) > 0 &&
			secondKeysActions is Map &&
			secondKeysActions.Has(keyPressed) &&
			secondKeysActions[keyPressed] is Func {
			secondKeysActions[keyPressed]()
		} else {
			!DefaultAction ? this.SendDefault(combo) : DefaultAction()
		}

		this.waitTimeSend := False
	}

	static SendDefault(combo) {
		arrowKeys := RegExMatch(combo, "SC(14B|148|14D|150)")

		Util.StrBind(combo, &keyRef, &modRef, &rulRef)
		Send(
			arrowKeys ? "{" keyRef "}" :
			("{Blind}" modRef (StrLen(keyRef) > 1 ? "{" keyRef "}" : keyRef))
		)
	}
}