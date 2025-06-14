Class ChrRecipeHandler {
	static Make(recipes, entryName := "", skipStatus := "") {
		output := []
		interArr := recipes.ToFlat()

		for recipe in interArr {
			this.MakeStr(recipe, output, entryName, skipStatus)
		}

		return output
	}

	static MakeStr(recipe, outputArray := "", entryName := "", skipStatus := "") {
		output := ""
		if InStr(recipe, "${") {
			if RegExMatch(recipe, "\((.*?)\|(.*?)\)", &match) {
				recipePair := [
					RegExReplace(recipe, "\((.*?)\|(.*?)\)", match[1]),
					RegExReplace(recipe, "\((.*?)\|(.*?)\)", match[2])
				]
				recipePair[1] := StrReplace(recipePair[1], "$(*)", "${" match[2] "}")
				recipePair[2] := StrReplace(recipePair[2], "$(*)", "${" match[1] "}")

				for pairRecipe in recipePair {
					if outputArray is Array {
						outputArray.Push(this.ProcessRecipeString(pairRecipe, entryName, skipStatus))
					} else {
						output .= this.ProcessRecipeString(pairRecipe, entryName, skipStatus)
					}
				}
			} else {
				if outputArray is Array {
					outputArray.Push(this.ProcessRecipeString(recipe, entryName, skipStatus))
				} else {
					output .= this.ProcessRecipeString(recipe, entryName, skipStatus)
				}
			}
		} else {
			if outputArray is Array {
				outputArray.Push(recipe)
			} else {
				output .= recipe
			}
		}

		if outputArray is String
			return output
	}

	static GetStr(entryName, formatted := False, formatChar := ", ", prompt := "") {
		output := []
		intermediate := []
		if ChrLib.entries.%entryName%.HasOwnProp("recipeAlt") && ChrLib.entries.%entryName%.recipeAlt.Length > 0 {
			intermediate := ChrLib.entries.%entryName%.recipeAlt
		} else if ChrLib.entries.%entryName%.HasOwnProp("recipe") && ChrLib.entries.%entryName%.recipe.Length > 0 {
			intermediate := ChrLib.entries.%entryName%.recipe
		}

		if prompt != "" && (intermediate.Length > 2 || (intermediate.Length = 2 && RegExMatch(intermediate[2], "^" Chr(0x25CC)))) {
			for i, recipe in intermediate {
				cleanRecipe := RegExReplace(recipe, Chr(0x25CC))
				if RegExMatch(cleanRecipe, "^" prompt)
					output.Push(recipe)
			}
		} else
			output := intermediate

		output := formatted && output.length > 0 ? output.ToString(formatChar) : output
		return output
	}

	static Count(rule := "", onlyUnique := False) {
		output := ChrLib.entryRecipes.Count
		substract := 0

		if onlyUnique {
			local arr := []

			for key, value in ChrLib.entryRecipes {
				if !arr.HasValue(value.name) {
					arr.Push(value.name)
				}
			}

			output := arr.Length
		}

		if ChrLib.entryGroups.Has("Custom Composes") && rule = "No Custom" {
			for entryName in ChrLib.entryGroups.Get("Custom Composes") {
				output -= ChrLib.entries.%entryName%.recipe.Length
			}
		} else if ChrLib.entryGroups.Has("Custom Composes") && rule = "Custom Only" {
			output := 0
			for entryName in ChrLib.entryGroups.Get("Custom Composes") {
				if onlyUnique && ChrLib.entries.%entryName%.recipe.Length > 0
					output++
				else
					output += ChrLib.entries.%entryName%.recipe.Length
			}
		}

		return output
	}

	static ProcessRecipeString(recipe, entryName := "", skipStatus := "") {
		tempRecipe := recipe

		while RegExMatch(tempRecipe, "\${(.*?)}", &match) {
			characterInfo := this.ParseCharacterInfo(match[1])

			if !ChrLib.entries.HasOwnProp(characterInfo.name) {
				if skipStatus = "Missing" {
					MsgBox(Locale.Read("error_critical") "`n`n" Locale.ReadInject("error_entry_not_found_recipe", [entryName, RegExReplace(recipe, "\$"), characterInfo.name]), App.Title(), "Iconx")
					return tempRecipe
				}
			}

			interValue := ""
			Loop characterInfo.repeatCount
				interValue .= Chrlib.Get(characterInfo.name, characterInfo.hasAlteration, characterInfo.alteration)

			tempRecipe := RegExReplace(tempRecipe, "\${" RegExEscape(match[1]) "}", interValue)
		}

		return tempRecipe
	}

	static ParseCharacterInfo(characterString) {
		info := {
			name: characterString,
			repeatCount: 1,
			alteration: "",
			hasAlteration: False
		}

		if RegExMatch(info.name, "×(\d+)$", &repeatMatch) {
			info.repeatCount := repeatMatch[1]
			info.name := RegExReplace(info.name, "×\d+$", "")
		}

		if RegExMatch(info.name, "\:\:(.*?)$", &alterationMatch) {
			info.alteration := ChrLib.ValidateAlt(alterationMatch[1])
			info.hasAlteration := True
			info.name := RegExReplace(info.name, "\:\:.*$", "")
		}

		return info
	}
}