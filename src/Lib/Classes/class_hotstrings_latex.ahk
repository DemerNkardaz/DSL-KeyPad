Class CommonHotstrings {
	static collection := Map(
		"gtgz", () => Util.Date.generalized,
		"gttd", () => Util.Date.today,
		"gtft", () => Util.Date.formatted,
		"gtch", () => Util.Date.time,
		"gtfl", () => Util.Date.filename,
	)

	static __New() {
		for hString, action in this.collection {
			local callback := ObjBindMethod(CommonHotstrings, "Send", action)
			HotString(":C?0:" hString, callback)
		}

		return
	}

	static Send(text, *) {
		return SendText(text is Func ? text() : text)
	}
}

Class LaTeXHotstrings {
	static collection := Map()
	static __New() {
		local stance := Cfg.Get("LaTeX_Hotstrings", , True, "bool")

		for char, code in characters.supplementaryData["LaTeX Commands"] {
			if code is Array {
				for each in code
					if each is Array {
						for sub in each
							this.collection.Set(sub, char)
					} else
						this.collection.Set(each, char)
			} else
				this.collection.Set(code, char)
		}

		for entryName, entry in ChrLib.entries.OwnProps() {
			if entry["LaTeX"].Length = 0 || entry["symbol"]["category"] ~= "Diacritic"
				continue
			for each in entry["LaTeX"]
				if !this.collection.Has(each)
					this.collection.Set(each, ChrLib.Get(entryName))
		}

		return LaTeXHotstrings(stance)
	}

	__New(stance := True) {
		for code, char in LaTeXHotstrings.collection {
			if StrLen(code) > 0 && StrLen(char) < 38 {
				local callback := ObjBindMethod(CommonHotstrings, "Send", char)
				HotString(":*C?:$>" code "$", callback, stance)
			}
		}

		return
	}
}