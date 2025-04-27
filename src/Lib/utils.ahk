Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })
Array.Prototype.DefineProp("ToFlat", { Call: _ArrayToFlat })
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })
Array.Prototype.DefineProp("Contains", { Call: _ArrayContains })
Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })
Array.Prototype.DefineProp("RemoveValue", { Call: _ArrayRemoveValue })
Array.Prototype.DefineProp("SortLen", { Call: _ArraySortLen })
Array.Prototype.DefineProp("MergeWith", { Call: _ArrayMergeWith })
Map.Prototype.DefineProp("Keys", { Call: _MapKeys })
Map.Prototype.DefineProp("ToArray", { Call: _MapToArray })
Map.Prototype.DefineProp("MergeWith", { Call: _MapMergeWith })
Map.Prototype.DefineProp("DeepClone", { Call: _MapDeepClone })
Object.Prototype.DefineProp("MaxIndex", { Call: _ObjMaxIndex })

_ObjMaxIndex(this) {
	indexes := 0
	for k, v in this.OwnProps() {
		indexes++
	}

	return indexes
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
	static specialChars := "\.-*+?^${}()[]|/"

	newStr := ""
	for k, char in StrSplit(str) {
		if InStr(specialChars, char) {
			newStr .= "\" char
		} else {
			newStr .= char
		}
	}
	return newStr
}

_MapKeys(this) {
	keys := []
	for k, v in this {
		keys.Push(k)
	}
	return keys
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
		if IsObject(value) && value is Map
			result[key] := value.DeepClone()
		else
			result[key] := value
	}
	return result
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
;CodesToAHK(entities_list, chr_entities)
;CodesToAHK(alt_codes_list, chr_alt_codes)
