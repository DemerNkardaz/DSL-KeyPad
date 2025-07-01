	Class GREPTypography {
		static userSettings := {}
		static punctuation := "[\x{2E2E}\x{00A1}\x{00BF}\x{203C}\x{2049}\x{2047}\x{2048}\x{203D}\x{2E18}.,!?…”’»›“]"
		static dictionariesPaths := [App.paths.data "\grep_rule_sets.json"]
		static dictionaries := Map()

		static __New() {
			GREPTypographyReg(this.dictionariesPaths)
			return
		}

		static SetStyles(extraRules*) {
			Keyboard.CheckLayout(&lang)
			if !GREPTypography.dictionaries.Has(lang)
				return
			else {
				local clipboard := ClipboardAll()
				local text := ""
				A_Clipboard := ""

				Send("{Shift Down}{Delete}{Shift Up}")
				ClipWait(0.5, 1)
				text := A_Clipboard
				A_Clipboard := ""

				if text != "" {
					GREPTypography(&text, &extraRules, &lang)

					A_Clipboard := text
					ClipWait(0.5, 1)
					Send("{Shift Down}{Insert}{Shift Up}")
				}

				Sleep 500
				A_Clipboard := clipboard
			}
			return
		}

		__New(&str, &extraRules, &lang) {
			this.sources := [GREPTypography.dictionaries[lang]]
			for each in extraRules
				if GREPTypography.dictionaries.Has(lang "::" each)
					this.sources.Push(GREPTypography.dictionaries[lang "::" each])

			str := this.HandleString(str)
			return
		}

		HandleString(str) {
			local lines := StrSplit(str, "`n", "`r")
			for data in this.sources
				for setName, rules in data
					Loop rules.Length // 2 {
						local pattern := rules[A_Index * 2 - 1]
						local replace := rules[A_Index * 2]
						for i, line in lines
							lines[i] := RegExReplace(line, pattern, replace)
					}

			return lines.ToString("`n")
		}
	}