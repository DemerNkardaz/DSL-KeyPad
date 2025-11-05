Class UnicodeWebResource {
	static resources := Map(
		"Compart", "https://www.compart.com/en/unicode/U+${Prompt}",
		"Codepoints", "https://codepoints.net/U+${Prompt}",
		"Unicode Plus", "https://unicodeplus.com/U+${Prompt}",
		"Decodeunicode", "https://decodeunicode.org/en/u+${Prompt}",
		"Util Unicode", "https://util.unicode.org/UnicodeJsps/character.jsp?a=${Prompt}",
		"Unicode Explorer", "https://unicode-explorer.com/c/${Prompt}",
		"Wiktionary (En)", "https://en.wiktionary.org/wiki/${0xPrompt}",
		"Wiktionary", "https://${language}.wiktionary.org/wiki/${0xPrompt}",
		"Wikipedia (En)", "https://en.wikipedia.org/wiki/${0xPrompt}",
		"Wikipedia", "https://${language}.wikipedia.org/wiki/${0xPrompt}",
		"SymblCC", "https://symbl.cc/${language}/${Prompt}",
	)

	__New(useType := "Clipboard", text := "") {
		if useType = "Clipboard" {
			Clip.CopySelected(&text, 0.25, "Backup & Release", ["Control", "Insert"])
			text := UnicodeUtils.SubStr(text, 1, 1)
			text := UnicodeUtils.GetCodePoint(text)
		}

		if text != "" {
			local codeURL := UnicodeWebResource.CodeHandler(text)
			Run(codeURL)
		}
	}

	static GetCurrentResource() {
		return Cfg.Get("Unicode_Web_Resource", , "SymblCC")
	}

	static CodeHandler(code) {
		resource := Cfg.Get("Unicode_Web_Resource", , "SymblCC")
		useSystemLanguage := Cfg.Get("Unicode_Web_Resource_Use_System_Language", , False, "bool")
		resource := UnicodeWebResource.resources.Has(resource)
			? UnicodeWebResource.resources.Get(resource)
			: UnicodeWebResource.resources.Get("SymblCC")
		lang := useSystemLanguage ? Language.GetSys(2) : Language.Get(, , 2)

		resource := StrReplace(resource, "${language}", lang)
		resource := StrReplace(resource, "${Prompt}", code)
		resource := StrReplace(resource, "${0xPrompt}", Chr("0x" code))

		return resource
	}
}

Class UnicodeBlockWebResource {
	static resources := Map(
		"Compart", "https://www.compart.com/en/unicode/block/U+${CodePrompt}",
		"Codepoints", "https://codepoints.net/${Name_Prompt}",
		"Unicode Plus", "https://unicodeplus.com/block/${CodePrompt}",
		"Util Unicode", "https://util.unicode.org/UnicodeJsps/list-unicodeset.jsp?a=[:Block=${Name_Prompt}:]",
		"Unicode Explorer", "https://unicode-explorer.com/b/${CodePrompt}",
		"Wiktionary (En)", "https://en.wiktionary.org/wiki/Appendix:Unicode/${Name_Prompt}",
		"SymblCC", "https://symbl.cc/${language}/unicode/blocks/${Name-Prompt}",
	)

	__New(prompt := "") {
		if prompt != "" {
			RegExMatch(prompt, "i)^(.*?)\.\.\.(.*?)\R(.*)", &m)

			codeURL := UnicodeBlockWebResource.CodeHandler(m[1], m[3])
			Run(codeURL)
		}
	}


	static GetCurrentResource() {
		resourceName := Cfg.Get("Unicode_Web_Resource", , "SymblCC")

		if !UnicodeBlockWebResource.resources.Has(resourceName)
			resourceName := RegExMatch(resourceName, "i)^Wik") ? "Wiktionary (En)" : "SymblCC"

		return resourceName
	}

	static CodeHandler(code, name) {
		resourceName := Cfg.Get("Unicode_Web_Resource", , "SymblCC")
		resource := ""
		useSystemLanguage := Cfg.Get("Unicode_Web_Resource_Use_System_Language", , False, "bool")

		if !UnicodeBlockWebResource.resources.Has(resourceName)
			resourceName := RegExMatch(resourceName, "i)^Wik") ? "Wiktionary (En)" : "SymblCC"

		resource := UnicodeBlockWebResource.resources.Get(resourceName)
		lang := useSystemLanguage ? Language.GetSys(2) : Language.Get(, , 2)

		switch resourceName {
			case "SymblCC", "Codepoints":
				name := StrLower(name)
			default:
				name := name
		}

		if resourceName = "SymblCC" && name ~= "greek.*coptic"
			name := "greek-coptic"


		resource := StrReplace(resource, "${language}", lang)
		resource := StrReplace(resource, "${CodePrompt}", code)
		resource := StrReplace(resource, "${Name_Prompt}", RegExReplace(name, "\s", "_"))
		resource := StrReplace(resource, "${Name-Prompt}", RegExReplace(name, "\s", "-"))

		return resource
	}
}