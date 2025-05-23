Class TextHandlers {

	static ToQuote(outerQuotes, innerQuotes) {

		backupClipboard := ClipboardAll()
		promptValue := ""
		A_Clipboard := ""

		Send("{Shift Down}{Delete}{Shift Up}")
		ClipWait(0.5, 0)
		promptValue := A_Clipboard

		if promptValue = "" {
			A_Clipboard := backupClipboard
			SendText(outerQuotes[1] outerQuotes[2])
			return
		}

		A_Clipboard := ""

		startSpace := ""
		endSpace := ""
		static checkFor := [
			SpaceKey,
			ChrLib.Get("emsp"),
			ChrLib.Get("ensp"),
			ChrLib.Get("emsp13"),
			ChrLib.Get("emsp14"),
			ChrLib.Get("thinspace"),
			ChrLib.Get("emsp16"),
			ChrLib.Get("narrow_no_break_space"),
			ChrLib.Get("hairspace"),
			ChrLib.Get("punctuation_space"),
			ChrLib.Get("figure_space"),
			ChrLib.Get("tabulation"),
			ChrLib.Get("no_break_space"),
		]

		for space in checkFor {
			if (promptValue ~= "^" space) {
				startSpace := (promptValue ~= "^" space) ? space : ""
				break
			}
		}

		for space in checkFor {
			if (promptValue ~= space "$") {
				endSpace := (promptValue ~= "^" space) ? space : ""
				break
			}
		}

		promptValue := RegExReplace(promptValue, startSpace "$")
		promptValue := RegExReplace(promptValue, "^" endSpace)

		promptValue := RegExReplace(promptValue, RegExEscape(outerQuotes[1]), innerQuotes[1])
		promptValue := RegExReplace(promptValue, RegExEscape(outerQuotes[2]), innerQuotes[2])

		promptValue := outerQuotes[1] promptValue outerQuotes[2]

		A_Clipboard := startSpace promptValue endSpace
		ClipWait(0.5, 0)
		Send("{Shift Down}{Insert}{Shift Up}")

		Sleep 500
		A_Clipboard := backupClipboard
		return
	}

}