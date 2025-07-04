Class Journal {
	static path := A_ScriptDir "\Logs"

	static __New() {
		if !DirExist(this.path)
			DirCreate(this.path)
		return
	}

	__New(logName, data) {
		this.filePath := Journal.path "\" logName ".log"
		local lineCount := 0
		if FileExist(this.filePath) {
			for i, line in StrSplit(FileRead(this.filePath, "UTF-8"), "`n", "`r") {
				lineCount++
				if i > 501
					break
			}

			if (lineCount > 500)
				FileDelete(this.filePath)
		}

		data := (lineCount > 0 ? "`n`n" : "") "====  " A_YYYY "-" A_MM "-" A_DD "–" A_Hour ":" A_Min ":" A_Sec "  ====`n`n" data
		FileAppend(data, this.filePath, "UTF-8")
		return
	}
}