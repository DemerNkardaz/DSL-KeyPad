Class Panel2 {
	static __New() {
		globalInstances.MainGUI := this()
		return
	}

	states := {
		tagsExpanded: False
	}

	setCached := False
	title := ""

	fontSizes := {
		preview: 70,
		smallerPreview: 40,
		title: 14,
		titleSmall: 13,
		field: 12,
		small: 10,
		extraSmall: 9
	}

	w := 1250
	h := 900

	xPos := 0
	yPos := 0

	resolutions := [
		[1080, 1920],
		[1440, 2560],
		[1800, 3200],
		[2160, 3840],
		[2880, 5120],
		[4320, 7680]
	]

	baseX := 21

	tabsX := 10
	tabsY := 10
	tabsW := this.w - this.tabsX * 2
	tabsH := this.h - this.tabsY * 2

	lvW := this.w - (this.w / 3)
	lvH := this.h - 90
	lvX := this.tabsX + 10
	lvY := this.tabsY + 35

	listViewColumnWidths := {
		default: [this.lvW * 0.525, this.lvW * 0.2, this.lvW * 0.125, this.lvW * 0.1, 0, 0],
		all: [this.lvW * 0.625, 0, this.lvW * 0.175, this.lvW * 0.15, 0, 0],
		favorites: [this.lvW * 0.5, this.lvW * 0.205, this.lvW * 0.175, this.lvW * 0.055, 0, 0]
	}

	filterIconX := this.baseX
	filterIconY := (this.lvY + this.lvH) + 5
	filterIconW := 24
	filterIconH := 24

	filterX := this.filterIconX + 28
	filterY := this.filterIconY
	filterW := (this.lvW - this.filterIconW) - 4
	filterH := this.filterIconH

	previewGrpBoxX := this.lvX + this.lvW + 10
	previewGrpBoxY := this.lvY
	previewGrpBoxW := (this.w - this.previewGrpBoxX) - 20
	previewGrpBoxH := (this.lvH + this.filterH) + 5

	defaultFrameW := (this.previewGrpBoxW / 1.75) * 1.25
	defaultFrameX := this.previewGrpBoxX + (this.previewGrpBoxW - this.defaultFrameW) / 2

	previewFrameW := this.defaultFrameW
	previewFrameH := 128
	previewFrameX := this.defaultFrameX
	previewFrameY := this.previewGrpBoxY + 60

	previewFontW := this.defaultFrameW
	previewFontH := 20
	previewFontY := this.previewGrpBoxY + ((this.previewFrameY - this.previewGrpBoxY - this.previewFontH) / 2) + 8
	previewFontX := this.defaultFrameX

	defaultButtonW := 24
	defaultButtonH := 24
	defaultButtonX_RightSide := this.previewFrameX + this.previewFrameW + 0.25
	defaultButtonX_LeftSide := this.previewFrameX - this.defaultButtonW - 0.75

	legendButtonW := this.defaultButtonW
	legendButtonH := this.defaultButtonH
	legendButtonX := this.defaultButtonX_RightSide
	legendButtonY := this.previewFrameY - 1

	glyphsVariantsButtonW := this.defaultButtonW
	glyphsVariantsButtonH := this.defaultButtonH
	glyphsVariantsButtonX := this.defaultButtonX_RightSide
	glyphsVariantsButtonY := (this.legendButtonY + this.legendButtonH) - 0.15

	previewAlterationsGroupW := this.defaultFrameW
	previewAlterationsWStep := 5
	previewAlterationsCount := 8

	previewAlterationH := 32
	previewAlterationW(itemNumber := 1) => (this.previewAlterationsGroupW - ((this.previewAlterationsCount - 1) * this.previewAlterationsWStep)) / this.previewAlterationsCount
	previewAlterationY := (this.previewFrameY + this.previewFrameH) + 5
	previewAlterationX(itemNumber := 1) => this.previewGrpBoxX + (this.previewGrpBoxW - this.previewAlterationsGroupW) / 2 + (itemNumber - 1) * (this.previewAlterationW(itemNumber) + this.previewAlterationsWStep)

	previewTitleW := this.previewGrpBoxW - 60
	previewTitleH := 72
	previewTitleX := this.previewGrpBoxX + (this.previewGrpBoxW - this.previewTitleW) / 2
	previewTitleY := (this.previewAlterationY + this.previewAlterationH) + 20

	fieldW := this.defaultFrameW
	fieldH := 24
	fieldX := this.defaultFrameX

	fieldTitleW := this.fieldW
	fieldTitleH := 14
	fieldTitleX := this.fieldX

	fieldTitleY := (this.previewTitleY + this.previewTitleH) + 15
	fieldY := (this.fieldTitleY + this.fieldTitleH) + 2

	fieldStep := 25
	reservedRecipeSteps := 1.5

	tagsLVW := this.defaultFrameW
	tagsLVH := 120
	tagsLVX := this.defaultFrameX
	tagsLVY := this.incrementFieldY(this.reservedRecipeSteps + 5)[1]

	openTagsButtonW := this.defaultButtonW
	openTagsButtonH := this.defaultButtonH
	openTagsButtonX := this.defaultButtonX_RightSide
	openTagsButtonY := this.tagsLVY - 1

	unicodeBlockW := this.defaultFrameW
	unicodeBlockH := 30
	unicodeBlockX := this.defaultFrameX
	unicodeBlockY := (this.tagsLVY + this.tagsLVH) + 15

	entryNameW := this.defaultFrameW
	entryNameH := 24
	entryNameX := this.defaultFrameX
	entryNameY := (this.unicodeBlockY + this.unicodeBlockH) + 15

	incrementField(stepsCount := 1) {
		local x := this.fieldX
		local y := this.fieldY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
		local w := this.fieldW
		local h := this.fieldH
		local field := [x, y, w, h]

		local x := this.fieldTitleX
		local y := this.fieldTitleY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
		local w := this.fieldTitleW
		local h := this.fieldTitleH
		local fieldTitle := [x, y, w, h]
		return [field, fieldTitle]
	}

	incrementFieldY(stepsCount := 1) {
		local y := this.fieldY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
		local y2 := this.fieldTitleY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
		return [y, y2]
	}

	defaultUnicode := "0000"
	defaultUnicodeBlock := "0000...10FFFF`n<UNKNOWN>"
	defaultHTML := "&#0;"
	defaultAlteration := Chr(0x1D504)
	notAvailable := "N/A"

	defaultTextOpts := "0x80 BackgroundTrans"
	defaultEditOpts := "Readonly Center -VScroll -HScroll"

	fontMarker := Chr(0x1D4D5) Chr(0x2004)

	fontColorNoData := "cc3c3c3"
	fontColorDefault := "c333333"

	tabs := [
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
	]

	listViewTabs := [
		"smelting",
		"fastkeys",
		"secondkeys",
		"tertiarykeys",
		"scripts",
		"TELEXVNI",
		"all",
		"favorites",
	]

	listViewLocaleColumnsIndexes := Map()

	listViewData := Map()
	combinationKeyToGroupPairs := Map()

	listViewColumnHeaders := {
		default: [
			"dictionary.name",
			"dictionary.key",
			"dictionary.view",
			"[default]unicode",
			"dictionary.entry",
			"dictionary.combination_key"
		],
		smelting: [
			"dictionary.name",
			"dictionary.recipe",
			"dictionary.result",
			"[default]unicode",
			"dictionary.entry",
			"dictionary.combination_key"
		],
		favorites: [
			"dictionary.name",
			"dictionary.recipe",
			"dictionary.key",
			"dictionary.view",
			"dictionary.entry",
			"dictionary.combination_key"
		]
	}

	tabContents := [{
		prefix: "smelting",
		columns: this.listViewColumnHeaders.smelting,
		columnWidths: this.listViewColumnWidths.default,
		source: "smelting",
		previewType: "Recipe",
	}, {
		prefix: "fastkeys",
		columns: this.listViewColumnHeaders.default,
		columnWidths: this.listViewColumnWidths.default,
		source: "fastkeys",
	}, {
		prefix: "secondkeys",
		columns: this.listViewColumnHeaders.default,
		columnWidths: this.listViewColumnWidths.default,
		source: "secondkeys",
	}, {
		prefix: "tertiarykeys",
		columns: this.listViewColumnHeaders.default,
		columnWidths: this.listViewColumnWidths.default,
		source: "tertiarykeys",
	}, {
		prefix: "scripts",
		columns: this.listViewColumnHeaders.default,
		columnWidths: this.listViewColumnWidths.default,
		source: "scripts",
		previewType: "Alternative Layout",
	}, {
		prefix: "TELEXVNI",
		columns: this.listViewColumnHeaders.default,
		columnWidths: this.listViewColumnWidths.default,
		source: "TELEXVNI",
	}, {
		prefix: "all",
		columns: this.listViewColumnHeaders.smelting,
		columnWidths: this.listViewColumnWidths.all,
		source: "all",
		previewType: "Recipe",
	}, {
		prefix: "favorites",
		columns: this.listViewColumnHeaders.favorites,
		columnWidths: this.listViewColumnWidths.favorites,
		source: "favorites",
		previewType: "Recipe",
	}]

	__New() {
		local JSONLists := JSON.LoadFile(App.paths.data "\ui_main_panel_lists.json", "UTF-8")

		this.GetColumnsData(&columnsData)

		for i, each in columnsData.supportedLanguages
			this.listViewLocaleColumnsIndexes.Set(each, i + columnsData.languageColumnsStartIndex)
		this.FillListViewData(&JSONLists, &columnsData)

		JSONLists := unset

		Event.OnEvent("UI Data", "Changed", () => this.setCached := False)
		Event.OnEvent("UI Language", "Switched", () => this.setCached := False)
		Event.OnEvent("Favorites", "Changed", (faveName, condition, preventFromTabChange) =>
			WinExist(this.title)
			&& this.ListViewFavoritesEvent(&faveName, &condition, &preventFromTabChange, this.GUI)
		)
		return Event.Trigger("UI Instance [Panel]", "Created", this)
	}

	GetColumnsData(&columnsData) {
		columnsData := {}
		columnsData.tabColumns := this.listViewColumnHeaders.default.Clone()
		columnsData.supportedLanguages := Language.GetSupported(, , useIndex := True)
		columnsData.languageColumnsStartIndex := columnsData.tabColumns.Length
		columnsData.tabColumns.MergeWith(columnsData.supportedLanguages)
		return columnsData
	}

	Show() {
		if this.title != "" && WinExist(this.title) {
			WinActivate(this.title)
		} else {
			local progress := DottedProgressTooltip(, &triggerEnds := False)

			if !this.setCached
				this.GUI := this.Constructor()
			this.GUI.Show(Format("w{} h{} x{} y{}", this.w, this.h, this.xPos, this.yPos))

			triggerEnds := True
			progress := unset
			this.setCached := True
		}

		return Event.Trigger("UI Instance [Panel]", "Shown", this)
	}

	Destroy() {
		this.GUI.Destroy()
		return Event.Trigger("UI Instance [Panel]", "Destroyed", this)
	}

	Constructor() {
		;

		local screenWidth := A_ScreenWidth
		local screenHeight := A_ScreenHeight

		for res in this.resolutions {
			if screenHeight = res[1] && screenWidth > res[2] {
				screenWidth := res[2]
				break
			}
		}

		this.xPos := screenWidth - this.w - 50
		this.yPos := screenHeight - this.h - 92

		; *
		; *
		; *

		this.title := App.Title("+status+version") " — " Locale.Read("gui.panel")

		local panelWindow := Gui()
		panelWindow.Title := this.title


		local localizedTabs := []

		for tab in this.tabs
			localizedTabs.Push(Locale.Read("gui.tabs." tab))

		local panelTabs := panelWindow.AddTab3(Format("vTabs x{} y{} w{} h{}", this.tabsX, this.tabsY, this.tabsW, this.tabsH), localizedTabs)

		local tabHeaders := []

		for tab in this.listViewTabs
			tabHeaders.Push(Locale.Read("gui.tabs." tab))

		for i, header in tabHeaders {
			panelTabs.UseTab(header)

			local attributes := this.tabContents[i]
			this.CreateTabConcent(panelWindow, attributes)
		}

		return panelWindow
	}

	CreateTabConcent(panelWindow, attributes := {}) {
		local instance := this
		if !attributes.HasOwnProp("previewType")
			attributes.previewType := "Key"

		local localizedColumns := []
		local languageCode := Language.Get()
		local localeData := {
			supportedLanguages: Language.GetSupported(, , useIndex := True),
			localeIndex: this.listViewLocaleColumnsIndexes.Get(languageCode),
			localeIndexMap: this.listViewLocaleColumnsIndexes,
		}

		for column in attributes.columns {
			RegExMatch(column, "^(?:\[(.*?)\])?(.*)$", &match)
			localizedColumns.Push(Locale.Read(match[2], match[1]))
		}

		localeData.columnsCount := localizedColumns.Length

		charactersLV := panelWindow.AddListView(Format("v{}LV w{} h{} x{} y{} +NoSort -Multi", attributes.prefix, this.lvW, this.lvH, this.lvX, this.lvY), localizedColumns)
		charactersLV.SetFont("s" Cfg.Get("List_Items_Font_Size", "PanelGUI", 10, "int"))

		Loop attributes.columns.Length {
			index := A_Index
			charactersLV.ModifyCol(index, attributes.columnWidths[index])
		}

		local localizesRowsList := []
		local src := this.listViewData[attributes.source]
		for i, item in this.listViewData[attributes.source] {
			charactersLV.Add(, item[localeData.localeIndex], ArraySlice(item, 2, attributes.columns.Length)*)
		}

		local characterFilterIcon := panelWindow.AddButton(Format("x{} y{} h{} w{}", this.filterIconX, this.filterIconY, this.filterIconW, this.filterIconH))

		GuiButtonIcon(characterFilterIcon, ImageRes, 169)
		characterFilter := panelWindow.AddEdit(Format("x{} y{} w{} h{} v{}Filter",
			this.filterX, this.filterY, this.filterW, this.filterH, attributes.prefix), "")
		characterFilter.SetFont("s10")

		local filterInstance := UIPanelFilter(&panelWindow, &characterFilter, &charactersLV, &src, &localeData)

		local previewGroupBox := panelWindow.AddGroupBox(Format("v{}Group x{} y{} w{} h{} Center", attributes.prefix, this.previewGrpBoxX, this.previewGrpBoxY, this.previewGrpBoxW, this.previewGrpBoxH), Locale.Read("dictionary.character"))

		local fontMarker := panelWindow.AddText(Format("v{}Font {} x{} y{} w{} h{} c5088c8 Center", attributes.prefix, this.defaultTextOpts, this.previewFontX, this.previewFontY, this.previewFontW, this.previewFontH))

		local previewGroupFrame := panelWindow.AddGroupBox(Format("v{}Frame x{} y{} w{} h{}", attributes.prefix, this.previewFrameX, this.previewFrameY, this.previewFrameW, this.previewFrameH))

		local previewSymbol := panelWindow.AddEdit(Format("v{}Symbol {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.previewFrameX, this.previewFrameY, this.previewFrameW, this.previewFrameH), DottedCircle)


		local legendButton := panelWindow.AddButton(Format("v{}LegendButton x{} y{} w{} h{}", attributes.prefix, this.legendButtonX, this.legendButtonY, this.legendButtonW, this.legendButtonH), Chr(0x1F4D6))

		local glyphsVariantsButton := panelWindow.AddButton(Format("v{}GlyphsVariantsButton x{} y{} w{} h{}", attributes.prefix, this.glyphsVariantsButtonX, this.glyphsVariantsButtonY, this.glyphsVariantsButtonW, this.glyphsVariantsButtonH), Chr(0x1D57B))

		Loop this.previewAlterationsCount {
			local index := A_Index
			local alterationPreview := panelWindow.AddEdit(Format("v{}AlterationPreview{} {} x{} y{} w{} h{}", attributes.prefix, index, this.defaultEditOpts " " this.fontColorNoData, this.previewAlterationX(index), this.previewAlterationY, this.previewAlterationW(index), this.previewAlterationH), this.defaultAlteration)
			alterationPreview.SetFont("s14")
		}

		local title := panelWindow.AddText(Format("v{}Title {} x{} y{} w{} h{} {} Center", attributes.prefix, this.defaultTextOpts, this.previewTitleX, this.previewTitleY, this.previewTitleW, this.previewTitleH, this.fontColorNoData), this.notAvailable)

		local keyRecipeTitle := panelWindow.AddText(Format("v{}RecipeTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.fieldTitleX, this.fieldTitleY, this.fieldTitleW, this.fieldTitleH), Locale.Read(attributes.previewType = "Recipe" ? "dictionary.recipe" : "dictionary.key"))

		local keyRecipeTitleSecondary := panelWindow.AddText(Format("v{}RecipeTitleSecondary {} x{} y{} w{} h{} Right", attributes.prefix, this.defaultTextOpts, this.fieldTitleX, this.fieldTitleY, this.fieldTitleW, this.fieldTitleH))

		local keyRecipeField := panelWindow.AddEdit(Format("v{}RecipeField {} x{} y{} w{} h{} Multi +Wrap", attributes.prefix, this.defaultEditOpts, this.fieldX, this.fieldY, this.fieldW, this.fieldH, this.defaultEditOpts), "")

		if attributes.prefix = "all" {
			keyRecipeField.Visible := False
			keyRecipeTitle.Visible := False
			keyRecipeTitleSecondary.Visible := False
		}

		local unicodeTitle := panelWindow.AddText(Format("v{}UnicodeTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 1)[2]*), Locale.Read("dictionary.unicode_point"))

		local unicodeField := panelWindow.AddEdit(Format("v{}UnicodeField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementField(this.reservedRecipeSteps + 1)[1]*), this.defaultUnicode)

		local htmlTitle := panelWindow.AddText(Format("v{}HTMLTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 2)[2]*), Locale.Read("dictionary.html_entity"))

		local htmlField := panelWindow.AddEdit(Format("v{}HTMLField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementField(this.reservedRecipeSteps + 2)[1]*), this.defaultHTML)

		local altCodeTitle := panelWindow.AddText(Format("v{}AltCodeTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 3)[2]*), Locale.Read("dictionary.alt_code"))

		local altCodePages := panelWindow.AddText(Format("v{}AltCodePages {} x{} y{} w{} h{} Right", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 3)[2]*), Locale.Read("dictionary.alt_code"))

		local altCodeField := panelWindow.AddEdit(Format("v{}AltCodeField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementField(this.reservedRecipeSteps + 3)[1]*), this.notAvailable)

		local LaTeX_LTX_Title := panelWindow.AddText(Format("v{}LaTeX_LTX {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4 - 0.04)[2]*), "L T  X")

		local LaTeX_A_Title := panelWindow.AddText(Format("v{}LaTeX_A {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4 - 0.04 - 0.035)[2]*), Chr(0x2004) "A")

		local LaTeX_E_Title := panelWindow.AddText(Format("v{}LaTeX_E {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4 - 0.04 + 0.07)[2]*), Chr(0x2003) Chr(0x2004) "E")

		local LaTeXPackageTitle := panelWindow.AddText(Format("v{}LaTeXPackage {} x{} y{} w{} h{} Right", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4)[2]*))

		local LaTeXField := panelWindow.AddEdit(Format("v{}LaTeXField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementField(this.reservedRecipeSteps + 4)[1]*), this.notAvailable)

		local tagsTitle := panelWindow.AddText(Format("v{}TagsTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts " c5088c8", this.incrementField(this.reservedRecipeSteps + 5)[2]*), Locale.Read("dictionary.tags"))

		local tagsListView := panelWindow.AddListView(Format("v{}TagsLV x{} y{} w{} h{} +NoSort -Multi -Hdr r15", attributes.prefix, this.tagsLVX, this.tagsLVY, this.tagsLVW, this.tagsLVH), [""])

		local openTagsButton := panelWindow.AddButton(Format("v{}OpenTagsButton x{} y{} w{} h{}", attributes.prefix, this.openTagsButtonX, this.openTagsButtonY, this.openTagsButtonW, this.openTagsButtonH), Chr(0x1F3F7) Chr(0xFE0F))

		local unicodeBlock := panelWindow.AddText(Format("v{}UnicodeBlock {} x{} y{} w{} h{} c5088c8 Center", attributes.prefix, this.defaultTextOpts, this.unicodeBlockX, this.unicodeBlockY, this.unicodeBlockW, this.unicodeBlockH), this.defaultUnicodeBlock)

		local entryNameLabel := panelWindow.AddText(Format("v{}EntryName {} x{} y{} w{} h{} Center", attributes.prefix, this.defaultTextOpts, this.entryNameX, this.entryNameY, this.entryNameW, this.entryNameH), "[" Chr(0x2003) this.notAvailable Chr(0x2003) "]")

		charactersLV.OnEvent("ItemFocus", (LV, rowNumber) => this.ItemSetPreview(panelWindow, LV, rowNumber, { prefix: attributes.prefix, previewType: attributes.previewType }))

		charactersLV.OnEvent("DoubleClick", (LV, rowNumber) => this.ItemDoubleClick(LV, rowNumber, attributes.prefix))

		charactersLV.OnEvent("ContextMenu", (LV, rowNumber, isRMB, X, Y) => this.ItemContextMenu(panelWindow, LV, rowNumber, isRMB, X, Y, attributes.prefix))

		characterFilter.OnEvent("Change", (Ctrl, Info) => (
			filterText := Ctrl.Text,
			filterInstance.FilterBridge(&filterText)
		))

		fontMarker.OnEvent("Click", (TextCtrl, *) => Fonts.OpenURL(TextCtrl.Text))
		tagsListView.OnEvent("DoubleClick", (LV, rowNumber) => this.TagItemDoubleClick(LV, rowNumber))
		unicodeBlock.OnEvent("Click", (TextCtrl, *) => UnicodeBlockWebResource(TextCtrl.Text))
		entryNameLabel.OnEvent("Click", (TextCtrl, *) => this.PreviewPanelEntryNameClick(TextCtrl.Text))

		tagsTitle.OnEvent("Click", (*) => this.ToggleExpandTagsList(panelWindow))
		openTagsButton.OnEvent("Click", (*) => Panel2.TagsPanel(panelWindow, tagsListView, attributes.prefix, instance))

		legendButton.OnEvent("Click", (B, I) => this.PreviewButtonsBridge(panelWindow, attributes.prefix, "ChrLegend"))
		glyphsVariantsButton.OnEvent("Click", (B, I) => this.PreviewButtonsBridge(panelWindow, attributes.prefix, "GlyphsPanel"))

		fontMarker.SetFont("s11", Fonts.fontFaces["Default"].name)

		legendButton.SetFont("s11")
		legendButton.Enabled := False
		glyphsVariantsButton.SetFont("s11")
		glyphsVariantsButton.Enabled := False
		openTagsButton.SetFont("s11")
		openTagsButton.Enabled := False

		previewSymbol.SetFont("s" this.fontSizes.preview, Fonts.fontFaces["Default"].name)
		title.SetFont("s" this.fontSizes.title, Fonts.fontFaces["Default"].name)

		keyRecipeField.SetFont("s" this.fontSizes.field)
		unicodeField.SetFont("s" this.fontSizes.field)
		htmlField.SetFont("s" this.fontSizes.field)
		altCodeField.SetFont("s" this.fontSizes.field)
		LaTeXField.SetFont("s" this.fontSizes.field)

		altCodePages.SetFont("s9")

		LaTeX_LTX_Title.SetFont("s10", "Cambria")
		LaTeX_A_Title.SetFont("s9", "Cambria")
		LaTeX_E_Title.SetFont("s10", "Cambria")
		return
	}

	ListViewFavoritesEvent(&faveName, &condition, &preventFromTabChange, panelWindow) {
		local star := Chr(0x2002) Chr(0x2605)
		local allPrefixes := []
		for tab in this.listViewTabs {
			allPrefixes.Push(tab)
		}

		for tabPrefix in allPrefixes {
			local listView := panelWindow[tabPrefix "LV"]
			local itemsCount := listView.GetCount()

			Loop itemsCount {
				local index := A_Index
				local entryName := listView.GetText(index, 5)

				if entryName == faveName {
					local entryTitle := listView.GetText(index, 1)

					if condition = "Added" {
						if !InStr(entryTitle, star) {
							listView.Modify(index, , entryTitle star)
						}
					} else if condition = "Removed" {
						if InStr(entryTitle, star) {
							listView.Modify(index, , StrReplace(entryTitle, star, ""))
						}
					}
					break
				}
			}
		}

		if !preventFromTabChange {
			local addingRow := []

			if condition = "Added" {
				local entry := ChrLib.GetEntry(faveName)
				local reserveCombinationKey := ""

				for cgroup, ckey in globalInstances.MainGUI.combinationKeyToGroupPairs
					reserveCombinationKey := entry["groups"].HasValue(cgroup) ? ckey : reserveCombinationKey

				local recipe := entry["recipeAlt"].Length > 0 ? entry["recipeAlt"].ToString() : entry["recipe"].Length > 0 ? entry["recipe"].ToString() : ""
				local bindings := entry["options"]["fastKey"] != "" ? entry["options"]["fastKey"] : entry["options"]["altLayoutKey"] != "" ? entry["options"]["altLayoutKey"] : entry["options"]["altSpecialKey"] != "" ? entry["options"]["altSpecialKey"] : ""
				bindings := bindings != "" ? (reserveCombinationKey != "" ? reserveCombinationKey " + " : "") bindings : ""

				while (RegExMatch(bindings, "\%(.*)\%", &match))
					bindings := RegExReplace(bindings, match[0], VariableParser.Parse(match[0]), , 1)

				local entryView := ""
				local actualTitle := ""

				for tabPrefix in allPrefixes {
					local lv := panelWindow[tabPrefix "LV"]
					local count := lv.GetCount()

					Loop count {
						local idx := A_Index
						local name := lv.GetText(idx, 5)

						if name == faveName {
							entryView := lv.GetText(idx, 3)
							actualTitle := lv.GetText(idx, 1)
							actualTitle := StrReplace(actualTitle, star, "")
							actualTitle := actualTitle star
							break
						}
					}
					if entryView != ""
						break
				}

				addingRow := [,
					actualTitle,
					recipe,
					bindings,
					entryView,
					faveName,
					""
				]
			}

			this.ListViewAffectFavoritesTab(&faveName, &condition, panelWindow, addingRow)
		}
		return
	}

	ListViewAffectFavoritesTab(&faveName, &condition, panelWindow, addingRow := []) {
		local favoritesListView := panelWindow["favoritesLV"]
		local itemsCount := favoritesListView.GetCount()

		if condition = "Removed" {
			Loop itemsCount {
				local index := A_Index
				local entryName := favoritesListView.GetText(index, 5)

				if entryName == faveName {
					favoritesListView.Delete(index)
					break
				}
			}
		} else if condition = "Added"
			favoritesListView.Add(addingRow*)

		return
	}

	FillListViewData(&source, &columnsData) {
		for category, attributes in source
			this.listViewData.Set(category, this.GetEntries(&attributes, &columnsData))
		return
	}

	MergeListViewData(&source, &columnsData) {
		for category, attributes in source {
			local ref := this.listViewData[category]
			ArrayMergeTo(&ref, this.GetEntries(&attributes, &columnsData))
		}
		return Event.Trigger("UI Data", "Changed")
	}

	GetEntries(&attributes, &columnsData) {
		if attributes is Array {
			local outputArrays := []

			for each in attributes
				ArrayMergeTo(&outputArrays, this.GetEntries(&each, &columnsData))

			return outputArrays
		} else if attributes["group"] is Array {
			local outputArrays := []
			local lastGroupKey := ""

			for i, each in attributes["group"] {
				local eachAttributes := attributes.Clone()
				eachAttributes["group"] := each

				if attributes.Has("groupKey") {
					if attributes["groupKey"] is Map && attributes["groupKey"].Has(each) {
						eachAttributes["groupKey"] := attributes["groupKey"].Get(each)
						lastGroupKey := eachAttributes["groupKey"]
					} else
						eachAttributes.Delete("groupKey")
				}

				if attributes.Has("subType") {
					if attributes["subType"] is Map && attributes["subType"].Has(each) {
						eachAttributes["subType"] := attributes["subType"].Get(each)
					} else {
						eachAttributes.Delete("subType")
					}
				}

				if attributes.Has("combinationKey") {
					if attributes["combinationKey"] is Map && attributes["combinationKey"].Has(each) {
						eachAttributes["combinationKey"] := attributes["combinationKey"].Get(each)
					} else {
						if lastGroupKey != ""
							eachAttributes["combinationKey"] := lastGroupKey
						else
							eachAttributes.Delete("combinationKey")
					}
				} else if lastGroupKey != ""
					eachAttributes["combinationKey"] := lastGroupKey


				if attributes["type"] = "Fast Key" {
					this.combinationKeyToGroupPairs.Set(
						eachAttributes["group"],
						eachAttributes.Has("combinationKey") ? eachAttributes["combinationKey"] : lastGroupKey
					)
				}

				ArrayMergeTo(&outputArrays, this.GetEntries(&eachAttributes, &columnsData))
			}

			return outputArrays
		} else {
			if !attributes.Has("type")
				throw "Type is required for MainGUI GetEntries"

			local defaultRow := Util.ArrRepeatEmpty(columnsData.tabColumns.Length + 1)

			if attributes["group"] == ""
				return [defaultRow]

			local outputArray := []
			local intermediateMap := Map()

			if attributes.Has("groupKey")
				if (attributes["groupKey"] is String && StrLen(attributes["groupKey"]) > 0
					|| attributes["groupKey"] is Func) {
					local groupRow := defaultRow.Clone()
					groupRow[2] := this.HandleKey(attributes["groupKey"])
					outputArray.Push(groupRow)
				}

			for groupKey, entryNamesArray in ChrLib.entryGroups {
				if !([groupKey].HasRegEx(attributes["group"])) || entryNamesArray.Length = 0 {
					continue
				} else {
					for entryName in entryNamesArray {
						local entry := ChrLib.GetEntry(entryName)
						local isFavorite := FavoriteChars.CheckVar(entryName)

						try {
							if (entry["options"]["hidden"]) ||
								(attributes.Has("blacklist") && attributes["blacklist"].HasRegEx(entryName)) ||
								(!entry["groups"].HasRegEx(attributes["group"])) ||
								(attributes["type"] = "Recipe" && (entry["recipe"].Length = 0)) ||
								(attributes["type"] = "Fast Key" && (StrLen(entry["options"]["fastKey"]) < 2)) ||
								(attributes["type"] = "Fast Key Special" && (StrLen(entry["options"]["specialKey"]) < 2)) ||
								(attributes["type"] = "Alternative Layout" && (StrLen(entry["options"]["altLayoutKey"]) < 2)) ||
								(attributes["type"] = "TELEX/VNI" && (!entry["options"].Has("telex__" attributes["subType"]) ||
									entry["options"].Has("telex__" attributes["subType"]) && entry["options"]["telex__" attributes["subType"]] = "")
								)
							{
								continue
							}
						} catch {
							throw "Trouble in paradise: " entryName " typeof groupKey" (attributes.Has("groupKey") ? Type(attributes["groupKey"]) : "null") " recipe" Type(entry["recipe"]) " fastKey" Type(entry["options"]["fastKey"]) " specialKey" Type(entry["options"]["specialKey"]) " altLayoutKey" Type(entry["options"]["altLayoutKey"])
						}

						local characterRawTitle := Format("{}[type::{}]", entryName, attributes["type"])

						local bindings := Map(
							"Recipe", entry["recipeAlt"].Length > 0 ? entry["recipeAlt"].ToString() : entry["recipe"].Length > 0 ? entry["recipe"].ToString() : "",
							"Alternative Layout", entry["options"]["altLayoutKey"],
							"Special Combinations", entry["options"]["altSpecialKey"],
							"Fast Key", entry["options"]["fastKey"],
							"TELEX/VNI", attributes["type"] = "TELEX/VNI" && entry["options"].Has("telex__" attributes["subType"]) ? entry["options"]["telex__" attributes["subType"]] : "",
						)

						for key, value in bindings
							bindings.Set(key, this.HandleKey(value))

						local characterSymbol := entry["symbol"]["set"]
						local characterBinding := bindings.Has(attributes["type"]) ? bindings.Get(attributes["type"]) : attributes["type"] = "" && entry["recipeAlt"].Length > 0 ? entry["recipeAlt"].ToString() : ""

						local reserveCombinationKey := ""

						for cgroup, ckey in this.combinationKeyToGroupPairs
							reserveCombinationKey := entry["groups"].HasValue(cgroup) ? ckey : reserveCombinationKey

						reserveCombinationKey := (reserveCombinationKey != "" ? reserveCombinationKey " + " : "")

						local entryRow := defaultRow.Clone()

						entryRow[2] := attributes["group"] = "Favorites"
							? bindings["Recipe"]
						: ((attributes.Has("label") && attributes["label"] != "All" || !attributes.Has("label")) ? characterBinding : "")

						entryRow[3] := attributes["group"] = "Favorites"
							? (bindings["Fast Key"] != "" ? reserveCombinationKey bindings["Fast Key"]
								: bindings["Alternative Layout"] != "" ? reserveCombinationKey bindings["Alternative Layout"]
								: "")
						: entry["symbol"]["alt"] != "" ? entry["symbol"]["alt"] : characterSymbol
						entryRow[3] := this.HandleKey(entryRow[3])

						entryRow[4] := attributes["group"] = "Favorites"
							? characterSymbol
						: Util.ExtractHex(entry["unicode"])

						entryRow[5] := entryName
						entryRow[6] := attributes["group"] = "Favorites"
							? ""
						: (attributes.Has("combinationKey") ? attributes["combinationKey"] : attributes.Has("groupKey") ? attributes["groupKey"] : "")
						entryRow[6] := this.HandleKey(entryRow[6])

						for each in columnsData.supportedLanguages {
							local index := this.listViewLocaleColumnsIndexes.Get(each)
							entryRow[index] := this.HandleTitle(characterRawTitle, &each)
						}

						intermediateMap.Set(entry["index"], entryRow)
					}
				}
			}

			for cgroup, entry in intermediateMap
				outputArray.Push(entry)

			if attributes.Has("target") {
				for each in outputArray
					%attributes["target"]%.Push(each)
			} else
				return outputArray
		}
		return
	}

	HandleTitle(str, &specificLanguage := "", useAlt?) {
		if RegExMatch(str, "^(.*)\[type::(.*)\]$", &partsMatch) {
			local languageCode := specificLanguage != "" ? specificLanguage : Language.Get()
			local entryName := partsMatch[1]
			local entry := ChrLib.entries.%entryName%
			local optionsType := partsMatch[2]
			local characterTitle := ""
			local isFavorite := FavoriteChars.CheckVar(entryName)

			local skipCombine := True
			local combinedTitle := ""

			local entryData := entry.Has("&data") ? entry["&data"] : entry["data"]
			local lScript := entryData["script"]
			local lOriginScript := entryData["originScript"]
			local hasScript := lScript != ""
			local useLetterLocale := entry["options"]["useLetterLocale"]

			local interLabel := entryName

			if entry["options"]["localeCombineAnd"] {
				split := StrSplit(entryName, "_and_")
				if split.Length > 1 {
					for i, each in split {
						if Locale.Read(each ".alt", specificLanguage, True, &titleText) || Locale.Read(each, specificLanguage, True, &titleText) {
							combinedTitle .= titleText " " (i < split.Length ? Locale.Read("dictionary.and", specificLanguage) " " : "")
							skipCombine := False
						}
					}
				}
			}

			if hasScript
				interLabel := RegExReplace(interLabel, "^" lOriginScript "_", "scripts." lScript ".")

			if optionsType = "Alternative Layout" && entry["options"]["layoutTitles"]
				&& (
					(IsSet(useAlt) && useAlt && Locale.Read(interLabel ".layout_locale_alt", specificLanguage, True, &titleText))
					|| (IsSet(useAlt) && useAlt && Locale.Read(interLabel ".layout_locale", specificLanguage, True, &titleText))
					|| (!IsSet(useAlt) && Locale.Read(interLabel ".layout_locale", specificLanguage, True, &titleText))
				) {
				characterTitle := titleText
			} else if !skipCombine {
				characterTitle := combinedTitle

			} else if (
				(IsSet(useAlt) && useAlt && Locale.Read(interLabel ".alt", specificLanguage, True, &titleText)) || (!IsSet(useAlt) && Locale.Read(interLabel, specificLanguage, True, &titleText))
			) {
				characterTitle := titleText

			} else if entry["titles"].Count > 0 && entry["titles"].Has(languageCode) {
				characterTitle := IsSet(useAlt) && entry["titles"].Has(languageCode "_alt") ? entry["titles"].Get(languageCode "_alt") : entry["titles"].Get(languageCode)

			} else if entry["name"] != "" {
				characterTitle := entry["name"]

			} else if Locale.Read(interLabel, specificLanguage, True, &titleText) {
				characterTitle := titleText

			} else
				characterTitle := Locale.Read(entryName, specificLanguage)


			if isFavorite
				characterTitle .= Chr(0x2002) Chr(0x2605)

			return characterTitle
		}
		return str
	}

	HandleKey(str) {
		local rules := Map(
			"^@(\S+)$", (str, match, callBack := Locale.Read.Bind(Locale, match[1])) => RegExReplace(str, match[0], callBack()),
			"%(.*?)%", (str, match) => RegExReplace(str, match[0], %match[1]%),
		)
		try
			for pattern, call in rules
				while RegExMatch(str, pattern, &match)
					str := call(str, match)

		return str
	}

	ItemContextMenu(panelWindow, LV, rowNumber, isRMB := False, X := 0, Y := 0, prefix := "") {
		local isFavoriteTab := prefix = "favorites"
		if !isRMB
			return
		try {
			if StrLen(LV.GetText(rowNumber, 1)) < 1 {
				return
			} else {
				local titleCol := LV.GetText(rowNumber, 1)
				local entryCol := LV.GetText(rowNumber, 5)
				local entry := ChrLib.GetEntry(entryCol)
				local unicode := entry["unicode"]
				local unicodeBlock := entry["unicodeBlock"]
				local sequence := entry["sequence"]
				local altsCount := ObjOwnPropCount(entry["alterations"])
				local hasLegend := entry["options"]["legend"]

				if StrLen(unicode) > 0 {
					isCharFavorite := FavoriteChars.CheckVar(entryCol)
					contextMenu := Menu()

					labels := {
						fav: Locale.Read("gui.panel.context_menu." (isCharFavorite ? "remove" : "add") "_favorites"),
						showSymbolPage: Locale.ReadInject("gui.panel.context_menu.show_symbol_page", [UnicodeWebResource.GetCurrentResource()]),
						showBlockPage: Locale.ReadInject("gui.panel.context_menu.show_block_page", [UnicodeBlockWebResource.GetCurrentResource()]),
						glyphVariations: Locale.Read("gui.panel.context_menu.glyph_variations"),
						legend: Locale.Read("gui.panel.context_menu.legend"),
						showEntry: Locale.ReadInject("gui.panel.context_menu.show_entry", [entryCol])
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
						if !isCharFavorite {
							FavoriteChars.Add(entryCol, isFavoriteTab)
						} else if isCharFavorite {
							FavoriteChars.Remove(entryCol, isFavoriteTab)
						}

					}
				}
			}
		}
		return
	}

	ItemDoubleClick(LV, rowNumber, prefix := "False") {
		local isFavoriteTab := prefix = "favorites"
		if StrLen(LV.GetText(rowNumber, 4)) < 1 {
			return
		} else {
			local titleCol := LV.GetText(rowNumber, 1)
			local entryCol := LV.GetText(rowNumber, 5)
			local entry := ChrLib.GetEntry(entryCol)
			local unicode := entry["unicode"]
			local sequence := entry["sequence"]

			if StrLen(unicode) > 0 {
				isCtrlDown := GetKeyState("LControl")
				isShiftDown := GetKeyState("LShift")

				if (isCtrlDown) {
					unicodeCodePoint := Util.UnicodeToChar(sequence.length > 1 ? sequence : unicode)
					A_Clipboard := unicodeCodePoint

					SoundPlay("C:\Windows\Media\Speech On.wav")
				} else if isShiftDown {
					if (unicode = Util.ExtractHex(entry["unicode"])) {
						SoundPlay("C:\Windows\Media\Speech Misrecognition.wav")
						if !FavoriteChars.CheckVar(entryCol) {
							FavoriteChars.Add(entryCol, isFavoriteTab)
						} else {
							FavoriteChars.Remove(entryCol, isFavoriteTab)
						}
					}

				} else {
					UnicodeWebResource("Copy", unicode)
				}
			}
		}
		return
	}

	ItemSetPreview(panelWindow, LV, rowValue, options) {
		local entryName := LV.GetText(rowValue, 5)
		local key := LV.GetText(rowValue, 2)
		local view := LV.GetText(rowValue, 3)
		local combinationKey := LV.GetText(rowValue, 6)
		local prefix := options.prefix
		local previewType := options.previewType

		if entryName = "" {
			panelWindow[prefix "Title"].Text := this.notAvailable
			panelWindow[prefix "Symbol"].Text := DottedCircle
			panelWindow[prefix "UnicodeField"].Text := this.defaultUnicode
			panelWindow[prefix "UnicodeBlock"].Text := this.defaultUnicodeBlock
			panelWindow[prefix "HTMLField"].Text := this.defaultHTML
			panelWindow[prefix "AltCodeField"].Text := this.notAvailable
			panelWindow[prefix "AltCodePages"].Text := ""
			panelWindow[prefix "LaTeXField"].Text := this.notAvailable
			panelWindow[prefix "LaTeXPackage"].Text := ""
			panelWindow[prefix "Group"].Text := Locale.Read("character")
			panelWindow[prefix "Font"].Text := ""
			panelWindow[prefix "EntryName"].Text := "[" Chr(0x2003) this.notAvailable Chr(0x2003) "]"

			panelWindow[prefix "Title"].SetFont("s" this.fontSizes.title " norm " this.fontColorNoData, Fonts.fontFaces["Default"].name)
			panelWindow[prefix "Symbol"].SetFont("s" this.fontSizes.preview " norm " this.fontColorNoData, Fonts.fontFaces["Default"].name)
			panelWindow[prefix "UnicodeField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "HTMLField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "LaTeXField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "AltCodeField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "EntryName"].SetFont(this.fontColorNoData)

			panelWindow[prefix "RecipeField"].Text := ""
			panelWindow[prefix "LegendButton"].Enabled := False
			panelWindow[prefix "GlyphsVariantsButton"].Enabled := False
			panelWindow[prefix "OpenTagsButton"].Enabled := False

			Loop this.previewAlterationsCount {
				local index := A_Index
				panelWindow[prefix "AlterationPreview" index].Text := this.defaultAlteration
				panelWindow[prefix "AlterationPreview" index].SetFont(this.fontColorNoData)
			}

			panelWindow[prefix "TagsLV"].Delete()
			return
		}

		local languageCode := Language.Get()
		local entry := ChrLib.GetEntry(entryName)
		local isReferenced := entry["reference"] is Object || entry["reference"] != ""

		local char := Util.UnicodeToChar(entry["sequence"].Length > 0 ? entry["sequence"] : entry["unicode"])
		local htmlCode := Util.StrToHTML(char)
		local previewSymbol := StrLen(entry["symbol"]["alt"]) > 0 ? entry["symbol"]["alt"] : entry["symbol"]["set"]
		local characterTitle := this.HandleTitle(entryName "[type::" previewType "]", &languageCode, True)

		local isDiacritic := RegExMatch(entry["symbol"]["set"], "^" DottedCircle "\S")
		local groupTitle := Locale.Read(isDiacritic ? "dictionary.combining_character" : "dictionary.character")

		local altCodePages := entry["altCodePages"].Length > 0 ? entry["altCodePages"].ToString() : ""
		local unicodeBlock := entry["unicodeBlock"] != "" ? entry["unicodeBlock"] : this.defaultUnicodeBlock
		local entryFont := entry["symbol"]["font"]

		panelWindow[prefix "Group"].Text := groupTitle
		panelWindow[prefix "Title"].Text := characterTitle
		panelWindow[prefix "Symbol"].Text := previewSymbol
		panelWindow[prefix "UnicodeField"].Text := entry["sequence"].Length > 0 ? entry["sequence"].ToString(" ") : entry["unicode"]
		panelWindow[prefix "UnicodeBlock"].Text := unicodeBlock
		panelWindow[prefix "HTMLField"].Text := StrLen(entry["entity"]) > 0 ? [htmlCode, entry["entity"]].ToString(" ") : htmlCode
		panelWindow[prefix "AltCodeField"].Text := StrLen(entry["altCode"]) > 0 ? entry["altCode"] : this.notAvailable
		panelWindow[prefix "AltCodePages"].Text := entry["altCodePages"].Length > 0 ? Locale.ReadInject("dynamic_dictionary.code_page", [Util.StrCutToComma(altCodePages, 24)]) : ""
		panelWindow[prefix "LaTeXField"].Text := entry["LaTeX"].Length > 0 ? entry["LaTeX"].ToString(Chr(0x2002)) : this.notAvailable
		panelWindow[prefix "LaTeXPackage"].Text := StrLen(entry["LaTeXPackage"]) > 0 ? Chrs(0x1F4E6, 0x2005) entry["LaTeXPackage"] : ""
		panelWindow[prefix "Font"].Text := entryFont != "" ? this.fontMarker entryFont : ""
		panelWindow[prefix "EntryName"].Text := "[" Chr(0x2003) entryName Chr(0x2003) "]"
		panelWindow[prefix "RecipeField"].Text := key != "" ? key : view
		panelWindow[prefix "RecipeTitleSecondary"].Text := combinationKey

		panelWindow[prefix "TagsLV"].Delete()

		for tag in entry["tags"]
			panelWindow[prefix "TagsLV"].Add(, tag)

		local alterationSymbols := []

		panelWindow[prefix "GlyphsVariantsButton"].Enabled := entry["alterations"].Count > 0
		for alteration, codePoint in entry["alterations"]
			if !(alteration ~= "i)Entity")
				alterationSymbols.Push(codePoint)

		Loop this.previewAlterationsCount {
			local index := A_Index
			local notHasAlt := index <= alterationSymbols.Length
			local character := notHasAlt ? Util.UnicodeToChar(alterationSymbols[index]) : this.defaultAlteration
			local fontColor := notHasAlt ? this.fontColorDefault : this.fontColorNoData
			panelWindow[prefix "AlterationPreview" index].Text := character
			panelWindow[prefix "AlterationPreview" index].SetFont(fontColor, notHasAlt ? Fonts.CompareByPair(alterationSymbols[index]) : "Segoe UI")
		}

		panelWindow[prefix "LegendButton"].Enabled := entry["options"]["legend"]
		panelWindow[prefix "openTagsButton"].Enabled := entry["tags"].Length > 0

		local keyLen := StrLen(key) - Util.StrCountOfChr(key, DottedCircle)
		local combinationLen := StrLen(combinationKey)
		local titleLen := StrLen(characterTitle)

		panelWindow[prefix "Symbol"].SetFont(this.fontColorDefault, entryFont != "" ? entryFont : Fonts.fontFaces["Default"].name)
		panelWindow[prefix "Title"].SetFont("s" (titleLen > 32 ? this.fontSizes.titleSmall : this.fontSizes.title) " " (panelWindow[prefix "Title"].Text = this.notAvailable ? this.field : this.fontColorDefault))
		panelWindow[prefix "UnicodeField"].SetFont(panelWindow[prefix "UnicodeField"].Text = this.defaultUnicode ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "HTMLField"].SetFont(panelWindow[prefix "HTMLField"].Text = this.defaultHTML ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "AltCodeField"].SetFont(panelWindow[prefix "AltCodeField"].Text = this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "LaTeXField"].SetFont(panelWindow[prefix "LaTeXField"].Text = this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "EntryName"].SetFont(panelWindow[prefix "EntryName"].Text ~= this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "RecipeField"].SetFont(, entryFont != "" ? entryFont : "Segoe UI")
		panelWindow[prefix "RecipeField"].Move(, , , keyLen > 32 ? this.fieldH * (this.reservedRecipeSteps * 1.25) : this.fieldH)


		return
	}

	TagItemDoubleClick(LV, rowNumber) {
		local tag := LV.GetText(rowNumber, 1)

		if tag != "" {
			isCtrlDown := GetKeyState("LControl")

			if isCtrlDown {
				A_Clipboard := tag
				SoundPlay("C:\Windows\Media\Speech On.wav")
			} else {
				Run("https://www.google.com/search?q=" tag)
			}
		}
		return
	}


	PreviewPanelEntryNameClick(text) {
		RegExMatch(text, "\[\x{2003}(.*)\x{2003}\]", &entryName)
		A_Clipboard := entryName[1]
		SoundPlay("C:\Windows\Media\Speech On.wav")

		return
	}

	PreviewButtonsBridge(guiObj, prefix, callType := "GlyphsPanel") {
		RegExMatch(guiObj[prefix "EntryName"].Text, "\[\x{2003}(.*)\x{2003}\]", &entryName)

		callMethods := Map(
			"GlyphsPanel", (*) => GlyphsPanel(entryName[1]),
			"ChrLegend", (*) => ChrLegend(entryName[1])
		)

		callMethods[callType]()
		return
	}

	ToggleExpandTagsList(panelWindow) {
		this.states.tagsExpanded := !this.states.tagsExpanded

		for prefix in this.listViewTabs {
			local LV := panelWindow[prefix "TagsLV"]
			local BTN := panelWindow[prefix "OpenTagsButton"]
			local newW := this.states.tagsExpanded ? this.defaultFrameW : this.previewGrpBoxW - 2
			local newX := this.states.tagsExpanded ? this.defaultFrameX : this.previewGrpBoxX + 1

			LV.Move(newX, , newW)
			LV.ModifyCol(1, newW - 6)

			BTN.Visible := this.states.tagsExpanded
		}

		return
	}

	Class TagsPanel {
		w := 500
		h := 500

		__New(panelWindow, LV, prefix, instance) {
			WinGetPos(&panelX, &panelY, &panelW, &panelH, panelWindow.Title)
			this.panelW := panelW
			this.panelH := panelH
			this.panelX := panelX
			this.panelY := panelY

			this.x := this.panelX + (this.panelW - this.w) / 2
			this.y := this.panelY + (this.panelH - this.h) / 2
			this.Constructor(panelWindow, LV, prefix, instance)

			return
		}

		Constructor(panelWindow, LV, prefix, instance) {
			local entryName := panelWindow[prefix "EntryName"].Text
			local title := App.Title() " — " Locale.Read("dictionary.tags") " — " entryName
			local tagsWindow := Gui()
			tagsWindow.Title := title

			local innerLV := tagsWindow.AddListView(Format("x{} y{} w{} h{} -Multi -Hdr", 5, 5, this.w - 10, this.h - 10), [""])
			innerLV.OnEvent("DoubleClick", (LV, rowNumber) => instance.TagItemDoubleClick(LV, rowNumber))

			Loop LV.GetCount() {
				local index := A_Index
				innerLV.Add(, LV.GetText(index, 1))
			}
			return tagsWindow.Show(Format("x{} y{} w{} h{}", this.x, this.y, this.w, this.h))
		}
	}
}

F11:: globalInstances.MainGUI.Show()

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
		Map("help.search_at_library", [
			"help.search_at_library.glyph_variations",
			"help.search_at_library.funcs",
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

	static panelTitle := App.Title("+status+version") " — " Locale.Read("gui.panel")

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

	static externalGroups := {
		smelting: [],
		fastKeys: [],
		secondkeys: [],
		tertiarykeys: [],
		scripts: [],
		TELEXVNI: [],
	}

	static externalGroupKeys := {
		smelting: Map(),
		fastKeys: Map(),
		secondkeys: Map(),
		tertiarykeys: Map(),
		scripts: Map(),
		TELEXVNI: Map(),
	}

	static SetPanelData() {
		; tt := this.PanelDataToolTip.Bind(this)
		; SetTimer(tt, 100, 0)

		this.LV_Content := {
			smelting: this.LV_InsertGroup({
				type: "Recipe",
				group: ArrayMerge([
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
				], this.externalGroups.smelting),
				groupKey: MapMerge(Map(), this.externalGroupKeys.smelting),
			}),
			fastkeys: ArrayMerge(this.LV_InsertGroup({
				type: "Fast Key",
				group: ArrayMerge([
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
				], this.externalGroups.fastKeys),
				groupKey: MapMerge(Map(
					"FK Diacritics Primary", LeftControl LeftAlt,
					"Special Fast Left", LeftAlt,
					"Special Fast Secondary", RightAlt,
					"Special Right Shift", RightShift,
					"Wallet Signs Left Shift", LeftShift
				), this.externalGroupKeys.fastKeys),
			}), this.LV_InsertGroup({
				type: "Special Combinations",
				group: ["Special Combinations"],
				groupKey: Map("Special Combinations", Locale.Read("symbol_special_key")),
			})
			),
			secondkeys: this.LV_InsertGroup({
				type: "Fast Key",
				group: ArrayMerge([
					"SK Diacritics Primary", "",
					"SK Spaces Primary", "",
					"SK Special Secondary", "",
					"SK Spaces Secondary", "",
					"SK Special Left Alt", "",
					"SK Spaces Left Alt", "",
				], this.externalGroups.secondkeys),
				groupKey: MapMerge(Map(
					"SK Diacritics Primary", LeftControl LeftAlt,
					"SK Special Secondary", RightAlt,
					"SK Special Left Alt", LeftAlt,
				), this.externalGroupKeys.fastKeys),
			}),
			tertiarykeys: this.LV_InsertGroup({
				type: "Fast Key",
				group: ArrayMerge([
					"TK Diacritics Primary", "",
				], this.externalGroups.tertiarykeys),
				groupKey: MapMerge(Map(
					"TK Diacritics Primary", LeftControl LeftAlt,
				), this.externalGroupKeys.fastKeys),
			}),
			scripts: this.LV_InsertGroup({
				type: "Alternative Layout",
				group: ArrayMerge([
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
				], this.externalGroups.scripts),
				groupKey: MapMerge(Map(
					"Hellenic", Locale.Read.Bind(Locale, "symbol_hellenic"),
					"Germanic Runic Elder Futhark", Locale.Read.Bind(Locale, "symbol_futhark"),
					"Germanic Runic Futhork", Locale.Read.Bind(Locale, "symbol_futhork"),
					"Germanic Runic Younger Futhark", Locale.Read.Bind(Locale, "symbol_futhark_younger"),
					"Germanic Runic Almanac", Locale.Read.Bind(Locale, "symbol_futhark_almanac"),
					"Germanic Runic Later Younger Futhark", Locale.Read.Bind(Locale, "symbol_futhark_younger_later"),
					"Germanic Runic Medieval", Locale.Read.Bind(Locale, "symbol_medieval_runes"),
					"Runic Punctuation", Locale.Read.Bind(Locale, "symbol_runic_punctuation"),
					"Glagolitic", Locale.Read.Bind(Locale, "symbol_glagolitic"),
					"Old Turkic", Locale.Read.Bind(Locale, "symbol_turkic"),
					"Old Turkic Orkhon", Locale.Read.Bind(Locale, "symbol_turkic_orkhon"),
					"Old Turkic Yenisei", Locale.Read.Bind(Locale, "symbol_turkic_yenisei"),
					"Old Permic", Locale.Read.Bind(Locale, "symbol_permic"),
					"Old Hungarian", Locale.Read.Bind(Locale, "symbol_hungarian"),
					"Gothic", Locale.Read.Bind(Locale, "symbol_gothic"),
					"Old Italic", Locale.Read.Bind(Locale, "symbol_old_italic"),
					"Phoenician", Locale.Read.Bind(Locale, "symbol_phoenician"),
					"South Arabian", Locale.Read.Bind(Locale, "symbol_ancient_south_arabian"),
					"North Arabian", Locale.Read.Bind(Locale, "symbol_ancient_north_arabian"),
					"Carian", Locale.Read.Bind(Locale, "symbol_carian"),
					"Lycian", Locale.Read.Bind(Locale, "symbol_lycian"),
					"Lydian", Locale.Read.Bind(Locale, "symbol_lydian"),
					"Sidetic", Locale.Read.Bind(Locale, "symbol_sidetic"),
					"Cypriot Syllabary", Locale.Read.Bind(Locale, "symbol_cypriot_syllabary"),
					"Tifinagh", Locale.Read.Bind(Locale, "symbol_tifinagh"),
					"Ugaritic", Locale.Read.Bind(Locale, "symbol_ugaritic"),
					"Old Persian", Locale.Read.Bind(Locale, "symbol_old_persian"),
					"IPA", Locale.Read.Bind(Locale, "symbol_ipa"),
					"Deseret", Locale.Read.Bind(Locale, "symbol_deseret"),
					"Shavian", Locale.Read.Bind(Locale, "symbol_shavian"),
					"Mathematical", Locale.Read.Bind(Locale, "symbol_maths")
				), this.externalGroupKeys.scripts),
			}),
			TELEXVNI: this.LV_InsertGroup({
				type: "TELEX/VNI",
				group: ArrayMerge([
					"TELEX/VNI Vietnamese", "",
					"TELEX/VNI Jorai", "",
					"TELEX/VNI Chinese Romanization", "",
				], this.externalGroups.TELEXVNI),
				groupKey: MapMerge(Map(
					"TELEX/VNI Vietnamese", Locale.Read.Bind(Locale, "symbol_vietnamese"),
					"TELEX/VNI Jorai", Locale.Read.Bind(Locale, "symbol_jorai"),
					"TELEX/VNI Chinese Romanization", Locale.Read.Bind(Locale, "symbol_chinese_romanization"),
				), this.externalGroupKeys.fastKeys),
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

		; SetTimer(tt, 0)
		; ToolTip(Chr(0x2705))
		; this.pdToolTipIncrement := 0
		; SetTimer(ToolTip.Bind(""), -500)
	}

	static Panel(redraw := False) {
		if !initialized
			return

		UISets := this.GetUISets()

		title := App.Title("+status+version") " — " Locale.Read("gui.panel")

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
			WinExist(this.panelTitle) && ReConstructor()

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

			aboutSampleWordsContent := panelWindow.AddText(UISets.aboutInfoBox.aboutSampleWordsContent, Locale.Read("about.scripts_words", "default"))
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


		if WinExist(this.panelTitle) && !redraw {
			WinActivate(this.panelTitle)
		} else {
			this.PanelGUI := Constructor()
			this.PanelGUI.Show()


			SetTimer(this.LV_SetRandomPreviews.Bind(this), -100)
		}

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
			items_LV.Add(, item[1] is Func ? item[1]() : item[1], item[2], item[3], item[4], item[5], item[6])
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
				TargetTextBox.Text := Locale.Read(label ".description")
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
				local titleCol := LV.GetText(rowNumber, 1)
				local entryCol := LV.GetText(rowNumber, 5)
				local entry := ChrLib.GetEntry(entryCol)
				local unicode := entry["unicode"]
				local unicodeBlock := entry["unicodeBlock"]
				local sequence := entry["sequence"]
				local altsCount := ObjOwnPropCount(entry["alterations"])
				local hasLegend := entry["options"]["legend"]

				if StrLen(unicode) > 0 {
					star := " " Chr(0x2605)
					isCharFavorite := FavoriteChars.CheckVar(entryCol)
					contextMenu := Menu()

					labels := {
						fav: Locale.Read("gui.panel.context_menu." (isCharFavorite ? "remove" : "add") "_favorites"),
						showSymbolPage: Locale.ReadInject("gui.panel.context_menu.show_symbol_page", [UnicodeWebResource.GetCurrentResource()]),
						showBlockPage: Locale.ReadInject("gui.panel.context_menu.show_block_page", [UnicodeBlockWebResource.GetCurrentResource()]),
						glyphVariations: Locale.Read("gui.panel.context_menu.glyph_variations"),
						legend: Locale.Read("gui.panel.context_menu.legend"),
						showEntry: Locale.ReadInject("gui.panel.context_menu.show_entry", [entryCol])
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
			local titleCol := LV.GetText(rowNumber, 1)
			local entryCol := LV.GetText(rowNumber, 5)
			local entry := ChrLib.GetEntry(entryCol)
			local unicode := entry["unicode"]
			local sequence := entry["sequence"]

			if StrLen(unicode) > 0 {
				isCtrlDown := GetKeyState("LControl")
				isShiftDown := GetKeyState("LShift")

				if (isCtrlDown) {
					unicodeCodePoint := Util.UnicodeToChar(sequence.length > 1 ? sequence : unicode)
					A_Clipboard := unicodeCodePoint

					SoundPlay("C:\Windows\Media\Speech On.wav")
				} else if isShiftDown {
					if (unicode = Util.ExtractHex(entry["unicode"])) {
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
			referenced := value["reference"] is Object || value["reference"] != ""

			getChar := Util.UnicodeToChar(value["sequence"].Length > 0 ? value["sequence"] : value["unicode"])
			htmlCode := Util.StrToHTML(getChar)
			previewSymbol := StrLen(value["symbol"]["alt"]) > 0 ? value["symbol"]["alt"] : value["symbol"]["set"]
			entryString := Locale.Read("entry") ": [" characterEntry "]"
			characterTitle := ""

			skipCombine := True
			combinedTitle := ""

			if value["options"]["localeCombineAnd"] {
				split := StrSplit(characterEntry, "_and_")
				if split.Length > 1 {
					for i, each in split {
						if Locale.Read(each "_alt", , True, &titleText) || Locale.Read(each, , True, &titleText) {
							combinedTitle .= titleText " " (i < split.Length ? Locale.Read("dictionary.and") " " : "")
							skipCombine := False
						}
					}
				}
			}

			if options.HasOwnProp("previewType") && options.previewType = "Alternative Layout" &&
				(value["options"]["layoutTitles"]) &&
				(Locale.Read(characterEntry "_layout_alt", , True, &titleText) ||
					Locale.Read(characterEntry "_layout", , True, &titleText)) {
				characterTitle := titleText
			} else if !skipCombine {
				characterTitle := combinedTitle

			} else if Locale.Read(characterEntry "_alt", , True, &titleText) {
				characterTitle := titleText

			} else if Locale.Read(characterEntry, , True, &titleText) {
				characterTitle := titleText

			} else if value["titles"].Count > 0 && value["titles"].Has(languageCode) {
				characterTitle := value["titles"][languageCode (value["titles"].Has(languageCode "_alt") ? "_alt" : "")]

			} else {
				characterTitle := Locale.Read(characterEntry)
			}

			if options.HasOwnProp("previewType") && options.previewType = "Alternative Layout"
				&& value["options"]["showOnAlt"] != "" && value["alterations"].Has(value["options"]["showOnAlt"]) {
				previewSymbol := Util.UnicodeToChar(value["alterations"][value["options"]["showOnAlt"]])
				entryString .= " :: " value["options"]["showOnAlt"]
			}


			local altCodePages := value["altCodePages"].Length > 0 ? value["altCodePages"].ToString() : ""

			this.PanelGUI[options.prefix "Title"].Text := characterTitle
			this.PanelGUI[options.prefix "Symbol"].Text := previewSymbol
			this.PanelGUI[options.prefix "Unicode"].Text := value["sequence"].Length > 0 ? value["sequence"].ToString(" ") : value["unicode"]
			this.PanelGUI[options.prefix "HTML"].Text := StrLen(value["entity"]) > 0 ? [htmlCode, value["entity"]].ToString(" ") : htmlCode
			this.PanelGUI[options.prefix "Alt"].Text := StrLen(value["altCode"]) > 0 ? value["altCode"] : "N/A"
			this.PanelGUI[options.prefix "AltPages"].Text := value["altCodePages"].Length > 0 ? Locale.ReadInject("symbol_altcode_pages", [Util.StrCutToComma(altCodePages, 24)]) : ""
			this.PanelGUI[options.prefix "LaTeX"].Text := value["LaTeX"].Length > 0 ? value["LaTeX"].ToString(Chr(0x2002)) : "N/A"
			this.PanelGUI[options.prefix "LaTeXPackage"].Text := StrLen(value["LaTeXPackage"]) > 0 ? Chrs(0x1F4E6, 0x2005) value["LaTeXPackage"] : ""


			this.PanelGUI[options.prefix "Title"].SetFont((StrLen(this.PanelGUI[options.prefix "Title"].Text) > 30) ? "s12" : "s" UISets.infoFonts.titleSize)

			this.PanelGUI[options.prefix "Symbol"].SetFont(, StrLen(value["symbol"]["font"]) > 0 ? value["symbol"]["font"] : previewFont)
			this.PanelGUI[options.prefix "Symbol"].SetFont("s" UISets.infoFonts.previewSize " norm cDefault")
			this.PanelGUI[options.prefix "Symbol"].SetFont(StrLen(value["symbol"]["customs"]) > 0 ? value["symbol"]["customs"] : StrLen(this.PanelGUI[options.prefix "Symbol"].Text) > 2 ? "s" UISets.infoFonts.previewSmaller " norm cDefault" : "s" UISets.infoFonts.previewSize " norm cDefault")


			this.PanelGUI[options.prefix "Unicode"].SetFont((StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "Unicode"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "HTML"].SetFont((StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "HTML"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont((StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 20) ? "s9" : "s12")

			tagsString := value["tags"].Length > 0 ? Locale.Read("tags") ": " value["tags"].ToString() : ""

			this.PanelGUI[options.prefix "Tags"].Text := entryString Chr(0x2002) tagsString


			groupTitle := ""
			isDiacritic := RegExMatch(value["symbol"]["set"], "^" DottedCircle "\S")

			AlterationsValidator := Map(
				"IsModifier", [value["alterations"].Has("modifier"), 0x02B0],
				"IsUncombined", [value["alterations"].Has("uncombined"), "(h)"],
				"IsSubscript", [value["alterations"].Has("subscript"), 0x2095],
				"IsCombining", [isDiacritic || value["alterations"].Has("combining"), 0x036A],
				"IsItalic", [value["alterations"].Has("italic"), 0x210E],
				"IsItalicBold", [value["alterations"].Has("italicBold"), 0x1D489],
				"IsBold", [value["alterations"].Has("bold"), 0x1D421],
				"IsFraktur", [value["alterations"].Has("fraktur"), 0x1D525],
				"IsFrakturBold", [value["alterations"].Has("frakturBold"), 0x1D58D],
				"IsScript", [value["alterations"].Has("script"), 0x1D4BD],
				"IsScriptBold", [value["alterations"].Has("scriptBold"), 0x1D4F1],
				"IsDoubleStruck", [value["alterations"].Has("doubleStruck"), 0x1D559],
				"IsDoubleStruckItalic", [value["alterations"].Has("doubleStruckItalic"), 0x2148],
				"IsSmallCaps", [value["alterations"].Has("smallCapital"), 0x029C],
			)

			for entry, value in AlterationsValidator {
				if (value[1]) {
					groupTitle .= (["(h)", 0x029C].HasValue(value[2]) ? (value[2] is Number ? Chr(value[2]) : value[2])
						: DottedCircle Chr(value[2])) " "
				}
			}

			this.PanelGUI[options.prefix "Group"].Text := groupTitle (isDiacritic ? Locale.Read("character_combining") : Locale.Read(referenced ? "entry_reference" : "character"))
			this.PanelGUI[options.prefix "Alert"].Text := value["symbol"]["font"] != "" ? Chr(0x1D4D5) " " value["symbol"]["font"] : ""

			this.PanelGUI[options.prefix "KeyPreview"].Text := characterKey
			this.PanelGUI[options.prefix "KeyPreviewSet"].Text := characterCombinationKey != "" ? characterCombinationKey : ""


			keyPreviewLength := StrLen(StrReplace(this.PanelGUI[options.prefix "KeyPreview"].Text, Chr(0x25CC), ""))
			KeyPreviewSetLength := StrLen(this.PanelGUI[options.prefix "KeyPreviewSet"].Text)


			hMult := keyPreviewLength > 25 ? 2 : 1
			this.PanelGUI[options.prefix "KeyPreview"].Move(, , , 24 * hMult)


			this.PanelGUI[options.prefix "KeyPreview"].SetFont("s12")

			this.PanelGUI[options.prefix "KeyPreviewSet"].SetFont((KeyPreviewSetLength > 5) ? "s10" : "s12")


			this.PanelGUI[options.prefix "LegendButton"].Enabled := value["options"]["legend"]
			this.PanelGUI[options.prefix "GlyphsVariantsButton"].Enabled := value["alterations"].Count > 0

		}

		if value["unicodeBlock"] != ""
			this.PanelGUI[options.prefix "UnicodeBlockLabel"].Text := value["unicodeBlock"]
	}

	static LV_SetCharacterPreview2(LV, rowValue, options) {
		UISets := this.GetUISets()
		entryName := LV.GetText(rowValue, 5)
		characterKey := LV.GetText(rowValue, 2)
		characterCombinationKey := LV.GetText(rowValue, 6)

		try {
			if options.prefix ~= "i)Keys"
				characterKey := Util.ReplaceModifierKeys(ChrLib.GetValue(rowValue, "options")["fastKey"])
			else if options.prefix = "Glago"
				characterKey := Util.ReplaceModifierKeys(ChrLib.GetValue(rowValue, "options")["altLayoutKey"])
		}

		previewFont := Cfg.Get("Preview_Font_Family", "PanelGUI", Fonts.fontFaces["Default"].name)

		if StrLen(entryName) < 1 {
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
			entry := ChrLib.GetEntry(entryName)
			referenced := entry["reference"] is Object || entry["reference"] != ""

			getChar := Util.UnicodeToChar(entry["sequence"].Length > 0 ? entry["sequence"] : entry["unicode"])
			htmlCode := Util.StrToHTML(getChar)
			previewSymbol := StrLen(entry["symbol"]["alt"]) > 0 ? entry["symbol"]["alt"] : entry["symbol"]["set"]
			entryString := Locale.Read("entry") ": [" entryName "]"
			characterTitle := ""

			skipCombine := True
			combinedTitle := ""

			if entry["options"]["localeCombineAnd"] {
				split := StrSplit(entryName, "_and_")
				if split.Length > 1 {
					for i, each in split {
						if Locale.Read(each "_alt", , True, &titleText) || Locale.Read(each, , True, &titleText) {
							combinedTitle .= titleText " " (i < split.Length ? Locale.Read("dictionary.and") " " : "")
							skipCombine := False
						}
					}
				}
			}

			if options.HasOwnProp("previewType") && options.previewType = "Alternative Layout" &&
				(entry["options"]["layoutTitles"]) &&
				(Locale.Read(entryName "_layout_alt", , True, &titleText) ||
					Locale.Read(entryName "_layout", , True, &titleText)) {
				characterTitle := titleText
			} else if !skipCombine {
				characterTitle := combinedTitle

			} else if Locale.Read(entryName "_alt", , True, &titleText) {
				characterTitle := titleText

			} else if Locale.Read(entryName, , True, &titleText) {
				characterTitle := titleText

			} else if entry["titles"].Count > 0 && entry["titles"].Has(languageCode) {
				characterTitle := entry["titles"][languageCode (entry["titles"].Has(languageCode "_alt") ? "_alt" : "")]

			} else {
				characterTitle := Locale.Read(entryName)
			}

			if options.HasOwnProp("previewType") && options.previewType = "Alternative Layout"
				&& entry["options"]["showOnAlt"] != "" && entry["alterations"].Has(entry["options"]["showOnAlt"]) {
				previewSymbol := Util.UnicodeToChar(entry["alterations"][entry["options"]["showOnAlt"]])
				entryString .= " :: " entry["options"]["showOnAlt"]
			}

			local altCodePages := entry["altCodePages"].Length > 0 ? entry["altCodePages"].ToString() : ""

			this.PanelGUI[options.prefix "Title"].Text := characterTitle
			this.PanelGUI[options.prefix "Symbol"].Text := previewSymbol
			this.PanelGUI[options.prefix "Unicode"].Text := entry["sequence"].Length > 0 ? entry["sequence"].ToString(" ") : entry["unicode"]
			this.PanelGUI[options.prefix "HTML"].Text := StrLen(entry["entity"]) > 0 ? [htmlCode, entry.entity].ToString(" ") : htmlCode
			this.PanelGUI[options.prefix "Alt"].Text := StrLen(entry["altCode"]) > 0 ? entry["altCode"] : "N/A"
			this.PanelGUI[options.prefix "AltPages"].Text := entry["altCodePages"].Length > 0 ? Locale.ReadInject("symbol_altcode_pages", [Util.StrCutToComma(altCodePages, 24)]) : ""
			this.PanelGUI[options.prefix "LaTeX"].Text := entry["LaTeX"].Length > 0 ? entry["LaTeX"].ToString(Chr(0x2002)) : "N/A"
			this.PanelGUI[options.prefix "LaTeXPackage"].Text := StrLen(entry["LaTeXPackage"]) > 0 ? Chrs(0x1F4E6, 0x2005) entry["LaTeXPackage"] : ""


			this.PanelGUI[options.prefix "Title"].SetFont((StrLen(this.PanelGUI[options.prefix "Title"].Text) > 30) ? "s12" : "s" UISets.infoFonts.titleSize)

			this.PanelGUI[options.prefix "Symbol"].SetFont(, StrLen(entry["symbol"]["font"]) > 0 ? entry["symbol"]["font"] : previewFont)
			this.PanelGUI[options.prefix "Symbol"].SetFont("s" UISets.infoFonts.previewSize " norm cDefault")
			this.PanelGUI[options.prefix "Symbol"].SetFont(StrLen(entry["symbol"]["customs"]) > 0 ? entry["symbol"]["customs"] : StrLen(this.PanelGUI[options.prefix "Symbol"].Text) > 2 ? "s" UISets.infoFonts.previewSmaller " norm cDefault" : "s" UISets.infoFonts.previewSize " norm cDefault")


			this.PanelGUI[options.prefix "Unicode"].SetFont((StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "Unicode"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "Unicode"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "HTML"].SetFont((StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "HTML"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "HTML"].Text) > 20) ? "s9" : "s12")
			this.PanelGUI[options.prefix "LaTeX"].SetFont((StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 15 && StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) < 21) ? "s10" : (StrLen(this.PanelGUI[options.prefix "LaTeX"].Text) > 20) ? "s9" : "s12")

			tagsString := entry["tags"].Length > 0 ? Locale.Read("tags") ": " entry["tags"].ToString() : ""

			this.PanelGUI[options.prefix "Tags"].Text := entryString Chr(0x2002) tagsString

			groupTitle := ""
			isDiacritic := RegExMatch(entry["symbol"]["set"], "^" DottedCircle "\S")

			AlterationsValidator := Map(
				"IsModifier", [entry["alterations"].Has("modifier"), 0x02B0],
				"IsUncombined", [entry["alterations"].Has("uncombined"), "(h)"],
				"IsSubscript", [entry["alterations"].Has("subscript"), 0x2095],
				"IsCombining", [isDiacritic || entry["alterations"].Has("combining"), 0x036A],
				"IsItalic", [entry["alterations"].Has("italic"), 0x210E],
				"IsItalicBold", [entry["alterations"].Has("italicBold"), 0x1D489],
				"IsBold", [entry["alterations"].Has("bold"), 0x1D421],
				"IsFraktur", [entry["alterations"].Has("fraktur"), 0x1D525],
				"IsFrakturBold", [entry["alterations"].Has("frakturBold"), 0x1D58D],
				"IsScript", [entry["alterations"].Has("script"), 0x1D4BD],
				"IsScriptBold", [entry["alterations"].Has("scriptBold"), 0x1D4F1],
				"IsDoubleStruck", [entry["alterations"].Has("doubleStruck"), 0x1D559],
				"IsDoubleStruckItalic", [entry["alterations"].Has("doubleStruckItalic"), 0x2148],
				"IsSmallCaps", [entry["alterations"].Has("smallCapital"), 0x029C],
			)

			for entry, entry in AlterationsValidator {
				if (entry[1]) {
					groupTitle .= (["(h)", 0x029C].HasValue(entry[2]) ? (entry[2] is Number ? Chr(entry[2]) : entry[2])
						: DottedCircle Chr(entry[2])) " "
				}
			}

			this.PanelGUI[options.prefix "Group"].Text := groupTitle (isDiacritic ? Locale.Read("character_combining") : Locale.Read(referenced ? "entry_reference" : "character"))
			this.PanelGUI[options.prefix "Alert"].Text := entry["symbol"]["font"] != "" ? Chr(0x1D4D5) " " entry["symbol"]["font"] : ""

			this.PanelGUI[options.prefix "KeyPreview"].Text := characterKey
			this.PanelGUI[options.prefix "KeyPreviewSet"].Text := characterCombinationKey != "" ? characterCombinationKey : ""


			keyPreviewLength := StrLen(StrReplace(this.PanelGUI[options.prefix "KeyPreview"].Text, Chr(0x25CC), ""))
			KeyPreviewSetLength := StrLen(this.PanelGUI[options.prefix "KeyPreviewSet"].Text)


			hMult := keyPreviewLength > 25 ? 2 : 1
			this.PanelGUI[options.prefix "KeyPreview"].Move(, , , 24 * hMult)


			; this.PanelGUI[options.prefix "KeyPreview"].SetFont((keyPreviewLength > 25 && keyPreviewLength < 36) ? "s10" : (keyPreviewLength > 36) ? "s9" : "s12")
			this.PanelGUI[options.prefix "KeyPreview"].SetFont("s12")

			this.PanelGUI[options.prefix "KeyPreviewSet"].SetFont((KeyPreviewSetLength > 5) ? "s10" : "s12")


			this.PanelGUI[options.prefix "LegendButton"].Enabled := StrLen(entry["options"]["legend"]) > 1 ? True : False
			this.PanelGUI[options.prefix "GlyphsVariantsButton"].Enabled := ObjOwnPropCount(entry["alterations"]) > 0 ? True : False

		}

		if entry["unicodeBlock"] != ""
			this.PanelGUI[options.prefix "UnicodeBlockLabel"].Text := entry["unicodeBlock"]
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
				ArrayMergeTo(&outputArrays, this.LV_InsertGroup(each))
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

					; if eachOptions.hasOwnProp("groupKey") && eachOptions.groupKey is Func
					; 	eachOptions.groupKey := eachOptions.groupKey()

					ArrayMergeTo(&outputArrays, this.LV_InsertGroup(eachOptions))
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
			if options.HasOwnProp("groupKey") {
				if options.groupKey is Func
					options.groupKey := options.groupKey()
				if StrLen(options.groupKey) > 0
					outputArray.Push(["", options.groupKey, "", "", "", "", ""])
			}


			for groupKey, entryNamesArray in ChrLib.entryGroups {
				if !([groupKey].HasRegEx(options.group)) || entryNamesArray.Length = 0 {
					continue
				} else {
					for entryName in entryNamesArray {
						local entry := ChrLib.GetEntry(entryName)

						isFavorite := FavoriteChars.CheckVar(entryName)

						try {
							if (entry["options"]["hidden"]) ||
								(options.hasOwnProp("blacklist") && options.blacklist.HasRegEx(entryName)) ||
								(!entry["groups"].HasRegEx(options.group)) ||
								(options.type = "Recipe" && (entry["recipe"].Length = 0)) ||
								(options.type = "Fast Key" && (StrLen(entry["options"]["fastKey"]) < 2)) ||
								(options.type = "Fast Key Special" && (StrLen(entry["options"]["specialKey"]) < 2)) ||
								(options.type = "Alternative Layout" && (StrLen(entry["options"]["altLayoutKey"]) < 2)) ||
								(options.type = "TELEX/VNI" && (!entry["options"].Has("telex__" options.subType) ||
									entry["options"].Has("telex__" options.subType) && entry["options"]["telex__" options.subType] = "")
								)
							{
								continue
							}
						} catch {
							throw "Trouble in paradise: " entryName " typeof groupKey" (options.hasOwnProp("groupKey") ? Type(options.groupKey) : "null") " recipe" Type(entry["recipe"]) " fastKey" Type(entry["options"]["fastKey"]) " specialKey" Type(entry["options"]["specialKey"]) " altLayoutKey" Type(entry["options"]["altLayoutKey"])
						}

						characterTitle := ""

						skipCombine := True
						combinedTitle := ""

						if entry["options"]["localeCombineAnd"] {
							split := StrSplit(entryName, "_and_")
							if split.Length > 1 {
								for i, each in split {
									if Locale.Read(each "_alt", , True, &titleText) || Locale.Read(each, , True, &titleText) {
										combinedTitle .= titleText " " (i < split.Length ? Locale.Read("dictionary.and") " " : "")
										skipCombine := False
									}
								}
							}
						}

						if options.type = "Alternative Layout" && entry["options"]["layoutTitles"] &&
							Locale.Read(entryName "_layout", , True, &titleText) {
							characterTitle := titleText

						} else if !skipCombine {
							characterTitle := combinedTitle

						} else if Locale.Read(entryName, , True, &titleText) {
							characterTitle := titleText

						} else if entry["titles"].Count > 0 && entry["titles"].Has(languageCode) {
							characterTitle := entry["titles"].Get(languageCode)

						} else if entry["name"] != "" {
							characterTitle := entry["name"]

						} else {
							characterTitle := Locale.Read(entryName)
						}

						if isFavorite {
							characterTitle .= " " Chr(0x2605)
						}

						characterSymbol := entry["symbol"]["set"]

						characterBinding := ""

						bindings := Map(
							"Recipe", entry["recipeAlt"].Length > 0 ? entry["recipeAlt"].ToString() : entry["recipe"].Length > 0 ? entry["recipe"].ToString() : "",
							"Alternative Layout", entry["options"]["altLayoutKey"],
							"Special Combinations", entry["options"]["altSpecialKey"],
							"Fast Key", entry["options"]["fastKey"],
							"TELEX/VNI", options.type = "TELEX/VNI" && entry["options"].Has("telex__" options.subType) ? entry["options"]["telex__" options.subType] : "",
						)

						characterBinding := bindings.Has(options.type) ? bindings.Get(options.type) : options.type = "" && entry["recipeAlt"].Length > 0 ? entry["recipeAlt"].ToString() : ""

						reserveCombinationKey := ""

						for cgroup, ckey in this.combinationKeyToGroupPairs {
							reserveCombinationKey := entry["groups"].HasValue(cgroup) ? ckey : reserveCombinationKey
						}
						reserveCombinationKey := (reserveCombinationKey != "" ? reserveCombinationKey " + " : "")

						intermediateMap.Set(entry["index"],
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
								Util.ExtractHex(entry["unicode"]),
								entryName,
								options.hasOwnProp("combinationKey") ? options.combinationKey : options.hasOwnProp("groupKey") ? options.groupKey : ""
							])
					}
				}
			}

			for cgroup, entry in intermediateMap {
				outputArray.Push(entry)
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