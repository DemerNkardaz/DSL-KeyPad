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

	static GetSupported(by := "locale") {
		output := []

		for key, value in this.supported {
			if value.%by% {
				output.Push(key)
			}
		}
		return output
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

	static Get(language := "") {
		userLanguage := StrLen(language) > 0 ? language : Cfg.Get("User_Language")
		userLanguage := !IsSpace(userLanguage) ? userLanguage : this.GetSys()

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

	static localesPath := A_ScriptDir "\Locale\"

	static OpenDir(*) {
		Run(this.localesPath)
	}

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
		Section := this.Validate(Prefix) ? Prefix : (!IsSpace(Prefix) ? Prefix "_" this.Get() : this.Get())
		try {
			;Intermediate := IniRead(this.locales, Section, EntryName, "")
			Intermediate := this.ReadStr(Section, EntryName)

			while (RegExMatch(Intermediate, "\{([a-zA-Z]{2})\}", &match)) {
				LangCode := match[1]
				SectionOverride := !IsSpace(Prefix) ? Prefix "_" LangCode : LangCode
				Replacement := this.ReadStr(SectionOverride, EntryName)
				Intermediate := StrReplace(Intermediate, match[0], Replacement)
			}

			while (RegExMatch(Intermediate, "\{(?:([^\}_]+)_)?([a-zA-Z]{2}):([^\}]+)\}", &match)) {
				CustomPrefix := match[1] ? match[1] : ""
				LangCode := match[2]
				CustomEntry := match[3]
				SectionOverride := !IsSpace(CustomPrefix) ? CustomPrefix "_" LangCode : LangCode
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
					Replacement := "VAR (" Varname "): NOT FOUND"
				}
				Intermediate := StrReplace(Intermediate, match[0], Replacement)
			}
			Intermediate := this.HandleString(Intermediate)
		}


		if validate {
			output := Intermediate
			return StrLen(Intermediate) > 0
		} else {
			Intermediate := !IsSpace(Intermediate) ? Intermediate : "KEY (" EntryName "): NOT FOUND"
			return Intermediate
		}
	}

	static VarSelect(str, varI) {
		output := str
		if (RegExMatch(str, "\$\((.*?)\)", &match)) {
			split := StrSplit(match[1], "|")
			if (varI > 0 && varI <= split.Length) {
				beforePart := SubStr(str, 1, match.Pos(0) - 1)
				afterPart := SubStr(str, match.Pos(0) + match.Len(0))
				output := beforePart split[varI] afterPart
			}
		}
		return output
	}

	static LocaleRules(input, lang) {
		lang := SubStr(lang, 1, 2)
		nbsp := Chr(160)
		rules := Map(
			"ru", Map(
				"conjunction", (str) => (InStr(str, "{conjuction}" nbsp "с") || InStr(str, "{conjuction}" nbsp "ш")) ? RegExReplace(str, "\{conjuction\}", Locale.Read("gen_postfix_with_2", lang)) : RegExReplace(str, "\{conjuction\}", Locale.Read("gen_postfix_with", lang))
			),
			"en", Map(
				"conjunction", (str) => RegExReplace(str, "\{conjuction\}", Locale.Read("gen_postfix_with", lang)
				)
			)
		)

		for key, rule in rules[lang] {
			input := rule(input)
		}

		return input
	}

	static LocalesGeneration(entryName, entry) {
		nbsp := Chr(160)
		pfx := "gen_"
		useLetterLocale := entry.options.HasOwnProp("useLetterLocale") ? entry.options.useLetterLocale : False
		letter := (entry.symbol.HasOwnProp("letter") && StrLen(entry.symbol.letter) > 0) ? entry.symbol.letter : entry.data.letter
		lScript := entry.data.script
		lCase := entry.data.case
		lType := entry.data.type
		lPostfixes := entry.data.postfixes
		lVariant := lType = "digraph" ? 2 : lType = "numeral" ? 3 : 1

		langCodes := ["en", "ru", "en_alt", "ru_alt"]
		entry.titles := Map()
		tags := Map()

		for _, langCode in langCodes {
			isAlt := InStr(langCode, "_alt")
			lang := isAlt ? SubStr(langCode, 1, 2) : langCode
			postLetter := useLetterLocale ? Locale.Read((useLetterLocale = "Origin" ? RegExReplace(entryName, "i)^(.*?)__.*", "$1") : entryName) "_LTL", lang) : letter

			lBeforeletter := ""
			lAfterletter := ""
			lSecondName := ""

			if entry.options.secondName {
				lSecondName := " " Locale.Read(entryName "_sN", lang)
			}

			for letterBound in ["beforeLetter", "afterLetter"] {
				if entry.symbol.HasOwnProp(letterBound) && StrLen(entry.symbol.%letterBound%) > 0 {
					boundLink := Util.StrUpper(letterBound, 1)
					if InStr(entry.symbol.%letterBound%, ",") {
						splitted := StrSplit(Util.StrTrim(entry.symbol.%letterBound%), ",")
						for i, bound in splitted {
							l%boundLink% .= Locale.Read(pfx letterBound "_" bound, lang) (i < splitted.Length ? " " : "")
						}
					} else
						l%boundLink% := Locale.Read(pfx letterBound "_" entry.symbol.%boundLink%, lang)
				}
			}

			lBeforeletter := StrLen(lBeforeletter) > 0 ? lBeforeletter " " : ""
			lAfterletter := StrLen(lAfterletter) > 0 ? " " lAfterletter : ""

			proxyMark := StrLen(entry.proxy) > 0 ? " " Locale.Read("gen_proxy", lang) : ""


			if isAlt {
				entry.titles[langCode] := Util.StrUpper(Locale.Read(pfx "type_" lType, lang), 1) " " lBeforeletter postLetter lAfterletter lSecondName proxyMark
			} else {
				localedCase := lCase != "neutral" ? Locale.VarSelect(Locale.Read(pfx "case_" lCase, lang), lVariant) " " : ""

				entry.titles[langCode] := Locale.Read(pfx "prefix_" lScript, lang) " " localedCase Locale.Read(pfx "type_" lType, lang) " " lBeforeletter postLetter lAfterletter lSecondName proxyMark
				tags[langCode] := localedCase Locale.Read(pfx "type_" lType, lang) " " lBeforeletter postLetter lAfterletter lSecondName
			}
		}

		if lPostfixes.Length > 0 {
			for _, langCode in langCodes {
				lang := InStr(langCode, "_alt") ? SubStr(langCode, 1, 2) : langCode
				postfixText := ""

				postfixText .= " {conjuction}" nbsp Locale.Read(pfx "postfix_" lPostfixes[1], lang)

				Loop lPostfixes.Length - 2
					postfixText .= ", " Locale.Read(pfx "postfix_" lPostfixes[A_Index + 1], lang)

				if lPostfixes.Length > 1
					postfixText .= " " Locale.Read(pfx "postfix_and", lang) nbsp Locale.Read(pfx "postfix_" lPostfixes[lPostfixes.Length], lang)

				entry.titles[langCode] .= postfixText

				if !InStr(langCode, "_alt") {
					tags[langCode] .= postfixText
				}
			}
		}

		tags["en"] := Locale.Read(pfx "tagScript_" lScript, "en") " " tags["en"]
		tags["ru"] := tags["ru"] " " Locale.Read(pfx "tagScript_" lScript, "ru")

		for _, langCode in langCodes {
			entry.titles[langCode] := this.LocaleRules(entry.titles[langCode], langCode)
			if !InStr(langCode, "_alt") {
				tags[langCode] := this.LocaleRules(tags[langCode], langCode)
			}
		}


		hasTags := entry.tags.Length > 0
		tagIndex := 0
		for tag in tags {
			tagIndex++
			entry.tags.InsertAt(tagIndex, tags[tag])
		}


		return entry
	}

}