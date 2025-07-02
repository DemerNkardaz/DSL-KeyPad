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

		KbdBinder.RebuilBinds(, altMode != "")

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
			KbdBinder.Registration(BindList.Get("Hellenic", "Script Specified"), True, True)
		else if useRemap && currentMode != "Hellenic"
			KbdBinder.Registration(BindList.Get("Keyboard Default"), True, True)

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
				if !(KbdBinder.disabledByMonitor || KbdBinder.disabledByUser)
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