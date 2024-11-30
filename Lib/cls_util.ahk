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

}