Class ChrEntry {
	index := 0
	unicode := ""
	sequence := []
	html := ""
	entity := ""
	altCode := ""
	LaTeX := []
	LaTeXPackage := ""
	titles := Map()
	tags := []
	groups := []
	alterations := {}
	options := {
		noCalc: False,
		useLetterLocale: False,
		layoutTitles: False,
		legend: "",
		altLayoutKey: "",
		altSpecialKey: "",
		fastKey: "",
		groupKey: [],
		specialKey: "",
	}
	recipe := []
	recipeAlt := []
	symbol := {
		category: "",
		letter: "",
		afterLetter: "",
		beforeLetter: "",
		set: "",
		alt: "",
		customs: "",
		font: "",
	}
	data := { script: "", case: "", type: "", letter: "", postfixes: [], }

	__New(attributes := {}) {
		for key, value in attributes.OwnProps() {
			if Util.IsArray(value) {
				this.%key% := []
				this.%key% := value.Clone()
			} else if Util.IsObject(value) {
				for subKey, subValue in value.OwnProps() {
					this.%key%.%subKey% := subValue
				}
			} else {
				this.%key% := value
			}
		}
		return this
	}
}

class ChrLib {
	static entries := {}
	static entryGroups := Map()
	static entryCategories := Map()
	static entryRecipes := Map()
	static entryTags := Map()
	static duplicatesList := []
	static lastIndexAdded := -1

	static __New() {
		this.Registrate()
	}

	static Registrate() {
		LibRegistrate(this)
	}

	static AddEntry(entryName, entry) {
		if RegExMatch(entryName, "\[(.*?)\]", &match) {
			splitVariants := StrSplit(match[1], ",")
			entries := {}

			for i, variant in splitVariants {
				variantName := RegExReplace(entryName, "\[.*?\]", variant)
				entries.%variantName% := entry.Clone()

				entries.%variantName%.unicode := entry.unicode[i]
				entries.%variantName% := this.SetDecomposedData(variantName, entries.%variantName%)

				entries.%variantName%.symbol := entry.symbol.Clone()
				if Util.IsArray(entries.%variantName%.symbol.letter) {
					entries.%variantName%.symbol.letter := entry.symbol.letter[i]
				}

				if Util.IsArray(entry.alterations) {
					entries.%variantName%.alterations := entry.alterations[i].Clone()
				}

				this.ProcessReferences(entries.%variantName%, entry, i)

				entries.%variantName%.options := this.CloneOptions(entry.options, i)
			}

			for entryName, entry in entries.OwnProps() {
				this.ProcessRecipe(entry, splitVariants)
				this.AddEntry(entryName, ChrEntry(entry))
			}
		} else {
			this.entries.%entryName% := {}
			entry := this.EntryPreProcessing(entryName, entry)

			this.TransferProperties(entryName, entry)

			this.entries.%entryName%.index := ++this.lastIndexAdded

			this.EntryPostProcessing(entryName, this.entries.%entryName%)
		}
	}

	static AddEntries(arguments*) {
		Loop arguments.Length // 2 {
			index := A_Index * 2 - 1
			entryName := arguments[index]
			entryValue := arguments[index + 1]
			this.AddEntry(entryName, ChrEntry(entryValue))
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

		getMode := StrLen(getMode) ? getMode : "Unicode"

		if (getMode = "HTML" && StrLen(entry.html) > 0) {
			if (extraRules && StrLen(AlterationActiveName) > 0 && entry.alterations.HasOwnProp(AlterationActiveName)) {
				return entry.alterations.%AlterationActiveName%HTML
			}
			return StrLen(entry.entity) > 0 ? entry.entity : entry.html

		} else if (getMode = "LaTeX" && entry.LaTeX.Length > 0) {
			return (entry.LaTeX.Length = 2 && Cfg.Get("LaTeX_Mode") = "Math")
				? entry.LaTeX[2]
			: entry.LaTeX[1]

		} else {
			if (extraRules && StrLen(AlterationActiveName) > 0 && entry.alterations.HasOwnProp(AlterationActiveName)) {
				return Util.UnicodeToChar(entry.alterations.%AlterationActiveName%)

			} else if (extraRules && getMode != "Unicode" && entry.alterations.HasOwnProp(getMode)) {
				return Util.UnicodeToChar(entry.alterations.%getMode%)

			} else {
				return Util.UnicodeToChar(entry.sequence.Length > 0 ? entry.sequence : entry.unicode)
			}
		}
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

	static Count(groupRestrict?) {
		count := 0
		for entry, value in this.entries.OwnProps() {
			if !IsSet(groupRestrict) || (IsSet(groupRestrict) && value.groups.HasValue(groupRestrict)) {
				if !(value.options.noCalc) {
					count++
				}

				for alteration, value in value.alterations.OwnProps() {
					if !InStr(alteration, "HTML") {
						count++
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
			if entry.tags.Length = 0
				continue

			for _, tag in entry.tags {
				if checkTagExact(tag)
					return this.Get(entryName, True, Cfg.Get("Input_Mode", , "Unicode"))
			}
		}

		for entryName, entry in this.entries.OwnProps() {
			if entry.tags.Length = 0
				continue

			for _, tag in entry.tags {
				if checkTagPartial(tag)
					return this.Get(entryName, True, Cfg.Get("Input_Mode", , "Unicode"))
			}
		}

		for entryName, entry in this.entries.OwnProps() {
			if entry.tags.Length = 0
				continue

			for _, tag in entry.tags {
				if checkTagLowAcc(tag)
					return this.Get(entryName, True, Cfg.Get("Input_Mode", , "Unicode"))
			}
		}

		return ""
	}

	static ProcessReferences(targetEntry, sourceEntry, index) {
		for reference in ["recipe", "tags", "groups"] {
			if sourceEntry.%reference%.Length > 0 && Util.IsArray(sourceEntry.%reference%[sourceEntry.%reference%.Length]) {
				if sourceEntry.%reference%[index].Length > 0 {
					targetEntry.%reference% := sourceEntry.%reference%[index].Clone()
				} else {
					targetEntry.DeleteProp(reference)
				}
			}
		}
	}

	static CloneOptions(sourceOptions, index) {
		tempOptions := sourceOptions.Clone()
		for key, value in sourceOptions.OwnProps() {
			if Util.IsArray(sourceOptions.%key%) && key != "groupKey" && sourceOptions.%key%.Length > 0 {
				tempOptions.%key% := sourceOptions.%key%[index]
			}
		}
		return tempOptions
	}

	static ProcessRecipe(entry, splitVariants) {
		if !entry.recipe.Length > 0 && entry.data.postfixes.Length > 0 {
			if entry.data.postfixes.Length = 1 {
				entry.recipe := ["$${" entry.data.postfixes[1] "}"]
			} else {
				entry.recipe := [
					"$${(" entry.data.postfixes[1] "|" entry.data.postfixes[2] ")}$(*)",
					"${" SubStr(entry.data.script, 1, 3) "_[" splitVariants.ToString(",") "]_"
					SubStr(entry.data.type, 1, 3) "_@__(" entry.data.postfixes[1] "|"
					entry.data.postfixes[2] ")}$(*)"
				]
			}
		}

		if entry.recipe.Length > 0 {
			tempRecipe := entry.recipe.Clone()
			for i, recipe in tempRecipe {
				tempRecipe[i] := RegExReplace(recipe, "\[.*?\]", SubStr(entry.data.case, 1, 1))
				tempRecipe[i] := RegExReplace(tempRecipe[i], "@", entry.data.letter)
			}
			entry.recipe := tempRecipe
		}
	}

	static TransferProperties(entryName, entry) {
		for key, value in entry.OwnProps() {
			if !["String", "Integer", "Boolean"].HasValue(Type(value)) {
				if key = "recipe" && value.Length > 0
					this.TransferRecipeProperty(entryName, value)
				else
					this.Transfer%Type(value)%Property(entryName, key, value)
			} else {
				this.entries.%entryName%.%key% := value
			}
		}
	}

	static TransferFuncProperty(entryName, key, value) {
		definedValue := value
		this.entries.%entryName%.DefineProp(key, {
			Get: (*) => definedValue(),
			Set: (this, value) => this.DefineProp(key, { Get: (*) => value })
		})
	}

	static TransferRecipeProperty(entryName, value) {
		tempRecipe := value.Clone()
		definedRecipe := (*) => ChrRecipeHandler.Make(tempRecipe)
		interObj := {}
		interObj.DefineProp("Get", { Get: definedRecipe, Set: definedRecipe })
		this.entries.%entryName%.recipe := interObj.Get
	}

	static TransferArrayProperty(entryName, key, value) {
		this.entries.%entryName%.%key% := []
		for subValue in value {
			if Util.IsFunc(subValue) {
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
	}

	static TransferMapProperty(entryName, key, value) {
		this.entries.%entryName%.%key% := Map()
		for mapKey, mapValue in value {
			if Util.IsFunc(mapValue) {
				interObj := {}
				interObj.DefineProp("Get", { Get: mapValue, Set: mapValue })
				this.entries.%entryName%.%key%.Set(mapKey, interObj.Get)
			} else {
				this.entries.%entryName%.%key%.Set(mapKey, mapValue)
			}
		}
	}

	static TransferObjectProperty(entryName, key, value) {
		this.entries.%entryName%.%key% := {}
		for subKey, subValue in value.OwnProps() {
			if Util.IsFunc(subValue) {
				this.entries.%entryName%.%key%.DefineProp(subKey, {
					Get: subValue,
					Set: subValue
				})
			} else {
				this.entries.%entryName%.%key%.%subKey% := subValue
			}
		}
	}

	static EntryPreProcessing(entryName, entry) {
		refinedEntry := entry.Clone()
		refinedEntry := this.SetDecomposedData(entryName, refinedEntry)

		if StrLen(refinedEntry.data.script) > 0 && StrLen(refinedEntry.data.type) > 0 {
			if refinedEntry.groups.Length = 0 {
				hasPostfix := refinedEntry.data.postfixes.Length > 0
				if refinedEntry.data.script = "latin" {
					refinedEntry.groups := refinedEntry.data.type = "ligature" ? ["Latin Ligatures"] : refinedEntry.data.type = "digraph" ? ["Latin Digraphs"] : ["Latin" (hasPostfix ? " Accented" : "")]
				}
			}

			if StrLen(refinedEntry.symbol.category = 0) {
				if StrLen(refinedEntry.data.script) && StrLen(refinedEntry.data.type) {

					hasPostfix := refinedEntry.data.postfixes.Length > 0
					refinedEntry.symbol.category := Util.StrUpper(refinedEntry.data.script, 1) " " Util.StrUpper(refinedEntry.data.type, 1) (hasPostfix ? " Accented" : "")
				} else {
					refinedEntry.symbol.category := "N/A"
				}
			}
		}

		if StrLen(refinedEntry.options.fastKey) && RegExMatch(refinedEntry.options.fastKey, "\?(.*?)$", &addGroupMatch) {
			refinedEntry.groups.Push(refinedEntry.groups[1] " " addGroupMatch[1])
		}

		if refinedEntry.recipe.Length = 0 && refinedEntry.data.postfixes.Length > 0 {
			refinedEntry.recipe := ["$"]
			for postfix in refinedEntry.data.postfixes {
				refinedEntry.recipe[1] .= "${" postfix "}"
			}
		}

		return refinedEntry
	}

	static EntryPostProcessing(entryName, entry) {
		refinedEntry := entry
		character := Util.UnicodeToChar(refinedEntry.unicode)
		characterSequence := Util.UnicodeToChar(refinedEntry.sequence.Length > 0 ? refinedEntry.sequence : refinedEntry.unicode)
		try {
		} catch {
			throw "Trouble in paradise: " entryName
		}

		if refinedEntry.sequence.Length > 0 {
			for sequenceChr in refinedEntry.sequence {
				if StrLen(refinedEntry.html)
					refinedEntry.html := ""
				refinedEntry.html .= "&#" Util.ChrToDecimal(Util.UnicodeToChar(sequenceChr)) ";"
			}
		} else {
			refinedEntry.html := "&#" Util.ChrToDecimal(character) ";"
		}

		for alteration, value in refinedEntry.alterations.OwnProps() {
			if !InStr(alteration, "HTML")
				refinedEntry.alterations.%alteration%HTML := "&#" Util.ChrToDecimal(Util.UnicodeToChar(value)) ";"
		}

		for i, altCodeSymbol in AltCodesLibrary {
			if Mod(i, 2) = 1 {
				AltCode := AltCodesLibrary[i + 1]

				if character == altCodeSymbol {
					if StrLen(refinedEntry.altCode) = 0 {
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

		refinedEntry.symbol.set := characterSequence

		if refinedEntry.groups.Length = 0
			refinedEntry.groups := ["Default Group"]


		for group in ["fastKey", "specialKey", "altLayoutKey"] {
			if refinedEntry.options.HasOwnProp(group) {
				refinedEntry.options.%group% := Util.ReplaceModifierKeys(refinedEntry.options.%group%)
			} else {
				refinedEntry.options.%group% := ""
			}
		}

		hasSet := StrLen(refinedEntry.symbol.set) > 0
		hasCustoms := StrLen(refinedEntry.symbol.customs) > 0
		hasFont := StrLen(refinedEntry.symbol.font) > 0

		if StrLen(refinedEntry.symbol.category) > 0 {
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

		if refinedEntry.tags.Length > 0 {
			for tag in refinedEntry.tags {
				if !this.entryTags.Has(tag)
					this.entryTags.Set(tag, [])

				this.entryTags[tag].Push(entryName)
			}
		}

		dataLetter := StrLen(refinedEntry.symbol.letter) > 0 ? refinedEntry.symbol.letter : refinedEntry.data.letter

		if StrLen(refinedEntry.data.letter) > 0 {
			if refinedEntry.recipe.Length > 0 {
				for i, recipe in refinedEntry.recipe {
					refinedEntry.recipe[i] := RegExReplace(recipe, "\~", SubStr(refinedEntry.data.letter, 1, 1))
					refinedEntry.recipe[i] := RegExReplace(recipe, "\$", dataLetter)
				}
			}

			if StrLen(refinedEntry.options.fastKey) > 0 {
				refinedEntry.options.fastKey := RegExReplace(refinedEntry.options.fastKey, "\$", "[" dataLetter "]")
				refinedEntry.options.fastKey := RegExReplace(refinedEntry.options.fastKey, "\~", "[" SubStr(refinedEntry.data.letter, 1, 1) "]")
				refinedEntry.options.fastKey := RegExReplace(refinedEntry.options.fastKey, "\?(.*?)$")
			}
			if StrLen(refinedEntry.options.altLayoutKey) > 0 {
				refinedEntry.options.altLayoutKey := RegExReplace(refinedEntry.options.altLayoutKey, "\$", "[" dataLetter "]")
				refinedEntry.options.altLayoutKey := RegExReplace(refinedEntry.options.altLayoutKey, "\~", "[" SubStr(refinedEntry.data.letter, 1, 1) "]")
			}
		}


		if refinedEntry.recipe.Length > 0 {
			for recipe in refinedEntry.recipe {
				if !this.entryRecipes.Has(recipe) {
					this.entryRecipes.Set(recipe, { chr: Util.UnicodeToChar(refinedEntry.sequence.Length > 0 ? refinedEntry.sequence : refinedEntry.unicode), index: refinedEntry.index })
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
			refinedEntry := Locale.LocalesGeneration(entryName, refinedEntry)
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

	static EntryPreview(entryName, indent := 0) {
		entry := this.GetEntry(entryName)
		output := this.FormatEntry(entry, indent)
		MsgBox(output)
	}

	static FormatEntry(entry, indent) {
		output := ""
		indentStr := Util.StrRepeat("`t", indent)

		for key, value in entry.OwnProps() {
			if Util.IsArray(value) {
				output .= indentStr key ": " value.ToString() "`n"
			} else if Util.IsObject(value) {
				output .= indentStr key ":`n" . this.FormatEntry(value, indent + 1)
			} else {
				output .= indentStr key ": " value "`n"
			}
		}

		return output
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
			titlesAlt: True, ; Deprecated attribute
			useLetterLocale: True,
			layoutTitles: True,
			groupKey: "9",
			groupModifiers: CapsLock,
			fastKey: "<+ [-]",
			specialKey: "[Num-]",
			altLayoutKey: "[A]",
		},
		symbol: {
			letter: "Ц",
			afterLetter: "",
			beforeLetter : "",
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
