class UnicodeUtils {
	static icuLib := ""
	static ICU_LIBS := ["icuuc.dll", "icuuc74.dll", "icuuc73.dll", "icuuc72.dll", "icuuc71.dll"]

	static U_UNICODE_CHAR_NAME := 0
	static U_UNICODE_10_CHAR_NAME := 1
	static U_EXTENDED_CHAR_NAME := 2

	static U_DEFAULT_SYMBOLS := "[a-zA-Zа-яА-ЯёЁ0-9.,\s:;!?()\`"'-+=/\\]"
	static U_ASCII_SYMBOLS := "[\x00-\x7F]"

	static U_CHARACTER_CATEGORIES := Map(
		0, ["UNASSIGNED", "Not assigned", "Cn", "Not assigned (Cn)"],
		1, ["UPPERCASE_LETTER", "Letter, uppercase", "Lu", "Letter, uppercase (Lu)"],
		2, ["LOWERCASE_LETTER", "Letter, lowercase", "Ll", "Letter, lowercase (Ll)"],
		3, ["TITLECASE_LETTER", "Letter, titlecase", "Lt", "Letter, titlecase (Lt)"],
		4, ["MODIFIER_LETTER", "Letter, modifier", "Lm", "Letter, modifier (Lm)"],
		5, ["OTHER_LETTER", "Letter, other", "Lo", "Letter, other (Lo)"],
		6, ["NON_SPACING_MARK", "Mark, nonspacing", "Mn", "Mark, nonspacing (Mn)"],
		7, ["ENCLOSING_MARK", "Mark, enclosing", "Me", "Mark, enclosing (Me)"],
		8, ["COMBINING_SPACING_MARK", "Mark, spacing combining", "Mc", "Mark, spacing combining (Mc)"],
		9, ["DECIMAL_DIGIT_NUMBER", "Number, decimal digit", "Nd", "Number, decimal digit (Nd)"],
		10, ["LETTER_NUMBER", "Number, letter", "Nl", "Number, letter (Nl)"],
		11, ["OTHER_NUMBER", "Number, other", "No", "Number, other (No)"],
		12, ["SPACE_SEPARATOR", "Separator, space", "Zs", "Separator, space (Zs)"],
		13, ["LINE_SEPARATOR", "Separator, line", "Zl", "Separator, line (Zl)"],
		14, ["PARAGRAPH_SEPARATOR", "Separator, paragraph", "Zp", "Separator, paragraph (Zp)"],
		15, ["CONTROL_CHAR", "Other, control", "Cc", "Other, control (Cc)"],
		16, ["FORMAT_CHAR", "Other, format", "Cf", "Other, format (Cf)"],
		17, ["PRIVATE_USE_CHAR", "Other, private use", "Co", "Other, private use (Co)"],
		18, ["SURROGATE", "Other, surrogate", "Cs", "Other, surrogate (Cs)"],
		19, ["DASH_PUNCTUATION", "Punctuation, dash", "Pd", "Punctuation, dash (Pd)"],
		20, ["START_PUNCTUATION", "Punctuation, open", "Ps", "Punctuation, open (Ps)"],
		21, ["END_PUNCTUATION", "Punctuation, close", "Pe", "Punctuation, close (Pe)"],
		22, ["CONNECTOR_PUNCTUATION", "Punctuation, connector", "Pc", "Punctuation, connector (Pc)"],
		23, ["OTHER_PUNCTUATION", "Punctuation, other", "Po", "Punctuation, other (Po)"],
		24, ["MATH_SYMBOL", "Symbol, math", "Sm", "Symbol, math (Sm)"],
		25, ["CURRENCY_SYMBOL", "Symbol, currency", "Sc", "Symbol, currency (Sc)"],
		26, ["MODIFIER_SYMBOL", "Symbol, modifier", "Sk", "Symbol, modifier (Sk)"],
		27, ["OTHER_SYMBOL", "Symbol, other", "So", "Symbol, other (So)"],
		28, ["INITIAL_PUNCTUATION", "Punctuation, initial quote", "Pi", "Punctuation, initial quote (Pi)"],
		29, ["FINAL_PUNCTUATION", "Punctuation, final quote", "Pf", "Punctuation, final quote (Pf)"]
	)

	static U_CODEPOINT_FORMATS := Map(
		"Default", "{:04X}",
		"Hex", "0x{:X}",
		"Hex4", "0x{:04X}",
		"Dec", "{}",
		"JSON", "\u{:04X}",
		"CSS", "\u{:04X}",
		"CSS-10000", "\u{{:04X}}",
		"Python", "\u{:04X}",
		"Python-10000", "\U{:08X}",
		"U+", "U+{:04X}",
		"XML", "&#x{:X};",
		"XML4", "&#x{:04X};",
		"HTML", "&#{};"
	)

	static InitICU() {
		if (this.icuLib != "")
			return true

		for lib in this.ICU_LIBS {
			try {
				DllCall(lib "\u_charName",
					"UInt", 0x41,
					"Int", this.U_UNICODE_CHAR_NAME,
					"Ptr", 0,
					"Int", 0,
					"Ptr", 0,
					"Int")
				this.icuLib := lib
				return true
			}
		}
		return false
	}

	static ParseCodePoint(input, prefix := "") {
		if !(input is String)
			return input

		local len := StrLen(input)

		if prefix = "0x" && input ~= "^[0-9A-Fa-f]{1,8}$"
			return Number("0x" input)

		if (len >= 4) && input ~= "^[0-9A-Fa-f]{4,8}$"
			return Number("0x" input)

		if (len = 1)
			return Ord(input)

		if (len = 2)
			return this.DecodeSurrogatePair(input)

		if (len >= 4) && RegExMatch(input, "&#x([0-9A-Fa-f]{1,8});", &m)
			return Number("0x" m[1])

		if (len >= 3) && RegExMatch(input, "&#([0-9]{1,10});", &m)
			return Number(m[1])

		return -1
	}

	static DecodeSurrogatePair(str) {
		local high := Ord(SubStr(str, 1, 1))
		local low := Ord(SubStr(str, 2, 1))

		if (high >= 0xD800 && high <= 0xDBFF && low >= 0xDC00 && low <= 0xDFFF)
			return 0x10000 + ((high - 0xD800) << 10) + (low - 0xDC00)

		return high
	}

	static IsSurrogate(input, skipParse := False) {
		local codepoint := !skipParse ? this.ParseCodePoint(input) : input
		return (codepoint >= 0x10000)
	}

	static IsHighSurrogate(input, skipParse := False) {
		local codepoint := !skipParse ? this.ParseCodePoint(input) : input
		return (codepoint >= 0xD800 && codepoint <= 0xDBFF)
	}

	static IsLowSurrogate(input, skipParse := False) {
		local codepoint := !skipParse ? this.ParseCodePoint(input) : input
		return (codepoint >= 0xDC00 && codepoint <= 0xDFFF)
	}

	static GetFormat(formatLabel) {
		local output := formatLabel

		if this.U_CODEPOINT_FORMATS.Has(formatLabel)
			output := this.U_CODEPOINT_FORMATS.Get(formatLabel)
		else if InStr(formatLabel, "-10000") && this.U_CODEPOINT_FORMATS.Has(StrReplace(formatLabel, "-10000"))
			output := this.U_CODEPOINT_FORMATS.Get(StrReplace(formatLabel, "-10000"))

		return output
	}

	static GetCodePoint(input, outputFormat := "Default") {
		local codepoint := this.ParseCodePoint(input)

		if (codepoint < 0)
			return ""

		return Format(this.GetFormat(outputFormat), codepoint)
	}

	static GetSurrogatePair(input, outputFormat := "Default") {
		local codepoint := this.ParseCodePoint(input)

		if !this.IsSurrogate(codepoint, True)
			return this.GetCodePoint(codepoint, outputFormat)

		codepoint -= 0x10000
		local highSurrogate := 0xD800 + (codepoint >> 10)
		local lowSurrogate := 0xDC00 + (codepoint & 0x3FF)

		outputFormat := this.GetFormat(outputFormat)

		return [Format(outputFormat, highSurrogate), Format(outputFormat, lowSurrogate)]
	}

	static GetBatchCodePoints(sourceArray, outputFormat := "Default", splitSurrogates := False, skipASCII := False) {
		local output := []

		if sourceArray is String
			sourceArray := this.StrSplitChars(sourceArray)

		for value in sourceArray {
			if skipASCII && RegExMatch(value, "i)^" this.U_ASCII_SYMBOLS "$") {
				output.Push(value)
				continue
			}

			local isSurrogate := this.IsSurrogate(value)
			local currentFormat := isSurrogate ? outputFormat "-10000" : outputFormat

			if splitSurrogates {
				local symbolValue := this.GetSurrogatePair(value, currentFormat)

				if (isSurrogate)
					output.Push(symbolValue[1], symbolValue[2])
				else
					output.Push(symbolValue)

			} else
				output.Push(this.GetCodePoint(value, currentFormat))
		}

		return output
	}

	static GetRangeOfCodePoints(startCodepoint, endCodepoint) {
		local output := []

		startCodepoint := this.ParseCodePoint(startCodepoint)
		endCodepoint := this.ParseCodePoint(endCodepoint)

		Loop (endCodepoint - startCodepoint + 1) {
			local codepoint := startCodepoint + A_Index - 1
			output.Push(Format("{:04X}", codepoint))
		}

		return output
	}

	static GetSymbol(input) {
		local codepoint := this.ParseCodePoint(input)

		if (codepoint < 0)
			return ""

		if (codepoint <= 0xFFFF)
			return Chr(codepoint)

		codepoint -= 0x10000
		local highSurrogate := 0xD800 + (codepoint >> 10)
		local lowSurrogate := 0xDC00 + (codepoint & 0x3FF)

		return Chr(highSurrogate) Chr(lowSurrogate)
	}

	static GetBatchSymbols(sourceArray, outputType := []) {
		local output := []

		if sourceArray is String
			sourceArray := this.StrSplit(sourceArray, " ")

		for value in sourceArray
			output.Push(this.GetSymbol(value))

		return outputType is String ? output.ToString("") : output
	}

	static GetRangeOfSymbols(startCodepoint, endCodepoint) {
		local output := []

		startCodepoint := this.ParseCodePoint(startCodepoint)
		endCodepoint := this.ParseCodePoint(endCodepoint)

		Loop (endCodepoint - startCodepoint + 1) {
			local codepoint := startCodepoint + A_Index - 1
			local symbol := this.GetSymbol(codepoint)

			if (symbol != "")
				output.Push(symbol)
		}

		return output
	}

	static GetName(input, prefix := "", nameType := 0) {
		if !this.InitICU()
			return ""

		local codepoint := this.ParseCodePoint(input, prefix)

		if (codepoint < 0)
			return ""

		local nameBuffer := Buffer(256, 0)
		local errorCode := Buffer(4, 0)

		try {
			local length := DllCall(this.icuLib "\u_charName",
				"UInt", codepoint,
				"Int", nameType,
				"Ptr", nameBuffer.Ptr,
				"Int", nameBuffer.Size,
				"Ptr", errorCode.Ptr,
				"Int")

			if (length > 0) {
				local name := StrGet(nameBuffer.Ptr, "UTF-8")
				return (name != "" && name != " ") ? name : ""
			}
		}

		return ""
	}

	static GetBatchNames(sourceArray, prefix := "") {
		local output := []

		if sourceArray is String
			sourceArray := this.StrSplitChars(sourceArray)

		for value in sourceArray
			output.Push(this.GetName(value, prefix))

		return output
	}

	static GetRangeOfNames(startCodepoint, endCodepoint) {
		local output := Map()

		startCodepoint := this.ParseCodePoint(startCodepoint)
		endCodepoint := this.ParseCodePoint(endCodepoint)

		Loop (endCodepoint - startCodepoint + 1) {
			local codepoint := startCodepoint + A_Index - 1
			local name := this.GetName(codepoint)

			if (name != "")
				output.Set(Format("{:04X}", codepoint), name)
		}

		return output
	}

	static GetAllNames(input) {
		local output := Map()

		local standardName := this.GetName(input, this.U_UNICODE_CHAR_NAME)
		if (standardName != "")
			output["Standard"] := standardName

		local unicode10Name := this.GetName(input, this.U_UNICODE_10_CHAR_NAME)
		if (unicode10Name != "")
			output["Unicode 1.0"] := unicode10Name

		local extendedName := this.GetName(input, this.U_EXTENDED_CHAR_NAME)
		if (extendedName != "")
			output["Extended"] := extendedName

		return output
	}

	static GetSymbolCategory(input, nameType := 1) {
		if !this.InitICU()
			return ""

		local codepoint := this.ParseCodePoint(input)
		if (codepoint < 0)
			return ""

		try {
			local category := DllCall(this.icuLib "\u_charType",
				"UInt", codepoint)

			category := category & 0xFF

			return this.U_CHARACTER_CATEGORIES.Has(category) ? this.U_CHARACTER_CATEGORIES[category][nameType] : "UNKNOWN_CATEGORY_" category
		}

		return ""
	}

	static GetNamedEntity(symbol, skipASCII := False, outputFormat := "XML4", parseSymbol := False) {
		if parseSymbol
			symbol := this.GetSymbol(symbol)

		if skipASCII && RegExMatch(symbol, "i)^" this.U_ASCII_SYMBOLS "$")
			return symbol

		for char, htmlCode in characters.supplementaryData["HTML Named Entities"] {
			if char == symbol
				return htmlCode
		}

		return this.GetCodePoint(symbol, outputFormat)
	}

	static GetBatchNamedEntities(sourceArray, skipASCII := False, outputFormat := "XML4", parseSymbol := False) {
		local output := []

		if sourceArray is String
			sourceArray := this.StrSplitChars(sourceArray)

		for value in sourceArray
			output.Push(this.GetNamedEntity(value, skipASCII, outputFormat, parseSymbol))

		return output
	}

	static ConvertSelectedStrToCodePoints(outputFormat := "Default", stringJoiner := "", splitSurrogates := False, skipASCII := False) {
		Clip.CopySelected(&text, , "Backup")

		if text = "" {
			Clip.Release(1)
			return
		}

		text := outputFormat = "Entities" ? this.GetBatchNamedEntities(text, skipASCII).ToString(stringJoiner) : this.GetBatchCodePoints(text, outputFormat, splitSurrogates, skipASCII).ToString(stringJoiner)

		Clip.Send(&text, , , "Release")
		return
	}

	static FullWidth(str, variant := "To") {
		local split := this.StrSplitChars(str)
		local output := ""

		for char in split {
			local code := this.ParseCodePoint(char)

			if (variant = "To") {
				if (code == 32)
					code := 0x3000
				else if (code >= 33 && code <= 126)
					code += 0xFEE0
			} else if (variant = "From") {
				if (code == 0x3000)
					code := 32
				else if (code >= 0xFF01 && code <= 0xFF5E)
					code -= 0xFEE0
			}

			output .= Chr(code)
		}

		return output
	}


	static StrSplit(str, delimiters := "", omitChars := "", maxParts := -1) {
		if (delimiters = "")
			return this.StrSplitChars(str, omitChars, maxParts)

		if (delimiters is String) {
			delimArray := this.StrSplitChars(delimiters)
		} else if (delimiters is Array) {
			delimArray := delimiters
		} else {
			throw ValueError("Delimiters must be a String or Array")
		}

		local output := []
		local currentPart := ""
		local charArray := this.StrSplitChars(str)
		local partCount := 0

		for index, char in charArray {
			if (maxParts > 0 && partCount >= maxParts - 1) {
				currentPart .= char
				continue
			}

			local isDelimiter := False
			for _, delim in delimArray {
				if (char = delim) {
					isDelimiter := True
					break
				}
			}

			if (isDelimiter) {
				trimmed := this.TrimChars(currentPart, omitChars)
				output.Push(trimmed)
				currentPart := ""
				partCount++
			} else {
				currentPart .= char
			}
		}

		trimmed := this.TrimChars(currentPart, omitChars)
		output.Push(trimmed)

		return output
	}

	static TrimChars(str, omitChars) {
		if (omitChars = "" || str = "")
			return str

		local omitArray := this.StrSplitChars(omitChars)
		local chars := this.StrSplitChars(str)

		local startIdx := 1
		for index, char in chars {
			local found := False
			for _, omit in omitArray {
				if (char = omit) {
					found := True
					break
				}
			}
			if (!found) {
				startIdx := index
				break
			}
		}

		local endIdx := chars.Length
		Loop chars.Length {
			idx := chars.Length - A_Index + 1
			if (idx < startIdx)
				break

			local char := chars[idx]
			local found := False
			for _, omit in omitArray {
				if (char = omit) {
					found := True
					break
				}
			}
			if (!found) {
				endIdx := idx
				break
			}
		}

		if (startIdx > endIdx)
			return ""

		local output := ""
		loop endIdx - startIdx + 1 {
			output .= chars[startIdx + A_Index - 1]
		}

		return output
	}

	static StrSplitChars(str, omitChars := "", maxParts := -1) {
		local chars := []
		local i := 1
		local len := StrLen(str)
		local partCount := 0

		while (i <= len) {
			if (maxParts > 0 && partCount >= maxParts)
				break


			local code := Ord(SubStr(str, i, 1))
			local char := ""

			if (code >= 0xD800 && code <= 0xDBFF && i < len) {
				nextCode := Ord(SubStr(str, i + 1, 1))

				if (nextCode >= 0xDC00 && nextCode <= 0xDFFF) {
					char := SubStr(str, i, 2)
					i += 2
				} else {
					char := SubStr(str, i, 1)
					i++
				}
			} else {
				char := SubStr(str, i, 1)
				i++
			}

			if (omitChars != "") {
				local skip := False
				Loop Parse, omitChars {
					if (char = A_LoopField) {
						skip := True
						break
					}
				}
				if (skip)
					continue
			}

			chars.Push(char)
			partCount++
		}

		return chars
	}

	static SubStr(str, startingPos, length := unset) {
		if (str = "")
			return ""

		chars := this.StrSplitChars(str)
		totalChars := chars.Length

		if (startingPos = 0 || Abs(startingPos) > totalChars)
			return ""


		if (startingPos < 0)
			startingPos := totalChars + startingPos + 1


		if (startingPos < 1)
			startingPos := 1

		if (!IsSet(length))
			length := totalChars - startingPos + 1

		if (length < 0) {
			length := totalChars - startingPos + 1 + length
			if (length < 0)
				return ""
		}

		if (startingPos + length - 1 > totalChars)
			length := totalChars - startingPos + 1

		if (length <= 0)
			return ""

		result := ""
		loop length {
			idx := startingPos + A_Index - 1
			if (idx > totalChars)
				break
			result .= chars[idx]
		}

		return result
	}

	static StrLen(str) {
		return this.StrSplitChars(str).Length
	}
}