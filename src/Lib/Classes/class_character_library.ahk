Class ChrLib {
	Class Events {
		static __New() {
			Event.OnEvent("Application", "Initialized", (*) => ChrLib.CountOfUpdate())
			return
		}
	}

	static entries := {}
	static entriesSource := {}
	static entryGroups := Map("Favorites", [])
	static entryCategories := Map()
	static entryRecipes := Map()
	static entryTags := Map()
	static entryIdentifiers := Map()
	static dumpPath := App.paths.temp "\characters_dump.json"
	static duplicatesList := Map()
	static lastIndexAdded := -1
	static countOf := {
		entries: 0,
		glyphVariations: 0,
		userEntries: 0,
		recipes: 0,
		userRecipes: 0,
		uniqueRecipes: 0,
		uniqueUserRecipes: 0,
		fastKeys: 0,
		allKeys: 0,
	}

	static AddScript(scriptNames*) {
		for each in scriptNames
			this.scriptsValidator.Push(each)
		return
	}

	static scriptsValidator := [
		"deseret",
		"glagolitic",
		"germanic_runic",
		"cirth_runic",
		"tolkien_runic",
		"gothic",
		"old_hungarian",
		"old_italic",
		"old_permic",
		"old_persian",
		"old_turkic",
		"phoenician",
		"carian",
		"sidetic",
		"lycian",
		"lydian",
		"cypriot_syllabary",
		"tifinagh",
		"shavian",
		"caucasian_albanian",
		;
		"north_arabian",
		"south_arabian",
		;
		"ugaritic",
		"parthian",
		"palmyrene",
		;
		"ipa",
		"&ipa",
	]

	static __New() {
		ChrReg(characters.data)

		if ChrLib.duplicatesList.Count > 0 {
			TrayTip(Locale.ReadInject("warnings.duplicate_recipe", [ChrLib.duplicatesList.Keys().ToString()]), App.Title("+status+version"), "Icon! Mute")
			output := ""
			for recipe, names in ChrLib.duplicatesList
				output .= recipe "`t" names.ToString() "`n"

			Journal("duplicates", output)
		}

		return Event.Trigger("Character Library", "Default Ready")
	}

	static RenameEntry(entryName, newName) {
		if this.entries.HasOwnProp(entryName) {
			local entry := this.GetEntry(entryName)

			local scenarios := Map(
				"groups", { source: entry["groups"], target: this.entryGroups },
				"tags", { source: entry["tags"], target: this.entryTags }
			)

			for scenarioName, scenario in scenarios {
				for item in scenario.source {
					if scenario.target.Has(item) && scenario.target.Get(item).HasValue(entryName, &i) {
						scenario.target[item][i] := newName
					}
				}
			}

			this.entryIdentifiers.Set(entry["index"], newName)

			this.entries.DeleteProp(entryName)
			this.entries.%newName% := entry
		}
		return
	}

	static RemoveEntry(entryName) {
		if this.entries.HasOwnProp(entryName) {
			local entry := this.GetEntry(entryName)

			local scenarios := Map(
				"groups", { source: entry["groups"], target: this.entryGroups },
				"tags", { source: entry["tags"], target: this.entryTags }
			)

			for scenarioName, scenario in scenarios {
				for item in scenario.source {
					if scenario.target.Has(item) && scenario.target.Get(item).HasValue(entryName) {
						local intermediateArray := scenario.target.Get(item)
						intermediateArray.RemoveValue(entryName)

						scenario.target.Delete(item)
						scenario.target.Set(item, intermediateArray)
					}
				}
			}

			this.entries.DeleteProp(entryName)
		}
		return
	}

	static GetReferenceName(&entryName, &entry?) {
		if !IsSet(entry)
			entry := this.entries.%entryName%

		local referencingTo := entry["reference"] is Object ? entry["reference"].Clone() : entry["reference"]

		if referencingTo is Object && referencingTo.Has("params") {
			local call := referencingTo.Has("call") ? referencingTo["call"] : Cfg.Get.Bind(Cfg, referencingTo["params"]*)
			local result := call()
			referencingTo := result = referencingTo["if"]
				? referencingTo["then"]
				: referencingTo["else"]
		} else if referencingTo is Object && referencingTo.Has("name")
			referencingTo := referencingTo["name"]

		return referencingTo
	}

	static GetEntry(entryName) {
		if this.entries.HasOwnProp(entryName) && this.entries.%entryName% is Map {
			local entry := this.entries.%entryName%.DeepClone()
			local referencingTo := this.GetReferenceName(&entryName, &entry)

			if referencingTo != ""
				entry := this.ReplaceEntryKeys(entry, this.GetEntry(referencingTo), entry["modifiedKeys"])

			return entry
		} else {
			return False
		}
		return
	}

	static GetValue(entryName, value, useRef := False, &output?) {
		if useRef {
			if this.entries.%entryName%.Has(value) {
				output := this.entries.%entryName%[value]
				return True
			} else {
				return False
			}
		} else {
			return this.entries.%entryName%[value]
		}
		return
	}

	static Print() {
		local lang := Language.Get(, , 2)
		local printPath := App.paths.temp "\printed_pairs.html"
		local tableRows := ""

		if FileExist(printPath)
			FileDelete(printPath)

		local i := 0
		for entryName, entry in this.entries.OwnProps() {
			i++
			local characterContent := (entry["symbol"]["category"] = "Diacritic Mark" ? DottedCircle : "") (entry["result"].Length = 1 ? (
				Util.StrToHTML(entry["result"][1])) : Util.UnicodeToChar(entry["sequence"].Length > 0 ? entry["sequence"] : entry["unicode"]))

			local characterAlts := ""

			local maxJ := ObjOwnPropCount(entry["alterations"])
			if maxJ > 0 {
				local j := 0
				for key, value in entry["alterations"] {
					j++
					if !InStr(key, "HTML") {
						characterAlts .= (j = 1 ? "`n" : "") '<span class="small-text">' key ':</span> ' DottedCircle Util.UnicodeToChar(value) (j < maxJ ? "`n" : "")
					}
				}
			}

			local tableRows .= (
				'				<tr>`n'
				'					<td class="index">' i '</td>`n'
				'					<td' (StrLen(characterContent) > 15 * (InStr(characterContent, "&") ? 8 : 1) ? ' class="small-text"' : entry["symbol"]["category"] = "Spaces" ? ' class="spaces"' : '') '>' characterContent characterAlts '</td>`n'
				'					<td>' entryName '</td>`n'
				'				</tr>`n'
			)
		}

		local html := (
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
		return
	}

	static ReplaceEntryKeys(entryToModify, entrySource, keyNames := []) {
		if !entrySource || !entryToModify
			return False

		local output := entrySource.Clone()

		for each in ArrayMerge(keyNames, ["index", "variant", "variantPos"]) {
			if entryToModify.Has(each) {
				output[each] := entryToModify[each] is Object
					? entryToModify[each].Clone()
					: entryToModify[each]
			}
		}

		if entryToModify["reference"] is Object
			&& entryToModify["reference"].Has("as")
			&& entrySource["alterations"].Count > 0
			&& entrySource["alterations"].Has(entryToModify["reference"]["as"]) {
			output["unicode"] := entrySource["alterations"][entryToModify["reference"]["as"]]
			output["symbol"]["set"] := Util.UnicodeToChar(entrySource["alterations"][entryToModify["reference"]["as"]])
			output["sequence"] := []
			output["alterations"] := Map()
			output["altCode"] := []
			output["altCodePages"] := []
			output["LaTeX"] := []
			output["LaTeXPackage"] := ""

			if entryToModify["reference"].Has("include")
				for k, v in entryToModify["reference"]["include"]
					output["alterations"][k] := entrySource["alterations"][v]
		}

		local dataPack := output["data"]

		for key, value in output["options"]
			if ["fastKey", "altLayoutKey", "altSpecialKey"].HasValue(key)
				output["options"][key] := ChrReg.SetNotaion(&value, &dataPack)

		return output
	}

	static Get(entryName, extraRules := False, getMode := "Unicode", alt := Scripter.selectedMode.Get("Glyph Variations")) {
		if RegExMatch(entryName, "\\(.*?)\/", &multiMatch) {
			local output := ""
			local split := StrSplit(multiMatch[1], ",")

			for each in split {
				local name := each ~= "^\+" ? SubStr(each, 2) : RegExReplace(entryName, "\\(.*?)\/", each)
				output .= this.Get(name, extraRules, getMode, alt)
			}

			return output
		}

		if StrLen(alt) == 0
			alt := Scripter.selectedMode.Get("Glyph Variations")

		alt := this.ValidateAlt(alt)
		local entry := this.GetEntry(entryName)

		if alt = "superscript" && !entry["alterations"].Has("superscript")
			alt := "modifier"
		else if alt = "fraktur" && !entry["alterations"].Has("fraktur")
			alt := "blackletter"

		getMode := StrLen(getMode) ? getMode : "Unicode"

		local getChar := entry["result"].Length = 1 ? entry["result"][1] : Util.UnicodeToChar(entry["sequence"].Length > 0 ? entry["sequence"] : entry["unicode"])

		if (getMode = "HTML") {
			local output := getChar
			local entity := entry["entity"]

			if (extraRules && StrLen(alt) > 0 && entry["alterations"].Has(alt)) {
				output := Util.UnicodeToChar(entry["alterations"][alt])

				if entry["alterations"].Has(alt "Entity") && entry["alterations"][alt "Entity"] != ""
					entity := entry["alterations"][alt "Entity"]
			}

			return StrLen(entity) > 0 ? entity : Util.StrToHTML(output, , Cfg.HTMLMode)

		} else if (getMode = "LaTeX" && entry["LaTeX"].Length > 0) {
			return (entry["LaTeX"].Length = 2 && Cfg.LaTeXMode = "Math") ? entry["LaTeX"][2] : entry["LaTeX"][1]

		} else {
			if (extraRules && StrLen(alt) > 0 && entry["alterations"].Has(alt)) {
				return Util.UnicodeToChar(entry["alterations"][alt])

			} else if (extraRules && getMode != "Unicode" && entry["alterations"].Has(getMode)) {
				return Util.UnicodeToChar(entry["alterations"][getMode])
			} else {
				try {
					return getChar
				} catch {
					MsgBox(Locale.Read("error.critical") "`n`n" Locale.ReadInject("error.entry_not_found", [entryName]), App.Title(), "Iconx")
					return
				}
			}
		}
		return
	}

	static GetByPrefix(prefix, extraRules := False, getMode := "Unicode", alt := Scripter.selectedMode.Get("Glyph Variations")) {
		local output := ""

		for entryName, entyr in this.entries.OwnProps()
			if entryName ~= "^(" prefix ")"
				output .= this.Get(entryName, extraRules, getMode, alt)

		return output
	}

	static Gets(entryNames*) {
		local output := ""
		local indexMap := Map()

		local charIndex := 0
		for i, character in entryNames {
			charIndex++
			local repeatCount := 1
			local characterMatch := character

			if RegExMatch(characterMatch, "(.+?)\[(\d+(?:,\d+)*)\]$", &match) {
				if RegExMatch(match[1], "(.+?)×(\d+)$", &subMatch) {
					character := subMatch[1]
					repeatCount := subMatch[2]
				} else {
					character := match[1]
				}
				local positions := StrSplit(match[2], ",")
				for _, position in positions {
					position := Number(position)
					if !indexMap.Has(position) {
						indexMap[position] := []
					}
					indexMap[position].Push([character, repeatCount])
				}
				continue
			} else if RegExMatch(characterMatch, "(.+?)×(\d+)$", &match) {
				character := match[1]
				repeatCount := match[2]
				continue
			}

			if !indexMap.Has(charIndex) {
				indexMap[charIndex] := []
			}
			indexMap[charIndex].Push([character, repeatCount])
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

	static GetIndexedMap() {
		local output := Map()

		for k, v in this.entries.OwnProps()
			output.Set(v["index"], k)

		return output
	}

	static GeneratePermutations(items) {
		if items.Length = 1 {
			return [items[1]]
		}

		local permutations := []
		for i, item in items {
			local remaining := items.Clone()
			remaining.RemoveAt(i)
			subPermutations := this.GeneratePermutations(remaining)
			for subPerm in subPermutations {
				permutations.Push(item subPerm)
			}
		}

		return permutations
	}

	static Count(groupRestrict?, onlyGlyphsVariations := False) {
		local count := 0
		for entry, value in this.entries.OwnProps() {
			if !IsSet(groupRestrict) || (IsSet(groupRestrict) && value["groups"].HasValue(groupRestrict)) {
				if !value["options"]["noCalc"] && !onlyGlyphsVariations
					count++

				for alteration, value in value["alterations"]
					if !InStr(alteration, "HTML") && !InStr(alteration, "Entity")
						count++
			}
		}

		return count
	}

	static HotKeysCount(key := "fastKey") {
		local count := 0
		for entry, value in this.entries.OwnProps() {
			if key is Array {
				for k in key
					if value["options"].Has(k) && value["options"][k] != ""
						count++
			} else
				if value["options"].Has(key) && value["options"][key] != ""
					count++
		}

		return count
	}

	static CountOfUpdate() {
		this.countOf.userEntries := this.Count("Custom Composes")
		this.countOf.entries := this.Count() - this.countOf.userEntries
		this.countOf.glyphVariations := this.Count(, True)
		this.countOf.userRecipes := ChrRecipeHandler.Count("Custom Only")
		this.countOf.recipes := ChrRecipeHandler.Count("No Custom")
		this.countOf.uniqueRecipes := ChrRecipeHandler.Count("No Custom", True)
		this.countOf.uniqueUserRecipes := ChrRecipeHandler.Count("Custom Only", True)
		this.countOf.fastKeys := this.HotKeysCount("fastKey")
		this.countOf.allKeys := this.countOf.fastKeys + this.HotKeysCount(["altLayoutKey", "altSpecialKey"])
		return
	}

	static ValidateAlt(str) {
		static alterationNames := Map(
			"modifier", ["модификатор", "мо", "mo"],
			"superscript", ["верхний индекс", "ви", "sup"],
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
			"smallCapitalModifier", ["капитель-модификатор", "км", "scm"],
			"small", ["маленький", "мал", "sm"],
			"combining", ["комбинируемый", "ко", "c"],
			"uncombined", ["некомбинируемый", "неко", "uc"],
			"fullwidth", ["полноширинный", "пш", "fw"],
			"blackletter", ["bl"],
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

	static EntryPreview(entryName, indent := 1) {
		local entry := this.GetEntry(entryName)
		local output := "'" entryName "', {`n"
		output .= this.FormatEntry(entry, indent)
		output .= "}"

		Constructor() {
			local pGui := Gui()
			pGui.title := App.Title() " — [ " entryName " ]"

			local w := 600
			local h := 800

			local xPos := (A_ScreenWidth - w) / 2
			local yPos := (A_ScreenHeight - h) / 2

			local contentW := w - 20
			local contentH := h - 20
			local contentX := (w - contentW) / 2
			local contentY := (h - contentH) / 2

			local content := pGui.AddEdit(Format("vEntryPreviewContent w{} h{} x{} y{} ReadOnly +Wrap -HScroll", contentW, contentH, contentX, contentY), output)
			content.SetFont("s10", "Courier New")


			pGui.Show(Format("w{} h{} x{} y{}", w, h, xPos, yPos))
			return pGui
		}

		pGui := Constructor()
		return
	}

	static FormatEntry(entry, indent := 1) {
		; if !(entry is Map)
		; 	return ""

		local output := ""
		local indentStr := Util.StrRepeat(" ", indent * 8)

		for key, value in entry {
			if value is Array {
				output .= indentStr key ": ["
				local subOutput := ""

				for subValue in value {
					if subValue is Array
						subOutput .= indentStr indentStr "[" subValue.ToString(, "'") indentStr "]`n"
					else if subValue is Map
						subOutput .= this.FormatEntry(subValue, indent + 2)
					else if subValue is Object {
						local tempMap := Map()
						for prop in subValue.OwnProps()
							tempMap[prop] := subValue.%prop%
						subOutput .= this.FormatEntry(tempMap, indent + 2)
					}
					else
						subOutput .= indentStr indentStr "'" subValue "'`n"
				}

				if subOutput != ""
					output .= "`n" subOutput indentStr

				output .= "]`n"
			} else if value is Map {
				output .= indentStr key ": (`n"

				for mapKey, mapValue in value {
					if mapValue is Map {
						output .= Util.StrRepeat(" ", (indent + 1) * 8) mapKey ": (`n"
						output .= this.FormatEntry(mapValue, indent + 2)
						output .= Util.StrRepeat(" ", (indent + 1) * 8) ")`n"
					} else if mapValue is Array {
						output .= Util.StrRepeat(" ", (indent + 1) * 8) mapKey ": ["
						local arrayOutput := ""

						for arrayValue in mapValue {
							if arrayValue is Array
								arrayOutput .= Util.StrRepeat(" ", (indent + 2) * 8) "[" arrayValue.ToString(, "'") "]`n"
							else if arrayValue is Map
								arrayOutput .= this.FormatEntry(arrayValue, indent + 2)
							else if arrayValue is Object {
								local tempMap := Map()
								for prop in arrayValue.OwnProps()
									tempMap[prop] := arrayValue.%prop%
								arrayOutput .= this.FormatEntry(tempMap, indent + 2)
							}
							else
								arrayOutput .= Util.StrRepeat(" ", (indent + 2) * 8) "'" arrayValue "'`n"
						}

						if arrayOutput != ""
							output .= "`n" arrayOutput Util.StrRepeat(" ", (indent + 1) * 8)

						output .= "]`n"
					} else if mapValue is Object {
						local tempMap := Map()
						for prop in mapValue.OwnProps()
							tempMap[prop] := mapValue.%prop%
						subOutput := this.FormatEntry(tempMap, indent + 2)
						subOutput := subOutput != "" ? "`n" subOutput Util.StrRepeat(" ", (indent + 1) * 8) : ""
						output .= Util.StrRepeat(" ", (indent + 1) * 8) mapKey ": {" subOutput "}`n"
					} else {
						output .= mapValue is Number ? Util.StrRepeat(" ", (indent + 1) * 8) mapKey ": " mapValue "`n" : Util.StrRepeat(" ", (indent + 1) * 8) mapKey ": '" StrReplace(mapValue, "`n", " ") "'`n"
					}
				}

				output .= indentStr ")`n"
			} else if value is Object {
				local tempMap := Map()
				for prop in value.OwnProps()
					tempMap[prop] := value.%prop%
				subOutput := this.FormatEntry(tempMap, indent + 1)
				subOutput := subOutput != "" ? "`n" subOutput indentStr : ""
				output .= indentStr key ": {" subOutput "}`n"
			} else
				output .= value is Number ? indentStr key ": " value "`n" : indentStr key ": '" StrReplace(value, "`n", " ") "'`n"
		}

		return output
	}

	static PrintRecipesToFile() {
		local filePath := A_ScriptDir "\recipes.txt"
		local indexedMap := Map()
		local output := ""

		for recipe, reference in ChrLib.entryRecipes {
			indexedMap.Set(reference.index, recipe "`t::`t" reference.name "`n")
		}

		for key, value in indexedMap {
			output .= value
		}

		FileAppend(output, filePath, "UTF-8")
		return
	}
}