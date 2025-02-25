Class Language {

	static supported := Map(
		"en", { code: "00000409", locale: True, bindings: True },
		"ru", { code: "00000419", locale: True, bindings: True },
		"gr", { code: "00000408", locale: False },
	)

	static locales := App.paths.ufile "\DSLKeyPad.locales.ini"
	static localeObj := {}

	static __New() {
		this.FillLocalizedObject()
	}

	static Validate(input, extraRule?) {
		if StrLen(input) > 5 {
			for key, value in this.supported {
				extraRuleValidate := (!IsSet(extraRule) || IsSet(extraRule) && (HasProp(value, extraRule) ? value.%extraRule% : False))

				if input == value.code && extraRuleValidate {
					return True
				}
			}
		} else if StrLen(input) > 0 {
			extraRuleValidate := (!IsSet(extraRule) || IsSet(extraRule) && (HasProp(this.supported[input], extraRule) ? this.supported[input].%extraRule% : False))

			if this.supported.Has(input) && extraRuleValidate {
				return True
			}
		}

		return False
	}

	static FillLocalizedObject() {
		pathsArray := []

		for lang, value in this.supported {
			if value.locale {
				pathsArray.Push(App.paths.loc "\" lang ".ini")
			}
		}

		Loop Files App.paths.loc "\Automated\*", "D" {
			Loop Files A_LoopFileFullPath "\*.ini" {
				pathsArray.Push(A_LoopFileFullPath)
			}
		}

		Loop Files App.paths.loc "\Automated\*.ini" {
			pathsArray.Push(A_LoopFileFullPath)
		}

		this.localeObj := Util.MultiINIToObj(pathsArray)
	}

	static Set(value) {
		if this.Validate(value, "locale") {
			Cfg.Set(value, "User_Language")
		}
	}

	static Get() {
		userLanguage := Cfg.Get("User_Language")
		userLanguage := userLanguage != "" ? userLanguage : this.GetSys()

		if this.Validate(userLanguage) {
			return userLanguage
		} else {
			return "en"
		}
	}

	static GetSys() {
		return SubStr(RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName"), 1, 2)
	}
}

Class Keyboard extends Language {

	static disabledByMonitor := False
	static disabledByUser := False

	static __New() {
		this.InitialValidator()

		SetTimer((*) => SetTimer((*) => this.Monitor(), 2000), -10000)
	}

	static Monitor() {
		isCurrentLanguageValid := this.Validate(this.CurrentLayout(), "bindings")

		if isCurrentLanguageValid && !this.disabledByUser {
			this.BindingsToggle(True)
		} else if (!isCurrentLanguageValid || A_TimeIdle > 1 * hour) && !this.disabledByUser {
			this.BindingsToggle(False)
		}
	}

	static BindingsToggle(enable := True, rule := "disabledByMonitor", addRule?) {
		if enable && (!IsSet(addRule) || IsSet(addRule) && !this.%addRule%) {
			if this.%rule% {
				this.%rule% := False
				UnregisterKeysLayout()
				RegisterLayout(Cfg.Get("Layout_Latin", , "QWERTY"))
			}
		} else if !this.%rule% && (!IsSet(addRule) || IsSet(addRule) && !this.%addRule%) {
			this.%rule% := True
			UnregisterKeysLayout()
		}

		ManageTrayItems()
	}

	static CurrentLayout(&layoutHex?) {
		threadId := DllCall("GetWindowThreadProcessId", "UInt", DllCall("GetForegroundWindow", "UInt"), "UInt", 0)
		layout := DllCall("GetKeyboardLayout", "UInt", threadId, "UPtr")
		layoutHex := Format("{:08X}", layout & 0xFFFF)
		return layoutHex
	}

	static SwitchLayout(code, id := 1, timer := 1) {
		SetTimer((*) => SwitchCall(), -timer)
		SwitchCall() {
			layout := DllCall("LoadKeyboardLayout", "Str", code, "Int", id)
			hwnd := DllCall("GetForegroundWindow")
			pid := DllCall("GetWindowThreadProcessId", "UInt", hwnd, "Ptr", 0)
			DllCall("PostMessage", "UInt", hwnd, "UInt", 0x50, "UInt", 0, "UInt", layout)
		}
	}

	static CheckLayout(abbr) {
		this.CurrentLayout(&code)

		if !IsObject(abbr) {
			for key, value in this.supported {
				if abbr == key && code == value.code {
					return True
				}
			}
			return False
		} else {
			for key, value in this.supported {
				if code == value.code {
					%abbr% := key
					break
				} else {
					%abbr% := ""
				}
			}
		}
	}

	static InitialValidator() {
		currentLayout := this.CurrentLayout()
		previousLeyout := Cfg.Get("Prev_Layout", "ServiceFields")

		if currentLayout != this.supported["en"].code {
			Cfg.Set(currentLayout, "Prev_Layout", "ServiceFields")
			this.SwitchLayout(this.supported["en"].code, 2)
			Reload
		} else if StrLen(previousLeyout) > 0 {
			this.SwitchLayout(previousLeyout, 2, 150)
			Cfg.Set("", "Prev_Layout", "ServiceFields")
		}
	}
}

Class Locale extends Language {

	static HandleString(str) {
		str := StrReplace(str, "\R2", "`r`n`r`n", True)
		str := StrReplace(str, "\R", "`r`n", True)
		str := StrReplace(str, "\r", "`r", True)
		str := StrReplace(str, "\n", "`n")
		str := StrReplace(str, "\t", "`t")

		return str
	}

	static ReadStr(section, entry) {
		return (this.localeObj.HasOwnProp(section) && this.localeObj.%section%.HasOwnProp(entry))
			? this.localeObj.%section%.%entry% : ""
	}

	static Read(EntryName, Prefix := "", validate := False, &output?) {
		Intermediate := ""
		Section := Prefix != "" ? Prefix . "_" . this.Get() : this.Get()
		try {
			;Intermediate := IniRead(this.locales, Section, EntryName, "")
			Intermediate := this.ReadStr(Section, EntryName)

			while (RegExMatch(Intermediate, "\{([a-zA-Z]{2})\}", &match)) {
				LangCode := match[1]
				SectionOverride := Prefix != "" ? Prefix . "_" . LangCode : LangCode
				Replacement := this.ReadStr(SectionOverride, EntryName)
				Intermediate := StrReplace(Intermediate, match[0], Replacement)
			}

			while (RegExMatch(Intermediate, "\{(?:([^\}_]+)_)?([a-zA-Z]{2}):([^\}]+)\}", &match)) {
				CustomPrefix := match[1] ? match[1] : ""
				LangCode := match[2]
				CustomEntry := match[3]
				SectionOverride := CustomPrefix != "" ? CustomPrefix . "_" . LangCode : LangCode
				Replacement := this.ReadStr(SectionOverride, CustomEntry)
				Intermediate := StrReplace(Intermediate, match[0], Replacement)
			}

			while (RegExMatch(Intermediate, "\{U\+(\w+)\}", &match)) {
				Unicode := match[1]
				Replacement := Chr("0x" . Unicode)
				Intermediate := StrReplace(Intermediate, match[0], Replacement)
			}

			while (RegExMatch(Intermediate, "\{var:([^\}]+)\}", &match)) {
				Varname := match[1]
				if IsSet(%Varname%) {
					Replacement := %Varname%
				} else {
					Replacement := "VAR (" . Varname . "): NOT FOUND"
				}
				Intermediate := StrReplace(Intermediate, match[0], Replacement)
			}
			Intermediate := this.HandleString(Intermediate)
		}


		if validate {
			output := Intermediate
			return StrLen(Intermediate) > 0
		} else {
			Intermediate := Intermediate != "" ? Intermediate : "KEY (" . EntryName . "): NOT FOUND"
			return Intermediate
		}
	}
}