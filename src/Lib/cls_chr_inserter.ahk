Class CharacterInserter {
	static AltcodePrefix := "Alt+"
	static UnicodePrefix := "U+"

	__New(insertType := "Unicode") {
		this.insertType := insertType
		this.lastPrompt := Cfg.Get(this.insertType, "LatestPrompts")
	}

	InputDialog(UseHWND := True) {
		hwnd := WinActive('A')

		IB := InputBox(Locale.Read("symbol_code_prompt"), Locale.Read("symbol_" StrLower(this.insertType)), "w256 h92", this.lastPrompt)
		this.lastPrompt := IB.Value

		if IB.Result = "Cancel"
			return

		output := ""
		try {

			splittedPrompt := StrSplit(this.lastPrompt, " ")
			for charCode in splittedPrompt {
				if charCode != "" {
					charCode := RegExReplace(charCode, "^(U\+|u\+|Alt\+|alt\+)", "")

					if !CharacterInserter.%this.insertType%Validate(charCode)
						throw

					output .= CharacterInserter.%this.insertType%(charCode)

				}
			}
			Cfg.Set(this.lastPrompt, this.insertType, "LatestPrompts")
		} catch {
			MsgBox(Locale.Read("message_wrong_format") "`n`n" Locale.Read("message_wrong_format_" StrLower(this.insertType)), DSLPadTitle, "Icon!")
			return
		}

		try {
			if UseHWND && !WinActive('ahk_id ' hwnd) {
				WinActivate('ahk_id ' hwnd)
				WinWaitActive(hwnd)
			}

			Send(output)
		}
		return
	}

	static Altcode(charCode, isReturn := False) {
		if isReturn {
			if AltCodesLibrary.HasValue(charCode, &i) {
				return AltCodesLibrary[i - 1]
			}
		} else {
			return "{ASC " charCode "}"
		}
	}

	static Unicode(charCode, isReturn?) {
		charCode := Format("0x" charCode, "d")
		return Chr(charCode)
	}

	static AltcodeValidate(charCode) {
		return IsInteger(charCode) && ((RegExMatch(charCode, "^0") ? charCode >= 128 : charCode > 0) && charCode <= 255)
	}

	static UnicodeValidate(charCode) {
		if !RegExMatch(charCode, "^[0-9A-Fa-f]{1,6}$")
			return False

		code := Integer("0x" charCode)
		len := StrLen(charCode)

		leadingZeros := 0
		Loop Parse, charCode {
			if A_LoopField == "0"
				leadingZeros++
			else
				break
		}

		if (leadingZeros > 0 && len > 4)
			return False


		if (code >= 0x1000 && StrUpper(charCode) != Format("{:X}", code))
			return False

		return code <= 0x10FFFF
	}


}