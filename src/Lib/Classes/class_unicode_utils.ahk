class UnicodeUtils {
	static icuLib := ""
	static ICU_LIBS := ["icuuc.dll", "icuuc74.dll", "icuuc73.dll", "icuuc72.dll", "icuuc71.dll"]

	static U_UNICODE_CHAR_NAME := 0
	static U_UNICODE_10_CHAR_NAME := 1
	static U_EXTENDED_CHAR_NAME := 2

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

	static ParseCodepoint(input) {
		if !(input is String)
			return input

		len := StrLen(input)

		if (len >= 4)
			return Number("0x" input)

		if (len = 1)
			return Ord(input)

		if (len = 2)
			return this.DecodeSurrogatePair(input)

		return -1
	}

	static DecodeSurrogatePair(str) {
		high := Ord(SubStr(str, 1, 1))
		low := Ord(SubStr(str, 2, 1))

		if (high >= 0xD800 && high <= 0xDBFF && low >= 0xDC00 && low <= 0xDFFF)
			return 0x10000 + ((high - 0xD800) << 10) + (low - 0xDC00)

		return high
	}

	static GetSymbol(input) {
		codepoint := this.ParseCodepoint(input)
		if (codepoint < 0)
			return ""

		if (codepoint <= 0xFFFF)
			return Chr(codepoint)

		codepoint -= 0x10000
		highSurrogate := 0xD800 + (codepoint >> 10)
		lowSurrogate := 0xDC00 + (codepoint & 0x3FF)

		return Chr(highSurrogate) . Chr(lowSurrogate)
	}

	static GetRangeOfSymbols(startCodepoint, endCodepoint) {
		local result := []

		startCodepoint := this.ParseCodepoint(startCodepoint)
		endCodepoint := this.ParseCodepoint(endCodepoint)

		Loop (endCodepoint - startCodepoint + 1) {
			local codepoint := startCodepoint + A_Index - 1
			local symbol := this.GetSymbol(codepoint)

			if (symbol != "")
				result.Push(symbol)
		}

		return result
	}

	static GetName(input, nameType := 0) {
		if !this.InitICU()
			return ""

		codepoint := this.ParseCodepoint(input)
		if (codepoint < 0)
			return ""

		nameBuffer := Buffer(256, 0)
		errorCode := Buffer(4, 0)

		try {
			length := DllCall(this.icuLib "\u_charName",
				"UInt", codepoint,
				"Int", nameType,
				"Ptr", nameBuffer.Ptr,
				"Int", nameBuffer.Size,
				"Ptr", errorCode.Ptr,
				"Int")

			if (length > 0) {
				name := StrGet(nameBuffer.Ptr, "UTF-8")
				return (name != "" && name != " ") ? name : ""
			}
		}

		return ""
	}

	static GetBatchUnicodeNames(sourceArray) {
		local result := []

		for value in sourceArray
			result.Push(this.GetName(value))

		return result
	}

	static GetRangeOfNames(startCodepoint, endCodepoint) {
		local result := Map()

		startCodepoint := this.ParseCodepoint(startCodepoint)
		endCodepoint := this.ParseCodepoint(endCodepoint)

		Loop (endCodepoint - startCodepoint + 1) {
			local codepoint := startCodepoint + A_Index - 1
			local name := this.GetName(codepoint)

			if (name != "")
				result.Set(Format("{:04X}", codepoint), name)
		}

		return result
	}

	static GetAllNames(input) {
		result := Map()

		standardName := this.GetName(input, this.U_UNICODE_CHAR_NAME)
		if (standardName != "")
			result["Standard"] := standardName

		unicode10Name := this.GetName(input, this.U_UNICODE_10_CHAR_NAME)
		if (unicode10Name != "")
			result["Unicode 1.0"] := unicode10Name

		extendedName := this.GetName(input, this.U_EXTENDED_CHAR_NAME)
		if (extendedName != "")
			result["Extended"] := extendedName

		return result
	}

	static GetSymbolCategory(input, nameType := 1) {
		if !this.InitICU()
			return ""

		codepoint := this.ParseCodepoint(input)
		if (codepoint < 0)
			return ""

		try {
			category := DllCall(this.icuLib "\u_charType",
				"UInt", codepoint)

			category := category & 0xFF

			return this.U_CHARACTER_CATEGORIES.Has(category) ? this.U_CHARACTER_CATEGORIES[category][nameType] : "UNKNOWN_CATEGORY_" category
		}

		return ""
	}
}

MsgBox UnicodeUtils.GetRangeOfSymbols("𐌰", "𐍊").ToString("") "`n`n" UnicodeUtils.GetRangeOfNames("𐌰", "𐍊").Values().ToString("`n")