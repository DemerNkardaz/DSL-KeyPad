Class LayoutList {
	static GetKeyCodes(keyNames*) {
		list := MapMerge(this.default, this.latin, this.cyrillic, this.hellenic)
		output := []

		isInt := keyNames[1] = "int"

		if isInt
			keyNames.RemoveAt(1)

		for k, v in list {
			if keyNames.HasValue(k)
				output.Push(isInt ? Number("0x" SubStr(v, 3)) : v)
		}

		return output
	}

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
		Chr(0x00DE), "SC99F", ; Thorn
		Chr(0x01F7), "SC99E", ; Wynn
		Chr(0xA768), "SC99D", ; Vend
		Chr(0x01B7), "SC99C", ; Ezh
		Chr(0x021C), "SC99B", ; Yogh
		Chr(0x1E9E), "SC99A", ; Eszett
		Chr(0x0194), "SC999", ; Gamma
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
		"Запятая", "SC90F",
		"Слэш", "SC90E",
		"Тильда", "SC90D",
		"Апостроф", "SC90C",
		"ТочкаСЗапятой", "SC90B",
		"ЛеваяКВСкобка", "SC90A",
		"ПраваяКВСкобка", "SC909",
		Chr(0x0406), "SC99F", ; Decimal I
		Chr(0x0462), "SC99E", ; Yat
		Chr(0x046A), "SC99D", ; Big Yus
		Chr(0x0466), "SC99C", ; Small Yus
		Chr(0x0470), "SC99B", ; Psi
		Chr(0x046E), "SC99A", ; Ksi
		Chr(0x0460), "SC999", ; Omega
		Chr(0x0472), "SC998", ; Fita
		Chr(0x051C), "SC997", ; We
		Chr(0x051A), "SC998", ; Qa
		Chr(0xA65E), "SC997", ; Yn
	)
	static hellenic := Map(
		"ΑνωΤελεια", "SC027",
		"Αποστροφη", "SC028",
		"ΑριστερηΑγκυλη", "SC01A",
		"ΔεξιαΑγκυλη", "SC01B",
		"Περισπωμενη", "SC029",
		"HyphenMinus", "SC00C",
		"Ισον", "SC00D",
		"Κομμα", "SC033",
		"Τελεια", "SC034",
		"Σολιδος", "SC035",
		"ΠισωΣολιδος", "SC02B",
		"Α", "SC01E",
		"Β", "SC030",
		"Ψ", "SC02E",
		"Δ", "SC020",
		"Ε", "SC012",
		"Φ", "SC021",
		"Γ", "SC022",
		"Η", "SC023",
		"Ι", "SC017",
		"Ξ", "SC024",
		"Κ", "SC025",
		"Λ", "SC026",
		"Μ", "SC032",
		"Ν", "SC031",
		"Ο", "SC018",
		"Π", "SC019",
		"Ϟ", "SC010",
		"Ρ", "SC013",
		"Σ", "SC01F",
		"Τ", "SC014",
		"Θ", "SC016",
		"Ω", "SC02F",
		"Ϝ", "SC011",
		"Χ", "SC02D",
		"Υ", "SC015",
		"Ζ", "SC02C",
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
		hellenic: Map(
			"ϞϜΕΡΤΥ", LayoutList("hellenic"),
		)
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
	static userLayoutNames := Map("latin", [], "cyrillic", [], "hellenic", [])
	static layoutNames := Map("latin", [], "cyrillic", [], "hellenic", [])
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

		for script in this.layoutNames.Keys()
			for k, v in this.layouts.%script%
				if !this.layoutNames[script].HasValue(k)
					this.layoutNames[script].Push(k)

		this.UserLayouts()
		this.UserBinds()
		this.RebuilBinds()
	}

	static Monitor() {
		if A_IsPaused
			return

		layoutHex := Keyboard.CurrentLayout()
		langBlock := Language.GetLanguageBlock(layoutHex)

		Keyboard.activeLanguage := langBlock ? langBlock[1] : "0x" Format("{:X}", layoutHex)

		isLanguageLayoutValid := Language.Validate(layoutHex, "bindings")
		disableTimer := Cfg.Get("Binds_Autodisable_Timer", , 1, "int")
		disableType := Cfg.Get("Binds_Autodisable_Type", , "hour")
		try {
			disableType := %disableType%
		} catch {
			disableType := hour
		}

		if !this.disabledByUser
			this.MonitorToggler(isLanguageLayoutValid && A_TimeIdle <= disableTimer * disableType)

		if (!this.disabledByUser && !this.disabledByMonitor) && isLanguageLayoutValid
			&& Cfg.Get("Alt_Input_Autoactivation", , False, "bool")
			&& langBlock {

			if !["^en", "^ru", "^vi"].HasRegEx(langBlock[1])
				&& Scripter.selectedMode.Get("Alternative Modes") = ""
				&& InputScriptProcessor.options.interceptionInputMode = ""
				&& langBlock[2].altInput != ""
				&& Scripter.Has(langBlock[2].altInput) {
				Scripter.activatedViaMonitor := True
				Scripter.OptionSelect(langBlock[2].altInput)
			} else if Scripter.activatedViaMonitor
				&& langBlock[2].altInput = "" {
				Scripter.activatedViaMonitor := False
				Scripter.OptionSelect(Scripter.selectedMode.Get("Alternative Modes"))
			}
		}

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
		KeyboardBinder.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)
		Keyboard.CheckLayout(&lang)

		if lang != "" && Language.supported[lang].parent != ""
			lang := Language.supported[lang].parent

		local iconCode := App.indexIcos["app"]
		local trayTitle := App.Title("+status+version") "`n" latinLayout "/" cyrillicLayout "/" hellenicLayout
		local iconFile := App.icoDLL

		if this.disabledByMonitor || this.disabledByUser {
			iconCode := App.indexIcos["disabled"]
		} else {
			local currentAlt := Scripter.selectedMode.Get("Alternative Modes")
			local currentGlyph := Scripter.selectedMode.Get("Glyph Variations")
			local currentISP := InputScriptProcessor.options.interceptionInputMode
			local mode := currentAlt != "" ? "Alternative Modes" : "Glyph Variations"
			local current := currentAlt != "" ? currentAlt : currentGlyph
			local instanceRef := currentISP != "" ? globalInstances.scriptProcessors[currentISP] : False

			if currentISP != "" && App.indexIcos.Has(instanceRef.tag) {
				iconCode := App.indexIcos[instanceRef.tag]
				trayTitle .= "`n" Locale.Read("script_processor_mode_" instanceRef.tag)
			} else if currentAlt != "" || currentGlyph != "" {
				local data := Scripter.GetData(mode, current)
				local icons := data["icons"]
				local icon := icons.Length > 1 ? icons[lang = "ru-RU" ? 2 : 1] : icons[1]
				if icon ~= "file::" {
					iconFile := StrReplace(icon, "file::")
					iconCode := 1
				} else
					iconCode := App.indexIcos[icon]
				trayTitle .= "`n" Locale.Read(data["locale"])
			}
		}

		TraySetIcon(iconFile, iconCode, True)
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

	static CurrentLayouts(&latin?, &cyrillic?, &hellenic?) {
		latin := Cfg.Get("Layout_Latin")
		cyrillic := Cfg.Get("Layout_Cyrillic")
		hellenic := Cfg.Get("Layout_Hellenic")
	}

	static GetCurrentLayoutMap() {
		layout := Map()
		this.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)

		latinLayout := KeyboardBinder.layouts.latin.Has(latinLayout) ? latinLayout : "QWERTY"
		cyrillicLayout := KeyboardBinder.layouts.cyrillic.Has(cyrillicLayout) ? cyrillicLayout : "ЙЦУКЕН"
		hellenicLayout := KeyboardBinder.layouts.hellenic.Has(hellenicLayout) ? hellenicLayout : "ϞϜΕΡΤΥ"

		latinLayout := KeyboardBinder.layouts.latin[latinLayout]
		cyrillicLayout := KeyboardBinder.layouts.cyrillic[cyrillicLayout]
		hellenicLayout := KeyboardBinder.layouts.hellenic[hellenicLayout]

		for keySet in [latinLayout, cyrillicLayout, hellenicLayout] {
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
		static matchRu := "(?!.*[a-zA-Z" enExt "])[а-яА-ЯёЁ" ruExt "]+"
		static matchEn := "(?!.*[а-яА-ЯёЁ" ruExt "])[a-zA-Z" enExt "]+"
		static metchEl := "[" hellenicRange "]+"
		KeyboardBinder.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)
		layout := this.GetCurrentLayoutMap()
		output := Map()
		restrictKeys := []

		if bindingsMap.Count > 0 {
			for combo, binds in bindingsMap {
				if binds is String {
					local originalBinds := binds
					local processedBinds := binds
					local lastProcessed := ""

					while (RegExMatch(processedBinds, "(?<!\\)%([^%]+)%", &varExprMatch) && processedBinds != lastProcessed) {
						lastProcessed := processedBinds

						try {
							local funcObject := VariableParser.Parse(varExprMatch[0])

							if (funcObject is Func) {
								processedBinds := funcObject
								break
							} else {
								processedBinds := StrReplace(processedBinds, varExprMatch[0], funcObject, , , 1)
							}
						} catch as e {
							processedBinds := StrReplace(processedBinds, varExprMatch[0], "[Parse Error: " . e.Message . "]", , , 1)
						}
					}

					binds := processedBinds
				}

				local bindString := binds is String ? binds : (binds is Array && binds.Length == 1 && binds[1] is String ? binds[1] : "")

				if bindString != "" {
					local brackets := []
					local pos := 1
					while (pos := RegExMatch(bindString, "\[(.*?)\]", &match, pos)) {
						brackets.Push({
							fullMatch: match[0],
							content: match[1],
							startPos: pos,
							endPos: pos + StrLen(match[0]) - 1
						})
						pos += StrLen(match[0])
					}

					if brackets.Length > 0 {
						local allVariants := []
						local maxVariants := 0

						for bracket in brackets {
							local variants := StrSplit(bracket.content, ",")
							for i, variant in variants {
								variants[i] := Trim(variant)
							}
							allVariants.Push(variants)
							if variants.Length > maxVariants
								maxVariants := variants.Length
						}

						for variants in allVariants {
							if variants.Length != maxVariants {
								MsgBox((
									Locale.Read("error_at_binds_registration") "`n"
									Locale.ReadInject("error_invalid_variants_at_name", [variants.Length, maxVariants, bindString])
								), App.Title(), "Iconx")
								continue 2
							}
						}

						local tempBinds := []

						for i in Range(1, maxVariants) {
							local variantBind := bindString

							for j in Range(brackets.Length, 1, -1) {
								local bracket := brackets[j]
								local variant := allVariants[j][i]

								variantBind := (
									SubStr(variantBind, 1, bracket.startPos - 1)
									variant
									SubStr(variantBind, bracket.endPos + 1)
								)
							}

							tempBinds.Push(variantBind)
						}

						binds := tempBinds
						allVariants := unset
						brackets := unset
					}
				}

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
					if RegExMatch(combo, "(?:\[(?<modKey>[a-zA-Zа-яА-ЯёЁѣѢіІ0-9\-\x{0370}-\x{03FF}\x{1F00}-\x{1FFF}]+)(?=:)?\]|(?<key>[a-zA-Zа-яА-ЯёЁѣѢіІ0-9\-\x{0370}-\x{03FF}\x{1F00}-\x{1FFF}]+)(?=:)?)(?=[:\]]|$)", &match) {
						keyLetter := match["modKey"] != "" ? match["modKey"] : match["key"]
						if keyNamesArray.HasValue(keyLetter) {
							isCyrillicKey := RegExMatch(keyLetter, matchRu)
							isHellenicKey := RegExMatch(keyLetter, metchEl)

							rules := Map(
								"Caps", binds is Array ? [binds] : [[binds]],
								"ReverseCase", [binds, True],
								"Lang", isCyrillicKey ? [["", ""], binds] : [binds, ["", ""]],
								"LangReverseCase", isCyrillicKey ? [["", ""], binds, True] : [binds, ["", ""], True],
								"LangFlat", binds is Array && binds.Length == 2 ? [binds[1], binds[2]] : [binds],
								"Flat", binds
							)

							rule := binds is Array ? "Lang" : ""
							if RegExMatch(combo, ":(.*?)$", &ruleMatch)
								rule := ruleMatch[1]

							interCombo := RegExReplace(combo, ":" rule "$", "")
							interCombo := RegExReplace(interCombo, keyLetter, scanCode)
							interCombo := RegExReplace(interCombo, "\[(.*?)\]", "$1")

							if rule = "Caps" || rule = "Flat"
								restrictKeys.Push(interCombo)

							if !output.Has(interCombo) || isHellenicKey {
								try {
									output.Set(interCombo,
										binds is String || binds is Func ? [binds] :
										rules[rule]
									)
								} catch as e {
									MsgBox "Error in Origin Combo: " combo "`n Combo: " interCombo "`n Rule: " rule "`n Error: " e.Message
								}
							} else if !restrictKeys.HasValue(interCombo) {
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

	static Registration(bindingsMap := Map(), rule := True, silent := False) {
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

			if useTooltip && !silent
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

		if useTooltip && !silent && i >= total {
			SetTimer(ShowTooltip, -50)
			SetTimer((*) => ToolTip(), -700)
		}

		ShowTooltip(*) {
			ToolTip(Locale.ReadInject("init.elements", [i, total], "default") " : " Locale.Read("init.binds") "`n" Util.TextProgressBar(i, total))
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
		this.CurrentLayouts(&latin, &cyrillic, &hellenic)

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
			bingingsNames := Scripter.GetData(, altMode)["bindings"]


		if !ignoreUnregister || useRemap && altMode = "Hellenic"
			this.UnregisterAll()

		preparedBindLists := []
		rawBindLists := [
			useRemap && altMode != "Hellenic" ? "Keyboard Default" : "",
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
		handled := Map("latin", [], "cyrillic", [], "hellenic", [])
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
				handled[scriptType].Push(scriptName)
			} else {
				MsgBox("Invalid layout file: " A_LoopFileFullPath)
			}
		}

		this.userLayoutNames := handled

		for script in handled.Keys() {
			for k, v in this.layouts.%script% {
				if this.layoutNames[script].HasValue(k)
					continue
				if !this.userLayoutNames[script].HasValue(k)
					this.layouts.%script%.Delete(k)
			}
		}
	}

	static SetBinds(name := Locale.Read("gui_options_bindings_none")) {
		Cfg.Set(name = Locale.Read("gui_options_bindings_none") ? "None" : name, "Active_User_Bindings")
		this.RebuilBinds()
	}

	static UserBinds() {
		handled := []
		Loop Files this.autoimport.binds "\*.ini" {
			name := IniRead(A_LoopFileFullPath, "info", "name", "")
			bindsMap := Util.INIToMap(A_LoopFileFullPath)

			if StrLen(name) > 0 && bindsMap.Has("binds") {
				if !handled.HasValue(name)
					handled.Push(name)
				this.UserBindsHandler(bindsMap["binds"], name)
			}
		}

		this.userBindings := handled

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
				} else {
					if rulRef = ""
						rulRef := ":Flat"
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
			BindReg.storedData["User"].Set(name, interMap)

		}
	}
}

Class Scripter {
	static selectorGUI := Map("Alternative Modes", Gui(), "Glyph Variations", Gui())
	static selectorTitle := Map("Alternative Modes", "", "Glyph Variations", "",)
	static selectedMode := Map("Alternative Modes", "", "Glyph Variations", "")
	static activatedViaMonitor := False

	static SelectorPanel(selectorType := "Alternative Modes", currentPage := 1) {
		local keySymbols := Map(
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
			"ΑνωΤελεια", ";",
			"Αποστροφη", "'",
			"ΑριστερηΑγκυλη", "[",
			"ΔεξιαΑγκυλη", "]",
			"Περισπωμενη", "``",
			"Παυλα", "-",
			"Ισον", "=",
			"Κομμα", ",",
			"Τελεια", ".",
			"Σολιδος", "/",
			"ΠισωΣολιδος", "\",
		)

		local selectorAntagonist := selectorType != "Alternative Modes" ? "Alternative Modes" : "Glyph Variations"
		local isGlyphs := selectorType = "Glyph Variations"
		local keyCodes := [
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

		local hotkeys := Map()
		local keys := keyCodes.Clone()
		local keysLen := keys.Length
		KeyboardBinder.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)

		Loop keysLen
			keys.Push("", "")

		for keyName, keyCode in KeyboardBinder.layouts.latin[latinLayout].layout
			keyCodes.HasValue(keyCode, &i) && (keys[i] := keyName)
		for keyName, keyCode in KeyboardBinder.layouts.cyrillic[cyrillicLayout].layout
			keyCodes.HasValue(keyCode, &i) && (keys[keysLen + i] := keyName)
		for keyName, keyCode in KeyboardBinder.layouts.hellenic[hellenicLayout].layout
			keyCodes.HasValue(keyCode, &i) && (keys[keysLen * 2 + i] := keyName)

		for key, value in keySymbols
			keys.HasValue(key, &i) && (keys[i] := value)


		local prevAltMode := this.selectedMode.Get(selectorType)
		this.selectorTitle.Set(selectorType, App.Title("+status+version") " — " Locale.Read("gui_scripter_" (selectorType == "Alternative Modes" ? "alt_mode" : "glyph_variation")))

		Constructor() {
			local maxItems := Cfg.Get("Scripter_Selector_Max_Items", "UI", 24, "int")
			maxItems := Min(Max(1, maxItems), keysLen)

			local selectorPanel := Gui()
			selectorPanel.OnEvent("Close", (Obj) => this.PanelDestroy(selectorType))
			selectorPanel.title := this.selectorTitle.Get(selectorType)

			local totalItems := ScripterStore.storedData[selectorType].Length // 2
			local totalPages := Ceil(totalItems / maxItems)

			if currentPage > totalPages
				currentPage := totalPages

			selectorPanel.title .= Chr(0x2003) "::" Chr(0x2003) Locale.ReadInject("gui_scripter_pages", [currentPage, totalPages]) " " Locale.Read("gui_scripter_pages_help")

			local startIndex := (currentPage - 1) * maxItems + 1
			local pageItems := Min(maxItems, totalItems - startIndex + 1)

			local widthDefault := 256
			local heightDefault := 256

			local itemsPerRow := totalItems > 24 && !isGlyphs ? 4 : 3
			local rowCount := Ceil(pageItems / itemsPerRow)
			local columnCount := Min(pageItems, itemsPerRow)

			local icoW := 32
			local icoH := 32

			local optionW := 386 - 24
			local optionH := ((icoH * 2) + 30) / (isGlyphs ? 1.5 : 1)
			local optionGap := 10

			local optionTitleH := 24

			local borderPadding := optionGap
			local panelWidth := optionW * columnCount + optionGap * (columnCount - 1) + 2 * borderPadding
			local panelHeight := optionH * rowCount + (optionGap // 2) * (rowCount - 1) + 2 * borderPadding


			local currentRow := 0
			local currentCol := 0

			j := 0
			Loop pageItems {
				j++
				local dataIndex := startIndex + A_Index - 1
				local i := dataIndex * 2 - 1
				local dataName := ScripterStore.storedData[selectorType][i]
				local dataValue := ScripterStore.storedData[selectorType][i + 1]
				AddOption(dataName, dataValue, j)
			}

			selectorPanel.Show("w" panelWidth " h" panelHeight " Center")

			return selectorPanel


			AddOption(dataName, dataValue, j) {
				local optionX := borderPadding + currentCol * (optionW + optionGap)
				local optionY := borderPadding + currentRow * (optionH + (optionGap // 2))
				local icoX := optionX + 10
				local icoY := optionY + 15
				local icoShift := 0

				local plateButtonW := optionW
				local plateButtonH := optionH - 7
				local plateButtonX := optionX
				local plateButtonY := optionY + 6

				local borderBackground := selectorPanel.AddText("w" plateButtonW + 4 " h" plateButtonH + 4 " x" plateButtonX - 2 " y" plateButtonY - 2 " Background" (prevAltMode = dataName ? "0xfdd500" : "Trans"))

				local plateButton := selectorPanel.AddText("w" plateButtonW " h" plateButtonH " x" plateButtonX " y" plateButtonY " BackgroundWhite")
				plateButton.OnEvent("Click", (Obj, Info) => (
					this.PanelDestroy(selectorType),
					this.OptionSelect(dataName, selectorType)
				))


				selectorPanel.AddGroupBox("v" dataValue["uiid"] " w" optionW " h" optionH " x" optionX " y" optionY)

				for i, ico in dataValue["icons"] {
					if ico ~= "file::" {
						selectorPanel.AddPicture("v" dataValue["uiid"] "Ico" i " w" icoW " h" icoH " x" icoX " y" (icoY + icoShift) " BackgroundTrans", StrReplace(ico, "file::"))
					} else
						selectorPanel.AddPicture("v" dataValue["uiid"] "Ico" ico " w" icoW " h" icoH " x" icoX " y" (icoY + icoShift) " BackgroundTrans Icon" App.indexIcos[ico], App.icoDLL)
					icoShift += icoH + 5
				}

				local optionTitleX := optionX + icoW + 20
				local optionTitleY := icoY

				local optionTitleW := optionW - (icoX - optionX) - icoW - 20

				local optionTitle := selectorPanel.AddText("v" dataValue["uiid"] "Title w" optionTitleW " h" optionTitleH " x" optionTitleX " y" optionTitleY " 0x80 +BackgroundTrans", Locale.Read(dataValue["locale"]))
				optionTitle.SetFont("s10 c333333 Bold", "Segoe UI")

				local scriptPreviewX := optionTitleX
				local scriptPreviewY := optionTitleY + optionTitleH - 2

				for i, previewText in dataValue["preview"] {
					local pt := selectorPanel.AddText("v" dataValue["uiid"] "Preview" i " w" optionTitleW " h" optionTitleH " x" scriptPreviewX " y" scriptPreviewY " 0x80 +BackgroundTrans", previewText)
					pt.SetFont("s" (isGlyphs && dataName != "fullwidth" ? 12 : 10) " c333333", dataValue["fonts"].length > 0 ? dataValue["fonts"][dataValue["fonts"].length > 1 ? i : 1] : "Segoe UI")

					scriptPreviewY += optionTitleH - 5
				}

				hotkeys.Set(keys[j], dataName)
				hotkeys.Set(keys[keyCodes.Length + j], dataName)
				hotkeys.Set(keys[keyCodes.Length * 2 + j], dataName)
				hotkeysLabel := selectorPanel.AddText(
					"v" dataValue["uiid"] "Hotkey w" optionTitleW " h" optionTitleH " x" optionTitleX " y" ((optionY + optionH) - optionTitleH)
					" 0x80 Right +BackgroundTrans",
					Locale.ReadInject("alt_mode_gui_press", [keys[j] " / " keys[keyCodes.Length + j] " / " keys[keyCodes.Length * 2 + j]])
				)

				currentCol++
				if (currentCol >= itemsPerRow) {
					currentCol := 0
					currentRow++
				}
			}
		}

		if WinExist(this.selectorTitle.Get(selectorType)) {
			WinActivate(this.selectorTitle.Get(selectorType))
		} else {
			if WinExist(this.selectorTitle.Get(selectorAntagonist)) {
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
		local currentISP := InputScriptProcessor.options.interceptionInputMode
		if name != "" {
			local currentMode := this.selectedMode.Get(selectorType)

			if selectorType = "Alternative Modes" {
				if currentISP != "" {
					WarningISP(name, currentISP, selectorType)
					return
				}
			}

			this.selectedMode.Set(selectorType, currentMode != name ? name : "")
		}

		local altMode := this.selectedMode.Get(selectorType)

		KeyboardBinder.RebuilBinds(, altMode != "")

		WarningISP(name, currentISP, selectorType) {
			local instanceRef := currentISP != "" ? globalInstances.scriptProcessors[currentISP] : False
			local nameTitle := Locale.Read(this.GetData(selectorType, name).locale)
			local IPSTitle := Locale.Read("script_processor_mode_" instanceRef.tag)
			MsgBox(Locale.ReadInject("alt_mode_warning_isp_active", [nameTitle, IPSTitle]), App.Title(), "Icon!")
		}
	}

	static isScripterWaiting := False
	static WaitForKey(hotkeys, selectorType) {
		this.isScripterWaiting := True
		local currentMode := this.selectedMode.Get(selectorType)
		local useRemap := Cfg.Get("Layout_Remapping", , False, "bool")

		if !useRemap && currentMode != "Hellenic" && Keyboard.activeLanguage != "el-GR"
			Suspend(1)
		else if Keyboard.activeLanguage = "el-GR" && currentMode != "Hellenic"
			KeyboardBinder.Registration(BindList.Get("Hellenic", "Script Specified"), True, True)
		else if useRemap && currentMode != "Hellenic"
			KeyboardBinder.Registration(BindList.Get("Keyboard Default"), True, True)

		local fKeys := ""
		Loop 12
			fKeys .= "{F" A_Index "}"

		local IH := InputHook("L1 M", fKeys)
		IH.OnEnd := OnEnd
		IH.Start()
		SetTimer(WaitCheckGUI, 50)

		WaitCheckGUI() {
			if !WinExist(this.selectorTitle.Get(selectorType)) {
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
			} else if RegExMatch(IH.EndKey, "^F(\d*)", &page) {
				if WinExist(this.selectorTitle.Get(selectorType))
					this.PanelDestroy(selectorType)
				this.SelectorPanel(selectorType, page[1])
				return
			}
			this.HandleWaiting(StrUpper(IH.Input), hotkeys, selectorType)
		}
	}

	static HandleWaiting(endKey, hotkeys, selectorType) {
		this.PanelDestroy(selectorType)
		if endKey != "" && hotkeys.Has(endKey) {
			this.activatedViaMonitor := False
			this.OptionSelect(hotkeys.Get(endKey), selectorType)
		}
	}

	static PanelDestroy(selectorType) {
		this.selectorGUI[selectorType].Destroy()
	}

	static Has(name := "", selectorType := "Alternative Modes") {
		for i, item in ScripterStore.storedData[selectorType] {
			if Mod(i, 2) = 1 {
				if item = name {
					return True
				}
			}
		}
		return False
	}

	static GetData(mode := "Alternative Modes", name := "Germanic runes & Glagolitic") {
		for i, item in ScripterStore.storedData[mode] {
			if Mod(i, 2) = 1 {
				if item = name {
					return ScripterStore.storedData[mode][i + 1]
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

		for entryName, entry in ChrLib.entries.OwnProps()
			if ObjOwnPropCount(entry["alterations"]) > 0
				entries.Set(entry["index"], entryName)

		for index, entryName in entries {
			unicode := Util.UnicodeToChar(ChrLib.entries.%entryName%["unicode"])
			alts := ""

			for key, alt in ChrLib.entries.%entryName%["alterations"]
				if !(key ~= "i)HTML$")
					alts .= (key = "combining" ? DottedCircle : "") Util.UnicodeToChar(alt) " "

			output.Push([unicode, alts, entryName])
		}

		this.glyphsPanelList := output
	}

	static Panel(preselectEntry := "") {
		if preselectEntry ~= "^&"
			preselectEntry := ChrLib.GetReferenceName(&preselectEntry)

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
		)
		static scriptFonts := Map(
			"glagolitic", "Noto Sans Glagolitic",
			"old_permic", "Noto Sans Old Permic",
		)

		Loop previewsCount
			glyphsPanel["SymbolPreview" A_Index].Text := ""

		entryName := LV.GetText(rowNumber, 3)
		entry := ChrLib.entries.%entryName%.Clone()
		entryAlts := {}

		scriptFontFamily := ""
		scriptFontFamilyKey := ""

		for key, value in scriptFonts {
			if entryName ~= "i)^" key {
				scriptFontFamilyKey := key
				scriptFontFamily := value
				break
			}
		}

		for key, value in entry["alterations"]
			if !(key ~= "i)HTML$")
				entryAlts.%key% := value

		for i, each in order {
			if entryAlts.HasOwnProp(each) {
				unicode := Util.UnicodeToChar(entryAlts.%each%)
				fontFamily := (scriptFontFamily != "" ? scriptFontFamily : fonts.Get(each))

				if entryAlts.%each% is Array {
					for j, each in entryAlts.%each% {
						code := Number("0x" each)
						if code >= 0x1E030 && code <= 0x1E08F
							fontFamily := "Catrinity"

					} else {
						code := Number("0x" entryAlts.%each%)
						if code >= 0x1E030 && code <= 0x1E08F
							fontFamily := "Catrinity"
					}
				}

				glyphsPanel["SymbolPreview" i].Text := (["combining", "modifier", "superscript", "subscript"].HasValue(each) && scriptFontFamilyKey != "glagolitic" ? DottedCircle : "") unicode glyphsPanel["SymbolPreview" i].SetFont("s" (42), (fontFamily)
				)
			}
		}
	}
}

Class BindHandler {
	static waitTimeSend := False

	static Send(combo := "", characterNames*) {
		Thread("Priority", 100)
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
					if rawMatch[1] ~= "\\n" || output ~= "[`n`r]"
						lineBreaks := True
				} else {
					alt := !globalInstances.crafter.isComposeInstanceActive && !Scripter.isScripterWaiting ? Scripter.selectedMode.Get("Glyph Variations") : "None"
					inputMode := !globalInstances.crafter.isComposeInstanceActive && !Scripter.isScripterWaiting ? Auxiliary.inputMode : "Unicode"
					repeatCount := 1

					if RegExMatch(character, "×(\d+)$", &repeatMatch) {
						repeatCount := repeatMatch[1]
						character := RegExReplace(character, "×\d+$", "")
					}

					if RegExMatch(character, "\:\:(.*?)$", &alterationMatch) {
						alt := alterationMatch[1]
						character := RegExReplace(character, "\:\:.*$", "")
					}

					if ChrLib.entries.HasOwnProp(character) {
						output .= Util.StrRepeat(ChrLib.Get(character, True, inputMode, alt), repeatCount)

						chrSendOption := ChrLib.GetValue(character, "options")["send"]

						if StrLen(chrSendOption) > 0
							inputType := chrSendOption
					}
				}
			}

			keysValidation := "SC(14B|148|14D|150|04A)"
			chrValidation := "(\" Chr(0x00AE) "|\" Chr(0x2122) "|\" Chr(0x00A9) "|\" Chr(0x2022) "|\" Chr(0x25B6) "|\" Chr(0x25C0) "|\" Chr(0x0021) "|\" Chr(0x002B) "|\" Chr(0x005E) "|\" Chr(0x0023) "|\" Chr(0x007B) "|\" Chr(0x007D) "|\" Chr(0x0060) "|\" Chr(0x007E) "|\" Chr(0x0025) "|\" Chr(0x0009) "|\" Chr(0x000A) "|\" Chr(0x000D) ")"

			if StrLen(inputType) == 0
				inputType := (RegExMatch(combo, keysValidation) || RegExMatch(output, chrValidation) || Auxiliary.inputMode != "Unicode" || StrLen(output) > 10) ? "Text" : ""

			if StrLen(output) > 4 || lineBreaks
				ClipSend(output)
			else
				Send%inputType%(output)
		} else {
			this.SendDefault(combo)
		}
		Thread("Priority", 1)
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

	static TimeShell(defaultAction := "", timeLimit := "0.005") {
		return (combo) => BindHandler.TimeSend(
			combo,
			Map(),
			defaultAction is Func ? defaultAction : (*) => BindHandler.Send(combo, defaultAction),
			timeLimit
		)
	}

	static TimeSend__HandleSecondKeys(secondKeysActions, combo := "") {
		output := Map()
		keys := []
		actions := []

		if RegExMatch(secondKeysActions[1], "\[(.*?)\]", &keysMatch)
			keys := StrSplit(keysMatch[1], ",")

		if RegExMatch(secondKeysActions[2], "\[(.*?)\]", &actionsMatch) {
			interActions := StrSplit(actionsMatch[1], ",")

			for each in interActions
				actions.Push(RegExReplace(secondKeysActions[2], "\[(.*?)\]", each))
		}


		for i, each in keys
			output.Set(each, BindHandler.Send.Bind(BindHandler, combo, actions[i]))


		return (output)
	}

	static TimeSend(combo := "", secondKeysActions := Map(), defaultAction := False, timeLimit := "0.1", alwaysUpper := False) {
		if this.waitTimeSend {
			this.SendDefault(combo)
			return
		}
		this.waitTimeSend := True

		if secondKeysActions is Array
			secondKeysActions := this.TimeSend__HandleSecondKeys(secondKeysActions, combo)


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
		IH.KeyOpt("{A}{B}{C}{D}{E}{F}{G}{H}{I}{J}{K}{L}{M}{N}{O}{P}{Q}{R}{S}{T}{U}{V}{W}{X}{Y}{Z}", "-E")
		IH.Start()
		IH.Wait()

		input := IH.Input
		endKey := IH.EndKey

		keyPressed := StrLen(input) > 0 ? input : StrLen(endKey) > 0 ? endKey : ""

		if StrLen(keyPressed) = 1 && (alwaysUpper || GetKeyState("CapsLock", "T"))
			keyPressed := StrUpper(keyPressed)

		report .= "`n" keyPressed

		; ToolTip(combo report '`n' input '`n' endKey)

		if StrLen(keyPressed) > 0 &&
			secondKeysActions is Map &&
			secondKeysActions.Has(keyPressed) &&
			secondKeysActions[keyPressed] is Func {
			secondKeysActions[keyPressed]()
		} else {
			!defaultAction ? this.SendDefault(combo) : defaultAction()
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