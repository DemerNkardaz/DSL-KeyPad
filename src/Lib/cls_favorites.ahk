favoriteCharsList := Map()

Class FavoriteChars {

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

		if !favoriteCharsList.Has(fave) {
			favoriteCharsList.Set(fave, True)
		}
	}

	static Remove(fave) {
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

		if favoriteCharsList.Has(fave) {
			favoriteCharsList.Delete(fave)
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
		return favoriteCharsList.Has(fave)
	}

	static UpdateVar() {
		global favoriteCharsList
		faveList := FavoriteChars.ReadList()

		for fave in faveList {
			favoriteCharsList.Set(fave, True)
		}
	}
}