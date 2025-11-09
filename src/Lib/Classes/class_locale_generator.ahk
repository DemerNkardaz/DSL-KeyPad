Class LocaleGenerator {
	static HANDLING_LOCALES := Language.GetSupported("generatedLocale", , True)
	static FALLBACK_LOCALE := "en-US"

	static FORMATS_DEFAULT_VARIANTS := ["titlePostfix", "titleAltPostfix", "titlePostfixMulti", "titleAltPostfixMulti", "title", "titleAlt", "tag", "hiddenTag", "additiveTitle", "additiveTag", "additiveHiddenTag"]
	static FORMATS := Map(
		"en-US", Map(
			"titlePostfix", (&data, &postfixText) => [
				"{conjuction}",
				postfixText,
			],
			"titleAltPostfix", (&data, &postfixText) => [
				"{conjuction}",
				data.wordAltSeparator,
				postfixText,
			],
			"titlePostfixMulti", (&data, &postfixText) => [
				data.wordSeparator data.postfixAnd,
				postfixText,
			],
			"titleAltPostfixMulti", (&data, &postfixText) => [
				data.wordSeparator data.postfixAnd,
				data.wordAltSeparator,
				postfixText,
			],
			"title", (&data) => [
				data.lBeforeTitle,
				(
					(data.boundsCollector["script"][data.langCode].Length > 0 ? data.boundsCollector["script"][data.langCode][1] : "")
					LocaleGenerator.GetLocale(data.pfx "prefix." data.lScript (!data.isGermanic ? data.scriptAdditive : ""), data.lang, , , data.lVariant)
					(data.boundsCollector["script"][data.langCode].Length > 0 ? data.boundsCollector["script"][data.langCode][2] : "")
				),
				data.lBeforeType,
				data.localedCase,
				(data.typeIsNeutral ? "" : LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang)),
				data.lAfterType,
				(data.isGermanic && data.scriptAdditive != "" ? LocaleGenerator.GetLocale(data.pfx "prefix." data.lScript data.scriptAdditive, data.lang, , , data.lVariant) : ""),
				data.lBeforeletter,
				data.postLetter,
				data.lAfterletter,
				data.lSecondName,
				data.lCopyNumber,
				data.proxyMark,
				data.lAfterTitle,
				data.titlePostfixText,
			],
			"titleAlt", (&data) => [
				data.lBeforeAltTitle,
				(data.altTitleUseLineBreak && data.lBeforeAltTitle != "" ? "`n" : ""),
				(data.typeIsNeutral ? "" : Util.StrUpper(LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang), 1)),
				data.lBeforeletter,
				data.postLetter,
				data.lAfterletter,
				data.lSecondName,
				data.proxyMark,
				(data.altTitleUseLineBreak && data.lAfterletter != "" ? "`n" : ""),
				data.lAfterAltTitle,
				data.altTitlePostfixText,
			],
			"tag", (&data) => [
				LocaleGenerator.GetLocale(data.pfx "tag." data.lScript, data.lang, , , data.lVariant),
				(data.typeIsNeutral ? "" : (data.isGermanic ? LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang) : "")),
				data.tagScriptAdditive,
				; Tag Base [
				data.lBeforeTitle,
				data.localedCase,
				data.lBeforeType,
				(data.typeIsNeutral ? "" : (!data.isGermanic ? LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang) : "")),
				data.lAfterType,
				data.lBeforeletter,
				data.postLetter,
				data.lAfterletter,
				data.lSecondName,
				data.lCopyNumber,
				data.lAfterTitle,
				; ]
				data.titlePostfixText,
			],
			"hiddenTag", (&data) => [
				(LocaleGenerator.GetLocale({ path: data.pfx "tag." data.lScript, end: ".__hidden" }, data.lang, True, , data.lVariant)),
				(data.typeIsNeutral ? "" : (data.isGermanic ? (LocaleGenerator.GetLocale({ path: data.pfx "type." data.lType, end: ".__hidden" }, data.lang, True)) : "")),
				data.hiddenTagScriptAdditive,
				; Tag Base [
				data.lHiddenBeforeTitle,
				data.localedCase,
				data.lHiddenBeforeType,
				(data.typeIsNeutral ? "" : (!data.isGermanic ? LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang) : "")),
				data.lHiddenAfterType,
				data.lHiddenBeforeletter,
				data.hiddenLetter,
				data.lHiddenAfterletter,
				data.lSecondName,
				data.lCopyNumber,
				data.lHiddenAfterTitle,
				; ]
				data.titlePostfixText
			],
			"additiveTitle", (&data) => [
				data.lAdditionalBeforeTitle,
				(
					(data.boundsCollector["script"][data.lang].Length > 0 ? data.boundsCollector["script"][data.lang][1] : "")
					LocaleGenerator.GetLocale(data.pfx "prefix." data.curScript (!data.curIsGermanic ? data.curScriptAdditive : ""), data.lang, , , data.curLVariant)
					(data.boundsCollector["script"][data.lang].Length > 0 ? data.boundsCollector["script"][data.lang][2] : "")
				),
				data.lAdditionalBeforeType,
				data.localedCase data.typeTag,
				data.lAdditionalAfterType,
				(data.curIsGermanic && data.scriptAdditive != "" ? LocaleGenerator.GetLocale(data.pfx "prefix." data.curScript data.curScriptAdditive, data.lang, , , data.curLVariant) : ""),
				data.lAdditionalBeforeLetter,
				data.additionalPostLetter,
				data.lAdditionalAfterLetter,
				; lSecondName
				data.lAdditionalCopyNumber,
				data.proxyMark,
				data.lAdditionalAfterTitle,
			],
			"additiveTag", (&data) => [
				data.lAdditionalBeforeTitle,
				data.scriptTag,
				data.lAdditionalBeforeType,
				data.localedCase data.typeTag,
				data.lAdditionalAfterType,
				data.lAdditionalBeforeLetter,
				data.additionalPostLetter,
				data.lAdditionalAfterLetter,
				data.lAdditionalCopyNumber,
				data.lAdditionalAfterTitle,
			],
			"additiveHiddenTag", (&data) => [
				data.lHiddenAdditionalBeforeTitle,
				data.scriptHiddenTag,
				data.lHiddenAdditionalBeforeType,
				data.localedHiddenCase data.typeHiddenTag,
				data.lHiddenAdditionalAfterType,
				data.lHiddenAdditionalBeforeletter,
				data.additionalHiddenLetter,
				data.lHiddenAdditionalAfterletter,
				data.lAdditionalCopyNumber,
				data.lHiddenAdditionalAfterTitle,
			],
		),
		"ru-RU", Map(
			"tag", (&data) => [
				data.tagScriptAtStart ? LocaleGenerator.GetLocale(data.pfx "tag." data.lScript, data.lang, , , data.lVariant) : "",
				(data.typeIsNeutral ? "" : (data.isGermanic ? LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang) : "")),
				data.tagScriptAdditive,
				; Tag Base [
				data.lBeforeTitle,
				data.localedCase,
				data.lBeforeType,
				(data.typeIsNeutral ? "" : (!data.isGermanic ? LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang) : "")),
				data.lAfterType,
				data.lBeforeletter,
				data.postLetter,
				data.lAfterletter,
				data.lSecondName,
				data.lCopyNumber,
				data.lAfterTitle,
				; ]
				data.titlePostfixText,
				!data.tagScriptAtStart ? LocaleGenerator.GetLocale(data.pfx "tag." data.lScript, data.lang, , , data.lVariant) : "",
			],
			"hiddenTag", (&data) => [
				data.tagScriptAtStart ? (LocaleGenerator.GetLocale({ path: data.pfx "tag." data.lScript, end: ".__hidden" }, data.lang, True, , data.lVariant)) : "",
				(data.typeIsNeutral ? "" : (data.isGermanic ? (LocaleGenerator.GetLocale({ path: data.pfx "type." data.lType, end: ".__hidden" }, data.lang, True)) : "")),
				(data.typeIsNeutral ? "" : (data.isGermanic ? LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang) : "")),
				data.hiddenTagScriptAdditive,
				; Tag Base [
				data.lHiddenBeforeTitle,
				data.localedCase,
				data.lHiddenBeforeType,
				(data.typeIsNeutral ? "" : (!data.isGermanic ? LocaleGenerator.GetLocale(data.pfx "type." data.lType, data.lang) : "")),
				data.lHiddenAfterType,
				data.lHiddenBeforeletter,
				data.hiddenLetter,
				data.lHiddenAfterletter,
				data.lSecondName,
				data.lCopyNumber,
				data.lHiddenAfterTitle,
				; ]
				data.titlePostfixText,
				!data.tagScriptAtStart ? (LocaleGenerator.GetLocale({ path: data.pfx "tag." data.lScript, end: ".__hidden" }, data.lang, True, , data.lVariant)) : "",
			],
			"additiveTag", (&data) => [
				data.lAdditionalBeforeTitle,
				(data.curTagScriptAtStart ? data.scriptTag : ""),
				data.lAdditionalBeforeType,
				data.localedCase data.typeTag,
				data.lAdditionalAfterType,
				data.lAdditionalBeforeLetter,
				data.additionalPostLetter,
				data.lAdditionalAfterLetter,
				data.lAdditionalCopyNumber,
				data.lAdditionalAfterTitle,
				(!data.curTagScriptAtStart ? data.scriptTag : ""),
			],
			"additiveHiddenTag", (&data) => [
				data.lHiddenAdditionalBeforeTitle,
				(data.curTagScriptAtStart ? data.scriptHiddenTag : ""),
				data.lHiddenAdditionalBeforeType,
				data.localedHiddenCase data.typeHiddenTag,
				data.lHiddenAdditionalAfterType,
				data.lHiddenAdditionalBeforeletter,
				data.additionalHiddenLetter,
				data.lHiddenAdditionalAfterletter,
				data.lAdditionalCopyNumber,
				data.lHiddenAdditionalAfterTitle,
				(!data.curTagScriptAtStart ? data.scriptHiddenTag : ""),
			],
		),
	)

	static wordSeparators := this.GetLocales().ToMap(" ")
	static wordAltSeparators := this.GetLocales().ToMap(Chr(160))
	static postfixSeparators := this.GetLocales().ToMap(", ")

	static AddLocale(locale) {
		if !LocaleGenerator.HANDLING_LOCALES.HasValue(locale)
			LocaleGenerator.HANDLING_LOCALES.Push(locale)
	}

	static RemoveLocale(locale) {
		if LocaleGenerator.HANDLING_LOCALES.HasValue(locale)
			LocaleGenerator.HANDLING_LOCALES.RemoveValue(locale)
	}

	static GetLocales() {
		return LocaleGenerator.HANDLING_LOCALES
	}

	static GetFormatEntry(locale) {
		locale := StrReplace(locale, "_alt")
		local currentFormat := this.FORMATS.Get(locale, this.FORMATS.Get(this.FALLBACK_LOCALE))

		for key in this.FORMATS_DEFAULT_VARIANTS
			if !currentFormat.Has(key)
				currentFormat.Set(key, this.FORMATS[this.FALLBACK_LOCALE][key])

		return currentFormat
	}

	static FormatCallBridge(formatEntry) {
		return {
			Get: Get,
		}

		Get(this, formatName, &data, &secondArg?) {
			local currentFormat := formatEntry.Get(formatName, LocaleGenerator.FORMATS[LocaleGenerator.FALLBACK_LOCALE].Get(formatName))
			currentFormat := IsSet(secondArg) ? currentFormat(&data, &secondArg) : currentFormat(&data)
			local toStringArgs := [
				separaotr := data.wordSeparator,
				bounds := "",
				blackList := ["", data.wordSeparator],
				skipSeparator := ["`n", data.wordAltSeparator],
				skipSeparatorIfNext := [data.wordAltSeparator]
			]

			return currentFormat is Array ? currentFormat.ToString(toStringArgs*) : currentFormat
		}
	}

	static GetFormat(locale, label) {
		local currentFormatEntry := this.FORMATS.Get(locale, this.FORMATS.Get(this.FALLBACK_LOCALE))
		local currentFormat := currentFormatEntry.Get(label, this.FORMATS[this.FALLBACK_LOCALE].Get(label))

		return currentFormat
	}

	static SetFormat(locale, label, value) {
		return this.FORMATS[locale].Set(label, value)
	}

	static SetFormatEntry(locale, value) {
		return this.FORMATS.Set(locale, value)
	}

	static localesCache := Map()

	static SetCache(lang, key, value) {
		if !this.localesCache.Has(lang)
			this.localesCache.Set(lang, Map())

		this.localesCache[lang].Set(key, value)
	}

	static GetCache(lang, key) {
		return this.localesCache.Get(lang).Get(key)
	}

	static CheckCache(lang, key) {
		return this.localesCache.Has(lang) && this.localesCache[lang].Has(key)
	}

	static GetLocale(entryName, lang, validate := False, strInjections := [], variantSelect := 1) {
		local key := entryName is String ? entryName : entryName.path entryName.end

		if this.CheckCache(lang, key "::" variantSelect)
			return this.GetCache(lang, key "::" variantSelect)
		else {
			local localeStr := ""
			if validate
				localeStr := Locale.Read(key, lang, True, &end, strInjections, variantSelect) ? end : LocaleGenerator.GetLocale(entryName.path, lang, , , variantSelect)
			else
				localeStr := Locale.Read(key, lang, validate, , strInjections, variantSelect)

			this.SetCache(lang, key "::" variantSelect, localeStr)
			return localeStr
		}
	}

	Generate(entryName, entry, dataEntry := "data") {
		local handlingLocales := LocaleGenerator.GetLocales()
		local altHandlingLocales := LocaleGenerator.GetLocales().StringsAppend("_alt", False)

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

		local entryData := ""
		local entrySymbol := ""
		local lPostfixes := ""

		local tagsCollector := handlingLocales.ToMap([])
		local titlesCollector := handlingLocales.ToMap([])

		local useHiddenTags := entry["options"]["useHiddenTags"]
		local hiddenTagsLanguage := entry["options"]["hiddenTagsLanguage"]
		local hiddenTagsCollector := handlingLocales.ToMap([])

		local boundsCollector := Map(
			"script", handlingLocales.ToMap([])
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
				if RegExMatch(referenceLocale, "i)^(.*?)\$(\(.*?\))?", &refMatch) {
					if refMatch[2] != "" && InStr(refMatch[2], "remove") {
						referenceName := RegExReplace(entryName, "i)" RegExReplace(refMatch[1], "([\\.\^$*+?()[\]{}|])", "\$1"))
					} else
						referenceName := RegExReplace(entryName, "i)^(.*?" RegExReplace(refMatch[1], "([\\.\^$*+?()[\]{}|])", "\$1") ").*", "$1")
				} else
					referenceName := referenceLocale

				if ChrLib.entries.HasOwnProp(referenceName) {
					entryData := ChrLib.GetValue(referenceName, "data")
					entrySymbol := ChrLib.GetValue(referenceName, "symbol")
				}

				entryName := referenceName
			} else
				LTLReference := StrReplace(referenceLocale, ":", "")


			if useSelfPostfixesOnReferenceLocale
				lPostfixes := entry[dataEntry]["postfixes"]
		}

		if entryData = ""
			entryData := entry[dataEntry]

		if entrySymbol = ""
			entrySymbol := entry["symbol"]

		if lPostfixes = ""
			lPostfixes := entryData["postfixes"]

		local letter := (entrySymbol.Has("letter") && StrLen(entrySymbol["letter"]) > 0) ? entrySymbol["letter"] : entryData["letter"]
		local lScript := entryData["script"]
		local lOriginScript := entryData["originScript"]
		local lCase := entryData["case"]
		local lType := entry["symbol"]["type"] != "" ? entry["symbol"]["type"] : entryData["type"]
		; local lPostfixes := entryData["postfixes"]
		local lVariant := ["digraph", "symbol", "sign", "syllable", "glyph"].HasValue(lType) ? 2 : lType = "numeral" ? 3 : 1

		local hasScript := lScript != ""
		local isGermanic := ["germanic_runic", "cirth_runic"].HasValue(lScript)

		local langCodes := ArrayMerge(handlingLocales, altHandlingLocales)
		local tags := Map()
		local hiddenTags := handlingLocales.ToMap("")
		entry["titles"] := Map()

		local ref := LTLReference ? LTLReference : entryName

		for _, langCode in langCodes {
			local isAlt := InStr(langCode, "_alt")
			local lang := isAlt ? RegExReplace(langCode, "_alt") : langCode

			local data := {
				pfx: pfx,
				lang: lang,
				langCode: langCode,
				lType: lType,
				lScript: lScript,
				lVariant: lVariant,
				lPostfixes: lPostfixes,
				boundsCollector: boundsCollector,
				isGermanic: isGermanic,
				tagScriptAtStart: tagScriptAtStart,
				scriptAdditive: scriptAdditive,
				wordSeparator: LocaleGenerator.wordSeparators.Get(lang, LocaleGenerator.wordSeparators.Get(LocaleGenerator.FALLBACK_LOCALE)),
				wordAltSeparator: LocaleGenerator.wordAltSeparators.Get(lang, LocaleGenerator.wordAltSeparators.Get(LocaleGenerator.FALLBACK_LOCALE)),
				postfixSeparator: LocaleGenerator.postfixSeparators.Get(lang, LocaleGenerator.postfixSeparators.Get(LocaleGenerator.FALLBACK_LOCALE)),
			}

			local currentFormats := LocaleGenerator.GetFormatEntry(langCode)
			local currentFormatBridge := LocaleGenerator.FormatCallBridge(currentFormats)

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
				entry["titles"][langCode] := LocaleGenerator.GetLocale(interLetter ".layout_locale", lang)
				if !isAlt
					tagsCollector[lang].Push(StrLower(entry["titles"][langCode]))
				continue
			}

			data.titlePostfixText := ""
			data.altTitlePostfixText := ""

			if lPostfixes.Length > 0 {
				local postfixText := LocaleGenerator.GetLocale(pfx "postfix." lPostfixes[1], lang)

				data.titlePostfixText .= currentFormatBridge.Get("titlePostfix", &data, &postfixText)
				data.altTitlePostfixText .= currentFormatBridge.Get("titleAltPostfix", &data, &postfixText)

				Loop lPostfixes.Length - 2 {
					data.titlePostfixText .= data.postfixSeparator LocaleGenerator.GetLocale(pfx "postfix." lPostfixes[A_Index + 1], lang)
					data.altTitlePostfixText .= data.titlePostfixText
				}

				if lPostfixes.Length > 1 {
					data.postfixAnd := LocaleGenerator.GetLocale(pfx "postfix.and", lang)
					local postfixText := LocaleGenerator.GetLocale(pfx "postfix." lPostfixes[lPostfixes.Length], lang)

					data.titlePostfixText .= currentFormatBridge.Get("titlePostfixMulti", &data, &postfixText)
					data.altTitlePostfixText .= currentFormatBridge.Get("titleAltPostfixMulti", &data, &postfixText)
				}
			}

			data.postLetter := useLetterLocale ? LocaleGenerator.GetLocale(interLetter (useLetterLocale ? ".letter_locale" : ""), lang) : letter
			local interPath := originalName

			if useLayoutTitles {
				if hasScript
					interPath := RegExReplace(interPath, "^" lOriginScript "_", "scripts." lScript ".")

				layoutTitle := LocaleGenerator.GetLocale(interPath ".layout_locale", lang)
			}

			if useLetterLocale && useHiddenTags
				data.hiddenLetter := LocaleGenerator.GetLocale({ path: interLetter (useLetterLocale ? ".letter_locale" : ""), end: (useLetterLocale ? ".__hidden" : "") }, lang, True)

			data.lBeforeletter := ""
			data.lAfterletter := ""
			data.lBeforeType := ""
			data.lAfterType := ""
			data.lSecondName := ""

			data.lBeforeTitle := ""
			data.lAfterTitle := ""
			data.lBeforeAltTitle := ""
			data.lAfterAltTitle := ""

			if useHiddenTags {
				data.lHiddenBeforeletter := ""
				data.lHiddenAfterletter := ""
				data.lHiddenBeforeType := ""
				data.lHiddenAfterType := ""
				data.lHiddenSecondName := ""

				data.lHiddenBeforeTitle := ""
				data.lHiddenAfterTitle := ""
				data.lHiddenBeforeAltTitle := ""
				data.lHiddenAfterAltTitle := ""
			}


			data.altTitleUseLineBreak := entry["options"]["altTitleUseLineBreak"]

			local copyNumber := entry["symbol"]["copyNumber"]
			local hasCopyNumber := copyNumber > 0
			data.lCopyNumber := hasCopyNumber ? " [" copyNumber "]" : ""

			if entry["options"]["secondName"] {
				if hasScript
					ref := RegExReplace(ref, "^" lOriginScript "_", "scripts." lScript ".")

				data.lSecondName := " " LocaleGenerator.GetLocale(("Origin" ? RegExReplace(ref, "i)^(.*?)__.*", "$1") : ref) ".second_name", lang)
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
							data.l%boundLink% .= addition + Integer(entry["variantPos"])
							if useHiddenTags
								data.lHidden%boundLink% .= addition + Integer(entry["variantPos"])
							continue
						} else if RegExMatch(boundKey, "^@(.+)$", &match) {
							data.l%boundLink% .= match[1]
							if useHiddenTags
								data.lHidden%boundLink% .= match[1]
							continue
						}

						if RegExMatch(boundKey, "\:\:(.*?)$", &match) {
							local index := Integer(match[1])
							local cleanBound := SubStr(boundKey, 1, match.Pos(0) - 1)
							data.l%boundLink% .= LocaleGenerator.GetLocale((useSelfReference ? interLetter : pfx localeKey) "." cleanBound, lang, , , index) (i < splitted.Length ? data.wordSeparator : "")

							if useHiddenTags
								data.lHidden%boundLink% .= (LocaleGenerator.GetLocale({ path: (useSelfReference ? interLetter : pfx localeKey) "." cleanBound, end: ".__hidden" }, lang, True, , index)) (i < splitted.Length ? data.wordSeparator : "")
						} else {
							data.l%boundLink% .= LocaleGenerator.GetLocale((useSelfReference ? interLetter : pfx localeKey) "." boundKey, lang, , , (InStr(boundLink, "Type") ? lVariant : 1)) (i < splitted.Length ? data.wordSeparator : "")

							if useHiddenTags
								data.lHidden%boundLink% .= (LocaleGenerator.GetLocale({ path: (useSelfReference ? interLetter : pfx localeKey) "." boundKey, end: ".__hidden" }, lang, True, , (InStr(boundLink, "Type") ? lVariant : 1))) (i < splitted.Length ? data.wordSeparator : "")
						}

						if titlelizeFirstLetter {
							data.l%boundLink% := StrTitle(data.l%boundLink%)
							if useHiddenTags
								data.lHidden%boundLink% := StrTitle(data.lHidden%boundLink%)
						}
					}
				}
			}

			if data.lBeforeAltTitle = "" && data.lBeforeTitle != ""
				data.lBeforeAltTitle := data.lBeforeTitle
			if data.lAfterAltTitle = "" && data.lAfterTitle != ""
				data.lAfterAltTitle := data.lAfterTitle

			if useHiddenTags {
				if data.lHiddenBeforeAltTitle = "" && data.lHiddenBeforeTitle != ""
					data.lHiddenBeforeAltTitle := data.lHiddenBeforeTitle
				if data.lHiddenAfterAltTitle = "" && data.lHiddenAfterTitle != ""
					data.lHiddenAfterAltTitle := data.lHiddenAfterTitle
			}

			data.proxyMark := entry["proxy"] != "" ? LocaleGenerator.GetLocale("gen.proxy", lang) : ""
			data.typeIsNeutral := lType = "neutral"

			if isAlt {
				local title := currentFormatBridge.Get("titleAlt", &data)
				title := this.LocaleRules(title, lang, data.wordAltSeparator)

				entry["titles"][langCode] := title
			} else {
				data.localedCase := lCase != "neutral" ? LocaleGenerator.GetLocale(pfx "case." lCase, lang, , , lVariant) : ""

				local title := currentFormatBridge.Get("title", &data)
				title := this.LocaleRules(title, lang, data.wordSeparator)

				entry["titles"][langCode] := title

				data.tagScriptAdditive := scriptAdditive ? LocaleGenerator.GetLocale(pfx "tag." lScript (scriptAdditive), lang, , , lVariant) : ""

				local tag := currentFormatBridge.Get("tag", &data)

				tag := this.LocaleRules(tag, lang, data.wordSeparator)

				tagsCollector[lang].Push(tag)

				if useLayoutTitles {
					titlesCollector[lang].Push(layoutTitle)
					tagsCollector[lang].Push(StrLower(layoutTitle))
				}

				if useHiddenTags && (hiddenTagsLanguage = "" || hiddenTagsLanguage != "" && InStr(hiddenTagsLanguage, langCode)) {

					data.hiddenTagScriptAdditive := scriptAdditive ? (LocaleGenerator.GetLocale({ path: pfx "tag." lScript (scriptAdditive), end: ".__hidden" }, lang, True)) : ""

					local hiddenTag := currentFormatBridge.Get("hiddenTag", &data)
					hiddenTag := this.LocaleRules(hiddenTag, lang, data.wordSeparator)

					hiddenTagsCollector[lang].Push(hiddenTag)
				}
			}


			if !isAlt && entry["symbol"]["tagAdditive"].Length > 0 {
				for tagAdd in entry["symbol"]["tagAdditive"] {
					if tagsCollector.Has(lang) {
						local additiveData := {
							pfx: pfx,
							lang: lang,
							scriptAdditive: scriptAdditive,
							boundsCollector: boundsCollector,
							wordSeparator: data.wordSeparator,
							wordAltSeparator: data.wordAltSeparator,
							proxyMark: data.proxyMark,
						}

						local allowsMultiTitles := entry["options"]["allowsMultiTitles"]

						additiveData.curScript := (tagAdd.Has("script") ? tagAdd["script"] : lScript)
						local curType := (tagAdd.Has("type") ? tagAdd["type"] : lType)
						local curCase := (tagAdd.Has("case") ? tagAdd["case"] : lCase)
						local curLetter := (tagAdd.Has("letter") ? tagAdd["letter"] : letter)
						local curCopyNumber := (tagAdd.Has("copyNumber") ? tagAdd["copyNumber"] : copyNumber)
						local curHasCopyNumber := curCopyNumber > 0
						additiveData.curTagScriptAtStart := (tagAdd.Has("tagScriptAtStart") ? tagAdd["tagScriptAtStart"] : tagScriptAtStart)
						local curAltTitleUseLineBreak := tagAdd.Has("altTitleUseLineBreak") ? tagAdd["altTitleUseLineBreak"] : data.altTitleUseLineBreak
						local curUseHiddenTags := (tagAdd.Has("useHiddenTags") ? tagAdd["useHiddenTags"] : useHiddenTags)

						local useOriginalTypePath := tagAdd.Has("typeOriginPath") ? tagAdd["typeOriginPath"] : False

						local curScriptKey := ChrLib.GetDecomposition("script", additiveData.curScript, "Key", &curScriptDecomposeKey) ? curScriptDecomposeKey : additiveData.curScript
						local curTypeKey := ChrLib.GetDecomposition("type", (useOriginalTypePath ? entryData["type"] : curType), "Key", &curTypeDecomposeKey) ? curTypeDecomposeKey : (useOriginalTypePath ? entryData["type"] : curType)
						local curCaseKey := ChrLib.GetDecomposition("case", curCase, "Key", &curCaseDecomposeKey) ? curCaseDecomposeKey : curCase

						local hasScriptAdditive := tagAdd.Has("scriptAdditive") && StrLen(tagAdd["scriptAdditive"]) > 0
						additiveData.curScriptAdditive := hasScriptAdditive ? "." tagAdd["scriptAdditive"] : ""
						additiveData.typeIsNeutral := curType = "neutral"

						additiveData.curLVariant := ["digraph", "symbol", "sign", "syllable", "glyph"].HasValue(curType) ? 2 : curType = "numeral" ? 3 : 1
						additiveData.curIsGermanic := ["germanic_runic", "cirth_runic"].HasValue(additiveData.curScript)

						additiveData.lAdditionalBeforeLetter := ""
						additiveData.lAdditionalAfterLetter := ""
						additiveData.lAdditionalBeforeType := ""
						additiveData.lAdditionalAfterType := ""
						additiveData.lAdditionalCopyNumber := curHasCopyNumber ? " [" curCopyNumber "]" : ""

						additiveData.lAdditionalBeforeTitle := ""
						additiveData.lAdditionalAfterTitle := ""

						if curUseHiddenTags {
							additiveData.lHiddenAdditionalBeforeletter := ""
							additiveData.lHiddenAdditionalAfterletter := ""
							additiveData.lHiddenAdditionalBeforeType := ""
							additiveData.lHiddenAdditionalAfterType := ""

							additiveData.lHiddenAdditionalBeforeTitle := ""
							additiveData.lHiddenAdditionalAfterTitle := ""
							additiveData.lHiddenAdditionalBeforeAltTitle := ""
							additiveData.lHiddenAdditionalAfterAltTitle := ""
						}

						local draftRef := StrLower("scripts." additiveData.curScript "." curCaseKey "_" curTypeKey "_" curLetter)

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
										additiveData.lAdditional%boundLink% .= addition + Integer(entry["variantPos"])
										if curUseHiddenTags
											additiveData.lHiddenAdditional%boundLink% .= addition + Integer(entry["variantPos"])
										continue
									} else if RegExMatch(boundKey, "^@(.+)$", &match) {
										additiveData.lAdditional%boundLink% .= match[1]
										if curUseHiddenTags
											additiveData.lHiddenAdditional%boundLink% .= match[1]
										continue
									}

									if RegExMatch(boundKey, "\:\:(.*?)$", &match) {
										local index := Integer(match[1])
										local cleanBound := SubStr(boundKey, 1, match.Pos(0) - 1)
										additiveData.lAdditional%boundLink% .= LocaleGenerator.GetLocale((useSelfReference ? draftRef : pfx localeKey) "." cleanBound, lang, , , index) (i < splitted.Length ? data.wordSeparator : "")

										if curUseHiddenTags {
											additiveData.lHiddenAdditional%boundLink% .= LocaleGenerator.GetLocale({ path: (useSelfReference ? draftRef : pfx localeKey) "." cleanBound, end: ".__hidden" }, lang, True, , index)
										}
									} else {
										additiveData.lAdditional%boundLink% .= LocaleGenerator.GetLocale((useSelfReference ? draftRef : pfx localeKey) "." boundKey, lang, , , (InStr(boundLink, "Type") ? additiveData.curLVariant : 1)) (i < splitted.Length ? data.wordSeparator : "")

										if curUseHiddenTags {
											additiveData.lHiddenAdditional%boundLink% .= LocaleGenerator.GetLocale({ path: (useSelfReference ? draftRef : pfx localeKey) "." boundKey, end: ".__hidden" }, lang, True)
										}
									}

									if titlelizeFirstLetter {
										additiveData.lAdditional%boundLink% := StrTitle(additiveData.lAdditional%boundLink%)
										if curUseHiddenTags {
											additiveData.lHiddenAdditional%boundLink% := StrTitle(additiveData.lHiddenAdditional%boundLink%)
										}
									}
								}
							}
						}

						if curUseHiddenTags {
							if additiveData.lHiddenAdditionalBeforeAltTitle = "" && additiveData.lHiddenAdditionalBeforeTitle != ""
								additiveData.lHiddenAdditionalBeforeAltTitle := additiveData.lHiddenAdditionalBeforeTitle
							if additiveData.lHiddenAdditionalAfterAltTitle = "" && additiveData.lHiddenAdditionalAfterTitle != ""
								additiveData.lHiddenAdditionalAfterAltTitle := additiveData.lHiddenAdditionalAfterTitle
						}

						if additiveData.curIsGermanic {
							local lBuildedName := StrLower("scripts." additiveData.curScript "." curCaseKey "_" curTypeKey "_" letter (hasScriptAdditive ? "_" tagAdd["scriptAdditive"] : "") "_" curLetter) ".letter_locale"
							additiveData.additionalPostLetter := LocaleGenerator.GetLocale(lBuildedName, lang)

							local aLScript := LocaleGenerator.GetLocale(pfx "tag." additiveData.curScript, lang, , , additiveData.curLVariant)
							local aScriptAdditive := hasScriptAdditive ? data.wordSeparator LocaleGenerator.GetLocale(pfx "tag." additiveData.curScript additiveData.curScriptAdditive, lang, , , additiveData.curLVariant) : ""
							local aLType := LocaleGenerator.GetLocale(pfx "type." curType, lang)

							tagsCollector[lang].Push(
								additiveData.lAdditionalBeforeTitle
								aLScript
								additiveData.lAdditionalBeforeType
								aLType
								additiveData.lAdditionalAfterType
								aScriptAdditive data.wordSeparator
								additiveData.lAdditionalBeforeLetter
								additiveData.additionalPostLetter
								additiveData.lAdditionalAfterLetter
								additiveData.lAdditionalCopyNumber
								additiveData.lAdditionalAfterTitle
							)

							if curUseHiddenTags && (hiddenTagsLanguage = "" || hiddenTagsLanguage != "" && InStr(hiddenTagsLanguage, lang)) {
								additiveData.additionalHiddenLetter := LocaleGenerator.GetLocale({ path: lBuildedName, end: ".__hidden" }, lang, True)
								local aLHiddenScript := LocaleGenerator.GetLocale({ path: pfx "tag." additiveData.curScript, end: ".__hidden" }, lang, True)
								local aHiddenScriptAdditive := hasScriptAdditive ? data.wordSeparator (LocaleGenerator.GetLocale({ path: pfx "tag." additiveData.curScript additiveData.curScriptAdditive, end: ".__hidden" }, lang, True)) : ""
								local aLHiddenType := LocaleGenerator.GetLocale({ path: pfx "type." curType, end: ".__hidden" }, lang, True)

								local tag := (
									additiveData.lHiddenAdditionalBeforeTitle
									aLHiddenScript
									additiveData.lHiddenAdditionalBeforeType
									data.wordSeparator aLHiddenType
									additiveData.lHiddenAdditionalAfterType
									aHiddenScriptAdditive data.wordSeparator
									additiveData.lHiddenAdditionalBeforeletter
									additiveData.additionalHiddenLetter
									additiveData.lHiddenAdditionalAfterletter
									additiveData.lAdditionalCopyNumber
									additiveData.lHiddenAdditionalAfterTitle
								)

								hiddenTagsCollector[lang].Push(this.LocaleRules((tag), lang))
							}


						} else {
							local lBuildedName := StrLower("scripts." additiveData.curScript "." curCaseKey "_" curTypeKey "_" curLetter (hasScriptAdditive ? "_" tagAdd["scriptAdditive"] : "")) ".letter_locale"
							additiveData.additionalPostLetter := LocaleGenerator.GetLocale(lBuildedName, lang)

							additiveData.localedCase := curCase != "neutral" ? LocaleGenerator.GetLocale(pfx "case." curCase, lang, , , additiveData.curLVariant) : ""
							additiveData.scriptTag := LocaleGenerator.GetLocale(pfx "tag." additiveData.curScript, lang, , , additiveData.curLVariant)
							additiveData.typeTag := LocaleGenerator.GetLocale(pfx "type." curType, lang)

							local tag := currentFormatBridge.Get("additiveTag", &additiveData)
							tagsCollector[lang].Push(this.LocaleRules((tag), lang))

							if titlesCollector.Has(lang) && (allowsMultiTitles || tagAdd.Has("script")) {

								local title := currentFormatBridge.Get("additiveTitle", &additiveData)
								titlesCollector[lang].Push(this.LocaleRules((title), lang))
							}

							if curUseHiddenTags && (hiddenTagsLanguage = "" || hiddenTagsLanguage != "" && InStr(hiddenTagsLanguage, lang)) {
								additiveData.additionalHiddenLetter := LocaleGenerator.GetLocale({ path: lBuildedName, end: ".__hidden" }, lang, True)
								additiveData.localedHiddenCase := curCase != "neutral" ? (LocaleGenerator.GetLocale({ path: pfx "case." curCase, end: ".__hidden" }, lang, True, , additiveData.curLVariant)) : ""
								additiveData.scriptHiddenTag := LocaleGenerator.GetLocale({ path: pfx "tag." additiveData.curScript, end: ".__hidden" }, lang, True, , additiveData.curLVariant)
								additiveData.typeHiddenTag := LocaleGenerator.GetLocale({ path: pfx "type." curType, end: ".__hidden" }, lang, True)

								local tag := currentFormatBridge.Get("additiveHiddenTag", &additiveData)
								tag := this.LocaleRules(tag, lang)

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

		for lang in handlingLocales {
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

	static localeRuleSets := Map(
		"ru-RU", Map(
			"conjunction", (str, lang, spaceSymbol := Chr(160)) => (InStr(str, "{conjuction}" spaceSymbol "с") || InStr(str, "{conjuction}" spaceSymbol "ш")) ? RegExReplace(str, "\{conjuction\}", LocaleGenerator.GetLocale("generated.postfix.with_2", lang)) : RegExReplace(str, "\{conjuction\}", LocaleGenerator.GetLocale("generated.postfix.with", lang))
		),
		"en-US", Map(
			"conjunction", (str, lang, *) => RegExReplace(str, "\{conjuction\}", LocaleGenerator.GetLocale("generated.postfix.with", lang)
			)
		)
	)

	static AddRule(lang, key, rule) {
		if !LocaleGenerator.localeRuleSets.Has(lang)
			LocaleGenerator.localeRuleSets.Set(lang, Map())

		LocaleGenerator.localeRuleSets[lang].Set(key, rule)
	}

	static ReferenceToRule(lang, key) {
		if LocaleGenerator.localeRuleSets.Has(lang) && LocaleGenerator.localeRuleSets[lang].Has(key)
			return LocaleGenerator.localeRuleSets[lang][key]
	}

	LocaleRules(input, lang, spaceSymbol := Chr(160)) {
		lang := RegExReplace(lang, "_alt")

		if LocaleGenerator.localeRuleSets.Has(lang)
			for key, rule in LocaleGenerator.localeRuleSets[lang]
				input := rule(input, lang, spaceSymbol)

		return input
	}
}