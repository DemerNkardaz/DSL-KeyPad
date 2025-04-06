Class Util {

	static IsArray(value) {
		return Type(value) = "Array"
	}

	static IsObject(value) {
		return Type(value) = "Object"
	}

	static IsMap(value) {
		return Type(value) = "Map"
	}

	static IsString(value) {
		return Type(value) = "String"
	}

	static IsNumber(value) {
		return Type(value) = "Number"
	}

	static IsInt(value) {
		return Type(value) = "Integer"
	}

	static IsBool(value) {
		return Type(value) = "Boolean"
	}

	static IsClass(value) {
		return Type(value) = "Class"
	}

	static IsFunc(value) {
		return Type(value) = "Func"
	}

	static IsClipboardTextOnly() {
		return
	}

	static StrUpper(Str, Length := StrLen(Str)) {
		return StrUpper(SubStr(Str, 1, Length)) SubStr(Str, Length + 1)
	}

	static StrLower(Str, Length := StrLen(Str)) {
		return StrLower(SubStr(Str, 1, Length)) SubStr(Str, Length + 1)
	}

	static StrRepeat(str, count) {
		output := ""
		loop count {
			output .= str
		}
		return output
	}

	static StrFormattedReduce(str, maxLength := 32, removeLineBreaks := False) {
		output := StrLen(str) > maxLength ? "[ " SubStr(str, 1, maxLength) " " Chr(0x2026) " ]" : str
		if removeLineBreaks {
			output := StrReplace(output, "`r`n", " ")
			output := StrReplace(output, "`n", " ")
		}
		return output
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

	static ReplaceModifierKeys(Input) {
		Output := Input
		if IsObject(Output) {
			for i, k in Output {
				Output[i] = ReplaceModifierKeys(k)
			}
		} else {
			Output := RegExReplace(Output, "\<\!", LeftAlt)
			Output := RegExReplace(Output, "\>\!", RightAlt)
			Output := RegExReplace(Output, "\<\+", LeftShift)
			Output := RegExReplace(Output, "\>\+", RightShift)
			Output := RegExReplace(Output, "\<\^", LeftControl)
			Output := RegExReplace(Output, "\>\^", RightControl)
			Output := RegExReplace(Output, "c\*", CapsLock)
		}
		return Output
	}

	static OpenCharWeb(InputCode := "", IsReturn := False) {
		CharacterWebResource := Cfg.Get("Character_Web_Resource", , "SymblCC")
		if InputCode = "" {
			BackupClipboard := A_Clipboard
			PromptValue := ""
			A_Clipboard := ""

			Send("^c")
			ClipWait(0.5, 1)
			PromptValue := A_Clipboard
			PromptValue := this.ChrToUnicode(PromptValue)
		} else {
			PromptValue := StrLen(InputCode) >= 4 ? InputCode : this.ChrToUnicode(InputCode)
		}

		resources := Map(
			"Compart", "https://www.compart.com/en/unicode/U+" PromptValue,
			"Codepoints", "https://codepoints.net/U+" PromptValue,
			"UnicodePlus", "https://unicodeplus.com/U+" PromptValue,
			"DecodeUnicode", "https://decodeunicode.org/en/u+" PromptValue,
			"UtilUnicode", "https://util.unicode.org/UnicodeJsps/character.jsp?a=" PromptValue,
			"Wiktionary", "https://en.wiktionary.org/wiki/" Chr("0x" PromptValue),
			"Wikipedia", "https://en.wikipedia.org/wiki/" Chr("0x" PromptValue),
			"SymblCC", "https://symbl.cc/" Language.Get() "/" PromptValue,
		)

		URIComponent := resources.Has(CharacterWebResource) ? resources[CharacterWebResource] : resources["SymblCC"]

		if (PromptValue != "" && !IsReturn) {
			Run(URIComponent)
		} else if (PromptValue != "" && IsReturn) {
			return URIComponent
		}

		if InputCode = "" {
			A_Clipboard := BackupClipboard
		}
	}

	static EscapePathChars(str) {
		str := StrReplace(str, " ", "_")
		str := StrReplace(str, "\", "____")
		str := StrReplace(str, "/", "____")
		dotPos := InStr(str, ".", , -1)
		if (dotPos) {
			ext := SubStr(str, dotPos)
			str := SubStr(str, 1, dotPos - 1)
		}

		str := StrReplace(str, ".", "_")

		return str
	}

	static TrimBasePath(filePath, basePath := App.paths.user "\") {
		if (InStr(filePath, basePath) == 1) {
			return SubStr(filePath, StrLen(basePath) + 1)
		}
		return filePath
	}

	static HasAllCharacters(str, pattern) {
		WordBoundary := "[^a-zA-Zа-яА-ЯёЁ]"

		if RegExMatch(pattern, "\s") {
			WordSplit := StrSplit(pattern, " ")
			for word in WordSplit {
				if StrLen(word) < 3 {
					pattern := "(^|" . WordBoundary . ")" . word . "($|" . WordBoundary . ")"
					if !RegExMatch(str, pattern)
						return False
				} else {
					if !InStr(str, word)
						return False
				}
			}
			return true
		} else {
			for char in StrSplit(pattern) {
				if !InStr(str, char)
					return False
			}
			return true
		}
	}

	static INIToObj(filePath) {
		obj := {}
		content := FileRead(filePath (!InStr(filePath, ".ini") ? ".ini" : ""), "UTF-8")
		lines := StrSplit(content, "`n", "`r`n")

		currentSection := ""

		for line in lines {
			line := Trim(line)
			if (line = "" or SubStr(line, 1, 1) = ";")
				continue

			if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
				currentSection := SubStr(line, 2, -1)
				obj.%currentSection% := {}
			} else if (currentSection != "" && InStr(line, "=")) {
				parts := StrSplit(line, "=", "`t ")
				key := Trim(parts[1])
				value := Trim(parts[2])
				obj.%currentSection%.%key% := value
			}
		}

		return obj
	}

	static INIToMap(filePath) {
		if !InStr(filePath, ".ini")
			filePath .= ".ini"

		content := FileRead(filePath, "UTF-8")
		lines := StrSplit(content, "`n", "`r`n")

		iniMap := Map()
		currentSection := ""

		for line in lines {
			line := Trim(line)
			if (line = "" or SubStr(line, 1, 1) = ";")
				continue

			if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
				currentSection := SubStr(line, 2, -1)
				iniMap.Set(currentSection, Map())
			}
			else if (currentSection != "" && InStr(line, "=")) {
				parts := StrSplit(line, "=", "`t ")
				key := Trim(parts[1])
				value := Trim(parts[2])
				iniMap[currentSection].Set(key, value)
			}
		}

		return iniMap
	}


	static MultiINIToObj(pathsArray) {
		bufferArray := []
		bufferObject := {}

		for path in pathsArray {
			bufferArray.Push(this.INIToObj(path))
		}

		for obj in bufferArray {
			for localeKey, value in obj.OwnProps() {
				if !bufferObject.HasOwnProp(localeKey)
					bufferObject.%localeKey% := {}

				for key, value in obj.%localeKey%.OwnProps() {
					bufferObject.%localeKey%.%key% := value
				}
			}
		}

		return bufferObject
	}

	static ObjToINI(obj, filePath) {

		for localeKey, dict in obj.OwnProps() {
			for key, value in obj.%localeKey%.OwnProps() {
				IniWrite(value, filePath, localeKey, key)
			}
		}

	}

	static ObjPreview(obj, indent := 0) {
		output := ""
		indentStr := Util.StrRepeat("`t", indent)

		for key, value in obj.OwnProps() {
			if IsObject(value) {
				output .= indentStr key ":`n" . this.ObjPreview(value, indent + 1)
			} else {
				output .= indentStr key ": " value "`n"
			}
		}

		return output
	}
}