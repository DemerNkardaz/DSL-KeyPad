Class LocaleGenerator {
	Generate(entryName, entry, dataEntry := "data") {
		local originalName := entryName
		local nbsp := Chr(160)
		local pfx := "generated."

		local useLetterLocale := entry["options"]["useLetterLocale"]
		local useLayoutTitles := entry["options"]["layoutTitles"]
		local useLayoutTitlesAsMain := entry["options"]["layoutTitlesAsMain"]
		local scriptAdditive := entry["symbol"]["scriptAdditive"] != "" ? "." entry["symbol"]["scriptAdditive"] : ""

		local tagScriptAtStart := False
		local bannedFromScriptAtStart := entryName ~= "^(yijing|taixuanjing|mahjong|xiangqi)"
		local scriptBounds := entry["symbol"]["scriptBounds"]

		if ChrLib.scriptsValidator.HasRegEx(entryName, &i, ["^", "_"], ["sidetic", "glagolitic", "tolkien_runic", "domino"]) {
			if !useLetterLocale
				useLetterLocale := True
			if !bannedFromScriptAtStart
				tagScriptAtStart := True
		}

		local referenceLocale := entry["options"].Has("referenceLocale") && entry["options"]["referenceLocale"] != "" ? entry["options"]["referenceLocale"] : False

		local useSelfPostfixesOnReferenceLocale := entry["options"]["useSelfPostfixesOnReferenceLocale"]

		local LTLReference := False

		local entryData := entry[dataEntry].Clone()
		local entrySymbol := entry["symbol"].Clone()

		local tagsCollector := Map("en-US", [], "ru-RU", [])
		local titlesCollector := Map("en-US", [], "ru-RU", [])

		local useHiddenTags := entry["options"]["useHiddenTags"]
		local hiddenTagsLanguage := entry["options"]["hiddenTagsLanguage"]
		local hiddenTagsCollector := Map("en-US", [], "ru-RU", [])

		local boundsCollector := Map(
			"script", Map("en-US", [], "ru-RU", [])
		)

		if scriptBounds.Length > 0 {
			for item in scriptBounds {
				local boundSplit := StrSplit(item, ",")
				for each in boundSplit {
					if RegExMatch(each, "^(.+)<([^<>]+)>$", &match) {
						local bound := match[1]
						local lang := match[2]

						boundsCollector["script"][lang].Push(bound)
					}
				}
			}
		}

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
				entryData["postfixes"] := entry[dataEntry]["postfixes"].Clone()
		}


		local letter := (entrySymbol.Has("letter") && StrLen(entrySymbol["letter"]) > 0) ? entrySymbol["letter"] : entryData["letter"]
		local lScript := entryData["script"]
		local lOriginScript := entryData["originScript"]
		local lCase := entryData["case"]
		local lType := entry["symbol"]["type"] != "" ? entry["symbol"]["type"] : entryData["type"]
		local lPostfixes := entryData["postfixes"]
		local lVariant := ["digraph", "symbol", "sign", "syllable", "glyph"].HasValue(lType) ? 2 : lType = "numeral" ? 3 : 1

		local hasScript := lScript != ""
		local isGermanic := ["germanic_runic", "cirth_runic"].HasValue(lScript)

		local langCodes := ["en-US", "ru-RU", "en-US_alt", "ru-RU_alt"]
		local tags := Map()
		local hiddenTags := Map("en-US", "", "ru-RU", "")
		entry["titles"] := Map()

		local ref := LTLReference ? LTLReference : entryName

		for _, langCode in langCodes {
			local isAlt := InStr(langCode, "_alt")
			local lang := isAlt ? RegExReplace(langCode, "_alt") : langCode

			local interLetter := ref

			if useLetterLocale {
				if RegExMatch(useLetterLocale, "i)^(.*?)\$(\(.*?\))?", &refMatch) {
					if refMatch[2] != "" && InStr(refMatch[2], "remove") {
						interLetter := RegExReplace(entryName, "i)" RegExReplace(refMatch[1], "([\\.\^$*+?()[\]{}|])", "\$1"))
					} else
						interLetter := RegExReplace(entryName, "i)^(.*?" RegExReplace(refMatch[1], "([\\.\^$*+?()[\]{}|])", "\$1") ").*", "$1")
				} else if useLetterLocale = "Origin"
					interLetter := RegExReplace(ref, "i)^(.*?)__.*", "$1")

				if hasScript
					interLetter := RegExReplace(interLetter, "^" lOriginScript "_", "scripts." lScript ".")
			}

			if useLayoutTitlesAsMain {
				entry["titles"][langCode] := Locale.Read(interLetter ".layout_locale", lang)
				if !isAlt
					tagsCollector[lang].Push(StrLower(entry["titles"][langCode]))
				continue
			}

			local postfixText := ""

			if lPostfixes.Length > 0 {
				postfixText .= " {conjuction}" nbsp Locale.Read(pfx "postfix." lPostfixes[1], lang)

				Loop lPostfixes.Length - 2
					postfixText .= ", " Locale.Read(pfx "postfix." lPostfixes[A_Index + 1], lang)

				if lPostfixes.Length > 1
					postfixText .= " " Locale.Read(pfx "postfix.and", lang) nbsp Locale.Read(pfx "postfix." lPostfixes[lPostfixes.Length], lang)

				postfixText := this.LocaleRules(postfixText, lang)
			}

			local postLetter := useLetterLocale ? Locale.Read(interLetter (useLetterLocale ? ".letter_locale" : ""), lang) : letter
			local interPath := originalName

			if useLayoutTitles {
				if hasScript
					interPath := RegExReplace(interPath, "^" lOriginScript "_", "scripts." lScript ".")

				layoutTitle := Locale.Read(interPath ".layout_locale", lang)
			}

			if useLetterLocale && useHiddenTags
				hiddenLetter := Locale.Read(interLetter (useLetterLocale ? ".letter_locale.__hidden" : ""), lang, True, &hidden) ? hidden : postLetter

			local lBeforeletter := ""
			local lAfterletter := ""
			local lBeforeType := ""
			local lAfterType := ""
			local lSecondName := ""

			local lBeforeTitle := ""
			local lAfterTitle := ""
			local lBeforeAltTitle := ""
			local lAfterAltTitle := ""

			if useHiddenTags {
				lHiddenBeforeletter := ""
				lHiddenAfterletter := ""
				lHiddenBeforeType := ""
				lHiddenAfterType := ""
				lHiddenSecondName := ""

				lHiddenBeforeTitle := ""
				lHiddenAfterTitle := ""
				lHiddenBeforeAltTitle := ""
				lHiddenAfterAltTitle := ""
			}


			local altTitleUseLineBreak := entry["options"]["altTitleUseLineBreak"]

			local copyNumber := entry["symbol"]["copyNumber"]
			local hasCopyNumber := copyNumber > 0
			local lCopyNumber := hasCopyNumber ? " [" copyNumber "]" : ""

			if entry["options"]["secondName"] {
				if hasScript
					ref := RegExReplace(ref, "^" lOriginScript "_", "scripts." lScript ".")

				lSecondName := " " Locale.Read(("Origin" ? RegExReplace(ref, "i)^(.*?)__.*", "$1") : ref) ".second_name", lang)
			}

			for letterBound in ["beforeLetter", "afterLetter", "beforeType", "afterType", "beforeTitle", "afterTitle", "beforeAltTitle", "afterAltTitle"] {
				if entry["symbol"].Has(letterBound) && StrLen(entry["symbol"][letterBound]) > 0 {
					if entry["symbol"][letterBound] ~= "^<(!?)" langCode ">$" {
						entry["symbol"][letterBound] := ""
						continue
					}

					local boundLink := Util.StrUpper(letterBound, 1)
					local entryBoundReference := entry["symbol"][letterBound]
					local splitted := StrSplit(Util.StrTrim(entry["symbol"][letterBound]), ",")

					local localeKey := RegExReplace(letterBound, "(Letter|Type)", "_letter")

					for i, bound in splitted {
						local titlelizeFirstLetter := bound ~= "i)^t\."
						local boundKey := RegExReplace(bound, "i)^t\.")
						local useSelfReference := false

						if RegExMatch(boundKey, "^/(.*?)/", &selfRefMatch) {
							useSelfReference := selfRefMatch[1] = "self"
							boundKey := RegExReplace(boundKey, selfRefMatch[0])
						}

						if RegExMatch(boundKey, "<(!?)([^<>]+)>$", &languageRuleMatch) {
							local isBan := languageRuleMatch[1] = "!"
							local languageRule := languageRuleMatch[2]

							if !InStr(langCode, languageRule) && !isBan || InStr(langCode, languageRule) && isBan
								continue

							boundKey := RegExReplace(boundKey, languageRuleMatch[0])
						} else if RegExMatch(boundKey, "\{(-?\d+)?(?:\.\.\.)?i\}", &match) {
							local addition := match[1] ? Integer(match[1]) : 0
							l%boundLink% .= addition + Integer(entry["variantPos"])
							if useHiddenTags
								lHidden%boundLink% .= addition + Integer(entry["variantPos"])
							continue
						} else if RegExMatch(boundKey, "@(.*?)", &match) {
							l%boundLink% .= match[1]
							if useHiddenTags
								lHidden%boundLink% .= match[1]
							continue
						}

						if RegExMatch(boundKey, "\:\:(.*?)$", &match) {
							local index := Integer(match[1])
							local cleanBound := SubStr(boundKey, 1, match.Pos(0) - 1)
							l%boundLink% .= Locale.Read((useSelfReference ? interLetter : pfx localeKey) "." cleanBound, lang, , , , index) (i < splitted.Length ? " " : "")

							if useHiddenTags
								lHidden%boundLink% .= (Locale.Read((useSelfReference ? interLetter : pfx localeKey) "." cleanBound ".__hidden", lang, True, &hidden, , index) ? hidden : l%boundLink%) (i < splitted.Length ? " " : "")
						} else {
							l%boundLink% .= Locale.Read((useSelfReference ? interLetter : pfx localeKey) "." boundKey, lang, , , , (InStr(boundLink, "Type") ? lVariant : 1)) (i < splitted.Length ? " " : "")

							if useHiddenTags
								lHidden%boundLink% .= (Locale.Read((useSelfReference ? interLetter : pfx localeKey) "." boundKey ".__hidden", lang, True, &hidden, , (InStr(boundLink, "Type") ? lVariant : 1)) ? hidden : l%boundLink%) (i < splitted.Length ? " " : "")
						}

						if titlelizeFirstLetter {
							l%boundLink% := StrTitle(l%boundLink%)
							if useHiddenTags
								lHidden%boundLink% := StrTitle(lHidden%boundLink%)
						}
					}
				}
			}

			lBeforeType := lBeforeType != "" ? lBeforeType " " : ""
			lAfterType := lAfterType != "" ? " " lAfterType : ""

			lBeforeletter := lBeforeletter != "" ? lBeforeletter " " : ""
			lAfterletter := lAfterletter != "" ? " " lAfterletter : ""


			if lBeforeAltTitle = "" && lBeforeTitle != ""
				lBeforeAltTitle := lBeforeTitle
			if lAfterAltTitle = "" && lAfterTitle != ""
				lAfterAltTitle := lAfterTitle

			lBeforeTitle := lBeforeTitle != "" ? lBeforeTitle " " : ""
			lAfterTitle := lAfterTitle != "" ? " " lAfterTitle : ""

			lBeforeAltTitle := lBeforeAltTitle != "" ? lBeforeAltTitle (altTitleUseLineBreak ? "`n" : " ") : ""
			lAfterAltTitle := lAfterAltTitle != "" ? (altTitleUseLineBreak ? "`n" : " ") lAfterAltTitle : ""

			if useHiddenTags {
				lHiddenBeforeType := lHiddenBeforeType != "" ? lHiddenBeforeType " " : ""
				lHiddenAfterType := lHiddenAfterType != "" ? " " lHiddenAfterType : ""

				lHiddenBeforeletter := lHiddenBeforeletter != "" ? lHiddenBeforeletter " " : ""
				lHiddenAfterletter := lHiddenAfterletter != "" ? " " lHiddenAfterletter : ""

				if lHiddenBeforeAltTitle = "" && lHiddenBeforeTitle != ""
					lHiddenBeforeAltTitle := lHiddenBeforeTitle
				if lHiddenAfterAltTitle = "" && lHiddenAfterTitle != ""
					lHiddenAfterAltTitle := lHiddenAfterTitle


				lHiddenBeforeTitle := lHiddenBeforeTitle != "" ? lHiddenBeforeTitle " " : ""
				lHiddenAfterTitle := lHiddenAfterTitle != "" ? " " lHiddenAfterTitle : ""

				lHiddenBeforeAltTitle := lHiddenBeforeAltTitle != "" ? lHiddenBeforeAltTitle (altTitleUseLineBreak ? "`n" : " ") : ""
				lHiddenAfterAltTitle := lHiddenAfterAltTitle != "" ? (altTitleUseLineBreak ? "`n" : " ") lHiddenAfterAltTitle : ""
			}

			local proxyMark := entry["proxy"] != "" ? " " Locale.Read("gen.proxy", lang) : ""

			if isAlt {
				local title := (
					lBeforeAltTitle
					Util.StrUpper(Locale.Read(pfx "type." lType, lang), 1) " "
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
					proxyMark
					lAfterAltTitle
				)

				entry["titles"][langCode] := title postfixText
			} else {
				localedCase := lCase != "neutral" ? Locale.Read(pfx "case." lCase, lang, , , , lVariant) " " : ""

				local title := (
					lBeforeTitle
					(boundsCollector["script"][langCode].Length > 0 ? boundsCollector["script"][langCode][1] : "")
					Locale.Read(pfx "prefix." lScript (!isGermanic ? scriptAdditive : ""), lang, , , , lVariant)
					(boundsCollector["script"][langCode].Length > 0 ? boundsCollector["script"][langCode][2] : "")
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
					lAfterTitle
				)

				entry["titles"][langCode] := title postfixText

				tagScriptAdditive := scriptAdditive ? " " Locale.Read(pfx "tag." lScript (scriptAdditive), lang, , , , lVariant) : ""

				local tag := (
					lBeforeTitle
					(!isGermanic ? localedCase lBeforeType Locale.Read(pfx "type." lType, lang) lAfterType " " : "")
					lBeforeletter
					postLetter
					lAfterletter
					lSecondName
					lCopyNumber
					lAfterTitle
				)

				if lang = "ru-RU" {
					tag := (
						tagScriptAtStart ?
							(
								Locale.Read(pfx "tag." lScript, lang, , , , lVariant)
								(isGermanic ? " " Locale.Read(pfx "type." lType, lang) : "")
								tagScriptAdditive " "
								tag
							)
						: (
							tag
							" "
							Locale.Read(pfx "tag." lScript, lang, , , , lVariant)
						)
					)
				} else {
					tag := (
						Locale.Read(pfx "tag." lScript, lang, , , , lVariant)
						(isGermanic ? " " Locale.Read(pfx "type." lType, lang) : "")
						tagScriptAdditive " "
						tag
					)
				}

				tagsCollector[lang].Push(tag postfixText)

				if useLayoutTitles {
					titlesCollector[lang].Push(layoutTitle)
					tagsCollector[lang].Push(StrLower(layoutTitle))
				}

				if useHiddenTags && (hiddenTagsLanguage = "" || hiddenTagsLanguage != "" && InStr(hiddenTagsLanguage, langCode)) {
					local hiddenTag := (
						lHiddenBeforeTitle
						(!isGermanic ? localedCase lHiddenBeforeType (Locale.Read(pfx "type." lType, lang, True, &hidden) ? hidden : Locale.Read(pfx "type." lType, lang)) lHiddenAfterType " " : "")
						lHiddenBeforeletter
						hiddenLetter
						lHiddenAfterletter
						lSecondName
						lCopyNumber
						lHiddenAfterTitle
					)

					local hiddenTagScriptAdditive := scriptAdditive ? " " (Locale.Read(pfx "tag." lScript (scriptAdditive) ".__hidden", lang, True, &hidden) ? hidden : tagScriptAdditive[lang]) : ""

					local hiddenTag := (
						tagScriptAtStart ?
							(
								(Locale.Read(pfx "tag." lScript ".__hidden", lang, True, &hidden, , lVariant) ? hidden : Locale.Read(pfx "tag." lScript, lang, , , , lVariant))
								(isGermanic ? " " (Locale.Read(pfx "type." lType ".__hidden", lang, True, &hidden) ? hidden : Locale.Read(pfx "type." lType, lang)) : "")
								hiddenTagScriptAdditive " "
								hiddenTag
							)
						: (
							hiddenTag
							" "
							(Locale.Read(pfx "tag." lScript ".__hidden", lang, True, &hidden, , lVariant) ? hidden : Locale.Read(pfx "tag." lScript, lang, , , , lVariant))
						)
					)

					hiddenTagsCollector[lang].Push(hiddenTag postfixText)
				}
			}
		}

		local additionalTags := []
		if entry["symbol"]["tagAdditive"].Length > 0 {
			local allowsMultiTitles := entry["options"]["allowsMultiTitles"]

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
						local curAltTitleUseLineBreak := tagAdd.Has("altTitleUseLineBreak") ? tagAdd["altTitleUseLineBreak"] : altTitleUseLineBreak
						local curUseHiddenTags := (tagAdd.Has("useHiddenTags") ? tagAdd["useHiddenTags"] : useHiddenTags)

						local useOriginalTypePath := tagAdd.Has("typeOriginPath") ? tagAdd["typeOriginPath"] : False

						local curScriptKey := ChrLib.GetDecomposition("script", curScript, "Key", &curScriptDecomposeKey) ? curScriptDecomposeKey : curScript
						local curTypeKey := ChrLib.GetDecomposition("type", (useOriginalTypePath ? entryData["type"] : curType), "Key", &curTypeDecomposeKey) ? curTypeDecomposeKey : (useOriginalTypePath ? entryData["type"] : curType)
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

						local lAdditionalBeforeTitle := ""
						local lAdditionalAfterTitle := ""

						if curUseHiddenTags {
							lHiddenAdditionalBeforeletter := ""
							lHiddenAdditionalAfterletter := ""
							lHiddenAdditionalBeforeType := ""
							lHiddenAdditionalAfterType := ""

							lHiddenAdditionalBeforeTitle := ""
							lHiddenAdditionalAfterTitle := ""
							lHiddenAdditionalBeforeAltTitle := ""
							lHiddenAdditionalAfterAltTitle := ""
						}

						local draftRef := StrLower("scripts." curScript "." curCaseKey "_" curTypeKey "_" curLetter)

						for letterBound in ["beforeLetter", "afterLetter", "beforeType", "afterType", "beforeTitle", "afterTitle"] {
							if tagAdd.Has(letterBound) && StrLen(tagAdd[letterBound]) > 0 {
								local boundLink := Util.StrUpper(letterBound, 1)
								local splitted := StrSplit(Util.StrTrim(tagAdd[letterBound]), ",")
								local localeKey := RegExReplace(letterBound, "(Letter|Type)", "_letter")

								for i, bound in splitted {
									local titlelizeFirstLetter := bound ~= "i)^t\."
									local boundKey := RegExReplace(bound, "i)^t\.")
									local useSelfReference := false

									if RegExMatch(boundKey, "^/(.*?)/", &selfRefMatch) {
										useSelfReference := selfRefMatch[1] = "self"
										boundKey := RegExReplace(boundKey, selfRefMatch[0])
									}

									if RegExMatch(boundKey, "<(!?)(.*?)>$", &languageRuleMatch) {
										local isBan := languageRuleMatch[1] = "!"
										local languageRule := languageRuleMatch[2]

										if !InStr(lang, languageRule) && !isBan || InStr(lang, languageRule) && isBan
											continue

										boundKey := RegExReplace(boundKey, languageRuleMatch[0])
									} else if RegExMatch(boundKey, "\{(-?\d+)?(?:\.\.\.)?i\}", &match) {
										local addition := match[1] ? Integer(match[1]) : 0
										lAdditional%boundLink% .= addition + Integer(entry["variantPos"])
										if curUseHiddenTags
											lHiddenAdditional%boundLink% .= addition + Integer(entry["variantPos"])
										continue
									} else if RegExMatch(boundKey, "@(.*?)", &match) {
										lAdditional%boundLink% .= match[1]
										if curUseHiddenTags
											lHiddenAdditional%boundLink% .= match[1]
										continue
									}

									if RegExMatch(boundKey, "\:\:(.*?)$", &match) {
										local index := Integer(match[1])
										local cleanBound := SubStr(boundKey, 1, match.Pos(0) - 1)
										lAdditional%boundLink% .= Locale.Read((useSelfReference ? draftRef : pfx localeKey) "." cleanBound, lang, , , , index) (i < splitted.Length ? " " : "")

										if curUseHiddenTags {
											lHiddenAdditional%boundLink% .= Locale.Read((useSelfReference ? draftRef : pfx localeKey) "." cleanBound ".__hidden", lang, True, &hidden, , index) ? hidden : lAdditional%boundLink%
										}
									} else {
										lAdditional%boundLink% .= Locale.Read((useSelfReference ? draftRef : pfx localeKey) "." boundKey, lang, , , , (InStr(boundLink, "Type") ? curLVariant : 1)) (i < splitted.Length ? " " : "")

										if curUseHiddenTags {
											lHiddenAdditional%boundLink% .= Locale.Read((useSelfReference ? draftRef : pfx localeKey) "." boundKey ".__hidden", lang, True, &hidden) ? hidden : lAdditional%boundLink%
										}
									}

									if titlelizeFirstLetter {
										lAdditional%boundLink% := StrTitle(lAdditional%boundLink%)
										if curUseHiddenTags {
											lHiddenAdditional%boundLink% := StrTitle(lHiddenAdditional%boundLink%)
										}
									}
								}
							}
						}

						lAdditionalBeforeLetter := lAdditionalBeforeLetter != "" ? lAdditionalBeforeLetter " " : ""
						lAdditionalAfterLetter := lAdditionalAfterLetter != "" ? " " lAdditionalAfterLetter : ""

						lAdditionalBeforeType := lAdditionalBeforeType != "" ? lAdditionalBeforeType " " : ""
						lAdditionalAfterType := lAdditionalAfterType != "" ? " " lAdditionalAfterType : ""

						lAdditionalBeforeTitle := lAdditionalBeforeTitle != "" ? lAdditionalBeforeTitle " " : ""
						lAdditionalAfterTitle := lAdditionalAfterTitle != "" ? " " lAdditionalAfterTitle : ""

						if curUseHiddenTags {
							lHiddenAdditionalBeforeType := lHiddenAdditionalBeforeType != "" ? lHiddenAdditionalBeforeType " " : ""
							lHiddenAdditionalAfterType := lHiddenAdditionalAfterType != "" ? " " lHiddenAdditionalAfterType : ""

							lHiddenAdditionalBeforeletter := lHiddenAdditionalBeforeletter != "" ? lHiddenAdditionalBeforeletter " " : ""
							lHiddenAdditionalAfterletter := lHiddenAdditionalAfterletter != "" ? " " lHiddenAdditionalAfterletter : ""

							if lHiddenAdditionalBeforeAltTitle = "" && lHiddenAdditionalBeforeTitle != ""
								lHiddenAdditionalBeforeAltTitle := lHiddenAdditionalBeforeTitle
							if lHiddenAdditionalAfterAltTitle = "" && lHiddenAdditionalAfterTitle != ""
								lHiddenAdditionalAfterAltTitle := lHiddenAdditionalAfterTitle

							lHiddenAdditionalBeforeTitle := lHiddenAdditionalBeforeTitle != "" ? lHiddenAdditionalBeforeTitle " " : ""
							lHiddenAdditionalAfterTitle := lHiddenAdditionalAfterTitle != "" ? " " lHiddenAdditionalAfterTitle : ""
						}

						if curIsGermanic {
							local lBuildedName := StrLower("scripts." curScript "." curCaseKey "_" curTypeKey "_" letter (hasScriptAdditive ? "_" tagAdd["scriptAdditive"] : "") "_" curLetter) ".letter_locale"
							local additionalPostLetter := Locale.Read(lBuildedName, lang)

							local aLScript := Locale.Read(pfx "tag." curScript, lang, , , , curLVariant)
							local aScriptAdditive := hasScriptAdditive ? " " Locale.Read(pfx "tag." curScript curScriptAdditive, lang, , , , curLVariant) : ""
							local aLType := Locale.Read(pfx "type." curType, lang)

							tagsCollector[lang].Push(
								lAdditionalBeforeTitle
								aLScript
								lAdditionalBeforeType
								aLType
								lAdditionalAfterType
								aScriptAdditive " "
								lAdditionalBeforeLetter
								additionalPostLetter
								lAdditionalAfterLetter
								lAdditionalCopyNumber
								lAdditionalAfterTitle
							)

							if curUseHiddenTags && (hiddenTagsLanguage = "" || hiddenTagsLanguage != "" && InStr(hiddenTagsLanguage, lang)) {
								local additionalHiddenLetter := Locale.Read(lBuildedName ".__hidden", lang, True, &hidden) ? hidden : additionalPostLetter
								local aLHiddenScript := Locale.Read(pfx "tag." curScript ".__hidden", lang, True, &hidden) ? hidden : aLScript
								local aHiddenScriptAdditive := hasScriptAdditive ? " " (Locale.Read(pfx "tag." curScript curScriptAdditive ".__hidden", lang, True, &hidden) ? hidden : aScriptAdditive) : ""
								local aLHiddenType := Locale.Read(pfx "type." curType ".__hidden", lang, True, &hidden) ? hidden : aLType

								local tag := (
									lHiddenAdditionalBeforeTitle
									aLHiddenScript
									lHiddenAdditionalBeforeType
									" " aLHiddenType
									lHiddenAdditionalAfterType
									aHiddenScriptAdditive " "
									lHiddenAdditionalBeforeLetter
									additionalHiddenLetter
									lHiddenAdditionalAfterLetter
									lAdditionalCopyNumber
									lHiddenAdditionalAfterTitle
								)

								hiddenTagsCollector[lang].Push(this.LocaleRules((tag), lang))
							}


						} else {
							local lBuildedName := StrLower("scripts." curScript "." curCaseKey "_" curTypeKey "_" curLetter (hasScriptAdditive ? "_" tagAdd["scriptAdditive"] : "")) ".letter_locale"
							local additionalPostLetter := Locale.Read(lBuildedName, lang)

							local localedCase := curCase != "neutral" ? Locale.Read(pfx "case." curCase, lang, , , , curLVariant) " " : ""
							local scriptTag := Locale.Read(pfx "tag." curScript, lang, , , , curLVariant)
							local typeTag := Locale.Read(pfx "type." curType, lang)

							local tag := (
								lAdditionalBeforeTitle
								((lang = "en-US" || lang = "ru-RU" && curTagScriptAtStart) ? scriptTag " " : "")
								lAdditionalBeforeType
								localedCase typeTag
								lAdditionalAfterType " "
								lAdditionalBeforeLetter
								additionalPostLetter
								lAdditionalAfterLetter
								lAdditionalCopyNumber
								lAdditionalAfterTitle
								((lang = "ru-RU" && !curTagScriptAtStart) ? " " scriptTag : "")
							)
							tagsCollector[lang].Push(this.LocaleRules((tag), lang))

							if titlesCollector.Has(lang) && (allowsMultiTitles || tagAdd.Has("script")) {
								local title := (
									lAdditionalBeforeTitle
									(boundsCollector["script"][lang].Length > 0 ? boundsCollector["script"][lang][1] : "")
									Locale.Read(pfx "prefix." curScript (!isGermanic ? curScriptAdditive : ""), lang, , , , curLVariant)
									(boundsCollector["script"][lang].Length > 0 ? boundsCollector["script"][lang][2] : "")
									" "
									lAdditionalBeforeType
									localedCase typeTag
									lAdditionalAfterType
									(isGermanic && scriptAdditive != "" ? " " Locale.Read(pfx "prefix." curScript curScriptAdditive, lang, , , , curLVariant) : "")
									" "
									lAdditionalBeforeLetter
									additionalPostLetter
									lAdditionalAfterLetter
									; lSecondName
									lAdditionalCopyNumber
									proxyMark
									lAdditionalAfterTitle
								)
								titlesCollector[lang].Push(this.LocaleRules((title), lang))
							}

							if curUseHiddenTags && (hiddenTagsLanguage = "" || hiddenTagsLanguage != "" && InStr(hiddenTagsLanguage, lang)) {
								local additionalHiddenLetter := Locale.Read(lBuildedName ".__hidden", lang, True, &hidden) ? hidden : additionalPostLetter
								local localedHiddenCase := curCase != "neutral" ? (Locale.Read(pfx "case." curCase ".__hidden", lang, True, &hidden, , curLVariant) ? hidden : localedCase) " " : ""
								local scriptHiddenTag := Locale.Read(pfx "tag." curScript ".__hidden", lang, True, &hidden, , curLVariant) ? hidden : scriptTag
								local typeHiddenTag := Locale.Read(pfx "type." curType ".__hidden", lang, True, &hidden) ? hidden : typeTag

								local tag := (
									lHiddenAdditionalBeforeTitle
									((lang = "en-US" || lang = "ru-RU" && curTagScriptAtStart) ? scriptHiddenTag " " : "")
									lHiddenAdditionalBeforeType
									localedHiddenCase typeHiddenTag " "
									lHiddenAdditionalAfterType
									lHiddenAdditionalBeforeLetter
									additionalHiddenLetter
									lHiddenAdditionalAfterLetter
									lAdditionalCopyNumber
									lHiddenAdditionalAfterTitle
									((lang = "ru-RU" && !curTagScriptAtStart) ? " " scriptHiddenTag : "")
								)

								hiddenTagsCollector[lang].Push(tag)
							}
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

			if useHiddenTags {
				for each in hiddenTagsCollector[lang] {
					if (each = "" || !entry["hiddenTags"].HasValue(each))
						entry["hiddenTags"].Push(each)

					if !entry["hiddenTagsMap"].Has(lang)
						entry["hiddenTagsMap"].Set(lang, [])

					entry["hiddenTagsMap"][lang].Push(each)
				}
			}

			for each in titlesCollector[lang] {
				if !entry["altTitles"].HasValue(each)
					entry["altTitles"].Push(each)

				if !entry["altTitlesMap"].Has(lang)
					entry["altTitlesMap"].Set(lang, [])

				entry["altTitlesMap"][lang].Push(each)
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