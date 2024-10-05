#Requires Autohotkey v2
#SingleInstance Force

GetLangCode() {
	ValidateLanguage(LanguageSource) {
		for language in ["ru", "en"] {
			if (LanguageSource = language) {
				return language
			}
		}

		return "en"
	}

	SysLanguageKey := RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName")
	SysLanguageKey := SubStr(SysLanguageKey, 1, 2)

	return ValidateLanguage(SysLanguageKey)
}

LanguageCode := GetLangCode()

RawRepo := "https://raw.githubusercontent.com/DemerNkardaz/DSL-KeyPad/main/"
RawRepoFiles := RawRepo "UtilityFiles/"
RepoSource := "https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/DSLKeyPad.ahk"
RawSource := RawRepo "DSLKeyPad.ahk"
LocalesRaw := RawRepoFiles "DSLKeyPad.locales.ini"
AppIcoRaw := RawRepoFiles "DSLKeyPad.app.ico"
AppIcosDLLRaw := RawRepoFiles "DSLKeyPad_App_Icons.dll"
HTMLEntitiesListRaw := RawRepoFiles "entities_list.txt"
AltCodesListRaw := RawRepoFiles "alt_codes_list.txt"

SelectedDir := FileSelect("D", , LanguageCode = "ru" ? "Выберите директорию для утилиты, например E:\Software\" : "Choose a directory for the utility, for example E:\Software\")
if !SelectedDir {
	Exit
}

WorkingDir := SelectedDir "\DSLKeyPad"
DirCreate(WorkingDir)

LocalesFile := WorkingDir "\UtilityFiles\DSLKeyPad.locales.ini"
AppIcoFile := WorkingDir "\UtilityFiles\DSLKeyPad.app.ico"
AppIcosDLLFile := WorkingDir "\UtilityFiles\DSLKeyPad_App_Icons.dll"
HTMLEntitiesListFile := WorkingDir "\UtilityFiles\entities_list.txt"
AltCodesListFile := WorkingDir "\UtilityFiles\alt_codes_list.txt"
AppDestination := WorkingDir "\DSLKeyPad.ahk"

Download(LocalesRaw, LocalesFile)
Download(HTMLEntitiesListRaw, HTMLEntitiesListFile)
Download(AltCodesListRaw, AltCodesListFile)
Download(AppIcoRaw, AppIcoFile)
Download(AppIcosDLLRaw, AppIcosDLLFile)
Download(RawSource, AppDestination)
Run(AppDestination)
FileDelete(A_ScriptFullPath)

Exit