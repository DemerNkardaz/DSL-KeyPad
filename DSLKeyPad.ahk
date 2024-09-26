#Requires Autohotkey v2
#SingleInstance Force

; Only EN US & RU RU Keyboard Layout


SupportedLanguages := [
	"en",
	"ru",
]

CodeEn := "00000409"
CodeRu := "00000419"

ChracterMap := "C:\Windows\System32\charmap.exe"
ImageRes := "C:\Windows\System32\imageres.dll"
Shell32 := "C:\Windows\SysWOW64\shell32.dll"

AppVersion := [0, 1, 1, 0]
CurrentVersionString := Format("{:d}.{:d}.{:d}", AppVersion[1], AppVersion[2], AppVersion[3])
UpdateVersionString := ""

RawRepo := "https://raw.githubusercontent.com/DemerNkardaz/DSL-KeyPad/main/"
RawRepoFiles := RawRepo . "UtilityFiles/"
RepoSource := "https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/DSLKeyPad.ahk"

RawSource := RawRepo . "DSLKeyPad.ahk"
UpdateAvailable := False

ChangeLogRaw := Map(
	"ru", RawRepoFiles . "DSLKeyPad.Changelog.ru.md",
	"en", RawRepoFiles . "DSLKeyPad.Changelog.en.md"
)

LocalesRaw := RawRepoFiles . "DSLKeyPad.locales.ini"
AppIcoRaw := RawRepoFiles . "DSLKeyPad.app.ico"

WorkingDir := A_MyDocuments . "\DSLKeyPad"
DirCreate(WorkingDir)

ConfigFile := WorkingDir . "\DSLKeyPad.config.ini"
LocalesFile := WorkingDir . "\DSLKeyPad.locales.ini"
AppIcoFile := WorkingDir . "\DSLKeyPad.app.ico"

DSLPadTitle := "DSL KeyPad (αλφα)" . " — " . CurrentVersionString
DSLPadTitleDefault := "DSL KeyPad"
DSLPadTitleFull := "Diacritics-Spaces-Letters KeyPad"

GetLocales() {
	global LocalesRaw
	ErrMessages := Map(
		"ru", "Произошла ошибка при получении файла перевода.`nСервер недоступен или ошибка соединения с интернетом.",
		"en", "An error occured during receiving locales file.`nServer unavailable or internet connection error."
	)
	http := ComObject("WinHttp.WinHttpRequest.5.1")
	http.Open("GET", LocalesRaw, true)
	try {
		http.Send()
		http.WaitForResponse()
	} catch {
		MsgBox(ErrMessages[GetLanguageCode()], DSLPadTitle)
		return
	}

	if http.Status != 200 {
		MsgBox(ErrMessages[GetLanguageCode()], DSLPadTitle)
		return
	}

	Download(LocalesRaw, LocalesFile)
}

if !FileExist(LocalesFile) {
	GetLocales()
}

ReadLocale(EntryName, Prefix := "") {
	global LocalesFile
	Section := Prefix != "" ? Prefix . "_" . GetLanguageCode() : GetLanguageCode()
	Intermediate := IniRead(LocalesFile, Section, EntryName, "")

	while (RegExMatch(Intermediate, "\{U\+(\w+)\}", &match)) {
		Unicode := match[1]
		Replacement := Chr("0x" . Unicode)
		Intermediate := StrReplace(Intermediate, match[0], Replacement)
	}

	while (RegExMatch(Intermediate, "\{([a-zA-Z]{2})\}", &match)) {
		LangCode := match[1]
		SectionOverride := Prefix != "" ? Prefix . "_" . LangCode : LangCode
		Replacement := IniRead(LocalesFile, SectionOverride, EntryName, "")
		Intermediate := StrReplace(Intermediate, match[0], Replacement)
	}

	while (RegExMatch(Intermediate, "\{(?:([^\}_]+)_)?([a-zA-Z]{2}):([^\}]+)\}", &match)) {
		CustomPrefix := match[1] ? match[1] : ""
		LangCode := match[2]
		CustomEntry := match[3]
		SectionOverride := CustomPrefix != "" ? CustomPrefix . "_" . LangCode : LangCode
		Replacement := IniRead(LocalesFile, SectionOverride, CustomEntry, "")
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
	Intermediate := Intermediate != "" ? Intermediate : "KEY (" . EntryName . "): NOT FOUND"
	return Intermediate
}

SetStringVars(StringVar, SetVars*) {
	Result := StringVar
	for index, value in SetVars {
		Result := StrReplace(Result, "{" (index - 1) "}", value)
	}
	return Result
}

GetAppIco() {
	global AppIcoRaw, AppIcoFile
	ErrMessages := Map(
		"ru", "Произошла ошибка при получении иконки приложения.`nСервер недоступен или ошибка соединения с интернетом.",
		"en", "An error occured during receiving app icon.`nServer unavailable or internet connection error."
	)
	http := ComObject("WinHttp.WinHttpRequest.5.1")
	http.Open("GET", AppIcoRaw, true)
	try {
		http.Send()
		http.WaitForResponse()
	} catch {
		MsgBox(ErrMessages[GetLanguageCode()], DSLPadTitle)
		return
	}

	if http.Status != 200 {
		MsgBox(ErrMessages[GetLanguageCode()], DSLPadTitle)
		return
	}

	Download(AppIcoRaw, AppIcoFile)
}

if !FileExist(AppIcoFile) {
	GetAppIco()
}

OpenConfigFile(*) {
	global ConfigFile
	Run(ConfigFile)
}

OpenLocalesFile(*) {
	global LocalesFile
	Run(LocalesFile)
}

EscapePressed := False

FastKeysIsActive := False
SkipGroupMessage := False
GlagoFutharkActive := False
CombiningEnabled := False
DisabledAllKeys := False
InputMode := "Default"
LaTeXMode := "common"

DefaultConfig := [
	["Settings", "FastKeysIsActive", "False"],
	["Settings", "SkipGroupMessage", "False"],
	["Settings", "InputMode", "Default"],
	["Settings", "ScriptInput", "Default"],
	["Settings", "UserLanguage", ""],
	["Settings", "LatinLayout", "QWERTY"],
	["Settings", "CyrillicLayout", "ЙЦУКЕН"],
	["CustomRules", "ParagraphBeginning", ""],
	["CustomRules", "ParagraphAfterStartEmdash", ""],
	["CustomRules", "GREPDialogAttribution", ""],
	["CustomRules", "GREPThisEmdash", ""],
	["CustomRules", "GREPInitials", ""],
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
	isSkipGroupMessage := IniRead(ConfigFile, "Settings", "SkipGroupMessage", "False")
	InputMode := IniRead(ConfigFile, "Settings", "InputMode", "Default")
	LaTeXMode := IniRead(ConfigFile, "Settings", "LaTeXMode", "common")

	FastKeysIsActive := (isFastKeysEnabled = "True")
	SkipGroupMessage := (isSkipGroupMessage = "True")
} else {
	for index, config in DefaultConfig {
		IniWrite config[3], ConfigFile, config[1], config[2]
	}
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

IsFont(FontName)
{
	Loop Reg, "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" {

		if (RegExMatch(A_LoopRegName, "^" FontName "(?:\sRegular)")) {
			return true
		}
	}

	return false
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
		MsgBox(ReadLocale("prepare_fonts") NamesToBeInstalled, DSLPadTitle)

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
		MsgBox("Can’t download font.`n" ReadLocale("prepare_fonts"), "Font Installer")
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
Sleep 150
PreviousLayout := IniRead(ConfigFile, "ServiceFields", "PrevLayout", "")
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
		return ReadLocale("warning_nointernet")
	}

	for language, url in ChangeLogRaw {
		http.Open("GET", url, true)
		try {
			http.Send()
			http.WaitForResponse()
		} catch {
			return ReadLocale("warning_nointernet")
		}

		if http.Status != 200 || Cancelled {
			if Cancelled {
				http.Abort()
				return ReadLocale("warning_nointernet")
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
		ver: IniRead(LocalesFile, LanguageCode, "version", ""),
		date: IniRead(LocalesFile, LanguageCode, "date", ""),
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

CheckUpdateError := ""
GetUpdate(TimeOut := 0, RepairMode := False) {
	Sleep TimeOut
	global AppVersion, RawSource
	ErrorOccured := False
	ErroMessage := ""

	if RepairMode == True {
		IB := InputBox(ReadLocale("update_repair"), ReadLocale("update_repair_title"), "w256", "")
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
			MsgBox(ReadLocale("update_failed"), DSLPadTitle)
			return
		}

		if http.Status != 200 {
			MsgBox(ReadLocale("update_failed"), DSLPadTitle)
			return
		}

		CurrentFilePath := A_ScriptFullPath
		CurrentFileName := StrSplit(CurrentFilePath, "\").Pop()
		UpdateFilePath := A_ScriptDir "\DSLKeyPad.ahk-GettingUpdate"

		Download(RawSource, UpdateFilePath)

		FileMove(CurrentFilePath, A_ScriptDir "\" CurrentFileName "-Backup-" GetTimeString())

		FileMove(UpdateFilePath, A_ScriptDir "\" CurrentFileName)

		GetLocales()
		GetAppIco()

		if RepairMode == True {
			MsgBox(ReadLocale("update_repair_success"), DSLPadTitle)
		} else {
			MsgBox(SetStringVars(ReadLocale("update_successful"), CurrentVersionString, UpdateVersionString), DSLPadTitle)
		}

		Reload
		return
	} else {
		if CheckUpdateError != "" {
			MsgBox(CheckUpdateError, DSLPadTitle)
		} else {
			MsgBox(ReadLocale("update_absent"), DSLPadTitle)
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
		CheckUpdateError := ReadLocale("update_failed")
		return
	}

	if http.Status != 200 {
		CheckUpdateError := ReadLocale("update_failed")
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
InformationSymbol := "ⓘ"
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

RegisterLayout(LayoutName := "QWERTY") {
	global GlagoFutharkActive, DisabledAllKeys

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

	if DisabledAllKeys {
		if IsLatin {
			IniWrite LayoutName, ConfigFile, "Settings", "LatinLayout"
		} else if IsCyrillic {
			IniWrite LayoutName, ConfigFile, "Settings", "CyrillicLayout"
		}
		return
	} else {
		if IsLatin {
			IniWrite LayoutName, ConfigFile, "Settings", "LatinLayout"

			UnregisterKeysLayout()
			if (LayoutName != "QWERTY") {
				RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "NonQWERTY"))
			}

			IsLettersModeEnabled := GlagoFutharkActive

			Sleep 250
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Utility"))
			Sleep 25
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))

			if IsLettersModeEnabled {
				Sleep 50
				GlagoFutharkActive := False
				ToggleLetterScript(True)
			}
		} else if IsCyrillic {
			IniWrite LayoutName, ConfigFile, "Settings", "CyrillicLayout"
			UnregisterKeysLayout()

			if (ActiveLatin != "QWERTY") || (LayoutName != "ЙЦУКЕН") {
				RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "NonQWERTY"))
			}

			IsLettersModeEnabled := GlagoFutharkActive

			Sleep 250
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Utility"))
			Sleep 25
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))

			if IsLettersModeEnabled {
				Sleep 50
				GlagoFutharkActive := False
				ToggleLetterScript(True)
			}
		} else {
			return
		}
	}
}

GetLayoutsList := []
for layout in LayoutsPresets {
	GetLayoutsList.Push(layout)
}

CyrillicLayoutsList := ["ЙЦУКЕН"]


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


FormatHotKey(HKey, Modifier := "") {
	MakeString := ""

	SpecialCommandsMap := Map(
		CtrlA, LeftControl " [a][ф]", CtrlB, LeftControl " [b][и]", CtrlC, LeftControl " [c][с]", CtrlD, LeftControl " [d][в]", CtrlE, LeftControl " [e][у]", CtrlF, LeftControl " [f][а]", CtrlG, LeftControl " [g][п]",
		CtrlH, LeftControl " [h][р]", CtrlI, LeftControl " [i][ш]", CtrlJ, LeftControl " [j][о]", CtrlK, LeftControl " [k][л]", CtrlL, LeftControl " [l][д]", CtrlM, LeftControl " [m][ь]", CtrlN, LeftControl " [n][т]",
		CtrlO, LeftControl " [o][щ]", CtrlP, LeftControl " [p][з]", CtrlQ, LeftControl " [q][й]", CtrlR, LeftControl " [r][к]", CtrlS, LeftControl " [s][ы]", CtrlT, LeftControl " [t][е]", CtrlU, LeftControl " [u][г]",
		CtrlV, LeftControl " [v][м]", CtrlW, LeftControl " [w][ц]", CtrlX, LeftControl " [x][ч]", CtrlY, LeftControl " [y][н]", CtrlZ, LeftControl " [z][я]", SpaceKey, "[Space]", ExclamationMark, "[!]", CommercialAt, "[@]", QuotationDouble, "[" QuotationDouble "]", Tabulation, "[Tab]"
	)
	for key, value in SpecialCommandsMap {
		if (HKey = key)
			return value
	}

	if IsObject(HKey) {
		for keys in HKey {
			MakeString .= FormatHotKey(keys)
		}
	} else {
		if (RegExMatch(HKey, "^\S+\+")) {
			StringSplitter := StrSplit(HKey, "+")
			MakeString := StringSplitter[1] . " " . "[" . StringSplitter[2] . "]"
		} else {
			MakeString := "[" . HKey . "]"
		}
	}

	MakeString := Modifier != "" ? (Modifier . " " . MakeString) : MakeString

	return MakeString
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
		if (TrimValue = CharacterName) {
			Result := value.%GetValue%
			break
		}
	}
	return Result
}

MapInsert(MapObj, Pairs*) {
	keyCount := 0
	for index in MapObj {
		keyCount++
	}

	startNumber := keyCount + 1
	numberLength := 4

	for i, pair in Pairs {
		if (Mod(i, 2) == 1) {
			key := pair
			numberStr := "0" . startNumber
			while (StrLen(numberStr) < numberLength) {
				numberStr := "0" . numberStr
			}
			formattedKey := numberStr . " " . key
			startNumber++
		} else {
			MapObj[formattedKey] := pair
		}
	}
}

MapPush(MapObj, Pairs*) {
	for i, pair in Pairs {
		if (Mod(i, 2) == 1) {
			key := pair
		} else {
			MapObj[key] := pair
		}
	}
}


GetMapCount(MapObj, SortGroups := "") {
	if !IsObject(SortGroups) {
		keyCount := MapObj.Count

		for characterEntry, value in MapObj {
			if HasProp(value, "calcOff") {
				keyCount--
			}
			if HasProp(value, "combiningForm") {
				keyCount++
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

			if HasProp(value, "combiningForm") {
				keyCount++
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
	return false
}


InsertCharactersGroups(TargetArray := "", GroupName := "", GroupHotKey := "", AddSeparator := True, ShowOnFastKeys := False, ShowRecipes := False, BlackList := [], FastSpecial := False, AlternativeLayout := False) {
	if GroupName == "" {
		return
	}

	LanguageCode := GetLanguageCode()
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
		TermporaryArray.Push(["", "", "", "", ""])
	if GroupHotKey != ""
		TermporaryArray.Push(["", GroupHotKey, "", "", ""])

	for characterEntry, value in Characters {
		entryID := ""
		entryName := ""
		if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
			entryID := match[1]
			entryName := match[2]
		}

		for blackListEntry in BlackList {
			if (blackListEntry = entryName) {
				continue 2
			}
		}

		GroupValid := False

		IsDefault := !ShowOnFastKeys && !ShowRecipes && !AlternativeLayout

		if (ShowRecipes && !HasProp(value, "recipe")) || (IsDefault && HasProp(value, "group") && !value.group.Has(2)) {
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
			if (ShowOnFastKeys && FastSpecial && !HasProp(value, "alt_special")) {
				continue
			}

			characterTitle := ""
			if (HasProp(value, "titles")) {
				characterTitle := value.titles[LanguageCode]
			} else {
				characterTitle := ReadLocale(entryName, "chars")
			}

			characterSymbol := HasProp(value, "symbol") ? value.symbol : ""
			characterModifier :=
				(HasProp(value, "modifier") && ShowOnFastKeys) ? value.modifier :
					HasProp(value, "defaultModifier") ? value.defaultModifier : ""
			characterBinding := ""

			if (ShowRecipes) {
				if (HasProp(value, "recipeAlt")) {
					characterBinding := RecipesMicroController(value.recipeAlt)
				} else if (HasProp(value, "recipe")) {
					characterBinding := RecipesMicroController(value.recipe)
				} else {
					characterBinding := ""
				}
			} else if (AlternativeLayout && HasProp(value, "alt_layout")) {
				characterBinding := value.alt_layout
			} else if (ShowOnFastKeys && FastSpecial && HasProp(value, "alt_special")) {
				characterBinding := value.alt_special
			} else if (ShowOnFastKeys && HasProp(value, "alt_on_fast_keys")) {
				characterBinding := value.alt_on_fast_keys
			} else {
				if value.group.Has(2) {
					characterBinding := FormatHotKey(value.group[2], characterModifier)
				}
			}

			if !ShowOnFastKeys || ShowOnFastKeys && (HasProp(value, "show_on_fast_keys") && value.show_on_fast_keys) {
				TermporaryArray.Push([characterTitle, characterBinding, characterSymbol, UniTrim(value.unicode), entryID])
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

Characters := Map(
	"", {
		unicode: "", html: "", entity: "",
		altcode: "",
		LaTeX: "",
		titles: Map("ru", "", "en", ""),
		titlesAlt: False,
		tags: [""],
		group: ["", ""],
		modifier: "",
		recipe: "",
		show_on_fast_keys: False,
		alt_on_fast_keys: "",
		symbol: "",
		symbolAlt: "",
		symbolCustom: ""
	})
MapInsert(Characters,
	"acute", {
		unicode: "{U+0301}", html: "&#769;",
		LaTeX: ["\'", "\acute"],
		tags: ["acute", "акут", "ударение"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["a", "ф"]],
		show_on_fast_keys: True,
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
		"acute_double", {
			unicode: "{U+030B}", html: "&#779;",
			tags: ["double acute", "двойной акут", "двойное ударение"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["A", "Ф"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"acute_below", {
			unicode: "{U+0317}", html: "&#791;",
			tags: ["acute below", "акут снизу"],
			group: ["Diacritics Secondary", ["a", "ф"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"acute_tone_vietnamese", {
			unicode: "{U+0341}", html: "&#833;",
			tags: ["acute tone", "акут тона"],
			group: ["Diacritics Secondary", ["A", "Ф"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"asterisk_above", {
			unicode: "{U+20F0}", html: "&#8432;",
			tags: ["asterisk above", "астериск сверху"],
			group: ["Diacritics Tertiary", ["a", "ф"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"asterisk_below", {
			unicode: "{U+0359}", html: "&#857;",
			tags: ["asterisk below", "астериск снизу"],
			group: ["Diacritics Tertiary", ["A", "Ф"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"breve", {
			unicode: "{U+0306}", html: "&#774;",
			LaTeX: ["\u", "\breve"],
			tags: ["breve", "бреве", "кратка"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["b", "и"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"breve_inverted", {
			unicode: "{U+0311}", html: "&#785;",
			tags: ["inverted breve", "перевёрнутое бреве", "перевёрнутая кратка"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["B", "И"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"breve_below", {
			unicode: "{U+032E}", html: "&#814;",
			tags: ["breve below", "бреве снизу", "кратка снизу"],
			group: ["Diacritics Secondary", ["b", "и"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"breve_inverted_below", {
			unicode: "{U+032F}", html: "&#815;",
			tags: ["inverted breve below", "перевёрнутое бреве снизу", "перевёрнутая кратка снизу"],
			group: ["Diacritics Secondary", ["B", "И"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"bridge_above", {
			unicode: "{U+0346}", html: "&#838;",
			tags: ["bridge above", "мостик сверху"],
			group: ["Diacritics Tertiary", ["b", "и"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"bridge_below", {
			unicode: "{U+032A}", html: "&#810;",
			tags: ["bridge below", "мостик снизу"],
			group: ["Diacritics Tertiary", ["B", "И"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"bridge_inverted_below", {
			unicode: "{U+033A}", html: "&#825;",
			tags: ["inverted bridge below", "перевёрнутый мостик снизу"],
			group: ["Diacritics Tertiary", CtrlB],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"circumflex", {
			unicode: "{U+0302}", html: "&#770;",
			LaTeX: ["\^", "\hat"],
			tags: ["circumflex", "циркумфлекс"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["c", "с"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"caron", {
			unicode: "{U+030C}", html: "&#780;",
			LaTeX: "\v",
			tags: ["caron", "hachek", "карон", "гачек"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["C", "С"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"circumflex_below", {
			unicode: "{U+032D}", html: "&#813;",
			tags: ["circumflex below", "циркумфлекс снизу"],
			group: ["Diacritics Secondary", ["c", "с"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"caron_below", {
			unicode: "{U+032C}", html: "&#812;",
			tags: ["caron below", "карон снизу", "гачек снизу"],
			group: ["Diacritics Secondary", ["C", "С"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"cedilla", {
			unicode: "{U+0327}", html: "&#807;",
			LaTeX: "\c",
			tags: ["cedilla", "седиль"],
			group: [["Diacritics Tertiary", "Diacritics Fast Secondary"], ["c", "с"]],
			symbolClass: "Diacritic Mark",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above", {
			unicode: "{U+0313}", html: "&#787;",
			tags: ["comma above", "запятая сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], [",", "б"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_below", {
			unicode: "{U+0326}", html: "&#806;",
			tags: ["comma below", "запятая снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["<", "Б"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above_turned", {
			unicode: "{U+0312}", html: "&#786;",
			tags: ["turned comma above", "перевёрнутая запятая сверху"],
			group: ["Diacritics Secondary", [",", "б"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above_reversed", {
			unicode: "{U+0314}", html: "&#788;",
			tags: ["reversed comma above", "зеркальная запятая сверху"],
			group: [["Diacritics Secondary", "Diacritics Fast Secondary"], ["<", "Б"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above_right", {
			unicode: "{U+0315}", html: "&#789;",
			tags: ["comma above right", "запятая сверху справа"],
			group: [["Diacritics Tertiary", "Diacritics Fast Secondary"], [",", "б"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"candrabindu", {
			unicode: "{U+0310}", html: "&#784;",
			tags: ["candrabindu", "карон снизу"],
			group: ["Diacritics Tertiary", ["C", "С"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"dot_above", {
			unicode: "{U+0307}", html: "&#775;",
			LaTeX: ["\.", "\dot"],
			tags: ["dot above", "точка сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["d", "в"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"diaeresis", {
			unicode: "{U+0308}", html: "&#776;",
			LaTeX: ["\" . QuotationDouble, "\ddot"],
			tags: ["diaeresis", "диерезис"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["D", "В"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"dot_below", {
			unicode: "{U+0323}", html: "&#803;",
			tags: ["dot below", "точка снизу"],
			group: ["Diacritics Secondary", ["d", "в"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"diaeresis_below", {
			unicode: "{U+0324}", html: "&#804;",
			tags: ["diaeresis below", "диерезис снизу"],
			group: ["Diacritics Secondary", ["D", "В"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"fermata", {
			unicode: "{U+0352}", html: "&#850;",
			tags: ["fermata", "фермата"],
			group: [["Diacritics Tertiary", "Diacritics Fast Primary"], ["F", "А"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"grave", {
			unicode: "{U+0300}", html: "&#768;",
			LaTeX: ["\" . Backquote, "\grave"],
			tags: ["grave", "гравис"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["g", "п"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"grave_double", {
			unicode: "{U+030F}", html: "&#783;",
			tags: ["double grave", "двойной гравис"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["G", "П"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"grave_below", {
			unicode: "{U+0316}", html: "&#790;",
			tags: ["grave below", "гравис снизу"],
			group: ["Diacritics Secondary", ["g", "п"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"grave_tone_vietnamese", {
			unicode: "{U+0340}", html: "&#832;",
			tags: ["grave tone", "гравис тона"],
			group: ["Diacritics Secondary", ["G", "П"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"hook_above", {
			unicode: "{U+0309}", html: "&#777;",
			tags: ["hook above", "хвостик сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["h", "р"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"horn", {
			unicode: "{U+031B}", html: "&#795;",
			tags: ["horn", "рожок"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["H", "Р"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"palatal_hook_below", {
			unicode: "{U+0321}", html: "&#801;",
			tags: ["palatal hook below", "палатальный крюк"],
			group: ["Diacritics Secondary", ["h", "р"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"retroflex_hook_below", {
			unicode: "{U+0322}", html: "&#802;",
			tags: ["retroflex hook below", "ретрофлексный крюк"],
			group: ["Diacritics Secondary", ["H", "Р"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"macron", {
			unicode: "{U+0304}", html: "&#772;",
			tags: ["macron", "макрон"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["m", "ь"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"macron_below", {
			unicode: "{U+0331}", html: "&#817;",
			tags: ["macron below", "макрон снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["M", "Ь"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ogonek", {
			unicode: "{U+0328}", html: "&#808;",
			tags: ["ogonek", "огонэк"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["o", "щ"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ogonek_above", {
			unicode: "{U+1DCE}", html: "&#7630;",
			tags: ["ogonek above", "огонэк сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["O", "Щ"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
		},
		"overline", {
			unicode: "{U+0305}", html: "&#773;",
			tags: ["overline", "черта сверху"],
			group: ["Diacritics Secondary", ["o", "щ"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"overline_double", {
			unicode: "{U+033F}", html: "&#831;",
			tags: ["overline", "черта сверху"],
			group: ["Diacritics Secondary", ["O", "Щ"]],
			symbolClass: "Diacritic Mark",
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"low_line", {
			unicode: "{U+0332}", html: "&#818;",
			tags: ["low line", "черта снизу"],
			group: ["Diacritics Tertiary", ["o", "щ"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"low_line_double", {
			unicode: "{U+0333}", html: "&#819;",
			tags: ["dobule low line", "двойная черта снизу"],
			group: ["Diacritics Tertiary", ["O", "Щ"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ring_above", {
			unicode: "{U+030A}", html: "&#778;",
			tags: ["ring above", "кольцо сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["r", "к"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ring_below", {
			unicode: "{U+0325}", html: "&#805;",
			tags: ["ring below", "кольцо снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["R", "К"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ring_below_double", {
			unicode: "{U+035A}", html: "&#858;",
			tags: ["double ring below", "двойное кольцо снизу"],
			group: ["Diacritics Primary", CtrlR],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical", {
			unicode: "{U+030D}", html: "&#781;",
			tags: ["vertical line", "вертикальная черта"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["v", "м"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical_double", {
			unicode: "{U+030E}", html: "&#782;",
			tags: ["double vertical line", "двойная вертикальная черта"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["V", "М"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical_below", {
			unicode: "{U+0329}", html: "&#809;",
			tags: ["vertical line below", "вертикальная черта снизу"],
			group: ["Diacritics Secondary", ["v", "м"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical_double_below", {
			unicode: "{U+0348}", html: "&#840;",
			tags: ["dobule vertical line below", "двойная вертикальная черта снизу"],
			group: ["Diacritics Secondary", ["V", "М"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"stroke_short", {
			unicode: "{U+0335}", html: "&#821;",
			tags: ["short stroke", "короткое перечёркивание"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], ["s", "ы"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"stroke_long", {
			unicode: "{U+0336}", html: "&#822;",
			tags: ["long stroke", "длинное перечёркивание"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], ["S", "Ы"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"solidus_short", {
			unicode: "{U+0337}", html: "&#823;",
			tags: ["short solidus", "короткая косая черта"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], "\"],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			alt_on_fast_keys: "[/]",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"solidus_long", {
			unicode: "{U+0338}", html: "&#824;",
			tags: ["long solidus", "длинная косая черта"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], "/"],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde", {
			unicode: "{U+0303}", html: "&#771;",
			tags: ["tilde", "тильда"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["t", "е"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_vertical", {
			unicode: "{U+033E}", html: "&#830;",
			tags: ["tilde vertical", "вертикальная тильда"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["T", "Е"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_below", {
			unicode: "{U+0330}", html: "&#816;",
			tags: ["tilde below", "тильда снизу"],
			group: ["Diacritics Secondary", ["t", "е"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_not", {
			unicode: "{U+034A}", html: "&#842;",
			tags: ["not tilde", "перечёрнутая тильда"],
			group: ["Diacritics Secondary", ["T", "Е"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_overlay", {
			unicode: "{U+0334}", html: "&#820;",
			tags: ["tilde overlay", "тильда посередине"],
			group: ["Diacritics Quatemary", ["t", "е"]],
			symbolClass: "Diacritic Mark",
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"x_above", {
			unicode: "{U+033D}", html: "&#829;",
			tags: ["x above", "x сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["x", "ч"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"x_below", {
			unicode: "{U+0353}", html: "&#851;",
			tags: ["x below", "x снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["X", "Ч"]],
			symbolClass: "Diacritic Mark",
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"zigzag_above", {
			unicode: "{U+035B}", html: "&#859;",
			tags: ["zigzag above", "зигзаг сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["z", "я"]],
			symbolClass: "Diacritic Mark",
			show_on_fast_keys: True,
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		; ? Шпации
		"space", {
			unicode: "{U+0020}", html: "&#32;",
			symbolClass: "Spaces",
		},
		"emsp", {
			unicode: "{U+2003}", html: "&#8195;", entity: "&emsp;",
			tags: ["em space", "emspace", "emsp", "круглая шпация"],
			group: ["Spaces", "1"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2003),
		},
		"ensp", {
			unicode: "{U+2002}", html: "&#8194;", entity: "&ensp;",
			tags: ["en space", "enspace", "ensp", "полукруглая шпация"],
			group: ["Spaces", "2"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2002),
		},
		"emsp13", {
			unicode: "{U+2004}", html: "&#8196;", entity: "&emsp13;",
			tags: ["emsp13", "1/3emsp", "1/3 круглой Шпации"],
			group: ["Spaces", "3"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2004),
		},
		"emsp14", {
			unicode: "{U+2005}", html: "&#8196;", entity: "&emsp14;",
			tags: ["emsp14", "1/4emsp", "1/4 круглой Шпации"],
			group: ["Spaces", "4"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2005),
		},
		"thinspace", {
			unicode: "{U+2009}", html: "&#8201;", entity: "&thinsp;",
			tags: ["thinsp", "thin space", "узкий пробел", "тонкий пробел"],
			group: ["Spaces", "5"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2009),
		},
		"emsp16", {
			unicode: "{U+2006}", html: "&#8198;",
			tags: ["emsp16", "1/6emsp", "1/6 круглой Шпации"],
			group: ["Spaces", "6"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2006),
		},
		"narrow_no_break_space", {
			unicode: "{U+202F}", html: "&#8239;",
			tags: ["nnbsp", "narrow no-break space", "узкий неразрывный пробел", "тонкий неразрывный пробел"],
			group: ["Spaces", "7"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x202F),
		},
		"hairspace", {
			unicode: "{U+200A}", html: "&#8202;", entity: "&hairsp;",
			tags: ["hsp", "hairsp", "hair space", "волосяная шпация"],
			group: ["Spaces", "8"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x200A),
		},
		"punctuation_space", {
			unicode: "{U+2008}", html: "&#8200;", entity: "&puncsp;",
			tags: ["psp", "puncsp", "punctuation space", "пунктуационный пробел"],
			group: ["Spaces", "9"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2008),
		},
		"zero_width_space", {
			unicode: "{U+200B}", html: "&#8200;", entity: "&NegativeVeryThinSpace;",
			tags: ["zwsp", "zero-width space", "пробел нулевой ширины"],
			group: ["Spaces", "0"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x200B),
		},
		"word_joiner", {
			unicode: "{U+2060}", html: "&#8288;", entity: "&NoBreak;",
			tags: ["wj", "word joiner", "соединитель слов"],
			group: ["Spaces", "-"],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2060),
		},
		"figure_space", {
			unicode: "{U+2007}", html: "&#8199;", entity: "&numsp;",
			tags: ["nsp", "numsp", "figure space", "цифровой пробел"],
			group: ["Spaces", "="],
			symbolClass: "Spaces",
			modifier: RightShift,
			show_on_fast_keys: True,
			symbolAlt: Chr(0x2007),
		},
		"no_break_space", {
			unicode: "{U+00A0}", html: "&#160;", entity: "&nbsp;",
			altcode: "0160",
			LaTeX: "~",
			tags: ["nbsp", "no-break space", "неразрывный пробел"],
			group: ["Spaces", SpaceKey],
			symbolClass: "Spaces",
			show_on_fast_keys: True,
			symbolAlt: Chr(0x00A0),
		},
		"tabulation", {
			unicode: "{U+0009}", html: "&#9;", entity: "&Tab;",
			tags: ["tab", "tabulation", "табуляция"],
			group: ["Spaces", Tabulation],
			symbolClass: "Spaces",
			show_on_fast_keys: True,
			symbolAlt: Chr(0x0009),
		},
		"emquad", {
			unicode: "{U+2001}", html: "&#8193;",
			LaTeX: "\qquad",
			tags: ["em quad", "emquad", "emqd", "em-квадрат"],
			group: ["Spaces", ExclamationMark],
			symbolClass: "Spaces",
			symbolAlt: Chr(0x2001),
		},
		"enquad", {
			unicode: "{U+2000}", html: "&#8192;",
			LaTeX: "\quad",
			tags: ["en quad", "enquad", "enqd", "en-квадрат"],
			group: ["Spaces", [CommercialAt, QuotationDouble]],
			symbolClass: "Spaces",
			symbolAlt: Chr(0x2000),
		},
		;
		;
		; ? Sys Group
		"carriage_return", {
			unicode: "{U+000D}", html: "&#13;",
			tags: ["carriage return", "возврат каретки"],
			group: ["Sys Group"],
			show_on_fast_keys: True,
			symbolAlt: Chr(0x21B5),
		},
		"new_line", {
			unicode: "{U+000A}", html: "&#10;",
			tags: ["new line", "перевод строки"],
			group: ["Sys Group"],
			show_on_fast_keys: True,
			symbolAlt: Chr(0x21B4),
		},
		;
		;
		; ? Special Characters
		"arrow_left", {
			unicode: "{U+2190}", html: "&#8592;",
			altCode: "27",
			tags: ["left arrow", "стрелка влево"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2190) "]",
		},
		"arrow_right", {
			unicode: "{U+2192}", html: "&#8594;",
			altCode: "26",
			tags: ["right arrow", "стрелка вправо"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2192) "]",
		},
		"arrow_up", {
			unicode: "{U+2191}", html: "&#8593;",
			altCode: "25",
			tags: ["up arrow", "стрелка вверх"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2191) "]",
		},
		"arrow_down", {
			unicode: "{U+2193}", html: "&#8595;",
			altCode: "24",
			tags: ["down arrow", "стрелка вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2193) "]",
		},
		"arrow_leftup", {
			unicode: "{U+2196}", html: "&#8598;",
			altCode: "24",
			tags: ["left up arrow", "стрелка влево-вверх"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2191) "][" Chr(0x2190) "]",
		},
		"arrow_rightup", {
			unicode: "{U+2197}", html: "&#8599;",
			tags: ["right up arrow", "стрелка вправо-вверх"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2191) "][" Chr(0x2192) "]",
		},
		"arrow_leftdown", {
			unicode: "{U+2199}", html: "&#8601;",
			tags: ["left down arrow", "стрелка влево-вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2193) "][" Chr(0x2190) "]",
		},
		"arrow_rightdown", {
			unicode: "{U+2198}", html: "&#8600;",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2193) "][" Chr(0x2192) "]",
		},
		"arrow_leftright", {
			unicode: "{U+2194}", html: "&#8597;",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2190) "][" Chr(0x2192) "]",
		},
		"arrow_updown", {
			unicode: "{U+2195}", html: "&#8597;",
			altCode: "18",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2191) "][" Chr(0x2193) "]",
		},
		"arrow_left_circle", {
			unicode: "{U+21BA}", html: "&#8634;", entity: "&olarr;",
			tags: ["left circle arrow", "округлая стрелка влево"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [" Chr(0x2190) "]",
		},
		"arrow_right_circle", {
			unicode: "{U+21BB}", html: "&#8635;", entity: "&orarr;",
			tags: ["right circle arrow", "округлая стрелка вправо"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [" Chr(0x2192) "]",
		},
		"arrow_left_ushaped", {
			unicode: "{U+2B8C}", html: "&#11148;",
			tags: ["left u-arrow", "u-образная стрелка влево"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2190) "]",
		},
		"arrow_right_ushaped", {
			unicode: "{U+2B8E}", html: "&#11150;",
			tags: ["right u-arrow", "u-образная стрелка вправо"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2192) "]",
		},
		"arrow_up_ushaped", {
			unicode: "{U+2B8D}", html: "&#11149;",
			tags: ["up u-arrow", "u-образная стрелка вверх"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2190) "]",
		},
		"arrow_down_ushaped", {
			unicode: "{U+2B8F}", html: "&#11151;",
			tags: ["down u-arrow", "u-образная стрелка вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2192) "]",
		},
		"asterisk_low", {
			unicode: "{U+204E}", html: "&#8270;",
			tags: ["low asterisk", "нижний астериск"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], ["a", "ф"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Num*]",
			recipe: "*",
		},
		"asterisk_two", {
			unicode: "{U+2051}", html: "&#8273;",
			tags: ["two asterisks", "два астериска"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], ["A", "Ф"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num*]",
			recipe: ["**", "2*"],
		},
		"asterism", {
			unicode: "{U+2042}", html: "&#8258;",
			tags: ["asterism", "астеризм"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], CtrlA],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Num*]",
			recipe: ["***", "3*"],
		},
		"bullet", {
			unicode: "{U+2022}", html: "&#8226;", entity: "&bull;",
			altCode: "0149 7",
			tags: ["bullet", "булит"],
			group: [["Special Characters", "Special Fast Secondary"], Backquote],
			show_on_fast_keys: True,
		},
		"bullet_hyphen", {
			unicode: "{U+2043}", html: "&#8259;", entity: "&hybull;",
			altCode: "0149 7",
			tags: ["hyphen bullet", "чёрточный булит"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [" Backquote "]",
		},
		"interpunct", {
			unicode: "{U+00B7}", html: "&#183;", entity: "&middot;",
			altCode: "0183 250",
			tags: ["middle dot", "точка по центру", "интерпункт"],
			group: [["Special Characters", "Special Fast Secondary"], '~'],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Backquote "]",
		},
		"bullet_white", {
			unicode: "{U+25E6}", html: "&#9702;",
			tags: ["white bullet", "прозрачный булит"],
			group: [["Special Characters", "Special Fast Secondary"], Backquote],
			show_on_fast_keys: True,
		},
		"colon_triangle", {
			unicode: "{U+02D0}", html: "&#720;",
			tags: ["triangle colon", "знак долготы"],
			group: ["Special Characters", [";", "ж"]],
		},
		"colon_triangle_half", {
			unicode: "{U+02D1}", html: "&#721;",
			tags: ["half triangle colon", "знак полудолготы"],
			group: ["Special Characters", [":", "Ж"]],
		},
		"degree", {
			unicode: "{U+00B0}", html: "&#176;", entity: "&deg;",
			tags: ["degree", "градус"],
			group: [["Special Characters", "Special Fast Left"], ["d", "в"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[D]",
		},
		"celsius", {
			unicode: "{U+2103}", html: "&#8451;",
			tags: ["celsius", "градус Цельсия"],
			group: [["Special Characters", "Smelting Special"]],
			recipe: Chr(0x00B0) . "C",
		},
		"fahrenheit", {
			unicode: "{U+2109}", html: "&#8457;",
			tags: ["fahrenheit", "градус по Фаренгейту"],
			group: [["Special Characters", "Smelting Special"]],
			recipe: Chr(0x00B0) . "F",
		},
		"kelvin", {
			unicode: "{U+212A}", html: "&#8490;",
			tags: ["kelvin", "Кельвин"],
			group: [["Special Characters", "Smelting Special"]],
			recipe: Chr(0x00B0) . "K",
		},
		"dagger", {
			unicode: "{U+2020}", html: "&#8224;", entity: "&dagger;",
			LaTeX: "\dagger",
			tags: ["dagger", "даггер", "крест"],
			group: [["Special Characters", "Special Fast Secondary"], ["t", "е"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num/]",
		},
		"dagger_double", {
			unicode: "{U+2021}", html: "&#8225;", entity: "&Dagger;",
			LaTeX: "\ddagger",
			tags: ["double dagger", "двойной даггер", "двойной крест"],
			group: [["Special Characters", "Special Fast Secondary"], ["T", "Е"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Num/]",
		},
		"dagger_tripple", {
			unicode: "{U+2E4B}", html: "&#11851;",
			tags: ["tripple dagger", "тройной даггер", "тройной крест"],
			group: ["Special Characters", CtrlT],
		},
		"fraction_slash", {
			unicode: "{U+2044}", html: "&#8260;",
			tags: ["fraction slash", "дробная черта"],
			group: [["Special Characters", "Special Fast Secondary"], "/"],
			modifier: RightShift,
			show_on_fast_keys: True,
		},
		"grapheme_joiner", {
			unicode: "{U+034F}", html: "&#847;",
			tags: ["grapheme joiner", "соединитель графем"],
			group: ["Special Characters", ["g", "п"]],
		},
		"infinity", {
			unicode: "{U+221E}", html: "&#8734;", entity: "&infin;",
			tags: ["fraction slash", "дробная черта"],
			group: [["Special Characters", "Special Fast Secondary"], "9"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [8]",
		},
		"multiplication", {
			unicode: "{U+00D7}", html: "&#215;", entity: "&times;",
			altcode: "0215",
			tags: ["multiplication", "умножение"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "8"],
			show_on_fast_keys: True,
			alt_special: "[Num*]",
			recipe: "-x",
		},
		"prime_single", {
			unicode: "{U+2032}", html: "&#8242;", entity: "&prime;",
			LaTeX: "\prime",
			tags: ["prime", "штрих"],
			group: ["Special Characters", ["p", "з"]],
		},
		"prime_double", {
			unicode: "{U+2033}", html: "&#8243;", entity: "&Prime;",
			LaTeX: "\prime\prime",
			tags: ["double prime", "двойной штрих"],
			group: ["Special Characters", ["P", "З"]],
		},
		"permille", {
			unicode: "{U+2030}", html: "&#8240;", entity: "&permil;",
			altcode: "0137",
			LaTeX: "\permil",
			LaTeXPackage: "wasysym",
			tags: ["per mille", "промилле"],
			group: [["Special Characters", "Special Fast Secondary"], "5"],
			show_on_fast_keys: True,
		},
		"pertenthousand", {
			unicode: "{U+2031}", html: "&#8241;", entity: "&pertenk;",
			LaTeX: "\textpertenthousand",
			LaTeXPackage: "textcomp",
			tags: ["per ten thousand", "промилле", "базисный пункт", "basis point"],
			group: [["Special Characters", "Special Fast Secondary"], "%"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [5]",
			symbolCustom: "s40"
		},
		"section", {
			unicode: "{U+00A7}", html: "&#167;", entity: "&sect;",
			altCode: "21",
			tags: ["section", "параграф"],
			group: [["Special Characters", "Special Fast Secondary"], ["s", "ы"]],
			show_on_fast_keys: True,
		},
		"noequals", {
			unicode: "{U+2260}", html: "&#8800;", entity: "&ne;",
			tags: ["no equals", "не равно"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "="],
			show_on_fast_keys: True,
			alt_special: "[/=]",
			recipe: "/=",
		},
		"almostequals", {
			unicode: "{U+2248}", html: "&#8776;", entity: "&asymp;",
			tags: ["almost equals", "примерно равно"],
			group: [["Smelting Special", "Special Fast Secondary", "Special Fast"], "="],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [=]",
			alt_special: "[``=]",
			recipe: "~=",
		},
		"plusminus", {
			unicode: "{U+00B1}", html: "&#177;", entity: "&plusmn;",
			altcode: "0177",
			tags: ["plus minus", "плюс-минус"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "+"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [=]",
			alt_special: "[Num+ Num-]",
			recipe: ["+-", "+" Chr(0x2212)],
		},
		"dotted_circle", {
			unicode: "{U+25CC}", html: "&#9676;",
			tags: ["пунктирный круг", "dottet circle"],
			group: ["Special Fast Primary", "Num0"],
			show_on_fast_keys: True,
		},
		"ellipsis", {
			unicode: "{U+2026}", html: "&#8230;", entity: "&hellip;",
			altcode: "0133",
			tags: ["ellipsis", "многоточие"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], "."],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[/]",
			recipe: "...",
		},
		"two_dot_leader", {
			unicode: "{U+2025}", html: "&#8229;",
			tags: ["two dot leader", "двухточечный пунктир"],
			group: [["Smelting Special", "Special Fast Secondary"], "."],
			recipe: "..",
		},
		"exclamation", {
			unicode: "{U+0021}", html: "&#33;", entity: "&excl;",
		},
		"question", {
			unicode: "{U+003F}", html: "&#63;", entity: "&quest;",
		},
		"reversed_question", {
			unicode: "{U+2E2E}", html: "&#11822;",
			tags: ["reversed ?", "обратный ?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [1]",
			recipe: Chr(0x2B8C) "?",
		},
		"inverted_exclamation", {
			unicode: "{U+00A1}", html: "&#161;", entity: "&iexcl;",
			tags: ["inverted !", "перевёрнутый !"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[1]",
			recipe: Chr(0x2B8F) "!",
		},
		"inverted_question", {
			unicode: "{U+00BF}", html: "&#191;", entity: "&iquest;",
			tags: ["inverted ?", "перевёрнутый ?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[7]",
			recipe: Chr(0x2B8F) "?",
		},
		"double_exclamation", {
			unicode: "{U+203C}", html: "&#8252;",
			altcode: "19",
			tags: ["double !!", "двойной !!"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock RightShift " [1]",
			recipe: "!!",
		},
		"double_exclamation_question", {
			unicode: "{U+2049}", html: "&#8265;",
			tags: ["double !?", "двойной !?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [1]",
			recipe: "!?",
		},
		"double_question", {
			unicode: "{U+2047}", html: "&#8263;",
			tags: ["double ??", "двойной ??"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock RightShift " [7]",
			recipe: "??",
		},
		"double_question_exclamation", {
			unicode: "{U+2048}", html: "&#8264;",
			tags: ["double ?!", "двойной ?!"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [7]",
			recipe: "?!",
		},
		"interrobang", {
			unicode: "{U+203D}", html: "&#8253;",
			tags: ["interrobang", "интерробанг", "лигатура !?", "ligature !?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [1]",
			recipe: "!+?",
		},
		"interrobang_inverted", {
			unicode: "{U+2E18}", html: "&#11800;",
			tags: ["inverted interrobang", "перевёрнутый интерробанг", "лигатура перевёрнутый !?", "ligature inverted !?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock LeftShift RightShift " [1]",
			recipe: Chr(0x2B8F) "!+?",
		},
		;
		"bracket_square_left", {
			unicode: "{U+005B}", html: "&#91;", entity: "&lbrack;",
			altCode: "91",
			tags: ["left square bracket", "левая квадратная скобка"],
			group: [["Brackets", "Special Fast Secondary"], "["],
			show_on_fast_keys: True,
		},
		"bracket_square_right", {
			unicode: "{U+005D}", html: "&#93;", entity: "&rbrack;",
			altCode: "123",
			tags: ["right square bracket", "правая квадратная скобка"],
			group: [["Brackets", "Special Fast Secondary"], "]"],
			show_on_fast_keys: True,
		},
		"bracket_curly_left", {
			unicode: "{U+007B}", html: "&#123;", entity: "&lbrace;",
			altCode: "123",
			tags: ["left curly bracket", "левая фигурная скобка"],
			group: [["Brackets", "Special Fast Secondary"]],
			alt_on_fast_keys: RightShift " [[]",
			show_on_fast_keys: True,
		},
		"bracket_curly_right", {
			unicode: "{U+007D}", html: "&#125;", entity: "&rbrace;",
			altCode: "125",
			tags: ["right curly bracket", "правая фигурная скобка"],
			group: [["Brackets", "Special Fast Secondary"]],
			alt_on_fast_keys: RightShift " []]",
			show_on_fast_keys: True,
		},
		"bracket_angle_math_left", {
			unicode: "{U+27E8}", html: "&#10216;",
			altCode: "123",
			tags: ["left angle math bracket", "левая угловая математическая скобка"],
			group: [["Brackets", "Special Fast Secondary"], "9"],
			show_on_fast_keys: True,
		},
		"bracket_angle_math_right", {
			unicode: "{U+27E9}", html: "&#10217;",
			altCode: "125",
			tags: ["right angle math bracket", "правая угловая математическая скобка"],
			group: [["Brackets", "Special Fast Secondary"], "0"],
			show_on_fast_keys: True,
		},
		;
		"emdash", {
			unicode: "{U+2014}", html: "&#8212;", entity: "&mdash;",
			altcode: "0151",
			tags: ["em dash", "длинное тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "1"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[-]",
			recipe: "---",
		},
		"emdash_vertical", {
			unicode: "{U+FE31}", html: "&#65073;",
			tags: ["vertical em dash", "вертикальное длинное тире"],
			group: ["Smelting Special"],
			recipe: Chr(0x2B8F) "—",
		},
		"endash", {
			unicode: "{U+2013}", html: "&#8211;", entity: "&ndash;",
			altcode: "0150",
			tags: ["en dash", "короткое тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "2"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [-]",
			recipe: "--",
		},
		"endash_vertical", {
			unicode: "{U+FE32}", html: "&#65074;",
			tags: ["vertical en dash", "вертикальное короткое тире"],
			group: ["Smelting Special"],
			recipe: Chr(0x2B8F) "–",
		},
		"three_emdash", {
			unicode: "{U+2E3B}", html: "&#11835;",
			tags: ["three-em dash", "тройное тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "3"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [-]",
			recipe: ["-----", "3-"],
		},
		"two_emdash", {
			unicode: "{U+2E3A}", html: "&#11834;",
			tags: ["two-em dash", "двойное тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "4"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock LeftShift " [-]",
			recipe: ["----", "2-"],
		},
		"softhyphen", {
			unicode: "{U+00AD}", html: "&#173;", entity: "&shy;",
			altcode: "0173",
			tags: ["soft hyphen", "мягкий перенос"],
			group: [["Dashes", "Smelting Special", "Special Fast Primary"], "5"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[-]",
			recipe: ".-",
		},
		"figure_dash", {
			unicode: "{U+2012}", html: "&#8210;",
			tags: ["figure dash", "цифровое тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "6"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [-]",
			recipe: "n-",
		},
		"hyphen", {
			unicode: "{U+2010}", html: "&#8208;", entity: "&hyphen;",
			tags: ["hyphen", "дефис"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "7"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [-]",
			recipe: "-",
		},
		"no_break_hyphen", {
			unicode: "{U+2011}", html: "&#8209;",
			tags: ["no-break hyphen", "неразрывный дефис"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "8"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [-]",
			recipe: "0-",
		},
		"minus", {
			unicode: "{U+2212}", html: "&#8722;", entity: "&minus;",
			tags: ["minus", "минус"],
			group: [["Dashes", "Smelting Special", "Special Fast Primary", "Special Fast"], "9"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [-]",
			alt_special: "[Num-]",
			recipe: "m-",
		},
		"horbar", {
			unicode: "{U+2015}", html: "&#8213;", entity: "&horbar;",
			tags: ["horbar", "горизонтальная черта"],
			group: [["Dashes", "Smelting Special"], "0"],
			recipe: "h-",
		},
		;
		;
		; * Quotation Marks
		"france_left", {
			unicode: "{U+00AB}", html: "&#171;", entity: "&laquo;",
			altcode: "0171",
			tags: ["left guillemets", "левая ёлочка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "1"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[б]",
			recipe: ["<<", "2<"],
		},
		"france_right", {
			unicode: "{U+00BB}", html: "&#187;", entity: "&raquo;",
			altcode: "0172",
			tags: ["right guillemets", "правая ёлочка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "2"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[ю]",
			recipe: [">>", "2>"],
		},
		"france_single_left", {
			unicode: "{U+2039}", html: "&#8249;", entity: "&lsaquo;",
			altcode: "0139",
			tags: ["left single guillemet", "левая одиночная ёлочка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "2"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Б]",
			recipe: "<",
		},
		"france_single_right", {
			unicode: "{U+203A}", html: "&#8250;", entity: "&rsaquo;",
			altcode: "0155",
			tags: ["right single guillemet", "правая одиночная ёлочка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "3"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Ю]",
			recipe: ">",
		},
		"quote_left_double", {
			unicode: "{U+201C}", html: "&#8220;", entity: "&ldquo;",
			altcode: "0147",
			tags: ["left quotes", "левая кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "4"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[<]",
			recipe: QuotationDouble . "<",
		},
		"quote_right_double", {
			unicode: "{U+201D}", html: "&#8221;", entity: "&rdquo;",
			altcode: "0148",
			tags: ["right quotes", "правая кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "5"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[>]",
			recipe: QuotationDouble . ">",
		},
		"quote_left_single", {
			unicode: "{U+2018}", html: "&#8216;", entity: "&lsquo;",
			altcode: "0145",
			tags: ["left quote", "левая одинарная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "6"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [<]",
			recipe: ApostropheMark . "<",
		},
		"quote_right_single", {
			unicode: "{U+2019}", html: "&#8217;", entity: "&rsquo;",
			altcode: "0146",
			tags: ["right quote", "правая одинарная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "7"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [>] " RightShift " [" Backquote "][Ё]",
			recipe: ApostropheMark ">",
		},
		"quote_low_9_single", {
			unicode: "{U+201A}", html: "&#8218;", entity: "&sbquo;",
			tags: ["single low-9", "нижняя открывающая кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "8"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift "  [<]",
			recipe: ApostropheMark Chr(0x2193) "<",
		},
		"quote_low_9_double", {
			unicode: "{U+201E}", html: "&#8222;", entity: "&bdquo;",
			altcode: "0132",
			tags: ["low-9 quotes", "нижняя открывающая двойная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "0"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [<]",
			recipe: QuotationDouble Chr(0x2193) "<",
		},
		"quote_low_9_double_reversed", {
			unicode: "{U+2E42}", html: "&#11842;",
			tags: ["low-9 reversed quotes", "нижняя двойная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "-"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [>]",
			recipe: QuotationDouble Chr(0x2193) ">",
		},
		"quote_left_double_ghost_ru", {
			unicode: "{U+201E}", html: "&#8222;", entity: "&bdquo;",
			altcode: "0132",
			tags: ["left low quotes", "левая нижняя кавычка"],
			group: ["Special Fast Secondary"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Б]",
		},
		"quote_right_double_ghost_ru", {
			unicode: "{U+201C}", html: "&#8220;", entity: "&ldquo;",
			altcode: "0147",
			tags: ["left quotes", "левая кавычка"],
			group: ["Special Fast Secondary"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Ю]",
		},
		"asian_left_quote", {
			unicode: "{U+300C}", html: "#12300;",
			tags: ["asian left quote", "левая азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num4]",
		},
		"asian_right_quote", {
			unicode: "{U+300D}", html: "#12301;",
			tags: ["asian right quote", "правая азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num6]",
		},
		"asian_up_quote", {
			unicode: "{U+FE41}", html: "&#65089;",
			tags: ["asian up quote", "верхняя азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num8]",
		},
		"asian_down_quote", {
			unicode: "{U+FE42}", html: "&#65090;",
			tags: ["asian down quote", "нижняя азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num2]",
		},
		"asian_double_left_quote", {
			unicode: "{U+300E}", html: "&#12302;",
			tags: ["asian double left quote", "левая двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num4]",
		},
		"asian_double_right_quote", {
			unicode: "{U+300F}", html: "&#12303;",
			tags: ["asian double right quote", "правая двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num6]",
		},
		"asian_double_up_quote", {
			unicode: "{U+FE43}", html: "&#65091;",
			tags: ["asian double up quote", "верхняя двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num8]",
		},
		"asian_double_down_quote", {
			unicode: "{U+FE44}", html: "&#65092;",
			tags: ["asian double down quote", "нижняя двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num2]",
		},
		"asian_double_left_title", {
			unicode: "{U+300A}", html: "&#12298;",
			tags: ["asian double left title", "двойная левая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [<][Б]",
		},
		"asian_double_right_title", {
			unicode: "{U+300B}", html: "&#12299;",
			tags: ["asian double right title", "двойная правая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [>][Ю]",
		},
		"asian_left_title", {
			unicode: "{U+3008}", html: "&#12296;",
			tags: ["asian left title", "левая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [<][Б]",
		},
		"asian_right_title", {
			unicode: "{U+3009}", html: "&#12297;",
			tags: ["asian right title", "правая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [>][Ю]",
		},
)

MapInsert(Characters,
	;
	;
	; * Letters Latin
	"lat_c_lig_aa", {
		unicode: "{U+A732}", html: "&#42802;",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!aa", "лигатура AA", "ligature AA"],
		recipe: "AA",
	},
		"lat_s_lig_aa", {
			unicode: "{U+A733}", html: "&#42803;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".aa", "лигатура aa", "ligature aa"],
			recipe: "aa",
		},
		"lat_c_lig_ae", {
			unicode: "{U+00C6}", html: "&#198;", entity: "&AElig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ae", "лигатура AE", "ligature AE"],
			recipe: "AE",
		},
		"lat_s_lig_ae", {
			unicode: "{U+00E6}", html: "&#230;", entity: "&aelig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ae", "лигатура ae", "ligature ae"],
			recipe: "ae",
		},
		"lat_c_lig_ae_acute", {
			unicode: "{U+01FC}", html: "&#508;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!aea", "лигатура AE с акутом", "ligature AE with acute"],
			recipe: ["AE" . GetChar("acute"), Chr(0x00C6) GetChar("acute"), "A" Chr(0x00C9)],
		},
		"lat_s_lig_ae_acute", {
			unicode: "{U+01FD}", html: "&#509;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".aea", "лигатура ae с акутом", "ligature ae with acute"], recipe: ["ae" . GetChar("acute"), Chr(0x00E6) GetChar("acute"), "a" Chr(0x00E9)],
		},
		"lat_c_lig_ae_macron", {
			unicode: "{U+01E2}", html: "&#482;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!aem", "лигатура AE с макроном", "ligature AE with macron"],
			recipe: ["AE" . GetChar("macron"), Chr(0x00C6) GetChar("macron"), "A" Chr(0x0112)],
		},
		"lat_s_lig_ae_macron", {
			unicode: "{U+01E3}", html: "&#483;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".aem", "лигатура ae с макроном", "ligature ae with macron"],
			recipe: ["ae" . GetChar("macron"), Chr(0x00E6) GetChar("macron"), "a" Chr(0x0113)],
		},
		"lat_c_lig_ao", {
			unicode: "{U+A734}", html: "&#42804;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ao", "лигатура AO", "ligature AO"],
			recipe: "AO",
		},
		"lat_s_lig_ao", {
			unicode: "{U+A735}", html: "&#42805;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ao", "лигатура ao", "ligature ao"],
			recipe: "ao",
		},
		"lat_c_lig_au", {
			unicode: "{U+A736}", html: "&#42806;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!au", "лигатура AU", "ligature AU"],
			recipe: "AU",
		},
		"lat_s_lig_au", {
			unicode: "{U+A737}", html: "&#42807;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".au", "лигатура au", "ligature au"],
			recipe: "au",
		},
		"lat_c_lig_av", {
			unicode: "{U+A738}", html: "&#42808;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!av", "лигатура AV", "ligature AV"],
			recipe: "AV",
		},
		"lat_s_lig_av", {
			unicode: "{U+A739}", html: "&#42809;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".av", "лигатура av", "ligature av"],
			recipe: "av",
		},
		"lat_c_lig_avi", {
			unicode: "{U+A73A}", html: "&#42810;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!avi", "лигатура AVI", "ligature AVI"],
			recipe: "AVI",
		},
		"lat_s_lig_avi", {
			unicode: "{U+A73B}", html: "&#42811;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".avi", "лигатура avi", "ligature avi"],
			recipe: "avi",
		},
		"lat_c_lig_ay", {
			unicode: "{U+A73C}", html: "&#42812;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ay", "лигатура AY", "ligature AY"],
			recipe: "AY",
		},
		"lat_s_lig_ay", {
			unicode: "{U+A73D}", html: "&#42813;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ay", "лигатура ay", "ligature ay"],
			recipe: "ay",
		},
		"lat_s_lig_db", {
			unicode: "{U+0238}", html: "&#568;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".db", "лигатура db", "ligature db"],
			recipe: "db",
		},
		"lat_s_lig_et", {
			unicode: "{U+0026}", html: "&#38;", entity: "&amp;",
			altCode: "38",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".et", "лигатура et", "ligature et", "амперсанд", "ampersand"],
			recipe: "et",
		},
		"lat_s_lig_et_turned", {
			unicode: "{U+214B}", html: "&#8523;",
			altCode: "38",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ett", "лигатура перевёрнутый et", "ligature turned et", "перевёрнутый амперсанд", "turned ampersand"],
			recipe: ["et" . Chr(0x21BA), "&" . Chr(0x21BA)],
		},
		"lat_s_lig_ff", {
			unicode: "{U+FB00}", html: "&#64256;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ff", "лигатура ff", "ligature ff"],
			recipe: "ff",
		},
		"lat_s_lig_fi", {
			unicode: "{U+FB01}", html: "&#64257;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".fi", "лигатура fi", "ligature fi"],
			recipe: "fi",
		},
		"lat_s_lig_fl", {
			unicode: "{U+FB02}", html: "&#64258;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".fl", "лигатура fl", "ligature fl"],
			recipe: "fl",
		},
		"lat_s_lig_ft", {
			unicode: "{U+FB05}", html: "&#64261;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ft", "лигатура ft", "ligature ft"],
			recipe: ["ft", Chr(0x017F) . "t"],
		},
		"lat_s_lig_ffi", {
			unicode: "{U+FB03}", html: "&#64259;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ffi", "лигатура ffi", "ligature ffi"],
			recipe: "ffi",
		},
		"lat_s_lig_ffl", {
			unicode: "{U+FB04}", html: "&#64260;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ffl", "лигатура ffl", "ligature ffl"],
			recipe: "ffl",
		},
		"lat_c_lig_ij", {
			unicode: "{U+0132}", html: "&#306;", entity: "&IJlig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ij", "лигатура IJ", "ligature IJ"],
			recipe: "IJ",
		},
		"lat_s_lig_ij", {
			unicode: "{U+0133}", html: "&#307;", entity: "&ijlig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ij", "лигатура ij", "ligature ij"],
			recipe: "ij",
		},
		"lat_s_lig_lb", {
			unicode: "{U+2114}", html: "&#8468;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".lb", "лигатура lb", "ligature lb"],
			recipe: "lb",
		},
		"lat_c_lig_ll", {
			unicode: "{U+1EFA}", html: "&#7930;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ll", "лигатура lL", "ligature lL"],
			recipe: "lL",
		},
		"lat_s_lig_ll", {
			unicode: "{U+1EFB}", html: "&#7931;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ll", "лигатура ll", "ligature ll"],
			recipe: "ll",
		},
		"lat_c_lig_oi", {
			unicode: "{U+01A2}", html: "&#418;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!oi", "лигатура OI", "ligature OI"],
			recipe: "OI",
		},
		"lat_s_lig_oi", {
			unicode: "{U+01A3}", html: "&#419;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".oi", "лигатура oi", "ligature oi"],
			recipe: "oi",
		},
		"lat_c_lig_oe", {
			unicode: "{U+0152}", html: "&#338;", entity: "&OElig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!oe", "лигатура OE", "ligature OE"],
			recipe: "OE",
		},
		"lat_s_lig_oe", {
			unicode: "{U+0153}", html: "&#339;", entity: "&oelig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".oe", "лигатура oe", "ligature oe"],
			recipe: "oe",
		},
		"lat_c_lig_oo", {
			unicode: "{U+A74E}", html: "&#42830;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!oo", "лигатура OO", "ligature OO"],
			recipe: "OO",
		},
		"lat_s_lig_oo", {
			unicode: "{U+A74F}", html: "&#42831;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".oo", "лигатура oo", "ligature oo"],
			recipe: "oo",
		},
		"lat_c_lig_pl", {
			unicode: "{U+214A}", html: "&#8522;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!pl", "лигатура PL", "ligature PL", "Property Line"],
			recipe: "PL",
		},
		"lat_s_lig_ue", {
			unicode: "{U+1D6B}", html: "&#7531;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ue", "лигатура ue", "ligature ue"],
			recipe: "ue",
		},
		"lat_c_lig_eszett", {
			unicode: "{U+1E9E}", html: "&#7838;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ss", "лигатура SS", "ligature SS", "прописной эсцет", "capital eszett"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [S]",
			recipe: ["SS", Chr(0x017F) . "S"],
		},
		"lat_s_lig_eszett", {
			unicode: "{U+00DF}", html: "&#223;", entity: "&szlig;",
			titlesAlt: True,
			group: [["Latin Ligatures"]],
			tags: [".ss", "лигатура ss", "ligature ss", "строчный эсцет", "small eszett"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [s]",
			recipe: ["ss", Chr(0x017F) . "s"],
		},
		"lat_c_lig_vy", {
			unicode: "{U+A760}", html: "&#42848;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!vy", "лигатура VY", "ligature VY"],
			recipe: "VY",
		},
		"lat_s_lig_vy", {
			unicode: "{U+A761}", html: "&#42849;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".vy", "лигатура vy", "ligature vy"],
			recipe: "vy",
		},
		;
		;
		; * Latin Digraphs
		"lat_c_dig_dz", {
			unicode: "{U+01F1}", html: "&#497;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: ["!dz", "диграф DZ", "diagraph DZ"],
			recipe: "DZ",
		},
		"lat_cs_dig_dz", {
			unicode: "{U+01F2}", html: "&#498;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: ["!.dz", "диграф Dz", "diagraph Dz"],
			recipe: "Dz",
		},
		"lat_s_dig_dz", {
			unicode: "{U+01F3}", html: "&#499;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: [".dz", "диграф dz", "diagraph dz"],
			recipe: "dz",
		},
		"lat_c_dig_dz_caron", {
			unicode: "{U+01C4}", html: "&#452;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: ["!dzh", "диграф DZ с гачеком", "diagraph DZ with caron"],
			recipe: ["DZ" GetChar("caron"), Chr(0x01F1) GetChar("caron")],
		},
		"lat_cs_dig_dz_caron", {
			unicode: "{U+01C5}", html: "&#453;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: ["!.dzh", "диграф Dz с гачеком", "diagraph Dz with caron"],
			recipe: ["Dz" . GetChar("caron"), Chr(0x01F2) . GetChar("caron")],
		},
		"lat_s_dig_dz_caron", {
			unicode: "{U+01C6}", html: "&#454;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: [".dzh", "диграф dz с гачеком", "diagraph dz with caron"],
			recipe: ["dz" GetChar("caron"), Chr(0x01F3) GetChar("caron")],
		},
		"lat_s_dig_feng", {
			unicode: "{U+02A9}", html: "&#681;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".fnj", "диграф фэнг", "diagraph feng"],
			recipe: ["fnj", "fŋ"],
		},
		"lat_c_dig_lj", {
			unicode: "{U+01C7}", html: "&#455;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!lj", "диграф LJ", "diagraph LJ"],
			recipe: "LJ",
		},
		"lat_cs_dig_lj", {
			unicode: "{U+01C8}", html: "&#456;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!.lj", "диграф Lj", "diagraph Lj"],
			recipe: "Lj",
		},
		"lat_s_dig_lj", {
			unicode: "{U+01C9}", html: "&#457;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".lj", "диграф lj", "diagraph lj"],
			recipe: "lj",
		},
		"lat_s_dig_ls", {
			unicode: "{U+02AA}", html: "&#682;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ls", "диграф ls", "diagraph ls"],
			recipe: "ls",
		},
		"lat_s_dig_lz", {
			unicode: "{U+02AB}", html: "&#683;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".lz", "диграф lz", "diagraph lz"],
			recipe: "lz",
		},
		"lat_c_dig_nj", {
			unicode: "{U+01CA}", html: "&#458;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!nj", "диграф NJ", "diagraph NJ"],
			recipe: "N-J",
		},
		"lat_cs_dig_nj", {
			unicode: "{U+01CB}", html: "&#459;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!.nj", "диграф Nj", "diagraph Nj"],
			recipe: "N-j",
		},
		"lat_s_dig_nj", {
			unicode: "{U+01CC}", html: "&#460;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".nj", "диграф nj", "diagraph nj"],
			recipe: "n-j",
		},
		"lat_s_dig_st", {
			unicode: "{U+FB06}", html: "&#64262;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".st", "диграф st", "diagraph st"],
			recipe: "st",
		},
		"lat_s_dig_tc", {
			unicode: "{U+02A8}", html: "&#680;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".tc", "диграф tc", "diagraph tc"],
			recipe: ["tc", "t" Chr(0x0255)],
		},
		"lat_s_dig_tch", {
			unicode: "{U+02A7}", html: "&#679;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".tch", "диграф tch", "diagraph tch"],
			recipe: ["tch", "t" Chr(0x0283)],
		},
		"lat_s_dig_ts", {
			unicode: "{U+02A6}", html: "&#678;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ts", "диграф ts", "diagraph ts"],
			recipe: "ts",
		},
		;
		;
		; * Latin Letters
		"lat_c_let_d_insular", {
			unicode: "{U+A779}", html: "&#42873;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["прописная замкнутая D", "capital insular D"],
			recipe: "D0",
		},
		"lat_s_let_d_insular", {
			unicode: "{U+A77A}", html: "&#42874;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["строчная замкнутая d", "small insular d"],
			recipe: "d0",
		},
		"lat_s_let_i_dotless", {
			unicode: "{U+0131}", html: "&#305;", entity: "&imath;",
			titlesAlt: True,
			group: ["Latin Extended"],
			show_on_fast_keys: False,
			tags: ["і без точки", "i dotless"],
			recipe: "i/",
		},
		"lat_s_let_ie", {
			unicode: "{U+AB61}", html: "&#43873;;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["строчная ie", "small ie"],
			recipe: "ie",
		},
		"lat_c_let_thorn", {
			unicode: "{U+00DE}", html: "&#222;", entity: "&THORN;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["!th", "прописной Торн", "capital Thorn"],
			recipe: "TH",
		},
		"lat_s_let_thorn", {
			unicode: "{U+00FE}", html: "&#254;", entity: "&thorn;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: [".th", "строчный торн", "small thorn"],
			recipe: "th",
		},
		"lat_c_let_wynn", {
			unicode: "{U+01F7}", html: "&#503;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["!wy", "прописной винн", "capital wynn"],
			recipe: "WY",
		},
		"lat_s_let_wynn", {
			unicode: "{U+01BF}", html: "&#447;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: [".wy", "строчный винн", "small wynn"],
			recipe: "wy",
		},
		"lat_c_let_nj", {
			unicode: "{U+014A}", html: "&#330;", entity: "&ENG;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["!nj", "прописной энг", "capital eng"],
			recipe: "NJ",
		},
		"lat_s_let_nj", {
			unicode: "{U+014B}", html: "&#331;", entity: "&eng;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: [".nj", "строчный энг", "small eng"],
			recipe: "nj",
		},
		"lat_s_let_s_long", {
			unicode: "{U+017F}", html: "&#383;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["строчное s длинное", "small s long"],
			recipe: "fs",
		},
		;
		;
		; * Accented Latin Letters
		"lat_c_let_a_acute", {
			unicode: "{U+00C1}", html: "&#193;", entity: "&Aacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная A с акутом", "capital A with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[A]",
			recipe: "A" GetChar("acute"),
		},
		"lat_s_let_a_acute", {
			unicode: "{U+00E1}", html: "&#225;", entity: "&aacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная a с акутом", "small a with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[a]",
			recipe: "a" GetChar("acute"),
		},
		"lat_c_let_a_breve", {
			unicode: "{U+0102}", html: "&#258;", entity: "&Abreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с краткой", "capital A with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[A]",
			recipe: "A" GetChar("breve"),
		},
		"lat_s_let_a_breve", {
			unicode: "{U+0103}", html: "&#259;", entity: "&abreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с краткой", "small a with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[a]",
			recipe: "a" GetChar("breve"),
		},
		"lat_c_let_a_breve_acute", {
			unicode: "{U+1EAE}", html: "&#7854;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и акутом", "capital A with breve and acute"],
			recipe: ["A" GetChar("breve", "acute"), Chr(0x0102) GetChar("acute")],
		},
		"lat_s_let_a_breve_acute", {
			unicode: "{U+1EAF}", html: "&#7855;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и акутом", "small a with breve and acute"],
			recipe: ["a" GetChar("breve", "acute"), Chr(0x0103) GetChar("acute")],
		},
		"lat_c_let_a_breve_dot_below", {
			unicode: "{U+1EB6}", html: "&#7862;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и точкой снизу", "capital A with breve and dot below"],
			recipe: ["A" GetChar("breve", "dot_below"), Chr(0x0102) GetChar("dot_below")],
		},
		"lat_s_let_a_breve_dot_below", {
			unicode: "{U+1EB7}", html: "&#7863;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и точкой снизу", "small a with breve and dot below"],
			recipe: ["a" GetChar("breve", "dot_below"), Chr(0x0103) GetChar("dot_below")],
		},
		"lat_c_let_a_breve_grave", {
			unicode: "{U+1EB0}", html: "&#7856;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и грависом", "capital A with breve and grave"],
			recipe: ["A" GetChar("breve", "grave"), Chr(0x0102) GetChar("grave")],
		},
		"lat_s_let_a_breve_grave", {
			unicode: "{U+1EB1}", html: "&#7857;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и грависом", "small a with breve and grave"],
			recipe: ["a" GetChar("breve", "grave"), Chr(0x0103) GetChar("grave")],
		},
		"lat_c_let_a_breve_hook_above", {
			unicode: "{U+1EB2}", html: "&#7858;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и хвостиком сверху", "capital A with breve and hook_above"],
			recipe: ["A" GetChar("breve", "hook_above"), Chr(0x0102) GetChar("hook_above")],
		},
		"lat_s_let_a_breve_hook_above", {
			unicode: "{U+1EB3}", html: "&#7859;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и хвостиком сверху", "small a with breve and hook_above"],
			recipe: ["a" GetChar("breve", "hook_above"), Chr(0x0103) GetChar("hook_above")],
		},
		"lat_c_let_a_breve_tilde", {
			unicode: "{U+1EB4}", html: "&#7860;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и тильдой", "capital A with breve and tilde"],
			recipe: ["A" GetChar("breve", "tilde"), Chr(0x0102) GetChar("tilde")],
		},
		"lat_s_let_a_breve_tilde", {
			unicode: "{U+1EB5}", html: "&#7861;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и тильдой", "small a with breve and tilde"],
			recipe: ["a" GetChar("breve", "tilde"), Chr(0x0103) GetChar("tilde")],
		},
		"lat_c_let_a_breve_inverted", {
			unicode: "{U+0202}", html: "&#514;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с перевёрнутой краткой", "capital A with inverted breve"],
			recipe: "A" GetChar("breve_inverted"),
		},
		"lat_s_let_a_breve_inverted", {
			unicode: "{U+0203}", html: "&#515;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с перевёрнутой краткой", "small a with inverted breve"],
			recipe: "a" GetChar("breve_inverted"),
		},
		"lat_c_let_a_circumflex", {
			unicode: "{U+00C2}", html: "&#194;", entity: "&Acirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с циркумфлексом", "capital A with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [A]",
			recipe: "A" GetChar("circumflex"),
		},
		"lat_s_let_a_circumflex", {
			unicode: "{U+00E2}", html: "&#226;", entity: "&acirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с циркумфлексом", "small a with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [a]",
			recipe: "a" GetChar("circumflex"),
		},
		"lat_c_let_a_circumflex_acute", {
			unicode: "{U+1EA4}", html: "&#7844;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и акутом", "capital A with circumflex and acute"],
			recipe: ["A" GetChar("circumflex", "acute"), Chr(0x00C2) GetChar("acute")],
		},
		"lat_s_let_a_circumflex_acute", {
			unicode: "{U+1EA5}", html: "&#7845;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и акутом", "small a with circumflex and acute"],
			recipe: ["a" GetChar("circumflex", "acute"), Chr(0x00E2) GetChar("acute")],
		},
		"lat_c_let_a_circumflex_dot_below", {
			unicode: "{U+1EAC}", html: "&#7852;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и точкой снизу", "capital A with circumflex and dot below"],
			recipe: ["A" GetChar("circumflex", "dot_below"), Chr(0x00C2) GetChar("dot_below")],
		},
		"lat_s_let_a_circumflex_dot_below", {
			unicode: "{U+1EAD}", html: "&#7853;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и точкой снизу", "small a with circumflex and dot below"],
			recipe: ["a" GetChar("circumflex", "dot_below"), Chr(0x00E2) GetChar("dot_below")],
		},
		"lat_c_let_a_circumflex_grave", {
			unicode: "{U+1EA6}", html: "&#7846;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и грависом", "capital A with circumflex and grave"],
			recipe: ["A" GetChar("circumflex", "grave"), Chr(0x00C2) GetChar("grave")],
		},
		"lat_s_let_a_circumflex_grave", {
			unicode: "{U+1EA7}", html: "&#7847;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и грависом", "small a with circumflex and grave"],
			recipe: ["a" GetChar("circumflex", "grave"), Chr(0x00E2) GetChar("grave")],
		},
		"lat_c_let_a_circumflex_hook_above", {
			unicode: "{U+1EA8}", html: "&#7848;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и хвостиком сверху", "capital A with circumflex and hook above"],
			recipe: ["A" GetChar("circumflex", "hook_above"), Chr(0x00C2) GetChar("hook_above")],
		},
		"lat_s_let_a_circumflex_hook_above", {
			unicode: "{U+1EA9}", html: "&#7849;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и хвостиком сверху", "small a with circumflex and hook above"],
			recipe: ["a" GetChar("circumflex", "hook_above"), Chr(0x00E2) GetChar("hook_above")],
		},
		"lat_c_let_a_circumflex_tilde", {
			unicode: "{U+1EAA}", html: "&#7850;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и тильдой", "capital A with circumflex and tilde"],
			recipe: ["A" GetChar("circumflex", "tilde"), Chr(0x00C2) GetChar("tilde")],
		},
		"lat_s_let_a_circumflex_tilde", {
			unicode: "{U+1EAB}", html: "&#7851;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и тильдой", "small a with circumflex and tilde"],
			recipe: ["a" GetChar("circumflex", "tilde"), Chr(0x00E2) GetChar("tilde")],
		},
		"lat_c_let_a_caron", {
			unicode: "{U+01CD}", html: "&#461;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с гачеком", "capital A with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [A]",
			recipe: "A" GetChar("caron"),
		},
		"lat_s_let_a_caron", {
			unicode: "{U+01CE}", html: "&#462;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с гачеком", "small a with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [a]",
			recipe: "a" GetChar("caron"),
		},
		"lat_c_let_a_dot_above", {
			unicode: "{U+0226}", html: "&#550;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с точкой сверху", "capital A with dot above"],
			recipe: "A" GetChar("dot_above"),
		},
		"lat_s_let_a_dot_above", {
			unicode: "{U+0227}", html: "&#551;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с точкой сверху", "small a with dot above"],
			recipe: "a" GetChar("dot_above"),
		},
		"lat_c_let_a_dot_above_macron", {
			unicode: "{U+01E0}", html: "&#480;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с точкой сверху и макроном", "capital A with dot above and macron"],
			recipe: ["A" GetChar("dot_above", "macron"), Chr(0x0226) GetChar("macron")],
		},
		"lat_s_let_a_dot_above_macron", {
			unicode: "{U+01E1}", html: "&#481;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с точкой сверху и макроном", "small a with dot above and macron"],
			recipe: ["a" GetChar("dot_above", "macron"), Chr(0x0227) GetChar("macron")],
		},
		"lat_c_let_a_dot_below", {
			unicode: "{U+1EA0}", html: "&#7840;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с точкой снизу", "capital A with dot below"],
			recipe: "A" GetChar("dot_below"),
		},
		"lat_s_let_a_dot_below", {
			unicode: "{U+1EA1}", html: "&#7841;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с точкой снизу", "small a with dot below"],
			recipe: "a" GetChar("dot_below"),
		},
		"lat_c_let_a_diaeresis", {
			unicode: "{U+00C4}", html: "&#196;", entity: "&Auml;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с диерезисом", "capital A with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [A]",
			recipe: "A" GetChar("diaeresis"),
		},
		"lat_s_let_a_diaeresis", {
			unicode: "{U+00E4}", html: "&#228;", entity: "&auml;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с диерезисом", "small a with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [a]",
			recipe: "a" GetChar("diaeresis"),
		},
		"lat_c_let_a_diaeresis_macron", {
			unicode: "{U+01DE}", html: "&#478;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с диерезисом и макроном", "capital A with diaeresis and macron"],
			recipe: ["A" GetChar("diaeresis", "macron"), Chr(0x00C4) GetChar("macron")],
		},
		"lat_s_let_a_diaeresis_macron", {
			unicode: "{U+01DF}", html: "&#479;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с диерезисом и макроном", "small a with diaeresis and macron"],
			recipe: ["a" GetChar("diaeresis", "macron"), Chr(0x00E4) GetChar("macron")],
		},
		"lat_c_let_a_grave", {
			unicode: "{U+00C0}", html: "&#192;", entity: "&Agrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с грависом", "capital A with grave"],
			recipe: "A" GetChar("grave"),
		},
		"lat_s_let_a_grave", {
			unicode: "{U+00E0}", html: "&#224;", entity: "&agrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с грависом", "small a with grave"],
			recipe: "a" GetChar("grave"),
		},
		"lat_c_let_a_grave_double", {
			unicode: "{U+0200}", html: "&#512;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с двойным грависом", "capital A with double grave"],
			recipe: "A" GetChar("grave_double"),
		},
		"lat_s_let_a_grave_double", {
			unicode: "{U+0201}", html: "&#513;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с двойным грависом", "small a with double grave"],
			recipe: "a" GetChar("grave_double"),
		},
		"lat_c_let_a_hook_above", {
			unicode: "{U+1EA2}", html: "&#7842;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с хвостиком сверху", "capital A with hook above"],
			recipe: "A" GetChar("hook_above"),
		},
		"lat_s_let_a_hook_above", {
			unicode: "{U+1EA3}", html: "&#7843;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с хвостиком сверху", "small a with hook above"],
			recipe: "a" GetChar("hook_above"),
		},
		"lat_s_let_a_retroflex_hook", {
			unicode: "{U+1D8F}", html: "&#7567;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с ретрофлексным крюком", "small a with retroflex hook"],
			recipe: "a" GetChar("retroflex_hook_below"),
		},
		"lat_c_let_a_macron", {
			unicode: "{U+0100}", html: "&#256;", entity: "&Amacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с макроном", "capital A with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [A]",
			recipe: "A" GetChar("macron"),
		},
		"lat_s_let_a_macron", {
			unicode: "{U+0101}", html: "&#257;", entity: "&amacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с макроном", "small a with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [a]",
			recipe: "a" GetChar("macron"),
		},
		"lat_c_let_a_ring_above", {
			unicode: "{U+00C5}", html: "&#197;", entity: "&Aring;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с кольцом сверху", "capital A with ring above"],
			recipe: "A" GetChar("ring_above"),
		},
		"lat_s_let_a_ring_above", {
			unicode: "{U+00E5}", html: "&#229;", entity: "&aring;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с кольцом сверху", "small a with ring above"],
			recipe: "a" GetChar("ring_above"),
		},
		"lat_c_let_a_ring_above_acute", {
			unicode: "{U+01FA}", html: "&#506;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с кольцом сверху и акутом", "capital A with ring above and acute"],
			recipe: ["A" GetChar("ring_above", "acute"), Chr(0x00C5) GetChar("acute")],
		},
		"lat_s_let_a_ring_above_acute", {
			unicode: "{U+01FB}", html: "&#507;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с кольцом сверху и акутом", "small a with ring above and acute"],
			recipe: ["a" GetChar("ring_above", "acute"), Chr(0x00E5) GetChar("acute")],
		},
		"lat_c_let_a_ring_below", {
			unicode: "{U+1E00}", html: "&#7680;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с кольцом снизу", "capital A with ring below"],
			recipe: "A" GetChar("ring_below"),
		},
		"lat_s_let_a_ring_below", {
			unicode: "{U+1E01}", html: "&#7681;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с кольцом снизу", "small a with ring below"],
			recipe: "a" GetChar("ring_below"),
		},
		"lat_c_let_a_solidus_long", {
			unicode: "{U+023A}", html: "&#570;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с наклонной чертой", "capital A with solidus"],
			recipe: "A" GetChar("solidus_long"),
		},
		"lat_s_let_a_solidus_long", {
			unicode: "{U+2C65}", html: "&#11365;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с наклонной чертой", "small a with solidus"],
			recipe: "a" GetChar("solidus_long"),
		},
		"lat_c_let_a_ogonek", {
			unicode: "{U+0104}", html: "&#260;", entity: "&Aogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с огонэком", "capital A with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [A]",
			recipe: "A" GetChar("ogonek"),
		},
		"lat_s_let_a_ogonek", {
			unicode: "{U+0105}", html: "&#261;", entity: "&aogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с огонэком", "small a with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [a]",
			recipe: "a" GetChar("ogonek"),
		},
		"lat_c_let_a_tilde", {
			unicode: "{U+00C3}", html: "&#195;", entity: "&Atilde;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с тильдой", "capital A with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [A]",
			recipe: "A" GetChar("tilde"),
		},
		"lat_s_let_a_tilde", {
			unicode: "{U+00E3}", html: "&#227;", entity: "&atilde;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с тильдой", "small a with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [a]",
			recipe: "a" GetChar("tilde"),
		},
		;
		"lat_c_let_b_dot_above", {
			unicode: "{U+1E02}", html: "&#7682;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с точкой сверху", "capital B with dot above"],
			recipe: "B" GetChar("dot_above"),
		},
		"lat_s_let_b_dot_above", {
			unicode: "{U+1E03}", html: "&#7683;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с точкой сверху", "small b with dot above"],
			recipe: "b" GetChar("dot_above"),
		},
		"lat_c_let_b_dot_below", {
			unicode: "{U+1E04}", html: "&#7684;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с точкой снизу", "capital B with dot below"],
			recipe: "B" GetChar("dot_below"),
		},
		"lat_s_let_b_dot_below", {
			unicode: "{U+1E05}", html: "&#7685;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с точкой снизу", "small b with dot below"],
			recipe: "b" GetChar("dot_below"),
		},
		"lat_c_let_b_hook", {
			unicode: "{U+0181}", html: "&#385;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная B с крючком", "capital B with hook"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift "[B]",
			recipe: "B" GetChar("arrow_left"),
		},
		"lat_s_let_b_hook", {
			unicode: "{U+0253}", html: "&#595;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная b с крючком", "small b with hook"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift "[b]",
			recipe: "b" . GetChar("arrow_left"),
		},
		"lat_s_let_b_palatal_hook", {
			unicode: "{U+1D80}", html: "&#7552;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с палатальным крюком", "small b with palatal hook"],
			recipe: "b" GetChar("palatal_hook_below"),
		},
		"lat_c_let_b_flourish", {
			unicode: "{U+A796}", html: "&#42902;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с завитком", "capital B with flourish"],
			recipe: "B" . GetChar("arrow_left_ushaped"),
		},
		"lat_s_let_b_flourish", {
			unicode: "{U+A797}", html: "&#42903;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с завитком", "small b with flourish"],
			recipe: "b" . GetChar("arrow_left_ushaped"),
		},
		"lat_c_let_b_line_below", {
			unicode: "{U+1E06}", html: "&#7686;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с чертой снизу", "capital B with line below"],
			recipe: "B" GetChar("macron_below"),
		},
		"lat_s_let_b_line_below", {
			unicode: "{U+1E07}", html: "&#7687;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с чертой снизу", "small b with line below"],
			recipe: "b" GetChar("macron_below"),
		},
		"lat_c_let_b_stroke_short", {
			unicode: "{U+0243}", html: "&#579;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная B со штрихом", "capital B with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[B]",
			recipe: "B" GetChar("stroke_short"),
		},
		"lat_s_let_b_stroke_short", {
			unicode: "{U+0180}", html: "&#384;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная b со штрихом", "small b with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[b]",
			recipe: "b" GetChar("stroke_short"),
		},
		"lat_s_let_b_tilde_overlay", {
			unicode: "{U+1D6C}", html: "&#7532;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с тильдой посередине", "small b with middle tilde"],
			recipe: "b" GetChar("tilde_overlay"),
		},
		"lat_c_let_b_topbar", {
			unicode: "{U+0182}", html: "&#386;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с чертой сверху", "capital B with topbar"],
			recipe: "B" . GetChar("arrow_up"),
		},
		"lat_s_let_b_topbar", {
			unicode: "{U+0183}", html: "&#387;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с чертой сверху", "small b with topbar"],
			recipe: "b" . GetChar("arrow_up"),
		},
		;
		"lat_c_let_c_acute", {
			unicode: "{U+0106}", html: "&#262;", entity: "&Cacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная C с акутом", "capital C with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[C]",
			recipe: "C" GetChar("acute"),
		},
		"lat_s_let_c_acute", {
			unicode: "{U+0107}", html: "&#263;", entity: "&cacute;",
			titlesAlt: True,
			group: ["Latin Accented"],
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная c с акутом", "small c with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[c]",
			recipe: "c" GetChar("acute"),
		},
		"lat_c_let_c_circumflex", {
			unicode: "{U+0108}", html: "&#264;", entity: "&Ccirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная C с циркумфлексом", "capital C with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [C]",
			recipe: "C" GetChar("circumflex"),
		},
		"lat_s_let_c_circumflex", {
			unicode: "{U+0109}", html: "&#265;", entity: "&ccirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная c с циркумфлексом", "small c with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [c]",
			recipe: "c" GetChar("circumflex"),
		},
		"lat_c_let_c_caron", {
			unicode: "{U+010C}", html: "&#268;", entity: "&Ccaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная C с гачеком", "capital C with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [C]",
			recipe: "C" GetChar("caron"),
		},
		"lat_s_let_c_caron", {
			unicode: "{U+010D}", html: "&#269;", entity: "&ccaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная c с гачеком", "small c with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [c]",
			recipe: "c" GetChar("caron"),
		},
		"lat_c_let_c_cedilla", {
			unicode: "{U+00C7}", html: "&#199;", entity: "&Ccedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная C с седилью", "capital C with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [C]",
			recipe: "C" GetChar("cedilla"),
		},
		"lat_s_let_c_cedilla", {
			unicode: "{U+00E7}", html: "&#231;", entity: "&ccedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная c с седилью", "small c with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [c]",
			recipe: "c" GetChar("cedilla"),
		},
		"lat_c_let_c_cedilla_acute", {
			unicode: "{U+1E08}", html: "&#7688;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с седилью", "capital C with cedilla"],
			recipe: ["C" GetChar("cedilla", "acute"), Chr(0x00C7) GetChar("acute")],
		},
		"lat_s_let_c_cedilla_acute", {
			unicode: "{U+1E09}", html: "&#7689;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с седилью", "small c with cedilla"],
			recipe: ["c" GetChar("cedilla", "acute"), Chr(0x00E7) GetChar("acute")],
		},
		"lat_s_let_c_curl", {
			unicode: "{U+0255}", html: "&#597;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с завитком", "small c with curl"],
			recipe: "c" GetChar("arrow_left_ushaped"),
		},
		"lat_c_let_c_dot_above", {
			unicode: "{U+010A}", html: "&#266;", entity: "&Cdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с точкой сверху", "capital C with dot above"],
			recipe: "C" GetChar("dot_above"),
		},
		"lat_s_let_c_dot_above", {
			unicode: "{U+010B}", html: "&#267;", entity: "&cdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с точкой сверху", "small c with dot above"],
			recipe: "c" GetChar("dot_above"),
		},
		"lat_c_let_c_reversed_dot_middle", {
			unicode: "{U+A73E}", html: "&#42814;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная обратная C с точкой", "capital reversed C with middle dot"],
			recipe: "C" GetChar("arrow_left_circle") "·",
		},
		"lat_s_let_c_reversed_dot_middle", {
			unicode: "{U+A73F}", html: "&#42815;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная обратная c с точкой", "small reversed c with middle dot"],
			recipe: "c" GetChar("arrow_left_circle") "·",
		},
		"lat_c_let_c_hook", {
			unicode: "{U+0187}", html: "&#391;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с крючком", "capital C with hook"],
			recipe: "C" . GetChar("arrow_up"),
		},
		"lat_s_let_c_hook", {
			unicode: "{U+0188}", html: "&#392;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с крючком", "small c with hook"],
			recipe: "c" . GetChar("arrow_up"),
		},
		"lat_c_let_c_palatal_hook", {
			unicode: "{U+A7C4}", html: "&#42948;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с палатальным крюком", "capital C with palatal hook"],
			recipe: "C" GetChar("palatal_hook_below"),
		},
		"lat_s_let_c_palatal_hook", {
			unicode: "{U+A794}", html: "&#42900;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с палатальным крюком", "small c with palatal hook"],
			recipe: "c" GetChar("palatal_hook_below"),
		},
		"lat_s_let_c_retroflex_hook", {
			unicode: "{U+1DF1D}", html: "&#122653;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с ретрофлксным крюком", "small c with retroflex hook"],
			recipe: "c" GetChar("retroflex_hook_below"),
		},
		"lat_c_let_c_solidus_long", {
			unicode: "{U+023B}", html: "&#571;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с косым штрихом", "capital C with solidus"],
			recipe: "C" GetChar("solidus_long"),
		},
		"lat_s_let_c_solidus_long", {
			unicode: "{U+023C}", html: "&#572;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с косым штрихом", "small c with solidus"],
			recipe: "c" GetChar("solidus_long"),
		},
		"lat_c_let_c_stroke_short", {
			unicode: "{U+A792}", html: "&#42898;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C со штрихом", "capital C with stroke"],
			recipe: "C" GetChar("stroke_short"),
		},
		"lat_s_let_c_stroke_short", {
			unicode: "{U+A793}", html: "&#42899;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c со штрихом", "small c with stroke"],
			recipe: "c" GetChar("stroke_short"),
		},
		;
		"lat_c_let_d_circumflex_below", {
			unicode: "{U+1E12}", html: "&#7698;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D с циркумфлексом снизу", "capital D with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [D]",
			recipe: "D" GetChar("circumflex_below"),
		},
		"lat_s_let_d_circumflex_below", {
			unicode: "{U+1E13}", html: "&#7699;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d с циркумфлексом снизу", "small d with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [d]",
			recipe: "d" GetChar("circumflex_below"),
		},
		"lat_c_let_d_caron", {
			unicode: "{U+010E}", html: "&#270;", entity: "&Dcaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D с гачеком", "capital D with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [D]",
			recipe: "D" GetChar("caron"),
		},
		"lat_s_let_d_caron", {
			unicode: "{U+010F}", html: "&#271;", entity: "&dcaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d с гачеком", "small d with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [d]",
			recipe: "d" GetChar("caron"),
		},
		"lat_c_let_d_cedilla", {
			unicode: "{U+1E10}", html: "&#7696;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D с седилью", "capital D with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [D]",
			recipe: "D" GetChar("cedilla"),
		},
		"lat_s_let_d_cedilla", {
			unicode: "{U+1E11}", html: "&#7697;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d с седилью", "small d with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [d]",
			recipe: "d" GetChar("cedilla"),
		},
		"lat_s_let_d_curl", {
			unicode: "{U+0221}", html: "&#545;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с завитком", "small d with curl"],
			recipe: "d" GetChar("arrow_left_ushaped"),
		},
		"lat_c_let_d_dot_above", {
			unicode: "{U+1E0A}", html: "&#7690;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с точкой сверху", "capital D with dot above"],
			recipe: "D" GetChar("dot_above"),
		},
		"lat_s_let_d_dot_above", {
			unicode: "{U+1E0B}", html: "&#7691;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с точкой сверху", "small d with dot above"],
			recipe: "d" GetChar("dot_above"),
		},
		"lat_c_let_d_eth", {
			unicode: "{U+00D0}", html: "&#208;", entity: "&ETH;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная Эт", "capital Eth"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[D]",
			recipe: "D" GetChar("solidus_short"),
		},
		"lat_s_let_d_eth", {
			unicode: "{U+00F0}", html: "&#240;", entity: "&eth;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная эт", "small eth"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[d]",
			recipe: "d" GetChar("solidus_short"),
		},
		"lat_c_let_d_dot_below", {
			unicode: "{U+1E0C}", html: "&#7692;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с точкой снизу", "capital D with dot below"],
			recipe: "D" GetChar("dot_below"),
		},
		"lat_s_let_d_dot_below", {
			unicode: "{U+1E0D}", html: "&#7693;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с точкой снизу", "small d with dot below"],
			recipe: "d" GetChar("dot_below"),
		},
		"lat_c_let_d_hook", {
			unicode: "{U+018A}", html: "&#394;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с крючком", "capital D with hook"],
			recipe: "D" GetChar("arrow_left"),
		},
		"lat_s_let_d_hook", {
			unicode: "{U+0257}", html: "&#599;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с крючком", "small d with hook"],
			recipe: "d" GetChar("arrow_left"),
		},
		"lat_s_let_d_hook_retroflex_hook", {
			unicode: "{U+1D91}", html: "&#7569;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с хвостиком и ретрофлексным крюком", "small d with hook and retroflex hook"],
			recipe: "d" GetChar("arrow_left", "retroflex_hook_below"),
		},
		"lat_s_let_d_palatal_hook", {
			unicode: "{U+1D81}", html: "&#7553;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с палатальным крюком", "small d with palatal hook"],
			recipe: "d" GetChar("palatal_hook_below"),
		},
		"lat_s_let_d_retroflex_hook", {
			unicode: "{U+0256}", html: "&#598;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с ретрофлексным крюком", "small d with retroflex hook"],
			recipe: "d" GetChar("retroflex_hook_below"),
		},
		"lat_c_let_d_line_below", {
			unicode: "{U+1E0E}", html: "&#7694;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с чертой снизу", "capital D with line below"],
			recipe: "D" GetChar("macron_below"),
		},
		"lat_s_let_d_line_below", {
			unicode: "{U+1E0F}", html: "&#7695;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с чертой снизу", "small d with line below"],
			recipe: "d" GetChar("macron_below"),
		},
		"lat_c_let_d_stroke_short", {
			unicode: "{U+0110}", html: "&#272;", entity: "&Dstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D со штрихом", "capital D with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [D]",
			recipe: "D" GetChar("stroke_short"),
		},
		"lat_s_let_d_stroke_short", {
			unicode: "{U+0111}", html: "&#273;", entity: "&dstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d со штрихом", "small d with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [d]",
			recipe: "d" GetChar("stroke_short"),
		},
		"lat_c_let_d_stroke_s2", {
			unicode: "{U+A7C7}", html: "&#42951;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D со штрихом посередине", "capital D with short stroke overlay"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[D]",
			recipe: "D" GetChar("stroke_long"),
		},
		"lat_s_let_d_stroke_s2", {
			unicode: "{U+A7C8}", html: "&#42952;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d со штрихом посередине", "small d with short stroke overlay"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[d]",
			recipe: "d" GetChar("stroke_long"),
		},
		"lat_s_let_d_tilde_overlay", {
			unicode: "{U+1D6D}", html: "&#7533;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с тильдой посередине", "small d with middle tilde"],
			recipe: "d" GetChar("tilde_overlay"),
		},
		"lat_c_let_d_topbar", {
			unicode: "{U+018B}", html: "&#395;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с чертой сверху", "capital D with topbar"],
			recipe: "D" . GetChar("arrow_up"),
		},
		"lat_s_let_d_topbar", {
			unicode: "{U+018C}", html: "&#396;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с чертой сверху", "small d with topbar"],
			recipe: "d" . GetChar("arrow_up"),
		},
		"lat_c_let_e_acute", {
			unicode: "{U+00C9}", html: "&#201;", entity: "&Eacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная E с акутом", "capital E with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[E]",
			recipe: "E" GetChar("acute"),
		},
		"lat_s_let_e_acute", {
			unicode: "{U+00E9}", html: "&#233;", entity: "&eacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная e с акутом", "small e with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[e]",
			recipe: "e" GetChar("acute"),
		},
		"lat_c_let_e_breve", {
			unicode: "{U+0114}", html: "&#276;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с краткой", "capital E with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[E]",
			recipe: "E" GetChar("breve"),
		},
		"lat_s_let_e_breve", {
			unicode: "{U+0115}", html: "&#277;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с краткой", "small e with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[e]",
			recipe: "e" GetChar("breve"),
		},
		"lat_c_let_e_breve_cedilla", {
			unicode: "{U+1E1C}", html: "&#7708;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с краткой и акутом", "capital E with breve and cedilla"],
			recipe: ["E" GetChar("breve", "cedilla"), Chr(0x0114) GetChar("cedilla")],
		},
		"lat_s_let_e_breve_cedilla", {
			unicode: "{U+1E1D}", html: "&#7709;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с краткой и акутом", "small e with breve and cedilla"],
			recipe: ["e" GetChar("breve", "cedilla"), Chr(0x0115) GetChar("cedilla")],
		},
		"lat_c_let_e_breve_inverted", {
			unicode: "{U+0206}", html: "&#518;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с перевёрнутой краткой", "capital E with inverted breve"],
			recipe: "E" GetChar("breve_inverted"),
		},
		"lat_s_let_e_breve_inverted", {
			unicode: "{U+0207}", html: "&#519;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с перевёрнутой краткой", "small e with inverted breve"],
			recipe: "e" GetChar("breve_inverted"),
		},
		"lat_c_let_e_circumflex", {
			unicode: "{U+00CA}", html: "&#202;", entity: "&Ecirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с циркумфлексом", "capital E with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [E]",
			recipe: "E" GetChar("circumflex"),
		},
		"lat_s_let_e_circumflex", {
			unicode: "{U+00EA}", html: "&#234;", entity: "&ecirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с циркумфлексом", "small e with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [e]",
			recipe: "e" GetChar("circumflex"),
		},
		"lat_c_let_e_circumflex_acute", {
			unicode: "{U+1EBE}", html: "&#7870;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и акутом", "capital E with circumflex and acute"],
			recipe: ["E" GetChar("circumflex", "acute"), Chr(0x00CA) GetChar("acute")],
		},
		"lat_s_let_e_circumflex_acute", {
			unicode: "{U+1EBF}", html: "&#7871;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и акутом", "small e with circumflex and acute"],
			recipe: ["e" GetChar("circumflex", "acute"), Chr(0x00EA) GetChar("acute")],
		},
		"lat_c_let_e_circumflex_dot_below", {
			unicode: "{U+1EC6}", html: "&#7878;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и точкой снизу", "capital E with circumflex and dot below"],
			recipe: ["E" GetChar("circumflex", "dot_below"), Chr(0x00CA) GetChar("dot_below")],
		},
		"lat_s_let_e_circumflex_dot_below", {
			unicode: "{U+1EC7}", html: "&#7879;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и точкой снизу", "small e with circumflex and dot below"],
			recipe: ["e" GetChar("circumflex", "dot_below"), Chr(0x00EA) GetChar("dot_below")],
		},
		"lat_c_let_e_circumflex_grave", {
			unicode: "{U+1EC0}", html: "&#7872;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и грависом", "capital E with circumflex and grave"],
			recipe: ["E" GetChar("circumflex", "grave"), Chr(0x00CA) GetChar("grave")],
		},
		"lat_s_let_e_circumflex_grave", {
			unicode: "{U+1EC1}", html: "&#7873;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и грависом", "small e with circumflex and grave"],
			recipe: ["e" GetChar("circumflex", "grave"), Chr(0x00EA) GetChar("grave")],
		},
		"lat_c_let_e_circumflex_hook_above", {
			unicode: "{U+1EC2}", html: "&#7874;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и хвостиком сверху", "capital E with circumflex and hook above"],
			recipe: ["E" GetChar("circumflex", "hook_above"), Chr(0x00CA) GetChar("hook_above")],
		},
		"lat_s_let_e_circumflex_hook_above", {
			unicode: "{U+1EC3}", html: "&#7875;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и хвостиком сверху", "small e with circumflex and hook above"],
			recipe: ["e" GetChar("circumflex", "hook_above"), Chr(0x00EA) GetChar("hook_above")],
		},
		"lat_c_let_e_circumflex_tilde", {
			unicode: "{U+1EC4}", html: "&#7876;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и тильдой", "capital E with circumflex and tilde"],
			recipe: ["E" GetChar("circumflex", "tilde"), Chr(0x00CA) GetChar("tilde")],
		},
		"lat_s_let_e_circumflex_tilde", {
			unicode: "{U+1EC5}", html: "&#7877;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и тильдой", "small e with circumflex and tilde"],
			recipe: ["e" GetChar("circumflex", "tilde"), Chr(0x00EA) GetChar("tilde")],
		},
		"lat_c_let_e_circumflex_below", {
			unicode: "{U+1E18}", html: "&#7704;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с циркумфлексом снизу", "capital E with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [E]",
			recipe: "E" GetChar("circumflex_below"),
		},
		"lat_s_let_e_circumflex_below", {
			unicode: "{U+1E19}", html: "&#7705;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с циркумфлексом снизу", "small e with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [e]",
			recipe: "e" GetChar("circumflex_below"),
		},
		"lat_c_let_e_caron", {
			unicode: "{U+011A}", html: "&#282;", entity: "&Ecaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с гачеком", "capital E with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [E]",
			recipe: "E" GetChar("caron"),
		},
		"lat_s_let_e_caron", {
			unicode: "{U+011B}", html: "&#283;", entity: "&ecaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с гачеком", "small e with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [e]",
			recipe: "e" GetChar("caron"),
		},
		"lat_c_let_e_cedilla", {
			unicode: "{U+0228}", html: "&#552;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с седилью", "capital E with cedilla"],
			recipe: "E" GetChar("cedilla"),
		},
		"lat_s_let_e_cedilla", {
			unicode: "{U+0229}", html: "&#553;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с седилью", "small e with cedilla"],
			recipe: "e" GetChar("cedilla"),
		},
		"lat_c_let_e_dot_above", {
			unicode: "{U+0116}", html: "&#278;", entity: "&Edot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с точкой сверху", "capital E with dot above"],
			recipe: "E" GetChar("dot_above"),
		},
		"lat_s_let_e_dot_above", {
			unicode: "{U+0117}", html: "&#279;", entity: "&edot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с точкой сверху", "small e with dot above"],
			recipe: "e" GetChar("dot_above"),
		},
		"lat_c_let_e_dot_below", {
			unicode: "{U+1EB8}", html: "&#7864;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с точкой снизу", "capital E with dot below"],
			recipe: "E" GetChar("dot_below"),
		},
		"lat_s_let_e_dot_below", {
			unicode: "{U+1EB9}", html: "&#7865;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с точкой снизу", "small e with dot below"],
			recipe: "e" GetChar("dot_below"),
		},
		"lat_c_let_e_diaeresis", {
			unicode: "{U+00CB}", html: "&#203;", entity: "&Euml;",
			titlesAlt: True,
			group: ["Latin Accented"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [E]",
			tags: ["прописная E с диерезисом", "capital EA with diaeresis"],
			recipe: "E" GetChar("diaeresis"),
		},
		"lat_s_let_e_diaeresis", {
			unicode: "{U+00EB}", html: "&#235;", entity: "&euml;",
			titlesAlt: True,
			group: ["Latin Accented"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [e]",
			tags: ["строчная e с диерезисом", "small e with diaeresis"],
			recipe: "e" GetChar("diaeresis"),
		},
		"lat_c_let_e_grave", {
			unicode: "{U+00C8}", html: "&#200;", entity: "&Egrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с грависом", "capital E with grave"],
			recipe: "E" GetChar("grave"),
		},
		"lat_s_let_e_grave", {
			unicode: "{U+00E8}", html: "&#232;", entity: "&egrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с грависом", "small e with grave"],
			recipe: "e" GetChar("grave"),
		},
		"lat_c_let_e_grave_double", {
			unicode: "{U+0204}", html: "&#516;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с двойным грависом", "capital E with double grave"],
			recipe: "E" GetChar("grave_double"),
		},
		"lat_s_let_e_grave_double", {
			unicode: "{U+0205}", html: "&#517;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с двойным грависом", "small e with double grave"],
			recipe: "e" GetChar("grave_double"),
		},
		"lat_c_let_e_hook_above", {
			unicode: "{U+1EBA}", html: "&#7866;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с хвостиком сверху", "capital E with hook above"],
			recipe: "E" GetChar("hook_above"),
		},
		"lat_s_let_e_hook_above", {
			unicode: "{U+1EBB}", html: "&#7867;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с хвостиком сверху", "small e with hook above"],
			recipe: "e" GetChar("hook_above"),
		},
		"lat_s_let_e_retroflex_hook", {
			unicode: "{U+1D92}", html: "&#7570;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с ретрофлексным крюком", "small e with retroflex hook"],
			recipe: "e" GetChar("retroflex_hook_below"),
		},
		"lat_s_let_e_notch", {
			unicode: "{U+2C78}", html: "&#11384;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с бороздой", "small e with notch"],
			recipe: "e" . GetChar("arrow_right"),
		},
		"lat_c_let_e_macron", {
			unicode: "{U+0112}", html: "&#274;", entity: "&Emacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с макроном", "capital E with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [E]",
			recipe: "E" GetChar("macron"),
		},
		"lat_s_let_e_macron", {
			unicode: "{U+0113}", html: "&#275;", entity: "&emacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с макроном", "small e with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [e]",
			recipe: "e" GetChar("macron"),
		},
		"lat_c_let_e_macron_acute", {
			unicode: "{U+1E16}", html: "&#7702;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с макроном и акутом", "capital E with macron and acute"],
			recipe: ["E" GetChar("macron", "acute"), Chr(0x0112) GetChar("acute")],
		},
		"lat_s_let_e_macron_acute", {
			unicode: "{U+1E17}", html: "&#7703;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с макроном и акутом", "small e with macron and acute"],
			recipe: ["e" GetChar("macron", "acute"), Chr(0x0113) GetChar("acute")],
		},
		"lat_c_let_e_macron_grave", {
			unicode: "{U+1E14}", html: "&#7700;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с макроном и грависом", "capital E with macron and grave"],
			recipe: ["E" GetChar("macron", "grave"), Chr(0x0112) GetChar("grave")],
		},
		"lat_s_let_e_macron_grave", {
			unicode: "{U+1E15}", html: "&#7701;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с макроном и грависом", "small e with macron and grave"],
			recipe: ["e" GetChar("macron", "grave"), Chr(0x0113) GetChar("grave")],
		},
		"lat_c_let_e_solidus_long", {
			unicode: "{U+0246}", html: "&#582;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с наклонной чертой", "capital E with solidus"],
			recipe: "E" GetChar("solidus_long"),
		},
		"lat_s_let_e_solidus_long", {
			unicode: "{U+0247}", html: "&#583;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с наклонной чертой", "small e with solidus"],
			recipe: "e" GetChar("solidus_long"),
		},
		"lat_c_let_e_ogonek", {
			unicode: "{U+0118}", html: "&#280;", entity: "&Eogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с огонэком", "capital E with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [E]",
			recipe: "E" GetChar("ogonek"),
		},
		"lat_s_let_e_ogonek", {
			unicode: "{U+0119}", html: "&#281;", entity: "&eogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с огонэком", "small e with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [e]",
			recipe: "e" GetChar("ogonek"),
		},
		"lat_c_let_e_tilde", {
			unicode: "{U+1EBC}", html: "&#7868;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с тильдой", "capital E with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [E]",
			recipe: "E" GetChar("tilde"),
		},
		"lat_s_let_e_tilde", {
			unicode: "{U+1EBD}", html: "&#7869;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с тильдой", "small e with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [e]",
			recipe: "e" GetChar("tilde"),
		},
		"lat_c_let_e_tilde_below", {
			unicode: "{U+1E1A}", html: "&#7706;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с тильдой", "capital E with tilde"],
			recipe: "E" GetChar("tilde_below"),
		},
		"lat_s_let_e_tilde_below", {
			unicode: "{U+1E1B}", html: "&#7707;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с тильдой", "small e with tilde"],
			recipe: "e" GetChar("tilde_below"),
		},
		"lat_c_let_f_dot_above", {
			unicode: "{U+1E1E}", html: "&#7710;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная F с точкой сверху", "capital F with dot above"],
			recipe: "F" GetChar("dot_above"),
		},
		"lat_s_let_f_dot_above", {
			unicode: "{U+1E1F}", html: "&#7711;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с точкой сверху", "small f with dot above"],
			recipe: "f" GetChar("dot_above"),
		},
		"lat_c_let_f_hook", {
			unicode: "{U+0191}", html: "&#401;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная F с крюком", "capital F with hook"],
			recipe: "F" GetChar("arrow_down"),
		},
		"lat_s_let_f_hook", {
			unicode: "{U+0192}", html: "&#402;", entity: "&fnof;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с крюком", "small f with hook"],
			recipe: "f" GetChar("arrow_down"),
		},
		"lat_s_let_f_palatal_hook", {
			unicode: "{U+1D82}", html: "&#7554;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с палатальным крюком", "small f with palatal hook"],
			recipe: "f" GetChar("palatal_hook_below"),
		},
		"lat_c_let_f_stroke_short", {
			unicode: "{U+A798}", html: "&#42904;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная F со штрихом", "capital F with stroke"],
			recipe: "F" GetChar("stroke_short"),
		},
		"lat_s_let_f_stroke_short", {
			unicode: "{U+A799}", html: "&#42905;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f со штрихом", "small f with stroke"],
			recipe: "f" GetChar("stroke_short"),
		},
		"lat_s_let_f_tilde_overlay", {
			unicode: "{U+1D6E}", html: "&#7534;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с тильдой посередине", "small f with tilde overlay"],
			recipe: "f" GetChar("tilde_overlay"),
		},
		"lat_c_let_g_acute", {
			unicode: "{U+01F4}", html: "&#500;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная G с акутом", "capital G with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[G]",
			recipe: "G" GetChar("acute"),
		},
		"lat_s_let_g_acute", {
			unicode: "{U+01F5}", html: "&#501;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная g с акутом", "small g with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[g]",
			recipe: "g" GetChar("acute"),
		},
		"lat_c_let_g_breve", {
			unicode: "{U+011E}", html: "&#286;", entity: "&Gbreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с краткой", "capital G with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[G]",
			recipe: "G" GetChar("breve"),
		},
		"lat_s_let_g_breve", {
			unicode: "{U+011F}", html: "&#287;", entity: "&gbreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с краткой", "small g with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[g]",
			recipe: "g" GetChar("breve"),
		},
		"lat_c_let_g_circumflex", {
			unicode: "{U+011C}", html: "&#284;", entity: "&Gcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с циркумфлексом", "capital G with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [G]",
			recipe: "G" GetChar("circumflex"),
		},
		"lat_s_let_g_circumflex", {
			unicode: "{U+011D}", html: "&#285;", entity: "&gcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с циркумфлексом", "small g with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [g]",
			recipe: "g" GetChar("circumflex"),
		},
		"lat_c_let_g_caron", {
			unicode: "{U+01E6}", html: "&#486;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с гачеком", "capital G with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [G]",
			recipe: "G" GetChar("caron"),
		},
		"lat_s_let_g_caron", {
			unicode: "{U+01E7}", html: "&#487;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с гачеком", "small g with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [g]",
			recipe: "g" GetChar("caron"),
		},
		"lat_c_let_g_cedilla", {
			unicode: "{U+0122}", html: "&#290;", entity: "&Gcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с седилью", "capital G with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [G]",
			recipe: "G" GetChar("cedilla"),
		},
		"lat_s_let_g_cedilla", {
			unicode: "{U+0123}", html: "&#291;", entity: "&gcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с седилью", "small g with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [g]",
			recipe: "g" GetChar("cedilla"),
		},
		"lat_s_let_g_curl_right", {
			unicode: "{U+AB36}", html: "&#43830;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с завитком", "small g with curl"],
			recipe: "g" GetChar("arrow_right_ushaped"),
		},
		"lat_c_let_g_dot_above", {
			unicode: "{U+0120}", html: "&#288;", entity: "&Gdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G с точкой сверху", "capital G with dot above"],
			recipe: "G" GetChar("dot_above"),
		},
		"lat_s_let_g_dot_above", {
			unicode: "{U+0121}", html: "&#289;", entity: "&gdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с точкой сверху", "small g with dot above"],
			recipe: "g" GetChar("dot_above"),
		},
		"lat_c_let_g_macron", {
			unicode: "{U+1E20}", html: "&#7712;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с макроном", "capital G with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [G]",
			recipe: "G" GetChar("macron"),
		},
		"lat_s_let_g_macron", {
			unicode: "{U+1E21}", html: "&#7713;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с макроном", "small g with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [g]",
			recipe: "g" GetChar("macron"),
		},
		"lat_c_let_g_solidus_long", {
			unicode: "{U+A7A0}", html: "&#42912;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G с косым штрихом", "capital G with solidus"],
			recipe: "G" GetChar("solidus_long"),
		},
		"lat_s_let_g_solidus_long", {
			unicode: "{U+A7A1}", html: "&#42913;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с косым штрихом", "small g with solidus"],
			recipe: "g" GetChar("solidus_long"),
		},
		"lat_c_let_g_stroke_short", {
			unicode: "{U+01E4}", html: "&#484;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G со штрихом", "capital G with stroke"],
			recipe: "G" GetChar("stroke_short"),
		},
		"lat_s_let_g_stroke_short", {
			unicode: "{U+01E5}", html: "&#485;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g со штрихом", "small g with stroke"],
			recipe: "g" GetChar("stroke_short"),
		},
		"lat_c_let_g_hook", {
			unicode: "{U+0193}", html: "&#403;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G с крючком", "capital G with hook"],
			recipe: "G" . GetChar("arrow_up"),
		},
		"lat_s_let_g_hook", {
			unicode: "{U+0260}", html: "&#608;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с крючком", "small g with hook"],
			recipe: "g" . GetChar("arrow_up"),
		},
		"lat_s_let_g_palatal_hook", {
			unicode: "{U+1D83}", html: "&#7555;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с палатальным крюком", "small g with palatal hook"],
			recipe: "g" GetChar("palatal_hook_below"),
		},
		"lat_c_let_h_breve_below", {
			unicode: "{U+1E2A}", html: "&#7722;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с краткой снизу", "capital H with breve below"],
			recipe: "H" GetChar("breve"),
		},
		"lat_s_let_h_breve_below", {
			unicode: "{U+1E2B}", html: "&#7723;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с краткой снизу", "small h with breve below"],
			recipe: "h" GetChar("breve"),
		},
		"lat_c_let_h_circumflex", {
			unicode: "{U+0124}", html: "&#292;", entity: "&Hcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с циркумфлексом", "capital H with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [H]",
			recipe: "H" GetChar("circumflex"),
		},
		"lat_s_let_h_circumflex", {
			unicode: "{U+0125}", html: "&#293;", entity: "&hcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с циркумфлексом", "small h with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [h]",
			recipe: "h" GetChar("circumflex"),
		},
		"lat_c_let_h_caron", {
			unicode: "{U+021E}", html: "&#542;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с гачеком", "capital H with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [H]",
			recipe: "H" GetChar("caron"),
		},
		"lat_s_let_h_caron", {
			unicode: "{U+021F}", html: "&#543;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с гачеком", "small h with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [h]",
			recipe: "h" GetChar("caron"),
		},
		"lat_c_let_h_cedilla", {
			unicode: "{U+1E28}", html: "&#7720;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с седилью", "capital H with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [H]",
			recipe: "H" GetChar("cedilla"),
		},
		"lat_s_let_h_cedilla", {
			unicode: "{U+1E29}", html: "&#7721;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с седилью", "small h with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [h]",
			recipe: "h" GetChar("cedilla"),
		},
		"lat_c_let_h_dot_above", {
			unicode: "{U+1E22}", html: "&#7714;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная H с точкой сверху", "capital H with dot above"],
			recipe: "H" GetChar("dot_above"),
		},
		"lat_s_let_h_dot_above", {
			unicode: "{U+1E23}", html: "&#7715;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с точкой сверху", "small h with dot above"],
			recipe: "h" GetChar("dot_above"),
		},
		"lat_c_let_h_dot_below", {
			unicode: "{U+1E24}", html: "&#7716;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная H с точкой снизу", "capital H with dot below"],
			recipe: "H" GetChar("dot_below"),
		},
		"lat_s_let_h_dot_below", {
			unicode: "{U+1E25}", html: "&#7717;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с точкой снизу", "small h with dot below"],
			recipe: "h" GetChar("dot_below"),
		},
		"lat_c_let_h_diaeresis", {
			unicode: "{U+1E26}", html: "&#7718;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с диерезисом", "capital H with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [H]",
			recipe: "H" GetChar("diaeresis"),
		},
		"lat_s_let_h_diaeresis", {
			unicode: "{U+1E27}", html: "&#7719;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с диерезисом", "small h with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [h]",
			recipe: "h" GetChar("diaeresis"),
		},
		"lat_c_let_h_descender", {
			unicode: "{U+2C67}", html: "&#11367;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная H с нижним выносным элементом", "capital H with descender"],
			recipe: "H" GetChar("arrow_down"),
		},
		"lat_s_let_h_descender", {
			unicode: "{U+2C68}", html: "&#11368;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с нижним выносным элементом", "small h with descender"],
			recipe: "h" . GetChar("arrow_down"),
		},
		"lat_c_let_h_hook", {
			unicode: "{U+A7AA}", html: "&#42922;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная H с крючком", "capital H with hook"],
			recipe: "H" GetChar("arrow_left"),
		},
		"lat_s_let_h_hook", {
			unicode: "{U+0266}", html: "&#614;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с крючком", "small h with hook"],
			recipe: "h" . GetChar("arrow_left"),
		},
		"lat_s_let_h_palatal_hook", {
			unicode: "{U+A795}", html: "&#42901;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с палатальным крюком", "small h with palatal hook"],
			recipe: "h" GetChar("palatal_hook_below"),
		},
		"lat_c_let_h_hwair", {
			unicode: "{U+01F6}", html: "&#502;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописной хвайр", "capital hwair"],
			recipe: "H" GetChar("arrow_right"),
		},
		"lat_s_let_h_hwair", {
			unicode: "{U+0195}", html: "&#405;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчный хвайр", "small hwair"],
			recipe: "h" GetChar("arrow_right"),
		},
		"lat_c_let_h_halfleft", {
			unicode: "{U+2C75}", html: "&#11381;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["половинная прописная H", "capital half H"],
			recipe: "H/",
		},
		"lat_s_let_h_halfleft", {
			unicode: "{U+2C76}", html: "&#11382;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["половинная строчная h", "small half h"],
			recipe: "h/",
		},
		"lat_c_let_h_halfright", {
			unicode: "{U+A7F5}", html: "&#42997;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["перевёрнутая половинная прописная H", "capital reversed half H"],
			recipe: "H/" GetChar("arrow_right"),
		},
		"lat_s_let_h_halfright", {
			unicode: "{U+A7F6}", html: "&#42998;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["перевёрнутая половинная строчная h", "small reversed half h"],
			recipe: "h/" GetChar("arrow_right"),
		},
		"lat_c_let_h_stroke_short", {
			unicode: "{U+0126}", html: "&#294;", entity: "&Hstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H со штрихом", "capital H with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[H]",
			recipe: "H" GetChar("stroke_short"),
		},
		"lat_s_let_h_stroke_short", {
			unicode: "{U+0127}", html: "&#295;", entity: "&hstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h со штрихом", "small h with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[h]",
			recipe: "h" GetChar("stroke_short"),
		},
		"lat_c_let_i_acute", {
			unicode: "{U+00CD}", html: "&#205;", entity: "&Iacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная I с акутом", "capital I with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[I]",
			recipe: "I" GetChar("acute"),
		},
		"lat_s_let_i_acute", {
			unicode: "{U+00ED}", html: "&#237;", entity: "&iacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная i с акутом", "small i with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[i]",
			recipe: "i" GetChar("acute"),
		},
		"lat_c_let_i_breve", {
			unicode: "{U+012C}", html: "&#300;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с краткой", "capital I with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[I]",
			recipe: "I" GetChar("breve"),
		},
		"lat_s_let_i_breve", {
			unicode: "{U+012D}", html: "&#301;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с краткой", "small i with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[i]",
			recipe: "i" GetChar("breve"),
		},
		"lat_c_let_i_breve_inverted", {
			unicode: "{U+020A}", html: "&#523;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с перевёрнутой краткой", "capital I with interted breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[I]",
			recipe: "I" GetChar("breve_inverted"),
		},
		"lat_s_let_i_breve_inverted", {
			unicode: "{U+020B}", html: "&#301;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с перевёрнутой краткой", "small i with interted breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[i]",
			recipe: "i" GetChar("breve_inverted"),
		},
		"lat_c_let_i_circumflex", {
			unicode: "{U+00CE}", html: "&#206;", entity: "&Icirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с циркумфлексом", "capital I with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [I]",
			recipe: "I" GetChar("circumflex"),
		},
		"lat_s_let_i_circumflex", {
			unicode: "{U+00EE}", html: "&#238;", entity: "&icirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с циркумфлексом", "small i with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [i]",
			recipe: "i" GetChar("circumflex"),
		},
		"lat_c_let_i_caron", {
			unicode: "{U+01CF}", html: "&#463;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с гачеком", "capital I with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [I]",
			recipe: "I" GetChar("caron"),
		},
		"lat_s_let_i_caron", {
			unicode: "{U+01D0}", html: "&#464;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с гачеком", "small i with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [i]",
			recipe: "i" GetChar("caron"),
		},
		"lat_c_let_i_dot_above", {
			unicode: "{U+0130}", html: "&#304;", entity: "&Idot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с точкой сверху", "capital I with dot above"],
			recipe: "I" GetChar("dot_above"),
		},
		"lat_c_let_i_dot_below", {
			unicode: "{U+1ECA}", html: "&#7882;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с точкой снизу", "capital I with dot below"],
			recipe: "I" GetChar("dot_below"),
		},
		"lat_s_let_i_dot_below", {
			unicode: "{U+1ECB}", html: "&#7883;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i с точкой снизу", "small i with dot below"],
			recipe: "i" GetChar("dot_below"),
		},
		"lat_c_let_i_diaeresis", {
			unicode: "{U+00CF}", html: "&#207;", entity: "&Iuml;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с диерезисом", "capital I with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [I]",
			recipe: "I" GetChar("diaeresis"),
		},
		"lat_s_let_i_diaeresis", {
			unicode: "{U+00EF}", html: "&#239;", entity: "&iuml;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с диерезисом", "small i with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [i]",
			recipe: "i" GetChar("diaeresis"),
		},
		"lat_c_let_i_diaeresis_acute", {
			unicode: "{U+1E2F}", html: "&#7727;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с диерезисом и акутом", "capital I with diaeresis and acute"],
			recipe: ["I" GetChar("diaeresis", "acute"), Chr(0x00CF) GetChar("diaeresis")],
		},
		"lat_s_let_i_diaeresis_acute", {
			unicode: "{U+1E2E}", html: "&#7726;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i с диерезисом и акутом", "small i with diaeresis and acute"],
			recipe: ["i" GetChar("diaeresis", "acute"), Chr(0x00EF) GetChar("diaeresis")],
		},
		"lat_c_let_i_grave", {
			unicode: "{U+00CC}", html: "&#204;", entity: "&Igrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с грависом", "capital I with grave"],
			recipe: "I" GetChar("grave"),
		},
		"lat_s_let_i_grave", {
			unicode: "{U+00EC}", html: "&#236;", entity: "&igrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i с грависом", "small i with grave"],
			recipe: "i" GetChar("grave"),
		},
		"lat_c_let_i_grave_double", {
			unicode: "{U+0208}", html: "&#520;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с двойным грависом", "capital I with double grave"],
			recipe: "I" GetChar("grave_double"),
		},
		"lat_s_let_i_grave_double", {
			unicode: "{U+0209}", html: "&#513;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i с двойным грависом", "small i with double grave"],
			recipe: "i" GetChar("grave_double"),
		},
		"lat_c_let_i_hook_above", {
			unicode: "{U+1EC8}", html: "&#7880;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с хвостиком сверху", "capital I with hook above"],
			recipe: "I" GetChar("hook_above"),
		},
		"lat_s_let_i_hook_above", {
			unicode: "{U+1EC9}", html: "&#7881;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i с хвостиком сверху", "small i with hook above"],
			recipe: "i" GetChar("hook_above"),
		},
		"lat_s_let_i_retroflex_hook", {
			unicode: "{U+1D96}", html: "&#7574;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i с ретрофлексным крюком", "small i with retroflex hook"],
			recipe: "i" GetChar("retroflex_hook_below"),
		},
		"lat_c_let_i_macron", {
			unicode: "{U+012A}", html: "&#298;", entity: "&Imacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с макроном", "capital I with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [I]",
			recipe: "I" GetChar("macron"),
		},
		"lat_s_let_i_macron", {
			unicode: "{U+012B}", html: "&#299;", entity: "&imacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с макроном", "small i with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [i]",
			recipe: "i" GetChar("macron"),
		},
		"lat_c_let_i_stroke_short", {
			unicode: "{U+0197}", html: "&#407;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I со штрихом", "capital I with stroke"],
			recipe: "I" GetChar("stroke_short"),
		},
		"lat_s_let_i_stroke_short", {
			unicode: "{U+0268}", html: "&#616;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i со штрихом", "small i with stroke"],
			recipe: "i" GetChar("stroke_short"),
		},
		"lat_s_c_let_i_stroke_short", {
			unicode: "{U+1D7B}", html: "&#7547;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["капитель I со штрихом", "small capital I with stroke"],
			recipe: "I↓" GetChar("stroke_short"),
		},
		"lat_s_let_i_stroke_short_retroflex_hook", {
			unicode: "{U+1DF1A}", html: "&#122650;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i со штрихом и ретрофлексным крюком", "small i with stroke and retroflex hook"],
			recipe: ["i" GetChar("stroke_short", "retroflex_hook_below"), Chr(0x0268) GetChar("retroflex_hook_below")],
		},
		"lat_c_let_i_ogonek", {
			unicode: "{U+012E}", html: "&#302;", entity: "&Iogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с огонэком", "capital I with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [I]",
			recipe: "I" GetChar("ogonek"),
		},
		"lat_s_let_i_ogonek", {
			unicode: "{U+012F}", html: "&#303;", entity: "&iogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с огонэком", "small i with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [i]",
			recipe: "i" GetChar("ogonek"),
		},
		"lat_c_let_i_tilde", {
			unicode: "{U+0128}", html: "&#296;", entity: "&Itilde;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с тильдой", "capital I with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [I]",
			recipe: "I" GetChar("tilde"),
		},
		"lat_s_let_i_tilde", {
			unicode: "{U+0129}", html: "&#297;", entity: "&itilde;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с тильдой", "small i with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [i]",
			recipe: "i" GetChar("tilde"),
		},
		"lat_c_let_i_tilde_below", {
			unicode: "{U+1E2C}", html: "&#7724;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с тильдой", "capital I with tilde"],
			recipe: "I" GetChar("tilde_below"),
		},
		"lat_s_let_i_tilde_below", {
			unicode: "{U+1E2D}", html: "&#7725;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная i с тильдой", "small i with tilde"],
			recipe: "i" GetChar("tilde_below"),
		},
		;
		"lat_c_let_j_circumflex", {
			unicode: "{U+0134}", html: "&#308;", entity: "&Jcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная J с циркумфлексом", "capital J with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [J]",
			recipe: "J" GetChar("circumflex"),
		},
		"lat_s_let_j_circumflex", {
			unicode: "{U+0135}", html: "&#309;", entity: "&jcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная j с циркумфлексом", "small j with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [j]",
			recipe: "j" GetChar("circumflex"),
		},
		"lat_c_let_j_crossed_tail", {
			unicode: "{U+A7B2}", html: "&#42930;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная J с завитком", "small J with crossed tail"],
			recipe: "J" GetChar("arrow_right_ushaped"),
		},
		"lat_c_let_j_stroke_short", {
			unicode: "{U+0248}", html: "&#584;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная J со штрихом", "capital J with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[J]",
			recipe: "J" GetChar("stroke_short"),
		},
		"lat_s_let_j_stroke_short", {
			unicode: "{U+0249}", html: "&#585;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная j со штрихом", "small j with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[j]",
			recipe: "j" GetChar("stroke_short"),
		},
		"lat_c_let_k_acute", {
			unicode: "{U+1E30}", html: "&#7728;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная K с акутом", "capital K with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[K]",
			recipe: "K" GetChar("acute"),
		},
		"lat_s_let_k_acute", {
			unicode: "{U+1E31}", html: "&#7729;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная k с акутом", "small k with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[k]",
			recipe: "k" GetChar("acute"),
		},
		"lat_c_let_k_caron", {
			unicode: "{U+01E8}", html: "&#488;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная K с гачеком", "capital K with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [K]",
			recipe: "K" GetChar("caron"),
		},
		"lat_s_let_k_caron", {
			unicode: "{U+01E9}", html: "&#489;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная k с гачеком", "small k with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [k]",
			recipe: "k" GetChar("caron"),
		},
		"lat_c_let_k_cedilla", {
			unicode: "{U+0136}", html: "&#310;", entity: "&Kcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная K с седилью", "capital K with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [K]",
			recipe: "K" GetChar("cedilla"),
		},
		"lat_s_let_k_cedilla", {
			unicode: "{U+0137}", html: "&#311;", entity: "&kcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная k с седилью", "small k with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [k]",
			recipe: "k" GetChar("cedilla"),
		},
		"lat_c_let_k_dot_below", {
			unicode: "{U+1E32}", html: "&#7730;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная I с точкой снизу", "capital I with dot below"],
			recipe: "I" GetChar("dot_below"),
		},
		"lat_s_let_k_dot_below", {
			unicode: "{U+1E33}", html: "&#7731;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k с точкой снизу", "small k with dot below"],
			recipe: "k" GetChar("dot_below"),
		},
		"lat_c_let_k_hook", {
			unicode: "{U+0199}", html: "&#409;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная K с крючком", "capital K with hook"],
			recipe: "K" . GetChar("arrow_up"),
		},
		"lat_s_let_k_hook", {
			unicode: "{U+0198}", html: "&#408;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k с крючком", "small k with hook"],
			recipe: "k" . GetChar("arrow_up"),
		},
		"lat_s_let_k_palatal_hook", {
			unicode: "{U+1D84}", html: "&#7556;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k с палатальным крюком", "small k with palatal hook"],
			recipe: "k" GetChar("palatal_hook_below"),
		},
		"lat_c_let_k_solidus_long", {
			unicode: "{U+A7A2}", html: "&#42914;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная K с косым штрихом", "capital K with solidus"],
			recipe: "K" GetChar("solidus_long"),
		},
		"lat_s_let_k_solidus_long", {
			unicode: "{U+A7A3}", html: "&#42915;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k с косым штрихом", "small k with solidus"],
			recipe: "k" GetChar("solidus_long"),
		},
		"lat_c_let_k_solidus_short", {
			unicode: "{U+A742}", html: "&#42818;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная K с диагональным штрихом", "capital K with short solidus"],
			recipe: "K" GetChar("solidus_short"),
		},
		"lat_s_let_k_solidus_short", {
			unicode: "{U+A743}", html: "&#42819;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k с диагональным штрихом", "small k with short solidus"],
			recipe: "k" GetChar("solidus_short"),
		},
		"lat_c_let_k_stroke_short", {
			unicode: "{U+A740}", html: "&#42816;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная K со штрихом", "capital K with stroke"],
			recipe: "K" GetChar("stroke_short"),
		},
		"lat_s_let_k_stroke_short", {
			unicode: "{U+A741}", html: "&#42817;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k со штрихом", "small k with stroke"],
			recipe: "k" GetChar("stroke_short"),
		},
		"lat_c_let_k_stroke_short_solidus_short", {
			unicode: "{U+A744}", html: "&#42820;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная K со штрихом и диагональным штрихом", "capital K with stroke and short solidus"],
			recipe: "K" GetChar("stroke_short", "solidus_short"),
		},
		"lat_s_let_k_stroke_short_solidus_short", {
			unicode: "{U+A745}", html: "&#42821;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k со штрихом и диагональным штрихом", "small k with stroke and short solidus"],
			recipe: "k" GetChar("stroke_short", "solidus_short"),
		},
		"lat_c_let_k_line_below", {
			unicode: "{U+1E34}", html: "&#7732;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная K с чертой снизу", "capital K with line below"],
			recipe: "K" GetChar("macron_below"),
		},
		"lat_s_let_k_line_below", {
			unicode: "{U+1E35}", html: "&#7733;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k с чертой снизу", "small k with line below"],
			recipe: "k" GetChar("macron_below"),
		},
		"lat_c_let_k_descender", {
			unicode: "{U+2C69}", html: "&#11369;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная K с нижним выносным элементом", "capital K with descender"],
			recipe: "K" GetChar("arrow_down"),
		},
		"lat_s_let_k_descender", {
			unicode: "{U+2C6A}", html: "&#11370;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная k с нижним выносным элементом", "small k with descender"],
			recipe: "k" . GetChar("arrow_down"),
		},
		"lat_c_let_l_acute", {
			unicode: "{U+0139}", html: "&#313;", entity: "&Lacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная L с акутом", "capital L with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[L]",
			recipe: "L" GetChar("acute"),
		},
		"lat_s_let_l_acute", {
			unicode: "{U+013A}", html: "&#314;", entity: "&lacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная l с акутом", "small l with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[l]",
			recipe: "l" GetChar("acute"),
		},
		"lat_c_let_l_circumflex_below", {
			unicode: "{U+1E3C}", html: "&#7740;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная L с циркумфлексом снизу", "capital L with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [L]",
			recipe: "L" GetChar("circumflex_below"),
		},
		"lat_s_let_l_circumflex_below", {
			unicode: "{U+1E3D}", html: "&#7741;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная l с циркумфлексом снизу", "small l with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [l]",
			recipe: "l" GetChar("circumflex_below"),
		},
		"lat_c_let_l_caron", {
			unicode: "{U+013D}", html: "&#488;", entity: "&Lcaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная L с гачеком", "capital L with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [L]",
			recipe: "L" GetChar("caron"),
		},
		"lat_s_let_l_caron", {
			unicode: "{U+013E}", html: "&#318;", entity: "&lcaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная l с гачеком", "small l with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [l]",
			recipe: "l" GetChar("caron"),
		},
		"lat_c_let_l_cedilla", {
			unicode: "{U+013B}", html: "&#315;", entity: "&Lcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная L с седилью", "capital L with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [L]",
			recipe: "L" GetChar("cedilla"),
		},
		"lat_s_let_l_cedilla", {
			unicode: "{U+013C}", html: "&#316;", entity: "&lcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная l с седилью", "small l with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [l]",
			recipe: "l" GetChar("cedilla"),
		},
		"lat_s_let_l_curl", {
			unicode: "{U+0234}", html: "&#564;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с завитком", "small l with curl"],
			recipe: "l" GetChar("arrow_left_ushaped"),
		},
		"lat_c_let_l_belt", {
			unicode: "{U+A7AD}", html: "&#42925;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L с ремешком", "capital L with belt"],
			recipe: "L" GetChar("arrow_right_ushaped"),
		},
		"lat_s_let_l_belt", {
			unicode: "{U+026C}", html: "&#620;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с ремешком", "small l with belt"],
			recipe: "l" GetChar("arrow_right_ushaped"),
		},
		"lat_s_let_l_belt_retroflex_hook", {
			unicode: "{U+A78E}", html: "&#42894;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с ремешком и ретрофлксным крюком", "small l with belt and retroflex hook"],
			recipe: "l" GetChar("arrow_right_ushaped", "retroflex_hook_below"),
		},
		"lat_s_let_l_fishhook", {
			unicode: "{U+1DF11}", html: "&#122641;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с крючком", "small l with fishhook"],
			recipe: "l" GetChar("arrow_right"),
		},
		"lat_c_let_l_dot_below", {
			unicode: "{U+1E36}", html: "&#7734;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L с точкой снизу", "capital L with dot below"],
			recipe: "L" GetChar("dot_below"),
		},
		"lat_s_let_l_dot_below", {
			unicode: "{U+1E37}", html: "&#7735;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с точкой снизу", "small l with dot below"],
			recipe: "l" GetChar("dot_below"),
		},
		"lat_c_let_l_dot_middle", {
			unicode: "{U+013F}", html: "&#319;", entity: "&Lmidot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L с точкой", "capital L with middle dot"],
			recipe: "L·",
		},
		"lat_s_let_l_dot_middle", {
			unicode: "{U+0140}", html: "&#320;", entity: "&lmidot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с точкой", "small l with middle dot"],
			recipe: "l·",
		},
		"lat_s_let_l_palatal_hook", {
			unicode: "{U+1D85}", html: "&#7557;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с палатальным крюком", "small l with palatal hook"],
			recipe: "l" GetChar("palatal_hook_below"),
		},
		"lat_s_let_l_retroflex_hook", {
			unicode: "{U+026D}", html: "&#621;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с ретрофлксным крюком", "small l with retroflex hook"],
			recipe: "l" GetChar("retroflex_hook_below"),
		},
		"lat_s_let_l_ring_middle", {
			unicode: "{U+AB39}", html: "&#43833;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с кольцом посередине", "small l with middle ring"],
			recipe: "l◦",
		},
		"lat_c_let_l_solidus_short", {
			unicode: "{U+0141}", html: "&#321;", entity: "&Lstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная L с диагональным штрихом", "capital L with short solidus"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[L]",
			recipe: "L" GetChar("solidus_short"),
		},
		"lat_s_let_l_solidus_short", {
			unicode: "{U+0142}", html: "&#322;", entity: "&lstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная l с диагональным штрихом", "small l with short solidus"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[l]",
			recipe: "l" GetChar("solidus_short"),
		},
		"lat_c_let_l_stroke_short", {
			unicode: "{U+023D}", html: "&#573;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L со штрихом", "capital L with stroke"],
			recipe: "L" GetChar("stroke_short"),
		},
		"lat_s_let_l_stroke_short", {
			unicode: "{U+019A}", html: "&#410;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l со штрихом", "small l with stroke"],
			recipe: "l" GetChar("stroke_short"),
		},
		"lat_c_let_l_stroke_short_high", {
			unicode: "{U+A748}", html: "&#42824;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L с высоким штрихом", "capital L with high stroke"],
			recipe: "L" GetChar("stroke_short"),
		},
		"lat_s_let_l_stroke_short_high", {
			unicode: "{U+A749}", html: "&#42825;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с высоким штрихом", "small l with high stroke"],
			recipe: "l" GetChar("stroke_short"),
		},
		"lat_c_let_l_stroke_short_double", {
			unicode: "{U+2C60}", html: "&#11360;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L с двойным штрихом", "capital L with double stroke"],
			recipe: ["L" GetChar("stroke_short", "stroke_short"), Chr(0x023D) GetChar("stroke_short")],
		},
		"lat_s_let_l_stroke_short_double", {
			unicode: "{U+2C61}", html: "&#11361;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с двойным штрихом", "small l with double stroke"],
			recipe: ["l" GetChar("stroke_short", "stroke_short"), Chr(0x019A) GetChar("stroke_short")],
		},
		"lat_c_let_l_macron_dot_below", {
			unicode: "{U+1E38}", html: "&#7736;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L с макроном и точкой снизу", "capital L with macron and dot below"],
			recipe: "L" GetChar("macron", "dot_below"),
		},
		"lat_s_let_l_macron_dot_below", {
			unicode: "{U+1E39}", html: "&#7737;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с макроном и точкой снизу", "small l with macron and dot below"],
			recipe: "l" GetChar("macron", "dot_below"),
		},
		"lat_c_let_l_line_below", {
			unicode: "{U+1E3A}", html: "&#7738;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная L с чертой снизу", "capital L with line below"],
			recipe: "L" GetChar("macron_below"),
		},
		"lat_s_let_l_line_below", {
			unicode: "{U+1E3B}", html: "&#7739;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с чертой снизу", "small l with line below"],
			recipe: "l" GetChar("macron_below"),
		},
		"lat_s_let_l_tilde_overlay", {
			unicode: "{U+2C62}", html: "&#11362;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная L с тильдой посередине", "small L with middle tilde"],
			recipe: "L" GetChar("tilde_overlay"),
		},
		"lat_s_let_l_tilde_overlay", {
			unicode: "{U+026B}", html: "&#619;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с тильдой посередине", "small l with middle tilde"],
			recipe: "l" GetChar("tilde_overlay"),
		},
		"lat_s_let_l_tilde_overlay_double", {
			unicode: "{U+AB38}", html: "&#43832;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная l с двойной тильдой посередине", "small l with double middle tilde"],
			recipe: "l" GetChar("tilde_overlay", "tilde_overlay"),
		},
		"lat_s_let_l_inverted_lazy_s", {
			unicode: "{U+AB37}", html: "&#43831;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["R$ с повёрнутой s", "E$ with inverted lazy s"],
			recipe: "$" GetChar("arrow_right_circle") "s",
		},
		;
		;
		;
		;
		;
		;
		;
		;
		;
		; * Letters Cyriillic
		"cyr_c_let_a_iotified", {
			unicode: "{U+A656}", html: "&#42582;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йа", "!ia", "R$ йотированное", "E$ iotified"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Я]",
			recipe: "ІА",
			letter: "а",
		},
		"cyr_s_let_a_iotified", {
			unicode: "{U+A657}", html: "&#42583;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йа", ".ia", "R$ йотированное", "E$ iotified"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [я]",
			recipe: "іа",
			letter: "а",
		},
		"cyr_c_let_e_iotified", {
			unicode: "{U+0464}", html: "&#1124;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йэ", "!ie", "Е йотированное", "E iotified"],
			recipe: ["ІЕ", "ІЄ"],
		},
		"cyr_s_let_e_iotified", {
			unicode: "{U+0465}", html: "&#1125;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йэ", ".ie", "е йотированное", "e iotified"],
			recipe: ["іе", "іє"],
		},
		"cyr_c_let_yus_big", {
			unicode: "{U+046A}", html: "&#1130;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "У"],
			tags: ["!юсб", "!yusb", "Юс большой", "big Yus"],
			show_on_fast_keys: True,
			recipe: "УЖ",
		},
		"cyr_s_let_yus_big", {
			unicode: "{U+046B}", html: "&#046B;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "у"],
			tags: [".юсб", ".yusb", "юс большой", "big yus"],
			show_on_fast_keys: True,
			recipe: "уж",
		},
		"cyr_c_let_yus_big_iotified", {
			unicode: "{U+046C}", html: "&#1132;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йюсб", "!iyusb", "Юс большой йотированный", "big Yus iotified"],
			recipe: ["ІУЖ", "І" . Chr(0x046A)],
		},
		"cyr_s_let_yus_big_iotified", {
			unicode: "{U+046D}", html: "&#1133;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йюсб", ".iyusb", "юс большой йотированный", "big yus iotified"],
			recipe: ["іуж", "і" . Chr(0x046B)],
		},
		"cyr_c_let_yus_little", {
			unicode: "{U+0466}", html: "&#1126;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "Я"],
			tags: ["!юсм", "!yusm", "Юс малый", "little Yus"],
			show_on_fast_keys: True,
			recipe: "АТ",
		},
		"cyr_s_let_yus_little", {
			unicode: "{U+0467}", html: "&#1127;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "я"],
			tags: [".юсм", ".yusm", "юс малый", "little yus"],
			show_on_fast_keys: True,
			recipe: "ат",
		},
		"cyr_c_let_yus_little_iotified", {
			unicode: "{U+0468}", html: "&#1128;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йюсм", "!iyusm", "Юс малый йотированный", "little Yus iotified"],
			recipe: ["ІАТ", "І" Chr(0x0466)],
		},
		"cyr_s_let_yus_little_iotified", {
			unicode: "{U+0469}", html: "&#1129;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йюсм", ".iyusm", "юс малый йотированный", "little yus iotified"],
			recipe: ["іат", "і" Chr(0x0467)],
		},
		"cyr_c_let_yus_little_closed", {
			unicode: "{U+A658}", html: "&#42584;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!юсмз", "!yusmz", "Юс малый закрытый", "little Yus closed"],
			recipe: ["_АТ", "_" Chr(0x0466)],
		},
		"cyr_s_let_yus_little_closed", {
			unicode: "{U+A659}", html: "&#42585;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".юсмз", ".yusmz", "юс малый закрытый", "little yus closed"],
			recipe: ["_ат", "_" Chr(0x0467)],
		},
		"cyr_c_let_yus_little_closed_iotified", {
			unicode: "{U+A65C}", html: "&#42588;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йюсмз", "!iyusmz", "Юс малый закрытый йотированный", "little Yus closed iotified"],
			recipe: ["І_АТ", "І" Chr(0xA658), "І_" Chr(0x0466)],
		},
		"cyr_s_let_yus_little_closed_iotified", {
			unicode: "{U+A65D}", html: "&#42589;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йюсмз", ".iyusmz", "юс малый закрытый йотированный", "little yus closed iotified"],
			recipe: ["і_ат", "І" Chr(0xA659), "і_" Chr(0x0467)],
		},
		"cyr_c_let_yus_blended", {
			unicode: "{U+A65A}", html: "&#42586;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!юсс", "!yuss", "Юс смешанный", "blended Yus"],
			recipe: ["УЖАТ", Chr(0x046A) . Chr(0x0466)],
		},
		"cyr_s_let_yus_blended", {
			unicode: "{U+A65B}", html: "&#42587;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".юсс", ".yuss", "юс смешанный", "blended yus"],
			recipe: ["ужат", Chr(0x046B) . Chr(0x0467)],
		},
		"cyr_c_let_tse", {
			unicode: "{U+04B4}", html: "&#1204;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["Тцэ", "Tse cyrillic"],
			recipe: "ТЦ",
		},
		"cyr_s_let_tse", {
			unicode: "{U+04B5}", html: "&#1205;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["тцэ", "tse cyrillic"],
			recipe: "тц",
		},
		"cyr_c_let_tche", {
			unicode: "{U+A692}", html: "&#42642;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["Тчэ", "Tche cyrillic"],
			recipe: "ТЧ",
		},
		"cyr_s_let_tche", {
			unicode: "{U+A693}", html: "&#42643;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["тчэ", "tche cyrillic"],
			recipe: "тч",
		},
		"cyr_c_let_yat_iotified", {
			unicode: "{U+A652}", html: "&#42578;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["Ять йотированный", "Yat iotified"],
			recipe: ["ІТЬ", "І" . Chr(0x0462)],
		},
		"cyr_s_let_yat_iotified", {
			unicode: "{U+A653}", html: "&#42579;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["ять йотированный", "yat iotified"],
			recipe: ["іть", "і" . Chr(0x0463)],
		},
		"cyr_c_let_dzhe", {
			unicode: "{U+040F}", html: "&#1039;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Д"],
			tags: ["Дже", "Dzhe cyrillic"],
			show_on_fast_keys: True,
			recipe: "ДЖ",
		},
		"cyr_s_let_dzhe", {
			unicode: "{U+045F}", html: "&#1119;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "д"],
			tags: ["дже", "dzhe cyrillic"],
			show_on_fast_keys: True,
			recipe: "дж",
		},
		"cyr_c_let_i", {
			unicode: "{U+0406}", html: "&#1030;",
			altCode: "0178 RU" Chr(0x2328),
			titlesAlt: True,
			group: ["Cyrillic Letters", "И"],
			show_on_fast_keys: True,
			tags: ["И десятиричное", "I cyrillic"],
		},
		"cyr_s_let_i", {
			unicode: "{U+0456}", html: "&#1110;",
			altCode: "0179 RU" Chr(0x2328),
			titlesAlt: True,
			group: ["Cyrillic Letters", "и"],
			show_on_fast_keys: True,
			tags: ["и десятиричное", "i cyrillic"],
		},
		"cyr_c_let_izhitsa", {
			unicode: "{U+0474}", html: "&#1140;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "И"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["Ижица", "Izhitsa cyrillic"],
		},
		"cyr_s_let_izhitsa", {
			unicode: "{U+0475}", html: "&#1141;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "и"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["ижица", "izhitsa cyrillic"],
		},
		"cyr_c_let_yi", {
			unicode: "{U+0407}", html: "&#1031;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Й"],
			show_on_fast_keys: True,
			tags: ["ЙИ десятиричное", "YI cyrillic"],
			recipe: "І" GetChar("diaeresis"),
		},
		"cyr_s_let_yi", {
			unicode: "{U+0457}", html: "&#1111;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "й"],
			show_on_fast_keys: True,
			tags: ["йи десятиричное", "yi cyrillic"],
			recipe: "і" GetChar("diaeresis"),
		},
		"cyr_c_let_j", {
			unicode: "{U+0408}", html: "&#1032;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Й"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["ЙЕ", "J cyrillic"],
		},
		"cyr_s_let_j", {
			unicode: "{U+0458}", html: "&#1112;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "й"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["йе", "j cyrillic"],
		},
		"cyr_c_let_ksi", {
			unicode: "{U+046E}", html: "&#1134;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["Кси", "Ksi cyrillic"],
			recipe: "КС",
		},
		"cyr_s_let_ksi", {
			unicode: "{U+046F}", html: "&#1135;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["кси", "ksi cyrillic"],
			recipe: "кс",
		},
		"cyr_c_let_omega", {
			unicode: "{U+0460}", html: "&#1120;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "О"],
			show_on_fast_keys: True,
			tags: ["Омега", "Omega cyrillic"],
		},
		"cyr_s_let_omega", {
			unicode: "{U+0461}", html: "&#1121;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "о"],
			show_on_fast_keys: True,
			tags: ["омега", "omega cyrillic"],
		},
		"cyr_c_let_psi", {
			unicode: "{U+0470}", html: "&#1136;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["Пси", "Psi cyrillic"],
			recipe: "ПС",
		},
		"cyr_s_let_psi", {
			unicode: "{U+0471}", html: "&#1137;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["пси", "psi cyrillic"],
			recipe: "пс",
		},
		"cyr_c_let_fita", {
			unicode: "{U+0472}", html: "&#1138;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Ф"],
			show_on_fast_keys: True,
			tags: ["Фита", "Fita cyrillic"],
		},
		"cyr_s_let_fita", {
			unicode: "{U+0473}", html: "&#1139;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "ф"],
			show_on_fast_keys: True,
			tags: ["фита", "fita cyrillic"],
		},
		"cyr_c_let_ukr_e", {
			unicode: "{U+0404}", html: "&#1028;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Э"],
			show_on_fast_keys: True,
			tags: ["Э якорное", "E ukrainian"],
		},
		"cyr_s_let_ukr_e", {
			unicode: "{U+0454}", html: "&#1108;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "э"],
			show_on_fast_keys: True,
			tags: ["э якорное", "e ukrainian"],
		},
		"cyr_c_let_yat", {
			unicode: "{U+0462}", html: "&#1122;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Е"],
			show_on_fast_keys: True,
			tags: ["Ять", "Yat"],
			recipe: "ТЬ",
		},
		"cyr_s_let_yat", {
			unicode: "{U+0463}", html: "&#1123;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "е"],
			show_on_fast_keys: True,
			tags: ["ять", "yat"],
			recipe: "ть",
		},
		"cyr_c_let_yeru_back_yer", {
			unicode: "{U+A650}", html: "&#42576;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Ы]",
			tags: ["древняя Ы", "Ы с твёрдым знаком", "cyrillic Yeru with back Yer"],
			recipe: "ЪІ",
		},
		"cyr_s_let_yeru_back_yer", {
			unicode: "{U+A651}", html: "&#42577;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [ы]",
			tags: ["древняя ы", "ы с твёрдым знаком", "cyrillic yeru with back yer"],
			recipe: "ъі",
		},
		;
		;
		"glagolitic_c_let_az", {
			unicode: "{U+2C00}", html: "&#11264;",
			combiningForm: "{U+1E000}",
			combiningHTML: "&#122880;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "А"],
			tags: ["прописной Аз глаголицы", "capital Az glagolitic"],
		},
		"glagolitic_s_let_az", {
			unicode: "{U+2C30}", html: "&#11312;",
			combiningForm: "{U+1E000}",
			combiningHTML: "&#122880;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "а"],
			tags: ["строчный аз глаголицы", "small az glagolitic"],
		},
		"glagolitic_c_let_buky", {
			unicode: "{U+2C01}", html: "&#11265;",
			combiningForm: "{U+1E001}",
			combiningHTML: "&#122881;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Б"],
			tags: ["прописной Буки глаголицы", "capital Buky glagolitic"],
		},
		"glagolitic_s_let_buky", {
			unicode: "{U+2C31}", html: "&#11313;",
			combiningForm: "{U+1E001}",
			combiningHTML: "&#122881;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "б"],
			tags: ["строчный буки глаголицы", "small buky glagolitic"],
		},
		"glagolitic_c_let_vede", {
			unicode: "{U+2C02}", html: "&#11266;",
			combiningForm: "{U+1E002}",
			combiningHTML: "&#122882;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "В"],
			tags: ["прописной Веди глаголицы", "capital Vede glagolitic"],
		},
		"glagolitic_s_let_vede", {
			unicode: "{U+2C32}", html: "&#11314;",
			combiningForm: "{U+1E002}",
			combiningHTML: "&#122882;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "в"],
			tags: ["строчный веди глаголицы", "small vede glagolitic"],
		},
		"glagolitic_c_let_glagoli", {
			unicode: "{U+2C03}", html: "&#11267;",
			combiningForm: "{U+1E003}",
			combiningHTML: "&#122883;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Г"],
			tags: ["прописной Глаголи глаголицы", "capital Glagoli glagolitic"],
		},
		"glagolitic_s_let_glagoli", {
			unicode: "{U+2C33}", html: "&#11315;",
			combiningForm: "{U+1E003}",
			combiningHTML: "&#122883;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "г"],
			tags: ["строчный глаголи глаголицы", "small glagoli glagolitic"],
		},
		"glagolitic_c_let_dobro", {
			unicode: "{U+2C04}", html: "&#11268;",
			combiningForm: "{U+1E004}",
			combiningHTML: "&#122884;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Д"],
			tags: ["прописной Добро глаголицы", "capital Dobro glagolitic"],
		},
		"glagolitic_s_let_dobro", {
			unicode: "{U+2C34}", html: "&#11316;",
			combiningForm: "{U+1E004}",
			combiningHTML: "&#122884;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "д"],
			tags: ["строчный добро глаголицы", "small dobro glagolitic"],
		},
		"glagolitic_c_let_yestu", {
			unicode: "{U+2C05}", html: "&#11269;",
			combiningForm: "{U+1E005}",
			combiningHTML: "&#122885;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Е"],
			tags: ["прописной Есть глаголицы", "capital Yestu glagolitic"],
		},
		"glagolitic_s_let_yestu", {
			unicode: "{U+2C35}", html: "&#11317;",
			combiningForm: "{U+1E005}",
			combiningHTML: "&#122885;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "е"],
			tags: ["строчный есть глаголицы", "small yestu glagolitic"],
		},
		"glagolitic_c_let_zhivete", {
			unicode: "{U+2C06}", html: "&#11270;",
			combiningForm: "{U+1E006}",
			combiningHTML: "&#122886;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ж"],
			tags: ["прописной Живете глаголицы", "capital Zhivete glagolitic"],
		},
		"glagolitic_s_let_zhivete", {
			unicode: "{U+2C36}", html: "&#11318;",
			combiningForm: "{U+1E006}",
			combiningHTML: "&#122886;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ж"],
			tags: ["строчный живете глаголицы", "small zhivete glagolitic"],
		},
		"glagolitic_c_let_dzelo", {
			unicode: "{U+2C07}", html: "&#11271;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной Зело глаголицы", "capital Dzelo glagolitic"],
			alt_layout: RightAlt " [С]",
		},
		"glagolitic_s_let_dzelo", {
			unicode: "{U+2C37}", html: "&#11319;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["строчный зело глаголицы", "small dzelo glagolitic"],
			alt_layout: RightAlt " [с]",
		},
		"glagolitic_c_let_zemlja", {
			unicode: "{U+2C08}", html: "&#11272;",
			combiningForm: "{U+1E008}",
			combiningHTML: "&#122888;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "З"],
			tags: ["прописная Земля глаголицы", "capital Zemlja glagolitic"],
		},
		"glagolitic_s_let_zemlja", {
			unicode: "{U+2C38}", html: "&#11320;",
			combiningForm: "{U+1E008}",
			combiningHTML: "&#122888;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "з"],
			tags: ["строчная земля глаголицы", "small zemlja glagolitic"],
		},
		"glagolitic_c_let_initial_izhe", {
			unicode: "{U+2C0A}", html: "&#11274;",
			combiningForm: "{U+1E00A}",
			combiningHTML: "&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [И]",
			tags: ["прописное начальное Иже глаголицы", "capital initial Izhe glagolitic"],
		},
		"glagolitic_s_let_initial_izhe", {
			unicode: "{U+2C3A}", html: "&#11322;",
			combiningForm: "{U+1E00A}",
			combiningHTML: "&#122890;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [и]",
			tags: ["строчное начальное иже глаголицы", "small initial izhe glagolitic"],
		},
		"glagolitic_c_let_izhe", {
			unicode: "{U+2C09}", html: "&#11273;",
			combiningForm: "{U+1E009}",
			combiningHTML: "&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: LeftShift " [И], [Й]",
			tags: ["прописная Иже глаголицы", "capital Izhe glagolitic"],
		},
		"glagolitic_s_let_izhe", {
			unicode: "{U+2C39}", html: "&#11321;",
			combiningForm: "{U+1E009}",
			combiningHTML: "&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: LeftShift " [и], [й]",
			tags: ["строчная иже глаголицы", "small izhe glagolitic"],
		},
		"glagolitic_c_let_i", {
			unicode: "{U+2C0B}", html: "&#11275;",
			combiningForm: "{U+1E00B}",
			combiningHTML: "&#122891;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "И"],
			tags: ["прописная Ие глаголицы", "capital I glagolitic"],
		},
		"glagolitic_s_let_i", {
			unicode: "{U+2C3B}", html: "&#11323;",
			combiningForm: "{U+1E00B}",
			combiningHTML: "&#122891;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "и"],
			tags: ["строчная и глаголицы", "small i glagolitic"],
		},
		"glagolitic_c_let_djervi", {
			unicode: "{U+2C0C}", html: "&#11276;",
			combiningForm: "{U+1E00C}",
			combiningHTML: "&#122892;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [Ж]",
			tags: ["прописной Гюрв глаголицы", "capital Djervi glagolitic"],
		},
		"glagolitic_s_let_djervi", {
			unicode: "{U+2C3C}", html: "&#11324;",
			combiningForm: "{U+1E00C}",
			combiningHTML: "&#122892;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [ж]",
			tags: ["строчной гюрв глаголицы", "small djervi glagolitic"],
		},
		"glagolitic_c_let_kako", {
			unicode: "{U+2C0D}", html: "&#11277;",
			combiningForm: "{U+1E00D}",
			combiningHTML: "&#122893;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "К"],
			tags: ["прописная Како глаголицы", "capital Kako glagolitic"],
		},
		"glagolitic_s_let_kako", {
			unicode: "{U+2C3D}", html: "&#11325;",
			combiningForm: "{U+1E00D}",
			combiningHTML: "&#122893;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "к"],
			tags: ["строчная како глаголицы", "small kako glagolitic"],
		},
		"glagolitic_c_let_ljudije", {
			unicode: "{U+2C0E}", html: "&#11278;",
			combiningForm: "{U+1E00E}",
			combiningHTML: "&#122894;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Л"],
			tags: ["прописная Люди глаголицы", "capital Ljudije glagolitic"],
		},
		"glagolitic_s_let_ljudije", {
			unicode: "{U+2C3E}", html: "&#11326;",
			combiningForm: "{U+1E00E}",
			combiningHTML: "&#122894;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "л"],
			tags: ["строчная люди глаголицы", "small ljudije glagolitic"],
		},
		"glagolitic_c_let_myslite", {
			unicode: "{U+2C0F}", html: "&#11279;",
			combiningForm: "{U+1E00F}",
			combiningHTML: "&#122895;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "М"],
			tags: ["прописная Мыслете глаголицы", "capital Myslite glagolitic"],
		},
		"glagolitic_s_let_myslite", {
			unicode: "{U+2C3F}", html: "&#11327;",
			combiningForm: "{U+1E00F}",
			combiningHTML: "&#122895;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "м"],
			tags: ["строчная мыслете глаголицы", "small myslite glagolitic"],
		},
		"glagolitic_c_let_nashi", {
			unicode: "{U+2C10}", html: "&#11280;",
			combiningForm: "{U+1E010}",
			combiningHTML: "&#122896;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Н"],
			tags: ["прописная Наш глаголицы", "capital Nashi glagolitic"],
		},
		"glagolitic_s_let_nashi", {
			unicode: "{U+2C40}", html: "&#11328;",
			combiningForm: "{U+1E010}",
			combiningHTML: "&#122896;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "н"],
			tags: ["строчная наш глаголицы", "small nashi glagolitic"],
		},
		"glagolitic_c_let_onu", {
			unicode: "{U+2C11}", html: "&#11281;",
			combiningForm: "{U+1E011}",
			combiningHTML: "&#122897;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "О"],
			tags: ["прописная Он глаголицы", "capital Onu glagolitic"],
		},
		"glagolitic_s_let_onu", {
			unicode: "{U+2C41}", html: "&#11329;",
			combiningForm: "{U+1E011}",
			combiningHTML: "&#122897;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "о"],
			tags: ["строчная он глаголицы", "small onu glagolitic"],
		},
		"glagolitic_c_let_pokoji", {
			unicode: "{U+2C12}", html: "&#11282;",
			combiningForm: "{U+1E012}",
			combiningHTML: "&#122898;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "П"],
			tags: ["прописная Покой глаголицы", "capital Pokoji glagolitic"],
		},
		"glagolitic_s_let_pokoji", {
			unicode: "{U+2C42}", html: "&#11330;",
			combiningForm: "{U+1E012}",
			combiningHTML: "&#122898;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "п"],
			tags: ["строчная покой глаголицы", "small pokoji glagolitic"],
		},
		"glagolitic_c_let_ritsi", {
			unicode: "{U+2C13}", html: "&#11283;",
			combiningForm: "{U+1E013}",
			combiningHTML: "&#122899;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Р"],
			tags: ["прописная Рцы глаголицы", "capital Ritsi glagolitic"],
		},
		"glagolitic_s_let_ritsi", {
			unicode: "{U+2C43}", html: "&#11331;",
			combiningForm: "{U+1E013}",
			combiningHTML: "&#122899;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "р"],
			tags: ["строчная рцы глаголицы", "small ritsi glagolitic"],
		},
		"glagolitic_c_let_slovo", {
			unicode: "{U+2C14}", html: "&#11284;",
			combiningForm: "{U+1E014}",
			combiningHTML: "&#122900;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "С"],
			tags: ["прописная Слово глаголицы", "capital Slovo glagolitic"],
		},
		"glagolitic_s_let_slovo", {
			unicode: "{U+2C44}", html: "&#11332;",
			combiningForm: "{U+1E014}",
			combiningHTML: "&#122900;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "с"],
			tags: ["строчная слово глаголицы", "small slovo glagolitic"],
		},
		"glagolitic_c_let_tvrido", {
			unicode: "{U+2C15}", html: "&#11285;",
			combiningForm: "{U+1E015}",
			combiningHTML: "&#122901;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Т"],
			tags: ["прописная Твердо глаголицы", "capital Tvrido glagolitic"],
		},
		"glagolitic_s_let_tvrido", {
			unicode: "{U+2C45}", html: "&#11333;",
			combiningForm: "{U+1E015}",
			combiningHTML: "&#122901;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "т"],
			tags: ["строчная твердо глаголицы", "small tvrido glagolitic"],
		},
		"glagolitic_c_let_izhitsa", {
			unicode: "{U+2C2B}", html: "&#11307;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt LeftShift " [И]",
			tags: ["прописное начальное Иже глаголицы", "capital Izhitsae glagolitic"],
		},
		"glagolitic_s_let_izhitsa", {
			unicode: "{U+2C5B}", html: "&#11355;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt LeftShift " [и]",
			tags: ["строчное начальное иже глаголицы", "small izhitsa glagolitic"],
		},
		"glagolitic_c_let_uku", {
			unicode: "{U+2C16}", html: "&#11286;",
			combiningForm: "{U+1E016}",
			combiningHTML: "&#122902;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "У"],
			tags: ["прописная Ук глаголицы", "capital Uku glagolitic"],
		},
		"glagolitic_s_let_uku", {
			unicode: "{U+2C46}", html: "&#11334;",
			combiningForm: "{U+1E016}",
			combiningHTML: "&#122902;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "у"],
			tags: ["строчная ук глаголицы", "small uku glagolitic"],
		},
		"glagolitic_c_let_fritu", {
			unicode: "{U+2C17}", html: "&#11287;",
			combiningForm: "{U+1E017}",
			combiningHTML: "&#122903;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ф"],
			tags: ["прописной Ферт глаголицы", "capital Fritu glagolitic"],
		},
		"glagolitic_s_let_fritu", {
			unicode: "{U+2C47}", html: "&#11335;",
			combiningForm: "{U+1E017}",
			combiningHTML: "&#122903;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ф"],
			tags: ["строчный ферт глаголицы", "small fritu glagolitic"],
		},
		"glagolitic_c_let_heru", {
			unicode: "{U+2C18}", html: "&#11288;",
			combiningForm: "{U+1E018}",
			combiningHTML: "&#122904;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Х"],
			tags: ["прописной Хер глаголицы", "capital Heru glagolitic"],
		},
		"glagolitic_s_let_heru", {
			unicode: "{U+2C48}", html: "&#11336;",
			combiningForm: "{U+1E018}",
			combiningHTML: "&#122904;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "х"],
			tags: ["строчный хер глаголицы", "small heru glagolitic"],
		},
		"glagolitic_c_let_otu", {
			unicode: "{U+2C19}", html: "&#11289;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [О]",
			tags: ["прописная От глаголицы", "capital Otu glagolitic"],
		},
		"glagolitic_s_let_otu", {
			unicode: "{U+2C49}", html: "&#11337;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [о]",
			tags: ["строчная от глаголицы", "small otu glagolitic"],
		},
		"glagolitic_c_let_pe", {
			unicode: "{U+2C1A}", html: "&#11290;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [П]",
			tags: ["прописная Пе глаголицы", "capital Pe glagolitic"],
		},
		"glagolitic_s_let_pe", {
			unicode: "{U+2C4A}", html: "&#11338;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [п]",
			tags: ["строчная пе глаголицы", "small pe glagolitic"],
		},
		"glagolitic_c_let_tsi", {
			unicode: "{U+2C1C}", html: "&#11292;",
			combiningForm: "{U+1E01C}",
			combiningHTML: "&#122908;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ц"],
			tags: ["прописная Цы глаголицы", "capital Tsi glagolitic"],
		},
		"glagolitic_s_let_tsi", {
			unicode: "{U+2C4C}", html: "&#11340;",
			combiningForm: "{U+1E01C}",
			combiningHTML: "&#122908;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ц"],
			tags: ["строчная цы глаголицы", "small tsi glagolitic"],
		},
		"glagolitic_c_let_chrivi", {
			unicode: "{U+2C1D}", html: "&#11293;",
			combiningForm: "{U+1E01D}",
			combiningHTML: "&#122909;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ч"],
			tags: ["прописная Червь глаголицы", "capital Chrivi glagolitic"],
		},
		"glagolitic_s_let_chrivi", {
			unicode: "{U+2C4D}", html: "&#11341;",
			combiningForm: "{U+1E01D}",
			combiningHTML: "&#122909;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ч"],
			tags: ["строчная червь глаголицы", "small chrivi glagolitic"],
		},
		"glagolitic_c_let_sha", {
			unicode: "{U+2C1E}", html: "&#11294;",
			combiningForm: "{U+1E01E}",
			combiningHTML: "&#122910;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ш"],
			tags: ["прописная Ша глаголицы", "capital Sha glagolitic"],
		},
		"glagolitic_s_let_sha", {
			unicode: "{U+2C4E}", html: "&#11342;",
			combiningForm: "{U+1E01E}",
			combiningHTML: "&#122910;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ш"],
			tags: ["строчная ша глаголицы", "small sha glagolitic"],
		},
		"glagolitic_c_let_shta", {
			unicode: "{U+2C1B}", html: "&#11291;",
			combiningForm: "{U+1E01B}",
			combiningHTML: "&#122907;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Щ"],
			tags: ["прописная Шта глаголицы", "capital Shta glagolitic"],
		},
		"glagolitic_s_let_shta", {
			unicode: "{U+2C4B}", html: "&#11339;",
			combiningForm: "{U+1E01B}",
			combiningHTML: "&#122907;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "щ"],
			tags: ["строчная шта глаголицы", "small shta glagolitic"],
		},
		"glagolitic_c_let_yeru", {
			unicode: "{U+2C1F}", html: "&#11295;",
			combiningForm: "{U+1E01F}",
			combiningHTML: "&#122911;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ъ"],
			tags: ["прописной Еръ глаголицы", "capital Yeru glagolitic"],
		},
		"glagolitic_s_let_yeru", {
			unicode: "{U+2C4F}", html: "&#11343;",
			combiningForm: "{U+1E01F}",
			combiningHTML: "&#122911;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ъ"],
			tags: ["строчный еръ глаголицы", "small yeru glagolitic"],
		},
		"glagolitic_c_let_yery", {
			unicode: "{U+2C1F}", html: "&#11295;&#11274;",
			uniSequence: ["{U+2C1F}", "{U+2C0A}"],
			combiningForm: ["{U+1E01F}", "{U+1E00A}"],
			combiningHTML: "&#122911;&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ы"],
			tags: ["прописной Еры глаголицы", "capital Yery glagolitic"],
			symbolCustom: "s36"
		},
		"glagolitic_s_let_yery", {
			unicode: "{U+2C4F}", html: "&#11343;&#11322;",
			uniSequence: ["{U+2C4F}", "{U+2C3A}"],
			combiningForm: ["{U+1E01F}", "{U+1E00A}"],
			combiningHTML: "&#122911;&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ы"],
			tags: ["строчный еры глаголицы", "small yery glagolitic"],
			symbolCustom: "s36"
		},
		"glagolitic_c_let_yeri", {
			unicode: "{U+2C20}", html: "&#11296;",
			combiningForm: "{U+1E020}",
			combiningHTML: "&#122912;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ь"],
			tags: ["прописной Ерь глаголицы", "capital Yeri glagolitic"],
		},
		"glagolitic_s_let_yeri", {
			unicode: "{U+2C50}", html: "&#11344;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ь"],
			tags: ["строчный ерь глаголицы", "small yeri glagolitic"],
		},
		"glagolitic_c_let_yati", {
			unicode: "{U+2C21}", html: "&#11297;",
			combiningForm: "{U+1E021}",
			combiningHTML: "&#122913;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Я"],
			tags: ["прописной Ять глаголицы", "capital Yati glagolitic"],
		},
		"glagolitic_s_let_yati", {
			unicode: "{U+2C51}", html: "&#11345;",
			combiningForm: "{U+1E021}",
			combiningHTML: "&#122913;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "я"],
			tags: ["строчный ять глаголицы", "small yati glagolitic"],
		},
		"glagolitic_c_let_yo", {
			unicode: "{U+2C26}", html: "&#11302;",
			combiningForm: "{U+1E026}",
			combiningHTML: "&#122918;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ё"],
			tags: ["прописная Ё глаголицы", "capital Yo glagolitic"],
		},
		"glagolitic_s_let_yo", {
			unicode: "{U+2C56}", html: "&#11350;",
			combiningForm: "{U+1E026}",
			combiningHTML: "&#122918;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ё"],
			tags: ["строчная ё глаголицы", "small yo glagolitic"],
		},
		"glagolitic_c_let_spider_ha", {
			unicode: "{U+2C22}", html: "&#11298;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной Хлъмъ глаголицы", "capital spider Ha glagolitic"],
			alt_layout: RightAlt " [Х]",
		},
		"glagolitic_s_let_spider_ha", {
			unicode: "{U+2C52}", html: "&#11346;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["строчный хлъмъ глаголицы", "small spider ha glagolitic"],
			alt_layout: RightAlt " [х]",
		},
		"glagolitic_c_let_yu", {
			unicode: "{U+2C23}", html: "&#11299;",
			combiningForm: "{U+1E023}",
			combiningHTML: "&#122915;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ю"],
			tags: ["прописная Ю глаголицы", "capital Yu glagolitic"],
		},
		"glagolitic_s_let_yu", {
			unicode: "{U+2C53}", html: "&#11347;",
			combiningForm: "{U+1E023}",
			combiningHTML: "&#122915;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ю"],
			tags: ["строчная ю глаголицы", "small yu glagolitic"],
		},
		"glagolitic_c_let_small_yus", {
			unicode: "{U+2C24}", html: "&#11300;",
			combiningForm: "{U+1E024}",
			combiningHTML: "&#122916;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Э"],
			tags: ["прописной малый Юс глаголицы", "capital small Yus glagolitic"],
		},
		"glagolitic_s_let_small_yus", {
			unicode: "{U+2C54}", html: "&#11348;",
			combiningForm: "{U+1E024}",
			combiningHTML: "&#122916;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "э"],
			tags: ["прописной малый юс глаголицы", "capital small yus glagolitic"],
		},
		"glagolitic_c_let_small_yus_iotified", {
			unicode: "{U+2C27}", html: "&#11303;",
			combiningForm: "{U+1E027}",
			combiningHTML: "&#122919;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной малый Юс йотированный глаголицы", "capital small Yus iotified glagolitic"],
			alt_layout: RightAlt " [Э]",
			recipe: Chr(0x2C05) Chr(0x2C24),
		},
		"glagolitic_s_let_small_yus_iotified", {
			unicode: "{U+2C57}", html: "&#11351;",
			combiningForm: "{U+1E027}",
			combiningHTML: "&#122919;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной малый юс йотированный глаголицы", "capital small yus iotified glagolitic"],
			alt_layout: RightAlt " [э]",
			recipe: Chr(0x2C35) Chr(0x2C54),
		},
		"glagolitic_c_let_big_yus", {
			unicode: "{U+2C28}", html: "&#11304;",
			combiningForm: "{U+1E028}",
			combiningHTML: "&#122920;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной большой Юс глаголицы", "capital big Yus glagolitic"],
			alt_layout: LeftAlt " [О]",
			recipe: Chr(0x2C11) Chr(0x2C24),
		},
		"glagolitic_s_let_big_yus", {
			unicode: "{U+2C58}", html: "&#11352;",
			combiningForm: "{U+1E028}",
			combiningHTML: "&#122920;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной большой юс глаголицы", "capital big yus glagolitic"],
			alt_layout: LeftAlt " [о]",
			recipe: Chr(0x2C35) Chr(0x2C54),
		},
		"glagolitic_c_let_big_yus_iotified", {
			unicode: "{U+2C29}", html: "&#11305;",
			combiningForm: "{U+1E029}",
			combiningHTML: "&#122921;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной большой Юс йотированный глаголицы", "capital big Yus iotified glagolitic"],
			alt_layout: LeftAlt " [Ё]",
			recipe: Chr(0x2C26) Chr(0x2C24),
		},
		"glagolitic_s_let_big_yus_iotified", {
			unicode: "{U+2C59}", html: "&#11353;",
			combiningForm: "{U+1E029}",
			combiningHTML: "&#122921;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной большой юс йотированный глаголицы", "capital big yus iotified glagolitic"],
			alt_layout: LeftAlt " [ё]",
			recipe: Chr(0x2C56) Chr(0x2C54),
		},
		"glagolitic_c_let_fita", {
			unicode: "{U+2C2A}", html: "&#11306;",
			combiningForm: "{U+1E02A}",
			combiningHTML: "&#122922;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [Ф]",
			tags: ["прописная Фита глаголицы", "capital Fita glagolitic"],
		},
		"glagolitic_s_let_fita", {
			unicode: "{U+2C5A}", html: "&#11354;",
			combiningForm: "{U+1E02A}",
			combiningHTML: "&#122922;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [ф]",
			tags: ["строчная фита глаголицы", "small fita glagolitic"],
		},
		"glagolitic_c_let_shtapic", {
			unicode: "{U+2C2C}", html: "&#11308;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [Ъ]",
			tags: ["прописной Штапик глаголицы", "capital Shtapic glagolitic"],
		},
		"glagolitic_s_let_shtapic", {
			unicode: "{U+2C5C}", html: "&#11356;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [ъ]",
			tags: ["строчной штапик глаголицы", "small shtapic glagolitic"],
		},
		"glagolitic_c_let_trokutasti_a", {
			unicode: "{U+2C2D}", html: "&#11309;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [А]",
			tags: ["прописная треугольная А глаголицы", "capital trokutasti A glagolitic"],
		},
		"glagolitic_s_let_trokutasti_a", {
			unicode: "{U+2C5D}", html: "&#11357;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [А]",
			tags: ["строчная треугольная a глаголицы", "small trokutasti a glagolitic"],
		},
		;
		"cyr_com_vzmet", {
			unicode: "{U+A66F}", html: "&#42607;",
			group: [["Diacritics Primary", "Cyrillic Diacritics"], CtrlD],
			alt_layout: LeftControl LeftAlt " [в]",
			tags: ["взмет", "vzmet"],
			symbolClass: "Diacritic Mark",
		},
		"cyr_com_titlo", {
			unicode: "{U+0483}", html: "&#1155;",
			group: [["Diacritics Primary", "Cyrillic Diacritics"], ["n", "т"]],
			alt_layout: LeftControl LeftAlt " [т]",
			tags: ["титло", "titlo"],
			symbolClass: "Diacritic Mark",
		},
		;
		;
		"futhark_ansuz", {
			unicode: "{U+16A8}", html: "&#5800;",
			titlesAlt: True,
			group: ["Futhark Runes", "A"],
			tags: ["старший футарк ансуз", "elder futhark ansuz"],
		},
		"futhark_berkanan", {
			unicode: "{U+16D2}", html: "&#5842;",
			titlesAlt: True,
			group: ["Futhark Runes", "B"],
			tags: ["старший футарк беркана", "elder futhark berkanan", "futhork beorc", "younger futhark bjarkan"],
		},
		"futhark_dagaz", {
			unicode: "{U+16DE}", html: "&#5854;",
			titlesAlt: True,
			group: ["Futhark Runes", "D"],
			tags: ["старший футарк дагаз", "elder futhark dagaz", "futhork daeg", "futhork dæg"],
		},
		"futhark_ehwaz", {
			unicode: "{U+16D6}", html: "&#5846;",
			titlesAlt: True,
			group: ["Futhark Runes", "E"],
			tags: ["старший футарк эваз", "elder futhark ehwaz", "futhork eh"],
		},
		"futhark_fehu", {
			unicode: "{U+16A0}", html: "&#5792;",
			titlesAlt: True,
			group: ["Futhark Runes", "F"],
			tags: ["старший футарк феху", "elder futhark fehu", "futhork feoh", "younger futhark fe", "younger futhark fé"],
		},
		"futhark_gebo", {
			unicode: "{U+16B7}", html: "&#5815;",
			titlesAlt: True,
			group: ["Futhark Runes", "G"],
			tags: ["старший футарк гебо", "elder futhark gebo", "futhork gyfu", "elder futhark gebō"],
		},
		"futhark_haglaz", {
			unicode: "{U+16BA}", html: "&#5818;",
			titlesAlt: True,
			group: ["Futhark Runes", "H"],
			tags: ["старший футарк хагалаз", "elder futhark hagalaz"],
		},
		"futhark_isaz", {
			unicode: "{U+16C1}", html: "&#5825;",
			titlesAlt: True,
			group: ["Futhark Runes", "I"],
			tags: ["старший футарк исаз", "elder futhark isaz", "futhork is", "younger futhark iss", "futhork īs", "younger futhark íss"],
		},
		"futhark_eihwaz", {
			unicode: "{U+16C7}", html: "&#5831;",
			titlesAlt: True,
			group: ["Futhark Runes"],
			alt_layout: RightShift " [I]",
			tags: ["старший футарк эваз", "elder futhark eihwaz", "elder futhark iwaz", "elder futhark ēihwaz", "futhork eoh", "futhork ēoh"],
		},
		"futhark_jeran", {
			unicode: "{U+16C3}", html: "&#5827;",
			titlesAlt: True,
			group: ["Futhark Runes", "J"],
			tags: ["старший футарк йера", "elder futhark jeran", "elder futhark jēra"],
		},
		"futhark_kauna", {
			unicode: "{U+16B2}", html: "&#5810;",
			titlesAlt: True,
			group: ["Futhark Runes", "K"],
			tags: ["старший футарк кеназ", "elder futhark kauna", "elder futhark kenaz", "elder futhark kauną"],
		},
		"futhark_laguz", {
			unicode: "{U+16DA}", html: "&#5850;",
			titlesAlt: True,
			group: ["Futhark Runes", "L"],
			tags: ["старший футарк лагуз", "elder futhark laukaz", "elder futhark laguz", "futhork lagu", "futhork logr", "futhork lögr"],
		},
		"futhark_mannaz", {
			unicode: "{U+16D7}", html: "&#5847;",
			titlesAlt: True,
			group: ["Futhark Runes", "M"],
			tags: ["старший футарк манназ", "elder futhark mannaz", "futhork mann"],
		},
		"futhark_naudiz", {
			unicode: "{U+16BE}", html: "&#5822;",
			titlesAlt: True,
			group: ["Futhark Runes", "N"],
			tags: ["старший футарк наудиз", "elder futhark naudiz", "futhork nyd", "younger futhark naudr", "younger futhark nauðr"],
		},
		"futhark_ingwaz", {
			unicode: "{U+16DC}", html: "&#5852;",
			titlesAlt: True,
			group: ["Futhark Runes"],
			alt_layout: RightShift " [N]",
			tags: ["старший футарк ингваз", "elder futhark ingwaz"],
		},
		"futhark_odal", {
			unicode: "{U+16DF}", html: "&#5855;",
			titlesAlt: True,
			group: ["Futhark Runes", "O"],
			tags: ["старший футарк одал", "elder futhark othala", "futhork edel", "elder futhark ōþala", "futhork ēðel"],
		},
		"futhark_pertho", {
			unicode: "{U+16C8}", html: "&#5832;",
			titlesAlt: True,
			group: ["Futhark Runes", "P"],
			tags: ["старший футарк перто", "elder futhark pertho", "futhork peord", "elder futhark perþō", "futhork peorð"],
		},
		"futhark_raido", {
			unicode: "{U+16B1}", html: "&#5809;",
			titlesAlt: True,
			group: ["Futhark Runes", "R"],
			tags: ["старший футарк райдо", "elder futhark raido", "futhork rad", "younger futhark reid", "elder futhark raidō", "futhork rād", "younger futhark reið"],
		},
		"futhark_sowilo", {
			unicode: "{U+16CA}", html: "&#5834;",
			titlesAlt: True,
			group: ["Futhark Runes", "S"],
			tags: ["старший футарк совило", "elder futhark sowilo", "elder futhark sōwilō"],
		},
		"futhark_tiwaz", {
			unicode: "{U+16CF}", html: "&#5839;",
			titlesAlt: True,
			group: ["Futhark Runes", "T"],
			tags: ["старший футарк тейваз", "elder futhark tiwaz", "futhork ti", "futhork tir", "younger futhark tyr", "elder futhark tēwaz", "futhork tī", "futhork tīr", "younger futhark týr"],
		},
		"futhark_thurisaz", {
			unicode: "{U+16A6}", html: "&#5798;",
			titlesAlt: True,
			group: ["Futhark Runes"],
			alt_layout: RightShift "[T]",
			tags: ["старший футарк турисаз", "elder futhark thurisaz", "futhork thorn", "younger futhark thurs", "elder futhark þurisaz", "futhork þorn", "younger futhark þurs"],
		},
		"futhark_uruz", {
			unicode: "{U+16A2}", html: "&#5794;",
			titlesAlt: True,
			group: ["Futhark Runes", "U"],
			tags: ["старший футарк уруз", "elder futhark uruz", "elder futhark ura", "futhork ur", "younger futhark ur", "elder futhark ūrą", "elder futhark ūruz", "futhork ūr", "younger futhark úr"],
		},
		"futhark_wunjo", {
			unicode: "{U+16B9}", html: "&#5817;",
			titlesAlt: True,
			group: ["Futhark Runes", "W"],
			tags: ["старший футарк вуньо", "elder futhark wunjo", "futhork wynn", "elder futhark wunjō", "elder futhark ƿunjō", "futhork ƿynn"],
		},
		"futhark_algiz", {
			unicode: "{U+16C9}", html: "&#5833;",
			titlesAlt: True,
			group: ["Futhark Runes", "Z"],
			tags: ["старший футарк альгиз", "elder futhark algiz", "futhork eolhx"],
		},
		"futhork_as", {
			unicode: "{U+16AA}", html: "&#5802;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [A]",
			tags: ["футорк ас", "futhork as", "futhork ās"],
		},
		"futhork_aesc", {
			unicode: "{U+16AB}", html: "&#5803;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift " [A]",
			tags: ["футорк эск", "futhork aesc", "futhork æsc"],
			recipe: Chr(0x16A8) Chr(0x16D6),
		},
		"futhork_cen", {
			unicode: "{U+16B3}", html: "&#5811;",
			titlesAlt: True,
			group: ["Futhork Runes", "C"],
			tags: ["футорк кен", "futhork cen", "futhork cēn"],
		},
		"futhork_ear", {
			unicode: "{U+16E0}", html: "&#5820;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [E]",
			tags: ["футорк эар", "ear"],
		},
		"futhork_gar", {
			unicode: "{U+16B8}", html: "&#5816;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [G]",
			tags: ["футорк гар", "futhork gar", "futhork gār"],
		},
		"futhork_haegl", {
			unicode: "{U+16BB}", html: "&#5819;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [H]",
			tags: ["футорк хегль", "futhork haegl", "futhork hægl"],
		},
		"futhork_ger", {
			unicode: "{U+16C4}", html: "&#5828;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [J]",
			tags: ["футорк гер", "futhork ger", "futhork gēr"],
		},
		"futhork_ior", {
			unicode: "{U+16E1}", html: "&#5857;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift "[J]",
			tags: ["футорк йор", "futhork gerx", "futhork ior", "younger futhark arx", "futhork gērx", "futhork īor", "youner futhark árx"],
		},
		"futhork_cealc", {
			unicode: "{U+16E4}", html: "&#5860;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [K]",
			tags: ["футорк келк", "futhork cealc"],
		},
		"futhork_calc", {
			unicode: "{U+16E3}", html: "&#5859;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift " [K]",
			tags: ["футорк калк", "futhork calc"],
		},
		"futhork_ing", {
			unicode: "{U+16DD}", html: "&#5853;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [N]",
			tags: ["футорк инг", "futhork ing"],
		},
		"futhork_os", {
			unicode: "{U+16A9}", html: "&#5801;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [O]",
			tags: ["футорк ос", "futhork os", "futhork ōs"],
		},
		"futhork_cweorth", {
			unicode: "{U+16E2}", html: "&#5801;",
			titlesAlt: True,
			group: ["Futhork Runes", "Q"],
			tags: ["футорк квирд", "futhark cweorth", "futhork cƿeorð"],
		},
		"futhork_sigel", {
			unicode: "{U+16CB}", html: "&#5835;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [S]",
			tags: ["футорк сигель", "futhork sigel", "younger futhark sól"],
		},
		"futhork_stan", {
			unicode: "{U+16E5}", html: "&#5861;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift " [S]",
			tags: ["футорк стан", "futhork stan"],
		},
		"futhork_yr", {
			unicode: "{U+16A3}", html: "&#5795;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [Y]",
			tags: ["футорк ир", "futhork yr", "futhork ȳr"],
		},
		"futhark_younger_jera", {
			unicode: "{U+16C5}", html: "&#5829;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [A]",
			tags: ["младший футарк йера", "younger futhark jera", "younger futhark ar", "younger futhark ár"],
		},
		"futhark_younger_jera_short_twig", {
			unicode: "{U+16C6}", html: "&#5830;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [A]",
			tags: ["младший футарк короткая йера", "younger futhark short twig jera"],
		},
		"futhark_younger_bjarkan_short_twig", {
			unicode: "{U+16D3}", html: "&#5843;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [B]",
			tags: ["младший футарк короткая беркана", "younger futhark short twig bjarkan"],
		},
		"futhark_younger_hagall", {
			unicode: "{U+16BC}", html: "&#5820;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [H]",
			tags: ["младший футарк хагал", "younger futhark hagall"],
		},
		"futhark_younger_hagall_short_twig", {
			unicode: "{U+16BD}", html: "&#5821;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [H]",
			tags: ["младший футарк короткий хагал", "younger futhark short twig hagall"],
		},
		"futhark_younger_kaun", {
			unicode: "{U+16B4}", html: "&#5812;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [K]",
			tags: ["младший футарк каун", "younger futhark kaun"],
		},
		"futhark_younger_madr", {
			unicode: "{U+16D8}", html: "&#5848;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [M]",
			tags: ["младший футарк мадр", "younger futhark madr", "younger futhark maðr"],
		},
		"futhark_younger_madr_short_twig", {
			unicode: "{U+16D9}", html: "&#5849;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [M]",
			tags: ["младший футарк короткий мадр", "younger futhark short twig madr", "younger futhark short twig maðr"],
		},
		"futhark_younger_naud_short_twig", {
			unicode: "{U+16BF}", html: "&#5823;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [N]",
			tags: ["младший футарк короткий науд", "younger futhark short twig naud", "younger futhark short twig nauðr"],
		},
		"futhark_younger_oss", {
			unicode: "{U+16AC}", html: "&#5804;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [O]",
			tags: ["младший футарк осс", "younger futhark oss", "younger futhark óss"],
		},
		"futhark_younger_oss_short_twig", {
			unicode: "{U+16AD}", html: "&#5805;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [O]",
			tags: ["младший футарк короткий осс", "younger futhark short twig oss", "younger futhark short twig óss"],
		},
		"futhark_younger_sol_short_twig", {
			unicode: "{U+16CC}", html: "&#5836;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [S]",
			tags: ["младший футарк короткий сол", "younger futhark short twig sol", "younger futhark short twig sól"],
		},
		"futhark_younger_tyr_short_twig", {
			unicode: "{U+16D0}", html: "&#5840;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [T]",
			tags: ["младший футарк короткий тир", "younger futhark short twig tyr", "younger futhark short twig týr"],
		},
		"futhark_younger_ur", {
			unicode: "{U+16A4}", html: "&#5804;",
			titlesAlt: True,
			group: ["Younger Futhark Runes", "Y"],
			tags: ["младший футарк ур", "younger futhark ur"],
		},
		"futhark_younger_yr", {
			unicode: "{U+16E6}", html: "&#5862;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt "[Y]",
			tags: ["младший футарк короткий тис", "younger futhark yr"],
		},
		"futhark_younger_yr_short_twig", {
			unicode: "{U+16E7}", html: "&#5863;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [Y]",
			tags: ["младший футарк короткий тис", "younger futhark short twig yr"],
		},
		"futhark_younger_icelandic_yr", {
			unicode: "{U+16E8}", html: "&#5864;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightShift " [Y]",
			tags: ["младший футарк исладнский тис", "younger futhark icelandic yr"],
		},
		"futhark_almanac_arlaug", {
			unicode: "{U+16EE}", html: "&#5870;",
			titlesAlt: True,
			group: ["Almanac Runes"],
			alt_layout: RightAlt " [7]",
			tags: ["золотой номер 17 арлауг", "golden number 17 arlaug"],
		},
		"futhark_almanac_tvimadur", {
			unicode: "{U+16EF}", html: "&#5871;",
			titlesAlt: True,
			group: ["Almanac Runes"],
			alt_layout: RightAlt " [8]",
			tags: ["золотой номер 18 твимадур", "golden number 18 tvimadur", "golden number 18 tvímaður"],
		},
		"futhark_almanac_belgthor", {
			unicode: "{U+16F0}", html: "&#5872;",
			titlesAlt: True,
			group: ["Almanac Runes"],
			alt_layout: RightAlt " [9]",
			tags: ["золотой номер 19 белгтор", "golden number 19 belgthor"],
		},
		"futhark_younger_later_e", {
			unicode: "{U+16C2}", html: "&#5826;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [E]",
			tags: ["младшяя поздняя е", "later younger futhark e"],
		},
		"futhark_younger_later_eth", {
			unicode: "{U+16A7}", html: "&#5799;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [D]",
			tags: ["поздний младший футарк эт", "later younger futhark eth"],
		},
		"futhark_younger_later_d", {
			unicode: "{U+16D1}", html: "&#5841;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [D]",
			tags: ["поздний младший футарк д", "later younger futhark d"],
		},
		"futhark_younger_later_l", {
			unicode: "{U+16DB}", html: "&#5851;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [L]",
			tags: ["поздний младший футарк л", "later younger futhark l"],
		},
		"futhark_younger_later_p", {
			unicode: "{U+16D4}", html: "&#5844;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [P]",
			tags: ["младшяя поздняя п", "later younger futhark p"],
		},
		"futhark_younger_later_v", {
			unicode: "{U+16A1}", html: "&#5793;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes", "V"],
			tags: ["поздний младший футарк в", "later younger futhark v"],
		},
		"medieval_c", {
			unicode: "{U+16CD}", html: "&#5837;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [C]",
			tags: ["средневековый си", "medieval с"],
		},
		"medieval_en", {
			unicode: "{U+16C0}", html: "&#5824;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [N]",
			tags: ["средневековый эн", "medieval en"],
		},
		"medieval_on", {
			unicode: "{U+16B0}", html: "&#5808;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [O]",
			tags: ["средневековый он", "medieval on"],
		},
		"medieval_o", {
			unicode: "{U+16AE}", html: "&#5806;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt RightShift " [O]",
			tags: ["средневековый о", "medieval o"],
		},
		"medieval_x", {
			unicode: "{U+16EA}", html: "&#5866;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [X]",
			tags: ["средневековый экс", "medieval ex"],
		},
		"medieval_z", {
			unicode: "{U+16CE}", html: "&#5838;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [Z]",
			tags: ["средневековый зе", "medieval ze"],
		},
		"runic_single_punctuation", {
			unicode: "{U+16EB}", html: "&#5867;",
			titlesAlt: True,
			group: ["Runic Punctuation"],
			alt_layout: RightAlt " [.]",
			tags: ["руническая одиночное препинание", "runic single punctuation"],
		},
		"runic_multiple_punctuation", {
			unicode: "{U+16EC}", html: "&#5868;",
			titlesAlt: True,
			group: ["Runic Punctuation"],
			alt_layout: RightAlt " [Space]",
			tags: ["руническое двойное препинание", "runic multiple punctuation"],
		},
		"runic_cruciform_punctuation", {
			unicode: "{U+16ED}", html: "&#5869;",
			titlesAlt: True,
			group: ["Runic Punctuation"],
			alt_layout: RightAlt " [,]",
			tags: ["руническое крестовидное препинание", "runic cruciform punctuation"],
		},
		;
		;
		; * Wallet Signs
		"wallet_sign", {
			unicode: "{U+00A4}", html: "&#164;", entity: "&curren;",
			group: ["Wallet Signs"],
			tags: ["знак валюты", "currency sign"],
			recipe: ["XO"],
		},
		"wallet_austral", {
			unicode: "{U+20B3}", html: "&#8371;",
			group: ["Wallet Signs"],
			tags: ["аустраль", "austral"],
			recipe: ["A=", "ARA"],
		},
		"wallet_dollar", {
			unicode: "{U+0024}", html: "&#36;", entity: "&dollar;",
			group: ["Wallet Signs"],
			tags: ["доллар", "dollar"],
			recipe: ["S|", "USD", "DLR"],
		},
		"wallet_cent", {
			unicode: "{U+00A2}", html: "&cent;",
			group: ["Wallet Signs"],
			tags: ["цент", "cent"],
			recipe: ["c|", "CNT"],
		},
		"wallet_pound", {
			unicode: "{U+00A3}", html: "&#163;", entity: "&pound;",
			group: ["Wallet Signs"],
			tags: ["фунт", "pound"],
			recipe: ["f_", "GBP"],
		},
		"wallet_eur", {
			unicode: "{U+20AC}", html: "&#8364;",
			group: ["Wallet Signs"],
			tags: ["евро", "euro"],
			recipe: ["C=", "EUR"],
		},
		"wallet_franc", {
			unicode: "{U+20A3}", html: "&#8374;",
			group: ["Wallet Signs"],
			tags: ["франк", "franc"],
			recipe: ["F=", "FRF"],
		},
		"wallet_tournois", {
			unicode: "{U+20B6}", html: "&#8353;",
			group: ["Wallet Signs"],
			tags: ["турский ливр", "tournois"],
			recipe: ["lt", "LTF"],
		},
		"wallet_rub", {
			unicode: "{U+20BD}", html: "&#8381;",
			group: ["Wallet Signs"],
			tags: ["рубль", "ruble"],
			recipe: ["Р=", "RUB", "РУБ"],
		},
		"wallet_hryvnia", {
			unicode: "{U+20B4}", html: "&#8372;",
			group: ["Wallet Signs"],
			tags: ["гривна", "hryvnia"],
			recipe: ["S=", "UAH", "ГРН"],
		},
		"wallet_lira", {
			unicode: "{U+20A4}", html: "&#8356;",
			group: ["Wallet Signs"],
			tags: ["лира", "lira"],
			recipe: ["f=", "LIR"],
		},
		"wallet_turkish_lira", {
			unicode: "{U+20BA}", html: "&#8378;",
			group: ["Wallet Signs"],
			tags: ["лира", "lira"],
			recipe: ["L=", "TRY"],
		},
		"wallet_rupee", {
			unicode: "{U+20B9}", html: "&#8377;",
			group: ["Wallet Signs"],
			tags: ["рупия", "rupee"],
			recipe: ["R=", "INR", "RUP"],
		},
		"wallet_won", {
			unicode: "{U+20A9}", html: "&#8361;",
			group: ["Wallet Signs"],
			tags: ["вон", "won"],
			recipe: ["W=", "WON", "KRW"],
		},
		"wallet_yen", {
			unicode: "{U+00A5}", html: "&#165;", entity: "&yen;",
			group: ["Wallet Signs"],
			tags: ["знак йены", "yen sign"],
			recipe: ["Y=", "YEN"],
		},
		"wallet_jpy_yen", {
			unicode: "{U+5186}", html: "&#20870;",
			group: ["Wallet Signs"],
			tags: ["йена", "yen"],
			recipe: ["JPY"],
		},
		"wallet_cny_yuan", {
			unicode: "{U+5143}", html: "&#20803;",
			group: ["Wallet Signs"],
			tags: ["юань", "yuan"],
			recipe: ["CNY"],
		},
		"wallet_viet_dong", {
			unicode: "{U+20AB}", html: "&#8363;",
			group: ["Wallet Signs"],
			tags: ["вьетнамский донг", "vietnamese dong"],
			recipe: ["VND", "DNG"],
		},
		"wallet_mongol_tugrik", {
			unicode: "{U+20AE}", html: "&#8366;",
			group: ["Wallet Signs"],
			tags: ["монгольский тугрик", "mongolian tugrik"],
			recipe: ["T//", "MNT", "TGK"],
		},
		"wallet_qazaq_tenge", {
			unicode: "{U+20B8}", html: "&#8376;",
			group: ["Wallet Signs"],
			tags: ["казахский тенге", "kazakh tenge"],
			recipe: ["T=", "KZT", "TNG"],
		},
		"wallet_new_sheqel", {
			unicode: "{U+20AA}", html: "&#8362;",
			group: ["Wallet Signs"],
			tags: ["новый шекель", "new sheqel"],
			recipe: ["NZD", "SHQ"],
		},
		"wallet_philippine_peso", {
			unicode: "{U+20B1}", html: "&#8369;",
			group: ["Wallet Signs"],
			tags: ["филиппинский песо", "philippine peso"],
			recipe: ["P=", "PHP"],
		},
		"wallet_roman_denarius", {
			unicode: "{U+10196}", html: "&#65942;",
			group: ["Wallet Signs"],
			tags: ["римский денарий", "roman denarius"],
			recipe: ["X-", "DIN"],
		},
		"wallet_bitcoin", {
			unicode: "{U+20BF}", html: "&#8383;",
			group: ["Wallet Signs"],
			tags: ["биткоин", "bitcoin"],
			recipe: ["B||", "BTC"],
		},
		;
		"copyright", {
			unicode: "{U+00A9}", html: "&#169;", entity: "&copy;",
			altCode: "0169",
			group: ["Other Signs", ["c", "с"]],
			show_on_fast_keys: True,
			tags: ["копирайт", "copyright"],
			recipe: ["copy", "cri"],
		},
		"copyleft", {
			unicode: "{U+1F12F}", html: "&#127279;",
			group: ["Other Signs"],
			tags: ["копилефт", "copyleft"],
			recipe: "cft",
		},
		"registered", {
			unicode: "{U+00AE}", html: "&#174;", entity: "&reg;",
			altCode: "0174",
			group: ["Other Signs", ["c", "с"]],
			modifier: CapsLock,
			show_on_fast_keys: True,
			tags: ["зарегистрированный", "registered"],
			recipe: "reg",
		},
		"trademark", {
			unicode: "{U+2122}", html: "&#8482;", entity: "&trade;",
			altCode: "0153",
			group: ["Other Signs", ["c", "с"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			tags: ["торговый знак", "trademark"],
			recipe: ["TM", "tm"],
		},
		"servicemark", {
			unicode: "{U+2120}", html: "&#8480;",
			group: ["Other Signs", ["c", "с"]],
			modifier: CapsLock LeftShift,
			show_on_fast_keys: True,
			tags: ["знак обслуживания", "servicemark"],
			recipe: ["SM", "sm"],
		},
)

MapInsert(Characters,
	"lat_c_let_a", { calcOff: "", unicode: "{U+0041}" },
		"lat_s_let_a", { calcOff: "", unicode: "{U+0061}" },
		"lat_c_let_b", { calcOff: "", unicode: "{U+0042}" },
		"lat_s_let_b", { calcOff: "", unicode: "{U+0062}" },
		"lat_c_let_c", { calcOff: "", unicode: "{U+0043}" },
		"lat_s_let_c", { calcOff: "", unicode: "{U+0063}" },
		"lat_c_let_d", { calcOff: "", unicode: "{U+0044}" },
		"lat_s_let_d", { calcOff: "", unicode: "{U+0064}" },
		"lat_c_let_e", { calcOff: "", unicode: "{U+0045}" },
		"lat_s_let_e", { calcOff: "", unicode: "{U+0065}" },
		"lat_c_let_f", { calcOff: "", unicode: "{U+0046}" },
		"lat_s_let_f", { calcOff: "", unicode: "{U+0066}" },
		"lat_c_let_g", { calcOff: "", unicode: "{U+0047}" },
		"lat_s_let_g", { calcOff: "", unicode: "{U+0067}" },
		"lat_c_let_h", { calcOff: "", unicode: "{U+0048}" },
		"lat_s_let_h", { calcOff: "", unicode: "{U+0068}" },
		"lat_c_let_i", { calcOff: "", unicode: "{U+0049}" },
		"lat_s_let_i", { calcOff: "", unicode: "{U+0069}" },
		"lat_c_let_j", { calcOff: "", unicode: "{U+004A}" },
		"lat_s_let_j", { calcOff: "", unicode: "{U+006A}" },
		"lat_c_let_k", { calcOff: "", unicode: "{U+004B}" },
		"lat_s_let_k", { calcOff: "", unicode: "{U+006B}" },
		"lat_c_let_l", { calcOff: "", unicode: "{U+004C}" },
		"lat_s_let_l", { calcOff: "", unicode: "{U+006C}" },
		"lat_c_let_m", { calcOff: "", unicode: "{U+004D}" },
		"lat_s_let_m", { calcOff: "", unicode: "{U+006D}" },
		"lat_c_let_n", { calcOff: "", unicode: "{U+004E}" },
		"lat_s_let_n", { calcOff: "", unicode: "{U+006E}" },
		"lat_c_let_o", { calcOff: "", unicode: "{U+004F}" },
		"lat_s_let_o", { calcOff: "", unicode: "{U+006F}" },
		"lat_c_let_p", { calcOff: "", unicode: "{U+0050}" },
		"lat_s_let_p", { calcOff: "", unicode: "{U+0070}" },
		"lat_c_let_q", { calcOff: "", unicode: "{U+0051}" },
		"lat_s_let_q", { calcOff: "", unicode: "{U+0071}" },
		"lat_c_let_r", { calcOff: "", unicode: "{U+0052}" },
		"lat_s_let_r", { calcOff: "", unicode: "{U+0072}" },
		"lat_c_let_s", { calcOff: "", unicode: "{U+0053}" },
		"lat_s_let_s", { calcOff: "", unicode: "{U+0073}" },
		"lat_c_let_t", { calcOff: "", unicode: "{U+0054}" },
		"lat_s_let_t", { calcOff: "", unicode: "{U+0074}" },
		"lat_c_let_u", { calcOff: "", unicode: "{U+0055}" },
		"lat_s_let_u", { calcOff: "", unicode: "{U+0075}" },
		"lat_c_let_v", { calcOff: "", unicode: "{U+0056}" },
		"lat_s_let_v", { calcOff: "", unicode: "{U+0076}" },
		"lat_c_let_w", { calcOff: "", unicode: "{U+0057}" },
		"lat_s_let_w", { calcOff: "", unicode: "{U+0077}" },
		"lat_c_let_x", { calcOff: "", unicode: "{U+0058}" },
		"lat_s_let_x", { calcOff: "", unicode: "{U+0078}" },
		"lat_c_let_y", { calcOff: "", unicode: "{U+0059}" },
		"lat_s_let_y", { calcOff: "", unicode: "{U+0079}" },
		"lat_c_let_z", { calcOff: "", unicode: "{U+005A}" },
		"lat_s_let_z", { calcOff: "", unicode: "{U+007A}" },
		;
		"cyr_c_let_a", { calcOff: "", unicode: "{U+0410}" }, ; А
		"cyr_s_let_a", { calcOff: "", unicode: "{U+0430}" }, ; а
		"cyr_c_let_b", { calcOff: "", unicode: "{U+0411}" }, ; Б
		"cyr_s_let_b", { calcOff: "", unicode: "{U+0431}" }, ; б
		"cyr_c_let_v", { calcOff: "", unicode: "{U+0412}" }, ; В
		"cyr_s_let_v", { calcOff: "", unicode: "{U+0432}" }, ; в
		"cyr_c_let_g", { calcOff: "", unicode: "{U+0413}" }, ; Г
		"cyr_s_let_g", { calcOff: "", unicode: "{U+0433}" }, ; г
		"cyr_c_let_d", { calcOff: "", unicode: "{U+0414}" }, ; Д
		"cyr_s_let_d", { calcOff: "", unicode: "{U+0434}" }, ; д
		"cyr_c_let_e", { calcOff: "", unicode: "{U+0415}" }, ; Е
		"cyr_s_let_e", { calcOff: "", unicode: "{U+0435}" }, ; е
		"cyr_c_let_yo", { calcOff: "", unicode: "{U+0401}" }, ; Ё
		"cyr_s_let_yo", { calcOff: "", unicode: "{U+0451}" }, ; ё
		"cyr_c_let_zh", { calcOff: "", unicode: "{U+0416}" }, ; Ж
		"cyr_s_let_zh", { calcOff: "", unicode: "{U+0436}" }, ; ж
		"cyr_c_let_z", { calcOff: "", unicode: "{U+0417}" }, ; З
		"cyr_s_let_z", { calcOff: "", unicode: "{U+0437}" }, ; з
		"cyr_c_let_и", { calcOff: "", unicode: "{U+0418}" }, ; И
		"cyr_s_let_и", { calcOff: "", unicode: "{U+0438}" }, ; и
		"cyr_c_let_iy", { calcOff: "", unicode: "{U+0419}" }, ; Й
		"cyr_s_let_iy", { calcOff: "", unicode: "{U+0439}" }, ; й
		"cyr_c_let_k", { calcOff: "", unicode: "{U+041A}" }, ; К
		"cyr_s_let_k", { calcOff: "", unicode: "{U+043A}" }, ; к
		"cyr_c_let_l", { calcOff: "", unicode: "{U+041B}" }, ; Л
		"cyr_s_let_l", { calcOff: "", unicode: "{U+043B}" }, ; л
		"cyr_c_let_m", { calcOff: "", unicode: "{U+041C}" }, ; М
		"cyr_s_let_m", { calcOff: "", unicode: "{U+043C}" }, ; м
		"cyr_c_let_n", { calcOff: "", unicode: "{U+041D}" }, ; Н
		"cyr_s_let_n", { calcOff: "", unicode: "{U+043D}" }, ; н
		"cyr_c_let_o", { calcOff: "", unicode: "{U+041E}" }, ; О
		"cyr_s_let_o", { calcOff: "", unicode: "{U+043E}" }, ; о
		"cyr_c_let_p", { calcOff: "", unicode: "{U+041F}" }, ; П
		"cyr_s_let_p", { calcOff: "", unicode: "{U+043F}" }, ; п
		"cyr_c_let_r", { calcOff: "", unicode: "{U+0420}" }, ; Р
		"cyr_s_let_r", { calcOff: "", unicode: "{U+0440}" }, ; р
		"cyr_c_let_s", { calcOff: "", unicode: "{U+0421}" }, ; С
		"cyr_s_let_s", { calcOff: "", unicode: "{U+0441}" }, ; с
		"cyr_c_let_t", { calcOff: "", unicode: "{U+0422}" }, ; Т
		"cyr_s_let_t", { calcOff: "", unicode: "{U+0442}" }, ; т
		"cyr_c_let_u", { calcOff: "", unicode: "{U+0423}" }, ; У
		"cyr_s_let_u", { calcOff: "", unicode: "{U+0443}" }, ; у
		"cyr_c_let_f", { calcOff: "", unicode: "{U+0424}" }, ; Ф
		"cyr_s_let_f", { calcOff: "", unicode: "{U+0444}" }, ; ф
		"cyr_c_let_h", { calcOff: "", unicode: "{U+0425}" }, ; Х
		"cyr_s_let_h", { calcOff: "", unicode: "{U+0445}" }, ; х
		"cyr_c_let_ts", { calcOff: "", unicode: "{U+0426}" }, ; Ц
		"cyr_s_let_ts", { calcOff: "", unicode: "{U+0446}" }, ; ц
		"cyr_c_let_ch", { calcOff: "", unicode: "{U+0427}" }, ; Ч
		"cyr_s_let_ch", { calcOff: "", unicode: "{U+0447}" }, ; ч
		"cyr_c_let_sh", { calcOff: "", unicode: "{U+0428}" }, ; Ш
		"cyr_s_let_sh", { calcOff: "", unicode: "{U+0448}" }, ; ш
		"cyr_c_let_shch", { calcOff: "", unicode: "{U+0429}" }, ; Щ
		"cyr_s_let_shch", { calcOff: "", unicode: "{U+0449}" }, ; щ
		"cyr_c_let_yeru", { calcOff: "", unicode: "{U+042A}" }, ; Ъ
		"cyr_s_let_yeru", { calcOff: "", unicode: "{U+044A}" }, ; ъ
		"cyr_c_let_yery", { calcOff: "", unicode: "{U+042B}" }, ; Ы
		"cyr_s_let_yery", { calcOff: "", unicode: "{U+044B}" }, ; ы
		"cyr_c_let_yeri", { calcOff: "", unicode: "{U+042C}" }, ; Ь
		"cyr_s_let_yeri", { calcOff: "", unicode: "{U+044C}" }, ; ь
		"cyr_c_let_э", { calcOff: "", unicode: "{U+042D}" }, ; Э
		"cyr_s_let_э", { calcOff: "", unicode: "{U+044D}" }, ; э
		"cyr_c_let_yu", { calcOff: "", unicode: "{U+042E}" }, ; Ю
		"cyr_s_let_yu", { calcOff: "", unicode: "{U+044E}" }, ; ю
		"cyr_c_let_ya", { calcOff: "", unicode: "{U+042F}" }, ; Я
		"cyr_s_let_ya", { calcOff: "", unicode: "{U+044F}" } ; я
)

MapInsert(Characters,
	"num_sup_0", { unicode: "{U+2070}", html: "&#8304;" },
		"num_sup_1", { unicode: "{U+00B9}", html: "&#185;", entity: "&sup1;" },
		"num_sup_2", { unicode: "{U+00B2}", html: "&#178;", entity: "&sup2;" },
		"num_sup_3", { unicode: "{U+00B3}", html: "&#179;", entity: "&sup3;" },
		"num_sup_4", { unicode: "{U+2074}", html: "&#8308;" },
		"num_sup_5", { unicode: "{U+2075}", html: "&#8309;" },
		"num_sup_6", { unicode: "{U+2076}", html: "&#8310;" },
		"num_sup_7", { unicode: "{U+2077}", html: "&#8311;" },
		"num_sup_8", { unicode: "{U+2078}", html: "&#8312;" },
		"num_sup_9", { unicode: "{U+2079}", html: "&#8313;" },
		"num_sup_minus", { unicode: "{U+207B}", html: "&#8315;" },
		"num_sup_equals", { unicode: "{U+207C}", html: "&#8316;" },
		"num_sup_plus", { unicode: "{U+207A}", html: "&#8314;" },
		"num_sup_left_parenthesis", { unicode: "{U+207D}", html: "&#8317;" },
		"num_sup_right_parenthesis", { unicode: "{U+207E}", html: "&#8318;" },
		"num_sub_0", { unicode: "{U+2080}", html: "&#8320;" },
		"num_sub_1", { unicode: "{U+2081}", html: "&#8321;" },
		"num_sub_2", { unicode: "{U+2082}", html: "&#8322;" },
		"num_sub_3", { unicode: "{U+2083}", html: "&#8323;" },
		"num_sub_4", { unicode: "{U+2084}", html: "&#8324;" },
		"num_sub_5", { unicode: "{U+2085}", html: "&#8325;" },
		"num_sub_6", { unicode: "{U+2086}", html: "&#8326;" },
		"num_sub_7", { unicode: "{U+2087}", html: "&#8327;" },
		"num_sub_8", { unicode: "{U+2088}", html: "&#8328;" },
		"num_sub_9", { unicode: "{U+2089}", html: "&#8329;" },
		"num_sub_minus", { unicode: "{U+208B}", html: "&#8331;" },
		"num_sub_equals", { unicode: "{U+208C}", html: "&#8332;" },
		"num_sub_plus", { unicode: "{U+208A}", html: "&#8330;" },
		"num_sub_left_parenthesis", { unicode: "{U+208D}", html: "&#8333;" },
		"num_sub_right_parenthesis", { unicode: "{U+208E}", html: "&#8334;" },
)

MapInsert(Characters,
	"kkey_0", { calcOff: "", unicode: "{U+0030}", sup: "num_sup_0", sub: "num_sub_0" },
		"kkey_1", { calcOff: "", unicode: "{U+0031}", sup: "num_sup_1", sub: "num_sub_1" },
		"kkey_2", { calcOff: "", unicode: "{U+0032}", sup: "num_sup_2", sub: "num_sub_2" },
		"kkey_3", { calcOff: "", unicode: "{U+0033}", sup: "num_sup_3", sub: "num_sub_3" },
		"kkey_4", { calcOff: "", unicode: "{U+0034}", sup: "num_sup_4", sub: "num_sub_4" },
		"kkey_5", { calcOff: "", unicode: "{U+0035}", sup: "num_sup_5", sub: "num_sub_5" },
		"kkey_6", { calcOff: "", unicode: "{U+0036}", sup: "num_sup_6", sub: "num_sub_6" },
		"kkey_7", { calcOff: "", unicode: "{U+0037}", sup: "num_sup_7", sub: "num_sub_7" },
		"kkey_8", { calcOff: "", unicode: "{U+0038}", sup: "num_sup_8", sub: "num_sub_8" },
		"kkey_9", { calcOff: "", unicode: "{U+0039}", sup: "num_sup_9", sub: "num_sub_9" },
		"kkey_minus", { calcOff: "", unicode: "{U+002D}", sup: "num_sup_minus", sub: "num_sub_minus" },
		"kkey_equals", { calcOff: "", unicode: "{U+003D}", sup: "num_sup_equals", sub: "num_sub_equals" },
		"kkey_underscore", { calcOff: "", unicode: "{U+005F}" },
		"kkey_hyphen_minus", { calcOff: "", unicode: "{U+002D}" },
		"kkey_plus", { calcOff: "", unicode: "{U+002B}", sup: "num_sup_plus", sub: "num_sub_plus" },
		"kkey_left_parenthesis", { calcOff: "", unicode: "{U+0028}", sup: "num_sup_left_parenthesis", sub: "num_sub_left_parenthesis" },
		"kkey_right_parenthesis", { calcOff: "", unicode: "{U+0029}", sup: "num_sup_right_parenthesis", sub: "num_sub_right_parenthesis" },
		"kkey_comma", { calcOff: "", unicode: "{U+002C}" },
		"kkey_dot", { calcOff: "", unicode: "{U+002E}" },
		"kkey_semicolon", { calcOff: "", unicode: "{U+003B}" },
		"kkey_colon", { calcOff: "", unicode: "{U+003A}" },
		"kkey_apostrophe", { calcOff: "", unicode: "{U+0027}" },
		"kkey_quotation", { calcOff: "", unicode: "{U+0022}" },
		"kkey_l_square_bracket", { calcOff: "", unicode: "{U+005B}" },
		"kkey_r_square_bracket", { calcOff: "", unicode: "{U+005D}" },
		"kkey_l_curly_bracket", { calcOff: "", unicode: "{U+007B}" },
		"kkey_r_curly_bracket", { calcOff: "", unicode: "{U+007D}" },
		"kkey_grave_accent", { calcOff: "", unicode: "{U+0060}" },
		"kkey_tilde", { calcOff: "", unicode: "{U+007E}" },
		"kkey_slash", { calcOff: "", unicode: "{U+002F}" },
		"kkey_backslash", { calcOff: "", unicode: "{U+005C}" },
		"kkey_verticalline", { calcOff: "", unicode: "{U+007C}" },
		"kkey_lessthan", { calcOff: "", unicode: "{U+003C}" },
		"kkey_greaterthan", { calcOff: "", unicode: "{U+003E}" },
)

CharactersCount := GetMapCount(Characters)

MapInsert(Characters,
	"misc_crlf_emspace", {
		unicode: CallChar("carriage_return", "unicode"), html:
			CallChar("carriage_return", "html") .
			CallChar("new_line", "html") .
			CallChar("emsp", "html"),
		uniSequence: [
			CallChar("carriage_return", "unicode"),
			CallChar("new_line", "unicode"),
			CallChar("emsp", "unicode"),
		],
		group: ["Misc"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Enter]",
		symbolAlt: CallChar("carriage_return", "symbolAlt")
	},
		"misc_lf_emspace", {
			unicode: CallChar("new_line", "unicode"), html:
				CallChar("new_line", "html") .
				CallChar("emsp", "html"),
			group: ["Misc"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Enter]",
			symbolAlt: CallChar("new_line", "symbolAlt")
		},
)


ProcessMapAfter() {
	global Characters
	Library := Map("Diacritic Mark", [], "Spaces", [])

	for characterEntry, value in Characters {
		EntryName := RegExReplace(characterEntry, "^\S+\s+")
		if HasProp(value, "symbolClass") {
			if value.symbolClass = "Diacritic Mark" {
				Library["Diacritic Mark"].Push(GetChar(EntryName))
			} else if value.symbolClass = "Spaces" {
				Library["Spaces"].Push(GetChar(EntryName))
			}
		}
	}

	for characterEntry, value in Characters {
		EntryName := RegExReplace(characterEntry, "^\S+\s+")
		EntryCharacter := GetChar(EntryName)
		if HasProp(value, "symbolClass") {
			for symbol in Library[value.symbolClass] {
				if value.symbolClass = "Diacritic Mark" {
					value.symbol := GetChar("dotted_circle") EntryCharacter
				} else if value.symbolClass = "Spaces" {
					value.symbol := "[" EntryCharacter "]"
					value.symbolCustom := "underline"
				}
			}
		} else {
			value.symbol := EntryCharacter
		}

		if HasProp(value, "tags") {
			if RegExMatch(EntryName, "^\S+_(.)_let_(.)", &match) {
				ValueLetter := HasProp(value, "letter") ? value.letter : match[2]
				LetterVar := match[1] = "c" ? StrUpper(ValueLetter) : ValueLetter
				CaseRu := match[1] = "c" ? "прописная буква" : "строчная буква"
				CaseEn := match[1] = "c" ? "capital letter" : "small letter"

				for index, tag in value.tags {
					tag := RegExReplace(tag, "R\$", CaseRu " " LetterVar)
					tag := RegExReplace(tag, "E\$", CaseEn " " LetterVar)
					value.tags[index] := tag
				}
			}
		}

		if HasProp(value, "recipe") {
			if IsObject(value.recipe) {
				recipeAltCreated := false

				for recipe in value.recipe {
					modifiedRecipe := ""
					recipeModified := false

					for k, char in StrSplit(recipe) {
						foundMatch := false

						for diacritic in Library["Diacritic Mark"] {
							if InStr(char, diacritic) {
								modifiedRecipe .= GetChar("dotted_circle") char
								recipeModified := true
								foundMatch := true
								break
							}
						}

						if !foundMatch {
							modifiedRecipe .= char
						}
					}

					if recipeModified {
						if !recipeAltCreated {
							value.recipeAlt := []
							recipeAltCreated := true
						}
						value.recipeAlt.Push(modifiedRecipe)
					}
				}
			} else {
				if RegExMatch(EntryName, "^\S+_(.)_let_(.)", &match) {
					LetterVar := match[1] = "c" ? StrUpper(match[2]) : match[2]
					value.recipe := RegExReplace(value.recipe, "^\$", LetterVar)
				}


				modifiedRecipe := ""
				recipeModified := false

				for k, char in StrSplit(value.recipe) {
					foundMatch := false

					for diacritic in Library["Diacritic Mark"] {
						if InStr(char, diacritic) {
							modifiedRecipe .= GetChar("dotted_circle") char
							recipeModified := true
							foundMatch := true
							break
						}
					}

					if !foundMatch {
						modifiedRecipe .= char
					}
				}

				if recipeModified {
					value.recipeAlt := modifiedRecipe
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

			if IsObject(characterKeys) {
				for _, key in characterKeys {
					if (keyPressed == key) {
						if InputMode = "HTML" && HasProp(value, "html") {
							SendText(characterEntity)
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
							if CombiningEnabled && HasProp(value, "combiningForm") {
								if IsObject(value.combiningForm) {
									TempValue := ""
									for combining in value.combiningForm {
										TempValue .= PasteUnicode(combining)
									}
									SendText(TempValue)
								} else {
									Send(value.combiningForm)
								}
							}
							else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
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
						SendText(characterEntity)
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
						if CombiningEnabled && HasProp(value, "combiningForm") {
							if IsObject(value.combiningForm) {
								TempValue := ""
								for combining in value.combiningForm {
									TempValue .= PasteUnicode(combining)
								}
								SendText(TempValue)
							} else {
								Send(value.combiningForm)
							}
						}
						else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
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
					return false
			} else {
				if !InStr(str, word)
					return false
			}
		}
		return true
	} else {
		for char in StrSplit(pattern) {
			if !InStr(str, char)
				return false
		}
		return true
	}
}


SearchKey(CycleSend := "") {
	CyclingSearch := False

	if StrLen(CycleSend) > 0 {
		PromptValue := CycleSend
		CyclingSearch := True
	} else {
		PromptValue := IniRead(ConfigFile, "LatestPrompts", "Search", "")


		IB := InputBox(ReadLocale("symbol_search_prompt"), ReadLocale("symbol_search"), "w350 h110", PromptValue)

		if IB.Result = "Cancel"
			return
		else
			PromptValue := IB.Value

		if (PromptValue = "\") {
			Reload
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
				SendValue := CombiningEnabled && HasProp(value, "combiningHTML") ? value.combiningHTML : characterEntity
				OutputValue := SendValue
			} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
				if IsObject(characterLaTeX) {
					if LaTeXMode = "common"
						OutputValue := characterLaTeX[1]
					else if LaTeXMode = "math"
						OutputValue := characterLaTeX[2]
				} else {
					OutputValue := characterLaTeX
				}
			}
			else {
				if CombiningEnabled && HasProp(value, "combiningForm") {
					if IsObject(value.combiningForm) {
						TempValue := ""
						for combining in value.combiningForm {
							TempValue .= PasteUnicode(combining)
						}
						OutputValue := TempValue
					} else {
						OutputValue := Chr("0x" UniTrim(value.combiningForm))
					}
				}
				else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
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
				characterLaTeX := (HasProp(value, "LaTeX")) ? value.LaTeX : ""

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
		MsgBox "Знак не найден."
	}


}

PasteUnicode(Unicode) {
	HexStr := UniTrim(Unicode)
	if HexStr != "" {
		Num := Format("0x" HexStr, "d")
		return Chr(Num)
	}
	return
}

InsertUnicodeKey() {
	PromptValue := IniRead(ConfigFile, "LatestPrompts", "Unicode", "")
	IB := InputBox(ReadLocale("symbol_code_prompt"), ReadLocale("symbol_unicode"), "w256 h92", PromptValue)

	if IB.Result = "Cancel"
		return

	PromptValue := IB.Value
	UnicodeCodes := StrSplit(PromptValue, " ")

	Output := ""
	for code in UnicodeCodes {
		if code
			Output .= Chr("0x" . code)
	}

	Send(Output)
	IniWrite PromptValue, ConfigFile, "LatestPrompts", "Unicode"
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
	LanguageCode := GetLanguageCode()
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

ToggleLetterScript(HideMessage := False) {
	LanguageCode := GetLanguageCode()
	global GlagoFutharkActive, ConfigFile
	GlagoFutharkActive := !GlagoFutharkActive

	ActivationMessage := {}
	ActivationMessage[] := Map()
	ActivationMessage["ru"] := {}
	ActivationMessage["en"] := {}
	ActivationMessage["ru"].Active := "Ввод глаголицы/футарка активирован"
	ActivationMessage["ru"].Deactive := "Ввод глаголицы/футарка деактивирован"
	ActivationMessage["en"].Active := "Glagolitic/Futhark activated"
	ActivationMessage["en"].Deactive := "Glagolitic/Futhark deactivated"
	if !HideMessage {
		MsgBox(GlagoFutharkActive ? ActivationMessage[LanguageCode].Active : ActivationMessage[LanguageCode].Deactive, "Glagolitic/Futhark", 0x40)
	}

	Sleep 25
	RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Glagolitic Futhark"), GlagoFutharkActive)
	if !GlagoFutharkActive {
		Sleep 25
		RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))
	}
	return
}

ChangeScriptInput(ScriptMode) {
	PreviousScriptMode := IniRead(ConfigFile, "Settings", "ScriptInput", "Default")

	if (ScriptMode != "Default" && (ScriptMode = PreviousScriptMode)) {
		IniWrite("Default", ConfigFile, "Settings", "ScriptInput")
		UnregisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Cleanscript"))
	} else {
		IniWrite(ScriptMode, ConfigFile, "Settings", "ScriptInput")
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
	LanguageCode := GetLanguageCode()

	PromptValue := IniRead(ConfigFile, "LatestPrompts", "RomanNumeral", "")

	IB := InputBox(ReadLocale("symbol_roman_numeral_prompt"), ReadLocale("symbol_roman_numeral"), "w256 h92", PromptValue)
	if IB.Result = "Cancel"
		return
	else {
		if (Integer(IB.Value) < 1 || Integer(IB.Value) > 2000000) {
			MsgBox(ReadLocale("warning_roman_2m"), DSLPadTitle, "Icon!")
			return
		}
		PromptValue := ToRomanNumeral(Integer(IB.Value))

		IniWrite IB.Value, ConfigFile, "LatestPrompts", "RomanNumeral"
	}
	SendText(PromptValue)
}
InsertAltCodeKey() {
	PromptValue := IniRead(ConfigFile, "LatestPrompts", "Altcode", "")
	IB := InputBox(ReadLocale("symbol_code_prompt"), ReadLocale("symbol_altcode"), "w256 h92", PromptValue)
	if IB.Result = "Cancel"
		return
	else
		PromptValue := IB.Value

	AltCodes := StrSplit(PromptValue, " ")

	for code in AltCodes {
		if (code ~= "^\d+$") {
			SendAltNumpad(code)
		} else {
			MsgBox(ReadLocale("warning_only_nums"), ReadLocale("symbol_altcode"), 0x30)
			return
		}
	}

	IniWrite PromptValue, ConfigFile, "LatestPrompts", "Altcode"
}
SendAltNumpad(CharacterCode) {
	Send("{Alt Down}")
	Loop Parse, CharacterCode
		Send("{Numpad" A_LoopField "}")
	Send("{Alt Up}")

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


Ligaturise(SmeltingMode := "InputBox") {
	LanguageCode := GetLanguageCode()
	BackupClipboard := ""

	Found := False


	if (SmeltingMode = "InputBox") {
		PromptValue := IniRead(ConfigFile, "LatestPrompts", "Ligature", "")
		IB := InputBox(ReadLocale("symbol_smelting_prompt"), ReadLocale("symbol_smelting"), "w256 h92", PromptValue)
		if IB.Result = "Cancel"
			return
		else
			PromptValue := IB.Value
	} else if (SmeltingMode = "Clipboard" || SmeltingMode = "Backspace") {
		BackupClipboard := A_Clipboard
		A_Clipboard := ""

		if (SmeltingMode = "Backspace") {
			;Send("^+{Left}")
			BufferValue := ""
			Loop 20 {
				Send("^+{Left}")
				Sleep 75
				Send("^c")
				Sleep 75
				ClipWait(0.25, 1)

				if (A_Clipboard = BufferValue) {
					break
				}

				BufferValue := A_Clipboard

				if RegExMatch(A_Clipboard, "(\s|`n|`r|`t)") {
					Send("^+{Right}")
					Send("^c")
					Sleep 75
					if RegExMatch(A_Clipboard, "(\s|`n|`r|`t)") {
						Send("+{Right}")
						Send("^c")
						Sleep 75
					}
					break
				}
			}
			Sleep 120
		}
		Send("^c")
		Sleep 120
		PromptValue := A_Clipboard
		Sleep 50
	} else if (SmeltingMode = "Compose") {
		ShowInfoMessage("message_compose", , , SkipGroupMessage, True)

		ih := InputHook("C")
		ih.MaxLen := 6
		ih.Start()

		Input := ""
		LastInput := ""

		GetUnicodeSymbol := ""
		IsValidateBreak := False
		IsSingleCase := False
		IsCancelledByUser := False
		IsForceWaiting := False

		Loop {
			if GetKeyState("Escape", "P") {
				IsCancelledByUser := True
				break
			}
			if GetKeyState("Pause", "P") {
				if IsForceWaiting == False {
					IsForceWaiting := True
					ShowInfoMessage("message_compose_waiting", , , SkipGroupMessage, True)
				} else {
					IsForceWaiting := False
					LastInput := ""
				}
			}

			if IsForceWaiting == True {
				TempInput := ih.Input
				Sleep 10
				continue
			}

			Input := ih.Input
			if (Input != LastInput) {
				LastInput := Input
				InputValidator := RegExEscape(Input)
				IsValidateBreak := True

				for validatingValue in RecipeValidatorArray {
					if (RegExMatch(validatingValue, "^" . InputValidator)) {
						IsValidateBreak := False
						break
					}
				}

				if IsValidateBreak {
					for validatingValue in RecipeValidatorArray {
						if (RegExMatch(StrLower(validatingValue), "^" . StrLower(InputValidator))) {
							IsSingleCase := True
							IsValidateBreak := False
							break
						}
					}
				}

				for chracterEntry, value in Characters {
					if !HasProp(value, "recipe") || (HasProp(value, "recipe") && value.recipe == "") {
						continue
					} else {
						Recipe := value.recipe

						if IsObject(Recipe) {
							for _, recipeEntry in Recipe {
								if (!IsSingleCase && Input == recipeEntry) ||
									(IsSingleCase && Input = recipeEntry) {
									if InputMode = "HTML" && HasProp(value, "html") {
										GetUnicodeSymbol := value.HasProp("entity") ? value.entity : value.html
									} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
										GetUnicodeSymbol := value.LaTeX
									} else {
										GetUnicodeSymbol := Chr("0x" . UniTrim(value.unicode))
									}
									IniWrite Input, ConfigFile, "LatestPrompts", "Ligature"
									Found := True
									break 3
								}
							}
						} else if (!IsSingleCase && Input == Recipe) ||
							(IsSingleCase && Input = Recipe) {
							if InputMode = "HTML" && HasProp(value, "html") {
								GetUnicodeSymbol := value.HasProp("entity") ? value.entity : value.html
							} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
								GetUnicodeSymbol := value.LaTeX
							} else {
								GetUnicodeSymbol := Chr("0x" . UniTrim(value.unicode))
							}
							IniWrite Input, ConfigFile, "LatestPrompts", "Ligature"
							Found := True
							break 2
						}
					}
				}
			}

			if (StrLen(Input) >= 6 || IsValidateBreak) {
				break
			}

			Sleep 10
		}

		ih.Stop()
		if (!Found && !IsCancelledByUser) {
			if (SmeltingMode = "Compose") {
				ShowInfoMessage("warning_recipe_absent", , , SkipGroupMessage, True)
			} else {
				MsgBox(ReadLocale("warning_recipe_absent"), ReadLocale("symbol_smelting"), 0x30)
			}
		} else {
			SendText(GetUnicodeSymbol)
		}

		return
	}

	OriginalValue := PromptValue
	NewValue := ""

	for chracterEntry, value in Characters {
		if !HasProp(value, "recipe") || (HasProp(value, "recipe") && value.recipe == "") {
			continue
		} else {
			Recipe := value.recipe

			if IsObject(Recipe) {
				for _, recipe in Recipe {
					if (recipe == PromptValue) {
						if InputMode = "HTML" && HasProp(value, "html") {
							value.HasProp("entity") ? SendText(value.entity) : SendText(value.html)
						} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
							SendText(value.LaTeX)
						} else {
							Send(value.unicode)
						}
						IniWrite PromptValue, ConfigFile, "LatestPrompts", "Ligature"
						Found := True
					}
				}
			} else if (Recipe == PromptValue) {
				if InputMode = "HTML" && HasProp(value, "html") {
					value.HasProp("entity") ? SendText(value.entity) : SendText(value.html)
				} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
					SendText(value.LaTeX)
				} else {
					Send(value.unicode)
				}
				IniWrite PromptValue, ConfigFile, "LatestPrompts", "Ligature"
				Found := True
			}
		}
	}

	if (!Found) {
		SplitWords := StrSplit(OriginalValue, " ")

		for i, word in SplitWords {
			TempValue := word
			for chracterEntry, value in Characters {
				if !HasProp(value, "recipe") || (HasProp(value, "recipe") && value.recipe == "") {
					continue
				} else {
					Recipe := value.recipe

					if IsObject(Recipe) {
						for _, recipe in Recipe {
							if InStr(TempValue, recipe, true) {
								TempValue := StrReplace(TempValue, recipe, value.unicode)
							}
						}
					} else {
						if InStr(TempValue, Recipe, true) {
							TempValue := StrReplace(TempValue, Recipe, value.unicode)
						}
					}
				}
			}
			NewValue .= TempValue . (i < SplitWords.Length - 0 ? " " : "")

		}

		NewValue := RTrim(NewValue)

		if (NewValue != OriginalValue) {
			Send(NewValue)
			Found := True
		}
	}


	if !Found {
		if !SmeltingMode = "InputBox" {
			Send("^{Right}")
			Sleep 400
		}
		MsgBox(ReadLocale("warning_recipe_absent"), ReadLocale("symbol_smelting"), 0x30)
	}

	if (SmeltingMode = "Clipboard" || SmeltingMode = "Backspace") {
		A_Clipboard := BackupClipboard
	}
	return
}

GroupActivator(GroupName, KeyValue := "") {
	LocaleMark := KeyValue != "" && RegExMatch(KeyValue, "^F") ? KeyValue : GroupName
	MsgTitle := "[" LocaleMark "] " DSLPadTitle

	ShowInfoMessage("tray_active_" . StrLower(LocaleMark), , MsgTitle, SkipGroupMessage, True)
	InputBridge(GroupName)
}


ReplaceWithUnicode(Mode := "") {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	Sleep 120
	PromptValue := A_Clipboard
	Sleep 50
	PromptValue := GetCharacterUnicode(PromptValue)

	if (PromptValue != "") {
		if Mode == "Hex" {
			SendText("0x" . PromptValue)
		} else {
			SendText(PromptValue)
		}
	}

	A_Clipboard := BackupClipboard
}

GetCharacterUnicode(symbol) {
	return Format("{:04X}", Ord(symbol))
}


RegExEscape(str) {
	static specialChars := "\.*+?^${}()[]|/"

	newStr := ""
	for k, char in StrSplit(str) {
		if InStr(specialChars, char) {
			newStr .= "\" char
		} else {
			newStr .= char
		}
	}
	return newStr
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
FindCharacterPage() {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	Sleep 120
	PromptValue := A_Clipboard
	Sleep 50
	PromptValue := GetCharacterUnicode(PromptValue)

	if (PromptValue != "") {
		Sleep 100
		Run("https://symbl.cc/" . GetLanguageCode() . "/" . PromptValue)
	}

	A_Clipboard := BackupClipboard
}
ToggleGroupMessage() {
	LanguageCode := GetLanguageCode()
	global SkipGroupMessage, ConfigFile
	SkipGroupMessage := !SkipGroupMessage
	IniWrite (SkipGroupMessage ? "True" : "False"), ConfigFile, "Settings", "SkipGroupMessage"

	ActivationMessage := {}
	ActivationMessage[] := Map()
	ActivationMessage["ru"] := {}
	ActivationMessage["en"] := {}
	ActivationMessage["ru"].Active := "Сообщения активации групп включены"
	ActivationMessage["ru"].Deactive := "Сообщения активации групп отключены"
	ActivationMessage["en"].Active := "Activation messages for groups enabled"
	ActivationMessage["en"].Deactive := "Activation messages for groups disabled"
	MsgBox(SkipGroupMessage ? ActivationMessage[LanguageCode].Deactive : ActivationMessage[LanguageCode].Active, DSLPadTitle, 0x40)

	return
}

LocaliseArrayKeys(ObjectPath) {
	for index, item in ObjectPath {
		if IsObject(item[1]) {
			item[1] := item[1][GetLanguageCode()]
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

	ManageTrayItems()
}
Constructor() {
	CheckUpdate()
	ManageTrayItems()

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

	DSLTabs := []
	DSLCols := { default: [], smelting: [] }

	for _, localeKey in ["diacritics", "spaces", "smelting", "fastkeys", "scripts", "commands", "about", "useful", "changelog"] {
		DSLTabs.Push(ReadLocale("tab_" . localeKey))
	}

	for _, localeKey in ["name", "key", "view", "unicode", "entryid"] {
		DSLCols.default.Push(ReadLocale("col_" . localeKey))
	}

	for _, localeKey in ["name", "recipe", "result", "unicode", "entryid"] {
		DSLCols.smelting.Push(ReadLocale("col_" . localeKey))
	}

	DSLContent := {}
	DSLContent[] := Map()
	DSLContent["BindList"] := {}
	DSLContent["ru"] := {}
	DSLContent["en"] := {}

	CommonInfoBox := {
		body: "x650 y35 w200 h510",
		bodyText: ReadLocale("character"),
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
	}

	CommonFilter := {
		icon: "x21 y520 h24 w24",
		field: "x49 y520 w593 h24 v",
	}

	LanguageCode := GetLanguageCode()

	DSLPadGUI := Gui()

	ColumnWidths := [300, 150, 60, 85, 0]
	ColumnAreaWidth := "w620"
	ColumnAreaHeight := "h480"
	ColumnAreaRules := "+NoSort -Multi"
	ColumnListStyle := ColumnAreaWidth . " " . ColumnAreaHeight . " " . ColumnAreaRules

	Tab := DSLPadGUI.Add("Tab3", "w" windowWidth " h" windowHeight, DSLTabs)
	DSLPadGUI.SetFont("s11")
	Tab.UseTab(1)

	DiacriticLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	DiacriticLV.ModifyCol(1, ColumnWidths[1])
	DiacriticLV.ModifyCol(2, ColumnWidths[2])
	DiacriticLV.ModifyCol(3, ColumnWidths[3])
	DiacriticLV.ModifyCol(4, ColumnWidths[4])
	DiacriticLV.ModifyCol(5, ColumnWidths[5])


	DSLContent["BindList"].TabDiacritics := []

	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Primary", Window LeftAlt " F1", False)
	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Secondary", Window LeftAlt " F2")
	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Tertiary", Window LeftAlt " F3")
	InsertCharactersGroups(DSLContent["BindList"].TabDiacritics, "Diacritics Quatemary", Window LeftAlt " F6")

	for item in DSLContent["BindList"].TabDiacritics
	{
		DiacriticLV.Add(, item[1], item[2], item[3], item[4], item[5])
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
	}

	GroupBoxDiacritic.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxDiacritic.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxDiacritic.LaTeX.SetFont("s12")
	GroupBoxDiacritic.alt.SetFont("s12")
	GroupBoxDiacritic.unicode.SetFont("s12")
	GroupBoxDiacritic.html.SetFont("s12")
	GroupBoxDiacritic.tags.SetFont("s9")


	Tab.UseTab(2)

	DSLContent["BindList"].TabSpaces := []
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Spaces", Window LeftAlt " Space", False)
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Dashes", Window LeftAlt " -")
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Quotes", Window LeftAlt QuotationDouble)
	InsertCharactersGroups(DSLContent["BindList"].TabSpaces, "Special Characters", Window LeftAlt " F7")

	SpacesLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	SpacesLV.ModifyCol(1, ColumnWidths[1])
	SpacesLV.ModifyCol(2, ColumnWidths[2])
	SpacesLV.ModifyCol(3, ColumnWidths[3])
	SpacesLV.ModifyCol(4, ColumnWidths[4])
	SpacesLV.ModifyCol(5, ColumnWidths[5])

	for item in DSLContent["BindList"].TabSpaces
	{
		SpacesLV.Add(, item[1], item[2], item[3], item[4], item[5])
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
	}

	GroupBoxSpaces.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxSpaces.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxSpaces.LaTeX.SetFont("s12")
	GroupBoxSpaces.alt.SetFont("s12")
	GroupBoxSpaces.unicode.SetFont("s12")
	GroupBoxSpaces.html.SetFont("s12")
	GroupBoxSpaces.tags.SetFont("s9")

	Tab.UseTab(6)
	CommandsTree := DSLPadGUI.AddTreeView("x25 y43 w256 h510 -HScroll")

	CommandsTree.OnEvent("ItemSelect", (TV, Item) => TV_InsertCommandsDesc(TV, Item, GroupBoxCommands.text))

	CommandsInfoBox := {
		body: "x300 y35 w540 h450",
		bodyText: Map("ru", "Команда", "en", "Command"),
		text: "vCommandDescription x310 y65 w520 h400",
	}

	GroupBoxCommands := {
		group: DSLPadGUI.Add("GroupBox", CommandsInfoBox.body, CommandsInfoBox.bodyText[LanguageCode]),
		text: DSLPadGUI.Add("Link", CommandsInfoBox.text),
	}

	Command_controls := CommandsTree.Add(ReadLocale("func_label_controls"))
	Command_disable := CommandsTree.Add(ReadLocale("func_label_disable"))
	Command_gotopage := CommandsTree.Add(ReadLocale("func_label_gotopage"))
	Command_selgoto := CommandsTree.Add(ReadLocale("func_label_selgoto"))
	Command_copylist := CommandsTree.Add(ReadLocale("func_label_copylist"))
	Command_tagsearch := CommandsTree.Add(ReadLocale("func_label_tagsearch"))
	Command_uninsert := CommandsTree.Add(ReadLocale("func_label_uninsert"))
	Command_altcode := CommandsTree.Add(ReadLocale("func_label_altcode"))
	Command_smelter := CommandsTree.Add(ReadLocale("func_label_smelter"), , "Expand")
	Command_smelter_sel := CommandsTree.Add(ReadLocale("func_label_smelter_sel"), Command_Smelter)
	Command_smelter_carr := CommandsTree.Add(ReadLocale("func_label_smelter_carr"), Command_Smelter)
	Command_compose := CommandsTree.Add(ReadLocale("func_label_compose"), Command_smelter)
	Command_num_superscript := CommandsTree.Add(ReadLocale("func_label_num_superscript"))
	Command_num_roman := CommandsTree.Add(ReadLocale("func_label_num_roman"))
	Command_fastkeys := CommandsTree.Add(ReadLocale("func_label_fastkeys"))
	Command_combining := CommandsTree.Add(ReadLocale("func_label_combining"))
	Command_extralayouts := CommandsTree.Add(ReadLocale("func_label_extralayouts"))
	Command_glagokeys := CommandsTree.Add(ReadLocale("func_label_glagokeys"), Command_extralayouts)
	Command_oldturkic := CommandsTree.Add(ReadLocale("func_label_oldturkic"), Command_extralayouts)
	Command_oldhungary := CommandsTree.Add(ReadLocale("func_label_oldhungary"), Command_extralayouts)
	Command_func_label_ipa := CommandsTree.Add(ReadLocale("func_label_ipa"), Command_extralayouts)
	Command_inputtoggle := CommandsTree.Add(ReadLocale("func_label_inputtoggle"))
	Command_layouttoggle := CommandsTree.Add(ReadLocale("func_label_layouttoggle"))
	Command_notifs := CommandsTree.Add(ReadLocale("func_label_notifs"))
	Command_textprocessing := CommandsTree.Add(ReadLocale("func_label_textprocessing"))
	Command_tp_paragraph := CommandsTree.Add(ReadLocale("func_label_tp_paragraph"), Command_textprocessing)
	Command_tp_grep := CommandsTree.Add(ReadLocale("func_label_tp_grep"), Command_textprocessing)
	Command_tp_quotes := CommandsTree.Add(ReadLocale("func_label_tp_quotes"), Command_textprocessing)
	Command_lcoverage := CommandsTree.Add(ReadLocale("func_label_coverage"))
	Command_lro := CommandsTree.Add(ReadLocale("func_label_coverage_ro"), Command_lcoverage)


	DSLContent["ru"].AutoLoadAdd := "Добавить в автозагрузку"
	DSLContent["en"].AutoLoadAdd := "Add to Autoload"
	DSLContent["ru"].GetUpdate := "Обновить"
	DSLContent["en"].GetUpdate := "Get Update"
	DSLContent["ru"].UpdateAvailable := "Доступно обновление: версия " . UpdateVersionString
	DSLContent["en"].UpdateAvailable := "Update available: version " . UpdateVersionString

	DSLPadGUI.SetFont("s9")

	BtnAutoLoad := DSLPadGUI.Add("Button", "x577 y527 w200 h32", DSLContent[LanguageCode].AutoLoadAdd)
	BtnAutoLoad.OnEvent("Click", AddScriptToAutoload)

	BtnSwitchRU := DSLPadGUI.Add("Button", "x300 y527 w32 h32", "РУ")
	BtnSwitchRU.OnEvent("Click", (*) => SwitchLanguage("ru"))

	BtnSwitchEN := DSLPadGUI.Add("Button", "x332 y527 w32 h32", "EN")
	BtnSwitchEN.OnEvent("Click", (*) => SwitchLanguage("en"))

	UpdateBtn := DSLPadGUI.Add("Button", "x809 y495 w32 h32")
	UpdateBtn.OnEvent("Click", (*) => GetUpdate())
	GuiButtonIcon(UpdateBtn, ImageRes, 176, "w24 h24")

	RepairBtn := DSLPadGUI.Add("Button", "x777 y495 w32 h32", "🛠️")
	RepairBtn.SetFont("s16")
	RepairBtn.OnEvent("Click", (*) => GetUpdate(0, True))

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
			DSLContent[LanguageCode].UpdateAvailable . ' (<a href="' . RepoSource . '">GitHub</a>)'
		DSLPadGUI["NewVersionIcon"].Text := InformationSymbol
	}

	LatinLayoutSelector := DSLPadGUI.AddDropDownList("vLatLayout w74 x502 y528", GetLayoutsList)
	PostMessage(0x0153, -1, 24, LatinLayoutSelector)

	LatinLayoutName := IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")
	LatinLayoutSelector.Text := LatinLayoutName
	LatinLayoutSelector.OnEvent("Change", (CB, Zero) => ChangeQWERTY(CB))

	CyrillicLayoutSelector := DSLPadGUI.AddDropDownList("vCyrLayout w74 x426 y528", CyrillicLayoutsList)
	PostMessage(0x0153, -1, 24, CyrillicLayoutSelector)

	CyrillicLayoutName := IniRead(ConfigFile, "Settings", "CyrillicLayout", "QWERTY")
	CyrillicLayoutSelector.Text := CyrillicLayoutName
	CyrillicLayoutSelector.OnEvent("Change", (CB, Zero) => ChangeQWERTY(CB))

	DSLPadGUI.SetFont("s11")


	Tab.UseTab(3)


	DSLContent["BindList"].TabSmelter := []

	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Ligatures", , False, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Digraphs", , False, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Extended", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Accented", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Cyrillic Ligatures & Letters", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Cyrillic Letters", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Futhork Runes", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Glagolitic Letters", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Smelting Special", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Wallet Signs", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Other Signs", , True, , True)


	LigaturesLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.smelting)
	LigaturesLV.ModifyCol(1, ColumnWidths[1])
	LigaturesLV.ModifyCol(2, 110)
	LigaturesLV.ModifyCol(3, 100)
	LigaturesLV.ModifyCol(4, ColumnWidths[4])
	LigaturesLV.ModifyCol(5, ColumnWidths[5])

	for item in DSLContent["BindList"].TabSmelter
	{
		LigaturesLV.Add(, item[1], item[2], item[3], item[4], item[5])
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
	}

	GroupBoxLigatures.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxLigatures.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxLigatures.LaTeX.SetFont("s12")
	GroupBoxLigatures.alt.SetFont("s12")
	GroupBoxLigatures.unicode.SetFont("s12")
	GroupBoxLigatures.html.SetFont("s12")
	GroupBoxLigatures.tags.SetFont("s9")


	Tab.UseTab(4)

	DSLContent["BindList"].TabFastKeys := []

	for groupName in [
		"Diacritics Fast Primary",
		"Special Fast Primary",
		"Special Fast Left",
		"Latin Accented Primary",
		"Diacritics Fast Secondary",
		"Special Fast Secondary",
		"Asian Quotes",
		"Other Signs",
		"Spaces",
		"Misc",
		"Latin Extended",
		"Latin Ligatures",
		"Latin Accented Secondary",
		"Cyrillic Ligatures & Letters",
		"Cyrillic Letters",
		"Special Fast",
	] {
		AddSeparator := (groupName = "Diacritics Fast Primary" || groupName = "Latin Ligatures") ? False : True
		GroupHotKey := (groupName = "Diacritics Fast Primary") ? LeftControl LeftAlt
			: (groupName = "Special Fast Left") ? LeftAlt
				: (groupName = "Diacritics Fast Secondary") ? RightAlt
					: (groupName = "Special Fast") ? ReadLocale("symbol_special_key")
						: ""

		FastSpecial := groupName = "Special Fast" ? True : False

		InsertCharactersGroups(DSLContent["BindList"].TabFastKeys, groupName, GroupHotKey, AddSeparator, True, , , FastSpecial)
	}


	FastKeysLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	FastKeysLV.ModifyCol(1, ColumnWidths[1])
	FastKeysLV.ModifyCol(2, ColumnWidths[2])
	FastKeysLV.ModifyCol(3, ColumnWidths[3])
	FastKeysLV.ModifyCol(4, ColumnWidths[4])
	FastKeysLV.ModifyCol(5, ColumnWidths[5])

	for item in DSLContent["BindList"].TabFastKeys
	{
		FastKeysLV.Add(, item[1], item[2], item[3], item[4], item[5])
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
	}

	GroupBoxFastKeys.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxFastKeys.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxFastKeys.LaTeX.SetFont("s12")
	GroupBoxFastKeys.alt.SetFont("s12")
	GroupBoxFastKeys.unicode.SetFont("s12")
	GroupBoxFastKeys.html.SetFont("s12")
	GroupBoxFastKeys.tags.SetFont("s9")

	Tab.UseTab(5)

	DSLContent["BindList"].TabGlagoKeys := []

	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Fake", RightControl " 1", False)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Futhark Runes", ReadLocale("symbol_futhark"), False, , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Futhork Runes", ReadLocale("symbol_futhork"), , , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Younger Futhark Runes", ReadLocale("symbol_futhark_younger"), , , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Almanac Runes", ReadLocale("symbol_futhark_almanac"), , , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Later Younger Futhark Runes", ReadLocale("symbol_futhark_younger_later"), , , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Medieval Runes", ReadLocale("symbol_medieval_runes"), , , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Runic Punctuation", ReadLocale("symbol_runic_punctuation"), , , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Glagolitic Letters", ReadLocale("symbol_glagolitic"), , , , , , True)
	InsertCharactersGroups(DSLContent["BindList"].TabGlagoKeys, "Cyrillic Diacritics", , , , , , , True)

	GlagoLV := DSLPadGUI.Add("ListView", ColumnListStyle, DSLCols.default)
	GlagoLV.ModifyCol(1, ColumnWidths[1])
	GlagoLV.ModifyCol(2, ColumnWidths[2])
	GlagoLV.ModifyCol(3, ColumnWidths[3])
	GlagoLV.ModifyCol(4, ColumnWidths[4])
	GlagoLV.ModifyCol(5, ColumnWidths[5])

	for item in DSLContent["BindList"].TabGlagoKeys
	{
		GlagoLV.Add(, item[1], item[2], item[3], item[4], item[5])
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
	}

	GroupBoxGlagoKeys.preview.SetFont(CommonInfoFonts.previewSize, FontFace["serif"].name)
	GroupBoxGlagoKeys.title.SetFont(CommonInfoFonts.titleSize, FontFace["serif"].name)
	GroupBoxGlagoKeys.LaTeX.SetFont("s12")
	GroupBoxGlagoKeys.alt.SetFont("s12")
	GroupBoxGlagoKeys.unicode.SetFont("s12")
	GroupBoxGlagoKeys.html.SetFont("s12")
	GroupBoxGlagoKeys.tags.SetFont("s9")


	Tab.UseTab(7)

	AboutLeftBox := DSLPadGUI.Add("GroupBox", "x23 y34 w280 h520",)
	DSLPadGUI.Add("GroupBox", "x75 y65 w170 h170")
	DSLPadGUI.Add("Picture", "x98 y89 w128 h128", AppIcoFile)

	AboutTitle := DSLPadGUI.Add("Text", "x75 y245 w170 h32 Center BackgroundTrans", DSLPadTitleDefault)
	AboutTitle.SetFont("s20 c333333", "Cambria")

	AboutVersion := DSLPadGUI.Add("Text", "x75 y285 w170 h32 Center BackgroundTrans", CurrentVersionString)
	AboutVersion.SetFont("s12 c333333", "Cambria")

	AboutRepoLinkX := LanguageCode == "ru" ? "x114" : "x123"
	AboutRepoLink := DSLPadGUI.Add("Link", AboutRepoLinkX " y320 w150 h20 Center",
		'<a href="https://github.com/DemerNkardaz/Misc-Scripts/tree/main/AutoHotkey2.0/">' ReadLocale("about_repository") '</a>'
	)
	AboutRepoLink.SetFont("s12", "Cambria")

	AboutAuthor := DSLPadGUI.Add("Text", "x75 y495 w170 h16 Center BackgroundTrans", ReadLocale("about_author"))
	AboutAuthor.SetFont("s11 c333333", "Cambria")

	AboutAuthorLinks := DSLPadGUI.Add("Link", "x90 y525 w150 h16 Center",
		'<a href="https://github.com/DemerNkardaz/">GitHub</a> '
		'<a href="http://steamcommunity.com/profiles/76561198177249942">STEAM</a> '
		'<a href="https://ficbook.net/authors/4241255">Фикбук</a>'
	)
	AboutAuthorLinks.SetFont("s9", "Cambria")

	AboutDescBox := DSLPadGUI.Add("GroupBox", "x315 y34 w530 h520", ReadLocale("about_item_count") . " — " . DSLPadTitleFull)
	AboutDescBox.SetFont("s11", "Cambria")

	AboutDescription := DSLPadGUI.Add("Text", "x330 y70 w505 h495 Wrap BackgroundTrans", ReadLocale("about_description"))
	AboutDescription.SetFont("s12 c333333", "Cambria")


	Tab.UseTab(8)
	DSLContent["ru"].Useful := {}
	DSLContent["ru"].Useful.Typography := "Типографика"
	DSLContent["ru"].Useful.TypographyLayout := '<a href="https://ilyabirman.ru/typography-layout/">«Типографская раскладка»</a>'
	DSLContent["ru"].Useful.Unicode := "Unicode-ресурсы"
	DSLContent["ru"].Useful.Dictionaries := "Словари"
	DSLContent["ru"].Useful.JPnese := "Японский: "
	DSLContent["ru"].Useful.CHnese := "Китайский: "
	DSLContent["ru"].Useful.VTnese := "Вьетнамский: "


	DSLContent["en"].Useful := {}
	DSLContent["en"].Useful.Typography := "Typography"
	DSLContent["en"].Useful.TypographyLayout := '<a href="https://ilyabirman.net/typography-layout/">“Typography Layout”</a>'
	DSLContent["en"].Useful.Unicode := "Unicode-Resources"
	DSLContent["en"].Useful.Dictionaries := "Dictionaries"
	DSLContent["en"].Useful.JPnese := "Japanese: "
	DSLContent["en"].Useful.CHnese := "Chinese: "
	DSLContent["en"].Useful.VTnese := "Vietnamese: "

	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , DSLContent[LanguageCode].Useful.Typography)
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", DSLContent[LanguageCode].Useful.TypographyLayout)
	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , DSLContent[LanguageCode].Useful.Unicode)
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", '<a href="https://symbl.cc/">Symbl.cc</a> <a href="https://www.compart.com/en/unicode/">Compart</a>')
	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , DSLContent[LanguageCode].Useful.Dictionaries)
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", DSLContent[LanguageCode].Useful.JPnese . '<a href="https://yarxi.ru">ЯРКСИ</a> <a href="https://www.warodai.ruu">Warodai</a>')
	DSLPadGUI.Add("Link", "w600", DSLContent[LanguageCode].Useful.CHnese . '<a href="https://bkrs.info">БКРС</a>')
	DSLPadGUI.Add("Link", "w600", DSLContent[LanguageCode].Useful.VTnese . '<a href="https://chunom.org">Chữ Nôm</a>')

	Tab.UseTab(9)
	DSLPadGUI.Add("GroupBox", "w825 h520", "🌐 " . ReadLocale("tab_changelog"))
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
			GroupBoxDiacritic]
		))
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
			GroupBoxSpaces]
		))
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
			GroupBoxFastKeys]
		))
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
			GroupBoxGlagoKeys]
		))
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
			GroupBoxLigatures]
		))


	RandPreview := Map(
		"Diacritics", GetRandomByGroups(["Diacritics Primary", "Diacritics Secondary", "Diacritics Tertiary"]),
		"Spaces", GetRandomByGroups(["Spaces", "Dashes", "Quotes", "Special Characters"]),
		"Ligatures", GetRandomByGroups(["Latin Ligatures", "Cyrillic Ligatures & Letters", "Latin Accented", "Dashes", "Asian Quotes", "Quotes"]),
		"FastKeys", GetRandomByGroups(["Diacritics Fast Primary", "Special Fast Primary", "Special Fast Left", "Latin Accented Primary", "Latin Accented Secondary", "Diacritics Fast Secondary", "Asian Quotes"]),
		"GlagoKeys", GetRandomByGroups(["Futhark Runes", "Glagolitic Letters"]),
	)

	SetCharacterInfoPanel(RandPreview["Diacritics"][1], RandPreview["Diacritics"][3], DSLPadGUI, "DiacriticSymbol", "DiacriticTitle", "DiacriticLaTeX", "DiacriticLaTeXPackage", "DiacriticAlt", "DiacriticUnicode", "DiacriticHTML", "DiacriticTags", "DiacriticGroup", GroupBoxDiacritic)
	SetCharacterInfoPanel(RandPreview["Spaces"][1], RandPreview["Spaces"][3], DSLPadGUI, "SpacesSymbol", "SpacesTitle", "SpacesLaTeX", "SpacesLaTeXPackage", "SpacesAlt", "SpacesUnicode", "SpacesHTML", "SpacesTags", "SpacesGroup", GroupBoxSpaces)
	SetCharacterInfoPanel(RandPreview["FastKeys"][1], RandPreview["FastKeys"][3], DSLPadGUI, "FastKeysSymbol", "FastKeysTitle", "FastKeysLaTeX", "FastKeysLaTeXPackage", "FastKeysAlt", "FastKeysUnicode", "FastKeysHTML", "FastKeysTags", "FastKeysGroup", GroupBoxFastKeys)
	SetCharacterInfoPanel(RandPreview["Ligatures"][1], RandPreview["Ligatures"][3], DSLPadGUI, "LigaturesSymbol", "LigaturesTitle", "LigaturesLaTeX", "LigaturesLaTeXPackage", "LigaturesAlt", "LigaturesUnicode", "LigaturesHTML", "LigaturesTags", "LigaturesGroup", GroupBoxLigatures)
	SetCharacterInfoPanel(RandPreview["GlagoKeys"][1], RandPreview["GlagoKeys"][3], DSLPadGUI, "GlagoKeysSymbol", "GlagoKeysTitle", "GlagoKeysLaTeX", "GlagoKeysLaTeXPackage", "GlagoKeysAlt", "GlagoKeysUnicode", "GlagoKeysHTML", "GlagoKeysTags", "GlagoKeysGroup", GroupBoxGlagoKeys)

	DSLPadGUI.Title := DSLPadTitle

	DSLPadGUI.Show("x" xPos " y" yPos)

	return DSLPadGUI
}
PopulateListView(LV, DataList) {
	LV.Delete()
	for item in DataList {
		LV.Add(, item[1], item[2], item[3], item[4], item[5])
	}
}
FilterListView(GuiFrame, FilterField, LV, DataList) {
	FilterText := StrLower(GuiFrame[FilterField].Text)
	LV.Delete()

	if FilterText = ""
		PopulateListView(LV, DataList)
	else {
		GroupStarted := false
		PreviousGroupName := ""
		for item in DataList {
			if StrLower(item[1]) = "" {
				LV.Add(, item[1], item[2], item[3], item[4], item[5])
				GroupStarted := true
			} else if InStr(StrLower(item[1]), FilterText) {
				if !GroupStarted {
					GroupStarted := true
				}
				LV.Add(, item[1], item[2], item[3], item[4], item[5])
			} else if GroupStarted {
				GroupStarted := false
			}

			if StrLower(item[1]) != "" and StrLower(item[1]) != PreviousGroupName {
				PreviousGroupName := StrLower(item[1])
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


SetCharacterInfoPanel(EntryIDKey, UnicodeKey, TargetGroup, PreviewObject, PreviewTitle, PreviewLaTeX, PreviewLaTeXPackage, PreviewAlt, PreviewUnicode, PreviewHTML, PreviewTags, PreviewGroupTitle, PreviewGroup) {
	LanguageCode := GetLanguageCode()

	if (UnicodeKey != "") {
		for characterEntry, value in Characters {
			entryID := ""
			entryName := ""
			if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
				entryID := match[1]
				entryName := match[2]
			}
			characterTitle := ""
			if (HasProp(value, "titles") &&
				(!HasProp(value, "titlesAlt") || HasProp(value, "titlesAlt") && value.titlesAlt == True)) {
				characterTitle := value.titles[LanguageCode]
			} else if (HasProp(value, "titlesAlt") && value.titlesAlt == True) {
				characterTitle := ReadLocale(entryName . "_alt", "chars")
			} else {
				characterTitle := ReadLocale(entryName, "chars")
			}


			if entryID == EntryIDKey && ((UnicodeKey == UniTrim(value.unicode)) || (UnicodeKey == value.unicode)) {
				if (HasProp(value, "symbol")) {
					if (HasProp(value, "symbolAlt")) {
						TargetGroup[PreviewObject].Text := value.symbolAlt
					} else if (StrLen(value.symbol) > 3) {
						TargetGroup[PreviewObject].Text := SubStr(value.symbol, 1, 1)
					} else {
						TargetGroup[PreviewObject].Text := value.symbol
					}
				}


				if (HasProp(value, "symbolFont")) {
					PreviewGroup.preview.SetFont(, value.symbolFont)
				} else {
					PreviewGroup.preview.SetFont(, FontFace["serif"].name)
				}

				if HasProp(value, "symbolCustom") {
					PreviewGroup.preview.SetFont(
						CommonInfoFonts.previewSize . " norm cDefault"
					)
					TargetGroup[PreviewObject].SetFont(
						value.symbolCustom
					)
				} else if (StrLen(TargetGroup[PreviewObject].Text) > 2) {
					PreviewGroup.preview.SetFont(
						CommonInfoFonts.previewSmaller . " norm cDefault"
					)
				} else {
					PreviewGroup.preview.SetFont(
						CommonInfoFonts.previewSize . " norm cDefault"
					)
				}

				TargetGroup[PreviewTitle].Text := characterTitle

				if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
					TempValue := ""
					TotalIndex := 0
					for index in value.uniSequence {
						TotalIndex++
					}
					CurrentIndex := 0
					for unicode in value.uniSequence {
						CurrentIndex++
						TempValue .= SubStr(unicode, 2, StrLen(unicode) - 2)
						TempValue .= CurrentIndex < TotalIndex ? " " : ""
					}
					TargetGroup[PreviewUnicode].Text := TempValue
				} else {
					TargetGroup[PreviewUnicode].Text := SubStr(value.unicode, 2, StrLen(value.unicode) - 2)
				}

				if (StrLen(TargetGroup[PreviewUnicode].Text) > 9
					&& StrLen(TargetGroup[PreviewUnicode].Text) < 15) {
					PreviewGroup.unicode.SetFont("s10")
				} else if (StrLen(TargetGroup[PreviewUnicode].Text) > 14) {
					PreviewGroup.unicode.SetFont("s9")
				} else {
					PreviewGroup.unicode.SetFont("s12")
				}


				if (HasProp(value, "entity")) {
					TargetGroup[PreviewHTML].Text := value.html . " " . value.entity
				} else {
					TargetGroup[PreviewHTML].Text := value.html
				}

				if (StrLen(TargetGroup[PreviewHTML].Text) > 9
					&& StrLen(TargetGroup[PreviewHTML].Text) < 15) {
					PreviewGroup.html.SetFont("s10")
				} else if (StrLen(TargetGroup[PreviewHTML].Text) > 14) {
					PreviewGroup.html.SetFont("s9")
				} else {
					PreviewGroup.html.SetFont("s12")
				}


				EntryString := ReadLocale("entry") . ": " . entryName
				TagsString := ""
				if (HasProp(value, "tags")) {
					TagsString := ReadLocale("tags") . ": "

					totalCount := 0
					for index in value.tags {
						totalCount++
					}

					currentIndex := 0
					for index, tag in value.tags {
						TagsString .= tag
						currentIndex++
						if (currentIndex < totalCount) {
							TagsString .= ", "
						}
					}

				}
				TargetGroup[PreviewTags].Text := EntryString . GetChar("ensp") . TagsString

				if (HasProp(value, "combiningForm")) {
					TargetGroup[PreviewGroupTitle].Text := ReadLocale("character_have_combining")
				} else if RegExMatch(value.symbol, "^" DottedCircle "\S") {
					TargetGroup[PreviewGroupTitle].Text := ReadLocale("character_combining")
				} else {
					TargetGroup[PreviewGroupTitle].Text := ReadLocale("character")
				}

				if (HasProp(value, "altcode")) {
					TargetGroup[PreviewAlt].Text := value.altcode
				} else {
					TargetGroup[PreviewAlt].Text := "N/A"
				}

				if (HasProp(value, "LaTeXPackage")) {
					TargetGroup[PreviewLaTeXPackage].Text := "📦 " . value.LaTeXPackage
				} else {
					TargetGroup[PreviewLaTeXPackage].Text := ""
				}

				if (HasProp(value, "LaTeX")) {
					if IsObject(value.LaTeX) {
						LaTeXString := ""
						totalCount := 0
						for index in value.LaTeX {
							totalCount++
						}
						currentIndex := 0
						for index, latex in value.LaTeX {
							LaTeXString .= latex
							currentIndex++
							if (currentIndex < totalCount) {
								LaTeXString .= " "
							}
						}
						TargetGroup[PreviewLaTeX].Text := LaTeXString

					} else {
						TargetGroup[PreviewLaTeX].Text := value.LaTeX
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
			}
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
		"func_label_copylist",
		"func_label_tagsearch",
		"func_label_uninsert",
		"func_label_altcode",
		"func_label_smelter",
		"func_label_smelter_sel",
		"func_label_smelter_carr",
		"func_label_compose",
		"func_label_num_superscript",
		"func_label_num_roman",
		"func_label_fastkeys",
		"func_label_combining",
		"func_label_extralayouts",
		"func_label_glagokeys",
		"func_label_oldturkic",
		"func_label_oldhungary",
		"func_label_ipa",
		"func_label_inputtoggle",
		"func_label_layouttoggle",
		"func_label_notifs",
		"func_label_textprocessing",
		"func_label_tp_quotes",
		"func_label_tp_paragraph",
		"func_label_tp_grep",
		"func_label_coverage",
		"func_label_coverage_ro",
	]
	SelectedLabel := TV.GetText(Item)

	for label in LabelValidator
	{
		if (ReadLocale(label) = SelectedLabel)
			TargetTextBox.Text := ReadLocale(label . "_description")
	}

}
LV_CharacterDetails(LV, RowNumber, SetupArray) {
	UnicodeKey := LV.GetText(RowNumber, 4)
	EntryIDKey := LV.GetText(RowNumber, 5)
	SetCharacterInfoPanel(EntryIDKey, UnicodeKey,
		SetupArray[1], SetupArray[2], SetupArray[3],
		SetupArray[4], SetupArray[5], SetupArray[6],
		SetupArray[7], SetupArray[8], SetupArray[9],
		SetupArray[10], SetupArray[11])
}
LV_OpenUnicodeWebsite(LV, RowNumber) {
	LanguageCode := GetLanguageCode()
	SelectedRow := LV.GetText(RowNumber, 4)
	URIComponent := "https://symbl.cc/" . LanguageCode . "/" . SelectedRow
	if (SelectedRow != "") {
		IsCtrlDown := GetKeyState("LControl")
		if (IsCtrlDown) {
			if (InputMode = "HTML" || InputMode = "LaTeX") {
				for characterEntry, value in Characters {
					if (SelectedRow = UniTrim(value.unicode)) {
						if InputMode = "HTML" && HasProp(value, "html") {
							A_Clipboard := HasProp(value, "entity") ? value.entity : value.html
						} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
							if IsObject(value.LaTeX) {
								if LaTeXMode = "common"
									A_Clipboard := value.LaTeX[1]
								else if LaTeXMode = "math"
									A_Clipboard := value.LaTeX[2]
							} else {
								A_Clipboard := value.LaTeX
							}
						}
					}
				}
			} else {
				UnicodeCodePoint := "0x" . SelectedRow
				A_Clipboard := Chr(UnicodeCodePoint)
			}


			SoundPlay("C:\Windows\Media\Speech On.wav")
		}
		else {
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
	global DSLPadTitleDefault, AppIcoFile
	LanguageCode := GetLanguageCode()
	Labels := {}
	Labels[] := Map()
	Labels["ru"] := {}
	Labels["en"] := {}
	Labels["ru"].Success := "Ярлык для автозагрузки создан или обновлен."
	Labels["en"].Success := "Shortcut for autoloading created or updated."
	CurrentScriptPath := A_ScriptFullPath
	AutoloadFolder := A_StartMenu "\Programs\Startup"
	ShortcutPath := AutoloadFolder "\DSLKeyPad.lnk"

	if (FileExist(ShortcutPath)) {
		FileDelete(ShortcutPath)
	}

	Command := "powershell -command " "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut('" ShortcutPath "'); $shortcut.TargetPath = '" CurrentScriptPath "'; $shortcut.WorkingDirectory = '" A_ScriptDir "'; $shortcut.IconLocation = '" AppIcoFile "'; $shortcut.Description = 'DSLKeyPad AutoHotkey Script'; $shortcut.Save()" ""
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
	return LayoutsPresets.Has(IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН")) ? IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН") : "ЙЦУКЕН"
}

ToggleFastKeys() {
	LanguageCode := GetLanguageCode()
	global FastKeysIsActive, ConfigFile
	FastKeysIsActive := !FastKeysIsActive
	IniWrite (FastKeysIsActive ? "True" : "False"), ConfigFile, "Settings", "FastKeysIsActive"

	ActivationMessage := {}
	ActivationMessage[] := Map()
	ActivationMessage["ru"] := {}
	ActivationMessage["en"] := {}
	ActivationMessage["ru"].Active := "Быстрые ключи активированы"
	ActivationMessage["ru"].Deactive := "Быстрые ключи деактивированы"
	ActivationMessage["en"].Active := "Fast keys activated"
	ActivationMessage["en"].Deactive := "Fast keys deactivated"
	MsgBox(FastKeysIsActive ? ActivationMessage[LanguageCode].Active : ActivationMessage[LanguageCode].Deactive, "FastKeys", 0x40)

	Sleep 25
	RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))
	return
}

ToggleInputMode() {
	LanguageCode := GetLanguageCode()

	ActivationMessage := {}
	ActivationMessage[] := Map()
	ActivationMessage["ru"] := {}
	ActivationMessage["en"] := {}

	InputModeLabel := Map(
		"Default", Map("ru", "символов юникода", "en", "unicode symbols"),
		"HTML", Map("ru", "HTML-кодов", "en", "HTML codes"),
		"LaTeX", Map("ru", "LaTeX-кодов", "en", "LaTeX codes")
	)

	global InputMode, ConfigFile

	if (InputMode = "Default") {
		InputMode := "HTML"
	} else if (InputMode = "HTML") {
		InputMode := "LaTeX"
	} else if (InputMode = "LaTeX") {
		InputMode := "Default"
	}

	IniWrite InputMode, ConfigFile, "Settings", "InputMode"


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


DisableAllKeys() {
	global DisabledAllKeys
	DisabledAllKeys := !DisabledAllKeys

	if DisabledAllKeys {
		UnregisterKeysLayout()
	} else {
		Sleep 50
		RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
	}
}
>^F10:: DisableAllKeys()


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

HandleFastKey(Combo := "", CharacterNames*) {
	global FastKeysIsActive
	IsLayoutValid := CheckLayoutValid()


	if IsLayoutValid {
		Output := ""

		for _, Character in CharacterNames {
			Output .= GetCharacterSequence(Character)
		}
		SendText(Output)

	} else {
		if Combo != "" {
			Send(ConvertComboKeys(Combo))
		}
	}
	return
}

GetCharacterSequence(CharacterName) {
	Output := ""
	for characterEntry, value in Characters {
		entryName := RegExReplace(characterEntry, "^\S+\s+")

		if (entryName = CharacterName) {
			characterEntity := (HasProp(value, "entity")) ? value.entity : (HasProp(value, "html")) ? value.html : ""
			characterLaTeX := (HasProp(value, "LaTeX")) ? value.LaTeX : ""

			if InputMode = "HTML" && HasProp(value, "html") {
				Output .= CombiningEnabled && HasProp(value, "combiningHTML") ? value.combiningHTML : characterEntity
			} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
				if IsObject(characterLaTeX) {
					if LaTeXMode = "common"
						Output .= characterLaTeX[1]
					else if LaTeXMode = "math"
						Output .= characterLaTeX[2]
				} else {
					Output .= characterLaTeX
				}
			} else {
				if CombiningEnabled && HasProp(value, "combiningForm") {
					if IsObject(value.combiningForm) {
						TempValue := ""
						for combining in value.combiningForm {
							TempValue .= PasteUnicode(combining)
						}
						SendText(TempValue)
					} else {
						Send(value.combiningForm)
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

LangSeparatedCall(LatinCallback, CyrillicCallback) {
	if GetLayoutLocale() == CodeEn {
		LatinCallback()
	} else {
		CyrillicCallback()
	}
	return
}

LangSeparatedKey(Combo, LatinCharacter, CyrillicCharacter, UseCaps := False, Reverse := False) {
	Character := (GetLayoutLocale() == CodeEn) ? LatinCharacter : CyrillicCharacter
	if UseCaps && IsObject(Character) {
		CapsSeparatedKey(Combo, Character[1], Character[2], Reverse)
	} else {
		HandleFastKey(Combo, IsObject(Character) ? Character[1] : Character)
	}
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

GetKeyBindings(UseKey, Combinations := "FastKeys") {
	LatinLayout := CheckQWERTY()
	CyrillicLayout := CheckYITSUKEN()
	if Combinations = "FastKeys" {
		return [
			"<^<!" UseKey["A"], (K) => HandleFastKey(K, "acute"),
			"<^<+<!" UseKey["A"], (K) => HandleFastKey(K, "acute_double"),
			"<^<!" UseKey["B"], (K) => HandleFastKey(K, "breve"),
			"<^<+<!" UseKey["B"], (K) => HandleFastKey(K, "breve_inverted"),
			"<^<!" UseKey["C"], (K) => HandleFastKey(K, "circumflex"),
			"<^<+<!" UseKey["C"], (K) => HandleFastKey(K, "caron"),
			"<^<!" UseKey["Comma"], (K) => HandleFastKey(K, "comma_above"),
			"<^<+<!" UseKey["Comma"], (K) => HandleFastKey(K, "comma_below"),
			"<^<!" UseKey["D"], (K) => HandleFastKey(K, "dot_above"),
			"<^<+<!" UseKey["D"], (K) => HandleFastKey(K, "diaeresis"),
			"<^<!" UseKey["F"], (K) => HandleFastKey(K, "fermata"),
			"<^<!" UseKey["G"], (K) => HandleFastKey(K, "grave"),
			"<^<+<!" UseKey["G"], (K) => HandleFastKey(K, "grave_double"),
			"<^<!" UseKey["H"], (K) => HandleFastKey(K, "hook_above"),
			"<^<+<!" UseKey["H"], (K) => HandleFastKey(K, "horn"),
			"<^<!" UseKey["M"], (K) => HandleFastKey(K, "macron"),
			"<^<+<!" UseKey["M"], (K) => HandleFastKey(K, "macron_below"),
			"<^<!" UseKey["N"], (K) => HandleFastKey(K, "cyr_com_titlo"),
			"<^<!" UseKey["O"], (K) => HandleFastKey(K, "ogonek"),
			"<^<!<+" UseKey["O"], (K) => HandleFastKey(K, "ogonek_above"),
			"<^<!" UseKey["R"], (K) => HandleFastKey(K, "ring_above"),
			"<^<!<+" UseKey["R"], (K) => HandleFastKey(K, "ring_below"),
			"<^<!" UseKey["V"], (K) => HandleFastKey(K, "line_vertical"),
			"<^<!<+" UseKey["V"], (K) => HandleFastKey(K, "line_vertical_double"),
			"<^<!" UseKey["T"], (K) => HandleFastKey(K, "tilde"),
			"<^<!<+" UseKey["T"], (K) => HandleFastKey(K, "tilde_overlay"),
			"<^<!" UseKey["S"], (K) => HandleFastKey(K, "stroke_short"),
			"<^<!<+" UseKey["S"], (K) => HandleFastKey(K, "stroke_long"),
			"<^<!" UseKey["Slash"], (K) => HandleFastKey(K, "solidus_short"),
			"<^<!<+" UseKey["Slash"], (K) => HandleFastKey(K, "solidus_long"),
			"<^<!" UseKey["X"], (K) => HandleFastKey(K, "x_above"),
			"<^<!<+" UseKey["X"], (K) => HandleFastKey(K, "x_below"),
			"<^<!" UseKey["Z"], (K) => HandleFastKey(K, "zigzag_above"),
			;
			"<^<!" UseKey["Minus"], (K) => HandleFastKey(K, "softhyphen"),
			"<^<!<+" UseKey["Minus"], (K) => HandleFastKey(K, "minus"),
			;
			"<^>!" UseKey["Comma"], (K) => LangSeparatedKey(K, "quote_left_double", "france_left"),
			"<^>!" UseKey["Dot"], (K) => LangSeparatedKey(K, "quote_right_double", "france_right"),
			"<^>!<+" UseKey["Comma"], (K) => LangSeparatedKey(K, "quote_left_single", "quote_low_9_double"),
			"<^>!<+" UseKey["Dot"], (K) => LangSeparatedKey(K, "quote_right_single", "quote_left_double"),
			"<^>!>+" UseKey["Comma"], (K) => LangSeparatedKey(K, "quote_low_9_double", "france_single_left"),
			"<^>!<+>+" UseKey["Comma"], (K) => LangSeparatedKey(K, "quote_low_9_single", ""),
			"<^>!>+" UseKey["Dot"], (K) => LangSeparatedKey(K, "quote_low_9_double_reversed", "france_single_right"),
			"<^>!>+" UseKey["Tilde"], (K) => HandleFastKey(K, "quote_right_single"),
			"<^>!>+" UseKey["C"], (K) => HandleFastKey(K, "cedilla"),
			;
			"<^>!>+" UseKey["1"], (K) => CapsSeparatedKey(K, "double_exclamation", "emsp"),
			"<^>!>+" UseKey["2"], (K) => HandleFastKey(K, "ensp"),
			"<^>!>+" UseKey["3"], (K) => HandleFastKey(K, "emsp13"),
			"<^>!>+" UseKey["4"], (K) => HandleFastKey(K, "emsp14"),
			"<^>!>+" UseKey["5"], (K) => HandleFastKey(K, "thinspace"),
			"<^>!>+" UseKey["6"], (K) => HandleFastKey(K, "emsp16"),
			"<^>!>+" UseKey["7"], (K) => CapsSeparatedKey(K, "double_question", "narrow_no_break_space"),
			"<^>!>+" UseKey["8"], (K) => HandleFastKey(K, "hairspace"),
			"<^>!>+" UseKey["9"], (K) => HandleFastKey(K, "punctuation_space"),
			"<^>!>+" UseKey["0"], (K) => HandleFastKey(K, "zero_width_space"),
			"<^>!>+" UseKey["Minus"], (K) => HandleFastKey(K, "word_joiner"),
			"<^>!>+" UseKey["Equals"], (K) => HandleFastKey(K, "figure_space"),
			"<^>!>+" UseKey["Tab"], (K) => HandleFastKey(K, "tabulation"),
			;
			"<^>!" UseKey["Space"], (K) => HandleFastKey(K, "no_break_space"),
			;
			"<^<!" UseKey["Numpad0"], (K) => HandleFastKey(K, "dotted_circle"),
			"<^>!" UseKey["NumpadMult"], (K) => HandleFastKey(K, "asterisk_two"),
			"<^>!>+" UseKey["NumpadMult"], (K) => HandleFastKey(K, "asterism"),
			"<^>!<+" UseKey["NumpadMult"], (K) => HandleFastKey(K, "asterisk_low"),
			"<^>!" UseKey["NumpadDiv"], (K) => HandleFastKey(K, "dagger"),
			"<^>!>+" UseKey["NumpadDiv"], (K) => HandleFastKey(K, "dagger_double"),
			;
			"<!" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_acute", "lat_s_let_a_acute"], ["", ""], True),
			"<^>!" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_breve", "lat_s_let_a_breve"], ["cyr_c_let_fita", "cyr_s_let_fita"], True),
			"<^>!<!" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_circumflex", "lat_s_let_a_circumflex"], ["", ""], True),
			"<^>!<!<+" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_caron", "lat_s_let_a_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_ogonek", "lat_s_let_a_ogonek"], ["", ""], True),
			"<^>!>+" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_macron", "lat_s_let_a_macron"], ["", ""], True),
			"<^>!<+" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_diaeresis", "lat_s_let_a_diaeresis"], ["", ""], True),
			"<^>!<+>+" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a_tilde", "lat_s_let_a_tilde"], ["", ""], True),
			;
			"<^>!" UseKey["B"], (K) => LangSeparatedKey(K, ["lat_c_let_b_stroke_short", "lat_s_let_b_stroke_short"], ["cyr_c_let_i", "cyr_s_let_i"], True),
			"<^>!<+" UseKey["B"], (K) => LangSeparatedKey(K, ["lat_c_let_b_hook", "lat_s_let_b_hook"], ["cyr_c_let_izhitsa", "cyr_s_let_izhitsa"], True),
			;
			"<!" UseKey["C"], (K) => LangSeparatedKey(K, ["lat_c_let_c_acute", "lat_s_let_c_acute"], ["", ""], True),
			"<^>!<!" UseKey["C"], (K) => LangSeparatedKey(K, ["lat_c_let_c_circumflex", "lat_s_let_c_circumflex"], ["", ""], True),
			"<^>!<!<+" UseKey["C"], (K) => LangSeparatedKey(K, ["lat_c_let_c_caron", "lat_s_let_c_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["C"], (K) => LangSeparatedKey(K, ["lat_c_let_c_cedilla", "lat_s_let_c_cedilla"], ["", ""], True),
			;
			"<^>!" UseKey["D"], (K) => LangSeparatedKey(K, ["lat_c_let_d_eth", "lat_s_let_d_eth"], ["", ""], True),
			"<^>!<!" UseKey["D"], (K) => LangSeparatedKey(K, ["lat_c_let_d_stroke_short", "lat_s_let_d_stroke_short"], ["", ""], True),
			"<^>!<!>+" UseKey["D"], (K) => LangSeparatedKey(K, ["lat_c_let_d_cedilla", "lat_s_let_d_cedilla"], ["", ""], True),
			"<^>!<!<+" UseKey["D"], (K) => LangSeparatedKey(K, ["lat_c_let_d_caron", "lat_s_let_d_caron"], ["", ""], True),
			"<^>!<+>+" UseKey["D"], (K) => LangSeparatedKey(K, ["lat_c_let_d_circumflex_below", "lat_s_let_d_circumflex_below"], ["", ""], True),
			;
			"<^>!" UseKey["S"], (K) => HandleFastKey(K, "section"),
			"<^>!<+" UseKey["S"], (K) => LangSeparatedKey(K, ["lat_c_lig_eszett", "lat_s_lig_eszett"], ["cyr_c_let_yeru_back_yer", "cyr_s_let_yeru_back_yer"], True),
			;
			"<!" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_acute", "lat_s_let_e_acute"], ["", ""], True),
			"<^>!" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_breve", "lat_s_let_e_breve"], ["cyr_c_let_yus_big", "cyr_s_let_yus_big"], True),
			"<^>!<!" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_circumflex", "lat_s_let_e_circumflex"], ["", ""], True),
			"<^>!<!<+" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_caron", "lat_s_let_e_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_ogonek", "lat_s_let_e_ogonek"], ["", ""], True),
			"<^>!>+" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_macron", "lat_s_let_e_macron"], ["", ""], True),
			"<^>!<+" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_diaeresis", "lat_s_let_e_diaeresis"], ["", ""], True),
			"<^>!<+>+" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e_tilde", "lat_s_let_e_tilde"], ["", ""], True),
			;
			"<!" UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g_acute", "lat_s_let_g_acute"], ["", ""], True),
			"<^>!" UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g_breve", "lat_s_let_g_breve"], ["", ""], True),
			"<^>!<!" UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g_circumflex", "lat_s_let_g_circumflex"], ["", ""], True),
			"<^>!<!<+" UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g_caron", "lat_s_let_g_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g_cedilla", "lat_s_let_g_cedilla"], ["", ""], True),
			"<^>!>+" UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g_macron", "lat_s_let_g_macron"], ["", ""], True),
			;
			"<^>!" UseKey["H"], (K) => LangSeparatedKey(K, ["lat_c_let_h_stroke_short", "lat_s_let_h_stroke_short"], ["", ""], True),
			"<^>!<!" UseKey["H"], (K) => LangSeparatedKey(K, ["lat_c_let_h_circumflex", "lat_s_let_h_circumflex"], ["", ""], True),
			"<^>!<!<+" UseKey["H"], (K) => LangSeparatedKey(K, ["lat_c_let_h_caron", "lat_s_let_h_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["H"], (K) => LangSeparatedKey(K, ["lat_c_let_h_cedilla", "lat_s_let_h_cedilla"], ["", ""], True),
			"<^>!<+" UseKey["H"], (K) => LangSeparatedKey(K, ["lat_c_let_h_diaeresis", "lat_s_let_h_diaeresis"], ["", ""], True),
			;
			"<!" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_acute", "lat_s_let_i_acute"], ["", ""], True),
			"<^>!" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_breve", "lat_s_let_i_breve"], ["", ""], True),
			"<^>!<!" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_circumflex", "lat_s_let_i_circumflex"], ["", ""], True),
			"<^>!<!<+" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_caron", "lat_s_let_i_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_ogonek", "lat_s_let_i_ogonek"], ["", ""], True),
			"<^>!>+" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_macron", "lat_s_let_i_macron"], ["", ""], True),
			"<^>!<+" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_diaeresis", "lat_s_let_i_diaeresis"], ["", ""], True),
			"<^>!<+>+" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i_tilde", "lat_s_let_i_tilde"], ["", ""], True),
			;
			"<^>!" UseKey["J"], (K) => LangSeparatedKey(K, ["lat_c_let_j_stroke_short", "lat_s_let_j_stroke_short"], ["cyr_c_let_omega", "cyr_s_let_omega"], True),
			"<^>!<!" UseKey["J"], (K) => LangSeparatedKey(K, ["lat_c_let_j_circumflex", "lat_s_let_j_circumflex"], ["", ""], True),
			;
			"<!" UseKey["K"], (K) => LangSeparatedKey(K, ["lat_c_let_k_acute", "lat_s_let_k_acute"], ["", ""], True),
			"<^>!<!<+" UseKey["K"], (K) => LangSeparatedKey(K, ["lat_c_let_k_caron", "lat_s_let_k_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["K"], (K) => LangSeparatedKey(K, ["lat_c_let_k_cedilla", "lat_s_let_k_cedilla"], ["", ""], True),
			;
			"<!" UseKey["L"], (K) => LangSeparatedKey(K, ["lat_c_let_l_acute", "lat_s_let_l_acute"], ["", ""], True),
			"<^>!" UseKey["L"], (K) => LangSeparatedKey(K, ["lat_c_let_l_solidus_short", "lat_s_let_l_solidus_short"], ["cyr_c_let_dzhe", "cyr_s_let_dzhe"], True),
			"<^>!<!<+" UseKey["L"], (K) => LangSeparatedKey(K, ["lat_c_let_l_caron", "lat_s_let_l_caron"], ["", ""], True),
			"<^>!<!>+" UseKey["L"], (K) => LangSeparatedKey(K, ["lat_c_let_l_cedilla", "lat_s_let_l_cedilla"], ["", ""], True),
			"<^>!<+>+" UseKey["L"], (K) => LangSeparatedKey(K, ["lat_c_let_l_circumflex_below", "lat_s_let_l_circumflex_below"], ["", ""], True),
			;
			;
			"<^>!" UseKey["Q"], (K) => LangSeparatedKey(K, ["", ""], ["cyr_c_let_yi", "cyr_s_let_yi"], True),
			"<^>!<!" UseKey["Q"], (K) => LangSeparatedKey(K, ["", ""], ["cyr_c_let_j", "cyr_s_let_j"], True),
			;
			"<^>!" UseKey["Z"], (K) => LangSeparatedKey(K, ["", ""], ["cyr_c_let_yus_little", "cyr_s_let_yus_little"], True),
			"<^>!<+" UseKey["Z"], (K) => LangSeparatedKey(K, ["", ""], ["cyr_c_let_a_iotified", "cyr_s_let_a_iotified"], True),
			"<^>!" UseKey["T"], (K) => LangSeparatedKey(K, ["", ""], ["cyr_c_let_yat", "cyr_s_let_yat"], True),
			"<^>!" UseKey["Apostrophe"], (K) => LangSeparatedKey(K, ["", ""], ["cyr_c_let_ukr_e", "cyr_s_let_ukr_e"], True),
			"<^>!" UseKey["C"], (K) => CapsSeparatedKey(K, "registered", "copyright"),
			"<^>!<+" UseKey["C"], (K) => CapsSeparatedKey(K, "servicemark", "trademark"),
			"<^>!" UseKey["P"], (K) => HandleFastKey(K, "prime_single"),
			"<^>!+" UseKey["P"], (K) => HandleFastKey(K, "prime_double"),
			"<^>!" UseKey["Equals"], (K) => HandleFastKey(K, "noequals"),
			"<^>!>+" UseKey["Equals"], (K) => HandleFastKey(K, "almostequals"),
			"<^>!<+" UseKey["Equals"], (K) => HandleFastKey(K, "plusminus"),
			"<^>!" UseKey["Minus"], (K) => CapsSeparatedKey(K, "three_emdash", "emdash"),
			"<^>!<+" UseKey["Minus"], (K) => CapsSeparatedKey(K, "two_emdash", "endash"),
			"<^>!<!" UseKey["Minus"], (K) => CapsSeparatedKey(K, "", "hyphen"),
			"<^>!<!<+" UseKey["Minus"], (K) => CapsSeparatedKey(K, "", "no_break_hyphen"),
			"<^>!<!>+" UseKey["Minus"], (K) => CapsSeparatedKey(K, "", "figure_dash"),
			"<^>!" UseKey["Slash"], (K) => HandleFastKey(K, "ellipsis"),
			"<^>!>+" UseKey["Slash"], (K) => HandleFastKey(K, "fraction_slash"),
			"<^>!" UseKey["8"], (K) => HandleFastKey(K, "multiplication"),
			"<^>!" UseKey["Tilde"], (K) => HandleFastKey(K, "bullet"),
			"<^>!<!" UseKey["Tilde"], (K) => HandleFastKey(K, "bullet_hyphen"),
			"<^>!<+" UseKey["Tilde"], (K) => HandleFastKey(K, "interpunct"),
			"<^>!<!>+" UseKey["Tilde"], (K) => HandleFastKey(K, "bullet_white"),
			;
			;"<^>!" UseKey["ArrLeft"], (K) => HandleFastKey(K, "arrow_left"),
			;"<^>!" UseKey["ArrUp"], (K) => HandleFastKey(K, "arrow_up"),
			;"<^>!" UseKey["ArrRight"], (K) => HandleFastKey(K, "arrow_right"),
			;"<^>!" UseKey["ArrDown"], (K) => HandleFastKey(K, "arrow_down"),
			;"<^>!" UseKey["ArrLeft"], (K) => TimedKeyCombinations("ArrLeft", UseKey["ArrUp"], (*) => HandleFastKey(K, "arrow_leftup"), (*) => HandleFastKey(K, "arrow_left")),
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
			"<^>!<!" UseKey["Comma"], (K) => HandleFastKey(K, "asian_double_left_title"),
			"<^>!<!<+" UseKey["Comma"], (K) => HandleFastKey(K, "asian_left_title"),
			"<^>!<!" UseKey["Dot"], (K) => HandleFastKey(K, "asian_double_right_title"),
			"<^>!<!<+" UseKey["Dot"], (K) => HandleFastKey(K, "asian_right_title"),
			"<!" UseKey["D"], (K) => HandleFastKey(K, "degree"),
			"<^>!<!" UseKey["0"], (K) => HandleFastKey(K, "infinity"),
			"<^>!" UseKey["9"], (K) => HandleFastKey(K, "bracket_angle_math_left"),
			"<^>!" UseKey["0"], (K) => HandleFastKey(K, "bracket_angle_math_right"),
			;
			"<^>!" UseKey["Enter"], (K) => HandleFastKey(K, "misc_crlf_emspace"),
			"<^>!<+" UseKey["Enter"], (K) => SendPaste("+{Enter}", (*) => HandleFastKey(K, "emsp")),
			"<^>!>+" UseKey["Enter"], (K) => HandleFastKey(K, "misc_crlf_emspace", "emsp"),
			;
			"<^>!" UseKey["1"], (K) => HandleFastKey(K, "inverted_exclamation"),
			"<^>!<+" UseKey["1"], (K) => HandleFastKey(K, "double_exclamation_question"),
			"<^>!<+>+" UseKey["1"], (K) => CapsSeparatedKey(K, "interrobang_inverted", "interrobang"),
			"<^>!" UseKey["5"], (K) => HandleFastKey(K, "permille"),
			"<^>!<+" UseKey["5"], (K) => HandleFastKey(K, "pertenthousand"),
			"<^>!" UseKey["7"], (K) => HandleFastKey(K, "inverted_question"),
			"<^>!<+" UseKey["7"], (K) => HandleFastKey(K, "double_question_exclamation"),
			"<^>!<!" UseKey["7"], (K) => HandleFastKey(K, "reversed_question"),
			;
			UseKey["NumpadMult"], (K) => HandleFastKey(K, "multiplication"),
			UseKey["NumpadSub"], (K) => TimedKeyCombinations("NumpadSub", UseKey["NumpadAdd"], (*) => HandleFastKey(K, "plusminus"), (*) => HandleFastKey(K, "minus")),
			UseKey["NumpadAdd"], (K) => TimedKeyCombinations("NumpadAdd", UseKey["NumpadSub"], "Off"),
			UseKey["Equals"], (K) =>
				TimedKeyCombinations("Equals",
					[UseKey["Slash"], UseKey["Tilde"]],
					[(*) => HandleFastKey(K, "noequals"), (*) => HandleFastKey(K, "almostequals")],
				),
			UseKey["Slash"], (K) => TimedKeyCombinations("Slash", UseKey["Equals"], "Off"),
			UseKey["Tilde"], (K) => TimedKeyCombinations("Tilde", UseKey["Equals"], "Off"),
			;
			"<^>!" UseKey["LSquareBracket"], (K) => HandleFastKey(K, "bracket_square_left"),
			"<^>!" UseKey["RSquareBracket"], (K) => HandleFastKey(K, "bracket_square_right"),
			"<^>!>+" UseKey["LSquareBracket"], (K) => HandleFastKey(K, "bracket_curly_left"),
			"<^>!>+" UseKey["RSquareBracket"], (K) => HandleFastKey(K, "bracket_curly_right"),
		]
	} else if Combinations = "Glagolitic Futhark" {
		return [
			UseKey["A"], (K) => LangSeparatedKey(K, "futhark_ansuz", ["glagolitic_c_let_fritu", "glagolitic_s_let_fritu"], True),
			"<+" UseKey["A"], (K) => LangSeparatedKey(K, "futhork_as", ["", ""], True),
			">+" UseKey["A"], (K) => LangSeparatedKey(K, "futhork_aesc", ["", ""], True),
			"<^>!" UseKey["A"], (K) => LangSeparatedKey(K, "futhark_younger_jera", ["glagolitic_c_let_fita", "glagolitic_s_let_fita"], True),
			"<^>!<+" UseKey["A"], (K) => LangSeparatedKey(K, "futhark_younger_jera_short_twig", ["", ""], True),
			UseKey["B"], (K) => LangSeparatedKey(K, "futhark_berkanan", ["glagolitic_c_let_i", "glagolitic_s_let_i"], True),
			"<^>!" UseKey["B"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_initial_izhe", "glagolitic_s_let_initial_izhe"], True),
			"<+" UseKey["B"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"], True),
			"<^>!<+" UseKey["B"], (K) => LangSeparatedKey(K, "futhark_younger_bjarkan_short_twig", ["glagolitic_c_let_izhitsa", "glagolitic_s_let_izhitsa"], True),
			UseKey["C"], (K) => LangSeparatedKey(K, "futhork_cen", ["glagolitic_c_let_slovo", "glagolitic_s_let_slovo"], True),
			"<^>!" UseKey["C"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_dzelo", "glagolitic_s_let_dzelo"], True),
			"<^>!<!" UseKey["C"], (K) => LangSeparatedKey(K, "medieval_c", ["", ""], True),
			UseKey["D"], (K) => LangSeparatedKey(K, "futhark_dagaz", ["glagolitic_c_let_vede", "glagolitic_s_let_vede"], True),
			"<^>!" UseKey["D"], (K) => LangSeparatedKey(K, "futhark_younger_later_eth", ["", ""], True),
			"<^>!<+" UseKey["D"], (K) => LangSeparatedKey(K, "futhark_younger_later_d", ["", ""], True),
			UseKey["E"], (K) => LangSeparatedKey(K, "futhark_ehwaz", ["glagolitic_c_let_uku", "glagolitic_s_let_uku"], True),
			"<+" UseKey["E"], (K) => LangSeparatedKey(K, "futhork_ear", ["", ""], True),
			"<^>!" UseKey["E"], (K) => LangSeparatedKey(K, "futhark_younger_later_e", ["", ""], True),
			"<^>!<!" UseKey["E"], (K) => LangSeparatedKey(K, "medieval_en", ["", ""], True),
			UseKey["F"], (K) => LangSeparatedKey(K, "futhark_fehu", ["glagolitic_c_let_az", "glagolitic_s_let_az"], True),
			"<^>!" UseKey["F"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_trokutasti_a", "glagolitic_s_let_trokutasti_a"], True),
			UseKey["G"], (K) => LangSeparatedKey(K, "futhark_gebo", ["glagolitic_c_let_pokoji", "glagolitic_s_let_pokoji"], True),
			"<^>!" UseKey["G"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_pe", "glagolitic_s_let_pe"], True),
			"<+" UseKey["G"], (K) => LangSeparatedKey(K, "futhork_gar", ["", ""], True),
			UseKey["H"], (K) => LangSeparatedKey(K, "futhark_haglaz", ["glagolitic_c_let_ritsi", "glagolitic_s_let_ritsi"], True),
			"<+" UseKey["H"], (K) => LangSeparatedKey(K, "futhork_haegl", ["", ""], True),
			"<^>!" UseKey["H"], (K) => LangSeparatedKey(K, "futhark_younger_hagall", ["", ""], True),
			"<^>!<+" UseKey["H"], (K) => LangSeparatedKey(K, "futhark_younger_hagall_short_twig", ["", ""], True),
			UseKey["I"], (K) => LangSeparatedKey(K, "futhark_isaz", ["glagolitic_c_let_sha", "glagolitic_s_let_sha"], True),
			">+" UseKey["I"], (K) => LangSeparatedKey(K, "futhark_eihwaz", ["", ""], True),
			"<^>!" UseKey["J"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_otu", "glagolitic_s_let_otu"], True),
			UseKey["J"], (K) => LangSeparatedKey(K, "futhark_jeran", ["glagolitic_c_let_onu", "glagolitic_s_let_onu"], True),
			"<!" UseKey["J"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_big_yus", "glagolitic_s_let_big_yus"], True),
			"<+" UseKey["J"], (K) => LangSeparatedKey(K, "futhork_ger", ["", ""], True),
			">+" UseKey["J"], (K) => LangSeparatedKey(K, "futhork_ior", ["", ""], True),
			UseKey["L"], (K) => LangSeparatedKey(K, "futhark_laguz", ["glagolitic_c_let_dobro", "glagolitic_s_let_dobro"], True),
			"<^>!" UseKey["L"], (K) => LangSeparatedKey(K, "futhark_younger_later_l", ["", ""], True),
			UseKey["K"], (K) => LangSeparatedKey(K, "futhark_kauna", ["glagolitic_c_let_ljudije", "glagolitic_s_let_ljudije"], True),
			"<+" UseKey["K"], (K) => LangSeparatedKey(K, "futhork_cealc", ["", ""], True),
			">+" UseKey["K"], (K) => LangSeparatedKey(K, "futhork_calc", ["", ""], True),
			"<^>!" UseKey["K"], (K) => LangSeparatedKey(K, "futhark_younger_kaun", ["", ""], True),
			"<^>!" UseKey["K"], (K) => LangSeparatedKey(K, "futhark_younger_kaun", ["", ""], True),
			UseKey["M"], (K) => LangSeparatedKey(K, "futhark_mannaz", ["glagolitic_c_let_yeri", "glagolitic_s_let_yeri"], True),
			"<^>!" UseKey["M"], (K) => LangSeparatedKey(K, "futhark_younger_madr", ["", ""], True),
			"<^>!<+" UseKey["M"], (K) => LangSeparatedKey(K, "futhark_younger_madr_short_twig", ["", ""], True),
			UseKey["N"], (K) => LangSeparatedKey(K, "futhark_naudiz", ["glagolitic_c_let_tvrido", "glagolitic_s_let_tvrido"], True),
			">+" UseKey["N"], (K) => LangSeparatedKey(K, "futhark_ingwaz", ["", ""], True),
			"<+" UseKey["N"], (K) => LangSeparatedKey(K, "futhork_ing", ["", ""], True),
			"<^>!<+" UseKey["N"], (K) => LangSeparatedKey(K, "futhark_younger_naud_short_twig", ["", ""], True),
			UseKey["O"], (K) => LangSeparatedKey(K, "futhark_odal", ["glagolitic_c_let_shta", "glagolitic_s_let_shta"], True),
			"<+" UseKey["O"], (K) => LangSeparatedKey(K, "futhork_os", ["", ""], True),
			"<^>!" UseKey["O"], (K) => LangSeparatedKey(K, "futhark_younger_oss", ["", ""], True),
			"<^>!<+" UseKey["O"], (K) => LangSeparatedKey(K, "futhark_younger_oss_short_twig", ["", ""], True),
			"<^>!<!" UseKey["O"], (K) => LangSeparatedKey(K, "medieval_on", ["", ""], True),
			"<^>!<!>+" UseKey["O"], (K) => LangSeparatedKey(K, "medieval_o", ["", ""], True),
			UseKey["P"], (K) => LangSeparatedKey(K, "futhark_pertho", ["glagolitic_c_let_zemlja", "glagolitic_c_let_zemlja"], True),
			"<^>!" UseKey["P"], (K) => LangSeparatedKey(K, "futhark_younger_later_p", ["", ""], True),
			UseKey["Q"], (K) => LangSeparatedKey(K, "futhork_cweorth", ["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"], True),
			UseKey["R"], (K) => LangSeparatedKey(K, "futhark_raido", ["glagolitic_c_let_kako", "glagolitic_s_let_kako"], True),
			UseKey["S"], (K) => LangSeparatedKey(K, "futhark_sowilo", ["glagolitic_c_let_yery", "glagolitic_s_let_yery"], True),
			"<+" UseKey["S"], (K) => LangSeparatedKey(K, "futhork_sigel", ["", ""], True),
			">+" UseKey["S"], (K) => LangSeparatedKey(K, "futhork_stan", ["", ""], True),
			"<^>!<+" UseKey["S"], (K) => LangSeparatedKey(K, "futhark_younger_sol_short_twig", ["", ""], True),
			UseKey["T"], (K) => LangSeparatedKey(K, "futhark_tiwaz", ["glagolitic_c_let_yestu", "glagolitic_s_let_yestu"], True),
			">+" UseKey["T"], (K) => LangSeparatedKey(K, "futhark_thurisaz", ["", ""], True),
			"<^>!<+" UseKey["T"], (K) => LangSeparatedKey(K, "futhark_younger_tyr_short_twig", ["", ""], True),
			UseKey["U"], (K) => LangSeparatedKey(K, "futhark_uruz", ["glagolitic_c_let_glagoli", "glagolitic_s_let_glagoli"], True),
			UseKey["Y"], (K) => LangSeparatedKey(K, "futhark_younger_ur", ["glagolitic_c_let_nashi", "glagolitic_s_let_nashi"], True),
			">+" UseKey["Y"], (K) => LangSeparatedKey(K, "futhark_younger_icelandic_yr", ["", ""], True),
			"<^>!" UseKey["Y"], (K) => LangSeparatedKey(K, "futhark_younger_yr", ["", ""], True),
			"<^>!<+" UseKey["Y"], (K) => LangSeparatedKey(K, "futhark_younger_yr_short_twig", ["", ""], True),
			"<+" UseKey["Y"], (K) => LangSeparatedKey(K, "futhork_yr", ["", ""], True),
			UseKey["V"], (K) => LangSeparatedKey(K, "futhark_younger_later_v", ["glagolitic_c_let_myslite", "glagolitic_s_let_myslite"], True),
			UseKey["W"], (K) => LangSeparatedKey(K, "futhark_wunjo", ["glagolitic_c_let_tsi", "glagolitic_s_let_tsi"], True),
			UseKey["Z"], (K) => LangSeparatedKey(K, "futhark_algiz", ["glagolitic_c_let_yati", "glagolitic_s_let_yati"], True),
			"<^>!<!" UseKey["Z"], (K) => LangSeparatedKey(K, "medieval_x", ["", ""], True),
			UseKey["X"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_chrivi", "glagolitic_s_let_chrivi"], True),
			"<^>!<!" UseKey["X"], (K) => LangSeparatedKey(K, "medieval_z", ["", ""], True),
			;
			UseKey["Tilde"], (K) => LangSeparatedKey(K, "kkey_grave_accent", ["glagolitic_c_let_yo", "glagolitic_s_let_yo"], True),
			"<!" UseKey["Tilde"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_big_yus_iotified", "glagolitic_s_let_big_yus_iotified"], True),
			UseKey["Comma"], (K) => LangSeparatedKey(K, "kkey_comma", ["glagolitic_c_let_buky", "glagolitic_s_let_buky"], True),
			UseKey["Dot"], (K) => LangSeparatedKey(K, "kkey_dot", ["glagolitic_c_let_yu", "glagolitic_s_let_yu"], True),
			"<^>!" UseKey["Comma"], (K) => LangSeparatedKey(K, "runic_cruciform_punctuation", ["", ""], True),
			"<^>!" UseKey["Dot"], (K) => LangSeparatedKey(K, "runic_single_punctuation", ["", ""], True),
			"<^>!" UseKey["Space"], (K) => LangSeparatedKey(K, "runic_multiple_punctuation", ["", ""], True),
			UseKey["Semicolon"], (K) => LangSeparatedKey(K, "kkey_semicolon", ["glagolitic_c_let_zhivete", "glagolitic_s_let_zhivete"], True),
			"<^>!" UseKey["Semicolon"], (K) => LangSeparatedKey(K, "kkey_semicolon", ["glagolitic_c_let_djervi", "glagolitic_s_let_djervi"], True),
			UseKey["Apostrophe"], (K) => LangSeparatedKey(K, "kkey_apostrophe", ["glagolitic_c_let_small_yus", "glagolitic_s_let_small_yus"], True),
			"<^>!" UseKey["Apostrophe"], (K) => LangSeparatedKey(K, "kkey_apostrophe", ["glagolitic_c_let_small_yus_iotified", "glagolitic_s_let_small_yus_iotified"], True),
			UseKey["LSquareBracket"], (K) => LangSeparatedKey(K, "kkey_l_square_bracket", ["glagolitic_c_let_heru", "glagolitic_s_let_heru"], True),
			"<^>!" UseKey["LSquareBracket"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_spider_ha", "glagolitic_s_let_spider_ha"], True),
			UseKey["RSquareBracket"], (K) => LangSeparatedKey(K, "kkey_r_square_bracket", ["glagolitic_c_let_yeru", "glagolitic_s_let_yeru"], True),
			"<^>!" UseKey["RSquareBracket"], (K) => LangSeparatedKey(K, "", ["glagolitic_c_let_shtapic", "glagolitic_s_let_shtapic"], True),
			;
			"<^>!" UseKey["7"], (K) => LangSeparatedKey(K, "futhark_almanac_arlaug", ["", ""], True),
			"<^>!" UseKey["8"], (K) => LangSeparatedKey(K, "futhark_almanac_tvimadur", ["", ""], True),
			"<^>!" UseKey["9"], (K) => LangSeparatedKey(K, "futhark_almanac_belgthor", ["", ""], True),
			;
			"<^<!" UseKey["D"], (K) => HandleFastKey(K, "cyr_com_vzmet"),
		]
	} else if Combinations = "NonQWERTY" {
		Slots := Map()

		if CyrillicLayout = "ЙЦУКЕН" {
			if LatinLayout = "QWERTY" {
				MapPush(Slots,
					"A", ["cyr_c_let_f", "cyr_s_let_f"],
					"B", ["cyr_c_let_и", "cyr_s_let_и"],
					"C", ["cyr_c_let_s", "cyr_s_let_s"],
					"D", ["cyr_c_let_v", "cyr_s_let_v"],
					"E", ["cyr_c_let_u", "cyr_s_let_u"],
					"F", ["cyr_c_let_a", "cyr_s_let_a"],
					"G", ["cyr_c_let_p", "cyr_s_let_p"],
					"H", ["cyr_c_let_r", "cyr_s_let_r"],
					"I", ["cyr_c_let_sh", "cyr_s_let_sh"],
					"J", ["cyr_c_let_o", "cyr_s_let_o"],
					"K", ["cyr_c_let_l", "cyr_s_let_l"],
					"L", ["cyr_c_let_d", "cyr_s_let_d"],
					"M", ["cyr_c_let_yeri", "cyr_s_let_yeri"],
					"N", ["cyr_c_let_t", "cyr_s_let_t"],
					"O", ["cyr_c_let_shch", "cyr_s_let_shch"],
					"P", ["cyr_c_let_z", "cyr_s_let_z"],
					"Q", ["cyr_c_let_iy", "cyr_s_let_iy"],
					"R", ["cyr_c_let_k", "cyr_s_let_k"],
					"S", ["cyr_c_let_yery", "cyr_s_let_yery"],
					"T", ["cyr_c_let_e", "cyr_s_let_e"],
					"U", ["cyr_c_let_g", "cyr_s_let_g"],
					"V", ["cyr_c_let_m", "cyr_s_let_m"],
					"W", ["cyr_c_let_ts", "cyr_s_let_ts"],
					"X", ["cyr_c_let_ch", "cyr_s_let_ch"],
					"Y", ["cyr_c_let_n", "cyr_s_let_n"],
					"Z", ["cyr_c_let_ya", "cyr_s_let_ya"],
					"+Z", ["cyr_c_let_ya", "cyr_s_let_ya"],
					",", ["cyr_c_let_b", "cyr_s_let_b"],
					"+,", ["cyr_c_let_b", "cyr_s_let_b"],
					".", ["cyr_c_let_yu", "cyr_s_let_yu"],
					"+.", ["cyr_c_let_yu", "cyr_s_let_yu"],
					";", ["cyr_c_let_zh", "cyr_s_let_zh"],
					"+;", ["cyr_c_let_zh", "cyr_s_let_zh"],
					"'", ["cyr_c_let_э", "cyr_s_let_э"],
					"+'", ["cyr_c_let_э", "cyr_s_let_э"],
					"[", ["cyr_c_let_h", "cyr_s_let_h"],
					"+[", ["cyr_c_let_h", "cyr_s_let_h"],
					"]", ["cyr_c_let_yeru", "cyr_s_let_yeru"],
					"+]", ["cyr_c_let_yeru", "cyr_s_let_yeru"],
					"~", ["cyr_c_let_yo", "cyr_s_let_yo"],
					"+~", ["cyr_c_let_yo", "cyr_s_let_yo"],
					"/", "kkey_dot",
					"+/", "kkey_comma",
					"\", "kkey_slash",
					"+\", "kkey_backslash",
					"=", "kkey_equals",
					"+=", "kkey_plus",
					"-", "kkey_hyphen_minus",
					"+-", "kkey_underscore",
				)
			} else if LatinLayout = "Dvorak" {
				MapPush(Slots,
					"A", ["cyr_c_let_f", "cyr_s_let_f"],
					"X", ["cyr_c_let_и", "cyr_s_let_и"],
					"J", ["cyr_c_let_s", "cyr_s_let_s"],
					"E", ["cyr_c_let_v", "cyr_s_let_v"],
					".", ["cyr_c_let_u", "cyr_s_let_u"],
					"+.", ["cyr_c_let_u", "cyr_s_let_u"],
					"U", ["cyr_c_let_a", "cyr_s_let_a"],
					"I", ["cyr_c_let_p", "cyr_s_let_p"],
					"D", ["cyr_c_let_r", "cyr_s_let_r"],
					"C", ["cyr_c_let_sh", "cyr_s_let_sh"],
					"H", ["cyr_c_let_o", "cyr_s_let_o"],
					"T", ["cyr_c_let_l", "cyr_s_let_l"],
					"N", ["cyr_c_let_d", "cyr_s_let_d"],
					"M", ["cyr_c_let_yeri", "cyr_s_let_yeri"],
					"B", ["cyr_c_let_t", "cyr_s_let_t"],
					"R", ["cyr_c_let_shch", "cyr_s_let_shch"],
					"L", ["cyr_c_let_z", "cyr_s_let_z"],
					"'", ["cyr_c_let_iy", "cyr_s_let_iy"],
					"+'", ["cyr_c_let_iy", "cyr_s_let_iy"],
					"P", ["cyr_c_let_k", "cyr_s_let_k"],
					"O", ["cyr_c_let_yery", "cyr_s_let_yery"],
					"Y", ["cyr_c_let_e", "cyr_s_let_e"],
					"G", ["cyr_c_let_g", "cyr_s_let_g"],
					"K", ["cyr_c_let_m", "cyr_s_let_m"],
					",", ["cyr_c_let_ts", "cyr_s_let_ts"],
					"+,", ["cyr_c_let_ts", "cyr_s_let_ts"],
					"Q", ["cyr_c_let_ch", "cyr_s_let_ch"],
					"F", ["cyr_c_let_n", "cyr_s_let_n"],
					";", ["cyr_c_let_ya", "cyr_s_let_ya"],
					"+;", ["cyr_c_let_ya", "cyr_s_let_ya"],
					"W", ["cyr_c_let_b", "cyr_s_let_b"],
					"V", ["cyr_c_let_yu", "cyr_s_let_yu"],
					"S", ["cyr_c_let_zh", "cyr_s_let_zh"],
					"-", ["cyr_c_let_э", "cyr_s_let_э"],
					"+-", ["cyr_c_let_э", "cyr_s_let_э"],
					"/", ["cyr_c_let_h", "cyr_s_let_h"],
					"+/", ["cyr_c_let_h", "cyr_s_let_h"],
					"=", ["cyr_c_let_yeru", "cyr_s_let_yeru"],
					"+=", ["cyr_c_let_yeru", "cyr_s_let_yeru"],
					"~", ["cyr_c_let_yo", "cyr_s_let_yo"],
					"Z", "kkey_dot",
					"+Z", "kkey_comma",
					"\", "kkey_slash",
					"+\", "kkey_backslash",
					"]", "kkey_equals",
					"+]", "kkey_plus",
					"[", "kkey_hyphen_minus",
					"+[", "kkey_underscore",
				)
			} else if LatinLayout = "Colemak" {
				MapPush(Slots,
					"A", ["cyr_c_let_f", "cyr_s_let_f"],
					"B", ["cyr_c_let_и", "cyr_s_let_и"],
					"C", ["cyr_c_let_s", "cyr_s_let_s"],
					"S", ["cyr_c_let_v", "cyr_s_let_v"],
					"F", ["cyr_c_let_u", "cyr_s_let_u"],
					"T", ["cyr_c_let_a", "cyr_s_let_a"],
					"D", ["cyr_c_let_p", "cyr_s_let_p"],
					"H", ["cyr_c_let_r", "cyr_s_let_r"],
					"U", ["cyr_c_let_sh", "cyr_s_let_sh"],
					"N", ["cyr_c_let_o", "cyr_s_let_o"],
					"E", ["cyr_c_let_l", "cyr_s_let_l"],
					"I", ["cyr_c_let_d", "cyr_s_let_d"],
					"M", ["cyr_c_let_yeri", "cyr_s_let_yeri"],
					"K", ["cyr_c_let_t", "cyr_s_let_t"],
					"Y", ["cyr_c_let_shch", "cyr_s_let_shch"],
					";", ["cyr_c_let_z", "cyr_s_let_z"],
					"+;", ["cyr_c_let_z", "cyr_s_let_z"],
					"Q", ["cyr_c_let_iy", "cyr_s_let_iy"],
					"P", ["cyr_c_let_k", "cyr_s_let_k"],
					"R", ["cyr_c_let_yery", "cyr_s_let_yery"],
					"G", ["cyr_c_let_e", "cyr_s_let_e"],
					"L", ["cyr_c_let_g", "cyr_s_let_g"],
					"V", ["cyr_c_let_m", "cyr_s_let_m"],
					"W", ["cyr_c_let_ts", "cyr_s_let_ts"],
					"X", ["cyr_c_let_ch", "cyr_s_let_ch"],
					"J", ["cyr_c_let_n", "cyr_s_let_n"],
					"Z", ["cyr_c_let_ya", "cyr_s_let_ya"],
					"+Z", ["cyr_c_let_ya", "cyr_s_let_ya"],
					",", ["cyr_c_let_b", "cyr_s_let_b"],
					"+,", ["cyr_c_let_b", "cyr_s_let_b"],
					".", ["cyr_c_let_yu", "cyr_s_let_yu"],
					"+.", ["cyr_c_let_yu", "cyr_s_let_yu"],
					"O", ["cyr_c_let_zh", "cyr_s_let_zh"],
					"'", ["cyr_c_let_э", "cyr_s_let_э"],
					"+'", ["cyr_c_let_э", "cyr_s_let_э"],
					"[", ["cyr_c_let_h", "cyr_s_let_h"],
					"+[", ["cyr_c_let_h", "cyr_s_let_h"],
					"]", ["cyr_c_let_yeru", "cyr_s_let_yeru"],
					"+]", ["cyr_c_let_yeru", "cyr_s_let_yeru"],
					"~", ["cyr_c_let_yo", "cyr_s_let_yo"],
					"+~", ["cyr_c_let_yo", "cyr_s_let_yo"],
					"/", "kkey_dot",
					"+/", "kkey_comma",
					"\", "kkey_slash",
					"+\", "kkey_backslash",
					"=", "kkey_equals",
					"+=", "kkey_plus",
					"-", "kkey_hyphen_minus",
					"+-", "kkey_underscore",
				)
			}
		}

		return [
			UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a", "lat_s_let_a"], Slots["A"], True),
			"+" UseKey["A"], (K) => LangSeparatedKey(K, ["lat_c_let_a", "lat_s_let_a"], Slots["A"], True, True),
			UseKey["B"], (K) => LangSeparatedKey(K, ["lat_c_let_b", "lat_s_let_b"], Slots["B"], True),
			"+" UseKey["B"], (K) => LangSeparatedKey(K, ["lat_c_let_b", "lat_s_let_b"], Slots["B"], True, True),
			UseKey["C"], (K) => LangSeparatedKey(K, ["lat_c_let_c", "lat_s_let_c"], Slots["C"], True),
			"+" UseKey["C"], (K) => LangSeparatedKey(K, ["lat_c_let_c", "lat_s_let_c"], Slots["C"], True, True),
			UseKey["D"], (K) => LangSeparatedKey(K, ["lat_c_let_d", "lat_s_let_d"], Slots["V"], True),
			"+" UseKey["D"], (K) => LangSeparatedKey(K, ["lat_c_let_d", "lat_s_let_d"], Slots["V"], True, True),
			UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e", "lat_s_let_e"], Slots["E"], True),
			"+" UseKey["E"], (K) => LangSeparatedKey(K, ["lat_c_let_e", "lat_s_let_e"], Slots["E"], True, True),
			UseKey["F"], (K) => LangSeparatedKey(K, ["lat_c_let_f", "lat_s_let_f"], Slots["F"], True),
			"+" UseKey["F"], (K) => LangSeparatedKey(K, ["lat_c_let_f", "lat_s_let_f"], Slots["F"], True, True),
			UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g", "lat_s_let_g"], Slots["G"], True),
			"+" UseKey["G"], (K) => LangSeparatedKey(K, ["lat_c_let_g", "lat_s_let_g"], Slots["G"], True, True),
			UseKey["H"], (K) => LangSeparatedKey(K, ["lat_c_let_h", "lat_s_let_h"], Slots["H"], True),
			"+" UseKey["H"], (K) => LangSeparatedKey(K, ["lat_c_let_h", "lat_s_let_h"], Slots["H"], True, True),
			UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i", "lat_s_let_i"], Slots["I"], True),
			"+" UseKey["I"], (K) => LangSeparatedKey(K, ["lat_c_let_i", "lat_s_let_i"], Slots["I"], True, True),
			UseKey["J"], (K) => LangSeparatedKey(K, ["lat_c_let_j", "lat_s_let_j"], Slots["J"], True),
			"+" UseKey["J"], (K) => LangSeparatedKey(K, ["lat_c_let_j", "lat_s_let_j"], Slots["J"], True, True),
			UseKey["K"], (K) => LangSeparatedKey(K, ["lat_c_let_k", "lat_s_let_k"], Slots["K"], True),
			"+" UseKey["K"], (K) => LangSeparatedKey(K, ["lat_c_let_k", "lat_s_let_k"], Slots["K"], True, True),
			UseKey["L"], (K) => LangSeparatedKey(K, ["lat_c_let_l", "lat_s_let_l"], Slots["L"], True),
			"+" UseKey["L"], (K) => LangSeparatedKey(K, ["lat_c_let_l", "lat_s_let_l"], Slots["L"], True, True),
			UseKey["M"], (K) => LangSeparatedKey(K, ["lat_c_let_m", "lat_s_let_m"], Slots["M"], True),
			"+" UseKey["M"], (K) => LangSeparatedKey(K, ["lat_c_let_m", "lat_s_let_m"], Slots["M"], True, True),
			UseKey["N"], (K) => LangSeparatedKey(K, ["lat_c_let_n", "lat_s_let_n"], Slots["N"], True),
			"+" UseKey["N"], (K) => LangSeparatedKey(K, ["lat_c_let_n", "lat_s_let_n"], Slots["N"], True, True),
			UseKey["O"], (K) => LangSeparatedKey(K, ["lat_c_let_o", "lat_s_let_o"], Slots["O"], True),
			"+" UseKey["O"], (K) => LangSeparatedKey(K, ["lat_c_let_o", "lat_s_let_o"], Slots["O"], True, True),
			UseKey["P"], (K) => LangSeparatedKey(K, ["lat_c_let_p", "lat_s_let_p"], Slots["P"], True),
			"+" UseKey["P"], (K) => LangSeparatedKey(K, ["lat_c_let_p", "lat_s_let_p"], Slots["P"], True, True),
			UseKey["Q"], (K) => LangSeparatedKey(K, ["lat_c_let_q", "lat_s_let_q"], Slots["Q"], True),
			"+" UseKey["Q"], (K) => LangSeparatedKey(K, ["lat_c_let_q", "lat_s_let_q"], Slots["Q"], True, True),
			UseKey["R"], (K) => LangSeparatedKey(K, ["lat_c_let_r", "lat_s_let_r"], Slots["R"], True),
			"+" UseKey["R"], (K) => LangSeparatedKey(K, ["lat_c_let_r", "lat_s_let_r"], Slots["R"], True, True),
			UseKey["S"], (K) => LangSeparatedKey(K, ["lat_c_let_s", "lat_s_let_s"], Slots["S"], True),
			"+" UseKey["S"], (K) => LangSeparatedKey(K, ["lat_c_let_s", "lat_s_let_s"], Slots["S"], True, True),
			UseKey["T"], (K) => LangSeparatedKey(K, ["lat_c_let_t", "lat_s_let_t"], Slots["T"], True),
			"+" UseKey["T"], (K) => LangSeparatedKey(K, ["lat_c_let_t", "lat_s_let_t"], Slots["T"], True, True),
			UseKey["U"], (K) => LangSeparatedKey(K, ["lat_c_let_u", "lat_s_let_u"], Slots["U"], True),
			"+" UseKey["U"], (K) => LangSeparatedKey(K, ["lat_c_let_u", "lat_s_let_u"], Slots["U"], True, True),
			UseKey["V"], (K) => LangSeparatedKey(K, ["lat_c_let_v", "lat_s_let_v"], Slots["V"], True),
			"+" UseKey["V"], (K) => LangSeparatedKey(K, ["lat_c_let_v", "lat_s_let_v"], Slots["V"], True, True),
			UseKey["W"], (K) => LangSeparatedKey(K, ["lat_c_let_w", "lat_s_let_w"], Slots["W"], True),
			"+" UseKey["W"], (K) => LangSeparatedKey(K, ["lat_c_let_w", "lat_s_let_w"], Slots["W"], True, True),
			UseKey["X"], (K) => LangSeparatedKey(K, ["lat_c_let_x", "lat_s_let_x"], Slots["X"], True),
			"+" UseKey["X"], (K) => LangSeparatedKey(K, ["lat_c_let_x", "lat_s_let_x"], Slots["X"], True, True),
			UseKey["Y"], (K) => LangSeparatedKey(K, ["lat_c_let_y", "lat_s_let_y"], Slots["Y"], True),
			"+" UseKey["Y"], (K) => LangSeparatedKey(K, ["lat_c_let_y", "lat_s_let_y"], Slots["Y"], True, True),
			UseKey["Z"], (K) => LangSeparatedKey(K, ["lat_c_let_z", "lat_s_let_z"], Slots["Z"], True),
			"+" UseKey["Z"], (K) => LangSeparatedKey(K, ["lat_c_let_z", "lat_s_let_z"], Slots["+Z"], True, True),
			;
			UseKey["Comma"], (K) => LangSeparatedKey(K, "kkey_comma", Slots[","], True),
			"+" UseKey["Comma"], (K) => LangSeparatedKey(K, "kkey_lessthan", Slots["+,"], True, True),
			UseKey["Dot"], (K) => LangSeparatedKey(K, "kkey_dot", Slots["."], True),
			"+" UseKey["Dot"], (K) => LangSeparatedKey(K, "kkey_greaterthan", Slots["+."], True, True),
			UseKey["Semicolon"], (K) => LangSeparatedKey(K, "kkey_semicolon", Slots[";"], True),
			"+" UseKey["Semicolon"], (K) => LangSeparatedKey(K, "kkey_colon", Slots["+;"], True, True),
			UseKey["Apostrophe"], (K) => LangSeparatedKey(K, "kkey_apostrophe", Slots["'"], True),
			"+" UseKey["Apostrophe"], (K) => LangSeparatedKey(K, "kkey_quotation", Slots["+'"], True, True),
			UseKey["LSquareBracket"], (K) => LangSeparatedKey(K, "kkey_l_square_bracket", Slots["["], True),
			"+" UseKey["LSquareBracket"], (K) => LangSeparatedKey(K, "kkey_l_curly_bracket", Slots["+["], True, True),
			UseKey["RSquareBracket"], (K) => LangSeparatedKey(K, "kkey_r_square_bracket", Slots["]"], True),
			"+" UseKey["RSquareBracket"], (K) => LangSeparatedKey(K, "kkey_r_curly_bracket", Slots["+]"], True, True),
			UseKey["Equals"], (K) => LangSeparatedKey(K, "kkey_equals", Slots["="], True),
			"+" UseKey["Equals"], (K) => LangSeparatedKey(K, "kkey_plus", Slots["+="], True, True),
			UseKey["Minus"], (K) => LangSeparatedKey(K, "kkey_hyphen_minus", Slots["-"], True),
			"+" UseKey["Minus"], (K) => LangSeparatedKey(K, "kkey_underscore", Slots["+-"], True, True),
			UseKey["Tilde"], (K) => LangSeparatedKey(K, "kkey_grave_accent", Slots["~"], True),
			"+" UseKey["Tilde"], (K) => LangSeparatedKey(K, "kkey_tilde", Slots["+~"], True, True),
			UseKey["Slash"], (K) => LangSeparatedKey(K, "kkey_slash", Slots["/"], True),
			"+" UseKey["Slash"], (K) => LangSeparatedKey(K, "question", Slots["+/"], True, True),
			UseKey["Backslash"], (K) => LangSeparatedKey(K, "kkey_backslash", Slots["\"], True),
			"+" UseKey["Backslash"], (K) => LangSeparatedKey(K, "kkey_verticalline", Slots["+\"], True, True),
		]
	} else if Combinations = "Cleanscript" {
		return [
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
			"<+" UseKey["9"], "Off",
			"<+" UseKey["0"], "Off",
			"<+" UseKey["Equals"], "Off",
		]
	} else if Combinations = "Supercript" {
		return [
			UseKey["1"], (K) => HandleFastKey(K, "num_sup_1"),
			UseKey["2"], (K) => HandleFastKey(K, "num_sup_2"),
			UseKey["3"], (K) => HandleFastKey(K, "num_sup_3"),
			UseKey["4"], (K) => HandleFastKey(K, "num_sup_4"),
			UseKey["5"], (K) => HandleFastKey(K, "num_sup_5"),
			UseKey["6"], (K) => HandleFastKey(K, "num_sup_6"),
			UseKey["7"], (K) => HandleFastKey(K, "num_sup_7"),
			UseKey["8"], (K) => HandleFastKey(K, "num_sup_8"),
			UseKey["9"], (K) => HandleFastKey(K, "num_sup_9"),
			UseKey["0"], (K) => HandleFastKey(K, "num_sup_0"),
			UseKey["Minus"], (K) => HandleFastKey(K, "num_sup_minus"),
			UseKey["Equals"], (K) => HandleFastKey(K, "num_sup_equals"),
			"<+" UseKey["9"], (K) => HandleFastKey(K, "num_sup_left_parenthesis"),
			"<+" UseKey["0"], (K) => HandleFastKey(K, "num_sup_right_parenthesis"),
			"<+" UseKey["Equals"], (K) => HandleFastKey(K, "num_sup_plus"),
		]
	} else if Combinations = "Subscript" {
		return [
			UseKey["1"], (K) => HandleFastKey(K, "num_sub_1"),
			UseKey["2"], (K) => HandleFastKey(K, "num_sub_2"),
			UseKey["3"], (K) => HandleFastKey(K, "num_sub_3"),
			UseKey["4"], (K) => HandleFastKey(K, "num_sub_4"),
			UseKey["5"], (K) => HandleFastKey(K, "num_sub_5"),
			UseKey["6"], (K) => HandleFastKey(K, "num_sub_6"),
			UseKey["7"], (K) => HandleFastKey(K, "num_sub_7"),
			UseKey["8"], (K) => HandleFastKey(K, "num_sub_8"),
			UseKey["9"], (K) => HandleFastKey(K, "num_sub_9"),
			UseKey["0"], (K) => HandleFastKey(K, "num_sub_0"),
			UseKey["Minus"], (K) => HandleFastKey(K, "num_sub_minus"),
			UseKey["Equals"], (K) => HandleFastKey(K, "num_sub_equals"),
			"<+" UseKey["9"], (K) => HandleFastKey(K, "num_sub_left_parenthesis"),
			"<+" UseKey["0"], (K) => HandleFastKey(K, "num_sub_right_parenthesis"),
			"<+" UseKey["Equals"], (K) => HandleFastKey(K, "num_sub_plus"),
		]
	} else if Combinations = "Utility" {
		return [
			"<#<!" UseKey["F1"], (*) => GroupActivator("Diacritics Primary", "F1"),
			"<#<!" UseKey["F2"], (*) => GroupActivator("Diacritics Secondary", "F2"),
			"<#<!" UseKey["F3"], (*) => GroupActivator("Diacritics Tertiary", "F3"),
			"<#<!" UseKey["F6"], (*) => GroupActivator("Diacritics Quatemary", "F6"),
			"<#<!" UseKey["F7"], (*) => GroupActivator("Special Characters", "F7"),
			"<#<!" UseKey["Space"], (*) => GroupActivator("Spaces"),
			"<#<!" UseKey["Minus"], (*) => GroupActivator("Dashes", "-"),
			"<#<!" UseKey["Apostrophe"], (*) => GroupActivator("Quotes", "'"),
			;
			"<#<!" UseKey["F"], (*) => SearchKey(),
			"<#<!" UseKey["U"], (*) => InsertUnicodeKey(),
			"<#<!" UseKey["A"], (*) => InsertAltCodeKey(),
			"<#<!" UseKey["L"], (*) => Ligaturise(),
			">+" UseKey["L"], (*) => Ligaturise("Clipboard"),
			">+" UseKey["Backspace"], (*) => Ligaturise("Backspace"),
			"<#<^>!" UseKey["1"], (*) => SwitchToScript("sup"),
			"<#<^>!" UseKey["2"], (*) => SwitchToScript("sub"),
			"<#<^>!" UseKey["3"], (*) => SwitchToRoman(),
			"<#<!" UseKey["M"], (*) => ToggleGroupMessage(),
			"<#<!" UseKey["PgUp"], (*) => FindCharacterPage(),
			"<#<!" UseKey["PgDn"], (*) => ReplaceWithUnicode(),
			"<#<+" UseKey["PgDn"], (*) => ReplaceWithUnicode("Hex"),
			"<#<!" UseKey["Home"], (*) => OpenPanel(),
			"<^>!>+" UseKey["F1"], (*) => ToggleInputMode(),
			"<^>!" UseKey["F1"], (*) => ToggleFastKeys(),
			">^" UseKey["F12"], (*) => SwitchQWERTY_YITSUKEN(),
			"<!" UseKey["Q"], (*) => LangSeparatedCall(
				() => QuotatizeSelection("Double"),
				() => QuotatizeSelection("France")),
			"<!<+" UseKey["Q"], (*) => LangSeparatedCall(
				() => QuotatizeSelection("Single"),
				() => QuotatizeSelection("Paw")),
			"<#<!" UseKey["NumpadEnter"], (*) => ParagraphizeSelection(),
			"<#<!" UseKey["NumpadDot"], (*) => GREPizeSelection(),
			"<^>!" UseKey["NumpadDot"], (*) => GREPizeSelection(True),
			"<#<!" UseKey["ArrUp"], (*) => ChangeScriptInput("sup"),
			"<#<!" UseKey["ArrDown"], (*) => ChangeScriptInput("sub"),
			">^" UseKey["1"], (*) => ToggleLetterScript(),
			;
			"RAlt", (*) => ProceedCompose(),
			"RCtrl", (*) => ProceedCombining(),
			;
			"<#<+" UseKey["PgUp"], (*) => SendCharToPy(),
			"<#<^<+" UseKey["PgUp"], (*) => SendCharToPy("Copy"),
		]
	}
}

RecoveryKey(KeySC, Shift := False) {
	KeySCCode := RegExReplace(LayoutsPresets[CheckQWERTY()][KeySC], "SC")

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
		Ligaturise("Compose")
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

RCtrlCount := 0
RCtrlTimerEnds := False
RCtrlTimer := ""

ProceedCombining() {
	global RCtrlTimerEnds, RCtrlCount, CombiningEnabled

	if (RCtrlTimerEnds) {
		return
	}

	if RCtrlCount = 1 {
		RCtrlCount := 0
		CombiningEnabled := !CombiningEnabled ? True : False
		if CombiningEnabled {
			ShowInfoMessage("message_combining", , , SkipGroupMessage, True)
		} else {
			ShowInfoMessage("message_combining_disabled", , , SkipGroupMessage, True)
		}
		return
	} else {
		RCtrlCount++
		RCtrlEndingTimer()
	}
}

RCtrlEndingTimer() {
	global RCtrlTimer
	if (RCtrlTimer != "") {
		SetTimer(RAltsSetStats, 0)
		RCtrlTimer := ""
	}

	return SetTimer(RAltsSetStats, -300)
}


RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))

ShowInfoMessage(MessagePost, MessageIcon := "Info", MessageTitle := DSLPadTitle, SkipMessage := False, Mute := False) {
	if SkipMessage == True
		return
	LanguageCode := GetLanguageCode()
	Muting := Mute ? " Mute" : ""
	Ico := MessageIcon == "Info" ? "Iconi" :
		MessageIcon == "Warning" ? "Icon!" :
			MessageIcon == "Error" ? "Iconx" : 0x0
	TrayTip(ReadLocale(MessagePost), MessageTitle, Ico . Muting)

}
TraySetIcon(AppIcoFile)
A_IconTip := DSLPadTitle
DSLTray := A_TrayMenu
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
	LanguageCode := GetLanguageCode()
	Labels := Map(
		"reload", ReadLocale("tray_func_reload"),
		"config", ReadLocale("tray_func_config"),
		"locale", ReadLocale("tray_func_locale"),
		"exit", ReadLocale("tray_func_exit") "`t" LeftControl "Esc",
		"panel", ReadLocale("tray_func_panel") "`t" Window LeftAlt "Home",
		"install", ReadLocale("tray_func_install"),
		"search", ReadLocale("tray_func_search") "`t" Window LeftAlt "F",
		"open_folder", ReadLocale("tray_func_open_folder"),
		"smelter", ReadLocale("tray_func_smelter") "`t" Window LeftAlt "L",
		"unicode", ReadLocale("tray_func_unicode") "`t" Window LeftAlt "U",
		"altcode", ReadLocale("tray_func_altcode") "`t" Window LeftAlt "A",
		"notif", ReadLocale("tray_func_notif") "`t" Window LeftAlt "M"
	)

	CurrentApp := "DSL KeyPad " . CurrentVersionString
	UpdateEntry := Labels["install"] . " " . UpdateVersionString

	DSLTray.Delete()
	DSLTray.Add(CurrentApp, (*) => {})
	if UpdateAvailable {
		DSLTray.Add(UpdateEntry, (*) => GetUpdate())
		DSLTray.SetIcon(UpdateEntry, ImageRes, 176)
	}
	DSLTray.Add()
	DSLTray.Add(Labels["panel"], OpenPanel)
	DSLTray.Add()
	DSLTray.Add(Labels["search"], (*) => SearchKey())
	DSLTray.Add(Labels["unicode"], (*) => InsertUnicodeKey())
	DSLTray.Add(Labels["altcode"], (*) => InsertAltCodeKey())
	DSLTray.Add(Labels["smelter"], (*) => Ligaturise())
	DSLTray.Add(Labels["open_folder"], OpenScriptFolder)
	DSLTray.Add()
	DSLTray.Add(Labels["notif"], (*) => ToggleGroupMessage())
	DSLTray.Add()
	DSLTray.Add(Labels["reload"], ReloadApplication)
	DSLTray.Add(Labels["config"], OpenConfigFile)
	DSLTray.Add(Labels["locale"], OpenLocalesFile)
	DSLTray.Add()
	DSLTray.Add(Labels["exit"], ExitApplication)
	DSLTray.Add()

	DSLTray.SetIcon(Labels["panel"], AppIcoFile)
	DSLTray.SetIcon(Labels["search"], ImageRes, 169)
	DSLTray.SetIcon(Labels["unicode"], Shell32, 225)
	DSLTray.SetIcon(Labels["altcode"], Shell32, 313)
	DSLTray.SetIcon(Labels["smelter"], ImageRes, 151)
	DSLTray.SetIcon(Labels["open_folder"], ImageRes, 180)
	DSLTray.SetIcon(Labels["notif"], ImageRes, 016)
	DSLTray.SetIcon(Labels["reload"], ImageRes, 229)
	DSLTray.SetIcon(Labels["config"], ImageRes, 065)
	DSLTray.SetIcon(Labels["locale"], ImageRes, 015)
	DSLTray.SetIcon(Labels["exit"], ImageRes, 085)
}

ManageTrayItems()

ShowInfoMessage("tray_app_started")

<^Esc:: ExitApp

SetPreviousLayout()

;! Third Party Functions
;{ [Function] GuiButtonIcon
;{
; Fanatic Guru
; Version 2023 04 08
;
; #Requires AutoHotkey v2.0.2+
;
; FUNCTION to Assign an Icon to a Gui Button
;
;------------------------------------------------
;
; Method:
;   GuiButtonIcon(Handle, File, Index, Options)
;
;   Parameters:
;   1) {Handle} 	HWND handle of Gui button or the Gui button object
;   2) {File} 		File containing icon image
;   3) {Index} 		Index of icon in file
;						Optional: Default = 1
;   4) {Options}	Single letter flag followed by a number with multiple options delimited by a space
;						W = Width of Icon (default = 16)
;						H = Height of Icon (default = 16)
;						S = Size of Icon, Makes Width and Height both equal to Size
;						L = Left Margin
;						T = Top Margin
;						R = Right Margin
;						B = Botton Margin
;						A = Alignment (0 = left, 1 = right, 2 = top, 3 = bottom, 4 = center; default = 4)
;
; Return:
;   1 = icon found, 0 = icon not found
;
; Example:
; MyGui := Gui()
; MyButton := MyGui.Add('Button', 'w70 h38', 'Save')
; GuiButtonIcon(MyButton, 'shell32.dll', 259, 's32 a1 r2')
; MyGui.Show
;}
GuiButtonIcon(Handle, File, Index := 1, Options := '') {
	RegExMatch(Options, 'i)w\K\d+', &W) ? W := W.0 : W := 16
	RegExMatch(Options, 'i)h\K\d+', &H) ? H := H.0 : H := 16
	RegExMatch(Options, 'i)s\K\d+', &S) ? W := H := S.0 : ''
	RegExMatch(Options, 'i)l\K\d+', &L) ? L := L.0 : L := 0
	RegExMatch(Options, 'i)t\K\d+', &T) ? T := T.0 : T := 0
	RegExMatch(Options, 'i)r\K\d+', &R) ? R := R.0 : R := 0
	RegExMatch(Options, 'i)b\K\d+', &B) ? B := B.0 : B := 0
	RegExMatch(Options, 'i)a\K\d+', &A) ? A := A.0 : A := 4
	W *= A_ScreenDPI / 96, H *= A_ScreenDPI / 96
	button_il := Buffer(20 + A_PtrSize)
	normal_il := DllCall('ImageList_Create', 'Int', W, 'Int', H, 'UInt', 0x21, 'Int', 1, 'Int', 1)
	NumPut('Ptr', normal_il, button_il, 0)			; Width & Height
	NumPut('UInt', L, button_il, 0 + A_PtrSize)		; Left Margin
	NumPut('UInt', T, button_il, 4 + A_PtrSize)		; Top Margin
	NumPut('UInt', R, button_il, 8 + A_PtrSize)		; Right Margin
	NumPut('UInt', B, button_il, 12 + A_PtrSize)	; Bottom Margin
	NumPut('UInt', A, button_il, 16 + A_PtrSize)	; Alignment
	SendMessage(BCM_SETIMAGELIST := 5634, 0, button_il, Handle)
	Return IL_Add(normal_il, File, Index)
}
;}
;
;? Special

;* Ultra Super Duper Puper Dev’s Secret Function
GetUnicodeName(Char) {
	Char := SubStr(Char, 1, 1)
	Python := ""
	Python .= "import unicodedata`n"
	Python .= "def get_unicode_name(char):`n"
	Python .= "    try:`n"
	Python .= "        return unicodedata.name(char)`n"
	Python .= "    except ValueError:`n"
	Python .= "        return 'Unknown character'`n`n"
	Python .= "with open('DSL_temp-uniName.txt', 'w') as f:`n"
	Python .= "    f.write(get_unicode_name('" Char "'))"

	FileAppend(Python, "DSL_temp-uniName.py", "UTF-8")
	Sleep 25

	RunWait("python DSL_temp-uniName.py", , "Hide")

	Sleep 25

	Result := FileRead("DSL_temp-uniName.txt", "UTF-8")

	Sleep 25

	FileDelete("DSL_temp-uniName.txt")
	FileDelete("DSL_temp-uniName.py")

	return Result
}

SendCharToPy(Mode := "") {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	Sleep 120
	PromptValue := A_Clipboard

	if (PromptValue != "") {
		PromptValue := GetUnicodeName(PromptValue)
		Sleep 50
		if (Mode == "Copy") {
			A_Clipboard := PromptValue
			return
		} else {
			SendText(PromptValue)
		}
	}

	A_Clipboard := BackupClipboard
}


;ApplicationEnd
