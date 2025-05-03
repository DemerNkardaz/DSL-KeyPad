$ver = "0.1.1.2-alpha-testing"
$preRelease = "True"
$makeLatest = "True"
$title = "DSL KeyPad — V[0.1.1.2-alpha-testing] — (αλφα)"
$message = "Release with tag 0.1.1.2-alpha-testing automatically created or updated via workflow :: [Stamp :: 2025-05-03 11:25:32]<br><br>[Yalla Nkardaz’s custom files](https://github.com/DemerNkardaz/DSL-KeyPad-Custom-Files) repository for DSL KeyPad."

Write-Host "Version: $ver"
Write-Host "Pre-release: $preRelease"
Write-Host "Release message:
$message"

& "./build_executable.cmd"
& "./Bin/build_icons_dll.cmd"

& "$PSScriptRoot/Lib/powershell/pack_bundle.ps1" -FolderPath "$PSScriptRoot" -Version $ver

echo "version=$ver" >> $env:GITHUB_OUTPUT
echo "preRelease=$prerelease" >> $env:GITHUB_OUTPUT
echo "makeLatest=$make_latest" >> $env:GITHUB_OUTPUT
echo "title=$title" >> $env:GITHUB_OUTPUT
echo "body=$message" >> $env:GITHUB_OUTPUT