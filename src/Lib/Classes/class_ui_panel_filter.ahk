Class UIMainPanelFilter {
	__New(&panelWindow, &filterField, &LV, &dataList, &localeData) {
		this.panelWindow := panelWindow
		this.filterField := filterField
		this.LV := LV
		this.dataList := dataList
		this.localeData := localeData
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

	Filter(&filterText) {
		filterText := filterText
		this.LV.Delete()

		if filterText = "" {
			this.Populate()
		} else {
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

					if item[5] != ""
						reserveTexts.MergeWith([item[5]], ChrLib.GetValue(item[5], "tags"))

					local isFavorite := InStr(itemText, Chr(0x2605))
					local isMatch := keyOrRecipeMark ? (item[2] ~= filterText) : (isFavorite && filterText ~= "^(изб|fav|\*)") || filterText != "*" && (itemText ~= filterText || this.MatchInArray(&reserveTexts, &filterText))

					if isMatch {
						if !groupStarted
							groupStarted := True
						this.LV.Add(, item[this.localeData.localeIndex], ArraySlice(item, 2, this.localeData.columnsCount)*)
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