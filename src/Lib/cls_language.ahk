Class Language {
	static optionsFile := App.paths.loc "\locale.options.ini"
	static supported := Map()
	static links := Map()

	static __New() {
		this.Init()
	}

	static Init() {
		languages := Util.INIGetSections([this.optionsFile])

		for iso in languages {
			data := {
				parent: IniRead(this.optionsFile, iso, "parent", ""),
				title: IniRead(this.optionsFile, iso, "title", ""),
				code: IniRead(this.optionsFile, iso, "code", ""),
				locale: IniRead(this.optionsFile, iso, "is_locale", False),
				bindings: IniRead(this.optionsFile, iso, "is_bindings", False),
				altInput: IniRead(this.optionsFile, iso, "alt_input", ""),
			}

			data.code := data.code != "" ? Number(data.code) : ""
			data.locale := data.locale = "True" ? True : False
			data.bindings := data.bindings = "True" ? True : False

			this.supported.Set(iso, data)
			if data.code != ""
				this.links.Set(data.code, iso)
		}
	}

	static GetSupported(by := "locale", get := "key") {
		output := []

		for key, value in this.supported
			if value.%by% && !(value.code is String)
				output.Push(get = "key" ? key : value.title)

		return output
	}

	static Validate(input, extraRule?) {
		if input is Number && this.links.Has(input)
			input := this.links.Get(input)

		if input is String && input != "" {
			extraRuleValidate := (!IsSet(extraRule) || IsSet(extraRule) && (HasProp(this.supported[input], extraRule) ? this.supported[input].%extraRule% : False))

			if this.supported.Has(input) && extraRuleValidate
				return True
		}

		return False
	}

	static Set(value) {
		if this.Validate(value, "locale") {
			Cfg.Set(value, "User_Language")
		}
	}

	static Get(language := "", getTitle := False, endLen := 0) {
		userLanguage := language != "" ? language : Cfg.Get("User_Language")
		userLanguage := !IsSpace(userLanguage) ? userLanguage : this.GetSys()

		if this.Validate(userLanguage) {
			return getTitle ? this.supported.Get(userLanguage).title : endLen > 0 ? SubStr(userLanguage, 1, endLen) : userLanguage
		} else {
			return getTitle ? this.supported.Get("en-US").title : endLen > 0 ? SubStr("en-US", 1, endLen) : "en-US"
		}
	}

	static GetLanguageBlock(input, &output?) {
		output := False
		if input is Number && this.links.Has(input)
			input := this.links.Get(input)

		if input is String && input != ""
			if this.supported.Has(input)
				output := [input, this.supported.Get(input)]

		return output
	}

	static GetSys(endLen := 0) {
		regVal := RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName")
		return endLen > 0 ? SubStr(RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName"), 1, endLen) : regVal
	}
}

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
		if timer is Array
			SwitchCall()
		else
			SetTimer((*) => SwitchCall(), -timer)
		SwitchCall() {
			layout := DllCall("LoadKeyboardLayout", "Str", code, "Int", id)
			hwnd := DllCall("GetForegroundWindow")
			pid := DllCall("GetWindowThreadProcessId", "UInt", hwnd, "Ptr", 0)
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

		if currentLayout != Language.supported["en-US"].code {
			Cfg.Set(currentLayout, "Prev_Layout", "ServiceFields")
			this.SwitchLayout(Language.supported["en-US"].code, 2)
			this.blockedForReload := True
			Reload
		} else if StrLen(previousLeyout) > 0 {
			this.SwitchLayout(previousLeyout, 2, 150)
			Cfg.Set("", "Prev_Layout", "ServiceFields")
		}
	}
}

Class Locale {
	static localeObj := {}
	static localesPath := A_ScriptDir "\Locale\"

	static __New() {
		this.Fill()
	}

	static Fill() {
		this.localeObj := {}
		pathsArray := []

		for lang, value in Language.supported {
			if value.locale {
				pathsArray.Push(App.paths.loc "\locale_" lang ".ini")
			}
		}

		Loop Files App.paths.loc "\Automated\*", "FR" {
			if A_LoopFileFullPath ~= "i)\.ini$"
				pathsArray.Push(A_LoopFileFullPath)
		}

		this.localeObj := Util.MultiINIToObj(pathsArray)
	}

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

	static ReadNoLinks(entryName, inSection := "") {
		baseString := this.Read(entryName, inSection)
		result := baseString

		while (RegExMatch(result, "<a [^>]*>(.*?)</a>", &match)) {
			linkText := match[1]
			result := StrReplace(result, match[0], linkText)
		}

		return result
	}

	static ReadInject(entryName, strInjections := [], inSection := "", validate := False) {
		return this.Read(entryName, inSection, validate, , strInjections)
	}

	static ReadMulti(entryNames*) {
		output := ""

		for entryName in entryNames {
			output .= " " this.Read(entryName)
		}

		return output
	}

	static Read(entryName, inSection := "", validate := False, &output?, strInjections := []) {
		intermediate := ""
		section := Language.Validate(inSection) ? inSection : Language.Get()

		intermediate := this.ReadStr(section, entryName)

		while (RegExMatch(intermediate, "\{@([a-zA-Z-]*)(?::([^\}]+))?\}", &match)) {
			langCode := (match[1] != "" ? match[1] : section)
			customEntry := (match[2] != "" ? match[2] : entryName)
			replacement := this.ReadStr(langCode, customEntry)
			intermediate := StrReplace(intermediate, match[0], replacement)
		}

		while (RegExMatch(intermediate, "\{U\+(.*?)\}", &match)) {
			Unicode := StrSplit(match[1], ",")
			replacement := Util.UnicodeToChars(Unicode)
			intermediate := StrReplace(intermediate, match[0], replacement)
		}

		while (RegExMatch(intermediate, "\{var:([^\}]+)\}", &match)) {
			variableName := match[1]
			parts := StrSplit(variableName, ".")
			ref := %parts[1]%
			if (parts.Length > 1) {
				Loop parts.Length - 1 {
					ref := ref.%parts[A_Index + 1]%
				}
			}
			replacement := ref
			intermediate := StrReplace(intermediate, match[0], replacement)
		}

		intermediate := this.HandleString(intermediate)

		if validate {
			output := intermediate
			return StrLen(intermediate) > 0
		} else {
			intermediate := !IsSpace(intermediate) ? intermediate : "KEY (" entryName "): NOT FOUND in " section
			return strInjections ? Util.StrVarsInject(intermediate, strInjections) : intermediate
		}
	}

	static VarSelect(str, i) {
		output := str
		if (RegExMatch(str, "\$\((.*?)\)", &match)) {
			split := StrSplit(match[1], "|")
			if (i > 0 && i <= split.Length) {
				beforePart := SubStr(str, 1, match.Pos(0) - 1)
				afterPart := SubStr(str, match.Pos(0) + match.Len(0))
				output := beforePart split[i] afterPart
			}
		}
		return output
	}

	static LocaleRules(input, lang) {
		lang := RegExReplace(lang, "_alt")
		nbsp := Chr(160)
		rules := Map(
			"ru-RU", Map(
				"conjunction", (str) => (InStr(str, "{conjuction}" nbsp "с") || InStr(str, "{conjuction}" nbsp "ш")) ? RegExReplace(str, "\{conjuction\}", Locale.Read("gen_postfix_with_2", lang)) : RegExReplace(str, "\{conjuction\}", Locale.Read("gen_postfix_with", lang))
			),
			"en-US", Map(
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
		originalName := entryName
		nbsp := Chr(160)
		pfx := "gen_"

		useLetterLocale := entry.options.useLetterLocale
		scriptAdditive := entry.symbol.scriptAdditive != "" ? "_" entry.symbol.scriptAdditive : ""

		cyrillicTasgScriptAtStart := False

		if ChrLib.scriptsValidator.HasRegEx(entryName, &i, ["^", "_"], ["sidetic", "glagolitic"]) {
			useLetterLocale := True
			cyrillicTasgScriptAtStart := True
		}

		referenceLocale := entry.options.HasOwnProp("referenceLocale") && entry.options.referenceLocale != "" ? entry.options.referenceLocale : False

		useSelfPrefixesOnReferenceLocale := entry.options.useSelfPrefixesOnReferenceLocale

		LTLReference := False

		entryData := entry.data.Clone()
		entrySymbol := entry.symbol.Clone()

		if referenceLocale {
			if !(referenceLocale ~= "i)^:") {
				referenceName := entryName
				if RegExMatch(referenceLocale, "i)^(.*?)\$", &refMatch) {
					referenceName := RegExReplace(entryName, "i)^(.*?" RegExReplace(refMatch[1], "([\\.\^$*+?()[\]{}|])", "\$1") ").*", "$1")
				} else
					referenceName := referenceLocale

				if ChrLib.entries.HasOwnProp(referenceName) {
					entryData := ChrLib.GetValue(referenceName, "data").Clone()
					entrySymbol := ChrLib.GetValue(referenceName, "symbol").Clone()

				}

				entryName := referenceName
			} else {
				LTLReference := StrReplace(referenceLocale, ":", "")
			}

			if useSelfPrefixesOnReferenceLocale
				entryData.postfixes := entry.data.postfixes.Clone()
		}

		letter := (entrySymbol.HasOwnProp("letter") && StrLen(entrySymbol.letter) > 0) ? entrySymbol.letter : entryData.letter
		lScript := entryData.script
		lCase := entryData.case
		lType := entryData.type
		lPostfixes := entryData.postfixes
		lVariant := ["digraph", "symbol", "sign", "syllable", "glyph"].HasValue(lType) ? 2 : lType = "numeral" ? 3 : 1

		isGermanic := ["germanic_runic", "cirth_runic"].HasValue(lScript)

		langCodes := ["en-US", "ru-RU", "en-US_alt", "ru-RU_alt"]
		entry.titles := Map()
		tags := Map()

		ref := LTLReference ? LTLReference : entryName

		for _, langCode in langCodes {
			isAlt := InStr(langCode, "_alt")
			lang := isAlt ? RegExReplace(langCode, "_alt") : langCode

			interLetter := ref "_LTL"

			if useLetterLocale {
				if RegExMatch(useLetterLocale, "i)^(.*?)\$", &refMatch)
					interLetter := RegExReplace(entryName, "i)^(.*?" RegExReplace(refMatch[1], "([\\.\^$*+?()[\]{}|])", "\$1") ").*", "$1") "_LTL"
				else if useLetterLocale = "Origin"
					interLetter := RegExReplace(ref, "i)^(.*?)__.*", "$1") "_LTL"
			}

			postLetter := useLetterLocale ? Locale.Read(interLetter, lang) : letter

			lBeforeletter := ""
			lAfterletter := ""
			lSecondName := ""

			if entry.options.secondName {
				lSecondName := " " Locale.Read(("Origin" ? RegExReplace(ref, "i)^(.*?)__.*", "$1") : ref) "_sN", lang)
			}

			for letterBound in ["beforeLetter", "afterLetter"] {
				if entry.symbol.HasOwnProp(letterBound) && StrLen(entry.symbol.%letterBound%) > 0 {
					boundLink := Util.StrUpper(letterBound, 1)
					entryBoundReference := entry.symbol.%letterBound%
					splitted := StrSplit(Util.StrTrim(entry.symbol.%letterBound%), ",")

					for i, bound in splitted {
						if RegExMatch(bound, "\:\:(.*?)$", &match) {
							index := Integer(match[1])
							bound := SubStr(bound, 1, match.Pos(0) - 1)
							l%boundLink% .= Locale.VarSelect(Locale.Read(pfx letterBound "_" bound, lang), index) (i < splitted.Length ? " " : "")
						} else
							l%boundLink% .= Locale.VarSelect(Locale.Read(pfx letterBound "_" bound, lang), 1) (i < splitted.Length ? " " : "")
					}
				}
			}


			lBeforeletter := StrLen(lBeforeletter) > 0 ? lBeforeletter " " : ""
			lAfterletter := StrLen(lAfterletter) > 0 ? " " lAfterletter : ""

			proxyMark := StrLen(entry.proxy) > 0 ? " " Locale.Read("gen_proxy", lang) : ""


			if isAlt {
				entry.titles[langCode] := Util.StrUpper(Locale.Read(pfx "type_" lType, lang), 1) " " lBeforeletter postLetter lAfterletter lSecondName proxyMark
			} else {
				localedCase := lCase != "neutral" ? Locale.VarSelect(Locale.Read(pfx "case_" lCase, lang), lVariant) " " : ""

				entry.titles[langCode] := (
					Locale.VarSelect(Locale.Read(pfx "prefix_" lScript (!isGermanic ? scriptAdditive : ""), lang), lVariant)
					" "
					localedCase Locale.Read(pfx "type_" lType, lang)
					(isGermanic && scriptAdditive != "" ? " " Locale.VarSelect(Locale.Read(pfx "prefix_" lScript scriptAdditive, lang), lVariant) : "")
					" "
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
					proxyMark
				)
				tags[langCode] := (
					(!isGermanic ? localedCase Locale.Read(pfx "type_" lType, lang) " " : "")
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
				)
			}
		}

		if lPostfixes.Length > 0 {
			for _, langCode in langCodes {
				lang := InStr(langCode, "_alt") ? RegExReplace(langCode, "_alt") : langCode
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

		tagScriptAdditive := Map(
			"en-US", scriptAdditive ? " " Locale.VarSelect(Locale.Read(pfx "tagScript_" lScript (scriptAdditive), "en-US"), lVariant) : "",
			"ru-RU", scriptAdditive ? " " Locale.VarSelect(Locale.Read(pfx "tagScript_" lScript (scriptAdditive), "ru-RU"), lVariant) : "",
		)

		tags["en-US"] := (
			Locale.VarSelect(Locale.Read(pfx "tagScript_" lScript, "en-US"), lVariant)
			(isGermanic ? " " Locale.Read(pfx "type_" lType, "en-US") : "")
			tagScriptAdditive["en-US"] " "
			tags["en-US"]
		)
		tags["ru-RU"] := (
			cyrillicTasgScriptAtStart ?
				(
					Locale.VarSelect(Locale.Read(pfx "tagScript_" lScript, "ru-RU"), lVariant)
					(isGermanic ? " " Locale.Read(pfx "type_" lType, "ru-RU") : "")
					tagScriptAdditive["ru-RU"] " "
					tags["ru-RU"]
				)
			: (
				tags["ru-RU"]
				" "
				Locale.VarSelect(Locale.Read(pfx "tagScript_" lScript, "ru-RU"), lVariant)
			)
		)

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

		additionalTags := []
		if entry.symbol.tagAdditive.Length > 0 && isGermanic {
			for tagAdd in entry.symbol.tagAdditive {
				for lang in ["en-US", "ru-RU"] {
					local curScript := (tagAdd.HasOwnProp("script") ? tagAdd.script : lScript)
					local curType := (tagAdd.HasOwnProp("type") ? tagAdd.type : lType)
					local aLScript := Locale.VarSelect(Locale.Read(pfx "tagScript_" curScript, lang), lVariant)
					local aScriptAdditive := Locale.VarSelect(Locale.Read(pfx "tagScript_" curScript "_" tagAdd.scriptAdditive, lang), lVariant)
					local aLType := Locale.VarSelect(Locale.Read(pfx "type_" curType, lang), lVariant)
					local lBuildedName := StrLower(curScript "_n_" curType "_" letter "_" tagAdd.scriptAdditive "_" tagAdd.letter) "_LTL"

					additionalTags.Push(
						aLScript
						" " aLType " "
						aScriptAdditive " "
						Locale.Read(lBuildedName, lang)
					)
				}
			}
		}


		if additionalTags.Length > 0 {
			for tag in additionalTags {
				entry.tags.Push(tag)
			}
		}

		if entry.tags.Length > 0 {
			sorting := Map()
			for i, tag in entry.tags
				sorting.Set(tag, i)

			entry.tags := sorting.Keys()
		}

		return entry
	}

}