GetUnicodeName(char) {
	char := SubStr(char, 1, 1)
	scriptPath := A_ScriptDir "\Lib\.py\unicodeName.py"
	labelPath := App.paths.temp "\uniName.txt"

	RunWait("python " StrReplace(scriptPath, " ", "`` ") " " char " " StrReplace(App.paths.temp, " ", "`` "), , "Hide")

	result := FileRead(labelPath, "UTF-8")

	if FileExist(labelPath)
		FileDelete(labelPath)
	return result
}


SendCharToPy2(Mode := "") {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	Sleep 120
	PromptValue := A_Clipboard

	if (PromptValue != "") {
		PromptValue := GetUnicodeName(PromptValue)
		Sleep 50
		if (Mode == "Copy") {
			A_Clipboard := PromptValue
			return
		} else {
			SendText(PromptValue)
		}
	}

	A_Clipboard := BackupClipboard
}
SendCharToPy(Mode := "") {
	ClipSendProcessed(GetUnicodeName, Mode == "Copy")
}