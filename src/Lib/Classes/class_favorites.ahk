Class FavoriteChars {

	static favoriteCharsList := Map()

	static favesPath := App.PATHS.PROFILE "\FavoriteCharacters.txt"

	static __New() {
		if !FileExist(this.favesPath) {
			FileAppend("", this.favesPath, "UTF-8")
		}

		this.UpdateVar()
	}

	static Add(fave, preventFromTabChange := False) {
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

		if !ChrLib.entries.%fave%["groups"].HasValue("Favorites")
			ChrLib.entries.%fave%["groups"].Push("Favorites")

		return Event.Trigger("Favorites", "Changed", fave, "Added", preventFromTabChange)
	}

	static Remove(fave, preventFromTabChange := False) {
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

		if ChrLib.entries.%fave%["groups"].HasValue("Favorites", &i)
			ChrLib.entries.%fave%["groups"].RemoveAt(i)

		return Event.Trigger("Favorites", "Changed", fave, "Removed", preventFromTabChange)
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
		split := StrSplit(fileContent, "`n", "`r")
		output := []
		toClean := False

		for line in split
			if ChrLib.entries.HasOwnProp(line)
				output.Push(line)

		return output
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

			if !ChrLib.entries.%fave%["groups"].HasValue("Favorites")
				ChrLib.entries.%fave%["groups"].Push("Favorites")
		}
	}
}