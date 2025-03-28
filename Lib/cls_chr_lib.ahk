class ChrLib {

	static entries := {}
	static entryGroups := Map()
	static entryCategories := Map()
	static entryRecipes := Map()
	static entryTags := Map()
	static duplicatesList := []
	static lastIndexAdded := -1

	static AddEntry(entryName, entry) {

		if RegExMatch(entryName, "\[(.*?)\]", &match) {
			splitVariants := StrSplit(match[1], ",")
			entries := {}

			for i, variant in splitVariants {
				variantName := RegExReplace(entryName, "\[.*?\]", variant)
				entries.%variantName% := entry.Clone()
				entries.%variantName%.unicode := entry.unicode[i]
				entries.%variantName% := this.SetDecomposedData(variantName, entries.%variantName%)
				if entry.hasOwnProp("symbol") {
					entries.%variantName%.symbol := entry.symbol.Clone()
					if entries.%variantName%.symbol.HasOwnProp("letter") {
						entries.%variantName%.symbol.letter := entry.symbol.letter[i]
					}
				}
				if entry.hasOwnProp("alterations") {
					entries.%variantName%.alterations := entry.alterations[i].Clone()
				}
				if entry.hasOwnProp("recipe") && entry.recipe.Length > 0 && IsObject(entry.recipe[entry.recipe.Length]) {
					entries.%variantName%.recipe := entry.recipe[i].Clone()
				}
			}

			for entryName, entry in entries.OwnProps() {
				if entry.hasOwnProp("recipe") && entry.recipe.Length > 0 {
					tempRecipe := entry.recipe.Clone()
					for i, recipe in tempRecipe {
						tempRecipe[i] := RegExReplace(tempRecipe[i], "\[.*?\]", SubStr(entry.data.case, 1, 1))
						tempRecipe[i] := RegExReplace(tempRecipe[i], "@", entry.data.letter)
					}

					entry.recipe := tempRecipe
				}

				this.AddEntry(entryName, entry)
			}

		} else {
			if !entry.HasOwnProp("data")
				entry := this.SetDecomposedData(entryName, entry)

			this.entries.%entryName% := {}

			for key, value in entry.OwnProps() {
				if value is Func {
					definedValue := value
					this.entries.%entryName%.DefineProp(key, { Get: (*) => definedValue(), Set: (this, value) => this.DefineProp(key, { Get: (*) => value }) })
				} else if key = "recipe" && value.Length > 0 {
					tempRecipe := value.Clone()

					definedRecipe := (*) => this.MakeRecipe(tempRecipe)
					interObj := {}
					interObj.DefineProp("Get", { Get: definedRecipe, Set: definedRecipe })

					this.entries.%entryName%.%key% := interObj.Get
				} else if Util.IsArray(value) {
					this.entries.%entryName%.%key% := []
					for subValue in value {
						if subValue is Func {
							interObj := {}
							interObj.DefineProp("Get", { Get: subValue, Set: subValue })
							if Util.IsArray(interObj.Get) {
								for interValue in interObj.Get {
									this.entries.%entryName%.%key%.Push(interValue)
								}
							} else {
								this.entries.%entryName%.%key%.Push(interObj.Get)
							}
						} else {
							this.entries.%entryName%.%key%.Push(subValue)
						}
					}
				} else if IsObject(value) {
					this.entries.%entryName%.%key% := {}
					for subKey, subValue in value.OwnProps() {
						if subValue is Func {
							this.entries.%entryName%.%key%.DefineProp(subKey, { Get: subValue, Set: subValue })
						} else {
							this.entries.%entryName%.%key%.%subKey% := subValue
						}
					}
				} else {
					this.entries.%entryName%.%key% := value
				}
			}

			this.entries.%entryName%.index := this.lastIndexAdded + 1

			this.lastIndexAdded := this.entries.%entryName%.index

			this.EntryPostProcessing(entryName, this.entries.%entryName%)
		}
	}

	static AddEntries(arguments*) {
		Loop arguments.Length // 2 {
			index := A_Index * 2 - 1
			entryName := arguments[index]
			entryValue := arguments[index + 1]
			this.AddEntry(entryName, entryValue)
		}
		return
	}

	static RemoveEntry(entryName) {
		if this.entries.HasOwnProp(entryName) {
			entry := this.GetEntry(entryName)

			scenarios := Map(
				"groups", { source: entry.groups, target: this.entryGroups },
				"tags", { source: entry.tags, target: this.entryTags }
			)

			for scenarioName, scenario in scenarios {
				for item in scenario.source {
					if scenario.target.Has(item) && scenario.target.Get(item).HasValue(entryName) {
						intermediateArray := scenario.target.Get(item)
						intermediateArray.RemoveValue(entryName)

						scenario.target.Delete(item)
						scenario.target.Set(item, intermediateArray)
					}
				}
			}

			this.entries.DeleteProp(entryName)
		}
	}

	static GetEntry(entryName) {
		if this.entries.HasOwnProp(entryName) {
			return this.entries.%entryName%
		} else {
			return False
		}
	}

	static GetValue(entryName, value, useRef := False, &output?) {
		if useRef {
			if this.entries.%entryName%.HasOwnProp(value) {
				output := this.entries.%entryName%.%value%
				return True
			} else {
				return False
			}
		} else {
			return this.entries.%entryName%.%value%
		}
	}

	static Get(entryName, extraRules := False, getMode := "Unicode") {
		entry := this.GetEntry(entryName)
		output := ""

		if StrLen(getMode) = 0 {
			getMode := "Unicode"
		}

		if getMode = "HTML" && entry.HasOwnProp("html") {
			if (extraRules && StrLen(AlterationActiveName) > 0) && entry.HasOwnProp("alterations") && entry.alterations.HasOwnProp(AlterationActiveName) {
				output .= entry.alterations.%AlterationActiveName%HTML

			} else {
				output .= entry.HasOwnProp("entity") ? entry.entity : entry.html
			}

		} else if getMode = "LaTeX" && entry.HasOwnProp("LaTeX") {
			output .= (entry.LaTeX.Length = 2 && Cfg.Get("LaTeX_Mode") = "Math") ? entry.LaTeX[2] : entry.LaTeX[1]

		} else {
			if (extraRules && StrLen(AlterationActiveName) > 0) && entry.HasOwnProp("alterations") && entry.alterations.HasOwnProp(AlterationActiveName) {
				output .= Util.UnicodeToChar(entry.alterations.%AlterationActiveName%)

			} else if (extraRules && getMode != "Unicode") && entry.HasOwnProp("alterations") && entry.alterations.HasOwnProp(getMode) {
				output .= Util.UnicodeToChar(entry.alterations.%getMode%)

			} else {
				output .= Util.UnicodeToChar(entry.HasOwnProp("sequence") ? entry.sequence : entry.unicode)
			}
		}

		return output
	}

	static EntryPreview(entryName, indent := 0) {
		entry := this.GetEntry(entryName)
		output := this.FormatEntry(entry, indent)
		MsgBox(output)
	}

	static FormatEntry(entry, indent) {
		output := ""
		indentStr := Util.StrRepeat("`t", indent)

		for key, value in entry.OwnProps() {
			if IsObject(value) {
				output .= indentStr key ":`n" . this.FormatEntry(value, indent + 1)
			} else {
				output .= indentStr key ": " value "`n"
			}
		}

		return output
	}

	static Gets(entryNames*) {
		output := ""
		indexMap := Map()

		charIndex := 0
		for i, character in entryNames {
			charIndex++
			repeatCount := 1
			characterMatch := character

			if RegExMatch(characterMatch, "(.+?)\[(\d+(?:,\d+)*)\]$", &match) {
				if RegExMatch(match[1], "(.+?)×(\d+)$", &subMatch) {
					character := subMatch[1]
					repeatCount := subMatch[2]
				} else {
					character := match[1]
				}
				Positions := StrSplit(match[2], ",")
				for _, Position in Positions {
					Position := Number(Position)
					if !IndexMap.Has(Position) {
						IndexMap[Position] := []
					}
					IndexMap[Position].Push([character, repeatCount])
				}
				continue
			} else if RegExMatch(characterMatch, "(.+?)×(\d+)$", &match) {
				character := match[1]
				repeatCount := match[2]
				continue
			}

			if !IndexMap.Has(charIndex) {
				IndexMap[charIndex] := []
			}
			IndexMap[charIndex].Push([character, repeatCount])
		}

		for indexEntry, value in indexMap {
			for _, charData in value {
				setSequence(charData[1], charData[2])
			}
		}

		setSequence(entryName, repeatCount) {
			Loop repeatCount {
				output .= ChrLib.Get(entryName)
			}
		}

		return output
	}

	static MakeRecipe(recipes*) {
		output := []
		interArr := []


		for recipe in recipes {
			if Util.IsArray(recipe) {
				for recipeEntry in recipe {
					interArr.Push(recipeEntry)
				}
			} else
				interArr.Push(recipe)
		}


		for recipe in interArr {
			test := False
			if InStr(recipe, "breve") {
				test := True
				;msgbox("Breve detected in recipe: " recipe)
			}
			if InStr(recipe, "${") {
				if RegExMatch(recipe, "\((.*?)\|(.*?)\)", &match) {
					recipePair := [
						RegExReplace(recipe, "\((.*?)\|(.*?)\)", match[1]),
						RegExReplace(recipe, "\((.*?)\|(.*?)\)", match[2])
					]
					recipePair[1] := StrReplace(recipePair[1], "$(*)", "${" match[2] "}")
					recipePair[2] := StrReplace(recipePair[2], "$(*)", "${" match[1] "}")


					for recipe in recipePair {
						while RegExMatch(recipe, "\${(.*?)}", &subMatch) {
							characterName := subMatch[1]
							characterAlteration := ""
							hasAlteration := False

							if RegExMatch(characterName, "\:\:(.*?)$", &alterationMatch) {
								characterAlteration := alterationMatch[1]
								hasAlteration := True
								characterName := RegExReplace(characterName, "\:\:.*$", "")
							}
							try {
								recipe := RegExReplace(recipe, "\${" subMatch[1] "}", this.Get(characterName, hasAlteration, characterAlteration))
							} catch {
								throw "Error in recipe: " recipe " with character: " characterName
							}
						}
						output.Push(recipe)
					}
				} else {
					while RegExMatch(recipe, "\${(.*?)}", &match) {

						characterName := match[1]
						characterAlteration := ""
						hasAlteration := False

						if RegExMatch(characterName, "\:\:(.*?)$", &alterationMatch) {
							characterAlteration := alterationMatch[1]
							hasAlteration := True
							characterName := RegExReplace(characterName, "\:\:.*$", "")
						}

						recipe := RegExReplace(recipe, "\${" match[1] "}", this.Get(characterName, hasAlteration, characterAlteration))
					}

					output.Push(recipe)

				}
			} else {
				output.Push(recipe)
			}

		}


		return output
	}

	static GeneratePermutations(items) {
		if items.Length = 1 {
			return [items[1]]
		}

		permutations := []
		for i, item in items {
			remaining := items.Clone()
			remaining.RemoveAt(i)
			subPermutations := this.GeneratePermutations(remaining)
			for subPerm in subPermutations {
				permutations.Push(item subPerm)
			}
		}

		return permutations
	}


	static GetRecipe(entryName, formatted := False, formatChar := ", ") {
		output := []
		if this.entries.%entryName%.HasOwnProp("recipeAlt") && this.entries.%entryName%.recipeAlt.Length > 0 {
			output := this.entries.%entryName%.recipeAlt
		} else if this.entries.%entryName%.HasOwnProp("recipe") && this.entries.%entryName%.recipe.Length > 0 {
			output := this.entries.%entryName%.recipe
		}

		output := formatted && output.length > 0 ? output.ToString(formatChar) : output
		return output
	}

	static Count(groupRestrict?) {
		count := 0
		for entry, value in this.entries.OwnProps() {
			if !IsSet(groupRestrict) || (IsSet(groupRestrict) && value.groups.HasValue(groupRestrict)) {
				if !(value.options.noCalc) {
					count++
				}

				if value.HasOwnProp("alterations") {
					for alteration, value in value.alterations.OwnProps() {
						if !InStr(alteration, "HTML") {
							count++
						}
					}
				}
			}
		}

		return count
	}

	static SearchPrompt() {
		searchQuery := Cfg.Get("Search", "LatestPrompts", "")
		resultObj := { result: "", prompt: "", send: (*) => "" }
		IB := InputBox(Locale.Read("symbol_search_prompt"), Locale.Read("symbol_search"), "w350 h110", searchQuery)
		if IB.Result = "Cancel"
			return resultObj
		else
			searchQuery := IB.Value

		if searchQuery == "\" {
			Reload
			return resultObj
		}

		resultObj.result := this.Search(searchQuery)
		resultObj.prompt := searchQuery
		resultObj.send := (*) => SendText(resultObj.result)

		if StrLen(resultObj.result) > 0 {
			Cfg.Set(searchQuery, "Search", "LatestPrompts")
		}

		return resultObj
	}

	static Search(searchQuery) {
		isSensitive := SubStr(searchQuery, 1, 1) = "*"
		if isSensitive
			searchQuery := SubStr(searchQuery, 2)

		checkTagExact(tag) {
			if isSensitive
				return searchQuery == tag
			return StrLower(searchQuery) = StrLower(tag)
		}

		checkTagPartial(tag) {
			if isSensitive
				return RegExMatch(tag, searchQuery)
			return RegExMatch(StrLower(tag), StrLower(searchQuery))
		}

		checkTagLowAcc(tag) {
			if isSensitive
				return Util.HasAllCharacters(tag, searchQuery)
			return Util.HasAllCharacters(StrLower(tag), StrLower(searchQuery))
		}

		for entryName, entry in this.entries.OwnProps() {
			if !entry.HasOwnProp("tags")
				continue

			for _, tag in entry.tags {
				if checkTagExact(tag)
					return this.Get(entryName, True, Cfg.Get("Input_Mode", , "Unicode"))
			}
		}

		for entryName, entry in this.entries.OwnProps() {
			if !entry.HasOwnProp("tags")
				continue

			for _, tag in entry.tags {
				if checkTagPartial(tag)
					return this.Get(entryName, True, Cfg.Get("Input_Mode", , "Unicode"))
			}
		}

		for entryName, entry in this.entries.OwnProps() {
			if !entry.HasOwnProp("tags")
				continue

			for _, tag in entry.tags {
				if checkTagLowAcc(tag)
					return this.Get(entryName, True, Cfg.Get("Input_Mode", , "Unicode"))
			}
		}

		return ""
	}

	static PostProcess() {
		for entryName, entry in this.entries.OwnProps() {
			this.EntryPostProcessing(entryName, entry)
		}
	}
	static EntryPostProcessing(entryName, entry) {
		refinedEntry := entry
		character := Util.UnicodeToChar(refinedEntry.unicode)
		characterSequence := Util.UnicodeToChar(refinedEntry.HasOwnProp("sequence") ? refinedEntry.sequence : refinedEntry.unicode)

		if refinedEntry.hasOwnProp("sequence") {
			for sequenceChr in refinedEntry.sequence {
				if !refinedEntry.HasOwnProp("html")
					refinedEntry.html := ""
				refinedEntry.html .= "&#" Util.ChrToDecimal(Util.UnicodeToChar(sequenceChr)) ";"
			}
		} else {
			refinedEntry.html := "&#" Util.ChrToDecimal(character) ";"
		}

		if refinedEntry.HasOwnProp("alterations") {
			for alteration, value in refinedEntry.alterations.OwnProps() {
				if !InStr(alteration, "HTML")
					refinedEntry.alterations.%alteration%HTML := "&#" Util.ChrToDecimal(Util.UnicodeToChar(value)) ";"
			}
		}

		for i, altCodeSymbol in AltCodesLibrary {
			if Mod(i, 2) = 1 {
				AltCode := AltCodesLibrary[i + 1]

				if character == altCodeSymbol {
					if !refinedEntry.HasOwnProp("altCode") {
						refinedEntry.altCode := ""
					}

					if !InStr(refinedEntry.altCode, AltCode) {
						refinedEntry.altCode .= AltCode " "
					}
				}
			}
		}

		for i, entitySymbol in EntitiesLibrary {
			if Mod(i, 2) = 1 {
				entityCode := EntitiesLibrary[i + 1]

				if character == entitySymbol {
					refinedEntry.entity := entityCode
					break
				}
			}
		}

		if !refinedEntry.HasOwnProp("options")
			refinedEntry.options := { noCalc: False }
		else if !refinedEntry.options.HasOwnProp("noCalc")
			refinedEntry.options.noCalc := False

		if !refinedEntry.HasOwnProp("symbol") {
			refinedEntry.symbol := { category: "N/A" }
			refinedEntry.symbol.set := characterSequence
		}

		if !refinedEntry.HasOwnProp("alterations")
			refinedEntry.alterations := {}

		if !refinedEntry.HasOwnProp("groups")
			refinedEntry.groups := ["Default Group"]

		if !refinedEntry.HasOwnProp("recipes")
			refinedEntry.recipes := []
		if !refinedEntry.HasOwnProp("recipe")
			refinedEntry.recipe := refinedEntry.recipes
		if !refinedEntry.HasOwnProp("recipeAlt")
			refinedEntry.recipeAlt := []

		if !refinedEntry.HasOwnProp("tags")
			refinedEntry.tags := []


		for group in ["fastKey", "specialKey", "altLayoutKey"] {
			if refinedEntry.options.HasOwnProp(group) {
				refinedEntry.options.%group% := Util.ReplaceModifierKeys(refinedEntry.options.%group%)
			} else {
				refinedEntry.options.%group% := ""
			}
		}

		if refinedEntry.HasOwnProp("symbol") {
			hasSet := refinedEntry.symbol.HasOwnProp("set")
			hasCustoms := refinedEntry.symbol.HasOwnProp("customs")
			hasFont := refinedEntry.symbol.HasOwnProp("font")

			if refinedEntry.symbol.HasOwnProp("category") {
				category := refinedEntry.symbol.category

				refinedEntry.symbol.set := (category = "Diacritic Mark" ? Chr(0x25CC) characterSequence : characterSequence)
				if category = "Diacritic Mark" {
					if !hasCustoms
						refinedEntry.symbol.customs := "s72"
					if !hasFont
						refinedEntry.symbol.font := "Cambria"
				} else if category = "Spaces" && !hasCustoms {
					refinedEntry.symbol.customs := "underline"
				}
			} else {
				refinedEntry.symbol.category := "N/A"
				if !hasSet
					refinedEntry.symbol.set := characterSequence
			}

			if RegExMatch(entryName, "i)^(permic|hungarian|north_arabian|south_arabian)", &match) {
				scriptName := StrReplace(match[1], "_", " ")
				refinedEntry.symbol.font := "Noto Sans Old " scriptName
			} else if RegExMatch(entryName, "i)^(ugaritic)", &match) {
				scriptName := StrReplace(match[1], "_", " ")
				refinedEntry.symbol.font := "Noto Sans " scriptName
			} else if RegExMatch(entryName, "i)^(alchemical|astrological|astronomical|symbolistics|ugaritic)") {
				refinedEntry.symbol.font := "Kurinto Sans"
			} else if InStr(entryName, "phoenician") {
				refinedEntry.symbol.font := "Segoe UI Historic"
			}
		}

		for group in refinedEntry.groups {
			if !this.entryGroups.Has(group)
				this.entryGroups.Set(group, [])

			if !this.entryGroups.Get(group).HasValue(entryName)
				this.entryGroups[group].Push(entryName)
		}

		if !this.entryCategories.Has(refinedEntry.symbol.category)
			this.entryCategories.Set(refinedEntry.symbol.category, [])

		if !this.entryCategories.Get(refinedEntry.symbol.category).HasValue(entryName)
			this.entryCategories[refinedEntry.symbol.category].Push(entryName)

		if refinedEntry.hasOwnProp("tags") && refinedEntry.tags.Length > 0 {
			for tag in refinedEntry.tags {
				if !this.entryTags.Has(tag)
					this.entryTags.Set(tag, [])

				this.entryTags[tag].Push(entryName)
			}
		}

		dataLetter := (refinedEntry.symbol.HasOwnProp("letter") && StrLen(refinedEntry.symbol.letter) > 0) ? refinedEntry.symbol.letter : refinedEntry.data.letter

		if StrLen(refinedEntry.data.letter) > 0 {
			if refinedEntry.recipe.Length > 0 {
				for i, recipe in refinedEntry.recipe {
					refinedEntry.recipe[i] := RegExReplace(recipe, "\$", dataLetter)
				}
			}

			if StrLen(refinedEntry.options.fastKey) > 0 {
				refinedEntry.options.fastKey := RegExReplace(refinedEntry.options.fastKey, "\$", "[" dataLetter "]")
			}
		}


		if refinedEntry.recipe.Length > 0 {
			for recipe in refinedEntry.recipe {
				if !this.entryRecipes.Has(recipe) {
					this.entryRecipes.Set(recipe, { chr: Util.UnicodeToChar(refinedEntry.hasOwnProp("sequence") ? refinedEntry.sequence : refinedEntry.unicode), index: refinedEntry.index })
				} else {
					this.duplicatesList.Push(recipe)
				}
			}
		}

		if refinedEntry.recipeAlt.Length = 0 && refinedEntry.recipe.Length > 0 {
			refinedEntry.recipeAlt := refinedEntry.recipe.Clone()

			for diacriticName in this.entryCategories["Diacritic Mark"] {
				diacriticChr := this.Get(diacriticName)
				for i, altRecipe in refinedEntry.recipeAlt {
					if InStr(altRecipe, diacriticChr) {
						refinedEntry.recipeAlt[i] := RegExReplace(altRecipe, diacriticChr, DottedCircle diacriticChr)
					}
				}
			}
		}

		if StrLen(refinedEntry.data.script) > 0 && StrLen(refinedEntry.data.case) > 0 && StrLen(refinedEntry.data.letter) > 0 {
			refinedEntry := this.LocalesGeneration(entryName, refinedEntry)
		}

		this.entries.%entryName% := refinedEntry
	}

	static NameDecompose(entryName) {
		decomposedName := {
			script: Map("lat", "latin", "cyr", "cyrillic", "hel", "hellenic"),
			case: Map("c", "capital", "s", "small", "sc", "small_capital", "i", "inter"),
			type: Map("let", "letter", "lig", "ligature", "dig", "digraph"),
			letter: "",
			postfixes: []
		}

		foundScript := False

		for key, value in decomposedName.script {
			if RegExMatch(entryName, "^" key "_") {
				foundScript := True
				break
			}
		}

		if !foundScript
			return entryName

		for key, value in decomposedName.case {
			if !RegExMatch(entryName, "i)_" key "_") {
				foundScript := False
			} else {
				foundScript := True
				break
			}
		}

		if !foundScript
			return entryName

		for key, value in decomposedName.type {
			if !RegExMatch(entryName, "i)_" key "_") {
				foundScript := False
			} else {
				foundScript := True
				break
			}
		}


		if !foundScript {
			return entryName
		} else {
			if RegExMatch(entryName, "i)^([\w]+(?:_[\w]+){3,})_?", &rawMatch) {
				rawCharacterName := StrSplit(rawMatch[1], "_")

				decomposedName.script := decomposedName.script[rawCharacterName[1]]
				decomposedName.case := decomposedName.case[rawCharacterName[2]]
				decomposedName.type := decomposedName.type[rawCharacterName[3]]
				decomposedName.letter := (decomposedName.case = "capital" ? StrUpper(rawCharacterName[4]) : rawCharacterName[4])

				diacriticSet := InStr(entryName, "__") ? RegExReplace(entryName, "i)^.*?__(.*)", "$1") : ""
				decomposedName.postfixes := StrLen(diacriticSet) > 0 ? StrSplit(diacriticSet, "__") : []

				return decomposedName
			} else {
				return entryName
			}
		}
	}

	static LocalesGeneration(entryName, entry) {
		pfx := "gen_"
		letter := (entry.symbol.HasOwnProp("letter") && StrLen(entry.symbol.letter) > 0) ? entry.symbol.letter : entry.data.letter
		lScript := entry.data.script
		lCase := entry.data.case
		lType := entry.data.type
		lPostfixes := entry.data.postfixes
		psx := lType = "digraph" ? "_second" : ""

		langCodes := ["en", "ru", "en_alt", "ru_alt"]
		entry.titles := Map()
		tags := Map()

		for _, langCode in langCodes {
			isAlt := InStr(langCode, "_alt")
			lang := isAlt ? SubStr(langCode, 1, 2) : langCode

			lBeforeletter := entry.symbol.HasOwnProp("beforeLetter") && StrLen(entry.symbol.beforeLetter) > 0 ? Locale.Read(pfx "beforeLetter_" entry.symbol.beforeLetter, lang) " " : ""
			lAfterletter := entry.symbol.HasOwnProp("afterLetter") && StrLen(entry.symbol.afterLetter) > 0 ? " " Locale.Read(pfx "afterLetter_" entry.symbol.afterLetter, lang) : ""


			if isAlt {
				entry.titles[langCode] := Util.StrUpper(Locale.Read(pfx "type_" lType, lang), 1) " " lBeforeletter letter lAfterletter
			} else {
				entry.titles[langCode] := Locale.Read(pfx "prefix_" lScript, lang) " " Locale.Read(pfx "case_" lCase psx, lang) " " Locale.Read(pfx "type_" lType, lang) " " lBeforeletter letter lAfterletter
				tags[langCode] := Locale.Read(pfx "case_" lCase psx, lang) " " Locale.Read(pfx "type_" lType, lang) " " lBeforeletter letter lAfterletter
			}
		}

		if lPostfixes.Length > 0 {
			for _, langCode in langCodes {
				lang := InStr(langCode, "_alt") ? SubStr(langCode, 1, 2) : langCode
				postfixText := ""

				postfixText .= " " Locale.Read(pfx "postfix_with", lang) " " Locale.Read(pfx "postfix_" lPostfixes[1], lang)

				Loop lPostfixes.Length - 2
					postfixText .= ", " Locale.Read(pfx "postfix_" lPostfixes[A_Index + 1], lang)

				if lPostfixes.Length > 1
					postfixText .= " " Locale.Read(pfx "postfix_and", lang) " " Locale.Read(pfx "postfix_" lPostfixes[lPostfixes.Length], lang)

				entry.titles[langCode] .= postfixText

				if !InStr(langCode, "_alt") {
					tags[langCode] .= postfixText
				}
			}
		}

		tags["en"] := Locale.Read(pfx "tagScript_" lScript, "en") " " tags["en"]
		tags["ru"] := tags["ru"] " " Locale.Read(pfx "tagScript_" lScript, "ru")


		hasTags := entry.tags.Length > 0
		tagIndex := 0
		for tag in tags {
			tagIndex++
			entry.tags.InsertAt(tagIndex, tags[tag])
		}


		return entry
	}

	static SetDecomposedData(entryName, entry) {
		decomposedName := this.NameDecompose(entryName)

		if decomposedName == entryName {
			entry.data := {
				script: "",
				case: "",
				type: "",
				letter: "",
				postfixes: []
			}
			return entry
		} else {
			entry.data := decomposedName
			return entry
		}
	}
}

/*
ChrLib.AddEntry(
	"concept_c_letter_tse", {
		titles: Map("ru", "", "en", ""),
		unicode: "{U+0426}", html: "fills automatically", altCode: "fills automatically", LaTeX: ["\^", "\hat"], LaTeXPackage: "amsmath",
		sequence: ["{U+0426}", "{U+0426}", "{U+0426}"],
		tags: ["concept", "концепт"],
		groups: ["Concept Entry"],
		alterations: {
			modifier: "{U+02D7}",
			combining: "{U+02D7}",
			uncombined: "{U+02D7}",
			subscript: "{U+02D7}",
			italic: "{U+02D7}",
			italicBold: "{U+02D7}",
			bold: "{U+02D7}",
			script: "{U+02D7}",
			fraktur: "{U+02D7}",
			scriptBold: "{U+02D7}",
			frakturBold: "{U+02D7}",
			doubleStruck: "{U+02D7}",
			doubleStruckBold: "{U+02D7}",
			doubleStruckItalic: "{U+02D7}",
			doubleStruckItalicBold: "{U+02D7}",
			sansSerif: "{U+02D7}",
			sansSerifItalic: "{U+02D7}",
			sansSerifItalicBold: "{U+02D7}",
			sansSerifBold: "{U+02D7}",
			monospace: "{U+02D7}",
			smallCapital: "{U+02D7}",
		},
		options: {
			noCalc: True,
			noHTML: False,
			titlesAlt: True,
			layoutTitles: True,
			groupKey: "9",
			groupModifiers: CapsLock,
			fastKey: "<+ [-]",
			specialKey: "[Num-]",
			altLayoutKey: "[A]",
		},
		symbol: {
			letter: "Ц",
			set: Chr(0x0426),
			alt: "[" Chr(0x0426) "]",
			category: "Entry Concept",
			customs: "s72 underline",
			font: "Cambria",
		},
		recipe: ["m-"],
	}
)
*/

CopyDiacriticMarks() {


	marks := ChrLib.entryCategories["Diacritic Mark"]

	text := ""
	for index, mark in marks {
		text .= mark "`n"
	}

	A_Clipboard := text
	MsgBox "Символы успешно скопированы в буфер обмена!"
}

;SetTimer(() => CopyDiacriticMarks(), -5000)
