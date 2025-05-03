$ver = "0.1.1.2-alpha-testing"
$preRelease = "True"
$makeLatest = "True"
$title = "DSL KeyPad — V[0.1.1.2-alpha-testing] — (αλφα)"
$message = "Release with tag 0.1.1.2-alpha-testing automatically created or updated via workflow :: [Stamp :: 2025-05-03 12:09:46]<br><br>[Yalla Nkardaz’s custom files](https://github.com/DemerNkardaz/DSL-KeyPad-Custom-Files) repository for DSL KeyPad."

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