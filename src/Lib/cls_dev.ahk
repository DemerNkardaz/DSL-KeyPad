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
		version := App.Ver("+hotfix+postfix")
		isPre := App.Ver(["pre-release"]) = "1"
		status := StrLen(App.Title(["status"])) > 0 ? " — " App.Title(["status"]) : ""

		downloadLink := App.URL "/releases/download/" version "/DSL-KeyPad-" version ".zip"
		releasesArray := Update.ChekVersions()

		previousVersion := releasesArray.Length = 1 ? version : ""
		found := False

		if releasesArray.Length > 1 {
			for i, release in releasesArray {
				if release = version {
					previousVersion := releasesArray[i + 1]
					found := True
					break
				}
			}
			if !found
				previousVersion := releasesArray[1]
		}

		versionCompare := (previousVersion != version) ? '**Versions compare** [' previousVersion '&ensp;>>>&ensp;' version '](' App.URL '/compare/' previousVersion '...' version '#files_bucket) | ' : ""

		messageParts := (
			'Automatically created/updated via build process in workflow.<br>`n`n'
			'<table>`n'
			'		<tr>`n'
			'			<td><b>Stamp</b></td>`n'
			'			<td>`n'
			'				' Util.GetDate("YYYY-MM-DD hh:mm:ss") '`n'
			'			</td>`n'
			'		</tr>`n'
			'		<tr>`n'
			'			<td><b>Version</b></td>`n'
			'			<td>`n'
			'				&#128229;&emsp14;<a href="' downloadLink '">' version '</a>`n'
			'			</td>`n'
			'		</tr>`n'
			'		<tr>`n'
			'			<td><b>Requirements</b></td>`n'
			'			<td>`n'
			'				<img src="https://www.autohotkey.com/favicon.ico" width="16" style="vertical-align:middle;">&emsp14;<a href="https://www.autohotkey.com/download/ahk-v2.exe">AutoHotkey v2.^</a>`n'
			'			</td>`n'
			'		</tr>`n'
			'</table>`n`n'
			versionCompare '[Changelog](' App.URL '/tree/main/CHANGELOG.md)`n`n'
			'[Yalla Nkardaz’s custom files](' App.URL '-Custom-Files) repository for DSL KeyPad.`n'
		)

		body := (
			'$ver = "' version '"`n'
			'$preRelease = "' (isPre ? "True" : "False") '"`n'
			'$title = "DSL KeyPad — V[' version ']' status '"`n'
			'$message =@"`n' messageParts '`n"@`n`n'
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