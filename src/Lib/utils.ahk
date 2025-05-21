Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })
Array.Prototype.DefineProp("ToFlat", { Call: _ArrayToFlat })
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })
Array.Prototype.DefineProp("HasRegEx", { Call: _ArrayHasRegEx })
Array.Prototype.DefineProp("Contains", { Call: _ArrayContains })
Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })
Array.Prototype.DefineProp("RemoveValue", { Call: _ArrayRemoveValue })
Array.Prototype.DefineProp("SortLen", { Call: _ArraySortLen })
Array.Prototype.DefineProp("MergeWith", { Call: _ArrayMergeWith })
Map.Prototype.DefineProp("Keys", { Call: _MapKeys })
Map.Prototype.DefineProp("Values", { Call: _MapValues })
Map.Prototype.DefineProp("ToArray", { Call: _MapToArray })
Map.Prototype.DefineProp("MergeWith", { Call: _MapMergeWith })
Map.Prototype.DefineProp("DeepMergeWith", { Call: _MapDeepMergeWith })
Map.Prototype.DefineProp("DeepMergeBinds", { Call: _MapDeepMergeBinds })
Map.Prototype.DefineProp("DeepClone", { Call: _MapDeepClone })
Object.Prototype.DefineProp("MaxIndex", { Call: _ObjMaxIndex })
Object.Prototype.DefineProp("ObjKeys", { Call: _ObjKeys })

_ObjMaxIndex(this) {
	indexes := 0
	for k, v in this.OwnProps() {
		indexes++
	}

	return indexes
}

_ObjKeys(this) {
	keys := []
	for k, v in this.OwnProps() {
		keys.Push(k)
	}
	return keys
}

_ArrayMergeWith(this, arrays*) {
	for arr in arrays {
		for item in arr {
			this.Push(item)
		}
	}
}

_ArrayToFlat(this) {
	result := []
	for item in this {
		if item is Array {
			for subItem in item {
				result.Push(subItem)
			}
		} else {
			result.Push(item)
		}
	}
	return result
}

_ArrayToString(this, separator := ", ", bounds := "") {
	str := ""
	for index, value in this {
		if index = this.Length {
			if value is Array {
				str .= bounds value.ToString(separator, bounds) bounds
			} else {
				str .= bounds value bounds
			}
			break
		}
		if value is Array {
			str .= bounds value.ToString(separator, bounds) bounds separator
		} else {
			str .= bounds value bounds separator
		}
	}
	return str
}

_ArrayHasValue(this, valueToFind, &indexID?) {
	for index, value in this {
		if value = valueToFind {
			indexID := index
			return true
		}
	}
	return false
}

_ArrayHasRegEx(this, valueToFind, &indexID?, boundRegEx := [], skipValues := []) {
	for index, value in this {
		if skipValues.Length > 0 && skipValues.HasValue(value) {
			continue
		} else if value is String && (value = valueToFind ||
			(valueToFind ~= "[" RegExEscape(regExChars) "]" && value ~= valueToFind) ||
			(value ~= "[" RegExEscape(regExChars) "]" && valueToFind ~= value) ||
			boundRegEx.Length = 2 && valueToFind ~= boundRegEx[1] value boundRegEx[2]
		) {
			indexID := index
			return true
		}
	}
	return false
}


_ArrayContains(this, valueToFind, &indexID?) {
	for index, value in this {
		if value == valueToFind {
			indexID := index
			return true
		}
	}
	return false
}

_ArrayMaxIndex(this) {
	indexes := 0
	for i, v in this {
		indexes++
	}

	return indexes
}

_ArrayRemoveValue(this, valueToRemove) {
	for index, value in this {
		if value = valueToRemove {
			this.RemoveAt(index)
			break
		}
	}
}

_ArraySortLen(this) {
	sorted := this.Clone()

	for i, _ in sorted {
		for j, _ in sorted {
			if (StrLen(sorted[i]) > StrLen(sorted[j])) {
				temp := sorted[i]
				sorted[i] := sorted[j]
				sorted[j] := temp
			}
		}
	}
	return sorted
}


ArrayMergeTo(TargetArray, Arrays*) {
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			TargetArray.Push(element)
		}
	}
}

ArrayMerge(Arrays*) {
	TempArray := []
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			TempArray.Push(element)
		}
	}
	return TempArray
}

RegExEscape(str) {
	newStr := ""
	for k, char in StrSplit(str) {
		if InStr(regExChars, char) {
			newStr .= "\" char
		} else {
			newStr .= char
		}
	}
	return newStr
}

_MapKeys(this, t := "k") {
	keys := []
	for k, v in this {
		keys.Push(%t%)
	}
	return keys
}

_MapValues(this) {
	return _MapKeys(this, "v")
}

_MapToArray(this) {
	arr := []
	for k, v in this {
		arr.Push(k, v)
	}
	return arr
}

_MapMergeWith(this, maps*) {
	for mapIdx, mapToMerge in maps {
		for key, val in mapToMerge {
			if this.Has(key) && this[key] is Map {
				this[key].MergeWith(val)
			} else {
				this.Set(key, val)
			}
		}
	}
	return this
}

_MapDeepClone(this) {
	result := Map()
	for key, value in this {
		if value is Map
			result[key] := value.DeepClone()
		else
			result[key] := value
	}
	return result
}

_MapDeepMergeWith(this, maps*) {
	for mapIdx, mapToMerge in maps {
		if mapToMerge.Count = 0
			continue

		for key, val in mapToMerge {
			if this.Has(key) && this[key] is Map {
				this[key].DeepMergeWith(val)
			} else {
				this.Set(key, val)
			}
		}
	}
	return this
}

_MapDeepMergeBinds(this, maps*) {
	for mapIdx, mapToMerge in maps {
		if mapToMerge.Count = 0
			continue
		for newKey, newVal in mapToMerge {
			newKeyBase := RegExMatch(newKey, "^([^:]+)", &baseMatch) ? baseMatch[1] : newKey

			keyToRemove := ""
			for existingKey in this {
				existingKeyBase := RegExMatch(existingKey, "^([^:]+)", &existingBaseMatch) ? existingBaseMatch[1] : existingKey

				if (existingKeyBase = newKeyBase) {
					if (InStr(newKey, ":") > 0) {
						keyToRemove := existingKey
						break
					}
				}
			}

			if (keyToRemove != "") {
				this.Delete(keyToRemove)
			}

			if this.Has(newKey) && this[newKey] is Map && newVal is Map {
				this[newKey].DeepMergeBinds(newVal)
			} else {
				this.Set(newKey, newVal)
			}
		}
	}
	return this
}

MapInsert(MapObj, Pairs*) {
	keyCount := 0
	for index in MapObj {
		keyCount++
	}

	startNumber := keyCount + 1
	numberLength := 10

	for i, pair in Pairs {
		if (Mod(i, 2) == 1) {
			try {
				key := pair
				numberStr := "0" . startNumber
				while (StrLen(numberStr) < numberLength) {
					numberStr := "0" . numberStr
				}
				formattedKey := numberStr . " " . key
				startNumber++
			} catch {
				throw Error("Failed to format key: " i " ")
			}
		} else {
			MapObj[formattedKey] := pair
		}
	}
}

MapPush(MapObj, Pairs*) {
	for i, pair in Pairs {
		if (Mod(i, 2) == 1) {
			key := pair
		} else {
			MapObj[key] := pair
		}
	}
}

MapMergeTo(TargetMap, MapObjects*) {
	for mapObj in MapObjects {
		if !IsObject(mapObj)
			continue
		for entry, value in mapObj {
			TargetMap[entry] := value
		}
	}
}

MapMerge(MapObjects*) {
	TempMap := Map()
	for mapObj in MapObjects {
		for entry, value in mapObj {
			TempMap[entry] := value
		}
	}
	return TempMap
}


RegExRemove(str, toRemove*) {
	for i, v in toRemove {
		str := RegExReplace(str, v, "")
	}
	return str
}

ClipSendProcessed(callback, noSendRestore := False, isClipReverted := True, untilRevert := 300) {
	if isClipReverted
		prevClip := ClipboardAll()

	A_Clipboard := ""
	ClipWait(1)
	Send("{Shift Down}{Delete}{Shift Up}")
	ClipWait(1)

	copyBackup := A_Clipboard

	if A_Clipboard != "" {
		A_Clipboard := callback(A_Clipboard)
	}

	if !noSendRestore {
		Send("{Shift Down}{Insert}{Shift Up}")

		if isClipReverted
			SetTimer(() => A_Clipboard := prevClip, -untilRevert)
	} else {
		SendText(copyBackup)
	}
}

CodesToAHK(filePath, outputFilePath := "funcOut") {
	fullPath := A_ScriptDir "\UtilityFiles\" filePath ".txt"
	outputFilePath := A_ScriptDir "\UtilityFiles\" outputFilePath ".ahk"


	fileContent := FileRead(fullPath, "UTF-8")

	FileAppend("funcOut := [`n", outputFilePath, "UTF-8")

	for line in StrSplit(fileContent, "`n") {
		RegExMatch(line, '^(.+)\t(.+)', &match)
		entityCode := Format("0x{1}", match[1])
		entityName := InStr(filePath, "alt") ? match[2] : "&" match[2] ";"

		outString := "`tChr(" entityCode "), `"" entityName "`",`n"
		FileAppend(outString, outputFilePath, "UTF-8")
	}

	FileAppend("]", outputFilePath, "UTF-8")

	fileContent := FileRead(fullPath, "UTF-8")
}

Chrs(chrCodes*) {
	Output := ""

	for code in chrCodes {
		if code is Array {
			charCode := code[1]
			charRepeats := code.Has(2) ? code[2] : 1

			Loop charRepeats
				Output .= Chr(charCode)
		} else {
			Output .= Chr(code)
		}
	}

	return Output
}

GetKeyScanCode() {
	IB := InputBox("Scan code get", "Scan code", "w350 h110", "")

	if IB.Result = "Cancel"
		return
	else
		PromptValue := IB.Value
	scanCode := GetKeySC(PromptValue)
	scanCode := Format("{:X}", scanCode)
	scanCode := StrLen(scanCode) == 1 ? "00" scanCode : StrLen(scanCode) == 2 ? "0" scanCode : scanCode
	scanCode := "SC" scanCode
	SendText(scanCode)
}


ReplaceWithUnicode(Mode := "") {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("{Shift Down}{Delete}{Shift Up}")
	ClipWait(0.5, 1)
	PromptValue := A_Clipboard
	A_Clipboard := ""

	if PromptValue != "" {
		Output := ""

		i := 1
		while (i <= StrLen(PromptValue)) {
			Symbol := SubStr(PromptValue, i, 1)
			Code := Ord(Symbol)
			Surrogated := Code >= 0xD800 && Code <= 0xDBFF

			if (Surrogated) {
				NextSymbol := SubStr(PromptValue, i + 1, 1)
				Symbol .= NextSymbol
				i += 1
			}

			if Mode == "Hex" {
				Output .= "0x" Util.ChrToUnicode(Symbol) " "
			} else if Mode == "CSS" {
				Output .= Surrogated ? "\u{" Util.ChrToUnicode(Symbol) "} " : "\u" Util.ChrToUnicode(Symbol) " "
			} else {
				Output .= Util.ChrToUnicode(Symbol) " "
			}

			i += 1
		}

		A_Clipboard := RegExReplace(Output, "\s$", "")
		ClipWait(0.250, 1)
		Send("{Shift Down}{Insert}{Shift Up}")
	}
	Sleep 500
	A_Clipboard := BackupClipboard

	Send("{Ctrl Up}")

	return
}

ContainsEmoji(StringInput) {
	EmojisPattern := "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{1F700}-\x{1F77F}\x{1F900}-\x{1F9FF}\x{2700}-\x{27BF}\x{1F1E6}-\x{1F1FF}]"
	return RegExMatch(StringInput, EmojisPattern)
}

IsGuiOpen(title) {
	return WinExist(title) != 0
}

ShowInfoMessage(MessagePost, MessageIcon := "Info", MessageTitle := App.Title("+status+version"), SkipMessage := False, Mute := False, NoReadLocale := False) {
	if SkipMessage == True
		return
	Muting := Mute ? " Mute" : ""
	Ico := MessageIcon == "Info" ? "Iconi" :
		MessageIcon == "Warning" ? "Icon!" :
		MessageIcon == "Error" ? "Iconx" : 0x0
	TrayTip(NoReadLocale ? MessagePost : Locale.Read(MessagePost), MessageTitle, Ico . Muting)

}