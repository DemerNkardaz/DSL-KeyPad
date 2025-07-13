class JSONExt extends JSON {
	static Dump(obj, pretty := 0, escape := False) {
		local originalEscapeUnicode := this.lib.bEscapeUnicode
		if !escape
			this.lib.bEscapeUnicode := 0

		result := super.Dump(obj, pretty)

		if !escape
			this.lib.bEscapeUnicode := originalEscapeUnicode

		return result
	}

	static BulkLoad(dirPath, options?) {
		local foundFiles := []
		local output := []

		Loop Files dirPath "\*", "F"
			if A_LoopFileFullPath ~= "i)\.json$"
				foundFiles.Push(A_LoopFileFullPath)

		for each in foundFiles
			output.MergeWith(super.LoadFile(each, options))

		return output
	}
}


; JSONExt.BulkLoad(A_ScriptDir "\Data\characters", "UTF-8")
