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
			MsgBox(Locale.Read("message_wrong_format") "`n`n" Locale.Read("message_wrong_format_" StrLower(this.insertType)), App.Title(), "Icon!")
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
	static Altcode(charCode) {
		if !(StrLen(charCode) > 1 && charCode ~= "^0") && Number(charCode) < 32 && AltCodesLibrary.HasValue(charCode, &i)
			return AltCodesLibrary[i + 1]

		Keyboard.CheckLayout(&lang)

		codePage := StrLen(charCode) > 1 && charCode ~= "^0" ? ((lang = "ru") ? 1251 : 1252) : Number(charCode) >= 128 ? ((lang = "ru") ? 866 : 850) : 437

		bytes := Buffer(1)
		NumPut("UChar", charCode, bytes)

		chars := StrGet(bytes, 1, "CP" codePage)

		return chars
	}

	static GetAltcode(char, page := 437) {
		if StrLen(char) = 0
			return -1

		try {
			Loop 256 {
				b := A_Index - 1
				buf := Buffer(1)
				NumPut("UChar", b, buf)
				result := StrGet(buf, 1, "CP" page)
				if result = char
					return b
			}
		} catch {
			return -1
		}

		return -1
	}

	static Unicode(charCode) {
		charCode := Format("0x" charCode, "d")
		return Chr(charCode)
	}

	static AltcodeValidate(charCode) {
		return StrLen(charCode) > 0 && (charCode ~= "^[0-9]{1,4}$") && (Number(charCode) >= 0) && Number(charCode) <= 255
	}

	static UnicodeValidate(charCode) {
		if charCode ~= "i)[АБСЦДЕФ]"
			charCode := Util.HexCyrToLat(charCode)
		if charCode ~= "^(?![0-9A-Fa-f]{1,6}$)"
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

		return code <= 0x10FFFF
	}
}