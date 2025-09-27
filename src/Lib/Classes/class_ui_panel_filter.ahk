Class UIMainPanelFilter {
	__New(&panelWindow, &filterField, &LV, &dataList, &localeData, prefix) {
		this.panelWindow := panelWindow
		this.filterField := filterField
		this.LV := LV
		this.dataList := dataList
		this.localeData := localeData

		this.prefix := prefix
		this.isCurrentTabFavorites := prefix = "favorites"
	}

	Populate() {
		this.LV.Delete()
		for item in this.dataList
			this.LV.Add(, item[this.localeData.localeIndex], ArraySlice(item, 2, this.localeData.columnsCount)*)
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

	FindMatchingTag(&textsArray, &filterText) {
		for each in textsArray {
			local escaped := RegExEscape(each)
			if escaped = filterText
				|| escaped ~= filterText
				|| filterText ~= escaped
				return each
		}
		return ""
	}

	Filter(&filterText) {
		filterText := filterText
		this.LV.Delete()

		if filterText = "" {
			this.Populate()
		} else {
			local languageCode := Language.Get()
			local groupStarted := False
			local previousGroupName := ""
			local keyOrRecipeMark := False

			if filterText ~= "i)^(R::|Р::)" {
				keyOrRecipeMark := True
				filterText := RegExReplace(filterText, "i)^(R::|Р::)")
			}

			try {
				for item in this.dataList {
					if item[this.localeData.localeIndex] = ""
						continue
					local itemText := StrReplace(item[this.localeData.localeIndex], Chr(0x00A0), " ")

					local reserveTexts := []
					for key, index in this.localeData.localeIndexMap
						if index != this.localeData.localeIndex
							reserveTexts.Push(StrReplace(item[index], Chr(0x00A0), " "))

					local tags := []
					local tagsMap := Map()
					local isTagsMirrored := False
					local entryName := item[5]
					if entryName != "" {
						reserveTexts.MergeWith([entryName], ChrLib.GetValue(entryName, "tags"))
						tags := ChrLib.GetValue(entryName, "tags")
						tagsMap := ChrLib.GetValue(entryName, "tagsMap")
						isTagsMirrored := ChrLib.GetValue(entryName, "options.isTagsMirrored")
					}

					local isFavorite := InStr(itemText, Chr(0x2605)) || ChrLib.entryGroups["Favorites"].HasValue(entryName)
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
							matchedTag := this.FindMatchingTag(&tags, &filterText)
							if matchedTag != "" {
								isMatch := True
								if tagsMap.Has(languageCode) && tagsMap[languageCode].HasValue(matchedTag)
									displayText := Util.StrUpper(matchedTag, 1) (isFavorite ? Chr(0x2002) Chr(0x2605) : "")
								else if isTagsMirrored {
									for lang, tags in tagsMap
										for i, tag in tags
											if tag = matchedTag && tagsMap[languageCode].Has(i) {
												displayText := Util.StrUpper(tagsMap[languageCode][i], 1) (isFavorite ? Chr(0x2002) Chr(0x2605) : "")
												break 2
											}
								}
							} else
								isMatch := this.MatchInArray(&reserveTexts, &filterText)
						}
					}

					if isMatch {
						if !groupStarted
							groupStarted := True
						this.LV.Add(, displayText, ArraySlice(item, 2, this.localeData.columnsCount)*)
					} else if groupStarted
						groupStarted := False

					if itemText != "" && itemText != previousGroupName
						previousGroupName := itemText
				}

				if groupStarted
					this.LV.Add()

				if previousGroupName != ""
					this.LV.Add()

			} catch
				this.Populate()
		}
	}
}