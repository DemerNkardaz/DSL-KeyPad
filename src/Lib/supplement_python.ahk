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



SendCharToPy(Mode := "") {
	ClipSendProcessed(GetUnicodeName, Mode == "Copy")
}