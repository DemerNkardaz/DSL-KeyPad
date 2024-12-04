Class Panel {

	static UISets := {
		infoBox: {
			body: "x650 y35 w200 h510",
			bodyText: Locale.Read("character"),
			previewFrame: "x685 y80 w128 h128 Center",
			preview: "x685 y80 w128 h128 readonly Center -VScroll -HScroll",
			previewText: "◌͏",
			title: "x655 y215 w190 h150 Center BackgroundTrans",
			titleText: "N/A",
			LaTeXTitleA: "x689 y371 w128 h24 BackgroundTrans",
			LaTeXTitleAText: "A",
			LaTeXTitleE: "x703 y375 w128 h24 BackgroundTrans",
			LaTeXTitleEText: "E",
			LaTeXTitleLTX: "x685 y373 w128 h24 BackgroundTrans",
			LaTeXTitleLTXText: "L T  X",
			LaTeXPackage: "x685 y373 w128 h24 BackgroundTrans Right",
			LaTeXPackageText: "",
			LaTeX: "x685 y390 w128 h24 readonly Center -VScroll -HScroll",
			LaTeXText: "N/A",
			alt: "x685 y430 w128 h24 readonly Center -VScroll -HScroll",
			altTitle: "x685 y415 w128 h24 BackgroundTrans",
			altTitleText: Map("ru", "Альт-код", "en", "Alt-code"),
			altText: "N/A",
			unicode: "x685 y470 w128 h24 readonly Center -VScroll -HScroll",
			unicodeTitle: "x685 y455 w128 h24 BackgroundTrans",
			unicodeTitleText: Map("ru", "Юникод", "en", "Unicode"),
			unicodeText: "U+0000",
			html: "x685 y510 w128 h24 readonly Center -VScroll -HScroll",
			htmlText: "&#x0000;",
			htmlTitle: "x685 y495 w128 h24 BackgroundTrans",
			htmlTitleText: Map("ru", "HTML-Код/Мнемоника", "en", "HTML/Entity"),
			tags: "x21 y546 w800 h24 readonly -VScroll -HScroll -E0x200",
			alert: "x655 y333 w190 h40 readonly Center -VScroll -HScroll -E0x200",
		},
		commandsInfoBox: {
			body: "x300 y35 w540 h450",
			bodyText: Map("ru", "Команда", "en", "Command"),
			text: "vCommandDescription x310 y65 w520 h400",
		},
		filter: {
			icon: "x21 y520 h24 w24",
			field: "x49 y520 w593 h24 v",
		},
		column: {
			widths: [300, 150, 60, 85, 0],
			widthsSmelting: [300, 110, 100, 85, 0],
			areaWidth: "w620",
			areaHeight: "h480",
			areaRules: "+NoSort -Multi",
			listStyle: "w620 h480 +NoSort -Multi",
		},
		infoFonts: {
			preview: "Noto Serif",
			previewSize: "s70",
			previewSmaller: "s40",
			titleSize: "s14",
			fontFace: Map(
				"serif", {
					name: "Noto Serif",
					source: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSerif/googlefonts/variable-ttf/NotoSerif%5Bwdth%2Cwght%5D.ttf"
				},
			),
		},
	}

	static panelTitle := App.winTitle

	static PanelGUI := Gui()

	static Panel() {

		Constructor() {
			this.panelTitle := App.winTitle

			languageCode := Language.Get()

			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := 870
			windowHeight := 570

			resolutions := [
				[1080, 1920],
				[1440, 2560],
				[1800, 3200],
				[2160, 3840],
				[2880, 5120],
				[4320, 7680]
			]

			for res in resolutions {
				if screenHeight = res[1] && screenWidth > res[2] {
					screenWidth := res[2]
					break
				}
			}

			xPos := screenWidth - windowWidth - 50
			yPos := screenHeight - windowHeight - 92

			panelWindow := Gui()
			panelWindow.title := this.panelTitle

			panelTabList := { Obj: {}, Arr: [] }
			panelColList := { default: [], smelting: [] }

			for _, localeKey in ["diacritics", "spaces", "smelting", "fastkeys", "scripts", "commands", "about", "useful", "changelog"] {
				localeText := Locale.Read("tab_" localeKey)
				panelTabList.Obj.%localeKey% := localeText
				panelTabList.Arr.Push(localeText)
			}

			for _, localeKey in ["name", "key", "view", "unicode", "entry_title"] {
				panelColList.default.Push(Locale.Read("col_" localeKey))
			}

			for _, localeKey in ["name", "recipe", "result", "unicode", "entry_title"] {
				panelColList.smelting.Push(Locale.Read("col_" localeKey))
			}

			LV_Content := {
				diacritics: ArrayMerge(
					this.LV_insertGroup([
						;
						{ type: "Group Activator", group: "Diacritics Primary", groupKey: Window LeftAlt " F1" },
						;
						{ type: "Group Activator", group: "Diacritics Secondary", groupKey: Window LeftAlt " F2", separator: true },
						;
						{ type: "Group Activator", group: "Diacritics Tertiary", groupKey: Window LeftAlt " F3", separator: true },
						;
						{ type: "Group Activator", group: "Diacritics Quatemary", groupKey: Window LeftAlt " F6", separator: true },
					]),
				),
				spaces: ArrayMerge(
					this.LV_insertGroup([
						;
						{ type: "Group Activator", group: "Spaces", groupKey: Window LeftAlt " Space" },
						;
						{ type: "Group Activator", group: "Dashes", groupKey: Window LeftAlt " -", separator: true },
						;
						{ type: "Group Activator", group: "Quotes", groupKey: Window LeftAlt " `"", separator: true },
						;
						{ type: "Group Activator", group: "Special Characters", groupKey: Window LeftAlt " F7", separator: true },
					]),
				),
				smelting: ArrayMerge(
					this.LV_insertGroup([
						;
						{ type: "Recipe", group: "Latin Ligatures" },
						;
						{ type: "Recipe", group: "Latin Digraphs" },
						;
						{ type: "Recipe", group: "Latin Extended", separator: true },
						;
						{ type: "Recipe", group: "Latin Accented", separator: true },
						;
						{ type: "Recipe", group: "Cyrillic Ligatures & Letters", separator: true },
						;
						{ type: "Recipe", group: "Cyrillic Letters", separator: true },
						;
						{ type: "Recipe", group: "Futhork Runes", separator: true },
						;
						{ type: "Recipe", group: "Glagolitic Letters", separator: true },
						;
						{ type: "Recipe", group: "Smelting Special", separator: true },
						;
						{ type: "Recipe", group: "Wallet Signs", separator: true },
						;
						{ type: "Recipe", group: "Other Signs", separator: true },
						;
						{ type: "Recipe", group: "Miscellaneous Technical", separator: true },
					]),
				),
				fastkeys: ArrayMerge(
					this.LV_insertGroup([
						;
						{ type: "Fast Key", group: "Diacritics Fast Primary", groupKey: LeftControl LeftAlt },
						;
						{ type: "Fast Key", group: "Special Fast Primary", separator: true },
						;
						{ type: "Fast Key", group: "Special Fast Left", groupKey: LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Spaces Left Alt", separator: true },
						;
						{ type: "Fast Key", group: "Latin Accented Primary", separator: true },
						;
						{ type: "Fast Key", group: "Cyrillic Primary", separator: true },
						;
						{ type: "Fast Key", group: "Special Fast Secondary", groupKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Asian Quotes", separator: true },
						;
						{ type: "Fast Key", group: "Other Signs", separator: true },
						;
						{ type: "Fast Key", group: "Spaces", separator: true },
						;
						{ type: "Fast Key", group: "Format Characters", separator: true },
						;
						{ type: "Fast Key", group: "Misc", separator: true },
						;
						{ type: "Fast Key", group: "Latin Extended", separator: true },
						;
						{ type: "Fast Key", group: "Latin Ligatures" },
						;
						{ type: "Fast Key", group: "Latin Accented Secondary", separator: true },
						;
						{ type: "Fast Key", group: "Cyrillic Ligatures & Letters", separator: true },
						;
						{ type: "Fast Key", group: "Cyrillic Secondary", separator: true },
						;
						{ type: "Fast Key", group: "Spaces Right Shift", groupKey: RightShift, separator: true },
						;
						{ type: "Fast Key", group: "Latin Accented Tertiary", separator: true },
						;
						{ type: "Fast Key", group: "Cyrillic Tertiary", separator: true },
						;
						{ type: "Fast Key", group: "Special Fast RShift", separator: true },
						;
						{ type: "Fast Key", group: "Spaces Left Shift", groupKey: LeftShift, separator: true },
						;
						{ type: "Fast Key Special", group: "Special Fast", groupKey: Locale.Read("symbol_special_key"), separator: true },
					]),
				),
				scripts: ArrayMerge(
					this.LV_insertGroup([
						;
						{ type: "Alternative Layout", group: "Fake Futhark", groupKey: RightControl " 1" },
						;
						{ type: "Alternative Layout", group: "Futhark Runes", groupKey: Locale.Read("symbol_futhark") },
						;
						{ type: "Alternative Layout", group: "Futhork Runes", groupKey: Locale.Read("symbol_futhork"), separator: true },
						;
						{ type: "Alternative Layout", group: "Younger Futhark Runes", groupKey: Locale.Read("symbol_futhark_younger"), separator: true },
						;
						{ type: "Alternative Layout", group: "Almanac Runes", groupKey: Locale.Read("symbol_futhark_almanac"), separator: true },
						;
						{ type: "Alternative Layout", group: "Later Younger Futhark Runes", groupKey: Locale.Read("symbol_futhark_younger_later"), separator: true },
						;
						{ type: "Alternative Layout", group: "Medieval Runes", groupKey: Locale.Read("symbol_medieval_runes"), separator: true },
						;
						{ type: "Alternative Layout", group: "Runic Punctuation", groupKey: Locale.Read("symbol_runic_punctuation"), separator: true },
						;
						{ type: "Alternative Layout", group: "Fake Glagolitic", groupKey: RightControl " 1" },
						;
						{ type: "Alternative Layout", group: "Glagolitic Letters", groupKey: Locale.Read("symbol_glagolitic") },
						;
						{ type: "Alternative Layout", group: "Cyrillic Diacritics", groupKey: "", separator: true },
						;
						{ type: "Alternative Layout", group: "Fake Turkic", groupKey: CapsLock RightControl " 1", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Turkic", groupKey: Locale.Read("symbol_turkic") },
						;
						{ type: "Alternative Layout", group: "Old Turkic Orkhon", groupKey: Locale.Read("symbol_turkic_orkhon") },
						;
						{ type: "Alternative Layout", group: "Old Turkic Yenisei", groupKey: Locale.Read("symbol_turkic_yenisei"), separator: true },
						;
						{ type: "Alternative Layout", group: "Fake Permic", groupKey: CapsLock RightControl " 1", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Permic", groupKey: Locale.Read("symbol_permic") },
						;
						{ type: "Alternative Layout", group: "Fake Hungarian", groupKey: RightControl " 2", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Hungarian", groupKey: Locale.Read("symbol_hungarian") },
						;
						{ type: "Alternative Layout", group: "Fake Gothic", groupKey: CapsLock RightControl " 2", separator: true },
						;
						{ type: "Alternative Layout", group: "Gothic Alphabet", groupKey: Locale.Read("symbol_gothic") },
						;
						{ type: "Alternative Layout", group: "Fake Italic", groupKey: RightControl " 3", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Italic", groupKey: Locale.Read("symbol_old_italic") },
						;
						{ type: "Alternative Layout", group: "Fake Phoenician", groupKey: CapsLock RightControl " 3", separator: true },
						;
						{ type: "Alternative Layout", group: "Phoenician", groupKey: Locale.Read("symbol_phoenician") },
						;
						{ type: "Alternative Layout", group: "Fake South Arabian", groupKey: RightControl " 4", separator: true },
						;
						{ type: "Alternative Layout", group: "South Arabian", groupKey: Locale.Read("symbol_ancient_south_arabian") },
						;
						{ type: "Alternative Layout", group: "Fake North Arabian", groupKey: CapsLock RightControl " 4", separator: true },
						;
						{ type: "Alternative Layout", group: "North Arabian", groupKey: Locale.Read("symbol_ancient_north_arabian") },
						;
						{ type: "Alternative Layout", group: "Fake IPA", groupKey: RightControl " 0", separator: true },
						;
						{ type: "Alternative Layout", group: "IPA", groupKey: Locale.Read("symbol_ipa") },
						;
						{ type: "Alternative Layout", group: "Fake Math", groupKey: RightControl RightShift " 0", separator: true },
						;
						{ type: "Alternative Layout", group: "Mathematical", groupKey: Locale.Read("symbol_maths") },
						;
						{ type: "Alternative Layout", group: "Math", groupKey: "", separator: true },
						;
						{ type: "Alternative Layout", group: "Math Spaces", groupKey: "", separator: true },
					]),
				),
			}

			panelTabs := panelWindow.AddTab3("w" windowWidth - 15 " h" windowHeight - 12, panelTabList.Arr)
			panelTabs.UseTab(panelTabList.Obj.diacritics)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Diacritic",
				columns: panelColList.default,
				columnWidths: this.UISets.column.widths,
				source: LV_Content.diacritics,
			})

			panelTabs.UseTab(panelTabList.Obj.spaces)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Spaces",
				columns: panelColList.default,
				columnWidths: this.UISets.column.widths,
				source: LV_Content.spaces,
			})

			panelTabs.UseTab(panelTabList.Obj.smelting)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Smelting",
				columns: panelColList.smelting,
				columnWidths: this.UISets.column.widthsSmelting,
				source: LV_Content.smelting,
			})

			panelTabs.UseTab(panelTabList.Obj.fastkeys)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "FastKeys",
				columns: panelColList.default,
				columnWidths: this.UISets.column.widths,
				source: LV_Content.fastkeys,
			})

			panelTabs.UseTab(panelTabList.Obj.scripts)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Glago",
				columns: panelColList.default,
				columnWidths: this.UISets.column.widths,
				source: LV_Content.scripts,
			})

			panelTabs.UseTab()

			panelWindow.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)


			return panelWindow
		}

		if IsGuiOpen(this.panelTitle) {
			WinActivate(this.panelTitle)
		} else {
			this.PanelGUI := Constructor()
			this.PanelGUI.Show()

			for each in ["Diacritic", "Spaces", "Smelting", "FastKeys", "Glago"] {
				try {
					this.LV_SetRandomPreview(each)
				}
			}
		}

	}

	static AddCharactersTab(options) {
		languageCode := Language.Get()
		panelWindow := options.winObj

		items_LV := panelWindow.AddListView(this.UISets.column.listStyle " v" options.prefix "LV", options.columns)
		items_LV.SetFont("s10")
		items_LV.OnEvent("ItemFocus", (LV, rowNumber) => this.LV_SetCharacterPreview(LV, rowNumber, { prefix: options.prefix }))
		items_LV.OnEvent("DoubleClick", (LV, rowNumber) => this.LV_DoubleClickHandler(LV, rowNumber))

		Loop options.columns.Length {
			index := A_Index
			items_LV.ModifyCol(index, options.columnWidths[index])
		}

		for item in options.source {
			items_LV.Add(, item[1], item[2], item[3], item[4], item[5])
		}

		items_FilterIcon := panelWindow.AddButton(this.UISets.filter.icon)
		GuiButtonIcon(items_FilterIcon, ImageRes, 169)
		items_Filter := panelWindow.AddEdit(this.UISets.filter.field options.prefix "Filter", "")
		items_Filter.SetFont("s10")
		items_Filter.OnEvent("Change", (*) => this.LV_Filter(panelWindow, options.prefix "Filter", items_LV, options.source))

		GroupBoxOptions := {
			group: panelWindow.Add("GroupBox", "v" options.prefix "Group " this.UISets.infoBox.body, this.UISets.infoBox.bodyText),
			groupFrame: panelWindow.Add("GroupBox", this.UISets.infoBox.previewFrame),
			preview: panelWindow.Add("Edit", "v" options.prefix "Symbol " this.UISets.infoBox.preview, this.UISets.infoBox.previewText),
			title: panelWindow.Add("Text", "v" options.prefix "Title " this.UISets.infoBox.title, this.UISets.infoBox.titleText),
			;
			LaTeXTitleLTX: panelWindow.Add("Text", this.UISets.infoBox.LaTeXTitleLTX, this.UISets.infoBox.LaTeXTitleLTXText).SetFont("s10", "Cambria"),
			LaTeXTitleA: panelWindow.Add("Text", this.UISets.infoBox.LaTeXTitleA, this.UISets.infoBox.LaTeXTitleAText).SetFont("s9", "Cambria"),
			LaTeXTitleE: panelWindow.Add("Text", this.UISets.infoBox.LaTeXTitleE, this.UISets.infoBox.LaTeXTitleEText).SetFont("s10", "Cambria"),
			LaTeXPackage: panelWindow.Add("Text", "v" options.prefix "LaTeXPackage " this.UISets.infoBox.LaTeXPackage, this.UISets.infoBox.LaTeXPackageText).SetFont("s9"),
			LaTeX: panelWindow.Add("Edit", "v" options.prefix "LaTeX " this.UISets.infoBox.LaTeX, this.UISets.infoBox.LaTeXText),
			;
			altTitle: panelWindow.Add("Text", this.UISets.infoBox.altTitle, this.UISets.infoBox.altTitleText[languageCode]).SetFont("s9"),
			alt: panelWindow.Add("Edit", "v" options.prefix "Alt " this.UISets.infoBox.alt, this.UISets.infoBox.altText),
			;
			unicodeTitle: panelWindow.Add("Text", this.UISets.infoBox.unicodeTitle, this.UISets.infoBox.unicodeTitleText[languageCode]).SetFont("s9"),
			unicode: panelWindow.Add("Edit", "v" options.prefix "Unicode " this.UISets.infoBox.unicode, this.UISets.infoBox.unicodeText),
			;
			htmlTitle: panelWindow.Add("Text", this.UISets.infoBox.htmlTitle, this.UISets.infoBox.htmlTitleText[languageCode]).SetFont("s9"),
			html: panelWindow.Add("Edit", "v" options.prefix "HTML " this.UISets.infoBox.html, this.UISets.infoBox.htmlText),
			;
			tags: panelWindow.Add("Edit", "v" options.prefix "Tags " this.UISets.infoBox.tags),
			alert: panelWindow.Add("Edit", "v" options.prefix "Alert " this.UISets.infoBox.alert),
		}

		GroupBoxOptions.preview.SetFont(this.UISets.infoFonts.previewSize, this.UISets.infoFonts.fontFace["serif"].name)
		GroupBoxOptions.title.SetFont(this.UISets.infoFonts.titleSize, this.UISets.infoFonts.fontFace["serif"].name)
		GroupBoxOptions.LaTeX.SetFont("s12")
		GroupBoxOptions.alt.SetFont("s12")
		GroupBoxOptions.unicode.SetFont("s12")
		GroupBoxOptions.html.SetFont("s12")
		GroupBoxOptions.tags.SetFont("s9")
		GroupBoxOptions.alert.SetFont("s9")

		return
	}

	static LV_DoubleClickHandler(LV, rowNumber) {
		if StrLen(LV.GetText(rowNumber, 4)) < 1 {
			return
		} else {
			entryTitle := LV.GetText(rowNumber, 1)
			unicodeKey := LV.GetText(rowNumber, 4)
			characterEntry := LV.GetText(rowNumber, 5)
			value := ChrLib.GetEntry(characterEntry)
			URIComponent := Util.OpenCharWeb(unicodeKey, True)

			if StrLen(unicodeKey) > 0 {
				isCtrlDown := GetKeyState("LControl")
				isShiftDown := GetKeyState("LShift")

				if (isCtrlDown) {
					unicodeCodePoint := "0x" unicodeKey
					A_Clipboard := Chr(unicodeCodePoint)

					SoundPlay("C:\Windows\Media\Speech On.wav")
				} else if isShiftDown {
					if (unicodeKey = Util.ExtractHex(value.unicode)) {
						if !FavoriteChars.CheckVar(characterEntry) {
							FavoriteChars.Add(characterEntry)
							LV.Modify(rowNumber, , entryTitle " " Chr(0x2605))
						} else {
							FavoriteChars.Remove(characterEntry)
							LV.Modify(rowNumber, , StrReplace(entryTitle, " " Chr(0x2605)))
						}
					}

					SoundPlay("C:\Windows\Media\Speech Misrecognition.wav")
				} else {
					Run(URIComponent)
				}
			}
		}
	}

	static LV_SetRandomPreview(prefix) {
		LV_Rows := this.PanelGUI[prefix "LV"].GetCount()
		allowedRows := []

		Loop LV_Rows {
			if StrLen(this.PanelGUI[prefix "LV"].GetText(A_Index, 5)) > 0 {
				allowedRows.Push(A_Index)
			}
		}

		rand := Random(1, allowedRows.Length)
		entryName := this.PanelGUI[prefix "LV"].GetText(allowedRows[rand], 5)

		this.LV_SetCharacterPreview(this.PanelGUI[prefix "LV"], entryName, { prefix: prefix })
	}

	static LV_SetCharacterPreview(LV, rowValue, options) {
		characterEntry := Type(rowValue) = "String" ? rowValue : LV.GetText(rowValue, 5)
		if StrLen(characterEntry) < 1 {
			this.PanelGUI[options.prefix "Title"].Text := "N/A"
			this.PanelGUI[options.prefix "Symbol"].Text := ChrLib.Get("dotted_circle")
			this.PanelGUI[options.prefix "Unicode"].Text := "U+0000"
			this.PanelGUI[options.prefix "HTML"].Text := "&#x0000;"
			this.PanelGUI[options.prefix "Alt"].Text := "N/A"
			this.PanelGUI[options.prefix "LaTeX"].Text := "N/A"
			this.PanelGUI[options.prefix "LaTeXPackage"].Text := ""
			this.PanelGUI[options.prefix "Tags"].Text := ""
			this.PanelGUI[options.prefix "Group"].Text := Locale.Read("character")
			this.PanelGUI[options.prefix "Alert"].Text := ""

			this.PanelGUI[options.prefix "Symbol"].SetFont(this.UISets.infoFonts.previewSize " norm cDefault", this.UISets.infoFonts.fontFace["serif"].name)
			this.PanelGUI[options.prefix "Unicode"].SetFont("s12")
			this.PanelGUI[options.prefix "HTML"].SetFont("s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont("s12")

			return
		} else {
			languageCode := Language.Get()
			value := ChrLib.GetEntry(characterEntry)


			characterTitle := ""

			if options.HasOwnProp("type") && options.type = "Alternative Layout" &&
			(value.options.HasOwnProp("layoutTitlesAlt") && value.options.layoutTitlesAlt) &&
			Locale.Read(characterEntry "_layout_alt", "chars", True, &titleText) {
				characterTitle := titleText

			} else if (value.options.HasOwnProp("titlesAlt") && value.options.titlesAlt) && Locale.Read(characterEntry "_alt", "chars", True, &titleText) {
				characterTitle := titleText

			} else if Locale.Read(characterEntry, "chars", True, &titleText) {
				characterTitle := titleText

			} else if value.HasOwnProp("titles") && value.titles.HasValue(languageCode) {
				characterTitle := value.titles[languageCode]

			} else {
				characterTitle := Locale.Read(characterEntry, "chars")
			}

			this.PanelGUI[options.prefix "Title"].Text := characterTitle
			this.PanelGUI[options.prefix "Symbol"].Text := value.symbol.HasOwnProp("alt") ? value.symbol.alt : value.symbol.set
			this.PanelGUI[options.prefix "Unicode"].Text := value.HasOwnProp("sequence") ? Util.StrCutBrackets(value.sequence.ToString(" ")) : Util.StrCutBrackets(value.unicode)
			this.PanelGUI[options.prefix "HTML"].Text := value.HasOwnProp("entity") ? [value.html, value.entity].ToString(" ") : value.html
			this.PanelGUI[options.prefix "Alt"].Text := value.HasOwnProp("altCode") ? value.altCode : "N/A"
			this.PanelGUI[options.prefix "LaTeX"].Text := value.HasOwnProp("LaTeX") ? value.LaTeX.ToString(Chr(0x2002)) : "N/A"
			this.PanelGUI[options.prefix "LaTeXPackage"].Text := value.HasOwnProp("LaTeXPackage") ? Chrs(0x1F4E6, 0x2005) value.LaTeXPackage : ""

			this.PanelGUI[options.prefix "Symbol"].SetFont(, value.symbol.HasOwnProp("font") ? value.symbol.font : this.UISets.infoFonts.fontFace["serif"].name)
			this.PanelGUI[options.prefix "Symbol"].SetFont(this.UISets.infoFonts.previewSize " norm cDefault")
			this.PanelGUI[options.prefix "Symbol"].SetFont(value.symbol.HasOwnProp("customs") ? value.symbol.customs : StrLen(this.PanelGUI[options.prefix "Symbol"].Text) > 2 ? this.UISets.infoFonts.previewSmaller " norm cDefault" : this.UISets.infoFonts.previewSize " norm cDefault")

			this.PanelGUI[options.prefix "Unicode"].SetFont((StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 9 && StrLen(this.PanelGUI[options.prefix "Unicode"].Text) < 15) ? "s10" : (StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 14) ? "s9" : "s12")
			this.PanelGUI[options.prefix "HTML"].SetFont((StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 9 && StrLen(this.PanelGUI[options.prefix "HTML"].Text) < 15) ? "s10" : (StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 14) ? "s9" : "s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont((StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 9 && StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) < 15) ? "s10" : (StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 14) ? "s9" : "s12")

			entryString := Locale.Read("entry") ": " characterEntry
			tagsString := value.HasOwnProp("tags") ? Locale.Read("tags") ": " value.tags.ToString() : ""

			this.PanelGUI[options.prefix "Tags"].Text := entryString ChrLib.Get("ensp") tagsString


			groupTitle := ""
			isDiacritic := RegExMatch(value.symbol.set, "^" ChrLib.Get("dotted_circle") "\S")

			AlterationsValidator := Map(
				"IsModifier", [value.alterations.HasOwnProp("modifier"), 0x02B0],
				"IsUncombined", [value.alterations.HasOwnProp("uncombined"), "(h)"],
				"IsSubscript", [value.alterations.HasOwnProp("subscript"), 0x2095],
				"IsCombining", [isDiacritic || value.alterations.HasOwnProp("combining"), 0x036A],
				"IsItalic", [value.alterations.HasOwnProp("italic"), 0x210E],
				"IsItalicBold", [value.alterations.HasOwnProp("italicBold"), 0x1D489],
				"IsBold", [value.alterations.HasOwnProp("bold"), 0x1D421],
				"IsFraktur", [value.alterations.HasOwnProp("fraktur"), 0x1D525],
				"IsFrakturBold", [value.alterations.HasOwnProp("frakturBold"), 0x1D58D],
				"IsScript", [value.alterations.HasOwnProp("script"), 0x1D4BD],
				"IsScriptBold", [value.alterations.HasOwnProp("scriptBold"), 0x1D4F1],
				"IsDoubleStruck", [value.alterations.HasOwnProp("doubleStruck"), 0x1D559],
				"IsDoubleStruckItalic", [value.alterations.HasOwnProp("doubleStruckItalic"), 0x2148],
			)

			for entry, value in AlterationsValidator {
				if (value[1]) {
					groupTitle .= (value[2] == "(h)" ? value[2] : ChrLib.Get("dotted_circle") Chr(value[2])) " "
				}
			}

			this.PanelGUI[options.prefix "Group"].Text := groupTitle (isDiacritic ? Locale.Read("character_combining") : Locale.Read("character"))
			this.PanelGUI[options.prefix "Alert"].Text := RegExMatch(characterEntry, "^permic") && HasPermicFont = "Noto Sans Old Permic" ? Util.StrVarsInject(Locale.Read("warning_nofont"), HasPermicFont) : RegExMatch(characterEntry, "^hungarian") && HasHungarianFont = "Noto Sans Old Hungarian" ? Util.StrVarsInject(Locale.Read("warning_nofont"), HasHungarianFont) : ""

		}

	}

	static LV_FilterPopulate(LV, DataList) {
		LV.Delete()
		for item in DataList {
			LV.Add(, item[1], item[2], item[3], item[4], item[5])
		}
	}

	static LV_Filter(GuiFrame, FilterField, LV, DataList) {
		FilterText := StrLower(GuiFrame[FilterField].Text)
		LV.Delete()

		if FilterText = ""
			this.LV_FilterPopulate(LV, DataList)
		else {
			GroupStarted := False
			PreviousGroupName := ""
			for item in DataList {
				ItemText := StrLower(item[1])

				IsFavorite := (ItemText ~= "\Q★")
				IsMatch := InStr(ItemText, FilterText)
				|| (IsFavorite && (InStr("избранное", FilterText) || InStr("favorite", FilterText)))

				if ItemText = "" {
					LV.Add(, item[1], item[2], item[3], item[4], item[5])
					GroupStarted := true
				} else if IsMatch {
					if !GroupStarted {
						GroupStarted := true
					}
					LV.Add(, item[1], item[2], item[3], item[4], item[5])
				} else if GroupStarted {
					GroupStarted := False
				}

				if ItemText != "" and ItemText != PreviousGroupName {
					PreviousGroupName := ItemText
				}
			}

			if GroupStarted {
				LV.Add(, "", "", "", "")
			}

			if PreviousGroupName != "" {
				LV.Add(, "", "", "", "")
			}
		}
	}

	static LV_insertGroup(options) {
		if Type(options) = "Array" {
			outputArrays := []
			for each in options {
				ArrayMergeTo(outputArrays, this.LV_insertGroup(each))
			}

			return outputArrays
		} else {

			if options.group == "" {
				return
			}

			if !(options.hasOwnProp("type")) {
				throw "Type is required for LV_insertGroup"
			}

			languageCode := Language.Get()
			outputArray := []
			intermediateMap := Map()


			if options.hasOwnProp("separator") && options.separator
				outputArray.Push(["", "", "", "", "", ""])
			if options.HasOwnProp("groupKey") && StrLen(options.groupKey) > 0
				outputArray.Push(["", options.groupKey, "", "", "", ""])


			for characterEntry, value in ChrLib.entries.OwnProps() {
				isFavorite := FavoriteChars.CheckVar(characterEntry)

				if (options.hasOwnProp("blacklist") && options.blacklist.HasValue(characterEntry)) || !(value.hasOwnProp("groups")) ||
				(value.hasOwnProp("groups") && !value.groups.HasValue(options.group)) ||
				(options.type = "Group Activator" && !value.options.HasOwnProp("groupKey")) ||
				(options.type = "Recipe" && !value.HasOwnProp("recipe")) ||
				(options.type = "Fast Key" && ((!value.options.HasOwnProp("isFastKey") || !value.options.HasOwnProp("fastKey")) || !value.options.isFastKey)) ||
				(options.type = "Fast Key Special" && !value.options.HasOwnProp("specialKey")) ||
				(options.type = "Alternative Layout" && ((!value.options.HasOwnProp("isAltLayout") || !value.options.HasOwnProp("altLayoutKey")) || !value.options.isAltLayout))
				{
					continue
				}

				characterTitle := ""

				if options.type = "Alternative Layout" &&
					(value.options.HasOwnProp("layoutTitles") && value.options.layoutTitles) &&
					Locale.Read(characterEntry "_layout", "chars", True, &titleText) {
					characterTitle := titleText

				} else if Locale.Read(characterEntry, "chars", True, &titleText) {
					characterTitle := titleText

				} else if value.HasOwnProp("titles") && value.titles.HasValue(languageCode) {
					characterTitle := value.titles[languageCode]

				} else {
					characterTitle := Locale.Read(characterEntry, "chars")
				}

				if isFavorite {
					characterTitle .= " " Chr(0x2605)
				}

				characterSymbol := value.symbol.set

				characterBinding := ""

				if options.type = "Recipe" {
					if value.HasOwnProp("recipeAlt")
						characterBinding := value.recipeAlt.ToString()
					else if value.HasOwnProp("recipe")
						characterBinding := value.recipe.ToString()
					else
						characterBinding := "N/A"
				} else if options.type = "Alternative Layout" {
					characterBinding := value.options.altLayoutKey
				} else if options.type = "Fast Special" {
					characterBinding := value.options.specialKey
				} else if options.type = "Fast Key" {
					characterBinding := value.options.fastKey
				} else if options.type = "Group Activator" {
					characterBinding := Util.FormatHotKey(value.options.groupKey)
				} else {
					characterBinding := "N/A"
				}

				intermediateMap.Set(value.index, [characterTitle, characterBinding, characterSymbol, Util.ExtractHex(value.unicode), characterEntry])
			}

			for key, value in intermediateMap {
				outputArray.Push(value)
			}

			if options.HasOwnProp("target") {
				for each in outputArray {
					%options.target%.Push(each)
				}
			} else {
				return outputArray
			}
		}
	}
}


>^F8:: Panel.Panel()