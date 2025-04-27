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
		lvCols := [lvW * 0.55, lvW * 0.2, lvW * 0.1, lvW * 0.1, 0, 0]

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

		commandsBoxW := (panelWidth - commandsTreeW) - (50 * 1.4)
		commandsBoxH := commandsTreeH + 9
		commandsBoxX := commandsTreeW + 50
		commandsBoxY := 36

		commandsTexW := commandsBoxW - 20
		commandsTexH := commandsBoxH - 40
		commandsTexX := commandsBoxX + 10
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
		aboutAuthorLinksX := aboutLeftX + ((aboutLeftW - aboutAuthorLinksW) / 2) + 9
		aboutAuthorLinksY := (aboutAuthorY + aboutAuthorH) + 14

		aboutDescBoxW := (panelWidth - aboutLeftW) - (50 * 1.4)
		aboutDescBoxH := aboutLeftH + 2
		aboutDescBoxX := (aboutLeftX + aboutLeftW) + 10
		aboutDescBoxY := 32

		aboutDescriptionW := 505
		aboutDescriptionH := aboutDescBoxH - 40
		aboutDescriptionX := aboutDescBoxX + 10
		aboutDescriptionY := aboutDescBoxY + 38

		aboutChrCountW := aboutDescriptionW
		aboutChrCountH := 24
		aboutChrCountX := aboutDescriptionX
		aboutChrCountY := ((aboutLeftH - 45) + 32) + 14

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
				title: Format("x{} y{} w{} h{} Center BackgroundTrans",
					(ibBodyX + ibPreviewFrameX), ibPreviewTitleY, ibPreviewBoxEditW, ibPreviewTitleH),
				titleText: "N/A",
				LaTeXTitleA: Format("x{} y{} w{} h{} BackgroundTrans",
					(ibBodyX + ibPreviewFrameX) + 4, 371, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXTitleAText: "A",
				LaTeXTitleE: Format("x{} y{} w{} h{} BackgroundTrans",
					(ibBodyX + ibPreviewFrameX) + 17, 375, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXTitleEText: "E",
				LaTeXTitleLTX: Format("x{} y{} w{} h{} BackgroundTrans",
					(ibBodyX + ibPreviewFrameX), 373, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXTitleLTXText: "L T  X",
				LaTeXPackage: Format("x{} y{} w{} h{} BackgroundTrans Right",
					ibBodyX + ibPreviewFrameX, 373, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXPackageText: "",
				LaTeX: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 390, ibPreviewBoxEditW, ibPreviewBoxEditH),
				LaTeXText: "N/A",
				alt: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 430, ibPreviewBoxEditW, ibPreviewBoxEditH),
				altTitle: Format("x{} y{} w{} h{} BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 415, ibPreviewBoxEditW, ibPreviewBoxEditH),
				altText: "N/A",
				unicode: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 470, ibPreviewBoxEditW, ibPreviewBoxEditH),
				unicodeTitle: Format("x{} y{} w{} h{} BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 455, ibPreviewBoxEditW, ibPreviewBoxEditH),
				unicodeText: "U+0000",
				html: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 510, ibPreviewBoxEditW, ibPreviewBoxEditH),
				htmlText: "&#x0000;",
				htmlTitle: Format("x{} y{} w{} h{} BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 495, ibPreviewBoxEditW, ibPreviewBoxEditH),
				tags: Format("x{} y{} w{} h{} readonly -VScroll -HScroll -E0x200",
					baseX, tagsY, tagsW, ibPreviewBoxEditH),
				alert: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll -E0x200",
					ibBodyX + ibPreviewFrameX, 55, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreviewTitle: Format("x{} y{} w{} h{} BackgroundTrans",
					ibBodyX + ibPreviewFrameX, 305, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreview: Format("x{} y{} w{} h{} readonly Center -VScroll -HScroll",
					ibBodyX + ibPreviewFrameX, 320, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreviewSet: Format("x{} y{} w{} h{} BackgroundTrans Right",
					ibBodyX + ibPreviewFrameX, 301, ibPreviewBoxEditW, ibPreviewBoxEditH),
				keyPreviewSetText: "",
				legendButton: Format("x{} y{} h{} w{}",
					ibPreviewButtonOffsetX, ibPreviewFrameY - 1, ibPreviewButtonW, ibPreviewButtonH),
			},
			commandsInfoBox: {
				commandsTree: Format("vCommandTree x{} y{} w{} h{} -HScroll",
					commandsTreeX, commandsTreeY, commandsTreeW, commandsTreeH),
				body: Format("vCommandGroup x{} y{} w{} h{}",
					commandsBoxX, commandsBoxY, commandsBoxW, commandsBoxH),
				bodyText: Map("ru", "Команда", "en", "Command"),
				text: Format("vCommandDescription x{} y{} w{} h{}",
					commandsTexX, commandsTexY, commandsTexW, commandsTexH),
			},
			aboutInfoBox: {
				leftBox: Format("vAboutGroupBox x{} y{} w{} h{}",
					aboutLeftX, aboutLeftY, aboutLeftW, aboutLeftH),
				panelWindow: Format("vAboutPanelWindow x{} y{} w{} h{}",
					aboutPanelWindowX, aboutPanelWindowY, aboutPanelWindowW, aboutPanelWindowH),
				panelWindowIco: Format("vAboutIco x{} y{} w{} h{}",
					aboutPanelWindowIcoX, aboutPanelWindowIcoY, aboutPanelWindowIcoW, aboutPanelWindowIcoH),
				aboutTitle: Format("vAboutTitle x{} y{} w{} h{} Center BackgroundTrans",
					aboutTitleX, aboutTitleY, aboutTitleW, aboutTitleH),
				aboutVersion: Format("vAboutVersion x{} y{} w{} h{} Center BackgroundTrans",
					aboutVersionX, aboutVersionY, aboutVersionW, aboutVersionH),
				aboutRepoLink: Format("vAboutRepoLink x{} y{} w{} h{}",
					aboutRepoLinkX, aboutRepoLinkY, aboutRepoLinkW, aboutRepoLinkH),
				aboutAuthor: Format("vAboutAuthor x{} y{} w{} h{} Center BackgroundTrans",
					aboutAuthorX, aboutAuthorY, aboutAuthorW, aboutAuthorH),
				aboutAuthorLinks: Format("vAboutAuthorLinks x{} y{} w{} h{}",
					aboutAuthorLinksX, aboutAuthorLinksY, aboutAuthorLinksW, aboutAuthorLinksH),
				aboutDescBox: Format("vAboutDescBox x{} y{} w{} h{}",
					aboutDescBoxX, aboutDescBoxY, aboutDescBoxW, aboutDescBoxH),
				aboutDescription: Format("vAboutDescription x{} y{} w{} h{} Wrap BackgroundTrans",
					aboutDescriptionX, aboutDescriptionY, aboutDescriptionW, aboutDescriptionH),
				aboutChrCount: Format("vAboutChrCount x{} y{} w{} h{} Wrap BackgroundTrans",
					aboutChrCountX, aboutChrCountY, aboutChrCountW, aboutChrCountH),
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
			},
			filter: {
				icon: { x: baseX, y: filterY, h: ibPreviewBoxEditH, w: filterButtonW },
				field: { x: filterOffsetX, y: filterY, h: ibPreviewBoxEditH, w: filterW },
			},
			column: {
				widths: lvCols,
				widthsSmelting: lvCols,
				listStyle: { w: lvW, h: lvH }
			},
		}

		return %set%
	}


	static commandLabels := { structured: [
		"func_label_controls",
		"func_label_disable",
		"func_label_gotopage",
		"func_label_selgoto",
		"func_label_favorites",
		"func_label_copylist",
		"func_label_tagsearch",
		"func_label_uninsert",
		"func_label_altcode",
		Map("func_label_smelter", [
			"func_label_compose",
		]),
		"func_label_num_superscript",
		"func_label_num_roman",
		"func_label_fastkeys",
		Map("func_label_alterations", [
			"func_label_alterations_combining",
			"func_label_alterations_modifier",
			"func_label_alterations_italic_to_bold",
			"func_label_alterations_fraktur_script_struck",
			"func_label_alterations_sans_serif",
			"func_label_alterations_monospace",
			"func_label_alterations_small_capital",
		],
			"func_label_scripts", [
				"func_label_glagolitic_futhark",
				"func_label_old_permic_old_turkic",
				"func_label_old_hungarian",
				"func_label_gothic",
				"func_label_old_italic",
				"func_label_phoenician",
				"func_label_ancient_south_arabian",
				"func_label_ipa",
				"func_label_maths",
			]),
		"func_label_input_toggle",
		"func_label_layout_toggle",
		"func_label_notifications",
		Map("func_label_text_processing", [
			"func_label_tp_quotes",
			"func_label_tp_paragraph",
			"func_label_tp_grep",
			"func_label_tp_html",
			"func_label_tp_unicode",
		]),
	], flat: [] }

	static panelTitle := App.winTitle " — " Locale.Read("gui_panel")

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

	static Panel() {

		Constructor() {
			this.panelTitle := App.winTitle " — " Locale.Read("gui_panel")
			UISets := this.GetUISets()

			languageCode := Language.Get()

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

			panelTabList := { Obj: {}, Arr: [] }
			panelColList := { default: [], smelting: [] }

			for _, localeKey in ["diacritics", "spaces", "smelting", "fastkeys", "scripts", "commands", "about", "useful", "changelog"] {
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

			LV_Content := {
				diacritics: ArrayMerge(
					this.LV_InsertGroup([
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
					this.LV_InsertGroup([
						;
						{ type: "Group Activator", group: "Spaces", groupKey: Window LeftAlt " Space" },
						;
						{ type: "Group Activator", group: "Format Characters", combinationKey: Window LeftAlt " Space" },
						;
						{ type: "Group Activator", group: "Dashes", groupKey: Window LeftAlt " -", separator: true },
						;
						{ type: "Group Activator", group: "Quotes", groupKey: Window LeftAlt " `"", separator: true },
						;
						{ type: "Group Activator", group: "Special Characters", groupKey: Window LeftAlt " F7", separator: true },
					]),
				),
				smelting: ArrayMerge(
					this.LV_InsertGroup([
						;
						{ type: "Recipe", group: "Latin Ligatures" },
						;
						{ type: "Recipe", group: "Latin Digraphs" },
						;
						{ type: "Recipe", group: "Latin", separator: true },
						;
						{ type: "Recipe", group: "Latino-Hellenic", separator: true },
						;
						{ type: "Recipe", group: "Latin Accented", separator: true },
						;
						{ type: "Recipe", group: "Latin Numerals", separator: true },
						;
						{ type: "Recipe", group: "Hellenic Ligatures", separator: true },
						;
						{ type: "Recipe", group: "Hellenic", separator: true },
						;
						{ type: "Recipe", group: "Hellenic Accented", separator: true },
						;
						{ type: "Recipe", group: "Cyrillic Ligatures", separator: true },
						;
						{ type: "Recipe", group: "Cyrillic Digraphs" },
						;
						{ type: "Recipe", group: "Cyrillic", separator: true },
						;
						{ type: "Recipe", group: "Cyrillic Accented", separator: true },
						;
						{ type: "Recipe", group: "Futhork Runes", separator: true },
						;
						{ type: "Recipe", group: "Glagolitic Letters", separator: true },
						;
						{ type: "Recipe", group: "Smelting Special", separator: true },
						;
						{ type: "Recipe", group: "Extra Symbolistics", separator: true },
						;
						{ type: "Recipe", group: "Alchemical", separator: true },
						;
						{ type: "Recipe", group: "Astrology", separator: true },
						;
						{ type: "Recipe", group: "Astronomy", separator: true },
						;
						{ type: "Recipe", group: "Wallet Signs", separator: true },
						;
						{ type: "Recipe", group: "Other Signs", separator: true },
						;
						{ type: "Recipe", group: "Miscellaneous Technical", separator: true },
					]),
				),
				fastkeys: ArrayMerge(
					this.LV_InsertGroup([
						;
						{ type: "Fast Key", group: "Diacritics Fast Primary", groupKey: LeftControl LeftAlt },
						;
						{ type: "Fast Key", group: "Special Fast Primary", combinationKey: LeftControl LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Spaces Primary", combinationKey: LeftControl LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Special Fast Left", groupKey: LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Spaces Left Alt", combinationKey: LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Latin Primary", combinationKey: LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Latin Accented Primary", combinationKey: LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Cyrillic Primary", combinationKey: LeftAlt, separator: true },
						;
						{ type: "Fast Key", group: "Special Fast Secondary", groupKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Asian Quotes", combinationKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Other Signs", combinationKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Spaces", combinationKey: RightAlt, separator: true, blacklist: ["emsp13", "emsp14", "emsp16", "narrow_no_break_space"] },
						;
						{ type: "Fast Key", group: "Format Characters", combinationKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Misc", combinationKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Latin Ligatures", combinationKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Latin Secondary", combinationKey: RightAlt },
						;
						{ type: "Fast Key", group: "Latin Accented Secondary", combinationKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Cyrillic Ligatures Secondary", combinationKey: RightAlt, separator: true },
						;
						;
						{ type: "Fast Key", group: "Cyrillic Digraphs Secondary", combinationKey: RightAlt, },
						;
						{ type: "Fast Key", group: "Cyrillic Secondary", combinationKey: RightAlt, separator: true },
						;
						{ type: "Fast Key", group: "Special Right Shift", groupKey: RightShift, separator: true },
						;
						{ type: "Fast Key", group: "Spaces Right Shift", groupKey: RightShift, separator: true },
						;
						{ type: "Fast Key", group: "Latin Accented Tertiary", combinationKey: RightShift, separator: true },
						;
						{ type: "Fast Key", group: "Cyrillic Tertiary", combinationKey: RightShift, separator: true },
						;
						{ type: "Fast Key", group: "Special Fast RShift", combinationKey: RightShift, separator: true },
						;
						{ type: "Fast Key", group: "Spaces Left Shift", groupKey: LeftShift, separator: true },
						;
						{ type: "Special Combinations", group: "Special Combinations", groupKey: Locale.Read("symbol_special_key"), separator: true },
					]),
				),
				scripts: ArrayMerge(
					this.LV_InsertGroup([
						;
						{ type: "Alternative Layout", group: "Fake Futhark", groupKey: RightControl " 1" },
						;
						{ type: "Alternative Layout", group: "Futhark Runes", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_futhark") },
						;
						{ type: "Alternative Layout", group: "Futhork Runes", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_futhork"), separator: true },
						;
						{ type: "Alternative Layout", group: "Younger Futhark Runes", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_futhark_younger"), separator: true },
						;
						{ type: "Alternative Layout", group: "Almanac Runes", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_futhark_almanac"), separator: true },
						;
						{ type: "Alternative Layout", group: "Later Younger Futhark Runes", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_futhark_younger_later"), separator: true },
						;
						{ type: "Alternative Layout", group: "Medieval Runes", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_medieval_runes"), separator: true },
						;
						{ type: "Alternative Layout", group: "Runic Punctuation", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_runic_punctuation"), separator: true },
						;
						{ type: "Alternative Layout", group: "Fake Glagolitic", groupKey: RightControl " 1" },
						;
						{ type: "Alternative Layout", group: "Glagolitic Letters", combinationKey: RightControl " 1", groupKey: Locale.Read("symbol_glagolitic") },
						;
						{ type: "Alternative Layout", group: "Cyrillic Diacritics", combinationKey: RightControl " 1", groupKey: "", separator: true },
						;
						{ type: "Alternative Layout", group: "Fake Hellenic", groupKey: RightControl " ?", separator: true },
						;
						{ type: "Alternative Layout", group: "Hellenic", combinationKey: RightControl " ``", groupKey: Locale.Read("symbol_hellenic") },
						;
						{ type: "Alternative Layout", group: "Fake Turkic", groupKey: CapsLock RightControl " 1", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Turkic", groupKey: Locale.Read("symbol_turkic") },
						;
						{ type: "Alternative Layout", group: "Old Turkic Orkhon", combinationKey: CapsLock RightControl " 1", groupKey: Locale.Read("symbol_turkic_orkhon") },
						;
						{ type: "Alternative Layout", group: "Old Turkic Yenisei", combinationKey: CapsLock RightControl " 1", groupKey: Locale.Read("symbol_turkic_yenisei"), separator: true },
						;
						{ type: "Alternative Layout", group: "Fake Permic", groupKey: CapsLock RightControl " 1", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Permic", combinationKey: CapsLock RightControl " 1", groupKey: Locale.Read("symbol_permic") },
						;
						{ type: "Alternative Layout", group: "Fake Hungarian", groupKey: RightControl " 2", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Hungarian", combinationKey: RightControl " 2", groupKey: Locale.Read("symbol_hungarian") },
						;
						{ type: "Alternative Layout", group: "Fake Gothic", groupKey: CapsLock RightControl " 2", separator: true },
						;
						{ type: "Alternative Layout", group: "Gothic Alphabet", combinationKey: CapsLock RightControl " 2", groupKey: Locale.Read("symbol_gothic") },
						;
						{ type: "Alternative Layout", group: "Fake Italic", groupKey: RightControl " 3", separator: true },
						;
						{ type: "Alternative Layout", group: "Old Italic", combinationKey: RightControl " 3", groupKey: Locale.Read("symbol_old_italic") },
						;
						{ type: "Alternative Layout", group: "Fake Phoenician", groupKey: CapsLock RightControl " 3", separator: true },
						;
						{ type: "Alternative Layout", group: "Phoenician", combinationKey: CapsLock RightControl " 3", groupKey: Locale.Read("symbol_phoenician") },
						;
						{ type: "Alternative Layout", group: "Fake South Arabian", groupKey: RightControl " 4", separator: true },
						;
						{ type: "Alternative Layout", group: "South Arabian", combinationKey: RightControl " 4", groupKey: Locale.Read("symbol_ancient_south_arabian") },
						;
						{ type: "Alternative Layout", group: "Fake North Arabian", groupKey: CapsLock RightControl " 4", separator: true },
						;
						{ type: "Alternative Layout", group: "North Arabian", combinationKey: CapsLock RightControl " 4", groupKey: Locale.Read("symbol_ancient_north_arabian") },
						;
						{ type: "Alternative Layout", group: "Fake Ugaritic", groupKey: RightControl " ??", separator: true },
						;
						{ type: "Alternative Layout", group: "Ugaritic", combinationKey: RightControl " ??", groupKey: Locale.Read("symbol_ugaritic") },
						;
						{ type: "Alternative Layout", group: "Fake IPA", groupKey: RightControl " 0", separator: true },
						;
						{ type: "Alternative Layout", group: "IPA", combinationKey: RightControl " 0", groupKey: Locale.Read("symbol_ipa") },
						;
						{ type: "Alternative Layout", group: "Fake Math", groupKey: RightControl RightShift " 0", separator: true },
						;
						{ type: "Alternative Layout", group: "Mathematical", combinationKey: RightControl RightShift " 0", groupKey: Locale.Read("symbol_maths") },
						;
						{ type: "Alternative Layout", group: "Math", combinationKey: RightControl RightShift " 0", groupKey: "", separator: true },
						;
						{ type: "Alternative Layout", group: "Math Spaces", combinationKey: RightControl RightShift " 0", groupKey: "", separator: true },
					]),
				),
			}

			panelTabs := panelWindow.AddTab3(UISets.tabs, panelTabList.Arr)
			panelTabs.UseTab(panelTabList.Obj.diacritics)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Diacritic",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: LV_Content.diacritics,
			})

			panelTabs.UseTab(panelTabList.Obj.spaces)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Spaces",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: LV_Content.spaces,
			})

			panelTabs.UseTab(panelTabList.Obj.smelting)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Smelting",
				columns: panelColList.smelting,
				columnWidths: UISets.column.widthsSmelting,
				source: LV_Content.smelting,
				previewType: "Recipe",
			})

			panelTabs.UseTab(panelTabList.Obj.fastkeys)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "FastKeys",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: LV_Content.fastkeys,
			})

			panelTabs.UseTab(panelTabList.Obj.scripts)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Glago",
				columns: panelColList.default,
				columnWidths: UISets.column.widths,
				source: LV_Content.scripts,
				previewType: "Alternative Layout",
			})

			panelTabs.UseTab(panelTabList.Obj.commands)

			commandsTree := panelWindow.AddTreeView(UISets.commandsInfoBox.commandsTree)
			commandsTree.OnEvent("ItemSelect", (TV, Item) => this.TV_InsertCommandsDesc(TV, Item, groupBoxCommands.text))

			groupBoxCommands := {
				group: panelWindow.AddGroupBox(UISets.commandsInfoBox.body, UISets.commandsInfoBox.bodyText[languageCode]),
				text: panelWindow.AddLink(UISets.commandsInfoBox.text),
			}

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

			aboutTitle := panelWindow.AddText(UISets.aboutInfoBox.aboutTitle, App.title)
			aboutTitle.SetFont("s20 c333333", "Cambria")

			aboutVersion := panelWindow.AddText(UISets.aboutInfoBox.aboutVersion, App.versionText)
			aboutVersion.SetFont("s12 c333333", "Cambria")

			aboutRepoLink := panelWindow.AddLink(UISets.aboutInfoBox.aboutRepoLink,
				'<a href="https://github.com/DemerNkardaz/DSL-KeyPad">' Locale.Read("about_repository") '</a>'
			)
			aboutRepoLink.SetFont("s12", "Cambria")

			aboutAuthor := panelWindow.AddText(UISets.aboutInfoBox.aboutAuthor, Locale.Read("about_author"))
			aboutAuthor.SetFont("s11 c333333", "Cambria")

			aboutAuthorLinks := panelWindow.AddLink(UISets.aboutInfoBox.aboutAuthorLinks, Locale.Read("about_author_links"))
			aboutAuthorLinks.SetFont("s9", "Cambria")


			recipesCount := ChrRecipeHandler.Count("No Custom")
			customRecipesCount := ChrRecipeHandler.Count("Custom Only")
			customEntriesCount := ChrLib.Count("Custom Composes")


			chrCount := Util.StrVarsInject(Locale.Read("about_lib_count"), (ChrLib.Count() - customEntriesCount), recipesCount, customRecipesCount)

			aboutDescBox := panelWindow.AddGroupBox(UISets.aboutInfoBox.aboutDescBox, App.decodedTitle)
			aboutDescBox.SetFont("s11", "Cambria")

			aboutDescription := panelWindow.AddText(UISets.aboutInfoBox.aboutDescription, Locale.Read("about_description"))
			aboutDescription.SetFont("s12 c333333", "Cambria")

			aboutChrCount := panelWindow.AddText(UISets.aboutInfoBox.aboutChrCount, chrCount)
			aboutChrCount.SetFont("c333333")

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

			panelTabs.UseTab(panelTabList.Obj.changelog)

			panelWindow.Add("GroupBox", "w825 h520", "🌐 " . Locale.Read("tab_changelog"))
			InsertChangesList(panelWindow)

			panelTabs.UseTab()

			GUI_Util.RemoveMinMaxButtons(panelWindow.Hwnd)
			panelWindow.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)


			panelResize(guiObj, minMax, w, h) {
				UISets := this.GetUISets("WHXY", w, h)

				guiObj["Tabs"].Move(, , UISets.tabs.w, UISets.tabs.h)

				for prefix in ["Diacritic", "Spaces", "Smelting", "FastKeys", "Glago"] {
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
		UISets := this.GetUISets()
		languageCode := Language.Get()
		panelWindow := options.winObj

		if !options.hasOwnProp("previewType") {
			options.previewType := "Key"
		}

		items_LV := panelWindow.AddListView(UISets.column.listStyle " v" options.prefix "LV", options.columns)
		items_LV.SetFont("s10")
		items_LV.OnEvent("ItemFocus", (LV, rowNumber) => this.LV_SetCharacterPreview(LV, rowNumber, { prefix: options.prefix, previewType: options.previewType }))
		items_LV.OnEvent("DoubleClick", (LV, rowNumber) => this.LV_DoubleClickHandler(LV, rowNumber))

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
		items_Filter.OnEvent("Change", (*) => this.LV_Filter(panelWindow, options.prefix "Filter", items_LV, options.source))

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
		}

		GroupBoxOptions.preview.SetFont("s" UISets.infoFonts.previewSize, Fonts.fontFaces["Default"].name)
		GroupBoxOptions.title.SetFont("s" UISets.infoFonts.titleSize, Fonts.fontFaces["Default"].name)
		GroupBoxOptions.LaTeX.SetFont("s12")
		GroupBoxOptions.alt.SetFont("s12")
		GroupBoxOptions.unicode.SetFont("s12")
		GroupBoxOptions.html.SetFont("s12")
		GroupBoxOptions.tags.SetFont("s9")
		GroupBoxOptions.alert.SetFont("s9")
		GroupBoxOptions.keyPreview.SetFont("s12")
		GroupBoxOptions.legendButton.SetFont("s11")
		GroupBoxOptions.legendButton.Enabled := False


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
				TargetTextBox.SetFont("s10", "Segoe UI")
			}
		}
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
		this.LV_SetCharacterPreview(this.PanelGUI[prefix "LV"], allowedRows[rand], { prefix: prefix })
	}

	static LV_SetCharacterPreview(LV, rowValue, options) {
		UISets := this.GetUISets()
		characterEntry := LV.GetText(rowValue, 5)
		characterKey := LV.GetText(rowValue, 2)
		characterCombinationKey := LV.GetText(rowValue, 6)

		try {
			if options.prefix = "Smelting" {
				characterKey := ChrLib.GetValue(rowValue, "recipe").ToString(", ")
			} else if options.prefix = "Diacritic" || options.prefix = "Spaces" {
				characterKey := Util.FormatHotKey(ChrLib.GetValue(rowValue, "options").groupKey)
			} else if options.prefix = "FastKeys" {
				characterKey := Util.ReplaceModifierKeys(ChrLib.GetValue(rowValue, "options").fastKey)
			} else if options.prefix = "Glago" {
				characterKey := Util.ReplaceModifierKeys(ChrLib.GetValue(rowValue, "options").altLayoutKey)
			}
		}

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

			this.PanelGUI[options.prefix "Title"].SetFont("s" UISets.infoFonts.titleSize " norm cDefault", Fonts.fontFaces["Default"].name)
			this.PanelGUI[options.prefix "Symbol"].SetFont("s" UISets.infoFonts.previewSize " norm cDefault", Fonts.fontFaces["Default"].name)
			this.PanelGUI[options.prefix "Unicode"].SetFont("s12")
			this.PanelGUI[options.prefix "HTML"].SetFont("s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont("s12")

			this.PanelGUI[options.prefix "KeyPreview"].Text := "N/A"
			this.PanelGUI[options.prefix "KeyPreview"].SetFont("s12")
			this.PanelGUI[options.prefix "KeyPreviewSet"].Text := ""
			this.PanelGUI[options.prefix "LegendButton"].Enabled := False
			this.PanelGUI[options.prefix "LegendButton"].OnEvent("Click", (*) => "")

			return
		} else {
			languageCode := Language.Get()
			value := ChrLib.GetEntry(characterEntry)


			characterTitle := ""

			if options.HasOwnProp("previewType") && options.previewType = "Alternative Layout" &&
				(value.options.layoutTitles) &&
				(Locale.Read(characterEntry "_layout_alt", , True, &titleText) ||
					Locale.Read(characterEntry "_layout", , True, &titleText)) {
				characterTitle := titleText
			} else if Locale.Read(characterEntry "_alt", , True, &titleText) {
				characterTitle := titleText

			} else if Locale.Read(characterEntry, , True, &titleText) {
				characterTitle := titleText

			} else if value.titles.Count > 0 && value.titles.Has(languageCode) {
				characterTitle := value.titles[languageCode (value.titles.Has(languageCode "_alt") ? "_alt" : "")]

			} else {
				characterTitle := Locale.Read(characterEntry)
			}

			this.PanelGUI[options.prefix "Title"].Text := characterTitle
			this.PanelGUI[options.prefix "Symbol"].Text := StrLen(value.symbol.alt) > 0 ? value.symbol.alt : value.symbol.set
			this.PanelGUI[options.prefix "Unicode"].Text := value.sequence.Length > 0 ? Util.StrCutBrackets(value.sequence.ToString(" ")) : Util.StrCutBrackets(value.unicode)
			this.PanelGUI[options.prefix "HTML"].Text := StrLen(value.entity) > 0 ? [value.html, value.entity].ToString(" ") : value.html
			this.PanelGUI[options.prefix "Alt"].Text := StrLen(value.altCode) > 0 ? value.altCode : "N/A"
			this.PanelGUI[options.prefix "LaTeX"].Text := value.LaTeX.Length > 0 ? value.LaTeX.ToString(Chr(0x2002)) : "N/A"
			this.PanelGUI[options.prefix "LaTeXPackage"].Text := StrLen(value.LaTeXPackage) > 0 ? Chrs(0x1F4E6, 0x2005) value.LaTeXPackage : ""


			this.PanelGUI[options.prefix "Title"].SetFont((StrLen(this.PanelGUI[options.prefix "Title"].Text) > 30) ? "s12" : "s" UISets.infoFonts.titleSize)

			this.PanelGUI[options.prefix "Symbol"].SetFont(, StrLen(value.symbol.font) > 0 ? value.symbol.font : Fonts.fontFaces["Default"].name)
			this.PanelGUI[options.prefix "Symbol"].SetFont("s" UISets.infoFonts.previewSize " norm cDefault")
			this.PanelGUI[options.prefix "Symbol"].SetFont(StrLen(value.symbol.customs) > 0 ? value.symbol.customs : StrLen(this.PanelGUI[options.prefix "Symbol"].Text) > 2 ? "s" UISets.infoFonts.previewSmaller " norm cDefault" : "s" UISets.infoFonts.previewSize " norm cDefault")


			this.PanelGUI[options.prefix "Unicode"].SetFont((StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "Unicode"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "HTML"].SetFont((StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "HTML"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont((StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 20) ? "s9" : "s12")

			entryString := Locale.Read("entry") ": " characterEntry
			tagsString := value.tags.Length > 0 ? Locale.Read("tags") ": " value.tags.ToString() : ""

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
				"IsSmallCaps", [value.alterations.HasOwnProp("smallCapital"), 0x029C],
				; "IsSmall", [value.alterations.HasOwnProp("small"), 0xFE57],
			)

			for entry, value in AlterationsValidator {
				if (value[1]) {
					groupTitle .= (["(h)", 0x029C].HasValue(value[2]) ? (value[2] is Number ? Chr(value[2]) : value[2])
						: ChrLib.Get("dotted_circle") Chr(value[2])) " "
				}
			}

			this.PanelGUI[options.prefix "Group"].Text := groupTitle (isDiacritic ? Locale.Read("character_combining") : Locale.Read("character"))
			FontMap := Map(
				"^permic", "Noto Sans Old Permic",
				"^hungarian", "Noto Sans Old Hungarian",
				"^south_arabian", "Noto Sans Old South Arabian",
				"^north_arabian", "Noto Sans Old North Arabian",
				"^alchemical", "Kurinto Sans",
				"^astrological", "Kurinto Sans",
				"^astronomical", "Kurinto Sans",
				"^symbolistics", "Kurinto Sans"
			)

			this.PanelGUI[options.prefix "Alert"].Text := ""
			for pattern, fontName in FontMap {
				if RegExMatch(characterEntry, pattern) {
					this.PanelGUI[options.prefix "Alert"].Text := Util.StrVarsInject(Locale.Read("warning_nofont"), fontName)
					break
				}
			}

			this.PanelGUI[options.prefix "KeyPreview"].Text := characterKey
			this.PanelGUI[options.prefix "KeyPreviewSet"].Text := StrLen(characterCombinationKey) < 10 ? characterCombinationKey : ""

			keyPreviewLength := StrLen(StrReplace(this.PanelGUI[options.prefix "KeyPreview"].Text, Chr(0x25CC), ""))


			this.PanelGUI[options.prefix "KeyPreview"].SetFont((keyPreviewLength > 25 && keyPreviewLength < 35) ? "s10" : (keyPreviewLength > 36) ? "s9" : "s12")

			if StrLen(value.options.legend) > 1 {
				this.PanelGUI[options.prefix "LegendButton"].Enabled := True
				this.PanelGUI[options.prefix "LegendButton"].OnEvent("Click", (*) => ChrLegend({ entry: characterEntry }))
			} else {
				this.PanelGUI[options.prefix "LegendButton"].Enabled := False
				this.PanelGUI[options.prefix "LegendButton"].OnEvent("Click", (*) => "")
			}
		}

	}

	static LV_FilterPopulate(LV, DataList) {
		LV.Delete()
		for item in DataList {
			LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
		}
	}

	static LV_Filter(guiFrame, filterField, LV, dataList) {
		filterText := StrLower(guiFrame[filterField].Text)
		LV.Delete()

		if filterText = ""
			this.LV_FilterPopulate(LV, dataList)
		else {
			GroupStarted := False
			PreviousGroupName := ""
			for item in dataList {
				ItemText := StrLower(item[1])

				;IsFavorite := (ItemText ~= "\Q" Chr(0x2605))
				IsFavorite := InStr(ItemText, Chr(0x2605))
				IsMatch := InStr(ItemText, filterText)
					|| (IsFavorite && RegExMatch(filterText, "^(изб|fav|\*)"))

				if ItemText = "" {
					LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
					GroupStarted := true
				} else if IsMatch {
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
		}
	}

	static LV_InsertGroup(options) {
		if Type(options) = "Array" {
			outputArrays := []
			for each in options {
				ArrayMergeTo(outputArrays, this.LV_InsertGroup(each))
			}

			return outputArrays
		} else {

			if options.group == "" {
				return
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
				if groupKey != options.group || entryNamesArray.Length = 0 {
					continue
				} else {
					for characterEntry in entryNamesArray {
						value := ChrLib.GetEntry(characterEntry)

						isFavorite := FavoriteChars.CheckVar(characterEntry)

						try {
							if (options.hasOwnProp("blacklist") && options.blacklist.HasValue(characterEntry)) ||
								(!value.groups.HasValue(options.group)) ||
								(options.type = "Group Activator" && value.options.groupKey.Length = 0) ||
								(options.type = "Recipe" && (value.recipe.Length = 0)) ||
								(options.type = "Fast Key" && (StrLen(value.options.fastKey) < 2)) ||
								(options.type = "Fast Key Special" && (StrLen(value.options.specialKey) < 2)) ||
								(options.type = "Alternative Layout" && (StrLen(value.options.altLayoutKey) < 2))
							{
								continue
							}
						} catch {
							throw "Trouble in paradise: " characterEntry " typeof groupKey" Type(options.groupKey) " recipe" Type(value.recipe) " fastKey" Type(value.options.fastKey) " specialKey" Type(value.options.specialKey) " altLayoutKey" Type(value.options.altLayoutKey)
						}

						characterTitle := ""

						if options.type = "Alternative Layout" && value.options.layoutTitles &&
							Locale.Read(characterEntry "_layout", , True, &titleText) {
							characterTitle := titleText

						} else if Locale.Read(characterEntry, , True, &titleText) {
							characterTitle := titleText

						} else if value.titles.Count > 0 && value.titles.Has(languageCode) {
							characterTitle := value.titles[languageCode]

						} else {
							characterTitle := Locale.Read(characterEntry)
						}

						if isFavorite {
							characterTitle .= " " Chr(0x2605)
						}

						characterSymbol := value.symbol.set

						characterBinding := ""

						bindings := Map(
							"Recipe", value.recipeAlt.Length > 0 ? value.recipeAlt.ToString() : value.recipe.Length > 0 ? value.recipe.ToString() : "N/A",
							"Alternative Layout", value.options.altLayoutKey,
							"Special Combinations", value.options.altSpecialKey,
							"Fast Key", value.options.fastKey,
							"Group Activator", StrLen(value.options.groupKeyPreview) > 0 && value.options.groupKeyPreview,
						)

						characterBinding := bindings.Has(options.type) ? bindings.Get(options.type) : "N/A"

						intermediateMap.Set(value.index, [characterTitle, characterBinding, characterSymbol, Util.ExtractHex(value.unicode), characterEntry, options.hasOwnProp("combinationKey") ? options.combinationKey : options.hasOwnProp("groupKey") ? options.groupKey : ""])
					}
				}
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