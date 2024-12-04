Class Util {
	static StrFormattedReduce(str, maxLength := 32) {
		return StrLen(str) > maxLength ? "[ " SubStr(str, 1, maxLength) " " Chr(0x2026) " ]" : str
	}

	static StrVarsInject(StringVar, SetVars*) {
		Result := StringVar
		for index, value in SetVars {
			Result := StrReplace(Result, "{" (index - 1) "}", value)
		}
		return Result
	}

	static StrCutBrackets(Str) {
		output := ""
		blacklist := ["{", "}"]

		for symbol in StrSplit(Str, "") {
			if !blacklist.Contains(symbol) {
				output .= symbol
			}
		}

		return output
	}

	static UniTrim(Str) {
		return SubStr(Str, 4, StrLen(Str) - 4)
	}

	static ExtractHex(Str) {
		return RegExReplace(Str, "[^0-9A-Fa-f]", "")
	}

	static UnicodeToChar(unicode) {
		if IsObject(unicode) {
			hexStr := ""

			for value in unicode {
				intermediate := this.ExtractHex(value)
				if StrLen(intermediate) > 0 {
					num := Format("0x{1}", intermediate)
					hexStr .= Chr(num)
				}
			}

			if StrLen(hexStr) > 0 {
				return hexStr
			}
		} else {
			hexStr := this.ExtractHex(unicode)
			if StrLen(hexStr) > 0 {
				num := Format("0x{1}", hexStr)
				return Chr(num)
			}
		}
		return
	}

	static ChrToUnicode(Symbol, StartFormat := "") {
		Code := Ord(Symbol)

		if (Code >= 0xD800 && Code <= 0xDBFF) {
			nextSymbol := SubStr(Symbol, 2, 1)
			NextCode := Ord(nextSymbol)

			if (NextCode >= 0xDC00 && NextCode <= 0xDFFF) {
				HighSurrogate := Code - 0xD800
				LowSurrogate := NextCode - 0xDC00
				FullCodePoint := (HighSurrogate << 10) + LowSurrogate + 0x10000
				return StartFormat Format("{:06X}", FullCodePoint)
			}
		}

		return StartFormat Format("{:04X}", Code)
	}

	static ChrToDecimal(Symbol) {
		HexCode := this.ChrToUnicode(Symbol)
		return Format("{:d}", "0x" HexCode)
	}

	static ChrToHexaDecimal(StringInput, StartFromat := "0x") {
		if StringInput != "" {
			Output := ""
			i := 1

			while (i <= StrLen(StringInput)) {
				Symbol := SubStr(StringInput, i, 1)
				Code := Ord(Symbol)

				if (Code >= 0xD800 && Code <= 0xDBFF) {
					NextSymbol := SubStr(StringInput, i + 1, 1)
					Symbol .= NextSymbol
					i += 1
				}

				Output .= this.ChrToUnicode(Symbol, StartFromat) "-"
				i += 1
			}

			return RegExReplace(Output, "-$", "")
		} else {
			return StringInput
		}
	}

	static HexaDecimalToChr(StringInput) {
		if StringInput != "" {
			Output := ""
			for symbol in StrSplit(StringInput, "-") {
				Output .= Chr(symbol)
			}
			return Output
		} else {
			return StringInput
		}
	}


	static FormatHotKey(HKey, Modifier := "") {
		MakeString := ""

		SpecialCommandsMap := Map(
			CtrlA, LeftControl " [a][ф]", CtrlB, LeftControl " [b][и]", CtrlC, LeftControl " [c][с]", CtrlD, LeftControl " [d][в]", CtrlE, LeftControl " [e][у]", CtrlF, LeftControl " [f][а]", CtrlG, LeftControl " [g][п]",
			CtrlH, LeftControl " [h][р]", CtrlI, LeftControl " [i][ш]", CtrlJ, LeftControl " [j][о]", CtrlK, LeftControl " [k][л]", CtrlL, LeftControl " [l][д]", CtrlM, LeftControl " [m][ь]", CtrlN, LeftControl " [n][т]",
			CtrlO, LeftControl " [o][щ]", CtrlP, LeftControl " [p][з]", CtrlQ, LeftControl " [q][й]", CtrlR, LeftControl " [r][к]", CtrlS, LeftControl " [s][ы]", CtrlT, LeftControl " [t][е]", CtrlU, LeftControl " [u][г]",
			CtrlV, LeftControl " [v][м]", CtrlW, LeftControl " [w][ц]", CtrlX, LeftControl " [x][ч]", CtrlY, LeftControl " [y][н]", CtrlZ, LeftControl " [z][я]", SpaceKey, "[Space]", ExclamationMark, "[!]", CommercialAt, "[@]", QuotationDouble, "[" QuotationDouble "]", Tabulation, "[Tab]"
		)

		for key, value in SpecialCommandsMap {
			if (HKey = key)
				return value
		}

		if IsObject(HKey) {
			for keys in HKey {
				MakeString .= this.FormatHotKey(keys)
			}
		} else {
			if (RegExMatch(HKey, "^\S+\+")) {
				StringSplitter := StrSplit(HKey, "+")
				MakeString := StringSplitter[1] . " " . "[" . StringSplitter[2] . "]"
			} else {
				MakeString := "[" . HKey . "]"
			}
		}

		MakeString := Modifier != "" ? (Modifier . " " . MakeString) : MakeString

		return MakeString
	}
}