Class Panel {
	static UISets := {
		infoFonts: {
			preview: "Noto Serif",
			previewSize: 70,
			previewSmaller: 40,
			titleSize: 14,
			fontFace: Map(
				"serif", {
					name: "Noto Serif",
					source: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSerif/googlefonts/variable-ttf/NotoSerif%5Bwdth%2Cwght%5D.ttf"
				},
			),
		},
	}

	static GetUISets(set := "construction", w := 1200, h := 600) {
		baseX := 21
		panelWidth := w
		panelHeight := h

		tabsW := panelWidth - 15
		tabsH := panelHeight - 12

		lvW := panelWidth - (panelWidth / 3)
		lvH := panelHeight - 90
		lvCols := [lvW * 0.525, lvW * 0.2, lvW * 0.125, lvW * 0.1, 0, 0]
		lvColsAll := [lvW * 0.625, 0, lvW * 0.175, lvW * 0.15, 0, 0]
		lvColsFavorites := [lvW * 0.5, lvW * 0.205, lvW * 0.175, lvW * 0.055, 0, 0]

		ibBodyW := (panelWidth - lvW) / 1.25
		ibBodyH := panelHeight - 60
		ibBodyX := lvW + 50
		ibBodyY := 35
		ibPreviewFrameW := (ibBodyW / 1.75) * 1.25
		ibPreviewFrameH := 128
		ibPreviewFrameX := (ibBodyW - ibPreviewFrameW) / 2
		ibPreviewFrameY := 80
		ibPreviewBoxEditW := ibPreviewFrameW
		ibPreviewBoxEditH := 24
		ibPreviewButtonW := 24
		ibPreviewButtonH := 24
		ibPreviewButtonOffsetX := (ibBodyX + ibPreviewFrameX + ibPreviewFrameW)
		ibPreviewTitleY := (ibPreviewFrameY + ibPreviewFrameH) + 10
		ibPreviewTitleH := 150

		filterW := lvW - 27
		filterY := lvH + 40
		filterOffsetX := baseX + 28
		filterButtonW := 24

		tagsY := filterY + 26
		tagsW := panelWidth - 20

		commandsTreeW := panelWidth - (panelWidth / 1.4)
		commandsTreeH := panelHeight - 70
		commandsTreeX := baseX + 4
		commandsTreeY := 43

		commandsBoxW := (panelWidth - commandsTreeW) - (40 * 1.4)
		commandsBoxH := commandsTreeH + 9
		commandsBoxX := commandsTreeW + 40
		commandsBoxY := 36

		commandsTexW := commandsBoxW - 25
		commandsTexH := commandsBoxH - 40
		commandsTexX := commandsBoxX + 15
		commandsTexY := commandsBoxY + 30

		aboutLeftW := 280
		aboutLeftH := panelHeight - 70
		aboutLeftX := baseX + 3
		aboutLeftY := 34

		aboutPanelWindowW := 170
		aboutPanelWindowH := 170
		aboutPanelWindowX := aboutLeftX + (aboutLeftW - aboutPanelWindowW) / 2
		aboutPanelWindowY := aboutLeftY + 11

		aboutPanelWindowIcoW := 128
		aboutPanelWindowIcoH := 128
		aboutPanelWindowIcoX := aboutPanelWindowX + ((aboutPanelWindowW - aboutPanelWindowIcoW) / 2)
		aboutPanelWindowIcoY := aboutPanelWindowY + ((aboutPanelWindowH - aboutPanelWindowIcoH) / 2)

		aboutTitleW := aboutLeftW
		aboutTitleH := 32
		aboutTitleX := aboutLeftX
		aboutTitleY := (aboutPanelWindowY + aboutPanelWindowH) + 14

		aboutVersionW := aboutTitleW
		aboutVersionH := aboutTitleH
		aboutVersionX := aboutTitleX
		aboutVersionY := (aboutTitleY + aboutTitleH) + 14

		aboutRepoStrLen := StrLen(Locale.Read("about_repository"))
		aboutRepoLinkW := aboutRepoStrLen * 10
		aboutRepoLinkH := aboutTitleH
		aboutRepoLinkX := aboutLeftX + ((aboutLeftW - aboutRepoLinkW) / 2) + 9
		aboutRepoLinkY := (aboutVersionY + aboutVersionH) + 14

		aboutAuthorW := aboutTitleW
		aboutAuthorH := aboutTitleH
		aboutAuthorX := aboutTitleX
		aboutAuthorY := aboutLeftH - 45

		aboutAuthorLinksStrLen := Util.WidthBasedStrLen(Locale.ReadNoLinks("about_author_links"))
		aboutAuthorLinksW := aboutAuthorLinksStrLen * 8
		aboutAuthorLinksH := 24
		aboutAuthorLinksX := aboutLeftX + ((aboutLeftW - aboutAuthorLinksW) / 2)
		aboutAuthorLinksY := (aboutAuthorY + aboutAuthorH) + 14

		aboutDescBoxW := 515
		aboutDescBoxH := aboutLeftH + 2
		aboutDescBoxX := (aboutLeftX + aboutLeftW) + 10
		aboutDescBoxY := 32

		aboutDescriptionW := aboutDescBoxW - 25
		aboutDescriptionH := aboutDescBoxH - 40
		aboutDescriptionX := aboutDescBoxX + 15
		aboutDescriptionY := aboutDescBoxY + 38

		aboutChrCountW := aboutDescriptionW
		aboutChrCountH := (18 * 5) + 5
		aboutChrCountX := aboutDescriptionX
		aboutChrCountY := ((aboutLeftH + aboutLeftY) - (aboutChrCountH)) - 18 + 5

		aboutSampleWordsW := panelWidth - (aboutDescBoxX + aboutDescBoxW) - 30
		aboutSampleWordsH := aboutDescBoxH
		aboutSampleWordsX := aboutDescBoxX + aboutDescBoxW + 10
		aboutSampleWordsY := aboutDescBoxY

		aboutSampleWordsContentX := aboutSampleWordsX + 14
		aboutSampleWordsContentY := aboutSampleWordsY + 30
		aboutSampleWordsContentW := (aboutSampleWordsX + aboutSampleWordsW) - aboutSampleWordsContentX - 16
		aboutSampleWordsContentH := aboutSampleWordsH - 40

		clBodyW := panelWidth - 45
		clBodyH := panelHeight - 55
		clBodyX := baseX + 4
		clBodyY := 35

		clContentW := clBodyW - 20
		clContentH := clBodyH - 40
		clContentX := clBodyX + 10
		clContentY := clBodyY + 30

		construction := {
			window: {
				width: panelWidth,
				height: panelHeight,
				minWidth: 800,
				minHeight: panelHeight
			},
			tabs: Format("vTabs  w{} h{}", tabsW, tabsH),
			infoBox: {
				body: Format("x{} y{} w{} h{} Center",
					ibBodyX, ibBodyY, ibBodyW, ibBodyH),
				bodyText: Locale.Read("character"),
				previewFrame: Format("x{} y{} w{} h{} Center",
					ibBodyX + ibPreviewFrameX, ibPreviewFrameY, ibPreviewBoxEditW, ibPreviewFrameH),
				preview: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, ibPreviewFrameY, ibPreviewBoxEditW, ibPreviewFrameH),
				previewText: "◌͏",
				title: Format("x{} y{} w{} h{} 0x80 Center BackgroundTrans",
					(ibBodyX + ibPreviewFrameX), ibPreviewTitleY, ibPreviewBoxEditW, ibPreviewTitleH),
				titleText: "N/A",
				LaTeXTitleA: Format("x{} y{} w{} h{} 0x80 BackgroundTrans",
					(ibBodyX + ibPreviewFrameX) + 4, 371, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXTitleAText: "A",
				LaTeXTitleE: Format("x{} y{} w{} h{} 0x80 BackgroundTrans",
					(ibBodyX + ibPreviewFrameX) + 17, 375, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXTitleEText: "E",
				LaTeXTitleLTX: Format("x{} y{} w{} h{} 0x80 BackgroundTrans",
					(ibBodyX + ibPreviewFrameX), 373, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXTitleLTXText: "L T  X",
				LaTeXPackage: Format("x{} y{} w{} h{} 0x80 BackgroundTrans Right",
					ibBodyX + ibPreviewFrameX, 373, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXPackageText: "",
				LaTeX: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 390, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXText: "N/A",
				alt: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 430, ibPreviewBoxEditW, ibPreviewBoxEditH),
				altTitle: Format("x{} y{} w{} h{} 0x80 BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 415, ibPreviewBoxEditW, ibPreviewBoxEditH),
				altPages: Format("x{} y{} w{} h{} 0x80 BackgroundTrans Right",
					ibBodyX + ibPreviewFrameX, 415, ibPreviewBoxEditW, ibPreviewBoxEditH),
				altText: "N/A",
				unicode: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 470, ibPreviewBoxEditW, ibPreviewBoxEditH),
				unicodeTitle: Format("x{} y{} w{} h{} 0x80 BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 455, ibPreviewBoxEditW, ibPreviewBoxEditH),
				unicodeText: "0000",
				html: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 510, ibPreviewBoxEditW, ibPreviewBoxEditH),
				htmlText: "&#x0000;",
				htmlTitle: Format("x{} y{} w{} h{} 0x80 BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 495, ibPreviewBoxEditW, ibPreviewBoxEditH),
				tags: Format("x{} y{} w{} h{} readonly -VScroll -HScroll -E0x200",
					baseX, tagsY, tagsW, ibPreviewBoxEditH),
				alert: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll -E0x200",
					ibBodyX + ibPreviewFrameX, 55, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreviewTitle: Format("x{} y{} w{} h{} 0x80 BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 305, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreview: Format("x{} y{} w{} h{} readonly Center +Multi +Wrap -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 320, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreviewSet: Format("x{} y{} w{} h{} 0x80 BackgroundTrans Right",
					ibBodyX + ibPreviewFrameX, 301, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreviewSetText: "",
				legendButton: Format("x{} y{} h{} w{}",
					ibPreviewButtonOffsetX, ibPreviewFrameY - 1, ibPreviewButtonW, ibPreviewButtonH),
				glyphsVariantsButton: Format("x{} y{} h{} w{}",
					ibPreviewButtonOffsetX, (ibPreviewFrameY - 1) + ibPreviewButtonH, ibPreviewButtonW, ibPreviewButtonH),
				unicodeBlockLabel: Format("x{} y{} w{} h{} Center 0x80 BackgroundTrans",
					ibBodyX + ibPreviewFrameX, (ibBodyY + ibBodyH) - 34, ibPreviewBoxEditW, ibPreviewBoxEditH + 8),
			},
			commandsInfoBox: {
				commandsTree: Format("vCommandTree x{} y{} w{} h{} -HScroll",
					commandsTreeX, commandsTreeY, commandsTreeW, commandsTreeH),
				body: Format("vCommandGroup x{} y{} w{} h{}",
					commandsBoxX, commandsBoxY, commandsBoxW, commandsBoxH),
				text: Format("vCommandDescription x{} y{} w{} h{} 0x80",
					commandsTexX, commandsTexY, commandsTexW, commandsTexH),
			},
			aboutInfoBox: {
				leftBox: Format("vAboutGroupBox x{} y{} w{} h{}",
					aboutLeftX, aboutLeftY, aboutLeftW, aboutLeftH),
				panelWindow: Format("vAboutPanelWindow x{} y{} w{} h{}",
					aboutPanelWindowX, aboutPanelWindowY, aboutPanelWindowW, aboutPanelWindowH),
				panelWindowIco: Format("vAboutIco x{} y{} w{} h{}",
					aboutPanelWindowIcoX, aboutPanelWindowIcoY, aboutPanelWindowIcoW, aboutPanelWindowIcoH),
				aboutTitle: Format("vAboutTitle x{} y{} w{} h{} 0x80 Center BackgroundTrans",
					aboutTitleX, aboutTitleY, aboutTitleW, aboutTitleH),
				aboutVersion: Format("vAboutVersion x{} y{} w{} h{} 0x80 Center BackgroundTrans",
					aboutVersionX, aboutVersionY, aboutVersionW, aboutVersionH),
				aboutRepoLink: Format("vAboutRepoLink x{} y{} w{} h{}",
					aboutRepoLinkX, aboutRepoLinkY, aboutRepoLinkW, aboutRepoLinkH),
				aboutAuthor: Format("vAboutAuthor x{} y{} w{} h{} 0x80 Center BackgroundTrans",
					aboutAuthorX, aboutAuthorY, aboutAuthorW, aboutAuthorH),
				aboutAuthorLinks: Format("vAboutAuthorLinks x{} y{} w{} h{}",
					aboutAuthorLinksX, aboutAuthorLinksY, aboutAuthorLinksW, aboutAuthorLinksH),
				aboutDescBox: Format("vAboutDescBox x{} y{} w{} h{}",
					aboutDescBoxX, aboutDescBoxY, aboutDescBoxW, aboutDescBoxH),
				aboutDescription: Format("vAboutDescription x{} y{} w{} h{} 0x80 Wrap BackgroundTrans",
					aboutDescriptionX, aboutDescriptionY, aboutDescriptionW, aboutDescriptionH),
				aboutChrCount: Format("vAboutChrCount x{} y{} w{} h{} 0x80 Wrap BackgroundTrans",
					aboutChrCountX, aboutChrCountY, aboutChrCountW, aboutChrCountH),
				aboutSampleWords: Format("vAboutSampleWords x{} y{} w{} h{}",
					aboutSampleWordsX, aboutSampleWordsY, aboutSampleWordsW, aboutSampleWordsH),
				aboutSampleWordsContent: Format("vAboutSampleWordsContent x{} y{} w{} h{}",
					aboutSampleWordsContentX, aboutSampleWordsContentY, aboutSampleWordsContentW, aboutSampleWordsContentH),
			},
			filter: {
				icon: Format("x{} y{} h{} w{}",
					baseX, filterY, filterButtonW, ibPreviewBoxEditH),
				field: Format("x{} y{} w{} h{} v",
					filterOffsetX, filterY, filterW, ibPreviewBoxEditH),
			},
			column: {
				widths: lvCols,
				widthsSmelting: lvCols,
				widthsAll: lvColsAll,
				widthsFavorites: lvColsFavorites,
				listStyle: Format("w{} h{} +NoSort -Multi", lvW, lvH)
			},
			infoFonts: {
				preview: "Noto Serif",
				previewSize: 70,
				previewSmaller: 40,
				titleSize: 14,
				fontFace: Map(
					"serif", {
						name: "Noto Serif",
						source: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSerif/googlefonts/variable-ttf/NotoSerif%5Bwdth%2Cwght%5D.ttf"
					},
				),
			},
		}

		WHXY := {
			window: {
				width: panelWidth,
				height: panelHeight,
				minWidth: 800,
				minHeight: panelHeight
			},
			tabs: { w: tabsW, h: tabsH },
			infoBox: {
				body: { x: ibBodyX, y: ibBodyY, w: ibBodyW, h: ibBodyH },
				previewFrame: { x: ibBodyX + ibPreviewFrameX, y: ibPreviewFrameY, w: ibPreviewBoxEditW, h: ibPreviewFrameH },
				preview: { x: ibBodyX + ibPreviewFrameX, y: ibPreviewFrameY, w: ibPreviewBoxEditW, h: ibPreviewFrameH },
				title: { x: ibBodyX + ibPreviewFrameX, y: ibPreviewTitleY, w: ibPreviewBoxEditW, h: ibPreviewTitleH },
				LaTeXTitleA: { x: ibBodyX + ibPreviewFrameX + 4, y: 371, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				LaTeXTitleE: { x: ibBodyX + ibPreviewFrameX + 17, y: 375, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				LaTeXTitleLTX: { x: ibBodyX + ibPreviewFrameX, y: 373, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				LaTeXPackage: { x: ibBodyX + ibPreviewFrameX, y: 373, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				LaTeXPackageText: "",
				LaTeX: { x: ibBodyX + ibPreviewFrameX, y: 390, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				alt: { x: ibBodyX + ibPreviewFrameX, y: 430, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				altTitle: { x: ibBodyX + ibPreviewFrameX, y: 415, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				unicode: { x: ibBodyX + ibPreviewFrameX, y: 470, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				unicodeTitle: { x: ibBodyX + ibPreviewFrameX, y: 455, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				html: { x: ibBodyX + ibPreviewFrameX, y: 510, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				htmlTitle: { x: ibBodyX + ibPreviewFrameX, y: 495, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				tags: { x: baseX, y: tagsY, w: tagsW, h: ibPreviewBoxEditH },
				alert: { x: ibBodyX + ibPreviewFrameX, y: 55, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				keyPreviewTitle: { x: ibBodyX + ibPreviewFrameX, y: 305, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				keyPreview: { x: ibBodyX + ibPreviewFrameX, y: 320, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				keyPreviewSet: { x: ibBodyX + ibPreviewFrameX, y: 301, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
				keyPreviewSetText: "",
				legendButton: { x: ibPreviewButtonOffsetX, y: ibPreviewFrameY - 1, w: ibPreviewButtonW, h: ibPreviewButtonH },
				glyphsVariantsButton: { x: ibPreviewButtonOffsetX, y: (ibPreviewFrameY - 1) + ibPreviewButtonH, w: ibPreviewButtonW, h: ibPreviewButtonH },
				unicodeBlockLabel: { x: ibBodyX + ibPreviewFrameX, y: (ibBodyY + ibBodyH) - 30, w: ibPreviewBoxEditW, h: ibPreviewBoxEditH },
			},
			commandsInfoBox: {
				commandsTree: { x: commandsTreeX, y: commandsTreeY, w: commandsTreeW, h: commandsTreeH },
				body: { x: commandsBoxX, y: commandsBoxY, w: commandsBoxW, h: commandsBoxH },
				text: { x: commandsTexX, y: commandsTexY, w: commandsTexW, h: commandsTexH },
			},
			aboutInfoBox: {
				leftBox: { x: aboutLeftX, y: aboutLeftY, w: aboutLeftW, h: aboutLeftH },
				panelWindow: { x: aboutPanelWindowX, y: aboutPanelWindowY, w: aboutPanelWindowW, h: aboutPanelWindowH },
				panelWindowIco: { x: aboutPanelWindowIcoX, y: aboutPanelWindowIcoY, w: aboutPanelWindowIcoW, h: aboutPanelWindowIcoH },
				aboutTitle: { x: aboutTitleX, y: aboutTitleY, w: aboutTitleW, h: aboutTitleH },
				aboutVersion: { x: aboutVersionX, y: aboutVersionY, w: aboutVersionW, h: aboutVersionH },
				aboutRepoLink: { x: aboutRepoLinkX, y: aboutRepoLinkY, w: aboutRepoLinkW, h: aboutRepoLinkH },
				aboutAuthor: { x: aboutAuthorX, y: aboutAuthorY, w: aboutAuthorW, h: aboutAuthorH },
				aboutAuthorLinks: { x: aboutAuthorLinksX, y: aboutAuthorLinksY, w: aboutAuthorLinksW, h: aboutAuthorLinksH },
				aboutDescBox: { x: aboutDescBoxX, y: aboutDescBoxY, w: aboutDescBoxW, h: aboutDescBoxH },
				aboutDescription: { x: aboutDescriptionX, y: aboutDescriptionY, w: aboutDescriptionW, h: aboutDescriptionH },
				aboutChrCount: { x: aboutChrCountX, y: aboutChrCountY, w: aboutChrCountW, h: aboutChrCountH },
				aboutSampleWords: { x: aboutSampleWordsX, y: aboutSampleWordsY, w: aboutSampleWordsW, h: aboutSampleWordsH },
				aboutSampleWordsContent: { x: aboutSampleWordsContentX, y: aboutSampleWordsContentY, w: aboutSampleWordsContentW, h: aboutSampleWordsContentH },
			},
			filter: {
				icon: { x: baseX, y: filterY, h: ibPreviewBoxEditH, w: filterButtonW },
				field: { x: filterOffsetX, y: filterY, h: ibPreviewBoxEditH, w: filterW },
			},
			column: {
				widths: lvCols,
				widthsSmelting: lvCols,
				widthsAll: lvColsAll,
				listStyle: { w: lvW, h: lvH }
			},
		}

		return %set%
	}

	static commandLabels := { structured: [
		"help_modifier_keys",
		"help_common_binds",
		"help_panel_commands",
		"help_tray_commands",
		"help_uncommon_titles",
		Map("help_search", [
			"help_search__glyph_variations",
			"help_search__funcs",
		]),
		"help_forge",
		"help_alternative_input",
		"help_glyph_variations",
		"help_TELEX",
		"help_digit_cases",
		Map("help_hotstrings", [
			"help_hotstrings__temperature_conversion",
		]),
		Map("help_text_processing", [
			"help_text_processing__quotes",
		]),
	], flat: [] }

	static panelTitle := App.Title("+status+version") " — " Locale.Read("gui_panel")

	static PanelGUI := Gui()

	static __New() {
		for each in this.commandLabels.structured {
			if Type(each) = "String" {
				this.commandLabels.flat.Push(each)
			} else if Type(each) = "Map" {
				for key, value in each {
					this.commandLabels.flat.Push(key)
					for eachChild in value {
						this.commandLabels.flat.Push(eachChild)
					}
				}
			}
		}
	}

	static pdToolTipIncrement := 0
	static PanelDataToolTip() {
		this.pdToolTipIncrement := this.pdToolTipIncrement > 4 ? 0 : this.pdToolTipIncrement + 1
		ToolTip(Chr(0x2B1C) " " Util.StrRepeat(".", this.pdToolTipIncrement))
	}

	static SetPanelData() {
		tt := this.PanelDataToolTip.Bind(this)
		SetTimer(tt, 100, 0)

		this.LV_Content := {
			smelting: this.LV_InsertGroup({
				type: "Recipe",
				group: [
					"Latin Ligatures", "",
					"Latin Digraphs", "",
					"Latin", "",
					"Latino-Hellenic", "",
					"Latin Accented", "",
					"Latin Numerals", "",
					"Hellenic Ligatures", "",
					"Hellenic", "",
					"Hellenic Accented", "",
					"Hellenic Diacritics", "",
					"Cyrillic Ligatures", "",
					"Cyrillic Digraphs", "",
					"Cyrillic", "",
					"Cyrillic Accented", "",
					"Germanic Runic Elder Futhark",
					"Germanic Runic Futhork",
					"Germanic Runic Younger Futhark",
					"Germanic Runic Almanac",
					"Germanic Runic Later Younger Futhark",
					"Germanic Runic Medieval",
					"Cirth Runic", "",
					"Glagolitic", "",
					"Old Persian", "",
					"Shavian Ligatures", "",
					"Smelting Special", "",
					"Extra Symbolistics", "",
					"Alchemical", "",
					"Astrology", "",
					"Astronomy", "",
					"Wallet Signs", "",
					"Other Signs", "",
					"Miscellaneous Technical",
				]
			}),
			fastkeys: ArrayMerge(this.LV_InsertGroup({
				type: "Fast Key",
				group: [
					"FK Diacritics Primary", "",
					"Special Fast Primary", "",
					"Spaces Primary", "",
					"Special Fast Left",
					"Wallet Signs Primary", "",
					"Spaces Left Alt", "",
					"Latin Primary", "",
					"Latin Accented Primary", "",
					"Cyrillic Primary", "",
					"Cyrillic Accented Primary", "",
					"Special Fast Secondary",
					"Wallet Signs Secondary", "",
					"Asian Quotes", "",
					"Other Signs", "",
					"Spaces", "",
					"Format Characters", "",
					"Misc", "",
					"Latin Ligatures", "",
					"Latin Secondary", "",
					"Latino-Hellenic Secondary", "",
					"Latin Accented Secondary", "",
					"Cyrillic Ligatures Secondary", "",
					"Cyrillic Digraphs Secondary", "",
					"Cyrillic Secondary", "",
					"Cyrillic Accented Secondary", "",
					"Special Right Shift",
					"Wallet Signs Right Shift", "",
					"Spaces Right Shift", "",
					"Latin Accented Tertiary", "",
					"Cyrillic Tertiary", "",
					"Special Fast RShift", "",
					"Wallet Signs Left Shift", ""
					"Spaces Left Shift", ""
				],
				groupKey: Map(
					"FK Diacritics Primary", LeftControl LeftAlt,
					"Special Fast Left", LeftAlt,
					"Special Fast Secondary", RightAlt,
					"Special Right Shift", RightShift,
					"Wallet Signs Left Shift", LeftShift
				),
			}), this.LV_InsertGroup({
				type: "Special Combinations",
				group: ["Special Combinations"],
				groupKey: Map("Special Combinations", Locale.Read("symbol_special_key")),
			})
			),
			secondkeys: this.LV_InsertGroup({
				type: "Fast Key",
				group: [
					"SK Diacritics Primary", "",
					"SK Spaces Primary", "",
					"SK Special Secondary", "",
					"SK Spaces Secondary", "",
					"SK Special Left Alt", "",
					"SK Spaces Left Alt", "",
				],
				groupKey: Map(
					"SK Diacritics Primary", LeftControl LeftAlt,
					"SK Special Secondary", RightAlt,
					"SK Special Left Alt", LeftAlt,
				),
			}),
			tertiarykeys: this.LV_InsertGroup({
				type: "Fast Key",
				group: [
					"TK Diacritics Primary", "",
				],
				groupKey: Map(
					"TK Diacritics Primary", LeftControl LeftAlt,
				),
			}),
			scripts: this.LV_InsertGroup({
				type: "Alternative Layout",
				group: [
					"Hellenic", "",
					"Hellenic Accented", "",
					"Hellenic Diacritics", "",
					"Hellenic Punctuation",
					"Hellenic Specials", "",
					"Germanic Runic Elder Futhark", "",
					"Germanic Runic Futhork", "",
					"Germanic Runic Younger Futhark", "",
					"Germanic Runic Almanac", "",
					"Germanic Runic Later Younger Futhark", "",
					"Germanic Runic Medieval", "",
					"Germanic Runic", "",
					"Cirth Runic",
					"Tolkien Runic", "",
					"Runic Punctuation", "",
					"Glagolitic",
					"Cyrillic Diacritics", "",
					"Old Turkic",
					"Old Turkic Orkhon", "",
					"Old Turkic Yenisei", "",
					"Old Permic", "",
					"Old Hungarian", "",
					"Gothic", "",
					"Old Italic", "",
					"Phoenician", "",
					"South Arabian", "",
					"North Arabian", "",
					"Carian", "",
					"Lycian", "",
					"Lydian", "",
					"Sidetic", "",
					"Cypriot Syllabary", "",
					"Tifinagh", "",
					"Ugaritic", "",
					"Old Persian", "",
					"IPA", "",
					"Deseret", "",
					"Shavian", "Shavian Ligatures", "",
					"Mathematical", "",
					"Math", "",
					"Math Spaces"
				],
				groupKey: Map(
					"Hellenic", Locale.Read("symbol_hellenic"),
					"Germanic Runic Elder Futhark", Locale.Read("symbol_futhark"),
					"Germanic Runic Futhork", Locale.Read("symbol_futhork"),
					"Germanic Runic Younger Futhark", Locale.Read("symbol_futhark_younger"),
					"Germanic Runic Almanac", Locale.Read("symbol_futhark_almanac"),
					"Germanic Runic Later Younger Futhark", Locale.Read("symbol_futhark_younger_later"),
					"Germanic Runic Medieval", Locale.Read("symbol_medieval_runes"),
					"Runic Punctuation", Locale.Read("symbol_runic_punctuation"),
					"Glagolitic", Locale.Read("symbol_glagolitic"),
					"Old Turkic", Locale.Read("symbol_turkic"),
					"Old Turkic Orkhon", Locale.Read("symbol_turkic_orkhon"),
					"Old Turkic Yenisei", Locale.Read("symbol_turkic_yenisei"),
					"Old Permic", Locale.Read("symbol_permic"),
					"Old Hungarian", Locale.Read("symbol_hungarian"),
					"Gothic", Locale.Read("symbol_gothic"),
					"Old Italic", Locale.Read("symbol_old_italic"),
					"Phoenician", Locale.Read("symbol_phoenician"),
					"South Arabian", Locale.Read("symbol_ancient_south_arabian"),
					"North Arabian", Locale.Read("symbol_ancient_north_arabian"),
					"Carian", Locale.Read("symbol_carian"),
					"Lycian", Locale.Read("symbol_lycian"),
					"Lydian", Locale.Read("symbol_lydian"),
					"Sidetic", Locale.Read("symbol_sidetic"),
					"Cypriot Syllabary", Locale.Read("symbol_cypriot_syllabary"),
					"Tifinagh", Locale.Read("symbol_tifinagh"),
					"Ugaritic", Locale.Read("symbol_ugaritic"),
					"Old Persian", Locale.Read("symbol_old_persian"),
					"IPA", Locale.Read("symbol_ipa"),
					"Deseret", Locale.Read("symbol_deseret"),
					"Shavian", Locale.Read("symbol_shavian"),
					"Mathematical", Locale.Read("symbol_maths")
				),
			}),
			TELEXVNI: this.LV_InsertGroup({
				type: "TELEX/VNI",
				group: [
					"TELEX/VNI Vietnamese", "",
					"TELEX/VNI Jorai", "",
					"TELEX/VNI Chinese Romanization", "",
				],
				groupKey: Map(
					"TELEX/VNI Vietnamese", Locale.Read("symbol_vietnamese"),
					"TELEX/VNI Jorai", Locale.Read("symbol_jorai"),
					"TELEX/VNI Chinese Romanization", Locale.Read("symbol_chinese_romanization"),
				),
				subType: Map(
					"TELEX/VNI Vietnamese", "vietnamese",
					"TELEX/VNI Jorai", "jorai",
					"TELEX/VNI Chinese Romanization", "chinese_romanization",
				),
				combinationKey: Map(
					"TELEX/VNI Vietnamese", RightAlt " F2",
					"TELEX/VNI Jorai", RightAlt " F2",
					"TELEX/VNI Chinese Romanization", RightAlt RightShift " F2",
				)
			}),
			all: this.LV_InsertGroup({ type: "", group: ["i)^(?!Custom)"], }),
		}

		SetTimer(tt, 0)
		ToolTip(Chr(0x2705))
		this.pdToolTipIncrement := 0
		SetTimer(ToolTip.Bind(""), -500)
	}

	static Panel(redraw := False) {
		if !initialized
			return

		tt := this.PanelDataToolTip.Bind(this)
		SetTimer(tt, 100, 0)

		UISets := this.GetUISets()

		title := App.Title("+status+version") " — " Locale.Read("gui_panel")

		panelTabList := { Obj: {}, Arr: [] }
		panelColList := { default: [], smelting: [], favorites: [] }

		for _, localeKey in [
			"smelting",
			"fastkeys",
			"secondkeys",
			"tertiarykeys",
			"scripts",
			"TELEXVNI",
			"help",
			"about",
			"all",
			"favorites",
		] {
			localeText := Locale.Read("tab_" localeKey)
			panelTabList.Obj.%localeKey% := localeText
			panelTabList.Arr.Push(localeText)
		}

		for _, localeKey in ["name", "key", "view", "unicode", "entry_title", "entry_key"] {
			panelColList.default.Push(Locale.Read("col_" localeKey))
		}

		for _, localeKey in ["name", "recipe", "result", "unicode", "entry_title", "entry_key"] {
			panelColList.smelting.Push(Locale.Read("col_" localeKey))
		}

		for _, localeKey in ["name", "recipe", "key", "view", "entry_title", "entry_key"] {
			panelColList.favorites.Push(Locale.Read("col_" localeKey))
		}

		if redraw {
			IsGuiOpen(this.panelTitle) && ReConstructor()

			ReConstructor() {
				this.panelTitle := title

				panelWindow := this.PanelGUI
				panelTabs := panelWindow["Tabs"]

				panelWindow.title := this.panelTitle

			}
			return
		}

		Constructor() {
			this.panelTitle := title

			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := UISets.window.width
			windowHeight := UISets.window.height
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
			; panelWindow.Opt("+Resize +MinSize" UISets.window.minWidth "x" UISets.window.minHeight)
			panelWindow.title := this.panelTitle

			panelWindow.OnEvent("Size", panelResize)

			panelTabs := panelWindow.AddTab3(UISets.tabs, panelTabList.Arr)

			this.LV_Content.favorites := ArrayMerge(
				this.LV_InsertGroup({ type: "", group: ["Favorites"] })
			)

			tabContents := [{
				winObj: panelWindow,
				prefix: "Smelting",
				columns: panelColList.smelting,
				columnWidths: UISets.column.widthsSmelting,
				source: this.LV_Content.smelting,
				previewType: "Recipe",
			}, {
				winObj: panelWindow,
				prefix: "FastKeys",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: this.LV_Content.fastkeys,
			}, {
				winObj: panelWindow,
				prefix: "SecondKeys",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: this.LV_Content.secondkeys,
			}, {
				winObj: panelWindow,
				prefix: "TertiaryKeys",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: this.LV_Content.tertiarykeys,
			}, {
				winObj: panelWindow,
				prefix: "Glago",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: this.LV_Content.scripts,
				previewType: "Alternative Layout",
			}, {
				winObj: panelWindow,
				prefix: "TELEX/VNI",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: this.LV_Content.TELEXVNI,
			}, {
				winObj: panelWindow,
				prefix: "AllSymbols",
				columns: panelColList.smelting,
				columnWidths: UISets.column.widthsAll,
				source: this.LV_Content.all,
				previewType: "Recipe",
			}, {
				winObj: panelWindow,
				prefix: "Favorites",
				columns: panelColList.favorites,
				columnWidths: UISets.column.widthsFavorites,
				source: this.LV_Content.favorites,
				previewType: "Recipe",
			}]

			tabHeaders := [
				panelTabList.Obj.smelting,
				panelTabList.Obj.fastkeys,
				panelTabList.Obj.secondkeys,
				panelTabList.Obj.tertiarykeys,
				panelTabList.Obj.scripts,
				panelTabList.Obj.TELEXVNI,
				panelTabList.Obj.all,
				panelTabList.Obj.favorites,
			]

			for i, header in tabHeaders {
				panelTabs.UseTab(header)

				this.AddCharactersTab(tabContents[i])
			}

			panelTabs.UseTab(panelTabList.Obj.help)

			commandsTree := panelWindow.AddTreeView(UISets.commandsInfoBox.commandsTree)
			commandsTree.OnEvent("ItemSelect", (TV, Item) => this.TV_InsertCommandsDesc(TV, Item, groupBoxCommands.text))
			commandsTree.SetFont("s10")

			groupBoxCommands := {
				group: panelWindow.AddGroupBox(UISets.commandsInfoBox.body, Locale.Read("tab_help")),
				text: panelWindow.AddLink(UISets.commandsInfoBox.text),
			}

			groupBoxCommands.group.SetFont("s11")

			for each in this.commandLabels.structured {
				if Type(each) = "String" {
					commandsTree.Add(Locale.Read(each))
				} else if Type(each) = "Map" {
					for key, value in each {
						parentalEntry := commandsTree.Add(Locale.Read(key), , InStr(key, "smelter") ? "Expand" : "")
						for eachChild in value {
							commandsTree.Add(Locale.Read(eachChild), parentalEntry)
						}
					}
				}
			}

			panelTabs.UseTab(panelTabList.Obj.about)


			aboutLeftBox := panelWindow.AddGroupBox(UISets.aboutInfoBox.leftBox)
			panelWindow.AddGroupBox(UISets.aboutInfoBox.panelWindow)
			panelWindow.AddPicture(UISets.aboutInfoBox.panelWindowIco, App.icoDLL)

			aboutTitle := panelWindow.AddText(UISets.aboutInfoBox.aboutTitle, App.Title())
			aboutTitle.SetFont("s20 c333333", "Cambria")

			aboutVersion := panelWindow.AddText(UISets.aboutInfoBox.aboutVersion, App.Ver())
			aboutVersion.SetFont("s12 c333333", "Cambria")

			aboutRepoLink := panelWindow.AddLink(UISets.aboutInfoBox.aboutRepoLink,
				'<a href="https://github.com/DemerNkardaz/DSL-KeyPad">' Locale.Read("about_repository") '</a>'
			)
			aboutRepoLink.SetFont("s12", "Cambria")

			aboutAuthor := panelWindow.AddText(UISets.aboutInfoBox.aboutAuthor, Locale.Read("about_author"))
			aboutAuthor.SetFont("s11 c333333", Fonts.fontFaces["Default"].name)

			aboutAuthorLinks := panelWindow.AddLink(UISets.aboutInfoBox.aboutAuthorLinks, Locale.Read("about_author_links"))
			aboutAuthorLinks.SetFont("s9", Fonts.fontFaces["Default"].name)

			chrCount := Format(Locale.Read("about_lib_count"),
				ChrLib.countOf.entries,
				ChrLib.countOf.glyphVariations,
				ChrLib.countOf.allKeys,
				ChrLib.countOf.fastKeys,
				ChrLib.countOf.recipes,
				ChrLib.countOf.uniqueRecipes,
				ChrLib.countOf.userRecipes,
				ChrLib.countOf.uniqueUserRecipes
			)

			aboutDescBox := panelWindow.AddGroupBox(UISets.aboutInfoBox.aboutDescBox, App.Title(["decoded"]))
			aboutDescBox.SetFont("s11 c333333", Fonts.fontFaces["Default"].name)

			aboutDescription := panelWindow.AddText(UISets.aboutInfoBox.aboutDescription, Locale.ReadInject("about_description", [App.Ver("+hotfix+postfix") " " App.Title(["status"])]))
			aboutDescription.SetFont("s11 c333333", Fonts.fontFaces["Default"].name)

			aboutChrCount := panelWindow.AddText(UISets.aboutInfoBox.aboutChrCount, chrCount)
			aboutChrCount.SetFont("s10 c333333", Fonts.fontFaces["Default"].name)

			aboutSampleWords := panelWindow.AddGroupBox(UISets.aboutInfoBox.aboutSampleWords)

			aboutSampleWordsContent := panelWindow.AddText(UISets.aboutInfoBox.aboutSampleWordsContent, Locale.Read("about_sample_words", "default"))
			aboutSampleWordsContent.SetFont("s11 c555555", Fonts.fontFaces["Default"].name)

			/*
						panelTabs.UseTab(panelTabList.Obj.useful)
			
						panelWindow.SetFont("s13")
						panelWindow.Add("Text", , Locale.Read("typography"))
						panelWindow.SetFont("s11")
						panelWindow.Add("Link", "w600", Locale.Read("typography_layout"))
						panelWindow.SetFont("s13")
						panelWindow.Add("Text", , Locale.Read("unicode_resources"))
						panelWindow.SetFont("s11")
						panelWindow.Add("Link", "w600", '<a href="https://symbl.cc/">Symbl.cc</a> <a href="https://www.compart.com/en/unicode/">Compart</a>')
						panelWindow.SetFont("s13")
						panelWindow.Add("Text", , Locale.Read("dictionaries"))
						panelWindow.SetFont("s11")
						panelWindow.Add("Link", "w600", Locale.Read("dictionaries_japanese") '<a href="https://yarxi.ru">ЯРКСИ</a> <a href="https://www.warodai.ruu">Warodai</a>')
						panelWindow.Add("Link", "w600", Locale.Read("dictionaries_chinese") '<a href="https://bkrs.info">БКРС</a>')
						panelWindow.Add("Link", "w600", Locale.Read("dictionaries_vietnamese") '<a href="https://chunom.org">Chữ Nôm</a>')
			*/
			panelTabs.UseTab()

			GUI_Util.RemoveMinMaxButtons(panelWindow.Hwnd)
			panelWindow.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)


			panelResize(guiObj, minMax, w, h) {
				UISets := this.GetUISets("WHXY", w, h)

				guiObj["Tabs"].Move(, , UISets.tabs.w, UISets.tabs.h)

				for prefix in [
					"Smelting",
					"FastKeys",
					"Glago"
				] {
					guiObj[prefix "Group"].Move(UISets.infoBox.body.x, UISets.infoBox.body.y, UISets.infoBox.body.w, UISets.infoBox.body.h)
					guiObj[prefix "GroupFrame"].Move(UISets.infoBox.preview.x, UISets.infoBox.preview.y, UISets.infoBox.preview.w, UISets.infoBox.preview.h)
					guiObj[prefix "Symbol"].Move(UISets.infoBox.preview.x, UISets.infoBox.preview.y, UISets.infoBox.preview.w, UISets.infoBox.preview.h)
					guiObj[prefix "Title"].Move(UISets.infoBox.title.x, UISets.infoBox.title.y, UISets.infoBox.title.w, UISets.infoBox.title.h)
					guiObj[prefix "LaTeXTitleLTX"].Move(UISets.infoBox.LaTeXTitleLTX.x, UISets.infoBox.LaTeXTitleLTX.y, UISets.infoBox.LaTeXTitleLTX.w, UISets.infoBox.LaTeXTitleLTX.h)
					guiObj[prefix "LaTeXTitleA"].Move(UISets.infoBox.LaTeXTitleA.x, UISets.infoBox.LaTeXTitleA.y, UISets.infoBox.LaTeXTitleA.w, UISets.infoBox.LaTeXTitleA.h)
					guiObj[prefix "LaTeXTitleE"].Move(UISets.infoBox.LaTeXTitleE.x, UISets.infoBox.LaTeXTitleE.y, UISets.infoBox.LaTeXTitleE.w, UISets.infoBox.LaTeXTitleE.h)
					guiObj[prefix "LaTeXPackage"].Move(UISets.infoBox.LaTeXPackage.x, UISets.infoBox.LaTeXPackage.y, UISets.infoBox.LaTeXPackage.w, UISets.infoBox.LaTeXPackage.h)
					guiObj[prefix "LaTeX"].Move(UISets.infoBox.LaTeX.x, UISets.infoBox.LaTeX.y, UISets.infoBox.LaTeX.w, UISets.infoBox.LaTeX.h)
					guiObj[prefix "AltTitle"].Move(UISets.infoBox.altTitle.x, UISets.infoBox.altTitle.y, UISets.infoBox.altTitle.w, UISets.infoBox.altTitle.h)
					guiObj[prefix "Alt"].Move(UISets.infoBox.alt.x, UISets.infoBox.alt.y, UISets.infoBox.alt.w, UISets.infoBox.alt.h)
					guiObj[prefix "UnicodeTitle"].Move(UISets.infoBox.unicodeTitle.x, UISets.infoBox.unicodeTitle.y, UISets.infoBox.unicodeTitle.w, UISets.infoBox.unicodeTitle.h)
					guiObj[prefix "Unicode"].Move(UISets.infoBox.unicode.x, UISets.infoBox.unicode.y, UISets.infoBox.unicode.w, UISets.infoBox.unicode.h)
					guiObj[prefix "HTMLTitle"].Move(UISets.infoBox.htmlTitle.x, UISets.infoBox.htmlTitle.y, UISets.infoBox.htmlTitle.w, UISets.infoBox.htmlTitle.h)
					guiObj[prefix "HTML"].Move(UISets.infoBox.html.x, UISets.infoBox.html.y, UISets.infoBox.html.w, UISets.infoBox.html.h)
					guiObj[prefix "Tags"].Move(UISets.infoBox.tags.x, UISets.infoBox.tags.y, UISets.infoBox.tags.w, UISets.infoBox.tags.h)
					guiObj[prefix "Alert"].Move(UISets.infoBox.alert.x, UISets.infoBox.alert.y, UISets.infoBox.alert.w, UISets.infoBox.alert.h)
					guiObj[prefix "KeyPreviewTitle"].Move(UISets.infoBox.keyPreviewTitle.x, UISets.infoBox.keyPreviewTitle.y, UISets.infoBox.keyPreviewTitle.w, UISets.infoBox.keyPreviewTitle.h)
					guiObj[prefix "KeyPreviewSet"].Move(UISets.infoBox.keyPreviewSet.x, UISets.infoBox.keyPreviewSet.y, UISets.infoBox.keyPreviewSet.w, UISets.infoBox.keyPreviewSet.h)
					guiObj[prefix "KeyPreview"].Move(UISets.infoBox.keyPreview.x, UISets.infoBox.keyPreview.y, UISets.infoBox.keyPreview.w, UISets.infoBox.keyPreview.h)
					guiObj[prefix "LegendButton"].Move(UISets.infoBox.legendButton.x, UISets.infoBox.legendButton.y, UISets.infoBox.legendButton.w, UISets.infoBox.legendButton.h)
				}
			}
			return panelWindow
		}


		if IsGuiOpen(this.panelTitle) && !redraw {
			WinActivate(this.panelTitle)
		} else {
			this.PanelGUI := Constructor()
			this.PanelGUI.Show()


			SetTimer(this.LV_SetRandomPreviews.Bind(this), -100)
		}

		SetTimer(tt, 0)
		ToolTip(Chr(0x2705))
		this.pdToolTipIncrement := 0
		SetTimer(ToolTip.Bind(""), -500)
	}

	static AddCharactersTab(options) {
		UISets := this.GetUISets()
		panelWindow := options.winObj

		if !options.hasOwnProp("previewType") {
			options.previewType := "Key"
		}

		items_LV := panelWindow.AddListView(UISets.column.listStyle " v" options.prefix "LV", options.columns)
		items_LV.SetFont("s" Cfg.Get("List_Items_Font_Size", "PanelGUI", 10, "int"))
		items_LV.OnEvent("ItemFocus", (LV, rowNumber) => this.LV_SetCharacterPreview(LV, rowNumber, { prefix: options.prefix, previewType: options.previewType }))
		items_LV.OnEvent("DoubleClick", (LV, rowNumber) => this.LV_DoubleClickHandler(LV, rowNumber, options.prefix = "Favorites"))
		items_LV.OnEvent("ContextMenu", (LV, rowNumber, isRMB, X, Y) => this.LV_ContextMenu(panelWindow, LV, rowNumber, options.prefix = "Favorites", isRMB, X, Y))

		Loop options.columns.Length {
			index := A_Index
			items_LV.ModifyCol(index, options.columnWidths[index])
		}

		for item in options.source {
			items_LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
		}

		items_FilterIcon := panelWindow.AddButton(UISets.filter.icon)
		GuiButtonIcon(items_FilterIcon, ImageRes, 169)
		items_Filter := panelWindow.AddEdit(UISets.filter.field options.prefix "Filter", "")
		items_Filter.SetFont("s10")
		items_Filter.OnEvent("Change", (E, I) => this.LV_FilterBridge(panelWindow, options.prefix "Filter", items_LV, options.source, E.Text))

		GroupBoxOptions := {
			group: panelWindow.AddGroupBox("v" options.prefix "Group " UISets.infoBox.body, UISets.infoBox.bodyText),
			groupFrame: panelWindow.AddGroupBox("v" options.prefix "GroupFrame " UISets.infoBox.previewFrame),
			preview: panelWindow.AddEdit("v" options.prefix "Symbol " UISets.infoBox.preview, UISets.infoBox.previewText),
			title: panelWindow.AddText("v" options.prefix "Title " UISets.infoBox.title, UISets.infoBox.titleText),
			;
			LaTeXTitleLTX: panelWindow.AddText("v" options.prefix "LaTeXTitleLTX " UISets.infoBox.LaTeXTitleLTX, UISets.infoBox.LaTeXTitleLTXText).SetFont("s10", "Cambria"),
			LaTeXTitleA: panelWindow.AddText("v" options.prefix "LaTeXTitleA " UISets.infoBox.LaTeXTitleA, UISets.infoBox.LaTeXTitleAText).SetFont("s9", "Cambria"),
			LaTeXTitleE: panelWindow.AddText("v" options.prefix "LaTeXTitleE " UISets.infoBox.LaTeXTitleE, UISets.infoBox.LaTeXTitleEText).SetFont("s10", "Cambria"),
			LaTeXPackage: panelWindow.AddText("v" options.prefix "LaTeXPackage " UISets.infoBox.LaTeXPackage, UISets.infoBox.LaTeXPackageText).SetFont("s9"),
			LaTeX: panelWindow.AddEdit("v" options.prefix "LaTeX " UISets.infoBox.LaTeX, UISets.infoBox.LaTeXText),
			;
			altTitle: panelWindow.AddText("v" options.prefix "AltTitle " UISets.infoBox.altTitle, Locale.Read("symbol_altcode")).SetFont("s9"),
			altPages: panelWindow.AddText("v" options.prefix "AltPages " UISets.infoBox.altPages, Locale.ReadInject("symbol_altcode_pages", [""])).SetFont("s9"),
			alt: panelWindow.AddEdit("v" options.prefix "Alt " UISets.infoBox.alt, UISets.infoBox.altText),
			;
			unicodeTitle: panelWindow.AddText("v" options.prefix "UnicodeTitle " UISets.infoBox.unicodeTitle, Locale.Read("preview_unicode")).SetFont("s9"),
			unicode: panelWindow.AddEdit("v" options.prefix "Unicode " UISets.infoBox.unicode, UISets.infoBox.unicodeText),
			;
			htmlTitle: panelWindow.AddText("v" options.prefix "HTMLTitle " UISets.infoBox.htmlTitle, Locale.Read("preview_html")).SetFont("s9"),
			html: panelWindow.AddEdit("v" options.prefix "HTML " UISets.infoBox.html, UISets.infoBox.htmlText),
			;
			tags: panelWindow.AddEdit("v" options.prefix "Tags " UISets.infoBox.tags),
			alert: panelWindow.AddEdit("v" options.prefix "Alert " UISets.infoBox.alert),
			;
			keyPreviewTitle: panelWindow.AddText("v" options.prefix "KeyPreviewTitle " UISets.infoBox.keyPreviewTitle, options.previewType = "Recipe" ? Locale.Read("col_recipe") : Locale.Read("col_key")).SetFont("s9"),
			keyPreviewSet: panelWindow.AddText("v" options.prefix "KeyPreviewSet " UISets.infoBox.keyPreviewSet, UISets.infoBox.keyPreviewSetText).SetFont("s12"),
			keyPreview: panelWindow.AddEdit("v" options.prefix "KeyPreview " UISets.infoBox.keyPreview, "N/A"),
			legendButton: panelWindow.AddButton("v" options.prefix "LegendButton " UISets.infoBox.legendButton, Chr(0x1F4D6)),
			glyphsVariantsButton: panelWindow.AddButton("v" options.prefix "GlyphsVariantsButton " UISets.infoBox.glyphsVariantsButton, Chr(0x1D57B)),
			unicodeBlockLabel: panelWindow.AddText("v" options.prefix "UnicodeBlockLabel " UISets.infoBox.unicodeBlockLabel, ""),
		}

		previewFont := Cfg.Get("Preview_Font_Family", "PanelGUI", Fonts.fontFaces["Default"].name)

		GroupBoxOptions.preview.SetFont("s" UISets.infoFonts.previewSize, previewFont)
		GroupBoxOptions.title.SetFont("s" UISets.infoFonts.titleSize, previewFont)
		GroupBoxOptions.LaTeX.SetFont("s12")
		GroupBoxOptions.alt.SetFont("s12")
		GroupBoxOptions.unicode.SetFont("s12")
		GroupBoxOptions.html.SetFont("s12")
		GroupBoxOptions.tags.SetFont("s9")
		GroupBoxOptions.alert.SetFont("s10", Fonts.fontFaces["Default"].name)
		GroupBoxOptions.keyPreview.SetFont("s12")
		GroupBoxOptions.legendButton.SetFont("s11")
		GroupBoxOptions.legendButton.Enabled := False
		GroupBoxOptions.glyphsVariantsButton.SetFont("s11")
		GroupBoxOptions.glyphsVariantsButton.Enabled := False
		GroupBoxOptions.unicodeBlockLabel.SetFont("s9 c5088c8")

		GroupBoxOptions.unicodeBlockLabel.OnEvent("Click", (*) => UnicodeBlockWebResource(GroupBoxOptions.unicodeBlockLabel.Text))
		GroupBoxOptions.legendButton.OnEvent("Click", (B, I) => this.PreviewButtonsBridge(panelWindow, options.prefix, "ChrLegend"))
		GroupBoxOptions.glyphsVariantsButton.OnEvent("Click", (B, I) => this.PreviewButtonsBridge(panelWindow, options.prefix, "GlyphsPanel"))

		return
	}

	static TV_InsertCommandsDesc(TV, Item, TargetTextBox) {
		if !Item {
			return
		}

		selectedLabel := TV.GetText(Item)

		for label in this.commandLabels.flat {
			if (Locale.Read(label) = selectedLabel) {
				TargetTextBox.Text := Locale.Read(label "_description")
				TargetTextBox.SetFont("s11", "Segoe UI")
			}
		}
	}

	static LV_ContextMenu(panelWindow, LV, rowNumber, isFavorite := False, isRMB := False, X := 0, Y := 0) {
		if !isRMB
			return
		try {
			if StrLen(LV.GetText(rowNumber, 1)) < 1 {
				return
			} else {
				titleCol := LV.GetText(rowNumber, 1)
				entryCol := LV.GetText(rowNumber, 5)
				unicode := ChrLib.entries.%entryCol%.unicode
				unicodeBlock := ChrLib.entries.%entryCol%.unicodeBlock
				sequence := ChrLib.entries.%entryCol%.sequence
				altsCount := ObjOwnPropCount(ChrLib.entries.%entryCol%.alterations)
				hasLegend := ChrLib.entries.%entryCol%.options.legend != ""
				value := ChrLib.GetEntry(entryCol)

				if StrLen(unicode) > 0 {
					star := " " Chr(0x2605)
					isCharFavorite := FavoriteChars.CheckVar(entryCol)
					contextMenu := Menu()

					labels := {
						fav: Locale.Read("gui_panel_context_" (isCharFavorite ? "remove" : "add") "_favorites"),
						showSymbolPage: Locale.ReadInject("gui_panel_context_show_symbol_page", [UnicodeWebResource.GetCurrentResource()]),
						showBlockPage: Locale.ReadInject("gui_panel_context_show_block_page", [UnicodeBlockWebResource.GetCurrentResource()]),
						glyphVariations: Locale.Read("gui_panel_context_glyph_variations"),
						legend: Locale.Read("gui_panel_context_legend"),
						showEntry: Locale.ReadInject("gui_panel_context_show_entry", [entryCol])
					}

					contextMenu.Add(labels.fav, doFav)
					contextMenu.Add()
					contextMenu.Add(labels.showSymbolPage, (*) => UnicodeWebResource("Copy", unicode))
					contextMenu.Add(labels.showBlockPage, (*) => UnicodeBlockWebResource(unicodeBlock))
					contextMenu.Add()
					contextMenu.Add(labels.glyphVariations, (*) => GlyphsPanel(entryCol))
					contextMenu.Add(labels.legend, (*) => ChrLegend(entryCol))
					contextMenu.Add()
					contextMenu.Add(labels.showEntry, (*) => ChrLib.EntryPreview(entryCol))

					if altsCount = 0
						contextMenu.Disable(labels.glyphVariations)

					if !hasLegend
						contextMenu.Disable(labels.legend)

					contextMenu.Show(X, Y)
					return

					doFav(*) {
						SoundPlay("C:\Windows\Media\Speech Misrecognition.wav")
						if !isCharFavorite && !InStr(titleCol, star) {
							FavoriteChars.Add(entryCol)
							LV.Modify(rowNumber, , titleCol star)
						} else if isCharFavorite {
							FavoriteChars.Remove(entryCol, isFavorite)
							LV.Modify(rowNumber, , StrReplace(titleCol, star))
						}

					}
				}
			}
		}
	}

	static LV_DoubleClickHandler(LV, rowNumber, isFavorite := False) {
		star := " " Chr(0x2605)
		if StrLen(LV.GetText(rowNumber, 4)) < 1 {
			return
		} else {
			titleCol := LV.GetText(rowNumber, 1)
			entryCol := LV.GetText(rowNumber, 5)
			unicode := ChrLib.entries.%entryCol%.unicode
			sequence := ChrLib.entries.%entryCol%.sequence
			value := ChrLib.GetEntry(entryCol)

			if StrLen(unicode) > 0 {
				isCtrlDown := GetKeyState("LControl")
				isShiftDown := GetKeyState("LShift")

				if (isCtrlDown) {
					unicodeCodePoint := Util.UnicodeToChar(sequence.length > 1 ? sequence : unicode)
					A_Clipboard := unicodeCodePoint

					SoundPlay("C:\Windows\Media\Speech On.wav")
				} else if isShiftDown {
					if (unicode = Util.ExtractHex(value.unicode)) {
						SoundPlay("C:\Windows\Media\Speech Misrecognition.wav")
						if !FavoriteChars.CheckVar(entryCol) && !InStr(titleCol, star) {
							FavoriteChars.Add(entryCol)
							LV.Modify(rowNumber, , titleCol star)
						} else {
							FavoriteChars.Remove(entryCol, isFavorite)
							LV.Modify(rowNumber, , StrReplace(titleCol, star))
						}
					}

				} else {
					UnicodeWebResource("Copy", unicode)
				}
			}
		}
	}

	static LV_SetRandomPreviews() {
		for each in ["Smelting", "FastKeys", "SecondKeys", "TertiaryKeys", "Glago", "TELEX/VNI", "AllSymbols", "Favorites"]
			try
				this.LV_SetRandomPreview(each)
	}

	static LV_SetRandomPreview(prefix) {
		panelGUI := this.PanelGUI
		LV := panelGUI[prefix "LV"]
		total := LV.GetCount()
		if total = 0
			return

		loopCount := 0
		maxTries := 100
		while True {
			rand := Random(1, total)
			col1 := LV.GetText(rand, 1)
			col4 := LV.GetText(rand, 4)
			if (col1 != "" && col4 != "")
				break
			loopCount++
			if loopCount > maxTries
				return
		}

		LV.Modify(rand, "+Select +Focus")
		this.LV_SetCharacterPreview(LV, rand, { prefix: prefix })
	}

	static LV_SetCharacterPreview(LV, rowValue, options) {
		UISets := this.GetUISets()
		characterEntry := LV.GetText(rowValue, 5)
		characterKey := LV.GetText(rowValue, 2)
		characterCombinationKey := LV.GetText(rowValue, 6)

		try {
			if options.prefix ~= "i)Keys" {
				characterKey := Util.ReplaceModifierKeys(ChrLib.GetValue(rowValue, "options").fastKey)
			} else if options.prefix = "Glago" {
				characterKey := Util.ReplaceModifierKeys(ChrLib.GetValue(rowValue, "options").altLayoutKey)
			}
		}

		previewFont := Cfg.Get("Preview_Font_Family", "PanelGUI", Fonts.fontFaces["Default"].name)

		if StrLen(characterEntry) < 1 {
			this.PanelGUI[options.prefix "Title"].Text := "N/A"
			this.PanelGUI[options.prefix "Symbol"].Text := DottedCircle
			this.PanelGUI[options.prefix "Unicode"].Text := "0000"
			this.PanelGUI[options.prefix "HTML"].Text := "&#x0000;"
			this.PanelGUI[options.prefix "Alt"].Text := "N/A"
			this.PanelGUI[options.prefix "AltPages"].Text := ""
			this.PanelGUI[options.prefix "LaTeX"].Text := "N/A"
			this.PanelGUI[options.prefix "LaTeXPackage"].Text := ""
			this.PanelGUI[options.prefix "Tags"].Text := ""
			this.PanelGUI[options.prefix "Group"].Text := Locale.Read("character")
			this.PanelGUI[options.prefix "Alert"].Text := ""

			this.PanelGUI[options.prefix "Title"].SetFont("s" UISets.infoFonts.titleSize " norm cDefault", previewFont)
			this.PanelGUI[options.prefix "Symbol"].SetFont("s" UISets.infoFonts.previewSize " norm cDefault", previewFont)
			this.PanelGUI[options.prefix "Unicode"].SetFont("s12")
			this.PanelGUI[options.prefix "HTML"].SetFont("s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont("s12")

			this.PanelGUI[options.prefix "KeyPreview"].Text := "N/A"
			this.PanelGUI[options.prefix "KeyPreview"].SetFont("s12")
			this.PanelGUI[options.prefix "KeyPreviewSet"].Text := ""
			this.PanelGUI[options.prefix "LegendButton"].Enabled := False
			this.PanelGUI[options.prefix "GlyphsVariantsButton"].Enabled := False
			this.PanelGUI[options.prefix "UnicodeBlockLabel"].Text := ""

			return
		} else {
			languageCode := Language.Get()
			value := ChrLib.GetEntry(characterEntry)

			getChar := Util.UnicodeToChar(value.sequence.Length > 0 ? value.sequence : value.unicode)
			htmlCode := Util.StrToHTML(getChar)
			previewSymbol := StrLen(value.symbol.alt) > 0 ? value.symbol.alt : value.symbol.set
			entryString := Locale.Read("entry") ": [" characterEntry "]"
			characterTitle := ""

			skipCombine := True
			combinedTitle := ""

			if value.options.localeCombineAnd {
				split := StrSplit(characterEntry, "_and_")
				if split.Length > 1 {
					for i, each in split {
						if Locale.Read(each "_alt", , True, &titleText) || Locale.Read(each, , True, &titleText) {
							combinedTitle .= titleText " " (i < split.Length ? Locale.Read("and") " " : "")
							skipCombine := False
						}
					}
				}
			}

			if options.HasOwnProp("previewType") && options.previewType = "Alternative Layout" &&
				(value.options.layoutTitles) &&
				(Locale.Read(characterEntry "_layout_alt", , True, &titleText) ||
					Locale.Read(characterEntry "_layout", , True, &titleText)) {
				characterTitle := titleText
			} else if !skipCombine {
				characterTitle := combinedTitle

			} else if Locale.Read(characterEntry "_alt", , True, &titleText) {
				characterTitle := titleText

			} else if Locale.Read(characterEntry, , True, &titleText) {
				characterTitle := titleText

			} else if value.titles.Count > 0 && value.titles.Has(languageCode) {
				characterTitle := value.titles[languageCode (value.titles.Has(languageCode "_alt") ? "_alt" : "")]

			} else {
				characterTitle := Locale.Read(characterEntry)
			}

			if options.HasOwnProp("previewType") && options.previewType = "Alternative Layout"
				&& value.options.showOnAlt != "" && value.alterations.HasOwnProp(value.options.showOnAlt) {
				previewSymbol := Util.UnicodeToChar(value.alterations.%value.options.showOnAlt%)
				entryString .= " :: " value.options.showOnAlt
			}


			this.PanelGUI[options.prefix "Title"].Text := characterTitle
			this.PanelGUI[options.prefix "Symbol"].Text := previewSymbol
			this.PanelGUI[options.prefix "Unicode"].Text := value.sequence.Length > 0 ? Util.StrCutBrackets(value.sequence.ToString(" ")) : Util.StrCutBrackets(value.unicode)
			this.PanelGUI[options.prefix "HTML"].Text := StrLen(value.entity) > 0 ? [htmlCode, value.entity].ToString(" ") : htmlCode
			this.PanelGUI[options.prefix "Alt"].Text := StrLen(value.altCode) > 0 ? value.altCode : "N/A"
			this.PanelGUI[options.prefix "AltPages"].Text := value.altCodePages.Length > 0 ? Locale.ReadInject("symbol_altcode_pages", [value.altCodePages.ToString()]) : ""
			this.PanelGUI[options.prefix "LaTeX"].Text := value.LaTeX.Length > 0 ? value.LaTeX.ToString(Chr(0x2002)) : "N/A"
			this.PanelGUI[options.prefix "LaTeXPackage"].Text := StrLen(value.LaTeXPackage) > 0 ? Chrs(0x1F4E6, 0x2005) value.LaTeXPackage : ""


			this.PanelGUI[options.prefix "Title"].SetFont((StrLen(this.PanelGUI[options.prefix "Title"].Text) > 30) ? "s12" : "s" UISets.infoFonts.titleSize)

			this.PanelGUI[options.prefix "Symbol"].SetFont(, StrLen(value.symbol.font) > 0 ? value.symbol.font : previewFont)
			this.PanelGUI[options.prefix "Symbol"].SetFont("s" UISets.infoFonts.previewSize " norm cDefault")
			this.PanelGUI[options.prefix "Symbol"].SetFont(StrLen(value.symbol.customs) > 0 ? value.symbol.customs : StrLen(this.PanelGUI[options.prefix "Symbol"].Text) > 2 ? "s" UISets.infoFonts.previewSmaller " norm cDefault" : "s" UISets.infoFonts.previewSize " norm cDefault")


			this.PanelGUI[options.prefix "Unicode"].SetFont((StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "Unicode"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "HTML"].SetFont((StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "HTML"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont((StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 20) ? "s9" : "s12")

			tagsString := value.tags.Length > 0 ? Locale.Read("tags") ": " value.tags.ToString() : ""

			this.PanelGUI[options.prefix "Tags"].Text := entryString Chr(0x2002) tagsString


			groupTitle := ""
			isDiacritic := RegExMatch(value.symbol.set, "^" DottedCircle "\S")

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
				"IsSmallCaps", [value.alterations.HasOwnProp("smallCapital"), 0x029C],
				; "IsSmall", [value.alterations.HasOwnProp("small"), 0xFE57],
			)

			for entry, value in AlterationsValidator {
				if (value[1]) {
					groupTitle .= (["(h)", 0x029C].HasValue(value[2]) ? (value[2] is Number ? Chr(value[2]) : value[2])
						: DottedCircle Chr(value[2])) " "
				}
			}

			this.PanelGUI[options.prefix "Group"].Text := groupTitle (isDiacritic ? Locale.Read("character_combining") : Locale.Read("character"))
			this.PanelGUI[options.prefix "Alert"].Text := value.symbol.font != "" ? Chr(0x1D4D5) " " value.symbol.font : ""

			this.PanelGUI[options.prefix "KeyPreview"].Text := characterKey
			this.PanelGUI[options.prefix "KeyPreviewSet"].Text := characterCombinationKey != "" ? characterCombinationKey : ""


			keyPreviewLength := StrLen(StrReplace(this.PanelGUI[options.prefix "KeyPreview"].Text, Chr(0x25CC), ""))
			KeyPreviewSetLength := StrLen(this.PanelGUI[options.prefix "KeyPreviewSet"].Text)


			hMult := keyPreviewLength > 25 ? 2 : 1
			this.PanelGUI[options.prefix "KeyPreview"].Move(, , , 24 * hMult)


			; this.PanelGUI[options.prefix "KeyPreview"].SetFont((keyPreviewLength > 25 && keyPreviewLength < 36) ? "s10" : (keyPreviewLength > 36) ? "s9" : "s12")
			this.PanelGUI[options.prefix "KeyPreview"].SetFont("s12")

			this.PanelGUI[options.prefix "KeyPreviewSet"].SetFont((KeyPreviewSetLength > 5) ? "s10" : "s12")


			this.PanelGUI[options.prefix "LegendButton"].Enabled := StrLen(value.options.legend) > 1 ? True : False
			this.PanelGUI[options.prefix "GlyphsVariantsButton"].Enabled := ObjOwnPropCount(value.alterations) > 0 ? True : False

		}

		if value.unicodeBlock != ""
			this.PanelGUI[options.prefix "UnicodeBlockLabel"].Text := value.unicodeBlock
	}

	static PreviewButtonsBridge(guiObj, prefix, callType := "GlyphsPanel") {
		tagsElement := guiObj[prefix "Tags"]
		RegExMatch(tagsElement.Text, "\[([^\]]+)\]", &entryName)

		callMethods := Map(
			"GlyphsPanel", (*) => GlyphsPanel(entryName[1]),
			"ChrLegend", (*) => ChrLegend(entryName[1])
		)

		callMethods[callType]()
	}

	static LV_FilterPopulate(LV, DataList) {
		LV.Delete()
		for item in DataList {
			LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
		}
	}

	static LV_FilterBridge(guiFrame, filterField, LV, dataList, filterText) {
		static lastFilterText := ""
		currentFilterText := guiFrame[filterField].Text

		SetTimer(() => this.LV_FilterCheck(guiFrame, filterField, LV, dataList, currentFilterText, &lastFilterText), -500)
	}

	static LV_FilterCheck(guiFrame, filterField, LV, dataList, originalFilterText, &lastFilterText) {
		currentFilterText := guiFrame[filterField].Text

		if (currentFilterText == originalFilterText) {
			this.LV_Filter(guiFrame, filterField, LV, dataList, currentFilterText)
			lastFilterText := currentFilterText
		}
	}

	static LV_Filter(guiFrame, filterField, LV, dataList, filterText) {
		filterText := filterText
		LV.Delete()

		if filterText = "" {
			this.LV_FilterPopulate(LV, dataList)
		} else {
			GroupStarted := False
			PreviousGroupName := ""

			try {
				for item in dataList {
					if item[1] = "" {
						continue
					}

					ItemText := StrReplace(item[1], Chr(0x00A0), " ")
					ReserveArray := [StrReplace(item[1], Chr(0x00A0), " "), item[5]]
					IsFavorite := InStr(ItemText, Chr(0x2605))
					IsMatch := ItemText ~= filterText || ReserveArray.HasRegEx(filterText) || (IsFavorite && filterText ~= "^(изб|fav|\*)")

					if IsMatch {
						if !GroupStarted {
							GroupStarted := true
						}
						LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
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
			} catch {
				this.LV_FilterPopulate(LV, dataList)
			}
		}
	}

	static combinationKeyToGroupPairs := Map()

	static LV_InsertGroup(options) {
		if Type(options) = "Array" {
			outputArrays := []
			for each in options {
				ArrayMergeTo(outputArrays, this.LV_InsertGroup(each))
			}

			return outputArrays
		} else if options.group is Array {
			outputArrays := []
			lastGroupKey := ""
			for i, each in options.group {
				outputArrays := []
				lastGroupKey := ""

				for i, each in options.group {
					eachOptions := options.Clone()
					eachOptions.group := each

					if options.HasOwnProp("groupKey") {
						if options.groupKey is Map && options.groupKey.Has(each) {
							eachOptions.groupKey := options.groupKey.Get(each)
							lastGroupKey := eachOptions.groupKey
						} else
							eachOptions.DeleteProp("groupKey")
					}

					if options.hasOwnProp("subType") {
						if options.subType is Map && options.subType.Has(each) {
							eachOptions.subType := options.subType.Get(each)
						} else {
							eachOptions.DeleteProp("subType")
						}
					}

					if options.HasOwnProp("combinationKey") {
						if options.combinationKey is Map && options.combinationKey.Has(each) {
							eachOptions.combinationKey := options.combinationKey.Get(each)
						} else {
							if lastGroupKey != ""
								eachOptions.combinationKey := lastGroupKey
							else
								eachOptions.DeleteProp("combinationKey")
						}
					} else if lastGroupKey != ""
						eachOptions.combinationKey := lastGroupKey


					if options.type = "Fast Key" {
						this.combinationKeyToGroupPairs.Set(
							eachOptions.group,
							eachOptions.HasOwnProp("combinationKey") ? eachOptions.combinationKey : lastGroupKey
						)
					}

					ArrayMergeTo(outputArrays, this.LV_InsertGroup(eachOptions))
				}

				return outputArrays
			}

			return outputArrays
		} else {

			if options.group == "" {
				return [["", "", "", "", "", "", ""]]
			}

			if !(options.hasOwnProp("type")) {
				throw "Type is required for LV_InsertGroup"
			}

			languageCode := Language.Get()
			outputArray := []
			intermediateMap := Map()


			if options.hasOwnProp("separator") && options.separator
				outputArray.Push(["", "", "", "", "", "", ""])
			if options.HasOwnProp("groupKey") && StrLen(options.groupKey) > 0
				outputArray.Push(["", options.groupKey, "", "", "", "", ""])


			for groupKey, entryNamesArray in ChrLib.entryGroups {
				if !([groupKey].HasRegEx(options.group)) || entryNamesArray.Length = 0 {
					continue
				} else {
					for entryName in entryNamesArray {
						value := ChrLib.GetEntry(entryName)

						isFavorite := FavoriteChars.CheckVar(entryName)

						try {
							if (value.options.hidden) ||
								(options.hasOwnProp("blacklist") && options.blacklist.HasRegEx(entryName)) ||
								(!value.groups.HasRegEx(options.group)) ||
								(options.type = "Recipe" && (value.recipe.Length = 0)) ||
								(options.type = "Fast Key" && (StrLen(value.options.fastKey) < 2)) ||
								(options.type = "Fast Key Special" && (StrLen(value.options.specialKey) < 2)) ||
								(options.type = "Alternative Layout" && (StrLen(value.options.altLayoutKey) < 2)) ||
								(options.type = "TELEX/VNI" && (!value.options.HasOwnProp("telex__" options.subType) ||
									value.options.HasOwnProp("telex__" options.subType) && value.options.telex__%options.subType% = "")
								)
							{
								continue
							}
						} catch {
							throw "Trouble in paradise: " entryName " typeof groupKey" Type(options.groupKey) " recipe" Type(value.recipe) " fastKey" Type(value.options.fastKey) " specialKey" Type(value.options.specialKey) " altLayoutKey" Type(value.options.altLayoutKey)
						}

						characterTitle := ""

						skipCombine := True
						combinedTitle := ""

						if value.options.localeCombineAnd {
							split := StrSplit(entryName, "_and_")
							if split.Length > 1 {
								for i, each in split {
									if Locale.Read(each "_alt", , True, &titleText) || Locale.Read(each, , True, &titleText) {
										combinedTitle .= titleText " " (i < split.Length ? Locale.Read("and") " " : "")
										skipCombine := False
									}
								}
							}
						}

						if options.type = "Alternative Layout" && value.options.layoutTitles &&
							Locale.Read(entryName "_layout", , True, &titleText) {
							characterTitle := titleText

						} else if !skipCombine {
							characterTitle := combinedTitle

						} else if Locale.Read(entryName, , True, &titleText) {
							characterTitle := titleText

						} else if value.titles.Count > 0 && value.titles.Has(languageCode) {
							characterTitle := value.titles.Get(languageCode)

						} else {
							characterTitle := Locale.Read(entryName)
						}

						if isFavorite {
							characterTitle .= " " Chr(0x2605)
						}

						characterSymbol := value.symbol.set

						characterBinding := ""

						bindings := Map(
							"Recipe", value.recipeAlt.Length > 0 ? value.recipeAlt.ToString() : value.recipe.Length > 0 ? value.recipe.ToString() : "",
							"Alternative Layout", value.options.altLayoutKey,
							"Special Combinations", value.options.altSpecialKey,
							"Fast Key", value.options.fastKey,
							"TELEX/VNI", options.type = "TELEX/VNI" && value.options.HasOwnProp("telex__" options.subType) ? value.options.telex__%options.subType% : "",
						)

						characterBinding := bindings.Has(options.type) ? bindings.Get(options.type) : options.type = "" && value.recipeAlt.Length > 0 ? value.recipeAlt.ToString() : ""

						reserveCombinationKey := ""

						for cgroup, ckey in this.combinationKeyToGroupPairs {
							reserveCombinationKey := value.groups.HasValue(cgroup) ? ckey : reserveCombinationKey
						}
						reserveCombinationKey := (reserveCombinationKey != "" ? reserveCombinationKey " + " : "")

						intermediateMap.Set(value.index,
							options.group = "Favorites"
								? [
									characterTitle,
									bindings["Recipe"],
									bindings["Fast Key"] != "" ? reserveCombinationKey bindings["Fast Key"]
									: bindings["Alternative Layout"] != "" ? reserveCombinationKey bindings["Alternative Layout"]
									: "",
									characterSymbol,
									entryName,
									""
								]
							: [
								characterTitle,
								characterBinding,
								characterSymbol,
								Util.ExtractHex(value.unicode),
								entryName,
								options.hasOwnProp("combinationKey") ? options.combinationKey : options.hasOwnProp("groupKey") ? options.groupKey : ""
							])
					}
				}
			}

			for cgroup, value in intermediateMap {
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