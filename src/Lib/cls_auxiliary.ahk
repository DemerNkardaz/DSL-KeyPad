Class Auxiliary {

	static inputMode := "Unicode"

	static ToggleInputMode() {
		switch this.inputMode {
			case "Unicode":
				this.inputMode := "HTML"

			case "HTML":
				this.inputMode := "LaTeX"

			case "LaTeX":
				this.inputMode := "Unicode"

			default:
				this.inputMode := "Unicode"
		}

		MsgBox(Locale.ReReadInjectad("message_input_mode_changed", [Locale.Read("message_input_mode_changed_" StrLower(this.inputMode))]), DSLPadTitle, 0x40)

		return
	}
	static ToRomanNumeral(IntValue, CapitalLetters := True) {
		IntValue := Integer(IntValue)
		if (IntValue < 1 || IntValue > 2000000) {
			return
		}

		RomanNumerals := []

		for key, value in RoNum {
			entryName := RegExReplace(key, "^\S+-")
			if CapitalLetters == True && !RegExMatch(entryName, "^s") || CapitalLetters == False && RegExMatch(entryName, "^s")
				RomanNumerals.Push(value)
		}

		Values := [100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
		RomanStr := ""

		for i, v in Values {
			while (IntValue >= v) {
				RomanStr .= RomanNumerals[i]
				IntValue -= v
			}
		}
		return RomanStr
	}
}