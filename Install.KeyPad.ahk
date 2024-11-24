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
RawRepoLib := RawRepo "Lib/"
RepoSource := "https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/DSLKeyPad.ahk"

SelectedDir := FileSelect("D", , LanguageCode = "ru" ? "Выберите директорию для утилиты, например E:\Software\" : "Choose a directory for the utility, for example E:\Software\")
if !SelectedDir {
	Exit
}
GetInstall() {
	ErrMessages := Map(
		"ru", "Произошла ошибка при получении файла перевода.`nСервер недоступен или ошибка соединения с интернетом.",
		"en", "An error occured during receiving locales file.`nServer unavailable or internet connection error."
	)
	try {
		WorkingDir := SelectedDir "\DSLKeyPad"
		DirCreate(WorkingDir)
		DirCreate(WorkingDir "\UtilityFiles")
		DirCreate(WorkingDir "\Lib")


		InternalFiles := Map(
			"Locales", { Repo: RawRepoFiles "DSLKeyPad.locales.ini", File: WorkingDir "\UtilityFiles\DSLKeyPad.locales.ini" },
			"AppIco", { Repo: RawRepoFiles "DSLKeyPad.app.ico", File: WorkingDir "\UtilityFiles\DSLKeyPad.app.ico" },
			"AppIcoDLL", { Repo: RawRepoFiles "DSLKeyPad_App_Icons.dll", File: WorkingDir "\UtilityFiles\DSLKeyPad_App_Icons.dll" },
			"HTMLEntities", { Repo: RawRepoFiles "entities_list.txt", File: WorkingDir "\UtilityFiles\entities_list.txt" },
			"AltCodes", { Repo: RawRepoFiles "alt_codes_list.txt", File: WorkingDir "\UtilityFiles\alt_codes_list.txt" },
			"Exe", { Repo: RawRepoFiles "DSLKeyPad.exe", File: WorkingDir "\DSLKeyPad.exe" },
			"App", { Repo: RawRepo "DSLKeyPad.ahk", File: WorkingDir "\DSLKeyPad.ahk" },
			"LibClsCfg", { Repo: RawRepoLib "cls_cfg.ahk", File: WorkingDir "\Lib\cls_cfg.ahk" },
			"LibClsLang", { Repo: RawRepoLib "cls_language.ahk", File: WorkingDir "\Lib\cls_language.ahk" },
			"LibClsApp", { Repo: RawRepoLib "cls_app.ahk", File: WorkingDir "\Lib\cls_app.ahk" },
			"LibClsScrPrc", { Repo: RawRepoLib "cls_script_processor.ahk", File: WorkingDir "\Lib\cls_script_processor.ahk" },
			"LibChrLib", { Repo: RawRepoLib "chr_lib.ahk", File: WorkingDir "\Lib\chr_lib.ahk" },
		)

		for fileEntry, value in InternalFiles {
			try {
				Download(value.Repo, value.File)
			} catch {
				Error(ErrMessages[GetLangCode()])
			}

		}
	} catch {
		Error(ErrMessages[GetLangCode()])
	} finally {
		Run(InternalFiles["Exe"].File)

		Desktop := A_Desktop "\DSLKeyPad.lnk"
		CreateShortcut(InternalFiles["Exe"].File, Desktop, InternalFiles["AppIcoDLL"].File, 0)

		FileDelete(A_ScriptFullPath)
	}
	return
}

GetInstall()

CreateShortcut(TargetPath, ShortcutPath, IconFilePath, IconIndex := 0) {
	shell := ComObject("WScript.Shell")
	shortcut := shell.CreateShortcut(ShortcutPath)
	shortcut.TargetPath := TargetPath
	shortcut.IconLocation := IconFilePath "," IconIndex
	shortcut.Save()
}

Exit