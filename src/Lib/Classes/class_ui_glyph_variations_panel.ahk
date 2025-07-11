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
			if entry["alterations"].Count > 0
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

		this.title := App.Title() " — " Locale.Read("gui.scripter.glyph_variations.gui_title")

		Constructor() {

			glyphsPanel := Gui()
			glyphsPanel.title := this.title
			glyphsPanel.OnEvent("Close", (*) => glyphsPanel.Destroy())

			glyphsColumns := ["key", "view", "entry_title"]
			for i, each in glyphsColumns
				glyphsColumns[i] := Locale.Read("dictionary." each)

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

		if WinExist(this.title) {
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

		Loop previewsCount
			glyphsPanel["SymbolPreview" A_Index].Text := ""

		entryName := LV.GetText(rowNumber, 3)
		entry := ChrLib.entries.%entryName%.Clone()
		entryAlts := {}

		for key, value in entry["alterations"]
			if !(key ~= "i)HTML$")
				entryAlts.%key% := value

		for i, each in order {
			if entryAlts.HasOwnProp(each) {
				local unicode := Util.UnicodeToChar(entryAlts.%each%)
				local code := entryAlts.%each%
				local fontFamily := Fonts.CompareByPair(code, "")
				code := Number("0x" code)
				local addition := ["combining", "modifier", "superscript", "subscript"].HasValue(each) && !(code >= 0x1E000 && code <= 0x1E02F) ? DottedCircle : ""

				glyphsPanel["SymbolPreview" i].Text := (addition) unicode
				glyphsPanel["SymbolPreview" i].SetFont("s" (42), (fontFamily))
			}
		}
	}
}