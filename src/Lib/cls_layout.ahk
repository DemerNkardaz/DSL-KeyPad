Class LayoutList {
	static default := Map(
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
	static latin := Map(
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
	static cyrillic := Map(
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

		for key, scanCode in LayoutList.default {
			this.layout.Set(key, scanCode)
		}

		for key, scanCode in LayoutList.%base% {
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

		this.TrayIconSwitch()
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

	static TrayIconSwitch() {
		KeyboardBinder.CurrentLayouts(&latinLayout, &cyrillicLayout)
		Keyboard.CheckLayout(&lang)

		iconCode := App.indexIcos["app"]
		trayTitle := App.Title("+status+version") "`n" latinLayout "/" cyrillicLayout

		if this.disabledByMonitor || this.disabledByUser {
			iconCode := App.indexIcos["disabled"]
		} else {
			currentAlt := Scripter.selectedMode["Alternative Modes"]
			currentISP := InputScriptProcessor.options.interceptionInputMode

			if currentISP != "" && App.indexIcos.Has(currentISP) {
				iconCode := App.indexIcos[currentISP]
				trayTitle .= "`n" Locale.Read("script_processor_mode_" currentISP)
			} else if currentAlt != "" {
				data := Scripter.GetData(, currentAlt)
				icons := data.icons
				iconCode := App.indexIcos[icons.Length > 1 ? icons[lang = "ru" ? 2 : 1] : icons[1]]
				trayTitle .= "`n" Locale.Read(data.locale)
			}
		}

		TraySetIcon(App.icoDLL, iconCode)
		A_IconTip := trayTitle
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
		total := bindingsMap.Count
		useTooltip := Cfg.Get("Bind_Register_Tooltip_Progress_Bar", , True, "bool")

		comboActions := []


		if total > 0 {
			i := 0

			for combo, action in bindingsMap {
				comboActions.Push(combo, action)
				if combo ~= "^\<\^\>\!" {
					comboActions.Push(SubStr(combo, 3), action)
					total++
				}
			}

			if useTooltip
				SetTimer(ShowTooltip, 50)

			Loop comboActions.Length // 2 {
				try {
					i++
					index := A_Index * 2 - 1
					comboSeq := comboActions[index]
					actionSeq := comboActions[index + 1]

					HotKey(comboSeq, actionSeq, rule ? "On" : "Off")
				} catch
					StrLen(combo) > 0 && MsgBox("Failed to register HotKey: " combo)
			}
		}

		if useTooltip {
			SetTimer(ShowTooltip, -0)
			ToolTip()
		}

		ShowTooltip(*) {
			ToolTip(Locale.ReadInject("lib_init_elems", [i, total]) " : " Locale.Read("binds_init") "`n" Util.TextProgressBar(i, total))
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

	static RebuilBinds(ignoreAltMode := False) {
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

		if this.numStyle != ""
			this.ToggleNumStyle(this.numStyle, True)


		altMode := Scripter.selectedMode["Alternative Modes"]
		if altMode != "" && !ignoreAltMode {
			bingingsNames := Scripter.GetData(, altMode).bindings
			this.Registration(BindList.Gets(bingingsNames, "Script Specified"), True)
		}
	}


	static ToggleLigaturedMode() {
		this.ligaturedBinds := !this.ligaturedBinds
		this.RebuilBinds()
	}

	static ToggleDefaultMode() {
		modeActive := Cfg.Get("Mode_Fast_Keys", , False, "bool")
		modeActive := !modeActive
		Cfg.Set(modeActive, "Mode_Fast_Keys", , "bool")

		MsgBox(Locale.Read("message_fastkeys_" (!modeActive ? "de" : "") "activated"), "FastKeys", 0x40)

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
		if !this.userBindings.HasValue(currentBindings) && currentBindings != "None" {
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
					interRef := []
					rawString := RegExMatch(arrRefMatch[1], "^RAW\:\:\{") ? Trim(arrRefMatch[1]) : Util.StrTrim(arrRefMatch[1])
					openBraces := 0
					currentSegment := ""

					Loop Parse, rawString {
						if A_LoopField = "{"
							openBraces++
						else if A_LoopField = "}"
							openBraces--

						if A_LoopField = "," && openBraces = 0 {
							interRef.Push(Trim(currentSegment))
							currentSegment := ""
						}
						else {
							currentSegment .= A_LoopField
						}
					}

					if StrLen(currentSegment) > 0
						interRef.Push(Trim(currentSegment))
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
	static selectorGUI := Map("Alternative Modes", Gui(), "Glyph Variations", Gui())
	static selectorTitle := Map(
		"Alternative Modes", App.Title("+status+version") " — " Locale.Read("gui_scripter_alt_mode"),
		"Glyph Variations", App.Title("+status+version") " — " Locale.Read("gui_scripter_glyph_variation"),
	)
	static selectedMode := Map("Alternative Modes", "", "Glyph Variations", "")

	static data := Map(
		"Alternative Modes", [
			"Hellenic", {
				preview: [Util.UnicodeToChars("1F19", "03BB", "03BB", "03AC", "03B4", "03BF", "03C2", "0020", "03C6", "1FF6", "03C2")],
				fonts: [],
				locale: "alt_mode_hellenic",
				bindings: ["Hellenic"],
				uiid: "Hellenic",
				icons: ["hellenic"],
			},
			"Germanic runes & Glagolitic", {
				preview: [Util.UnicodeToChars("16B7", "16D6", "16B1", "16D7", "16A8", "16BE", "16C1", "16B2", "0020", "16B1", "16A2", "16BE", "16D6", "16CA"), Util.UnicodeToChars("2C03", "2C3E", "2C30", "2C33", "2C41", "2C3E", "2C3A", "2C4C", "2C30")],
				fonts: ["Segoe UI Historic"],
				locale: "alt_mode_germanic_runes__glagolitic",
				bindings: ["Germanic Runes", "Glagolitic"],
				uiid: "GermanicGlagolitic",
				icons: ["germanic", "glagolitic"],
			},
			"Old Turkic & Old Permic", {
				preview: [Util.UnicodeToChars("10C34", "10C0D", "10C23", "2003", "10C03", "10C3E", "10C18", "10C03", "003A", "10C20", "10C03", "10C1A", "10C2D"), Util.UnicodeToChars("10363", "10371", "10355", "10350", "2003", "1035C", "10369", "10360", "10362")],
				fonts: ["Noto Sans Old Turkic", "Noto Sans Old Permic"],
				locale: "alt_mode_old_turkic__old_permic",
				bindings: ["Old Turkic", "Old Permic"],
				uiid: "TukicPermic",
				icons: ["turkic", "permic"],
			},
			"Old Hungarian", {
				preview: [Util.UnicodeToChars("10C87", "10CCF", "10C96", "10C9A", "10CDF", "10C9D", "10CAC")],
				fonts: ["Noto Sans Old Hungarian"],
				locale: "alt_mode_old_hungarian",
				bindings: ["Old Hungarian"],
				uiid: "Hungarian",
				icons: ["hungarian"],
			},
			"Gothic", {
				preview: [Util.UnicodeToChars("10330", "10339", "10342", "10338", "10330", "1033A", "1033F", "1033D", "10333", "10343")],
				fonts: ["Noto Sans Gothic"],
				locale: "alt_mode_gothic",
				bindings: ["Gothic"],
				uiid: "Gothic",
				icons: ["gothic"],
			},
			"Old Italic", {
				preview: [Util.UnicodeToChars("10300", "1030B", "10304", "10319", "10314", "10300", "1030D", "10315", "10313", "10304", "2003", "10316", "10304", "10313", "1031A", "10300", "1030B", "10304")],
				fonts: ["Noto Sans Old Italic"],
				locale: "alt_mode_old_italic",
				bindings: ["Old Italic"],
				uiid: "Italic",
				icons: ["italic"],
			},
			"Phoenician", {
				preview: [Util.UnicodeToChars("10912", "10913", "10915", "10907", "10903", "10914", "10915", "2003", "10900", "1090B", "10914", "10909")],
				fonts: ["Segoe UI Historic"],
				locale: "alt_mode_phoenician",
				bindings: ["Phoenician"],
				uiid: "Phoenician",
				icons: ["phoenician"],
			},
			"Ancient South Arabian", {
				preview: [Util.UnicodeToChars("10A6B", "10A65", "10A6B", "10A68", "2003", "10A79", "10A69", "10A62", "10A63", "10A7A", "10A63")],
				fonts: ["Noto Sans Old South Arabian"],
				locale: "alt_mode_ancient_south_arabian",
				bindings: ["Ancient South Arabian"],
				uiid: "AncientSouthArabian",
				icons: ["south_arabian"],
			},
			"Ancient North Arabian", {
				preview: [Util.UnicodeToChars("10A83", "10A9A", "10A89", "2003", "10A88", "10A93", "10A87", "2003", "10A81", "10A89")],
				fonts: ["Noto Sans Old North Arabian"],
				locale: "alt_mode_ancient_north_arabian",
				bindings: ["Ancient North Arabian"],
				uiid: "AncientNorthArabian",
				icons: ["north_arabian"],
			},
			"Carian", {
				preview: [Util.UnicodeToChars("102A8", "102A0", "102B5", "2003", "102B2", "102B0", "102AB", "102C7", "2003", "102BA", "102B5")],
				fonts: ["Noto Sans Carian"],
				locale: "alt_mode_carian",
				bindings: ["Carian"],
				uiid: "Carian",
				icons: ["carian"],
			},
			"Lycian", {
				preview: [Util.UnicodeToChars("10297", "10295", "10290", "1028E", "10286", "10296", "2003", "1029C", "10291", "10297", "10280", "10287", "10280", "10297", "10286")],
				fonts: ["Noto Sans Lycian"],
				locale: "alt_mode_lycian",
				bindings: ["Lycian"],
				uiid: "Lycian",
				icons: ["lycian"],
			},
			"Tifinagh", {
				preview: [Util.UnicodeToChars("2D30", "2D4E", "2D53", "2D4F", "2D59", "2D3D", "2D30", "2D4D", "2003", "2D49", "2D39", "2003", "2D30", "2D3C", "2D54", "2D37", "2D49", "2D59")],
				fonts: ["Noto Sans Tifinagh"],
				locale: "alt_mode_tifinagh",
				bindings: ["Tifinagh"],
				uiid: "Tifinagh",
				icons: ["tifinagh"],
			},
			"Ugaritic", {
				preview: [Util.UnicodeToChars("10383", "1038A", "10397", "2003", "10384", "1038A", "10390", "2003", "10382", "1038E", "10397")],
				fonts: ["Noto Sans Ugaritic"],
				locale: "alt_mode_ugaritic",
				bindings: ["Ugaritic"],
				uiid: "Ugaritic",
				icons: ["ugaritic"],
			},
			"Old Persian", {
				preview: [Util.UnicodeToChars("103A0", "103BC", "103AB", "103A7", "103C1", "103C2", "103A0", "2003", "")],
				fonts: ["Noto Sans Old Persian"],
				locale: "alt_mode_old_persian",
				bindings: ["Old Persian"],
				uiid: "OldPersian",
				icons: ["persian"],
			},
			"IPA", {
				preview: [Util.UnicodeToChars("002F", "02CC", "026A", "006E", "002E", "0074", "0259", "02C8", "006E", "00E6", "0283", "002E", "006E", "0259", "006C", "0020", "0066", "0259", "02C8", "006E", "025B", "002E", "0074", "026A", "006B", "0020", "02C8", "00E6", "006C", "002E", "0066", "0259", "002E", "0062", "025B", "0074", "002F")],
				fonts: ["Noto Sans"],
				locale: "alt_mode_ipa",
				bindings: ["IPA"],
				uiid: "IPA",
				icons: ["ipa"],
			},
			"Math", {
				preview: [Util.UnicodeToChars("2211", "222D", "2206", "2207", "22D8", "22D9")],
				fonts: ["Noto Sans"],
				locale: "alt_mode_math",
				bindings: ["Math"],
				uiid: "Math",
				icons: ["math"],
			},
		],
		"Glyph Variations", []
	)

	static SelectorPanel(selectorType := "Alternative Modes") {
		keyCodes := [
			"SC010",
			"SC011",
			"SC012",
			"SC013",
			"SC014",
			"SC015",
			"SC016",
			"SC017",
			"SC018",
			"SC019",
			"SC01E",
			"SC01F",
			"SC020",
			"SC021",
			"SC022",
			"SC023",
			"SC024",
			"SC025",
			"SC026",
			"SC02C",
			"SC02D",
			"SC02E",
			"SC02F",
			"SC030",
			"SC031",
			"SC032"
		]
		Constructor() {
			IH := InputHook("L1", "{Escape}")
			hotkeys := Map()
			keys := keyCodes.Clone()
			keysLen := keys.Length
			KeyboardBinder.CurrentLayouts(&latinLayout, &cyrillicLayout)

			Loop keys.Length
				keys.Push("")

			for keyName, keyCode in KeyboardBinder.layouts.latin[latinLayout].layout
				keyCodes.HasValue(keyCode, &i) && (keys[i] := keyName)
			for keyName, keyCode in KeyboardBinder.layouts.cyrillic[cyrillicLayout].layout
				keyCodes.HasValue(keyCode, &i) && (keys[keysLen + i] := keyName)

			selectorPanel := Gui()
			selectorPanel.OnEvent("Close", (Obj) => Destroy())
			selectorPanel.title := this.selectorTitle[selectorType]

			widthDefault := 256
			heightDefault := 256

			elementsPerColumn := 4
			rowCount := 0
			columnCount := 0
			totalColumns := 0
			elementCount := 0

			dataCount := this.data[selectorType].Length // 2

			Loop dataCount {
				(columnCount < elementsPerColumn) ? columnCount++ : (columnCount := 1, rowCount++)
				(totalColumns < elementsPerColumn) && totalColumns++
				elementCount++
			}

			(columnCount > 0 && columnCount < elementsPerColumn) && rowCount++

			icoW := 32
			icoH := 32

			optionW := 386
			optionH := (icoH * 2) + 20
			optionGap := 20

			optionTitleW := (optionW - icoW) - 21
			optionTitleH := 24

			borderPadding := 20
			panelWidth := optionW * totalColumns + optionGap * (totalColumns - 1) + 2 * borderPadding
			panelHeight := optionH * rowCount + optionGap * (rowCount - 1) + 2 * borderPadding


			currentRow := 0
			currentCol := 0

			j := 0
			Loop dataCount {
				j++
				i := A_Index * 2 - 1
				dataName := this.data[selectorType][i]
				dataValue := this.data[selectorType][i + 1]
				AddOption(dataName, dataValue, j)
			}

			prevAltMode := this.selectedMode.Get(selectorType)
			if prevAltMode != "" && selectorType = "Alternative Modes" {
				bingingsNames := this.GetData(selectorType, prevAltMode).bindings
				KeyboardBinder.Registration(BindList.Gets(bingingsNames, "Script Specified"), False)
			}

			selectorPanel.Show("w" panelWidth " h" panelHeight " Center")

			SetTimer((*) => SetIH(), -100)
			return selectorPanel

			AddOption(dataName, dataValue, j) {
				optionX := borderPadding + currentCol * (optionW + optionGap)
				optionY := borderPadding + currentRow * (optionH + optionGap)
				icoX := optionX + 5
				icoY := optionY + 10
				icoShift := 0

				selectorPanel.AddGroupBox("v" dataValue.uiid " w" optionW " h" optionH " x" optionX " y" optionY)
				invisibleButton := selectorPanel.AddPicture("v" dataValue.uiid "Invisible w" optionW " h" optionH " x" optionX " y" optionY " +BackgroundTrans")
				invisibleButton.OnEvent("Click", (Obj, Info) => OptionSelect(dataName))

				for i, ico in dataValue.icons {
					selectorPanel.AddPicture("v" dataValue.uiid "Ico" ico " w" icoW " h" icoH " x" icoX " y" (icoY + icoShift) " Icon" App.indexIcos[ico], App.icoDLL)
					icoShift += icoH + 5
				}

				optionTitleX := optionX + icoW + 13
				optionTitleY := optionY + 13

				optionTitle := selectorPanel.AddText("v" dataValue.uiid "Title w" optionTitleW " h" optionTitleH " x" optionTitleX " y" optionTitleY " +BackgroundTrans", Locale.Read(dataValue.locale))
				optionTitle.SetFont("s11 c333333 Bold", "Segoe UI")

				scriptPreviewX := optionTitleX
				scriptPreviewY := optionTitleY + optionTitleH

				for i, previewText in dataValue.preview {
					pt := selectorPanel.AddText("v" dataValue.uiid "Preview" i " w" optionTitleW " h" optionTitleH " x" scriptPreviewX " y" scriptPreviewY " +BackgroundTrans", previewText)
					pt.SetFont("s10 c333333", dataValue.fonts.length > 0 ? dataValue.fonts[dataValue.fonts.length > 1 ? i : 1] : "Segoe UI")

					scriptPreviewY += optionTitleH - 5
				}

				hotkeys.Set(keys[j], dataName)
				hotkeys.Set(keys[keyCodes.Length + j], dataName)
				hotkeysLabel := selectorPanel.AddText("v" dataValue.uiid "Hotkey w" optionTitleW " h" optionTitleH " x" optionTitleX " y" ((optionY + optionH) - optionTitleH) " Right +BackgroundTrans", Locale.ReadInject("alt_mode_gui_press", [keys[j] "/" keys[keyCodes.Length + j]]))

				currentCol++
				if (currentCol >= elementsPerColumn) {
					currentCol := 0
					currentRow++
				}
			}

			OptionSelect(name) {
				currentISP := InputScriptProcessor.options.interceptionInputMode

				if name != "" {
					currentMode := this.selectedMode.Get(selectorType)

					Destroy()
					if selectorType = "Alternative Modes" {
						if currentISP != "" {
							WarningISP(name, currentISP, selectorType)
							return
						}

						this.selectedMode.Set(selectorType, currentMode != name ? name : "")
						altMode := this.selectedMode.Get(selectorType)

						if !(KeyboardBinder.disabledByMonitor || KeyboardBinder.disabledByUser) {
							if altMode != "" {
								bingingsNames := this.GetData(selectorType, altMode).bindings
								KeyboardBinder.Registration(BindList.Gets(bingingsNames, "Script Specified"), True)
							} else
								KeyboardBinder.RebuilBinds()
						}
					}
				} else
					Destroy()

				return
			}

			WarningISP(name, currentISP, selectorType) {
				nameTitle := Locale.Read(this.GetData(selectorType, name).locale)
				IPSTitle := Locale.Read("script_processor_mode_" currentISP)
				MsgBox(Locale.ReadInject("alt_mode_warning_isp_active", [nameTitle, IPSTitle]), App.Title(), "Icon!")
				return
			}

			SetIH() {
				IH.Start()
				IH.Wait()

				if IH.EndKey = "Escape" {
					Destroy()
					return
				}

				input := StrUpper(IH.Input)

				if hotkeys.Has(input)
					OptionSelect(hotkeys.Get(input))
				else
					Destroy()
				return
			}

			Destroy() {
				selectorPanel.Destroy()
				IH.Stop()
				if prevAltMode != ""
					KeyboardBinder.RebuilBinds()
				return
			}
		}

		if IsGuiOpen(this.selectorTitle[selectorType]) {
			WinActivate(this.selectorTitle[selectorType])
		} else {
			this.selectorGUI[selectorType] := Constructor()
			this.selectorGUI[selectorType].Show()
			WinSetAlwaysOnTop(True, this.selectorTitle[selectorType])
		}
	}

	static DirectSelect(name, selectorType := "Alternative Modes") {
		if name != "" {
			currentMode := this.selectedMode.Get(selectorType)
			this.selectedMode.Set(selectorType, currentMode != name ? name : "")

			if selectorType = "Alternative Modes" {
				altMode := this.selectedMode.Get(selectorType)

				if !(KeyboardBinder.disabledByMonitor || KeyboardBinder.disabledByUser) {
					if altMode != "" {
						bingingsNames := Scripter.GetData(selectorType, altMode).bindings
						KeyboardBinder.Registration(BindList.Gets(bingingsNames, "Script Specified"), True)
					} else {
						KeyboardBinder.UnregisterAll()
						KeyboardBinder.RebuilBinds()
					}
				}
			}
			return
		}
	}

	static GetData(mode := "Alternative Modes", name := "Germanic runes & Glagolitic") {
		for i, item in this.data[mode] {
			if Mod(i, 2) = 1 {
				if item = name {
					return this.data[mode][i + 1]
				}
			}
		}
	}
}

Class BindHandler {
	static waitTimeSend := False

	static Send(combo := "", characterNames*) {
		Keyboard.CheckLayout(&lang)

		if Language.Validate(lang, "bindings") {
			output := ""
			inputType := ""
			lineBreaks := False

			for _, character in characterNames {
				if character is Func {
					character(combo)
				} else if RegExMatch(character, "^RAW\:\:\{(.*?)\}$", &rawMatch) {
					inputType := "Text"
					output .= MyRecipes.FormatResult(rawMatch[1], True)
					if RegExMatch(rawMatch[1], "\\n")
						lineBreaks := True
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

			if StrLen(output) > 20 || lineBreaks
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