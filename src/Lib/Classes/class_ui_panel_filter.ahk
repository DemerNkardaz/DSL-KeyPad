Class UIPanelFilter {
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
			if each = filterText
				|| each ~= filterText
				|| filterText ~= each
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
			local greviousGroupName := ""
			local caseSensitiveMark := ""

			try {
				for item in this.dataList {
					if item[this.localeData.localeIndex] = ""
						continue

					local itemText := StrReplace(item[this.localeData.localeIndex], Chr(0x00A0), " ")

					local reserveTexts := [item[5]]
					for key, index in this.localeData.localeIndexMap
						if index != this.localeData.localeIndex
							reserveTexts.Push(StrReplace(item[index], Chr(0x00A0), " "))

					local isFavorite := InStr(itemText, Chr(0x2605))
					local isMatch := itemText ~= filterText || this.MatchInArray(&reserveTexts, &filterText) || (isFavorite && filterText ~= "^(изб|fav|\*)")

					if isMatch {
						if !groupStarted
							groupStarted := True
						this.LV.Add(, item[this.localeData.localeIndex], ArraySlice(item, 2, this.localeData.columnsCount)*)
					} else if groupStarted
						groupStarted := False

					if itemText != "" && itemText != greviousGroupName
						greviousGroupName := itemText
				}

				if groupStarted
					this.LV.Add()


				if greviousGroupName != ""
					this.LV.Add()

			} catch
				this.Populate()
		}
	}
}