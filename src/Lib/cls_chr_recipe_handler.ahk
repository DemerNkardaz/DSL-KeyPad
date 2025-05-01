Class ChrRecipeHandler {
	static Make(recipes*) {
		output := []
		interArr := recipes.ToFlat()

		for recipe in interArr {
			this.MakeStr(recipe, output)
		}

		return output
	}

	static MakeStr(recipe, outputArray := "") {
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
						outputArray.Push(this.ProcessRecipeString(pairRecipe))
					} else {
						output .= this.ProcessRecipeString(pairRecipe)
					}
				}
			} else {
				if outputArray is Array {
					outputArray.Push(this.ProcessRecipeString(recipe))
				} else {
					output .= this.ProcessRecipeString(recipe)
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

	static GetStr(entryName, formatted := False, formatChar := ", ") {
		output := []
		if ChrLib.entries.%entryName%.HasOwnProp("recipeAlt") && ChrLib.entries.%entryName%.recipeAlt.Length > 0 {
			output := ChrLib.entries.%entryName%.recipeAlt
		} else if ChrLib.entries.%entryName%.HasOwnProp("recipe") && ChrLib.entries.%entryName%.recipe.Length > 0 {
			output := ChrLib.entries.%entryName%.recipe
		}

		output := formatted && output.length > 0 ? output.ToString(formatChar) : output
		return output
	}

	static Count(rule := "") {
		output := ChrLib.entryRecipes.Count
		substract := 0

		if ChrLib.entryGroups.Has("Custom Composes") && rule = "No Custom" {
			for entryName in ChrLib.entryGroups.Get("Custom Composes") {
				output := output - ChrLib.entries.%entryName%.recipe.Length
			}
		} else if ChrLib.entryGroups.Has("Custom Composes") && rule = "Custom Only" {
			output := 0
			for entryName in ChrLib.entryGroups.Get("Custom Composes") {
				output := output + ChrLib.entries.%entryName%.recipe.Length
			}
		}

		return output
	}

	static ProcessRecipeString(recipe) {
		tempRecipe := recipe

		while RegExMatch(tempRecipe, "\${(.*?)}", &match) {
			characterInfo := this.ParseCharacterInfo(match[1])

			interValue := ""
			Loop characterInfo.repeatCount {
				if !ChrLib.entries.HasOwnProp(characterInfo.name) {
					MsgBox(Locale.Read("error_critical") "`n`n" Util.StrVarsInject(Locale.Read("error_entry_not_found_recipe"), recipe, characterInfo.name), App.Title(), "Iconx")
					return
				}
				interValue .= Chrlib.Get(characterInfo.name, characterInfo.hasAlteration, characterInfo.alteration)

			}

			try {
				tempRecipe := RegExReplace(tempRecipe, "\${" match[1] "}", interValue)
			} catch {
				throw "Error in recipe: " tempRecipe " with character: " characterInfo.name
			}
		}

		return tempRecipe
	}

	static ParseCharacterInfo(characterString) {
		info := {
			name: characterString,
			repeatCount: 1,
			alteration: "",
			hasAlteration: false
		}

		if RegExMatch(info.name, "\:\:(.*?)$", &alterationMatch) {
			info.alteration := ChrLib.ValidateAlt(alterationMatch[1])
			info.hasAlteration := true
			info.name := RegExReplace(info.name, "\:\:.*$", "")
		}

		if RegExMatch(info.name, "×(\d+)$", &repeatMatch) {
			info.repeatCount := repeatMatch[1]
			info.name := RegExReplace(info.name, "×\d+$", "")
		}

		return info
	}
}