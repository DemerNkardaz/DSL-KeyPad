Class Search {
	static cache := Map()

	__New(action := "send") {
		this.SearchPrompt(action)
	}

	SearchPrompt(action) {
		local searchQuery := Cfg.Get("Search", "LatestPrompts", "")
		local resultObj := { result: "", prompt: "", failed: [], send: (*) => "" }
		local IB := InputBox(Locale.Read("symbol_search_prompt"), Locale.Read("symbol_search"), "w350 h110", searchQuery)
		if IB.Result = "Cancel" || IB.Value = "" || IB.Value ~= "^\s*$"
			return resultObj
		else
			searchQuery := IB.Value

		if searchQuery == "\" {
			Reload
			return resultObj
		}

		if searchQuery == "/ubuild" {
			Update.Build()
			return resultObj
		}

		if RegExMatch(searchQuery, "^\%(.*?)\%$", &match) {
			local result := VariableParser.Parse("%" match[1] "%")
			return result is String && result != "" ? MsgBox(result, App.Title(), "Iconi") : []
		} else if RegExMatch(searchQuery, "^\/(.*?)$", &match) {
			local funcRef := StrSplit(match[1], ".")
			if funcRef.Length = 1 {
				%funcRef[1]%()
			} else if funcRef.Length > 1 {
				local interRef := ""
				local objRef := ""

				for i, ref in funcRef {
					if i = 1 {
						interRef := %ref%
						objRef := interRef
					} else if i < funcRef.Length {
						interRef := interRef.%ref%
						objRef := interRef
					} else {
						local method := ref
						interRef := interRef.%method%
						interRef.Call(objRef)
					}
				}
			}
			return resultObj
		} else {

			if InStr(searchQuery, ",") {
				local tagSplit := StrSplit(searchQuery, ",")
				for tag in tagSplit {
					local interResult := this.Search(Trim(tag))
					if StrLen(interResult) = 0
						resultObj.failed.Push(tag)
					resultObj.result .= interResult
				}
			} else {
				local interResult := this.Search(searchQuery)
				if StrLen(interResult) = 0
					resultObj.failed.Push(searchQuery)
				resultObj.result := interResult
			}

			resultObj.prompt := searchQuery
			local result := resultObj.result
			local lineBreaks := result ~= "`n" || result ~= "`r"
			resultObj.send := (*) => (StrLen(result) > 20 || lineBreaks) ? Clip.Send(&result, , , "Backup & Release") : SendText(result)

			if StrLen(resultObj.result) > 0 {
				Cfg.Set(searchQuery, "Search", "LatestPrompts")
			} else {
				if resultObj.failed.Length > 0
					MsgBox(Locale.ReadInject("warning_tag_absent", [resultObj.failed.ToString()]), App.Title(), "Icon!")
			}

			return resultObj.%action%()
		}
		return
	}

	Search(searchQuery) {
		if Search.cache.Has(searchQuery)
			return Search.cache.Get(searchQuery)

		local indexedEntries := ChrLib.GetIndexedMap()
		local handledQuery := searchQuery

		local nonSensitiveMark := "i)"
		local isSensitive := SubStr(handledQuery, 1, 1) = "!"
		if isSensitive {
			handledQuery := SubStr(handledQuery, 2)
			nonSensitiveMark := ""
		}

		local alteration := RegExMatch(handledQuery, "\:\:(.*?)$", &match) ? match[1] : Scripter.selectedMode.Get("Glyph Variations")

		handledQuery := RegExReplace(handledQuery, "\:\:(.*?)$", "")

		if ChrLib.entries.HasOwnProp(handledQuery)
			return ChrLib.Get(handledQuery, True, Auxiliary.inputMode, alteration)

		local isHasExpression := RegExMatch(handledQuery, "(\^|\*|\+|\?|\.|\$|^\i\))")
		local output := ""

		checkBy32ID(&entryName) {
			if RegExMatch(handledQuery, "^#(.*)$", &IDMatch) && ChrLib.entryIdentifiers.Has(Number(IDMatch[1])) {
				entryName := ChrLib.entryIdentifiers.Get(Number(IDMatch[1]))
				return True
			}
			return False
		}

		checkTagByUserRegEx(tag) {
			tag := StrReplace(tag, Chr(0x00A0), " ")
			return tag ~= handledQuery
		}

		checkTagExact(tag) {
			tag := StrReplace(tag, Chr(0x00A0), " ")
			if isSensitive
				return handledQuery == tag
			return handledQuery = tag
		}

		checkTagPartial(tag) {
			tag := StrReplace(tag, Chr(0x00A0), " ")
			return tag ~= nonSensitiveMark handledQuery
		}

		checkTagSplittedPartial(tag, strict3 := True) {
			tag := StrReplace(tag, Chr(0x00A0), " ")
			local splitSearchQuery := StrSplit(handledQuery, " ")
			for _, part in splitSearchQuery {
				if StrLen(part) < 3 && strict3 {
					if !(tag ~= nonSensitiveMark "(\A" part "(\s|\z))|(\A|\s)" part "\z|(\A|\s)" part "(\s|\z)")
						return False
				} else {
					if !(tag ~= nonSensitiveMark part)
						return False
				}
			}
			return splitSearchQuery.Length > 0
		}

		checkTagLowAccSequental(tag) {
			tag := StrReplace(tag, Chr(0x00A0), " ")
			return Util.HasSequentialCharacters(tag, handledQuery, nonSensitiveMark = "")
		}

		checkTagLowAcc(tag) {
			tag := StrReplace(tag, Chr(0x00A0), " ")
			return Util.HasAllCharacters(tag, nonSensitiveMark handledQuery)
		}

		local conditions := [
			(tag) => (isHasExpression ? checkTagByUserRegEx(tag) : False),
			(tag) => (checkTagExact(tag)),
			(tag) => (checkTagPartial(tag) || checkTagSplittedPartial(tag)),
			(tag) => (checkTagSplittedPartial(tag, False)),
			(tag) => (checkTagLowAccSequental(tag)),
			(tag) => (checkTagLowAcc(tag)),
		]

		for i, condition in conditions {
			for j, entryName in indexedEntries {
				local entry := ChrLib.entries.%entryName%

				if checkBy32ID(&indexedEntryName) {
					output := ChrLib.Get(indexedEntryName, True, Auxiliary.inputMode, alteration)
					break 2
				}

				if entry["tags"].Length = 0
					continue

				for tag in entry["tags"]
					if conditions[i](tag) {
						output := ChrLib.Get(entryName, True, Auxiliary.inputMode, alteration)
						break 3
					}
			}
		}

		if output != ""
			Search.cache.Set(searchQuery, output)
		return output
	}
}