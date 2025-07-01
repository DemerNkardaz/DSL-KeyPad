Class ChrCrafter {
	composeKeyClicks := 0
	composeKeyTimer := ""
	isComposeInstanceActive := False

	Start(compositingMode := "InputBox") {
		this.compositingMode := compositingMode
		this.modifiedCharsType := Scripter.selectedMode.Get("Glyph Variations")
		this.prompt := Util.HexaDecimalToChr(Cfg.Get("Ligature", "LatestPrompts"))

		this.%this.compositingMode%Mode()
		try {
		} catch {
			if this.compositingMode = "InputBox"
				MsgBox(Locale.Read("warning_recipe_absent"), Locale.Read("symbol_smelting"), 0x30)
		}
	}

	InputBoxMode() {
		local IB := InputBox(Locale.Read("symbol_smelting_prompt"), Locale.Read("symbol_smelting"), "w256 h92", this.prompt)
		if IB.Result = "Cancel"
			return
		else
			this.prompt := IB.Value

		if this.prompt != "" {
			local output := ""
			for prompt in StrSplit(this.prompt, " ")
				output .= this.ValidateRecipes(prompt, , True) " "

			if output = "" || output ~= "^\s+$"
				return
			else {
				output := RegExReplace(output, "\s+$", "")
				this.SendOutput(&output)

				Cfg.Set(Util.ChrToHexaDecimal(SubStr(this.prompt, 1, 128)), "Ligature", "LatestPrompts")
			}
		}

		return
	}

	ComposeMode() {
		this.isComposeInstanceActive := True
		local ChrBlockInstance := ChrBlock()
		local output := ""
		local input := ""
		local previousInput := ""
		local pastInput := ""

		local tooltipSuggestions := ""
		local favoriteSuggestions := this.ReadFavorites()

		favoriteSuggestions := (
			favoriteSuggestions != "" ? (
				"`n" Chrs([0x2E3B, 10]) "`n"
				Chr(0x272A) " " Locale.Read("feature_favorites") "`n"
				RegExReplace(favoriteSuggestions, ",\s+$", "") "`n"
				Chrs([0x2E3B, 10])
			) : ""
		)

		local insertType := ""
		local currentInputMode := Locale.ReadInject("tooltip_input_mode", ["[" Auxiliary.inputMode "]"])

		local pauseOn := False
		local cancelledByUser := False
		local cleanPastInput := False

		local continueInInput := False
		local surrogatePair := ""
		local surrogatInput := ""

		local forceSurrogates := ["Old Persian", "Shavian"].HasValue(Scripter.selectedMode.Get("Alternative Modes"))
		local symCount := forceSurrogates ? 2 : 1

		local PH := InputHook("L0", "{Escape}")
		PH.Start()

		ComposeSuggestedTooltip() {
			local recipesToBeSuggested := this.ValidateRecipes(inputWithoutBackticks, True)
			tooltipSuggestions := input != "" ? this.FormatSuggestions(&recipesToBeSuggested) : ""

			Util.CaretTooltip(
				(pauseOn ? Chr(0x23F8) : Chr(0x2B1C))
				" " input "`n"
				currentInputMode
				(favoriteSuggestions)
				((StrLen(tooltipSuggestions) > 0) ? "`n" tooltipSuggestions : "")
			)
		}

		local tooltips := Map(
			"default", (*) => Util.CaretTooltip(
				(pauseOn ? Chr(0x23F8) : Chr(0x2B1C))
				" "
				input
				(favoriteSuggestions)
			),
			"unialt", (*) => Util.CaretTooltip(
				(Chr(0x2B1C))
				" "
				input "`n"
				"[ ]"
				Chr(0x2002) "`n"
				Locale.Read("tooltip_compose_" StrLower(insertType) "_range")
			),
			"suggested", (*) => ComposeSuggestedTooltip()
		)

		Loop {
			insertType := RegExMatch(input, "i)^([uюυaаα])\+", &m) ? (m[1] ~= "i)[uюυ]" ? "Unicode" : "Altcode") : ""
			local codes := RegExReplace(input, "i)^([uюυaаα])\+", "")

			local ruleTooltip := (
				insertType != "" && StrLen(input) > 1 && StrLen(input) < 3 ? "unialt"
				: insertType = "" && tooltipSuggestions != "" ? "suggested"
				: StrLen(input) < 2 ? "default" : ""
			)

			local useTooltip := tooltips.Has(ruleTooltip) ? tooltips.Get(ruleTooltip)() : (*) => []

			local IH := InputHook("L" symCount, "{Escape}{Backspace}{Enter}{Pause}{Tab}{Insert}")
			IH.Start(), IH.Wait()

			(IH.EndKey = "Backspace") && StrLen(input) > 0 && input := SubStr(input, 1, -symCount)
			(IH.EndKey = "Insert") && ClipWait(0.5, 1) && input .= this.parseUniAlt(A_Clipboard, input, insertType)
			(IH.EndKey = "Pause") && pauseOn := !pauseOn

			if (IH.EndKey = "Escape") {
				input := ""
				output := ""
				cancelledByUser := True
				PH.Stop()
				break
			} else if IH.Input != "" {
				input .= this.parseUniAlt(IH.Input, input, insertType)

				if InputScriptProcessor.options.interceptionInputMode != "" && StrLen(input) > 1 {
					local charPair := StrLen(input) > 2 && previousInput = "\" ? pastInput previousInput IH.Input : previousInput IH.Input
					local telexChar := InputScriptProcessor.TelexReturn(&charPair)

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

			if input ~= "^\([~0-9]"
				pauseOn := True

			inputWithoutBackticks := RegExReplace(input, "``", "")

			hasBacktick := InStr(input, "``")

			if insertType = "" {
				currentInputMode := Locale.ReadInject("tooltip_input_mode", ["[" Auxiliary.inputMode "]"])
				ComposeSuggestedTooltip()
			}

			insertType := RegExMatch(input, "i)^([uюυaаα])\+", &m) ? (m[1] ~= "i)[uюυ]" ? "Unicode" : "Altcode") : ""
			local reservedNoBreak := RegExMatch(input, "i)^(ю)") && StrLen(input) = 1

			if insertType != "" {
				input := StrUpper(input)
				codes := RegExReplace(input, "i)^([uюυaаα])\+", "")
				local codesArray := StrSplit(codes, " ")

				for i, checkEmpty in codesArray
					if checkEmpty = "" || checkEmpty ~= "^\s+$"
						codesArray.RemoveAt(i)

				local suggestion := ""

				if codesArray.length > 0 {
					for code in codesArray
						if code != "" && CharacterInserter.%insertType%Validate(code)
							suggestion .= CharacterInserter.%insertType%(code)

					local blockShown := codesArray.Length > 0 ? ChrBlockInstance.GetTooltip(codesArray[codesArray.Length], insertType) : Locale.Read("tooltip_compose_" StrLower(insertType) "_range")
					Util.CaretTooltip(
						(pauseOn ? Chr(0x23F8) : Chr(0x2B1C))
						" "
						input "`n"
						"[ " suggestion " ]"
						Chr(0x2002) "`n"
						blockShown
					)
				}

				output := suggestion

				if IH.EndKey = "Enter"
					break
			} else if !pauseOn || (IH.EndKey = "Enter") {
				if reservedNoBreak
					continue
				try {
					if (RegExMatch(input, "\((\d+)[\~]?\)\s+(.*)", &match)) {
						local repeatCount := (Number(match[1]) <= 100 && Number(match[1]) > 0) ? match[1] : 1
						local postInput := match[2]
						local intermediateValue := ""

						local postInputNoBackticks := RegExReplace(postInput, "``", "")
						local postInputHasBacktick := InStr(postInput, "``")

						Loop repeatCount {
							intermediateValue .= this.ValidateRecipes(postInputNoBackticks, , input ~= "^\(\d+~\)\s")

							local len := StrLen(intermediateValue)
							if (len >= 2) {
								local reduction := 1 + Floor(len / 2)
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
									local recipesToBeSuggested := this.ValidateRecipes(RegExReplace(input, "``", ""), True)
									tooltipSuggestions := input != "" ? this.FormatSuggestions(&recipesToBeSuggested) : ""

									Util.CaretTooltip(
										(pauseOn ? Chr(0x23F8) : Chr(0x2B1C))
										" "
										input "`n"
										currentInputMode
										(favoriteSuggestions)
										((StrLen(tooltipSuggestions) > 0) ? "`n" tooltipSuggestions : "")
									)
								}

								continue
							}
						}
					} else {
						local usePartialMode := input ~= "^\(\~\)\s"
						local inputToCheck := RegExReplace(input, "^\(\~\)\s", "")

						local inputToCheckNoBackticks := RegExReplace(inputToCheck, "``", "")

						local intermediateValue := this.ValidateRecipes(inputToCheckNoBackticks, , usePartialMode, , hasBacktick)
						if intermediateValue != "" {
							output := intermediateValue

							continueInInput := hasBacktick
							if !continueInInput
								break
							else {
								local originalInput := input
								input := RegExReplace(input, RegExEscape(inputToCheck), output)

								if (input != originalInput && insertType = "") {
									local recipesToBeSuggested := this.ValidateRecipes(RegExReplace(input, "``", ""), True)
									tooltipSuggestions := input != "" ? this.FormatSuggestions(&recipesToBeSuggested) : ""

									Util.CaretTooltip(
										(pauseOn ? Chr(0x23F8) : Chr(0x2B1C))
										" "
										input "`n"
										currentInputMode
										(favoriteSuggestions)
										((StrLen(tooltipSuggestions) > 0) ? "`n" tooltipSuggestions : "")
									)
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
				this.SendOutput(&output)
		}

		this.isComposeInstanceActive := False
		return
	}

	parseUniAlt(str, input, insertType) {
		output := ""
		if insertType != "" {
			temp := input str
			tempCodes := RegExReplace(temp, "i)^([uюυaаα])\+", "")

			tempCodesArray := StrSplit(tempCodes, " ")

			for i, checkEmpty in tempCodesArray
				if checkEmpty = "" || checkEmpty ~= "^\s+$"
					tempCodesArray.RemoveAt(i)

			if tempCodesArray.length > 0 {
				if str ~= "i)[АБСЦДЕФΑΒΨΣΔΕΦ]"
					str := Util.HexNonLatinToLatin(str)
				if CharacterInserter.%insertType%Validate(tempCodesArray[tempCodesArray.length])
					output .= str
			}

		} else
			output .= str

		return output
	}

	ComposeActivate() {
		if this.composeKeyClicks = 1 {
			this.composeKeyClicks := 0
			this.Start("Compose")
			return
		} else {
			this.composeKeyClicks++
			this.ComposeActivationWait()
		}
	}

	ComposeActivationWait() {
		if !(this.composeKeyTimer is String) {
			SetTimer(SetZero, 0)
			this.composeKeyTimer := ""
		}

		return SetTimer(SetZero, -300)

		SetZero(*) {
			this.composeKeyClicks := 0
		}
	}

	SendOutput(&output) {
		output := Auxiliary.inputMode = "Unicode" ? RegExReplace(output, "\#\#", "") : output
		if StrLen(output) > 20
			ClipSend(output)
		else
			SendText(output)
	}

	ValidateRecipes(prompt, getSuggestions := False, breakSkip := False, restrictClasses := [], hasBacktick := False) {
		if prompt = ""
			return

		inputMode := !hasBacktick ? Auxiliary.inputMode : "Unicode"

		promptBackup := prompt
		output := ""

		promptValidator := RegExEscape(prompt)
		breakValidate := True
		monoCaseRecipe := False

		charFound := False


		isPrefixOfLongerRecipe := False
		for validatingValue in ChrLib.entryRecipes {
			if validatingValue ~= "^" promptValidator && validatingValue != prompt {
				isPrefixOfLongerRecipe := True
				break
			}
		}

		if !isPrefixOfLongerRecipe {
			for validatingValue in ChrLib.entryRecipes {
				if validatingValue ~= "i)^" promptValidator && validatingValue ~= "i)^(?!" prompt "$).+" {
					isPrefixOfLongerRecipe := True
					break
				}
			}
		}

		for validatingValue in ChrLib.entryRecipes {
			if validatingValue ~= "^" promptValidator {
				breakValidate := False
				break
			}
		}

		if breakValidate {
			for validatingValue in ChrLib.entryRecipes {
				if validatingValue ~= "i)^" promptValidator {
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

			for entryName, entry in ChrLib.entries.OwnProps() {
				if entry["recipe"].Length == 0 || (restrictClasses.Length > 0 && !(restrictClasses.Contains(entry["symbol"]["category"]))) {
					continue
				}

				recipe := entry["recipe"]

				if recipe is Array {
					for _, recipeEntry in recipe {
						lowerRecipe := StrLower(recipeEntry)
						recipeVariantsMap[lowerRecipe] := recipeVariantsMap.Has(lowerRecipe) ? recipeVariantsMap[lowerRecipe] + 1 : 1
					}
				}
			}
		}

		for entryName, entry in ChrLib.entries.OwnProps() {
			notHasRecipe := entry["recipe"].Length == 0
			notInRestrictClass := restrictClasses.Length > 0 && !(restrictClasses.Contains(entry["symbol"]["category"]))

			if notInRestrictClass {
				continue
			} else if notHasRecipe {
				continue
			} else {
				recipe := entry["recipe"]

				if recipe is Array {
					for _, recipeEntry in recipe {
						if getSuggestions {
							caseSensitiveMatch := recipeEntry ~= "^" RegExEscape(prompt)

							uniqueRecipeMatch := False
							if !caseSensitiveMatch {
								lowerRecipe := StrLower(recipeEntry)
								if recipeVariantsMap.Has(lowerRecipe) && recipeVariantsMap[lowerRecipe] == 1 {
									uniqueRecipeMatch := recipeEntry ~= "i)^" RegExEscape(prompt)
								}
							}

							if caseSensitiveMatch || uniqueRecipeMatch {
								charFound := True
								if entry["options"]["suggestionsAtEnd"]
									indexedAtEndValueResult.Set(entry["index"], this.GetRecipesString(&entryName, &prompt))
								else
									indexedValueResult.Set(entry["index"], this.GetRecipesString(&entryName, &prompt))
							}
						} else if (!monoCaseRecipe && prompt == recipeEntry) || (monoCaseRecipe && StrLower(prompt) == StrLower(recipeEntry)) {
							charFound := True
							if entry["options"]["suggestionsAtEnd"]
								indexedAtEndValueResult.Set(entry["index"], ChrLib.Get(entryName, True, inputMode))
							else
								indexedValueResult.Set(entry["index"], ChrLib.Get(entryName, True, inputMode))
							if !isPrefixOfLongerRecipe
								break 2
						}
					}
				}
			}
		}

		if !charFound && !isPrefixOfLongerRecipe {
			IntermediateValue := prompt
			for entryName, entry in ChrLib.entries.OwnProps() {
				notHasRecipe := entry["recipe"].Length == 0
				notInRestrictClass := restrictClasses.Length > 0 && !(restrictClasses.Contains(entry["symbol"]["category"]))

				if notInRestrictClass {
					continue
				} else if notHasRecipe {
					continue
				} else {
					recipe := entry["recipe"]

					if IsObject(recipe) {
						for _, recipeEntry in recipe {
							if InStr(IntermediateValue, recipeEntry, true) {
								IntermediateValue := StrReplace(IntermediateValue, recipeEntry, this.GetComparedChar(&entry))
							}
						}
					} else {
						if InStr(IntermediateValue, recipe, true) {
							IntermediateValue := StrReplace(IntermediateValue, recipe, this.GetComparedChar(&entry))
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
				for key, entry in indexedMap {
					output .= entry
				}
			}
		}

		return output
	}

	ReadFavorites() {
		local output := ""

		local getList := FavoriteChars.ReadList()

		for line in getList {
			if StrLen(line) > 0 {
				if ChrLib.entries.HasOwnProp(line) {
					if ChrLib.entries.%line%["recipe"].Length = 0 {
						continue
					} else {
						output .= this.GetRecipesString(&line)
					}
				}
			}
		}

		if StrLen(output) > 0 {
			output := this.FormatSuggestions(&output)
		}

		return output
	}

	GetRecipesString(&entryName, &prompt := "") {
		local output := ""

		local recipe := ChrRecipeHandler.GetStr(entryName, True, " | ", prompt)
		local entry := ChrLib.GetEntry(entryName)
		local uniSequence := ""
		if StrLen(entry["symbol"]["alt"]) {
			uniSequence := entry["symbol"]["alt"]
		} else {
			uniSequence := Util.StrFormattedReduce(ChrLib.Get(entryName), , True)
		}

		output .= uniSequence " (" (IsObject(recipe) ? recipe.ToString(" | ") : recipe) "), "

		return output
	}

	GetComparedChar(&entry) {
		local output := ""
		if Auxiliary.inputMode = "HTML" && StrLen(entry["html"]) > 0 {
			output :=
				(this.modifiedCharsType && entry.Has(this.modifiedCharsType "HTML")) ? entry[this.modifiedCharsType "HTML"] :
				(StrLen(entry["entity"]) > 0 ? entry["entity"] : entry["html"])

		} else if Auxiliary.inputMode = "LaTeX" && entry["LaTeX"].Length > 0 {
			output := Cfg.Get("LaTeX_Mode", , "Text") = "Math" ? entry["LaTeX"][2] : entry["LaTeX"][1]

		} else {
			output := this.GetUniChar(&entry)
		}
		return output
	}

	GetUniChar(&entry, forceDefault := False) {
		local output := ""
		if this.modifiedCharsType && entry["alterations"].Has(this.modifiedCharsType) && !forceDefault {
			if IsObject(entry["alterations"][this.modifiedCharsType]) {
				local tempValue := ""
				for modifier in entry["alterations"][this.modifiedCharsType] {
					tempValue .= Util.UnicodeToChar(modifier)
				}
				output := tempValue
			} else {
				output := Util.UnicodeToChar(entry["alterations"][this.modifiedCharsType])
			}
		} else if entry["sequence"].Length > 0 {
			for unicode in entry["sequence"] {
				output .= Util.UnicodeToChar(unicode)
			}
		} else {
			output := Util.UnicodeToChar(entry["unicode"])
		}
		return output
	}

	EffectiveLength(&str) {
		local length := StrLen(str)

		local symbolCount := 0
		local pos := 1
		while (pos := InStr(str, DottedCircle, false, pos)) {
			symbolCount++
			pos++
		}

		return length - symbolCount
	}

	FormatSuggestions(&suggestions, maxLength := 80) {
		if suggestions = "N/A"
			return suggestions

		local output := ""
		local currentLine := ""
		local parts := StrSplit(suggestions, "), ")

		local uniqueParts := []
		for index, part in parts {
			part := part ")"

			local isUnique := True
			for uniquePart in uniqueParts {
				if (part == uniquePart) {
					isUnique := False
					break
				}
			}

			if this.EffectiveLength(&part) > 2 && (isUnique)
				uniqueParts.Push(part)
		}

		for part in uniqueParts {
			if (this.EffectiveLength(&currentLine) + this.EffectiveLength(&part) + 2 <= maxLength) {
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

		return this.SuggestionsLimiter(&output)
	}

	SuggestionsLimiter(&suggestions, maxLength := 80 * 8) {
		if this.EffectiveLength(&suggestions) <= maxLength
			return suggestions

		local effectivePos := 0
		local lastParenPos := 0

		Loop StrLen(suggestions) {
			local char := SubStr(suggestions, A_Index, 1)

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
				local char := SubStr(suggestions, A_Index, 1)

				if char != DottedCircle
					effectivePos++

				if effectivePos > maxLength
					break

				if char = " "
					lastParenPos := A_Index
			}

			if lastParenPos = 0 {
				local effectivePos := 0
				local realPos := 0

				Loop StrLen(suggestions) {
					local char := SubStr(suggestions, A_Index, 1)
					realPos := A_Index

					if char != DottedCircle
						effectivePos++

					if effectivePos >= maxLength
						break
				}

				lastParenPos := realPos
			}
		}

		return SubStr(suggestions, 1, lastParenPos) ", […]"
	}
}

globalInstances.crafter := ChrCrafter()