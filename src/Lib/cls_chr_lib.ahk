Class ChrEntry {
	index := 0
	proxy := ""
	unicode := ""
	sequence := []
	result := []
	html := ""
	entity := ""
	altCode := ""
	altCodePages := []
	LaTeX := []
	LaTeXPackage := ""
	titles := Map()
	tags := []
	groups := []
	alterations := {}
	options := {
		noCalc: False,
		suggestionsAtEnd: False,
		secondName: False,
		useLetterLocale: False,
		layoutTitles: False,
		legend: "",
		altLayoutKey: "",
		altSpecialKey: "",
		fastKey: "",
		groupKey: [],
		groupKeyPreview: "",
		specialKey: "",
		numericValue: 0,
		send: "",
	}
	recipe := []
	recipeAlt := []
	symbol := {
		category: "",
		letter: "",
		afterLetter: "",
		beforeLetter: "",
		set: "",
		alt: "",
		customs: "",
		font: "",
	}
	data := { script: "", case: "", type: "", letter: "", postfixes: [] }
	variant := ""
	variantPos := 1

	__New(attributes := {}, name := "") {
		attributes := ChrEntry.Proxying(this, attributes)

		for key, value in attributes.OwnProps() {
			if value is Array {
				this.%key% := []
				this.%key% := value.Clone()
			} else if value is Object {
				for subKey, subValue in value.OwnProps() {
					this.%key%.%subKey% := subValue
				}
			} else {
				this.%key% := value
			}
		}

		if StrLen(this.proxy) > 0
			this.options.noCalc := True

		return this
	}

	static Proxying(root, attributes) {
		if attributes.HasOwnProp("proxy") && StrLen(attributes.proxy) > 0 {
			proxyName := attributes.proxy
			proxyEntry := ChrLib.GetEntry(proxyName)

			if !proxyEntry {
				return attributes
			}

			blacklist := ["groups", "options", "recipe", "recipeAlt", "symbol", "data", "titles", "tags"]

			for key, value in proxyEntry.OwnProps() {
				if blacklist.Has(key) && attributes.HasOwnProp(key) {
					continue
				}

				if value is Array {
					root.%key% := value.Clone()
				} else if value is Object {
					root.%key% := {}
					for subKey, subValue in value.OwnProps() {
						root.%key%.%subKey% := subValue
					}
				} else {
					root.%key% := value
				}
			}

			for key, value in attributes.OwnProps() {
				if value is Array {
					root.%key% := value.Clone()
				} else if value is Object && root.HasOwnProp(key) {
					for subKey, subValue in value.OwnProps() {
						root.%key%.%subKey% := subValue
					}
				} else {
					root.%key% := value
				}
			}

			return root
		}

		return attributes
	}
}

Class ChrLib {
	static entries := {}
	static entryGroups := Map()
	static entryCategories := Map()
	static entryRecipes := Map()
	static entryTags := Map()
	static duplicatesList := []
	static lastIndexAdded := -1
	static maxCountOfEntries := 0
	static progressBarCurrent := 0
	static progressBarAddition := 0

	static __New() {
		this.Registrate()
	}

	static Registrate() {
		LibRegistrate(this)
	}

	static progressBarGUI := Gui()
	static InitPorgressBar(typeOfInit := "Internal") {
		progressBarTitle := Locale.Read("lib_init")

		Constructor() {
			progressPanel := Gui()
			progressPanel.title := progressBarTitle

			windowWidth := 300
			windowHeight := 80
			xPos := (A_ScreenWidth - windowWidth) / 2
			yPos := (A_ScreenHeight - windowHeight) / 2

			prgBarW := windowWidth - 20
			prgBarH := 24
			prgBarY := (windowHeight - 32)
			prgBarX := (windowWidth - prgBarW) / 2

			progressPanel.AddProgress("vInitPogressBar Range0-" this.maxCountOfEntries " w" prgBarW " h" prgBarH " x" prgBarX " y" prgBarY, 0)


			progressPanel.AddText("vInitPorgressCounter w" prgBarW " h" 16 " x" prgBarX " y" (prgBarY - 40), Locale.ReadInject("lib_init_elems", [0, this.maxCountOfEntries]))
			progressPanel.AddText("vInitPorgressEntryName w" prgBarW " h" 16 " x" prgBarX " y" (prgBarY - 20), "")

			progressPanel.Show("w" windowWidth " h" windowHeight " x" xPos " y" yPos)
			return progressPanel
		}

		if IsGuiOpen(progressBarTitle) {
			WinActivate(progressBarTitle)
		} else {
			this.progressBarGUI := Constructor()
			this.progressBarGUI.Show("NoActivate")
		}
	}

	static AddEntry(entryName, entry, typeOfInit := "Internal") {
		if RegExMatch(entryName, "\[(.*?)\]", &match) {
			splitVariants := StrSplit(match[1], ",")
			entries := {}

			for i, variant in splitVariants {
				variantName := RegExReplace(entryName, "\[.*?\]", variant)
				entries.e%i%_%variantName% := entry.Clone()

				for item in ["unicode", "proxy", "alterations"] {
					if entry.%item% is Array
						entries.e%i%_%variantName%.%item% := (
							entry.%item%[i] is Object ? entry.%item%[i].Clone() : entry.%item%[i]
						)
				}

				entries.e%i%_%variantName% := this.SetDecomposedData(variantName, entries.e%i%_%variantName%)

				entries.e%i%_%variantName%.symbol := entry.symbol.Clone()
				entries.e%i%_%variantName%.symbol := this.CloneOptions(entry.symbol, i)

				this.ProcessReferences(entries.e%i%_%variantName%, entry, i)

				entries.e%i%_%variantName%.options := this.CloneOptions(entry.options, i)
				entries.e%i%_%variantName%.variant := variant
				entries.e%i%_%variantName%.variantPos := i

			}

			for entryName, entry in entries.OwnProps() {
				noIndexName := RegExReplace(entryName, "i)^e(\d+)_(.*?)", "$2")
				this.ProcessRecipe(entry, splitVariants)
				this.AddEntry(noIndexName, ChrEntry(entry, noIndexName))
			}

		} else {

			this.entries.%entryName% := {}
			entry := this.EntryPreProcessing(entryName, entry)

			this.TransferProperties(entryName, entry)

			this.entries.%entryName%.index := ++this.lastIndexAdded

			this.EntryPostProcessing(entryName, this.entries.%entryName%)


			progressName := StrLen(entryName) > 40 ? SubStr(entryName, 1, 40) "…" : entryName

			this.progressBarCurrent++
			this.progressBarGUI["InitPorgressCounter"].Text := Locale.ReadInject("lib_init_elems", [this.progressBarCurrent, this.maxCountOfEntries]) (typeOfInit = "Custom" ? " : " Locale.Read("lib_init_custom") : " : " Locale.Read("lib_init_internal_lib"))
			this.progressBarGUI["InitPorgressEntryName"].Text := Locale.ReadInject("lib_init_entry", [progressName])

			if this.maxCountOfEntries > 0 {
				this.progressBarGUI["InitPogressBar"].Value++
				this.progressBarGUI.Show("NoActivate")
			}
		}
	}

	static AddEntries(rawEntries, typeOfInit := "Internal") {
		if Keyboard.blockedForReload
			return
		if rawEntries is Array && rawEntries.Length >= 2 {

			Loop rawEntries.Length // 2 {
				index := A_Index * 2 - 1
				entryName := rawEntries[index]

				if RegExMatch(entryName, "\[(.*?)\]", &match) {
					splitVariants := StrSplit(match[1], ",")
					this.maxCountOfEntries += splitVariants.Length
				} else {
					this.maxCountOfEntries++
				}
			}

			this.InitPorgressBar(typeOfInit)

			Loop rawEntries.Length // 2 {
				index := A_Index * 2 - 1
				entryName := rawEntries[index]
				entryValue := rawEntries[index + 1]
				this.AddEntry(entryName, ChrEntry(entryValue, entryName), typeOfInit)
			}

			Sleep 1000
			this.progressBarGUI.Hide()
			this.progressBarGUI["InitPogressBar"].Value := 0
			this.progressBarAddition := 0
			this.maxCountOfEntries := 0
			this.progressBarCurrent := 0
		}
		return
	}

	static RemoveEntry(entryName) {
		if this.entries.HasOwnProp(entryName) {
			entry := this.GetEntry(entryName)

			scenarios := Map(
				"groups", { source: entry.groups, target: this.entryGroups },
				"tags", { source: entry.tags, target: this.entryTags }
			)

			for scenarioName, scenario in scenarios {
				for item in scenario.source {
					if scenario.target.Has(item) && scenario.target.Get(item).HasValue(entryName) {
						intermediateArray := scenario.target.Get(item)
						intermediateArray.RemoveValue(entryName)

						scenario.target.Delete(item)
						scenario.target.Set(item, intermediateArray)
					}
				}
			}

			this.entries.DeleteProp(entryName)
		}
	}

	static GetEntry(entryName) {
		if this.entries.HasOwnProp(entryName) {
			return this.entries.%entryName%
		} else {
			return False
		}
	}

	static GetValue(entryName, value, useRef := False, &output?) {
		if useRef {
			if this.entries.%entryName%.HasOwnProp(value) {
				output := this.entries.%entryName%.%value%
				return True
			} else {
				return False
			}
		} else {
			return this.entries.%entryName%.%value%
		}
	}

	static Print() {
		lang := Language.Get()
		printPath := App.paths.user "\printed_pairs.html"
		tableRows := ""

		if FileExist(printPath)
			FileDelete(printPath)

		i := 0
		for entryName, entry in this.entries.OwnProps() {
			i++
			characterContent := (entry.symbol.category = "Diacritic Mark" ? DottedCircle : "") (entry.result.Length = 1 ? (
				Util.StrToHTML(entry.result[1])) : Util.UnicodeToChar(entry.sequence.Length > 0 ? entry.sequence : entry.unicode))

			characterAlts := ""

			maxJ := ObjOwnPropCount(entry.alterations)
			if maxJ > 0 {
				j := 0
				for key, value in entry.alterations.OwnProps() {
					j++
					if !InStr(key, "HTML") {
						characterAlts .= (j = 1 ? "`n" : "") '<span class="small-text">' key ':</span> ' DottedCircle Util.UnicodeToChar(value) (j < maxJ ? "`n" : "")
					}
				}
			}

			tableRows .= (
				'				<tr>`n'
				'					<td class="index">' i '</td>`n'
				'					<td' (StrLen(characterContent) > 15 * (InStr(characterContent, "&") ? 8 : 1) ? ' class="small-text"' : entry.symbol.category = "Spaces" ? ' class="spaces"' : '') '>' characterContent characterAlts '</td>`n'
				'					<td>' entryName '</td>`n'
				'				</tr>`n'
			)
		}

		html := (
			'<!DOCTYPE html>`n'
			'<html lang="en">`n'
			'	<head>`n'
			'		<meta charset="UTF-8">`n'
			'		<title>Printed Pairs</title>`n'
			'		<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin="use-credentials">`n'
			'		<link rel="preconnect" href="https://fonts.gstatic.com">`n'
			'		<link href="https://fonts.googleapis.com/css2?family=Noto+Color+Emoji&family=Noto+Sans+Carian&family=Noto+Sans+Glagolitic&family=Noto+Sans+Lycian&family=Noto+Sans+Mandaic&family=Noto+Sans+Nabataean&family=Noto+Sans+Old+North+Arabian&family=Noto+Sans+Old+South+Arabian&family=Noto+Sans+Old+Turkic&family=Noto+Sans+Runic&family=Noto+Sans+Symbols:wght@100..900&family=Noto+Sans+Tifinagh&family=Noto+Sans+Ugaritic&family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">`n'
			'		<style>`n'
			'			body {`n'
			'				font-family: "Noto Sans", "Noto Color Emoji", "Noto Sans Carian", "Noto Sans Glagolitic", "Noto Sans Old Turkic", "Noto Sans Lycian", "Noto Sans Mandaic", "Noto Sans Nabataean", "Noto Sans Old North Arabian", "Noto Sans Old South Arabian", "Noto Sans Runic", "Noto Sans Symbols", "Noto Sans Tifinagh", "Noto Sans Ugaritic", sans-serif;`n'
			'				margin: 0;`n'
			'				padding: 0;`n'
			'				font-size: 12pt;`n'
			'				width: 100%;`n'
			'				display: flex;`n'
			'				justify-content: center;`n'
			'				align-items: center;`n'
			'			}`n'
			'			div {`n'
			'				width: 1024px;`n'
			'				display: flex;`n'
			'				justify-content: center;`n'
			'				align-items: center;`n'
			'				margin: 20px auto;`n'
			'			}`n'
			'			table {`n'
			'				width: 100%;`n'
			'				border-collapse: separate;`n'
			'				border-spacing: 5px;`n'
			'			}`n'
			'			th, td {`n'
			'				border: 1px solid #e0e0e0;`n'
			'				padding: 5px 20px;`n'
			'				word-wrap: break-word;`n'
			'				overflow-wrap: break-word;`n'
			'				white-space: pre-wrap;`n'
			'				hyphens: auto;`n'
			'				border-radius: 8px;`n'
			'			}`n'
			'			td.index {`n'
			'				text-align: center;`n'
			'			}`n'
			'			tr > td:nth-child(3) {`n'
			'				width: 40%;`n'
			'			}`n'
			'			tr > td:nth-child(2):not(.small-text) {`n'
			'				font-size: 1.5em;`n'
			'			}`n'
			'			.small-text {`n'
			'				font-size: 0.8em;`n'
			'			}`n'
			'			.spaces {`n'
			'				text-decoration: underline;`n'
			'				&::after, &::before {`n'
			'					content: ".";`n'
			'					display: inline-block;`n'
			'					text-decoration: none;`n'
			'					margin: 0 0.2em;`n'
			'				}`n'
			'			}`n'
			'		</style>`n'
			'	</head>`n'
			'	<body>`n'
			'		<div>`n'
			'			<table>`n'
			'				<tr>`n'
			'					<th>' (lang = "en" ? "#" : "№") '</th>`n'
			'					<th>' (lang = "en" ? "Symbol" : "Символ") '</th>`n'
			'					<th>' (lang = "en" ? "Entry" : "Запись") '</th>`n'
			'				</tr>`n'
			tableRows
			'			</table>`n'
			'		</div>`n'
			'	</body>`n'
			'</html>'
		)
		FileAppend(html, printPath, "UTF-8")
		Run(printPath)
	}

	static Get(entryName, extraRules := False, getMode := "Unicode", alt := AlterationActiveName) {
		if StrLen(alt) == 0
			alt := AlterationActiveName

		entry := this.GetEntry(entryName)

		getMode := StrLen(getMode) ? getMode : "Unicode"

		if (getMode = "HTML" && StrLen(entry.html) > 0) {
			if (extraRules && StrLen(alt) > 0 && entry.alterations.HasOwnProp(alt)) {
				return entry.alterations.%alt%HTML
			}
			return StrLen(entry.entity) > 0 ? entry.entity : entry.html

		} else if (getMode = "LaTeX" && entry.LaTeX.Length > 0) {
			return (entry.LaTeX.Length = 2 && Cfg.Get("LaTeX_Mode") = "Math")
				? entry.LaTeX[2]
			: entry.LaTeX[1]

		} else {
			if (extraRules && StrLen(alt) > 0 && entry.alterations.HasOwnProp(alt)) {
				return Util.UnicodeToChar(entry.alterations.%alt%)

			} else if (extraRules && getMode != "Unicode" && entry.alterations.HasOwnProp(getMode)) {
				return Util.UnicodeToChar(entry.alterations.%getMode%)

			} else {
				try {
					return entry.result.Length = 1 ? entry.result[1] : Util.UnicodeToChar(entry.sequence.Length > 0 ? entry.sequence : entry.unicode)
				} catch {
					MsgBox(Locale.Read("error_critical") "`n`n" Locale.ReadInject("error_entry_not_found", [entryName]), App.Title(), "Iconx")
					return
				}
			}
		}
	}

	static Gets(entryNames*) {
		output := ""
		indexMap := Map()

		charIndex := 0
		for i, character in entryNames {
			charIndex++
			repeatCount := 1
			characterMatch := character

			if RegExMatch(characterMatch, "(.+?)\[(\d+(?:,\d+)*)\]$", &match) {
				if RegExMatch(match[1], "(.+?)×(\d+)$", &subMatch) {
					character := subMatch[1]
					repeatCount := subMatch[2]
				} else {
					character := match[1]
				}
				Positions := StrSplit(match[2], ",")
				for _, Position in Positions {
					Position := Number(Position)
					if !IndexMap.Has(Position) {
						IndexMap[Position] := []
					}
					IndexMap[Position].Push([character, repeatCount])
				}
				continue
			} else if RegExMatch(characterMatch, "(.+?)×(\d+)$", &match) {
				character := match[1]
				repeatCount := match[2]
				continue
			}

			if !IndexMap.Has(charIndex) {
				IndexMap[charIndex] := []
			}
			IndexMap[charIndex].Push([character, repeatCount])
		}

		for indexEntry, value in indexMap {
			for _, charData in value {
				setSequence(charData[1], charData[2])
			}
		}

		setSequence(entryName, repeatCount) {
			Loop repeatCount {
				output .= ChrLib.Get(entryName)
			}
		}

		return output
	}

	static GeneratePermutations(items) {
		if items.Length = 1 {
			return [items[1]]
		}

		permutations := []
		for i, item in items {
			remaining := items.Clone()
			remaining.RemoveAt(i)
			subPermutations := this.GeneratePermutations(remaining)
			for subPerm in subPermutations {
				permutations.Push(item subPerm)
			}
		}

		return permutations
	}

	static Count(groupRestrict?) {
		count := 0
		for entry, value in this.entries.OwnProps() {
			if !IsSet(groupRestrict) || (IsSet(groupRestrict) && value.groups.HasValue(groupRestrict)) {
				if !(value.options.noCalc) {
					count++
				}

				for alteration, value in value.alterations.OwnProps() {
					if !InStr(alteration, "HTML") {
						count++
					}
				}

			}
		}

		return count
	}

	static SearchPrompt() {
		searchQuery := Cfg.Get("Search", "LatestPrompts", "")
		resultObj := { result: "", prompt: "", failed: [], send: (*) => "" }
		IB := InputBox(Locale.Read("symbol_search_prompt"), Locale.Read("symbol_search"), "w350 h110", searchQuery)
		if IB.Result = "Cancel" || IB.Value = "" || IB.Value ~= "^\s*$"
			return resultObj
		else
			searchQuery := IB.Value

		if searchQuery == "\" {
			Reload
			return resultObj
		}

		if RegExMatch(searchQuery, "^\/(.*?)$", &match) {
			funcRef := StrSplit(match[1], ".")
			if funcRef.Length = 1 {
				%funcRef[1]%()
			} else if funcRef.Length > 1 {
				interRef := ""
				objRef := ""

				for i, ref in funcRef {
					if i = 1 {
						interRef := %ref%
						objRef := interRef
					} else if i < funcRef.Length {
						interRef := interRef.%ref%
						objRef := interRef
					} else {
						method := ref
						interRef := interRef.%method%
						interRef.Call(objRef)
					}
				}
			}
			return resultObj
		} else {

			if InStr(searchQuery, ",") {
				tagSplit := StrSplit(searchQuery, ",")
				for tag in tagSplit {
					interResult := this.Search(Trim(tag))
					if StrLen(interResult) = 0
						resultObj.failed.Push(tag)
					resultObj.result .= interResult
				}
			} else {
				interResult := this.Search(searchQuery)
				if StrLen(interResult) = 0
					resultObj.failed.Push(searchQuery)
				resultObj.result := interResult
			}

			resultObj.prompt := searchQuery
			lineBreaks := resultObj.result ~= "`n" || resultObj.result ~= "`r"
			resultObj.send := (*) => (StrLen(resultObj.result) > 20 || lineBreaks) ? ClipSend(resultObj.result) : SendText(resultObj.result)

			if StrLen(resultObj.result) > 0 {
				Cfg.Set(searchQuery, "Search", "LatestPrompts")
			} else {
				if resultObj.failed.Length > 0
					MsgBox(Locale.ReadInject("warning_tag_absent", [resultObj.failed.ToString()]), App.Title(), "Icon!")
			}

			return resultObj
		}
	}

	static ValidateAlt(str) {
		static alterationNames := Map(
			"modifier", ["superscript", "верхний индекс", "ви", "mo", "sup"],
			"subscript", ["нижний индекс", "ни", "sub"],
			"italic", ["курсив", "ку", "it"],
			"italicBold", ["курсив полужирный", "куп", "itb"],
			"bold", ["полужирный", "п", "b"],
			"fraktur", ["фрактур", "ф", "f"],
			"frakturBold", ["полужирный фрактур", "пф", "fb"],
			"script", ["рукописный", "р", "s"],
			"scriptBold", ["полужирный рукописный", "пр", "sb"],
			"doubleStruck", ["ds"],
			"sansSerif", ["без засечек", "бз", "ss"],
			"sansSerifItalic", ["курсив без засечек", "кубз", "ssit"],
			"sansSerifItalicBold", ["курсив полужирный без засечек", "купбз", "ssitb"],
			"sansSerifBold", ["полужирный без засечек", "пбз", "ssb"],
			"monospace", ["моноширинный", "м", "m"],
			"smallCapital", ["капитель", "к", "sc"],
			"small", ["маленький", "мал", "sm"],
			"combining", ["комбинируемый", "ко", "c"],
			"uncombined", ["некомбинируемый", "неко", "uc"],
		)

		for key, value in alterationNames {
			for name in value {
				if name = str || key = str {
					return key
				}
			}
		}

		return str
	}

	static Search(searchQuery) {
		isSensitive := SubStr(searchQuery, 1, 1) = "!"
		if isSensitive
			searchQuery := SubStr(searchQuery, 2)

		alteration := RegExMatch(searchQuery, "\:\:(.*?)$", &match) ? this.ValidateAlt(match[1]) : AlterationActiveName

		searchQuery := RegExReplace(searchQuery, "\:\:(.*?)$", "")

		if this.entries.HasOwnProp(searchQuery) {
			return this.Get(searchQuery, True, Auxiliary.inputMode, alteration)
		}

		isHasExpression := RegExMatch(searchQuery, "(\^|\*|\+|\?|\.|\$|^\i\))")

		checkTagByUserRegEx(tag) {
			return RegExMatch(tag, searchQuery)
		}

		checkTagExact(tag) {
			if isSensitive
				return searchQuery == tag
			return StrLower(searchQuery) = StrLower(tag)
		}

		checkTagPartial(tag) {
			if isSensitive
				return RegExMatch(tag, searchQuery)
			return RegExMatch(StrLower(tag), StrLower(searchQuery))
		}

		checkTagLowAcc(tag) {
			if isSensitive
				return Util.HasAllCharacters(tag, searchQuery)
			return Util.HasAllCharacters(StrLower(tag), StrLower(searchQuery))
		}

		if isHasExpression {
			for entryName, entry in this.entries.OwnProps() {
				if entry.tags.Length = 0
					continue

				for _, tag in entry.tags {
					if checkTagByUserRegEx(tag)
						return this.Get(entryName, True, Auxiliary.inputMode, alteration)
				}
			}
		}

		for entryName, entry in this.entries.OwnProps() {
			if entry.tags.Length = 0
				continue

			for _, tag in entry.tags {
				if checkTagExact(tag)
					return this.Get(entryName, True, Auxiliary.inputMode)
			}
		}

		for entryName, entry in this.entries.OwnProps() {
			if entry.tags.Length = 0
				continue

			for _, tag in entry.tags {
				if checkTagPartial(tag)
					return this.Get(entryName, True, Auxiliary.inputMode, alteration)
			}
		}

		for entryName, entry in this.entries.OwnProps() {
			if entry.tags.Length = 0
				continue

			for _, tag in entry.tags {
				if checkTagLowAcc(tag)
					return this.Get(entryName, True, Auxiliary.inputMode, alteration)
			}
		}

		return ""
	}

	static ProcessReferences(targetEntry, sourceEntry, index) {
		for reference in ["recipe", "tags", "groups"] {
			if sourceEntry.%reference%.Length > 0 && sourceEntry.%reference%[sourceEntry.%reference%.Length] is Array {
				if sourceEntry.%reference%[index].Length > 0 {
					targetEntry.%reference% := sourceEntry.%reference%[index].Clone()
					try {
						if sourceEntry.%reference%Prefixes.Length > 0 {
							for i, prefix in sourceEntry.%reference%Prefixes {
								targetEntry.%reference%[i] := prefix targetEntry.%reference%[i]
							}
						}
						targetEntry.DeleteProp(reference "Prefixes")
					}
				} else {
					targetEntry.DeleteProp(reference)
				}
			}
		}
	}

	static ProcessSymbolLetter(targetEntry) {
		if targetEntry.symbol.letter is String {
			targetEntry.symbol.letter := RegExReplace(targetEntry.symbol.letter, "\%self\%", Util.UnicodeToChar(targetEntry.unicode))
			if InStr(targetEntry.symbol.letter, "${") {
				while RegExMatch(targetEntry.symbol.letter, "\[(.*?)\]", &varMatch) {
					splittedVariants := StrSplit(varMatch[1], ",")
					targetEntry.symbol.letter := RegExReplace(targetEntry.symbol.letter, "\[.*?\]", splittedVariants[targetEntry.variantPos], , 1)
				}

				targetEntry.symbol.letter := ChrRecipeHandler.MakeStr(targetEntry.symbol.letter)
			} else if targetEntry.data.script = "cyrillic" &&
				RegExMatch(targetEntry.data.letter, "^[a-zA-Z0-9]+$") {
				targetEntry.symbol.letter := Util.UnicodeToChar(targetEntry.unicode)
			}
		}
	}

	static CloneOptions(sourceOptions, index) {
		tempOptions := sourceOptions.Clone()
		for key, value in sourceOptions.OwnProps() {
			if sourceOptions.%key% is Array && key != "groupKey" && sourceOptions.%key%.Length > 0 {
				tempOptions.%key% := sourceOptions.%key%[index]
			}
		}
		return tempOptions
	}

	static ProcessRecipe(entry, splitVariants) {
		if entry.recipe.Length = 0 {
			if entry.data.postfixes.Length > 0 {
				if entry.data.postfixes.Length = 1 {
					if ["ligature", "digraph"].HasValue(entry.data.type) {
						entry.recipe := ["$${" entry.data.postfixes[1] "}", "${" SubStr(entry.data.script, 1, 3) "_[" splitVariants.ToString(",") "]_" SubStr(entry.data.type, 1, 3) "_@}${" entry.data.postfixes[1] "}"]
					} else {
						entry.recipe := ["$${" entry.data.postfixes[1] "}"]
					}
				} else {
					entry.recipe := [
						"$${(" entry.data.postfixes[1] "|" entry.data.postfixes[2] ")}$(*)",
						"${" SubStr(entry.data.script, 1, 3) "_[" splitVariants.ToString(",") "]_"
						SubStr(entry.data.type, 1, 3) "_@__(" entry.data.postfixes[1] "|"
						entry.data.postfixes[2] ")}$(*)"
					]
				}
			} else if ["ligature", "digraph"].HasValue(entry.data.type) && entry.data.postfixes.Length = 0 {
				entry.recipe := ["$"]
			}
		}

		if entry.recipe.Length > 0 {
			tempRecipe := entry.recipe.Clone()
			for i, recipe in tempRecipe {
				tempRecipe[i] := RegExReplace(recipe, "\[.*?\]", SubStr(entry.data.case, 1, 1))
				tempRecipe[i] := RegExReplace(tempRecipe[i], "@", entry.data.letter)
				if RegExMatch(tempRecipe[i], "\/(.*?)\/", &match) {
					tempRecipe[i] := RegExReplace(tempRecipe[i], "\/(.*?)\/", entry.data.case = "capital" ? Util.StrUpper(match[1], 1) : Util.StrLower(match[1], 1))
				}
				if RegExMatch(tempRecipe[i], "\\(.*?)\\", &match) {
					tempRecipe[i] := RegExReplace(tempRecipe[i], "\\(.*?)\\", entry.data.case = "capital" ? StrUpper(match[1]) : StrLower(match[1]))
				}
			}
			entry.recipe := tempRecipe
		}
	}

	static TransferProperties(entryName, entry) {
		for key, value in entry.OwnProps() {
			if !["String", "Integer", "Boolean"].HasValue(Type(value)) {
				if ["recipe", "result"].HasValue(key) && value.Length > 0
					this.TransferRecipeProperty(entryName, key, value)
				else
					this.Transfer%Type(value)%Property(entryName, key, value)
			} else {
				this.entries.%entryName%.%key% := value
			}
		}
	}

	static TransferFuncProperty(entryName, key, value) {
		definedValue := value
		this.entries.%entryName%.DefineProp(key, {
			Get: (*) => definedValue(),
			Set: (this, value) => this.DefineProp(key, { Get: (*) => value })
		})
	}

	static TransferRecipeProperty(entryName, key, value) {
		tempRecipe := value.Clone()
		definedRecipe := (*) => ChrRecipeHandler.Make(tempRecipe)
		interObj := {}
		interObj.DefineProp("Get", { Get: definedRecipe, Set: definedRecipe })
		this.entries.%entryName%.%key% := interObj.Get
	}

	static TransferArrayProperty(entryName, key, value) {
		this.entries.%entryName%.%key% := []
		for subValue in value {
			if subValue is Func {
				interObj := {}
				interObj.DefineProp("Get", { Get: subValue, Set: subValue })
				if interObj.Get is Array {
					for interValue in interObj.Get {
						this.entries.%entryName%.%key%.Push(interValue)
					}
				} else {
					this.entries.%entryName%.%key%.Push(interObj.Get)
				}
			} else {
				this.entries.%entryName%.%key%.Push(subValue)
			}
		}
	}

	static TransferMapProperty(entryName, key, value) {
		this.entries.%entryName%.%key% := Map()
		for mapKey, mapValue in value {
			if mapValue is Func {
				interObj := {}
				interObj.DefineProp("Get", { Get: mapValue, Set: mapValue })
				this.entries.%entryName%.%key%.Set(mapKey, interObj.Get)
			} else {
				this.entries.%entryName%.%key%.Set(mapKey, mapValue)
			}
		}
	}

	static TransferObjectProperty(entryName, key, value) {
		this.entries.%entryName%.%key% := {}
		for subKey, subValue in value.OwnProps() {
			if subValue is Func {
				this.entries.%entryName%.%key%.DefineProp(subKey, {
					Get: subValue,
					Set: subValue
				})
			} else {
				this.entries.%entryName%.%key%.%subKey% := subValue
			}
		}
	}

	static EntryPreProcessing(entryName, entry) {
		refinedEntry := entry.Clone()
		refinedEntry := this.SetDecomposedData(entryName, refinedEntry)

		if StrLen(refinedEntry.data.script) > 0 && StrLen(refinedEntry.data.type) > 0 {
			if refinedEntry.groups.Length = 0 {
				hasPostfix := refinedEntry.data.postfixes.Length > 0
				if ["hellenic", "latin", "cyrillic"].HasValue(refinedEntry.data.script) {
					refinedEntry.groups :=
						(StrLen(refinedEntry.data.type) > 0 && ["digraph", "ligature", "numeral"].HasValue(refinedEntry.data.type) ?
							[StrTitle(refinedEntry.data.script " " refinedEntry.data.type "s")] :
							[StrTitle(refinedEntry.data.script (hasPostfix ? " Accented" : ""))]
						)
				}

				if refinedEntry.data.script = "hellenic" {
					refinedEntry.options.useLetterLocale := True
				}
			}

			if StrLen(refinedEntry.symbol.category = 0) {
				if StrLen(refinedEntry.data.script) && StrLen(refinedEntry.data.type) {

					hasPostfix := refinedEntry.data.postfixes.Length > 0
					refinedEntry.symbol.category := StrTitle(refinedEntry.data.script " " refinedEntry.data.type (hasPostfix ? " Accented" : ""))
				} else {
					refinedEntry.symbol.category := "N/A"
				}
			}
		}

		if StrLen(refinedEntry.options.fastKey) && RegExMatch(refinedEntry.options.fastKey, "\?(.*?)$", &addGroupMatch) {
			refinedEntry.groups.Push(refinedEntry.groups[1] " " addGroupMatch[1])
		}

		if refinedEntry.recipe.Length = 0 && refinedEntry.data.postfixes.Length > 0 {
			refinedEntry.recipe := ["$"]
			for postfix in refinedEntry.data.postfixes {
				refinedEntry.recipe[1] .= "${" postfix "}"
			}
		}


		this.ProcessSymbolLetter(refinedEntry)

		return refinedEntry
	}

	static EntryPostProcessing(entryName, entry) {
		refinedEntry := entry.Clone()

		if refinedEntry.result.Length > 0 {
			; refinedEntry.sequence := MyRecipes.HandleResult(refinedEntry.result.Clone())
			refinedEntry.unicode := Util.ChrToUnicode(SubStr(refinedEntry.result[1], 1, 1))
		}


		character := Util.UnicodeToChar(refinedEntry.unicode)
		characterSequence := Util.UnicodeToChar(refinedEntry.sequence.Length > 0 ? refinedEntry.sequence : refinedEntry.unicode)


		if refinedEntry.sequence.Length > 0 {
			for sequenceChr in refinedEntry.sequence {
				if StrLen(refinedEntry.html)
					refinedEntry.html := ""
				refinedEntry.html .= "&#" Util.ChrToDecimal(Util.UnicodeToChar(sequenceChr)) ";"

			}
		} else {
			refinedEntry.html := "&#" Util.ChrToDecimal(character) ";"
		}

		for alteration, value in refinedEntry.alterations.OwnProps() {
			if !InStr(alteration, "HTML")
				refinedEntry.alterations.%alteration%HTML := "&#" Util.ChrToDecimal(Util.UnicodeToChar(value)) ";"
		}

		if refinedEntry.altCode = "" {
			pages := [437, 850, 866, 1251, 1252]
			codePrefix := Map(1251, "0", 1252, "0")
			altOutput := []

			for i, page in pages {
				code := CharacterInserter.GetAltcode(character, page)

				if code is Number && code <= 255 && code >= 0 && !altOutput.HasValue(code) {
					altOutput.Push((codePrefix.Has(page) ? codePrefix[page] : "") code)
					refinedEntry.altCodePages.Push(page)
				} else if altOutput.HasValue(code) {
					refinedEntry.altCodePages.Push(page)
				}
			}

			refinedEntry.altCode := altOutput.ToString()
		}

		if refinedEntry.sequence.Length > 1 {
			for sequenceChr in refinedEntry.sequence {
				refinedEntry.entity .= Util.StrToHTML(Util.UnicodeToChar(sequenceChr), "Entities")
			}
		} else {
			for i, entitySymbol in EntitiesLibrary {
				if Mod(i, 2) = 1 {
					entityCode := EntitiesLibrary[i + 1]

					if character == entitySymbol {
						refinedEntry.entity := entityCode
						break
					}
				}
			}
		}

		refinedEntry.symbol.set := characterSequence

		if refinedEntry.groups.Length = 0
			refinedEntry.groups := ["Default Group"]


		for group in ["fastKey", "specialKey", "altLayoutKey"] {
			if refinedEntry.options.HasOwnProp(group) {
				refinedEntry.options.%group% := Util.ReplaceModifierKeys(refinedEntry.options.%group%)
			} else {
				refinedEntry.options.%group% := ""
			}
		}

		hasSet := StrLen(refinedEntry.symbol.set) > 0
		hasCustoms := StrLen(refinedEntry.symbol.customs) > 0
		hasFont := StrLen(refinedEntry.symbol.font) > 0

		if StrLen(refinedEntry.symbol.category) > 0 {
			category := refinedEntry.symbol.category

			refinedEntry.symbol.set := (category = "Diacritic Mark" ? Chr(0x25CC) characterSequence : characterSequence)
			if category = "Diacritic Mark" {
				if !hasCustoms
					refinedEntry.symbol.customs := "s72"
				if !hasFont
					refinedEntry.symbol.font := "Cambria"
			} else if category = "Spaces" && !hasCustoms {
				refinedEntry.symbol.customs := "underline"
			}
		} else {
			refinedEntry.symbol.category := "N/A"
			if !hasSet
				refinedEntry.symbol.set := characterSequence
		}

		if RegExMatch(entryName, "i)^(permic|hungarian|north_arabian|south_arabian)", &match) {
			scriptName := StrReplace(match[1], "_", " ")
			refinedEntry.symbol.font := "Noto Sans Old " scriptName
		} else if RegExMatch(entryName, "i)^(ugaritic)", &match) {
			scriptName := StrReplace(match[1], "_", " ")
			refinedEntry.symbol.font := "Noto Sans " scriptName
		} else if RegExMatch(entryName, "i)^(alchemical|astrological|astronomical|symbolistics|ugaritic)") {
			refinedEntry.symbol.font := "Kurinto Sans"
		} else if InStr(entryName, "phoenician") {
			refinedEntry.symbol.font := "Segoe UI Historic"
		}

		for group in refinedEntry.groups {
			if !this.entryGroups.Has(group)
				this.entryGroups.Set(group, [])

			if !this.entryGroups.Get(group).HasValue(entryName)
				this.entryGroups[group].Push(entryName)
		}

		if !this.entryCategories.Has(refinedEntry.symbol.category)
			this.entryCategories.Set(refinedEntry.symbol.category, [])

		if !this.entryCategories.Get(refinedEntry.symbol.category).HasValue(entryName)
			this.entryCategories[refinedEntry.symbol.category].Push(entryName)

		if refinedEntry.tags.Length > 0 {
			for tag in refinedEntry.tags {
				if !this.entryTags.Has(tag)
					this.entryTags.Set(tag, [])

				this.entryTags[tag].Push(entryName)
			}
		}

		dataLetter := StrLen(refinedEntry.symbol.letter) > 0 ? refinedEntry.symbol.letter : refinedEntry.data.letter
		dataPack := entry.data
		dataPack.dataLetter := dataLetter

		if StrLen(refinedEntry.data.letter) > 0 {
			if refinedEntry.recipe.Length > 0 {
				for i, recipe in refinedEntry.recipe {
					refinedEntry.recipe[i] := RegExReplace(recipe, "\~", SubStr(refinedEntry.data.letter, 1, 1))
					refinedEntry.recipe[i] := RegExReplace(recipe, "\$", dataLetter)
				}
			}
		}

		if refinedEntry.options.groupKey.Length > 0
			refinedEntry.options.groupKeyPreview := this.SetNotaion(Util.FormatHotKey(refinedEntry.options.groupKey), dataPack)
		for key in ["fastKey", "altLayoutKey", "altSpecialKey"] {
			refinedEntry.options.%key% := this.SetNotaion(refinedEntry.options.%key%, dataPack)
		}


		if refinedEntry.recipe.Length > 0 {
			for recipe in refinedEntry.recipe {
				if !this.entryRecipes.Has(recipe) {
					this.entryRecipes.Set(recipe, { chr: Util.UnicodeToChar(refinedEntry.sequence.Length > 0 ? refinedEntry.sequence : refinedEntry.unicode), index: refinedEntry.index, name: entryName })
				} else {
					this.duplicatesList.Push(recipe)
				}
			}
		}

		if refinedEntry.recipeAlt.Length = 0 && refinedEntry.recipe.Length > 0 {
			refinedEntry.recipeAlt := refinedEntry.recipe.Clone()

			for diacriticName in this.entryCategories["Diacritic Mark"] {
				diacriticChr := this.Get(diacriticName)
				for i, altRecipe in refinedEntry.recipeAlt {
					if InStr(altRecipe, diacriticChr) {
						refinedEntry.recipeAlt[i] := RegExReplace(altRecipe, diacriticChr, DottedCircle diacriticChr)
					}
				}
			}

			for i, aR in refinedEntry.recipeAlt {
				refinedEntry.recipeAlt[i] := RegExReplace(aR, DottedCircle DottedCircle, DottedCircle)
			}
		}

		if StrLen(refinedEntry.data.script) > 0 && StrLen(refinedEntry.data.case) > 0 && StrLen(refinedEntry.data.letter) > 0 {
			refinedEntry := Locale.LocalesGeneration(entryName, refinedEntry)
		}


		for i, LaTeXCodeSymbol in LaTeXCodesLibrary {
			if Mod(i, 2) = 1 {
				LaTeXCode := LaTeXCodesLibrary[i + 1]

				if character == LaTeXCodeSymbol {
					refinedEntry.LaTeX := LaTeXCode is Array ? LaTeXCode : [LaTeXCode]
				}
			}
		}

		if refinedEntry.data.postfixes.Length = 1 {
			postfixEntry := this.GetEntry(refinedEntry.data.postfixes[1])
			originSymbolEntry := this.GetEntry(RegExReplace(entryName, "i)^(.*?)__(.*)$", "$1"))
			if postfixEntry {
				postfixSymbol := Util.UnicodeToChar(postfixEntry.unicode)

				originLTXLen := originSymbolEntry ? originSymbolEntry.LaTeX.Length : 0
				postfixLTXLen := postfixEntry.LaTeX.Length
				isDigraphOrLigature := Util.InStr(refinedEntry.symbol.category, ["dig", "lig"]) && refinedEntry.recipe.Length > 1 ? refinedEntry.recipe[2] : refinedEntry.recipe[1]

				symbolForLaTeX := RegExReplace(isDigraphOrLigature, postfixSymbol)
				setLaTeX := (lpox := 1, epos := 1) => postfixEntry.LaTeX[lpox] "{" (originLTXLen > 0 ? originSymbolEntry.LaTeX[epos] : symbolForLaTeX) "}"

				if postfixLTXLen > 0
					refinedEntry.LaTeX := [setLaTeX()]

				if postfixLTXLen = 2
					refinedEntry.LaTeX.Push(setLaTeX(postfixLTXLen, originLTXLen))
			}
		}

		this.entries.%entryName% := refinedEntry
	}

	static SetNotaion(str, data) {
		static notationKey := (m) => Chrs(0x29FC, 0x202F) m Chrs(0x202F, 0x29FD)

		output := str

		if StrLen(data.letter) > 0 {
			output := RegExReplace(output, "\$", data.dataLetter)
			output := RegExReplace(output, "\~", SubStr(data.letter, 1, 1))
			output := RegExReplace(output, "\?(.*?)$")
		}

		if StrLen(data.case) > 0 {
			if RegExMatch(output, "\/(.*?)\/", &match) {
				output := RegExReplace(output, match[0], data.case = "capital" ? Util.StrUpper(match[1], 1) : Util.StrLower(match[1], 1))
			}

			if RegExMatch(output, "\\(.*?)\\", &match) {
				output := RegExReplace(output, match[0], data.case = "capital" ? StrUpper(match[1]) : StrLower(match[1]))
			}
		}

		output := RegExReplace(output, "([.])(\s|$|\?)", notationKey("$1"))
		staticReplaces := ["[", "]", "(", ")", "!", "@"]
		for replace in staticReplaces {
			output := StrReplace(output, replace, notationKey(replace))
		}
		while RegExMatch(output, "([a-zA-Zа-яА-ЯёЁ0-9<>``,\'\`";\~\%\-\=\\/]+|[\x{2190}-\x{2195}]+)(\s|$|\?|,\s)", &match) {
			output := RegExReplace(output, match[1], notationKey(match[1]))
		}


		return output
	}

	static NameDecompose(entryName) {
		decomposedName := {
			script: Map("lat", "latin", "cyr", "cyrillic", "hel", "hellenic"),
			case: Map("c", "capital", "s", "small", "sc", "small_capital", "i", "inter", "n", "neutral"),
			type: Map("let", "letter", "lig", "ligature", "dig", "digraph", "num", "numeral"),
			letter: "",
			postfixes: []
		}

		foundScript := False

		for key, value in decomposedName.script {
			if RegExMatch(entryName, "^" key "_") {
				foundScript := True
				break
			}
		}

		if !foundScript
			return entryName

		for key, value in decomposedName.case {
			if !RegExMatch(entryName, "i)_" key "_") {
				foundScript := False
			} else {
				foundScript := True
				break
			}
		}

		if !foundScript
			return entryName

		for key, value in decomposedName.type {
			if !RegExMatch(entryName, "i)_" key "_") {
				foundScript := False
			} else {
				foundScript := True
				break
			}
		}


		if !foundScript {
			return entryName
		} else {
			if RegExMatch(entryName, "i)^([\w]+(?:_[\w]+){3,})_?", &rawMatch) {
				rawCharacterName := StrSplit(rawMatch[1], "_")

				decomposedName.script := decomposedName.script[rawCharacterName[1]]
				decomposedName.case := decomposedName.case[rawCharacterName[2]]
				decomposedName.type := decomposedName.type[rawCharacterName[3]]
				decomposedName.letter := (decomposedName.case = "capital" ? StrUpper(rawCharacterName[4]) : rawCharacterName[4])

				diacriticSet := InStr(entryName, "__") ? RegExReplace(entryName, "i)^.*?__(.*)", "$1") : ""
				decomposedName.postfixes := StrLen(diacriticSet) > 0 ? StrSplit(diacriticSet, "__") : []

				return decomposedName
			} else {
				return entryName
			}
		}
	}

	static SetDecomposedData(entryName, entry) {
		decomposedName := this.NameDecompose(entryName)

		if decomposedName == entryName {
			entry.data := {
				script: "",
				case: "",
				type: "",
				letter: "",
				postfixes: [],
				variant: ""
			}
			return entry
		} else {
			entry.data := decomposedName
			return entry
		}
	}

	static EntryPreview(entryName, indent := 0) {
		entry := this.GetEntry(entryName)
		output := this.FormatEntry(entry, indent)
		MsgBox(output)
	}

	static FormatEntry(entry, indent := 0) {
		output := ""
		indentStr := Util.StrRepeat("`t", indent)

		for key, value in entry.OwnProps() {
			if value is Array {
				output .= indentStr key ": [`n"
				for subValue in value {
					if subValue is Array {
						output .= indentStr "`t[" subValue.ToString(, "'") indentStr "]`n"
					} else {
						output .= indentStr "`t'" subValue "'`n"
					}
				}
				output .= indentStr "]`n"
			} else if value is Map {
				output .= indentStr key ": (`n"
				for mapKey, mapValue in value {
					output .= indentStr "`t" mapKey ": '" mapValue "'`n"
				}
				output .= indentStr ")`n"
			} else if value is Object {
				output .= indentStr key ": {`n" this.FormatEntry(value, indent + 1) indentStr "}`n"
			} else {
				output .= indentStr key ": '" value "'`n"
			}
		}

		return output
	}

	static PrintRecipesToFile() {
		filePath := A_ScriptDir "\recipes.txt"
		indexedMap := Map()
		output := ""

		for recipe, reference in ChrLib.entryRecipes {
			indexedMap.Set(reference.index, recipe "`t::`t" reference.name "`n")
		}

		for key, value in indexedMap {
			output .= value
		}

		FileAppend(output, filePath, "UTF-8")
	}
}