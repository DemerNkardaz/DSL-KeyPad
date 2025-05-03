@echo off
set ver=0.1.1.1-alpha-testing
set preRelease=True
set message=Release with tag %ver% automatically created via workflow

echo %message%
call build_executable.cmd
call Bin\\build_icons_dll.cmd
powershell -ExecutionPolicy Bypass -File %~dp0\\Lib\\powershell\\pack_bundle.ps1 -FolderPath %~dp0 -Version "%ver%"
