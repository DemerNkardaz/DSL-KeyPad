Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })
Map.Prototype.DefineProp("Keys", { Call: _MapKeys })

_ArrayMaxIndex(this) {
	indexes := 0
	for i, v in this {
		indexes++
	}

	return indexes
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
