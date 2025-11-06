	Class GREPTypography {
		static userSettings := {}
		static punctuation := {
			leftSided: "\x{00A1}\x{00BF}\x{2E18}\x{2E2E}",
			rightSided: "\x{203C}\x{2049}\x{2047}\x{2048}\x{203D}.,!?…"
		}
		static dictionariesPaths := [App.PATHS.DATA "\grep_rule_sets.json"]
		static dictionaries := Map()

		static __New() {
			GREPTypographyReg(this.dictionariesPaths*)
			return
		}

		static Refresh() {
			GREPTypographyReg(this.dictionariesPaths*)
			return
		}

		static SetStyles(extraRules*) {
			Keyboard.CheckLayout(&lang)
			if !GREPTypography.dictionaries.Has(lang)
				return
			else {
				local text := ""
				Clip.CopySelected(&text, , "Backup")
				if text != ""
					GREPTypography(&text, &extraRules, &lang)
				Clip.Send(&text, , , "Release")
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
						for i, line in lines {
							lines[i] := RegExReplace(line, pattern, replace)
						}
					}

			return lines.ToString("`n")
		}
	}