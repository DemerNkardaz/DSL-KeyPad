Class ChrRecipeHandler {
	static Make(recipes, entryName := "", skipStatus := "", throwError := False) {
		local output := []
		local interArr := recipes.ToFlat()

		for recipe in interArr {
			this.MakeStr(recipe, output, entryName, skipStatus, throwError)
		}

		return output
	}

	static MakeStr(recipe, outputArray := "", entryName := "", skipStatus := "", throwError := False) {
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
						outputArray.Push(this.ProcessRecipeString(pairRecipe, entryName, skipStatus, throwError))
					} else {
						output .= this.ProcessRecipeString(pairRecipe, entryName, skipStatus, throwError)
					}
				}
			} else {
				if outputArray is Array {
					outputArray.Push(this.ProcessRecipeString(recipe, entryName, skipStatus, throwError))
				} else {
					output .= this.ProcessRecipeString(recipe, entryName, skipStatus, throwError)
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

	static GetStr(entryName, formatted := False, formatChar := ", ", prompt := "", showAltRecipes := False, isUniqueRecipe := False) {
		local output := []
		local intermediate := []
		local hasDiacritics := ChrLib.entries.%entryName%["options"]["usesDiacritics"] || ChrLib.entries.%entryName%["data"]["postfixes"].Length > 0

		if ChrLib.entries.%entryName%.Has("recipeAlt") && ChrLib.entries.%entryName%["recipeAlt"].Length > 0 {
			intermediate := ChrLib.entries.%entryName%["recipeAlt"]
		} else if ChrLib.entries.%entryName%.Has("recipe") && ChrLib.entries.%entryName%["recipe"].Length > 0 {
			intermediate := ChrLib.entries.%entryName%["recipe"]
		}

		if prompt != "" {
			if showAltRecipes && !hasDiacritics {
				local hasMatchingRecipe := False
				for i, recipe in intermediate {
					cleanRecipe := RegExReplace(recipe, Chr(0x25CC))
					caseSensitiveMatch := RegExMatch(cleanRecipe, "^" prompt)
					uniqueMatch := isUniqueRecipe && RegExMatch(cleanRecipe, "i)^" prompt)

					if caseSensitiveMatch || uniqueMatch {
						hasMatchingRecipe := True
						break
					}
				}

				if hasMatchingRecipe
					output := intermediate
			} else {
				if showAltRecipes {
					if intermediate.Length > 2 || (intermediate.Length = 2 && RegExMatch(intermediate[2], "^" Chr(0x25CC))) {
						for i, recipe in intermediate {
							cleanRecipe := RegExReplace(recipe, Chr(0x25CC))
							caseSensitiveMatch := RegExMatch(cleanRecipe, "^" prompt)
							uniqueMatch := isUniqueRecipe && RegExMatch(cleanRecipe, "i)^" prompt)

							if caseSensitiveMatch || uniqueMatch
								output.Push(recipe)
						}
					} else
						output := intermediate
				} else {
					for i, recipe in intermediate {
						cleanRecipe := RegExReplace(recipe, Chr(0x25CC))
						caseSensitiveMatch := RegExMatch(cleanRecipe, "^" prompt)
						uniqueMatch := isUniqueRecipe && RegExMatch(cleanRecipe, "i)^" prompt)

						if caseSensitiveMatch || uniqueMatch
							output.Push(recipe)
					}
				}
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
				output -= ChrLib.entries.%entryName%["recipe"].Length
			}
		} else if ChrLib.entryGroups.Has("Custom Composes") && rule = "Custom Only" {
			output := 0
			for entryName in ChrLib.entryGroups.Get("Custom Composes") {
				if onlyUnique && ChrLib.entries.%entryName%["recipe"].Length > 0
					output++
				else
					output += ChrLib.entries.%entryName%["recipe"].Length
			}
		}

		return output
	}

	static ProcessRecipeString(recipe, entryName := "", skipStatus := "", throwError := False) {
		tempRecipe := recipe
		outputRecipe := recipe

		while RegExMatch(tempRecipe, "\${(.*?)}", &match) {
			characterInfo := this.ParseCharacterInfo(match[1])
			if RegExMatch(characterInfo.name, "\\(.*?)\/", &multiMatch) {
				local resolvedValue := ""
				local split := StrSplit(multiMatch[1], ",")

				for each in split {
					local name := each ~= "^\+" ? SubStr(each, 2) : RegExReplace(characterInfo.name, "\\(.*?)\/", each)

					if !ChrLib.entries.HasOwnProp(name) {
						if skipStatus = "Missing" {
							MsgBox(Locale.Read("error.critical") "`n`n" Locale.ReadInject("error.entry_not_found_recipe", [entryName, RegExReplace(recipe, "\$(?![{(])"), name]), App.Title(), "Iconx")
							return tempRecipe
						}
					}

					local interValue := ""
					local entryCharacter := ChrLib.Get(name, characterInfo.hasAlteration, "Unicode", characterInfo.alteration)

					if entryCharacter {
						Loop characterInfo.repeatCount
							interValue .= entryCharacter
					} else if !entryCharacter && throwError {
						throw
					} else
						interValue := "${" name "}"

					resolvedValue .= interValue
				}

				outputRecipe := RegExReplace(outputRecipe, "\${" RegExEscape(match[1]) "}", resolvedValue)
				tempRecipe := RegExReplace(tempRecipe, "\${" RegExEscape(match[1]) "}")
				continue
			} else if !ChrLib.entries.HasOwnProp(characterInfo.name) {
				if skipStatus = "Missing" {
					MsgBox(Locale.Read("error.critical") "`n`n" Locale.ReadInject("error.entry_not_found_recipe", [entryName, RegExReplace(recipe, "\$(?![{(])"), characterInfo.name]), App.Title(), "Iconx")
					return tempRecipe
				}
			}

			local interValue := ""
			local entryCharacter := Chrlib.Get(characterInfo.name, characterInfo.hasAlteration, "Unicode", characterInfo.alteration)

			if entryCharacter {
				Loop characterInfo.repeatCount
					interValue .= entryCharacter
			} else if !entryCharacter && throwError {
				throw
			} else
				interValue := "${" characterInfo.name "}"

			outputRecipe := RegExReplace(outputRecipe, "\${" RegExEscape(match[1]) "}", interValue)
			tempRecipe := RegExReplace(tempRecipe, "\${" RegExEscape(match[1]) "}")
		}

		return outputRecipe
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