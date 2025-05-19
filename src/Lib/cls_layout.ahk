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
		"І", "SC999",
		"Ѣ", "SC999",
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
		SetTimer((*) => this.Monitor(), 1000)
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
		if A_IsPaused
			return

		; ToolTip(Keyboard.CurrentLayout(, True))
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
		if A_IsPaused
			return

		if enable && !this.disabledBy%addRule% {
			if this.disabledBy%rule% {
				this.disabledBy%rule% := False
				Suspend(-1)
			}
		} else if !this.disabledBy%rule% && !this.disabledBy%addRule% {
			this.disabledBy%rule% := True
			Suspend(1)
		}

		App.SetTray()
	}

	static TrayIconSwitch() {
		KeyboardBinder.CurrentLayouts(&latinLayout, &cyrillicLayout)
		Keyboard.CheckLayout(&lang)

		if lang != "" && Language.supported[lang].parent != ""
			lang := Language.supported[lang].parent

		iconCode := App.indexIcos["app"]
		trayTitle := App.Title("+status+version") "`n" latinLayout "/" cyrillicLayout

		if this.disabledByMonitor || this.disabledByUser {
			iconCode := App.indexIcos["disabled"]
		} else {
			currentAlt := Scripter.selectedMode.Get("Alternative Modes")
			currentGlyph := Scripter.selectedMode.Get("Glyph Variations")
			currentISP := InputScriptProcessor.options.interceptionInputMode
			mode := currentAlt != "" ? "Alternative Modes" : "Glyph Variations"
			current := currentAlt != "" ? currentAlt : currentGlyph

			if currentISP != "" && App.indexIcos.Has(currentISP) {
				iconCode := App.indexIcos[currentISP]
				trayTitle .= "`n" Locale.Read("script_processor_mode_" currentISP)
			} else if currentAlt != "" || currentGlyph != "" {
				data := Scripter.GetData(mode, current)
				icons := data.icons
				iconCode := App.indexIcos[icons.Length > 1 ? icons[lang = "ru-RU" ? 2 : 1] : icons[1]]
				trayTitle .= "`n" Locale.Read(data.locale)
			}
		}

		TraySetIcon(App.icoDLL, iconCode, True)
		A_IconTip := RegExReplace(trayTitle, "\&", "&&&")
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
			reverse := bind.Length == 3 ? bind[3] : Map("en-US", False, "ru-RU", False)
			targetMap.Set(combo, (K) => BindHandler.LangSend(K, Map("en-US", bind[1], "ru-RU", bind[2]), reverse))
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
				if (binds is Array && binds.Length == 1 && binds[1] is String && RegExMatch(binds[1], "\[(.*?)\]", &match)) ||
					(binds is String && RegExMatch(binds, "\[(.*?)\]", &match)) {
					splitVariants := StrSplit(match[1], ",")
					tempBinds := []

					for i, variant in splitVariants {
						variantBind := RegExReplace(binds is String ? binds : binds[1], "\[.*?\]", variant)
						tempBinds.Push(variantBind)
					}

					binds := tempBinds
				}

				for scanCode, keyNamesArray in layout {
					if RegExMatch(combo, "(?:\[(?<modKey>[a-zA-Zа-яА-ЯёЁѣѢіІ0-9\-]+)(?=:)?\]|(?<key>[a-zA-Zа-яА-ЯёЁѣѢіІ0-9\-]+)(?=:)?)(?=[:\]]|$)", &match) {
						keyLetter := match["modKey"] != "" ? match["modKey"] : match["key"]
						if keyNamesArray.HasValue(keyLetter) {
							isCyrillicKey := RegExMatch(keyLetter, matchRu)

							rules := Map(
								"Caps", binds is Array ? [binds] : [[binds]],
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
								try {
									output.Set(interCombo,
										binds is String || binds is Func ? [binds] :
										rules[rule]
									)
								} catch as e {
									MsgBox "Error in Origin Combo: " combo "`n Combo: " interCombo "`n Rule: " rule "`n Error: " e.Message
								}
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
				i++
				index := A_Index * 2 - 1
				comboSeq := comboActions[index]
				actionSeq := comboActions[index + 1]
				try {
					if comboSeq != ""
						HotKey(comboSeq, actionSeq, rule ? "On" : "Off")
				} catch as e
					MsgBox("Error: " e.Message "`nCombo: " comboSeq)
			}
		}

		if useTooltip && i >= total {
			SetTimer(ShowTooltip, -50)
			SetTimer((*) => ToolTip(), -700)
		}

		ShowTooltip(*) {
			ToolTip(Locale.ReadInject("lib_init_elems", [i, total], "default") " : " Locale.Read("binds_init") "`n" Util.TextProgressBar(i, total))
			Sleep 50
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

	static RebuilBinds(ignoreAltMode := False, ignoreUnregister := False) {
		this.CurrentLayouts(&latin, &cyrillic)

		useRemap := Cfg.Get("Layout_Remapping", , False, "bool")
		checkDefaultLayouts := (latin != "QWERTY" || cyrillic != "ЙЦУКЕН")
		isGlyphsVariationsOn := Scripter.selectedMode.Get("Glyph Variations") != ""

		useRemap := (useRemap && checkDefaultLayouts) || isGlyphsVariationsOn

		userBindings := Cfg.Get("Active_User_Bindings", , "None")
		isUserBindingsOn := userBindings != "None" && Cfg.FastKeysOn

		altMode := Scripter.selectedMode.Get("Alternative Modes")
		isAltModeOn := altMode != "" && !ignoreAltMode

		bingingsNames := []
		if isAltModeOn
			bingingsNames := Scripter.GetData(, altMode).bindings

		if !ignoreUnregister
			this.UnregisterAll()

		preparedBindLists := []
		rawBindLists := [
			useRemap ? "Keyboard Default" : "",
			Cfg.FastKeysOn ? "Common" : "",
			Cfg.FastKeysOver != "" && Cfg.FastKeysOn ? Cfg.FastKeysOver : "",
			isUserBindingsOn ? userBindings ":User" : "",
			"Important"
		]

		if isAltModeOn {
			for altBinding in bingingsNames {
				len := rawBindLists.Length
				rawBindLists.InsertAt(len - 1, altBinding ":Script Specified")
			}
		}

		for i, bindName in rawBindLists {
			if bindName != ""
				preparedBindLists.Push(bindName)
		}

		bindsConstructor := BindList.Gets(preparedBindLists)

		this.Registration(bindsConstructor, True)

		if this.numStyle != ""
			this.ToggleNumStyle(this.numStyle, True)
	}


	static ToggleLigaturedMode() {
		this.ligaturedBinds := !this.ligaturedBinds
		this.RebuilBinds()
	}

	static ToggleDefaultMode(typeofActivation := "") {
		isTOA := StrLen(typeofActivation) > 0
		modeActive := Cfg.Get("Mode_Fast_Keys" (isTOA ? "_Over" : ""), , isTOA ? "" : False, isTOA ? "" : "bool")

		modeActive := isTOA
			? (modeActive != typeofActivation ? typeofActivation : "")
			: !modeActive

		Cfg.Set(modeActive, "Mode_Fast_Keys" (isTOA ? "_Over" : ""), , isTOA ? "" : "bool")

		if typeofActivation = ""
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
	static selectorTitle := Map("Alternative Modes", "", "Glyph Variations", "",)
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
				fonts: [],
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
			"Lydian", {
				preview: [Util.UnicodeToChars("1092C", "1092D", "10920", "10937", "2003", "10929", "10924", "10931", "1092E", "2003", "10939", "10926", "10925", "10933")],
				fonts: ["Noto Sans Lydian"],
				locale: "alt_mode_lydian",
				bindings: ["Lydian"],
				uiid: "Lydian",
				icons: ["lydian"],
			},
			"Sidetic", {
				preview: ["Wait for Unicode 17.0 2025/09/09+"],
				fonts: ["Noto Sans Sidetic"],
				locale: "alt_mode_sidetic",
				bindings: ["Sidetic"],
				uiid: "Sidetic",
				icons: ["sidetic"],
			},
			"Cypriot Syllabary", {
				preview: [Util.UnicodeToChars("10800", "1081A", "1082E", "1080B", "2003", "10800", "10823", "1080E", "10826", "1081A", "2003", "10828", "1082D", "1082A", "1080E", "10821", "10826", "10829")],
				fonts: ["Noto Sans Cypriot"],
				locale: "alt_mode_cypriot_syllabary",
				bindings: ["Cypriot Syllabary"],
				uiid: "CypriotSyllabary",
				icons: ["cypriot_syllabary"],
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
				preview: [Util.UnicodeToChars("2211", "2212", "002B", "00B1", "00D7", "00F7", "0025", "2205", "2237", "2247", "22B9", "222D", "2206", "2207", "22D8", "22D9")],
				fonts: ["Noto Serif"],
				locale: "alt_mode_math",
				bindings: ["Math"],
				uiid: "Math",
				icons: ["math"],
			},
		],
		"Glyph Variations", [
			"combining", {
				preview: [Util.UnicodeToChars("25CC", "0363", "25CC", "0368", "25CC", "0369", "25CC", "0364", "25CC", "0365", "25CC", "0366", "25CC", "0367")],
				fonts: ["Cabmria"],
				locale: "glyph_mode_combining",
				uiid: "Combining",
				icons: ["glyph_combining"],
			},
			"superscript", {
				preview: [Util.UnicodeToChars("25CC", "1D43", "25CC", "1D47", "25CC", "1D9C", "25CC", "1D48", "25CC", "1D49", "25CC", "1DA0")],
				fonts: [],
				locale: "glyph_mode_superscript",
				uiid: "Superscript",
				icons: ["glyph_superscript"],
			},
			"subscript", {
				preview: [Util.UnicodeToChars("25CC", "2090", "25CC", "2091", "25CC", "2095", "25CC", "1D62", "25CC", "2C7C", "25CC", "2096", "25CC", "2097", "25CC", "2098", "25CC", "2099")],
				fonts: [],
				locale: "glyph_mode_subscript",
				uiid: "Subscript",
				icons: ["glyph_subscript"],
			},
			"italic", {
				preview: [Util.UnicodeToChars("1D43C", "1D461", "1D44E", "1D459", "1D456", "1D450")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_italic",
				uiid: "Italic",
				icons: ["glyph_italic"],
			},
			"bold", {
				preview: [Util.UnicodeToChars("1D401", "1D428", "1D425", "1D41D")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_bold",
				uiid: "Bold",
				icons: ["glyph_bold"],
			},
			"italicBold", {
				preview: [Util.UnicodeToChars("1D470", "1D495", "1D482", "1D48D", "1D48A", "1D484", "0020", "1D469", "1D490", "1D48D", "1D485")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_italic_bold",
				uiid: "ItalicBold",
				icons: ["glyph_italic_bold"],
			},
			"sansSerif", {
				preview: [Util.UnicodeToChars("1D5B2", "1D5BA", "1D5C7", "1D5CC", "002D", "1D5B2", "1D5BE", "1D5CB", "1D5C2", "1D5BF")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_sans_serif",
				uiid: "SansSerif",
				icons: ["glyph_sans_serif"],
			},
			"sansSerifItalic", {
				preview: [Util.UnicodeToChars("1D61A", "1D622", "1D62F", "1D634", "002D", "1D61A", "1D626", "1D633", "1D62A", "1D627", "0020", "1D610", "1D635", "1D622", "1D62D", "1D62A", "1D624")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_sans_serif_italic",
				uiid: "SansSerifItalic",
				icons: ["glyph_sans_serif_italic"],
			},
			"sansSerifBold", {
				preview: [Util.UnicodeToChars("1D5E6", "1D5EE", "1D5FB", "1D600", "002D", "1D5E6", "1D5F2", "1D5FF", "1D5F6", "1D5F3", "0020", "1D5D5", "1D5FC", "1D5F9", "1D5F1")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_sans_serif_bold",
				uiid: "SansSerifBold",
				icons: ["glyph_sans_serif_bold"],
			},
			"sansSerifItalicBold", {
				preview: [Util.UnicodeToChars("1D64E", "1D656", "1D663", "1D668", "002D", "1D64E", "1D65A", "1D667", "1D65E", "1D65B", "0020", "1D644", "1D669", "1D656", "1D661", "1D65E", "1D658", "0020", "1D63D", "1D664", "1D661", "1D659")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_sans_serif_italic_bold",
				uiid: "SansSerifItalicBold",
				icons: ["glyph_sans_serif_italic_bold"],
			},
			"monospace", {
				preview: [Util.UnicodeToChars("1D67C", "1D698", "1D697", "1D698", "1D69C", "1D699", "1D68A", "1D68C", "1D68E")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_monospace",
				uiid: "Monospace",
				icons: ["glyph_monospace"],
			},
			"fullwidth", {
				preview: [Util.UnicodeToChars("FF26", "FF35", "FF2C", "FF2C", "FF37", "FF29", "FF24", "FF34", "FF28")],
				fonts: [],
				locale: "glyph_mode_fullwidth",
				uiid: "Fullwidth",
				icons: ["glyph_fullwidth"],
			},
			"smallCapital", {
				preview: [Util.UnicodeToChars("A731", "1D0D", "1D00", "029F", "029F", "0020", "1D04", "1D00", "1D18", "026A", "1D1B", "1D00", "029F")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_small_capital",
				uiid: "SmallCapital",
				icons: ["glyph_small_capital"],
			},
			"fraktur", {
				preview: [Util.UnicodeToChars("1D509", "1D52F", "1D51E", "1D528", "1D531", "1D532", "1D52F")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_fraktur",
				uiid: "Fraktur",
				icons: ["glyph_fraktur"],
			},
			"frakturBold", {
				preview: [Util.UnicodeToChars("1D571", "1D597", "1D586", "1D590", "1D599", "1D59A", "1D597", "0020", "1D56D", "1D594", "1D591", "1D589")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_fraktur_bold",
				uiid: "FrakturBold",
				icons: ["glyph_fraktur_bold"],
			},
			"script", {
				preview: [Util.UnicodeToChars("1D4AE", "1D4B8", "1D4C7", "1D4BE", "1D4C5", "1D4C9")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_script",
				uiid: "Script",
				icons: ["glyph_script"],
			},
			"scriptBold", {
				preview: [Util.UnicodeToChars("1D4E2", "1D4EC", "1D4FB", "1D4F2", "1D4F9", "1D4FD", "0020", "1D4D1", "1D4F8", "1D4F5", "1D4ED")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_script_bold",
				uiid: "ScriptBold",
				icons: ["glyph_script_bold"],
			},
			"doubleStruck", {
				preview: [Util.UnicodeToChars("1D53B", "1D560", "1D566", "1D553", "1D55D", "1D556", "002D", "1D54A", "1D565", "1D563", "1D566", "1D554", "1D55C")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_double_struck",
				uiid: "DoubleStruck",
				icons: ["glyph_double_struck"],
			},
			"doubleStruckItalic", {
				preview: [Util.UnicodeToChars("2145", "2146", "2147", "2148", "2149")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_double_struck_italic",
				uiid: "DoubleStruckItalic",
				icons: ["glyph_double_struck_italic"],
			},
			"uncombined", {
				preview: [Util.UnicodeToChars("25CC", "00B4", "25CC", "02DD", "25CC", "02D8", "25CC", "00B8", "25CC", "02D9", "25CC", "00A8", "25CC", "0060", "25CC", "00AF", "25CC", "02DB", "25CC", "02DA", "25CC", "02DC")],
				fonts: ["Cabmria Math"],
				locale: "glyph_mode_uncombined",
				uiid: "Uncombined",
				icons: ["glyph_uncombined"],
			},
		]
	)

	static SelectorPanel(selectorType := "Alternative Modes") {
		keySymbols := Map(
			"Tilde", "``",
			"HyphenMinus", "-",
			"ДефисоМинус", "-",
			"Equals", "=",
			"Равно", "=",
			"LeftBracket", "[",
			"RightBracket", "]",
			"Semicolon", ";",
			"Apostrophe", "'",
			"Comma", ",",
			"Dot", ".",
			"Slash", "/",
		)

		selectorAntagonist := selectorType != "Alternative Modes" ? "Alternative Modes" : "Glyph Variations"
		isGlyphs := selectorType = "Glyph Variations"
		keyCodes := [
			; "SC029",
			; "SC002",
			; "SC003",
			; "SC004",
			; "SC005",
			; "SC006",
			; "SC007",
			; "SC008",
			; "SC009",
			; "SC00A",
			; "SC00B",
			; "SC00C",
			; "SC00D",
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
			"SC01A",
			"SC01B",
			"SC01E",
			"SC01F",
			"SC020",
			"SC021",
			"SC022",
			"SC023",
			"SC024",
			"SC025",
			"SC026",
			"SC027",
			"SC028",
			"SC02C",
			"SC02D",
			"SC02E",
			"SC02F",
			"SC030",
			"SC031",
			"SC032",
			"SC033",
			"SC034",
			"SC035",
		]

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

		for key, value in keySymbols {
			keys.HasValue(key, &i) && (keys[i] := value)
		}

		prevAltMode := this.selectedMode.Get(selectorType)
		this.selectorTitle.Set(selectorType, App.Title("+status+version") " — " Locale.Read("gui_scripter_" (selectorType == "Alternative Modes" ? "alt_mode" : "glyph_variation")))

		Constructor() {
			selectorPanel := Gui()
			selectorPanel.OnEvent("Close", (Obj) => this.PanelDestroy(selectorType))
			selectorPanel.title := this.selectorTitle.Get(selectorType)

			dataCount := this.data[selectorType].Length // 2

			widthDefault := 256
			heightDefault := 256

			elementsPerColumn := dataCount > 21 && !isGlyphs ? 4 : 3
			rowCount := 0
			columnCount := 0
			totalColumns := 0
			elementCount := 0

			Loop dataCount {
				if (columnCount < elementsPerColumn) ? columnCount++ : (columnCount := 1, rowCount++)
					(totalColumns < elementsPerColumn) && totalColumns++
				elementCount++
			}

			rowCount++

			icoW := 32
			icoH := 32

			optionW := 386 - 24
			optionH := ((icoH * 2) + 30) / (isGlyphs ? 1.5 : 1)
			optionGap := 10

			optionTitleH := 24

			borderPadding := optionGap
			panelWidth := optionW * totalColumns + optionGap * (totalColumns - 1) + 2 * borderPadding
			panelHeight := optionH * rowCount + (optionGap // 2) * (rowCount - 1) + 2 * borderPadding


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

			selectorPanel.Show("w" panelWidth " h" panelHeight " Center")

			return selectorPanel


			AddOption(dataName, dataValue, j) {
				optionX := borderPadding + currentCol * (optionW + optionGap)
				optionY := borderPadding + currentRow * (optionH + (optionGap // 2))
				icoX := optionX + 10
				icoY := optionY + 15
				icoShift := 0

				plateButtonW := optionW
				plateButtonH := optionH - 7
				plateButtonX := optionX
				plateButtonY := optionY + 6

				borderBackground := selectorPanel.AddText("w" plateButtonW + 4 " h" plateButtonH + 4 " x" plateButtonX - 2 " y" plateButtonY - 2 " Background" (prevAltMode = dataName ? "0xfdd500" : "Trans"))

				plateButton := selectorPanel.AddText("w" plateButtonW " h" plateButtonH " x" plateButtonX " y" plateButtonY " BackgroundWhite")
				plateButton.OnEvent("Click", (Obj, Info) => (
					this.PanelDestroy(selectorType),
					this.OptionSelect(dataName, selectorType)
				))


				selectorPanel.AddGroupBox("v" dataValue.uiid " w" optionW " h" optionH " x" optionX " y" optionY)

				for i, ico in dataValue.icons {
					selectorPanel.AddPicture("v" dataValue.uiid "Ico" ico " w" icoW " h" icoH " x" icoX " y" (icoY + icoShift) " BackgroundTrans Icon" App.indexIcos[ico], App.icoDLL)
					icoShift += icoH + 5
				}

				optionTitleX := optionX + icoW + 20
				optionTitleY := icoY

				optionTitleW := optionW - (icoX - optionX) - icoW - 20

				optionTitle := selectorPanel.AddText("v" dataValue.uiid "Title w" optionTitleW " h" optionTitleH " x" optionTitleX " y" optionTitleY " 0x80 +BackgroundTrans", Locale.Read(dataValue.locale))
				optionTitle.SetFont("s10 c333333 Bold", "Segoe UI")

				scriptPreviewX := optionTitleX
				scriptPreviewY := optionTitleY + optionTitleH - 2

				for i, previewText in dataValue.preview {
					pt := selectorPanel.AddText("v" dataValue.uiid "Preview" i " w" optionTitleW " h" optionTitleH " x" scriptPreviewX " y" scriptPreviewY " 0x80 +BackgroundTrans", previewText)
					pt.SetFont("s" (isGlyphs && dataName != "fullwidth" ? 12 : 10) " c333333", dataValue.fonts.length > 0 ? dataValue.fonts[dataValue.fonts.length > 1 ? i : 1] : "Segoe UI")

					scriptPreviewY += optionTitleH - 5
				}

				hotkeys.Set(keys[j], dataName)
				hotkeys.Set(keys[keyCodes.Length + j], dataName)
				hotkeysLabel := selectorPanel.AddText("v" dataValue.uiid "Hotkey w" optionTitleW " h" optionTitleH " x" optionTitleX " y" ((optionY + optionH) - optionTitleH) " 0x80 Right +BackgroundTrans", Locale.ReadInject("alt_mode_gui_press", [keys[j] "/" keys[keyCodes.Length + j]]))

				currentCol++
				if (currentCol >= elementsPerColumn) {
					currentCol := 0
					currentRow++
				}
			}
		}

		if IsGuiOpen(this.selectorTitle.Get(selectorType)) {
			WinActivate(this.selectorTitle.Get(selectorType))
		} else {
			if IsGuiOpen(this.selectorTitle.Get(selectorAntagonist)) {
				this.selectorGUI[selectorAntagonist].Destroy()
				Sleep 200
			}

			this.selectorGUI[selectorType] := Constructor()
			this.selectorGUI[selectorType].Show()
			WinSetAlwaysOnTop(True, this.selectorTitle.Get(selectorType))

			this.WaitForKey(hotkeys, selectorType)
		}
	}

	static OptionSelect(name, selectorType := "Alternative Modes") {
		currentISP := InputScriptProcessor.options.interceptionInputMode
		if name != "" {
			currentMode := this.selectedMode.Get(selectorType)

			if selectorType = "Alternative Modes" {
				if currentISP != "" {
					WarningISP(name, currentISP, selectorType)
					return
				}
			}

			this.selectedMode.Set(selectorType, currentMode != name ? name : "")
		}

		altMode := this.selectedMode.Get(selectorType)
		KeyboardBinder.RebuilBinds(, altMode != "")

		WarningISP(name, currentISP, selectorType) {
			nameTitle := Locale.Read(this.GetData(selectorType, name).locale)
			IPSTitle := Locale.Read("script_processor_mode_" currentISP)
			MsgBox(Locale.ReadInject("alt_mode_warning_isp_active", [nameTitle, IPSTitle]), App.Title(), "Icon!")
		}
	}

	static isScripterWaiting := False
	static WaitForKey(hotkeys, selectorType) {
		this.isScripterWaiting := True
		useRemap := Cfg.Get("Layout_Remapping", , False, "bool")
		useRemap ? (KeyboardBinder.Registration(BindList.Get("Keyboard Default"), True)) : Suspend(1)

		IH := InputHook("L1 M")
		IH.OnEnd := OnEnd
		IH.Start()
		SetTimer(WaitCheckGUI, 50)

		WaitCheckGUI() {
			if !IsGuiOpen(this.selectorTitle.Get(selectorType)) {
				IH.Stop()
				this.isScripterWaiting := False
				if !(KeyboardBinder.disabledByMonitor || KeyboardBinder.disabledByUser)
					Suspend(0)
				SetTimer(WaitCheckGUI, -0)
				Exit
			}
		}

		OnEnd(*) {
			if GetKeyState("Shift", "P") || GetKeyState("Ctrl", "P") || GetKeyState("Alt", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P") {
				this.WaitForKey(hotkeys, selectorType)
				return
			}
			this.HandleWaiting(StrUpper(IH.Input), hotkeys, selectorType)
		}

	}

	static HandleWaiting(endKey, hotkeys, selectorType) {
		this.PanelDestroy(selectorType)
		if endKey != "" && hotkeys.Has(endKey)
			this.OptionSelect(hotkeys.Get(endKey), selectorType)
	}

	static PanelDestroy(selectorType) {
		this.selectorGUI[selectorType].Destroy()
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

Class GlyphsPanel {
	static panelGUI := Gui()
	static title := ""
	static glyphsPanelList := []

	__New(preselectEntry) {
		GlyphsPanel.Panel(preselectEntry)
	}

	static SetPanelData() {
		entries := Map()
		output := []

		for entryName, value in ChrLib.entries.OwnProps()
			if ObjOwnPropCount(value.alterations) > 0
				entries.Set(value.index, entryName)

		for index, entryName in entries {
			unicode := Util.UnicodeToChar(ChrLib.entries.%entryName%.unicode)
			alts := ""

			for key, alt in ChrLib.entries.%entryName%.alterations.OwnProps()
				if !(key ~= "i)HTML$")
					alts .= (key = "combining" ? DottedCircle : "") Util.UnicodeToChar(alt) " "

			output.Push([unicode, alts, entryName])
		}

		this.glyphsPanelList := output
	}

	static Panel(preselectEntry := "") {
		panelW := 728
		panelH := 800

		posX := (A_ScreenWidth - panelW) / 2
		posY := (A_ScreenHeight - panelH) / 2

		listViewW := 256 + 96
		listViewH := panelH - 20
		listViewX := 10
		listViewY := (panelH - listViewH) / 2

		lvCols := [listViewW * 0.25, listViewW * 0.68, 0]

		symbolPreviewBoxW := 96 + 16
		symbolPreviewBoxH := 96 + 16
		symbolPreviewBoxX := (listViewW + listViewX) + 10
		symbolPreviewBoxY := 10

		symbolPreviewW := 96 - 8
		symbolPreviewH := 96 - 8
		symbolPreviewX := symbolPreviewBoxX + (symbolPreviewBoxW - symbolPreviewW) / 2
		symbolPreviewY := symbolPreviewBoxY + (symbolPreviewBoxH - symbolPreviewH) / 2

		previewsCount := 21

		this.title := App.Title() " — " Locale.Read("gui_scripter_glyph_variation_panel")

		Constructor() {

			glyphsPanel := Gui()
			glyphsPanel.title := this.title
			glyphsPanel.OnEvent("Close", (*) => glyphsPanel.Destroy())

			glyphsColumns := ["key", "view", "entry_title"]
			for i, each in glyphsColumns
				glyphsColumns[i] := Locale.Read("col_" each)

			glyphsLV := glyphsPanel.AddListView(Format("vGlyphsLV w{} h{} x{} y{} +NoSort -Multi", listViewW, listViewH, listViewX, listViewY), glyphsColumns)
			glyphsLV.OnEvent("ItemFocus", (LV, rowNumber) => this.GVPanelSelect(LV, rowNumber, glyphsPanel, previewsCount))

			for each in this.glyphsPanelList
				glyphsLV.Add(, each[1], each[2], each[3])

			for i, each in glyphsColumns
				glyphsLV.ModifyCol(i, lvCols[i])

			Loop previewsCount
				AddSymbolPreviewFrames(A_Index)

			if preselectEntry != "" {
				LV_Rows := glyphsLV.GetCount()
				Loop LV_Rows {
					if glyphsLV.GetText(A_Index, 3) = preselectEntry {
						glyphsLV.Modify(A_Index, "+Select +Focus")
						this.GVPanelSelect(glyphsLV, A_Index, glyphsPanel, previewsCount)
						break
					}
				}
			}

			glyphsPanel.Show(Format("w{} h{} x{} y{}", panelW, panelH, posX, posY))
			return glyphsPanel

			AddSymbolPreviewFrames(i := 0) {
				if (i > 0) {
					col := Mod(i - 1, 3)
					row := Floor((i - 1) / 3)

					gutterX := 5
					gutterY := -2

					xBox := symbolPreviewBoxX + col * (symbolPreviewBoxW + gutterX)
					yBox := symbolPreviewBoxY + row * (symbolPreviewBoxH + gutterY)

					glyphsPanel.AddText(
						Format("vSymbolPreviewBoxBg{} w{} h{} x{} y{} BackgroundWhite",
							i, symbolPreviewBoxW, symbolPreviewBoxH - 10, xBox, yBox + 7)
					)

					glyphsPanel.AddGroupBox(
						Format("vSymbolPreviewBox{} w{} h{} x{} y{}",
							i, symbolPreviewBoxW, symbolPreviewBoxH, xBox, yBox)
					)

					xEdit := xBox + (symbolPreviewBoxW - symbolPreviewW) / 2
					yEdit := (yBox + (symbolPreviewBoxH - symbolPreviewH) / 2) + 2

					glyphsEdit := glyphsPanel.AddEdit(
						Format("vSymbolPreview{} w{} h{} x{} y{} readonly Center -VScroll -HScroll",
							i, symbolPreviewW, symbolPreviewH, xEdit, yEdit)
					)
					glyphsEdit.SetFont("s42")
				}
			}
		}

		if IsGuiOpen(this.title) {
			WinActivate(this.title)

			if preselectEntry != "" {
				glyphsPanel := this.panelGUI
				glyphsLV := glyphsPanel["GlyphsLV"]

				LV_Rows := glyphsLV.GetCount()
				Loop LV_Rows {
					if glyphsLV.GetText(A_Index, 3) = preselectEntry {
						glyphsLV.Modify(A_Index, "+Select +Focus")
						this.GVPanelSelect(glyphsLV, A_Index, glyphsPanel, previewsCount)
						break
					}
				}
			}
		} else {
			this.panelGUI := Constructor()
			this.panelGUI.Show()
		}
	}

	static GVPanelSelect(LV, rowNumber, glyphsPanel, previewsCount) {
		static order := [
			"combining",
			"modifier",
			"superscript",
			"subscript",
			"italic",
			"italicBold",
			"bold",
			"sansSerif",
			"sansSerifItalic",
			"sansSerifItalicBold",
			"sansSerifBold",
			"fraktur",
			"frakturBold",
			"script",
			"scriptBold",
			"doubleStruck",
			"doubleStruckItalic",
			"monospace",
			"fullwidth",
			"smallCapital",
			"uncombined",
		]

		static fonts := Map(
			"combining", "Noto Serif",
			"modifier", "Noto Serif",
			"superscript", "Noto Serif",
			"subscript", "Noto Serif",
			"italic", "Cabmria Math",
			"bold", "Cabmria Math",
			"italicBold", "Cabmria Math",
			"sansSerif", "Cabmria Math",
			"sansSerifItalic", "Cabmria Math",
			"sansSerifBold", "Cabmria Math",
			"sansSerifItalicBold", "Cabmria Math",
			"monospace", "Cabmria Math",
			"fullwidth", "Cabmria Math",
			"smallCapital", "Noto Serif",
			"fraktur", "Cabmria Math",
			"frakturBold", "Cabmria Math",
			"script", "Cabmria Math",
			"scriptBold", "Cabmria Math",
			"doubleStruck", "Cabmria Math",
			"doubleStruckItalic", "Cabmria Math",
			"uncombined", "Noto Serif",
			"small", "Cabmria",
			"glagolitic", "Noto Sans Glagolitic",
		)

		static fontSizes := Map()

		Loop previewsCount
			glyphsPanel["SymbolPreview" A_Index].Text := ""

		entryName := LV.GetText(rowNumber, 3)
		cutEntryName := RegExReplace(entryName, "_.*$")
		entry := ChrLib.entries.%entryName%.Clone()
		entryAlts := {}

		for key, value in entry.alterations.OwnProps()
			if !(key ~= "i)HTML$")
				entryAlts.%key% := value

		for i, each in order {
			if entryAlts.HasOwnProp(each) {
				unicode := Util.UnicodeToChar(entryAlts.%each%)
				fontFamily := (fonts.Has(cutEntryName) ? fonts.Get(cutEntryName) : fonts.Get(each))

				if entryAlts.%each% is Array {
					for j, each in entryAlts.%each% {
						code := Number("0x" each)
						if code >= 0x1E030 && code <= 0x1E08F {
							fontFamily := "Catrinity"
						}
					} else {
						code := Number("0x" entryAlts.%each%)
						if code >= 0x1E030 && code <= 0x1E08F {
							fontFamily := "Catrinity"
						}
					}
				}


				glyphsPanel["SymbolPreview" i].Text := (["combining", "modifier", "superscript", "subscript"].HasValue(each) && cutEntryName != "glagolitic" ? DottedCircle : "") unicode glyphsPanel["SymbolPreview" i].SetFont("s"
					(fontSizes.Has(cutEntryName) ? fontSizes.Get(cutEntryName) : 42),
					fontFamily
				)
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
					alt := !ChrCrafter.isComposeInstanceActive && !Scripter.isScripterWaiting ? Scripter.selectedMode.Get("Glyph Variations") : "None"
					inputMode := !ChrCrafter.isComposeInstanceActive && !Scripter.isScripterWaiting ? Auxiliary.inputMode : "Unicode"

					if RegExMatch(character, "\:\:(.*?)$", &alterationMatch) {
						alt := alterationMatch[1]
						character := RegExReplace(character, "\:\:.*$", "")
					}

					if ChrLib.entries.HasOwnProp(character) {
						output .= ChrLib.Get(character, True, inputMode, alt)

						chrSendOption := ChrLib.GetValue(character, "options").send

						if StrLen(chrSendOption) > 0
							inputType := chrSendOption
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
		this.Send(combo, charactersPair.Length > 1 ? charactersPair[capsOn ? 1 : 2] : charactersPair[1])
	}

	static LangSend(combo := "", charactersMap := Map("en-US", "", "ru-RU", ""), reverse := Map("en-US", False "ru-RU", False)) {
		Keyboard.CheckLayout(&lang)

		if lang != "" && Language.supported[lang].parent != ""
			lang := Language.supported[lang].parent

		if !charactersMap.Has(lang)
			lang := "en-US"

		if Language.Validate(lang, "bindings") {
			if charactersMap.Has(lang) {
				if charactersMap[lang] is Array && charactersMap[lang].Length == 2 {
					this.CapsSend(combo, charactersMap[lang], reverse[lang])
				} else {
					this.Send(combo, charactersMap[lang] is Array ? charactersMap[lang][1] : charactersMap[lang])
				}
			}
		}
	}

	static LangCall(commandsMap := Map("en-US", "", "ru-RU", "")) {
		Keyboard.CheckLayout(&lang)

		if lang != "" && Language.supported[lang].parent != ""
			lang := Language.supported[lang].parent

		if !commandsMap.Has(lang)
			lang := "en-US"

		if Language.Validate(lang, "bindings")
			if commandsMap.Has(lang)
				commandsMap[lang]()

		return
	}

	static SendPaste(SendKey, Callback := "") {
		Send(SendKey)

		if Callback != "" {
			Sleep 50
			Callback()
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