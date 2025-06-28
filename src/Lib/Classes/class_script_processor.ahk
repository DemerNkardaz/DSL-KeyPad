Class InputScriptProcessor {
	static options := { interceptionInputMode: "" }

	static TelexReturn(&input) {
		local output := input
		local sequences := JSON.LoadFile(App.paths.data "\script_processor_sequences.json", "UTF-8")

		for key, value in sequences[this.options.interceptionInputMode] {
			isValid := input == key || InStr(input, "\") && (key == (SubStr(input, 1, 1) SubStr(input, 3)))
			if isValid {
				getValue := input == key ? value : key
				output := getValue
				break
			}
		}
		sequences := unset
		return output
	}

	library := JSON.LoadFile(App.paths.data "\script_processor_library.json", "UTF-8")
	sequences := Map("Escaped", Map(), "Default", Map())

	__New(mode := "Tieng Viet") {
		this.tag := StrLower(StrReplace(mode, " ", "_"))
		this.mode := mode

		this.Init()
		this.SetSequences()

		this.library := unset
	}

	Start(reloadHs := False) {
		local previousMode := InputScriptProcessor.options.interceptionInputMode
		if previousMode != "" {
			globalInstances.scriptProcessors[previousMode].Stop()
			if previousMode = this.mode
				return
		}

		local currentAlt := Scripter.selectedMode.Get("Alternative Modes")

		if currentAlt != "" {
			local nameTitle := Locale.Read(Scripter.GetData(, currentAlt).locale)
			local IPSTitle := Locale.Read("script_processor_mode_" this.tag)
			MsgBox(Locale.ReadInject("script_processor_warning_alt_mode_active", [IPSTitle, nameTitle]), App.Title(), "Icon!")
			return
		}

		this.RegistryHotstrings(reloadHs)
	}

	Stop() {
		InputScriptProcessor.options.interceptionInputMode := ""
		this.InH.Stop()
		this.inputLogger := ""
		Tooltip()
	}


	GenerateSequences(libLink, ending?, replaceWith?) {
		local output := Map()
		if IsObject(libLink) {
			local tempArray := []
			for i, key in libLink {
				if Mod(i, 3) = 1 {
					local link := libLink[i]
					ending := libLink[i + 1]
					replaceWith := libLink[i + 2]

					output := MapMerge(output, this.GenerateSequences(link, ending, replaceWith))
				}
			}

		} else {
			RegExMatch(libLink, "^(.*?):(.*?)(?:\[(.*?)\])?(?:::escape)?$", &match)

			local escape := ""
			if RegExMatch(libLink, "::escape$")
				escape := "[escape]"

			local category := match[1]
			local libChar := match[2]
			local inputVariations := match[3] = "" ? [""] : StrSplit(match[3], ", ")

			if ending is String
				ending := [StrLower(ending), StrUpper(ending)]


			if IsObject(ending[1]) {
				local deployedArray := []
				local pairs := []

				for i, endingEntry in ending {
					for j, variation in inputVariations {
						if i = j {
							pairs.Push(endingEntry, variation)
						}
					}
				}

				for i, pair in pairs {
					if Mod(i, 2) == 1 {
						local pairEnding := pairs[i]
						local pairVariation := pairs[i + 1]


						local refinedLibLink := RegExReplace(libLink, pairVariation ",?\s?", "")
						refinedLibLink := StrReplace(refinedLibLink, ", ]", "]")

						deployedArray.Push(refinedLibLink, pairEnding, (InStr(replaceWith, "[*]") ? StrReplace(replaceWith, "[*]", "_" pairVariation) : replaceWith))
					}
				}

				return this.GenerateSequences(deployedArray)
			} else {

				for variation in inputVariations {
					local var := variation != "" ? "_" variation : ""
					local ref := this.library[category][libChar var]
					local sequenceIn := ref is Array ? [ref[2], ref[1]] : [ref, ref]

					if !IsObject(replaceWith) {
						variationsReplace := (InStr(replaceWith, "[*]") ? StrReplace(replaceWith, "[*]", "_" variation) : replaceWith)
						local ref := this.library[category][variationsReplace]
						sequenceOut := ref is Array ? [ref[2], ref[1]] : [ref, ref]
					} else {
						sequenceOut := replaceWith
					}

					SetSequences(&sequenceIn, &ending, &sequenceOut, &escape)
				}
			}
		}

		SetSequences(&seqIn, &seqEnd, &seqOut, &escape) {
			if seqEnd.Length = 1
				seqEnd := [seqEnd[1], seqEnd[1]]

			output.Set(
				seqIn[1] seqEnd[1], seqOut[1] escape,
				seqIn[2] seqEnd[2], seqOut[2] escape,
				seqIn[1] "\" seqEnd[1], seqIn[1] seqEnd[1],
				seqIn[2] "\" seqEnd[2], seqIn[2] seqEnd[2],
				seqOut[1] "z", seqIn[1],
				seqOut[2] "Z", seqIn[2],
				seqOut[1] "\z", seqOut[1] "z",
				seqOut[2] "\Z", seqOut[2] "Z",
			)

			if !(seqEnd[1] ~= "i)z$") {
				output.Set(
					seqOut[1] seqEnd[1], seqIn[1] seqEnd[1] "[escape]",
					seqOut[2] seqEnd[2], seqIn[2] seqEnd[2] "[escape]",
				)
			}
		}

		return output
	}

	Init() {
		for scriptType, entries in this.library {
			for k, v in entries {
				if v is String {
					if RegExMatch(v, "\[(.*?)\]", &match) {
						local split := StrSplit(match[1], ",")
						local inter := []

						for each in split
							inter.Push(ChrLib.Get(RegExReplace(v, "\[(.*?)\]", each)))

						this.library[scriptType].Set(k, inter)
					} else {
						local inter := ChrLib.Get(v)
						this.library[scriptType].Set(k, inter)
					}
				}
			}
		}
		return
	}

	SetSequences() {
		local sequences := JSON.LoadFile(App.paths.data "\script_processor_sequences.json", "UTF-8")

		for script, groups in sequences {
			if script != this.mode
				continue

			for group, sequencesArray in groups {
				local handledSequences := this.GenerateSequences(sequencesArray)
				for k, v in handledSequences
					this.sequences[InStr(k, "\") ? "Escaped" : "Default"].Set(k, v)
			}
		}

		sequences := unset
		return
	}


	RegistryHotstrings(reloadHs) {
		Tooltip()

		InputScriptProcessor.options.interceptionInputMode := reloadHs
			? this.mode
			: (this.mode != InputScriptProcessor.options.interceptionInputMode ? this.mode : "")

		isEnabled := (InputScriptProcessor.options.interceptionInputMode != "" ? True : False)

		if this.mode != "" {
			this.InitHook()
		}

		!reloadHs && ShowInfoMessage(Locale.ReadInject("script_mode_" (isEnabled ? "" : "de") "activated", [Locale.Read("script_" this.tag)]), , , , True, True)
	}

	InH := InputHook("V")
	inputLogger := ""

	blockHandler := 1

	SequenceBridge(IPS, g, k, v) {
		this.backspaceLock := True
		this.blockHandler := g = "Escaped" ? 3 : 1

		Send(Util.StrRepeat("{Backspace}", StrLen(k)))

		if InStr(v, "[escape]")
			v := StrReplace(v, "[escape]")

		SendText(v)
		this.InH.Stop()
		this.inputLogger := this.LoggerDuplicates(v)
		this.InH.Start()
		this.backspaceLock := False
	}

	LoggerDuplicates(str) {
		if (str == "" || StrLen(str) <= 1)
			return str

		result := ""
		prevChar := SubStr(str, 1, 1)
		result .= prevChar

		Loop Parse, str
		{
			if (A_Index == 1)
				continue

			currentChar := A_LoopField

			if (currentChar != prevChar) {
				result .= currentChar
				prevChar := currentChar
			}
		}

		return result
	}

	SequenceHandler(IHObj, input := "", backspaceOn := False) {
		if this.blockHandler >= 2 {
			this.blockHandler--
			return
		} else {
			local inputCut := (str, len := 7) => StrLen(str) > len ? SubStr(str, StrLen(str) - (len - 1)) : str
			local forbiddenChars := "[`n`r`t\x{0000}-\x{0020},." (
				ChrLib.Get(
					(
						"\"
						"space,"
						"emsp,"
						"ensp,"
						"emsp13,"
						"emsp14,"
						"thinspace,"
						"emsp16,"
						"narrow_no_break_space,"
						"hairspace,"
						"punctuation_space,"
						"zero_width_space,"
						"zero_width_no_break_space,"
						"figure_space,"
						"no_break_space,"
						"medium_math_space,"
						"emquad,"
						"enquad,"
						"word_joiner,"
						"zero_width_joiner,"
						"zero_width_non_joiner"
						"/"
					)
				)
			) "]"

			if StrLen(input) > 0 && InputScriptProcessor.options.interceptionInputMode != "" {
				if !RegExMatch(input, forbiddenChars) {
					this.inputLogger .= input
					this.inputLogger := inputCut(this.inputLogger)

					for group in ["Escaped", "Default"] {
						for k, v in this.sequences.Get(group) {
							if this.inputLogger ~= RegExEscape(k) "$" {
								this.SequenceBridge(this, InStr(v, "[escape]") ? "Escaped" : group, k, v)
								break 2
							}
						}
					}

				} else {
					this.inputLogger := ""
				}

				suggestions := this.GetSuggestions(this.LoggerDuplicates(this.inputLogger))
				Util.CaretTooltip(this.LoggerDuplicates(this.inputLogger) (suggestions != "" ? "`n" globalInstances.crafter.FormatSuggestions(&suggestions) : ""))

			} else {
				this.InH.Stop()
				this.inputLogger := ""
				Tooltip()
			}
		}
		return
	}

	GetSuggestions(input) {
		suggestions := []
		output := ""

		if input != "" {
			for group in ["Default", "Escaped"] {
				for key, value in this.sequences.Get(group) {
					if key ~= "\\"
						continue

					suggestion := ""
					priority := 0

					if this.EntriesComparator(input, key, &a, &b, True) {
						suggestion := RegExReplace(b, "^" RegExEscape(a), "-") "(" StrReplace(value, "[escape]") ")"
						if (a == input)
							priority := 1000
						else
							priority := 500 + StrLen(a)
					} else if (RegExMatch(key, "^" RegExEscape(input))) {
						suggestion := RegExReplace(key, "^" RegExEscape(input), "-") "(" StrReplace(value, "[escape]") ")"
						priority := 100 + (1000 - StrLen(key))
					}

					if (suggestion != "") {
						suggestions.Push({
							text: suggestion,
							priority: priority,
							keyLength: StrLen(key),
							inputMatch: StrLen(a ?? input)
						})
					}
				}
			}

			suggestions := this.SortSuggestions(suggestions)

			for suggestion in suggestions {
				output .= suggestion.text ", "
			}
		}

		return output
	}

	SortSuggestions(suggestions) {
		if (suggestions.Length <= 1)
			return suggestions

		for i in this.SuggestionRange(2, suggestions.Length) {
			current := suggestions[i]
			j := i - 1

			while (j >= 1 && this.SuggestionShouldSwap(suggestions[j], current)) {
				suggestions[j + 1] := suggestions[j]
				j--
			}

			suggestions[j + 1] := current
		}

		return suggestions
	}

	SuggestionShouldSwap(a, b) {
		if (a.priority != b.priority)
			return a.priority < b.priority

		if (a.inputMatch != b.inputMatch)
			return a.inputMatch < b.inputMatch

		return a.keyLength > b.keyLength
	}

	SuggestionRange(start, end) {
		result := []
		Loop end - start + 1 {
			result.Push(start + A_Index - 1)
		}
		return result
	}

	EntriesComparator(a, entries, &foundKey := "", &foundValue := "", partial := False) {
		cutA := a
		found := False
		while !found && (StrLen(cutA) > 0) {
			if !IsObject(entries) {
				if partial && RegExMatch(entries, "^" RegExEscape(cutA)) || (cutA == entries) {
					foundKey := cutA
					foundValue := entries
					found := True
					break
				}
			} else {
				if entries.Has(cutA) {
					foundKey := cutA
					foundValue := entries.Get(cutA)
					found := True
					break
				}
			}
			cutA := SubStr(cutA, 2)
		}

		return found
	}

	backspaceLock := False
	Backspacer(ih, vk, sc) {
		local backspaceCode := LayoutList.GetKeyCodes("int", "Backspace")[1]
		local resetKeys := LayoutList.GetKeyCodes("int",
			"Left", "Right", "Up", "Down", "Home", "End", "PgUp", "PgDn",
			"RCtrl", "Space"
		)

		sc := Number(sc)

		isCtrlPressed := GetKeyState("LControl", "P") || GetKeyState("RControl", "P")

		if StrLen(this.inputLogger) > 0 && sc = backspaceCode && !this.backspaceLock {
			this.inputLogger := isCtrlPressed ? "" : SubStr(this.inputLogger, 1, -1)

			Util.CaretTooltip(this.inputLogger)
		} else if resetKeys.HasValue(sc) {
			this.inputLogger := ""
			Tooltip()
		}

		return
	}

	InitHook() {
		this.InH.Start()
		this.InH.NotifyNonText := True
		this.InH.KeyOpt("{Backspace}", "N")
		this.InH.OnChar := this.SequenceHandler.Bind(this)
		this.InH.OnKeyDown := ObjBindMethod(this, "Backspacer")

		return
	}
}

globalInstances.scriptProcessors := Map("Tieng Viet", InputScriptProcessor("Tieng Viet"), "HanYu PinYin", InputScriptProcessor("HanYu PinYin"))