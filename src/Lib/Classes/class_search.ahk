Class Search {
	static cache := Map()

	static __New() {
		Event.OnEvent("Input Mode", "Changed", () => this.cache := Map())
		return
	}

	__New(action := "send") {
		return this.SearchPrompt(action)
	}

	SearchPrompt(action) {
		local searchQuery := Cfg.Get("Search", "LatestPrompts", "")
		local resultObj := { result: "", prompt: "", failed: [], send: (*) => "" }
		local IB := InputBox(Locale.Read("symbol_search.prompt"), Locale.Read("symbol_search"), "w350 h110", searchQuery)
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
			local result := VariableParser.Parse("<% " match[1] " %/>")
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
					MsgBox(Locale.ReadInject("warnings.tag_absent", [resultObj.failed.ToString()]), App.Title(), "Icon!")
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
			return ChrLib.Get(handledQuery, True, Cfg.SessionGet("Input_Mode"), alteration)

		local isHasExpression := RegExMatch(handledQuery, "(\^|\*|\+|\?|\.|\$|^\i\))")
		local output := ""

		IsExtendedVersion(shortTag, longTag) {
			if StrLen(shortTag) >= StrLen(longTag)
				return False

			shortTag := StrReplace(shortTag, Chr(0x00A0), " ")
			longTag := StrReplace(longTag, Chr(0x00A0), " ")

			local shortWords := StrSplit(shortTag, " ")
			local longWords := StrSplit(longTag, " ")

			local cleanShortWords := []
			local cleanLongWords := []

			for word in shortWords {
				if Trim(word) != ""
					cleanShortWords.Push(Trim(word))
			}

			for word in longWords {
				if Trim(word) != ""
					cleanLongWords.Push(Trim(word))
			}

			for shortWord in cleanShortWords {
				local found := False
				for longWord in cleanLongWords {
					if isSensitive ? (shortWord == longWord) : (shortWord = longWord) {
						found := True
						break
					}
				}
				if !found
					return False
			}

			local additionalWords := cleanLongWords.Length - cleanShortWords.Length
			if additionalWords < 1
				return False

			if additionalWords >= 2
				return True

			if additionalWords = 1 {
				for longWord in cleanLongWords {
					local isInShort := False
					for shortWord in cleanShortWords {
						if isSensitive ? (shortWord == longWord) : (shortWord = longWord) {
							isInShort := True
							break
						}
					}
					if !isInShort && StrLen(longWord) > 2
						return True
				}
			}

			return False
		}

		checkByID(&entryName) {
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

		checkTagSingleWord(tag) {
			if !InStr(handledQuery, " ") {
				tag := StrReplace(tag, Chr(0x00A0), " ")
				local escapedQuery := RegExEscape(handledQuery)
				return tag ~= nonSensitiveMark "^" escapedQuery "$|^" escapedQuery "\s|\s" escapedQuery "\s|\s" escapedQuery "$"
			}
			return False
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
			(tag) => (checkTagSingleWord(tag)),
			(tag) => (checkTagPartial(tag) || checkTagSplittedPartial(tag)),
			(tag) => (checkTagSplittedPartial(tag, False)),
			(tag) => (checkTagLowAccSequental(tag)),
			(tag) => (checkTagLowAcc(tag)),
		]

		for i, condition in conditions {
			local matchedTags := []

			for j, entryName in indexedEntries {
				local entry := ChrLib.entries.%entryName%

				if checkByID(&indexedEntryName) {
					output := ChrLib.Get(indexedEntryName, True, Cfg.SessionGet("Input_Mode"), alteration)
					break 2
				}

				if entry["tags"].Length = 0
					continue

				for tag in entry["tags"] {
					if conditions[i](tag) {
						local cleanTag := StrReplace(tag, Chr(0x00A0), " ")
						matchedTags.Push({
							entryName: entryName,
							tag: cleanTag,
							originalIndex: j
						})
					}
				}
			}

			if matchedTags.Length > 0 {
				local bestMatch := matchedTags[1]

				if matchedTags.Length > 1 {
					for match in matchedTags {
						if IsExtendedVersion(match.tag, bestMatch.tag)
							bestMatch := match
						else if !IsExtendedVersion(bestMatch.tag, match.tag) && match.originalIndex < bestMatch.originalIndex
							bestMatch := match
					}
				}

				output := ChrLib.Get(bestMatch.entryName, True, Cfg.SessionGet("Input_Mode"), alteration)
				break
			}
		}

		if output != ""
			Search.cache.Set(searchQuery, output)
		return output
	}
}