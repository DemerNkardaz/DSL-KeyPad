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

SelectedDir := FileSelect("D", , LanguageCode = "ru" ? "Выберите директорию для утилиты, например E:\Software\" : "Choose a directory for the utility, for example E:\Software\")
if !SelectedDir {
	Exit
}

WorkingDir := SelectedDir "\DSLKeyPad"
DirCreate(WorkingDir)
DirCreate(WorkingDir "\UtilityFiles")


InternalFiles := Map(
	"Locales", { Repo: RawRepoFiles "DSLKeyPad.locales.ini", File: WorkingDir "\UtilityFiles\DSLKeyPad.locales.ini" },
	"AppIco", { Repo: RawRepoFiles "DSLKeyPad.app.ico", File: WorkingDir "\UtilityFiles\DSLKeyPad.app.ico" },
	"AppIcoDLL", { Repo: RawRepoFiles "DSLKeyPad_App_Icons.dll", File: WorkingDir "\UtilityFiles\DSLKeyPad_App_Icons.dll" },
	"HTMLEntities", { Repo: RawRepoFiles "entities_list.txt", File: WorkingDir "\UtilityFiles\entities_list.txt" },
	"AltCodes", { Repo: RawRepoFiles "alt_codes_list.txt", File: WorkingDir "\UtilityFiles\alt_codes_list.txt" },
	"Exe", { Repo: RawRepoFiles "DSLKeyPad.exe", File: WorkingDir "\DSLKeyPad.exe" },
	"App", { Repo: RawRepo "DSLKeyPad.ahk", File: WorkingDir "\DSLKeyPad.ahk" },
)

GetInstall() {
	ErrMessages := Map(
		"ru", "Произошла ошибка при получении файла перевода.`nСервер недоступен или ошибка соединения с интернетом.",
		"en", "An error occured during receiving locales file.`nServer unavailable or internet connection error."
	)

	for fileEntry in InternalFiles {
		try {
			Download(fileEntry.Repo, fileEntry.File)
		} catch {
			Error(ErrMessages[GetLangCode()])
		}

	}
	return
}
GetInstall()
Run(InternalFiles["Exe"].File)

Desktop := A_Desktop "\DSLKeyPad.lnk"
CreateShortcut(InternalFiles["Exe"].File, Desktop, InternalFiles["AppIcoDLL"].File, 0)

FileDelete(A_ScriptFullPath)


CreateShortcut(TargetPath, ShortcutPath, IconFilePath, IconIndex := 0) {
	shell := ComObject("WScript.Shell")
	shortcut := shell.CreateShortcut(ShortcutPath)
	shortcut.TargetPath := TargetPath
	shortcut.IconLocation := IconFilePath "," IconIndex
	shortcut.Save()
}

Exit