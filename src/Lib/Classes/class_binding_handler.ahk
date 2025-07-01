Class BindHandler {
	static waitTimeSend := False

	static Send(combo := "", characterNames*) {
		if !initialized
			return
		Thread("Priority", 100)
		Keyboard.CheckLayout(&lang)

		if Language.Validate(lang, "bindings") {
			output := ""
			inputType := ""
			lineBreaks := False

			for _, character in characterNames {
				if character is Func {
					character(combo)
				} else if RegExMatch(character, "^RAW\:\:\{(.*?)\}$", &rawMatch) {
					inputType := "Text"
					output .= MyRecipes.FormatResult(rawMatch[1], True)
					if rawMatch[1] ~= "\\n" || output ~= "[`n`r]"
						lineBreaks := True
				} else {
					alt := !globalInstances.crafter.isComposeInstanceActive && !Scripter.isScripterWaiting ? Scripter.selectedMode.Get("Glyph Variations") : "None"
					inputMode := !globalInstances.crafter.isComposeInstanceActive && !Scripter.isScripterWaiting ? Auxiliary.inputMode : "Unicode"
					repeatCount := 1

					if RegExMatch(character, "×(\d+)$", &repeatMatch) {
						repeatCount := repeatMatch[1]
						character := RegExReplace(character, "×\d+$", "")
					}

					if RegExMatch(character, "\:\:(.*?)$", &alterationMatch) {
						alt := alterationMatch[1]
						character := RegExReplace(character, "\:\:.*$", "")
					}

					if ChrLib.entries.HasOwnProp(character) {
						output .= Util.StrRepeat(ChrLib.Get(character, True, inputMode, alt), repeatCount)

						chrSendOption := ChrLib.GetValue(character, "options")["send"]

						if StrLen(chrSendOption) > 0
							inputType := chrSendOption
					}
				}
			}

			keysValidation := "SC(14B|148|14D|150|04A)"
			chrValidation := "(\" Chr(0x00AE) "|\" Chr(0x2122) "|\" Chr(0x00A9) "|\" Chr(0x2022) "|\" Chr(0x25B6) "|\" Chr(0x25C0) "|\" Chr(0x0021) "|\" Chr(0x002B) "|\" Chr(0x005E) "|\" Chr(0x0023) "|\" Chr(0x007B) "|\" Chr(0x007D) "|\" Chr(0x0060) "|\" Chr(0x007E) "|\" Chr(0x0025) "|\" Chr(0x0009) "|\" Chr(0x000A) "|\" Chr(0x000D) ")"

			if StrLen(inputType) == 0
				inputType := (RegExMatch(combo, keysValidation) || RegExMatch(output, chrValidation) || Auxiliary.inputMode != "Unicode" || StrLen(output) > 10) ? "Text" : ""

			if StrLen(output) > 4 || lineBreaks
				ClipSend(output)
			else
				Send%inputType%(output)
		} else {
			this.SendDefault(combo)
		}
		Thread("Priority", 1)
	}

	static CapsSend(combo := "", charactersPair := [], reverse := False) {
		capsOn := reverse ? !GetKeyState("CapsLock", "T") : GetKeyState("CapsLock", "T")
		this.Send(combo, charactersPair.Length > 1 ? charactersPair[capsOn ? 1 : 2] : charactersPair[1])
	}

	static LangSend(combo := "", charactersMap := Map("en-US", "", "ru-RU", ""), reverse := Map("en-US", False "ru-RU", False)) {
		Keyboard.CheckLayout(&lang)

		if lang != "" && Language.supported[lang].parent != ""
			lang := Language.supported[lang].parent

		if !charactersMap.Has(lang)
			lang := "en-US"

		if Language.Validate(lang, "bindings") {
			if charactersMap.Has(lang) {
				if charactersMap[lang] is Array && charactersMap[lang].Length == 2 {
					this.CapsSend(combo, charactersMap[lang], reverse[lang])
				} else {
					this.Send(combo, charactersMap[lang] is Array ? charactersMap[lang][1] : charactersMap[lang])
				}
			}
		}
	}

	static LangCall(commandsMap := Map("en-US", "", "ru-RU", ""), additionalRules := []) {
		Keyboard.CheckLayout(&lang)

		if lang != "" && Language.supported[lang].parent != "" && !commandsMap.Has(lang)
			lang := Language.supported[lang].parent

		if !commandsMap.Has(lang)
			lang := "en-US"

		if additionalRules.Length > 0 {
			for rule in additionalRules {
				if (rule.if is Func && rule.if() || rule.if is Integer && rule.if == 1) && commandsMap.Has(rule.then) {
					commandsMap[rule.then]()
					return
				}
			}
		}

		if Language.Validate(lang, "bindings")
			if commandsMap.Has(lang)
				commandsMap[lang]()

		return
	}

	static SendPaste(SendKey, Callback := "") {
		Send(SendKey)

		if Callback != "" {
			Sleep 50
			Callback()
		}
	}

	static TimeShell(defaultAction := "", timeLimit := "0.005") {
		return (combo) => BindHandler.TimeSend(
			combo,
			Map(),
			defaultAction is Func ? defaultAction : (*) => BindHandler.Send(combo, defaultAction),
			timeLimit
		)
	}

	static TimeSend__HandleSecondKeys(secondKeysActions, combo := "") {
		output := Map()
		keys := []
		actions := []

		if RegExMatch(secondKeysActions[1], "\[(.*?)\]", &keysMatch)
			keys := StrSplit(keysMatch[1], ",")

		if RegExMatch(secondKeysActions[2], "\[(.*?)\]", &actionsMatch) {
			interActions := StrSplit(actionsMatch[1], ",")

			for each in interActions
				actions.Push(RegExReplace(secondKeysActions[2], "\[(.*?)\]", each))
		}


		for i, each in keys
			output.Set(each, BindHandler.Send.Bind(BindHandler, combo, actions[i]))


		return (output)
	}

	static TimeSend(combo := "", secondKeysActions := Map(), defaultAction := False, timeLimit := "0.1", alwaysUpper := False) {
		if this.waitTimeSend {
			this.SendDefault(combo)
			return
		}
		this.waitTimeSend := True

		if secondKeysActions is Array
			secondKeysActions := this.TimeSend__HandleSecondKeys(secondKeysActions, combo)


		Util.StrBind(combo, &keyRef, &modRef, &rulRef)
		layoutMap := KeyboardBinder.GetCurrentLayoutMap()
		keyRefScanCode := ""

		for scanCode, keyNamesArray in layoutMap {
			if keyNamesArray.HasValue(keyRef) {
				keyRefScanCode := scanCode
				break
			}
		}

		IH := InputHook("L1 M T" timeLimit)
		IH.VisibleNonText := False

		IH.KeyOpt("{All}", "E")
		IH.KeyOpt("{LShift}{RShift}{LControl}{RControl}{LAlt}{RAlt}", "-E")
		IH.KeyOpt("{A}{B}{C}{D}{E}{F}{G}{H}{I}{J}{K}{L}{M}{N}{O}{P}{Q}{R}{S}{T}{U}{V}{W}{X}{Y}{Z}", "-E")
		IH.Start()
		IH.Wait()

		input := IH.Input
		endKey := IH.EndKey

		keyPressed := StrLen(input) > 0 ? input : StrLen(endKey) > 0 ? endKey : ""

		if StrLen(keyPressed) = 1 && (alwaysUpper || GetKeyState("CapsLock", "T"))
			keyPressed := StrUpper(keyPressed)

		report .= "`n" keyPressed

		; ToolTip(combo report '`n' input '`n' endKey)

		if StrLen(keyPressed) > 0 &&
			secondKeysActions is Map &&
			secondKeysActions.Has(keyPressed) &&
			secondKeysActions[keyPressed] is Func {
			secondKeysActions[keyPressed]()
		} else {
			!defaultAction ? this.SendDefault(combo) : defaultAction()
		}

		this.waitTimeSend := False
	}

	static SendDefault(combo) {
		arrowKeys := RegExMatch(combo, "SC(14B|148|14D|150)")

		Util.StrBind(combo, &keyRef, &modRef, &rulRef)
		Send(
			arrowKeys ? "{" keyRef "}" :
			("{Blind}" modRef (StrLen(keyRef) > 1 ? "{" keyRef "}" : keyRef))
		)
	}
}