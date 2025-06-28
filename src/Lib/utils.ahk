Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })
Array.Prototype.DefineProp("ToFlat", { Call: _ArrayToFlat })
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })
Array.Prototype.DefineProp("HasRegEx", { Call: _ArrayHasRegEx })
Array.Prototype.DefineProp("Contains", { Call: _ArrayContains })
Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })
Array.Prototype.DefineProp("RemoveValue", { Call: _ArrayRemoveValue })
Array.Prototype.DefineProp("SortLen", { Call: _ArraySortLen })
Array.Prototype.DefineProp("MergeWith", { Call: _ArrayMergeWith })
Array.Prototype.DefineProp("Clear", { Call: _ArrayClear })
Array.Prototype.DefineProp("ToLower", { Call: _ArrayToLower })
Array.Prototype.DefineProp("ToUpper", { Call: _ArrayToUpper })

Map.Prototype.DefineProp("Keys", { Call: _MapKeys })
Map.Prototype.DefineProp("Values", { Call: _MapValues })
Map.Prototype.DefineProp("ToArray", { Call: _MapToArray })
Map.Prototype.DefineProp("MergeWith", { Call: _MapMergeWith })
Map.Prototype.DefineProp("DeepMergeWith", { Call: _MapDeepMergeWith })
Map.Prototype.DefineProp("DeepMergeBinds", { Call: _MapDeepMergeBinds })
Map.Prototype.DefineProp("DeepClone", { Call: _MapDeepClone })
Map.Prototype.DefineProp("GetRef", { Call: _MapGetRef })
Object.Prototype.DefineProp("MaxIndex", { Call: _ObjMaxIndex })
Object.Prototype.DefineProp("ObjKeys", { Call: _ObjKeys })

ObjGet(this, j) {
	local i := 0
	for k, v in this.OwnProps() {
		if i = j {
			return v
		}
		i++
	}
	return
}

_ObjMaxIndex(this) {
	return ObjOwnPropCount(this)
}

_ObjKeys(this) {
	local keys := []
	for k, v in this.OwnProps() {
		keys.Push(k)
	}
	return keys
}

_ArrayClear(this) {
	this.Length := 0
	return this
}

_ArrayMergeWith(this, arrays*) {
	for arr in arrays {
		for item in arr {
			this.Push(item)
		}
	}
	return
}

_ArrayToFlat(this) {
	local result := []
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

_ArrayToLower(this) {
	local result := []
	for item in this
		if item is String
			result.Push(StrLower(item))

	return result
}

_ArrayToUpper(this) {
	local result := []
	for item in this
		if item is String
			result.Push(StrUpper(item))

	return result
}

_ArrayToString(this, separator := ", ", bounds := "") {
	local str := ""
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
	local indexes := 0
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
	return
}

_ArraySortLen(this) {
	local sorted := this.Clone()

	for i, _ in sorted {
		for j, _ in sorted {
			if (StrLen(sorted[i]) > StrLen(sorted[j])) {
				local temp := sorted[i]
				sorted[i] := sorted[j]
				sorted[j] := temp
			}
		}
	}
	return sorted
}


ArrayMergeTo(&targetArray, Arrays*) {
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			targetArray.Push(element)
		}
	}
	return
}

ArrayMerge(Arrays*) {
	local tempArray := []
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			tempArray.Push(element)
		}
	}
	return tempArray
}

RegExEscape(str) {
	local newStr := ""
	for k, char in StrSplit(str) {
		if InStr(regExChars, char) {
			newStr .= "\" char
		} else {
			newStr .= char
		}
	}
	return newStr
}

_MapKeys(this, t := "k", names?) {
	local keys := []
	for k, v in this {
		if IsSet(names) {
			if names.HasValue(k)
				keys.Push(%t%)
		} else
			keys.Push(%t%)
	}
	return keys
}

_MapValues(this, names?) {
	return _MapKeys(this, "v", names?)
}

_MapToArray(this) {
	local arr := []
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
	local result := Map()
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
			local newKeyBase := RegExMatch(newKey, "^([^:]+)", &baseMatch) ? baseMatch[1] : newKey

			local keyToRemove := ""
			for existingKey in this {
				local existingKeyBase := RegExMatch(existingKey, "^([^:]+)", &existingBaseMatch) ? existingBaseMatch[1] : existingKey

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

_MapGetRef(this, &key, &output := "") {
	if this.Has(key)
		output := this.Get(key)
	return this.Get(key)
}

MapMergeTo(TargetMap, MapObjects*) {
	for mapObj in MapObjects {
		if !IsObject(mapObj)
			continue
		for entry, value in mapObj {
			TargetMap[entry] := value
		}
	}
	return
}

MapMerge(MapObjects*) {
	local tempMap := Map()
	for mapObj in MapObjects {
		for entry, value in mapObj {
			tempMap[entry] := value
		}
	}
	return tempMap
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
	return
}

CodesToAHK(filePath, outputFilePath := "funcOut") {
	fullPath := A_ScriptDir "\UtilityFiles\" filePath ".txt"
	outputFilePath := A_ScriptDir "\UtilityFiles\" outputFilePath ".ahk"


	local fileContent := FileRead(fullPath, "UTF-8")

	FileAppend("funcOut := [`n", outputFilePath, "UTF-8")

	for line in StrSplit(fileContent, "`n") {
		RegExMatch(line, '^(.+)\t(.+)', &match)
		local entityCode := Format("0x{1}", match[1])
		local entityName := InStr(filePath, "alt") ? match[2] : "&" match[2] ";"

		local outString := "`tChr(" entityCode "), `"" entityName "`",`n"
		FileAppend(outString, outputFilePath, "UTF-8")
	}

	FileAppend("]", outputFilePath, "UTF-8")

	fileContent := FileRead(fullPath, "UTF-8")
	return
}

Chrs(chrCodes*) {
	local output := ""

	for code in chrCodes {
		if code is Array {
			local charCode := code[1]
			local charRepeats := code.Has(2) ? code[2] : 1

			Loop charRepeats
				output .= Chr(charCode)
		} else {
			output .= Chr(code)
		}
	}

	return output
}

GetKeyScanCode() {
	local IB := InputBox("Scan code get", "Scan code", "w350 h110", "")

	if IB.Result = "Cancel"
		return
	else {
		local promptValue := IB.Value
		local scanCode := GetKeySC(promptValue)
		scanCode := Format("{:X}", scanCode)
		scanCode := StrLen(scanCode) == 1 ? "00" scanCode : StrLen(scanCode) == 2 ? "0" scanCode : scanCode
		scanCode := "SC" scanCode
		SendText(scanCode)
	}
	return
}

ContainsEmoji(StringInput) {
	static emojisPattern := "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{1F700}-\x{1F77F}\x{1F900}-\x{1F9FF}\x{2700}-\x{27BF}\x{1F1E6}-\x{1F1FF}]"
	return RegExMatch(StringInput, emojisPattern)
}

IsGuiOpen(title) {
	return WinExist(title) != 0
}

ShowInfoMessage(MessagePost, MessageIcon := "Info", MessageTitle := App.Title("+status+version"), SkipMessage := False, Mute := False, NoReadLocale := False) {
	if SkipMessage == True
		return
	local muting := Mute ? " Mute" : ""
	local ico := MessageIcon == "Info" ? "Iconi" :
		MessageIcon == "Warning" ? "Icon!" :
		MessageIcon == "Error" ? "Iconx" : 0x0
	TrayTip(NoReadLocale ? MessagePost : Locale.Read(MessagePost), MessageTitle, ico . muting)

}

Range(start, end, step := 1) {
	local result := []
	if step > 0 {
		loop (end - start + 1) // step {
			result.Push(start + (A_Index - 1) * step)
		}
	} else {
		loop (start - end + 1) // Abs(step) {
			result.Push(start + (A_Index - 1) * step)
		}
	}
	return result
}

ModPath(modName) {
	return A_ScriptDir "\Mods\" modName
}