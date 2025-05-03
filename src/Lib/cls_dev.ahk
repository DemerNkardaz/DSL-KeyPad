Class Dev {
	static SetSrc() {
		gitPath := Cfg.Get("Git_Path", "Dev")
		srcPath := gitPath "\src"

		this.CreateWorkflowScript()

		if StrLen(gitPath) > 0 && RegExMatch(gitPath, "i)^[a-z]:\\") {
			DirCopy(App.paths.dir, srcPath, True)

			for path in [srcPath, srcPath "\Bin"] {
				Loop Files, path "\*.*" {
					if StrUpper(A_LoopFileExt) ~= "EXE|DLL"
						FileDelete(A_LoopFileFullPath)
				}
			}
		}
	}

	static CreateWorkflowScript() {
		path := App.paths.dir "\workflow.cmd"
		ver := App.Ver("+hotfix+postfix")

		body := (
			'@echo off`n'
			'set ver=' ver '`n'
			'set preRelease=' (App.Ver(["pre-release"]) = "1" ? "True" : "False") '`n'
			'set message=Release with tag ' ver ' automatically created via workflow`n'
			'`n'
			'echo %message%`n'
			'call build_executable.cmd`n'
			'call Bin\\build_icons_dll.cmd`n'
			'powershell -ExecutionPolicy Bypass -File %~dp0\\Lib\\powershell\\pack_bundle.ps1 -FolderPath %~dp0 -Version "%ver%"`n'
		)


		if FileExist(path)
			FileDelete(path)
		FileAppend(body, path)
	}
}