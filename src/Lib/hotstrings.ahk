HotString(":C?0:gtsd", (D) => Util.SendDate())
HotString(":C?0:gtdd", (D) => Util.SendDate("YYYY–MM–DD"))
HotString(":C?0:gtfd", (D) => Util.SendDate("YYYY–MM–DD hh:mm:ss"))
HotString(":C?0:gtfh", (D) => Util.SendDate("hh:mm:ss"))
HotString(":C?0:gtfl", (D) => Util.SendDate("YYYY_MM_DD-hh_mm_ss"))


Class LaTeXHotstrings {
	static __New() {
		for entryName, value in ChrLib.entries.OwnProps() {
			if value.LaTeX.Length = 0
				continue

			for each in value.LaTeX {
				if StrLen(each) > 0 && StrLen(each) < 10 {
					local char := ChrLib.Get(entryName)
					local callback := ObjBindMethod(this, "Send", char)
					HotString(":C?0:/" each "/", callback)
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