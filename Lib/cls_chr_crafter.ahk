/*
\\	App’s character compositing class
\\	Founds matches of input and “recipes” in characters’ map to return the result instead of original input.
*/

Class ChrCrafter {

	static modifiedCharsType := ""
	static prompt := ConvertFromHexaDecimal(IniRead(ConfigFile, "LatestPrompts", "Ligature", ""))

	__New(compositingMode := "InputBox") {
		this.compositingMode := compositingMode

		ChrCrafter.modifiedCharsType := GetModifiedCharsType()
		ChrCrafter.prompt := ConvertFromHexaDecimal(IniRead(ConfigFile, "LatestPrompts", "Ligature", ""))

		ChrCrafter.%this.compositingMode%Mode()
		try {
		} catch {
			if this.compositingMode = "InputBox"
				MsgBox(Locale.Read("warning_recipe_absent"), Locale.Read("symbol_smelting"), 0x30)
			else
				ShowInfoMessage("warning_recipe_absent", , , Cfg.SkipGroupMessage, True)
		}
	}

	static InputBoxMode() {
		IB := InputBox(Locale.Read("symbol_smelting_prompt"), Locale.Read("symbol_smelting"), "w256 h92", this.prompt)
		if IB.Result = "Cancel"
			return
		else
			this.prompt := IB.Value

		if this.prompt != "" {

			output := ""
			for prompt in StrSplit(this.prompt, " ") {
				output .= this.ValidateRecipes(prompt, , True) " "
			}

			if output = "" || RegExMatch(output, "^\s+$")
				return
			else {
				output := RegExReplace(output, "\s+$", "")
				this.SendOutput(output)

				IniWrite(ConvertToHexaDecimal(SubStr(this.prompt, 1, 128)), ConfigFile, "LatestPrompts", "Ligature")
			}
		}

		return
	}

	static ComposeMode() {

		output := ""
		input := ""
		previousInput := ""
		pastInput := ""
		tooltipSuggestions := ""
		favoriteSuggestions := this.ReadFavorites()
		favoriteSuggestions := favoriteSuggestions != "" ? ("`n" Chrs([0x2E3B, 10]) "`n" Chr(0x2605) " " Locale.Read("func_label_favorites") "`n" RegExReplace(favoriteSuggestions, ",\s+$", "") "`n" Chrs([0x2E3B, 10])) : ""

		pauseOn := False
		cleanPastInput := False

		continueInInput := False

		PH := InputHook("L0", "{Escape}")
		PH.Start()

		CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input (favoriteSuggestions))

		Loop {

			IH := InputHook("L1", "{Escape}{Backspace}{Enter}{Pause}{Tab}{Insert}")
			IH.Start(), IH.Wait()

			if (IH.EndKey = "Escape") {
				input := ""
				break

			} else if (IH.EndKey = "Pause") {
				pauseOn := pauseOn ? False : True

			} else if (IH.EndKey = "Backspace") {
				if StrLen(input) > 0
					input := SubStr(input, 1, -1)
			} else if (IH.EndKey = "Insert") {
				ClipWait(0.5, 1)
				input .= A_Clipboard

			} else if IH.Input != "" {
				input .= IH.Input

				if InputScriptProcessor.options.interceptionInputMode != "" && StrLen(input) > 1 {
					charPair := StrLen(input) > 2 && previousInput = "\" ? pastInput previousInput IH.Input : previousInput IH.Input
					telexChar := InputScriptProcessor.TelexReturn(charPair)

					if telexChar != charPair {
						input := SubStr(input, 1, previousInput = "\" ? -3 : -2) telexChar
						cleanPastInput := True
					}
				}

				pastInput := previousInput
				previousInput := IH.Input
			}

			if cleanPastInput {
				pastInput := ""
				previousInput := ""
				cleanPastInput := False
			}

			inputWithoutBackticks := RegExReplace(input, "``", "")

			hasBacktick := InStr(input, "``")

			tooltipSuggestions := input != "" ? ChrCrafter.FormatSuggestions(this.ValidateRecipes(inputWithoutBackticks, True)) : ""
			currentInputMode := Util.StrVarsInject(Locale.Read("tooltip_input_mode"), "[" Cfg.Get("Input_Mode") "]")

			CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input "`n" currentInputMode (favoriteSuggestions) ((StrLen(tooltipSuggestions) > 0 && !RegExMatch(input, "^\(\~\)\s")) ? "`n" tooltipSuggestions : ""))

			if !pauseOn || (IH.EndKey = "Enter") {
				try {
					if (RegExMatch(input, "\((\d+)[\~]?\)\s+(.*)", &match)) {
						repeatCount := (Number(match[1]) <= 100 && Number(match[1]) > 0) ? match[1] : 1
						postInput := match[2]
						intermediateValue := ""

						; Use version without backticks for matching but track if we had any
						postInputNoBackticks := RegExReplace(postInput, "``", "")
						postInputHasBacktick := InStr(postInput, "``")

						Loop repeatCount {
							tempValue := this.ValidateRecipes(postInputNoBackticks, , RegExMatch(input, "^\(\d+~\)\s"))
							intermediateValue .= tempValue

							len := StrLen(intermediateValue)
							if (len >= 2) {
								reduction := 1 + Floor(len / 2)
								repeatCount := Max(1, repeatCount - reduction)
							}

							if (len >= 200) {
								break
							}
						}

						if intermediateValue != "" {
							output := intermediateValue
							continueInInput := postInputHasBacktick
							if !continueInInput
								break
							else {
								input := RegExReplace(input, RegExEscape(postInput), output)

								tooltipSuggestions := input != "" ? ChrCrafter.FormatSuggestions(this.ValidateRecipes(RegExReplace(input, "``", ""), True)) : ""
								CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input "`n" currentInputMode (favoriteSuggestions) ((StrLen(tooltipSuggestions) > 0 && !RegExMatch(input, "^\(\~\)\s")) ? "`n" tooltipSuggestions : ""))

								continue
							}
						}
					} else {
						usePartialMode := RegExMatch(input, "^\(\~\)\s")
						inputToCheck := RegExReplace(input, "^\(\~\)\s", "")

						inputToCheckNoBackticks := RegExReplace(inputToCheck, "``", "")

						intermediateValue := this.ValidateRecipes(inputToCheckNoBackticks, , usePartialMode)
						if intermediateValue != "" {
							output := intermediateValue

							continueInInput := hasBacktick
							if !continueInInput
								break
							else {
								originalInput := input
								input := RegExReplace(input, RegExEscape(inputToCheck), output)

								if (input != originalInput) {
									tooltipSuggestions := input != "" ? ChrCrafter.FormatSuggestions(this.ValidateRecipes(RegExReplace(input, "``", ""), True)) : ""
									CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input "`n" currentInputMode (favoriteSuggestions) ((StrLen(tooltipSuggestions) > 0 && !RegExMatch(input, "^\(\~\)\s")) ? "`n" tooltipSuggestions : ""))
								}

								continue
							}
						}
					}
				}
			}
		}

		PH.Stop()

		if InStr(output, "N/A") {
			CaretTooltip(Chr(0x26A0) " " Locale.Read("warning_recipe_absent"))
			SetTimer(Tooltip, -1000)

		} else {
			CaretTooltip(Chr(0x2705) " " input " " Chr(0x2192) " " Util.StrFormattedReduce(output))
			SetTimer(Tooltip, -500)
			if !InStr(output, "N/A") || output != input
				this.SendOutput(output)
		}

		return
	}

	static SendOutput(output) {
		output := RegExReplace(output, "\#", "")
		if StrLen(output) > 20
			ClipSend(output)
		else
			SendText(output)
	}

	static ValidateRecipes(prompt, getSuggestions := False, breakSkip := False, restrictClasses := []) {
		promptBackup := prompt
		output := ""

		promptValidator := RegExEscape(prompt)
		breakValidate := True
		monoCaseRecipe := False

		charFound := False

		isPrefixOfLongerRecipe := False
		for validatingValue in ChrLib.entryRecipes {
			if (RegExMatch(validatingValue, "^" promptValidator) && validatingValue != prompt) {
				isPrefixOfLongerRecipe := True
				break
			}
		}

		if !isPrefixOfLongerRecipe {
			for validatingValue in ChrLib.entryRecipes {
				if (RegExMatch(StrLower(validatingValue), "^" StrLower(promptValidator)) && StrLower(validatingValue) != StrLower(prompt)) {
					isPrefixOfLongerRecipe := True
					break
				}
			}
		}

		for validatingValue in ChrLib.entryRecipes {
			if (RegExMatch(validatingValue, "^" promptValidator)) {
				breakValidate := False
				break
			}
		}

		if breakValidate {
			for validatingValue in ChrLib.entryRecipes {
				if (RegExMatch(StrLower(validatingValue), "^" StrLower(promptValidator))) {
					monoCaseRecipe := True
					breakValidate := False
					break
				}
			}
		}

		if breakValidate && !breakSkip
			return "N/A"

		indexedValueResult := Map()

		if getSuggestions {
			recipeVariantsMap := Map()

			for characterEntry, value in ChrLib.entries.OwnProps() {
				if value.recipe.Length == 0 || (restrictClasses.Length > 0 && !(restrictClasses.Contains(value.symbol.category))) {
					continue
				}

				recipe := value.recipe

				if IsObject(recipe) {
					for _, recipeEntry in recipe {
						lowerRecipe := StrLower(recipeEntry)
						recipeVariantsMap[lowerRecipe] := recipeVariantsMap.Has(lowerRecipe) ? recipeVariantsMap[lowerRecipe] + 1 : 1
					}
				} else {
					lowerRecipe := StrLower(recipe)
					recipeVariantsMap[lowerRecipe] := recipeVariantsMap.Has(lowerRecipe) ? recipeVariantsMap[lowerRecipe] + 1 : 1
				}
			}
		}

		for characterEntry, value in ChrLib.entries.OwnProps() {
			notHasRecipe := value.recipe.Length == 0
			notInRestrictClass := restrictClasses.Length > 0 && !(restrictClasses.Contains(value.symbol.category))

			if notInRestrictClass {
				continue
			} else if notHasRecipe {
				continue
			} else {
				recipe := value.recipe

				if IsObject(recipe) {
					for _, recipeEntry in recipe {
						if getSuggestions {
							caseSensitiveMatch := RegExMatch(recipeEntry, "^" RegExEscape(prompt))

							uniqueRecipeMatch := False
							if !caseSensitiveMatch {
								lowerRecipe := StrLower(recipeEntry)
								if recipeVariantsMap.Has(lowerRecipe) && recipeVariantsMap[lowerRecipe] == 1 {
									uniqueRecipeMatch := RegExMatch(StrLower(recipeEntry), "^" StrLower(RegExEscape(prompt)))
								}
							}

							if caseSensitiveMatch || uniqueRecipeMatch {
								charFound := True
								indexedValueResult.Set(value.index, this.GetRecipesString_NEW(characterEntry))
							}
						} else if (!monoCaseRecipe && prompt == recipeEntry) || (monoCaseRecipe && StrLower(prompt) == StrLower(recipeEntry)) {
							charFound := True
							indexedValueResult.Set(value.index, ChrLib.Get(characterEntry, True, Cfg.Get("Input_Mode")))
							if !isPrefixOfLongerRecipe
								break 2
						}
					}
				} else {
					if getSuggestions {
						caseSensitiveMatch := RegExMatch(recipe, "^" RegExEscape(prompt))

						uniqueRecipeMatch := False
						if !caseSensitiveMatch {
							lowerRecipe := StrLower(recipe)
							if recipeVariantsMap.Has(lowerRecipe) && recipeVariantsMap[lowerRecipe] == 1 {
								uniqueRecipeMatch := RegExMatch(StrLower(recipe), "^" StrLower(RegExEscape(prompt)))
							}
						}

						if caseSensitiveMatch || uniqueRecipeMatch {
							charFound := True
							indexedValueResult.Set(value.index, this.GetRecipesString_NEW(characterEntry))
						}
					} else if (!monoCaseRecipe && prompt == recipe) || (monoCaseRecipe && StrLower(prompt) == StrLower(recipe)) {
						charFound := True
						indexedValueResult.Set(value.index, ChrLib.Get(characterEntry, True, Cfg.Get("Input_Mode")))
						if !isPrefixOfLongerRecipe
							break
					}
				}
			}
		}

		if !charFound && !isPrefixOfLongerRecipe {
			IntermediateValue := prompt
			for characterEntry, value in ChrLib.entries.OwnProps() {
				notHasRecipe := value.recipe.Length == 0
				notInRestrictClass := restrictClasses.Length > 0 && !(restrictClasses.Contains(value.symbol.category))

				if notInRestrictClass {
					continue
				} else if notHasRecipe {
					continue
				} else {
					recipe := value.recipe

					if IsObject(recipe) {
						for _, recipeEntry in recipe {
							if InStr(IntermediateValue, recipeEntry, true) {
								IntermediateValue := StrReplace(IntermediateValue, recipeEntry, this.GetComparedChar(value))
							}
						}
					} else {
						if InStr(IntermediateValue, recipe, true) {
							IntermediateValue := StrReplace(IntermediateValue, recipe, this.GetComparedChar(value))
						}
					}
				}
			}

			if IntermediateValue != prompt {
				output := IntermediateValue
				charFound := True
			}
		}

		if charFound {
			for key, value in indexedValueResult {
				output .= value
			}
		}

		return output
	}

	static EntriesWalk(prompt, getSuggestions := False, breakSkip := False, restrictClasses := []) {
		promptBackup := prompt
		output := ""

		promptValidator := RegExEscape(prompt)
		breakValidate := True
		monoCaseRecipe := False

		charFound := False

		for validatingValue in RecipeValidatorArray {
			if (RegExMatch(validatingValue, "^" promptValidator)) {
				breakValidate := False
				break
			}
		}

		if breakValidate {
			for validatingValue in RecipeValidatorArray {
				if (RegExMatch(StrLower(validatingValue), "^" StrLower(promptValidator))) {
					monoCaseRecipe := True
					breakValidate := False
					break
				}
			}
		}

		if breakValidate && !breakSkip
			return "N/A"
		for characterEntry, value in Characters {
			notHasRecipe := value.recipe.Length == 0
			notInRestrictClass := restrictClasses.Length > 0 && (StrLen(value.symbol.category) == 0 || !restrictClasses.Contains(value.symbol.category))

			if notInRestrictClass {
				continue
			} else if notHasRecipe {
				continue
			} else {

				recipe := value.recipe

				if IsObject(recipe) {
					for _, recipeEntry in recipe {
						if (getSuggestions && RegExMatch(recipeEntry, "^" RegExEscape(prompt))) || (!monoCaseRecipe && prompt == recipeEntry) || (monoCaseRecipe && prompt = recipeEntry) {
							charFound := True

							if getSuggestions {
								output .= this.GetRecipesString(value)

							} else {
								output := this.GetComparedChar(value)
								break 2
							}
						}
					}
				} else if (getSuggestions && RegExMatch(recipe, "^" RegExEscape(prompt))) || (!monoCaseRecipe && prompt == recipe) || (monoCaseRecipe && prompt = recipe) {
					charFound := True

					if getSuggestions {
						output .= this.GetRecipesString(value)

					} else {
						output := this.GetComparedChar(value)
						break
					}
				}
			}
		}

		if !charFound {
			IntermediateValue := prompt
			for characterEntry, value in Characters {
				notHasRecipe := value.recipe.Length == 0
				notInRestrictClass := restrictClasses.Length > 0 && (StrLen(value.symbol.category) == 0 || !restrictClasses.Contains(value.symbol.category))

				if notInRestrictClass {
					continue
				} else if notHasRecipe {
					continue
				} else {
					recipe := value.recipe

					if IsObject(recipe) {
						for _, recipeEntry in recipe {
							if InStr(IntermediateValue, recipeEntry, true) {
								IntermediateValue := StrReplace(IntermediateValue, recipeEntry, this.GetComparedChar(value))
							}
						}
					} else {
						if InStr(IntermediateValue, recipe, true) {
							IntermediateValue := StrReplace(IntermediateValue, recipe, this.GetComparedChar(value))
						}
					}
				}
			}

			if IntermediateValue != prompt {
				output := IntermediateValue
				charFound := True
			}
		}

		return output
	}

	static ReadFavorites() {
		output := ""

		getList := FavoriteChars.ReadList()

		for line in getList {
			if StrLen(line) > 0 {
				characterEntry := ChrLib.GetEntry(line)

				if characterEntry.recipe.Length = 0 {
					continue
				} else {
					output .= this.GetRecipesString(characterEntry)
				}
			}
		}

		if StrLen(output) > 0 {
			output := ChrCrafter.FormatSuggestions(output)
		}

		return output
	}

	static FormatSuggestions(suggestions, maxLength := 72) {
		if suggestions = "N/A"
			return suggestions

		output := ""
		currentLine := ""
		parts := StrSplit(suggestions, "), ")

		uniqueParts := []
		for index, part in parts {
			part := part ")"

			isUnique := true
			for uniquePart in uniqueParts {
				if (part == uniquePart) {
					isUnique := false
					break
				}
			}

			if StrLen(part) > 2 && (isUnique) {
				uniqueParts.Push(part)
			}
		}

		for part in uniqueParts {
			if (StrLen(currentLine) + StrLen(part) + 2 <= maxLength) {
				currentLine .= part ", "
			} else {
				output .= currentLine "`n"
				currentLine := part ", "
			}
		}

		if (currentLine != "") {
			output .= currentLine
		}

		output := RegExReplace(output, ",\s$", "")

		return output
	}

	static GetRecipesString_NEW(entryName) {
		output := ""

		recipe := ChrRecipeHandler.GetStr(entryName, True, " | ")
		uniSequence := Util.StrFormattedReduce(ChrLib.Get(entryName), , True)

		output .= uniSequence " (" (IsObject(recipe) ? recipe.ToString(" | ") : recipe) "), "

		return output
	}

	static GetRecipesString(value) {
		output := ""

		recipe := value.recipeAlt.Length > 0 ? value.recipeAlt : value.recipe
		uniSequence := Util.StrFormattedReduce(this.GetUniChar(value, True))

		if IsObject(recipe) {
			intermediateValue := ""

			for _, recipeEntry in recipe {
				intermediateValue .= " " recipeEntry " |"
			}

			output .= uniSequence " (" RegExReplace(intermediateValue, "(^\s|\s\|$)", "") "), "
		} else {
			output .= uniSequence " (" recipe "), "
		}

		return output
	}

	static GetComparedChar(value) {
		output := ""
		if InputMode = "HTML" && StrLen(value.html) > 0 {
			output :=
				(this.modifiedCharsType && HasProp(value, this.modifiedCharsType "HTML")) ? value.%this.modifiedCharsType%HTML :
				(StrLen(value.entity) > 0 ? value.entity : value.html)

		} else if InputMode = "LaTeX" && value.LaTeX.Length > 0 {
			output := LaTeXMode = "Math" ? value.LaTeX[2] : value.LaTeX[1]

		} else {
			output := this.GetUniChar(value)
		}
		return output
	}

	static GetUniChar(value, forceDefault := False) {
		output := ""
		if this.modifiedCharsType && HasProp(value, this.modifiedCharsType "Form") && !forceDefault {
			if IsObject(value.%this.modifiedCharsType%Form) {
				TempValue := ""
				for modifier in value.%this.modifiedCharsType%Form {
					TempValue .= PasteUnicode(modifier)
				}
				output := TempValue
			} else {
				output := PasteUnicode(value.%this.modifiedCharsType%Form)
			}
		} else if value.sequence.Length > 0 {
			for unicode in value.sequence {
				output .= PasteUnicode(unicode)
			}
		} else {
			output := PasteUnicode(value.unicode)
		}
		return output
	}
}