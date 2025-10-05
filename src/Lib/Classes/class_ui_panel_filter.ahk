Class UIMainPanelFilter {
	__New(&panelWindow, &filterField, &originLV, &LV, &dataList, &localeData, prefix) {
		this.panelWindow := panelWindow
		this.filterField := filterField
		this.originLV := originLV
		this.LV := LV
		this.dataList := dataList
		this.localeData := localeData

		this.prefix := prefix
		this.isCurrentTabFavorites := prefix = "favorites"
	}

	UpdateDataList(&newDataList) {
		this.dataList := newDataList
		return
	}

	Populate() {
		this.LV.Delete()
		this.LV.Visible := False
		this.LV.Enabled := False
		this.originLV.Visible := True
		this.originLV.Enabled := True
		; for item in this.dataList
		; 	this.LV.Add(, item[this.localeData.localeIndex], ArraySlice(item, 2, this.localeData.columnsCount)*)
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

	MatchInArray(&textsArray, &filterText) {
		for each in textsArray {
			local escaped := RegExEscape(each)
			if escaped = filterText
				|| escaped ~= filterText
				|| filterText ~= escaped
				return True
		}
		return False
	}

	FindMatchingTag(&textsArray, &filterText, &caseSensitiveMark) {
		for each in textsArray {
			if each = "" || StrLen(each) = 0
				continue
			local escaped := RegExEscape(each)
			if escaped = filterText
				|| escaped ~= caseSensitiveMark filterText
				|| filterText ~= caseSensitiveMark escaped
				return each
		}
		return ""
	}

	Filter(&filterText) {
		filterText := filterText
		this.LV.Delete()

		local star := Chr(0x2002) Chr(0x2605)

		if filterText = "" {
			this.Populate()
		} else {
			local languageCode := Language.Get()
			local keyOrRecipeMark := False

			if filterText ~= "i)^(R::|Р::)" {
				keyOrRecipeMark := True
				filterText := RegExReplace(filterText, "i)^(R::|Р::)")
			}

			try {
				local matchedItems := []

				for item in this.dataList {
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
					local entryName := item[5]

					if entryName != "" {
						titles := ChrLib.GetValue(entryName, "altTitles")
						titlesMap := ChrLib.GetValue(entryName, "altTitlesMap")
						tags := ChrLib.GetValue(entryName, "tags")
						tagsMap := ChrLib.GetValue(entryName, "tagsMap")
						caseSensitiveMark := ChrLib.GetValue(entryName, "options.ignoreCaseOnPanelFilter") && !InStr(filterText, "i)") ? "i)" : ""
						isFavorite := ChrLib.GetValue(entryName, "groups").HasValue("Favorites")

						useHiddenTags := ChrLib.GetValue(entryName, "options.useHiddenTags")

						if useHiddenTags {
							hiddenTagsMap := ChrLib.GetValue(entryName, "hiddenTagsMap")
							hiddenTags := ChrLib.GetValue(entryName, "hiddenTags")
						}

						reserveTexts.MergeWith([entryName], titles, tags, hiddenTags)
						isTagsMirrored := ChrLib.GetValue(entryName, "options.isTagsMirrored")
					}

					local isMatch := False
					local matchedTag := ""
					local displayText := itemText

					if keyOrRecipeMark {
						isMatch := item[2] ~= filterText
					} else if isFavorite && filterText ~= "^(изб|fav|\*)" {
						isMatch := True
					} else if filterText != "*" {
						if itemText ~= filterText {
							isMatch := True
						} else {
							local unitedTitleTags := ArrayMerge(titles, tags, hiddenTags)
							matchedTag := this.FindMatchingTag(&unitedTitleTags, &filterText, &caseSensitiveMark)
							if matchedTag != "" {
								isMatch := True
								if (tagsMap.Has(languageCode) && tagsMap[languageCode].HasValue(matchedTag)) || (tagsMap.Has(languageCode) && tagsMap[languageCode].HasValue(matchedTag))
									displayText := Util.StrUpper(matchedTag, 1)
								else if isTagsMirrored {
									for mapIndex, eachMap in [titlesMap, tagsMap, hiddenTagsMap] {
										for lang, tags in eachMap {
											for i, tag in tags {
												if tag != "" {
													if mapIndex = 3 && tag = matchedTag && tagsMap[languageCode].Has(i) {
														displayText := Util.StrUpper(tagsMap[languageCode][i], 1)
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
								isMatch := this.MatchInArray(&reserveTexts, &filterText)
						}
					}

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

				local groupedItems := this.GroupAndSortMatches(matchedItems)

				local previousGroupName := ""
				for groupItem in groupedItems {
					this.LV.Add(, groupItem.displayText, ArraySlice(groupItem.item, 2, this.localeData.columnsCount)*)

					if groupItem.originalText != "" && groupItem.originalText != previousGroupName
						previousGroupName := groupItem.originalText
				}

				if groupedItems.Length > 0
					this.LV.Add()


				this.LV.Visible := True
				this.LV.Enabled := True

				this.originLV.Modify(0, "-Select -Focus")
				this.originLV.Visible := False
				this.originLV.Enabled := False
			} catch
				this.Populate()
		}
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