$ver = "0.1.2.2-alpha-testing"
$preRelease = "True"
$title = "DSL KeyPad@0.1.2.2 (αλφα)"
$message =@"
&#128230;&emsp14;Automatically created/updated via build process in workflow.<br>

<table>
		<tr>
			<td><b>Stamp</b></td>
			<td>
				&#128228;&emsp14;2025-05-09 10:57:12
			</td>
		</tr>
		<tr>
			<td><b>Version</b></td>
			<td>
				&#128229;&emsp14;<a href="https://github.com/DemerNkardaz/DSL-KeyPad/releases/download/0.1.2.2-alpha-testing/DSL-KeyPad-0.1.2.2-alpha-testing.zip">0.1.2.2-alpha-testing</a>
			</td>
		</tr>
		<tr>
			<td><b>Requirements</b></td>
			<td>
				<img src="https://www.autohotkey.com/favicon.ico" width="16">&emsp14;<a href="https://www.autohotkey.com/download/ahk-v2.exe">AutoHotkey v2.^</a><br>
				Windows 10/11 x64
			</td>
		</tr>
		<tr>
			<td><b>Additional</b></td>
			<td>
				<img src="https://www.gstatic.com/images/icons/material/apps/fonts/1x/catalog/v5/favicon.svg" width="16">&emsp14;<a href="https://fonts.google.com/?query=noto">Noto fonts (search)</a><br>
				<img src="https://www.kurinto.com/favicon.ico" width="16">&emsp14;<a href="https://www.kurinto.com/download.htm">Kurinto fonts</a>
				<details>
					<summary>Recommended font list</summary>
					<ul>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans">Noto Sans</a> <i>Important</i></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Serif">Noto Serif</a> <i>Important</i></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Color+Emoji">Noto Color Emoji</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Math">Noto Sans Math</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Symbols">Noto Sans Symbols</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Runic">Noto Sans Runic</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Glagolitic">Noto Sans Glagolitic</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Gothic">Noto Sans Gothic</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Lycian">Noto Sans Lycian</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Lydian">Noto Sans Lydian</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Carian">Noto Sans Carian</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Mandaic">Noto Sans Mandaic</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Nabataean">Noto Sans Nabataean</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Old+Hungarian">Noto Sans Old Hungarian</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Old+Italic">Noto Sans Old Italic</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Old+Permic">Noto Sans Old Permic</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Old+Persian">Noto Sans Old Persian</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Old+Turkic">Noto Sans Old Turkic</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Old+North+Arabian">Noto Sans Old North Arabian</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Old+South+Arabian">Noto Sans Old South Arabian</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Palmyrene">Noto Sans Palmyrene</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Phoenician">Noto Sans Phoenician</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Tifinagh">Noto Sans Tifinagh</a></li>
						<li><a href="https://fonts.google.com/specimen/Noto+Sans+Ugaritic">Noto Sans Ugaritic</a></li>
					</ul>
				</details>
			</td>
		</tr>
</table>

**Versions compare** [0.1.1.2-alpha-testing&ensp;>>>&ensp;0.1.2.2-alpha-testing](https://github.com/DemerNkardaz/DSL-KeyPad/compare/0.1.1.2-alpha-testing...0.1.2.2-alpha-testing#files_bucket) | [Changelog](https://github.com/DemerNkardaz/DSL-KeyPad/tree/main/CHANGELOG.md) | [Features Kanban](https://github.com/users/DemerNkardaz/projects/2) | [Docs](https://demernkardaz.github.io/DSL-KeyPad)

[Yalla Nkardaz’s custom files](https://github.com/DemerNkardaz/DSL-KeyPad-Custom-Files) repository for DSL KeyPad.
<br>[![Downloads GitHub](https://img.shields.io/github/downloads/DemerNkardaz/DSL-KeyPad/DSL-KeyPad-0.1.2.2-alpha-testing.zip?logo=github&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.2.2-alpha-testing) [![Downloads SourceForge](https://img.shields.io/sourceforge/dt/dsl-keypad/0.1.2.2-alpha-testing?logo=sourceforge&color=yellow)](https://sourceforge.net/projects/dsl-keypad/files/0.1.2.2-alpha-testing/)
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