Class CharacterInserter {

	__New(insertType) {
		this.insertType := insertType
		this.lastPrompt := IniRead(ConfigFile, "LatestPrompts", insertType, "")
	}

	InputDialog(UseHWND := True) {
		hwnd := WinActive('A')

		IB := InputBox(ReadLocale("symbol_code_prompt"), ReadLocale("symbol_" StrLower(this.insertType)), "w256 h92", this.lastPrompt)
		this.lastPrompt := IB.Value

		if IB.Result = "Cancel"
			return

		output := ""
		try {

			splittedPrompt := StrSplit(this.lastPrompt, " ")
			for charCode in splittedPrompt {
				if charCode != "" {
					charCode := RegExReplace(charCode, "^(U\+|u\+|Alt\+|alt\+)", "")

					if !%this.insertType%Validate(charCode)
						throw

					output .= %this.insertType%(charCode)

				}
			}
			IniWrite(this.lastPrompt, ConfigFile, "LatestPrompts", this.insertType)
		} catch {
			MsgBox(ReadLocale("message_wrong_format") "`n`n" ReadLocale("message_wrong_format_" StrLower(this.insertType)), DSLPadTitle, "Icon!")
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

		Altcode(charCode) {
			return "{ASC " charCode "}"
		}

		Unicode(charCode) {
			charCode := Format("0x" charCode, "d")
			return Chr(charCode)
		}

		AltcodeValidate(charCode) {
			return IsInteger(charCode) && ((RegExMatch(charCode, "^0") ? charCode >= 128 : charCode > 0) && charCode <= 255)
		}

		UnicodeValidate(charCode) {
			return RegExMatch(charCode, "^[0-9a-fA-F]+$")
		}
	}
}