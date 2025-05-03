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
		path := App.paths.dir "\workflow.ps1"
		ver := App.Ver("+hotfix+postfix")
		isPre := App.Ver(["pre-release"]) = "1"
		isLatest := App.Ver(["latest"]) = "1"
		status := StrLen(App.Title(["status"])) > 0 ? " — " App.Title(["status"]) : ""

		body := (
			'$ver = "' ver '"`n'
			'$preRelease = "' (isPre ? "True" : "False") '"`n'
			'$makeLatest = "' (isLatest ? "True" : "False") '"`n'
			'$title = "DSL KeyPad — V[' ver ']' status '"`n'
			'$message = "Release with tag ' ver ' automatically created or updated via workflow :: [Stamp :: ' Util.GetDate("YYYY-MM-DD hh:mm:ss") ']<br><br>[Yalla Nkardaz’s custom files](https://github.com/DemerNkardaz/DSL-KeyPad-Custom-Files) repository for DSL KeyPad."`n`n'
			'Write-Host "Version: $ver"`n'
			'Write-Host "Pre-release: $preRelease"`n'
			'Write-Host "Release message:`n$message"`n`n'
			'& "./build_executable.cmd"`n'
			'& "./Bin/build_icons_dll.cmd"`n`n'
			'& "$PSScriptRoot/Lib/powershell/pack_bundle.ps1" -FolderPath "$PSScriptRoot" -Version $ver -SleepingDuration 0`n`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/version", $ver, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/prerelease", $preRelease, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/latest", $makeLatest, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/title", $title, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/message", $message, [System.Text.Encoding]::UTF8)'
		)

		if FileExist(path)
			FileDelete(path)
		FileAppend(body, path, "UTF-8")
	}

}