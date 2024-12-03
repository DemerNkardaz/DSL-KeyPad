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
}