Class UIMainPanel {
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
		preview: 68,
		smallerPreview: 40,
		title: 14,
		titleSmall: 13,
		field: 12,
		fieldSmall: 11,
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
	fieldH := 28
	fieldX := this.defaultFrameX

	fieldTitleW := this.fieldW
	fieldTitleH := 14
	fieldTitleX := this.fieldX

	fieldTitleY := (this.previewTitleY + this.previewTitleH) + 10
	fieldY := (this.fieldTitleY + this.fieldTitleH) + 2

	fieldStep := 25
	fieldWStep := 5
	reservedRecipeSteps := 1.45

	incrementMultiPerRowTitle(stepsCount := 1, currentColumn := 1, maxColumns := 2) {
		local totalW := this.fieldTitleW
		local wStep := this.fieldWStep
		local w := (totalW - ((maxColumns - 1) * wStep)) / maxColumns
		local x := this.fieldTitleX + (currentColumn - 1) * (w + wStep)
		local y := this.fieldTitleY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
		local h := this.fieldTitleH

		return [x, y, w, h]
	}
	incrementMultiPerRowField(stepsCount := 1, currentColumn := 1, maxColumns := 2) {
		local totalW := this.fieldW
		local wStep := this.fieldWStep
		local w := (totalW - ((maxColumns - 1) * wStep)) / maxColumns

		local x := this.fieldX + (currentColumn - 1) * (w + wStep)

		local y := this.fieldY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
		local h := this.fieldH

		return [x, y, w, h]
	}

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

	entryNameW := this.previewGrpBoxW - 10
	entryNameH := 24
	entryNameX := this.previewGrpBoxX + (this.previewGrpBoxW - this.entryNameW) / 2
	entryNameY := (this.unicodeBlockY + this.unicodeBlockH) + 15

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

	; * Help
	helpX := this.tabsX + 10
	helpY := this.tabsY + 35
	helpW := 300
	helpH := this.tabsH - 45

	helpBoxX := this.helpX + this.helpW + 10
	helpBoxY := this.helpY
	helpBoxW := this.tabsW - (this.helpBoxX - this.tabsX) - 10
	helpBoxH := this.helpH

	helpTextX := this.helpBoxX + 10
	helpTextY := this.helpBoxY + 25
	helpTextW := this.helpBoxW - 20
	helpTextH := this.helpBoxH - 35

	tabs := [
		"smelting",
		"fastkeys",
		"secondkeys",
		"tertiarykeys",
		"scripts",
		"TELEXVNI",
		"all",
		"favorites",
		"help",
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
		this.helpData := JSON.LoadFile(App.paths.data "\ui_main_panel_help.json", "UTF-8")

		this.GetColumnsData(&columnsData)

		for i, each in columnsData.supportedLanguages
			this.listViewLocaleColumnsIndexes.Set(each, i + columnsData.languageColumnsStartIndex)
		this.FillListViewData(&JSONLists, &columnsData)

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

		if this.setCached
			Event.Trigger("UI Instance [Panel]", "Cache Loaded", this)
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
		local localizedWithKeys := Map()

		for tab in this.tabs {
			localizedTabs.Push(Locale.Read("gui.tabs." tab))
			localizedWithKeys.Set(tab, Locale.Read("gui.tabs." tab))
		}

		local panelTabs := panelWindow.AddTab3(Format("vTabs x{} y{} w{} h{}", this.tabsX, this.tabsY, this.tabsW, this.tabsH), localizedTabs)

		local tabHeaders := []

		for tab in this.listViewTabs
			tabHeaders.Push(Locale.Read("gui.tabs." tab))

		for i, header in tabHeaders {
			panelTabs.UseTab(header)

			local attributes := this.tabContents[i]
			this.CreateTabConcent(panelWindow, attributes)
		}

		panelTabs.UseTab(localizedWithKeys.Get("help"))

		local helpTree := panelWindow.AddTreeView(Format("vHelp x{} y{} w{} h{}", this.helpX, this.helpY, this.helpW, this.helpH))

		local helpTextBox := panelWindow.AddGroupBox(Format("vHelpBox x{} y{} w{} h{}", this.helpBoxX, this.helpBoxY, this.helpBoxW, this.helpBoxH), Locale.Read("dictionary.description"))

		local helpText := panelWindow.AddLink(Format("vHelpText x{} y{} w{} h{}", this.helpTextX, this.helpTextY, this.helpTextW, this.helpTextH))

		helpTree.SetFont("s10")
		helpTextBox.SetFont("s11")

		for each in this.helpData {
			if each is String {
				helpTree.Add(Locale.Read(each))
			} else if each is Map {
				for key, value in each {
					parentalEntry := helpTree.Add(Locale.Read(key), , InStr(key, "smelter") ? "Expand" : "")
					for eachChild in value {
						helpTree.Add(Locale.Read(eachChild), parentalEntry)
					}
				}
			}
		}

		helpTree.OnEvent("ItemSelect", (TV, Item) => this.TreeViewSetDescription(TV, Item, helpText))

		return panelWindow
	}

	TreeViewSetDescription(TV, Item, TargetTextBox) {
		if !Item
			return

		selectedLabel := TV.GetText(Item)

		for each in this.helpData {
			if each is String && Locale.Read(each) = selectedLabel {
				TargetTextBox.Text := Locale.Read(each ".description")
				TargetTextBox.SetFont("s11", "Segoe UI")
				return
			} else if each is Map {
				for key, value in each {
					if Locale.Read(key) = selectedLabel {
						TargetTextBox.Text := Locale.Read(key ".description")
						TargetTextBox.SetFont("s11", "Segoe UI")
						return
					} else {
						for eachChild in value {
							if Locale.Read(eachChild) = selectedLabel {
								TargetTextBox.Text := Locale.Read(eachChild ".description")
								TargetTextBox.SetFont("s11", "Segoe UI")
								return
							}
						}
					}
				}
			}
		}
		return
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
		for i, item in this.listViewData[attributes.source]
			charactersLV.Add(, item[localeData.localeIndex], ArraySlice(item, 2, attributes.columns.Length)*)

		local characterFilterIcon := panelWindow.AddButton(Format("x{} y{} h{} w{}", this.filterIconX, this.filterIconY, this.filterIconW, this.filterIconH))

		GuiButtonIcon(characterFilterIcon, ImageRes, 169)
		characterFilter := panelWindow.AddEdit(Format("x{} y{} w{} h{} v{}Filter",
			this.filterX, this.filterY, this.filterW, this.filterH, attributes.prefix), "")
		characterFilter.SetFont("s10")

		local filterInstance := UIMainPanelFilter(&panelWindow, &characterFilter, &charactersLV, &src, &localeData)

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

		local unicodeTitle := panelWindow.AddText(Format("v{}UnicodeTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementMultiPerRowTitle(this.reservedRecipeSteps + 1, 1, 2)*), Locale.Read("dictionary.unicode_point"))

		local internalIDTitle := panelWindow.AddText(Format("v{}InternalIDTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementMultiPerRowTitle(this.reservedRecipeSteps + 1, 2, 2)*), Locale.Read("dictionary.internal_id"))

		local unicodeField := panelWindow.AddEdit(Format("v{}UnicodeField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementMultiPerRowField(this.reservedRecipeSteps + 1, 1, 2)*), this.defaultUnicode)

		local internalIDField := panelWindow.AddEdit(Format("v{}InternalIDField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementMultiPerRowField(this.reservedRecipeSteps + 1, 2, 2)*), this.defaultUnicode)

		local htmlTitle := panelWindow.AddText(Format("v{}HTMLTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementMultiPerRowTitle(this.reservedRecipeSteps + 2, 1, 2)*), Locale.Read("dictionary.html_entity"))

		local htmlNamedTitle := panelWindow.AddText(Format("v{}HTMLNamedTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementMultiPerRowTitle(this.reservedRecipeSteps + 2, 2, 2)*), Locale.Read("dictionary.html_entity_named"))
		htmlNamedTitle.Visible := False

		local htmlField := panelWindow.AddEdit(Format("v{}HTMLField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementField(this.reservedRecipeSteps + 2)[1]*), this.defaultHTML)

		local htmlFieldDecimal := panelWindow.AddEdit(Format("v{}HTMLFieldDecimal {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementMultiPerRowField(this.reservedRecipeSteps + 2, 1, 2)*), this.defaultHTML)
		htmlFieldDecimal.Visible := False

		local htmlFieldNamed := panelWindow.AddEdit(Format("v{}HTMLFieldNamed {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementMultiPerRowField(this.reservedRecipeSteps + 2, 2, 2)*), this.defaultHTML)
		htmlFieldNamed.Visible := False

		local altCodeTitle := panelWindow.AddText(Format("v{}AltCodeTitle {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 3)[2]*), Locale.Read("dictionary.alt_code"))

		local altCodePages := panelWindow.AddText(Format("v{}AltCodePages {} x{} y{} w{} h{} Right", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 3)[2]*), Locale.Read("dictionary.alt_code"))

		local altCodeField := panelWindow.AddEdit(Format("v{}AltCodeField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementField(this.reservedRecipeSteps + 3)[1]*), this.notAvailable)

		local groupConfig := [2, 3, 4]
		local altCodeFields := Map()

		for groupIndex, groupSize in groupConfig {
			for fieldIndex in Range(1, groupSize) {
				local fieldName := Format("AltCodeField_G{}_{}", groupIndex + 1, fieldIndex)
				local fieldVar := Format("v{}{}", attributes.prefix, fieldName)

				local field := panelWindow.AddEdit(
					Format("{} {} x{} y{} w{} h{}",
						fieldVar,
						this.defaultEditOpts " " this.fontColorDefault,
						this.incrementMultiPerRowField(this.reservedRecipeSteps + 3, fieldIndex, groupIndex + 1)*
					),
					this.defaultHTML
				)

				field.Visible := False
				altCodeFields[fieldName] := field
			}
		}

		local LaTeX_LTX_Title := panelWindow.AddText(Format("v{}LaTeX_LTX {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4 - 0.04)[2]*), "L T  X")

		local LaTeX_A_Title := panelWindow.AddText(Format("v{}LaTeX_A {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4 - 0.04 - 0.035)[2]*), Chr(0x2004) "A")

		local LaTeX_E_Title := panelWindow.AddText(Format("v{}LaTeX_E {} x{} y{} w{} h{}", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4 - 0.04 + 0.07)[2]*), Chr(0x2003) Chr(0x2004) "E")

		local LaTeXPackageTitle := panelWindow.AddText(Format("v{}LaTeXPackage {} x{} y{} w{} h{} Right", attributes.prefix, this.defaultTextOpts, this.incrementField(this.reservedRecipeSteps + 4)[2]*))

		local LaTeXField := panelWindow.AddEdit(Format("v{}LaTeXField {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementField(this.reservedRecipeSteps + 4)[1]*), this.notAvailable)

		local LaTeXFieldText := panelWindow.AddEdit(Format("v{}LaTeXFieldText {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementMultiPerRowField(this.reservedRecipeSteps + 4, 1, 2)*), this.defaultHTML)
		LaTeXFieldText.Visible := False

		local LaTeXFieldMath := panelWindow.AddEdit(Format("v{}LaTeXFieldMath {} x{} y{} w{} h{}", attributes.prefix, this.defaultEditOpts " " this.fontColorNoData, this.incrementMultiPerRowField(this.reservedRecipeSteps + 4, 2, 2)*), this.defaultHTML)
		LaTeXFieldMath.Visible := False

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
		openTagsButton.OnEvent("Click", (*) => UIMainPanel.TagsPanel(panelWindow, tagsListView, attributes.prefix, instance))

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
		internalIDField.SetFont("s" this.fontSizes.field)
		htmlField.SetFont("s" this.fontSizes.field)
		htmlFieldDecimal.SetFont("s" this.fontSizes.field)
		htmlFieldNamed.SetFont("s" this.fontSizes.field)
		altCodeField.SetFont("s" this.fontSizes.field)
		for key, value in altCodeFields
			value.SetFont("s" this.fontSizes.field)
		LaTeXField.SetFont("s" this.fontSizes.field)
		LaTeXFieldText.SetFont("s" this.fontSizes.field)
		LaTeXFieldMath.SetFont("s" this.fontSizes.field)

		altCodePages.SetFont("s9")

		LaTeX_LTX_Title.SetFont("s10", "Cambria")
		LaTeX_A_Title.SetFont("s9", "Cambria")
		LaTeX_E_Title.SetFont("s10", "Cambria")
		EventFuncSetRandom()
		return Event.OnEvent("UI Instance [Panel]", "Cache Loaded", EventFuncSetRandom)

		EventFuncSetRandom(*) => this.SetRandomPreview(panelWindow, charactersLV, { prefix: attributes.prefix, previewType: attributes.previewType })
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

				while (RegExMatch(bindings, "\%([^%]+)\%", &match))
					bindings := RegExReplace(bindings, match[0], %match[1]%)

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
						: entry["symbol"]["alt"] != "" ? entry["symbol"]["alt"] : (entry["symbol"]["category"] = "Spaces" ? "[" characterSymbol "]" : characterSymbol)
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
			panelWindow[prefix "Symbol"].Value := DottedCircle
			panelWindow[prefix "UnicodeField"].Value := this.defaultUnicode
			panelWindow[prefix "InternalIDField"].Value := 0
			panelWindow[prefix "UnicodeBlock"].Value := this.defaultUnicodeBlock
			panelWindow[prefix "HTMLField"].Value := this.defaultHTML
			panelWindow[prefix "HTMLFieldDecimal"].Value := this.defaultHTML
			panelWindow[prefix "HTMLFieldNamed"].Value := this.notAvailable
			panelWindow[prefix "AltCodeField"].Value := this.notAvailable
			panelWindow[prefix "AltCodePages"].Text := ""
			panelWindow[prefix "LaTeXField"].Value := this.notAvailable
			panelWindow[prefix "LaTeXFieldText"].Value := this.notAvailable
			panelWindow[prefix "LaTeXFieldMath"].Value := this.notAvailable
			panelWindow[prefix "LaTeXPackage"].Text := ""
			panelWindow[prefix "Group"].Text := Locale.Read("character")
			panelWindow[prefix "Font"].Text := ""
			panelWindow[prefix "EntryName"].Text := "[" Chr(0x2003) this.notAvailable Chr(0x2003) "]"

			panelWindow[prefix "Title"].SetFont("s" this.fontSizes.title " norm " this.fontColorNoData, Fonts.fontFaces["Default"].name)
			panelWindow[prefix "Symbol"].SetFont("s" this.fontSizes.preview " norm " this.fontColorNoData, Fonts.fontFaces["Default"].name)
			panelWindow[prefix "UnicodeField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "InternalIDField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "HTMLField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "HTMLFieldDecimal"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "HTMLFieldNamed"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "LaTeXField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "LaTeXFieldText"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "LaTeXFieldMath"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "AltCodeField"].SetFont("s" this.fontSizes.field " " this.fontColorNoData)
			panelWindow[prefix "EntryName"].SetFont(this.fontColorNoData)

			panelWindow[prefix "RecipeField"].Value := ""
			panelWindow[prefix "LegendButton"].Enabled := False
			panelWindow[prefix "GlyphsVariantsButton"].Enabled := False
			panelWindow[prefix "OpenTagsButton"].Enabled := False

			Loop this.previewAlterationsCount {
				local index := A_Index
				panelWindow[prefix "AlterationPreview" index].Value := this.defaultAlteration
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
		panelWindow[prefix "Title"].Value := characterTitle
		panelWindow[prefix "Symbol"].Text := previewSymbol
		panelWindow[prefix "UnicodeField"].Value := entry["sequence"].Length > 0 ? entry["sequence"].ToString(" ") : entry["unicode"]
		panelWindow[prefix "InternalIDField"].Value := entry["index"]
		panelWindow[prefix "UnicodeBlock"].Text := unicodeBlock
		panelWindow[prefix "AltCodePages"].Text := entry["altCodePages"].Length > 0 ? Locale.ReadInject("dynamic_dictionary.code_page", [Util.StrCutToComma(altCodePages, 24)]) : ""
		panelWindow[prefix "LaTeXPackage"].Text := StrLen(entry["LaTeXPackage"]) > 0 ? Chrs(0x1F4E6, 0x2005) entry["LaTeXPackage"] : ""
		panelWindow[prefix "Font"].Text := entryFont != "" ? this.fontMarker entryFont : ""
		panelWindow[prefix "EntryName"].Text := "[" Chr(0x2003) entryName Chr(0x2003) "]"
		panelWindow[prefix "RecipeField"].Value := key != "" ? key : view
		panelWindow[prefix "RecipeTitleSecondary"].Text := combinationKey

		panelWindow[prefix "AltCodeField"].Value := entry["altCode"].Length > 0 ? entry["altCode"][1] : this.notAvailable
		panelWindow[prefix "AltCodeField"].Visible := entry["altCode"].Length < 2

		local groupSizes := [2, 3, 4]
		local altCodeLength := entry["altCode"].Length

		for groupIndex, groupSize in groupSizes {
			local groupNum := groupIndex + 1
			local isCurrentGroup := (altCodeLength = groupSize)

			for fieldIndex in Range(1, groupSize) {
				local fieldName := prefix "AltCodeField_G" groupNum "_" fieldIndex
				local field := panelWindow[fieldName]

				field.Value := isCurrentGroup ? entry["altCode"][fieldIndex] : this.notAvailable
				field.Visible := isCurrentGroup
			}
		}

		panelWindow[prefix "LaTeXField"].Value := entry["LaTeX"].Length > 0 ? entry["LaTeX"][1] : this.notAvailable
		panelWindow[prefix "LaTeXFieldText"].Value := entry["LaTeX"].Length = 2 ? entry["LaTeX"][1] : this.notAvailable
		panelWindow[prefix "LaTeXFieldMath"].Value := entry["LaTeX"].Length = 2 ? entry["LaTeX"][2] : this.notAvailable

		panelWindow[prefix "LaTeXField"].Visible := entry["LaTeX"].Length < 2
		panelWindow[prefix "LaTeXFieldText"].Visible := entry["LaTeX"].Length = 2
		panelWindow[prefix "LaTeXFieldMath"].Visible := entry["LaTeX"].Length = 2

		panelWindow[prefix "HTMLField"].Value := htmlCode
		panelWindow[prefix "HTMLFieldDecimal"].Value := htmlCode
		panelWindow[prefix "HTMLFieldNamed"].Value := entry["entity"]

		panelWindow[prefix "HTMLField"].Visible := entry["entity"] = ""
		panelWindow[prefix "HTMLFieldDecimal"].Visible := entry["entity"] != ""
		panelWindow[prefix "HTMLFieldNamed"].Visible := entry["entity"] != ""

		panelWindow[prefix "HTMLNamedTitle"].Visible := entry["entity"] != ""

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
		local entityLen := StrLen(entry["entity"])

		panelWindow[prefix "Symbol"].SetFont(this.fontColorDefault,
			entryFont != "" ? entryFont : Fonts.fontFaces["Default"].name)

		panelWindow[prefix "Symbol"].SetFont(entry["symbol"]["customs"] != "" ? entry["symbol"]["customs"] : "norm")

		panelWindow[prefix "Title"].SetFont("s" (titleLen > 32 ? this.fontSizes.titleSmall : this.fontSizes.title) " " (panelWindow[prefix "Title"].Text = this.notAvailable ? this.field : this.fontColorDefault))
		panelWindow[prefix "HTMLFieldNamed"].SetFont("s" (entityLen > 14 ? this.fontSizes.fieldSmall : this.fontSizes.field))

		panelWindow[prefix "UnicodeField"].SetFont(panelWindow[prefix "UnicodeField"].Text = this.defaultUnicode ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "InternalIDField"].SetFont(panelWindow[prefix "UnicodeField"].Text = 0 ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "HTMLField"].SetFont(panelWindow[prefix "HTMLField"].Text = this.defaultHTML ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "HTMLFieldDecimal"].SetFont(panelWindow[prefix "HTMLFieldDecimal"].Text = this.defaultHTML ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "HTMLFieldNamed"].SetFont(panelWindow[prefix "HTMLFieldNamed"].Text = this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "AltCodeField"].SetFont(panelWindow[prefix "AltCodeField"].Text = this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "LaTeXField"].SetFont(panelWindow[prefix "LaTeXField"].Text = this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "LaTeXFieldText"].SetFont(panelWindow[prefix "LaTeXField"].Text = this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "LaTeXFieldMath"].SetFont(panelWindow[prefix "LaTeXField"].Text = this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "EntryName"].SetFont(panelWindow[prefix "EntryName"].Text ~= this.notAvailable ? this.fontColorNoData : this.fontColorDefault)
		panelWindow[prefix "RecipeField"].SetFont(, entryFont != "" && previewType = "Recipe" ? entryFont : "Noto Serif")
		panelWindow[prefix "RecipeField"].Move(, , , keyLen > 32 ? this.fieldH * (this.reservedRecipeSteps * 1.25) : this.fieldH)

		return
	}

	SetRandomPreview(panelWindow, LV, options) {
		local count := LV.GetCount()
		local rand := 0
		local maxTries := 20

		if count > 0
			Loop maxTries {
				rand := Random(1, count)
				col1 := LV.GetText(rand, 1)
				col4 := LV.GetText(rand, 4)
				if (col1 != "" && col4 != "")
					break
			}

		if rand != 0 {
			LV.Modify(rand, "+Select +Focus")
			this.ItemSetPreview(panelWindow, LV, rand, options)
		}
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