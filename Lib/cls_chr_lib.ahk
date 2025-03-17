class ChrLib {

	static entries := {}
	static entryGroups := Map()
	static entryRecipes := Map()
	static lastIndexAdded := -1

	static AddEntry(entryName, entry) {

		this.entries.%entryName% := {}
		for key, value in entry.OwnProps() {
			if value is Func
				this.entries.%entryName%.DefineProp(key, { Get: value })
			else
				this.entries.%entryName%.%key% := value
		}

		this.entries.%entryName%.index := this.lastIndexAdded + 1

		this.lastIndexAdded := this.entries.%entryName%.index

		this.EntryPostProcessing(entryName, this.entries.%entryName%)
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

			for group in entry.groups {
				if this.entryGroups.Has(group) && this.entryGroups.Get(group).HasValue(entryName) {
					intermediateArray := this.entryGroups.Get(group)
					intermediateArray.RemoveValue(entryName)

					this.entryGroups.Delete(group)
					this.entryGroups.Set(group, intermediateArray)
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

		if getMode = "HTML" && entry.HasOwnProp("html") {
			if (extraRules && StrLen(AlterationActiveName) > 0) && entry.HasOwnProp("alterations") && entry.alterations.HasOwnProp(AlterationActiveName) {
				output .= entry.alterations.%AlterationActiveName%HTML

			} else {
				output .= entry.html
			}

		} else if getMode = "LaTeX" && entry.HasOwnProp("LaTeX") {
			output .= (entry.LaTeX.Length = 2 && Cfg.Get("LaTeX_Mode") = "Math") ? entry.LaTeX[2] : entry.LaTeX[1]

		} else {
			if (extraRules && StrLen(AlterationActiveName) > 0) && entry.HasOwnProp("alterations") && entry.alterations.HasOwnProp(AlterationActiveName) {
				output .= Util.UnicodeToChar(entry.alterations.%AlterationActiveName%)

			} else if (extraRules && getMode != "Unicode") && entry.HasOwnProp("alterations") && entry.alterations.HasOwnProp(getMode) {
				output .= Util.UnicodeToChar(entry.alterations.%getMode%)

			} else if entry.HasOwnProp("sequence") {
				output .= Util.UnicodeToChar(entry.sequence)

			} else {
				output .= Util.UnicodeToChar(entry.unicode)
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
		for recipe in recipes {
			if InStr(recipe, "${") {
				matches := []
				while RegExMatch(recipe, "\${(.*?)}", &match) {
					matches.Push(match[1])
					recipe := RegExReplace(recipe, "\${" match[1] "}", this.Get(match[1]))
				}
			}
			output.Push(recipe)
		}

		return output
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

		if !refinedEntry.HasOwnProp("alterations")
			refinedEntry.alterations := {}

		if !refinedEntry.HasOwnProp("groups")
			refinedEntry.groups := ["Default Group"]

		if !refinedEntry.HasOwnProp("recipe")
			refinedEntry.recipe := []
		if !refinedEntry.HasOwnProp("recipeAlt")
			refinedEntry.recipeAlt := []


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

				if category = "Diacritic Mark" {
					if !hasSet
						refinedEntry.symbol.set := Chr(0x25CC) characterSequence
					if !hasCustoms
						refinedEntry.symbol.customs := "s72"
					if !hasFont
						refinedEntry.symbol.font := "Cambria"
				} else if category = "Spaces" {
					if !hasSet
						refinedEntry.symbol.set := characterSequence
					if !hasCustoms
						refinedEntry.symbol.customs := "underline"
				} else {
					if !hasSet
						refinedEntry.symbol.set := characterSequence
				}

			} else {
				refinedEntry.symbol.category := "N/A"
				if !hasSet
					refinedEntry.symbol.set := characterSequence
			}
		} else {
			refinedEntry.symbol := { category: "N/A" }
			refinedEntry.symbol.set := characterSequence
		}

		for group in refinedEntry.groups {
			if !this.entryGroups.Has(group)
				this.entryGroups.Set(group, [])

			if !this.entryGroups.Get(group).HasValue(entryName)
				this.entryGroups[group].Push(entryName)
		}

		if refinedEntry.recipe.Length > 0 {
			for recipe in refinedEntry.recipe {
				if !this.entryRecipes.Has(recipe) {
					this.entryRecipes.Set(recipe, { chr: Util.UnicodeToChar(refinedEntry.hasOwnProp("sequence") ? refinedEntry.sequence : refinedEntry.unicode), index: refinedEntry.index })
				} else {
					MsgBox(Util.StrVarsInject(Locale.Read("warning_duplicate_recipe"), recipe), App.winTitle, "Icon!")
				}
			}
		}

		this.entries.%entryName% := refinedEntry
	}
}
; TODO Выделить Tags записей знаков в отдельный ini файл


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
