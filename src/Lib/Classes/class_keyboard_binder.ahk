Class KbdBinder {
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

	static numStyle := ""
	static userLayoutNames := Map("latin", [], "cyrillic", [], "hellenic", [])
	static layoutNames := Map("latin", [], "cyrillic", [], "hellenic", [])

	static __New() {
		this.ValidateSelectedLayouts()
		this.Init()
		return
	}

	static ValidateSelectedLayouts() {
		this.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)

		if !KbdLayoutReg.Check("latin", latinLayout)
			Options.SwitchVirualLayout("QWERTY", "Latin")

		if !KbdLayoutReg.Check("cyrillic", cyrillicLayout)
			Options.SwitchVirualLayout("ЙЦУКЕН", "Cyrillic")

		if !KbdLayoutReg.Check("hellenic", hellenicLayout)
			Options.SwitchVirualLayout("ϞϜΕΡΤΥ", "Hellenic")

		return
	}

	static Init() {
		for key, path in this.autoimport.OwnProps() {
			if !DirExist(path)
				DirCreate(path)
		}

		for script in this.layoutNames.Keys()
			for k, v in KbdLayoutReg.storedData[script]
				if !this.layoutNames[script].HasValue(k)
					this.layoutNames[script].Push(k)

		this.RebuilBinds()
	}


	static SetLayout(layout) {
		local types := KbdLayoutReg.storedData.Keys()
		local layoutType := ""

		for each in types {
			if KbdLayoutReg.storedData[each].Has(layout) {
				layoutType := StrTitle(each)
				break
			}
		}

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

		if KbdLayoutReg.storedData.Has(scriptType) {
			keys := KbdLayoutReg.storedData[scriptType].Keys()
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
		return
	}

	static GetCurrentLayoutMap() {
		layout := Map()
		this.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)

		latinLayout := KbdLayoutReg.Check("latin", latinLayout) ? latinLayout : "QWERTY"
		cyrillicLayout := KbdLayoutReg.Check("cyrillic", cyrillicLayout) ? cyrillicLayout : "ЙЦУКЕН"
		hellenicLayout := KbdLayoutReg.Check("hellenic", hellenicLayout) ? hellenicLayout : "ϞϜΕΡΤΥ"

		latinLayout := KbdLayoutReg.Get("latin", latinLayout)
		cyrillicLayout := KbdLayoutReg.Get("cyrillic", cyrillicLayout)
		hellenicLayout := KbdLayoutReg.Get("hellenic", hellenicLayout)

		for keySet in [latinLayout, cyrillicLayout, hellenicLayout] {
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
		local bindings := this.FormatBindings(bindingsMap)
		local processed := Map("mapping", Map(), "persistent", bindings["persistent"])

		for combo, value in bindings["mapping"] {
			local bind := value

			if bind is String && bind ~= "[`r`n`t]"
				bind := Util.FormatResult(bind)
			else if bind is Array && bind.Length > 0
				for i, item in bind
					if item is String && item ~= "[`r`n`t]"
						bind[i] := Util.FormatResult(item)
					else if bind[i] is Array && bind[i].Length > 0
						for j, childItem in bind[i]
							if childItem is String && childItem ~= "[`r`n`t]"
								bind[i][j] := Util.FormatResult(childItem)

			this.CompileBridge(combo, bind, processed["mapping"])
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
		KbdBinder.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)
		local layout := this.GetCurrentLayoutMap()
		local output := Map("mapping", Map(), "persistent", bindingsMap["persistent"].Clone())
		local restrictKeys := []

		if bindingsMap["mapping"].Count > 0 {
			for combo, binds in bindingsMap["mapping"] {
				if binds is String {
					local originalBinds := binds
					local processedBinds := binds
					local lastProcessed := ""

					while (RegExMatch(processedBinds, "(?s)(?<!\\)%([^%]+)%", &varExprMatch) && processedBinds != lastProcessed) {
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
							processedBinds := StrReplace(processedBinds, varExprMatch[0], "[Parse Error: " e.Message "]", , , 1)
						}
					}

					binds := processedBinds
				}

				local bindString := binds is String ? binds : (binds is Array && binds.Length == 1 && binds[1] is String ? binds[1] : "")

				if bindString != "" && !(bindString ~= "^@") {
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
									Locale.Read("error.at_binds_registration") "`n"
									Locale.ReadInject("error.invalid_variants_at_name", [variants.Length, maxVariants, bindString])
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
					(binds is String && RegExMatch(binds, "\[(.*?)\]", &match)) && !(match[1] ~= "^@") {
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
							interCombo := RegExReplace(interCombo, RegExEscape(keyLetter), scanCode)
							interCombo := RegExReplace(interCombo, "\[(.*?)\]", "$1")

							if rule = "Caps" || rule = "Flat"
								restrictKeys.Push(interCombo)

							if !output["mapping"].Has(interCombo) || isHellenicKey {
								try {
									output["mapping"].Set(interCombo,
										binds is String || binds is Func ? [binds] :
										rules[rule]
									)
								} catch as e {
									MsgBox "Error in Origin Combo: " combo "`n Combo: " interCombo "`n Rule: " rule "`n Error: " e.Message
								}
							} else if !restrictKeys.HasValue(interCombo) {
								if output["mapping"].Get(interCombo).Length == 2 {
									if output["mapping"][interCombo] is Func {
										interArr := [[], []]
										interArr[isCyrillicKey ? 1 : 2] := output["mapping"][interCombo]
										output["mapping"][interCombo] := interArr
									}
									output["mapping"][interCombo][isCyrillicKey ? 2 : 1] := binds

								} else {
									output["mapping"][interCombo].Push(binds)
								}
							}

							if output["persistent"].HasValue(combo, &persIndex)
								output["persistent"][persIndex] := interCombo
						}
					}
				}
			}
		}
		return output
	}

	static Registration(bindingsMap := Map(), rule := True, silent := False) {
		bindingsMap := this.CompileBinds(bindingsMap)
		total := bindingsMap["mapping"].Count
		useTooltip := Cfg.Get("Bind_Register_Tooltip_Progress_Bar", , True, "bool")
		comboActions := []

		if total > 0 {
			i := 0

			for combo, action in bindingsMap["mapping"] {
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
				local index := A_Index * 2 - 1
				local comboSeq := comboActions[index]
				local actionSeq := comboActions[index + 1]
				local isPersistent := bindingsMap["persistent"].HasValue(comboSeq)
				local options := [rule ? "On" : "Off", isPersistent ? "S" : ""]

				try {
					if comboSeq != ""
						HotKey(comboSeq, actionSeq, options.ToString(""))
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

		local useRemap := Cfg.Get("Layout_Remapping", , False, "bool")
		local checkDefaultLayouts := (latin != "QWERTY" || cyrillic != "ЙЦУКЕН")
		local isGlyphsVariationsOn := Scripter.selectedMode.Get("Glyph Variations") != ""
		local useRemap := (useRemap && checkDefaultLayouts) || isGlyphsVariationsOn
		local latinLayoutHasBinds := BindReg.Has(latin, "Layout Specified")
		local cyrillicLayoutHasBinds := BindReg.Has(cyrillic, "Layout Specified")

		local userBindings := Cfg.Get("Active_User_Bindings", , "None")
		local isUserBindingsOn := userBindings != "None" && Cfg.FastKeysOn
		local alternativeModeData := Scripter.GetCurrentModeData("Alternative Modes", &alternativeModeName)

		local alternativeModeBindings := []
		if alternativeModeData
			alternativeModeBindings := alternativeModeData["bindings"]


		if !ignoreUnregister || useRemap && alternativeModeData = "Hellenic"
			this.UnregisterAll()

		local preparedBindLists := []
		local rawBindLists := [
			useRemap && alternativeModeData != "Hellenic" ? "Keyboard Default" : "",
			Cfg.FastKeysOn ? "Common" : "",
			Cfg.FastKeysOver != "" && Cfg.FastKeysOn ? Cfg.FastKeysOver : "",
			latinLayoutHasBinds ? latin ":Layout Specified" : "",
			cyrillicLayoutHasBinds ? cyrillic ":Layout Specified" : "",
			isUserBindingsOn ? userBindings ":User" : "",
			"Important"
		]

		if alternativeModeData {
			for altBinding in alternativeModeBindings {
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


	static ToggleDefaultMode(typeofActivation := "") {
		isTOA := StrLen(typeofActivation) > 0
		modeActive := Cfg.Get("Mode_Fast_Keys" (isTOA ? "_Over" : ""), , isTOA ? "" : False, isTOA ? "" : "bool")

		modeActive := isTOA
			? (modeActive != typeofActivation ? typeofActivation : "")
			: !modeActive

		Cfg.Set(modeActive, "Mode_Fast_Keys" (isTOA ? "_Over" : ""), , isTOA ? "" : "bool")

		if typeofActivation = ""
			MsgBox(Locale.Read("messages.fastkeys_" (!modeActive ? "de" : "") "activated"), "FastKeys", 0x40)

		this.RebuilBinds()
	}

	static ToggleNumStyle(style := "Superscript", force := False) {
		this.numStyle := (style = this.numStyle && !force) ? "" : style
		this.Registration(BindList.Get(style " Digits"), force ? force : StrLen(this.numStyle) > 0)

		if StrLen(this.numStyle) == 0 {
			this.RebuilBinds()
		}
		return
	}

	static SetBinds(name := Locale.Read("dictionary.bindings_none")) {
		Cfg.Set(name = Locale.Read("dictionary.bindings_none") ? "None" : name, "Active_User_Bindings")
		this.RebuilBinds()
		return
	}
}