Class ChrEntry {
	data {
		get {
			return Map(
				"index", 0,
				"proxy", "",
				"modifiedKeys", [],
				"unicode", "",
				"unicodeBlock", "",
				"sequence", [],
				"result", [],
				"entity", "",
				"altCode", [],
				"altCodePages", [],
				"LaTeX", [],
				"LaTeXPackage", "",
				"titles", Map(),
				"altTitlesMap", Map(),
				"altTitles", [],
				"name", "",
				"filePath", "",
				"tags", [],
				"tagsMap", Map(),
				"hiddenTags", [],
				"hiddenTagsMap", Map(),
				"groups", [],
				"alterations", Map(),
				"options", Map(
					"noCalc", False,
					"hidden", False,
					"suggestionsAtEnd", False,
					"secondName", False,
					"useLetterLocale", False,
					"layoutTitles", False,
					"layoutTitlesAsMain", False,
					"referenceLocale", "",
					"useSelfPostfixesOnReferenceLocale", True,
					"localeCombineAnd", False,
					"legend", False,
					"preventLaTeX", False,
					"preventAltCode", False,
					"usesDiacritics", False,
					"applyFontOnRecipeField", True,
					"isTagsMirrored", False,
					"altTitleUseLineBreak", False,
					"allowsMultiTitles", False,
					"ignoreCaseOnPanelFilter", False,
					"useHiddenTags", False,
					"hiddenTagsLanguage", "",
					"altLayoutKey", "",
					"showOnAlt", "",
					"altSpecialKey", "",
					"fastKey", "",
					"specialKey", "",
					"numericValue", 0,
					"send", "",
				),
				"recipe", [],
				"recipeAlt", [],
				"symbol", Map(
					"category", "",
					"letter", "",
					"type", "",
					"afterLetter", "",
					"beforeLetter", "",
					"afterType", "",
					"beforeType", "",
					"afterTitle", "",
					"beforeTitle", "",
					"afterAltTitle", "",
					"beforeAltTitle", "",
					"copyNumber", 0,
					"scriptAdditive", "",
					"scriptBounds", [],
					"tagAdditive", [],
					"set", "",
					"view", "",
					"alt", "",
					"customs", "",
					"font", "",
				),
				"data", Map("script", "", "originScript", "", "case", "", "type", "", "letter", "", "endPart", "", "postfixes", []),
				"variant", "",
				"variantPos", 1,
				"isXCompose", False,
			)
		}
	}

	__New() {

	}

	Get(attributes := Map()) {
		local root := this.data

		if !attributes.Has("modifiedKeys") || attributes["modifiedKeys"].Length = 0
			attributes["modifiedKeys"] := attributes.Keys()

		if !attributes.Has("reference")
			attributes["reference"] := ""

		attributes := this.Proxying(&root, &attributes)

		for attribKey, attribValue in attributes {
			if attribValue is Array {
				root[attribKey] := []
				root[attribKey] := attribValue.Clone()
			} else if attribValue is Map {
				if !root.Has(attribKey)
					root[attribKey] := Map()
				for childKey, childValue in attribValue
					root[attribKey].Set(childKey, childValue)
			} else if attribValue is Object {
				if !root.Has(attribKey)
					root[attribKey] := {}
				for childKey, childValue in attribValue.OwnProps() {
					root[attribKey].%childKey% := childValue
				}
			} else {
				root[attribKey] := attribValue
			}
		}

		if StrLen(root["proxy"]) > 0
			root["options"]["noCalc"] := True

		return root
	}

	Proxying(&root, &attributes) {
		if attributes.Has("proxy") && StrLen(attributes["proxy"]) > 0 {
			local proxyName := attributes["proxy"]
			local proxyEntry := ChrLib.GetEntry(proxyName)

			if !proxyEntry
				return attributes


			local blacklist := ["groups", "options", "recipe", "recipeAlt", "symbol", "data", "titles", "tags"]

			for proxyAttribKey, proxyAttribValue in proxyEntry {
				if blacklist.Has(proxyAttribKey) && attributes.Has(proxyAttribKey)
					continue

				if proxyAttribValue is Array {
					root[proxyAttribKey] := proxyAttribValue.Clone()
				} else if proxyAttribValue is Map {
					root[proxyAttribKey] := Map()
					for childKey, childValue in proxyAttribValue
						root[proxyAttribKey].Set(childKey, childValue)
				} else if proxyAttribValue is Object {
					root[proxyAttribKey] := {}
					for childKey, ChildValue in proxyAttribValue.OwnProps() {
						root[proxyAttribKey].%childKey% := ChildValue
					}
				} else {
					root[proxyAttribKey] := proxyAttribValue
				}
			}

			for proxyAttribKey, proxyAttribValue in attributes {
				if proxyAttribValue is Array {
					root[proxyAttribKey] := proxyAttribValue.Clone()
				} else if proxyAttribValue is Map && root.Has(proxyAttribKey) {
					for childKey, ChildValue in proxyAttribValue
						root[proxyAttribKey].Set(childKey, ChildValue)
				} else if proxyAttribValue is Object && root.Has(proxyAttribKey) {
					for childKey, ChildValue in proxyAttribValue.OwnProps() {
						root[proxyAttribKey].%childKey% := ChildValue
					}
				} else {
					root[proxyAttribKey] := proxyAttribValue
				}
			}

			return root
		}

		return attributes
	}
}