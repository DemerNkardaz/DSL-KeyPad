@echo off
set ver="0.1.1.1-alpha-testing"
set preRelease="True"
set makeLatest="True"
set message="Release with tag 0.1.1.1-alpha-testing automatically created or updated via workflow"

set title="DSL KeyPad — V[0.1.1.1-alpha-testing] — (αλφα)"
echo Version: %ver%
echo Pre-release: %preRelease%
echo Release message: %message%

call build_executable.cmd
call Bin\\build_icons_dll.cmd

powershell -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('%~dp0\\version', '%ver%', [System.Text.Encoding]::UTF8)"
powershell -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('%~dp0\\prerelease', '%preRelease%', [System.Text.Encoding]::UTF8)"
powershell -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('%~dp0\\latest', '%makeLatest%', [System.Text.Encoding]::UTF8)"
powershell -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('%~dp0\\title', '%title%', [System.Text.Encoding]::UTF8)"
powershell -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('%~dp0\\message', '%message%', [System.Text.Encoding]::UTF8)"

powershell -ExecutionPolicy Bypass -File %~dp0\\Lib\\powershell\\pack_bundle.ps1 -FolderPath %~dp0 -Version "%ver%"