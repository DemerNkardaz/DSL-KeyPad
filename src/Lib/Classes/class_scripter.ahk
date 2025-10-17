Class Scripter {
	static selectorGUI := Map("Alternative Modes", Gui(), "Glyph Variations", Gui(), "TELEX", Gui())
	static selectorTitle := Map("Alternative Modes", "", "Glyph Variations", "", "TELEX", "")
	static selectedMode := Map("Alternative Modes", "", "Glyph Variations", "", "TELEX", "")
	static activatedViaMonitor := False

	Class Events {
		static __New() {
			Event.OnEvent("Scripter", "On Option Selected", (name, selectorType, terminated) => this.DisableAttachedGlyphsMode(name, selectorType, terminated))
			return
		}

		static DisableAttachedGlyphsMode(name, selectorType, terminated) {
			if (terminated && selectorType = "Alternative Modes")
				&& Scripter.GetCurrentModeData("Glyph Variations", &name, &data)
				&& data.Has("attached_to_alternative_mode")
				&& data["attached_to_alternative_mode"] {
				Scripter.ToggleSelectedOption(name, "Glyph Variations", True)
			}
			return
		}
	}

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

		if Cfg.Get("Scripter_Selector_Use_Number_Keys", "UI", "False", "bool") {
			keyCodes.InsertAt(1,
				"SC029",
				"SC002",
				"SC003",
				"SC004",
				"SC005",
				"SC006",
				"SC007",
				"SC008",
				"SC009",
				"SC00A",
				"SC00B",
				"SC00C",
				"SC00D",
			)
		}

		local hotkeys := Map()
		local keys := keyCodes.Clone()
		local keysLen := keys.Length
		KbdBinder.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)

		Loop keysLen
			keys.Push("", "")

		for keyName, keyCode in KbdLayoutReg.storedData["latin"][latinLayout]
			keyCodes.HasValue(keyCode, &i) && (keys[i] := keyName)
		for keyName, keyCode in KbdLayoutReg.storedData["cyrillic"][cyrillicLayout]
			keyCodes.HasValue(keyCode, &i) && (keys[keysLen + i] := keyName)
		for keyName, keyCode in KbdLayoutReg.storedData["hellenic"][hellenicLayout]
			keyCodes.HasValue(keyCode, &i) && (keys[keysLen * 2 + i] := keyName)

		for key, value in keySymbols
			keys.HasValue(key, &i) && (keys[i] := value)

		local prevAltMode := this.selectedMode.Get(selectorType)
		local titles := Map(
			"Alternative Modes", "gui.scripter.alternative_mode",
			"Glyph Variations", "gui.scripter.glyph_variations",
			"TELEX", "telex_script_processor",
		)
		this.selectorTitle.Set(selectorType, App.Title("+status+version") " — " Locale.Read(titles.Get(selectorType)))

		Constructor() {
			local maxItems := Cfg.Get("Scripter_Selector_Max_Items" (isGlyphs ? "_Glyph" : ""), "UI", (isGlyphs ? 32 : 24), "int")
			local maxColumns := Cfg.Get("Scripter_Selector_Max_Columns", "UI", 4, "int")
			local maxColumnsThreshold := Cfg.Get("Scripter_Selector_Max_Columns_Threshold" (isGlyphs ? "_Glyph" : ""), "UI", (isGlyphs ? 32 : 24), "int")

			maxItems := Min(Max(1, maxItems), keysLen)

			local selectorPanel := Gui()
			selectorPanel.OnEvent("Close", (Obj) => this.PanelDestroy(selectorType))
			selectorPanel.title := this.selectorTitle.Get(selectorType)

			local visibleItems := []
			for i, pairs in ScripterStore.storedData[selectorType] {
				if Mod(i, 2) = 1 {
					local dataName := ScripterStore.storedData[selectorType][i]
					local dataValue := ScripterStore.storedData[selectorType][i + 1]

					if !dataValue.Has("hidden") || !dataValue["hidden"] {
						visibleItems.Push({ name: dataName, value: dataValue, originalIndex: i })
					}
				}
			}

			local totalItems := visibleItems.Length
			local totalPages := Ceil(totalItems / maxItems)

			if currentPage > totalPages
				currentPage := totalPages

			selectorPanel.title .= Chr(0x2003) "::" Chr(0x2003) Locale.ReadInject("dynamic_dictionary.page_of", [currentPage, totalPages]) " " Locale.Read("gui.scripter.pages_help")

			local startIndex := (currentPage - 1) * maxItems + 1
			local pageItems := Min(maxItems, totalItems - startIndex + 1)

			local widthDefault := 256
			local heightDefault := 256

			local itemsPerRow := pageItems > maxColumnsThreshold && !isGlyphs ? maxColumns : 3
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

			Loop pageItems {
				local itemIndex := startIndex + A_Index - 1
				if itemIndex <= visibleItems.Length {
					local item := visibleItems[itemIndex]
					AddOption(item.name, item.value, A_Index)
				}
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
					this.ToggleSelectedOption(dataName, selectorType)
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

				local optionTitle := selectorPanel.AddText(Format("v{}Title w{} h{} x{} y{} 0x80 +BackgroundTrans", dataValue["uiid"], optionTitleW, optionTitleH, optionTitleX, optionTitleY), Locale.Read("script_labels." dataValue["locale"]))
				optionTitle.SetFont("s10 c333333 Bold", "Segoe UI")

				local scriptPreviewXOffset := dataValue.Has("preview_offset") && dataValue["preview_offset"].Has("X") ?
					(optionTitleX + dataValue["preview_offset"]["X"])
					: optionTitleX
				local scriptPreviewYOffset := dataValue.Has("preview_offset") && dataValue["preview_offset"].Has("Y") ?
					(optionTitleY + dataValue["preview_offset"]["Y"])
					: optionTitleY

				local scriptPreviewX := scriptPreviewXOffset
				local scriptPreviewY := scriptPreviewYOffset + optionTitleH - 2

				for i, previewText in dataValue["preview"] {
					local pt := selectorPanel.AddText(Format("v{}Preview{} w{} h{} x{} y{} 0x80 +BackgroundTrans", dataValue["uiid"], i, optionTitleW, optionTitleH, scriptPreviewX, scriptPreviewY), previewText)
					pt.SetFont(Format("s{} c333333", (dataValue.Has("font_size") ? dataValue["font_size"] : (isGlyphs && dataName != "fullwidth" ? 12 : 10))), dataValue["fonts"].length > 0 ? dataValue["fonts"][dataValue["fonts"].length > 1 ? i : 1] : "Segoe UI")

					scriptPreviewY += optionTitleH - 5
				}

				local pressKeys := [
					keys[j],
					keys[keyCodes.Length + j],
					keys[keyCodes.Length * 2 + j],
				]

				local visiblePressKeys := ""

				for i, each in pressKeys {
					hotkeys.Set(each, dataName)

					if !InStr(visiblePressKeys, each) {
						if (visiblePressKeys != "")
							visiblePressKeys .= " / "
						visiblePressKeys .= each
					}
				}

				local hotkeysLabel := selectorPanel.AddText(
					"v" dataValue["uiid"] "Hotkey w" optionTitleW " h" optionTitleH " x" optionTitleX " y" ((optionY + optionH) - optionTitleH)
					" 0x80 Right +BackgroundTrans",
					Locale.ReadInject("dynamic_dictionary.press", [visiblePressKeys])
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

	static ToggleSelectedOption(name, selectorType := "Alternative Modes", ignoreRebuild := False) {
		local currentTSP := TelexScriptProcessor.GetActiveMode()
		local curreltAlternative := this.GetCurrentMode("Alternative Modes")

		if name != "" {
			local currentMode := this.selectedMode.Get(selectorType)

			if selectorType = "Alternative Modes" && currentTSP {
				WarningISP(name, currentTSP, selectorType)
				return
			}

			if selectorType = "TELEX"
				globalInstances.scriptProcessors[name].Start()

			if curreltAlternative && selectorType = "TELEX"
				return

			this.selectedMode.Set(selectorType, currentMode != name ? name : "")
		}

		local altMode := this.selectedMode.Get(selectorType)
		local terminated := altMode = ""

		Event.Trigger("Scripter", "On Option Selected", name, selectorType, terminated)
		if !ignoreRebuild && selectorType != "TELEX"
			KbdBinder.RebuildBinds(, altMode != "")

		WarningISP(name, currentISP, selectorType) {
			local instanceRef := currentISP != "" ? globalInstances.scriptProcessors[currentISP] : False
			local nameTitle := Locale.Read("script_labels." this.GetModeData(selectorType, name)["locale"])
			local TSPTitle := Locale.Read("telex_script_processor.labels." instanceRef.tag)
			MsgBox(Locale.ReadInject("gui.scripter.alternative_mode.warnings.incompatible_with_telex", [nameTitle, TSPTitle]), App.Title(), "Icon!")
			return
		}

		return
	}

	static isScripterWaiting := False
	static WaitForKey(hotkeys, selectorType) {
		this.isScripterWaiting := True
		local currentMode := this.selectedMode.Get(selectorType)
		local useRemap := Cfg.Get("Layout_Remapping", , False, "bool")

		if !useRemap && currentMode != "Hellenic" && Keyboard.activeLanguage != "el-GR"
			Suspend(1)
		else if Keyboard.activeLanguage = "el-GR" && currentMode != "Hellenic"
			KbdBinder.Registration(BindList.Get("Hellenic", "Script Specified"), True, True)
		else if useRemap && currentMode != "Hellenic"
			KbdBinder.Registration(BindList.Get("Keyboard Default"), True, True)

		local fKeys := ""
		Loop 12
			fKeys .= "{F" A_Index "}"

		local IH := InputHook("L1 M", fKeys "{Space}")
		IH.OnEnd := OnEnd
		IH.Start()
		SetTimer(WaitCheckGUI, 50)

		WaitCheckGUI() {
			if !WinExist(this.selectorTitle.Get(selectorType)) {
				IH.Stop()
				this.isScripterWaiting := False
				if !(KbdMonitor.Disabled())
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
			} else if currentMode != "" && (IH.EndKey = "Space" || IH.Input = " ") {
				this.HandleWaiting(IH.EndKey, hotkeys, selectorType, currentMode)
				return
			}
			this.HandleWaiting(StrUpper(IH.Input), hotkeys, selectorType)
		}
	}

	static HandleWaiting(endKey, hotkeys, selectorType, currentMode?) {
		local isSpaceKey := ["Space", " "].HasValue(endKey)

		this.PanelDestroy(selectorType)
		if endKey != "" && (hotkeys.Has(endKey) || isSpaceKey) {
			this.activatedViaMonitor := False
			this.ToggleSelectedOption(isSpaceKey && currentMode != "" ? currentMode : hotkeys.Get(endKey), selectorType)
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

	static GetModeData(modeType := "Alternative Modes", name := "Germanic runes & Glagolitic") {
		if ScripterStore.Has(modeType, name)
			return ScripterStore.Get(modeType, name)
		return False
	}

	static GetCurrentMode(modeType := "Alternative Modes") {
		local name := this.selectedMode.Get(modeType)
		if name = ""
			return False
		return name
	}

	static GetCurrentModeData(modeType := "Alternative Modes", &name := "", &data := Map()) {
		name := this.GetCurrentMode(modeType)
		if !name
			return False
		data := ScripterStore.Get(modeType, name)
		return data
	}

}