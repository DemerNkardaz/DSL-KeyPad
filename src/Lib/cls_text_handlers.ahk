Class TextHandlers {

	static ToQuote(outerQuotes, innerQuotes) {
		static regEx := "[a-zA-Zа-яА-ЯёЁ0-9.,:;!?()\`"'-+=/\\]"

		backupClipboard := A_Clipboard
		promptValue := ""
		A_Clipboard := ""

		Send("{Shift Down}{Delete}{Shift Up}")
		ClipWait(0.5, 0)
		promptValue := A_Clipboard

		if !RegExMatch(promptValue, regEx) {
			A_Clipboard := backupClipboard
			SendText(outerQuotes[1] outerQuotes[2])
			return
		}

		A_Clipboard := ""

		if RegExMatch(promptValue, regEx) {
			tempSpace := ""
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
				if (promptValue ~= space "$") {
					tempSpace := space
					promptValue := RegExReplace(promptValue, space "$", "")
					break
				}
			}

			promptValue := RegExReplace(promptValue, RegExEscape(outerQuotes[1]), innerQuotes[1])
			promptValue := RegExReplace(promptValue, RegExEscape(outerQuotes[2]), innerQuotes[2])

			promptValue := outerQuotes[1] promptValue outerQuotes[2]

			A_Clipboard := promptValue tempSpace
			ClipWait(0.5, 0)
			Send("{Shift Down}{Insert}{Shift Up}")
		}

		Sleep 500
		A_Clipboard := backupClipboard
		return
	}

}