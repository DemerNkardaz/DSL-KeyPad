Class Keyboard {
	static disabledByMonitor := False
	static disabledByUser := False
	static blockedForReload := False
	static activeLanguage := ""

	static __New() {
	}

	static CurrentLayout(&layoutHex := "", toStr := False) {
		hwnd := DllCall("GetForegroundWindow", "UPtr")

		hIMC := DllCall("imm32\ImmGetContext", "UPtr", hwnd, "UPtr")

		layout := DllCall("imm32\ImmGetOpenStatus", "UPtr", hIMC) ?
			DllCall("imm32\ImmGetConversionStatus", "UPtr", hIMC, "UInt*", &mode := 0, "UInt*", &sentence := 0) : 0

		DllCall("imm32\ImmReleaseContext", "UPtr", hwnd, "UPtr", hIMC)

		threadId := DllCall("GetWindowThreadProcessId", "UPtr", hwnd, "UInt*", 0, "UInt")
		layoutID := DllCall("GetKeyboardLayout", "UInt", threadId, "UPtr")

		layoutHex := toStr ? Format("{:08X}", layoutID & 0xFFFF) : Number("0x" Format("{:X}", layoutID & 0xFFFF))
		return layoutHex
	}

	static SwitchLayout(code, id := 1, timer := 1) {
		code := "00000" SubStr(Format("0x{:X}", code), 3)
		if timer is Array
			SwitchCall()
		else
			SetTimer((*) => SwitchCall(), -timer)
		SwitchCall() {
			local layout := DllCall("LoadKeyboardLayout", "Str", code, "Int", id)
			local hwnd := DllCall("GetForegroundWindow")
			local pid := DllCall("GetWindowThreadProcessId", "UInt", hwnd, "Ptr", 0)
			DllCall("PostMessage", "UInt", hwnd, "UInt", 0x50, "UInt", 0, "UInt", layout)
		}
	}

	static CheckLayout(abbr) {
		this.CurrentLayout(&layoutHex)
		%abbr% := Language.links.Has(layoutHex) ? Language.links.Get(layoutHex) : ""
	}

	static InitialValidator() {
		currentLayout := this.CurrentLayout()
		previousLeyout := Cfg.Get("Prev_Layout", "ServiceFields")

		if currentLayout != Language.supported["en-US"]["code"] {
			Cfg.Set(currentLayout, "Prev_Layout", "ServiceFields")
			this.SwitchLayout(Language.supported["en-US"]["code"], 2)
			this.blockedForReload := True
			Reload
		} else if StrLen(previousLeyout) > 0 {
			this.SwitchLayout(previousLeyout, 2, 150)
			Cfg.Set("", "Prev_Layout", "ServiceFields")
		}
	}
}