Class UIPanelFilter {
	__New(&panelWindow, &filterField, &LV, &dataList) {
		this.panelWindow := panelWindow
		this.filterField := filterField
		this.LV := LV
		this.dataList := dataList
	}

	Populate() {
		this.LV.Delete()
		for item in this.dataList
			this.LV.Add(, item*)
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
		filterText := filterText
		this.LV.Delete()

		if filterText = "" {
			this.Populate()
		} else {
			local groupStarted := False
			local greviousGroupName := ""

			try {
				for item in this.dataList {
					if item[1] = ""
						continue

					local itemText := StrReplace(item[1], Chr(0x00A0), " ")
					local reserveArray := [StrReplace(item[1], Chr(0x00A0), " "), item[5]]
					local isFavorite := InStr(itemText, Chr(0x2605))
					local isMatch := itemText ~= filterText || reserveArray.HasRegEx(filterText) || (isFavorite && filterText ~= "^(изб|fav|\*)")

					if isMatch {
						if !groupStarted
							groupStarted := true

						this.LV.Add(, item*)
					} else if groupStarted
						groupStarted := False


					if itemText != "" and itemText != greviousGroupName
						greviousGroupName := itemText
				}

				if groupStarted
					this.LV.Add(, "", "", "", "")


				if greviousGroupName != ""
					this.LV.Add(, "", "", "", "")

			} catch
				this.Populate()
		}
	}
}