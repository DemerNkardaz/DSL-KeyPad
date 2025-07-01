Class TextHandlers {
	static ToQuote(outerQuotes, innerQuotes) {
		local backupClipboard := ClipboardAll()
		local promptValue := ""
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

		local spaces := "([\x{0009}\x{0020}\x{00A0}\x{2000}-\x{200B}\x{202F}\x{2060}\x{FEFF}\x{205F}\x{3000}]+)"
		local startSpace := ""
		local endSpace := ""

		if RegExMatch(promptValue, "^" spaces, &match)
			startSpace := match[1]
		if RegExMatch(promptValue, spaces "$", &match)
			endSpace := match[1]

		promptValue := RegExReplace(promptValue, "^" spaces "|" spaces "$", "")

		local level := 0
		local result := ""
		local allOpenQuotes := [outerQuotes[1], innerQuotes[1]]
		local allCloseQuotes := [outerQuotes[2], innerQuotes[2]]

		Loop Parse, promptValue {
			local char := A_LoopField
			local isOpenQuote := false
			local isCloseQuote := false

			for openQuote in allOpenQuotes {
				if char = openQuote {
					isOpenQuote := true
					break
				}
			}

			for closeQuote in allCloseQuotes {
				if char = closeQuote {
					isCloseQuote := true
					break
				}
			}

			if isOpenQuote {
				local quoteType := Mod(level, 2) = 1 ? outerQuotes : innerQuotes
				result .= quoteType[1]
				level++
			} else if isCloseQuote {
				level--
				local quoteType := Mod(level, 2) = 1 ? outerQuotes : innerQuotes
				result .= quoteType[2]
			} else
				result .= char
		}

		promptValue := outerQuotes[1] result outerQuotes[2]

		A_Clipboard := startSpace promptValue endSpace
		ClipWait(0.5, 0)
		Send("{Shift Down}{Insert}{Shift Up}")

		Sleep 500
		A_Clipboard := backupClipboard
		return
	}
}