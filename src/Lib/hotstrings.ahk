HotString(":C?0:gtsd", (D) => Util.SendDate())
HotString(":C?0:gtdd", (D) => Util.SendDate("YYYY–MM–DD"))
HotString(":C?0:gtfd", (D) => Util.SendDate("YYYY–MM–DD hh:mm:ss"))
HotString(":C?0:gtfh", (D) => Util.SendDate("hh:mm:ss"))
HotString(":C?0:gtfl", (D) => Util.SendDate("YYYY_MM_DD-hh_mm_ss"))


Class LaTeXHotstrings {
	static collection := Map()
	static __New() {
		local stance := Cfg.Get("LaTeX_Hotstrings", , True, "bool")

		for i, char in characters.supplementaryData["LaTeX Commands"] {
			if Mod(i, 2) = 1 {
				local code := characters.supplementaryData["LaTeX Commands"][i + 1]
				if code is Array {
					for each in code
						this.collection.Set(each, char)
				} else
					this.collection.Set(code, char)
				code := unset
			}
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
				local callback := ObjBindMethod(LaTeXHotstrings, "Send", char)
				HotString(":*C?:$>" code "$", callback, stance)
			}
		}

		return
	}

	static Send(char, *) {
		SendText(char)
		return
	}
}