Class ChrReg {
	static recipeAltReplaces := [
		["([" Chrs(0x21BA, 0x21BB, 0x2190, 0x2191, 0x2193, 0x2192, 0x2196, 0x2197, 0x2199, 0x2198, 0x2194, 0x2195, 0x2B8C, 0x2B8E, 0x2B8D, 0x2B8F) "])(" DottedCircle ")", "$1" Chr(0xE0020) "$2"]
	]


	__New(rawEntries, typeOfInit := "Internal", preventProgressGUI := False, defaultLib := False) {
		Event.Trigger("Character Library", "Registration Starts", rawEntries, typeOfInit, preventProgressGUI)

		this.AddEntries(&rawEntries, &typeOfInit, &preventProgressGUI)

		return Event.TriggerMulti(["Character Library", "Registration Ends"], ["UI Data", "Changed"])
	}

	AddEntry(&entryName, &entry, &progress, &instances, &isDump?) {
		if !IsSet(entry)
			return

		local brackets := []
		local pos := 1
		while (pos := RegExMatch(entryName, "\[(.*?)\]", &match, pos)) {
			local content := match[1]
			local isMultiply := false
			local multiplyCount := 0

			if RegExMatch(content, "^\×(\d+)$", &numMatch) {
				isMultiply := true
				multiplyCount := Integer(numMatch[1])
			}

			brackets.Push({
				fullMatch: match[0],
				content: content,
				startPos: pos,
				endPos: pos + StrLen(match[0]) - 1,
				isMultiply: isMultiply,
				multiplyCount: multiplyCount
			})
			pos += StrLen(match[0])
		}

		if brackets.Length > 0 {
			local allVariants := []
			local maxVariants := 0

			for bracket in brackets {
				local variants := []

				if bracket.isMultiply {
					Loop bracket.multiplyCount {
						variants.Push("")
					}
				} else {
					variants := StrSplit(bracket.content, ",")
					for i, variant in variants {
						variants[i] := Trim(variant)
					}
				}

				allVariants.Push(variants)
				if variants.Length > maxVariants
					maxVariants := variants.Length
			}

			for variants in allVariants {
				if variants.Length != maxVariants {
					MsgBox((
						Locale.Read("error.at_library_registration") "`n"
						Locale.ReadInject("error.invalid_variants_at_name", [variants.Length, maxVariants, entryName])
					), App.Title(), "Iconx")
					return
				}
			}

			local entries := Map()

			for i in Range(1, maxVariants) {
				local variantName := entryName

				for j in Range(brackets.Length, 1, -1) {
					local bracket := brackets[j]
					local variant := allVariants[j][i]

					variantName := (
						SubStr(variantName, 1, bracket.startPos - 1)
						variant
						SubStr(variantName, bracket.endPos + 1)
					)
				}

				if RegExMatch(variantName, "\{(-?\d+)?(?:\.\.\.)?i\}", &match) {
					local addition := match[1] != "" ? Integer(match[1]) : 0
					variantName := RegExReplace(variantName, match[0], addition + i)
				}

				local variantEntry := entry.Clone()

				for item in ["unicode", "proxy", "alterations"] {
					if entry[item] is Array
						variantEntry[item] := (
							entry[item][i] is Object ? entry[item][i].Clone() : entry[item][i]
						)
				}

				if entry.Has("recipePush")
					&& entry["recipePush"] is Array
					&& entry["recipePush"][i] is Object {
					variantEntry["recipePush"] := entry["recipePush"][i].Clone()
				}

				if entry.Has("reference") {
					if entry["reference"] is Array
						variantEntry["reference"] := entry["reference"][i].Clone()
				}

				if entry["sequence"].Length > 0 && entry["sequence"][i] is Array
					variantEntry["sequence"] := entry["sequence"][i].Clone()

				variantEntry := this.SetDecomposedData(&variantName, &variantEntry)

				local symbolRef := entry["symbol"]
				variantEntry["symbol"] := this.CloneOptions(&symbolRef, &i)

				this.ProcessProperties(&variantEntry, &entry, &i)

				local optionsRef := entry["options"]
				variantEntry["options"] := this.CloneOptions(&optionsRef, &i)
				variantEntry["variant"] := allVariants[1][i]
				variantEntry["variantPos"] := i

				if variantEntry["recipe"].Length > 0 {
					variantEntry["recipe"] := Util.ProcessConcatenation(variantEntry["recipe"])
					variantEntry["concatenated"] := True
				}

				entries.Set(i, Map("name", variantName, "entry", variantEntry))
			}

			for entryIndex, entryObj in entries {
				local variantName := entryObj["name"]
				local variantEntry := entryObj["entry"]
				local variant := allVariants[1]
				this.ProcessRecipe(&variantEntry, &variant)
				local value := ChrEntry().Get(variantEntry)
				this.AddEntry(&variantName, &value, &progress, &instances)
			}
		} else {
			local isEntryExists := ChrLib.entries.HasOwnProp(entryName)
			local presavedIndex := isEntryExists ? ChrLib.entries.%entryName%.Get("index") : 0

			ChrLib.entries.%entryName% := Map()
			ChrLib.entriesSource.%entryName% := entry

			local libEntry := Map()
			if IsSet(isDump) && isDump {
				this.ProcessDump(&entryName, &entry)
				libEntry := ChrLib.entries.%entryName%

				this.TransferProperties(&entryName, &entry)
			} else {
				this.EntryPreProcessing(&entryName, &entry, &instances)

				this.TransferProperties(&entryName, &entry)

				if !isEntryExists {
					local idx := ++ChrLib.lastIndexAdded
					ChrLib.entries.%entryName%["index"] := idx
					ChrLib.entryIdentifiers.Set(idx, entryName)
				} else
					ChrLib.entries.%entryName%["index"] := presavedIndex

				libEntry := ChrLib.entries.%entryName%
				this.EntryPostProcessing(&entryName, &libEntry, &instances)
			}
			if progress {
				progress.data.progressName := StrLen(entryName) > 50 ? SubStr(entryName, 1, 50) "…" : entryName
				progress.data.progressBarCurrent++
				progress.data.progressPercent := Floor((progress.data.progressBarCurrent / progress.data.maxCountOfEntries) * 100)
			}
			entry := unset
		}
		return
	}

	AddEntries(&rawEntries, &typeOfInit, &preventProgressGUI) {
		local progress := !preventProgressGUI ? PorgressBar({ typeOfInit: typeOfInit }) : False
		local setProgress := !preventProgressGUI ? progress.SetProgressBarValue.Bind(progress) : False
		local instances := {
			ChrBlock: ChrBlock(),
			LocaleGenerator: LocaleGenerator(),
		}

		if Keyboard.blockedForReload
			return


		if rawEntries is Array && rawEntries.Length >= 2 {
			if progress {
				Loop rawEntries.Length // 2 {
					local index := A_Index * 2 - 1
					local entryName := rawEntries[index]
					local entry := rawEntries[index + 1]

					if RegExMatch(entryName, "\[(.*?)\]", &match) {
						local splitVariants := StrSplit(match[1], ",")
						progress.data.maxCountOfEntries += splitVariants.Length
					} else {
						progress.data.maxCountOfEntries++
					}
				}

				SetTimer(setProgress, 25, 0)
			}

			Loop rawEntries.Length // 2 {
				local index := A_Index * 2 - 1
				local entryName := rawEntries[index]
				local entryValue := rawEntries[index + 1]
				local entry := ChrEntry().Get(entryValue)
				this.AddEntry(&entryName, &entry, &progress, &instances)

				entry := unset
			}

			this.Aftermath(&instances)

			if progress {
				Sleep 500
				progress.GUI.Destroy()
				progress.SetProgressBarZero()
			}
		} else if rawEntries is Map && rawEntries.Has("isDump") {
			rawEntries.Delete("isDump")
			if progress {
				progress.data.maxCountOfEntries := rawEntries.Count
				ChrLib.lastIndexAdded := rawEntries.Count - 1
				SetTimer(setProgress, 250, 0)
			}

			for entryName, entryValue in rawEntries {
				this.AddEntry(&entryName, &entryValue, &progress, &instances, &isDump := True)
			}
			progress.Destroy()
		}
		rawEntries := unset
		typeOfInit := unset
		instances := unset

		if progress
			SetTimer(setProgress, -0)
		progress := unset
		setProgress := unset
		return
	}

	ProcessDump(&entryName, &entry) {
		this.EntryPostProcessing__Categories(&entryName, &entry)
		this.EntryPostProcessing__Recipes(&entryName, &entry)
		return
	}


	ProcessProperties(&targetEntry, &sourceEntry, &index) {
		for reference in ["recipe", "tags", "groups"] {
			if sourceEntry[reference].Length > 0 && sourceEntry[reference][sourceEntry[reference].Length] is Array {
				if sourceEntry[reference][index].Length > 0 {
					targetEntry[reference] := sourceEntry[reference][index].Clone()

					if sourceEntry.Has(reference "Prefixes") {
						if sourceEntry[reference "Prefixes"].Length > 0
							for i, prefix in sourceEntry[reference "Prefixes"] {
								targetEntry[reference][i] := prefix targetEntry[reference][i]
							}
						targetEntry.Delete(reference "Prefixes")
					}

				} else {
					targetEntry[reference] := []
				}
			}
		}
		return
	}

	ProcessReference(&targetEntry) {
		if targetEntry.Has("reference") && targetEntry["reference"] is Object {
			for each in ["name", "then", "else", "as"] {
				if targetEntry["reference"].Has(each)
					&& RegExMatch(targetEntry["reference"][each], "\[(.*?)\]", &match) {
					local splittedVariants := StrSplit(match[1], ",")
					targetEntry["reference"][each] := RegExReplace(targetEntry["reference"][each], "\[.*?\]", splittedVariants[targetEntry["variantPos"]], , 1)
				}
			}
		}
	}

	ProcessSymbolLetter(&targetEntry) {
		if targetEntry["symbol"]["letter"] is String {
			targetEntry["symbol"]["letter"] := RegExReplace(targetEntry["symbol"]["letter"], "\%self\%", Util.UnicodeToChar(targetEntry["unicode"]))
			if InStr(targetEntry["symbol"]["letter"], "${") {
				while RegExMatch(targetEntry["symbol"]["letter"], "\[(.*?)\]", &varMatch) {
					local splittedVariants := StrSplit(varMatch[1], ",")
					targetEntry["symbol"]["letter"] := RegExReplace(targetEntry["symbol"]["letter"], "\[.*?\]", splittedVariants[targetEntry["variantPos"]], , 1)
				}

				targetEntry["symbol"]["letter"] := ChrRecipeHandler.MakeStr(targetEntry["symbol"]["letter"])
			} else if targetEntry["data"]["script"] = "cyrillic" &&
				RegExMatch(targetEntry["data"]["letter"], "^[a-zA-Z0-9]+$") {
				targetEntry["symbol"]["letter"] := Util.UnicodeToChar(targetEntry["unicode"])
			} else if RegExMatch(targetEntry["symbol"]["letter"], "\{(-?\d+)?(?:\.\.\.)?i\}", &match) {
				local addition := match[1] != "" ? Integer(match[1]) : 0
				targetEntry["symbol"]["letter"] := RegExReplace(targetEntry["symbol"]["letter"], match[0], addition + targetEntry["variantPos"])
			}
		}
		return
	}

	ProcessOptionStrings(&targetEntry) {
		for key, value in targetEntry["options"] {
			if targetEntry["options"][key] is String {
				targetEntry["options"][key] := RegExReplace(targetEntry["options"][key], "\%self\%", Util.UnicodeToChar(targetEntry["unicode"]))

				if InStr(targetEntry["options"][key], "${") || InStr(targetEntry["options"][key], "*?") {
					endPart := targetEntry["data"]["endPart"] != "" ? "_" targetEntry["data"]["endPart"] : ""
					while RegExMatch(targetEntry["options"][key], "\[(.*?)\]", &varMatch) {
						local splittedVariants := StrSplit(varMatch[1], ",")
						targetEntry["options"][key] := RegExReplace(targetEntry["options"][key], "\[.*?\]", splittedVariants[targetEntry["variantPos"]], , 1)
						targetEntry["options"][key] := RegExReplace(targetEntry["options"][key], "\@", targetEntry["data"]["letter"], , 1)
						targetEntry["options"][key] := RegExReplace(targetEntry["options"][key], "\?\?", endPart, , 1)
						targetEntry["options"][key] := RegExReplace(targetEntry["options"][key], "\*\?")
					}

					if InStr(targetEntry["options"][key], "${")
						targetEntry["options"][key] := ChrRecipeHandler.MakeStr(targetEntry["options"][key])
				}

			}
		}
		return
	}

	CloneOptions(&sourceOptions, &index) {
		local tempOptions := sourceOptions.Clone()
		local strIndexBanned := ["letter"]
		local arrIndexBanned := ["tagAdditive", "scriptBounds"]

		for key, value in sourceOptions {
			if sourceOptions[key] is Array && sourceOptions[key].Length > 0 && (arrIndexBanned.HasValue(key) && sourceOptions[key].Has(index) && sourceOptions[key][index] is Array || !arrIndexBanned.HasValue(key)) {
				if sourceOptions[key].Has(index) {
					if sourceOptions[key][index] is Array
						tempOptions[key] := sourceOptions[key][index].Clone()
					else
						tempOptions[key] := sourceOptions[key][index]
				} else
					tempOptions[key] := sourceOptions[key][1] is Array ? sourceOptions[key][1].Clone() : sourceOptions[key][1]
			} else if sourceOptions[key] is String {
				local option := sourceOptions[key]

				if !strIndexBanned.HasValue(key) {
					local result := ""
					local lastPos := 1

					while RegExMatch(option, "\[(.*?)\]", &match, lastPos) {
						result .= SubStr(option, lastPos, match.Pos - lastPos)

						local arrayContent := match[1]
						local elements := StrSplit(arrayContent, ",")
						local selectedElement := ""

						if index <= elements.Length {
							selectedElement := elements[index]

							if RegExMatch(selectedElement, "^\{\<(\d+)\}$", &indexPointMatch) {
								local indexPoint := Integer(indexPointMatch[1])
								if indexPoint > 0 && indexPoint <= elements.Length
									selectedElement := elements[indexPoint]
							}
						} else {
							selectedElement := elements[1]
						}

						result .= selectedElement

						lastPos := match.Pos + match.Len
					}

					result .= SubStr(option, lastPos)
					option := result
				}

				tempOptions[key] := option
			}
		}
		return tempOptions
	}

	ProcessRecipe(&entry, &splitVariants) {
		if entry["recipe"].Length = 0 {
			if entry["data"]["postfixes"].Length > 0 {
				if entry["data"]["postfixes"].Length = 1 {
					if ["ligature", "digraph"].HasValue(entry["data"]["type"]) {
						entry["recipe"] := [
							"$${" entry["data"]["postfixes"][1] "}",
							(
								"${" SubStr(entry["data"]["script"], 1, 3)
								"_[" splitVariants.ToString(",") "]_"
								SubStr(entry["data"]["type"], 1, 3)
								"_@??}${" entry["data"]["postfixes"][1] "}"
							),
							"${" entry["data"]["postfixes"][1] "}$",
							(
								"${" entry["data"]["postfixes"][1] "}"
								"${" SubStr(entry["data"]["script"], 1, 3)
								"_[" splitVariants.ToString(",") "]_"
								SubStr(entry["data"]["type"], 1, 3) "_@??}"
							),
						]
					} else {
						entry["recipe"] := [
							"$${" entry["data"]["postfixes"][1] "}",
							"${" entry["data"]["postfixes"][1] "}$",
						]
					}
				} else if entry["data"]["postfixes"].Length = 2 {
					entry["recipe"] := [
						(
							"$${(" entry["data"]["postfixes"][1]
							"|" entry["data"]["postfixes"][2] ")}$(*)"
						),
						(
							"${" SubStr(entry["data"]["script"], 1, 3)
							"_[" splitVariants.ToString(",") "]_"
							SubStr(entry["data"]["type"], 1, 3) "_@??__("
							entry["data"]["postfixes"][1] "|"
							entry["data"]["postfixes"][2] ")}$(*)"
						),
						(
							"${(" entry["data"]["postfixes"][1] "|"
							entry["data"]["postfixes"][2] ")}$(*)$"
						),
						(
							"${" entry["data"]["postfixes"][1] "}"
							"${" SubStr(entry["data"]["script"], 1, 3)
							"_[" splitVariants.ToString(",") "]_"
							SubStr(entry["data"]["type"], 1, 3) "_@??__"
							entry["data"]["postfixes"][2] "}"
						),
						(
							"${" entry["data"]["postfixes"][2] "}"
							"${" SubStr(entry["data"]["script"], 1, 3)
							"_[" splitVariants.ToString(",") "]_"
							SubStr(entry["data"]["type"], 1, 3) "_@??__"
							entry["data"]["postfixes"][1] "}"
						),
					]
				} else if entry["data"]["postfixes"].Length = 3 {
					entry["recipe"] := [
						(
							"$${" entry["data"]["postfixes"][1] "}"
							"${" entry["data"]["postfixes"][2] "}${" entry["data"]["postfixes"][3] "}"
						),
						(
							"${" entry["data"]["postfixes"][1] "}"
							"${" entry["data"]["postfixes"][2] "}${" entry["data"]["postfixes"][3] "}$"
						),
					]
				}
			} else if ["ligature", "digraph"].HasValue(entry["data"]["type"]) && entry["data"]["postfixes"].Length = 0 {
				entry["recipe"] := ["$"]
			}
		}

		if entry.Has("recipePush") {
			if entry["recipePush"] is Array {
				if entry["recipePush"].Length > 0
					for recipe in entry["recipePush"]
						entry["recipe"].Push(recipe)

			} else if entry["recipePush"] is Object {
				for i, r in entry["recipePush"] {
					if r is Array {
						for recipe in r
							entry["recipe"].InsertAt(Integer(i), recipe)
					} else
						entry["recipe"].InsertAt(Integer(i), r)
				}
			}
		}

		if entry["recipe"].Length > 0 {
			local tempRecipe := entry["recipe"].Clone()
			for i, recipe in tempRecipe {
				endPart := entry["data"]["endPart"] != "" ? "_" entry["data"]["endPart"] : ""

				while RegExMatch(recipe, "\[i:(.*?)\]", &varMatch) {
					local splittedVariants := StrSplit(varMatch[1], ",")
					recipe := RegExReplace(recipe, "\[i:.*?\]", splittedVariants[entry["variantPos"]], , 1)
				}

				tempRecipe[i] := RegExReplace(recipe, "\[.*?\]", SubStr(entry["data"]["case"], 1, 1))
				tempRecipe[i] := RegExReplace(tempRecipe[i], "@", entry["data"]["letter"])
				tempRecipe[i] := RegExReplace(tempRecipe[i], "\?\?", endPart)
				if RegExMatch(tempRecipe[i], "\/(.*?)\/", &match) && match[1] != "" {
					tempRecipe[i] := RegExReplace(tempRecipe[i], "\/(.*?)\/", entry["data"]["case"] = "capital" ? Util.StrUpper(match[1], 1) : Util.StrLower(match[1], 1))
				}
				if RegExMatch(tempRecipe[i], "\\(.*?)\\", &match) && match[1] != "" {
					tempRecipe[i] := RegExReplace(tempRecipe[i], "\\(.*?)\\", entry["data"]["case"] = "capital" ? StrUpper(match[1]) : StrLower(match[1]))
				}
				if RegExMatch(tempRecipe[i], "\{(-?\d+)?(?:\.\.\.)?i\}", &match) {
					local addition := match[1] != "" ? Integer(match[1]) : 0
					tempRecipe[i] := RegExReplace(tempRecipe[i], match[0], addition + entry["variantPos"])
				}
			}
			entry["recipe"] := tempRecipe
		}
		return
	}

	TransferProperties(&entryName, &entry, &skipStatus := "") {
		for key, value in entry {
			if !["String", "Integer", "Boolean"].HasValue(Type(value)) {
				if ["recipe", "result"].HasValue(key) && value.Length > 0
					this.TransferRecipeProperty(&entryName, &key, &value, &skipStatus)
				else
					this.Transfer%Type(value)%Property(&entryName, &key, &value)
			} else {
				ChrLib.entries.%entryName%[key] := value
			}
		}
		return
	}

	TransferFuncProperty(&entryName, &key, &value) {
		local definedValue := value
		local interObj := {}
		interObj.DefineProp(key, {
			Get: (*) => definedValue(),
			Set: (ChrLib, value) => this.DefineProp(key, { Get: (*) => value })
		})
		ChrLib.entries.%entryName%[key] := interObj
		return
	}

	TransferRecipeProperty(&entryName, &key, &value, &skipStatus := "") {
		try {
			local tempRecipe := [value.Clone()]
			local definedRecipe := (*) => ChrRecipeHandler.Make(tempRecipe, entryName, skipStatus, throwError := True)
			local interObj := {}
			interObj.DefineProp("Get", { Get: definedRecipe, Set: definedRecipe })
			ChrLib.entries.%entryName%[key] := interObj.Get
		} catch {
			ChrLib.entries.%entryName%[key] := value.Clone()
			if skipStatus = ""
				this.attemptQueue.Push(entryName)
		}
		return
	}

	attemptQueue := []
	Aftermath(&instances) {
		if this.attemptQueue.Length > 0 {
			for entryName in this.attemptQueue {
				local presavedIndex := ChrLib.entries.%entryName%["index"]
				ChrLib.entries.%entryName% := ChrLib.entriesSource.%entryName%.Clone()
				local libEntry := ChrLib.entries.%entryName%
				libEntry["index"] := presavedIndex

				this.EntryPreProcessing(&entryName, &libEntry, &instances)
				this.TransferProperties(&entryName, &libEntry, &skipStatus := "Missing")

				libEntry["recipe"] := ChrRecipeHandler.Make(libEntry["recipe"], entryName, skipStatus)
				libEntry["result"] := ChrRecipeHandler.Make(libEntry["result"], entryName, skipStatus)

				this.EntryPostProcessing(&entryName, &libEntry, &instances)
			}
			this.attemptQueue := []
			instances := unset
		}
		return
	}

	TransferArrayProperty(&entryName, &key, &value) {
		ChrLib.entries.%entryName%[key] := []
		for subValue in value {
			if subValue is Func {
				local interObj := {}
				interObj.DefineProp("Get", { Get: subValue, Set: subValue })
				if interObj.Get is Array {
					for interValue in interObj.Get
						ChrLib.entries.%entryName%[key].Push(interValue)
				} else {
					ChrLib.entries.%entryName%[key].Push(interObj.Get)
				}
			} else {
				ChrLib.entries.%entryName%[key].Push(subValue)
			}
		}
		return
	}

	TransferMapProperty(&entryName, &key, &value) {
		ChrLib.entries.%entryName%[key] := Map()
		for mapKey, mapValue in value {
			if mapValue is Func {
				local interObj := {}
				interObj.DefineProp("Get", { Get: mapValue, Set: mapValue })
				ChrLib.entries.%entryName%[key].Set(mapKey, interObj.Get)
			} else {
				ChrLib.entries.%entryName%[key].Set(mapKey, mapValue)
			}
		}
		return
	}

	TransferObjectProperty(&entryName, &key, &value) {
		ChrLib.entries.%entryName%[key] := {}
		for subKey, subValue in value.OwnProps() {
			if subValue is Func {
				ChrLib.entries.%entryName%[key].DefineProp(subKey, {
					Get: subValue,
					Set: subValue
				})
			} else {
				ChrLib.entries.%entryName%[key].%subKey% := subValue
			}
		}
		return
	}

	EntryPreProcessing(&entryName, &entry, &instances) {
		if !IsSet(entry)
			return

		entry := this.SetDecomposedData(&entryName, &entry)

		local selectivePart := ""
		if RegExMatch(entryName, "i)(orkhon|yenisei|later_younger_futhark|younger_futhark|elder_futhark|futhork|almanac|medieval)", &selectiveMatch)
			selectivePart := " " selectiveMatch[1]

		if StrLen(entry["data"]["script"]) > 0 && StrLen(entry["data"]["type"]) > 0 {

			if ["hellenic", "glagolitic"].HasValue(entry["data"]["script"])
				&& !entry["options"]["useLetterLocale"]
				entry["options"]["useLetterLocale"] := True


			if entry["groups"].Length = 0 {
				local hasPostfix := entry["data"]["postfixes"].Length > 0
				if ArrayMerge(ChrLib.scriptsValidator, ["hellenic", "latin", "cyrillic"]).HasValue(entry["data"]["script"]) {
					script := StrReplace(entry["data"]["script"], "_", " ")
					entry["groups"] := (StrLen(entry["data"]["type"]) > 0 && ["digraph", "ligature", "numeral"].HasValue(entry["data"]["type"]) ?
						[StrTitle(script RegExReplace(selectivePart, "_", " ") " " entry["data"]["type"] "s")] :
						[StrTitle(script RegExReplace(selectivePart, "_", " ") (hasPostfix ? " Accented" : ""))]
					)
				}
			}

			if StrLen(entry["symbol"]["category"] = 0) {
				if StrLen(entry["data"]["script"]) && StrLen(entry["data"]["type"]) {

					local hasPostfix := entry["data"]["postfixes"].Length > 0
					entry["symbol"]["category"] := StrTitle(entry["data"]["script"] " " entry["data"]["type"] (hasPostfix ? " Accented" : ""))

				} else {
					entry["symbol"]["category"] := "N/A"
				}
			}

			if entry["symbol"]["scriptAdditive"] = ""
				if entry["data"]["script"] = "old_italic"
					entry["symbol"]["scriptAdditive"] := "etruscan"
				else if selectivePart != ""
					entry["symbol"]["scriptAdditive"] := selectiveMatch[1]
		}

		if StrLen(entry["options"]["fastKey"]) && RegExMatch(entry["options"]["fastKey"], "\?(.*?)$", &addGroupMatch) {
			entry["groups"].Push(entry["groups"][1] " " addGroupMatch[1])
		}

		for each in ["&data", "data"] {
			if entry.Has(each) {
				for key, value in entry[each] {
					if value is String && value != "" && InStr(value, "[i:") {
						local newValue := value

						while RegExMatch(newValue, "\[i:(.*?)\]", &varMatch) {
							local splittedVariants := StrSplit(varMatch[1], ",")
							local newValue := RegExReplace(newValue, "\[i:.*?\]", splittedVariants[entry["variantPos"]], , 1)
						}

						entry[each].Set(key, newValue)
					}
				}
			}
		}

		if entry["data"]["postfixes"].Length > 0 {
			if entry["recipe"].Length = 0 {
				entry["recipe"] := ["$"]
				for postfix in entry["data"]["postfixes"] {
					entry["recipe"][1] .= "${" postfix "}"
				}
			}

			entry["options"].Set("usesDiacritics", True)
		}

		if entry["recipe"].Length > 0 && !entry.Has("concatenated")
			entry["recipe"] := Util.ProcessConcatenation(entry["recipe"])

		if entry.Has("concatenated")
			entry.Delete("concatenated")

		this.ProcessReference(&entry)
		this.ProcessSymbolLetter(&entry)
		this.ProcessOptionStrings(&entry)

		return
	}

	EntryPostProcessing(&entryName, &entry, &instances) {
		if !IsSet(entry)
			return

		if entry["result"].Length > 0
			entry["unicode"] := Util.ChrToUnicode(SubStr(entry["result"][1], 1, 1))


		if instances.ChrBlock.GetBlock(entry["unicode"], , &block) && block.name != "Unknown"
			entry["unicodeBlock"] := block.block "`n" block.name

		local character := Util.UnicodeToChar(entry["unicode"])
		local characterSequence := Util.UnicodeToChar(entry["sequence"].Length > 0 ? entry["sequence"] : entry["unicode"])


		this.EntryPostProcessing__Alterations(&entryName, &entry)
		this.EntryPostProcessing__AltCodes(&entryName, &entry, &character)
		this.EntryPostProcessing__Sequence(&entryName, &entry, &character)


		for key, value in entry["options"] {
			if key ~= "i)^telex__" && value != "" {
				local TELEXName := RegExReplace(key, "i)^telex__")
				TELEXName := StrReplace(TELEXName, "_", " ")
				TELEXName := StrTitle(TELEXName)

				entry["groups"].push("TELEX/VNI " TELEXName)

				TELEXName := unset
			}
		}

		for each in ["fastKey", "specialKey", "altLayoutKey"] {
			if entry["options"].Has(each) {
				entry["options"][each] := Util.ReplaceModifierKeys(entry["options"][each])
			} else {
				entry["options"][each] := ""
			}
		}

		this.EntryPostProcessing__Customs(&entryName, &entry, &characterSequence)
		this.EntryPostProcessing__Fonts(&entryName, &entry)
		this.EntryPostProcessing__Categories(&entryName, &entry)
		this.EntryPostProcessing__Notation(&entryName, &entry)
		this.EntryPostProcessing__Recipes(&entryName, &entry)

		local generationConditions := [
			StrLen(entry["data"]["script"]) > 0 && StrLen(entry["data"]["case"]) > 0 && StrLen(entry["data"]["letter"]) > 0,
			entry.Has("&data") && entry["&data"].Has("script") && entry["&data"].Has("case") && entry["&data"].Has("letter") && StrLen(entry["&data"]["script"]) > 0 && StrLen(entry["&data"]["case"]) > 0 && StrLen(entry["&data"]["letter"]) > 0
		]

		if generationConditions[1] || generationConditions[2]
			entry := instances.LocaleGenerator.Generate(entryName, entry, generationConditions[2] ? "&data" : "data")


		this.EntryPostProcessing__LaTeX(&entryName, &entry, &instances, &character)


		ChrLib.entries.%entryName% := entry
		return
	}

	EntryPostProcessing__Alterations(&entryName, &entry) {
		for alteration, value in entry["alterations"] {
			if !InStr(alteration, "Entity") {
				local entity := Util.CheckEntity(Util.UnicodeToChar(value))
				if entity
					entry["alterations"][alteration "Entity"] := entity
			}
		}
		return
	}

	EntryPostProcessing__AltCodes(&entryName, &entry, &character) {
		if entry["altCode"].Length = 0 && !entry["options"]["preventAltCode"] {
			local altOutput := []

			for i, page in CodePagesStore.pages {
				local code := Number(CodePagesStore.GetAltCode(character, page))


				if code is Number && code <= 255 && code >= 0 && !altOutput.HasValue(code) {
					altOutput.Push((page >= 1251 ? "0" : "") code)
					entry["altCodePages"].Push(page)
				} else if altOutput.HasValue(code) {
					entry["altCodePages"].Push(page)
				}
			}

			entry["altCode"] := altOutput

			if entry["altCode"].Length = 0 {
				for char, code in characters.supplementaryData["Alt Codes"] {
					if char = character {
						entry["altCode"] := [code]
						entry["altCodePages"] := [437]
						break
					}
				}
			}
		}
		return
	}

	EntryPostProcessing__Sequence(&entryName, &entry, &character) {
		if entry["sequence"].Length > 1 {
			local entityOutput := ""
			local foundNamedEntity := False

			for each in entry["sequence"] {
				local sequenceCharacter := Util.UnicodeToChar(each)
				local entity := Util.CheckEntity(sequenceCharacter)

				if entity {
					foundNamedEntity := True
					entityOutput .= entity
				} else
					entityOutput .= Util.StrToHTML(sequenceCharacter)
			}

			if foundNamedEntity
				entry["entity"] := entityOutput
		} else {

			for char, htmlCode in characters.supplementaryData["HTML Named Entities"] {
				if char == character {
					entry["entity"] := htmlCode
					break
				}
			}
		}

		return
	}

	EntryPostProcessing__Customs(&entryName, &entry, &characterSequence) {
		entry["symbol"]["set"] := characterSequence

		local hasSet := StrLen(entry["symbol"]["set"]) > 0
		local hasCustoms := StrLen(entry["symbol"]["customs"]) > 0
		local hasFont := StrLen(entry["symbol"]["font"]) > 0

		if StrLen(entry["symbol"]["category"]) > 0 {
			local category := entry["symbol"]["category"]

			entry["symbol"]["set"] := (category = "Diacritic Mark" ? Chr(0x25CC) characterSequence : characterSequence)
			if category = "Diacritic Mark" {
				if !hasCustoms
					entry["symbol"]["customs"] := "s72"
				if !hasFont
					entry["symbol"]["font"] := "Cambria"
			} else if category = "Spaces" && !hasCustoms {
				entry["symbol"]["customs"] := "underline"
			}
		} else {
			entry["symbol"]["category"] := "N/A"
			if !hasSet
				entry["symbol"]["set"] := characterSequence
		}
		return
	}

	EntryPostProcessing__Fonts(&entryName, &entry) {
		for fontName, scriptArrays in characters.fontAssignation {
			if entry["symbol"]["font"] != ""
				break
			if scriptArrays.HasRegEx(entry["data"]["script"] != "" ? entry["data"]["script"] : entryName) {
				entry["symbol"]["font"] := fontName
				break
			}
		}
		return
	}

	EntryPostProcessing__Categories(&entryName, &entry) {
		if entry["groups"].Length = 0
			entry["groups"] := ["Default Group"]

		for each in entry["groups"] {
			if !ChrLib.entryGroups.Has(each)
				ChrLib.entryGroups.Set(each, [])

			if !ChrLib.entryGroups.Get(each).HasValue(entryName)
				ChrLib.entryGroups[each].Push(entryName)
		}

		if !ChrLib.entryCategories.Has(entry["symbol"]["category"])
			ChrLib.entryCategories.Set(entry["symbol"]["category"], [])

		if !ChrLib.entryCategories.Get(entry["symbol"]["category"]).HasValue(entryName)
			ChrLib.entryCategories[entry["symbol"]["category"]].Push(entryName)

		for eachTagArray in [entry["tags"], entry["hiddenTags"]] {
			if eachTagArray.Length > 0 {
				for tag in eachTagArray {
					if tag != "" {
						if !ChrLib.entryTags.Has(tag)
							ChrLib.entryTags.Set(tag, [])

						ChrLib.entryTags[tag].Push(entryName)
					}
				}
			}
		}
		return
	}

	EntryPostProcessing__Notation(&entryName, &entry) {
		local dataLetter := StrLen(entry["symbol"]["letter"]) > 0 ? entry["symbol"]["letter"] : entry["data"]["letter"]
		local dataPack := entry["data"]
		dataPack["dataLetter"] := dataLetter

		if StrLen(entry["data"]["letter"]) > 0 {
			if entry["recipe"].Length > 0 {
				for i, recipe in entry["recipe"] {
					entry["recipe"][i] := RegExReplace(recipe, "\~", SubStr(entry["data"]["letter"], 1, 1))
					entry["recipe"][i] := RegExReplace(recipe, "\$(?![{(])", dataLetter)
				}
			}
		}

		local toNotate := ["fastKey", "altLayoutKey", "altSpecialKey"]

		for key, value in entry["options"]
			if toNotate.HasValue(key) || key ~= "i)^telex__"
				entry["options"][key] := ChrReg.SetNotaion(&value, &dataPack)
		return
	}

	EntryPostProcessing__Recipes(&entryName, &entry) {
		if entry["recipe"].Length > 0 {
			for recipe in entry["recipe"] {
				if !ChrLib.entryRecipes.Has(recipe) {
					ChrLib.entryRecipes.Set(
						recipe, {
							chr: Util.UnicodeToChar(entry["sequence"].Length > 0 ? entry["sequence"] : entry["unicode"]),
							index: entry["index"],
							name: entryName
						})
				} else if ChrLib.entryRecipes.Has(recipe) && entryName != ChrLib.entryRecipes[recipe].name {
					if !ChrLib.duplicatesList.Has(recipe)
						ChrLib.duplicatesList.Set(recipe, [ChrLib.entryRecipes[recipe].name " -> "])
					ChrLib.duplicatesList[recipe].Push(entryName)
				}
			}
		}

		if entry["recipeAlt"].Length = 0 && entry["recipe"].Length > 0 {
			entry["recipeAlt"] := entry["recipe"].Clone()

			for diacriticName in ChrLib.entryCategories["Diacritic Mark"] {
				local diacriticChr := Util.UnicodeToChar(ChrLib.entries.%diacriticName%["unicode"])
				for i, altRecipe in entry["recipeAlt"] {
					if InStr(altRecipe, diacriticChr) {
						entry["recipeAlt"][i] := RegExReplace(altRecipe, diacriticChr, DottedCircle diacriticChr)
					}
				}
			}

			for i, aR in entry["recipeAlt"] {
				entry["recipeAlt"][i] := RegExReplace(aR, DottedCircle DottedCircle, DottedCircle)
				for eachReplace in ChrReg.recipeAltReplaces {
					if RegExMatch(entry["recipeAlt"][i], eachReplace[1], &match) {
						entry["recipeAlt"][i] := RegExReplace(entry["recipeAlt"][i], eachReplace[1], eachReplace[2])
					}
				}
			}

		}

		return
	}

	EntryPostProcessing__LaTeX(&entryName, &entry, &instances, &character) {
		if characters.supplementaryData["LaTeX Commands"].Has(character) && entry["LaTeX"].Length = 0 {
			local code := characters.supplementaryData["LaTeX Commands"][character]

			if code is String
				entry["LaTeX"] := [code]
			else if code is Array && code.Length = 1 && code[1] is Array
				entry["LaTeX"] := [code[1][1]]
			else if code is Array && code.Length > 1
				entry["LaTeX"] := code.Clone()
		}

		if entry["data"]["postfixes"].Length = 1 && !entry["options"]["preventLaTeX"] {
			local postfixEntry := ChrLib.GetEntry(entry["data"]["postfixes"][1])
			local originSymbolEntry := ChrLib.GetEntry(RegExReplace(entryName, "i)^(.*?)__(.*)$", "$1"))
			if postfixEntry {
				postfixSymbol := Util.UnicodeToChar(postfixEntry["unicode"])

				local originLTXLen := originSymbolEntry ? originSymbolEntry["LaTeX"].Length : 0
				local postfixLTXLen := postfixEntry["LaTeX"].Length
				local isDigraphOrLigature := Util.InStr(entry["symbol"]["category"], ["dig", "lig"]) && entry["recipe"].Length > 1 ? entry["recipe"][2] : entry["recipe"][1]

				local symbolForLaTeX := RegExReplace(isDigraphOrLigature, postfixSymbol)
				local setLaTeX := (lpox := 1, epos := 1) => postfixEntry["LaTeX"][lpox] "{" (originLTXLen > 0 ? originSymbolEntry["LaTeX"][epos] : symbolForLaTeX) "}"

				if postfixLTXLen > 0
					entry["LaTeX"] := [setLaTeX()]

				if postfixLTXLen = 2
					entry["LaTeX"].Push(setLaTeX(postfixLTXLen, originLTXLen))
			}

		}
	}

	static SetNotaion(&str, &data) {
		static notationKey := (m) => Chrs(0x29FC, 0x202F) m Chrs(0x202F, 0x29FD)

		local output := str

		if StrLen(data["letter"]) > 0 {
			output := RegExReplace(output, "\$(?![{(])", data["dataLetter"])
			output := RegExReplace(output, "\~", SubStr(data["letter"], 1, 1))
			output := RegExReplace(output, "\?(.*?)$")
		}

		if StrLen(data["case"]) > 0 {
			while RegExMatch(output, "\/(.*?)\/", &match) {
				output := RegExReplace(output, RegExEscape(match[0]), ["capital", "neutral"].HasValue(data["case"]) ? Util.StrUpper(match[1], 1) : Util.StrLower(match[1], 1))
			}

			while RegExMatch(output, "\\(.*?)\\", &match) {
				output := RegExReplace(output, RegExEscape(match[0]), ["capital", "neutral"].HasValue(data["case"]) ? StrUpper((match[1])) : StrLower(match[1]))
			}
		}

		output := RegExReplace(output, "([.])(\s|$|\?)", notationKey("$1"))
		static replaces := ["[", "]", "(", ")", "!", "@"]
		for replace in replaces {
			output := StrReplace(output, replace, notationKey(replace))
		}
		while RegExMatch(output, "([a-zA-Zа-яА-ЯёЁ0-9<>``,\'\`";\~\%\-\=\\/]+|[\x{2190}-\x{2195}]+|[\x{0100}-\x{017F}]+|[\x{0080}-\x{00FF}]+|[\x{1E00}-\x{1EFF}]+|[\x{0370}-\x{03FF}\x{1F00}-\x{1FFF}]+)(\s|$|\?|,\s)", &match) {
			output := RegExReplace(output, RegExEscape(match[1]), notationKey(match[1]))
		}

		return output
	}


	NameDecompose(&entryName) {
		local decomposedName := ChrLib.decompositionAttributes.DeepClone()

		local altInputScript := ""
		local foundScript := False

		for key, value in decomposedName["script"] {
			if entryName ~= "^" key "_" {
				foundScript := True
				break
			}
		}

		if !foundScript && ChrLib.scriptsValidator.HasRegEx(entryName, &i, ["^", "_"]) {
			foundScript := True
			altInputScript := ChrLib.scriptsValidator[i]
		}

		if !foundScript
			return entryName

		for key, value in decomposedName["case"] {
			if !RegExMatch(entryName, "i)_" key "_") {
				foundScript := False
			} else {
				foundScript := True
				break
			}
		}

		if !foundScript
			return entryName

		for key, value in decomposedName["type"] {
			if !RegExMatch(entryName, "i)_" key "_") {
				foundScript := False
			} else {
				foundScript := True
				break
			}
		}

		if !foundScript {
			decomposedName := Map()
			return entryName
		} else {
			local regEx := InStr(altInputScript, "_")
				? "i)^(" altInputScript ")_([\w]+(?:_[\w]+){2,})_?"
				: "i)^([\w]+(?:_[\w]+){3,})_?"

			if RegExMatch(entryName, regEx, &rawMatch) {
				local rawCharacterName := StrSplit(rawMatch[InStr(altInputScript, "_") ? 2 : 1], "_")
				local shift := InStr(altInputScript, "_") ? 1 : 0

				decomposedName["script"] := altInputScript != "" ? altInputScript : decomposedName["script"][rawCharacterName[1]]
				decomposedName["originScript"] := altInputScript != "" ? altInputScript : rawCharacterName[1]
				decomposedName["case"] := decomposedName["case"][rawCharacterName[2 - shift]]
				decomposedName["type"] := decomposedName["type"][rawCharacterName[3 - shift]]
				decomposedName["letter"] := (["capital", "small_capital", "neutral"].HasValue(decomposedName["case"]) ? StrUpper(rawCharacterName[4 - shift]) : rawCharacterName[4 - shift])

				local letterIndex := 4 - shift
				local pattern := "i)^(?:[^_]+_){" (letterIndex - 1) "}[^_]+_([^_]+(?:_[^_]+)*)(?:__|$)"
				local endPartSet := RegExMatch(entryName, pattern, &m) ? m[1] : ""
				decomposedName["endPart"] := endPartSet

				local diacriticSet := InStr(entryName, "__") ? RegExReplace(entryName, "i)^.*?__(.*)", "$1") : ""
				decomposedName["postfixes"] := StrLen(diacriticSet) > 0 ? StrSplit(diacriticSet, "__") : []

				return decomposedName
			} else {
				decomposedName := {}
				return entryName
			}
		}
		return
	}

	SetDecomposedData(&entryName, &entry) {
		local decomposedName := this.NameDecompose(&entryName)

		if decomposedName == entryName {
			entry["data"] := Map(
				"script", "",
				"originScript", "",
				"case", "",
				"type", "",
				"letter", "",
				"endPart", "",
				"postfixes", [],
				"variant", ""
			)
			decomposedName := Map()
			return entry
		} else {
			entry["data"] := decomposedName
			decomposedName := Map()
			return entry
		}
		return
	}
}