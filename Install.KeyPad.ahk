#Requires Autohotkey v2
#SingleInstance Force

RawRepo := "https://raw.githubusercontent.com/DemerNkardaz/DSL-KeyPad/main/"
RawRepoFiles := RawRepo . "UtilityFiles/"
RepoSource := "https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/DSLKeyPad.ahk"
RawSource := RawRepo . "DSLKeyPad.ahk"
LocalesRaw := RawRepoFiles . "DSLKeyPad.locales.ini"
AppIcoRaw := RawRepoFiles . "DSLKeyPad.app.ico"
AppIcosDLLRaw := RawRepoFiles . "DSLKeyPad_App_Icons.dll"

WorkingDir := A_MyDocuments . "\DSLKeyPad"
DirCreate(WorkingDir)

LocalesFile := WorkingDir . "\DSLKeyPad.locales.ini"
AppIcoFile := WorkingDir . "\DSLKeyPad.app.ico"
AppIcosDLLFile := WorkingDir . "\DSLKeyPad_App_Icons.dll"
AppDestination := A_ScriptDir . "\DSLKeyPad.ahk"

Download(LocalesRaw, LocalesFile)
Download(AppIcoRaw, AppIcoFile)
Download(AppIcosDLLRaw, AppIcosDLLFile)
Download(RawSource, AppDestination)
Run(AppDestination)
FileDelete(A_ScriptFullPath)

Exit