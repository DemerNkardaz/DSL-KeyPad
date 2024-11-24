PowerShell_UserSID() {
	scriptPath := A_ScriptDir "\Lib\.ps\usrSID.ps1"
	idTextPath := App.paths.temp "\usrSID.txt"

	RunWait("powershell Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force; & " StrReplace(scriptPath, " ", "`` ") " -folderPath " StrReplace(App.paths.temp, " ", "`` "), , "Hide")
	result := FileRead(idTextPath, "UTF-8")

	for replaces in [" ", "`n", "`r"] {
		result := StrReplace(result, replaces)
	}

	if FileExist(idTextPath)
		FileDelete(idTextPath)
	return result
}