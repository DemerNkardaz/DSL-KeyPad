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
			targetMap.Set(combo, BindHandler.Send.Bind(BindHandler, , bind[1]))
		} else if (bind.Length = 1 && bind[1] is Array) ||
			(bind.Length == 2 && bind[1] is Array && Util.IsBool(bind[2])) {
			reverse := bind.Length == 2 ? bind[2] : False
			targetMap.Set(combo, BindHandler.CapsSend.Bind(BindHandler, , bind[1], reverse))
		} else if bind.Length >= 2 {
			reverse := bind.Length == 3 ? bind[3] : Map("en-US", False, "ru-RU", False)
			targetMap.Set(combo, BindHandler.LangSend.Bind(BindHandler, , Map("en-US", bind[1], "ru-RU", bind[2]), reverse))
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