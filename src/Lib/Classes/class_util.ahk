Class Util {
	static ClearDumps() {
		Loop Files, App.paths.dumps "\*.*", "FR"
			if (A_LoopFileName ~= "i)dump_.*\.json$")
				FileDelete(A_LoopFileFullPath)
		return
	}

	static IsBool(value) {
		return Type(value) = "Integer" && value >= 0 && value <= 1
	}
	static GetTimeStr() {
		return FormatTime(A_Now, "yyyy-MM-dd_HH-mm-ss")
	}

	static GetDate(dateStyle := "YYYYMMDDhhmmss") {
		local currentTime := A_Now
		static timeFormat := Map(
			"YYYY", SubStr(currentTime, 1, 4),
			"MM", SubStr(currentTime, 5, 2),
			"DD", SubStr(currentTime, 7, 2),
			"hh", SubStr(currentTime, 9, 2),
			"mm", SubStr(currentTime, 11, 2),
			"ss", SubStr(currentTime, 13, 2)
		)
		for Key, Value in timeFormat {
			dateStyle := StrReplace(dateStyle, Key, Value, True)
		}
		currentTime := dateStyle
		return currentTime
	}

	static SendDate(dateStyle := "YYYYMMDDhhmmss") {
		SendText(this.GetDate(dateStyle))
		return
	}

	static StrTrim(Str, chrs := "\s+") {
		return RegExReplace(Str, chrs)
	}

	static StrUpper(Str, Length := StrLen(Str)) {
		return StrUpper(SubStr(Str, 1, Length)) SubStr(Str, Length + 1)
	}

	static StrLower(Str, Length := StrLen(Str)) {
		return StrLower(SubStr(Str, 1, Length)) SubStr(Str, Length + 1)
	}

	static StrRepeat(str, count) {
		local output := ""
		loop count {
			output .= str
		}
		return output
	}

	static ArrRepeatEmpty(count) {
		local output := []
		loop count
			output.Push("")
		return output
	}

	static InStr(str, search, start := 1, end := StrLen(str)) {
		if search is Array {
			for value in search {
				if InStr(str, value, start, end) {
					return True
				}
			}
			return False
		} else
			return InStr(str, search, start, end)
		return
	}

	static StrFormattedReduce(str, maxLength := 32, removeLineBreaks := False) {
		local totalLen := this.StrDigitFormat(StrLen(str))
		local pages := this.StrPagesCalc(str)
		local output := StrLen(str) > maxLength ? "[ " SubStr(str, 1, maxLength) " " Chr(0x2026) " ] ⟨ " this.StrVarsInject(Locale.Read("tooltip_compose_overflow_properties"), totalLen, pages) " ⟩" : str
		if removeLineBreaks {
			output := StrReplace(output, "`r`n", " ")
			output := StrReplace(output, "`n", " ")
		}

		return output
	}

	static StrCutToComma(str, maxLength := 32, end := " [ " Chr(0x2026) " ] ") {
		local len := StrLen(str)

		if (len <= maxLength)
			return str

		local cutPos := maxLength
		local leftComma := 0
		local rightComma := 0

		Loop Parse, str {
			if (A_LoopField = ",") {
				if (A_Index <= cutPos) {
					leftComma := A_Index
				} else if (rightComma = 0) {
					rightComma := A_Index
					break
				}
			}
		}

		local finalCutPos := cutPos

		if (leftComma > 0 && rightComma > 0) {
			local leftDistance := cutPos - leftComma
			local rightDistance := rightComma - cutPos

			if (leftDistance <= rightDistance) {
				finalCutPos := leftComma
			} else {
				finalCutPos := rightComma
			}
		} else if (leftComma > 0) {
			finalCutPos := leftComma
		} else if (rightComma > 0) {
			finalCutPos := rightComma
		}

		local output := SubStr(str, 1, finalCutPos)
		local outputLen := StrLen(output)
		return output (outputLen < len ? end : "")
	}

	static StrDigitFormat(str) {
		local output := ""
		local len := StrLen(str)
		if len >= 4 {
			local pos := 0
			Loop len {
				local currentChar := SubStr(str, len - A_Index + 1, 1)
				output := currentChar output
				pos++
				if (pos = 3 && A_Index < len) {
					output := " " output
					pos := 0
				}
			}
		} else {
			output := str
		}
		return output
	}

	static StrPagesCalc(str, chrPerPage := 3000) {
		local len := StrLen(str)
		local pages := len / chrPerPage

		pages := Round(pages, 1)

		if (pages = Floor(pages))
			pages := Integer(pages)
		return pages
	}

	static StrVarsInject(stringVar, setVars*) {
		if setVars.Length = 1 && setVars[1] is Array {
			setVars := setVars[1]
		}

		local result := stringVar
		for index, value in setVars {
			; result := StrReplace(result, "{" (index - 1) "}", value)
			result := RegExReplace(result, "\{\}", value, , 1)
		}
		return result
	}

	static StrCutBrackets(Str) {
		local output := ""
		static blacklist := ["{", "}"]

		for symbol in StrSplit(Str, "") {
			if !blacklist.Contains(symbol) {
				output .= symbol
			}
		}

		return output
	}

	static CheckEntity(input, &entity := "") {
		for char, htmlCode in characters.supplementaryData["HTML Named Entities"] {
			if (char == input) {
				entity := htmlCode
				return entity
			}
		}
		return False
	}

	static StrToUnicode(inputString, mode := "") {
		local output := ""
		local len := StrLen(inputString)

		local i := 1
		while (i <= len) {
			local symbol := SubStr(inputString, i, 1)
			local code := Ord(symbol)
			local surrogated := False
			if (code >= 0xD800 && code <= 0xDBFF) {
				local nextSymbol := SubStr(inputString, i + 1, 1)
				symbol .= nextSymbol
				surrogated := True
				i += 1
			}

			if mode = "Hex" {
				output .= "0x" this.ChrToUnicode(symbol)
			} else if mode == "CSS" {
				output .= Surrogated ? "\u{" this.ChrToUnicode(symbol) "}" : "\u" this.ChrToUnicode(symbol)
			} else {
				output .= this.ChrToUnicode(symbol)
			}

			output .= (i < len ? " " : "")

			i += 1
		}
		return output
	}

	static StrSelToUnicode(mode := "") {
		Clip.CopySelected(&text, , "Backup")

		if text = "" {
			Clip.Release(1)
			return
		}

		text := this.StrToUnicode(text, mode)

		Clip.Send(&text, , , "Release")
		return
	}


	static StrToHTML(inputString, ignoreDefaultSymbols := False, mode := "", reverse := False) {
		static defaultSymbols := "[a-zA-Zа-яА-ЯёЁ0-9.,\s:;!?()\`"'-+=/\\]"
		local output := ""

		local i := 1
		while (i <= StrLen(inputString)) {
			local symbol := SubStr(inputString, i, 1)
			local code := Ord(symbol)

			if (code >= 0xD800 && code <= 0xDBFF) {
				local nextSymbol := SubStr(inputString, i + 1, 1)
				symbol .= nextSymbol
				i += 1
			}

			if (ignoreDefaultSymbols && RegExMatch(symbol, defaultSymbols)) {
				output .= symbol
			} else {
				if InStr(mode, "Entities") {
					local found := false
					for char, htmlCode in characters.supplementaryData["HTML Named Entities"] {
						if (char == symbol) {
							output .= htmlCode
							found := true
							break
						}
					}

					if (!found) {
						output .= "&#" (InStr(mode, "Hex") ? "x" this.ChrToHexaDecimal(symbol, "") : this.ChrToDecimal(symbol)) ";"
					}
				} else {
					output .= "&#" (InStr(mode, "Hex") ? "x" this.ChrToHexaDecimal(symbol, "") : this.ChrToDecimal(symbol)) ";"
				}
			}

			i += 1
		}
		return output
	}

	static StrSelToConvert(mode := "", ignoreDefaultSymbols := False, reverse := False) {
		Clip.CopySelected(&text, , "Backup")

		if text = "" {
			Clip.Release(1)
			return
		}

		text := this.StrToHTML(text, ignoreDefaultSymbols, mode, reverse)

		Clip.Send(&text, , , "Release")
		return
	}

	static URLEncoder(action := "encode") {
		Clip.CopySelected(&text, , "Backup")

		if text = "" {
			Clip.Release(1)
			return
		}

		text := action = "encode" ? this.UrlEscape(&text) : this.UrlUnescape(&text)

		Clip.Send(&text, , , "Release")
		return
	}

	static UrlEscape(&Url, Flags := 0x000C3000) {
		; * Code of Escape/Unescape taken from https://www.autohotkey.com/boards/viewtopic.php?p=554647&sid=83cf90bcab788e19e2aacfaa0e9e57e3#p554647
		; * by william_ahk
		Local CC := 4096, Esc := "", Result := ""
		Loop {
			VarSetStrCapacity(&Esc, CC)
			Result := DllCall("Shlwapi.dll\UrlEscapeW", "Str", Url, "Str", &Esc, "UIntP", &CC, "UInt", Flags, "UInt")
		} Until Result != 0x80004003

		Return Esc
	}

	static UrlUnescape(&Url, Flags := 0x00140000) {
		Return !DllCall("Shlwapi.dll\UrlUnescape", "Ptr", StrPtr(Url), "Ptr", 0, "UInt", 0, "UInt", Flags, "UInt") ? Url : ""
	}


	static StrBind(str, &keyRef?, &modRef?, &rulRef?) {
		keyRef := ""
		modRef := ""
		rulRef := ""

		if RegExMatch(str, ":(.*?)$", &ruleMatch) {
			rulRef := ":" ruleMatch[1]
			str := RegExReplace(str, ":(.*?)$")
		}

		if RegExMatch(str, "([\<\>\^\!\+\#]+)", &modMatch) {
			modRef := modMatch[1]
			str := RegExReplace(str, "[\<\>\^\!\+\#]+")
		}

		keyRef := str

		return True
	}

	static StrTrimPath(str) {
		return RegExReplace(str, ".*[\\/]", "")
	}

	static WidthBasedStrLen(str) {
		local len := StrLen(str)
		local lenSplit := StrSplit(str, "")

		for i, char in lenSplit {
			if (Ord(char) >= 0x2003 && Ord(char) <= 0x2002) {
				len++
			}
		}

		return len
	}

	static StrWrap(str, pair, space := " ") {
		return pair[1] space str space pair[2]
	}

	static UniTrim(Str) {
		return SubStr(Str, 4, StrLen(Str) - 4)
	}

	static HexNonLatinToLatin(str) {
		static replacements := [
			"А", "A", "Б", "B", "С", "C", "Ц", "C", "Д", "D", "Е", "E", "Ф", "F",
			"Α", "A", "Β", "B", "Σ", "C", "Ψ", "C", "Δ", "D", "Ε", "E", "Φ", "F",
		]
		for i, replacement in replacements
			if Mod(i, 2) = 1
				str := RegExReplace(str, "i)" replacement, replacements[i + 1])
		return str
	}

	static ExtractHex(Str) {
		return RegExReplace(Str, "[^0-9A-Fa-f]", "")
	}

	static UnicodeToChar(unicode) {
		if IsObject(unicode) {
			local hexStr := ""

			for value in unicode {
				local intermediate := this.ExtractHex(value)
				if StrLen(intermediate) > 0 {
					local num := Format("0x{1}", intermediate)
					hexStr .= Chr(num)
				}
			}

			if StrLen(hexStr) > 0 {
				return hexStr
			}
		} else {
			local hexStr := this.ExtractHex(unicode)
			if StrLen(hexStr) > 0 {
				local num := Format("0x{1}", hexStr)
				return Chr(num)
			}
		}
		return
	}

	static UnicodeToChars(unicode*) {
		local output := ""

		if unicode.Length = 1 && unicode[1] is Array
			unicode := unicode[1]

		for value in unicode
			output .= this.UnicodeToChar(value)

		return output
	}

	static ChrToUnicode(symbol, startFormat := "") {
		local symOrd := Ord(symbol)
		local code := startFormat Format("{:04X}", symOrd)

		return code
	}

	static ChrToDecimal(Symbol) {
		local hexCode := this.ChrToUnicode(Symbol)
		return Format("{:d}", "0x" hexCode)
	}

	static ChrToHexaDecimal(stringInput, startFromat := "0x") {
		if stringInput != "" {
			local output := ""
			local i := 1

			while (i <= StrLen(stringInput)) {
				local symbol := SubStr(stringInput, i, 1)
				local code := Ord(symbol)

				if (code >= 0xD800 && code <= 0xDBFF) {
					local nextSymbol := SubStr(stringInput, i + 1, 1)
					symbol .= nextSymbol
					i += 1
				}

				output .= this.ChrToUnicode(symbol, startFromat) "-"
				i += 1
			}

			return RegExReplace(output, "-$", "")
		} else {
			return stringInput
		}
		return
	}

	static HexaDecimalToChr(stringInput) {
		if stringInput != "" {
			local output := ""
			for symbol in StrSplit(stringInput, "-") {
				output .= Chr(symbol)
			}
			return output
		} else {
			return stringInput
		}
		return
	}


	static FormatHotKey(hKey, modifier := "") {
		local output := ""
		if hKey is Array && hKey.Length > 0 {
			output := hKey.ToString(" ")
		}

		static specialCommandsMap := Map(
			CtrlA, LeftControl " a ф",
			CtrlB, LeftControl " b и",
			CtrlC, LeftControl " c с",
			CtrlD, LeftControl " d в",
			CtrlE, LeftControl " e у",
			CtrlF, LeftControl " f а",
			CtrlG, LeftControl " g п",
			CtrlH, LeftControl " h р",
			CtrlI, LeftControl " i ш",
			CtrlJ, LeftControl " j о",
			CtrlK, LeftControl " k л",
			CtrlL, LeftControl " l д",
			CtrlM, LeftControl " m ь",
			CtrlN, LeftControl " n т",
			CtrlO, LeftControl " o щ",
			CtrlP, LeftControl " p з",
			CtrlQ, LeftControl " q й",
			CtrlR, LeftControl " r к",
			CtrlS, LeftControl " s ы",
			CtrlT, LeftControl " t е",
			CtrlU, LeftControl " u г",
			CtrlV, LeftControl " v м",
			CtrlW, LeftControl " w ц",
			CtrlX, LeftControl " x ч",
			CtrlY, LeftControl " y н",
			CtrlZ, LeftControl " z я",
			ExclamationMark, "!",
			CommercialAt, "@",
			QuotationDouble, QuotationDouble,
			Tabulation, "Tab"
		)

		for key, value in specialCommandsMap {
			output := RegExReplace(output, key, value)
		}

		return output
	}

	static ReplaceModifierKeys(input) {
		local output := input
		if IsObject(output) {
			for i, k in output {
				output[i] = this.ReplaceModifierKeys(k)
			}
		} else {
			output := RegExReplace(output, "\<\!", LeftAlt)
			output := RegExReplace(output, "\>\!", RightAlt)
			output := RegExReplace(output, "\<\+", LeftShift)
			output := RegExReplace(output, "\>\+", RightShift)
			output := RegExReplace(output, "\<\^", LeftControl)
			output := RegExReplace(output, "\>\^", RightControl)
			output := RegExReplace(output, "c\*", CapsLock)
		}
		return output
	}

	static EscapePathChars(str) {
		str := StrReplace(str, " ", "_")
		str := StrReplace(str, "\", "____")
		str := StrReplace(str, "/", "____")
		local dotPos := InStr(str, ".", , -1)
		if (dotPos) {
			local ext := SubStr(str, dotPos)
			str := SubStr(str, 1, dotPos - 1)
		}

		str := StrReplace(str, ".", "_")

		return str
	}

	static TrimBasePath(filePath, basePath := App.paths.profile "\") {
		if (InStr(filePath, basePath) == 1) {
			return SubStr(filePath, StrLen(basePath) + 1)
		}
		return filePath
	}

	static HasAllCharacters(str, pattern) {
		static wordBoundary := "[^a-zA-Zа-яА-ЯёЁ]"

		if RegExMatch(pattern, "\s") {
			local wordSplit := StrSplit(pattern, " ")
			for word in wordSplit {
				if StrLen(word) < 3 {
					pattern := "(^|" wordBoundary ")" word "($|" wordBoundary ")"
					if !RegExMatch(str, pattern)
						return False
				} else {
					if !InStr(str, word)
						return False
				}
			}
			return True
		} else {
			for char in StrSplit(pattern) {
				if !InStr(str, char)
					return False
			}
			return True
		}
	}

	static HasSequentialCharacters(str, pattern, caseSense := False) {
		local pos := 1
		for char in StrSplit(pattern) {
			local found := InStr(str, char, caseSense, pos)
			if !found
				return False
			pos := found + 1
		}
		return True
	}

	static INIRenameSection(filePaths, oldSection, newSection) {
		local content := FileRead(filePaths, "UTF-16")
		local split := StrSplit(content, "`n", "`r")

		local found := False
		for i, line in split {
			if (line = "[" oldSection "]") {
				split[i] := "[" newSection "]"
				found := True
			}
		}

		content := split.ToString("`n")

		if (found) {
			FileDelete(filePaths)
			FileAppend(content, filePaths, "UTF-16")
		}
	}

	static INIGetSections(filePaths, postfix := "") {
		local output := []
		for singleFile in filePaths {
			local content := FileRead(singleFile, "UTF-16")
			for line in StrSplit(content, "`n") {
				if RegExMatch(line, "^\[(.*)\]$", &match) {
					output.Push(Trim(match[1]) postfix)
				}
			}
		}
		return output
	}

	static INIToMap(filePath) {
		if !InStr(filePath, ".ini")
			filePath .= ".ini"

		local content := FileRead(filePath, "UTF-16")
		local lines := StrSplit(content, "`n", "`r`n")

		local iniMap := Map()
		local currentSection := ""

		for line in lines {
			line := Trim(line)
			if (line = "" or SubStr(line, 1, 1) = ";")
				continue

			if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
				currentSection := SubStr(line, 2, -1)
				iniMap.Set(currentSection, Map())
			}
			else if (currentSection != "" && InStr(line, "=")) {
				local parts := StrSplit(line, "=", "`t ")
				local key := Trim(parts[1])
				local value := Trim(parts[2])
				iniMap[currentSection].Set(key, value)
			}
		}

		return iniMap
	}


	static INIToObj(filePath) {
		local obj := {}
		filePath := filePath (!InStr(filePath, ".ini") ? ".ini" : "")

		if !FileExist(filePath)
			return obj

		local content := FileRead(filePath, "UTF-16")
		local lines := StrSplit(content, "`n", "`r`n")

		local currentSection := ""

		for line in lines {
			line := Trim(line)
			if (line = "" or SubStr(line, 1, 1) = ";")
				continue

			if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
				currentSection := SubStr(line, 2, -1)
				obj.%currentSection% := {}
			} else if (currentSection != "" && InStr(line, "=")) {
				local eqPos := InStr(line, "=")
				local key := Trim(SubStr(line, 1, eqPos - 1))
				local value := Trim(SubStr(line, eqPos + 1))

				obj.%currentSection%.%key% := value
			}
		}

		return obj
	}

	static MultiINIToObj(pathsArray) {
		local bufferArray := []
		local bufferObject := {}

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
		local output := ""
		local indentStr := Util.StrRepeat("`t", indent)

		for key, value in obj.OwnProps() {
			if IsObject(value) {
				output .= indentStr key ":`n" . this.ObjPreview(value, indent + 1)
			} else {
				output .= indentStr key ": " value "`n"
			}
		}

		return output
	}

	static CaretTooltip(tooltipText) {
		CaretGetPos(&x, &y) || UIA_Util.CaretGetPosAlternative(&x, &y) ?
			ToolTip(tooltipText, x, y + 30) : ToolTip(tooltipText)
	}

	static IsCaretPostExists() {
		return CaretGetPos(&x, &y) || UIA_Util.CaretGetPosAlternative(&x, &y) ? True : False
	}

	static TextProgressBar(current, total, width := 20) {
		local percent := Floor((current / total) * 100)
		local filledWidth := Round(width * percent / 100)
		local unfilledWidth := width - filledWidth
		local bar := "▏ " Util.StrRepeat("█" Chr(0x2006), filledWidth) Util.StrRepeat(Chrs(0x2002, 0x2005, 0x2006) (current != total ? Chr(0x2006) : ""), unfilledWidth) " ▕  " percent "%"

		return bar
	}

	static ProcessConcatenation(arr) {
		local result := []
		local concatStartI := 0
		local i := 1

		while i <= arr.Length {
			local item := arr[i]

			if item is Array {
				if concatStartI > 0 {
					i++
					continue
				} else {
					result.Push(this.ProcessConcatenation(item))
					i++
					continue
				}
			}

			if RegExMatch(item, "@concat\{") {
				concatStartI := i
				i++
				continue
			}

			if RegExMatch(item, "\}endConcat@") && concatStartI > 0 {
				local concatStr := ""

				Loop i - concatStartI - 1 {
					local idx := concatStartI + A_Index
					local concatItem := arr[idx]

					if concatItem is Array {
						local processedSubArray := this.ProcessConcatenation(concatItem)
						concatStr .= processedSubArray.ToString("")
					} else {
						concatStr .= concatItem
					}
				}

				result.Push(concatStr)
				concatStartI := 0
				i++
				continue
			}

			if concatStartI > 0 {
				i++
				continue
			}

			result.Push(item)
			i++
		}

		return result
	}
}

Class UIA_Util {
	; Caret get from https://www.autohotkey.com/boards/viewtopic.php?t=114802

	static CaretGetPosAlternative(&x?, &y?) {
		static OBJID_CARET := 0xFFFFFFF8
		CoordMode 'Caret'
		if !CaretGetPos(&x, &y) {
			AccObject := this.AccObjectFromWindow(WinExist('A'), OBJID_CARET)
			Pos := this.AccLocation(AccObject)
			try x := Pos.x, y := Pos.y
			if !(x && y) {
				Pos := this.CaretPos()
				try x := Pos.x, y := Pos.y
			}
		}
		Return !!(x && y)
	}

	static CaretPos() {
		static CLSID_CUIAutomation8 := '{E22AD333-B25F-460C-83D0-0581107395C9}'
			, IID_IUIAutomation2 := '{34723AFF-0C9D-49D0-9896-7AB52DF8CD8A}'
			, IUIA := ComObject(CLSID_CUIAutomation8, IID_IUIAutomation2)
			, TextPatternElement2 := 10024

		try {
			ComCall(8, IUIA, 'ptr*', &FocusedEl := 0) ; GetFocusedElement
			ComCall(16, FocusedEl, 'int', TextPatternElement2, 'ptr*', &TextPattern2 := 0) ; GetCurrentPattern
			if TextPattern2 {
				ComCall(10, TextPattern2, 'int*', 1, 'ptr*', &caretRange := 0) ; GetCaretRange
				ComCall(10, caretRange, 'ptr*', &boundingRects := 0) ; GetBoundingRectangles
				ObjRelease(FocusedEl), ObjRelease(TextPattern2), ObjRelease(caretRange)
				Rect := ComValue(0x2005, boundingRects)
				if Rect.MaxIndex() = 3
					return { X: Round(Rect[0]), Y: Round(Rect[1]), W: Round(Rect[2]), H: Round(Rect[3]) }
			}
		}
	}

	static AccObjectFromWindow(hWnd, idObject := 0) {
		static IID_IDispatch := '{00020400-0000-0000-C000-000000000046}'
			, IID_IAccessible := '{618736E0-3C3D-11CF-810C-00AA00389B71}'
			, OBJID_NATIVEOM := 0xFFFFFFF0, VT_DISPATCH := 9, F_OWNVALUE := 1
			, h := DllCall('LoadLibrary', 'Str', 'Oleacc', 'Ptr')

		idObject &= 0xFFFFFFFF, AccObject := 0
		DllCall('Ole32\CLSIDFromString', 'Str', idObject = OBJID_NATIVEOM ? IID_IDispatch : IID_IAccessible, 'Ptr', CLSID := Buffer(16))
		if DllCall('Oleacc\AccessibleObjectFromWindow', 'Ptr', hWnd, 'UInt', idObject, 'Ptr', CLSID, 'PtrP', &pAcc := 0) = 0
			AccObject := ComObjFromPtr(pAcc), ComObjFlags(AccObject, F_OWNVALUE, F_OWNVALUE)
		return AccObject
	}

	static AccLocation(Acc, ChildId := 0, &Position := '') {
		static type := (VT_BYREF := 0x4000) | (VT_I4 := 3)
		x := Buffer(4, 0), y := Buffer(4, 0), w := Buffer(4, 0), h := Buffer(4, 0)
		try Acc.accLocation(ComValue(type, x.Ptr), ComValue(type, y.Ptr),
			ComValue(type, w.Ptr), ComValue(type, h.Ptr), ChildId)
		catch
			return
		return { x: NumGet(x, 'int'), y: NumGet(y, 'int'), w: NumGet(w, 'int'), h: NumGet(h, 'int') }
	}
}

Class GUI_Util {
	static RemoveMinMaxButtons(hwnd) {
		style := DllCall("GetWindowLong", "Ptr", hwnd, "Int", -16, "Int")
		newStyle := style & ~(0x00020000 | 0x00010000) ; WS_MINIMIZEBOX = 0x20000, WS_MAXIMIZEBOX = 0x10000
		DllCall("SetWindowLong", "Ptr", hwnd, "Int", -16, "Int", newStyle)

		hMenu := DllCall("GetSystemMenu", "Ptr", hwnd, "Int", 0, "Ptr")
		DllCall("DeleteMenu", "Ptr", hMenu, "UInt", 0xF020, "UInt", 0) ; SC_MINIMIZE
		DllCall("DeleteMenu", "Ptr", hMenu, "UInt", 0xF030, "UInt", 0) ; SC_MAXIMIZE
		DllCall("DeleteMenu", "Ptr", hMenu, "UInt", 0xF120, "UInt", 0) ; SC_RESTORE

		DllCall("DrawMenuBar", "Ptr", hwnd)
	}
}