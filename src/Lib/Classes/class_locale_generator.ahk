Class LocaleGenerator {
	Generate(entryName, entry) {
		local originalName := entryName
		local nbsp := Chr(160)
		local pfx := "generated."

		local useLetterLocale := entry["options"]["useLetterLocale"]
		local scriptAdditive := entry["symbol"]["scriptAdditive"] != "" ? "." entry["symbol"]["scriptAdditive"] : ""

		local tagScriptAtStart := False

		if ChrLib.scriptsValidator.HasRegEx(entryName, &i, ["^", "_"], ["sidetic", "glagolitic", "tolkien_runic"]) {
			if !useLetterLocale
				useLetterLocale := True
			tagScriptAtStart := True
		}

		local referenceLocale := entry["options"].Has("referenceLocale") && entry["options"]["referenceLocale"] != "" ? entry["options"]["referenceLocale"] : False

		local useSelfPostfixesOnReferenceLocale := entry["options"]["useSelfPostfixesOnReferenceLocale"]

		local LTLReference := False

		local entryData := entry["data"].Clone()
		local entrySymbol := entry["symbol"].Clone()

		local tagsCollector := Map("en-US", [], "ru-RU", [])

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

			if useSelfPostfixesOnReferenceLocale
				entryData["postfixes"] := entry["data"]["postfixes"].Clone()
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
			local lBeforeType := ""
			local lAfterType := ""
			local lSecondName := ""

			local copyNumber := entry["symbol"]["copyNumber"]
			local hasCopyNumber := copyNumber > 0
			local lCopyNumber := hasCopyNumber ? " [" copyNumber "]" : ""

			if entry["options"]["secondName"] {
				if hasScript
					ref := RegExReplace(ref, "^" lOriginScript "_", "scripts." lScript ".")

				lSecondName := " " Locale.Read(("Origin" ? RegExReplace(ref, "i)^(.*?)__.*", "$1") : ref) ".second_name", lang)
			}

			for letterBound in ["beforeLetter", "afterLetter", "beforeType", "afterType"] {
				if entry["symbol"].Has(letterBound) && StrLen(entry["symbol"][letterBound]) > 0 {
					local boundLink := Util.StrUpper(letterBound, 1)
					local entryBoundReference := entry["symbol"][letterBound]
					local splitted := StrSplit(Util.StrTrim(entry["symbol"][letterBound]), ",")

					local localeKey := RegExReplace(letterBound, "(Letter|Type)", "_letter")

					for i, bound in splitted {
						local titlelizeFirstLetter := bound ~= "i)^t\."
						local boundKey := RegExReplace(bound, "i)^t\.")

						if RegExMatch(boundKey, "<(!?)(.*?)>$", &languageRuleMatch) {
							local isBan := languageRuleMatch[1] = "!"
							local languageRule := languageRuleMatch[2]

							if !InStr(langCode, languageRule) && !isBan || InStr(langCode, languageRule) && isBan
								continue

							boundKey := RegExReplace(boundKey, languageRuleMatch[0])
						}

						if RegExMatch(boundKey, "\:\:(.*?)$", &match) {
							local index := Integer(match[1])
							local cleanBound := SubStr(boundKey, 1, match.Pos(0) - 1)
							l%boundLink% .= Locale.Read(pfx localeKey "." cleanBound, lang, , , , index) (i < splitted.Length ? " " : "")
						} else
							l%boundLink% .= Locale.Read(pfx localeKey "." boundKey, lang, , , , (InStr(boundLink, "Type") ? lVariant : 1)) (i < splitted.Length ? " " : "")

						if titlelizeFirstLetter
							l%boundLink% := Util.StrUpper(l%boundLink%, 1)
					}
				}
			}

			lBeforeletter := StrLen(lBeforeletter) > 0 ? lBeforeletter " " : ""
			lAfterletter := StrLen(lAfterletter) > 0 ? " " lAfterletter : ""
			lBeforeType := StrLen(lBeforeType) > 0 ? lBeforeType " " : ""
			lAfterType := StrLen(lAfterType) > 0 ? " " lAfterType : ""

			local proxyMark := StrLen(entry["proxy"]) > 0 ? " " Locale.Read("gen.proxy", lang) : ""

			if isAlt {
				entry["titles"][langCode] := Util.StrUpper(Locale.Read(pfx "type." lType, lang), 1) " " lBeforeletter postLetter lAfterletter lSecondName proxyMark
			} else {
				localedCase := lCase != "neutral" ? Locale.Read(pfx "case." lCase, lang, , , , lVariant) " " : ""

				entry["titles"][langCode] := (
					Locale.Read(pfx "prefix." lScript (!isGermanic ? scriptAdditive : ""), lang, , , , lVariant)
					" "
					lBeforeType
					localedCase Locale.Read(pfx "type." lType, lang)
					lAfterType
					(isGermanic && scriptAdditive != "" ? " " Locale.Read(pfx "prefix." lScript scriptAdditive, lang, , , , lVariant) : "")
					" "
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
					lCopyNumber
					proxyMark
				)
				tags[langCode] := (
					lBeforeType
					(!isGermanic ? localedCase Locale.Read(pfx "type." lType, lang) " " : "")
					lAfterType
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
					lCopyNumber
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
			"en-US", scriptAdditive ? " " Locale.Read(pfx "tag." lScript (scriptAdditive), "en-US", , , , lVariant) : "",
			"ru-RU", scriptAdditive ? " " Locale.Read(pfx "tag." lScript (scriptAdditive), "ru-RU", , , , lVariant) : "",
		)

		tags["en-US"] := (
			Locale.Read(pfx "tag." lScript, "en-US", , , , lVariant)
			(isGermanic ? " " Locale.Read(pfx "type." lType, "en-US") : "")
			tagScriptAdditive["en-US"] " "
			tags["en-US"]
		)

		tags["ru-RU"] := (
			tagScriptAtStart ?
				(
					Locale.Read(pfx "tag." lScript, "ru-RU", , , , lVariant)
					(isGermanic ? " " Locale.Read(pfx "type." lType, "ru-RU") : "")
					tagScriptAdditive["ru-RU"] " "
					tags["ru-RU"]
				)
			: (
				tags["ru-RU"]
				" "
				Locale.Read(pfx "tag." lScript, "ru-RU", , , , lVariant)
			)
		)

		tagsCollector["en-US"].Push(this.LocaleRules(tags["en-US"], "en-US"))
		tagsCollector["ru-RU"].Push(this.LocaleRules(tags["ru-RU"], "ru-RU"))

		for _, langCode in langCodes {
			entry["titles"][langCode] := this.LocaleRules(entry["titles"][langCode], langCode)
		}

		local additionalTags := []
		if entry["symbol"]["tagAdditive"].Length > 0 {
			for tagAdd in entry["symbol"]["tagAdditive"] {
				for lang in ["en-US", "ru-RU"] {
					if tagsCollector.Has(lang) {

						local curScript := (tagAdd.Has("script") ? tagAdd["script"] : lScript)
						local curType := (tagAdd.Has("type") ? tagAdd["type"] : lType)
						local curCase := (tagAdd.Has("case") ? tagAdd["case"] : lCase)
						local curLetter := (tagAdd.Has("letter") ? tagAdd["letter"] : letter)
						local curCopyNumber := (tagAdd.Has("copyNumber") ? tagAdd["copyNumber"] : copyNumber)
						local curHasCopyNumber := curCopyNumber > 0
						local curTagScriptAtStart := (tagAdd.Has("tagScriptAtStart") ? tagAdd["tagScriptAtStart"] : tagScriptAtStart)

						local curScriptKey := ChrLib.GetDecomposition("script", curScript, "Key", &curScriptDecomposeKey) ? curScriptDecomposeKey : curScript
						local curTypeKey := ChrLib.GetDecomposition("type", curType, "Key", &curTypeDecomposeKey) ? curTypeDecomposeKey : curType
						local curCaseKey := ChrLib.GetDecomposition("case", curCase, "Key", &curCaseDecomposeKey) ? curCaseDecomposeKey : curCase

						local hasScriptAdditive := tagAdd.Has("scriptAdditive") && StrLen(tagAdd["scriptAdditive"]) > 0
						local curScriptAdditive := hasScriptAdditive ? "." tagAdd["scriptAdditive"] : ""

						local curLVariant := ["digraph", "symbol", "sign", "syllable", "glyph"].HasValue(curType) ? 2 : curType = "numeral" ? 3 : 1
						local curIsGermanic := ["germanic_runic", "cirth_runic"].HasValue(curScript)

						local lAdditionalBeforeLetter := ""
						local lAdditionalAfterLetter := ""
						local lAdditionalBeforeType := ""
						local lAdditionalAfterType := ""
						local lAdditionalCopyNumber := curHasCopyNumber ? " [" curCopyNumber "]" : ""

						for letterBound in ["beforeLetter", "afterLetter", "beforeType", "afterType"] {
							if tagAdd.Has(letterBound) && StrLen(tagAdd[letterBound]) > 0 {
								local boundLink := Util.StrUpper(letterBound, 1)
								local splitted := StrSplit(Util.StrTrim(tagAdd[letterBound]), ",")
								local localeKey := RegExReplace(letterBound, "(Letter|Type)", "_letter")

								for i, bound in splitted {
									local titlelizeFirstLetter := bound ~= "i)^t\."
									local boundKey := RegExReplace(bound, "i)^t\.")

									if RegExMatch(boundKey, "<(!?)(.*?)>$", &languageRuleMatch) {
										local isBan := languageRuleMatch[1] = "!"
										local languageRule := languageRuleMatch[2]

										if !InStr(langCode, languageRule) && !isBan || InStr(langCode, languageRule) && isBan
											continue

										boundKey := RegExReplace(boundKey, languageRuleMatch[0])
									}

									if RegExMatch(boundKey, "\:\:(.*?)$", &match) {
										local index := Integer(match[1])
										local cleanBound := SubStr(boundKey, 1, match.Pos(0) - 1)
										lAdditional%boundLink% .= Locale.Read(pfx localeKey "." cleanBound, lang, , , , index) (i < splitted.Length ? " " : "")
									} else
										lAdditional%boundLink% .= Locale.Read(pfx localeKey "." boundKey, lang, , , , (InStr(boundLink, "Type") ? curLVariant : 1)) (i < splitted.Length ? " " : "")

									if titlelizeFirstLetter
										lAdditional%boundLink% := Util.StrUpper(lAdditional%boundLink%, 1)
								}
							}
						}

						lAdditionalBeforeLetter := StrLen(lAdditionalBeforeLetter) > 0 ? lAdditionalBeforeLetter " " : ""
						lAdditionalAfterLetter := StrLen(lAdditionalAfterLetter) > 0 ? " " lAdditionalAfterLetter : ""
						lAdditionalBeforeType := StrLen(lAdditionalBeforeType) > 0 ? lAdditionalBeforeType " " : ""
						lAdditionalAfterType := StrLen(lAdditionalAfterType) > 0 ? " " lAdditionalAfterType : ""

						if curIsGermanic {
							local lBuildedName := StrLower("scripts." curScript "." curCaseKey "_" curTypeKey "_" letter (hasScriptAdditive ? "_" tagAdd["scriptAdditive"] : "") "_" curLetter) ".letter_locale"
							local additionalPostLetter := Locale.Read(lBuildedName, lang)

							local aLScript := Locale.Read(pfx "tag." curScript, lang, , , , curLVariant)
							local aScriptAdditive := hasScriptAdditive ? " " Locale.Read(pfx "tag." curScript curScriptAdditive, lang, , , , curLVariant) : ""
							local aLType := Locale.Read(pfx "type." curType, lang)

							tagsCollector[lang].Push(
								aLScript
								lAdditionalBeforeType
								" " aLType
								lAdditionalAfterType
								aScriptAdditive " "
								lAdditionalBeforeLetter
								additionalPostLetter
								lAdditionalAfterLetter
								lAdditionalCopyNumber
							)
						} else {
							local lBuildedName := StrLower("scripts." curScript "." curCaseKey "_" curTypeKey "_" curLetter (hasScriptAdditive ? "_" tagAdd["scriptAdditive"] : "")) ".letter_locale"
							local additionalPostLetter := Locale.Read(lBuildedName, lang)

							local localedCase := curCase != "neutral" ? Locale.Read(pfx "case." curCase, lang, , , , curLVariant) " " : ""
							local scriptTag := Locale.Read(pfx "tag." curScript, lang, , , , curLVariant)

							tagsCollector[lang].Push(
								((lang = "en-US" || lang = "ru-RU" && curTagScriptAtStart) ? scriptTag " " : "")
								lAdditionalBeforeType
								localedCase Locale.Read(pfx "type." curType, lang) " "
								lAdditionalAfterType
								lAdditionalBeforeLetter
								additionalPostLetter
								lAdditionalAfterLetter
								lAdditionalCopyNumber
								((lang = "ru-RU" && !curTagScriptAtStart) ? " " scriptTag : "")
							)
						}
					}
				}
			}
		}

		local hasTags := entry["tags"].Length > 0
		local tagsBackup := []

		if hasTags {
			for each in entry["tags"] {
				if RegExMatch(each, "^<(.*?)>(.*)", &match) {
					local lang := match[1]
					local tagContent := match[2]

					if tagsCollector.Has(lang)
						tagsCollector[lang].Push(tagContent)
				} else
					tagsBackup.Push(each)
			}

			entry["tags"] := []
		}

		for lang in ["en-US", "ru-RU"] {
			for each in tagsCollector[lang] {
				if !entry["tags"].HasValue(each)
					entry["tags"].Push(each)

				if !entry["tagsMap"].Has(lang)
					entry["tagsMap"].Set(lang, [])

				entry["tagsMap"][lang].Push(each)
			}
		}

		entry["options"].Set("isTagsMirrored", True)

		if tagsBackup.Length > 0
			for each in tagsBackup
				if !entry["tags"].HasValue(each)
					entry["tags"].Push(each)

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