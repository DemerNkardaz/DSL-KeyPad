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

		body := (
			'@echo off`n'
			'set ver=' App.Ver("+hotfix+postfix") '`n'
			'set preRelease=' (App.Ver(["pre-release"]) = "1" ? "True" : "False") '`n'
			'call build_executable.cmd`n'
			'call Bin\\build_icons_dll.cmd`n'
		)


		if FileExist(path)
			FileDelete(path)
		FileAppend(body, path)
	}
}