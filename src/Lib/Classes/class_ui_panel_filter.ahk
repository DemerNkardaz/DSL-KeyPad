Class UIMainPanelFilter {
	__New(&panelWindow, &filterField, &originLV, &LV, &dataList, &localeData, &attributes) {
		this.panelWindow := panelWindow
		this.filterField := filterField
		this.originLV := originLV
		this.LV := LV
		this.dataList := dataList
		this.localeData := localeData
		this.attributes := attributes

		this.filterGeneration := 0
		this.isFilterRegExOn := Cfg.Get("Filter_RegEx", "PanelGUI", True, "bool")

		return Event.OnEvent("UI Instance [Panel]", "Filter State Changed", (&attributes, &limitedToCurrentTab?) => this.OnFilterRegExToggled(&attributes, &limitedToCurrentTab?))
	}

	OnFilterRegExToggled(&attributes, &limitedToCurrentTab?) {
		if IsSet(limitedToCurrentTab) && limitedToCurrentTab && attributes.prefix != this.attributes.prefix
			return

		currentFilterText := this.filterField.Text

		if currentFilterText != ""
			this.FilterBridge(&currentFilterText)
		else if currentFilterText == "" && this.LV.Visible
			this.Populate()
		return
	}

	UpdateDataList(&newDataList) {
		this.dataList := newDataList
		return
	}

	Populate() {
		this.LV.Delete()
		this.LV.Off()
		this.originLV.On()
		this.filterGeneration := 0
		return
	}

	FilterBridge(&filterText) {
		local lastFilterText := ""
		local currentFilterText := this.filterField.Text

		return SetTimer(() => this.FilterCheck(&currentFilterText, &lastFilterText), -500)
	}

	FilterCheck(&originalFilterText, &lastFilterText) {
		currentFilterText := this.filterField.Text

		if (currentFilterText == originalFilterText) {
			this.Filter(&currentFilterText)
			lastFilterText := currentFilterText
		}
	}

	Filter(&filterText) {
		this.filterGeneration++
		local currentGeneration := this.filterGeneration
		this.isFilterRegExOn := Cfg.Get("Filter_RegEx", "PanelGUI", True, "bool")

		if currentGeneration != this.filterGeneration
			return

		this.LV.Delete()

		local star := Chr(0x2002) Chr(0x2605)

		if filterText = "" {
			this.Populate()
		} else {
			local languageCode := Language.Get()
			local filterTextModes := Map(
				"i)^(R|Р):", "Recipes",
				"i)^(K|К):", "Keys",
				"i)^(C|С):", "Symbols",
			)

			local searchMode := Cfg.Get("Filter_Mode", "PanelGUI", "Names")
			local caseSensitive := Cfg.Get("Filter_Case_Sensitive", "PanelGUI", True, "bool")

			for pattern, patternMode in filterTextModes {
				if filterText ~= pattern {
					searchMode := patternMode
					filterText := RegExReplace(filterText, pattern)
					break
				}
			}

			local isSearchModeActive := searchMode != "Names"

			try {
				local matchedItems := []
				local previewType := this.attributes.previewType

				for item in this.dataList {
					if currentGeneration != this.filterGeneration
						return

					if item[this.localeData.localeIndex] = ""
						continue
					local itemText := item[this.localeData.localeIndex]
					itemText := StrReplace(itemText, star, "")

					local reserveTexts := []
					for key, index in this.localeData.localeIndexMap
						if index != this.localeData.localeIndex
							reserveTexts.Push(StrReplace(item[index], Chr(0x00A0), " "))

					local titles := []
					local titlesMap := Map()
					local tags := []
					local tagsMap := Map()
					local hiddenTags := []
					local hiddenTagsMap := Map()
					local useHiddenTags := False
					local isTagsMirrored := False
					local caseSensitiveMark := ""
					local isFavorite := False
					local symbolSequence := ""
					local specialMatch := { key: "", recipe: [] }
					local entryName := item[5]
					local entry := Map()

					if entryName != "" {
						entry := ChrLib.GetEntry(entryName)

						caseSensitiveMark := (!caseSensitive || entry["options"]["ignoreCaseOnPanelFilter"]) && !(filterText ~= "^i\)") ? "i)" : ""

						if !isSearchModeActive {
							titles := entry["altTitles"]
							titlesMap := entry["altTitlesMap"]
							tags := entry["tags"]
							tagsMap := entry["tagsMap"]
						}

						isFavorite := entry["groups"].HasValue("Favorites")
						symbolSequence := Util.UnicodeToChar(entry["sequence"].Length > 0 ? entry["sequence"] : entry["unicode"])

						useHiddenTags := entry["options"]["useHiddenTags"]

						if useHiddenTags {
							hiddenTagsMap := entry["hiddenTagsMap"]
							hiddenTags := entry["hiddenTags"]
						}

						specialMatch.key := previewType ~= "i)(Key|Alternative)" ? entry["options"][previewType = "Key" ? "fastKey" : "altLayoutKey"] : ""
						specialMatch.recipe := previewType = "Recipe" ? ArrayMerge(entry["recipe"], entry["recipeAlt"]) : []

						reserveTexts.MergeWith([symbolSequence, entryName], titles, tags, hiddenTags)
						isTagsMirrored := entry["options"]["isTagsMirrored"]
					}

					local displayText := itemText
					local filterData := {
						isFavorite: isFavorite,
						itemText: itemText,
						titles: titles,
						tags: tags,
						hiddenTags: hiddenTags,
						titlesMap: titlesMap,
						tagsMap: tagsMap,
						hiddenTagsMap: hiddenTagsMap,
						isTagsMirrored: isTagsMirrored,
						key: specialMatch.key,
						recipe: specialMatch.recipe,
						symbol: symbolSequence,
						searchMode: searchMode
					}

					local isMatch := isSearchModeActive ? this.SearchModeCompare(&filterData, &filterText, &caseSensitiveMark) : this.FilterCompare(&filterData, &filterText, &caseSensitiveMark, &reserveTexts, &displayText, &languageCode)

					if isFavorite && displayText != "" && !InStr(displayText, star, , -StrLen(star)) {
						displayText .= star
					}

					if isMatch {
						matchedItems.Push({
							displayText: displayText,
							item: item,
							originalText: itemText
						})
					}
				}

				if currentGeneration != this.filterGeneration
					return

				local groupedItems := this.GroupAndSortMatches(matchedItems)

				if currentGeneration != this.filterGeneration
					return

				local previousGroupName := ""
				for groupItem in groupedItems {
					if currentGeneration != this.filterGeneration
						return

					this.LV.Add(, groupItem.displayText, ArraySlice(groupItem.item, 2, this.localeData.columnsCount)*)

					if groupItem.originalText != "" && groupItem.originalText != previousGroupName
						previousGroupName := groupItem.originalText
				}

				if currentGeneration != this.filterGeneration
					return

				this.LV.On()

				this.originLV.Modify(0, "-Select -Focus")
				this.originLV.Off()

				this.filterGeneration := 0
			} catch as e
				this.Populate()
		}
	}

	FilterCompare(&data, &filterText, &caseSensitiveMark, &reserveTexts, &displayText, &languageCode) {
		local output := False
		local matchedTag := ""
		local filterValue := this.isFilterRegExOn ? filterText : RegExEscape(filterText)

		if data.isFavorite && filterText ~= "i)^(изб|fav|\*)" {
			output := True
		} else if filterText != "*" {
			if data.itemText ~= caseSensitiveMark filterValue {
				output := True
			} else {
				local unitedTitleTags := ArrayMerge(data.titles, data.tags, data.hiddenTags)
				matchedTag := this.FindMatchingTag(&unitedTitleTags, &filterText, &caseSensitiveMark)
				if matchedTag != "" {
					output := True
					if (data.tagsMap.Has(languageCode) && data.tagsMap[languageCode].HasValue(matchedTag)) || (data.tagsMap.Has(languageCode) && data.tagsMap[languageCode].HasValue(matchedTag))
						displayText := Util.StrUpper(matchedTag, 1)
					else if data.isTagsMirrored {
						for mapIndex, eachMap in [data.titlesMap, data.tagsMap, data.hiddenTagsMap] {
							for lang, tags in eachMap {
								for i, tag in tags {
									if tag != "" {
										if mapIndex = 3 && tag = matchedTag && data.tagsMap[languageCode].Has(i) {
											displayText := Util.StrUpper(data.tagsMap[languageCode][i], 1)
											break 2
										} else if tag = matchedTag && eachMap[languageCode].Has(i) {
											displayText := Util.StrUpper(eachMap[languageCode][i], 1)
											break 2
										}
									}
								}
							}
						}
					}

				} else
					output := this.MatchInArray(&reserveTexts, &filterText, &caseSensitiveMark)
			}
		}

		return output
	}

	SearchModeCompare(&data, &filterText, &caseSensitiveMark) {
		local matchReferences := Map("Recipes", data.recipe, "Keys", data.key, "Symbols", data.symbol)
		local matchableValue := matchReferences[data.searchMode]
		local value := this.isFilterRegExOn ? filterText : RegExEscape(filterText)

		return (matchableValue is Array && RegExMatchArray(matchableValue, caseSensitiveMark value)) || (matchableValue is String && matchableValue ~= caseSensitiveMark value)
	}

	MatchInArray(&textsArray, &filterText, &caseSensitiveMark) {
		local value := this.isFilterRegExOn ? filterText : RegExEscape(filterText)
		for each in textsArray {
			if each = filterText
				|| each ~= caseSensitiveMark value
				return True
		}
		return False
	}

	FindMatchingTag(&textsArray, &filterText, &caseSensitiveMark) {
		local value := this.isFilterRegExOn ? filterText : RegExEscape(filterText)
		for each in textsArray {
			if each = "" || StrLen(each) = 0
				continue
			if each = filterText
				|| each ~= caseSensitiveMark value
				return each
		}
		return ""
	}

	GroupAndSortMatches(matchedItems) {
		if matchedItems.Length = 0
			return []

		local groups := Map()
		local groupOrder := []

		for item in matchedItems {
			local groupKey := this.ExtractGroupPattern(item.displayText)

			if !groups.Has(groupKey) {
				groups[groupKey] := []
				groupOrder.Push(groupKey)
			}

			groups[groupKey].Push(item)
		}

		local result := []
		for groupKey in groupOrder {
			local groupItems := groups[groupKey]

			this.SortGroupItems(&groupItems)

			for item in groupItems
				result.Push(item)
		}

		return result
	}

	ExtractGroupPattern(text) {
		if RegExMatch(text, "^(.*?)\s*(\d+)", &match)
			return match[1]

		return text
	}

	SortGroupItems(&items) {
		local n := items.Length

		loop n - 1 {
			local i := A_Index
			loop n - i {
				local j := A_Index

				local num1 := this.ExtractNumber(items[j].displayText)
				local num2 := this.ExtractNumber(items[j + 1].displayText)

				if num1 != "" && num2 != "" && (num1 > num2) {
					local temp := items[j]
					items[j] := items[j + 1]
					items[j + 1] := temp
				}
			}
		}
	}

	ExtractNumber(text) {
		if RegExMatch(text, "\d+", &match)
			return Integer(match[0])
		return ""
	}
}