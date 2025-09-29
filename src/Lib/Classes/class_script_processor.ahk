Class TelexScriptProcessor {

	static GetActiveMode() {
		return Scripter.GetCurrentMode("TELEX")
	}

	static TelexReturn(&input) {
		local output := input
		local sequences := JSON.LoadFile(App.paths.data "\telex_script_processor_sequences.json", "UTF-8")

		for key, value in sequences[Scripter.GetCurrentMode("TELEX")] {
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

	__New(mode := "Tieng Viet", customData?) {
		this.library := IsSet(customData) ? customData : JSON.LoadFile(App.paths.data "\telex_script_processor_library.json", "UTF-8")
		this.sequences := Map("Escaped", Map(), "Default", Map())
		this.tag := StrLower(StrReplace(mode, " ", "_"))
		this.mode := mode

		this.Init()
		this.SetSequences()

		this.library := unset
	}

	Start(reloadHs := False) {
		BindHandler.sendType := "Event"
		local previousMode := TelexScriptProcessor.GetActiveMode()
		if previousMode {
			globalInstances.scriptProcessors[previousMode].Stop()
			if previousMode = this.mode
				return
		}

		local currentAlternativeMode := Scripter.GetCurrentModeData("Alternative Modes", &alternativeModeName)

		if currentAlternativeMode {
			local nameTitle := Locale.Read("script_labels." currentAlternativeMode["locale"])
			local TSPTitle := Locale.Read("telex_script_processor.labels." this.tag)
			MsgBox(Locale.ReadInject("telex_script_processor.warnings.incompatible_with_alternative_modes", [TSPTitle, nameTitle]), App.Title(), "Icon!")
			return
		}

		this.RegistryHotstrings(reloadHs)
	}

	Stop() {
		this.InH.Stop()
		this.inputLogger := ""
		Tooltip()
		BindHandler.sendType := ""
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
		local sequences := JSON.LoadFile(App.paths.data "\telex_script_processor_sequences.json", "UTF-8")

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
		this.InitHook()
	}

	InH := InputHook("V")
	inputLogger := ""

	blockHandler := 1

	SequenceBridge(TSP, g, k, v) {
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
		if TooltipPresets.selected != "TELEX"
			TooltipPresets.Select("TELEX")

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

			if StrLen(input) > 0 && Scripter.selectedMode.Get("TELEX") != "" {
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
		local backspaceCode := 0x00E
		local resetKeys := [0x14B, 0x148, 0x14D, 0x150, 0x11D, 0x149, 0x151, 0x14F, 0x147, 0x039]
		; Left, Up, Right, Down, RCtrl, PgUp, PgDn, End, Home, Space,

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
		TooltipPresets.Select("TELEX")
		this.InH.Start()
		this.InH.NotifyNonText := True
		this.InH.KeyOpt("{Backspace}", "N")
		this.InH.OnChar := this.SequenceHandler.Bind(this)
		this.InH.OnKeyDown := ObjBindMethod(this, "Backspacer")

		return
	}
}

globalInstances.scriptProcessors := Map("Tieng Viet", TelexScriptProcessor("Tieng Viet"), "HanYu PinYin", TelexScriptProcessor("HanYu PinYin"))