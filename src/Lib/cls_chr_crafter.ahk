Class ChrCrafter {
	static ComposeKeyClicks := 0
	static ComposeKeyTimer := ""

	static modifiedCharsType := ""
	static prompt := ConvertFromHexaDecimal(Cfg.Get("Ligature", "LatestPrompts"))

	__New(compositingMode := "InputBox") {
		this.compositingMode := compositingMode

		ChrCrafter.modifiedCharsType := GetModifiedCharsType()
		ChrCrafter.prompt := ConvertFromHexaDecimal(Cfg.Get("Ligature", "LatestPrompts"))

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

			if output = "" || output ~= "^\s+$"
				return
			else {
				output := RegExReplace(output, "\s+$", "")
				this.SendOutput(output)

				Cfg.Set(ConvertToHexaDecimal(SubStr(this.prompt, 1, 128)), "Ligature", "LatestPrompts")
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
		insertType := ""
		currentInputMode := Locale.ReadInject("tooltip_input_mode", ["[" Auxiliary.inputMode "]"])

		pauseOn := False
		cancelledByUser := False
		cleanPastInput := False

		continueInInput := False

		isUnicodeTyping := False
		isAltcodeTyping := False

		PH := InputHook("L0", "{Escape}")
		PH.Start()

		ComposeSuggestedTooltip() {
			tooltipSuggestions := input != "" ? this.FormatSuggestions(this.ValidateRecipes(inputWithoutBackticks, True)) : ""

			Util.CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input "`n" currentInputMode (favoriteSuggestions) ((StrLen(tooltipSuggestions) > 0 && !RegExMatch(input, "^\(\~\)\s")) ? "`n" tooltipSuggestions : ""))
		}

		tooltips := Map(
			"default", (*) => Util.CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input (favoriteSuggestions)),
			"unialt", (*) => Util.CaretTooltip((Chr(0x2B1C)) " " input "`n" "[ ]" Chr(0x2002) "`n" Locale.Read("tooltip_compose_" StrLower(insertType) "_range")),
			"suggested", (*) => ComposeSuggestedTooltip()
		)

		Loop {

			insertType := RegExMatch(input, "i)(^u\+|^ю\+)") ? "Unicode" : RegExMatch(input, "i)(^a\+|^а\+)") ? "Altcode" : ""
			codes := RegExReplace(input, "i)(^u\+|^a\+|^ю\+|^а\+)", "")

			ruleTooltip := insertType != "" && StrLen(input) > 1 && StrLen(input) < 3 ? "unialt" : insertType = "" && tooltipSuggestions != "" ? "suggested" : StrLen(input) < 2 ? "default" : ""
			useTooltip := tooltips.Has(ruleTooltip) ? tooltips.Get(ruleTooltip)() : (*) => []

			isUnicodeTyping := insertType = "Unicode" ? True : False
			isAltcodeTyping := insertType = "Altcode" ? True : False

			IH := InputHook("L1", "{Escape}{Backspace}{Enter}{Pause}{Tab}{Insert}")
			IH.Start(), IH.Wait()

			if (IH.EndKey = "Escape") {
				input := ""
				output := ""
				cancelledByUser := True
				PH.Stop()
				break

			} else if (IH.EndKey = "Pause") {
				pauseOn := pauseOn ? False : True

			} else if (IH.EndKey = "Backspace") {
				if StrLen(input) > 0
					input := SubStr(input, 1, -1)
			} else if (IH.EndKey = "Insert") {
				ClipWait(0.5, 1)
				input .= this.parseUniAlt(A_Clipboard, input, insertType)
			} else if IH.Input != "" {
				input .= this.parseUniAlt(IH.Input, input, insertType)

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

			if insertType = "" {
				currentInputMode := Locale.ReadInject("tooltip_input_mode", ["[" Auxiliary.inputMode "]"])
				ComposeSuggestedTooltip()
			}

			insertType := RegExMatch(input, "i)(^u\+|^ю\+)") ? "Unicode" : RegExMatch(input, "i)(^a\+|^а\+)") ? "Altcode" : ""
			reservedNoBreak := RegExMatch(input, "i)^(ю)") && StrLen(input) = 1

			if insertType != "" {
				input := StrUpper(input)
				codes := RegExReplace(input, "i)(^u\+|^a\+|^ю\+|^а\+)", "")
				codesArray := StrSplit(codes, " ")

				for i, checkEmpty in codesArray
					if checkEmpty = "" || checkEmpty ~= "^\s+$"
						codesArray.RemoveAt(i)

				suggestion := ""

				isUnicodeTyping := insertType = "Unicode" ? True : False
				isAltcodeTyping := insertType = "Altcode" ? True : False

				if codesArray.length > 0 {
					for code in codesArray {
						if code != "" && CharacterInserter.%insertType%Validate(code) {
							suggestion .= CharacterInserter.%insertType%(code)
						}
					}

					blockShown := codesArray.Length > 0 ? CharacterInserter.GetBlock(codesArray[codesArray.Length], insertType) : Locale.Read("tooltip_compose_" StrLower(insertType) "_range")
					Util.CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input "`n" "[ " suggestion " ]" Chr(0x2002) "`n" blockShown)
				}

				output := suggestion

				if IH.EndKey = "Enter"
					break
			} else if !pauseOn || (IH.EndKey = "Enter") {
				if reservedNoBreak
					continue
				isUnicodeTyping := False
				isAltcodeTyping := False

				try {
					if (RegExMatch(input, "\((\d+)[\~]?\)\s+(.*)", &match)) {
						repeatCount := (Number(match[1]) <= 100 && Number(match[1]) > 0) ? match[1] : 1
						postInput := match[2]
						intermediateValue := ""

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

								if insertType = "" {
									tooltipSuggestions := input != "" ? ChrCrafter.FormatSuggestions(this.ValidateRecipes(RegExReplace(input, "``", ""), True)) : ""
									Util.CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input "`n" currentInputMode (favoriteSuggestions) ((StrLen(tooltipSuggestions) > 0 && !RegExMatch(input, "^\(\~\)\s")) ? "`n" tooltipSuggestions : ""))
								}

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

								if (input != originalInput && insertType = "") {
									tooltipSuggestions := input != "" ? ChrCrafter.FormatSuggestions(this.ValidateRecipes(RegExReplace(input, "``", ""), True)) : ""
									Util.CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input "`n" currentInputMode (favoriteSuggestions) ((StrLen(tooltipSuggestions) > 0 && !RegExMatch(input, "^\(\~\)\s")) ? "`n" tooltipSuggestions : ""))
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
			Util.CaretTooltip(Chr(0x26A0) " " Locale.Read("warning_recipe_absent"))
			SetTimer(Tooltip, -1000)

		} else {
			endTooltip := cancelledByUser ? Chr(0x274E) " " Chr(0x2192) " " Locale.Read("warning_compose_cancelled_by_user") : Chr(0x2705) " " input " " Chr(0x2192) " " Util.StrFormattedReduce(output)
			Util.CaretTooltip(endTooltip)
			SetTimer(Tooltip, -500)
			if !InStr(output, "N/A") || output != input
				this.SendOutput(output)
		}
		return
	}
	static parseUniAlt(str, input, insertType) {
		output := ""
		if insertType != "" {
			temp := input str
			tempCodes := RegExReplace(temp, "i)(^u\+|^a\+|^ю\+|^а\+)", "")
			tempCodesArray := StrSplit(tempCodes, " ")

			for i, checkEmpty in tempCodesArray
				if checkEmpty = "" || checkEmpty ~= "^\s+$"
					tempCodesArray.RemoveAt(i)

			if tempCodesArray.length > 0
				if CharacterInserter.%insertType%Validate(tempCodesArray[tempCodesArray.length])
					output .= str

		} else
			output .= str

		return output
	}


	static ComposeActivate() {
		if this.ComposeKeyClicks = 1 {
			this.ComposeKeyClicks := 0
			ChrCrafter("Compose")
			return
		} else {
			this.ComposeKeyClicks++
			this.ComposeActivationWait()
		}
	}

	static ComposeActivationWait() {
		if !(this.ComposeKeyTimer is String) {
			SetTimer(SetZero, 0)
			this.ComposeKeyTimer := ""
		}

		return SetTimer(SetZero, -300)

		SetZero(*) {
			this.ComposeKeyClicks := 0
		}
	}

	static SendOutput(output) {
		output := Auxiliary.inputMode = "Unicode" ? RegExReplace(output, "\#\#", "") : output
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
		indexedAtEndValueResult := Map()

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
								if value.options.suggestionsAtEnd
									indexedAtEndValueResult.Set(value.index, this.GetRecipesString(characterEntry))
								else
									indexedValueResult.Set(value.index, this.GetRecipesString(characterEntry))
							}
						} else if (!monoCaseRecipe && prompt == recipeEntry) || (monoCaseRecipe && StrLower(prompt) == StrLower(recipeEntry)) {
							charFound := True
							if value.options.suggestionsAtEnd
								indexedAtEndValueResult.Set(value.index, ChrLib.Get(characterEntry, True, Auxiliary.inputMode))
							else
								indexedValueResult.Set(value.index, ChrLib.Get(characterEntry, True, Auxiliary.inputMode))
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
							if value.options.suggestionsAtEnd
								indexedAtEndValueResult.Set(value.index, this.GetRecipesString(characterEntry))
							else
								indexedValueResult.Set(value.index, this.GetRecipesString(characterEntry))
						}
					} else if (!monoCaseRecipe && prompt == recipe) || (monoCaseRecipe && StrLower(prompt) == StrLower(recipe)) {
						charFound := True
						if value.options.suggestionsAtEnd
							indexedAtEndValueResult.Set(value.index, ChrLib.Get(characterEntry, True, Auxiliary.inputMode))
						else
							indexedValueResult.Set(value.index, ChrLib.Get(characterEntry, True, Auxiliary.inputMode))
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
			for indexedMap in [indexedValueResult, indexedAtEndValueResult] {
				for key, value in indexedMap {
					output .= value
				}
			}
		}

		return output
	}

	static ReadFavorites() {
		output := ""

		getList := FavoriteChars.ReadList()

		for line in getList {
			if StrLen(line) > 0 {
				if ChrLib.entries.HasOwnProp(line) {
					if ChrLib.entries.%line%.recipe.Length = 0 {
						continue
					} else {
						output .= this.GetRecipesString(line)
					}
				}
			}
		}

		if StrLen(output) > 0 {
			output := ChrCrafter.FormatSuggestions(output)
		}

		return output
	}

	static EffectiveLength(str) {
		length := StrLen(str)

		symbolCount := 0
		pos := 1
		while (pos := InStr(str, DottedCircle, false, pos)) {
			symbolCount++
			pos++
		}

		return length - symbolCount
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

			if this.EffectiveLength(part) > 2 && (isUnique) {
				uniqueParts.Push(part)
			}
		}

		for part in uniqueParts {
			if (this.EffectiveLength(currentLine) + this.EffectiveLength(part) + 2 <= maxLength) {
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

		return this.SuggestionsLimiter(output)
	}

	static SuggestionsLimiter(suggestions, maxLength := 72 * 6) {
		if this.EffectiveLength(suggestions) <= maxLength
			return suggestions

		effectivePos := 0
		lastParenPos := 0

		Loop StrLen(suggestions) {
			char := SubStr(suggestions, A_Index, 1)

			if char != DottedCircle
				effectivePos++

			if effectivePos > maxLength
				break

			if char = ")"
				lastParenPos := A_Index
		}

		if lastParenPos = 0 {
			effectivePos := 0

			Loop StrLen(suggestions) {
				char := SubStr(suggestions, A_Index, 1)

				if char != DottedCircle
					effectivePos++

				if effectivePos > maxLength
					break

				if char = " "
					lastParenPos := A_Index
			}

			if lastParenPos = 0 {
				effectivePos := 0
				realPos := 0

				Loop StrLen(suggestions) {
					char := SubStr(suggestions, A_Index, 1)
					realPos := A_Index

					if char != DottedCircle
						effectivePos++

					if effectivePos >= maxLength
						break
				}

				lastParenPos := realPos
			}
		}

		output := SubStr(suggestions, 1, lastParenPos) ", […]"
		return output
	}

	static GetRecipesString(entryName) {
		output := ""

		recipe := ChrRecipeHandler.GetStr(entryName, True, " | ")
		entry := ChrLib.GetEntry(entryName)
		uniSequence := ""
		if StrLen(entry.symbol.alt) {
			uniSequence := entry.symbol.alt
		} else {
			uniSequence := Util.StrFormattedReduce(ChrLib.Get(entryName), , True)
		}

		output .= uniSequence " (" (IsObject(recipe) ? recipe.ToString(" | ") : recipe) "), "

		return output
	}


	static GetComparedChar(value) {
		output := ""
		if Auxiliary.inputMode = "HTML" && StrLen(value.html) > 0 {
			output :=
				(this.modifiedCharsType && HasProp(value, this.modifiedCharsType "HTML")) ? value.%this.modifiedCharsType%HTML :
				(StrLen(value.entity) > 0 ? value.entity : value.html)

		} else if Auxiliary.inputMode = "LaTeX" && value.LaTeX.Length > 0 {
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