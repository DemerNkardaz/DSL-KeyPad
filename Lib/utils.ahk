Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })
Map.Prototype.DefineProp("Keys", { Call: _MapKeys })
Object.Prototype.DefineProp("MaxIndex", { Call: _ObjMaxIndex })

_ObjMaxIndex(this) {
	indexes := 0
	for k, v in this.OwnProps() {
		indexes++
	}

	return indexes
}

_ArrayMaxIndex(this) {
	indexes := 0
	for i, v in this {
		indexes++
	}

	return indexes
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
