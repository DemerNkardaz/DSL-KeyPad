Class LocaleGenerator {
	Generate(entryName, entry) {
		local originalName := entryName
		local nbsp := Chr(160)
		local pfx := "generated."

		local useLetterLocale := entry["options"]["useLetterLocale"]
		local scriptAdditive := entry["symbol"]["scriptAdditive"] != "" ? "_" entry["symbol"]["scriptAdditive"] : ""

		local cyrillicTasgScriptAtStart := False

		if ChrLib.scriptsValidator.HasRegEx(entryName, &i, ["^", "_"], ["sidetic", "glagolitic", "tolkien_runic"]) {
			useLetterLocale := True
			cyrillicTasgScriptAtStart := True
		}

		local referenceLocale := entry["options"].Has("referenceLocale") && entry["options"]["referenceLocale"] != "" ? entry["options"]["referenceLocale"] : False

		local useSelfPrefixesOnReferenceLocale := entry["options"]["useSelfPrefixesOnReferenceLocale"]

		local LTLReference := False

		local entryData := entry["data"].Clone()
		local entrySymbol := entry["symbol"].Clone()

		if referenceLocale {
			if !(referenceLocale ~= "i)^:") {
				local referenceName := entryName
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
				entryData.postfixes := entry["data"]["postfixes"].Clone()
		}

		local letter := (entrySymbol.Has("letter") && StrLen(entrySymbol["letter"]) > 0) ? entrySymbol["letter"] : entryData["letter"]
		local lScript := entryData["script"]
		local lOriginScript := entryData["originScript"]
		local lCase := entryData["case"]
		local lType := entryData["type"]
		local lPostfixes := entryData["postfixes"]
		local lVariant := ["digraph", "symbol", "sign", "syllable", "glyph"].HasValue(lType) ? 2 : lType = "numeral" ? 3 : 1

		local hasScript := lScript != ""
		local isGermanic := ["germanic_runic", "cirth_runic"].HasValue(lScript)

		local langCodes := ["en-US", "ru-RU", "en-US_alt", "ru-RU_alt"]
		local tags := Map()
		entry["titles"] := Map()

		local ref := LTLReference ? LTLReference : entryName

		for _, langCode in langCodes {
			local isAlt := InStr(langCode, "_alt")
			local lang := isAlt ? RegExReplace(langCode, "_alt") : langCode

			local interLetter := ref ".letter_locale"

			if useLetterLocale {
				if RegExMatch(useLetterLocale, "i)^(.*?)\$", &refMatch)
					interLetter := RegExReplace(entryName, "i)^(.*?" RegExReplace(refMatch[1], "([\\.\^$*+?()[\]{}|])", "\$1") ").*", "$1") ".letter_locale"
				else if useLetterLocale = "Origin"
					interLetter := RegExReplace(ref, "i)^(.*?)__.*", "$1") ".letter_locale"

				if hasScript
					interLetter := RegExReplace(interLetter, "^" lOriginScript "_", "scripts." lScript ".")
			}

			local postLetter := useLetterLocale ? Locale.Read(interLetter, lang) : letter

			local lBeforeletter := ""
			local lAfterletter := ""
			local lSecondName := ""

			if entry["options"]["secondName"] {
				if hasScript
					ref := RegExReplace(ref, "^" lOriginScript "_", "scripts." lScript ".")

				lSecondName := " " Locale.Read(("Origin" ? RegExReplace(ref, "i)^(.*?)__.*", "$1") : ref) ".second_name", lang)
			}

			for letterBound in ["beforeLetter", "afterLetter"] {
				if entry["symbol"].Has(letterBound) && StrLen(entry["symbol"][letterBound]) > 0 {
					local boundLink := Util.StrUpper(letterBound, 1)
					local entryBoundReference := entry["symbol"][letterBound]
					local splitted := StrSplit(Util.StrTrim(entry["symbol"][letterBound]), ",")

					local localeKey := RegExReplace(letterBound, "Letter", "_letter")

					for i, bound in splitted {
						if RegExMatch(bound, "\:\:(.*?)$", &match) {
							local index := Integer(match[1])
							local bound := SubStr(bound, 1, match.Pos(0) - 1)
							l%boundLink% .= Locale.VariantSelect(Locale.Read(pfx localeKey "." bound, lang), index) (i < splitted.Length ? " " : "")
						} else
							l%boundLink% .= Locale.VariantSelect(Locale.Read(pfx localeKey "." bound, lang), 1) (i < splitted.Length ? " " : "")
					}
				}
			}

			lBeforeletter := StrLen(lBeforeletter) > 0 ? lBeforeletter " " : ""
			lAfterletter := StrLen(lAfterletter) > 0 ? " " lAfterletter : ""

			local proxyMark := StrLen(entry["proxy"]) > 0 ? " " Locale.Read("gen.proxy", lang) : ""

			if isAlt {
				entry["titles"][langCode] := Util.StrUpper(Locale.Read(pfx "type." lType, lang), 1) " " lBeforeletter postLetter lAfterletter lSecondName proxyMark
			} else {
				localedCase := lCase != "neutral" ? Locale.VariantSelect(Locale.Read(pfx "case." lCase, lang), lVariant) " " : ""

				entry["titles"][langCode] := (
					Locale.VariantSelect(Locale.Read(pfx "prefix." lScript (!isGermanic ? scriptAdditive : ""), lang), lVariant)
					" "
					localedCase Locale.Read(pfx "type." lType, lang)
					(isGermanic && scriptAdditive != "" ? " " Locale.VariantSelect(Locale.Read(pfx "prefix." lScript scriptAdditive, lang), lVariant) : "")
					" "
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
					proxyMark
				)
				tags[langCode] := (
					(!isGermanic ? localedCase Locale.Read(pfx "type." lType, lang) " " : "")
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
				)
			}
		}

		if lPostfixes.Length > 0 {
			for _, langCode in langCodes {
				local lang := InStr(langCode, "_alt") ? RegExReplace(langCode, "_alt") : langCode
				local postfixText := ""

				postfixText .= " {conjuction}" nbsp Locale.Read(pfx "postfix." lPostfixes[1], lang)

				Loop lPostfixes.Length - 2
					postfixText .= ", " Locale.Read(pfx "postfix." lPostfixes[A_Index + 1], lang)

				if lPostfixes.Length > 1
					postfixText .= " " Locale.Read(pfx "postfix.and", lang) nbsp Locale.Read(pfx "postfix." lPostfixes[lPostfixes.Length], lang)

				entry["titles"][langCode] .= postfixText

				if !InStr(langCode, "_alt") {
					tags[langCode] .= postfixText
				}
			}
		}

		tagScriptAdditive := Map(
			"en-US", scriptAdditive ? " " Locale.VariantSelect(Locale.Read(pfx "tag." lScript (scriptAdditive), "en-US"), lVariant) : "",
			"ru-RU", scriptAdditive ? " " Locale.VariantSelect(Locale.Read(pfx "tag." lScript (scriptAdditive), "ru-RU"), lVariant) : "",
		)

		tags["en-US"] := (
			Locale.VariantSelect(Locale.Read(pfx "tag." lScript, "en-US"), lVariant)
			(isGermanic ? " " Locale.Read(pfx "type." lType, "en-US") : "")
			tagScriptAdditive["en-US"] " "
			tags["en-US"]
		)
		tags["ru-RU"] := (
			cyrillicTasgScriptAtStart ?
				(
					Locale.VariantSelect(Locale.Read(pfx "tag." lScript, "ru-RU"), lVariant)
					(isGermanic ? " " Locale.Read(pfx "type." lType, "ru-RU") : "")
					tagScriptAdditive["ru-RU"] " "
					tags["ru-RU"]
				)
			: (
				tags["ru-RU"]
				" "
				Locale.VariantSelect(Locale.Read(pfx "tag." lScript, "ru-RU"), lVariant)
			)
		)

		for _, langCode in langCodes {
			entry["titles"][langCode] := this.LocaleRules(entry["titles"][langCode], langCode)
			if !InStr(langCode, "_alt") {
				tags[langCode] := this.LocaleRules(tags[langCode], langCode)
			}
		}

		local hasTags := entry["tags"].Length > 0
		local tagIndex := 0
		for tag in tags {
			tagIndex++
			entry["tags"].InsertAt(tagIndex, tags[tag])
		}

		local additionalTags := []
		if entry["symbol"]["tagAdditive"].Length > 0 && isGermanic {
			for tagAdd in entry["symbol"]["tagAdditive"] {
				for lang in ["en-US", "ru-RU"] {
					local curScript := (tagAdd.Has("script") ? tagAdd.script : lScript)
					local curType := (tagAdd.Has("type") ? tagAdd.type : lType)
					local aLScript := Locale.VariantSelect(Locale.Read(pfx "tag." curScript, lang), lVariant)
					local aScriptAdditive := Locale.VariantSelect(Locale.Read(pfx "tag." curScript "." tagAdd["scriptAdditive"], lang), lVariant)
					local aLType := Locale.VariantSelect(Locale.Read(pfx "type." curType, lang), lVariant)
					local lBuildedName := StrLower(curScript "_n_" curType "_" letter "_" tagAdd["scriptAdditive"] "_" tagAdd["letter"]) ".letter_locale"

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
				entry["tags"].Push(tag)
			}
		}

		if entry["tags"].Length > 0 {
			sorting := Map()
			for i, tag in entry["tags"]
				sorting.Set(tag, i)

			entry["tags"] := sorting.Keys()
		}

		return entry
	}

	LocaleRules(input, lang) {
		lang := RegExReplace(lang, "_alt")
		nbsp := Chr(160)
		rules := Map(
			"ru-RU", Map(
				"conjunction", (str) => (InStr(str, "{conjuction}" nbsp "с") || InStr(str, "{conjuction}" nbsp "ш")) ? RegExReplace(str, "\{conjuction\}", Locale.Read("generated.postfix.with_2", lang)) : RegExReplace(str, "\{conjuction\}", Locale.Read("generated.postfix.with", lang))
			),
			"en-US", Map(
				"conjunction", (str) => RegExReplace(str, "\{conjuction\}", Locale.Read("generated.postfix.with", lang)
				)
			)
		)

		for key, rule in rules[lang] {
			input := rule(input)
		}

		return input
	}
}