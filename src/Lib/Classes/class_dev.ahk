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

			if DirExist(srcPath "\Mods")
				DirDelete(srcPath "\Mods", True)
			if DirExist(srcPath "\Data\Dumps")
				DirDelete(srcPath "\Data\Dumps", True)
			if DirExist(srcPath "\Logs")
				DirDelete(srcPath "\Logs", True)
			if DirExist(srcPath "\User")
				DirDelete(srcPath "\User", True)
			if FileExist(srcPath "\Bin\DSLKeyPad_App_Icons.dll")
				FileDelete(srcPath "\Bin\DSLKeyPad_App_Icons.dll")
			if FileExist(srcPath "\DSLKeyPad.exe")
				FileDelete(srcPath "\DSLKeyPad.exe")
		}
	}

	static CreateWorkflowScript() {
		path := App.paths.dir "\workflow.ps1"
		version := App.Ver("+hotfix+postfix")
		isPre := App.Ver(["pre-release"]) = "1"
		status := StrLen(App.Title(["status"])) > 0 ? " " App.Title(["status"]) : ""

		downloadLink := App.URL "/releases/download/" version "/DSL-KeyPad-" version ".zip"
		releasesArray := Update.ChekVersions()
		if releasesArray is Integer
			return MsgBox("Check versions failed")

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

		fontsArray := [
			"Noto Color Emoji",
			"Carian",
			"Caucasian Albanian",
			"Cypriot",
			"Deseret",
			"Elbasan",
			"Glagolitic",
			"Gothic",
			"Imperial Aramaic",
			"Inscriptional Parthian",
			"Linear A",
			"Linear B",
			"Lycian",
			"Lydian",
			"Mandaic",
			"Manichaean",
			"Math",
			"Old Hungarian",
			"Old Italic",
			"Old North Arabian",
			"Old Permic",
			"Old Persian",
			"Old Sogdian",
			"Old South Arabian",
			"Old Turkic",
			"Osmanya",
			"Palmyrene",
			"Phoenician",
			"Runic",
			"Samaritan",
			"Shavian",
			"Sidetic",
			"Sogdian",
			"Tifinagh",
			"Ugaritic",
			"Yi",
			"Noto Serif Vithkuqi",
			"Noto Serif Todhri",
		]

		for i, font in fontsArray {
			if !(font ~= "i)^Noto")
				fontsArray[i] := "Noto Sans " font
			fontsArray[i] := '						<li><a href="https://fonts.google.com/specimen/' RegExReplace(fontsArray[i], "\s", "+") '">' fontsArray[i] '</a></li>`n'
		}

		messageParts := (
			'&#128230;&emsp14;Automatically created/updated via build process in workflow.<br>`n`n'
			'<table>`n'
			'		<tr>`n'
			'			<td><b>Stamp</b></td>`n'
			'			<td>`n'
			'				&#128228;&emsp14;' Util.Date.formatted '`n'
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
			'				<img src="https://www.autohotkey.com/favicon.ico" width="16">&emsp14;<a href="https://www.autohotkey.com/download/ahk-v2.exe">AutoHotkey v2.^</a><br>`n'
			'				Windows 10/11 x64`n'
			'			</td>`n'
			'		</tr>`n'
			'		<tr>`n'
			'			<td><b>Additional</b></td>`n'
			'			<td>`n'
			'				<img src="https://www.gstatic.com/images/icons/material/apps/fonts/1x/catalog/v5/favicon.svg" width="16">&emsp14;<a href="https://fonts.google.com/?query=noto">Noto fonts (search)</a><br>`n'
			'				<img src="https://www.kurinto.com/favicon.ico" width="16">&emsp14;<a href="https://www.kurinto.com/download.htm">Kurinto fonts</a><br>`n'
			'				&emsp;&emsp14;&hairsp;<a href="https://catrinity-font.de">Catrinity font</a><br>`n'
			'				&emsp;&emsp14;&hairsp;<a href="https://www.babelstone.co.uk/Fonts/Han.html">BabelStone Han</a>`n'
			'				<details>`n'
			'					<summary>Recommended font list</summary>`n'
			'					<ul>`n'
			'						<li><a href="https://fonts.google.com/specimen/Noto+Serif">Noto Serif</a> <i>Required</i></li>`n'
			'						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Symbols">Noto Sans Symbols</a> <i>Required</i></li>`n'
			'						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Symbols+2">Noto Sans Symbols 2</a> <i>Important</i></li>`n'
			'						<li><a href="https://fonts.google.com/specimen/Noto+Sans">Noto Sans</a> <i>Required</i></li>`n'
			fontsArray.ToString("")
			'					</ul>`n'
			'				</details>`n'
			'			</td>`n'
			'		</tr>`n'
			'</table>`n`n'
			versionCompare '[Changelog](' App.branch["main"] '/CHANGELOG.md) | [Features Kanban](https://github.com/users/DemerNkardaz/projects/2) | [Customization Stuff](' App.URL '-Customization-Stuff) | [Docs](https://demernkardaz.github.io/DSL-KeyPad-Docs)`n`n'
			'[Yalla Nkardaz’s custom files](' App.URL '-Custom-Files) repository for DSL KeyPad.`n<br>'
			'[![Downloads GitHub](https://img.shields.io/github/downloads/DemerNkardaz/DSL-KeyPad/DSL-KeyPad-' version '.zip?logo=github&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/' version ') [![Downloads SourceForge](https://img.shields.io/sourceforge/dt/dsl-keypad/' version '?logo=sourceforge&color=yellow)](https://sourceforge.net/projects/dsl-keypad/files/' version '/)'
		)

		body := (
			'$ver = "' version '"`n'
			'$preRelease = "' (isPre ? "True" : "False") '"`n'
			'$title = "DSL KeyPad@' RegExReplace(version, "i)(\d+\.\d+\.\d+\.\d+).*", "$1") status '"`n'
			'$message =@"`n' messageParts '`n"@`n`n'
			'Write-Host "Version: $ver"`n'
			'Write-Host "Pre-release: $preRelease"`n'
			'Write-Host "Release message:`n$message"`n`n'
			'& "$PSScriptRoot/build_executable.cmd"`n'
			'& "$PSScriptRoot/Bin/build_icons_dll.cmd"`n`n'
			'& "$PSScriptRoot/Lib/powershell/pack_bundle.ps1" -FolderPath "$PSScriptRoot" -Version $ver -SleepingDuration 0`n`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/version", $ver, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/prerelease", $preRelease, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/latest", $makeLatest, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/title", $title, [System.Text.Encoding]::UTF8)`n'
			'[System.IO.File]::WriteAllText("$PSScriptRoot/message", $message, [System.Text.Encoding]::UTF8)`n'
		)

		if FileExist(path)
			FileDelete(path)
		FileAppend(body, path, "UTF-8")
	}

}