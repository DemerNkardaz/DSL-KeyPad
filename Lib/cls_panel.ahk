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
			areaWidth: "w620",
			areaHeight: "h480",
			areaRules: "+NoSort -Multi",
			listStyle: "w620 h480 +NoSort -Multi",
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

			windowWidth := 860
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

			for _, localeKey in ["name", "recipe", "result", "unicode", "entryid", "entry_title"] {
				panelColList.smelting.Push(Locale.Read("col_" localeKey))
			}

			LV_Content := {
				diacritics: ArrayMerge(
					this.LV_insertGroup([
						;
						{ type: "Group Activator", group: "Diacritics Primary", groupKey: Window LeftAlt " F1", separator: true },
						;
						{ type: "Group Activator", group: "Diacritics Secondary", groupKey: Window LeftAlt " F2" },
						;
						{ type: "Group Activator", group: "Diacritics Tertiary", groupKey: Window LeftAlt " F3" },
						;
						{ type: "Group Activator", group: "Diacritics Quatemary", groupKey: Window LeftAlt " F6" }
					]),
				)
			}

			panelTabs := panelWindow.AddTab3("w" windowWidth - 18 " h" windowHeight - 15, panelTabList.Arr)
			panelTabs.UseTab(panelTabList.Obj.diacritics)

			this.AddCharactersTab({
				winObj: panelWindow,
				prefix: "Diacritic",
				columns: panelColList.default,
				columnWidths: this.UISets.column.widths,
				source: LV_Content.diacritics,
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
		}
	}

	static AddCharactersTab(options) {
		items_LV := options.winObj.AddListView(this.UISets.column.listStyle, options.columns)

		Loop options.columns.Length {
			index := A_Index
			items_LV.ModifyCol(index, options.columnWidths[index])
		}

		for item in options.source {
			items_LV.Add(, item[1], item[2], item[3], item[4], item[5])
		}

		items_FilterIcon := options.winObj.AddButton(this.UISets.filter.icon)
		GuiButtonIcon(items_FilterIcon, ImageRes, 169)
		items_Filter := options.winObj.AddEdit(this.UISets.filter.field options.prefix "Filter", "")
		items_Filter.SetFont("s10")
	}

	static LV_insertGroup(options) {
		if Type(options) = "Array" {
			for each in options {
				this.LV_insertGroup(each)
			}
		} else {

			if options.group == "" {
				return
			}

			if !(options.hasOwnProp("type")) {
				throw "Type is required for LV_insertGroup"
			}

			languageCode := Language.Get()
			outputArray := []


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
						characterBinding := value.recipeAlt.ArrayToString()
					else if value.HasOwnProp("recipe")
						characterBinding := value.recipe.ArrayToString()
					else
						characterBinding := "N/A"
				} else if options.type = "Alternative Layout" {
					characterBinding := value.options.altLayoutKey
				} else if options.type = "Fast Special" {
					characterBinding := value.options.specialKey
				} else if options.type = "Fast Key" {
					characterBinding := value.options.fastKey
				} else if options.type = "Group Activator" {
					characterBinding := value.options.groupKey
				} else {
					characterBinding := "N/A"
				}

				outputArray.Push([characterTitle, characterBinding, characterSymbol, Util.ExtractHex(value.unicode), characterEntry])
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