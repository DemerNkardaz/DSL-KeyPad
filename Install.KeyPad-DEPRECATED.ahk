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
		DirCreate(WorkingDir "\Lib\External")

		InternalFiles := Map(
			"Locales", { Repo: RawRepoFiles "DSLKeyPad.locales.ini", File: WorkingDir "\UtilityFiles\DSLKeyPad.locales.ini" },
			"AppIco", { Repo: RawRepoFiles "DSLKeyPad.app.ico", File: WorkingDir "\UtilityFiles\DSLKeyPad.app.ico" },
			"AppIcoDLL", { Repo: RawRepoFiles "DSLKeyPad_App_Icons.dll", File: WorkingDir "\UtilityFiles\DSLKeyPad_App_Icons.dll" },
			"HTMLEntities", { Repo: RawRepoLib "chr_entities.ahk", File: WorkingDir "\Lib\chr_entities.ahk" },
			"AltCodes", { Repo: RawRepoLib "chr_alt_codes.ahk", File: WorkingDir "\Lib\chr_alt_codes.ahk" },
			"Exe", { Repo: RawRepoFiles "DSLKeyPad.exe", File: WorkingDir "\DSLKeyPad.exe" },
			"App", { Repo: RawRepo "DSLKeyPad.ahk", File: WorkingDir "\DSLKeyPad.ahk" },
			"LibClsCfg", { Repo: RawRepoLib "cls_cfg.ahk", File: WorkingDir "\Lib\cls_cfg.ahk" },
			"LibClsLang", { Repo: RawRepoLib "cls_language.ahk", File: WorkingDir "\Lib\cls_language.ahk" },
			"LibClsApp", { Repo: RawRepoLib "cls_app.ahk", File: WorkingDir "\Lib\cls_app.ahk" },
			"LibClsLigs", { Repo: RawRepoLib "cls_ligaturiser.ahk", File: WorkingDir "\Lib\cls_ligaturiser.ahk" },
			"LibClsScrPrc", { Repo: RawRepoLib "cls_script_processor.ahk", File: WorkingDir "\Lib\cls_script_processor.ahk" },
			"LibClsChrInsert", { Repo: RawRepoLib "cls_chr_inserter.ahk", File: WorkingDir "\Lib\cls_chr_inserter.ahk" },
			"LibClsFavs", { Repo: RawRepoLib "cls_favorites.ahk", File: WorkingDir "\Lib\cls_favorites.ahk" },
			"LibClsTConv", { Repo: RawRepoLib "cls_tempature_converter.ahk", File: WorkingDir "\Lib\cls_tempature_converter.ahk" },
			"LibChrLib", { Repo: RawRepoLib "chr_lib.ahk", File: WorkingDir "\Lib\chr_lib.ahk" },
			"ExternalPrtArray", { Repo: RawRepoLib "External\prt_array.ahk", File: WorkingDir "\Lib\External\prt_array.ahk" },
			"ExternalFncClSend", { Repo: RawRepoLib "External\fnc_clip_send.ahk", File: WorkingDir "\Lib\External\fnc_clip_send.ahk" },
			"ExternalFncCarPos", { Repo: RawRepoLib "External\fnc_caret_pos.ahk", File: WorkingDir "\Lib\External\fnc_caret_pos.ahk" },
			"ExternalFncGuiBtnClr", { Repo: RawRepoLib "External\fnc_gui_button_icon.ahk", File: WorkingDir "\Lib\External\fnc_gui_button_icon.ahk" },
			"LibUtils", { Repo: RawRepoLib "utils.ahk", File: WorkingDir "\Lib\utils.ahk" },
			"pyUniName", { Repo: RawRepoLib ".py/unicodeName.py", File: WorkingDir "\Lib\.py\unicodeName.py" },
			"psSID", { Repo: RawRepoLib ".ps/usrSID.ps1", File: WorkingDir "\Lib\.ps\usrSID.ps1" },
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