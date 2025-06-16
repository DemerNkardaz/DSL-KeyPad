HotString(":C?0:gtsd", (D) => Util.SendDate())
HotString(":C?0:gtdd", (D) => Util.SendDate("YYYY–MM–DD"))
HotString(":C?0:gtfd", (D) => Util.SendDate("YYYY–MM–DD hh:mm:ss"))
HotString(":C?0:gtfh", (D) => Util.SendDate("hh:mm:ss"))
HotString(":C?0:gtfl", (D) => Util.SendDate("YYYY_MM_DD-hh_mm_ss"))


Class LaTeXHotstrings {
	static __New() {
		stance := Cfg.Get("LaTeX_Hotstrings", , True, "bool")
		return LaTeXHotstrings(stance)
	}

	__New(stance := True) {
		for entryName, value in ChrLib.entries.OwnProps() {
			if value.LaTeX.Length = 0
				continue

			for each in value.LaTeX {
				if StrLen(each) > 0 && StrLen(each) < 10 {
					local char := ChrLib.Get(entryName)
					local callback := ObjBindMethod(LaTeXHotstrings, "Send", char)
					HotString(":*C?:$" each "$", callback, stance)
				}
			}
		}
		return
	}

	static Send(char, *) {
		SendText(char)
		return
	}
}