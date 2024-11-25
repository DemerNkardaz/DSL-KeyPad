Class CharacterInserter {

	__New(insertType := "Unicode") {
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

					if !CharacterInserter.%this.insertType%Validate(charCode)
						throw

					output .= CharacterInserter.%this.insertType%(charCode)

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


	}

	NumHook() {
		output := ""
		input := ""

		AltcodePrefix := "Alt+"
		UnicodePrefix := "U+"

		PH := InputHook("L0", "{Escape}")
		PH.Start()

		Loop {

			IH := InputHook("L1", "{Backspace}{Enter}{Escape}")
			IH.Start(), IH.Wait()

			if (IH.EndKey = "Escape") {
				input := ""
				break

			} else if (IH.EndKey = "Backspace") {
				if StrLen(input) > 0
					input := SubStr(input, 1, -1)

			} else if IH.Input != "" && StrLen(input) < 6 && (this.insertType = "Unicode" ? CharacterInserter.%this.insertType%Validate(IH.Input) : IsInteger(IH.Input)) {
				input .= IH.Input
			}

			preview := ""
			try {
				preview := CharacterInserter.%this.insertType%(input, True)
			}

			CaretTooltip("[ " preview " ]" Chr(0x2002) %this.insertType%Prefix StrUpper(input))

			if (IH.EndKey = "Enter") {
				if StrLen(input) > 0 {
					output := preview
				}
				IH.Stop()
				break
			}
		}

		PH.Stop()
		ToolTip()

		if StrLen(output) > 0
			SendText(output)

		return
	}


	static Altcode(charCode, isReturn := False) {
		if isReturn
			return Chr(charCode)
		return "{ASC " charCode "}"
	}

	static Unicode(charCode, isReturn?) {
		charCode := Format("0x" charCode, "d")
		return Chr(charCode)
	}

	static AltcodeValidate(charCode) {
		return IsInteger(charCode) && ((RegExMatch(charCode, "^0") ? charCode >= 128 : charCode > 0) && charCode <= 255)
	}

	static UnicodeValidate(charCode) {
		return RegExMatch(charCode, "^[0-9a-fA-F]+$")
	}

}