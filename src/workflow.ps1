$ver = "0.1.1.2-alpha-testing"
$preRelease = "True"
$title = "DSL KeyPad — V[0.1.1.2-alpha-testing] — (αλφα)"
$message =@"
Automatically created/updated via build process in workflow.<br>\n\n<table>\n		<tr>\n			<td><b>Stamp</b></td>\n			<td>\n				2025-05-03 23:36:21\n			</td>\n		</tr>\n		<tr>\n			<td><b>Version</b></td>\n			<td>\n				&#128229;&emsp14;<a href="https://github.com/DemerNkardaz/DSL-KeyPad/releases/download/0.1.1.2-alpha-testing/DSL-KeyPad-0.1.1.2-alpha-testing.zip">0.1.1.2-alpha-testing</a>\n			</td>\n		</tr>\n		<tr>\n			<td><b>Requirements</b></td>\n			<td>\n				<img src="https://www.autohotkey.com/favicon.ico" width="16" style="vertical-align:middle;">&emsp14;<a href="https://www.autohotkey.com/download/ahk-v2.exe">AutoHotkey v2.^</a>\n			</td>\n		</tr>\n</table>\n\n**Versions compare** [0.1.1.1-alpha-testing&ensp;>>>&ensp;0.1.1.2-alpha-testing](https://github.com/DemerNkardaz/DSL-KeyPad/compare/0.1.1.1-alpha-testing...0.1.1.2-alpha-testing#files_bucket) | [Changelog](https://github.com/DemerNkardaz/DSL-KeyPad/tree/main/CHANGELOG.md)\n\n[Yalla Nkardaz’s custom files](https://github.com/DemerNkardaz/DSL-KeyPad-Custom-Files) repository for DSL KeyPad.\n\n@DemerNkardaz 
"@

Write-Host "Version: $ver"
Write-Host "Pre-release: $preRelease"
Write-Host "Release message:
$message"

& "./build_executable.cmd"
& "./Bin/build_icons_dll.cmd"

& "$PSScriptRoot/Lib/powershell/pack_bundle.ps1" -FolderPath "$PSScriptRoot" -Version $ver -SleepingDuration 0

[System.IO.File]::WriteAllText("$PSScriptRoot/version", $ver, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$PSScriptRoot/prerelease", $preRelease, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$PSScriptRoot/latest", $makeLatest, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$PSScriptRoot/title", $title, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$PSScriptRoot/message", $message, [System.Text.Encoding]::UTF8)