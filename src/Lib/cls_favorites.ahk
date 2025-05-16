Class FavoriteChars {

	static favoriteCharsList := Map()

	static favesPath := App.paths.profile "\FavoriteCharacters.txt"

	static __New() {
		if !FileExist(this.favesPath) {
			FileAppend("", this.favesPath, "UTF-8")
		}

		this.UpdateVar()
	}

	static Add(fave) {
		fave := RegExReplace(fave, "^.*\s", "")

		newContent := ""
		alreadyExists := false

		for line in this.ReadList() {
			if line == fave {
				alreadyExists := true
			}
			newContent .= line "`n"
		}

		if !alreadyExists {
			newContent .= fave "`n"
		}

		FileDelete(this.favesPath)
		FileAppend(RTrim(newContent, "`n"), this.favesPath, "UTF-8")

		Sleep 100

		if !this.favoriteCharsList.Has(fave)
			this.favoriteCharsList.Set(fave, True)

		if !ChrLib.entryGroups["Favorites"].HasValue(fave)
			ChrLib.entryGroups["Favorites"].Push(fave)

		if !ChrLib.entries.%fave%.groups.HasValue("Favorites")
			ChrLib.entries.%fave%.groups.Push("Favorites")

		this.UpdatePanelLVItem(fave, "Add")

	}

	static Remove(fave, preventFavoriteTabRemove := False) {
		fave := RegExReplace(fave, "^.*\s", "")

		newContent := ""
		for line in this.ReadList() {
			if line != fave {
				newContent .= line "`n"
			}
		}

		FileDelete(this.favesPath)
		FileAppend(RTrim(newContent, "`n"), this.favesPath, "UTF-8")

		Sleep 100

		if this.favoriteCharsList.Has(fave)
			this.favoriteCharsList.Delete(fave)


		if ChrLib.entryGroups["Favorites"].HasValue(fave, &i)
			ChrLib.entryGroups["Favorites"].RemoveAt(i)

		if ChrLib.entries.%fave%.groups.HasValue("Favorites", &i)
			ChrLib.entries.%fave%.groups.RemoveAt(i)

		this.UpdatePanelLVItem(fave, "Remove", preventFavoriteTabRemove)
	}

	static UpdatePanelLVItem(entryName, action := "Add", preventFavoriteTabRemove := False) {
		LVContent := Panel.LV_Content
		star := " " Chr(0x2605)
		prefixes := ["Smelting", "FastKeys", "SecondKeys", "TertiaryKeys", "Glago", "TELEX/VNI", "AllSymbols", "Favorites"]
		isPanelOpened := IsGuiOpen(Panel.panelTitle)

		isUpdated := False

		for key, value in LVContent.OwnProps() {
			for i, row in value {
				if row[5] = entryName {
					if action = "Add" {
						if !InStr(row[1], star) {
							row[1] .= star
							isUpdated := True
						}
					} else {
						newTitle := StrReplace(row[1], star)
						if newTitle != row[1] {
							row[1] := newTitle
							isUpdated := True
						}
					}
				}
			}
		}

		if isUpdated && isPanelOpened {
			panelGUI := Panel.PanelGUI

			for i, prefix in prefixes {
				items_LV := panelGUI[prefix "LV"]
				favorites_LV := panelGUI["FavoritesLV"]
				rowCount := items_LV.GetCount()
				found := False

				Loop rowCount {
					rowIndex := A_Index
					entryCol := items_LV.GetText(rowIndex, 5)

					if entryCol = entryName {
						found := True
						titleCol := items_LV.GetText(rowIndex, 1)

						if action = "Add" {
							if !InStr(titleCol, star)
								items_LV.Modify(rowIndex, , titleCol star)
						} else {
							items_LV.Modify(rowIndex, , StrReplace(titleCol, star))
						}
					}
				}

				if action = "Add" && prefix = "Favorites" && !found {
					languageCode := Language.Get()
					entry := ChrLib.GetEntry(entryName)

					characterTitle := ""

					if Locale.Read(entryName, , True, &titleText) {
						characterTitle := titleText
					} else if entry.titles.Count > 0 && entry.titles.Has(languageCode) {
						characterTitle := entry.titles.Get(languageCode)
					} else {
						characterTitle := Locale.Read(entryName)
					}

					reserveCombinationKey := ""

					for cgroup, ckey in Panel.combinationKeyToGroupPairs {
						reserveCombinationKey := entry.groups.HasValue(cgroup) ? ckey : reserveCombinationKey
					}

					characterTitle .= star
					characterSymbol := entry.symbol.set
					recipe := entry.recipeAlt.Length > 0 ? entry.recipeAlt.ToString() : entry.recipe.Length > 0 ? entry.recipe.ToString() : ""

					bindings := entry.options.fastKey != "" ? entry.options.fastKey : entry.options.altLayoutKey != "" ? entry.options.altLayoutKey : entry.options.altSpecialKey != "" ? entry.options.altSpecialKey : ""
					bindings := bindings != "" ? (reserveCombinationKey != "" ? reserveCombinationKey " + " : "") bindings : ""


					favorites_LV.Add(,
						characterTitle,
						recipe,
						bindings,
						characterSymbol,
						entryName,
						""
					)
				} else if action = "Remove" && !preventFavoriteTabRemove && found {
					farotitesRowCount := favorites_LV.GetCount()
					Loop farotitesRowCount {
						if favorites_LV.GetText(A_Index, 5) = entryName {
							favorites_LV.Delete(A_Index)
							break
						}
					}
				}
			}
		}
	}


	static Check(fave) {
		fave := RegExReplace(fave, "^.*\s", "")

		for line in this.ReadList() {
			if line == fave {
				return True
			}
		}

		return False
	}

	static ReadList() {
		fileContent := FileRead(this.favesPath, "UTF-8")
		return StrSplit(fileContent, "`n", "`r")
	}

	static CheckVar(fave) {
		fave := RegExReplace(fave, "^.*\s", "")
		return this.favoriteCharsList.Has(fave)
	}

	static UpdateVar() {
		faveList := FavoriteChars.ReadList()

		for fave in faveList {
			this.favoriteCharsList.Set(fave, True)

			if !ChrLib.entryGroups["Favorites"].HasValue(fave)
				ChrLib.entryGroups["Favorites"].Push(fave)

			if !ChrLib.entries.%fave%.groups.HasValue("Favorites")
				ChrLib.entries.%fave%.groups.Push("Favorites")
		}
	}
}