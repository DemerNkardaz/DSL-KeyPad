#Requires Autohotkey v2
#SingleInstance Force
#MaxThreads 10
;#UseHook
;InstallKeybdHook(True, True)
<^>!BackSpace:: KeyHistory
A_HotkeyInterval := 1000
A_MaxHotkeysPerInterval := 50

second := 1000
minute := 60 * second
hour := 60 * minute

CtrlA := Chr(1)
CtrlB := Chr(2)
CtrlC := Chr(3)
CtrlD := Chr(4)
CtrlE := Chr(5)
CtrlF := Chr(6)
CtrlG := Chr(7)
CtrlH := Chr(8)
CtrlI := Chr(9)
CtrlJ := Chr(10)
CtrlK := Chr(11)
CtrlL := Chr(12)
CtrlM := Chr(13)
CtrlN := Chr(14)
CtrlO := Chr(15)
CtrlP := Chr(16)
CtrlQ := Chr(17)
CtrlR := Chr(18)
CtrlS := Chr(19)
CtrlT := Chr(20)
CtrlU := Chr(21)
CtrlV := Chr(22)
CtrlW := Chr(23)
CtrlX := Chr(24)
CtrlY := Chr(25)
CtrlZ := Chr(26)
CtrlTilde := Chr(30)
EscapeKey := Chr(27)
SpaceKey := Chr(32)
ExclamationMark := Chr(33)
CommercialAt := Chr(64)
QuotationDouble := Chr(34)
ApostropheMark := Chr(39)
Backquote := Chr(96)
Solidus := Chr(47)
ReverseSolidus := Chr(92)
InformationSymbol := Chr(0x24D8)
NewLine := Chr(0x000A)
CarriageReturn := Chr(0x000D)
Tabulation := Chr(0x0009)
NbrSpace := Chr(0x00A0)
DottedCircle := Chr(0x25CC)

LeftControl := Chr(0x2388)
RightControl := Chr(0x2318)
LeftShift := Chr(0x1F844)
RightShift := Chr(0x1F846)
LeftAlt := Chr(0x2387)
RightAlt := Chr(0x2384)
Window := Chr(0x229E)
CapsLock := Chr(0x2B9D)


EscapePressed := False

FastKeysIsActive := False
ActiveScriptName := ""
PreviousScriptName := ""
AlterationActiveName := ""
InputMode := "Default"
LaTeXMode := "Default"


#Include <External\prt_array>
#Include <External\fnc_clip_send>
#Include <External\fnc_caret_pos>
#Include <External\fnc_gui_button_icon>
#Include <utils>
#Include <chr_alt_codes>
#Include <chr_entities>
#Include <cls_util>
#Include <chr_lib>
#Include <cls_chr_lib>
#Include <cls_chr_recipe_handler>
#Include <cls_chr_legend>
#Include <cls_panel>
#Include <cls_key_event>
#Include <cls_layout>
#Include <cls_long_press>
#Include <supplement_pshell>
#Include <supplement_python>


; Only EN US & RU RU Keyboard Layout

SupportedLanguages := [
	"en",
	"ru",
]

CodeEn := "00000409"
CodeRu := "00000419"
CodeGr := "00000408"

ChracterMap := "C:\Windows\System32\charmap.exe"
ImageRes := "C:\Windows\System32\imageres.dll"
Shell32 := "C:\Windows\SysWOW64\shell32.dll"

AppVersion := [0, 1, 1, 0]
CurrentVersionString := Format("{:d}.{:d}.{:d}", AppVersion[1], AppVersion[2], AppVersion[3])
UpdateVersionString := ""

RawRepo := "https://raw.githubusercontent.com/DemerNkardaz/DSL-KeyPad/main/"
RawRepoFiles := RawRepo . "UtilityFiles/"
RawRepoLib := RawRepo . "Lib/"
RawRepoInfo := RawRepo . "__info/"
RepoSource := "https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/DSLKeyPad.ahk"

RawSource := RawRepo "DSLKeyPad.ahk"
UpdateAvailable := False

ChangeLogRaw := Map(
	"ru", RawRepoInfo "DSLKeyPad.Changelog.ru.md",
	"en", RawRepoInfo "DSLKeyPad.Changelog.en.md"
)

WorkingDir := A_ScriptDir

ConfigFile := WorkingDir "\DSLKeyPad.config.ini"
ExecutableFile := WorkingDir "\DSLKeyPad.exe"

InternalFiles := Map(
	"Locales", { Repo: RawRepoFiles "DSLKeyPad.locales.ini", File: WorkingDir "\UtilityFiles\DSLKeyPad.locales.ini" },
	"AppIco", { Repo: RawRepoFiles "DSLKeyPad.app.ico", File: WorkingDir "\UtilityFiles\DSLKeyPad.app.ico" },
	"AppIcoDLL", { Repo: RawRepoFiles "DSLKeyPad_App_Icons.dll", File: WorkingDir "\UtilityFiles\DSLKeyPad_App_Icons.dll" },
	"HTMLEntities", { Repo: RawRepoLib "chr_entities.ahk", File: WorkingDir "\Lib\chr_entities.ahk" },
	"AltCodes", { Repo: RawRepoLib "chr_alt_codes.ahk", File: WorkingDir "\Lib\chr_alt_codes.ahk" },
	"Exe", { Repo: RawRepoFiles "DSLKeyPad.exe", File: WorkingDir "\DSLKeyPad.exe" },
	"LibClsCfg", { Repo: RawRepoLib "cls_cfg.ahk", File: WorkingDir "\Lib\cls_cfg.ahk" },
	"LibClsLang", { Repo: RawRepoLib "cls_language.ahk", File: WorkingDir "\Lib\cls_language.ahk" },
	"LibClsApp", { Repo: RawRepoLib "cls_app.ahk", File: WorkingDir "\Lib\cls_app.ahk" },
	"LibClsScrPrc", { Repo: RawRepoLib "cls_script_processor.ahk", File: WorkingDir "\Lib\cls_script_processor.ahk" },
	"LibClsLigs", { Repo: RawRepoLib "cls_ligaturiser.ahk", File: WorkingDir "\Lib\cls_ligaturiser.ahk" },
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

#Include <cls_app>
#Include <cls_cfg>
#Include <cls_language>
#Include <cls_chr_crafter>
#Include <cls_chr_inserter>
#Include <cls_my_recipes>
#Include <cls_favorites>

DSLPadTitle := "DSL KeyPad (αλφα)" " — " CurrentVersionString
DSLPadTitleDefault := "DSL KeyPad"
DSLPadTitleFull := "Diacritics-Spaces-Letters KeyPad"

GetUtilityFiles(ForceUpdate := False) {
	ErrMessages := Map(
		"ru", "Произошла ошибка при получении файла перевода.`nСервер недоступен или ошибка соединения с интернетом.",
		"en", "An error occured during receiving locales file.`nServer unavailable or internet connection error."
	)

	for fileEntry, value in InternalFiles {
		if !FileExist(value.File) || ForceUpdate {
			try {
				Download(value.Repo, value.File)
			} catch {
				Error(ErrMessages[Language.Get()])
			}
		}
	}
	return
}


TraySetIcon(InternalFiles["AppIcoDLL"].File, 1)

ReadLocale(EntryName, Prefix := "") {
	Section := Prefix != "" ? Prefix . "_" . Language.Get() : Language.Get()
	Intermediate := IniRead(InternalFiles["Locales"].File, Section, EntryName, "")

	while (RegExMatch(Intermediate, "\{([a-zA-Z]{2})\}", &match)) {
		LangCode := match[1]
		SectionOverride := Prefix != "" ? Prefix . "_" . LangCode : LangCode
		Replacement := IniRead(InternalFiles["Locales"].File, SectionOverride, EntryName, "")
		Intermediate := StrReplace(Intermediate, match[0], Replacement)
	}

	while (RegExMatch(Intermediate, "\{(?:([^\}_]+)_)?([a-zA-Z]{2}):([^\}]+)\}", &match)) {
		CustomPrefix := match[1] ? match[1] : ""
		LangCode := match[2]
		CustomEntry := match[3]
		SectionOverride := CustomPrefix != "" ? CustomPrefix . "_" . LangCode : LangCode
		Replacement := IniRead(InternalFiles["Locales"].File, SectionOverride, CustomEntry, "")
		Intermediate := StrReplace(Intermediate, match[0], Replacement)
	}

	while (RegExMatch(Intermediate, "\{U\+(\w+)\}", &match)) {
		Unicode := match[1]
		Replacement := Chr("0x" . Unicode)
		Intermediate := StrReplace(Intermediate, match[0], Replacement)
	}

	while (RegExMatch(Intermediate, "\{var:([^\}]+)\}", &match)) {
		Varname := match[1]
		if IsSet(%Varname%) {
			Replacement := %Varname%
		} else {
			Replacement := "VAR (" . Varname . "): NOT FOUND"
		}
		Intermediate := StrReplace(Intermediate, match[0], Replacement)
	}


	Intermediate := StrReplace(Intermediate, "\n", "`n")
	Intermediate := StrReplace(Intermediate, "\t", "`t")
	Intermediate := Intermediate != "" ? Intermediate : "KEY (" . EntryName . "): NOT FOUND"
	return Intermediate
}


OpenConfigFile(*) {
	Run(ConfigFile)
}

OpenLocalesFile(*) {
	Run(InternalFiles["Locales"].File)
}


DefaultConfig := [
	["Settings", "FastKeysIsActive", "False"],
	["Settings", "SkipGroupMessage", "False"],
	["Settings", "InputMode", "Default"],
	["Settings", "ScriptInput", "Default"],
	["Settings", "LaTeXInput", "Default"],
	["Settings", "UserLanguage", ""],
	["Settings", "LatinLayout", "QWERTY"],
	["Settings", "CyrillicLayout", "ЙЦУКЕН"],
	["Settings", "CharacterWebResource", "SymblCC"],
	["Settings", "F13F24", "True"],
	["Settings", "TemperatureCalcExtendedFormatting", "True"],
	["Settings", "TemperatureCalcDedicatedUnicodeChars", "True"],
	["Settings", "ScriptProcessorAdvancedMode", "False"],
	["CustomRules", "ParagraphBeginning", ""],
	["CustomRules", "ParagraphAfterStartEmdash", ""],
	["CustomRules", "GREPDialogAttribution", ""],
	["CustomRules", "GREPThisEmdash", ""],
	["CustomRules", "GREPInitials", ""],
	["CustomRules", "TemperatureCalcRoundValue", "2"],
	["CustomRules", "TemperatureCalcSpaceType", "narrow_no_break_space"],
	["CustomRules", "TemperatureCalcExtendedFormattingFrom", "5"],
	["CustomRules", "TemperatureCalcExtendedFormattingSpaceType", "thinspace"],
	["LatestPrompts", "LaTeX", ""],
	["LatestPrompts", "Unicode", ""],
	["LatestPrompts", "Altcode", ""],
	["LatestPrompts", "Search", ""],
	["LatestPrompts", "Ligature", ""],
	["LatestPrompts", "RomanNumeral", ""],
	["ServiceFields", "PrevLayout", ""],
]

if FileExist(ConfigFile) {
	isFastKeysEnabled := IniRead(ConfigFile, "Settings", "FastKeysIsActive", "False")
	InputMode := IniRead(ConfigFile, "Settings", "InputMode", "Default")
	LaTeXMode := IniRead(ConfigFile, "Settings", "LaTeXInput", "Default")

	FastKeysIsActive := (isFastKeysEnabled = "True")
} else {

}
/*
FontFace := Map(
	"sans", {
		name: "Noto Sans",
		source: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSans/googlefonts/variable-ttf/NotoSans%5Bwdth%2Cwght%5D.ttf"
	},
		"serif", {
			name: "Noto Serif",
			source: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSerif/googlefonts/variable-ttf/NotoSerif%5Bwdth%2Cwght%5D.ttf"
		},
)
*/


FontFace := Map(
	"serif", {
		name: "Noto Serif",
		source: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSerif/googlefonts/variable-ttf/NotoSerif%5Bwdth%2Cwght%5D.ttf"
	},
)


IsFont(FontName) {
	Suffixes := ["", " Regular", " Regular (TrueType)"]

	for Suffix in Suffixes {
		FullKeyName := FontName Suffix

		try {
			RegPath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
			if RegRead(RegPath, FullKeyName) {
				return True
			}
		}
		catch {
		}

		try {
			if App.usr.sid != "" {
				RegPath := "HKEY_USERS\" App.usr.sid "\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
				if RegRead(RegPath, FullKeyName) {
					return True
				}
			}
		}
		catch {
		}
	}
	return False
}


FontValidate() {
	NamesToBeInstalled := "`n"
	SourcesToBeInstalled := []
	FoundNotInstalled := False
	for _, font in FontFace {
		if !IsFont(font.name) {
			SourcesToBeInstalled.Push(font.source)
			NamesToBeInstalled .= font.name "`n"
			FoundNotInstalled := True
		} else {
			continue
		}
	}

	if FoundNotInstalled {
		MsgBox(Locale.Read("prepare_fonts") NamesToBeInstalled, DSLPadTitle)

		for _, fontSource in SourcesToBeInstalled {
			FontInstall(fontSource)
		}
	}
}

FontInstall(FontSource) {
	TempFolder := A_Temp "\DSLTemp"
	DirCreate(TempFolder)

	http := ComObject("WinHttp.WinHttpRequest.5.1")
	http.Open("GET", FontSource, true)
	try {
		http.Send()
		http.WaitForResponse()
	} catch {
		MsgBox("Can’t download font.`n" Locale.Read("prepare_fonts"), "Font Installer")
	}

	if (http.Status != 200) {
		MsgBox("Can’t download font.", "Font Installer")
		return
	}

	FontTitle := RegExReplace(StrSplit(FontSource, "/").Pop(), "[^a-zA-Z]+.*$", "") ".ttf"
	FontPath := TempFolder "\" FontTitle
	Download(FontSource, FontPath)
	RunWait(FontPath)
	FileDelete(FontPath)
}

FontValidate()


ChangeKeyboardLayout(LocaleID, LayoutID := 1) {
	LanguageCode := ""
	if LocaleID == "en" {
		LanguageCode := CodeEn
	} else if LocaleID == "ru" {
		LanguageCode := CodeRu
	} else {
		LanguageCode := LocaleID
	}

	layout := DllCall("LoadKeyboardLayout", "Str", LanguageCode, "Int", LayoutID)
	hwnd := DllCall("GetForegroundWindow")
	pid := DllCall("GetWindowThreadProcessId", "UInt", hwnd, "Ptr", 0)
	DllCall("PostMessage", "UInt", hwnd, "UInt", 0x50, "UInt", 0, "UInt", layout)
}

GetLayoutLocale() {
	threadId := DllCall("GetWindowThreadProcessId", "UInt", DllCall("GetForegroundWindow", "UInt"), "UInt", 0)
	layout := DllCall("GetKeyboardLayout", "UInt", threadId, "UPtr")
	layoutHex := Format("{:08X}", layout & 0xFFFF)
	return layoutHex
}

CurrentLayout := GetLayoutLocale()
Sleep 25
PreviousLayout := IniRead(ConfigFile, "ServiceFields", "PrevLayout", "")
/*
if (CurrentLayout != CodeEn) {
	IniWrite(CurrentLayout, ConfigFile, "ServiceFields", "PrevLayout")
	ChangeKeyboardLayout("en", 2)
	Reload
}

SetPreviousLayout(Timing := 150) {
	if (PreviousLayout != "") {
		Sleep Timing
		ChangeKeyboardLayout(PreviousLayout, 2)
		Sleep 100
		IniWrite("", ConfigFile, "ServiceFields", "PrevLayout")
	}
}
*/
StrRepeat(char, count) {
	result := ""
	Loop count
		result .= char
	return result
}

TrimArray(From, Count) {
	result := []
	for i, item in From {
		if (i > Count)
			break
		result.Push(item)
	}
	return result
}

GetLanguageCode() {
	ValidateLanguage(LanguageSource) {
		for language in SupportedLanguages {
			if (LanguageSource = language) {
				return language
			}
		}

		return "en"
	}

	UserLanguageKey := IniRead(ConfigFile, "Settings", "UserLanguage", "")

	if (UserLanguageKey != "") {
		return ValidateLanguage(UserLanguageKey)
	}
	else {
		SysLanguageKey := RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName")
		SysLanguageKey := SubStr(SysLanguageKey, 1, 2)

		return ValidateLanguage(SysLanguageKey)
	}
}

GetChangeLog() {
	global ChangeLogRaw
	ReceiveMap := Map()

	TimeOut := 1000
	Cancelled := False

	http := ComObject("WinHttp.WinHttpRequest.5.1")
	CancelHttp() {
		Cancelled := True
	}

	SetTimer(CancelHttp, TimeOut)
	if Cancelled {
		return Locale.Read("warning_nointernet")
	}

	for language, url in ChangeLogRaw {
		http.Open("GET", url, true)
		try {
			http.Send()
			http.WaitForResponse()
		} catch {
			return Locale.Read("warning_nointernet")
		}

		if http.Status != 200 || Cancelled {
			if Cancelled {
				http.Abort()
				return Locale.Read("warning_nointernet")
			}
			continue
		}

		if Cancelled {
			return
		}

		ReceiveMap[language] := http.ResponseText
	}


	return ReceiveMap
}

InsertChangesList(TargetGUI) {
	LanguageCode := GetLanguageCode()
	Changes := GetChangeLog()
	IsEmpty := True

	if IsObject(Changes) {
		for language, _ in Changes {
			IsEmpty := False
			break
		}
	} else if Changes != "" {
		TargetGUI.Add("Edit", "x30 y58 w810 h485 readonly Left Wrap -HScroll -E0x200", Changes)
		return
	}

	if IsEmpty {
		return
	}

	Labels := {
		ver: IniRead(InternalFiles["Locales"].File, LanguageCode, "version", ""),
		date: IniRead(InternalFiles["Locales"].File, LanguageCode, "date", ""),
	}


	for language, content in Changes {
		if language = LanguageCode {
			content := RegExReplace(content, "m)^## " . Labels.ver . " (.*) — (.*)", Labels.ver . ": $1`n" . Labels.date . ": $2")
			content := RegExReplace(content, "m)^- (.*)", " • $1")
			content := RegExReplace(content, "m)^\s\s- (.*)", "  ‣ $1")
			content := RegExReplace(content, "m)^\s\s\s\s- (.*)", "   ⁃ $1")
			content := RegExReplace(content, "m)^---", " " . GetChar("emdash×84"))

			TargetGUI.Add("Edit", "x30 y58 w810 h485 readonly Left Wrap -HScroll -E0x200", content)
		}
	}
}

GetTimeString() {
	return FormatTime(A_Now, "yyyy-MM-dd_HH-mm-ss")
}


GetDate(DateStyle := "YYYYMMDDhhmmss") {
	CurrentTime := A_Now
	TimeFormat := Map(
		"YYYY", SubStr(CurrentTime, 1, 4),
		"MM", SubStr(CurrentTime, 5, 2),
		"DD", SubStr(CurrentTime, 7, 2),
		"hh", SubStr(CurrentTime, 9, 2),
		"mm", SubStr(CurrentTime, 11, 2),
		"ss", SubStr(CurrentTime, 13, 2)
	)
	for Key, Value in TimeFormat {
		DateStyle := StrReplace(DateStyle, Key, Value, True)
	}
	CurrentTime := DateStyle
	return CurrentTime
}

SendDate(DateStyle := "YYYYMMDDhhmmss") {
	SendText(GetDate(DateStyle))
}

HotString(":C?0:gtsd", (D) => SendDate())
HotString(":C?0:gtdd", (D) => SendDate("YYYY–MM–DD"))
HotString(":C?0:gtfd", (D) => SendDate("YYYY–MM–DD hh:mm:ss"))
HotString(":C?0:gtfh", (D) => SendDate("hh:mm:ss"))
HotString(":C?0:gtfl", (D) => SendDate("YYYY_MM_DD-hh_mm_ss"))

CheckUpdateError := ""
GetUpdate(TimeOut := 0, RepairMode := False) {
	Sleep TimeOut
	global AppVersion, RawSource
	ErrorOccured := False
	ErroMessage := ""

	if RepairMode == True {
		IB := InputBox(Locale.Read("update_repair"), Locale.Read("update_repair_title"), "w256", "")
		if IB.Result = "Cancel" || IB.Value != "y" {
			return
		}
	}

	if UpdateAvailable || RepairMode == True {
		http := ComObject("WinHttp.WinHttpRequest.5.1")
		http.Open("GET", RawSource, true)
		try {
			http.Send()
			http.WaitForResponse()
		} catch {
			MsgBox(Locale.Read("update_failed"), DSLPadTitle)
			return
		}

		if http.Status != 200 {
			MsgBox(Locale.Read("update_failed"), DSLPadTitle)
			return
		}

		CurrentFilePath := A_ScriptFullPath
		CurrentFileName := StrSplit(CurrentFilePath, "\").Pop()
		UpdateFilePath := A_ScriptDir "\DSLKeyPad.ahk-GettingUpdate"

		Download(RawSource, UpdateFilePath)

		FileMove(CurrentFilePath, A_ScriptDir "\" CurrentFileName "-Backup-" GetTimeString())

		FileMove(UpdateFilePath, A_ScriptDir "\" CurrentFileName)

		GetUtilityFiles(True)

		if RepairMode == True {
			MsgBox(Locale.Read("update_repair_success"), DSLPadTitle)
		} else {
			MsgBox(Util.StrVarsInject(Locale.Read("update_successful"), CurrentVersionString, UpdateVersionString), DSLPadTitle)
		}

		Reload
		return
	} else {
		if CheckUpdateError != "" {
			MsgBox(CheckUpdateError, DSLPadTitle)
		} else {
			MsgBox(Locale.Read("update_absent"), DSLPadTitle)
		}
	}
	return
}


CheckUpdate() {
	global AppVersion, RawSource, UpdateAvailable, UpdateVersionString, CheckUpdateError
	http := ComObject("WinHttp.WinHttpRequest.5.1")
	http.Open("GET", RawSource, true)
	try {
		http.Send()
		http.WaitForResponse()
	} catch {
		CheckUpdateError := Locale.Read("update_failed")
		return
	}

	if http.Status != 200 {
		CheckUpdateError := Locale.Read("update_failed")
		return
	}

	FileContent := http.ResponseText

	if !RegExMatch(FileContent, "AppVersion := \[(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\]", &match) {
		MsgBox "Application version not found."
		return
	}
	NewVersion := [match[1], match[2], match[3], match[4]]
	Loop 4 {
		if NewVersion[A_Index] > AppVersion[A_Index] {
			UpdateAvailable := True
			UpdateVersionString := Format("{:d}.{:d}.{:d}.{:d}", NewVersion[1], NewVersion[2], NewVersion[3], NewVersion[4])
			return
		} else if NewVersion[A_Index] < AppVersion[A_Index] {
			return
		}
	}
	CheckUpdateError := ""
}

CheckUpdate()

LayoutsPresets := Map(
	"QWERTY", Map(
		"Space", "SC039",
		"Tab", "SC00F",
		"Numpad0", "SC052",
		"Numpad1", "SC04F",
		"Numpad2", "SC050",
		"Numpad3", "SC051",
		"Numpad4", "SC04B",
		"Numpad5", "SC04C",
		"Numpad6", "SC04D",
		"Numpad7", "SC047",
		"Numpad8", "SC048",
		"Numpad9", "SC049",
		"NumpadMult", "SC037",
		"NumpadAdd", "SC04E",
		"NumpadSub", "SC04A",
		"NumpadDot", "SC053",
		"NumpadDiv", "SC135",
		"NumpadEnter", "SC11C",
		"PgUp", "SC149",
		"PgDn", "SC151",
		"End", "SC14F",
		"Home", "SC147",
		"Ins", "SC152",
		"Del", "SC153",
		"Shift", "SC02A",
		"Ctrl", "SC01D",
		"Alt", "SC038",
		"LShift", "SC02A",
		"RShift", "SC036",
		"LCtrl", "SC01D",
		"RCtrl", "SC11D",
		"RAlt", "SC138",
		"Backspace", "SC00E",
		"Enter", "SC01C",
		"ArrLeft", "SC14B",
		"ArrUp", "SC148",
		"ArrRight", "SC14D",
		"ArrDown", "SC150",
		"F1", "SC03B",
		"F2", "SC03C",
		"F3", "SC03D",
		"F4", "SC03E",
		"F5", "SC03F",
		"F6", "SC040",
		"F7", "SC041",
		"F8", "SC042",
		"F9", "SC043",
		"F10", "SC044",
		"F11", "SC057",
		"F12", "SC058",
		;
		"Semicolon", "SC027",
		"Apostrophe", "SC028",
		"LSquareBracket", "SC01A",
		"RSquareBracket", "SC01B",
		"Tilde", "SC029",
		"Minus", "SC00C",
		"Equals", "SC00D",
		"Comma", "SC033",
		"Dot", "SC034",
		"Slash", "SC035",
		"Backslash", "SC02B",
		"A", "SC01E",
		"B", "SC030",
		"C", "SC02E",
		"D", "SC020",
		"E", "SC012",
		"F", "SC021",
		"G", "SC022",
		"H", "SC023",
		"I", "SC017",
		"J", "SC024",
		"K", "SC025",
		"L", "SC026",
		"M", "SC032",
		"N", "SC031",
		"O", "SC018",
		"P", "SC019",
		"Q", "SC010",
		"R", "SC013",
		"S", "SC01F",
		"T", "SC014",
		"U", "SC016",
		"V", "SC02F",
		"W", "SC011",
		"X", "SC02D",
		"Y", "SC015",
		"Z", "SC02C",
		"0", "SC00B",
		"1", "SC002",
		"2", "SC003",
		"3", "SC004",
		"4", "SC005",
		"7", "SC008",
		"5", "SC006",
		"6", "SC007",
		"8", "SC009",
		"9", "SC00A",
	),
	"Dvorak", Map(
		"Space", "SC039",
		"Tab", "SC00F",
		"Numpad0", "SC052",
		"Numpad1", "SC04F",
		"Numpad2", "SC050",
		"Numpad3", "SC051",
		"Numpad4", "SC04B",
		"Numpad5", "SC04C",
		"Numpad6", "SC04D",
		"Numpad7", "SC047",
		"Numpad8", "SC048",
		"Numpad9", "SC049",
		"NumpadMult", "SC037",
		"NumpadAdd", "SC04E",
		"NumpadSub", "SC04A",
		"NumpadDot", "SC053",
		"NumpadDiv", "SC135",
		"NumpadEnter", "SC11C",
		"PgUp", "SC149",
		"PgDn", "SC151",
		"End", "SC14F",
		"Home", "SC147",
		"Ins", "SC152",
		"Del", "SC153",
		"Shift", "SC02A",
		"Ctrl", "SC01D",
		"Alt", "SC038",
		"LShift", "SC02A",
		"RShift", "SC036",
		"LCtrl", "SC01D",
		"RCtrl", "SC11D",
		"RAlt", "SC138",
		"Backspace", "SC00E",
		"Enter", "SC01C",
		"ArrLeft", "SC14B",
		"ArrUp", "SC148",
		"ArrRight", "SC14D",
		"ArrDown", "SC150",
		"F1", "SC03B",
		"F2", "SC03C",
		"F3", "SC03D",
		"F4", "SC03E",
		"F5", "SC03F",
		"F6", "SC040",
		"F7", "SC041",
		"F8", "SC042",
		"F9", "SC043",
		"F10", "SC044",
		"F11", "SC057",
		"F12", "SC058",
		;
		"Semicolon", "SC02C",
		"Apostrophe", "SC010",
		"LSquareBracket", "SC00C",
		"RSquareBracket", "SC00D",
		"Tilde", "SC029",
		"Minus", "SC028",
		"Equals", "SC01B",
		"Comma", "SC011",
		"Dot", "SC012",
		"Slash", "SC01A",
		"Backslash", "SC02B",
		"A", "SC01E",
		"B", "SC031",
		"C", "SC017",
		"D", "SC023",
		"E", "SC020",
		"F", "SC015",
		"G", "SC016",
		"H", "SC024",
		"I", "SC022",
		"J", "SC02E",
		"K", "SC02F",
		"L", "SC019",
		"M", "SC032",
		"N", "SC026",
		"O", "SC01F",
		"P", "SC013",
		"Q", "SC02D",
		"R", "SC018",
		"S", "SC027",
		"T", "SC025",
		"U", "SC021",
		"V", "SC034",
		"W", "SC033",
		"X", "SC030",
		"Y", "SC014",
		"Z", "SC035",
		"0", "SC00B",
		"1", "SC002",
		"2", "SC003",
		"3", "SC004",
		"4", "SC005",
		"5", "SC006",
		"6", "SC007",
		"7", "SC008",
		"8", "SC009",
		"9", "SC00A",
	),
	"Colemak", Map(
		"Space", "SC039",
		"Tab", "SC00F",
		"Numpad0", "SC052",
		"Numpad1", "SC04F",
		"Numpad2", "SC050",
		"Numpad3", "SC051",
		"Numpad4", "SC04B",
		"Numpad5", "SC04C",
		"Numpad6", "SC04D",
		"Numpad7", "SC047",
		"Numpad8", "SC048",
		"Numpad9", "SC049",
		"NumpadMult", "SC037",
		"NumpadAdd", "SC04E",
		"NumpadSub", "SC04A",
		"NumpadDot", "SC053",
		"NumpadDiv", "SC135",
		"NumpadEnter", "SC11C",
		"PgUp", "SC149",
		"PgDn", "SC151",
		"End", "SC14F",
		"Home", "SC147",
		"Ins", "SC152",
		"Del", "SC153",
		"Shift", "SC02A",
		"Ctrl", "SC01D",
		"Alt", "SC038",
		"LShift", "SC02A",
		"RShift", "SC036",
		"LCtrl", "SC01D",
		"RCtrl", "SC11D",
		"RAlt", "SC138",
		"Backspace", "SC00E",
		"Enter", "SC01C",
		"ArrLeft", "SC14B",
		"ArrUp", "SC148",
		"ArrRight", "SC14D",
		"ArrDown", "SC150",
		"F1", "SC03B",
		"F2", "SC03C",
		"F3", "SC03D",
		"F4", "SC03E",
		"F5", "SC03F",
		"F6", "SC040",
		"F7", "SC041",
		"F8", "SC042",
		"F9", "SC043",
		"F10", "SC044",
		"F11", "SC057",
		"F12", "SC058",
		;
		"Semicolon", "SC019",
		"Apostrophe", "SC028",
		"LSquareBracket", "SC01A",
		"RSquareBracket", "SC01B",
		"Tilde", "SC029",
		"Minus", "SC00C",
		"Equals", "SC00D",
		"Comma", "SC033",
		"Dot", "SC034",
		"Slash", "SC035",
		"Backslash", "SC02B",
		"A", "SC01E",
		"B", "SC030",
		"C", "SC02E",
		"D", "SC022",
		"E", "SC025",
		"F", "SC012",
		"G", "SC014",
		"H", "SC023",
		"I", "SC026",
		"J", "SC015",
		"K", "SC031",
		"L", "SC016",
		"M", "SC032",
		"N", "SC024",
		"O", "SC027",
		"P", "SC013",
		"Q", "SC010",
		"R", "SC01F",
		"S", "SC020",
		"T", "SC021",
		"U", "SC017",
		"V", "SC02F",
		"W", "SC011",
		"X", "SC02D",
		"Y", "SC018",
		"Z", "SC02C",
		"0", "SC00B",
		"1", "SC002",
		"2", "SC003",
		"3", "SC004",
		"4", "SC005",
		"5", "SC006",
		"6", "SC007",
		"7", "SC008",
		"8", "SC009",
		"9", "SC00A",
	),
)

CyrllicLayouts := Map(
	"ЙЦУКЕН", Map(),
	"Диктор", Map(),
	"ЙІУКЕН (1907)", Map(),
)


RegisterLayout(LayoutName := "QWERTY", DefaultRule := "QWERTY", ForceApply := False) {
	global ActiveScriptName

	IsLatin := False
	IsCyrillic := False
	ActiveLatin := IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")
	ActiveCyrillic := IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН")

	for key in GetLayoutsList {
		if LayoutName == key {
			IsLatin := True
			break
		}
	}
	if !IsLatin {
		for key in CyrillicLayoutsList {
			if LayoutName == key {
				IsCyrillic := True
				break
			}
		}
	}

	if Keyboard.disabledByMonitor || Keyboard.disabledByUser {
		if IsLatin {
			IniWrite LayoutName, ConfigFile, "Settings", "LatinLayout"
		} else if IsCyrillic {
			IniWrite LayoutName, ConfigFile, "Settings", "CyrillicLayout"
		}
		return
	} else {
		if IsLatin {
			IniWrite LayoutName, ConfigFile, "Settings", "LatinLayout"
		} else if IsCyrillic {
			IniWrite LayoutName, ConfigFile, "Settings", "CyrillicLayout"
		}

		UnregisterKeysLayout()

		if (IsLatin && LayoutName != "QWERTY") || (IsCyrillic && LayoutName != "ЙЦУКЕН") || (IsLatin && ActiveCyrillic != "ЙЦУКЕН") || (IsCyrillic && ActiveLatin != "QWERTY") || ForceApply {
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "NonQWERTY"), True)
		}


		IsLettersModeEnabled := ActiveScriptName != "" ? ActiveScriptName : False


		RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Utility"), True)
		RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))

		if IsLettersModeEnabled {
			ActiveScriptName := ""
			ToggleLetterScript(True, IsLettersModeEnabled)
		}
	}
}

GetLayoutsList := []
for keysLayout in LayoutsPresets {
	GetLayoutsList.Push(keysLayout)
}

CyrillicLayoutsList := []
for keysLayout in CyrllicLayouts {
	CyrillicLayoutsList.Push(keysLayout)
}

ChooseKeyByLayout(Script := "Latin", KeyNames*) {
	for i, keyName in KeyNames {
		if Script = "Latin" {
			GetActiveLatin := IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")

			try {
				if GetActiveLatin = "QWERTY" {
					return KeyNames[i]
				} else if GetActiveLatin = "Dvorak" {
					return KeyNames[i + 1]
				} else if GetActiveLatin = "Colemak" {
					return KeyNames[i + 2]
				}
			} catch {
				return KeyNames[i]
			}


		} else if Script = "Cyrillic" {
			GetActiveCyrillic := IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН")

			try {
				if GetActiveCyrillic = "ЙЦУКЕН" {
					return KeyNames[i]
				} else if GetActiveCyrillic = "Диктор" {
					return KeyNames[i + 1]
				}
			} catch {
				return KeyNames[i]
			}
		}
	}
}

RoNum := Map(
	"00-HundredM", Chr(0x2188),
	"01-FiftyTenM", Chr(0x2187),
	"02-TenM", Chr(0x2182),
	"03-FiveM", Chr(0x2181),
	"04-M", Chr(0x216F),
	"05-D", Chr(0x216E),
	"06-C", Chr(0x216D),
	"07-L", Chr(0x216C),
	;"08-XII", Chr(0x216B),
	;"09-XI", Chr(0x216A),
	"10-X", Chr(0x2169),
	"11-IX", Chr(0x2168),
	"12-VIII", Chr(0x2167),
	"13-VII", Chr(0x2166),
	"14-VI", Chr(0x2165),
	"15-V", Chr(0x2164),
	"16-IV", Chr(0x2163),
	"17-III", Chr(0x2162),
	"18-II", Chr(0x2161),
	"19-I", Chr(0x2160),
	"20-sHundredM", Chr(0x2188),
	"21-sFiftyTenM", Chr(0x2187),
	"22-sTenM", Chr(0x2182),
	"23-sFiveM", Chr(0x2181),
	"24-sM", Chr(0x217F),
	"25-sD", Chr(0x217E),
	"26-sC", Chr(0x217D),
	"27-sL", Chr(0x217C),
	;"28-sXII", Chr(0x217B),
	;"29-sXI", Chr(0x217A),
	"30-sX", Chr(0x2179),
	"31-sIX", Chr(0x2178),
	"32-sVIII", Chr(0x2177),
	"33-sVII", Chr(0x2176),
	"34-sVI", Chr(0x2175),
	"35-sV", Chr(0x2174),
	"36-sIV", Chr(0x2173),
	"37-sIII", Chr(0x2172),
	"38-sII", Chr(0x2171),
	"39-sI", Chr(0x2170),
)


Chrs(CharacterEntries*) {
	Output := ""

	for entryArray in CharacterEntries {
		if IsObject(entryArray) {
			charCode := entryArray[1]
			charRepeats := entryArray.Has(2) ? entryArray[2] : 1

			Loop charRepeats
				Output .= Chr(charCode)
		} else {
			Output .= Chr(entryArray)
		}
	}

	return Output
}

GetChar(CharacterNames*) {
	Output := ""
	IndexMap := Map()

	CharacterIndex := 0
	for _, Character in CharacterNames {
		CharacterIndex++
		CharacterRepeat := 1
		CharacterMatch := Character

		if !IsObject(Character) {
			if RegExMatch(CharacterMatch, "(.+?)\[(\d+(?:,\d+)*)\]$", &match) {
				if RegExMatch(match[1], "(.+?)×(\d+)$", &subMatch) {
					Character := subMatch[1]
					CharacterRepeat := subMatch[2]
				} else {
					Character := match[1]
				}
				Positions := StrSplit(match[2], ",")
				for _, Position in Positions {
					Position := Number(Position)
					if !IndexMap.Has(Position) {
						IndexMap[Position] := []
					}
					IndexMap[Position].Push([Character, CharacterRepeat])
				}
				continue
			}

			if RegExMatch(CharacterMatch, "(.+?)×(\d+)$", &match) {
				Character := match[1]
				CharacterRepeat := match[2]
			}
		}

		if !IndexMap.Has(CharacterIndex) {
			IndexMap[CharacterIndex] := []
		}
		IndexMap[CharacterIndex].Push([Character, CharacterRepeat])
	}

	for indexEntry, value in IndexMap {
		for _, charData in value {
			GetCharacterSequence(charData[1], charData[2])
		}
	}

	GetCharacterSequence(CharacterName, CharacterRepeat) {
		if IsObject(CharacterName) {
			Output .= CharacterName()
		} else {
			for characterEntry, value in Characters {
				TrimValue := RegExReplace(characterEntry, "^\S+\s+")
				if (TrimValue = CharacterName) {
					if CharacterRepeat > 1 {
						Loop CharacterRepeat {
							if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
								for unicode in value.uniSequence {
									Output .= PasteUnicode(unicode)
								}
							} else {
								Output .= PasteUnicode(value.unicode)
							}
						}
					} else {
						if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
							for unicode in value.uniSequence {
								Output .= PasteUnicode(unicode)
							}
						} else {
							Output .= PasteUnicode(value.unicode)
						}
					}
					break
				}
			}
		}
	}

	return Output
}

CallChar(CharacterName, GetValue) {
	Result := ""
	for characterEntry, value in Characters {
		TrimValue := RegExReplace(characterEntry, "^\S+\s+")
		if (TrimValue = CharacterName) && HasProp(value, GetValue) {
			Result := value.%GetValue%
			break
		}
	}
	return Result
}


GetMapCount(MapObj, SortGroups := "") {
	properties := ["combining", "uncombined", "modifier", "subscript", "italic", "italicBold", "bold", "script", "fraktur", "scriptBold", "frakturBold", "doubleStruck", "doubleStruckBold", "doubleStruckItalic", "doubleStruckItalicBold", "sansSerif", "sansSerifItalic", "sansSerifItalicBold", "sansSerifBold", "monospace", "smallCapital"]
	if !IsObject(SortGroups) {
		keyCount := MapObj.Count

		for characterEntry, value in MapObj {
			if HasProp(value, "calcOff") {
				keyCount--
			}
			for property in properties {
				if HasProp(value, property "Form") {
					keyCount++
				}
			}
		}

		return keyCount
	} else {
		keyCount := 0
		for characterEntry, value in MapObj {
			for group in SortGroups {
				groupsEntry := value.group[1]

				if IsObject(groupsEntry) {
					if CheckGroupMatch(groupsEntry, group) {
						keyCount++
						break
					}
				} else if (groupsEntry = group) {
					keyCount++
					break
				}
			}

			if HasProp(value, "calcOff") {
				keyCount--
			}
			for property in properties {
				if HasProp(value, property) {
					keyCount++
				}
			}
		}
		return keyCount
	}
}


CheckGroupMatch(groupsEntry, targetGroup) {
	for subGroup in groupsEntry {
		if IsObject(subGroup) {
			for nestedGroup in subGroup {
				if (nestedGroup = targetGroup) {
					return true
				}
			}
		} else if (subGroup = targetGroup) {
			return true
		}
	}
	return False
}

InsertCharactersGroups(TargetArray := "", GroupName := "", GroupHotKey := "", AddSeparator := True, InsertingOption := "", BlackList := []) {
	if GroupName == "" {
		return
	}

	LanguageCode := Language.Get()
	TermporaryArray := []

	RecipesMicroController(recipeEntry) {
		RecipeString := ""
		if IsObject(recipeEntry) {
			totalCount := 0
			for index in recipeEntry {
				totalCount++
			}

			currentIndex := 0
			for index, recipe in recipeEntry {
				RecipeString .= recipe
				currentIndex++
				if (currentIndex < totalCount) {
					RecipeString .= ", "
				}
			}
		} else {
			RecipeString := recipeEntry
		}
		return RecipeString
	}


	if AddSeparator
		TermporaryArray.Push(["", "", "", "", "", ""])
	if GroupHotKey != ""
		TermporaryArray.Push(["", GroupHotKey, "", "", "", ""])

	for characterEntry, value in Characters {
		entryID := ""
		entryName := ""
		if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
			entryID := match[1]
			entryName := match[2]
		}

		isFavorite := FavoriteChars.CheckVar(characterEntry)

		for blackListEntry in BlackList {
			if (blackListEntry = entryName) {
				continue 2
			}
		}

		GroupValid := False

		IsDefault := InsertingOption = ""

		if (InsertingOption = "Recipes" && !HasProp(value, "recipe")) || (IsDefault && HasProp(value, "group") && !value.group.Has(2)) {
			continue
		}

		if (HasProp(value, "group") && value.group[1] == GroupName) {
			GroupValid := True
		} else if (HasProp(value, "group") && IsObject(value.group[1])) {
			for group in value.group[1] {
				if (group = GroupName) {
					GroupValid := True
					break
				}
			}
		}

		if GroupValid {
			if (InsertingOption = "Fast Special" && !HasProp(value, "alt_special")) {
				continue
			}

			if InsertingOption = "Alternative Layout" && HasProp(value, "alt_layout") {
				value.alt_layout_options := True
			} else {
				value.alt_layout_options := False
			}

			characterTitle := ""
			if InsertingOption = "Alternative Layout" && HasProp(value, "alt_layout_title") && value.alt_layout_title && !InStr(Locale.Read(entryName "_layout"), "NOT FOUND") {
				characterTitle := Locale.Read(entryName "_layout")
			} else if !InStr(Locale.Read(entryName), "NOT FOUND") {
				characterTitle := Locale.Read(entryName)
			} else if (HasProp(value, "titles")) {
				characterTitle := value.titles[LanguageCode]
			} else {
				characterTitle := Locale.Read(entryName)
			}

			if isFavorite {
				characterTitle .= " " Chr(0x2605)
			}

			characterSymbol := HasProp(value, "symbol") ? value.symbol : ""
			characterModifier :=
				(HasProp(value, "modifier") && (InsertingOption = "Fast Special" || InsertingOption = "Fast Keys")) ? value.modifier :
				HasProp(value, "defaultModifier") ? value.defaultModifier : ""
			characterBinding := ""

			if (InsertingOption = "Recipes") {
				if (HasProp(value, "recipeAlt")) {
					characterBinding := RecipesMicroController(value.recipeAlt)
				} else if (HasProp(value, "recipe")) {
					characterBinding := RecipesMicroController(value.recipe)
				} else {
					characterBinding := ""
				}
			} else if (InsertingOption = "Alternative Layout" && HasProp(value, "alt_layout")) {
				characterBinding := value.alt_layout
			} else if (InsertingOption = "Fast Special" && HasProp(value, "alt_special")) {
				characterBinding := value.alt_special
			} else if (InsertingOption = "Fast Keys" && HasProp(value, "alt_on_fast_keys")) {
				characterBinding := value.alt_on_fast_keys
			} else {
				if value.group.Has(2) {
					characterBinding := Util.FormatHotKey(value.group[2], characterModifier)
				}
			}

			if InsertingOption != "Fast Keys" || InsertingOption = "Fast Keys" && (HasProp(value, "show_on_fast_keys") && value.show_on_fast_keys) || InsertingOption = "Raw" {
				TermporaryArray.Push([characterTitle, characterBinding, characterSymbol, UniTrim(value.unicode), entryID, entryName])
			}
		}
	}

	if TargetArray == "" {
		return TermporaryArray
	} else {
		for element in TermporaryArray {
			TargetArray.Push(element)
		}
	}
}
#Include <chr_lib_legacy>
#Include <cls_tempature_converter>

GetCountDifference() {
	Output := StaticCount
	CurrentCount := GetMapCount(Characters)
	if CurrentCount > StaticCount {
		Output := StaticCount " +" (CurrentCount - StaticCount) " " Locale.Read("with_my_recipes")
	}
	return Output
}


ReplaceModifierKeys(Input) {
	Output := Input
	if IsObject(Output) {
		for i, k in Output {
			Output[i] = ReplaceModifierKeys(k)
		}
	} else {
		Output := RegExReplace(Output, "\<\!", LeftAlt)
		Output := RegExReplace(Output, "\>\!", RightAlt)
		Output := RegExReplace(Output, "\<\+", LeftShift)
		Output := RegExReplace(Output, "\>\+", RightShift)
		Output := RegExReplace(Output, "\<\^", LeftControl)
		Output := RegExReplace(Output, "\>\^", RightControl)
		Output := RegExReplace(Output, "c\*", CapsLock)
	}
	return Output
}

ProcessMapAfter(GroupLimited := "") {
	global Characters
	Translations := [
		"acute", "acute", "акутом",
		"acute_double", "double acute", "двойным акутом",
		"acute_below", "acute below", "акутом сеизу",
		"acute_tone_vietnamese", "tone acute", "акутом тона",
		"asterisk_above", "asterisk above", "астериском сверху",
		"asterisk_below", "asterisk below", "астериском снизу",
		"breve", "breve", "краткой",
		"breve_inverted", "inverted breve", "перевёрнутой краткой",
		"breve_below", "breve below", "краткой снизу",
		"breve_inverted_below", "inverted breve below", "перевёрнутой краткой снизу",
		"bridge_above", "bridge above", "мостиком сверху",
		"bridge_below", "bridge below", "мостиком снизу",
		"bridge_inverted_below", "inverted bridge below", "перевёрнутым мостиком снизу",
		"circumflex", "circumflex", "циркумфлексом",
		"circumflex_below", "circumflex below", "циркумфлексом снизу",
		"caron", "caron", "гачеком",
		"caron_below", "caron below", "гачеком снизу",
		"cedilla", "cedilla", "седилью",
		"comma_above", "comma above", "запятой сверху",
		"comma_below", "comma below", "запятой снизу",
		"comma_above_turned", "turned comma above", "перевёрнутой запятой сверху",
		"comma_above_reversed", "reversed comma above", "зеркальной запятой сверху",
		"comma_above_right", "comma above right", "запятой сверху справа",
		"candrabindu", "candrabindu", "чандрабинду",
		"dot_above", "dot above", "точкой сверху",
		"diaeresis", "diaeresis", "диерезисом",
		"dot_below", "dot below", "точкой снизу",
		"diaeresis_below", "diaeresis below", "диерезисом снизу",
		"fermata", "fermata", "ферматой",
		"grave", "grave", "грависом",
		"grave_double", "double grave", "двойным грависом",
		"grave_below", "grave below", "грависом снизу",
		"grave_tone_vietnamese", "tone grave", "грависом тона",
		"hook_above", "hook above", "хвостиком сверху",
		"horn", "horn", "рожком",
		"palatal_hook_below", "palatal hook", "палатальным крюком",
		"retroflex_hook_below", "retroflex hook", "ретрофлексным крюком",
		"macron", "macron", "макроном",
		"macron_below", "macron below", "макроном снизу",
		"ogonek", "ogonek", "огонэком",
		"ogonek_above", "ogonek above", "огонэком сверху",
		"overline", "overline", "чертой сверху",
		"overline_double", "double overline", "двойной чертой сверху",
		"low_line", "low line", "чертой снизу",
		"low_line_double", "double low line", "двойной чертой снизу",
		"ring_above", "ring above", "кольцом сверху",
		"ring_below", "ring below", "кольцом снизу",
		"ring_below_double", "double ring below", "двойным кольцом снизу",
		"line_vertical", "vertical line", "вертикальной линией",
		"line_vertical_double", "double vertical line", "двойной вертикальной линией",
		"line_vertical_below", "vertical line below", "вертикальной линией снизу",
		"line_vertical_double_below", "double vertical line below", "двойной вертикальной линией снизу",
		"stroke_short", "stroke", "штрихом",
		"stroke_long", "long stroke", "длинным штрихом",
		"solidus_short", "diagonal stroke", "диагональным штрихом",
		"solidus_long", "oblique stroke", "косым штрихом",
		"tilde", "tilde", "тильдой",
		"tilde_vertical", "vertical tilde", "вертикальной тильдой",
		"tilde_below", "tilde below", "тильдой снизу",
		"tilde_not", "not tilde", "перечёрнутой тильдой",
		"tilde_overlay", "tilde overlay", "тильдой посередине",
		"x_above", "x above", "крестиком сверху",
		"x_below", "x below", "крестиком снизу",
		"zigzag_above", "z above", "зигзагом сверху",
	]
	ExtraTranslations := [
		"topbar", "topbar", "чертой сверху",
		"crossed_tail", "crossed‑tail", "завитком",
		"curl", "curl", "завитком",
		"common_hook_above", "hook above", "крюком сверху",
		"common_hook", "hook", "крюком",
		"right_chook", "right hook", "крюком вправо",
		"long_leg", "long leg", "ножкой",
		"swash_hook", "swash hook", "наклонным крюком",
		"fishhook", "fishhook", "крючком",
		"insular_turned", "turned insular", "перевёрнутая островная",
		"insular_closed", "closed insular", "закрытая островная",
		"insular", "insular", "островная",
		"flourish", "flourish", "завитком",
		"notch", "notch", "бороздой",
		"descender", "descender", "нижним выносным элементом",
		"squirrel_tail", "squirrel tail", "беличьим хвостиком",
		"tail", "tail", "хвостиком",
		"upturn", "upturn", "подъёмом",
		"halfleft", "half", "половинная",
		"halfright", "turned half", "перевёрнутая половинная",
		"belt", "belt", "ремешком",
		"open", "open", "открытая",
		"loop", "loop", "петлёй",
		"sideways", "sideways", "на боку",
		"dot_middle", "middle dot", "точкой посередине",
		"ring_middle", "middle ring", "кольцом посередине",
		"inverted_lazy_s", "inverted lazy s", "перевёрнутая плавная s",
		"stroke_short_high", "high stroke", "высоким штрихом",
		"stroke_short_down", "down stroke", "штрихом снизу",
	]

	Library := Map("Diacritic Mark", [], "Spaces", [])

	for characterEntry, value in Characters {
		EntryName := RegExReplace(characterEntry, "^\S+\s+")
		if HasProp(value, "symbolClass") {
			if value.symbolClass = "Diacritic Mark" {
				Library["Diacritic Mark"].Push(EntryName)
				Library["Diacritic Mark"].Push(GetChar(EntryName))
			} else if value.symbolClass = "Spaces" {
				Library["Spaces"].Push(GetChar(EntryName))
			} else {
				continue
			}
		}
	}


	for characterEntry, value in Characters {
		if GroupLimited != "" {
			FoundGroup := False

			if HasProp(value, "group") {
				if IsObject(value.group[1]) {
					for group in value.group[1] {
						if (group = GroupLimited) {
							FoundGroup := True
						}
					}
				} else {
					if (value.group[1] = GroupLimited) {
						FoundGroup := True
					}
				}
			}

			if !FoundGroup {
				continue
			}
		}

		EntryName := RegExReplace(characterEntry, "^\S+\s+")
		EntryCharacter := GetChar(EntryName)
		TitleSequence := { ru: "", en: "" }
		PreletterSequence := { ru: "", en: "" }

		RegExMatch(EntryName, "^(.+)_(.)_let_([^\W_]+)", &EntryExpression)
		RegExMatch(EntryName, "^(.+)_(.)_(.)_let_([^\W_]+)", &CapExpression)

		EntryParts := {
			script: CapExpression ? CapExpression[1] : EntryExpression ? EntryExpression[1] : "",
			case: CapExpression ? CapExpression[2] : EntryExpression ? EntryExpression[2] : "",
			cap: CapExpression ? CapExpression[3] : "",
			letter: CapExpression ? CapExpression[4] : EntryExpression ? EntryExpression[3] : "",
		}

		ValueLetter := HasProp(value, "letter") ? value.letter : EntryParts.letter
		LetterVar := (EntryParts.cap = "c" || EntryParts.case = "c") ? StrUpper(ValueLetter) : ValueLetter

		if RegExMatch(EntryName, "^permic") {
			value.symbolFont := "Noto Sans Old Permic"
		} else if RegExMatch(EntryName, "^turkic") {
			;value.symbolFont := "Noto Sans Old Turkic"
		} else if RegExMatch(EntryName, "^hungarian") {
			value.symbolFont := "Noto Sans Old Hungarian"
		} else if RegExMatch(EntryName, "^phoenician") {
			value.symbolFont := "Segoe UI Historic"
		}

		for i, pair in EntitiesLibrary {
			if Mod(i, 2) = 1 {
				Symbol := pair
				Entity := EntitiesLibrary[i + 1]

				if EntryCharacter = Symbol {
					value.entity := Entity
					break
				}
			}
		}

		for i, pair in AltCodesLibrary {
			if Mod(i, 2) = 1 {
				Symbol := pair
				AltCode := AltCodesLibrary[i + 1]

				if EntryCharacter = Symbol {
					if !HasProp(value, "altCode") {
						value.altCode := ""
					}

					if !InStr(value.altCode, AltCode) {
						value.altCode .= AltCode " "
					}
				}
			}
		}

		if HasProp(value, "altCode") {
			value.altCode := RegExReplace(value.altCode, "\s$", "")
		}

		if !HasProp(value, "html") {
			value.html := ""

			if HasProp(value, "uniSequence") {
				for uniSequence in value.uniSequence {
					value.html .= "&#" ConvertToDecimal(PasteUnicode(uniSequence)) ";"
				}
			} else {
				value.html := "&#" ConvertToDecimal(EntryCharacter) ";"
			}
		}

		Alterations := ["combining", "uncombined", "modifier", "subscript", "italic", "italicBold", "bold", "script", "fraktur", "scriptBold", "frakturBold", "doubleStruck", "doubleStruckBold", "doubleStruckItalic", "doubleStruckItalicBold", "sansSerif", "sansSerifItalic", "sansSerifItalicBold", "sansSerifBold", "monospace", "smallCapital"]

		for alteration in Alterations {
			if HasProp(value, alteration "Form") {
				if !HasProp(value, alteration "HTML") {
					value.%alteration%HTML := ""
				}
				if IsObject(value.%alteration%Form) {
					for FormUnicodeKey in value.%alteration%Form {
						value.%alteration%HTML .= "&#" ConvertToDecimal(PasteUnicode(FormUnicodeKey)) ";"
					}
				} else {
					value.%alteration%HTML := "&#" ConvertToDecimal(PasteUnicode(value.%alteration%Form)) ";"
				}
			}
		}

		ModifierReplacements := ["alt_special", "modifier", "alt_layout"]

		for modifierReplace in ModifierReplacements {
			if HasProp(value, modifierReplace) {
				value.%modifierReplace% := ReplaceModifierKeys(value.%modifierReplace%)
			}
		}

		if HasProp(value, "alt_on_fast_keys") {
			if EntryParts.script != "" {
				value.alt_on_fast_keys := RegExReplace(value.alt_on_fast_keys, "\$", "[" LetterVar "]")
			}
			value.alt_on_fast_keys := ReplaceModifierKeys(value.alt_on_fast_keys)
		}
		if (HasProp(value, "group") && value.group.Has(2)) {
			value.group[2] := ReplaceModifierKeys(value.group[2])
		}


		for i, diacriticLocalize in ExtraTranslations {
			if Mod(i, 3) = 1 {
				ExtraName := ExtraTranslations[i]
				ExtraEnglish := ExtraTranslations[i + 1]
				ExtraRussian := ExtraTranslations[i + 2]


				if RegExMatch(EntryName, ExtraName "$") {
					IsNotAddWith := ExtraName = "insular" || ExtraName = "insular_turned" || ExtraName = "halfleft" || ExtraName = "halfright" || ExtraName = "open" || ExtraName = "sideways"
					if IsNotAddWith {
						PreletterSequence.en := ExtraEnglish " "
						PreletterSequence.ru := ExtraRussian " "

					} else {
						WithRussian := !InStr(TitleSequence.ru, " с ") ? " с " : ""
						WithEnglish := !InStr(TitleSequence.en, " with ") ? " with " : ""

						TitleSequence.en .= WithEnglish ExtraEnglish ", "
						TitleSequence.ru .= WithRussian ExtraRussian ", "
					}
					break
				}
			}
		}

		if !HasProp(value, "symbol") {
			if HasProp(value, "symbolClass") {
				if value.symbolClass = "Diacritic Mark" {
					value.symbol := GetChar("dotted_circle") EntryCharacter
				} else if value.symbolClass = "Spaces" {
					value.symbol := "[" EntryCharacter "]"
					value.symbolCustom := "underline"
				} else {
					value.symbol := EntryCharacter
				}
			} else {
				value.symbol := EntryCharacter
			}
		}

		if (EntryExpression && (EntryParts.script = "lat" || EntryParts.script = "cyr") && !HasProp(value, "group")) {
			value.group := ["Default Letters"]
		}

		if HasProp(value, "recipe") {
			if IsObject(value.recipe) {
				if EntryParts.script != "" {
					for i, recipe in value.recipe {
						value.recipe[i] := RegExReplace(recipe, "^\$", LetterVar)
					}
				}

				SplittedRecipes := StrSplit(value.recipe[1])
				PreviousChar := ""
				for k, char in SplittedRecipes {
					if char == PreviousChar {
						continue
					}
					NextChar := k < SplittedRecipes.Length ? SplittedRecipes[k + 1] : ""
					PreviousChar := char
					foundMatch := False

					for index, pair in Library["Diacritic Mark"] {
						if (Mod(index, 2) = 1) {
							SymbolName := pair
							SymbolChar := Library["Diacritic Mark"][index + 1]

							if InStr(char, SymbolChar) {
								for i, diacriticLocalize in Translations {
									if Mod(i, 3) = 1 {
										DiacriticName := diacriticLocalize
										EnglishTranslation := Translations[i + 1]
										RussianTranslation := Translations[i + 2]
										DoublingRu := (char == NextChar) ? (InStr(DiacriticName, "tilde") ? "двойной " : "двойным ") : ""
										DoublingEn := (char == NextChar) ? ("double ") : ""

										if SymbolName == DiacriticName {
											WithRussian := (DiacriticName == "stroke_short" && (!InStr(TitleSequence.ru, " с ") || !InStr(TitleSequence.ru, " со "))) ? " со " : !InStr(TitleSequence.ru, " с ") ? " с " : ""
											WithEnglish := !InStr(TitleSequence.en, " with ") ? " with " : ""

											TitleSequence.en .= WithEnglish DoublingEn EnglishTranslation ", "
											TitleSequence.ru .= WithRussian DoublingRu RussianTranslation ", "
											break
										}
									}
								}

								ModifiedRecipe .= GetChar("dotted_circle") SymbolChar
								RecipeModified := true
								foundMatch := true
								break
							}
						}
					}

					if !foundMatch {
						ModifiedRecipe .= char
					}
				}

				RecipeAltCreated := False
				for recipe in value.recipe {
					ModifiedRecipe := ""
					setClass := ""
					RecipeModified := False

					for k, char in StrSplit(recipe) {
						foundMatch := False

						for i, pair in Library["Diacritic Mark"] {
							if (Mod(i, 2) = 1) {
								SymbolName := pair
								SymbolChar := Library["Diacritic Mark"][i + 1]

								if InStr(char, SymbolChar) {
									ModifiedRecipe .= GetChar("dotted_circle") SymbolChar
									RecipeModified := true
									setClass := EntryParts.script = "lat" ? "Latin Accented" : EntryParts.script = "cyr" ? "Cyrillic Accented" : ""
									foundMatch := true
									break
								}
							}
						}

						if !foundMatch {
							ModifiedRecipe .= char
						}
					}

					if RecipeModified {
						if !RecipeAltCreated {
							value.recipeAlt := []
							RecipeAltCreated := true
						}
						value.recipeAlt.Push(ModifiedRecipe)
					}

					if setClass != "" && !HasProp(value, "symbolClass") {
						value.symbolClass := setClass
					}
				}


			} else {
				if EntryParts.script != "" {
					ValueLetter := HasProp(value, "letter") ? value.letter : EntryParts.letter
					LetterVar := (EntryParts.cap = "c" || EntryParts.case = "c") ? StrUpper(ValueLetter) : ValueLetter
					value.recipe := RegExReplace(value.recipe, "^\$", LetterVar)
				}

				ModifiedRecipe := ""
				setClass := ""
				RecipeModified := False

				FirstChar := SubStr(value.recipe, 1, 1)

				SplittedRecipes := StrSplit(value.recipe)
				PreviousChar := ""
				for k, char in SplittedRecipes {
					if char == PreviousChar {
						continue
					}
					NextChar := k < SplittedRecipes.Length ? SplittedRecipes[k + 1] : ""
					PreviousChar := char
					foundMatch := False

					for index, pair in Library["Diacritic Mark"] {
						if (Mod(index, 2) = 1) {
							SymbolName := pair
							SymbolChar := Library["Diacritic Mark"][index + 1]

							if InStr(char, SymbolChar) {
								for i, diacriticLocalize in Translations {
									if Mod(i, 3) = 1 {
										DiacriticName := diacriticLocalize
										EnglishTranslation := Translations[i + 1]
										RussianTranslation := Translations[i + 2]
										DoublingRu := (char == NextChar) ? (InStr(DiacriticName, "tilde") ? "двойной " : "двойным ") : ""
										DoublingEn := (char == NextChar) ? ("double ") : ""

										if SymbolName == DiacriticName {
											WithRussian := (DiacriticName == "stroke_short" && (!InStr(TitleSequence.ru, " с ") || !InStr(TitleSequence.ru, " со "))) ? " со " : !InStr(TitleSequence.ru, " с ") ? " с " : ""
											WithEnglish := !InStr(TitleSequence.en, " with ") ? " with " : ""

											TitleSequence.en .= WithEnglish DoublingEn EnglishTranslation ", "
											TitleSequence.ru .= WithRussian DoublingRu RussianTranslation ", "
											break
										}
									}
								}

								ModifiedRecipe .= GetChar("dotted_circle") SymbolChar
								RecipeModified := true
								setClass := EntryParts.script = "lat" ? "Latin Accented" : EntryParts.script = "cyr" ? "Cyrillic Accented" : ""
								foundMatch := true

								if !HasProp(value, "LaTeX") {
									if CallChar(SymbolName, "LaTeX") != "" && !IsObject(CallChar(SymbolName, "LaTeX")) {
										value.LaTeX := CallChar(SymbolName, "LaTeX") "{" FirstChar "}"
									} else if IsObject(CallChar(SymbolName, "LaTeX")) {
										value.LaTeX := []
										for i, LaTeX in CallChar(SymbolName, "LaTeX") {
											value.LaTeX.Push(LaTeX "{" FirstChar "}")
										}
									}
								}

								break
							}
						}
					}

					if !foundMatch {
						ModifiedRecipe .= char
					}
				}

				if RecipeModified {
					value.recipeAlt := ModifiedRecipe
				}

				if setClass != "" && !HasProp(value, "symbolClass") {
					value.symbolClass := setClass
				}
			}

			if EntryParts.script != "" {
				if !HasProp(value, "titles") {
					value.titles := Map("ru", "", "en", "")
				}
				if !HasProp(value, "titlesAltOnEntry") {
					value.titlesAltOnEntry := Map("ru", "", "en", "")
				}

				ValueLetter := HasProp(value, "letter") ? value.letter : EntryParts.letter
				LetterVar := (EntryParts.cap = "c" || EntryParts.case = "c") ? StrUpper(ValueLetter) : ValueLetter
				CaseRu := EntryParts.cap = "c" ? "капитель" : EntryParts.case = "c" ? "прописная" : "строчная"
				CaseEn := EntryParts.cap = "c" ? "small capital" : EntryParts.case = "c" ? "Capital" : "Small"
				AltCaseRu := EntryParts.cap = "c" ? "Капитель " : ""
				AltCaseEn := EntryParts.cap = "c" ? "Small Capital " : ""

				Prefix := EntryParts.script = "cyr" ? "cyrillic " : ""
				Postfix := EntryParts.script = "cyr" ? " кириллицы" : ""

				TitleSequence.ru := RegExReplace(TitleSequence.ru, ",\s$", "")
				TitleSequence.en := RegExReplace(TitleSequence.en, ",\s$", "")

				TitleSequence.ru := RegExReplace(TitleSequence.ru, ",\s([^,]*)$", " и $1")
				TitleSequence.en := RegExReplace(TitleSequence.en, ",\s([^,]*)$", " and $1")

				TitleSequence.ru := RegExReplace(TitleSequence.ru, "\s\sс", "")


				FullTagRu := StrLower(CaseRu) " буква " PreletterSequence.ru LetterVar TitleSequence.ru Postfix
				FullTagEn := Prefix StrLower(CaseEn) " letter " PreletterSequence.en LetterVar TitleSequence.en
				if HasProp(value, "tags") {

					for index, tag in value.tags {
						tag := RegExReplace(tag, "R\^\$", FullTagRu)
						tag := RegExReplace(tag, "E\^\$", FullTagEn)
						tag := RegExReplace(tag, "R\$", CaseRu " буква " LetterVar)
						tag := RegExReplace(tag, "E\$", CaseEn " letter " LetterVar)
						value.tags[index] := tag
					}
				} else {
					value.tags := [FullTagRu, FullTagEn]
				}

				if (!HasProp(value, "forceINI") || (HasProp(value, "forceINI") && value.forceINI != True)) {

					if EntryParts.script = "lat" {
						value.titles["ru"] := "Лат. " CaseRu " " PreletterSequence.ru LetterVar TitleSequence.ru
						value.titles["en"] := "Lat. " CaseEn " " PreletterSequence.en LetterVar TitleSequence.en
						value.titlesAltOnEntry["ru"] := AltCaseRu PreletterSequence.ru LetterVar TitleSequence.ru
						value.titlesAltOnEntry["en"] := AltCaseEn PreletterSequence.en LetterVar TitleSequence.en
					} else if EntryParts.script = "cyr" {
						value.titles["ru"] := "Кир. " CaseRu " " PreletterSequence.ru LetterVar TitleSequence.ru
						value.titles["en"] := "Cyr. " CaseEn " " PreletterSequence.en LetterVar TitleSequence.en
						value.titlesAltOnEntry["ru"] := AltCaseRu PreletterSequence.ru LetterVar TitleSequence.ru
						value.titlesAltOnEntry["en"] := AltCaseEn PreletterSequence.en LetterVar TitleSequence.en
					}
				}
			}
		}
	}

}

ProcessMapAfter()

;CharCodes.smelter.cyrillic_Multiocular_O := ["{U+A66E}", "&#42606;"]

UniTrim(Str) {
	return SubStr(Str, 4, StrLen(Str) - 4)
}


InputBridge(GroupKey) {
	ih := InputHook("L1 C M")
	ih.Start()
	ih.Wait()
	keyPressed := ""

	if GetKeyState("RShift", "P") {
		keyPressed := "RShift+" . ih.Input
	} else {
		keyPressed := ih.Input
	}

	ProceedEntriesHandle(keyPressed, GroupKey)

	ih.Stop()
	return
}
ProceedEntriesHandle(keyPressed, GroupKey) {
	for characterEntry, value in Characters {
		GroupValid := False
		if (HasProp(value, "group") && value.group[1] == GroupKey) {
			GroupValid := True
		} else if (HasProp(value, "group") && IsObject(value.group[1])) {
			for group in value.group[1] {
				if (group = GroupKey) {
					GroupValid := True
					break
				}
			}
		}

		if GroupValid && value.group.Has(2) {
			characterKeys := value.group[2]
			characterEntity := (HasProp(value, "entity")) ? value.entity : (HasProp(value, "html")) ? value.html : ""
			characterLaTeX := (HasProp(value, "LaTeX")) ? value.LaTeX : ""

			ModifiedCharsType := GetModifiedCharsType()

			if IsObject(characterKeys) {
				for _, key in characterKeys {
					if (keyPressed == key) {
						if InputMode = "HTML" && HasProp(value, "html") {
							(ModifiedCharsType && HasProp(value, ModifiedCharsType "HTML")) ? SendText(value.%ModifiedCharsType%HTML) :
							SendText(characterEntity)
						} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
							SendText(IsObject(characterLaTeX) ? (LaTeXMode = "Math" ? characterLaTeX[2] : characterLaTeX[1]) : characterLaTeX)
						}
						else {
							if ModifiedCharsType && HasProp(value, ModifiedCharsType "Form") {
								if IsObject(value.%ModifiedCharsType%Form) {
									TempValue := ""
									for modifier in value.%ModifiedCharsType%Form {
										TempValue .= PasteUnicode(modifier)
									}
									SendText(TempValue)
								} else {
									Send(value.%ModifiedCharsType%Form)
								}
							} else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
								TempValue := ""
								for unicode in value.uniSequence {
									TempValue .= PasteUnicode(unicode)
								}
								SendText(TempValue)
							} else {
								Send(value.unicode)
							}
						}
						break
					}
				}
			} else {
				if (keyPressed == characterKeys) {
					if InputMode = "HTML" && HasProp(value, "html") {
						(ModifiedCharsType && HasProp(value, ModifiedCharsType "HTML")) ? SendText(value.%ModifiedCharsType%HTML) : SendText(characterEntity)
					} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
						if IsObject(characterLaTeX) {
							if LaTeXMode = "common"
								SendText(characterLaTeX[1])
							else if LaTeXMode = "math"
								SendText(characterLaTeX[2])
						} else {
							SendText(characterLaTeX)
						}
					}
					else {
						if ModifiedCharsType && HasProp(value, ModifiedCharsType "Form") {
							if IsObject(value.%ModifiedCharsType%Form) {
								TempValue := ""
								for modifier in value.%ModifiedCharsType%Form {
									TempValue .= PasteUnicode(modifier)
								}
								SendText(TempValue)
							} else {
								Send(value.%ModifiedCharsType%Form)
							}
						} else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
							TempValue := ""
							for unicode in value.uniSequence {
								TempValue .= PasteUnicode(unicode)
							}
							SendText(TempValue)
						} else {
							Send(value.unicode)
						}
					}
					break
				}
			}
		}
	}
}

CombineArrays(destinationArray, sourceArray*) {
	for array in sourceArray
	{
		for value in array
		{
			destinationArray.Push(value)
		}
	}
}

HasAllCharacters(str, pattern) {
	WordBoundary := "[^a-zA-Zа-яА-ЯёЁ]"

	if RegExMatch(pattern, "\s") {
		WordSplit := StrSplit(pattern, " ")
		for word in WordSplit {
			if StrLen(word) < 3 {
				pattern := "(^|" . WordBoundary . ")" . word . "($|" . WordBoundary . ")"
				if !RegExMatch(str, pattern)
					return False
			} else {
				if !InStr(str, word)
					return False
			}
		}
		return true
	} else {
		for char in StrSplit(pattern) {
			if !InStr(str, char)
				return False
		}
		return true
	}
}


SearchKey(CycleSend := "") {
	CyclingSearch := False
	LaTeXMode := IniRead(ConfigFile, "Settings", "LaTeXInput", "Default")
	ModifiedCharsType := GetModifiedCharsType()

	if StrLen(CycleSend) > 0 {
		PromptValue := CycleSend
		CyclingSearch := True
	} else {
		PromptValue := IniRead(ConfigFile, "LatestPrompts", "Search", "")


		IB := InputBox(Locale.Read("symbol_search_prompt"), Locale.Read("symbol_search"), "w350 h110", PromptValue)

		if IB.Result = "Cancel"
			return
		else
			PromptValue := IB.Value

		if (PromptValue = "\") {
			Reload
			return
		} else if InStr(PromptValue, "=>") {
			RegExMatch(PromptValue, "\((.+)\)", &args)
			PromptValue := RegExReplace(PromptValue, "=>", "")
			PromptValue := RegExReplace(PromptValue, "\((.+\))", "")

			try {
				if args[1] {
					args := StrSplit(args[1], ",")

					currIndex := 0
					for i, arg in args {
						currIndex++
						try {
							args[i] := %arg%
						}
					}

					%PromptValue%(args*)
				}
				return
			}
			%PromptValue%()

			return
		}
	}


	IsSensitive := (SubStr(PromptValue, 1, 1) = "*")
	if IsSensitive
		PromptValue := SubStr(PromptValue, 2)

	Found := False

	SymbolSearching(SearchingPrompt) {
		ProceedSearch(value, characterEntity, characterLaTeX) {
			OutputValue := ""
			if InputMode = "HTML" && HasProp(value, "html") {
				SendValue :=
					(ModifiedCharsType && HasProp(value, ModifiedCharsType "HTML")) ? value.%ModifiedCharsType%HTML : characterEntity
				OutputValue := SendValue
			} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
				OutputValue := IsObject(characterLaTeX) ? (LaTeXMode = "Math" ? characterLaTeX[2] : characterLaTeX[1]) : characterLaTeX
			}
			else {
				if ModifiedCharsType && HasProp(value, ModifiedCharsType "Form") {
					if IsObject(value.%ModifiedCharsType%Form) {
						TempValue := ""
						for modifier in value.%ModifiedCharsType%Form {
							TempValue .= PasteUnicode(modifier)
						}
						OutputValue := TempValue
					} else {
						OutputValue := Chr("0x" UniTrim(value.%ModifiedCharsType%Form))
					}
				} else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
					TempValue := ""
					for unicode in value.uniSequence {
						TempValue .= PasteUnicode(unicode)
					}
					OutputValue := TempValue
				} else {
					OutputValue := Chr("0x" UniTrim(value.unicode))
				}
			}
			Found := True
			if !CyclingSearch {
				IniWrite IsSensitive ? "*" . PromptValue : PromptValue, ConfigFile, "LatestPrompts", "Search"
			}
			return OutputValue
		}

		CheckTagExact(value, tag, SearchingPrompt, IsSensitive) {
			IsEqualNonSensitive := !IsSensitive && (StrLower(SearchingPrompt) = StrLower(tag))
			IsEqualSensitive := IsSensitive && (SearchingPrompt == tag)
			return IsEqualSensitive || IsEqualNonSensitive
		}

		CheckTagPartial(value, tag, SearchingPrompt, IsSensitive) {
			IsPartiallyEqual := !IsSensitive && RegExMatch(StrLower(tag), StrLower(SearchingPrompt))
			IsPartiallyEqualSensitive := IsSensitive && RegExMatch(tag, SearchingPrompt)
			return IsPartiallyEqual || IsPartiallyEqualSensitive
		}

		CheckTagLowAcc(value, tag, SearchingPrompt, IsSensitive) {
			IsLowAcc := !IsSensitive && HasAllCharacters(StrLower(tag), StrLower(SearchingPrompt))
			IsLowAccSensitive := IsSensitive && HasAllCharacters(tag, SearchingPrompt)
			return IsLowAcc || IsLowAccSensitive
		}

		MapProcess(CheckingRule) {
			for characterEntry, value in Characters {
				if !HasProp(value, "tags") {
					continue
				}
				characterEntity := (HasProp(value, "entity")) ? value.entity : (HasProp(value, "entity")) ? value.html : ""
				characterLaTeX := (HasProp(value, "LaTeX")) ? (IsObject(value.LaTeX) ? (LaTeXMode = "Math" ? value.LaTeX[2] : value.LaTeX[1]) : value.LaTeX) : ""

				for _, tag in value.tags {
					if CheckingRule(value, tag, SearchingPrompt, IsSensitive) {
						return ProceedSearch(value, characterEntity, characterLaTeX)
					}
				}
			}
		}

		Output := MapProcess(CheckTagExact)
		if !Found
			Output := MapProcess(CheckTagPartial)
		if !Found
			Output := MapProcess(CheckTagLowAcc)

		return Output
	}

	if InStr(PromptValue, ", ") && StrSplit(PromptValue, ", ")[2] != "" {
		IniWrite IsSensitive ? "*" . PromptValue : PromptValue, ConfigFile, "LatestPrompts", "Search"
		WordSplit := StrSplit(PromptValue, ", ")
		Count := WordSplit.Length

		loop Count {
			Sleep 10
			SearchKey(WordSplit[A_Index])
		}
	} else {
		SendText(SymbolSearching(PromptValue))
	}

	if !Found && !InStr(PromptValue, ",") {
		MsgBox(Locale.Read("message_character_not_found"), DSLPadTitle, "Icon!")
	}


}

PasteUnicode(Unicode) {
	HexStr := UniTrim(Unicode)
	if HexStr != "" {
		Num := Format("0x{1}", HexStr)
		return Chr(Num)
	}
	return
}

SwitchQWERTY_YITSUKEN(Script := "Latin") {
	if (Script == "Latin") {
		LayoutName := IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")


		LayoutItems := GetLayoutsList.Length
		loop LayoutItems {
			if GetLayoutsList[A_Index] == LayoutName {
				if A_Index + 1 > LayoutItems {
					NextLayout := GetLayoutsList[1]
				} else {
					NextLayout := GetLayoutsList[A_Index + 1]
				}
			}
		}
	} else if (Script == "Cyrillic") {
		LayoutName := IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН")

		LayoutItems := CyrillicLayoutsList.Length
		loop LayoutItems {
			if CyrillicLayoutsList[A_Index] == LayoutName {
				if A_Index + 1 > LayoutItems {
					NextLayout := CyrillicLayoutsList[1]
				} else {
					NextLayout := CyrillicLayoutsList[A_Index + 1]
				}
				break
			}
		}

	} else {
		return
	}

	if NextLayout {
		RegisterLayout(NextLayout)
	}
}

SwitchToScript(scriptMode) {
	LanguageCode := Language.Get()
	Labels := {}
	Labels[] := Map()
	Labels["ru"] := {}
	Labels["en"] := {}
	if (scriptMode = "sup") {
		Labels["ru"].SearchTitle := "Верхний индекс"
		Labels["en"].SearchTitle := "Superscript"
	}
	else if (scriptMode = "sub") {
		Labels["ru"].SearchTitle := "Нижний индекс"
		Labels["en"].SearchTitle := "Subscript"
	}
	Labels["ru"].WindowPrompt := "Введите знаки для конвертации"
	Labels["en"].WindowPrompt := "Enter chars for convert"

	PromptValue := ""

	IB := InputBox(Labels[LanguageCode].WindowPrompt, Labels[LanguageCode].SearchTitle, "w256 h92")
	if IB.Result = "Cancel"
		return
	else {
		PromptValue := IB.Value
		CharArray := []
		for promptCharacters in StrSplit(PromptValue) {
			CharArray.Push(GetCharacterUnicode(promptCharacters))
		}

		for index, char in CharArray {
			for characterEntry, value in Characters {
				entryID := ""
				entryName := ""
				if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
					entryID := match[1]
					entryName := match[2]
				}

				if (scriptMode = "sup" && !HasProp(value, "sup")) || (scriptMode = "sub" && !HasProp(value, "sub")) {
					continue
				}

				if (!IsObject(value.unicode) && char = UniTrim(value.unicode)) {
					ScriptObj := scriptMode = "sup" ? value.sup : value.sub
					for scriptEntry, scriptValue in Characters {
						scriptEntryID := ""
						scriptEntryName := ""
						if RegExMatch(scriptEntry, "^\s*(\d+)\s+(.+)", &match) {
							scriptEntryID := match[1]
							scriptEntryName := match[2]
						}

						if (scriptEntryName = ScriptObj) {
							PromptValue := StrReplace(PromptValue, Chr("0x" char), Chr("0x" UniTrim(scriptValue.unicode)))
							break
						} else {
							continue
						}
					}
				}
			}
		}
	}

	SendText(PromptValue)
	return
}


; Glagolitic, Fuþark
CallBuffer(Time := -25, Callback := "") {
	if Callback != ""
		SetTimer(Callback, Time)
}

ChangeTrayIconOnLanguage() {
	LanguageCode := Language.Get()
	CurrentLayout := GetLayoutLocale()

	if Keyboard.disabledByMonitor || Keyboard.disabledByUser {
		TraySetIcon(InternalFiles["AppIcoDLL"].File, 9)
		A_IconTip := DSLPadTitle " (" Locale.Read("tray_tooltip_disabled") ")"
		return
	}

	ActiveLatin := IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")
	ActiveCyrillic := IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН")

	TitleCompose := DSLPadTitle "`n" ActiveLatin " – " ActiveCyrillic

	IconMap := Map(
		"Hellenic", {
			CodeEn: 2, CodeRu: 3, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_futhark"),
			TitleRu: Locale.Read("tray_tooltip_glagolitic"),
		},
		"Glagolitic Futhark", {
			CodeEn: 2, CodeRu: 3, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_futhark"),
			TitleRu: Locale.Read("tray_tooltip_glagolitic"),
		},
		"Old Turkic Old Permic", {
			CodeEn: 4, CodeRu: 5, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_turkic"),
			TitleRu: Locale.Read("tray_tooltip_permic"),
		},
		"Old Hungarian", {
			CodeEn: 6, CodeRu: 6, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_hungarian"),
			TitleRu: Locale.Read("tray_tooltip_hungarian"),
		},
		"Gothic", {
			CodeEn: 7, CodeRu: 7, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_gothic"),
			TitleRu: Locale.Read("tray_tooltip_gothic"),
		},
		"Old Italic", {
			CodeEn: 13, CodeRu: 13, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_old_italic"),
			TitleRu: Locale.Read("tray_tooltip_old_italic"),
		},
		"Phoenician", {
			CodeEn: 14, CodeRu: 14, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_phoenician"),
			TitleRu: Locale.Read("tray_tooltip_phoenician"),
		},
		"Ancient South Arabian", {
			CodeEn: 15, CodeRu: 15, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_ancient_south_arabian"),
			TitleRu: Locale.Read("tray_tooltip_ancient_south_arabian"),
		},
		"Ancient North Arabian", {
			CodeEn: 16, CodeRu: 16, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_ancient_north_arabian"),
			TitleRu: Locale.Read("tray_tooltip_ancient_north_arabian"),
		},
		"IPA", {
			CodeEn: 8, CodeRu: 8, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_ipa"),
			TitleRu: Locale.Read("tray_tooltip_ipa"),
		},
		"Maths", {
			CodeEn: 10, CodeRu: 10, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_maths"),
			TitleRu: Locale.Read("tray_tooltip_maths"),
		},
	)

	ISPEntries := Map(
		"vietNam", {
			CodeEn: 11, CodeRu: 11, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_vietNam"),
			TitleRu: Locale.Read("tray_tooltip_vietNam"),
		},
		"pinYin", {
			CodeEn: 12, CodeRu: 12, Default: 1,
			TitleEn: Locale.Read("tray_tooltip_pinYin"),
			TitleRu: Locale.Read("tray_tooltip_pinYin"),
		},
	)

	ISPActive := ISPEntries.Has(InputScriptProcessor.options.interceptionInputMode)
	ISPMode := InputScriptProcessor.options.interceptionInputMode

	if IconMap.Has(ActiveScriptName) {
		TrayTitle := TitleCompose (CurrentLayout = CodeEn ? "`n" IconMap[ActiveScriptName].TitleEn :
			CurrentLayout = CodeRu ? "`n" IconMap[ActiveScriptName].TitleRu : 1) (ISPActive
				? "`n" (CurrentLayout = CodeEn ? "`n" ISPEntries[ISPMode].TitleEn :
					CurrentLayout = CodeRu ? "`n" ISPEntries[ISPMode].TitleRu : 1) : "")

		IconCode := (CurrentLayout = CodeEn ? IconMap[ActiveScriptName].CodeEn :
			CurrentLayout = CodeRu ? IconMap[ActiveScriptName].CodeRu : 1)
	} else if ISPActive {
		TrayTitle := TitleCompose (CurrentLayout = CodeEn ? "`n" ISPEntries[ISPMode].TitleEn :
			CurrentLayout = CodeRu ? "`n" ISPEntries[ISPMode].TitleRu : 1)

		IconCode := (CurrentLayout = CodeEn ? ISPEntries[ISPMode].CodeEn :
			CurrentLayout = CodeRu ? ISPEntries[ISPMode].CodeRu : 1)
	} else {
		TrayTitle := TitleCompose
		IconCode := 1
	}

	TraySetIcon(InternalFiles["AppIcoDLL"].File, IconCode)
	A_IconTip := TrayTitle
}

OnMessage(0x0051, On_WM_INPUTLANGCHANGE)

On_WM_INPUTLANGCHANGE(wParam, lParam, msg, hwnd) {
	ChangeTrayIconOnLanguage()
}

SetTimer(ChangeTrayIconOnLanguage, 1000)

ToggleLetterScript(HideMessage := False, ScriptName := "Glagolitic Futhark") {
	LanguageCode := Language.Get()
	CurrentLayout := GetLayoutLocale()
	global ActiveScriptName, ConfigFile, PreviousScriptName
	CurrentActive := ScriptName = ActiveScriptName

	LocalesPairs := [
		"Hellenic", "script_hellenic",
		"Glagolitic Futhark", "script_glagolitic_futhark",
		"Old Turkic Old Permic", "script_turkic_perimc",
		"Old Hungarian", "script_hungarian",
		"Gothic", "script_gothic",
		"Old Italic", "script_old_italic",
		"Phoenician", "script_phoenician",
		"Ancient South Arabian", "script_ancient_south_arabian",
		"Ancient North Arabian", "script_ancient_north_arabian",
		"IPA", "script_ipa",
		"Maths", "script_maths",
	]

	if !CurrentActive {
		if ScriptName = "Glagolitic Futhark" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, CurrentLayout = CodeEn ? 2 : CurrentLayout = CodeRu ? 3 : 1)
		} else if ScriptName = "Hellenic" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, CurrentLayout = CodeEn ? 2 : CurrentLayout = CodeRu ? 3 : 1)
		} else if ScriptName = "Old Turkic Old Permic" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, CurrentLayout = CodeEn ? 4 : CurrentLayout = CodeRu ? 5 : 1)
		} else if ScriptName = "Old Hungarian" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 6 : 1)
		} else if ScriptName = "Gothic" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 7 : 1)
		} else if ScriptName = "Old Italic" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 13 : 1)
		} else if ScriptName = "Phoenician" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 14 : 1)
		} else if ScriptName = "Ancient South Arabian" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 15 : 1)
		} else if ScriptName = "Ancient North Arabian" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 16 : 1)
		} else if ScriptName = "IPA" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 8 : 1)
		} else if ScriptName = "Maths" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 10 : 1)
		} else {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, 1)
		}
		if !Keyboard.disabledByMonitor || !Keyboard.disabledByUser {
			UnregisterKeysLayout()
		}
		ActiveScriptName := ""
		if !Keyboard.disabledByMonitor || !Keyboard.disabledByUser {
			RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], ScriptName), True)
		}
		ActiveScriptName := ScriptName
	} else {
		TraySetIcon(InternalFiles["AppIcoDLL"].File, 1)
		if !Keyboard.disabledByMonitor || !Keyboard.disabledByUser {
			UnregisterKeysLayout()
		}
		ActiveScriptName := ""
		if !Keyboard.disabledByMonitor || !Keyboard.disabledByUser {
			RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))
		}
	}

	if !HideMessage {
		for i, pair in LocalesPairs {
			if (Mod(i, 2) == 1) {
				key := pair
				localePair := LocalesPairs[i + 1]
				if ScriptName = key {
					MsgBox(CurrentActive ? Util.StrVarsInject(Locale.Read("script_mode_deactivated"), Locale.Read(localePair)) : Util.StrVarsInject(Locale.Read("script_mode_activated"), Locale.Read(localePair)), DSLPadTitle, 0x40)
					break
				}
			}
		}
	}
	return
}


NumberStyle := ""

SetNumberStyle(ScriptMode) {
	global NumberStyle
	PreviousScriptMode := NumberStyle

	IsAlterationsActive := AlterationActiveName != "" ? True : False

	if (ScriptMode != "" && (ScriptMode = PreviousScriptMode)) {
		NumberStyle := ""
		UnregisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Cleanscript"))
		RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"), , IsAlterationsActive)
	} else {
		NumberStyle := ScriptMode
		if IsAlterationsActive {
			RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"), , True)
		}
		RegisterHotKeys(ScriptMode == "sup" ? GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Supercript") : GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Subscript"), True)
	}
}

ToRomanNumeral(IntValue, CapitalLetters := True) {
	IntValue := Integer(IntValue)
	if (IntValue < 1 || IntValue > 2000000) {
		return
	}

	RomanNumerals := []

	for key, value in RoNum {
		entryName := RegExReplace(key, "^\S+-")
		if CapitalLetters == True && !RegExMatch(entryName, "^s") || CapitalLetters == False && RegExMatch(entryName, "^s")
			RomanNumerals.Push(value)
	}

	Values := [100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
	RomanStr := ""

	for i, v in Values {
		while (IntValue >= v) {
			RomanStr .= RomanNumerals[i]
			IntValue -= v
		}
	}
	return RomanStr
}

SwitchToRoman() {
	LanguageCode := Language.Get()

	PromptValue := Cfg.Get("Roman_Numeral", "LatestPrompts")

	IB := InputBox(Locale.Read("symbol_roman_numeral_prompt"), Locale.Read("symbol_roman_numeral"), "w256 h92", PromptValue)
	if IB.Result = "Cancel"
		return
	else {
		if (Integer(IB.Value) < 1 || Integer(IB.Value) > 2000000) {
			MsgBox(Locale.Read("warning_roman_2m"), DSLPadTitle, "Icon!")
			return
		}
		PromptValue := ToRomanNumeral(Integer(IB.Value))

		Cfg.Set(IB.Value, "Roman_Numeral", "LatestPrompts")
	}
	SendText(PromptValue)
}


SendAltNumpad(CharacterCode) {
	Send("{Alt Down}")
	Loop Parse, CharacterCode
		Send("{Numpad" A_LoopField "}")
	Send("{Alt Up}")
}


CaretTooltip(tooltipText) {
	if CaretGetPos(&x, &y)
		ToolTip(tooltipText, x, y + 30)
	else if CaretGetPosAlternative(&x, &y)
		ToolTip(tooltipText, x, y + 30)
	else
		ToolTip(tooltipText)
}

GREPizeSelection(GetCollaborative := False) {
	CustomAfterStartEmdash := (IniRead(ConfigFile, "CustomRules", "ParagraphAfterStartEmdash", "") != "") ? IniRead(ConfigFile, "CustomRules", "ParagraphAfterStartEmdash", "") : "ensp"
	CustomDialogue := (IniRead(ConfigFile, "CustomRules", "GREPDialogAttribution", "") != "") ? IniRead(ConfigFile, "CustomRules", "GREPDialogAttribution", "") : "no_break_space"
	CustomThisEmdash := (IniRead(ConfigFile, "CustomRules", "GREPThisEmdash", "") != "") ? IniRead(ConfigFile, "CustomRules", "GREPThisEmdash", "") : "no_break_space"
	CustomInitials := (IniRead(ConfigFile, "CustomRules", "GREPInitials", "") != "") ? IniRead(ConfigFile, "CustomRules", "GREPInitials", "") : "thinspace"

	Punctuations := "[" GetChar("reversed_question", "inverted_exclamation", "inverted_question", "double_exclamation", "double_exclamation_question", "double_question", "double_question_exclamation", "interrobang", "interrobang_inverted") ".,!?…”’»›“]"

	GREPRules := Map(
		"start_emdash", {
			grep: "^" GetChar("emdash") "\s",
			replace: GetChar("emdash", CustomAfterStartEmdash)
		},
		"dialogue_emdash", {
			grep: "(?<=" Punctuations ")\s" GetChar("emdash") "\s",
			replace: GetChar(CustomDialogue "[1,3]", "emdash")
		},
		"this_emdash", {
			grep: "(?<!" Punctuations ")\s" GetChar("emdash") "\s",
			replace: GetChar(CustomThisEmdash, "emdash", "space")
		},
		"nums", {
			grep: "(?<=\d)\s(?=\d{3})",
			replace: GetChar("no_break_space")
		},
		"paragraph_end", {
			grep: "(?<=[а-яА-ЯёЁa-zA-Z])\s(?=[а-яА-ЯёЁa-zA-Z]{1,12}[" Punctuations "]*$)",
			replace: GetChar("no_break_space")
		},
		"initials", {
			grep: "([A-ZА-ЯЁ]\.)\s([A-ZА-ЯЁ]\.)\s([A-ZА-ЯЁ][a-zа-яё]+)",
			replace: "$1" . GetChar(CustomInitials) . "$2" . GetChar(CustomInitials) . "$3"
		},
		"initials_reversed", {
			grep: "([A-ZА-ЯЁ][a-zа-яё]+)\s([A-ZА-Яё]\.)\s([A-ZА-ЯЁ]\.)",
			replace: "$1" . GetChar(CustomInitials) . "$2" . GetChar(CustomInitials) . "$3"
		},
		"single_letter", {
			grep: "(?<![а-яА-ЯёЁa-zA-Z])([а-яА-ЯёЁa-zA-Z])\s",
			replace: "$1" GetChar("no_break_space")
		},
		"russian_conjunctions", {
			grep: "\s(бы|ли|то|же)(?![а-яА-Я])",
			replace: GetChar("no_break_space") "$1"
		},
		"russian_conjunctions_2", {
			grep: "\s(из|до|для|на|но|не|ни|то|по|со|Из|До|Для|На|Но|Не|Ни|То|По|Со)\s",
			replace: GetChar("space") "$1" GetChar("no_break_space")
		},
	)

	BackupClipboard := A_Clipboard
	if !GetCollaborative {
		PromptValue := ""
		A_Clipboard := ""

		Send("^c")
		ClipWait(0.50, 1)
		PromptValue := A_Clipboard
		A_Clipboard := ""
	} else {
		PromptValue := ParagraphizeSelection(True)
		Sleep 100
	}

	if (PromptValue != "") {
		TotalLines := 0
		SplittedLines := StrSplit(PromptValue, "`r`n")
		ModifiedValue := ""

		for index in SplittedLines {
			TotalLines++
		}

		CurrentLine := 0
		for _, rule in GREPRules {
			for i, line in SplittedLines {
				SplittedLines[i] := RegExReplace(line, rule.grep, rule.replace)
			}
		}

		for line in SplittedLines {
			CurrentLine++
			EndLine := CurrentLine < TotalLines ? "`r`n" : ""
			ModifiedValue .= line . EndLine
		}

		A_Clipboard := ModifiedValue
		ClipWait(0.250, 1)
		Sleep 1000
		Send("^v")
	}

	Sleep 1000
	A_Clipboard := BackupClipboard
}

ParagraphizeSelection(SendCollaborative := False) {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	ClipWait(0.50, 1)
	PromptValue := A_Clipboard
	A_Clipboard := ""

	if (PromptValue != "") {
		CustomParagraphBeginning := (IniRead(ConfigFile, "CustomRules", "ParagraphBeginning", "") != "") ? IniRead(ConfigFile, "CustomRules", "ParagraphBeginning", "") : "emsp"
		CustomAfterStartEmdash := (IniRead(ConfigFile, "CustomRules", "ParagraphAfterStartEmdash", "") != "") ? IniRead(ConfigFile, "CustomRules", "ParagraphAfterStartEmdash", "") : "ensp"

		blockRules := [CustomParagraphBeginning, CustomAfterStartEmdash]

		for i, blockRule in blockRules {
			if blockRule = "noad" {
				blockRules[i] := ""
			}
		}

		CustomParagraphBeginning := blockRules[1]
		CustomAfterStartEmdash := blockRules[2]

		TotalLines := 0
		ModifiedValue := ""
		SplittedLines := StrSplit(PromptValue, "`r`n")

		for index in SplittedLines {
			TotalLines++
		}

		CurrentLine := 0
		for line in SplittedLines {
			CurrentLine++
			EndLine := CurrentLine < TotalLines ? "`r`n" : ""
			LocalModify := RegExReplace(
				line, "^" . GetChar("emdash") . "\s+",
				GetChar("emdash") . GetChar(CustomAfterStartEmdash)
			)
			ModifiedValue .= GetChar(CustomParagraphBeginning) . LocalModify . EndLine

		}

		if !SendCollaborative {
			A_Clipboard := ModifiedValue
			ClipWait(0.250, 1)
			Sleep 1000
			Send("^v")
		} else {
			A_Clipboard := BackupClipboard
			return ModifiedValue
		}

		;SendText(ModifiedValue)
	}

	Sleep 1000
	A_Clipboard := BackupClipboard
}

QuotatizeSelection(Mode) {
	RegEx := "[a-zA-Zа-яА-ЯёЁ0-9.,:;!?()\`"'-+=/\\]"

	france_left := GetChar("france_left")
	france_right := GetChar("france_right")
	quote_low_9_double := GetChar("quote_low_9_double")
	quote_left_double := GetChar("quote_left_double")
	quote_right_double := GetChar("quote_right_double")
	quote_left_single := GetChar("quote_left_single")
	quote_right_single := GetChar("quote_right_single")


	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	ClipWait(0.5, 0)
	PromptValue := A_Clipboard
	if !RegExMatch(PromptValue, RegEx) {
		A_Clipboard := BackupClipboard
		if Mode = "France" {
			SendText(france_left france_right)
		} else if Mode = "Paw" {
			SendText(quote_low_9_double quote_left_double)
		} else if Mode = "Double" {
			SendText(quote_left_double quote_right_double)
		} else if Mode = "Single" {
			SendText(quote_left_single quote_right_single)
		}
		return
	}
	A_Clipboard := ""

	if RegExMatch(PromptValue, RegEx) {


		TempSpace := ""
		CheckFor := [
			SpaceKey,
			GetChar("emsp"),
			GetChar("ensp"),
			GetChar("emsp13"),
			GetChar("emsp14"),
			GetChar("thinspace"),
			GetChar("emsp16"),
			GetChar("narrow_no_break_space"),
			GetChar("hairspace"),
			GetChar("punctuation_space"),
			GetChar("figure_space"),
			GetChar("tabulation"),
			GetChar("no_break_space"),
		]

		for space in CheckFor {
			if (PromptValue ~= space . "$") {
				TempSpace := space
				PromptValue := RegExReplace(PromptValue, space . "$", "")
				break
			}
		}

		if Mode = "France" {
			PromptValue := RegExReplace(PromptValue, RegExEscape(france_left), quote_low_9_double)
			PromptValue := RegExReplace(PromptValue, RegExEscape(france_right), quote_left_double)

			PromptValue := france_left . PromptValue . france_right
		} else if Mode = "Paw" {
			PromptValue := quote_low_9_double . PromptValue . quote_left_double
		} else if Mode = "Double" {
			PromptValue := RegExReplace(PromptValue, RegExEscape(quote_left_double), quote_left_single)
			PromptValue := RegExReplace(PromptValue, RegExEscape(quote_right_double), quote_right_single)

			PromptValue := quote_left_double . PromptValue . quote_right_double
		} else if Mode = "Single" {
			PromptValue := quote_left_single . PromptValue . quote_right_single
		}

		A_Clipboard := PromptValue . TempSpace
		ClipWait(0.250, 0)
		Sleep 250
		Send("^v")
	}

	Sleep 500
	A_Clipboard := BackupClipboard
	return
}

RecipeValidatorArray := []
UpdateRecipeValidator() {
	global RecipeValidatorArray
	RecipeValidatorArray := []
	for chracterEntry, value in Characters {
		if !HasProp(value, "recipe") || (HasProp(value, "recipe") && value.recipe == "") {
			continue
		} else {
			Recipe := value.recipe
			if IsObject(Recipe) {
				for _, recipe in Recipe {
					RecipeValidatorArray.Push(recipe)
				}
			} else {
				RecipeValidatorArray.Push(Recipe)
			}
		}
	}
}
UpdateRecipeValidator()

TranslateSelectionToHTML(Mode := "", IgnoreDefaultSymbols := False) {
	DefaultSymbols := "[a-zA-Zа-яА-ЯёЁ0-9.,\s:;!?()\`"'-+=/\\]"
	BackupClipboard := A_Clipboard
	A_Clipboard := ""

	Send("^c")
	ClipWait(0.5, 1)
	PromptValue := A_Clipboard
	A_Clipboard := ""

	if PromptValue != "" {
		Output := ""

		i := 1
		while (i <= StrLen(PromptValue)) {
			Symbol := SubStr(PromptValue, i, 1)
			Code := Ord(Symbol)

			if (Code >= 0xD800 && Code <= 0xDBFF) {
				NextSymbol := SubStr(PromptValue, i + 1, 1)
				Symbol .= NextSymbol
				i += 1
			}

			if (IgnoreDefaultSymbols && RegExMatch(Symbol, DefaultSymbols)) {
				Output .= Symbol
			} else {
				if InStr(Mode, "Entities") {
					Found := false
					for j, entity in EntitiesLibrary {
						if (Mod(j, 2) = 1 && entity = Symbol) {
							Output .= EntitiesLibrary[j + 1]
							Found := true
							break
						}
					}

					if (!Found) {
						Output .= "&#" (InStr(Mode, "Hex") ? "x" ConvertToHexaDecimal(Symbol, "") : ConvertToDecimal(Symbol)) ";"
					}
				} else {
					Output .= "&#" (InStr(Mode, "Hex") ? "x" ConvertToHexaDecimal(Symbol, "") : ConvertToDecimal(Symbol)) ";"
				}
			}

			i += 1
		}

		A_Clipboard := Output
		ClipWait(0.250, 1)
		Send("^v")
	}

	Sleep 500
	A_Clipboard := BackupClipboard
	Send("{Control Up}")
	return
}

#Include <cls_script_processor>

GroupActivator(GroupName, KeyValue := "") {
	LocaleMark := KeyValue != "" && RegExMatch(KeyValue, "^F") ? KeyValue : GroupName
	MsgTitle := "[" LocaleMark "] " DSLPadTitle

	ShowInfoMessage("tray_active_" . StrLower(LocaleMark), , MsgTitle, Cfg.SkipGroupMessage, True)
	InputBridge(GroupName)
}


ReplaceWithUnicode(Mode := "") {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("{Shift Down}{Delete}{Shift Up}")
	ClipWait(0.5, 1)
	PromptValue := A_Clipboard
	A_Clipboard := ""

	if PromptValue != "" {
		Output := ""

		i := 1
		while (i <= StrLen(PromptValue)) {
			Symbol := SubStr(PromptValue, i, 1)
			Code := Ord(Symbol)
			Surrogated := Code >= 0xD800 && Code <= 0xDBFF

			if (Surrogated) {
				NextSymbol := SubStr(PromptValue, i + 1, 1)
				Symbol .= NextSymbol
				i += 1
			}

			if Mode == "Hex" {
				Output .= "0x" GetCharacterUnicode(Symbol) " "
			} else if Mode == "CSS" {
				Output .= Surrogated ? "\u{" GetCharacterUnicode(Symbol) "} " : "\u" GetCharacterUnicode(Symbol) " "
			} else {
				Output .= GetCharacterUnicode(Symbol) " "
			}

			i += 1
		}

		A_Clipboard := RegExReplace(Output, "\s$", "")
		ClipWait(0.250, 1)
		Send("{Shift Down}{Insert}{Shift Up}")
	}
	Sleep 500
	A_Clipboard := BackupClipboard

	Send("{Ctrl Up}")

	return
}

GetCharacterUnicode(Symbol, StartFormat := "") {
	Code := Ord(Symbol)

	if (Code >= 0xD800 && Code <= 0xDBFF) {
		nextSymbol := SubStr(Symbol, 2, 1)
		NextCode := Ord(nextSymbol)

		if (NextCode >= 0xDC00 && NextCode <= 0xDFFF) {
			HighSurrogate := Code - 0xD800
			LowSurrogate := NextCode - 0xDC00
			FullCodePoint := (HighSurrogate << 10) + LowSurrogate + 0x10000
			return StartFormat Format("{:06X}", FullCodePoint)
		}
	}

	return StartFormat Format("{:04X}", Code)
}

ConvertToDecimal(Symbol) {
	HexCode := GetCharacterUnicode(Symbol)
	return Format("{:d}", "0x" HexCode)
}

ConvertToHexaDecimal(StringInput, StartFromat := "0x") {
	if StringInput != "" {
		Output := ""
		i := 1

		while (i <= StrLen(StringInput)) {
			Symbol := SubStr(StringInput, i, 1)
			Code := Ord(Symbol)

			if (Code >= 0xD800 && Code <= 0xDBFF) {
				NextSymbol := SubStr(StringInput, i + 1, 1)
				Symbol .= NextSymbol
				i += 1
			}

			Output .= GetCharacterUnicode(Symbol, StartFromat) "-"
			i += 1
		}

		return RegExReplace(Output, "-$", "")
	} else {
		return StringInput
	}
}

ConvertFromHexaDecimal(StringInput) {
	if StringInput != "" {
		Output := ""
		for symbol in StrSplit(StringInput, "-") {
			Output .= Chr(symbol)
		}
		return Output
	} else {
		return StringInput
	}
}

GetUnicodeString(str) {
	unicodeArray := []

	for symbol in StrSplit(str, "") {
		unicodeArray.Push(GetCharacterUnicode(symbol))
	}

	unicodeString := ""
	totalCount := 0
	for index in unicodeArray {
		totalCount++
	}

	currentIndex := 0
	for index, unicode in unicodeArray {
		unicodeString .= unicode
		currentIndex++
		if (currentIndex < totalCount) {
			unicodeString .= "-"
		}
	}

	return unicodeString
}

FindCharacterPage(InputCode := "", IsReturn := False) {
	CharacterWebResource := IniRead(ConfigFile, "Settings", "CharacterWebResource", "Symblcc")
	if InputCode = "" {
		BackupClipboard := A_Clipboard
		PromptValue := ""
		A_Clipboard := ""

		Send("^c")
		ClipWait(0.10, 1)
		PromptValue := A_Clipboard
		PromptValue := GetCharacterUnicode(PromptValue)
	} else {
		PromptValue := StrLen(InputCode) >= 4 ? InputCode : GetCharacterUnicode(InputCode)
	}

	resources := Map(
		"Compart", "https://www.compart.com/en/unicode/U+" PromptValue,
		"Codepoints", "https://codepoints.net/U+" PromptValue,
		"UnicodePlus", "https://unicodeplus.com/U+" PromptValue,
		"DecodeUnicode", "https://decodeunicode.org/en/u+" PromptValue,
		"UtilUnicode", "https://util.unicode.org/UnicodeJsps/character.jsp?a=" PromptValue,
		"Wiktionary", "https://en.wiktionary.org/wiki/" Chr("0x" PromptValue),
		"Wikipedia", "https://en.wikipedia.org/wiki/" Chr("0x" PromptValue),
		"SymblCC", "https://symbl.cc/" Language.Get() "/" PromptValue,
	)

	URIComponent := resources.Has(CharacterWebResource) ? resources[CharacterWebResource] : resources["SymblCC"]

	if (PromptValue != "" && !IsReturn) {
		Run(URIComponent)
	} else if (PromptValue != "" && IsReturn) {
		return URIComponent
	}

	if InputCode = "" {
		A_Clipboard := BackupClipboard
	}
}

ToggleGroupMessage() {
	LanguageCode := Language.Get()
	Cfg.SkipGroupMessage := !Cfg.SkipGroupMessage
	Cfg.SwitchSet(["True", "False"], "SkipGroupMessage")

	ActivationMessage := {}
	ActivationMessage[] := Map()
	ActivationMessage["ru"] := {}
	ActivationMessage["en"] := {}
	ActivationMessage["ru"].Active := "Сообщения активации групп включены"
	ActivationMessage["ru"].Deactive := "Сообщения активации групп отключены"
	ActivationMessage["en"].Active := "Activation messages for groups enabled"
	ActivationMessage["en"].Deactive := "Activation messages for groups disabled"
	MsgBox(Cfg.SkipGroupMessage ? ActivationMessage[LanguageCode].Deactive : ActivationMessage[LanguageCode].Active, DSLPadTitle, 0x40)

	return
}

LocaliseArrayKeys(ObjectPath) {
	for index, item in ObjectPath {
		if IsObject(item[1]) {
			item[1] := item[1][Language.Get()]
		}
	}
}

OpenPanel(*) {
	if (IsGuiOpen(DSLPadTitle))
	{
		WinActivate(DSLPadTitle)
	}
	else
	{
		DSLPadGUI := Constructor()
		DSLPadGUI.Show()
	}
}

CommonInfoFonts := {
	preview: "Noto Serif",
	previewSize: "s70",
	previewSmaller: "s40",
	titleSize: "s14",
}

SwitchLanguage(LanguageCode) {
	IniWrite LanguageCode, ConfigFile, "Settings", "UserLanguage"

	if (IsGuiOpen(DSLPadTitle))
	{
		WinClose(DSLPadTitle)
	}

	DSLPadGUI := Constructor()
	DSLPadGUI.Show()

	;ManageTrayItems()
}

ContainsEmoji(StringInput) {
	EmojisPattern := "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{1F700}-\x{1F77F}\x{1F900}-\x{1F9FF}\x{2700}-\x{27BF}\x{1F1E6}-\x{1F1FF}]"
	return RegExMatch(StringInput, EmojisPattern)
}


AlphabetCoverage := ["pl", "ro", "es"]
Constructor() {
	CheckUpdate()
	;ManageTrayItems()

	screenWidth := A_ScreenWidth
	screenHeight := A_ScreenHeight


	windowWidth := 850
	windowHeight := 560

	resolutions := [
		[1080, 1920],
		[1440, 2560],
		[1800, 3200],
		[2160, 3840],
		[2880, 5120],
		[4320, 7680]
	]

	for res in resolutions {
		if screenHeight = res[1] && screenWidth > res[2] {
			screenWidth := res[2]
			break
		}
	}

	xPos := screenWidth - windowWidth - 50
	yPos := screenHeight - windowHeight - 92

	LanguageCode := Language.Get()

	DSLPadGUI := Gui()

	DSLTabs := []
	DSLCols := { default: [], smelting: [] }

	for _, localeKey in ["diacritics", "spaces", "smelting", "fastkeys", "scripts", "commands", "about", "useful", "changelog"] {
		DSLTabs.Push(Locale.Read("tab_" . localeKey))
	}

	for _, localeKey in ["name", "key", "view", "unicode", "entryid", "entry_title"] {
		DSLCols.default.Push(Locale.Read("col_" . localeKey))
	}

	for _, localeKey in ["name", "recipe", "result", "unicode", "entryid", "entry_title"] {
		DSLCols.smelting.Push(Locale.Read("col_" . localeKey))
	}

	DSLContent := {}
	DSLContent[] := Map()
	DSLContent["BindList"] := {}

	CommonInfoBox := {
		body: "x650 y35 w200 h510",
		bodyText: Locale.Read("character"),
		previewFrame: "x685 y80 w128 h128 Center",
		preview: "x685 y80 w128 h128 readonly Center -VScroll -HScroll",
		previewText: "◌͏",
		title: "x655 y215 w190 h150 Center BackgroundTrans",
		titleText: "N/A",
		LaTeXTitleA: "x689 y371 w128 h24 BackgroundTrans",
		LaTeXTitleAText: "A",
		LaTeXTitleE: "x703 y375 w128 h24 BackgroundTrans",
		LaTeXTitleEText: "E",
		LaTeXTitleLTX: "x685 y373 w128 h24 BackgroundTrans",
		LaTeXTitleLTXText: "L T  X",
		LaTeXPackage: "x685 y373 w128 h24 BackgroundTrans Right",
		LaTeXPackageText: "",
		LaTeX: "x685 y390 w128 h24 readonly Center -VScroll -HScroll",
		LaTeXText: "N/A",
		alt: "x685 y430 w128 h24 readonly Center -VScroll -HScroll",
		altTitle: "x685 y415 w128 h24 BackgroundTrans",
		altTitleText: Map("ru", "Альт-код", "en", "Alt-code"),
		altText: "N/A",
		unicode: "x685 y470 w128 h24 readonly Center -VScroll -HScroll",
		unicodeTitle: "x685 y455 w128 h24 BackgroundTrans",
		unicodeTitleText: Map("ru", "Юникод", "en", "Unicode"),
		unicodeText: "U+0000",
		html: "x685 y510 w128 h24 readonly Center -VScroll -HScroll",
		htmlText: "&#x0000;",
		htmlTitle: "x685 y495 w128 h24 BackgroundTrans",
		htmlTitleText: Map("ru", "HTML-Код/Мнемоника", "en", "HTML/Entity"),
		tags: "x21 y546 w800 h24 readonly -VScroll -HScroll -E0x200",
		alert: "x655 y55 w190 h24 readonly Center -VScroll -HScroll -E0x200",
	}

	CommandsInfoBox := {
		body: "x300 y35 w540 h450",
		bodyText: Map("ru", "Команда", "en", "Command"),
		text: "vCommandDescription x310 y65 w520 h400",
	}

	CommonFilter := {
		icon: "x21 y520 h24 w24",
		field: "x49 y520 w593 h24 v",
	}

	ColumnWidths := [300, 150, 60, 85, 0, 0]
	ColumnAreaWidth := "w620"
	ColumnAreaHeight := "h480"
	ColumnAreaRules := "+NoSort -Multi"
	ColumnListStyle := ColumnAreaWidth . " " . ColumnAreaHeight . " " . ColumnAreaRules

	DSLContent["BindList"].TabDiacritics := []

	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Primary", Window LeftAlt " F1", False)
	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Secondary", Window LeftAlt " F2")
	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Tertiary", Window LeftAlt " F3")
	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Quatemary", Window LeftAlt " F6")

	DSLContent["BindList"].TabSpaces := []
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Spaces", Window LeftAlt " Space", False)
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Dashes", Window LeftAlt " -")
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Quotes", Window LeftAlt QuotationDouble)
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Special Characters", Window LeftAlt " F7")

	DSLContent["BindList"].TabSmelter := []

	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Ligatures", , False, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Digraphs", , False, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Extended", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Accented", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Cyrillic Ligatures & Letters", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Cyrillic Letters", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Futhork Runes", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Glagolitic Letters", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Smelting Special", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Wallet Signs", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Other Signs", , True, "Recipes")
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Miscellaneous Technical", , True, "Recipes")
	;InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Custom Composes", ReadLocale("symbol_custom_compose"), True, "Recipes")

	DSLContent["BindList"].TabFastKeys := []

	for groupName in [
		"Diacritics Fast Primary",
		"Special Fast Primary",
		"Special Fast Left",
		"Spaces Left Alt",
		"Latin Accented Primary",
		"Cyrillic Primary",
		"Special Fast Secondary",
		"Asian Quotes",
		"Other Signs",
		"Spaces",
		"Format Characters",
		"Misc",
		"Latin Extended",
		"Latin Ligatures",
		"Latin Accented Secondary",
		"Cyrillic Ligatures & Letters",
		"Cyrillic Secondary",
		"Spaces Right Shift",
		"Latin Accented Tertiary",
		"Cyrillic Tertiary",
		"Special Fast RShift",
		"Spaces Left Shift",
		"Special Fast",
	] {
		InsertingOption := groupName = "Special Fast" ? "Fast Special" : "Fast Keys"
		AddSeparator := (groupName = "Diacritics Fast Primary" || groupName = "Latin Ligatures") ? False : True
		GroupHotKey := (groupName = "Diacritics Fast Primary") ? LeftControl LeftAlt
			: (groupName = "Special Fast Left") ? LeftAlt
			: (groupName = "Special Fast Secondary") ? RightAlt
			: (groupName = "Spaces Right Shift") ? RightShift
			: (groupName = "Spaces Left Shift") ? LeftShift
			: (groupName = "Special Fast") ? Locale.Read("symbol_special_key")
			: ""

		BlackList := groupName = "Spaces" ? ["emsp13", "emsp14", "emsp16", "narrow_no_break_space"] : []
		FastSpecial := groupName = "Special Fast" ? True : False

		InsertCharactersGroups(DSLContent["BindList"].TabFastKeys, groupName, GroupHotKey, AddSeparator, InsertingOption, BlackList)
	}

	DSLContent["BindList"].TabGlagoKeys := []

	AltLayouts := [
		"Fake GlagoRunes", RightControl " 1",
		"Futhark Runes", Locale.Read("symbol_futhark"),
		"Futhork Runes", Locale.Read("symbol_futhork"),
		"Younger Futhark Runes", Locale.Read("symbol_futhark_younger"),
		"Almanac Runes", Locale.Read("symbol_futhark_almanac"),
		"Later Younger Futhark Runes", Locale.Read("symbol_futhark_younger_later"),
		"Medieval Runes", Locale.Read("symbol_medieval_runes"),
		"Runic Punctuation", Locale.Read("symbol_runic_punctuation"),
		"Glagolitic Letters", Locale.Read("symbol_glagolitic"),
		"Cyrillic Diacritics", "",
		"Fake TurkoPermic", CapsLock RightControl " 1",
		"Old Turkic", Locale.Read("symbol_turkic"),
		"Old Turkic Orkhon", Locale.Read("symbol_turkic_orkhon"),
		"Old Turkic Yenisei", Locale.Read("symbol_turkic_yenisei"),
		"Runic Punctuation", Locale.Read("symbol_runic_punctuation"),
		"Old Permic", Locale.Read("symbol_permic"),
		"Fake Hungarian", RightControl " 2",
		"Old Hungarian", Locale.Read("symbol_hungarian"),
		"Runic Punctuation", Locale.Read("symbol_runic_punctuation"),
		"Fake Gothic", CapsLock RightControl " 2",
		"Gothic Alphabet", Locale.Read("symbol_gothic"),
		"Fake Italic", RightControl " 3",
		"Old Italic", Locale.Read("symbol_old_italic"),
		"Fake Phoenician", CapsLock RightControl " 3",
		"Phoenician", Locale.Read("symbol_phoenician"),
		"Fake South Arabian", RightControl " 4",
		"South Arabian", Locale.Read("symbol_ancient_south_arabian"),
		"Fake North Arabian", CapsLock RightControl " 4",
		"North Arabian", Locale.Read("symbol_ancient_north_arabian"),
		"Runic Punctuation", Locale.Read("symbol_runic_punctuation"),
		"Fake IPA", RightControl " 0",
		"IPA", Locale.Read("symbol_ipa"),
		"Fake Math", RightControl RightShift " 0",
		"Mathematical", Locale.Read("symbol_maths"),
		"Math", "",
		"Math Spaces", "",
	]

	noSeparatorGroups := [
		"Fake GlagoRunes",
		"Futhark Runes",
		"Old Turkic",
		"Old Turkic Orkhon",
		"Old Hungarian",
		"Gothic Alphabet",
		"Old Italic",
		"Phoenician",
		"South Arabian",
		"North Arabian",
		"IPA",
		"Mathematical",
	]

	for i, groupName in AltLayouts {
		if Mod(i, 2) = 1 {
			AddSeparator := noSeparatorGroups.HasValue(groupName) ? False : True
			GroupHotKey := AltLayouts[i + 1]


			InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, groupName, GroupHotKey, AddSeparator, "Alternative Layout")
		}
	}

	RandPreview := Map(
		"Diacritics", GetRandomByGroups(["Diacritics Primary", "Diacritics Secondary", "Diacritics Tertiary"]),
		"Spaces", GetRandomByGroups(["Format Characters", "Spaces", "Dashes", "Quotes", "Special Characters"]),
		"Ligatures", GetRandomByGroups(["Latin Ligatures", "Cyrillic Ligatures & Letters", "Latin Accented", "Dashes", "Asian Quotes", "Quotes"]),
		"FastKeys", GetRandomByGroups(["Diacritics Fast Primary", "Special Fast Primary", "Special Fast Left", "Latin Accented Primary", "Latin Accented Secondary", "Diacritics Fast Secondary", "Asian Quotes"]),
		"GlagoKeys", GetRandomByGroups(["Futhark Runes", "Glagolitic Letters", "Old Turkic Orkhon", "Old Turkic Yenisei", "Old Permic"]),
	)

	Tab := DSLPadGUI.Add("Tab3", "w" windowWidth " h" windowHeight, DSLTabs)
	DSLPadGUI.SetFont("s11")
	Tab.UseTab(1)

	DiacriticLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	DiacriticLV.ModifyCol(1, ColumnWidths[1])
	DiacriticLV.ModifyCol(2, ColumnWidths[2])
	DiacriticLV.ModifyCol(3, ColumnWidths[3])
	DiacriticLV.ModifyCol(4, ColumnWidths[4])
	DiacriticLV.ModifyCol(5, ColumnWidths[5])
	DiacriticLV.ModifyCol(6, ColumnWidths[6])

	for item in DSLContent["BindList"].TabDiacritics
	{
		DiacriticLV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
	}


	DiacriticsFilterIcon := DSLPadGUI.Add("Button", CommonFilter.icon)
	GuiButtonIcon(DiacriticsFilterIcon, ImageRes, 169)
	DiacriticsFilter := DSLPadGUI.Add("Edit", CommonFilter.field . "DiacriticsFilter", "")
	DiacriticsFilter.SetFont("s10")
	DiacriticsFilter.OnEvent("Change", (*) => FilterListView(DSLPadGUI, "DiacriticsFilter", DiacriticLV, DSLContent["BindList"].TabDiacritics))

	GroupBoxDiacritic := {
		group: DSLPadGUI.Add("GroupBox", "vDiacriticGroup " . CommonInfoBox.body, CommonInfoBox.bodyText),
		groupFrame: DSLPadGUI.Add("GroupBox", CommonInfoBox.previewFrame),
		preview: DSLPadGUI.Add("Edit", "vDiacriticSymbol " . commonInfoBox.preview, CommonInfoBox.previewText),
		title: DSLPadGUI.Add("Text", "vDiacriticTitle " . commonInfoBox.title, CommonInfoBox.titleText),
		;
		LaTeXTitleLTX: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleLTX, CommonInfoBox.LaTeXTitleLTXText).SetFont("s10", "Cambria"),
		LaTeXTitleA: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleA, CommonInfoBox.LaTeXTitleAText).SetFont("s9", "Cambria"),
		LaTeXTitleE: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleE, CommonInfoBox.LaTeXTitleEText).SetFont("s10", "Cambria"),
		LaTeXPackage: DSLPadGUI.Add("Text", "vDiacriticLaTeXPackage " . CommonInfoBox.LaTeXPackage, CommonInfoBox.LaTeXPackageText).SetFont("s9"),
		LaTeX: DSLPadGUI.Add("Edit", "vDiacriticLaTeX " . commonInfoBox.LaTeX, CommonInfoBox.LaTeXText),
		;
		altTitle: DSLPadGUI.Add("Text", CommonInfoBox.altTitle, CommonInfoBox.altTitleText[LanguageCode]).SetFont("s9"),
		alt: DSLPadGUI.Add("Edit", "vDiacriticAlt " . commonInfoBox.alt, CommonInfoBox.altText),
		;
		unicodeTitle: DSLPadGUI.Add("Text", CommonInfoBox.unicodeTitle, CommonInfoBox.unicodeTitleText[LanguageCode]).SetFont("s9"),
		unicode: DSLPadGUI.Add("Edit", "vDiacriticUnicode " . commonInfoBox.unicode, CommonInfoBox.unicodeText),
		;
		htmlTitle: DSLPadGUI.Add("Text", CommonInfoBox.htmlTitle, CommonInfoBox.htmlTitleText[LanguageCode]).SetFont("s9"),
		html: DSLPadGUI.Add("Edit", "vDiacriticHTML " . commonInfoBox.html, CommonInfoBox.htmlText),
		;
		tags: DSLPadGUI.Add("Edit", "vDiacriticTags " . commonInfoBox.tags),
		alert: DSLPadGUI.Add("Edit", "vDiacriticAlert " commonInfoBox.alert),
	}

	GroupBoxDiacritic.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxDiacritic.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxDiacritic.LaTeX.SetFont("s12")
	GroupBoxDiacritic.alt.SetFont("s12")
	GroupBoxDiacritic.unicode.SetFont("s12")
	GroupBoxDiacritic.html.SetFont("s12")
	GroupBoxDiacritic.tags.SetFont("s9")
	GroupBoxDiacritic.alert.SetFont("s9")

	Tab.UseTab(2)

	SpacesLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	SpacesLV.ModifyCol(1, ColumnWidths[1])
	SpacesLV.ModifyCol(2, ColumnWidths[2])
	SpacesLV.ModifyCol(3, ColumnWidths[3])
	SpacesLV.ModifyCol(4, ColumnWidths[4])
	SpacesLV.ModifyCol(5, ColumnWidths[5])
	SpacesLV.ModifyCol(6, ColumnWidths[6])

	for item in DSLContent["BindList"].TabSpaces
	{
		SpacesLV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
	}

	SpacesFilterIcon := DSLPadGUI.Add("Button", CommonFilter.icon)
	GuiButtonIcon(SpacesFilterIcon, ImageRes, 169)
	SpacesFilter := DSLPadGUI.Add("Edit", CommonFilter.field . "SpaceFilter", "")
	SpacesFilter.SetFont("s10")
	SpacesFilter.OnEvent("Change", (*) => FilterListView(DSLPadGUI, "SpaceFilter", SpacesLV, DSLContent["BindList"].TabSpaces))

	GroupBoxSpaces := {
		group: DSLPadGUI.Add("GroupBox", "vSpacesGroup " . CommonInfoBox.body, CommonInfoBox.bodyText),
		groupFrame: DSLPadGUI.Add("GroupBox", CommonInfoBox.previewFrame),
		preview: DSLPadGUI.Add("Edit", "vSpacesSymbol " . commonInfoBox.preview, CommonInfoBox.previewText),
		title: DSLPadGUI.Add("Text", "vSpacesTitle " . commonInfoBox.title, CommonInfoBox.titleText),
		;
		LaTeXTitleLTX: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleLTX, CommonInfoBox.LaTeXTitleLTXText).SetFont("s10", "Cambria"),
		LaTeXTitleA: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleA, CommonInfoBox.LaTeXTitleAText).SetFont("s9", "Cambria"),
		LaTeXTitleE: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleE, CommonInfoBox.LaTeXTitleEText).SetFont("s10", "Cambria"),
		LaTeXPackage: DSLPadGUI.Add("Text", "vSpacesLaTeXPackage " . CommonInfoBox.LaTeXPackage, CommonInfoBox.LaTeXPackageText).SetFont("s9"),
		LaTeX: DSLPadGUI.Add("Edit", "vSpacesLaTeX " . commonInfoBox.LaTeX, CommonInfoBox.LaTeXText),
		;
		altTitle: DSLPadGUI.Add("Text", CommonInfoBox.altTitle, CommonInfoBox.altTitleText[LanguageCode]).SetFont("s9"),
		alt: DSLPadGUI.Add("Edit", "vSpacesAlt " . commonInfoBox.alt, CommonInfoBox.altText),
		;
		unicodeTitle: DSLPadGUI.Add("Text", CommonInfoBox.unicodeTitle, CommonInfoBox.unicodeTitleText[LanguageCode]).SetFont("s9"),
		unicode: DSLPadGUI.Add("Edit", "vSpacesUnicode " . commonInfoBox.unicode, CommonInfoBox.unicodeText),
		;
		htmlTitle: DSLPadGUI.Add("Text", CommonInfoBox.htmlTitle, CommonInfoBox.htmlTitleText[LanguageCode]).SetFont("s9"),
		html: DSLPadGUI.Add("Edit", "vSpacesHTML " . commonInfoBox.html, CommonInfoBox.htmlText),
		tags: DSLPadGUI.Add("Edit", "vSpacesTags " . commonInfoBox.tags),
		alert: DSLPadGUI.Add("Edit", "vSpacesAlert " commonInfoBox.alert),
	}

	GroupBoxSpaces.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxSpaces.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxSpaces.LaTeX.SetFont("s12")
	GroupBoxSpaces.alt.SetFont("s12")
	GroupBoxSpaces.unicode.SetFont("s12")
	GroupBoxSpaces.html.SetFont("s12")
	GroupBoxSpaces.tags.SetFont("s9")
	GroupBoxSpaces.alert.SetFont("s9")

	Tab.UseTab(6)
	CommandsTree := DSLPadGUI.AddTreeView("x25 y43 w256 h510 -HScroll")

	CommandsTree.OnEvent("ItemSelect", (TV, Item) => TV_InsertCommandsDesc(TV, Item, GroupBoxCommands.text))

	GroupBoxCommands := {
		group: DSLPadGUI.Add("GroupBox", CommandsInfoBox.body, CommandsInfoBox.bodyText[LanguageCode]),
		text: DSLPadGUI.Add("Link", CommandsInfoBox.text),
	}

	Command_controls := CommandsTree.Add(Locale.Read("func_label_controls"))
	Command_disable := CommandsTree.Add(Locale.Read("func_label_disable"))
	Command_gotopage := CommandsTree.Add(Locale.Read("func_label_gotopage"))
	Command_selgoto := CommandsTree.Add(Locale.Read("func_label_selgoto"))
	Command_copylist := CommandsTree.Add(Locale.Read("func_label_favorites"))
	Command_copylist := CommandsTree.Add(Locale.Read("func_label_copylist"))
	Command_tagsearch := CommandsTree.Add(Locale.Read("func_label_tagsearch"))
	Command_uninsert := CommandsTree.Add(Locale.Read("func_label_uninsert"))
	Command_altcode := CommandsTree.Add(Locale.Read("func_label_altcode"))
	Command_smelter := CommandsTree.Add(Locale.Read("func_label_smelter"), , "Expand")
	Command_compose := CommandsTree.Add(Locale.Read("func_label_compose"), Command_smelter)
	Command_num_superscript := CommandsTree.Add(Locale.Read("func_label_num_superscript"))
	Command_num_roman := CommandsTree.Add(Locale.Read("func_label_num_roman"))
	Command_fastkeys := CommandsTree.Add(Locale.Read("func_label_fastkeys"))
	Command_extralayouts := CommandsTree.Add(Locale.Read("func_label_scripts"))
	Command_glagokeys := CommandsTree.Add(Locale.Read("func_label_glagolitic_futhark"), Command_extralayouts)
	Command_oldturkic := CommandsTree.Add(Locale.Read("func_label_old_permic_old_turkic"), Command_extralayouts)
	Command_oldhungary := CommandsTree.Add(Locale.Read("func_label_old_hungarian"), Command_extralayouts)
	Command_gothic := CommandsTree.Add(Locale.Read("func_label_gothic"), Command_extralayouts)
	Command_olditalic := CommandsTree.Add(Locale.Read("func_label_old_italic"), Command_extralayouts)
	Command_phoenician := CommandsTree.Add(Locale.Read("func_label_phoenician"), Command_extralayouts)
	Command_southarabian := CommandsTree.Add(Locale.Read("func_label_ancient_south_arabian"), Command_extralayouts)
	Command_func_label_ipa := CommandsTree.Add(Locale.Read("func_label_ipa"), Command_extralayouts)
	Command_func_label_maths := CommandsTree.Add(Locale.Read("func_label_maths"), Command_extralayouts)
	Command_alterations := CommandsTree.Add(Locale.Read("func_label_alterations"))
	Command_alterations_combining := CommandsTree.Add(Locale.Read("func_label_alterations_combining"), Command_alterations)
	Command_alterations_modifier := CommandsTree.Add(Locale.Read("func_label_alterations_modifier"), Command_alterations)
	Command_alterations_italic_to_bold := CommandsTree.Add(Locale.Read("func_label_alterations_italic_to_bold"), Command_alterations)
	Command_alterations_fraktur_script_struck := CommandsTree.Add(Locale.Read("func_label_alterations_fraktur_script_struck"), Command_alterations)
	Command_alterations_sans_serif := CommandsTree.Add(Locale.Read("func_label_alterations_sans_serif"), Command_alterations)
	Command_alterations_monospace := CommandsTree.Add(Locale.Read("func_label_alterations_monospace"), Command_alterations)
	Command_alterations_small_capital := CommandsTree.Add(Locale.Read("func_label_alterations_small_capital"), Command_alterations)
	Command_inputtoggle := CommandsTree.Add(Locale.Read("func_label_input_toggle"))
	Command_layouttoggle := CommandsTree.Add(Locale.Read("func_label_layout_toggle"))
	Command_notifs := CommandsTree.Add(Locale.Read("func_label_notifications"))
	Command_textprocessing := CommandsTree.Add(Locale.Read("func_label_text_processing"))
	Command_tp_paragraph := CommandsTree.Add(Locale.Read("func_label_tp_paragraph"), Command_textprocessing)
	Command_tp_grep := CommandsTree.Add(Locale.Read("func_label_tp_grep"), Command_textprocessing)
	Command_tp_quotes := CommandsTree.Add(Locale.Read("func_label_tp_quotes"), Command_textprocessing)
	Command_tp_html := CommandsTree.Add(Locale.Read("func_label_tp_html"), Command_textprocessing)
	Command_tp_unicode := CommandsTree.Add(Locale.Read("func_label_tp_unicode"), Command_textprocessing)
	Command_lcoverage := CommandsTree.Add(Locale.Read("func_label_coverage"))


	for coverage in AlphabetCoverage {
		CommandsTree.Add(Locale.Read("func_label_coverage_" coverage), Command_lcoverage)
	}


	DSLPadGUI.SetFont("s9")

	BtnAutoLoad := DSLPadGUI.Add("Button", "x577 y527 w200 h32", Locale.Read("autoload_add"))
	BtnAutoLoad.OnEvent("Click", AddScriptToAutoload)

	BtnSwitchRU := DSLPadGUI.Add("Button", "x300 y527 w32 h32", "РУ")
	BtnSwitchRU.OnEvent("Click", (*) => SwitchLanguage("ru"))

	BtnSwitchEN := DSLPadGUI.Add("Button", "x332 y527 w32 h32", "EN")
	BtnSwitchEN.OnEvent("Click", (*) => SwitchLanguage("en"))

	UpdateBtn := DSLPadGUI.Add("Button", "x809 y495 w32 h32")
	UpdateBtn.OnEvent("Click", (*) => "GetUpdate()")
	GuiButtonIcon(UpdateBtn, ImageRes, 176, "w24 h24")

	RepairBtn := DSLPadGUI.Add("Button", "x777 y495 w32 h32", "🛠️")
	RepairBtn.SetFont("s16")
	RepairBtn.OnEvent("Click", (*) => "GetUpdate(0, True)")

	ConfigFileBtn := DSLPadGUI.Add("Button", "x809 y527 w32 h32")
	ConfigFileBtn.OnEvent("Click", (*) => OpenConfigFile())
	GuiButtonIcon(ConfigFileBtn, ImageRes, 065)

	LocalesFileBtn := DSLPadGUI.Add("Button", "x777 y527 w32 h32")
	LocalesFileBtn.OnEvent("Click", (*) => OpenLocalesFile())
	GuiButtonIcon(LocalesFileBtn, ImageRes, 015)


	UpdateNewIcon := DSLPadGUI.Add("Text", "vNewVersionIcon x300 y484 w40 h40 BackgroundTrans", "")
	UpdateNewIcon.SetFont("s16")
	UpdateNewVersion := DSLPadGUI.Add("Link", "vNewVersionAlert x316 y492 w300", "")
	UpdateNewVersion.SetFont("s9")

	if UpdateAvailable
	{
		DSLPadGUI["NewVersionAlert"].Text :=
			Util.StrVarsInject(Locale.Read("update_available"), UpdateVersionString) ' (<a href="' RepoSource '">GitHub</a>)'
		DSLPadGUI["NewVersionIcon"].Text := InformationSymbol
	}

	LatinLayoutSelector := DSLPadGUI.AddDropDownList("vLatLayout w74 x502 y528", GetLayoutsList)
	PostMessage(0x0153, -1, 24, LatinLayoutSelector)

	LatinLayoutName := IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")
	LatinLayoutSelector.Text := LatinLayoutName
	LatinLayoutSelector.OnEvent("Change", (CB, Zero) => ChangeQWERTY(CB))

	CyrillicLayoutSelector := DSLPadGUI.AddDropDownList("vCyrLayout w82 x418 y528", CyrillicLayoutsList)
	PostMessage(0x0153, -1, 24, CyrillicLayoutSelector)

	CyrillicLayoutName := IniRead(ConfigFile, "Settings", "CyrillicLayout", "QWERTY")
	CyrillicLayoutSelector.Text := CyrillicLayoutName
	CyrillicLayoutSelector.OnEvent("Change", (CB, Zero) => ChangeQWERTY(CB))

	DSLPadGUI.SetFont("s11")


	Tab.UseTab(3)

	LigaturesLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.smelting)
	LigaturesLV.ModifyCol(1, ColumnWidths[1])
	LigaturesLV.ModifyCol(2, 110)
	LigaturesLV.ModifyCol(3, 100)
	LigaturesLV.ModifyCol(4, ColumnWidths[4])
	LigaturesLV.ModifyCol(5, ColumnWidths[5])
	LigaturesLV.ModifyCol(6, ColumnWidths[6])

	for item in DSLContent["BindList"].TabSmelter
	{
		LigaturesLV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
	}

	LigaturesFilterIcon := DSLPadGUI.Add("Button", CommonFilter.icon)
	GuiButtonIcon(LigaturesFilterIcon, ImageRes, 169)
	LigaturesFilter := DSLPadGUI.Add("Edit", CommonFilter.field . "LigFilter", "")
	LigaturesFilter.SetFont("s10")
	LigaturesFilter.OnEvent("Change", (*) => FilterListView(DSLPadGUI, "LigFilter", LigaturesLV, DSLContent["BindList"].TabSmelter))


	GroupBoxLigatures := {
		group: DSLPadGUI.Add("GroupBox", "vLigaturesGroup " . CommonInfoBox.body, CommonInfoBox.bodyText),
		groupFrame: DSLPadGUI.Add("GroupBox", CommonInfoBox.previewFrame),
		preview: DSLPadGUI.Add("Edit", "vLigaturesSymbol " . commonInfoBox.preview, CommonInfoBox.previewText),
		title: DSLPadGUI.Add("Text", "vLigaturesTitle " . commonInfoBox.title, CommonInfoBox.titleText),
		;
		LaTeXTitleLTX: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleLTX, CommonInfoBox.LaTeXTitleLTXText).SetFont("s10", "Cambria"),
		LaTeXTitleA: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleA, CommonInfoBox.LaTeXTitleAText).SetFont("s9", "Cambria"),
		LaTeXTitleE: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleE, CommonInfoBox.LaTeXTitleEText).SetFont("s10", "Cambria"),
		LaTeXPackage: DSLPadGUI.Add("Text", "vLigaturesLaTeXPackage " . CommonInfoBox.LaTeXPackage, CommonInfoBox.LaTeXPackageText).SetFont("s9"),
		LaTeX: DSLPadGUI.Add("Edit", "vLigaturesLaTeX " . commonInfoBox.LaTeX, CommonInfoBox.LaTeXText),
		;
		altTitle: DSLPadGUI.Add("Text", CommonInfoBox.altTitle, CommonInfoBox.altTitleText[LanguageCode]).SetFont("s9"),
		alt: DSLPadGUI.Add("Edit", "vLigaturesAlt " . commonInfoBox.alt, CommonInfoBox.altText),
		;
		unicodeTitle: DSLPadGUI.Add("Text", CommonInfoBox.unicodeTitle, CommonInfoBox.unicodeTitleText[LanguageCode]).SetFont("s9"),
		unicode: DSLPadGUI.Add("Edit", "vLigaturesUnicode " . commonInfoBox.unicode, CommonInfoBox.unicodeText),
		;
		htmlTitle: DSLPadGUI.Add("Text", CommonInfoBox.htmlTitle, CommonInfoBox.htmlTitleText[LanguageCode]).SetFont("s9"),
		html: DSLPadGUI.Add("Edit", "vLigaturesHTML " . commonInfoBox.html, CommonInfoBox.htmlText),
		tags: DSLPadGUI.Add("Edit", "vLigaturesTags " . commonInfoBox.tags),
		alert: DSLPadGUI.Add("Edit", "vLigaturesAlert " commonInfoBox.alert),
	}

	GroupBoxLigatures.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxLigatures.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxLigatures.LaTeX.SetFont("s12")
	GroupBoxLigatures.alt.SetFont("s12")
	GroupBoxLigatures.unicode.SetFont("s12")
	GroupBoxLigatures.html.SetFont("s12")
	GroupBoxLigatures.tags.SetFont("s9")
	GroupBoxLigatures.alert.SetFont("s9")


	Tab.UseTab(4)

	FastKeysLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	FastKeysLV.ModifyCol(1, ColumnWidths[1])
	FastKeysLV.ModifyCol(2, ColumnWidths[2])
	FastKeysLV.ModifyCol(3, ColumnWidths[3])
	FastKeysLV.ModifyCol(4, ColumnWidths[4])
	FastKeysLV.ModifyCol(5, ColumnWidths[5])
	FastKeysLV.ModifyCol(6, ColumnWidths[6])

	for item in DSLContent["BindList"].TabFastKeys
	{
		FastKeysLV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
	}


	FastKeysFilterIcon := DSLPadGUI.Add("Button", CommonFilter.icon)
	GuiButtonIcon(FastKeysFilterIcon, ImageRes, 169)
	FastKeysFilter := DSLPadGUI.Add("Edit", CommonFilter.field . "FastFilter", "")
	FastKeysFilter.SetFont("s10")
	FastKeysFilter.OnEvent("Change", (*) => FilterListView(DSLPadGUI, "FastFilter", FastKeysLV, DSLContent["BindList"].TabFastKeys))


	GroupBoxFastKeys := {
		group: DSLPadGUI.Add("GroupBox", "vFastKeysGroup " . CommonInfoBox.body, CommonInfoBox.bodyText),
		groupFrame: DSLPadGUI.Add("GroupBox", CommonInfoBox.previewFrame),
		preview: DSLPadGUI.Add("Edit", "vFastKeysSymbol " . commonInfoBox.preview, CommonInfoBox.previewText),
		title: DSLPadGUI.Add("Text", "vFastKeysTitle " . commonInfoBox.title, CommonInfoBox.titleText),
		;
		LaTeXTitleLTX: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleLTX, CommonInfoBox.LaTeXTitleLTXText).SetFont("s10", "Cambria"),
		LaTeXTitleA: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleA, CommonInfoBox.LaTeXTitleAText).SetFont("s9", "Cambria"),
		LaTeXTitleE: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleE, CommonInfoBox.LaTeXTitleEText).SetFont("s10", "Cambria"),
		LaTeXPackage: DSLPadGUI.Add("Text", "vFastKeysLaTeXPackage " . CommonInfoBox.LaTeXPackage, CommonInfoBox.LaTeXPackageText).SetFont("s9"),
		LaTeX: DSLPadGUI.Add("Edit", "vFastKeysLaTeX " . commonInfoBox.LaTeX, CommonInfoBox.LaTeXText),
		;
		altTitle: DSLPadGUI.Add("Text", CommonInfoBox.altTitle, CommonInfoBox.altTitleText[LanguageCode]).SetFont("s9"),
		alt: DSLPadGUI.Add("Edit", "vFastKeysAlt " . commonInfoBox.alt, CommonInfoBox.altText),
		;
		unicodeTitle: DSLPadGUI.Add("Text", CommonInfoBox.unicodeTitle, CommonInfoBox.unicodeTitleText[LanguageCode]).SetFont("s9"),
		unicode: DSLPadGUI.Add("Edit", "vFastKeysUnicode " . commonInfoBox.unicode, CommonInfoBox.unicodeText),
		;
		htmlTitle: DSLPadGUI.Add("Text", CommonInfoBox.htmlTitle, CommonInfoBox.htmlTitleText[LanguageCode]).SetFont("s9"),
		html: DSLPadGUI.Add("Edit", "vFastKeysHTML " . commonInfoBox.html, CommonInfoBox.htmlText),
		tags: DSLPadGUI.Add("Edit", "vFastKeysTags " . commonInfoBox.tags),
		alert: DSLPadGUI.Add("Edit", "vFastAlert " commonInfoBox.alert),
	}

	GroupBoxFastKeys.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxFastKeys.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxFastKeys.LaTeX.SetFont("s12")
	GroupBoxFastKeys.alt.SetFont("s12")
	GroupBoxFastKeys.unicode.SetFont("s12")
	GroupBoxFastKeys.html.SetFont("s12")
	GroupBoxFastKeys.tags.SetFont("s9")
	GroupBoxFastKeys.alert.SetFont("s9")

	Tab.UseTab(5)

	GlagoLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	GlagoLV.ModifyCol(1, ColumnWidths[1])
	GlagoLV.ModifyCol(2, ColumnWidths[2])
	GlagoLV.ModifyCol(3, ColumnWidths[3])
	GlagoLV.ModifyCol(4, ColumnWidths[4])
	GlagoLV.ModifyCol(5, ColumnWidths[5])
	GlagoLV.ModifyCol(6, ColumnWidths[6])

	for item in DSLContent["BindList"].TabGlagoKeys
	{
		GlagoLV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
	}


	GlagoFilterIcon := DSLPadGUI.Add("Button", CommonFilter.icon)
	GuiButtonIcon(GlagoFilterIcon, ImageRes, 169)
	GlagoFilter := DSLPadGUI.Add("Edit", CommonFilter.field . "GlagoFilter", "")
	GlagoFilter.SetFont("s10")
	GlagoFilter.OnEvent("Change", (*) => FilterListView(DSLPadGUI, "GlagoFilter", GlagoLV, DSLContent["BindList"].TabGlagoKeys))


	GroupBoxGlagoKeys := {
		group: DSLPadGUI.Add("GroupBox", "vGlagoKeysGroup " . CommonInfoBox.body, CommonInfoBox.bodyText),
		groupFrame: DSLPadGUI.Add("GroupBox", CommonInfoBox.previewFrame),
		preview: DSLPadGUI.Add("Edit", "vGlagoKeysSymbol " . commonInfoBox.preview, CommonInfoBox.previewText),
		title: DSLPadGUI.Add("Text", "vGlagoKeysTitle " . commonInfoBox.title, CommonInfoBox.titleText),
		;
		LaTeXTitleLTX: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleLTX, CommonInfoBox.LaTeXTitleLTXText).SetFont("s10", "Cambria"),
		LaTeXTitleA: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleA, CommonInfoBox.LaTeXTitleAText).SetFont("s9", "Cambria"),
		LaTeXTitleE: DSLPadGUI.Add("Text", CommonInfoBox.LaTeXTitleE, CommonInfoBox.LaTeXTitleEText).SetFont("s10", "Cambria"),
		LaTeXPackage: DSLPadGUI.Add("Text", "vGlagoKeysLaTeXPackage " . CommonInfoBox.LaTeXPackage, CommonInfoBox.LaTeXPackageText).SetFont("s9"),
		LaTeX: DSLPadGUI.Add("Edit", "vGlagoKeysLaTeX " . commonInfoBox.LaTeX, CommonInfoBox.LaTeXText),
		;
		altTitle: DSLPadGUI.Add("Text", CommonInfoBox.altTitle, CommonInfoBox.altTitleText[LanguageCode]).SetFont("s9"),
		alt: DSLPadGUI.Add("Edit", "vGlagoKeysAlt " . commonInfoBox.alt, CommonInfoBox.altText),
		;
		unicodeTitle: DSLPadGUI.Add("Text", CommonInfoBox.unicodeTitle, CommonInfoBox.unicodeTitleText[LanguageCode]).SetFont("s9"),
		unicode: DSLPadGUI.Add("Edit", "vGlagoKeysUnicode " . commonInfoBox.unicode, CommonInfoBox.unicodeText),
		;
		htmlTitle: DSLPadGUI.Add("Text", CommonInfoBox.htmlTitle, CommonInfoBox.htmlTitleText[LanguageCode]).SetFont("s9"),
		html: DSLPadGUI.Add("Edit", "vGlagoKeysHTML " . commonInfoBox.html, CommonInfoBox.htmlText),
		tags: DSLPadGUI.Add("Edit", "vGlagoKeysTags " . commonInfoBox.tags),
		alert: DSLPadGUI.Add("Edit", "vGlagoAlert " commonInfoBox.alert),
	}

	GroupBoxGlagoKeys.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxGlagoKeys.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxGlagoKeys.LaTeX.SetFont("s12")
	GroupBoxGlagoKeys.alt.SetFont("s12")
	GroupBoxGlagoKeys.unicode.SetFont("s12")
	GroupBoxGlagoKeys.html.SetFont("s12")
	GroupBoxGlagoKeys.tags.SetFont("s9")
	GroupBoxGlagoKeys.alert.SetFont("s9")


	Tab.UseTab(7)

	AboutLeftBox := DSLPadGUI.Add("GroupBox", "x23 y34 w280 h520",)
	DSLPadGUI.Add("GroupBox", "x75 y65 w170 h170")
	DSLPadGUI.Add("Picture", "x98 y89 w128 h128", InternalFiles["AppIco"].File)

	AboutTitle := DSLPadGUI.Add("Text", "x75 y245 w170 h32 Center BackgroundTrans", DSLPadTitleDefault)
	AboutTitle.SetFont("s20 c333333", "Cambria")

	AboutVersion := DSLPadGUI.Add("Text", "x75 y285 w170 h32 Center BackgroundTrans", CurrentVersionString)
	AboutVersion.SetFont("s12 c333333", "Cambria")

	AboutRepoLinkX := LanguageCode == "ru" ? "x114" : "x123"
	AboutRepoLink := DSLPadGUI.Add("Link", AboutRepoLinkX " y320 w150 h20 Center",
		'<a href="https://github.com/DemerNkardaz/DSL-KeyPad">' Locale.Read("about_repository") '</a>'
	)
	AboutRepoLink.SetFont("s12", "Cambria")

	AboutAuthor := DSLPadGUI.Add("Text", "x75 y495 w170 h16 Center BackgroundTrans", Locale.Read("about_author"))
	AboutAuthor.SetFont("s11 c333333", "Cambria")

	AboutAuthorLinks := DSLPadGUI.Add("Link", "x90 y525 w150 h16 Center",
		'<a href="https://github.com/DemerNkardaz/">GitHub</a> '
		'<a href="http://steamcommunity.com/profiles/76561198177249942">STEAM</a> '
		'<a href="https://ficbook.net/authors/4241255">Фикбук</a>'
	)
	AboutAuthorLinks.SetFont("s9", "Cambria")

	AboutDescBox := DSLPadGUI.Add("GroupBox", "x315 y34 w530 h520", Locale.Read("about_item_count") . " — " . DSLPadTitleFull)
	AboutDescBox.SetFont("s11", "Cambria")

	AboutDescription := DSLPadGUI.Add("Text", "x330 y70 w505 h495 Wrap BackgroundTrans", Locale.Read("about_description"))
	AboutDescription.SetFont("s12 c333333", "Cambria")


	Tab.UseTab(8)

	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , Locale.Read("typography"))
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", Locale.Read("typography_layout"))
	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , Locale.Read("unicode_resources"))
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", '<a href="https://symbl.cc/">Symbl.cc</a> <a href="https://www.compart.com/en/unicode/">Compart</a>')
	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , Locale.Read("dictionaries"))
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", Locale.Read("dictionaries_japanese") '<a href="https://yarxi.ru">ЯРКСИ</a> <a href="https://www.warodai.ruu">Warodai</a>')
	DSLPadGUI.Add("Link", "w600", Locale.Read("dictionaries_chinese") '<a href="https://bkrs.info">БКРС</a>')
	DSLPadGUI.Add("Link", "w600", Locale.Read("dictionaries_vietnamese") '<a href="https://chunom.org">Chữ Nôm</a>')

	Tab.UseTab(9)
	DSLPadGUI.Add("GroupBox", "w825 h520", "🌐 " . Locale.Read("tab_changelog"))
	InsertChangesList(DSLPadGUI)


	DiacriticLV.OnEvent("DoubleClick", LV_OpenUnicodeWebsite)
	SpacesLV.OnEvent("DoubleClick", LV_OpenUnicodeWebsite)
	FastKeysLV.OnEvent("DoubleClick", LV_OpenUnicodeWebsite)
	LigaturesLV.OnEvent("DoubleClick", LV_OpenUnicodeWebsite)
	GlagoLV.OnEvent("DoubleClick", LV_OpenUnicodeWebsite)

	DiacriticLV.OnEvent("ItemFocus", (LV, RowNumber) =>
		LV_CharacterDetails(LV, RowNumber, [DSLPadGUI,
			"DiacriticSymbol",
			"DiacriticTitle",
			"DiacriticLaTeX",
			"DiacriticLaTeXPackage",
			"DiacriticAlt",
			"DiacriticUnicode",
			"DiacriticHTML",
			"DiacriticTags",
			"DiacriticGroup",
			GroupBoxDiacritic,
			"DiacriticAlert"
		]))
	SpacesLV.OnEvent("ItemFocus", (LV, RowNumber) =>
		LV_CharacterDetails(LV, RowNumber, [DSLPadGUI,
			"SpacesSymbol",
			"SpacesTitle",
			"SpacesLaTeX",
			"SpacesLaTeXPackage",
			"SpacesAlt",
			"SpacesUnicode",
			"SpacesHTML",
			"SpacesTags",
			"SpacesGroup",
			GroupBoxSpaces,
			"SpacesAlert"
		]))
	FastKeysLV.OnEvent("ItemFocus", (LV, RowNumber) =>
		LV_CharacterDetails(LV, RowNumber, [DSLPadGUI,
			"FastKeysSymbol",
			"FastKeysTitle",
			"FastKeysLaTeX",
			"FastKeysLaTeXPackage",
			"FastKeysAlt",
			"FastKeysUnicode",
			"FastKeysHTML",
			"FastKeysTags",
			"FastKeysGroup",
			GroupBoxFastKeys,
			"FastAlert"
		]))
	GlagoLV.OnEvent("ItemFocus", (LV, RowNumber) =>
		LV_CharacterDetails(LV, RowNumber, [DSLPadGUI,
			"GlagoKeysSymbol",
			"GlagoKeysTitle",
			"GlagoKeysLaTeX",
			"GlagoKeysLaTeXPackage",
			"GlagoKeysAlt",
			"GlagoKeysUnicode",
			"GlagoKeysHTML",
			"GlagoKeysTags",
			"GlagoKeysGroup",
			GroupBoxGlagoKeys,
			"GlagoAlert"
		]))
	LigaturesLV.OnEvent("ItemFocus", (LV, RowNumber) =>
		LV_CharacterDetails(LV, RowNumber, [DSLPadGUI,
			"LigaturesSymbol",
			"LigaturesTitle",
			"LigaturesLaTeX",
			"LigaturesLaTeXPackage",
			"LigaturesAlt",
			"LigaturesUnicode",
			"LigaturesHTML",
			"LigaturesTags",
			"LigaturesGroup",
			GroupBoxLigatures,
			"LigaturesAlert"
		]))

	SetCharacterInfoPanel(RandPreview["Diacritics"][1], RandPreview["Diacritics"][2], DSLPadGUI, "DiacriticSymbol", "DiacriticTitle", "DiacriticLaTeX", "DiacriticLaTeXPackage", "DiacriticAlt", "DiacriticUnicode", "DiacriticHTML", "DiacriticTags", "DiacriticGroup", GroupBoxDiacritic, "DiacriticAlert")
	SetCharacterInfoPanel(RandPreview["Spaces"][1], RandPreview["Spaces"][2], DSLPadGUI, "SpacesSymbol", "SpacesTitle", "SpacesLaTeX", "SpacesLaTeXPackage", "SpacesAlt", "SpacesUnicode", "SpacesHTML", "SpacesTags", "SpacesGroup", GroupBoxSpaces, "SpacesAlert")
	SetCharacterInfoPanel(RandPreview["FastKeys"][1], RandPreview["FastKeys"][2], DSLPadGUI, "FastKeysSymbol", "FastKeysTitle", "FastKeysLaTeX", "FastKeysLaTeXPackage", "FastKeysAlt", "FastKeysUnicode", "FastKeysHTML", "FastKeysTags", "FastKeysGroup", GroupBoxFastKeys, "FastAlert")
	SetCharacterInfoPanel(RandPreview["Ligatures"][1], RandPreview["Ligatures"][2], DSLPadGUI, "LigaturesSymbol", "LigaturesTitle", "LigaturesLaTeX", "LigaturesLaTeXPackage", "LigaturesAlt", "LigaturesUnicode", "LigaturesHTML", "LigaturesTags", "LigaturesGroup", GroupBoxLigatures, "LigaturesAlert")
	SetCharacterInfoPanel(RandPreview["GlagoKeys"][1], RandPreview["GlagoKeys"][2], DSLPadGUI, "GlagoKeysSymbol", "GlagoKeysTitle", "GlagoKeysLaTeX", "GlagoKeysLaTeXPackage", "GlagoKeysAlt", "GlagoKeysUnicode", "GlagoKeysHTML", "GlagoKeysTags", "GlagoKeysGroup", GroupBoxGlagoKeys, "GlagoAlert")

	DSLPadGUI.Title := DSLPadTitle

	DSLPadGUI.Show("x" xPos " y" yPos)

	return DSLPadGUI
}

PopulateListView(LV, DataList) {
	LV.Delete()
	for item in DataList {
		LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
	}
}

FilterListView(GuiFrame, FilterField, LV, DataList) {
	FilterText := StrLower(GuiFrame[FilterField].Text)
	LV.Delete()

	if FilterText = ""
		PopulateListView(LV, DataList)
	else {
		GroupStarted := False
		PreviousGroupName := ""
		for item in DataList {
			ItemText := StrLower(item[1])

			IsFavorite := (ItemText ~= "\Q★")
			IsMatch := InStr(ItemText, FilterText)
				|| (IsFavorite && (InStr("избранное", FilterText) || InStr("favorite", FilterText)))

			if ItemText = "" {
				LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
				GroupStarted := true
			} else if IsMatch {
				if !GroupStarted {
					GroupStarted := true
				}
				LV.Add(, item[1], item[2], item[3], item[4], item[5], item[6])
			} else if GroupStarted {
				GroupStarted := False
			}

			if ItemText != "" and ItemText != PreviousGroupName {
				PreviousGroupName := ItemText
			}
		}

		if GroupStarted {
			LV.Add(, "", "", "", "")
		}

		if PreviousGroupName != "" {
			LV.Add(, "", "", "", "")
		}
	}
}


GetRandomByGroups(GroupNames) {
	TemporaryStorage := []
	for characterEntry, value in Characters {
		if (HasProp(value, "group")) {
			groups := value.group[1]
			if IsObject(groups) {
				for group in GroupNames {
					for item in groups {
						if (item == group) {
							entryID := ""
							entryName := ""
							if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
								entryID := match[1]
								entryName := match[2]
							}
							TemporaryStorage.Push([entryID, entryName, value.unicode])
							break 2
						}
					}
				}
			} else {
				for group in GroupNames {
					if (groups == group) {
						entryID := ""
						entryName := ""
						if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
							entryID := match[1]
							entryName := match[2]
						}
						TemporaryStorage.Push([entryID, entryName, value.unicode])
						break
					}
				}
			}
		}
	}

	if (TemporaryStorage.Length > 0) {
		randomIndex := Random(1, TemporaryStorage.Length)
		return TemporaryStorage[randomIndex]
	}
}

HasPermicFont := IsFont("Noto Sans Old Permic2") ? True : "Noto Sans Old Permic"
HasHungarianFont := IsFont("Noto Sans Old Hungarian2") ? True : "Noto Sans Old Hungarian"

SetCharacterInfoPanel(EntryIDKey, EntryNameKey, TargetGroup, PreviewObject, PreviewTitle, PreviewLaTeX, PreviewLaTeXPackage, PreviewAlt, PreviewUnicode, PreviewHTML, PreviewTags, PreviewGroupTitle, PreviewGroup, PreviewAlert := "") {
	LanguageCode := Language.Get()
	if (EntryNameKey != "" && EntryIDKey != "") {
		GetEntry := Characters[EntryIDKey " " EntryNameKey]

		if !HasProp(GetEntry, "symbol") {
			return
		}

		characterTitle := ""
		if (HasProp(GetEntry, "titlesAlt") && GetEntry.titlesAlt == True && !InStr(Locale.Read(EntryNameKey "_alt"), "NOT FOUND")) {
			characterTitle := Locale.Read(EntryNameKey . "_alt")
		} else if !InStr(Locale.Read(EntryNameKey), "NOT FOUND") {
			characterTitle := Locale.Read(EntryNameKey)
		} else if (HasProp(GetEntry, "titlesAltOnEntry")) {
			characterTitle := GetEntry.titlesAltOnEntry[LanguageCode]
		} else if (HasProp(GetEntry, "titles") &&
			(!HasProp(GetEntry, "titlesAlt") || HasProp(GetEntry, "titlesAlt") && GetEntry.titlesAlt == True)) {
			characterTitle := GetEntry.titles[LanguageCode]
		} else {
			characterTitle := Locale.Read(EntryNameKey)
		}

		if (HasProp(GetEntry, "symbol")) {
			if (HasProp(GetEntry, "symbolAlt")) {
				TargetGroup[PreviewObject].Text := GetEntry.symbolAlt
			} else {
				TargetGroup[PreviewObject].Text := GetEntry.symbol
			}
		}

		if (HasProp(GetEntry, "symbolFont")) {
			PreviewGroup.preview.SetFont(, GetEntry.symbolFont)
		} else {
			PreviewGroup.preview.SetFont(, FontFace["serif"].name)
		}

		if HasProp(GetEntry, "symbolCustom") {
			PreviewGroup.preview.SetFont(
				CommonInfoFonts.previewSize . " norm cDefault"
			)
			TargetGroup[PreviewObject].SetFont(
				GetEntry.symbolCustom
			)
		} else if (StrLen(TargetGroup[PreviewObject].Text) > 2) || ContainsEmoji(TargetGroup[PreviewObject].Text) {
			PreviewGroup.preview.SetFont(
				CommonInfoFonts.previewSmaller " norm cDefault"
			)
		} else {
			PreviewGroup.preview.SetFont(
				CommonInfoFonts.previewSize " norm cDefault"
			)
		}

		TargetGroup[PreviewTitle].Text := characterTitle

		if HasProp(GetEntry, "uniSequence") && IsObject(GetEntry.uniSequence) {
			TempValue := ""
			TotalIndex := 0
			for index in GetEntry.uniSequence {
				TotalIndex++
			}
			CurrentIndex := 0
			for unicode in GetEntry.uniSequence {
				CurrentIndex++
				TempValue .= SubStr(unicode, 2, StrLen(unicode) - 2)
				TempValue .= CurrentIndex < TotalIndex ? " " : ""
			}
			TargetGroup[PreviewUnicode].Text := TempValue
		} else {
			TargetGroup[PreviewUnicode].Text := SubStr(GetEntry.unicode, 2, StrLen(GetEntry.unicode) - 2)
		}

		if (StrLen(TargetGroup[PreviewUnicode].Text) > 9
			&& StrLen(TargetGroup[PreviewUnicode].Text) < 15) {
			PreviewGroup.unicode.SetFont("s10")
		} else if (StrLen(TargetGroup[PreviewUnicode].Text) > 14) {
			PreviewGroup.unicode.SetFont("s9")
		} else {
			PreviewGroup.unicode.SetFont("s12")
		}

		if (HasProp(GetEntry, "entity")) {
			TargetGroup[PreviewHTML].Text := GetEntry.html " " GetEntry.entity
		} else {
			TargetGroup[PreviewHTML].Text := GetEntry.html
		}

		if (StrLen(TargetGroup[PreviewHTML].Text) > 9
			&& StrLen(TargetGroup[PreviewHTML].Text) < 15) {
			PreviewGroup.html.SetFont("s10")
		} else if (StrLen(TargetGroup[PreviewHTML].Text) > 14) {
			PreviewGroup.html.SetFont("s9")
		} else {
			PreviewGroup.html.SetFont("s12")
		}

		EntryString := Locale.Read("entry") ": " EntryNameKey
		TagsString := ""
		if (HasProp(GetEntry, "tags")) {
			TagsString := Locale.Read("tags") . ": "

			totalCount := 0
			for index in GetEntry.tags {
				totalCount++
			}

			currentIndex := 0
			for index, tag in GetEntry.tags {
				TagsString .= tag
				currentIndex++
				if (currentIndex < totalCount) {
					TagsString .= ", "
				}
			}

		}
		TargetGroup[PreviewTags].Text := EntryString GetChar("ensp") TagsString

		GroupTitle := ""
		IsDiacritic := RegExMatch(GetEntry.symbol, "^" DottedCircle "\S")

		AlterationsValidator := Map(
			"IsModifier", [HasProp(GetEntry, "modifierForm"), 0x02B0],
			"IsUncombined", [HasProp(GetEntry, "uncombinedForm"), "(h)"],
			"IsSubscript", [HasProp(GetEntry, "subscriptForm"), 0x2095],
			"IsCombining", [IsDiacritic || HasProp(GetEntry, "combiningForm"), 0x036A],
			"IsItalic", [HasProp(GetEntry, "italicForm"), 0x210E],
			"IsItalicBold", [HasProp(GetEntry, "italicBoldForm"), 0x1D489],
			"IsBold", [HasProp(GetEntry, "boldForm"), 0x1D421],
			"IsFraktur", [HasProp(GetEntry, "frakturForm"), 0x1D525],
			"IsFrakturBold", [HasProp(GetEntry, "frakturBoldForm"), 0x1D58D],
			"IsScript", [HasProp(GetEntry, "scriptForm"), 0x1D4BD],
			"IsScriptBold", [HasProp(GetEntry, "scriptBoldForm"), 0x1D4F1],
			"IsDoubleStruck", [HasProp(GetEntry, "doubleStruckForm"), 0x1D559],
			"IsDoubleStruckItalic", [HasProp(GetEntry, "doubleStruckItalicForm"), 0x2148],
		)

		for entry, value in AlterationsValidator {
			if (value[1]) {
				GroupTitle .= (value[2] == "(h)" ? value[2] : GetChar("dotted_circle") Chr(value[2])) " "
			}
		}


		TargetGroup[PreviewGroupTitle].Text := GroupTitle (IsDiacritic ? Locale.Read("character_combining") : Locale.Read("character"))

		if (HasProp(GetEntry, "altcode")) {
			TargetGroup[PreviewAlt].Text := GetEntry.altcode
		} else {
			TargetGroup[PreviewAlt].Text := "N/A"
		}

		if (HasProp(GetEntry, "LaTeXPackage")) {
			TargetGroup[PreviewLaTeXPackage].Text := "📦 " GetEntry.LaTeXPackage
		} else {
			TargetGroup[PreviewLaTeXPackage].Text := ""
		}

		if (HasProp(GetEntry, "LaTeX")) {
			if IsObject(GetEntry.LaTeX) {
				LaTeXString := ""
				totalCount := 0
				for index in GetEntry.LaTeX {
					totalCount++
				}
				currentIndex := 0
				for index, latex in GetEntry.LaTeX {
					LaTeXString .= latex
					currentIndex++
					if (currentIndex < totalCount) {
						LaTeXString .= " "
					}
				}
				TargetGroup[PreviewLaTeX].Text := LaTeXString

			} else {
				TargetGroup[PreviewLaTeX].Text := GetEntry.LaTeX
			}
		} else {
			TargetGroup[PreviewLaTeX].Text := "N/A"
		}

		if (StrLen(TargetGroup[PreviewLaTeX].Text) > 9
			&& StrLen(TargetGroup[PreviewLaTeX].Text) < 15) {
			PreviewGroup.latex.SetFont("s10")
		} else if (StrLen(TargetGroup[PreviewLaTeX].Text) > 14) {
			PreviewGroup.latex.SetFont("s9")
		} else {
			PreviewGroup.latex.SetFont("s12")
		}

		if RegExMatch(EntryNameKey, "^permic") && HasPermicFont = "Noto Sans Old Permic" {
			TargetGroup[PreviewAlert].Text := Util.StrVarsInject(Locale.Read("warning_nofont"), HasPermicFont)
		}
		else if RegExMatch(EntryNameKey, "^hungarian") && HasHungarianFont = "Noto Sans Old Hungarian" {
			TargetGroup[PreviewAlert].Text := Util.StrVarsInject(Locale.Read("warning_nofont"), HasHungarianFont)
		} else {
			TargetGroup[PreviewAlert].Text := ""
		}
	}
}

ChangeQWERTY(CB) {
	RegisterLayout(CB.Text)
}

TV_InsertCommandsDesc(TV, Item, TargetTextBox) {
	if !Item {
		return
	}

	LabelValidator := [
		"func_label_controls",
		"func_label_disable",
		"func_label_gotopage",
		"func_label_selgoto",
		"func_label_favorites",
		"func_label_copylist",
		"func_label_tagsearch",
		"func_label_uninsert",
		"func_label_altcode",
		"func_label_smelter",
		"func_label_compose",
		"func_label_num_superscript",
		"func_label_num_roman",
		"func_label_fastkeys",
		"func_label_scripts",
		"func_label_alterations",
		"func_label_alterations_combining",
		"func_label_alterations_modifier",
		"func_label_alterations_italic_to_bold",
		"func_label_alterations_fraktur_script_struck",
		"func_label_alterations_sans_serif",
		"func_label_alterations_monospace",
		"func_label_alterations_small_capital",
		"func_label_glagolitic_futhark",
		"func_label_old_permic_old_turkic",
		"func_label_old_hungarian",
		"func_label_gothic",
		"func_label_old_italic",
		"func_label_phoenician",
		"func_label_ancient_south_arabian",
		"func_label_ipa",
		"func_label_maths",
		"func_label_input_toggle",
		"func_label_layout_toggle",
		"func_label_notifications",
		"func_label_text_processing",
		"func_label_tp_quotes",
		"func_label_tp_paragraph",
		"func_label_tp_grep",
		"func_label_tp_html",
		"func_label_tp_unicode",
		"func_label_coverage",
	]

	for coverage in AlphabetCoverage {
		LabelValidator.Push("func_label_coverage_" coverage)
	}

	SelectedLabel := TV.GetText(Item)

	for label in LabelValidator
	{
		if (Locale.Read(label) = SelectedLabel) {
			TargetTextBox.Text := Locale.Read(label . "_description")
			if InStr(label, "coverage_") {
				TargetTextBox.SetFont("s16", FontFace["serif"].name)
			} else {
				TargetTextBox.SetFont("s10", "Segoe UI")
			}
		}
	}

}
LV_CharacterDetails(LV, RowNumber, SetupArray) {
	EntryTitle := LV.GetText(RowNumber, 1)
	;UnicodeKey := LV.GetText(RowNumber, 4)
	EntryIDKey := LV.GetText(RowNumber, 5)
	EntryNameKey := LV.GetText(RowNumber, 6)

	SetCharacterInfoPanel(EntryIDKey, EntryNameKey,
		SetupArray[1], SetupArray[2], SetupArray[3],
		SetupArray[4], SetupArray[5], SetupArray[6],
		SetupArray[7], SetupArray[8], SetupArray[9],
		SetupArray[10], SetupArray[11], SetupArray.Has(12) ? SetupArray[12] : "")
}

LV_OpenUnicodeWebsite(LV, RowNumber) {
	EntryTitle := LV.GetText(RowNumber, 1)
	SelectedRow := LV.GetText(RowNumber, 4)

	URIComponent := FindCharacterPage(SelectedRow, True)
	if (SelectedRow != "") {
		isCtrlDown := GetKeyState("LControl")
		isShiftDown := GetKeyState("LShift")
		ModifiedCharsType := GetModifiedCharsType()
		if (isCtrlDown) {
			if (InputMode = "HTML" || InputMode = "LaTeX") {
				for characterEntry, value in Characters {
					if (SelectedRow = UniTrim(value.unicode)) {
						if ModifiedCharsType && HasProp(value, ModifiedCharsType "Form") {
							A_Clipboard := value.%ModifiedCharsType%Form
						} else if InputMode = "HTML" && HasProp(value, "html") {
							A_Clipboard := HasProp(value, "entity") ? value.entity : value.html
						} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
							A_Clipboard := IsObject(value.LaTeX) ? (LaTeXMode = "Math" ? value.LaTeX[2] : value.LaTeX[1]) : value.LaTeX
						}
					}
				}
			} else {
				UnicodeCodePoint := "0x" . SelectedRow
				A_Clipboard := Chr(UnicodeCodePoint)
			}


			SoundPlay("C:\Windows\Media\Speech On.wav")
		} else if isShiftDown {
			for characterEntry, value in Characters {
				if (SelectedRow = UniTrim(value.unicode)) {
					if !FavoriteChars.CheckVar(characterEntry) {
						FavoriteChars.Add(characterEntry)
						LV.Modify(RowNumber, , EntryTitle " " Chr(0x2605))
					} else {
						FavoriteChars.Remove(characterEntry)
						LV.Modify(RowNumber, , StrReplace(EntryTitle, " " Chr(0x2605)))
					}
				}
			}

			SoundPlay("C:\Windows\Media\Speech Misrecognition.wav")
		} else {
			Run(URIComponent)
		}
	}
}

LV_MouseMove(Control, x, y) {
	RowNumber := Control.GetItemAt(x, y)

	if (RowNumber) {
		FileName := Control.GetText(RowNumber, 1)
		FileSize := Control.GetText(RowNumber, 2)
		Tooltip "File Name: " FileName "`nFile Size: " FileSize " KB"
	} else {
		Tooltip
	}
}

AddScriptToAutoload(*) {
	LanguageCode := Language.Get()
	Labels := {}
	Labels[] := Map()
	Labels["ru"] := {}
	Labels["en"] := {}
	Labels["ru"].Success := "Ярлык для автозагрузки создан или обновлен."
	Labels["en"].Success := "Shortcut for autoloading created or updated."
	CurrentScriptPath := A_ScriptDir "\DSLKeyPad.exe"
	AutoloadFolder := A_StartMenu "\Programs\Startup"
	ShortcutPath := AutoloadFolder "\DSLKeyPad.lnk"

	if (FileExist(ShortcutPath)) {
		FileDelete(ShortcutPath)
	}

	Command := "powershell -command " "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut('" ShortcutPath "'); $shortcut.TargetPath = '" CurrentScriptPath "'; $shortcut.WorkingDirectory = '" A_ScriptDir "'; $shortcut.IconLocation = '" InternalFiles["AppIco"].File "'; $shortcut.Description = 'DSLKeyPad AutoHotkey Script'; $shortcut.Save()" ""
	RunWait(Command, , "Hide")

	MsgBox(Labels[LanguageCode].Success, DSLPadTitle, 0x40)
}

IsGuiOpen(title) {
	return WinExist(title) != 0
}

CheckQWERTY() {
	return LayoutsPresets.Has(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")) ? IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY") : "QWERTY"
}

CheckYITSUKEN() {
	return CyrllicLayouts.Has(IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН")) ? IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН") : "ЙЦУКЕН"
}

ToggleFastKeys() {
	LanguageCode := Language.Get()
	global FastKeysIsActive, ActiveScriptName, ConfigFile
	FastKeysIsActive := !FastKeysIsActive
	IniWrite (FastKeysIsActive ? "True" : "False"), ConfigFile, "Settings", "FastKeysIsActive"

	MsgBox(Locale.Read("message_fastkeys_" (!FastKeysIsActive ? "de" : "") "activated"), "FastKeys", 0x40)

	Sleep 5
	RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))
	IsLettersModeEnabled := ActiveScriptName != "" ? ActiveScriptName : False
	if IsLettersModeEnabled {
		ActiveScriptName := ""
		ToggleLetterScript(True, IsLettersModeEnabled)
	}
	return
}

ToggleInputMode() {
	LanguageCode := Language.Get()

	ActivationMessage := {}
	ActivationMessage[] := Map()
	ActivationMessage["ru"] := {}
	ActivationMessage["en"] := {}

	InputModeLabel := Map(
		"Unicode", Map("ru", "символов юникода", "en", "unicode symbols"),
		"HTML", Map("ru", "HTML-кодов", "en", "HTML codes"),
		"LaTeX", Map("ru", "LaTeX-кодов", "en", "LaTeX codes")
	)

	global InputMode, ConfigFile

	if (InputMode = "Unicode") {
		InputMode := "HTML"
	} else if (InputMode = "HTML") {
		InputMode := "LaTeX"
	} else if (InputMode = "LaTeX") {
		InputMode := "Unicode"
	}

	IniWrite InputMode, ConfigFile, "Settings", "InputMode"
	Cfg.Set(InputMode, "Input_Mode")


	ActivationMessage["ru"].Active := "Ввод " . InputModeLabel[InputMode][LanguageCode] . " активирован"
	ActivationMessage["en"].Active := "Input " . InputModeLabel[InputMode][LanguageCode] . " activated"

	MsgBox(ActivationMessage[LanguageCode].Active, DSLPadTitle, 0x40)

	return
}

CheckLayoutValid() {
	GetCurrentLayout := GetLayoutLocale()
	if (GetCurrentLayout == CodeEn || GetCurrentLayout == CodeRu) {
		return True
	}
	return False
}

SendPaste(SendKey, Callback := "") {
	Send(SendKey)

	if Callback != "" {
		Sleep 50
		Callback()
	}
}

ConvertComboKeys(Output) {
	Patterns := [
		"<\^>!", "{RAlt}",
		"<\^", "{LCtrl}",
		">\^", "{RCtrl}",
		"\^", "{Ctrl}",
		"<!", "{LAlt}",
		"!", "{Alt}",
		"<\+", "{LShift}",
		">\+", "{RShift}",
		"+", "{Shift}",
		"<#", "{LWin}",
		">#", "{RWin}",
		"#", "{Win}",
		"SC(.*)", "{sc$1}",
		"VK(.*)", "{vk$1}",
	]

	for index, pair in Patterns {
		if (Mod(index, 2) = 1) {
			key := pair
			replacement := Patterns[index + 1]
			try {
				Output := RegExReplace(Output, key, replacement)
			} catch {
				continue
			}
		}
	}
	return Output
}

HandleFastKey(combo := "", characterNames*) {
	Keyboard.CheckLayout(&lang)

	if Language.Validate(lang, "bindings") {
		output := ""

		for _, character in characterNames {
			if ChrLib.entries.HasOwnProp(character) {
				output .= ChrLib.Get(character, True, Cfg.Get("Input_Mode"))
			} else {
				output .= GetCharacterSequence(character)
			}
		}

		keysValidation := "SC(14B|148|14D|150|04A)"
		chrValidation := "(" Chr(0x00AE) ")"

		if StrLen(LongPress.lastLetterInput) > 0 && output == LongPress.lastLetterInput {
			;CaretTooltip(LongPress.lastLetterInput)
		}

		LongPress.lastLetterInput := output


		inputType := (RegExMatch(combo, keysValidation) || RegExMatch(output, chrValidation) || Cfg.Get("Input_Mode") != "Unicode") ? "Text" : "Input"
		Send%inputType%(output)

	} else {
		LongPress.lastLetterInput := ""
		if combo != "" {
			Send(ConvertComboKeys(combo))
		}
	}
	return
}

GetCharacterEntry(characterName, linkOnly := False) {
	for characterEntry, value in Characters {
		entryID := ""
		entryName := ""
		if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
			entryID := match[1]
			entryName := match[2]

			if entryName == characterName {
				return linkOnly ? entryID " " entryName : value
			}
		}
	}

	return False
}

GetCharacterSequence(CharacterName) {
	Output := ""
	ModifiedCharsType := GetModifiedCharsType()
	for characterEntry, value in Characters {
		entryName := RegExReplace(characterEntry, "^\S+\s+")

		if (entryName = CharacterName) {
			characterEntity := (HasProp(value, "entity")) ? value.entity : (HasProp(value, "html")) ? value.html : ""
			characterLaTeX := (HasProp(value, "LaTeX")) ? value.LaTeX : ""

			if InputMode = "HTML" && HasProp(value, "html") {
				Output .=
					(ModifiedCharsType && HasProp(value, ModifiedCharsType "HTML")) ? value.%ModifiedCharsType%HTML : characterEntity
			} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
				Output .= IsObject(characterLaTeX) ? (LaTeXMode = "Math" ? characterLaTeX[2] : characterLaTeX[1]) : characterLaTeX
			} else {
				if ModifiedCharsType && HasProp(value, ModifiedCharsType "Form") {
					if IsObject(value.%ModifiedCharsType%Form) {
						TempValue := ""
						for modifier in value.%ModifiedCharsType%Form {
							TempValue .= PasteUnicode(modifier)
						}
						SendText(TempValue)
					} else {
						Send(value.%ModifiedCharsType%Form)
					}
				} else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
					for unicode in value.uniSequence {
						Output .= PasteUnicode(unicode)
					}
				} else {
					Output .= PasteUnicode(value.unicode)
				}
			}
		}
	}
	return Output
}

CapsSeparatedCall(DefaultAction, AdvancedAction) {
	if (GetKeyState("CapsLock", "T")) {
		AdvancedAction()
	} else {
		DefaultAction()
	}
}

CapsSeparatedKey(Combo, CapitalCharacter, SmallCharacter, Reverse := False) {
	if (GetKeyState("CapsLock", "T")) {
		HandleFastKey(Combo, Reverse ? SmallCharacter : CapitalCharacter)
	} else {
		HandleFastKey(Combo, Reverse ? CapitalCharacter : SmallCharacter)
	}
}

CapsShiftSeparatedKey(CapitalCharacter, SmallCharacter) {
	if (GetKeyState("CapsLock", "T")) {
		GetKeyState("LShift", "P") ? HandleFastKey(SmallCharacter) : HandleFastKey(CapitalCharacter)
	} else {
		GetKeyState("LShift", "P") ? HandleFastKey(CapitalCharacter) : HandleFastKey(SmallCharacter)
	}
}

LangSeparatedCall(enCallback, ruCallback) {
	Keyboard.CheckLayout(&lang)

	if Language.Validate(lang, "bindings") {
		if IsSet(%lang%Callback) {
			%lang%Callback()
		}
	}
	return
}

LangSeparatedKey(combo, enChar, ruChar, useCaps := False, reverse := False) {
	Keyboard.CheckLayout(&lang)

	if Language.Validate(lang, "bindings") {
		if useCaps && IsObject(%lang%Char) {
			CapsSeparatedKey(combo, %lang%Char[1], %lang%Char[2], reverse)
		} else {
			HandleFastKey(combo, IsObject(%lang%Char) ? %lang%Char[1] : %lang%Char)
		}
	} else {
		if combo != "" {
			Send(ConvertComboKeys(combo))
		}
	}
	return
}

RegisterHotKeys(Bindings, CheckRule := FastKeysIsActive) {
	for index, pair in Bindings {
		if (Mod(index, 2) = 1) {
			key := pair
			value := Bindings[index + 1]

			try {
				if (CheckRule) {
					HotKey(key, value, "On")
				} else {
					HotKey(key, value, "Off")
				}
			} catch {
				MsgBox "Error registering hotkey: " key
			}
		}
	}
}

UnregisterKeysLayout() {
	Keys := LayoutsPresets[CheckQWERTY()]
	for keyName, keySC in Keys {
		Patterns := [
			keySC,
			"+" keySC, "<+" keySC, ">+" keySC, "<+>+" keySC, ,
			"!" keySC, "<!" keySC, ">!" keySC, "<!>!" keySC,
			"^" keySC, "<^" keySC, ">^" keySC, "<^>^" keySC,
			"^!" keySC, "<^>!" keySC, "<^<!" keySC, ">^<!" keySC,
			"<^>!+" keySC, "<^>!<+" keySC, "<^>!>+" keySC,
			"<^>!<+>+" keySC, "<^>!<!+" keySC, "<^>!<!<+" keySC,
			"<^>!<!<+>+" keySC,
			"#" keySC, "<#" keySC, ">#" keySC,
			"<#<!" keySC, ">#<!" keySC, "<#>!" keySC, ">#>!" keySC,
			"<#<!+" keySC, ">#<!+" keySC, "<#>!+" keySC, ">#>!+" keySC,
			"<#<!>+" keySC, ">#<!>+" keySC, "<#>!>+" keySC, ">#>!>+" keySC,
		]

		for pattern in Patterns {
			try {
				HotKey(pattern, "Off", "Off")
			} catch {
				continue
			}
		}
	}
}

UnregisterHotKeys(Bindings) {
	for index, pair in Bindings {
		if (Mod(index, 2) = 1) {
			key := pair
			value := Bindings[index + 1]
			try {
				HotKey(key, "Off", "Off")
			} catch {
				continue
			}
		}
	}
}

KeySeq := Map(
	"A", ["A", "A", "A"],
	"B", ["B", "X", "B"],
	"C", ["C", "J", "C"],
	"D", ["D", "E", "S"],
	"E", ["E", ".", "F"],
	"F", ["F", "U", "T"],
	"G", ["G", "I", "D"],
	"H", ["H", "D", "H"],
	"I", ["I", "C", "U"],
	"J", ["J", "H", "N"],
	"K", ["K", "T", "E"],
	"L", ["L", "N", "I"],
	"M", ["M", "M", "M"],
	"N", ["N", "B", "K"],
	"O", ["O", "R", "Y"],
	"P", ["P", "L", ";"],
	"Q", ["Q", "'", "Q"],
	"R", ["R", "P", "P"],
	"S", ["S", "O", "R"],
	"T", ["T", "Y", "G"],
	"U", ["U", "G", "L"],
	"V", ["V", "K", "V"],
	"W", ["W", ",", "W"],
	"X", ["X", "Q", "X"],
	"Y", ["Y", "F", "J"],
	"Z", ["Z", ";", "Z"],
	",", [",", "W", ","],
	".", [".", "V", "."],
	";", [";", "S", "O"],
	"'", ["'", "-", "'"],
	"[", ["[", "/", "["],
	"]", ["]", "=", "]"],
	"~", ["~", "~", "~"],
	"-", ["-", "[", "-"],
	"=", ["=", "]", "="],
	"/", ["/", "Z", "/"],
	"\", ["\", "\", "\"],
	"1", ["1", "1", "1"],
	"2", ["2", "2", "2"],
	"3", ["3", "3", "3"],
	"4", ["4", "4", "4"],
	"5", ["5", "5", "5"],
	"6", ["6", "6", "6"],
	"7", ["7", "7", "7"],
	"8", ["8", "8", "8"],
	"9", ["9", "9", "9"],
	"0", ["0", "0", "0"],
	"Tab", ["Tab", "Tab", "Tab"],
)

KeySeqSlot := Map(
	"A", Map("ЙЦУКЕН", KeySeq["A"], "Диктор", KeySeq["Z"], "ЙІУКЕН (1907)", KeySeq["A"]),
	"B", Map("ЙЦУКЕН", KeySeq["B"], "Диктор", KeySeq["S"], "ЙІУКЕН (1907)", KeySeq["N"]),
	"C", Map("ЙЦУКЕН", KeySeq["C"], "Диктор", KeySeq["L"], "ЙІУКЕН (1907)", KeySeq["V"]),
	"D", Map("ЙЦУКЕН", KeySeq["D"], "Диктор", KeySeq["U"], "ЙІУКЕН (1907)", KeySeq["D"]),
	"E", Map("ЙЦУКЕН", KeySeq["E"], "Диктор", KeySeq["A"], "ЙІУКЕН (1907)", KeySeq["E"]),
	"F", Map("ЙЦУКЕН", KeySeq["F"], "Диктор", KeySeq["G"], "ЙІУКЕН (1907)", KeySeq["G"]),
	"G", Map("ЙЦУКЕН", KeySeq["G"], "Диктор", KeySeq[","], "ЙІУКЕН (1907)", KeySeq["H"]),
	"H", Map("ЙЦУКЕН", KeySeq["H"], "Диктор", KeySeq[";"], "ЙІУКЕН (1907)", KeySeq["J"]),
	"I", Map("ЙЦУКЕН", KeySeq["I"], "Диктор", KeySeq["["], "ЙІУКЕН (1907)", KeySeq["I"]),
	"J", Map("ЙЦУКЕН", KeySeq["J"], "Диктор", KeySeq["F"], "ЙІУКЕН (1907)", KeySeq["K"]),
	"K", Map("ЙЦУКЕН", KeySeq["K"], "Диктор", KeySeq["H"], "ЙІУКЕН (1907)", KeySeq["L"]),
	"L", Map("ЙЦУКЕН", KeySeq["L"], "Диктор", KeySeq["O"], "ЙІУКЕН (1907)", KeySeq[";"]),
	"M", Map("ЙЦУКЕН", KeySeq["M"], "Диктор", KeySeq["W"], "ЙІУКЕН (1907)", KeySeq[","]),
	"N", Map("ЙЦУКЕН", KeySeq["N"], "Диктор", KeySeq["K"], "ЙІУКЕН (1907)", KeySeq["M"]),
	"O", Map("ЙЦУКЕН", KeySeq["O"], "Диктор", KeySeq["]"], "ЙІУКЕН (1907)", KeySeq["O"]),
	"P", Map("ЙЦУКЕН", KeySeq["P"], "Диктор", KeySeq["Y"], "ЙІУКЕН (1907)", KeySeq["P"]),
	"Q", Map("ЙЦУКЕН", KeySeq["Q"], "Диктор", KeySeq["'"], "ЙІУКЕН (1907)", KeySeq["Q"]),
	"R", Map("ЙЦУКЕН", KeySeq["R"], "Диктор", KeySeq["I"], "ЙІУКЕН (1907)", KeySeq["R"]),
	"S", Map("ЙЦУКЕН", KeySeq["S"], "Диктор", KeySeq["V"], "ЙІУКЕН (1907)", KeySeq["S"]),
	"T", Map("ЙЦУКЕН", KeySeq["T"], "Диктор", KeySeq["D"], "ЙІУКЕН (1907)", KeySeq["T"]),
	"U", Map("ЙЦУКЕН", KeySeq["U"], "Диктор", KeySeq["."], "ЙІУКЕН (1907)", KeySeq["U"]),
	"V", Map("ЙЦУКЕН", KeySeq["V"], "Диктор", KeySeq["M"], "ЙІУКЕН (1907)", KeySeq["B"]),
	"W", Map("ЙЦУКЕН", KeySeq["W"], "Диктор", KeySeq["Q"], "ЙІУКЕН (1907)", KeySeq["-"]),
	"X", Map("ЙЦУКЕН", KeySeq["X"], "Диктор", KeySeq["P"], "ЙІУКЕН (1907)", KeySeq["X"]),
	"Y", Map("ЙЦУКЕН", KeySeq["Y"], "Диктор", KeySeq["J"], "ЙІУКЕН (1907)", KeySeq["Y"]),
	"Z", Map("ЙЦУКЕН", KeySeq["Z"], "Диктор", KeySeq["E"], "ЙІУКЕН (1907)", KeySeq["Z"]),
	",", Map("ЙЦУКЕН", KeySeq[","], "Диктор", KeySeq["N"], "ЙІУКЕН (1907)", KeySeq["."]),
	".", Map("ЙЦУКЕН", KeySeq["."], "Диктор", KeySeq["B"], "ЙІУКЕН (1907)", KeySeq["/"]),
	";", Map("ЙЦУКЕН", KeySeq[";"], "Диктор", KeySeq["/"], "ЙІУКЕН (1907)", KeySeq["'"]),
	"'", Map("ЙЦУКЕН", KeySeq["'"], "Диктор", KeySeq["X"], "ЙІУКЕН (1907)", KeySeq["="]),
	"[", Map("ЙЦУКЕН", KeySeq["["], "Диктор", KeySeq["C"], "ЙІУКЕН (1907)", KeySeq["["]),
	"]", Map("ЙЦУКЕН", KeySeq["]"], "Диктор", KeySeq["W"], "ЙІУКЕН (1907)", KeySeq["F"]),
	"~", Map("ЙЦУКЕН", KeySeq["~"], "Диктор", KeySeq["~"], "ЙІУКЕН (1907)", KeySeq["~"]),
	"/", Map("ЙЦУКЕН", KeySeq["/"], "Диктор", KeySeq["/"], "ЙІУКЕН (1907)", KeySeq["/"]),
	"-", Map("ЙЦУКЕН", KeySeq["-"], "Диктор", KeySeq["-"], "ЙІУКЕН (1907)", KeySeq["-"]),
	"-", Map("ЙЦУКЕН", KeySeq["-"], "Диктор", KeySeq["-"], "ЙІУКЕН (1907)", KeySeq["-"]),
	"=", Map("ЙЦУКЕН", KeySeq["="], "Диктор", KeySeq["="], "ЙІУКЕН (1907)", KeySeq["="]),
	"/", Map("ЙЦУКЕН", KeySeq["/"], "Диктор", KeySeq["\"], "ЙІУКЕН (1907)", KeySeq["]"]),
	"1", Map("ЙЦУКЕН", KeySeq["1"], "Диктор", KeySeq["1"], "ЙІУКЕН (1907)", KeySeq["1"]),
	"2", Map("ЙЦУКЕН", KeySeq["2"], "Диктор", KeySeq["2"], "ЙІУКЕН (1907)", KeySeq["2"]),
	"3", Map("ЙЦУКЕН", KeySeq["3"], "Диктор", KeySeq["3"], "ЙІУКЕН (1907)", KeySeq["3"]),
	"4", Map("ЙЦУКЕН", KeySeq["4"], "Диктор", KeySeq["4"], "ЙІУКЕН (1907)", KeySeq["4"]),
	"5", Map("ЙЦУКЕН", KeySeq["5"], "Диктор", KeySeq["5"], "ЙІУКЕН (1907)", KeySeq["5"]),
	"6", Map("ЙЦУКЕН", KeySeq["6"], "Диктор", KeySeq["6"], "ЙІУКЕН (1907)", KeySeq["6"]),
	"7", Map("ЙЦУКЕН", KeySeq["7"], "Диктор", KeySeq["7"], "ЙІУКЕН (1907)", KeySeq["7"]),
	"8", Map("ЙЦУКЕН", KeySeq["8"], "Диктор", KeySeq["8"], "ЙІУКЕН (1907)", KeySeq["8"]),
	"9", Map("ЙЦУКЕН", KeySeq["9"], "Диктор", KeySeq["9"], "ЙІУКЕН (1907)", KeySeq["9"]),
	"0", Map("ЙЦУКЕН", KeySeq["0"], "Диктор", KeySeq["0"], "ЙІУКЕН (1907)", KeySeq["0"]),
	"!", Map("ЙЦУКЕН", KeySeq["1"], "Диктор", KeySeq["T"], "ЙІУКЕН (1907)", KeySeq["1"]),
	"?", Map("ЙЦУКЕН", KeySeq["7"], "Диктор", KeySeq["R"], "ЙІУКЕН (1907)", KeySeq["7"]),
	"DotRu", Map("ЙЦУКЕН", KeySeq["/"], "Диктор", KeySeq["T"], "ЙІУКЕН (1907)", KeySeq["]"]),
	"CommaRu", Map("ЙЦУКЕН", KeySeq["/"], "Диктор", KeySeq["R"], "ЙІУКЕН (1907)", KeySeq["]"]),
	"Tab", Map("ЙЦУКЕН", KeySeq["Tab"], "Диктор", KeySeq["Tab"], "ЙІУКЕН (1907)", KeySeq["Tab"]),
)

ModifiersRules := Map(
	"I", "Modifier:ЙІУКЕН",
	"Y", "Modifier:ЙЦУКЕН",
	"D", "Modifier:Диктор",
)

GetModifiers(Modifiers*) {
	TempMap := Map()
	for modifier in Modifiers {
		ModifierType := RegExMatch(modifier, "^(.+):", &match) ? match[1] : "Modifier"
		ModifierKey := RegExReplace(modifier, "^(.+):", "")

		ModifierType := ModifiersRules.Has(ModifierType) ? ModifiersRules[ModifierType] : ModifierType
		TempMap[ModifierType] := ModifierKey
	}

	return TempMap
}

GetKeyBindings(UseKey, Combinations := "FastKeys") {
	LatinLayout := CheckQWERTY()
	CyrillicLayout := CheckYITSUKEN()

	SlotMod(SlotsKey, Slots, Mode := "+") {
		return Slots.Has(Mode SlotsKey) ? Slots[Mode SlotsKey] : Slots.Has(SlotsKey) ? Slots[SlotsKey] : ""
	}

	CheckPairs := [
		",", "Comma",
		"CommaRu", "Comma",
		".", "Dot",
		"DotRu", "Dot",
		"~", "Tilde",
		"-", "Minus",
		"=", "Equals",
		"[", "LSquareBracket",
		"]", "RSquareBracket",
		";", "Semicolon",
		"'", "Apostrophe",
		"/", "Slash",
		"\", "Backslash",
	]

	ValidateSlotPairs(SlotKey) {
		for i, pair in CheckPairs {
			if Mod(i, 2) == 1 && pair == SlotKey {
				return CheckPairs[i + 1]
			}
		}
		return SlotKey
	}

	GetBindingsArray(SlotMapping := Map(), SlotModdedMapping := Map(), Slots := Map(), SetReverseCaps := False, HotKeyMode := "", ProceedRegistryAll := False, CommonMode := False) {

		SlotKeys := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ",", ".", ";", "~", "-", "=", "[", "]", "'", "/", "\", "Space", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

		SlotMods := ["+"]
		if !CommonMode {
			SlotMods.Push("<!", "<!<+", ">!<+", "<+", ">+", "<+>+", "<^>!", "<^>!<+", "<^>!>+", "<^>!<!", "<^>!<!>+", "<^>!<!<+>+")
		}


		TempArray := []
		if IsObject(SlotMapping) && SlotMapping.Count > 0 {
			for label, value in SlotMapping {
				try {
					SlotMappingBridge(label, value)
				} catch {
					continue
				}
			}
		}

		if IsObject(SlotModdedMapping) && SlotModdedMapping.Count > 0 {
			for slotLabel, value in SlotModdedMapping {
				for moddedSlot, subValue in value {
					try {

						SlotMappingBridge(slotLabel, subValue, moddedSlot, SetReverseCaps)

					} catch {
						continue
					}
				}
			}
		}

		if IsObject(Slots) && Slots.Count > 0 {
			for slotEntry, slotValue in Slots {
				if (RegExMatch(slotEntry, "^(.*)(.)$", &match)) {
					EntryModifier := match[1]
					EntryKey := match[2]
				} else {
					EntryModifier := ""
					EntryKey := slotEntry
				}
				Found := False

				for i, pair in TempArray {
					if Mod(i, 2) == 1 {
						try {
							if pair = EntryModifier UseKey[ValidateSlotPairs(EntryKey)] {
								Found := True
								break
							}
						} catch {
							continue
						}
					}
				}
				if (!Found) {
					try {
						if EntryModifier != ""
							SlotMappingBridge(EntryKey, "", EntryModifier)
					} catch {
						continue
					}
				}
			}
		}

		if ProceedRegistryAll {
			for label in SlotKeys {
				for modifier in SlotMods {

					Found := False
					for i, pair in TempArray {
						if Mod(i, 2) == 1 {
							try {
								if pair = modifier UseKey[ValidateSlotPairs(label)] {
									Found := True
									break
								}
							} catch {
								continue
							}
						}
					}
					if (!Found) {
						try {
							if modifier != ""
								SlotMappingBridge(label, "", modifier)
						} catch {
							continue
						}
					}
				}
			}
		}

		SlotMappingBridge(SlotLabel, SlotValue, SlotModifier := "", ReverseCaps := False) {
			HotKeyVariant := HotKeyMode != "" ? HotKeyMode : RegExMatch(SlotModifier, "^(.+):", &match) ? match[1] : ""
			SlotModifier := RegExReplace(SlotModifier, "^(.+):", "")

			ValidateLabel := ValidateSlotPairs(SlotLabel)
			Label := SlotModifier != "" ? SlotModifier UseKey[ValidateLabel] : UseKey[ValidateLabel]
			Slot := SlotModifier != "" ? SlotMod(SlotLabel, Slots, SlotModifier) : Slots.Has(SlotLabel) ? Slots[SlotLabel] : ""


			if HotKeyVariant = "Flat" {
				if IsObject(SlotValue) {
					TempArray.Push(Label, (K) => CapsSeparatedKey(K, SlotValue[1], SlotValue[2]))
				} else {
					TempArray.Push(Label, (K) => HandleFastKey(K, SlotValue))
				}
			} else if HotKeyVariant = "Caps" {
				if IsObject(SlotValue) {
					TempArray.Push(Label, (K) => CapsSeparatedKey(K, SlotValue[1], SlotValue[2]))
				} else {
					TempArray.Push(Label, (K) => HandleFastKey(K, SlotValue))
				}
			} else {
				TempArray.Push(Label, (K) => LangSeparatedKey(K, SlotValue, Slot, True, ReverseCaps))
			}
		}

		return TempArray
	}

	GetLayoutImprovedCyrillic(CyrillicSlots) {
		TempMap := Map()
		LetterID := LatinLayout = "QWERTY" ? 1 : LatinLayout = "Dvorak" ? 2 : LatinLayout = "Colemak" ? 3 : 1

		for i, pair in CyrillicSlots {
			if Mod(i, 2) = 1 {
				Characters := pair
				InsertingSlot := CyrillicSlots[i + 1][CyrillicLayout][LetterID]
				Modifier := ""

				if CyrillicLayout = "Диктор" && CyrillicSlots[i + 1].Has("Modifier:Диктор") {
					Modifier := CyrillicSlots[i + 1]["Modifier:Диктор"]
				} else if CyrillicLayout = "ЙЦУКЕН" && CyrillicSlots[i + 1].Has("Modifier:ЙЦУКЕН") {
					Modifier := CyrillicSlots[i + 1]["Modifier:ЙЦУКЕН"]
				} else if CyrillicLayout = "ЙІУКЕН (1907)" && CyrillicSlots[i + 1].Has("Modifier:ЙІУКЕН") {
					Modifier := CyrillicSlots[i + 1]["Modifier:ЙІУКЕН"]
				} else {
					Modifier := CyrillicSlots[i + 1].Has("Modifier") ? CyrillicSlots[i + 1]["Modifier"] : ""
				}

				MapPush(TempMap, Modifier InsertingSlot, Characters)
			}
		}

		return TempMap
	}


	if Combinations = "FastKeys" {
		SlotModdedDiacritics := Map(
			"A", Map("Flat:<^<!", "acute", "Flat:<^<!<+", "acute_double", "Flat:<^<!>+", "acute_below"),
			"B", Map("Flat:<^<!", "breve", "Flat:<^<!<+", "breve_inverted", "Flat:<^<!>+", "breve_below", "Flat:<^<!<+>+", "breve_inverted_below"),
			"C", Map("Flat:<^<!", "circumflex", "Flat:<^<!<+", "caron", "Flat:<^<!>+", "cedilla", "Flat:<^<!<+>+", "circumflex_below"),
			"D", Map("Flat:<^<!", "dot_above", "Flat:<^<!<+", "diaeresis", "Flat:<^<!>+", "dot_below", "Flat:<^<!<+>+", "diaeresis_below"),
			"F", Map("Flat:<^<!", "fermata"),
			"G", Map("Flat:<^<!", "grave", "Flat:<^<!<+", "grave_double", "<^<!>+", "cyr_com_dasia_pneumata", "<^<!<+>+", "cyr_com_psili_pneumata"),
			"H", Map("Flat:<^<!", "hook_above", "Flat:<^<!<+", "horn", "Flat:<^<!>+", "palatal_hook_below", "Flat:<^<!<+>+", "retroflex_hook_below"),
			"M", Map("Flat:<^<!", "macron", "Flat:<^<!<+", "macron_below"),
			"N", Map("Flat:<^<!", "cyr_com_titlo"),
			"O", Map("Flat:<^<!", "ogonek", "Flat:<^<!<+", "ogonek_above"),
			"R", Map("Flat:<^<!", "ring_above", "Flat:<^<!<+", "ring_below"),
			"S", Map("Flat:<^<!", "stroke_short", "Flat:<^<!<+", "stroke_long"),
			"T", Map("Flat:<^<!", "tilde", "Flat:<^<!<+", "tilde_overlay"),
			"V", Map("Flat:<^<!", "line_vertical", "Flat:<^<!<+", "line_vertical_double"),
			"X", Map("Flat:<^<!", "x_above", "Flat:<^<!<+", "x_below"),
			"Z", Map("Flat:<^<!", "zigzag_above"),
			"/", Map("Flat:<^<!", "solidus_short", "Flat:<^<!<+", "solidus_long"),
			",", Map("Flat:<^<!", "comma_above", "Flat:<^<!<+", "comma_below"),
			".", Map("Flat:<^<!", "dot_above", "Flat:<^<!<+", "diaeresis"),
		)

		QuotesSlots := GetLayoutImprovedCyrillic([
			"france_left", MapMerge(GetModifiers("<^>!"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "," : "CommaRu"]),
			"france_right", MapMerge(GetModifiers("<^>!"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "." : "DotRu"]),
			"quote_right_double_ghost_ru", MapMerge(GetModifiers("<^>!<+"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "." : "DotRu"]),
			"france_single_left", MapMerge(GetModifiers("<^>!<!<+"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "," : "CommaRu"]),
			"france_single_right", MapMerge(GetModifiers("<^>!<!<+"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "." : "DotRu"]),
			"quote_low_9_single", MapMerge(GetModifiers("<^>!<+>+"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "," : "CommaRu"]),
			"quote_low_9_double", MapMerge(GetModifiers("<^>!<+"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "," : "CommaRu"]),
			"quote_low_9_double", MapMerge(GetModifiers("<^>!>+"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "," : "CommaRu"]),
			"quote_low_9_double_reversed", MapMerge(GetModifiers("<^>!>+"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "." : "DotRu"]),
			"quote_left_double", MapMerge(GetModifiers("<^>!<!"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "," : "CommaRu"]),
			"quote_right_double", MapMerge(GetModifiers("<^>!<!"), KeySeqSlot[CyrillicLayout = "ЙЦУКЕН" ? "." : "DotRu"]),
		])
		SlotModdedQuotes := Map(
			",", Map("<^>!", "quote_left_double", "<^>!<+", "quote_left_single", "<^>!>+", "quote_low_9_double", "<^>!<+>+", "quote_low_9_single", "<^>!<!", "france_left", "<^>!<!<+", "france_single_left"),
			".", Map("<^>!", "quote_right_double", "<^>!<+", "quote_right_single", "<^>!>+", "quote_low_9_double_reversed", "<^>!<!", "france_right", "<^>!<!<+", "france_single_right"),
			"~", Map("Flat:<^>!>+", "quote_right_single"),
		)
		DashesSlots := GetLayoutImprovedCyrillic([
			"softhyphen", MapMerge(GetModifiers("<^<!"), KeySeqSlot["-"]),
			"minus", MapMerge(GetModifiers("<^<!<+"), KeySeqSlot["-"]),
			"emdash", MapMerge(GetModifiers("<^>!"), KeySeqSlot["-"]),
			"endash", MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["-"]),
			["two_emdash", "three_emdash"], MapMerge(GetModifiers("<!"), KeySeqSlot["-"]),
			"hyphen", MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["-"]),
			"no_break_hyphen", MapMerge(GetModifiers("<^>!<!<+"), KeySeqSlot["-"]),
			"figure_dash", MapMerge(GetModifiers("<^>!<!>+"), KeySeqSlot["-"]),
		])
		SlotModdedDashes := Map(
			"-", Map("<^<!", "softhyphen", "<^<!<+", "minus", "<^>!", "emdash", "<^>!<+", "endash", "<!", ["two_emdash", "three_emdash"], "<^>!<!", "hyphen", "<^>!<!<+", "no_break_hyphen", "<^>!<!>+", "figure_dash"),
		)
		SpacesSlots := GetLayoutImprovedCyrillic([])
		SlotModdedSpaces := Map(
			"Tab", Map("Flat:<^>!", "zero_width_joiner", "Flat:<^>!>+", "zero_width_non_joiner", "Flat:<^>!<+", "word_joiner"),
			"Space", Map(
				"Flat:<^>!", "no_break_space",
				"Flat:<^>!>+", "emsp",
				"Flat:<^>!<+", "ensp",
				"Flat:<^>!<+>+", "figure_space",
				"Flat:<^>!<!", "thinspace",
				"Flat:<^>!<!<+", "hairspace",
				"Flat:<^>!<!>+", "punctuation_space",
				;"Flat:<^>!<!<+>+", "zero_width_space",
				"Flat:<!", "emsp13",
				"Flat:<^>!>^", "zero_width_space",
				"Flat:<^<!", "zero_width_no_break_space",
				;"Flat:<+", "emsp14",
				"Flat:>+", "emsp16",
				"Flat:<+>+", "narrow_no_break_space",
			),
		)
		SpecialsSlots := GetLayoutImprovedCyrillic([
			"noequals", MapMerge(GetModifiers("<^>!"), KeySeqSlot["="]),
			"almostequals", MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["="]),
			"plusminus", MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["="]),
			"ellipsis", MapMerge(GetModifiers("<^>!"), KeySeqSlot["DotRu"]),
			"two_dot_punctuation", MapMerge(GetModifiers("<!"), KeySeqSlot["DotRu"]),
			"fraction_slash", MapMerge(GetModifiers("<^>!>+"), KeySeqSlot["DotRu"]),
			"tricolon", MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["DotRu"]),
			"quartocolon", MapMerge(GetModifiers("<^>!<+>+"), KeySeqSlot["DotRu"]),
			"hyphenation_point", MapMerge(GetModifiers("<^>!+"), KeySeqSlot["-"]),
		])
		SlotModdedSpecials := Map(
			"D", Map("Flat:<!", "degree"),
			"S", Map(),
			"1", Map("Flat:<!", "section", "Flat:<^>!", "inverted_exclamation", "Flat:<^>!<+", "double_exclamation_question", "Flat:<^>!>+", "double_exclamation", "Caps:>+", ["interrobang_inverted", "interrobang"]),
			"2", Map("Caps:<^>!", ["registered", "copyright"], "Caps:<^>!<+", ["servicemark", "trademark"], "Flat:<^>!>+", "sound_recording_copyright"),
			"3", Map("Caps:<^>!", ["prime_reversed_single", "prime_single"], "Caps:<^>!>+", ["prime_reversed_double", "prime_double"], "Caps:<^>!<+", ["prime_reversed_triple", "prime_triple"], "Flat:<^>!<+>+", "prime_quadruple"),
			;"3", Map("Flat:<^>!", "prime_single", "Flat:<^>!>+", "prime_double", "Flat:<^>!<+", "prime_triple", "Flat:<^>!<+>+", "prime_quadruple", "Flat:<!", "prime_reversed_single", "Flat:<!>+", "prime_reversed_double", "Flat:<!<+", "prime_reversed_triple"),
			"4", Map("Flat:<^>!", "division"),
			"5", Map("Flat:<^>!", "permille", "Flat:<^>!<+", "pertenthousand"),
			"7", Map("Flat:<^>!", "inverted_question", "Flat:<^>!>+", "double_question", "Flat:<^>!<+", "double_question_exclamation", "Flat:<^>!<!", "reversed_question"),
			"8", Map("Flat:<^>!", "multiplication"),
			"9", Map("Flat:<^>!", "bracket_angle_math_left", "Flat:<!", "bracket_square_left", "Flat:<!<+", "bracket_curly_left"),
			"0", Map("Flat:<^>!", "bracket_angle_math_right", "Flat:<^>!<!", "infinity", "Flat:<!", "bracket_square_right", "Flat:<!<+", "bracket_curly_right"),
			"~", Map("Flat:<^>!", "bullet", "Flat:<^>!<!", "bullet_hyphen", "Flat:<^>!<+", "interpunct", "Flat:<^>!<!<+", "bullet_triangle", "Flat:<^>!<!>+", "bullet_white", "Flat:>+", "tilde_reversed"),
			"=", Map("<^>!", "noequals", "<^>!<!", "almostequals", "<^>!<+", "plusminus"),
			"-", Map("<^>!>+", "hyphenation_point"),
			"/", Map("<^>!", "ellipsis", "<^>!<+", "tricolon", "<^>!<+>+", "quartocolon", "<!", "two_dot_punctuation", "<^>!>+", "fraction_slash"),
		)
		LettersSlots := GetLayoutImprovedCyrillic([
			["cyr_c_let_fita", "cyr_s_let_fita"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["A"]),
			["cyr_c_let_i_decimal", "cyr_s_let_i_decimal"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["B"]),
			["cyr_c_let_izhitsa", "cyr_s_let_izhitsa"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["B"]),
			["cyr_c_let_i_diaeresis", "cyr_s_let_i_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["B"]),
			["cyr_c_let_i_macron", "cyr_s_let_i_macron"], MapMerge(GetModifiers("<^>!>+"), KeySeqSlot["B"]),
			["cyr_c_let_iota", "cyr_s_let_iota"], MapMerge(GetModifiers("<^>!<!<+>+"), KeySeqSlot["B"]),
			["cyr_c_let_s_descender", "cyr_s_let_s_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["C"]),
			["cyr_c_let_yery_diaeresis", "cyr_s_let_yery_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["S"]),
			["cyr_c_let_yeru_back_yer", "cyr_s_let_yeru_back_yer"], MapMerge(GetModifiers("<^>!>+"), KeySeqSlot["S"]),
			["cyr_c_let_yn", "cyr_s_let_yn"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["S"]),
			["cyr_c_let_u_breve", "cyr_s_let_u_breve"], MapMerge(GetModifiers("<!"), KeySeqSlot["E"]),
			["cyr_c_let_yus_big", "cyr_s_let_yus_big"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["E"]),
			["cyr_c_let_u_diaeresis", "cyr_s_let_u_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["E"]),
			["cyr_c_let_u_macron", "cyr_s_let_u_macron"], MapMerge(GetModifiers("<^>!>+"), KeySeqSlot["E"]),
			["cyr_c_let_uk_monograph", "cyr_s_let_uk_monograph"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["E"]),
			["cyr_c_let_a_breve", "cyr_s_let_a_breve"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["F"]),
			["cyr_c_let_a_diaeresis", "cyr_s_let_a_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["F"]),
			["cyr_c_let_psi", "cyr_s_let_psi"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["G"]),
			["cyr_c_let_p_descender", "cyr_s_let_p_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["G"]),
			["cyr_c_let_omega", "cyr_s_let_omega"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["J"]),
			["cyr_c_let_o_diaeresis", "cyr_s_let_o_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["J"]),
			["cyr_c_let_semiyeri", "cyr_s_let_semiyeri"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["M"]),
			["cyr_c_let_tje", "cyr_s_let_tje"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["N"]),
			["cyr_c_let_t_descender", "cyr_s_let_t_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["N"]),
			["cyr_c_let_lje", "cyr_s_let_lje"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["K"]),
			["cyr_c_let_l_descender", "cyr_s_let_l_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["K"]),
			["cyr_c_let_l_tail", "cyr_s_let_l_tail"], MapMerge(GetModifiers("<^>!<!>+"), KeySeqSlot["K"]),
			["cyr_c_let_palochka", "cyr_s_let_palochka"], MapMerge(GetModifiers("<^>!<!<+"), KeySeqSlot["K"]),
			["cyr_c_let_yat", "cyr_s_let_yat"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["T"]),
			["cyr_c_let_e_breve", "cyr_s_let_e_breve"], MapMerge(GetModifiers("<!"), KeySeqSlot["T"]),
			["cyr_c_let_e_grave", "cyr_s_let_e_grave"], MapMerge(GetModifiers(">+"), KeySeqSlot["T"]),
			["cyr_c_let_g_acute", "cyr_s_let_g_acute"], MapMerge(GetModifiers("<!"), KeySeqSlot["U"]),
			["cyr_c_let_g_upturn", "cyr_s_let_g_upturn"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["U"]),
			["cyr_c_let_g_stroke_short", "cyr_s_let_g_stroke_short"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["U"]),
			["cyr_c_let_g_descender", "cyr_s_let_g_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["U"]),
			["cyr_c_let_m_tail", "cyr_s_let_m_tail"], MapMerge(GetModifiers("<^>!<!>+"), KeySeqSlot["V"]),
			["cyr_c_let_dze", "cyr_s_let_dze"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["P"]),
			["cyr_c_let_zemlya", "cyr_s_let_zemlya"], MapMerge(GetModifiers("<^>!>+"), KeySeqSlot["P"]),
			["cyr_c_let_z_diaeresis", "cyr_s_let_z_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["P"]),
			["cyr_c_let_z_descender", "cyr_s_let_z_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["P"]),
			["cyr_c_let_yi", "cyr_s_let_yi"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["Q"]),
			["cyr_c_let_j", "cyr_s_let_j"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["Q"]),
			["cyr_c_let_i_breve_tail", "cyr_s_let_i_breve_tail"], MapMerge(GetModifiers("<^>!<!>+"), KeySeqSlot["Q"]),
			["cyr_c_let_ksi", "cyr_s_let_ksi"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["R"]),
			["cyr_c_let_k_descender", "cyr_s_let_k_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["R"]),
			["cyr_c_let_k_acute", "cyr_s_let_k_acute"], MapMerge(GetModifiers("<!"), KeySeqSlot["R"]),
			["cyr_c_let_yus_little", "cyr_s_let_yus_little"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["Z"]),
			["cyr_c_let_a_iotified", "cyr_s_let_a_iotified"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["Z"]),
			["cyr_c_let_tshe", "cyr_s_let_tshe"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["X"]),
			["cyr_c_let_ch_diaeresis", "cyr_s_let_ch_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["X"]),
			["cyr_c_let_ch_descender", "cyr_s_let_ch_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["X"]),
			["cyr_c_let_djerv", "cyr_s_let_djerv"], MapMerge(GetModifiers("<^>!<!<+"), KeySeqSlot["X"]),
			["cyr_c_let_nje", "cyr_s_let_nje"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["Y"]),
			["cyr_c_let_n_descender", "cyr_s_let_n_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["Y"]),
			["cyr_c_let_n_tail", "cyr_s_let_n_tail"], MapMerge(GetModifiers("<^>!<!>+"), KeySeqSlot["Y"]),
			["cyr_c_let_dzhe", "cyr_s_let_dzhe"], MapMerge(GetModifiers("<^>!"), KeySeqSlot[";"]),
			["cyr_c_let_zhe_breve", "cyr_s_let_zhe_breve"], MapMerge(GetModifiers("<!"), KeySeqSlot[";"]),
			["cyr_c_let_zhe_diaeresis", "cyr_s_let_zhe_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot[";"]),
			["cyr_c_let_zhe_descender", "cyr_s_let_zhe_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot[";"]),
			["cyr_c_let_dje", "cyr_s_let_dje"], MapMerge(GetModifiers("<^>!>+"), KeySeqSlot[";"]),
			["cyr_c_let_ukr_e", "cyr_s_let_ukr_e"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["'"]),
			["cyr_c_let_schwa", "cyr_s_let_schwa"], MapMerge(GetModifiers("<^>!>+"), KeySeqSlot["'"]),
			["cyr_c_let_ye_diaeresis", "cyr_s_let_ye_diaeresis"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["'"]),
			["cyr_c_let_schwa_diaeresis", "cyr_s_let_schwa_diaeresis"], MapMerge(GetModifiers("<^>!<+>+"), KeySeqSlot["'"]),
			["cyr_c_let_shha", "cyr_s_let_shha"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["["]),
			["cyr_c_let_h_descender", "cyr_s_let_h_descender"], MapMerge(GetModifiers("<^>!<!"), KeySeqSlot["["]),
			["cyr_c_let_u_straight", "cyr_s_let_u_straight"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["]"]),
			["cyr_c_let_u_straight_stroke_short", "cyr_s_let_u_straight_stroke_short"], MapMerge(GetModifiers("<^>!>+"), KeySeqSlot["]"]),
		])
		SlotModdedLetters := Map(
			"A", Map("<!", ["lat_c_let_a__acute", "lat_s_let_a__acute"],
				"<^>!", ["lat_c_let_a__breve", "lat_s_let_a__breve"],
				"<^>!<!", ["lat_c_let_a__circumflex", "lat_s_let_a__circumflex"],
				"<^>!<!<+", ["lat_c_let_a__ring_above", "lat_s_let_a__ring_above"],
				"<^>!<!>+", ["lat_c_let_a__ogonek", "lat_s_let_a__ogonek"],
				"<^>!>+", ["lat_c_let_a__macron", "lat_s_let_a__macron"],
				"<^>!<+", ["lat_c_let_a__diaeresis", "lat_s_let_a__diaeresis"],
				"<^>!<+>+", ["lat_c_let_a__tilde", "lat_s_let_a__tilde"],
				">+", ["lat_c_let_a__grave", "lat_s_let_a__grave"],
				"<+>+", ["lat_c_let_a__grave_double", "lat_s_let_a__grave_double"]),
			"B", Map(
				"<^>!", ["lat_c_let_b__dot_above", "lat_s_let_b__dot_above"],
				"<^>!<!", ["lat_c_let_b__dot_below", "lat_s_let_b__dot_below"],
				"<^>!<!<+", ["lat_c_let_b__flourish", "lat_s_let_b_flourish"],
				"<^>!<+", ["lat_c_let_b__stroke_short", "lat_s_let_b_stroke_short"],
				"<^>!>+", ["lat_c_let_b__common_hook", "lat_s_let_b__common_hook"]),
			"C", Map("<!", ["lat_c_let_c__acute", "lat_s_let_c__acute"],
				"<^>!", ["lat_c_let_c__dot_above", "lat_s_let_c__dot_above"],
				"<^>!<!", ["lat_c_let_c__circumflex", "lat_s_let_c__circumflex"],
				"<^>!<!<+", ["lat_c_let_c__caron", "lat_s_let_c__caron"],
				"<^>!<!>+", ["lat_c_let_c__cedilla", "lat_s_let_c__cedilla"],
				"Flat:>+", "celsius"),
			"D", Map(
				"<^>!", ["lat_c_let_d_eth", "lat_s_let_d_eth"],
				"<^>!<!", ["lat_c_let_d__stroke_short", "lat_s_let_d__stroke_short"],
				"<^>!<!<+", ["lat_c_let_d__caron", "lat_s_let_d__caron"],
				"<^>!<!>+", ["lat_c_let_d__cedilla", "lat_s_let_d__cedilla"],
				"<^>!<+>+", ["lat_c_let_d__circumflex_below", "lat_s_let_d__circumflex_below"]),
			"E", Map("<!", ["lat_c_let_e__acute", "lat_s_let_e__acute"],
				"<^>!", ["lat_c_let_schwa", "lat_s_let_schwa"],
				"<^>!<!", ["lat_c_let_e__circumflex", "lat_s_let_e__circumflex"],
				"<^>!<!<+", ["lat_c_let_e__caron", "lat_s_let_e__caron"],
				"<^>!<!>+", ["lat_c_let_e__ogonek", "lat_s_let_e__ogonek"],
				"<^>!>+", ["lat_c_let_e__macron", "lat_s_let_e__macron"],
				"<^>!<+", ["lat_c_let_e__diaeresis", "lat_s_let_e__diaeresis"],
				"<^>!<+>+", ["lat_c_let_e__tilde", "lat_s_let_e__tilde"],
				">+", ["lat_c_let_e__grave", "lat_s_let_e__grave"],
				"<+>+", ["lat_c_let_e__grave_double", "lat_s_let_e__grave_double"]),
			"F", Map(
				"<^>!", ["lat_c_let_f__dot_above", "lat_s_let_f__dot_above"],
				"Flat:>+", "fahrenheit"),
			"G", Map("<!", ["lat_c_let_g_acute", "lat_s_let_g_acute"],
				"<^>!", ["lat_c_let_g_breve", "lat_s_let_g_breve"],
				"<^>!<!", ["lat_c_let_g_circumflex", "lat_s_let_g_circumflex"],
				"<^>!<!<+", ["lat_c_let_g_caron", "lat_s_let_g_caron"],
				"<^>!<!>+", ["lat_c_let_g_cedilla", "lat_s_let_g_cedilla"],
				"<^>!<+", ["lat_c_let_g_insular", "lat_s_let_g_insular"],
				"<^>!>+", ["lat_c_let_g_macron", "lat_s_let_g_macron"],
				"<^>!<+>+", ["lat_c_let_gamma", "lat_s_let_gamma"],
				">+", ["lat_c_let_g_dot_above", "lat_s_let_g_dot_above"]),
			"H", Map("<!", ["lat_c_let_h_hwair", "lat_s_let_h_hwair"],
				"<^>!", ["lat_c_let_h_stroke_short", "lat_s_let_h_stroke_short"],
				"<^>!<!", ["lat_c_let_h_circumflex", "lat_s_let_h_circumflex"],
				"<^>!<!<+", ["lat_c_let_h_caron", "lat_s_let_h_caron"],
				"<^>!<!>+", ["lat_c_let_h_cedilla", "lat_s_let_h_cedilla"],
				"<^>!<+", ["lat_c_let_h_diaeresis", "lat_s_let_h_diaeresis"]),
			"I", Map("<!", ["lat_c_let_i_acute", "lat_s_let_i_acute"],
				"<^>!", ["lat_c_let_i_breve", "lat_s_let_i_breve"],
				"<^>!<!", ["lat_c_let_i_circumflex", "lat_s_let_i_circumflex"],
				"<^>!<!<+", ["lat_c_let_i_caron", "lat_s_let_i_caron"],
				"<^>!<!>+", ["lat_c_let_i_ogonek", "lat_s_let_i_ogonek"],
				"<^>!>+", ["lat_c_let_i_macron", "lat_s_let_i_macron"],
				"<^>!<+", ["lat_c_let_i_diaeresis", "lat_s_let_i_diaeresis"],
				"<^>!<+>+", ["lat_c_let_i_tilde", "lat_s_let_i_tilde"],
				">+", ["lat_c_let_i_grave", "lat_s_let_i_grave"],
				"<+>+", ["lat_c_let_i_grave_double", "lat_s_let_i_grave_double"],
				"<^>!<!<+>+", ["lat_c_let_i_dot_above", "lat_s_let_i_dotless"]),
			"J", Map(
				"<^>!", ["lat_c_let_j_stroke_short", "lat_s_let_j_stroke_short"],
				"<^>!>+", ["lat_c_let_j_yogh", "lat_s_let_j_yogh"],
				"<^>!<!", ["lat_c_let_j_circumflex", "lat_s_let_j_circumflex"],
				"<^>!<!<+", ["lat_c_let_j", "lat_s_let_j_caron"],
			),
			"K", Map("<!", ["lat_c_let_k_acute", "lat_s_let_k_acute"],
				"<^>!<!", ["lat_c_let_k_dot_below", "lat_s_let_k_dot_below"],
				"<^>!<!<+", ["lat_c_let_k_caron", "lat_s_let_k_caron"],
				"<^>!<!>+", ["lat_c_let_k_cedilla", "lat_s_let_k_cedilla"],
				"<^>!<+", ["lat_c_let_k_cuatrillo", "lat_s_let_k_cuatrillo"],
				"Flat:>+", "kelvin"
			),
			"L", Map("<!", ["lat_c_let_l_acute", "lat_s_let_l_acute"],
				"<^>!", ["lat_c_let_l_solidus_short", "lat_s_let_l_solidus_short"],
				"<^>!<!<+", ["lat_c_let_l_caron", "lat_s_let_l_caron"],
				"<^>!<!>+", ["lat_c_let_l_cedilla", "lat_s_let_l_cedilla"],
				"<^>!<+>+", ["lat_c_let_l_circumflex_below", "lat_s_let_l_circumflex_below"]),
			"M", Map("<!", ["lat_c_let_m_acute", "lat_s_let_m_acute"],
				"<^>!", ["lat_c_let_m_dot_above", "lat_s_let_m_dot_above"],
				"<^>!<!", ["lat_c_let_m_dot_below", "lat_s_let_m_dot_below"],
				"<^>!>+", ["lat_c_let_m_common_hook", "lat_s_let_m_common_hook"]),
			"N", Map("<!", ["lat_c_let_n_acute", "lat_s_let_n_acute"],
				"<^>!", ["lat_c_let_n_tilde", "lat_s_let_n_tilde"],
				"<^>!<!", ["lat_c_let_n_dot_below", "lat_s_let_n_dot_below"],
				"<^>!<!<+", ["lat_c_let_n_caron", "lat_s_let_n_caron"],
				"<^>!<!>+", ["lat_c_let_n_cedilla", "lat_s_let_n_cedilla"],
				"<^>!>+", ["lat_c_let_n_common_hook", "lat_s_let_n_common_hook"],
				"<^>!<+", ["let_c_let_n_descender", "let_s_let_n_descender"],
				"<^>!<+>+", ["lat_c_let_n_dot_above", "lat_s_let_n_dot_above"],
				">+", ["lat_c_let_n_grave", "lat_s_let_n_grave"]),
			"O", Map("<!", ["lat_c_let_o_acute", "lat_s_let_o_acute"],
				"<^>!", ["lat_c_let_o_solidus_long", "lat_s_let_o_solidus_long"],
				"<^>!<!", ["lat_c_let_o_circumflex", "lat_s_let_o_circumflex"],
				"<^>!<!<+", ["lat_c_let_o_caron", "lat_s_let_o_caron"],
				"<^>!<!>+", ["lat_c_let_o_ogonek", "lat_s_let_o_ogonek"],
				"<^>!>+", ["lat_c_let_o_macron", "lat_s_let_o_macron"],
				"<^>!<+", ["lat_c_let_o_diaeresis", "lat_s_let_o_diaeresis"],
				"<^>!<+>+", ["lat_c_let_o_tilde", "lat_s_let_o_tilde"],
				">+", ["lat_c_let_o_grave", "lat_s_let_o_grave"],
				"<+>+", ["lat_c_let_o_grave_double", "lat_s_let_o_grave_double"],
				"<^>!<!<+>+", ["lat_c_let_o_acute_double", "lat_s_let_o_acute_double"]),
			"P", Map("<!", ["lat_c_let_p_acute", "lat_s_let_p_acute"],
				"<^>!", ["lat_c_let_p_dot_above", "lat_s_let_p_dot_above"],
				"<^>!<!", ["lat_c_let_p_squirrel_tail", "lat_s_let_p_squirrel_tail"],
				"<^>!<!<+", ["lat_c_let_p_flourish", "lat_s_let_p_flourish"],
				"<^>!<+", ["lat_c_let_p_stroke_short", "lat_s_let_p_stroke_short"],
				"<^>!>+", ["lat_c_let_p_common_hook", "lat_s_let_p_common_hook"]),
			"Q", Map(
				"<^>!<+", ["lat_c_let_q_tresillo", "lat_s_let_q_tresillo"],
				"<^>!>+", ["lat_c_let_q_common_hook", "lat_s_let_q_common_hook"]),
			"R", Map("<!", ["lat_c_let_r_acute", "lat_s_let_r_acute"],
				"<^>!", ["lat_c_let_r_dot_above", "lat_s_let_r_dot_above"],
				"<^>!<!", ["lat_c_let_r_dot_below", "lat_s_let_r_dot_below"],
				"<^>!<!<+", ["lat_c_let_r_caron", "lat_s_let_r_caron"],
				"<^>!<!>+", ["lat_c_let_r_cedilla", "lat_s_let_r_cedilla"],
				"<^>!<+", ["lat_c_let_yr", "lat_s_let_yr"],
				"<^>!>+", ["lat_c_let_r_rotunda", "lat_s_let_r_rotunda"],
				"<+>+", ["lat_c_let_r_grave_double", "lat_s_let_r_grave_double"]),
			"S", Map("<!", ["lat_c_let_s_acute", "lat_s_let_s_acute"],
				"<^>!", ["lat_c_let_s_comma_below", "lat_s_let_s_comma_below"],
				"<^>!<!", ["lat_c_let_s_circumflex", "lat_s_let_s_circumflex"],
				"<^>!<!<+", ["lat_c_let_s_caron", "lat_s_let_s_caron"],
				"<^>!<!>+", ["lat_c_let_s_cedilla", "lat_s_let_s_cedilla"],
				"<^>!>+", "lat_s_let_s_long",
				"<^>!<+>+", ["lat_c_let_s_sigma", "lat_s_let_s_sigma"],
				"<^>!<+", ["lat_c_lig_s_eszett", "lat_s_lig_s_eszett"]),
			"T", Map(
				"<^>!", ["lat_c_let_t_comma_below", "lat_s_let_t_comma_below"],
				"<^>!<!", ["lat_c_let_t_dot_below", "lat_s_let_t_dot_below"],
				"<^>!<!<+", ["lat_c_let_t_caron", "lat_s_let_t_caron"],
				"<^>!<!>+", ["lat_c_let_t_cedilla", "lat_s_let_t_cedilla"],
				"<^>!>+", ["lat_c_let_t_thorn", "lat_s_let_t_thorn"],
				"<^>!<+", ["lat_c_let_t_dot_above", "lat_s_let_t_dot_above"],
				"<^>!<+>+", ["lat_c_let_et_tironian", "lat_s_let_et_tironian"]),
			"U", Map("<!", ["lat_c_let_u_acute", "lat_s_let_u_acute"],
				"<^>!", ["lat_c_let_u_breve", "lat_s_let_u_breve"],
				"<^>!<!", ["lat_c_let_u_circumflex", "lat_s_let_u_circumflex"],
				"<^>!<!<+", ["lat_c_let_u_ring_above", "lat_s_let_u_ring_above"],
				"<^>!<!>+", ["lat_c_let_u_ogonek", "lat_s_let_u_ogonek"],
				"<^>!>+", ["lat_c_let_u_macron", "lat_s_let_u_macron"],
				"<^>!<+", ["lat_c_let_u_diaeresis", "lat_s_let_u_diaeresis"],
				"<^>!<+>+", ["lat_c_let_u_tilde", "lat_s_let_u_tilde"],
				">+", ["lat_c_let_u_grave", "lat_s_let_u_grave"],
				"<+>+", ["lat_c_let_u_grave_double", "lat_s_let_u_grave_double"],
				"<^>!<!<+>+", ["lat_c_let_u_acute_double", "lat_s_let_u_acute_double"]),
			"V", Map(
				"<^>!", ["lat_c_let_v_solidus_long", "lat_s_let_v_solidus_long"],
				"<^>!<!", ["lat_c_let_v_dot_below", "lat_s_let_v_dot_below"],
				"<^>!<+", ["lat_c_let_v_middle_welsh", "lat_s_let_v_middle_welsh"],
				"<^>!>+", ["lat_c_let_vend", "lat_s_let_vend"],
				"<^>!<+>+", ["lat_c_let_v_tilde", "lat_s_let_v_tilde"]),
			"W", Map("<!", ["lat_c_let_w_acute", "lat_s_let_w_acute"],
				"<^>!", ["lat_c_let_w_dot_above", "lat_s_let_w_dot_above"],
				"<^>!<!", ["lat_c_let_w_circumflex", "lat_s_let_w_circumflex"],
				"<^>!<!<+", ["lat_c_let_w_dot_below", "lat_s_let_w_dot_below"],
				"<^>!<+", ["lat_c_let_w_diaeresis", "lat_s_let_w_diaeresis"],
				"<^>!>+", ["lat_c_let_w_wynn", "lat_s_let_w_wynn"],
				"<^>!<!>+", ["lat_c_let_w_anglicana", "lat_s_let_w_anglicana"],
				">+", ["lat_c_let_w_grave", "lat_s_let_w_grave"]),
			"X", Map(
				"<^>!", ["lat_c_let_x_dot_above", "lat_s_let_x_dot_above"],
				"<^>!<+", ["lat_c_let_x_diaeresis", "lat_s_let_x_diaeresis"]),
			"Y", Map("<!", ["lat_c_let_y_acute", "lat_s_let_y_acute"],
				"<^>!", ["lat_c_let_y_dot_above", "lat_s_let_y_dot_above"],
				"<^>!<!", ["lat_c_let_y_circumflex", "lat_s_let_y_circumflex"],
				"<^>!<!<+", ["lat_c_let_y_stroke_short", "lat_s_let_y_stroke_short"],
				"<^>!<!>+", ["lat_c_let_y_loop", "lat_s_let_y_loop"],
				"<^>!>+", ["lat_c_let_y_macron", "lat_s_let_y_macron"],
				"<^>!<+", ["lat_c_let_y_diaeresis", "lat_s_let_y_diaeresis"],
				"<^>!<+>+", ["lat_c_let_y_tilde", "lat_s_let_y_tilde"],
				">+", ["lat_c_let_y_grave", "lat_s_let_y_grave"]),
			"Z", Map("<!", ["lat_c_let_z_acute", "lat_s_let_z_acute"],
				"<^>!", ["lat_c_let_z_dot_above", "lat_s_let_z_dot_above"],
				"<^>!<!", ["lat_c_let_z_circumflex", "lat_s_let_z_circumflex"],
				"<^>!<!<+", ["lat_c_let_z_caron", "lat_s_let_z_caron"],
				"<^>!>+", ["lat_c_let_z_ezh", "lat_s_let_z_ezh"],
				"<^>!<+", ["lat_c_let_z_stroke_short", "lat_s_let_z_stroke_short"]),
		)

		SlotMapping := Map()

		letterI_Option := Cfg.Get("I_Dot_Shift_I_Dotless", "Characters", "Default")

		if letterI_Option = "Separated" {
			SlotModdedLetters["I"].Set("<+", ["lat_c_let_i", "lat_s_let_i_dotless"])
			SlotMapping.Set("I", ["lat_c_let_i_dot_above", "lat_s_let_i"])
		} else if letterI_Option = "Hybrid" {
			SlotModdedLetters["I"].Set("<+", ["lat_c_let_i_dot_above", "lat_s_let_i_dotless"])
		}

		LayoutArray := ArrayMerge(
			GetBindingsArray(, SlotModdedDiacritics),
			GetBindingsArray(, SlotModdedQuotes, QuotesSlots),
			GetBindingsArray(, SlotModdedSpaces, SpacesSlots),
			GetBindingsArray(, SlotModdedSpecials, SpecialsSlots),
			GetBindingsArray(, SlotModdedDashes, DashesSlots),
			GetBindingsArray(SlotMapping, SlotModdedLetters, LettersSlots),
			[
				"<^>!" UseKey["ArrLeft"], (K) =>
					TimedKeyCombinations("ArrLeft",
						[UseKey["ArrUp"], UseKey["ArrDown"], UseKey["ArrRight"]],
						[
							(*) => HandleFastKey(K, "arrow_leftup"),
							(*) => HandleFastKey(K, "arrow_leftdown"),
							(*) => HandleFastKey(K, "arrow_leftright")
						], (*) => HandleFastKey(K, "arrow_left"), -75
					),
				"<^>!" UseKey["ArrRight"], (K) =>
					TimedKeyCombinations("ArrRight",
						[UseKey["ArrLeft"], UseKey["ArrUp"], UseKey["ArrDown"]],
						["Off", (*) => HandleFastKey(K, "arrow_rightup"), (*) => HandleFastKey(K, "arrow_rightdown")], (*) => HandleFastKey(K, "arrow_right"), -75
					),
				"<^>!" UseKey["ArrUp"], (K) =>
					TimedKeyCombinations("ArrUp",
						[UseKey["ArrLeft"], UseKey["ArrRight"], UseKey["ArrDown"]],
						["Off", "Off", (*) => HandleFastKey(K, "arrow_updown")], (*) => HandleFastKey(K, "arrow_up"), -75
					),
				"<^>!" UseKey["ArrDown"], (K) =>
					TimedKeyCombinations("ArrDown",
						[UseKey["ArrUp"], UseKey["ArrLeft"], UseKey["ArrRight"]],
						["Off", "Off", "Off"], (*) => HandleFastKey(K, "arrow_down"), -75
					),
				"<^>!<+" UseKey["ArrLeft"], (K) => HandleFastKey(K, "arrow_left_ushaped"),
				"<^>!<+" UseKey["ArrRight"], (K) => HandleFastKey(K, "arrow_right_ushaped"),
				"<^>!<+" UseKey["ArrUp"], (K) => HandleFastKey(K, "arrow_up_ushaped"),
				"<^>!<+" UseKey["ArrDown"], (K) => HandleFastKey(K, "arrow_down_ushaped"),
				"<^>!>+" UseKey["ArrLeft"], (K) => HandleFastKey(K, "arrow_left_circle"),
				"<^>!>+" UseKey["ArrRight"], (K) => HandleFastKey(K, "arrow_right_circle"),
				;
				"<^>!" UseKey["Numpad4"], (K) => CapsSeparatedKey(K, "asian_double_left_quote", "asian_left_quote"),
				"<^>!" UseKey["Numpad6"], (K) => CapsSeparatedKey(K, "asian_double_right_quote", "asian_right_quote"),
				"<^>!" UseKey["Numpad8"], (K) => CapsSeparatedKey(K, "asian_double_up_quote", "asian_up_quote"),
				"<^>!" UseKey["Numpad2"], (K) => CapsSeparatedKey(K, "asian_double_down_quote", "asian_down_quote"),
				"<^>!" UseKey["Numpad7"], (K) => CapsSeparatedKey(K, "asian_double_left_title", "asian_left_title"),
				"<^>!" UseKey["Numpad9"], (K) => CapsSeparatedKey(K, "asian_double_right_title", "asian_right_title"),
				;
				"<^>!" UseKey["Enter"], (K) => HandleFastKey(K, "misc_crlf_emspace"),
				"<^>!<+" UseKey["Enter"], (K) => SendPaste("+{Enter}", (*) => HandleFastKey(K, "emsp")),
				"<^>!>+" UseKey["Enter"], (K) => HandleFastKey(K, "misc_crlf_emspace", "emsp"),
				;
				"<^<!" UseKey["NumpadDiv"], (K) => HandleFastKey(K, "asterisk_operator"),
				"<^<!<+" UseKey["NumpadDiv"], (K) => HandleFastKey(K, "bullet_operator"),
				UseKey["NumpadMult"], (K) => TimedKeyCombinations("NumpadMult", UseKey["NumpadDiv"], (*) => HandleFastKey(K, "division_times"), (*) => HandleFastKey(K, "multiplication"), -75),
				UseKey["NumpadDiv"], (K) => TimedKeyCombinations("NumpadDiv", UseKey["NumpadMult"], "Off", (*) => HandleFastKey(K, "division"), -75),
				UseKey["NumpadSub"], (K) => TimedKeyCombinations("NumpadSub", UseKey["NumpadAdd"], (*) => HandleFastKey(K, "plusminus"), (*) => HandleFastKey(K, "minus"), -75),
				UseKey["NumpadAdd"], (K) => TimedKeyCombinations("NumpadAdd", UseKey["NumpadSub"], (*) => HandleFastKey(K, "minusplus"), , -75),
				/*
				UseKey["Equals"], (K) =>
					TimedKeyCombinations("Equals",
						[UseKey["Slash"], UseKey["Tilde"]],
						[(*) => HandleFastKey(K, "noequals"), (*) => HandleFastKey(K, "almostequals")]
				),
				*/
				;UseKey["Slash"], (K) => TimedKeyCombinations("Slash", UseKey["Equals"], "Off"),
				UseKey["Tilde"], (K) => TimedKeyCombinations("Tilde", UseKey["Equals"], "Off"),
				;
				"<^>!" UseKey["Numpad0"], (K) => HandleFastKey(K, "empty_set"),
				"<^<!" UseKey["Numpad0"], (K) => HandleFastKey(K, "dotted_circle"),
				"<^>!" UseKey["NumpadMult"], (K) => HandleFastKey(K, "asterisk_two"),
				"<^>!>+" UseKey["NumpadMult"], (K) => HandleFastKey(K, "asterism"),
				"<^>!<+" UseKey["NumpadMult"], (K) => HandleFastKey(K, "asterisk_low"),
				"<^>!" UseKey["NumpadDiv"], (K) => HandleFastKey(K, "dagger"),
				"<^>!>+" UseKey["NumpadDiv"], (K) => HandleFastKey(K, "dagger_double"),
			],
			[
				"<!>^" UseKey["A"], (K) => HandleFastKey(K, "dagger_double"),
			])


	} else if Combinations = "Glagolitic Futhark" {
		Slots := GetLayoutImprovedCyrillic([
			["glagolitic_c_let_fritu", "glagolitic_s_let_fritu"], KeySeqSlot["A"],
			["glagolitic_c_let_fita", "glagolitic_s_let_fita"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["A"]),
			["glagolitic_c_let_i", "glagolitic_s_let_i"], KeySeqSlot["B"],
			["glagolitic_c_let_initial_izhe", "glagolitic_s_let_initial_izhe"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["B"]),
			["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"], MapMerge(GetModifiers("<+"), KeySeqSlot["B"]),
			["glagolitic_c_let_izhitsa", "glagolitic_s_let_izhitsa"], MapMerge(GetModifiers("<^>!<+"), KeySeqSlot["B"]),
			["glagolitic_c_let_slovo", "glagolitic_s_let_slovo"], KeySeqSlot["C"],
			["glagolitic_c_let_dzelo", "glagolitic_s_let_dzelo"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["C"]),
			["glagolitic_c_let_vede", "glagolitic_s_let_vede"], KeySeqSlot["D"],
			["glagolitic_c_let_uku", "glagolitic_s_let_uku"], KeySeqSlot["E"],
			["glagolitic_c_let_az", "glagolitic_s_let_az"], KeySeqSlot["F"],
			["glagolitic_c_let_trokutasti_a", "glagolitic_s_let_trokutasti_a"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["F"]),
			["glagolitic_c_let_pokoji", "glagolitic_s_let_pokoji"], KeySeqSlot["G"],
			["glagolitic_c_let_pe", "glagolitic_s_let_pe"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["G"]),
			["glagolitic_c_let_ritsi", "glagolitic_s_let_ritsi"], KeySeqSlot["H"],
			["glagolitic_c_let_sha", "glagolitic_s_let_sha"], KeySeqSlot["I"],
			["glagolitic_c_let_onu", "glagolitic_s_let_onu"], KeySeqSlot["J"],
			["glagolitic_c_let_otu", "glagolitic_s_let_otu"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["J"]),
			["glagolitic_c_let_big_yus", "glagolitic_s_let_big_yus"], MapMerge(GetModifiers("<!"), KeySeqSlot["J"]),
			["glagolitic_c_let_ljudije", "glagolitic_s_let_ljudije"], KeySeqSlot["K"],
			["glagolitic_c_let_dobro", "glagolitic_s_let_dobro"], KeySeqSlot["L"],
			["glagolitic_c_let_yeri", "glagolitic_s_let_yeri"], KeySeqSlot["M"],
			["glagolitic_c_let_tvrido", "glagolitic_s_let_tvrido"], KeySeqSlot["N"],
			["glagolitic_c_let_shta", "glagolitic_s_let_shta"], KeySeqSlot["O"],
			["glagolitic_c_let_zemlja", "glagolitic_s_let_zemlja"], KeySeqSlot["P"],
			["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"], KeySeqSlot["Q"],
			["glagolitic_c_let_kako", "glagolitic_s_let_kako"], KeySeqSlot["R"],
			["glagolitic_c_let_yery", "glagolitic_s_let_yery"], KeySeqSlot["S"],
			["glagolitic_c_let_yestu", "glagolitic_s_let_yestu"], KeySeqSlot["T"],
			["glagolitic_c_let_glagoli", "glagolitic_s_let_glagoli"], KeySeqSlot["U"],
			["glagolitic_c_let_myslite", "glagolitic_s_let_myslite"], KeySeqSlot["V"],
			["glagolitic_c_let_tsi", "glagolitic_s_let_tsi"], KeySeqSlot["W"],
			["glagolitic_c_let_chrivi", "glagolitic_s_let_chrivi"], KeySeqSlot["X"],
			["glagolitic_c_let_nashi", "glagolitic_s_let_nashi"], KeySeqSlot["Y"],
			["glagolitic_c_let_yati", "glagolitic_s_let_yati"], KeySeqSlot["Z"],
			["glagolitic_c_let_buky", "glagolitic_s_let_buky"], KeySeqSlot[","],
			["glagolitic_c_let_yu", "glagolitic_s_let_yu"], KeySeqSlot["."],
			["glagolitic_c_let_zhivete", "glagolitic_s_let_zhivete"], KeySeqSlot[";"],
			["glagolitic_c_let_djervi", "glagolitic_s_let_djervi"], MapMerge(GetModifiers("<^>!"), KeySeqSlot[";"]),
			["glagolitic_c_let_small_yus", "glagolitic_s_let_small_yus"], KeySeqSlot["'"],
			["glagolitic_c_let_small_yus_iotified", "glagolitic_s_let_small_yus_iotified"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["'"]),
			["glagolitic_c_let_heru", "glagolitic_s_let_heru"], KeySeqSlot["["],
			["glagolitic_c_let_spider_ha", "glagolitic_s_let_spider_ha"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["["]),
			["glagolitic_c_let_yeru", "glagolitic_s_let_yeru"], MapMerge(GetModifiers("D:<+"), KeySeqSlot["]"]),
			["glagolitic_c_let_shtapic", "glagolitic_s_let_shtapic"], MapMerge(GetModifiers("<^>!", "D:<^>!<+"), KeySeqSlot["]"]),
			["glagolitic_c_let_yo", "glagolitic_s_let_yo"], KeySeqSlot["~"],
			["glagolitic_c_let_big_yus_iotified", "glagolitic_s_let_big_yus_iotified"], MapMerge(GetModifiers("<!"), KeySeqSlot["~"]),
			"kkey_dot", KeySeqSlot["DotRu"],
			"kkey_comma", MapMerge(GetModifiers("Y:<+", "I:<+"), KeySeqSlot["CommaRu"]),
			"exclamation", MapMerge(GetModifiers("<+"), KeySeqSlot["!"]),
			"question", MapMerge(GetModifiers("<+"), KeySeqSlot["?"]),
			"kkey_hyphen_minus", MapMerge(GetModifiers("I:>+"), KeySeqSlot["-"]),
			"kkey_underscore", MapMerge(GetModifiers("<+", "I:<+>+"), KeySeqSlot["-"]),
			"kkey_equals", MapMerge(GetModifiers("I:>+"), KeySeqSlot["="]),
			"kkey_plus", MapMerge(GetModifiers("<+", "I:<+>+"), KeySeqSlot["="]),
		])


		if CyrillicLayout = "ЙІУКЕН (1907)" {
			MapPush(Slots, LatinLayout = "Dvorak" ? "," : "W", ["glagolitic_c_let_initial_izhe", "glagolitic_s_let_initial_izhe"])
			MapPush(Slots, LatinLayout = "Dvorak" ? "J" : "C", ["glagolitic_c_let_yati", "glagolitic_s_let_yati"])
		}

		SlotMapping := Map(
			"A", "futhark_ansuz",
			"B", "futhark_berkanan",
			"C", "futhork_cen",
			"D", "futhark_dagaz",
			"E", "futhark_ehwaz",
			"F", "futhark_fehu",
			"G", "futhark_gebo",
			"H", "futhark_haglaz",
			"I", "futhark_isaz",
			"J", "futhark_jeran",
			"K", "futhark_kauna",
			"L", "futhark_laguz",
			"M", "futhark_mannaz",
			"N", "futhark_naudiz",
			"O", "futhark_odal",
			"P", "futhark_pertho",
			"Q", "futhork_cweorth",
			"R", "futhark_raido",
			"S", "futhark_sowilo",
			"T", "futhark_tiwaz",
			"U", "futhark_uruz",
			"V", "futhark_younger_later_v",
			"W", "futhark_wunjo",
			"X", "",
			"Y", "futhark_younger_ur",
			"Z", "futhark_algiz",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"A", Map("<+", "futhork_as", ">+", "futhork_aesc", "<^>!", "futhark_younger_jera", "<^>!<+", "futhark_younger_jera_short_twig"),
			"B", Map("<^>!<+", "futhark_younger_bjarkan_short_twig"),
			"C", Map("<^>!<!", "medieval_c"),
			"D", Map("<^>!", "futhark_younger_later_eth", "<^>!<+", "futhark_younger_later_d", "<^<!", "cyr_com_vzmet"),
			"E", Map("<+", "futhork_ear", "<^>!", "futhark_younger_later_e", "<^>!<!", "medieval_en"),
			"G", Map("<+", "futhork_gar", "<^<!", "cyr_com_palatalization", "<^<!<+", "cyr_com_pokrytie", "<^<!>+", "cyr_com_dasia_pneumata", "<^<!<+>+", "cyr_com_psili_pneumata"),
			"H", Map("<+", "futhork_haegl", "<^>!", "futhark_younger_hagall", "<^>!<+", "futhark_younger_hagall_short_twig"),
			"I", Map(">+", "futhark_eihwaz"),
			"J", Map("<+", "futhork_ger", ">+", "futhork_ior"),
			"K", Map("<+", "futhork_cealc", ">+", "futhork_calc", "<^>!", "futhark_younger_kaun"),
			"L", Map("<^>!", "futhark_younger_later_l"),
			"M", Map("<^>!", "futhark_younger_madr", "<^>!<+", "futhark_younger_madr_short_twig"),
			"N", Map(">+", "futhark_ingwaz", "<+", "futhork_ing", "<^>!<+", "futhark_younger_naud_short_twig", "<^>!<!", "medieval_en"),
			"O", Map("<+", "futhork_os", "<^>!", "futhark_younger_oss", "<^>!<+", "futhark_younger_oss_short_twig", "<^>!<!", "medieval_on", "<^>!<!>+", "medieval_o"),
			"P", Map("<^>!", "futhark_younger_later_p"),
			"S", Map("<+", "futhork_sigel", ">+", "futhork_stan", "<^>!<+", "futhark_younger_sol_short_twig"),
			"T", Map(">+", "futhark_thurisaz", "<^>!<+", "futhark_younger_tyr_short_twig"),
			"X", Map("<^>!<!", "medieval_x"),
			"Y", Map(">+", "futhark_younger_icelandic_yr", "<^>!", "futhark_younger_yr", "<^>!<+", "futhark_younger_yr_short_twig", "<+", "futhork_yr"),
			"Z", Map("<^>!<!", "medieval_z"),
			",", Map("<^>!", "runic_cruciform_punctuation"),
			".", Map("<^>!", "runic_single_punctuation"),
			"Space", Map("<^>!", "runic_multiple_punctuation"),
			"=", Map("<+", "kkey_plus", ">+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore", ">+", "kkey_underscore"),
			"/", Map("<+", "question", ">+", "question"),
			"\", Map("<+", "kkey_verticalline", ">+", "kkey_verticalline"),
			;
			"1", Map("+", "exclamation"),
			"7", Map("<^>!", "futhark_almanac_arlaug", "+", "question"),
			"8", Map("<^>!", "futhark_almanac_tvimadur", "+", "kkey_asterisk"),
			"9", Map("<^>!", "futhark_almanac_belgthor", "+", "kkey_left_parenthesis"),
			"0", Map("+", "kkey_right_parenthesis"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, Slots)
	} else if Combinations = "NonQWERTY" {
		Slots := GetLayoutImprovedCyrillic([
			["cyr_c_let_f", "cyr_s_let_f"], KeySeqSlot["A"],
			["cyr_c_let_i", "cyr_s_let_i"], KeySeqSlot["B"],
			["cyr_c_let_s", "cyr_s_let_s"], KeySeqSlot["C"],
			["cyr_c_let_v", "cyr_s_let_v"], KeySeqSlot["D"],
			["cyr_c_let_u", "cyr_s_let_u"], KeySeqSlot["E"],
			["cyr_c_let_a", "cyr_s_let_a"], KeySeqSlot["F"],
			["cyr_c_let_p", "cyr_s_let_p"], KeySeqSlot["G"],
			["cyr_c_let_r", "cyr_s_let_r"], KeySeqSlot["H"],
			["cyr_c_let_sh", "cyr_s_let_sh"], KeySeqSlot["I"],
			["cyr_c_let_o", "cyr_s_let_o"], KeySeqSlot["J"],
			["cyr_c_let_l", "cyr_s_let_l"], KeySeqSlot["K"],
			["cyr_c_let_d", "cyr_s_let_d"], KeySeqSlot["L"],
			["cyr_c_let_yeri", "cyr_s_let_yeri"], KeySeqSlot["M"],
			["cyr_c_let_t", "cyr_s_let_t"], KeySeqSlot["N"],
			["cyr_c_let_shch", "cyr_s_let_shch"], KeySeqSlot["O"],
			["cyr_c_let_z", "cyr_s_let_z"], KeySeqSlot["P"],
			["cyr_c_let_iy", "cyr_s_let_iy"], KeySeqSlot["Q"],
			["cyr_c_let_k", "cyr_s_let_k"], KeySeqSlot["R"],
			["cyr_c_let_yery", "cyr_s_let_yery"], KeySeqSlot["S"],
			["cyr_c_let_ie", "cyr_s_let_ie"], KeySeqSlot["T"],
			["cyr_c_let_g", "cyr_s_let_g"], KeySeqSlot["U"],
			["cyr_c_let_m", "cyr_s_let_m"], KeySeqSlot["V"],
			["cyr_c_let_ts", "cyr_s_let_ts"], KeySeqSlot["W"],
			["cyr_c_let_ch", "cyr_s_let_ch"], KeySeqSlot["X"],
			["cyr_c_let_n", "cyr_s_let_n"], KeySeqSlot["Y"],
			["cyr_c_let_ya", "cyr_s_let_ya"], KeySeqSlot["Z"],
			["cyr_c_let_b", "cyr_s_let_b"], KeySeqSlot[","],
			["cyr_c_let_yu", "cyr_s_let_yu"], KeySeqSlot["."],
			["cyr_c_let_zh", "cyr_s_let_zh"], KeySeqSlot[";"],
			["cyr_c_let_e", "cyr_s_let_e"], KeySeqSlot["'"],
			["cyr_c_let_h", "cyr_s_let_h"], KeySeqSlot["["],
			["cyr_c_let_yeru", "cyr_s_let_yeru"], MapMerge(GetModifiers("D:<!"), KeySeqSlot["]"]),
			["cyr_c_let_yo", "cyr_s_let_yo"], KeySeqSlot["~"],
			"digit_1", KeySeqSlot["1"],
			"digit_2", KeySeqSlot["2"],
			"digit_3", KeySeqSlot["3"],
			"digit_4", KeySeqSlot["4"],
			"digit_5", KeySeqSlot["5"],
			"digit_6", KeySeqSlot["6"],
			"digit_7", KeySeqSlot["7"],
			"digit_8", KeySeqSlot["8"],
			"digit_9", KeySeqSlot["9"],
			"digit_0", KeySeqSlot["0"],
			"kkey_dot", KeySeqSlot["DotRu"],
			"kkey_comma", MapMerge(GetModifiers("Y:<+", "I:<+"), KeySeqSlot["CommaRu"]),
			"exclamation", MapMerge(GetModifiers("<+"), KeySeqSlot["!"]),
			"question", MapMerge(GetModifiers("<+"), KeySeqSlot["?"]),
			"kkey_hyphen_minus", MapMerge(GetModifiers("I:>+"), KeySeqSlot["-"]),
			"kkey_underscore", MapMerge(GetModifiers("<+", "I:<+>+"), KeySeqSlot["-"]),
			"kkey_equals", MapMerge(GetModifiers("I:>+"), KeySeqSlot["="]),
			"kkey_plus", MapMerge(GetModifiers("<+", "I:<+>+"), KeySeqSlot["="]),
			"kkey_quotation", MapMerge(GetModifiers("<+"), KeySeqSlot["2"]),
			"kkey_numero_sign", MapMerge(GetModifiers("<+"), KeySeqSlot["3"]),
			"kkey_semicolon", MapMerge(GetModifiers("<+"), KeySeqSlot["4"]),
			"kkey_colon", MapMerge(GetModifiers("<+"), KeySeqSlot["5"]),
		])

		if CyrillicLayout = "ЙІУКЕН (1907)" {
			MapPush(Slots,
				LatinLayout = "Dvorak" ? "," : "W", ["cyr_c_let_i_decimal", "cyr_s_let_i_decimal"],
				LatinLayout = "Dvorak" ? "J" : "C", ["cyr_c_let_yat", "cyr_s_let_yat"])
		}

		SlotMapping := Map(
			"A", ["lat_c_let_a", "lat_s_let_a"],
			"B", ["lat_c_let_b", "lat_s_let_b"],
			"C", ["lat_c_let_c", "lat_s_let_c"],
			"D", ["lat_c_let_d", "lat_s_let_d"],
			"E", ["lat_c_let_e", "lat_s_let_e"],
			"F", ["lat_c_let_f", "lat_s_let_f"],
			"G", ["lat_c_let_g", "lat_s_let_g"],
			"H", ["lat_c_let_h", "lat_s_let_h"],
			"I", ["lat_c_let_i", "lat_s_let_i"],
			"J", ["lat_c_let_j", "lat_s_let_j"],
			"K", ["lat_c_let_k", "lat_s_let_k"],
			"L", ["lat_c_let_l", "lat_s_let_l"],
			"M", ["lat_c_let_m", "lat_s_let_m"],
			"N", ["lat_c_let_n", "lat_s_let_n"],
			"O", ["lat_c_let_o", "lat_s_let_o"],
			"P", ["lat_c_let_p", "lat_s_let_p"],
			"Q", ["lat_c_let_q", "lat_s_let_q"],
			"R", ["lat_c_let_r", "lat_s_let_r"],
			"S", ["lat_c_let_s", "lat_s_let_s"],
			"T", ["lat_c_let_t", "lat_s_let_t"],
			"U", ["lat_c_let_u", "lat_s_let_u"],
			"V", ["lat_c_let_v", "lat_s_let_v"],
			"W", ["lat_c_let_w", "lat_s_let_w"],
			"X", ["lat_c_let_x", "lat_s_let_x"],
			"Y", ["lat_c_let_y", "lat_s_let_y"],
			"Z", ["lat_c_let_z", "lat_s_let_z"],
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
			"1", "digit_1",
			"2", "digit_2",
			"3", "digit_3",
			"4", "digit_4",
			"5", "digit_5",
			"6", "digit_6",
			"7", "digit_7",
			"8", "digit_8",
			"9", "digit_9",
			"0", "digit_0",
		)

		SlotModdedMapping := Map(
			"A", Map("<+", ["lat_c_let_a", "lat_s_let_a"]),
			"B", Map("<+", ["lat_c_let_b", "lat_s_let_b"]),
			"C", Map("<+", ["lat_c_let_c", "lat_s_let_c"]),
			"D", Map("<+", ["lat_c_let_d", "lat_s_let_d"]),
			"E", Map("<+", ["lat_c_let_e", "lat_s_let_e"]),
			"F", Map("<+", ["lat_c_let_f", "lat_s_let_f"]),
			"G", Map("<+", ["lat_c_let_g", "lat_s_let_g"]),
			"H", Map("<+", ["lat_c_let_h", "lat_s_let_h"]),
			"I", Map("<+", ["lat_c_let_i", "lat_s_let_i"]),
			"J", Map("<+", ["lat_c_let_j", "lat_s_let_j"]),
			"K", Map("<+", ["lat_c_let_k", "lat_s_let_k"]),
			"L", Map("<+", ["lat_c_let_l", "lat_s_let_l"]),
			"M", Map("<+", ["lat_c_let_m", "lat_s_let_m"]),
			"N", Map("<+", ["lat_c_let_n", "lat_s_let_n"]),
			"O", Map("<+", ["lat_c_let_o", "lat_s_let_o"]),
			"P", Map("<+", ["lat_c_let_p", "lat_s_let_p"]),
			"Q", Map("<+", ["lat_c_let_q", "lat_s_let_q"]),
			"R", Map("<+", ["lat_c_let_r", "lat_s_let_r"]),
			"S", Map("<+", ["lat_c_let_s", "lat_s_let_s"]),
			"T", Map("<+", ["lat_c_let_t", "lat_s_let_t"]),
			"U", Map("<+", ["lat_c_let_u", "lat_s_let_u"]),
			"V", Map("<+", ["lat_c_let_v", "lat_s_let_v"]),
			"W", Map("<+", ["lat_c_let_w", "lat_s_let_w"]),
			"X", Map("<+", ["lat_c_let_x", "lat_s_let_x"]),
			"Y", Map("<+", ["lat_c_let_y", "lat_s_let_y"]),
			"Z", Map("<+", ["lat_c_let_z", "lat_s_let_z"]),
			",", Map("<+", "kkey_lessthan"),
			".", Map("<+", "kkey_greaterthan"),
			";", Map("<+", "kkey_colon"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_tilde"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
			"1", Map("<+", "exclamation"),
			"2", Map("<+", "kkey_commercial_at"),
			"3", Map("<+", "kkey_number_sign"),
			"4", Map("<+", "wallet_dollar"),
			"5", Map("Flat:<+", "kkey_percent_sign"),
			"6", Map("<+", "kkey_circumflex_accent"),
			"7", Map("<+", "lat_s_lig_et"),
			"8", Map("Flat:<+", "kkey_asterisk"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, Slots, True)
	} else if Combinations = "Old Turkic Old Permic" {
		Slots := GetLayoutImprovedCyrillic([
			"permic_ef", KeySeqSlot["A"],
			"permic_i", KeySeqSlot["B"],
			"permic_sii", KeySeqSlot["C"],
			"permic_ver", KeySeqSlot["D"],
			"permic_u", KeySeqSlot["E"],
			"permic_an", KeySeqSlot["F"],
			"permic_peei", KeySeqSlot["G"],
			"permic_rei", KeySeqSlot["H"],
			"permic_shooi", KeySeqSlot["I"],
			"permic_vooi", KeySeqSlot["J"],
			"permic_o", MapMerge(GetModifiers("<^>!"), KeySeqSlot["J"]),
			"permic_lei", KeySeqSlot["K"],
			"permic_doi", KeySeqSlot["L"],
			"permic_yeri", KeySeqSlot["M"],
			"permic_tai", KeySeqSlot["N"],
			"permic_shchooi", KeySeqSlot["O"],
			"permic_zata", KeySeqSlot["P"],
			"permic_dzita", MapMerge(GetModifiers("<^>!"), KeySeqSlot["P"]),
			"permic_ie", KeySeqSlot["Q"],
			"permic_koke", KeySeqSlot["R"],
			"permic_yery", KeySeqSlot["S"],
			"permic_yry", MapMerge(GetModifiers("<^>!"), KeySeqSlot["S"]),
			"permic_e", KeySeqSlot["T"],
			"permic_gai", KeySeqSlot["U"],
			"permic_menoe", KeySeqSlot["V"],
			"permic_tsiu", KeySeqSlot["W"],
			"permic_chery", KeySeqSlot["X"],
			"permic_nenoe", KeySeqSlot["Y"],
			"permic_ia", KeySeqSlot["Z"],
			"permic_ya", MapMerge(GetModifiers("<^>!"), KeySeqSlot["Z"]),
			"permic_bur", KeySeqSlot[","],
			"permic_yu", KeySeqSlot["."],
			"permic_zhoi", KeySeqSlot[";"],
			"permic_dzhoi", MapMerge(GetModifiers("<^>!"), KeySeqSlot[";"]),
			"permic_yat", KeySeqSlot["'"],
			"permic_ha", KeySeqSlot["["],
			"permic_yeru", MapMerge(GetModifiers("D:<!"), KeySeqSlot["]"]),
			"permic_oo", KeySeqSlot["~"],
			"kkey_dot", KeySeqSlot["DotRu"],
			"kkey_comma", MapMerge(GetModifiers("Y:<+", "I:<+"), KeySeqSlot["CommaRu"]),
			"exclamation", MapMerge(GetModifiers("<+"), KeySeqSlot["!"]),
			"question", MapMerge(GetModifiers("<+"), KeySeqSlot["?"]),
			"kkey_hyphen_minus", MapMerge(GetModifiers("I:>+"), KeySeqSlot["-"]),
			"kkey_underscore", MapMerge(GetModifiers("<+", "I:<+>+"), KeySeqSlot["-"]),
			"kkey_equals", MapMerge(GetModifiers("I:>+"), KeySeqSlot["="]),
			"kkey_plus", MapMerge(GetModifiers("<+", "I:<+>+"), KeySeqSlot["="]),
		])
		SlotMapping := Map(
			"A", ["turkic_yenisei_a", "turkic_orkhon_a"],
			"B", ["turkic_yenisei_ab", "turkic_orkhon_ab"],
			"C", ["turkic_yenisei_ec", "turkic_orkhon_ec"],
			"D", ["turkic_yenisei_ad", "turkic_orkhon_ad"],
			"E", "turkic_yenisei_e",
			"F", ["", ""],
			"G", ["turkic_yenisei_ag", "turkic_orkhon_ag"],
			"H", ["", ""],
			"I", ["turkic_yenisei_i", "turkic_orkhon_i"],
			"J", ["turkic_yenisei_aey", "turkic_orkhon_aey"],
			"K", ["turkic_yenisei_aq", "turkic_orkhon_aq"],
			"L", ["turkic_yenisei_al", "turkic_orkhon_al"],
			"M", "turkic_orkhon_em",
			"N", "turkic_orkhon_an",
			"O", "turkic_orkhon_o",
			"P", "turkic_orkhon_ep",
			"Q", ["turkic_yenisei_oq", "turkic_orkhon_oq"],
			"R", ["turkic_yenisei_ar", "turkic_orkhon_ar"],
			"S", "turkic_orkhon_as",
			"T", ["turkic_yenisei_at", "turkic_orkhon_at"],
			"U", ["", ""],
			"V", ["", ""],
			"W", ["", ""],
			"X", ["", ""],
			"Y", ["turkic_yenisei_ay", "turkic_orkhon_ay"],
			"Z", ["turkic_yenisei_ez", "turkic_orkhon_ez"],
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"A", Map("<^>!", "turkic_yenisei_ae", "<!", ["turkic_yenisei_ash", "turkic_orkhon_ash"]),
			"B", Map("<^>!", ["turkic_yenisei_aeb", "turkic_orkhon_aeb"]),
			"C", Map("<^>!", "turkic_orkhon_ic"),
			"D", Map("<^>!", "turkic_orkhon_aed"),
			"G", Map("<^>!", ["turkic_yenisei_aeg", "turkic_orkhon_aeg"]),
			"K", Map("<^>!", ["turkic_yenisei_aek", "turkic_orkhon_aek"]),
			"L", Map("<^>!", "turkic_orkhon_ael"),
			"N", Map("<^>!>+", ["turkic_yenisei_ent", "turkic_orkhon_ent"], "<^>!", ["turkic_yenisei_aen", "turkic_orkhon_aen"], ">+", ["turkic_yenisei_enc", "turkic_orkhon_enc"], ">+", ["turkic_yenisei_eny", "turkic_orkhon_eny"], "<!", "turkic_orkhon_eng"),
			"O", Map("<^>!", ["turkic_yenisei_oe", "turkic_orkhon_oe"]),
			"P", Map("<!", "turkic_orkhon_op"),
			"Q", Map("<^>!", ["turkic_yenisei_oek", "turkic_orkhon_oek"], "<!", ["turkic_yenisei_iq", "turkic_orkhon_iq"]),
			"R", Map("<^>!", "turkic_orkhon_aer", "<!", "turkic_orkhon_bash"),
			"S", Map("<^>!", "turkic_orkhon_aes", "<!", ["turkic_yenisei_esh", "turkic_orkhon_esh"]),
			"T", Map("<^>!", ["turkic_yenisei_aet", "turkic_orkhon_aet"], "<^>!>+", "turkic_orkhon_elt", "<!", "turkic_orkhon_ot"),
			"Y", Map("<^>!", ["turkic_yenisei_aey", "turkic_orkhon_aey"]),
			",", Map("<+", "kkey_lessthan", "<^>!", "runic_cruciform_punctuation"),
			".", Map("<+", "kkey_greaterthan", "<^>!", "runic_single_punctuation"),
			";", Map("<+", "kkey_colon"),
			"Space", Map("<^>!", "runic_multiple_punctuation"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_grave_accent"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, Slots)
	} else if Combinations = "Old Hungarian" {
		SlotMapping := Map(
			"A", ["hungarian_c_let_a", "hungarian_s_let_a"],
			"B", ["hungarian_c_let_eb", "hungarian_s_let_eb"],
			"C", ["hungarian_c_let_ec", "hungarian_s_let_ec"],
			"D", ["hungarian_c_let_ed", "hungarian_s_let_ed"],
			"E", ["hungarian_c_let_e", "hungarian_s_let_e"],
			"F", ["hungarian_c_let_ef", "hungarian_s_let_ef"],
			"G", ["hungarian_c_let_eg", "hungarian_s_let_eg"],
			"H", ["hungarian_c_let_eh", "hungarian_s_let_eh"],
			"I", ["hungarian_c_let_i", "hungarian_s_let_i"],
			"J", ["hungarian_c_let_ej", "hungarian_s_let_ej"],
			"K", ["hungarian_c_let_ek", "hungarian_s_let_ek"],
			"L", ["hungarian_c_let_el", "hungarian_s_let_el"],
			"M", ["hungarian_c_let_em", "hungarian_s_let_em"],
			"N", ["hungarian_c_let_en", "hungarian_s_let_en"],
			"O", ["hungarian_c_let_o", "hungarian_s_let_o"],
			"P", ["hungarian_c_let_ep", "hungarian_s_let_ep"],
			"Q", ["", ""],
			"R", ["hungarian_c_let_er", "hungarian_s_let_er"],
			"S", ["hungarian_c_let_es", "hungarian_s_let_es"],
			"T", ["hungarian_c_let_et", "hungarian_s_let_et"],
			"U", ["hungarian_c_let_u", "hungarian_s_let_u"],
			"V", ["hungarian_c_let_ev", "hungarian_s_let_ev"],
			"W", ["", ""],
			"X", ["", ""],
			"Y", ["hungarian_c_let_ue", "hungarian_s_let_ue"],
			"Z", ["hungarian_c_let_ez", "hungarian_s_let_ez"],
			"1", "hungarian_num_one",
			"2", "hungarian_num_five",
			"3", "hungarian_num_ten",
			"4", "hungarian_num_fifty",
			"5", "hungarian_num_one_hundred",
			"6", "hungarian_num_one_thousand",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"A", Map("<^>!", ["hungarian_c_let_aa", "hungarian_s_let_aa"]),
			"B", Map("<+", ["hungarian_c_let_amb", "hungarian_s_let_amb"]),
			"C", Map("<^>!", ["hungarian_c_let_ecs", "hungarian_s_let_ecs"], "<+", ["hungarian_c_let_ech", "hungarian_s_let_ech"]),
			"E", Map("<^>!", ["hungarian_c_let_ee", "hungarian_s_let_ee"], "<+", ["hungarian_c_let_enk", "hungarian_s_let_enk"]),
			"G", Map("<^>!", ["hungarian_c_let_egy", "hungarian_s_let_egy"]),
			"I", Map("<^>!", ["hungarian_c_let_ii", "hungarian_s_let_ii"]),
			"K", Map("<^>!", ["hungarian_c_let_ak", "hungarian_s_let_ak"], "<+", ["hungarian_c_let_unk", "hungarian_s_let_unk"]),
			"L", Map("<^>!", ["hungarian_c_let_ely", "hungarian_s_let_ely"]),
			"N", Map("<^>!", ["hungarian_c_let_eny", "hungarian_s_let_eny"]),
			"O", Map("<^>!", ["hungarian_c_let_oo", "hungarian_s_let_oo"], "<+", ["hungarian_c_let_oe", "hungarian_s_let_oe"], "<^>!<+", ["hungarian_c_let_oe_nik", "hungarian_s_let_oe_nik"], ">+", ["hungarian_c_let_oee", "hungarian_s_let_oee"],),
			"P", Map("<+", ["hungarian_c_let_emp", "hungarian_s_let_emp"]),
			"R", Map("<+", ["hungarian_c_let_short_er", "hungarian_s_let_short_er"]),
			"S", Map("<^>!", ["hungarian_c_let_esz", "hungarian_s_let_esz"], "<+", ["hungarian_c_let_us", "hungarian_s_let_us"]),
			"T", Map("<^>!", ["hungarian_c_let_ety", "hungarian_s_let_ety"], "<+", ["hungarian_c_let_ent", "hungarian_s_let_ent"], ">+", ["hungarian_c_let_ent_shaped", "hungarian_s_let_ent_shaped"]),
			"U", Map("<^>!", ["hungarian_c_let_uu", "hungarian_s_let_uu"]),
			"Y", Map("<^>!", ["hungarian_c_let_ue_nik", "hungarian_s_let_ue_nik"]),
			"Z", Map("<^>!", ["hungarian_c_let_ezs", "hungarian_s_let_ezs"]),
			",", Map("<+", "kkey_lessthan", "<^>!", "runic_cruciform_punctuation"),
			".", Map("<+", "kkey_greaterthan", "<^>!", "runic_single_punctuation"),
			";", Map("<+", "kkey_colon"),
			"Space", Map("<^>!", "runic_multiple_punctuation"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_grave_accent"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Caps")
	} else if Combinations = "Gothic" {
		SlotMapping := Map(
			"A", "gothic_ahza",
			"B", "gothic_bairkan",
			"C", "gothic_thiuth",
			"D", "gothic_dags",
			"E", "gothic_aihvus",
			"F", "gothic_faihu",
			"G", "gothic_giba",
			"H", "gothic_hagl",
			"I", "gothic_eis",
			"J", "gothic_jer",
			"K", "gothic_kusma",
			"L", "gothic_lagus",
			"M", "gothic_manna",
			"N", "gothic_nauths",
			"O", "gothic_othal",
			"P", "gothic_pairthra",
			"Q", "gothic_qairthra",
			"R", "gothic_raida",
			"S", "gothic_sugil",
			"T", "gothic_teiws",
			"U", "gothic_urus",
			"V", "gothic_hwair",
			"W", "gothic_winja",
			"X", "gothic_iggws",
			"Y", "gothic_winja",
			"Z", "gothic_ezek",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"H", Map("<^>!", "gothic_hwair"),
			"K", Map("<^>!", "gothic_ninety"),
			"S", Map("<^>!", "gothic_nine_hundred"),
			"T", Map("<^>!", "gothic_thiuth"),
			",", Map("<+", "kkey_lessthan", "<^>!", "runic_cruciform_punctuation"),
			".", Map("<+", "kkey_greaterthan", "<^>!", "runic_single_punctuation"),
			";", Map("<+", "kkey_colon"),
			"Space", Map("<^>!", "runic_multiple_punctuation"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_grave_accent"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")
	} else if Combinations = "Old Italic" {
		SlotMapping := Map(
			"A", "italic_let_a",
			"B", "italic_let_be",
			"C", "italic_let_ke",
			"D", "italic_let_de",
			"E", "italic_let_e",
			"F", "italic_let_ve",
			"G", "",
			"H", "italic_let_he",
			"I", "italic_let_i",
			"J", "",
			"K", "italic_let_ka",
			"L", "italic_let_el",
			"M", "italic_let_em",
			"N", "italic_let_en",
			"O", "italic_let_o",
			"P", "italic_let_pe",
			"Q", "italic_let_ku",
			"R", "italic_let_er",
			"S", "italic_let_es",
			"T", "italic_let_te",
			"U", "italic_let_u",
			"V", "",
			"W", "italic_let_northern_tse",
			"X", "italic_let_eks",
			"Y", "italic_let_ye",
			"Z", "italic_let_ze",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"C", Map(">+", "italic_let_che"),
			"F", Map(">+", "italic_let_ef"),
			"I", Map(">+", "italic_let_ii"),
			"K", Map(">+", "italic_let_khe"),
			"P", Map(">+", "italic_let_phe"),
			"R", Map(">+", "italic_let_ers"),
			"S", Map(">+", "italic_let_esh", "<+", "italic_let_she", "<!", "italic_let_ess"),
			"T", Map(">+", "italic_let_the"),
			"U", Map(">+", "italic_let_uu"),
			"W", Map("<+", "italic_let_southern_tse"),
			"1", Map("<^>!", "italic_let_numeral_one"),
			"2", Map("<^>!", "italic_let_numeral_five"),
			"3", Map("<^>!", "italic_let_numeral_ten"),
			"4", Map("<^>!", "italic_let_numeral_fifty"),
			",", Map("<+", "kkey_lessthan", "<^>!", ""),
			".", Map("<+", "kkey_greaterthan", "<^>!", ""),
			";", Map("<+", "kkey_colon"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_grave_accent"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")
	} else if Combinations = "Phoenician" {
		SlotMapping := Map(
			"A", "phoenician_let_alef",
			"B", "phoenician_let_bet",
			"C", "phoenician_let_sade",
			"D", "phoenician_let_delt",
			"E", "",
			"F", "",
			"G", "phoenician_let_gaml",
			"H", "phoenician_let_he",
			"I", "",
			"J", "phoenician_let_yod",
			"K", "phoenician_let_kaf",
			"L", "phoenician_let_lamd",
			"M", "phoenician_let_mem",
			"N", "phoenician_let_nun",
			"O", "phoenician_let_ain",
			"P", "phoenician_let_pe",
			"Q", "phoenician_let_qof",
			"R", "phoenician_let_rosh",
			"S", "phoenician_let_semk",
			"T", "phoenician_let_tau",
			"U", "",
			"V", "",
			"W", "phoenician_let_wau",
			"X", "",
			"Y", "phoenician_let_yod",
			"Z", "phoenician_let_zai",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"A", Map("<+", "phoenician_let_ain"),
			"H", Map(">+", "phoenician_let_het"),
			"S", Map(">+", "phoenician_let_shin"),
			"T", Map(">+", "phoenician_let_tet"),
			"1", Map("<^>!", "phoenician_let_numeral_one"),
			"2", Map("<^>!", "phoenician_let_numeral_two"),
			"3", Map("<^>!", "phoenician_let_numeral_three"),
			"4", Map("<^>!", "phoenician_let_numeral_ten"),
			"5", Map("<^>!", "phoenician_let_numeral_twenty"),
			"6", Map("<^>!", "phoenician_let_numeral_hundred"),
			"Space", Map("<^>!", "phoenician_word_separator"),
			",", Map("<+", "kkey_lessthan", "<^>!", ""),
			".", Map("<+", "kkey_greaterthan", "<^>!", ""),
			";", Map("<+", "kkey_colon"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_grave_accent"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")
	} else if Combinations = "Ancient South Arabian" {
		SlotMapping := Map(
			"A", "south_arabian_let_alef",
			"B", "south_arabian_let_beth",
			"C", "",
			"D", "south_arabian_let_daleth",
			"E", "",
			"F", "south_arabian_let_fe",
			"G", "south_arabian_let_gimel",
			"H", "south_arabian_let_he",
			"I", "",
			"J", "south_arabian_let_yodh",
			"K", "south_arabian_let_kaph",
			"L", "south_arabian_let_lamedh",
			"M", "south_arabian_let_mem",
			"N", "south_arabian_let_nun",
			"O", "",
			"P", "",
			"Q", "south_arabian_let_qoph",
			"R", "south_arabian_let_resh",
			"S", "south_arabian_let_sat",
			"T", "south_arabian_let_taw",
			"U", "",
			"V", "",
			"W", "south_arabian_let_waw",
			"X", "south_arabian_let_kheth",
			"Y", "south_arabian_let_ghayn",
			"Z", "south_arabian_let_zayn",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"A", Map("<^>!", "south_arabian_let_ayn"),
			"D", Map("<^>!", "south_arabian_let_dhadhe", "<^>!>+", "south_arabian_let_dhaleth"),
			"H", Map("<^>!", "south_arabian_let_kheth", ">+", "south_arabian_let_heth"),
			"S", Map("<^>!", "south_arabian_let_sadhe", ">+", "south_arabian_let_shin", "<+", "south_arabian_let_samekh"),
			"T", Map("<^>!", "south_arabian_let_teth", "<^>!>+", "south_arabian_let_thaw", "<+", "south_arabian_let_theth"),
			"1", Map("<^>!", "south_arabian_let_numeral_one"),
			"5", Map("<^>!", "south_arabian_let_numeral_fifty"),
			"0", Map("<^>!", "south_arabian_let_numeral_bracket"),
			",", Map("<+", "kkey_lessthan", "<^>!", ""),
			".", Map("<+", "kkey_greaterthan", "<^>!", ""),
			";", Map("<+", "kkey_colon"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_grave_accent"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")
	} else if Combinations = "Ancient North Arabian" {
		SlotMapping := Map(
			"A", "north_arabian_let_alef",
			"B", "north_arabian_let_beh",
			"C", "",
			"D", "north_arabian_let_dal",
			"E", "",
			"F", "north_arabian_let_feh",
			"G", "north_arabian_let_geem",
			"H", "north_arabian_let_heh",
			"I", "",
			"J", "north_arabian_let_yeh",
			"K", "north_arabian_let_kaf",
			"L", "north_arabian_let_lam",
			"M", "north_arabian_let_meem",
			"N", "north_arabian_let_noon",
			"O", "",
			"P", "",
			"Q", "north_arabian_let_qaf",
			"R", "north_arabian_let_reh",
			"S", "north_arabian_let_es_1",
			"T", "north_arabian_let_teh",
			"U", "",
			"V", "",
			"W", "north_arabian_let_waw",
			"X", "",
			"Y", "north_arabian_let_ghain",
			"Z", "north_arabian_let_zain",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "kkey_semicolon",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"A", Map("<^>!", "north_arabian_let_ain"),
			"D", Map("<^>!", "north_arabian_let_dad", "<^>!>+", "north_arabian_let_thal"),
			"H", Map("<^>!", "north_arabian_let_hah", ">+", "north_arabian_let_khah"),
			"S", Map("<^>!", "north_arabian_let_sad", ">+", "north_arabian_let_es_2", "<+", "north_arabian_let_es_3"),
			"T", Map("<^>!", "north_arabian_let_tah", ">!>+", "north_arabian_let_theh"),
			"Z", Map("<+", "north_arabian_let_zah"),
			"1", Map("<^>!", "north_arabian_num_one"),
			"2", Map("<^>!", "north_arabian_num_ten"),
			"3", Map("<^>!", "north_arabian_num_twenty"),
			",", Map("<+", "kkey_lessthan", "<^>!", ""),
			".", Map("<+", "kkey_greaterthan", "<^>!", ""),
			";", Map("<+", "kkey_colon"),
			"'", Map("<+", "kkey_quotation"),
			"~", Map("<+", "kkey_grave_accent"),
			"=", Map("<+", "kkey_plus"),
			"-", Map("<+", "kkey_underscore"),
			"[", Map("<+", "kkey_l_curly_bracket"),
			"]", Map("<+", "kkey_r_curly_bracket"),
			"/", Map("<+", "question"),
			"\", Map("<+", "kkey_verticalline"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")
	} else if Combinations = "Hellenic" {
		SlotMapping := Map(
			"A", ["hel_c_let_a_alpha", "hel_s_let_a_alpha"],
			"B", ["hel_c_let_b_beta", "hel_s_let_b_beta"],
			"C", ["hel_c_let_g_gamma", "hel_s_let_g_gamma"],
			"D", ["hel_c_let_d_delta", "hel_s_let_d_delta"],
			"E", ["hel_c_let_e_epsilon", "hel_s_let_e_epsilon"],
			"F", ["hel_c_let_f_phi", "hel_s_let_f_phi"],
			"G", ["hel_c_let_g_gamma", "hel_s_let_g_gamma"],
			"H", ["hel_c_let_h_eta", "hel_s_let_h_eta"],
			"I", ["hel_c_let_i_iota", "hel_s_let_i_iota"],
			"J", "",
			"K", ["hel_c_let_k_kappa", "hel_s_let_k_kappa"],
			"L", ["hel_c_let_l_lambda", "hel_s_let_l_lambda"],
			"M", ["hel_c_let_m_mu", "hel_s_let_m_mu"],
			"N", ["hel_c_let_n_nu", "hel_s_let_n_nu"],
			"O", ["hel_c_let_o_omicron", "hel_s_let_o_omicron"],
			"P", ["hel_c_let_p_pi", "hel_s_let_p_pi"],
			"Q", ["hel_c_let_q_koppa_archaic", "hel_s_let_q_koppa_archaic"],
			"R", ["hel_c_let_r_rho", "hel_s_let_r_rho"],
			"S", ["hel_c_let_s_sigma", "hel_s_let_s_sigma"],
			"T", ["hel_c_let_t_tau", "hel_s_let_t_tau"],
			"U", ["hel_c_let_u_upsilon", "hel_s_let_u_upsilon"],
			"V", "",
			"W", ["", ""],
			"X", ["hel_c_let_x_xi", "hel_s_let_x_xi"],
			"Y", ["", ""],
			"Z", ["hel_c_let_z_zeta", "hel_s_let_z_zeta"],
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "colon_triangle",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"H", Map("<^>!", ["hel_c_let_h_chi", "hel_s_let_h_chi"]),
			"O", Map("<^>!", ["hel_c_let_o_omega", "hel_s_let_o_omega"]),
			"P", Map("<^>!", ["hel_c_let_p_psi", "hel_s_let_p_psi"]),
			"Q", Map("<^>!", ["hel_c_let_q_koppa", "hel_s_let_q_koppa"]),
			"S", Map("<^>!", "hel_s_let_s_sigma_final"),
			"T", Map("<^>!", ["hel_c_let_t_theta", "hel_s_let_t_theta"]),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")
	} else if Combinations = "IPA" {
		SlotMapping := Map(
			"A", "",
			"B", "",
			"C", "lat_s_let_c_curl",
			"D", "lat_s_let_d_eth",
			"E", "",
			"F", "",
			"G", "",
			"H", "",
			"I", "lat_s_c_let_i",
			"J", "",
			"K", "",
			"L", "",
			"M", "",
			"N", "",
			"O", "",
			"P", "",
			"Q", "",
			"R", "",
			"S", "",
			"T", "",
			"U", "",
			"V", "",
			"W", "",
			"X", "",
			"Y", "",
			"Z", "lat_s_let_z_ezh",
			"~", "kkey_grave_accent",
			",", "kkey_comma",
			".", "kkey_dot",
			";", "colon_triangle",
			"'", "kkey_apostrophe",
			"[", "kkey_l_square_bracket",
			"]", "kkey_r_square_bracket",
			"=", "kkey_equals",
			"-", "kkey_hyphen_minus",
			"/", "kkey_slash",
		)

		SlotModdedMapping := Map(
			"S", Map("<^>!>+", "lat_s_let_s_sigma"),
			"U", Map("<^>!<!", ["lat_c_let_U_upsilon", "lat_s_let_u_upsilon"]),
			";", Map("<^>!", "colon_triangle_half"),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")

		Loop 26
		{
			Letter := Chr(65 + A_Index - 1)
			LayoutArray.Push("<+" UseKey[Letter])
			LayoutArray.Push(CreateFastKeyHandler(Letter))
		}
		CreateFastKeyHandler(Letter) {
			return (K) => CapsSeparatedKey(K, "lat_c_let_" StrLower(Letter), "lat_s_let_" StrLower(Letter))
		}
	} else if Combinations = "Maths" {
		SlotMapping := Map(
			"D", "delta",
			"I", ["contour_integral", "integral"],
			"N", "nabla",
			"L", "gre_s_let_lambda",
			"P", "gre_s_let_pi",
			"R", "square_root",
			"S", "n_ary_summation",
			"U", "n_ary_union",
		)

		SlotModdedMapping := Map(
			"P", Map(
				"Flat:>+", "n_ary_product",
			),
			"Space", Map(
				"Flat:<!", "medium_math_space",
			),
			",", Map(
				"Flat:>+", "less_or_equals",
			),
			".", Map(
				"Flat:>+", "greater_or_equals",
			),
		)

		LayoutArray := GetBindingsArray(SlotMapping, SlotModdedMapping, , , "Flat")
	} else if Combinations = "Cleanscript" {
		LayoutArray := [
			UseKey["1"], "Off",
			UseKey["2"], "Off",
			UseKey["3"], "Off",
			UseKey["4"], "Off",
			UseKey["7"], "Off",
			UseKey["5"], "Off",
			UseKey["6"], "Off",
			UseKey["8"], "Off",
			UseKey["9"], "Off",
			UseKey["0"], "Off",
			UseKey["Minus"], "Off",
			UseKey["Equals"], "Off",
		]
	} else if Combinations = "Supercript" {

		SlotModdedMapping := Map(
			"1", Map("Caps:", ["num_sub_1", "num_sup_1"]),
			"2", Map("Caps:", ["num_sub_2", "num_sup_2"]),
			"3", Map("Caps:", ["num_sub_3", "num_sup_3"]),
			"4", Map("Caps:", ["num_sub_4", "num_sup_4"]),
			"5", Map("Caps:", ["num_sub_5", "num_sup_5"]),
			"6", Map("Caps:", ["num_sub_6", "num_sup_6"]),
			"7", Map("Caps:", ["num_sub_7", "num_sup_7"]),
			"8", Map("Caps:", ["num_sub_8", "num_sup_8"]),
			"9", Map("Caps:", ["num_sub_9", "num_sup_9"], "Caps:<+", ["num_sub_left_parenthesis", "num_sup_left_parenthesis"]),
			"0", Map("Caps:", ["num_sub_0", "num_sup_0"], "Caps:<+", ["num_sub_right_parenthesis", "num_sup_right_parenthesis"]),
			"-", Map("Caps:", ["num_sub_minus", "num_sup_minus"]),
			"=", Map("Caps:", ["num_sub_equals", "num_sup_equals"], "Caps:<+", ["num_sub_plus", "num_sup_plus"]),
		)
		LayoutArray := GetBindingsArray(, SlotModdedMapping)

	} else if Combinations = "Subscript" {
		SlotModdedMapping := Map(
			"1", Map("Caps:", ["num_sup_1", "num_sub_1"]),
			"2", Map("Caps:", ["num_sup_2", "num_sub_2"]),
			"3", Map("Caps:", ["num_sup_3", "num_sub_3"]),
			"4", Map("Caps:", ["num_sup_4", "num_sub_4"]),
			"5", Map("Caps:", ["num_sup_5", "num_sub_5"]),
			"6", Map("Caps:", ["num_sup_6", "num_sub_6"]),
			"7", Map("Caps:", ["num_sup_7", "num_sub_7"]),
			"8", Map("Caps:", ["num_sup_8", "num_sub_8"]),
			"9", Map("Caps:", ["num_sup_9", "num_sub_9"], "Caps:<+", ["num_sup_left_parenthesis", "num_sub_left_parenthesis"]),
			"0", Map("Caps:", ["num_sup_0", "num_sub_0"], "Caps:<+", ["num_sup_right_parenthesis", "num_sub_right_parenthesis"]),
			"-", Map("Caps:", ["num_sup_minus", "num_sub_minus"]),
			"=", Map("Caps:", ["num_sup_equals", "num_sub_equals"], "Caps:<+", ["num_sup_plus", "num_sub_plus"]),
		)
		LayoutArray := GetBindingsArray(, SlotModdedMapping)
	} else if Combinations = "Utility" {
		;IsF13F24Enabled := IniRead(ConfigFile, "Settings", "F13F24", "True")
		IsF13F24Enabled := False ;(IsF13F24Enabled = "True")

		FunctionKeysExtraLayer := []

		if (IsF13F24Enabled) {
			FunctionKeysBridge(numberValue) {
				DefaultKey := "F" numberValue
				AdvancedKey := "F" (numberValue + 12)
				FunctionKeysExtraLayer.Push(
					UseKey[DefaultKey], (*) => CapsSeparatedCall((*) => Send("{" DefaultKey "}"), (*) => Send("{" AdvancedKey "}")),
					;"+" UseKey[DefaultKey], (*) => CapsSeparatedCall((*) => Send("{Shift}{" DefaultKey "}"), (*) => Send("{Shift}{" AdvancedKey "}")),
					;"^" UseKey[DefaultKey], (*) => CapsSeparatedCall((*) => Send("{Ctrl}{" DefaultKey "}"), (*) => Send("{Ctrl}{" AdvancedKey "}")),
					;"!" UseKey[DefaultKey], (*) => CapsSeparatedCall((*) => Send("{Alt}{" DefaultKey "}"), (*) => Send("{Alt}{" AdvancedKey "}")),
					;"<#" UseKey[DefaultKey], (*) => CapsSeparatedCall((*) => Send("{LWin}{" DefaultKey "}"), (*) => Send("{LWin}{" AdvancedKey "}")),
					;">#" UseKey[DefaultKey], (*) => CapsSeparatedCall((*) => Send("{RWin}{" DefaultKey "}"), (*) => Send("{RWin}{" AdvancedKey "}")),
				)
			}

			for numberValue in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] {
				FunctionKeysBridge(numberValue)
			}
		}

		LayoutArray := ArrayMerge(FunctionKeysExtraLayer, [
			;
			"<#<!" UseKey["F1"], (*) => GroupActivator("Diacritics Primary", "F1"),
			"<#<!" UseKey["F2"], (*) => GroupActivator("Diacritics Secondary", "F2"),
			"<#<!" UseKey["F3"], (*) => GroupActivator("Diacritics Tertiary", "F3"),
			"<#<!" UseKey["F6"], (*) => GroupActivator("Diacritics Quatemary", "F6"),
			"<#<!" UseKey["F7"], (*) => GroupActivator("Special Characters", "F7"),
			"<#<!" UseKey["Space"], (*) => GroupActivator("Spaces"),
			"<#<!" UseKey["Minus"], (*) => GroupActivator("Dashes", "-"),
			"<#<!" UseKey["Apostrophe"], (*) => GroupActivator("Quotes", "'"),
			;
			"<#<!" UseKey["F"], (*) => ChrLib.SearchPrompt().send(), ;SearchKey(),
			"<#<!" UseKey["U"], (*) => CharacterInserter("Unicode").InputDialog(),
			"<#<!" UseKey["A"], (*) => CharacterInserter("Altcode").InputDialog(),
			"<#<!" UseKey["L"], (*) => ChrCrafter(),
			">^" UseKey["H"], (*) => TranslateSelectionToHTML("Entities"),
			">^" UseKey["J"], (*) => TranslateSelectionToHTML("Entities", True),
			">^>+" UseKey["H"], (*) => TranslateSelectionToHTML(),
			"<#<^>!" UseKey["1"], (*) => SwitchToScript("sup"),
			"<#<^>!" UseKey["2"], (*) => SwitchToScript("sub"),
			"<#<^>!" UseKey["3"], (*) => SwitchToRoman(),
			"<#<!" UseKey["M"], (*) => ToggleGroupMessage(),
			"<#<!" UseKey["PgUp"], (*) => FindCharacterPage(),
			">^" UseKey["U"], (*) => ReplaceWithUnicode(),
			">^" UseKey["Y"], (*) => ReplaceWithUnicode("CSS"),
			">^" UseKey["I"], (*) => ReplaceWithUnicode("Hex"),
			"<#<!" UseKey["Home"], (*) => OpenPanel(),
			"<^>!>+" UseKey["F1"], (*) => ToggleInputMode(),
			"<^>!" UseKey["F1"], (*) => ToggleFastKeys(),
			"<^>!" UseKey["F2"], (*) => InputScriptProcessor(),
			"<^>!>+" UseKey["F2"], (*) => InputScriptProcessor("pinYin"),
			"<^>!<+" UseKey["F2"], (*) => InputScriptProcessor("karaShiki"),
			"<^>!<!" UseKey["F2"], (*) => InputScriptProcessor("autoDiacritics"),
			;
			"<^<!" UseKey["Numpad1"], (*) => SetModifiedCharsInput(),
			"<^<!<+" UseKey["Numpad1"], (*) => SetModifiedCharsInput("modifier"),
			"<^<!>+" UseKey["Numpad1"], (*) => SetModifiedCharsInput("subscript"),
			"<^<!" UseKey["Numpad2"], (*) => SetModifiedCharsInput("italic"),
			"<^<!>+" UseKey["Numpad2"], (*) => SetModifiedCharsInput("italicBold"),
			"<^<!<+" UseKey["Numpad2"], (*) => SetModifiedCharsInput("bold"),
			"<^<!" UseKey["Numpad3"], (*) => SetModifiedCharsInput("fraktur"),
			"<^<!<+" UseKey["Numpad3"], (*) => SetModifiedCharsInput("frakturBold"),
			"<^<!" UseKey["Numpad4"], (*) => SetModifiedCharsInput("script"),
			"<^<!<+" UseKey["Numpad4"], (*) => SetModifiedCharsInput("scriptBold"),
			"<^<!" UseKey["Numpad5"], (*) => SetModifiedCharsInput("doubleStruck"),
			"<^<!<+" UseKey["Numpad5"], (*) => SetModifiedCharsInput("doubleStruckItalic"),
			"<^<!" UseKey["Numpad6"], (*) => SetModifiedCharsInput("sansSerifItalic"),
			"<^<!>+" UseKey["Numpad6"], (*) => SetModifiedCharsInput("sansSerifItalicBold"),
			"<^<!<+" UseKey["Numpad6"], (*) => SetModifiedCharsInput("sansSerifBold"),
			"<^<!<+>+" UseKey["Numpad6"], (*) => SetModifiedCharsInput("sansSerif"),
			"<^<!" UseKey["Numpad7"], (*) => SetModifiedCharsInput("monospace"),
			"<^<!" UseKey["Numpad8"], (*) => SetModifiedCharsInput("smallCapital"),
			"<^<!" UseKey["Numpad9"], (*) => SetModifiedCharsInput("uncombined"),
			;
			">^" UseKey["F12"], (*) => SwitchQWERTY_YITSUKEN(),
			">+" UseKey["F12"], (*) => SwitchQWERTY_YITSUKEN("Cyrillic"),
			"<!" UseKey["Q"], (*) => LangSeparatedCall(
				() => QuotatizeSelection("Double"),
				() => QuotatizeSelection("France")),
			"<!<+" UseKey["Q"], (*) => LangSeparatedCall(
				() => QuotatizeSelection("Single"),
				() => QuotatizeSelection("Paw")),
			">^" UseKey["NumpadEnter"], (*) => ParagraphizeSelection(),
			">^" UseKey["NumpadDot"], (*) => GREPizeSelection(),
			"<^>!" UseKey["NumpadDot"], (*) => GREPizeSelection(True),
			"<#<!" UseKey["ArrUp"], (*) => SetNumberStyle("sup"),
			"<#<!" UseKey["ArrDown"], (*) => SetNumberStyle("sub"),
			">^" UseKey["Tilde"], (*) => CapsSeparatedCall((*) => ToggleLetterScript(, "Hellenic"), (*) => ToggleLetterScript(, "Hellenic")),
			">^" UseKey["1"], (*) => CapsSeparatedCall((*) => ToggleLetterScript(, "Glagolitic Futhark"), (*) => ToggleLetterScript(, "Old Turkic Old Permic")),
			">^" UseKey["2"], (*) => CapsSeparatedCall((*) => ToggleLetterScript(, "Old Hungarian"), (*) => ToggleLetterScript(, "Gothic")),
			">^" UseKey["3"], (*) => CapsSeparatedCall((*) => ToggleLetterScript(, "Old Italic"), (*) => ToggleLetterScript(, "Phoenician")),
			">^" UseKey["4"], (*) => CapsSeparatedCall((*) => ToggleLetterScript(, "Ancient South Arabian"), (*) => ToggleLetterScript(, "Ancient North Arabian")),
			">^" UseKey["0"], (*) => CapsSeparatedCall((*) => ToggleLetterScript(, "IPA"), (*) => ToggleLetterScript(, "Maths")),
			;
			"RAlt", (*) => ProceedCompose(),
			;"RCtrl", (*) => ProceedCombining(),
			;"RShift", (*) => ProceedModifiers(),
			;
			"<!" UseKey["NumpadAdd"], (*) => CharacterInserter().NumHook(),
			"<!" UseKey["NumpadMult"], (*) => CharacterInserter("Altcode").NumHook(),
			;
			"<#<+" UseKey["PgUp"], (*) => SendCharToPy(),
			"<#<^<+" UseKey["PgUp"], (*) => SendCharToPy("Copy"),
			;
		])
	}


	return LayoutArray
}

RecoveryKey(KeySC, Shift := False) {
	KeySCCode := RegExReplace(LayoutsPresets["QWERTY"][KeySC], "SC")

	if Shift {
		Send("{Blind}+{sc" KeySCCode "}")
	} else {
		Send("{Blind}{sc" KeySCCode "}")
	}
}

EmptyFunc() {
	return
}

TimedKeyCombinationsIH(StartKey, SecondKeys, Callbacks, DefaultCallback := False, TimerLimit := -25) {

}

TimedKeyCombinations(StartKey, SecondKeys, Callbacks, DefaultCallback := False, TimerLimit := -25) {
	global IsCombinationPressed
	SCEntry := RegExReplace(StartKey, "^\+")
	IsShiftOn := RegExMatch(StartKey, "^\+")
	IsCombinationPressed := False


	if IsObject(SecondKeys) {
		for i, SecondKey in SecondKeys {
			if (GetKeyState(SecondKey, "P")) {
				if Callbacks[i] = "Off" {
					return
				} else {
					Callbacks[i]()
					IsCombinationPressed := True
					SetTimer(ResetDefault, 0)
					return
				}
			}
		}
	} else {
		if (GetKeyState(SecondKeys, "P")) {
			if Callbacks = "Off"
				return
			Callbacks()
			IsCombinationPressed := True
			SetTimer(ResetDefault, 0)
			return
		}
	}

	SetTimer(ResetDefault, TimerLimit)

	ResetDefault() {
		global IsCombinationPressed
		if !IsCombinationPressed {
			if !DefaultCallback {
				RecoveryKey(SCEntry, IsShiftOn)
			} else {
				DefaultCallback()
			}
		}
		IsCombinationPressed := False
		return
	}
}


RAltsCount := 0
RAltsTimerEnds := False
RAltsTimer := ""

ProceedCompose() {
	global RAltsTimerEnds, RAltsCount

	if (RAltsTimerEnds) {
		return
	}

	if RAltsCount = 1 {
		RAltsCount := 0
		ChrCrafter("Compose")
		return
	} else {
		RAltsCount++
		RAltsEndingTimer()
	}
}
RAltsEndingTimer() {
	global RAltsTimer
	if (RAltsTimer != "") {
		SetTimer(RAltsSetStats, 0)
		RAltsTimer := ""
	}

	return SetTimer(RAltsSetStats, -300)
}

RAltsSetStats() {
	global RAltsCount, RAltsTimerEnds
	RAltsCount := 0
	RAltsTimerEnds := True
	Sleep 100
	RAltsTimerEnds := False
}


SetModifiedCharsInput(ModeName := "combining") {
	global AlterationActiveName

	AlterationActiveName := ModeName = AlterationActiveName ? "" : ModeName

	if AlterationActiveName != "" {
		RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"), , True)
		ShowInfoMessage("message_" ModeName, , , Cfg.SkipGroupMessage, True)
	} else {
		RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
		ShowInfoMessage("message_" ModeName "_disabled", , , Cfg.SkipGroupMessage, True)
	}

}

GetModifiedCharsType() {
	return AlterationActiveName != "" ? AlterationActiveName : False
}

RShiftEndingTimer() {
	global RCtrlTimer
	if (RCtrlTimer != "") {
		SetTimer(RAltsSetStats, 0)
		RCtrlTimer := ""
	}

	return SetTimer(RAltsSetStats, -300)
}


RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))

ShowInfoMessage(MessagePost, MessageIcon := "Info", MessageTitle := DSLPadTitle, SkipMessage := False, Mute := False, NoReadLocale := False) {
	if SkipMessage == True
		return
	LanguageCode := Language.Get()
	Muting := Mute ? " Mute" : ""
	Ico := MessageIcon == "Info" ? "Iconi" :
		MessageIcon == "Warning" ? "Icon!" :
		MessageIcon == "Error" ? "Iconx" : 0x0
	TrayTip(NoReadLocale ? MessagePost : Locale.Read(MessagePost), MessageTitle, Ico . Muting)

}


ReloadApplication(*) {
	Reload
}
ExitApplication(*) {
	ExitApp
}
OpenScriptFolder(*) {
	Run A_ScriptDir
}

ManageTrayItems() {
	LanguageCode := Language.Get()
	Labels := Map(
		"reload", Locale.Read("tray_func_reload"),
		"config", Locale.Read("tray_func_config"),
		"locale", Locale.Read("tray_func_locale"),
		"custom_compose", Locale.Read("tray_func_custom_compose"),
		"exit", Locale.Read("tray_func_exit") "`t" LeftControl RightShift "Esc",
		"panel", Locale.Read("tray_func_panel") "`t" Window LeftAlt "Home",
		"options", Locale.Read("gui_options"),
		"install", Locale.Read("tray_func_install"),
		"search", Locale.Read("tray_func_search") "`t" Window LeftAlt "F",
		"open_folder", Locale.Read("tray_func_open_folder"),
		"smelter", Locale.Read("tray_func_smelter") "`t" Window LeftAlt "L",
		"unicode", Locale.Read("tray_func_unicode") "`t" Window LeftAlt "U",
		"altcode", Locale.Read("tray_func_altcode") "`t" Window LeftAlt "A",
		"notif", Locale.Read("tray_func_notif") "`t" Window LeftAlt "M",
		"disable", Locale.Read("tray_func_disable") "`t" RightControl "F10",
		"enable", Locale.Read("tray_func_enable") "`t" RightControl "F10",
		"altInput", Locale.Read("tray_func_altInput"),
		"glagolitic", Locale.Read("tray_func_glagolitic_runic") "`t" RightControl "1",
		"turkic", Locale.Read("tray_func_tukic_permic") "`t" CapsLock RightControl "1",
		"hungarian", Locale.Read("tray_func_hungarian") "`t" RightControl "2",
		"gothic", Locale.Read("tray_func_gothic") "`t" CapsLock RightControl "2",
		"italic", Locale.Read("tray_func_old_italic") "`t" RightControl "3",
		"phoenician", Locale.Read("tray_func_phoenician") "`t" CapsLock RightControl "3",
		"south_arabian", Locale.Read("tray_func_ancient_south_arabian") "`t" RightControl "4",
		"north_arabian", Locale.Read("tray_func_ancient_north_arabian") "`t" CapsLock RightControl "4",
		"ipa", Locale.Read("tray_func_ipa") "`t" RightControl "0",
		"maths", Locale.Read("tray_func_maths") "`t" CapsLock RightControl "0",
		"script", Locale.Read("func_label_scripts"),
		"telexInput", Locale.Read("tray_func_telexlike"),
		"telex_advanced_mode", Locale.Read("tray_func_telex_advanced_mode"),
		"vietNam", Locale.Read("tray_func_vietNam") "`t" RightAlt "F2",
		"pinYin", Locale.Read("tray_func_pinYin") "`t" RightAlt RightShift "F2",
		"layouts", Locale.Read("func_label_layouts"),
		"alterations", Locale.Read("func_label_alterations"),
		"combining_alteration", Locale.Read("tray_func_combining_alteration") "`t" LeftControl LeftAlt "Num1",
		"modifier_alteration", Locale.Read("tray_func_modifier_alteration") "`t" LeftControl LeftAlt LeftShift "Num1",
		"subscript_alteration", Locale.Read("tray_func_subscript_alteration") "`t" LeftControl LeftAlt RightShift "Num1",
		"italic_alteration", Locale.Read("tray_func_italic_alteration") "`t" LeftControl LeftAlt "Num2",
		"bold_alteration", Locale.Read("tray_func_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num2",
		"italic_bold_alteration", Locale.Read("tray_func_italic_bold_alteration") "`t" LeftControl LeftAlt RightShift "Num2",
		"fraktur_alteration", Locale.Read("tray_func_fraktur_alteration") "`t" LeftControl LeftAlt "Num3",
		"fraktur_bold_alteration", Locale.Read("tray_func_fraktur_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num3",
		"script_alteration", Locale.Read("tray_func_script_alteration") "`t" LeftControl LeftAlt "Num4",
		"script_bold_alteration", Locale.Read("tray_func_script_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num4",
		"double_struck_alteration", Locale.Read("tray_func_double_struck_alteration") "`t" LeftControl LeftAlt "Num5",
		"double_struck_italic_alteration", Locale.Read("tray_func_double_struck_italic_alteration") "`t" LeftControl LeftAlt LeftShift "Num5",
		"sans_serif_italic_alteration", Locale.Read("tray_func_sans_serif_italic_alteration") "`t" LeftControl LeftAlt "Num6",
		"sans_serif_bold_alteration", Locale.Read("tray_func_sans_serif_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num6",
		"sans_serif_italic_bold_alteration", Locale.Read("tray_func_sans_serif_italic_bold_alteration") "`t" LeftControl LeftAlt RightShift "Num6",
		"sans_serif_alteration", Locale.Read("tray_func_sans_serif_alteration") "`t" LeftControl LeftAlt LeftShift RightShift "Num6",
		"monospace_alteration", Locale.Read("tray_func_monospace_alteration") "`t" LeftControl LeftAlt "Num7",
		"small_capital_alteration", Locale.Read("tray_func_small_capital_alteration") "`t" LeftControl LeftAlt "Num8",
	)

	CurrentApp := "DSL KeyPad " . CurrentVersionString
	UpdateEntry := Labels["install"] . " " . UpdateVersionString

	App.tray.Delete()
	App.tray.Add(CurrentApp, (*) => Run("https://github.com/DemerNkardaz/DSL-KeyPad/tree/main"))
	if UpdateAvailable {
		App.tray.Add(UpdateEntry, (*) => "GetUpdate()")
		App.tray.SetIcon(UpdateEntry, ImageRes, 176)
	}
	App.tray.Add()
	App.tray.Add(Labels["panel"], OpenPanel)
	App.tray.Add(Labels["options"], (*) => Cfg.Editor())
	App.tray.Add()


	App.tray.SetIcon(Labels["options"], ImageRes, 63)

	ScriptsSubMenu := Menu()
	ScriptsSubMenu.Add(Labels["telexInput"], (*) => "")
	ScriptsSubMenu.Add(Labels["telex_advanced_mode"], (*) => Cfg.SwitchSet(["True", "False"], "Advanced_Mode", "ScriptProcessor", "bind"))
	ScriptsSubMenu.Add(Labels["vietNam"], (*) => InputScriptProcessor())
	ScriptsSubMenu.Add(Labels["pinYin"], (*) => InputScriptProcessor("pinYin"))
	ScriptsSubMenu.Add()
	ScriptsSubMenu.Add(Labels["altInput"], (*) => "")
	ScriptsSubMenu.Add(Labels["glagolitic"], (*) => ToggleLetterScript(, "Glagolitic Futhark"))
	ScriptsSubMenu.Add(Labels["turkic"], (*) => ToggleLetterScript(, "Old Turkic Old Permic"))
	ScriptsSubMenu.Add(Labels["hungarian"], (*) => ToggleLetterScript(, "Old Hungarian"))
	ScriptsSubMenu.Add(Labels["gothic"], (*) => ToggleLetterScript(, "Gothic"))
	ScriptsSubMenu.Add(Labels["italic"], (*) => ToggleLetterScript(, "Old Italic"))
	ScriptsSubMenu.Add(Labels["phoenician"], (*) => ToggleLetterScript(, "Phoenician"))
	ScriptsSubMenu.Add(Labels["south_arabian"], (*) => ToggleLetterScript(, "Ancient South Arabian"))
	ScriptsSubMenu.Add(Labels["north_arabian"], (*) => ToggleLetterScript(, "Ancient North Arabian"))
	ScriptsSubMenu.Add(Labels["ipa"], (*) => ToggleLetterScript(, "IPA"))
	ScriptsSubMenu.Add(Labels["maths"], (*) => ToggleLetterScript(, "Maths"))

	ScriptsSubMenu.SetIcon(Labels["vietNam"], InternalFiles["AppIcoDLL"].File, 11)
	ScriptsSubMenu.SetIcon(Labels["pinYin"], InternalFiles["AppIcoDLL"].File, 12)
	ScriptsSubMenu.SetIcon(Labels["glagolitic"], InternalFiles["AppIcoDLL"].File, 2)
	ScriptsSubMenu.SetIcon(Labels["turkic"], InternalFiles["AppIcoDLL"].File, 4)
	ScriptsSubMenu.SetIcon(Labels["hungarian"], InternalFiles["AppIcoDLL"].File, 6)
	ScriptsSubMenu.SetIcon(Labels["gothic"], InternalFiles["AppIcoDLL"].File, 7)
	ScriptsSubMenu.SetIcon(Labels["italic"], InternalFiles["AppIcoDLL"].File, 13)
	ScriptsSubMenu.SetIcon(Labels["phoenician"], InternalFiles["AppIcoDLL"].File, 14)
	ScriptsSubMenu.SetIcon(Labels["south_arabian"], InternalFiles["AppIcoDLL"].File, 15)
	ScriptsSubMenu.SetIcon(Labels["north_arabian"], InternalFiles["AppIcoDLL"].File, 16)
	ScriptsSubMenu.SetIcon(Labels["maths"], InternalFiles["AppIcoDLL"].File, 10)
	ScriptsSubMenu.SetIcon(Labels["ipa"], InternalFiles["AppIcoDLL"].File, 8)

	ScriptsSubMenu.Disable(Labels["telexInput"])
	ScriptsSubMenu.Disable(Labels["altInput"])

	App.tray.Add(Labels["script"], ScriptsSubMenu)

	AlterationSubMenu := Menu()
	AlterationSubMenu.Add(Labels["combining_alteration"], (*) => SetModifiedCharsInput())
	AlterationSubMenu.Add(Labels["modifier_alteration"], (*) => SetModifiedCharsInput("modifier"))
	AlterationSubMenu.Add(Labels["subscript_alteration"], (*) => SetModifiedCharsInput("subscript"))
	AlterationSubMenu.Add()
	AlterationSubMenu.Add(Labels["italic_alteration"], (*) => SetModifiedCharsInput("italic"))
	AlterationSubMenu.Add(Labels["italic_bold_alteration"], (*) => SetModifiedCharsInput("italicBold"))
	AlterationSubMenu.Add(Labels["bold_alteration"], (*) => SetModifiedCharsInput("bold"))
	AlterationSubMenu.Add()
	AlterationSubMenu.Add(Labels["fraktur_alteration"], (*) => SetModifiedCharsInput("fraktur"))
	AlterationSubMenu.Add(Labels["fraktur_bold_alteration"], (*) => SetModifiedCharsInput("frakturBold"))
	AlterationSubMenu.Add()
	AlterationSubMenu.Add(Labels["script_alteration"], (*) => SetModifiedCharsInput("script"))
	AlterationSubMenu.Add(Labels["script_bold_alteration"], (*) => SetModifiedCharsInput("scriptBold"))
	AlterationSubMenu.Add()
	AlterationSubMenu.Add(Labels["double_struck_alteration"], (*) => SetModifiedCharsInput("doubleStruck"))
	AlterationSubMenu.Add(Labels["double_struck_italic_alteration"], (*) => SetModifiedCharsInput("doubleStruckItalic"))
	AlterationSubMenu.Add()
	AlterationSubMenu.Add(Labels["sans_serif_italic_alteration"], (*) => SetModifiedCharsInput("sansSerifItalic"))
	AlterationSubMenu.Add(Labels["sans_serif_italic_bold_alteration"], (*) => SetModifiedCharsInput("sansSerifItalicBold"))
	AlterationSubMenu.Add(Labels["sans_serif_bold_alteration"], (*) => SetModifiedCharsInput("sansSerifBold"))
	AlterationSubMenu.Add(Labels["sans_serif_alteration"], (*) => SetModifiedCharsInput("sansSerif"))
	AlterationSubMenu.Add()
	AlterationSubMenu.Add(Labels["monospace_alteration"], (*) => SetModifiedCharsInput("monospace"))
	AlterationSubMenu.Add(Labels["small_capital_alteration"], (*) => SetModifiedCharsInput("smallCapital"))

	App.tray.Add(Labels["alterations"], AlterationSubMenu)

	LayoutsSubMenu := Menu()
	LayoutsSubMenu.Add("QWERTY", (*) => RegisterLayout("QWERTY"))
	LayoutsSubMenu.Add("Dvorak", (*) => RegisterLayout("Dvorak"))
	LayoutsSubMenu.Add("Colemak", (*) => RegisterLayout("Colemak"))
	LayoutsSubMenu.Add()
	LayoutsSubMenu.Add("ЙЦУКЕН", (*) => RegisterLayout("ЙЦУКЕН"))
	LayoutsSubMenu.Add("Диктор", (*) => RegisterLayout("Диктор"))
	LayoutsSubMenu.Add("ЙІУКЕН (1907)", (*) => RegisterLayout("ЙІУКЕН (1907)"))

	App.tray.Add(Labels["layouts"], LayoutsSubMenu)

	App.tray.Add()
	App.tray.Add(Labels["search"], (*) => SearchKey())
	App.tray.Add(Labels["unicode"], (*) => CharacterInserter("Unicode").InputDialog(False))
	App.tray.Add(Labels["altcode"], (*) => CharacterInserter("Altcode").InputDialog(False))
	App.tray.Add(Labels["smelter"], (*) => ChrCrafter())
	App.tray.Add(Labels["open_folder"], OpenScriptFolder)
	App.tray.Add()
	App.tray.Add(Labels["notif"], (*) => ToggleGroupMessage())
	App.tray.Add()
	App.tray.Add(Labels["reload"], ReloadApplication)
	App.tray.Add(Labels["config"], OpenConfigFile)
	App.tray.Add(Labels["locale"], OpenLocalesFile)
	App.tray.Add()
	App.tray.Add(Labels["custom_compose"], (*) => Cfg.SubGUIs("Recipes"))
	App.tray.Add()
	if Keyboard.disabledByMonitor || Keyboard.disabledByUser {
		App.tray.Add(Labels["enable"], (*) => Keyboard.BindingsToggle(Keyboard.disabledByUser = !False ? True : False, "disabledByUser", "disabledByMonitor"))
		App.tray.SetIcon(Labels["enable"], InternalFiles["AppIcoDLL"].File, 9)
	} else {

		App.tray.Add(Labels["disable"], (*) => Keyboard.BindingsToggle(Keyboard.disabledByUser = !False ? True : False, "disabledByUser", "disabledByMonitor"))
		App.tray.SetIcon(Labels["disable"], InternalFiles["AppIcoDLL"].File, 9)
	}
	App.tray.Add()
	App.tray.Add(Labels["exit"], ExitApplication)
	App.tray.Add()

	App.tray.SetIcon(CurrentApp, InternalFiles["AppIco"].File)
	App.tray.SetIcon(Labels["search"], ImageRes, 169)
	App.tray.SetIcon(Labels["unicode"], Shell32, 225)
	App.tray.SetIcon(Labels["altcode"], Shell32, 313)
	App.tray.SetIcon(Labels["smelter"], ImageRes, 151)
	App.tray.SetIcon(Labels["open_folder"], ImageRes, 180)
	App.tray.SetIcon(Labels["notif"], ImageRes, 016)
	App.tray.SetIcon(Labels["reload"], ImageRes, 229)
	App.tray.SetIcon(Labels["config"], ImageRes, 065)
	App.tray.SetIcon(Labels["locale"], ImageRes, 015)
	App.tray.SetIcon(Labels["custom_compose"], ImageRes, 188)
	App.tray.SetIcon(Labels["exit"], ImageRes, 085)

}

ManageTrayItems()

ShowInfoMessage("tray_app_started")

#Include <stc_bindings>

;ApplicationEnd
