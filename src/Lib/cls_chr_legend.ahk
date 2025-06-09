Class ChrLegend {
	static legendsPath := App.paths.loc "\CharacterLegend\"
	static legends := Map()
	static panelGUI := Gui()
	static title := ""

	static bracketPresets := Map(
		"Ornate", [Chr(0xFD3E), Chr(0xFD3F)],
	)

	static __New() {
		this.Init()
	}

	static Init() {
		Loop Files this.legendsPath "*", "FR" {
			if A_LoopFileFullPath ~= "i)\.ini$" {
				name := RegExReplace(A_LoopFileName, "\.ini$")
				filePath := RegExReplace(RegExReplace(A_LoopFileFullPath, RegExEscape(this.legendsPath)), "\.ini$")
				this.legends.Set(name, filePath)
			}
		}

		for name, path in this.legends
			if ChrLib.entries.HasOwnProp(name)
				ChrLib.entries.%name%.options.legend := path
	}

	__New(preselectEntry := "") {
		ChrLegend.Panel(preselectEntry)
	}

	static Panel(preselectEntry := "") {
		legendsList := this.CollectList()
		nameToEntry := Map()

		languageCode := Language.Get()

		for each in legendsList {
			if each is String {
				nameToEntry.Set(this.SetTreeTitle(each, languageCode), each)
			} else if each is Map {
				for k, v in each {
					nameToEntry.Set(Chr(0x269C) " " Locale.Read("symbol_" k), "")

					for child in v
						nameToEntry.Set(this.SetTreeTitle(child, languageCode), child)
				}
			}
		}

		labels := {
			unknown: Locale.Read("gui_legend_unknown"),
			uniTitle: Locale.Read("gui_legend_unicode"),
			altTitles: Locale.Read("gui_legend_alts"),
			languages: Locale.Read("gui_legend_languages"),
			description: Locale.Read("gui_legend_description_unavailable"),
			author: Locale.Read("gui_legend_author"),
			authorLink: Locale.Read("gui_legend_author_default"),
			entry: Locale.Read("gui_legend_entry"),
			unicode: Locale.Read("preview_unicode"),
			html: Locale.Read("preview_html"),
		}

		panelW := 1300
		panelH := 700

		posX := (A_ScreenWidth - panelW) / 2
		posY := (A_ScreenHeight - panelH) / 2

		treeW := 300
		treeH := panelH - 20
		treeX := 10
		treeY := 10

		groupBoxW := panelW - treeW - 40
		groupBoxH := panelH - 15
		groupBoxX := treeW + 25
		groupBoxY := 5

		previewW := 192
		previewH := 192
		previewX := groupBoxX + 25
		previewY := groupBoxY + 25 + 5

		chrTitleX := previewX + previewW + 25
		chrTitleY := groupBoxY + 25
		chrTitleW := panelW - chrTitleX - 35
		chrTitleH := 48

		defShiftY := 5

		uniTitleX := previewX + previewW + 25
		uniTitleY := chrTitleY + chrTitleH + defShiftY
		uniTitleW := chrTitleW
		uniTitleH := 24

		uniTitleContentX := previewX + previewW + 25
		uniTitleContentY := uniTitleY + uniTitleH - defShiftY
		uniTitleContentW := chrTitleW
		uniTitleContentH := 24

		altTitlesX := uniTitleX
		altTitlesY := uniTitleContentY + uniTitleContentH + defShiftY
		altTitlesW := chrTitleW
		altTitlesH := 24

		altTitlesContentX := uniTitleContentX
		altTitlesContentY := altTitlesY + altTitlesH - defShiftY
		altTitlesContentW := chrTitleW
		altTitlesContentH := 24

		languagesX := uniTitleX
		languagesY := altTitlesContentY + altTitlesContentH + defShiftY
		languagesW := chrTitleW
		languagesH := 24

		languagesContentX := uniTitleContentX
		languagesContentY := languagesY + languagesH - defShiftY
		languagesContentW := chrTitleW
		languagesContentH := 24

		descriptionX := groupBoxX + 25
		descriptionY := previewY + previewH + 25
		descriptionW := 192 * 2.5
		descriptionH := groupBoxH - descriptionY - 25

		tabList := [
			Locale.ReadMulti("gui_legend_ipa", "and", "gui_legend_transcription"),
			Locale.Read("gui_legend_names"),
			Locale.Read("gui_legend_data"),
		]

		tabsX := descriptionX + descriptionW + 10
		tabsY := descriptionY
		tabsW := panelW - tabsX - 25
		tabsH := descriptionH

		authorLabelLen := StrLen(labels.author)
		authorW := (authorLabelLen * (Language.Get() ~= "^en" ? 7 : 9))
		authorH := 24
		authorX := groupBoxX + 25
		authorY := groupBoxH - authorH

		authorLinkX := authorX + authorW + 10
		authorLinkY := authorY
		authorLinkW := groupBoxW - authorLinkX - 15
		authorLinkH := authorH

		opts := {
			TV: Format("vTV w{} h{} x{} y{}", treeW, treeH, treeX, treeY),
			GB: Format("vGB w{} h{} x{} y{}", groupBoxW, groupBoxH, groupBoxX, groupBoxY),
			PV: Format("vPV w{} h{} x{} y{} ReadOnly Center -VScroll -HScroll", previewW, previewH, previewX, previewY),
			chrTitle: Format("vTitle w{} h{} x{} y{}", chrTitleW, chrTitleH, chrTitleX, chrTitleY),
			uniTitle: Format("vUnicodeTitle w{} h{} x{} y{}", uniTitleW, uniTitleH, uniTitleX, uniTitleY),
			uniTitleContent: Format("vUnicodeTitleContent w{} h{} x{} y{} ReadOnly -VScroll -HScroll -E0x200", uniTitleContentW, uniTitleContentH, uniTitleContentX, uniTitleContentY),
			altTitles: Format("vAltTitles w{} h{} x{} y{}", altTitlesW, altTitlesH, altTitlesX, altTitlesY),
			altTitlesContent: Format("vAltTitlesContent w{} h{} x{} y{} ReadOnly -VScroll -HScroll -E0x200", altTitlesContentW, altTitlesContentH, altTitlesContentX, altTitlesContentY),
			languages: Format("vLanguages w{} h{} x{} y{}", languagesW, languagesH, languagesX, languagesY),
			languagesContent: Format("vLanguagesContent w{} h{} x{} y{} ReadOnly -VScroll -HScroll -E0x200", languagesContentW, languagesContentH, languagesContentX, languagesContentY),
			description: Format("vDescription w{} h{} x{} y{} ReadOnly +Multi +Wrap -HScroll -E0x200", descriptionW, descriptionH, descriptionX, descriptionY),
			tabs: Format("vTabs w{} h{} x{} y{}", tabsW, tabsH, tabsX, tabsY),
			author: Format("vAuthor w{} h{} x{} y{}", authorW, authorH, authorX, authorY),
			authorLink: Format("vAuthorLink w{} h{} x{} y{}", authorLinkW, authorLinkH, authorLinkX, authorLinkY),
		}
		lvHeaders := [
			Locale.Read("gui_legend_language"),
			Locale.Read("gui_legend_value"),
		]

		ipaLVW := tabsW - 25
		ipaLVH := tabsH - 45
		ipaLVX := tabsX + Floor((tabsW - ipaLVW) / 2)
		ipaLVY := tabsY + 35
		colW := [Floor(ipaLVW * 0.6) - 3, ipaLVW - (Floor(ipaLVW * 0.6) - 3) - 6]

		defDataH := 28

		entryW := tabsW - 25
		entryH := 18
		entryX := tabsX + Floor((tabsW - entryW) / 2)
		entryY := tabsY + 35
		entryContentW := entryW
		entryContentH := defDataH
		entryContentX := tabsX + Floor((tabsW - entryContentW) / 2)
		entryContentY := entryY + entryH

		unicodeW := entryW
		unicodeH := entryH
		unicodeX := tabsX + Floor((tabsW - unicodeW) / 2)
		unicodeY := entryContentY + entryContentH + defShiftY
		unicodeContentW := unicodeW
		unicodeContentH := defDataH
		unicodeContentX := tabsX + Floor((tabsW - unicodeContentW) / 2)
		unicodeContentY := unicodeY + unicodeH

		htmlW := entryW
		htmlH := entryH
		htmlX := tabsX + Floor((tabsW - htmlW) / 2)
		htmlY := unicodeContentY + unicodeContentH + defShiftY

		gap := 2
		totalGap := 2 * gap
		htmlContentDecW := Floor((htmlW - totalGap) / 3)
		htmlContentHexW := Floor((htmlW - totalGap) / 3)
		htmlContentEntW := htmlW - htmlContentDecW - htmlContentHexW - totalGap

		htmlContentDecH := defDataH
		htmlContentHexH := defDataH
		htmlContentEntH := defDataH

		totalHtmlContentW := htmlContentDecW + htmlContentHexW + htmlContentEntW + totalGap
		startX := tabsX + Floor((tabsW - totalHtmlContentW) / 2)

		htmlContentDecX := startX
		htmlContentHexX := htmlContentDecX + htmlContentDecW + gap
		htmlContentEntX := htmlContentHexX + htmlContentHexW + gap

		htmlContentDecY := htmlY + htmlH
		htmlContentHexY := htmlContentDecY
		htmlContentEntY := htmlContentDecY

		tabOpts := {
			ipa: {
				lv: Format("vIPA_LV w{} h{} x{} y{} +NoSort -Multi -Hdr",
					ipaLVW,
					(ipaLVH // 2) - gap,
					ipaLVX,
					ipaLVY
				),
			},
			trans: {
				lv: Format("vTrans_LV w{} h{} x{} y{} +NoSort -Multi -Hdr",
					ipaLVW,
					ipaLVH // 2,
					ipaLVX,
					ipaLVY + (ipaLVH // 2) + gap
				),
			},
			names: {
				lv: Format("vNames_LV w{} h{} x{} y{} +NoSort -Multi", ipaLVW, ipaLVH, ipaLVX, ipaLVY),
			},
			data: {
				entry: Format("vEntry w{} h{} x{} y{}", entryW, entryH, entryX, entryY),
				entryContent: Format("vEntryContent w{} h{} x{} y{} Center ReadOnly -VScroll -HScroll", entryContentW, entryContentH, entryContentX, entryContentY),
				unicode: Format("vUnicode w{} h{} x{} y{}", unicodeW, unicodeH, unicodeX, unicodeY),
				unicodeContent: Format("vUnicodeContent w{} h{} x{} y{} Center ReadOnly -VScroll -HScroll", unicodeContentW, unicodeContentH, unicodeContentX, unicodeContentY),
				html: Format("vHTML w{} h{} x{} y{}", htmlW, htmlH, htmlX, htmlY),
				htmlContentDec: Format("vHTMLContentDec w{} h{} x{} y{} Center ReadOnly -VScroll -HScroll", htmlContentDecW, htmlContentDecH, htmlContentDecX, htmlContentDecY),
				htmlContentHex: Format("vHTMLContentHex w{} h{} x{} y{} Center ReadOnly -VScroll -HScroll", htmlContentHexW, htmlContentHexH, htmlContentHexX, htmlContentHexY),
				htmlContentEnt: Format("vHTMLContentEnt w{} h{} x{} y{} Center ReadOnly -VScroll -HScroll", htmlContentEntW, htmlContentEntH, htmlContentEntX, htmlContentEntY),
			},
		}

		this.title := App.Title("+status+version") " — " Locale.Read("gui_legend")
		Constructor() {
			legendPanel := Gui()
			legendPanel.title := this.title

			tabs := legendPanel.AddTab3(opts.tabs, tabList)
			tabs.UseTab(1)

			ipaLV := legendPanel.AddListView(tabOpts.ipa.lv, lvHeaders)

			transLV := legendPanel.AddListView(tabOpts.trans.lv, lvHeaders)

			tabs.UseTab(2)

			namesLV := legendPanel.AddListView(tabOpts.names.lv, lvHeaders)

			tabs.UseTab(3)

			entry := legendPanel.AddText(tabOpts.data.entry, labels.entry)
			entry.SetFont("s" (11) " c333333 bold")
			entryContent := legendPanel.AddEdit(tabOpts.data.entryContent, labels.unknown)
			entryContent.SetFont("s" (11) " c333333")

			unicode := legendPanel.AddText(tabOpts.data.unicode, labels.unicode)
			unicode.SetFont("s" (11) " c333333 bold")
			unicodeContent := legendPanel.AddEdit(tabOpts.data.unicodeContent, "0000")
			unicodeContent.SetFont("s" (11) " c333333")

			html := legendPanel.AddText(tabOpts.data.html, labels.html)
			html.SetFont("s" (11) " c333333 bold")
			htmlContentDec := legendPanel.AddEdit(tabOpts.data.htmlContentDec, "&#0;")
			htmlContentDec.SetFont("s" (11) " c333333")
			htmlContentHex := legendPanel.AddEdit(tabOpts.data.htmlContentHex, "&#x0000;")
			htmlContentHex.SetFont("s" (11) " c333333")
			htmlContentEnt := legendPanel.AddEdit(tabOpts.data.htmlContentEnt, labels.unknown)
			htmlContentEnt.SetFont("s" (11) " c333333")

			tabs.UseTab()

			TV := legendPanel.AddTreeView(opts.TV)
			TV.SetFont("s" (11) " c333333", Fonts.fontFaces["Default"].name)

			for each in legendsList {
				if each is String {
					TV.Add(this.SetTreeTitle(each, languageCode))
				} else if each is Map {
					for k, v in each {
						parent := TV.Add(Chr(0x269C) " " Locale.Read("symbol_" k))

						for child in v
							TV.Add(this.SetTreeTitle(child, languageCode), parent)
					}
				}
			}

			TV.OnEvent("ItemSelect", (TV, Item) => this.PanelSelect(TV, item, nameToEntry))

			for each in [ipaLV, transLV, namesLV] {
				each.SetFont("s" (11) " c333333")
				Loop lvHeaders.Length {
					index := A_Index
					each.ModifyCol(index, colW[index])
				}
			}

			GB := legendPanel.AddGroupBox(opts.GB)

			PV := legendPanel.AddEdit(opts.PV, Chr(0x25CC))
			PV.SetFont("s" (70 * 1.5) " c333333", Fonts.fontFaces["Default"].name)

			chrTitle := legendPanel.AddText(opts.chrTitle, labels.unknown)
			chrTitle.SetFont("s" (24) " c333333", Fonts.fontFaces["Default"].name)

			uniTitle := legendPanel.AddText(opts.uniTitle, labels.uniTitle)
			uniTitle.SetFont("s" (11) " c333333 bold")

			uniTitleContent := legendPanel.AddEdit(opts.uniTitleContent, labels.unknown)
			uniTitleContent.SetFont("s" (11) " c333333")

			altTitles := legendPanel.AddText(opts.altTitles, labels.altTitles)
			altTitles.SetFont("s" (11) " c333333 bold")

			altTitlesContent := legendPanel.AddEdit(opts.altTitlesContent, labels.unknown)
			altTitlesContent.SetFont("s" (11) " c333333")

			languages := legendPanel.AddText(opts.languages, labels.languages)
			languages.SetFont("s" (11) " c333333 bold")

			languagesContent := legendPanel.AddEdit(opts.languagesContent, labels.unknown)
			languagesContent.SetFont("s" (11) " c333333")

			description := legendPanel.AddEdit(opts.description, labels.description)
			description.SetFont("s" (10) " c333333")

			author := legendPanel.AddText(opts.author, labels.author)
			author.SetFont("s" (11) " c333333 bold")
			authorLink := legendPanel.AddLink(opts.authorLink, labels.authorLink)
			authorLink.SetFont("s" (11) " c333333")


			legendPanel.Show(Format("w{} h{} x{} y{}", panelW, panelH, posX, posY))
			return legendPanel
		}


		if IsGuiOpen(this.title) {
			WinActivate(this.title)
		} else {
			this.panelGUI := Constructor()
			this.panelGUI.Show()
		}

		this.PanelAftermath(preselectEntry, nameToEntry)
	}

	static PanelAftermath(preselectEntry, nameToEntry) {
		TV := this.panelGUI["TV"]
		if preselectEntry = ""
			TV.Focus()

		if IsGuiOpen(this.title) && preselectEntry != "" {
		}


		if preselectEntry != "" {
			label := ""
			for k, v in nameToEntry {
				if preselectEntry = v {
					label := k
					break
				}
			}


			itemID := 0
			Loop {
				itemID := TV.GetNext(itemID, "Full")
				if !itemID
					break

				itemText := TV.GetText(itemID)
				if itemText = label {
					TV.Modify(itemID)
					this.PanelSelect(TV, itemID, nameToEntry)
					break
				}
			}
		}
	}

	static PanelSelect(TV, item, nameToEntry) {
		if !item
			return

		if IsGuiOpen(this.title) {
			selectedLabel := TV.GetText(item)

			if nameToEntry.Has(selectedLabel) && nameToEntry.GetRef(selectedLabel, &entryName) != "" {
				labels := {
					unknown: Locale.Read("gui_legend_unknown"),
					description: Locale.Read("gui_legend_description_unavailable"),
					authorLink: Locale.Read("gui_legend_author_default"),
				}

				languageCode := Language.Get()
				legendEntry := this.ReadLegend(this.legends.Get(entryName) ".ini")
				legendEntryL := legendEntry.%languageCode%

				entry := ChrLib.GetEntry(entryName)
				previewSymbol := StrLen(entry.symbol.alt) > 0 ? entry.symbol.alt : entry.symbol.set
				getChar := Util.UnicodeToChar(entry.sequence.Length > 0 ? entry.sequence : entry.unicode)

				legendPanel := this.panelGUI
				PV := legendPanel["PV"]
				PV.Text := previewSymbol != "" ? previewSymbol : Chr(0x25CC)

				chrTitle := legendPanel["Title"]
				chrTitle.Text := legendEntryL.HasOwnProp("title") && legendEntryL.title != "" ? legendEntryL.title : selectedLabel

				chrTitle.SetFont(
					StrLen(entry.symbol.customs) > 0 ? entry.symbol.customs : ("s" (24) " norm c333333"),
					StrLen(entry.symbol.font) > 0 ? entry.symbol.font : Fonts.fontFaces["Default"].name
				)

				uniTitleContent := legendPanel["UnicodeTitleContent"]
				uniTitleContent.Text := legendEntry.legend.HasOwnProp("unicode_name") && legendEntry.legend.unicode_name != "" ? legendEntry.legend.unicode_name : labels.unknown

				altTitlesContent := legendPanel["AltTitlesContent"]
				altTitlesContent.Text := legendEntryL.HasOwnProp("alts") && legendEntryL.alts != "" ? legendEntryL.alts : labels.unknown

				languagesContent := legendPanel["LanguagesContent"]
				languagesContent.Text := legendEntryL.HasOwnProp("languages") && legendEntryL.languages != "" ? legendEntryL.languages : labels.unknown

				description := legendPanel["Description"]
				description.Text := legendEntryL.HasOwnProp("description") && legendEntryL.description != "" ? Locale.HandleString(legendEntryL.description) : labels.description

				authorLink := legendPanel["AuthorLink"]
				authorLink.Text := legendEntryL.HasOwnProp("author") && legendEntryL.author != "" ? legendEntryL.author : labels.authorLink

				entryContent := legendPanel["EntryContent"]
				entryContent.Text := entryName

				unicodeContent := legendPanel["UnicodeContent"]
				unicodeContent.Text := entry.sequence.Length > 0 ? entry.sequence.ToString(" ") : entry.unicode

				htmlContentDec := legendPanel["HTMLContentDec"]
				htmlContentDec.Text := Util.StrToHTML(getChar)

				htmlContentHex := legendPanel["HTMLContentHex"]
				htmlContentHex.Text := Util.StrToHTML(getChar, "Hex")

				htmlContentEnt := legendPanel["HTMLContentEnt"]
				htmlContentEnt.Text := entry.entity != "" ? entry.entity : labels.unknown

				ipaLV := legendPanel["IPA_LV"]
				transLV := legendPanel["Trans_LV"]
				namesLV := legendPanel["Names_LV"]

				ipaLV.Delete()
				transLV.Delete()
				namesLV.Delete()

				ipaArray := this.ParseIPA(legendEntryL.HasOwnProp("ipa") && legendEntryL.ipa != "" ? legendEntryL.ipa : "")
				transArray := this.ParseIPA(legendEntryL.HasOwnProp("transcription") && legendEntryL.transcription != "" ? legendEntryL.transcription : "")
				namesArray := this.ParseIPA(legendEntryL.HasOwnProp("names") && legendEntryL.names != "" ? legendEntryL.names : "")

				for each in ["ipa", "trans", "names"] {
					if %each%Array.Length > 0 {
						for i, _ in %each%Array {
							if Mod(i, 2) = 1 {
								%each%LV.Add(, %each%Array[i], %each%Array[i + 1])
							}
						}
					}
				}
			}
		}
	}

	static ReadLegend(path) {
		legend := Util.INIToObj(this.legendsPath path)
		return legend
	}

	static ParseIPA(str) {
		output := []
		while pos := RegExMatch(str, "\[([^\[\]:]*)::((?:[^\[\]]|\[[^\]]*\])*)\]", &match) {
			output.Push(match[1], match[2])
			str := SubStr(str, 1, pos - 1) SubStr(str, pos + match.Len)
		}
		return output
	}

	static SetTreeTitle(item, languageCode) {
		title := IniRead(this.legendsPath this.legends.Get(item) ".ini", languageCode, "title", item)

		postfix := IniRead(this.legendsPath this.legends.Get(item) ".ini", "legend", "postfix", "")
		postfix := postfix != "" ? Chr(0x2002) this.SetBracketStyle(postfix) : ""

		prefix := IniRead(this.legendsPath this.legends.Get(item) ".ini", "legend", "prefix", "")
		prefix := prefix != "" ? this.SetBracketStyle(prefix) Chr(0x2002) : ""

		title := prefix title postfix

		return title
	}

	static SetBracketStyle(str) {
		if str = ""
			return str

		if RegExMatch(str, "\:\:(.*?)$", &bracketStyleMatch) {
			str := regexReplace(str, "\:\:(.*?)$")
			space := Chr(0x20)
			bracketStyle := bracketStyleMatch[1]

			if RegExMatch(bracketStyle, "\[(.*?)\]", &spaceMatch) {
				bracketStyle := RegExReplace(bracketStyle, "\[(.*?)\]", "")
				space := spaceMatch[1]
			}

			if space ~= "i)^U\+[a-fA-F0-9]+$"
				space := Chr("0x" SubStr(space, 3))

			if this.bracketPresets.Has(bracketStyle) {
				brackets := this.bracketPresets.Get(bracketStyle)
				str := Util.StrWrap(str Chr(0x200B), brackets, space)
			}
		}
		return str
	}

	static CollectList() {
		indexed := Map()
		output := []
		toRemove := []

		for name, path in this.legends
			if ChrLib.entries.HasOwnProp(name)
				indexed.Set(ChrLib.entries.%name%.index, name)

		for i, name in indexed {
			group := IniRead(this.legendsPath this.legends.Get(name) ".ini", "legend", "group", "")
			if group != "" {
				if !toRemove.HasValue(group)
					toRemove.Push(group)

				if !output.HasValue(group)
					output.Push(group, Map(group, [name]))
				else if output.HasValue(group, &j)
					output[j + 1][group].Push(name)
			} else
				output.Push(name)
		}

		for i, each in output
			if toRemove.HasValue(each)
				output.RemoveAt(i)

		return output
	}
}