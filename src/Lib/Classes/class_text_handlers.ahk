Class TextHandlers {
	static ToQuote(outerQuotes, innerQuotes) {
		Clip.CopySelected(&text, , "Backup")

		if text = "" {
			SendText(outerQuotes[1] outerQuotes[2])
			Clip.Release(1)
			return
		}

		local spaces := "([\x{0009}\x{0020}\x{00A0}\x{2000}-\x{200B}\x{202F}\x{2060}\x{FEFF}\x{205F}\x{3000}]+)"
		local startSpace := ""
		local endSpace := ""

		if RegExMatch(text, "^" spaces, &match)
			startSpace := match[1]
		if RegExMatch(text, spaces "$", &match)
			endSpace := match[1]

		text := RegExReplace(text, "^" spaces "|" spaces "$", "")

		local level := 0
		local result := ""
		local allOpenQuotes := [outerQuotes[1], innerQuotes[1]]
		local allCloseQuotes := [outerQuotes[2], innerQuotes[2]]

		Loop Parse, text {
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

		text := outerQuotes[1] result outerQuotes[2]
		text := startSpace text endSpace

		Clip.Send(&text, , , "Release")
		return
	}
}