class SideProcess {
	static pids := Map()

	static Start(paths) {
		for path in paths {
			fullPath := FileExist(path) ? path : App.paths.sidProc "\" path ".ahk"
			if !FileExist(fullPath)
				throw Error("File not found: " fullPath)

			SplitPath(fullPath, , , , &nameNoExt)

			Run('"' fullPath '"', , , &pid)
			SideProcess.pids.Set(nameNoExt, pid)
		}
	}

	static StartDynamic(name, addContent := "", title := "", icon := "", iconIndex := 0, parentPID := 0) {
		local path := FileExist(name) ? name : App.paths.sidProc "\" name ".ahk"
		if !FileExist(path)
			throw Error("File not found: " path)

		local content := FileRead(path, "UTF-8")
		content := "#SingleInstance Force" "`n" content
		content .= (
			"`n"
			'A_IconTip := "' title '"`n'
			'TraySetIcon("' icon '", ' iconIndex ', True)`n'
			'terminateBind := Terminate.Bind()`n'
			'SetTimer(terminateBind, 2000)`n'
			'Terminate(*) {`n'
			'	if !ProcessExist(' parentPID ') {`n'
			'		FileDelete(A_ScriptFullPath)`n'
			'		ExitApp()`n'
			'	}`n'
			'}`n'
		)
		content .= "`n" addContent

		local fullPath := App.paths.temp "\" name ".ahk"
		if FileExist(fullPath)
			FileDelete(fullPath)

		FileAppend(content, fullPath, "UTF-8")

		SplitPath(fullPath, , , , &nameNoExt)

		Run('"' fullPath '"', , , &pid)
		SideProcess.pids.Set(nameNoExt, pid)
		return
	}

	static GetPID(name) {
		if !SideProcess.pids.Has(name)
			throw Error("No such side process: " name)

		return SideProcess.pids[name]
	}
}