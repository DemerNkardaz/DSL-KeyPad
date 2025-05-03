@echo off
setlocal
chcp 65001 >nul

echo Building icons DLL...
:: Переходим в директорию скрипта
cd /d "%~dp0"

:: Директория проекта относительно текущей
set ProjectDir=%~dp0DSLKeyPad_App_Icons
set vcxproj="%ProjectDir%\DSLKeyPad_App_Icons.vcxproj"

:: Директория вывода относительно текущей
set OutputDir=%cd%

:: Пытаемся найти правильный путь к msbuild
set MSBUILD_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\msbuild.exe"
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\msbuild.exe" (
    set MSBUILD_PATH="C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\msbuild.exe"
)

echo Running msbuild...

:: Строим проект с msbuild
%MSBUILD_PATH% ^
  "%ProjectDir%\DSLKeyPad_App_Icons.vcxproj" ^
  /p:Configuration=Release ^
  /p:Platform=x64 ^
  /p:OutDir="%OutputDir%"\ ^
  /p:DebugSymbols=false ^
  /p:DebugType=None

del /q "%OutputDir%\*.pdb" >nul 2>&1
