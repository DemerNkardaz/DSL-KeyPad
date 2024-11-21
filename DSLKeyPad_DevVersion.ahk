#Requires Autohotkey v2
#SingleInstance Force

; Only EN US & RU RU Keyboard Layout

Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })


SupportedLanguages := [
	"en",
	"ru",
]

CodeEn := "00000409"
CodeRu := "00000419"
CodeGr := "00000408"

CodeLang := Map(
	"en", "00000409",
	"ru", "00000419",
	"gr", "00000408")

CompareLangCode(CodeInput) {
	for lang, value in CodeLang {
		if (value = CodeInput) {
			return True
		}
	}
	return False
}

ChracterMap := "C:\Windows\System32\charmap.exe"
ImageRes := "C:\Windows\System32\imageres.dll"
Shell32 := "C:\Windows\SysWOW64\shell32.dll"

AppVersion := [0, 1, 1, 0]
CurrentVersionString := Format("{:d}.{:d}.{:d}", AppVersion[1], AppVersion[2], AppVersion[3])
UpdateVersionString := ""

RawRepo := "https://raw.githubusercontent.com/DemerNkardaz/DSL-KeyPad/main/"
RawRepoFiles := RawRepo . "UtilityFiles/"
RepoSource := "https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/DSLKeyPad.ahk"

RawSource := RawRepo "DSLKeyPad.ahk"
UpdateAvailable := False

ChangeLogRaw := Map(
	"ru", RawRepoFiles "DSLKeyPad.Changelog.ru.md",
	"en", RawRepoFiles "DSLKeyPad.Changelog.en.md"
)


WorkingDir := A_ScriptDir

ConfigFile := WorkingDir "\DSLKeyPad.config.ini"
ExecutableFile := WorkingDir "\DSLKeyPad.exe"

InternalFiles := Map(
	"Locales", { Repo: RawRepoFiles "DSLKeyPad.locales.ini", File: WorkingDir "\UtilityFiles\DSLKeyPad.locales.ini" },
	"AppIco", { Repo: RawRepoFiles "DSLKeyPad.app.ico", File: WorkingDir "\UtilityFiles\DSLKeyPad.app.ico" },
	"AppIcoDLL", { Repo: RawRepoFiles "DSLKeyPad_App_Icons.dll", File: WorkingDir "\UtilityFiles\DSLKeyPad_App_Icons.dll" },
	"HTMLEntities", { Repo: RawRepoFiles "entities_list.txt", File: WorkingDir "\UtilityFiles\entities_list.txt" },
	"AltCodes", { Repo: RawRepoFiles "alt_codes_list.txt", File: WorkingDir "\UtilityFiles\alt_codes_list.txt" },
	"Exe", { Repo: RawRepoFiles "DSLKeyPad.exe", File: WorkingDir "\DSLKeyPad.exe" },
)

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
				Error(ErrMessages[GetLanguageCode()])
			}
		}
	}
	return
}


TraySetIcon(InternalFiles["AppIcoDLL"].File, 1)

ReadLocale(EntryName, Prefix := "") {
	Section := Prefix != "" ? Prefix . "_" . GetLanguageCode() : GetLanguageCode()
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

SetStringVars(StringVar, SetVars*) {
	Result := StringVar
	for index, value in SetVars {
		Result := StrReplace(Result, "{" (index - 1) "}", value)
	}
	return Result
}


OpenConfigFile(*) {
	Run(ConfigFile)
}

OpenLocalesFile(*) {
	Run(InternalFiles["Locales"].File)
}

OpenRecipesFile(*) {
	Run(CustomComposeFile)
}

EscapePressed := False

FastKeysIsActive := False
SkipGroupMessage := False
GlagoFutharkActive := False
DisabledAllKeys := False
ActiveScriptName := ""
PreviousScriptName := ""
AlterationActiveName := ""
InputMode := "Default"
LaTeXMode := "Default"

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
	isSkipGroupMessage := IniRead(ConfigFile, "Settings", "SkipGroupMessage", "False")
	InputMode := IniRead(ConfigFile, "Settings", "InputMode", "Default")
	LaTeXMode := IniRead(ConfigFile, "Settings", "LaTeXInput", "Default")

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

PowerShell_UserSID() {
	GetScriptPath := A_ScriptDir "\DSL_temp-usrSID.ps1"
	GetTXTPath := A_ScriptDir "\DSL_temp-usrSID.txt"

	PShell := '$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()`n'
	PShell .= '$path = "' GetTXTPath '"`n'
	PShell .= '$id.User.Value | Out-File -FilePath $path -Encoding UTF8'

	try {
		FileAppend(PShell, GetScriptPath, "UTF-8")
		Sleep 25
		RunWait("powershell Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force; & " StrReplace(GetScriptPath, " ", "`` "), , "Hide")
		Sleep 25
		Result := FileRead(GetTXTPath, "UTF-8")
	} finally {
		FileDelete(GetTXTPath)
		FileDelete(GetScriptPath)
	}
	for replaces in [" ", "`n", "`r"] {
		Result := StrReplace(Result, replaces)
	}
	return Result
}

UserSID := PowerShell_UserSID()

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
			if UserSID != "" {
				RegPath := "HKEY_USERS\" UserSID "\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
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
Sleep 25
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

		GetUtilityFiles(True)

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

CyrllicLayouts := Map(
	"ЙЦУКЕН", Map(),
	"Диктор", Map(),
	"ЙІУКЕН (1907)", Map(),
)
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

RegisterLayout(LayoutName := "QWERTY", DefaultRule := "QWERTY", ForceApply := False) {
	global DisabledAllKeys, ActiveScriptName

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
for layout in LayoutsPresets {
	GetLayoutsList.Push(layout)
}

CyrillicLayoutsList := []
for layout in CyrllicLayouts {
	CyrillicLayoutsList.Push(layout)
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
MapInsert(MapObj, Pairs*) {
	keyCount := 0
	for index in MapObj {
		keyCount++
	}

	startNumber := keyCount + 1
	numberLength := 10

	for i, pair in Pairs {
		if (Mod(i, 2) == 1) {
			try {
				key := pair
				numberStr := "0" . startNumber
				while (StrLen(numberStr) < numberLength) {
					numberStr := "0" . numberStr
				}
				formattedKey := numberStr . " " . key
				startNumber++
			} catch {
				throw Error("Failed to format key: " i " ")
			}
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

MapMergeTo(TargetMap, MapObjects*) {
	for mapObj in MapObjects {
		if !IsObject(mapObj)
			continue
		for entry, value in mapObj {
			TargetMap[entry] := value
		}
	}
}

MapMerge(MapObjects*) {
	TempMap := Map()
	for mapObj in MapObjects {
		for entry, value in mapObj {
			TempMap[entry] := value
		}
	}
	return TempMap
}

ArrayMergeTo(TargetArray, Arrays*) {
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			TargetArray.Push(element)
		}
	}
}

ArrayMerge(Arrays*) {
	TempArray := []
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			TempArray.Push(element)
		}
	}
	return TempArray
}

GetMapCount(MapObj, SortGroups := "") {
	properties := ["combining", "modifier", "subscript", "italic", "italicBold", "bold", "script", "fraktur", "scriptBold", "frakturBold", "doubleStruck", "doubleStruckBold", "doubleStruckItalic", "doubleStruckItalicBold", "sansSerif", "sansSerifItalic", "sansSerifItalicBold", "sansSerifBold", "monospace"]
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
			if InsertingOption = "Alternative Layout" && HasProp(value, "alt_layout_title") && value.alt_layout_title && !InStr(ReadLocale(entryName "_layout", "chars"), "NOT FOUND") {
				characterTitle := ReadLocale(entryName "_layout", "chars")
			} else if !InStr(ReadLocale(entryName, "chars"), "NOT FOUND") {
				characterTitle := ReadLocale(entryName, "chars")
			} else if (HasProp(value, "titles")) {
				characterTitle := value.titles[LanguageCode]
			} else {
				characterTitle := ReadLocale(entryName, "chars")
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
					characterBinding := FormatHotKey(value.group[2], characterModifier)
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

LocalEntitiesLibrary := FillCodesFromFile()
LocalAltCodesLibrary := FillCodesFromFile(InternalFiles["AltCodes"].File)

FillCodesFromFile(FilePath := InternalFiles["HTMLEntities"].File) {
	TempArray := []
	EntitiesList := FileRead(FilePath, "UTF-8")

	for line in StrSplit(EntitiesList, "`n") {
		RegExMatch(line, '^(.+)\t(.+)', &match)
		EntityCode := Format("0x{1}", match[1])
		EntityName := FilePath = InternalFiles["AltCodes"].File ? match[2] : "&" match[2] ";"
		TempArray.Push(Chr(EntityCode), EntityName)

	}

	return TempArray
}


Characters := Map(
	"", {
		unicode: "", html: "",
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
		unicode: "{U+0301}", LaTeX: ["\'", "\acute"],
		tags: ["acute", "акут", "ударение"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["a", "ф"]],
		show_on_fast_keys: True,
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"acute_double", {
		unicode: "{U+030B}", LaTeX: "\H",
		tags: ["double acute", "двойной акут", "двойное ударение"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["A", "Ф"]],
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"acute_below", {
		unicode: "{U+0317}",
		tags: ["acute below", "акут снизу"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["a", "ф"]],
		symbolClass: "Diacritic Mark",
		modifier: RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"acute_tone_vietnamese", {
		unicode: "{U+0341}",
		tags: ["acute tone", "акут тона"],
		group: ["Diacritics Secondary", ["A", "Ф"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"asterisk_above", {
		unicode: "{U+20F0}",
		tags: ["asterisk above", "астериск сверху"],
		group: ["Diacritics Tertiary", ["a", "ф"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"asterisk_below", {
		unicode: "{U+0359}",
		tags: ["asterisk below", "астериск снизу"],
		group: ["Diacritics Tertiary", ["A", "Ф"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"breve", {
		unicode: "{U+0306}",
		LaTeX: ["\u", "\breve"],
		tags: ["breve", "бреве", "кратка"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["b", "и"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"breve_inverted", {
		unicode: "{U+0311}",
		tags: ["inverted breve", "перевёрнутое бреве", "перевёрнутая кратка"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["B", "И"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"breve_below", {
		unicode: "{U+032E}",
		tags: ["breve below", "бреве снизу", "кратка снизу"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["b", "и"]],
		symbolClass: "Diacritic Mark",
		modifier: RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"breve_inverted_below", {
		unicode: "{U+032F}",
		tags: ["inverted breve below", "перевёрнутое бреве снизу", "перевёрнутая кратка снизу"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["B", "И"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"bridge_above", {
		unicode: "{U+0346}",
		tags: ["bridge above", "мостик сверху"],
		group: ["Diacritics Tertiary", ["b", "и"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"bridge_below", {
		unicode: "{U+032A}",
		tags: ["bridge below", "мостик снизу"],
		group: ["Diacritics Tertiary", ["B", "И"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"bridge_inverted_below", {
		unicode: "{U+033A}",
		tags: ["inverted bridge below", "перевёрнутый мостик снизу"],
		group: ["Diacritics Tertiary", CtrlB],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"circumflex", {
		unicode: "{U+0302}",
		LaTeX: ["\^", "\hat"],
		tags: ["circumflex", "циркумфлекс"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["c", "с"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"caron", {
		unicode: "{U+030C}", LaTeX: ["\v", "\check"],
		tags: ["caron", "hachek", "карон", "гачек"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["C", "С"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"circumflex_below", {
		unicode: "{U+032D}",
		tags: ["circumflex below", "циркумфлекс снизу"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["c", "с"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"caron_below", {
		unicode: "{U+032C}",
		tags: ["caron below", "карон снизу", "гачек снизу"],
		group: ["Diacritics Secondary", ["C", "С"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"cedilla", {
		unicode: "{U+0327}", LaTeX: "\c",
		tags: ["cedilla", "седиль"],
		group: [["Diacritics Tertiary", "Diacritics Fast Primary"], ["c", "с"]],
		symbolClass: "Diacritic Mark",
		modifier: RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"comma_above", {
		unicode: "{U+0313}",
		tags: ["comma above", "запятая сверху"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], [",", "б"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"comma_below", {
		unicode: "{U+0326}",
		tags: ["comma below", "запятая снизу"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["<", "Б"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"comma_above_turned", {
		unicode: "{U+0312}",
		tags: ["turned comma above", "перевёрнутая запятая сверху"],
		group: ["Diacritics Secondary", [",", "б"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"comma_above_reversed", {
		unicode: "{U+0314}",
		tags: ["reversed comma above", "зеркальная запятая сверху"],
		group: [["Diacritics Secondary", "Diacritics Fast Secondary"], ["<", "Б"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"comma_above_right", {
		unicode: "{U+0315}",
		tags: ["comma above right", "запятая сверху справа"],
		group: [["Diacritics Tertiary", "Diacritics Fast Secondary"], [",", "б"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"candrabindu", {
		unicode: "{U+0310}",
		tags: ["candrabindu", "карон снизу"],
		group: ["Diacritics Tertiary", ["C", "С"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"dot_above", {
		unicode: "{U+0307}",
		LaTeX: ["\.", "\dot"],
		tags: ["dot above", "точка сверху"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["d", "в"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"diaeresis", {
		unicode: "{U+0308}",
		LaTeX: ["\" QuotationDouble, "\ddot"],
		tags: ["diaeresis", "диерезис"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["D", "В"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"dot_below", {
		unicode: "{U+0323}", LaTeX: "\d",
		tags: ["dot below", "точка снизу"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["d", "в"]],
		symbolClass: "Diacritic Mark",
		modifier: RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"diaeresis_below", {
		unicode: "{U+0324}",
		tags: ["diaeresis below", "диерезис снизу"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["D", "В"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"fermata", {
		unicode: "{U+0352}",
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
		unicode: "{U+0300}",
		LaTeX: ["\" . Backquote, "\grave"],
		tags: ["grave", "гравис"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["g", "п"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"grave_double", {
		unicode: "{U+030F}",
		tags: ["double grave", "двойной гравис"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["G", "П"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"grave_below", {
		unicode: "{U+0316}",
		tags: ["grave below", "гравис снизу"],
		group: ["Diacritics Secondary", ["g", "п"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"grave_tone_vietnamese", {
		unicode: "{U+0340}",
		tags: ["grave tone", "гравис тона"],
		group: ["Diacritics Secondary", ["G", "П"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"hook_above", {
		unicode: "{U+0309}",
		tags: ["hook above", "хвостик сверху"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["h", "р"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"horn", {
		unicode: "{U+031B}",
		tags: ["horn", "рожок"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["H", "Р"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"palatal_hook_below", {
		unicode: "{U+0321}",
		tags: ["palatal hook below", "палатальный крюк"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["h", "р"]],
		symbolClass: "Diacritic Mark",
		modifier: RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"retroflex_hook_below", {
		unicode: "{U+0322}",
		tags: ["retroflex hook below", "ретрофлексный крюк"],
		group: [["Diacritics Secondary", "Diacritics Fast Primary"], ["H", "Р"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift RightShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	;
	"macron", {
		unicode: "{U+0304}", LaTeX: ["\=", "\bar"],
		tags: ["macron", "макрон"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["m", "ь"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"macron_below", {
		unicode: "{U+0331}",
		tags: ["macron below", "макрон снизу"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["M", "Ь"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"ogonek", {
		unicode: "{U+0328}", LaTeX: "\k",
		tags: ["ogonek", "огонэк"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["o", "щ"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"ogonek_above", {
		unicode: "{U+1DCE}",
		tags: ["ogonek above", "огонэк сверху"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["O", "Щ"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
	},
	"overline", {
		unicode: "{U+0305}",
		tags: ["overline", "черта сверху"],
		group: ["Diacritics Secondary", ["o", "щ"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"overline_double", {
		unicode: "{U+033F}",
		tags: ["overline", "черта сверху"],
		group: ["Diacritics Secondary", ["O", "Щ"]],
		symbolClass: "Diacritic Mark",
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"low_line", {
		unicode: "{U+0332}",
		tags: ["low line", "черта снизу"],
		group: ["Diacritics Tertiary", ["o", "щ"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"low_line_double", {
		unicode: "{U+0333}",
		tags: ["dobule low line", "двойная черта снизу"],
		group: ["Diacritics Tertiary", ["O", "Щ"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"ring_above", {
		unicode: "{U+030A}",
		tags: ["ring above", "кольцо сверху"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["r", "к"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"ring_below", {
		unicode: "{U+0325}",
		tags: ["ring below", "кольцо снизу"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["R", "К"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"ring_below_double", {
		unicode: "{U+035A}",
		tags: ["double ring below", "двойное кольцо снизу"],
		group: ["Diacritics Primary", CtrlR],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"line_vertical", {
		unicode: "{U+030D}",
		tags: ["vertical line", "вертикальная черта"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["v", "м"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"line_vertical_double", {
		unicode: "{U+030E}",
		tags: ["double vertical line", "двойная вертикальная черта"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["V", "М"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"line_vertical_below", {
		unicode: "{U+0329}",
		tags: ["vertical line below", "вертикальная черта снизу"],
		group: ["Diacritics Secondary", ["v", "м"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"line_vertical_double_below", {
		unicode: "{U+0348}",
		tags: ["dobule vertical line below", "двойная вертикальная черта снизу"],
		group: ["Diacritics Secondary", ["V", "М"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"stroke_short", {
		unicode: "{U+0335}",
		tags: ["short stroke", "короткое перечёркивание"],
		group: [["Diacritics Quatemary", "Diacritics Fast Primary"], ["s", "ы"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"stroke_long", {
		unicode: "{U+0336}",
		tags: ["long stroke", "длинное перечёркивание"],
		group: [["Diacritics Quatemary", "Diacritics Fast Primary"], ["S", "Ы"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"solidus_short", {
		unicode: "{U+0337}",
		tags: ["short solidus", "короткая косая черта"],
		group: [["Diacritics Quatemary", "Diacritics Fast Primary"], "\"],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		alt_on_fast_keys: "[/]",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"solidus_long", {
		unicode: "{U+0338}",
		tags: ["long solidus", "длинная косая черта"],
		group: [["Diacritics Quatemary", "Diacritics Fast Primary"], "/"],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"tilde", {
		unicode: "{U+0303}", LaTeX: ["\~", "\tilde"],
		tags: ["tilde", "тильда"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["t", "е"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"tilde_vertical", {
		unicode: "{U+033E}",
		tags: ["tilde vertical", "вертикальная тильда"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["T", "Е"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"tilde_below", {
		unicode: "{U+0330}",
		tags: ["tilde below", "тильда снизу"],
		group: ["Diacritics Secondary", ["t", "е"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"tilde_not", {
		unicode: "{U+034A}",
		tags: ["not tilde", "перечёрнутая тильда"],
		group: ["Diacritics Secondary", ["T", "Е"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"tilde_overlay", {
		unicode: "{U+0334}",
		tags: ["tilde overlay", "тильда посередине"],
		group: ["Diacritics Quatemary", ["t", "е"]],
		symbolClass: "Diacritic Mark",
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"x_above", {
		unicode: "{U+033D}",
		tags: ["x above", "x сверху"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["x", "ч"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"x_below", {
		unicode: "{U+0353}",
		tags: ["x below", "x снизу"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["X", "Ч"]],
		symbolClass: "Diacritic Mark",
		modifier: LeftShift,
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	"zigzag_above", {
		unicode: "{U+035B}",
		tags: ["zigzag above", "зигзаг сверху"],
		group: [["Diacritics Primary", "Diacritics Fast Primary"], ["z", "я"]],
		symbolClass: "Diacritic Mark",
		show_on_fast_keys: True,
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
	;
	"cyr_com_vzmet", {
		unicode: "{U+A66F}",
		group: [["Diacritics Primary", "Cyrillic Diacritics"], CtrlD],
		alt_layout: "<^<! [в]",
		tags: ["взмет кириллицы", "cyrillic vzmet"],
		symbolClass: "Diacritic Mark",
	},
	"cyr_com_titlo", {
		unicode: "{U+0483}",
		group: [["Diacritics Primary", "Cyrillic Diacritics"], ["n", "т"]],
		alt_layout: "<^<! [т]",
		tags: ["титло кириллицы", "cyrillic titlo"],
		symbolClass: "Diacritic Mark",
	},
	"cyr_com_palatalization", {
		unicode: "{U+0484}",
		group: [["Diacritics Tertiary", "Cyrillic Diacritics"], ["g", "п"]],
		alt_layout: "<^<! [п]",
		tags: ["палатализация кириллицы", "cyrillic palatalization"],
		symbolClass: "Diacritic Mark",
	},
	"cyr_com_pokrytie", {
		unicode: "{U+0487}",
		group: [["Diacritics Tertiary", "Cyrillic Diacritics"], ["G", "П"]],
		alt_layout: "<^<!<+ [g][п]",
		tags: ["покрытие кириллицы", "cyrillic pokrytie"],
		symbolClass: "Diacritic Mark",
	},
	"cyr_com_dasia_pneumata", {
		unicode: "{U+0485}",
		group: [["Diacritics Quatemary", "Cyrillic Diacritics", "Diacritics Fast Primary"], ["g", "п"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [g][п]",
		alt_layout: "<^<!>+ [п]",
		tags: ["густое придыхание кириллицы", "cyrillic dasia pneumata"],
		symbolClass: "Diacritic Mark",
	},
	"cyr_com_psili_pneumata", {
		unicode: "{U+0486}",
		group: [["Diacritics Quatemary", "Cyrillic Diacritics", "Diacritics Fast Primary"], ["G", "П"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [п]",
		alt_layout: "<^<!<+>+ [п]",
		tags: ["тонкое придыхание кириллицы", "cyrillic psili pneumata"],
		symbolClass: "Diacritic Mark",
	},
	;
	;
	; ? Шпации
	"space", {
		unicode: "{U+0020}",
		symbolClass: "Spaces",
	},
	"emsp", {
		unicode: "{U+2003}",
		tags: ["em space", "emspace", "emsp", "круглая шпация"],
		group: ["Spaces", "1"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [Space]",
		symbolAlt: Chr(0x2003),
	},
	"ensp", {
		unicode: "{U+2002}",
		tags: ["en space", "enspace", "ensp", "полукруглая шпация"],
		group: ["Spaces", "2"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Space]",
		symbolAlt: Chr(0x2002),
	},
	"emsp13", {
		unicode: "{U+2004}",
		tags: ["emsp13", "1/3emsp", "1/3 круглой Шпации"],
		group: [["Spaces", "Spaces Left Alt"], "3"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Space]",
		symbolAlt: Chr(0x2004),
	},
	"emsp14", {
		unicode: "{U+2005}",
		tags: ["emsp14", "1/4emsp", "1/4 круглой Шпации"],
		group: [["Spaces", "Spaces Left Shift"], "4"],
		symbolClass: "Spaces",
		show_on_fast_keys: False,
		alt_on_fast_keys: "[Space]",
		symbolAlt: Chr(0x2005),
	},
	"thinspace", {
		unicode: "{U+2009}",
		tags: ["thinsp", "thin space", "узкий пробел", "тонкий пробел"],
		group: ["Spaces", "5"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! [Space]",
		symbolAlt: Chr(0x2009),
	},
	"emsp16", {
		unicode: "{U+2006}",
		tags: ["emsp16", "1/6emsp", "1/6 круглой Шпации"],
		group: [["Spaces", "Spaces Right Shift"], "6"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Space]",
		symbolAlt: Chr(0x2006),
	},
	"narrow_no_break_space", {
		unicode: "{U+202F}", LaTeX: "\,",
		tags: ["nnbsp", "narrow no-break space", "узкий неразрывный пробел", "тонкий неразрывный пробел"],
		group: [["Spaces", "Spaces Right Shift"], "7"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Space]",
		symbolAlt: Chr(0x202F),
	},
	"hairspace", {
		unicode: "{U+200A}",
		tags: ["hsp", "hairsp", "hair space", "волосяная шпация"],
		group: ["Spaces", "8"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ [Space]",
		symbolAlt: Chr(0x200A),
	},
	"punctuation_space", {
		unicode: "{U+2008}",
		tags: ["psp", "puncsp", "punctuation space", "пунктуационный пробел"],
		group: ["Spaces", "9"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ [Space]",
		symbolAlt: Chr(0x2008),
	},
	"zero_width_space", {
		unicode: "{U+200B}",
		tags: ["zwsp", "zero-width space", "пробел нулевой ширины"],
		group: ["Spaces", "0"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ [Space]",
		symbolAlt: Chr(0x200B),
	},
	"word_joiner", {
		unicode: "{U+2060}",
		tags: ["wj", "word joiner", "соединитель слов"],
		group: ["Spaces", "-"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Tab]",
		symbolAlt: Chr(0x2060),
	},
	"figure_space", {
		unicode: "{U+2007}",
		tags: ["nsp", "numsp", "figure space", "цифровой пробел"],
		group: ["Spaces", "="],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [Space]",
		symbolAlt: Chr(0x2007),
	},
	"no_break_space", {
		unicode: "{U+00A0}",
		LaTeX: "~",
		tags: ["nbsp", "no-break space", "неразрывный пробел"],
		group: ["Spaces", SpaceKey],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		symbolAlt: Chr(0x00A0),
	},
	"medium_math_space", {
		unicode: "{U+205F}",
		tags: ["mmsp", "mathsp", "medium math space", "средний математический пробел"],
		group: ["Math Spaces"],
		symbolClass: "Spaces",
		alt_layout: "<! [Space]",
		symbolAlt: Chr(0x205F),
	},
	"tabulation", {
		unicode: "{U+0009}",
		tags: ["tab", "tabulation", "табуляция"],
		group: ["Spaces"],
		symbolClass: "Spaces",
		symbolAlt: Chr(0x0009),
	},
	"emquad", {
		unicode: "{U+2001}",
		LaTeX: "\qquad",
		tags: ["em quad", "emquad", "emqd", "em-квадрат"],
		group: ["Spaces", ExclamationMark],
		symbolClass: "Spaces",
		symbolAlt: Chr(0x2001),
	},
	"enquad", {
		unicode: "{U+2000}",
		LaTeX: "\quad",
		tags: ["en quad", "enquad", "enqd", "en-квадрат"],
		group: ["Spaces", [CommercialAt, QuotationDouble]],
		symbolClass: "Spaces",
		symbolAlt: Chr(0x2000),
	},
	"zero_width_joiner", {
		unicode: "{U+200D}",
		tags: ["zwj", "zero-width joiner", "соединитель нулевой ширины"],
		group: ["Format Characters", "Tab"],
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		symbolAlt: Chr(0x200D),
	},
	"zero_width_non_joiner", {
		unicode: "{U+200C}",
		tags: ["zwj", "zero-width non-joiner", "разъединитель нулевой ширины"],
		group: ["Format Characters", "Tab"],
		modifier: RightShift,
		symbolClass: "Spaces",
		show_on_fast_keys: True,
		symbolAlt: Chr(0x200C),
	},
	;
	;
	; ? Sys Group
	"carriage_return", {
		unicode: "{U+000D}",
		tags: ["carriage return", "возврат каретки"],
		group: ["Sys Group"],
		show_on_fast_keys: True,
		symbolAlt: Chr(0x21B5),
	},
	"new_line", {
		unicode: "{U+000A}",
		tags: ["new line", "перевод строки"],
		group: ["Sys Group"],
		show_on_fast_keys: True,
		symbolAlt: Chr(0x21B4),
	},
	;
	;
	; ? Special Characters
	"arrow_left", {
		unicode: "{U+2190}",
		tags: ["left arrow", "стрелка влево"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2190) "]",
		recipe: "<-",
	},
	"arrow_right", {
		unicode: "{U+2192}",
		tags: ["right arrow", "стрелка вправо"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2192) "]",
		recipe: "->",
	},
	"arrow_up", {
		unicode: "{U+2191}",
		tags: ["up arrow", "стрелка вверх"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2191) "]",
	},
	"arrow_down", {
		unicode: "{U+2193}",
		tags: ["down arrow", "стрелка вниз"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2193) "]",
	},
	"arrow_leftup", {
		unicode: "{U+2196}",
		tags: ["left up arrow", "стрелка влево-вверх"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2191) "][" Chr(0x2190) "]",
	},
	"arrow_rightup", {
		unicode: "{U+2197}",
		tags: ["right up arrow", "стрелка вправо-вверх"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2191) "][" Chr(0x2192) "]",
	},
	"arrow_leftdown", {
		unicode: "{U+2199}",
		tags: ["left down arrow", "стрелка влево-вниз"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2193) "][" Chr(0x2190) "]",
	},
	"arrow_rightdown", {
		unicode: "{U+2198}",
		tags: ["right down arrow", "стрелка вправо-вниз"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2193) "][" Chr(0x2192) "]",
	},
	"arrow_leftright", {
		unicode: "{U+2194}",
		tags: ["right down arrow", "стрелка вправо-вниз"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2190) "][" Chr(0x2192) "]",
	},
	"arrow_updown", {
		unicode: "{U+2195}",
		tags: ["right down arrow", "стрелка вправо-вниз"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[" Chr(0x2191) "][" Chr(0x2193) "]",
	},
	"arrow_left_circle", {
		unicode: "{U+21BA}",
		tags: ["left circle arrow", "округлая стрелка влево"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [" Chr(0x2190) "]",
	},
	"arrow_right_circle", {
		unicode: "{U+21BB}",
		tags: ["right circle arrow", "округлая стрелка вправо"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [" Chr(0x2192) "]",
	},
	"arrow_left_ushaped", {
		unicode: "{U+2B8C}",
		tags: ["left u-arrow", "u-образная стрелка влево"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [" Chr(0x2190) "]",
	},
	"arrow_right_ushaped", {
		unicode: "{U+2B8E}",
		tags: ["right u-arrow", "u-образная стрелка вправо"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [" Chr(0x2192) "]",
	},
	"arrow_up_ushaped", {
		unicode: "{U+2B8D}",
		tags: ["up u-arrow", "u-образная стрелка вверх"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [" Chr(0x2190) "]",
	},
	"arrow_down_ushaped", {
		unicode: "{U+2B8F}",
		tags: ["down u-arrow", "u-образная стрелка вниз"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [" Chr(0x2192) "]",
	},
	"asterisk_low", {
		unicode: "{U+204E}",
		tags: ["low asterisk", "нижний астериск"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], ["a", "ф"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Num*]",
		recipe: "*",
	},
	"asterisk_two", {
		unicode: "{U+2051}",
		tags: ["two asterisks", "два астериска"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], ["A", "Ф"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num*]",
		recipe: ["**", "2*"],
	},
	"asterism", {
		unicode: "{U+2042}",
		tags: ["asterism", "астеризм"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], CtrlA],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [Num*]",
		recipe: ["***", "3*"],
	},
	"bullet", {
		unicode: "{U+2022}",
		tags: ["bullet", "булит"],
		group: [["Special Characters", "Special Fast Secondary"], Backquote],
		show_on_fast_keys: True,
	},
	"bullet_hyphen", {
		unicode: "{U+2043}",
		tags: ["hyphen bullet", "чёрточный булит"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! [" Backquote "]",
	},
	"interpunct", {
		unicode: "{U+00B7}",
		tags: ["middle dot", "точка по центру", "интерпункт"],
		group: [["Special Characters", "Special Fast Secondary"], '~'],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [" Backquote "]",
	},
	"bullet_white", {
		unicode: "{U+25E6}",
		tags: ["white bullet", "прозрачный булит"],
		group: [["Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ [" Backquote "]",
	},
	"bullet_triangle", {
		unicode: "{U+2023}",
		tags: ["triangular bullet", "треугольный булит"],
		group: [["Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ [" Backquote "]",
	},
	"hyphenation_point", {
		unicode: "{U+2027}",
		tags: ["hyphenation point", "точка переноса"],
		group: [["Special Characters", "Special Fast Secondary"], "-"],
		modifier: RightShift,
		show_on_fast_keys: True,
	},
	"colon_triangle", {
		unicode: "{U+02D0}",
		tags: ["triangle colon", "знак долготы"],
		group: [["Special Characters", "IPA"], [";", "ж"]],
		alt_layout: "[;]",
	},
	"colon_triangle_half", {
		unicode: "{U+02D1}",
		tags: ["half triangle colon", "знак полудолготы"],
		group: [["Special Characters", "IPA"], [":", "Ж"]],
		alt_layout: ">! [;]",
	},
	"degree", {
		unicode: "{U+00B0}",
		tags: ["degree", "градус"],
		group: [["Special Characters", "Special Fast Left"], ["d", "в"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[D]",
	},
	"celsius", {
		unicode: "{U+2103}",
		tags: ["celsius", "градус Цельсия"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: Chr(0x00B0) . "C",
	},
	"fahrenheit", {
		unicode: "{U+2109}",
		tags: ["fahrenheit", "градус по Фаренгейту"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: Chr(0x00B0) . "F",
	},
	"kelvin", {
		unicode: "{U+212A}",
		tags: ["kelvin", "Кельвин"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: Chr(0x00B0) . "K",
	},
	"rankine", {
		calcOff: "",
		unicode: "{U+0052}",
		uniSequence: ["{U+00B0}", "{U+0052}"],
	},
	"newton", {
		calcOff: "",
		unicode: "{U+004E}",
		uniSequence: ["{U+00B0}", "{U+004E}"],
	},
	"delisle", {
		calcOff: "",
		unicode: "{U+0044}",
		uniSequence: ["{U+00B0}", "{U+0044}"],
	},
	"dagger", {
		unicode: "{U+2020}",
		LaTeX: "\dagger",
		tags: ["dagger", "даггер", "крест"],
		group: [["Special Characters", "Special Fast Secondary"], ["t", "е"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num/]",
	},
	"dagger_double", {
		unicode: "{U+2021}",
		LaTeX: "\ddagger",
		tags: ["double dagger", "двойной даггер", "двойной крест"],
		group: [["Special Characters", "Special Fast Secondary"], ["T", "Е"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [Num/]",
	},
	"dagger_tripple", {
		unicode: "{U+2E4B}",
		tags: ["tripple dagger", "тройной даггер", "тройной крест"],
		group: ["Special Characters", CtrlT],
	},
	"fraction_slash", {
		unicode: "{U+2044}",
		tags: ["fraction slash", "дробная черта"],
		group: [["Special Characters", "Special Fast Secondary"], "/"],
		modifier: RightShift,
		show_on_fast_keys: True,
	},
	"grapheme_joiner", {
		unicode: "{U+034F}",
		tags: ["grapheme joiner", "соединитель графем"],
		group: ["Special Characters", ["g", "п"]],
	},
	"infinity", {
		unicode: "{U+221E}",
		tags: ["fraction slash", "дробная черта"],
		group: [["Special Characters", "Special Fast Secondary"], "9"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! [8]",
	},
	"asterisk_operator", {
		unicode: "{U+2217}",
		tags: ["оператор астериск", "asterisk operator"],
		group: [["Special Characters", "Smelting Special", "Special Fast"]],
		show_on_fast_keys: True,
		alt_special: "<^<! [Num/]",
		recipe: "^*",
	},
	"bullet_operator", {
		unicode: "{U+2219}",
		tags: ["оператор буллит", "bullet operator"],
		group: [["Special Characters", "Smelting Special", "Special Fast"]],
		show_on_fast_keys: True,
		alt_special: "<^<!<+ [Num/]",
		recipe: "^.",
	},
	"multiplication", {
		unicode: "{U+00D7}",
		tags: ["multiplication", "умножение"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "8"],
		show_on_fast_keys: True,
		alt_special: "[Num*]",
		recipe: "-x",
	},
	"division", {
		unicode: "{U+00F7}",
		tags: ["деление", "обелюс", "division", "obelus"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "4"],
		show_on_fast_keys: True,
		alt_special: "[Num/]",
		recipe: ["-:", Chr(0x2212) ":"],
	},
	"division_times", {
		unicode: "{U+22C7}",
		tags: ["кратность деления", "division times"],
		group: [["Special Characters", "Smelting Special", "Special Fast"]],
		show_on_fast_keys: True,
		alt_special: "[Num/] [Num*]",
		recipe: ["-:x", Chr(0x2212) ":" Chr(0x00D7), Chr(0x00F7) Chr(0x00D7)],
	},
	"empty_set", {
		unicode: "{U+2205}",
		tags: ["пустое множество", "empty set"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num0]",
		recipe: "0/",
	},
	"prime_single", {
		unicode: "{U+2032}",
		LaTeX: "\prime",
		tags: ["prime", "штрих"],
		group: [["Special Characters", "Special Fast Secondary"], ["p", "з"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[3]",
	},
	"prime_double", {
		unicode: "{U+2033}",
		LaTeX: "\prime\prime",
		tags: ["double prime", "двойной штрих"],
		group: [["Smelting Special", "Special Characters", "Special Fast Secondary"], ["P", "З"]],
		modifier: RightShift,
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [3]",
		recipe: Chr(0x2032) Chr(0x2032),
	},
	"prime_triple", {
		unicode: "{U+2034}",
		LaTeX: "\prime\prime\prime",
		tags: ["triple prime", "тройной штрих"],
		group: [["Smelting Special", "Special Characters", "Special Fast Secondary"], CtrlP],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [3]",
		recipe: Chr(0x2032) Chr(0x2032) Chr(0x2032),
	},
	"prime_quadruple", {
		unicode: "{U+2057}",
		LaTeX: "\prime\prime\prime\prime",
		tags: ["quadruple prime", "четверной штрих"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [3]",
		recipe: Chr(0x2032) Chr(0x2032) Chr(0x2032) Chr(0x2032),
	},
	"prime_reversed_single", {
		unicode: "{U+2035}",
		tags: ["reversed prime", "обратный штрих"],
		group: [["Special Characters", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [3]",
	},
	"prime_reversed_double", {
		unicode: "{U+2036}",
		tags: ["reversed double prime", "обратный двойной штрих"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		modifier: RightShift,
		show_on_fast_keys: True,
		alt_on_fast_keys: "c*>+ [3]",
		recipe: Chr(0x2035) Chr(0x2035),
	},
	"prime_reversed_triple", {
		unicode: "{U+2037}",
		tags: ["reversed triple prime", "обратный тройной штрих"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c*<+ [3]",
		recipe: Chr(0x2035) Chr(0x2035) Chr(0x2035),
	},
	"permille", {
		unicode: "{U+2030}",
		LaTeX: "\permil",
		LaTeXPackage: "wasysym",
		tags: ["per mille", "промилле"],
		group: [["Special Characters", "Special Fast Secondary"], "5"],
		show_on_fast_keys: True,
	},
	"pertenthousand", {
		unicode: "{U+2031}",
		LaTeX: "\textpertenthousand",
		LaTeXPackage: "textcomp",
		tags: ["per ten thousand", "промилле", "базисный пункт", "basis point"],
		group: [["Special Characters", "Special Fast Secondary"], "%"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [5]",
		symbolCustom: "s40"
	},
	"section", {
		unicode: "{U+00A7}", LaTeX: "\S",
		tags: ["section", "параграф"],
		group: [["Special Characters", "Special Fast Left"], ["s", "с"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[1]",
	},
	"noequals", {
		unicode: "{U+2260}",
		tags: ["no equals", "не равно"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "="],
		show_on_fast_keys: True,
		alt_special: "[/=]",
		recipe: "/=",
	},
	"almostequals", {
		unicode: "{U+2248}",
		tags: ["almost equals", "примерно равно"],
		group: [["Smelting Special", "Special Fast Secondary", "Special Fast"], "="],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [=]",
		alt_special: "[``=]",
		recipe: "~=",
	},
	"less_or_equals", {
		unicode: "{U+2264}",
		tags: ["less than or equals", "меньше или равно"],
		group: [["Smelting Special", "Math"]],
		alt_layout: ">+ [<]",
		recipe: "<=",
	},
	"greater_or_equals", {
		unicode: "{U+2265}",
		tags: ["greater than or equals", "больше или равно"],
		group: [["Smelting Special", "Math"]],
		alt_layout: ">+ [>]",
		recipe: ">=",
	},
	"neither_less_nor_equals", {
		unicode: "{U+2270}",
		tags: ["neither less than nor equals", "ни меньше ни равно"],
		group: [["Smelting Special"]],
		recipe: "/<=",
	},
	"neither_greater_nor_equals", {
		unicode: "{U+2271}",
		tags: ["neither greater than nor equals", "ни больше ни равно"],
		group: [["Smelting Special"]],
		recipe: "/>=",
	},
	"less_over_equals", {
		unicode: "{U+2266}",
		tags: ["less than over equals", "меньше над равно"],
		group: [["Smelting Special"]],
		recipe: ["<==", Chr(0x2264) "="],
	},
	"greater_over_equals", {
		unicode: "{U+2267}",
		tags: ["greater than over equals", "больше над равно"],
		group: [["Smelting Special"]],
		recipe: [">==", Chr(0x2265) "="],
	},
	"plusminus", {
		unicode: "{U+00B1}",
		tags: ["plus minus", "плюс-минус"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "+"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [=]",
		alt_special: "[Num+ Num-]",
		recipe: ["+-", "+" Chr(0x2212)],
	},
	"minusplus", {
		unicode: "{U+2213}",
		tags: ["minus plus", "минус-плюс"],
		group: [["Special Characters", "Smelting Special", "Special Fast"]],
		show_on_fast_keys: True,
		alt_special: "[Num- Num+]",
		recipe: ["-+", Chr(0x2212) "+"],
	},
	"plusdot", {
		unicode: "{U+2214}",
		tags: ["dot plus", "плюс с точкой"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: "+.",
	},
	"plusequals_above", {
		unicode: "{U+2A71}",
		tags: ["plus with equals above", "плюс с равно сверху"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: "+=",
	},
	"plusequals_below", {
		unicode: "{U+2A72}",
		tags: ["plus with equals below", "плюс с равно снизу"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: "=+",
	},
	"nottilde", {
		unicode: "{U+2241}",
		tags: ["не эквивалентно", "not tilde"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: "/~",
	},
	"tilde_dot", {
		unicode: "{U+2A6A}",
		tags: ["tilde operator with dot above", "тильда с точкой"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: "~.",
	},
	"tilderising_dots", {
		unicode: "{U+2A6B}",
		tags: ["tilde Operator with rising dots", "тильда точками"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ".~.",
	},
	"homothetic", {
		unicode: "{U+223B}",
		tags: ["гомотетия", "homothetic"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: "~:",
	},
	"asymptotically_equal", {
		unicode: "{U+2243}",
		tags: ["асимптотически равно", "asymptotically equal"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["-~", Chr(0x2212) "~"],
	},
	"tilde_tripple", {
		unicode: "{U+224B}",
		tags: ["тройная тильда", "triple tilde"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["~~~", "3~"],
	},
	"tilde_reversed", {
		unicode: "{U+223D}",
		tags: ["обратная  тильда", "reversed tilde"],
		group: [["Special Characters", "Smelting Special", "Special Fast"]],
		show_on_fast_keys: True,
		alt_special: ">+ [~]",
		recipe: "↺~",
	},
	"tilde_reversed_equals", {
		unicode: "{U+22CD}",
		tags: ["обратная тильда равно", "reversed tilde equal"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["-↺~", Chr(0x2212) "↺~", "-" Chr(0x223D), Chr(0x2212) Chr(0x223D)],
	},
	"inverted_lazy_s", {
		unicode: "{U+223E}",
		tags: ["inverted lazy s", "перевёрнутая плавная s"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: "s" Chr(0x21BB),
	},
	"n_ary_summation", {
		unicode: "{U+2211}",
		doubleStruckForm: "{U+2140}",
		tags: ["n-ary summation", "summation", "знак суммирования"],
		group: [["Smelting Special", "Math"]],
		alt_layout: "[s]",
		recipe: ["sum", "сум"],
	},
	"modulo_two_sum", {
		unicode: "{U+2A0A}",
		tags: ["modulo two sum"],
		group: ["Smelting Special"],
		recipe: ["msum", "мсум"],
	},
	"n_ary_product", {
		unicode: "{U+220F}",
		tags: ["n-ary product", "product", "знак произведения"],
		group: [["Smelting Special", "Math"]],
		alt_layout: ">+ [P]",
		recipe: ["prod", "прод"],
	},
	"n_ary_union", {
		unicode: "{U+222A}",
		tags: ["n-ary union", "union", "знак объединения"],
		group: [["Smelting Special", "Math"]],
		alt_layout: "[u]",
		recipe: ["uni", "обд"],
	},
	"delta", {
		unicode: "{U+2206}",
		tags: ["increment", "delta", "дельта"],
		group: [["Smelting Special", "Math"]],
		alt_layout: "[d]",
		recipe: ["del", "дел"],
	},
	"nabla", {
		unicode: "{U+2207}",
		tags: ["nabla", "набла"],
		group: [["Smelting Special", "Math"]],
		alt_layout: "[n]",
		recipe: ["nab", "наб"],
	},
	"integral", {
		unicode: "{U+222B}", LaTeX: "\int",
		tags: ["integral", "интеграл"],
		group: [["Smelting Special", "Math"]],
		alt_layout: "[i]",
		recipe: ["int", "инт"],
	},
	"integral_double", {
		unicode: "{U+222C}", LaTeX: "\iint",
		tags: ["double integral", "двойной интеграл"],
		group: ["Smelting Special"],
		recipe: ["iint", "иинт", Chrs([0x222B, 2])],
	},
	"integral_triple", {
		unicode: "{U+222D}", LaTeX: "\iiint",
		tags: ["triple integral", "тройной интеграл"],
		group: ["Smelting Special"],
		recipe: ["tint", "тинт", Chrs([0x222B, 3])],
	},
	"intergral_quadruple", {
		unicode: "{U+2A0C}",
		tags: ["quadruple integral", "четверной интеграл"],
		group: ["Smelting Special"],
		recipe: ["qint", "чинт", Chrs([0x222B, 4])],
	},
	"contour_integral", {
		unicode: "{U+222E}", LaTeX: "\oint",
		tags: ["contour integral", "интеграл по контуру"],
		group: [["Smelting Special", "Math"]],
		alt_layout: "[I]",
		recipe: ["oint", "кинт"],
	},
	"surface_integral", {
		unicode: "{U+222F}", LaTeX: "\oiint", LaTeXPackage: "esint",
		tags: ["surface integral", "интеграл по поверхности"],
		group: ["Smelting Special"],
		recipe: ["oiint", "киинт", Chrs([0x222E, 2])],
	},
	"volume_integral", {
		unicode: "{U+2230}", LaTeX: "\oiiint", LaTeXPackage: "esint",
		tags: ["volume integral", "тройной по объёму"],
		group: ["Smelting Special"],
		recipe: ["otint", "ктинт", Chrs([0x222E, 3])],
	},
	"summation_integral", {
		unicode: "{U+2A0B}",
		tags: ["summation with integral", "суммирования с интегралом"],
		group: ["Smelting Special"],
		recipe: ["sumint", "суминт", Chrs(0x2211, 0x222B)],
	},
	"square_root", {
		unicode: "{U+221A}", LaTeX: "\sqrt",
		tags: ["square root", "квадратный корень"],
		group: [["Smelting Special", "Math"]],
		alt_layout: "[r]",
		recipe: ["sqrt", "квкр"],
	},
	"cube_root", {
		unicode: "{U+221B}", LaTeX: "\sqrt[3]",
		tags: ["cube root", "кубический корень"],
		group: ["Smelting Special"],
		recipe: ["cbrt", "кубкр"],
	},
	"fourth_root", {
		unicode: "{U+221C}", LaTeX: "\sqrt[4]",
		tags: ["fourth root", "корень четвёртой степени"],
		group: ["Smelting Special"],
		recipe: ["qurt", "чткр"],
	},
	"dotted_circle", {
		unicode: "{U+25CC}",
		tags: ["пунктирный круг", "dottet circle"],
		group: ["Special Fast Primary", "Num0"],
		show_on_fast_keys: True,
	},
	"ellipsis", {
		unicode: "{U+2026}",
		tags: ["ellipsis", "многоточие"],
		group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], "."],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[/][.]",
		recipe: "...",
	},
	"two_dot_leader", {
		unicode: "{U+2025}",
		tags: ["two dot leader", "двухточечный пунктир"],
		group: ["Smelting Special"],
		recipe: "/..",
	},
	"two_dot_punctuation", {
		unicode: "{U+205A}",
		tags: ["two dot punctuation", "двухточечная пунктуация"],
		group: [["Smelting Special", "Special Fast Left"], ["/", "."]],
		show_on_fast_keys: True,
		recipe: "..",
	},
	"tricolon", {
		unicode: "{U+205D}",
		tags: ["tricolon", "троеточие"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [/][.]",
		recipe: ":↑.",
	},
	"quartocolon", {
		unicode: "{U+205E}",
		tags: ["vertical four dots", "четвероточие"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [/][.]",
		recipe: ":↑:",
	},
	"reference_mark", {
		unicode: "{U+203B}",
		tags: ["reference mark", "знак сноски", "komejirushi", "комэдзируси"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["..×..", ":×:"],
	},
	"numero_sign", {
		unicode: "{U+2116}",
		tags: ["numero sign", "знак номера"],
		group: ["Smelting Special"],
		recipe: "no",
	},
	"exclamation", {
		unicode: "{U+0021}",
	},
	"question", {
		unicode: "{U+003F}",
	},
	"reversed_question", {
		unicode: "{U+2E2E}",
		tags: ["reversed ?", "обратный ?"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! [1]",
		recipe: Chr(0x2B8C) "?",
	},
	"inverted_exclamation", {
		unicode: "{U+00A1}",
		tags: ["inverted !", "перевёрнутый !"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[1]",
		recipe: Chr(0x2B8F) "!",
	},
	"inverted_question", {
		unicode: "{U+00BF}",
		tags: ["inverted ?", "перевёрнутый ?"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[7]",
		recipe: Chr(0x2B8F) "?",
	},
	"double_exclamation", {
		unicode: "{U+203C}",
		tags: ["double !!", "двойной !!"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c*>+ [1]",
		recipe: "!!",
	},
	"double_exclamation_question", {
		unicode: "{U+2049}",
		tags: ["double !?", "двойной !?"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [1]",
		recipe: "!?",
	},
	"double_question", {
		unicode: "{U+2047}",
		tags: ["double ??", "двойной ??"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c*>+ [7]",
		recipe: "??",
	},
	"double_question_exclamation", {
		unicode: "{U+2048}",
		tags: ["double ?!", "двойной ?!"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [7]",
		recipe: "?!",
	},
	"interrobang", {
		unicode: "{U+203D}",
		tags: ["interrobang", "интерробанг", "лигатура !?", "ligature !?"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [1]",
		recipe: "!+?",
	},
	"interrobang_inverted", {
		unicode: "{U+2E18}",
		tags: ["inverted interrobang", "перевёрнутый интерробанг", "лигатура перевёрнутый !?", "ligature inverted !?"],
		group: [["Smelting Special", "Special Fast Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c*<+>+ [1]",
		recipe: Chr(0x2B8F) "!+?",
	},
	;
	"bracket_square_left", {
		unicode: "{U+005B}",
		tags: ["left square bracket", "левая квадратная скобка"],
		group: [["Brackets", "Special Fast Left"], "9"],
		show_on_fast_keys: True,
	},
	"bracket_square_right", {
		unicode: "{U+005D}",
		tags: ["right square bracket", "правая квадратная скобка"],
		group: [["Brackets", "Special Fast Left"], "0"],
		show_on_fast_keys: True,
	},
	"bracket_curly_left", {
		unicode: "{U+007B}",
		tags: ["left curly bracket", "левая фигурная скобка"],
		group: [["Brackets", "Special Fast Left"]],
		alt_on_fast_keys: "<+ [9]",
		show_on_fast_keys: True,
	},
	"bracket_curly_right", {
		unicode: "{U+007D}",
		tags: ["right curly bracket", "правая фигурная скобка"],
		group: [["Brackets", "Special Fast Left"]],
		alt_on_fast_keys: "<+ [0]",
		show_on_fast_keys: True,
	},
	"bracket_angle_math_left", {
		unicode: "{U+27E8}",
		tags: ["left angle math bracket", "левая угловая математическая скобка"],
		group: [["Brackets", "Special Fast Secondary"], "9"],
		show_on_fast_keys: True,
	},
	"bracket_angle_math_right", {
		unicode: "{U+27E9}",
		tags: ["right angle math bracket", "правая угловая математическая скобка"],
		group: [["Brackets", "Special Fast Secondary"], "0"],
		show_on_fast_keys: True,
	},
	;
	"emdash", {
		unicode: "{U+2014}", LaTeX: "---",
		tags: ["em dash", "длинное тире"],
		group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "1"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[-]",
		recipe: "---",
	},
	"emdash_vertical", {
		unicode: "{U+FE31}", LaTeX: "--",
		tags: ["vertical em dash", "вертикальное длинное тире"],
		group: ["Smelting Special"],
		recipe: Chr(0x2B8F) "—",
	},
	"endash", {
		unicode: "{U+2013}",
		tags: ["en dash", "короткое тире"],
		group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "2"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [-]",
		recipe: "--",
	},
	"endash_vertical", {
		unicode: "{U+FE32}",
		tags: ["vertical en dash", "вертикальное короткое тире"],
		group: ["Smelting Special"],
		recipe: Chr(0x2B8F) "–",
	},
	"three_emdash", {
		unicode: "{U+2E3B}",
		tags: ["three-em dash", "тройное тире"],
		group: [["Dashes", "Smelting Special", "Special Fast Left"], "3"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[-]",
		recipe: ["-----", "3-"],
	},
	"two_emdash", {
		unicode: "{U+2E3A}",
		tags: ["two-em dash", "двойное тире"],
		group: [["Dashes", "Smelting Special", "Special Fast Left"], "4"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [-]",
		recipe: ["----", "2-"],
	},
	"softhyphen", {
		unicode: "{U+00AD}",
		tags: ["soft hyphen", "мягкий перенос"],
		group: [["Dashes", "Smelting Special", "Special Fast Primary"], "5"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[-]",
		recipe: ".-",
	},
	"figure_dash", {
		unicode: "{U+2012}",
		tags: ["figure dash", "цифровое тире"],
		group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "6"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ [-]",
		recipe: "n-",
	},
	"hyphen", {
		unicode: "{U+2010}",
		tags: ["hyphen", "дефис"],
		group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "7"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! [-]",
		recipe: "1-",
	},
	"no_break_hyphen", {
		unicode: "{U+2011}",
		tags: ["no-break hyphen", "неразрывный дефис"],
		group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "8"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ [-]",
		recipe: "0-",
	},
	"minus", {
		unicode: "{U+2212}",
		tags: ["minus", "минус"],
		group: [["Dashes", "Smelting Special", "Special Fast Primary", "Special Fast"], "9"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [-]",
		alt_special: "[Num-]",
		recipe: "m-",
	},
	"minusdot", {
		unicode: "{U+2238}",
		tags: ["dot minus", "минус с точкой"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["-.", Chr(0x2212) "."],
	},
	"minustilde", {
		unicode: "{U+2242}",
		tags: ["minus tilde", "тильда с минусом"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["~-", "~" Chr(0x2212)],
	},
	"horbar", {
		unicode: "{U+2015}",
		tags: ["horbar", "горизонтальная черта"],
		group: [["Dashes", "Smelting Special"], "0"],
		recipe: "h-",
	},
	;
	;
	; * Quotation Marks
	"france_left", {
		unicode: "{U+00AB}", LaTeX: "`"<",
		tags: ["left guillemets", "левая ёлочка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "1"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[б], <! [<]",
		recipe: ["<<", "2<"],
	},
	"france_right", {
		unicode: "{U+00BB}", LaTeX: "`">",
		tags: ["right guillemets", "правая ёлочка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "2"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[ю], <! [>]",
		recipe: [">>", "2>"],
	},
	"france_single_left", {
		unicode: "{U+2039}",
		tags: ["left single guillemet", "левая одиночная ёлочка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "3"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ [<]",
		recipe: "<",
	},
	"france_single_right", {
		unicode: "{U+203A}",
		tags: ["right single guillemet", "правая одиночная ёлочка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "4"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ [>]",
		recipe: ">",
	},
	"quote_left_double", {
		unicode: "{U+201C}", LaTeX: "````",
		tags: ["left quotes", "левая кавычка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "5"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[<]",
		recipe: QuotationDouble . "<",
	},
	"quote_right_double", {
		unicode: "{U+201D}", LaTeX: "''",
		tags: ["right quotes", "правая кавычка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "6"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[>]",
		recipe: QuotationDouble . ">",
	},
	"quote_left_single", {
		unicode: "{U+2018}", LaTeX: "``",
		tags: ["left quote", "левая одинарная кавычка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "7"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [<]",
		recipe: ApostropheMark . "<",
	},
	"quote_right_single", {
		unicode: "{U+2019}", LaTeX: "'",
		tags: ["right quote", "правая одинарная кавычка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "8"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [>], " ">+ [" Backquote "][Ё]",
		recipe: ApostropheMark ">",
	},
	"quote_low_9_single", {
		unicode: "{U+201A}",
		tags: ["single low-9", "нижняя открывающая кавычка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "9"],
		show_on_fast_keys: True,
		alt_on_fast_keys: LeftShift ">+ [<]",
		recipe: ApostropheMark Chr(0x2193) "<",
	},
	"quote_low_9_double", {
		unicode: "{U+201E}", LaTeX: "`"``",
		tags: ["low-9 quotes", "нижняя открывающая двойная кавычка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "0"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [<]",
		recipe: QuotationDouble Chr(0x2193) "<",
	},
	"quote_low_9_double_reversed", {
		unicode: "{U+2E42}",
		tags: ["low-9 reversed quotes", "нижняя двойная кавычка"],
		group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "-"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [>]",
		recipe: QuotationDouble Chr(0x2193) ">",
	},
	"quote_left_double_ghost_ru", {
		unicode: "{U+201E}", LaTeX: "`"``",
		tags: ["left low quotes", "левая нижняя кавычка"],
		group: ["Special Fast Secondary"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Б]",
	},
	"quote_right_double_ghost_ru", {
		unicode: "{U+201C}", LaTeX: "`"'",
		tags: ["left quotes", "левая кавычка"],
		group: ["Special Fast Secondary"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Ю]",
	},
	"asian_left_quote", {
		unicode: "{U+300C}",
		tags: ["asian left quote", "левая азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num4]",
	},
	"asian_right_quote", {
		unicode: "{U+300D}",
		tags: ["asian right quote", "правая азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num6]",
	},
	"asian_up_quote", {
		unicode: "{U+FE41}",
		tags: ["asian up quote", "верхняя азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num8]",
	},
	"asian_down_quote", {
		unicode: "{U+FE42}",
		tags: ["asian down quote", "нижняя азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num2]",
	},
	"asian_double_left_quote", {
		unicode: "{U+300E}",
		tags: ["asian double left quote", "левая двойная азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [Num4]",
	},
	"asian_double_right_quote", {
		unicode: "{U+300F}",
		tags: ["asian double right quote", "правая двойная азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [Num6]",
	},
	"asian_double_up_quote", {
		unicode: "{U+FE43}",
		tags: ["asian double up quote", "верхняя двойная азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [Num8]",
	},
	"asian_double_down_quote", {
		unicode: "{U+FE44}",
		tags: ["asian double down quote", "нижняя двойная азиатская кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [Num2]",
	},
	"asian_double_left_title", {
		unicode: "{U+300A}",
		tags: ["asian double left title", "двойная левая титульная кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num7]",
	},
	"asian_double_right_title", {
		unicode: "{U+300B}",
		tags: ["asian double right title", "двойная правая титульная кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Num9]",
	},
	"asian_left_title", {
		unicode: "{U+3008}",
		tags: ["asian left title", "левая титульная кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [Num7]",
	},
	"asian_right_title", {
		unicode: "{U+3009}",
		tags: ["asian right title", "правая титульная кавычка"],
		group: ["Asian Quotes"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "c* [Num9]",
	},
)

MapInsert(Characters,
	;
	;
	; * Letters Latin
	"lat_c_lig_aa", {
		unicode: "{U+A732}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!aa", "лигатура AA", "ligature AA"],
		recipe: "AA",
	},
	"lat_s_lig_aa", {
		unicode: "{U+A733}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".aa", "лигатура aa", "ligature aa"],
		recipe: "aa",
	},
	"lat_c_lig_ae", {
		unicode: "{U+00C6}",
		modifierForm: "{U+1D2D}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!ae", "прописная лигатура AE", "capital ligature AE"],
		recipe: "AE",
	},
	"lat_s_lig_ae", {
		unicode: "{U+00E6}",
		combiningForm: "{U+1DD4}",
		modifierForm: "{U+10783}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ae", "строчная лигатура ae", "small ligature ae"],
		recipe: "ae",
	},
	"lat_c_lig_ae_acute", {
		unicode: "{U+01FC}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!aea", "прописная лигатура AE с акутом", "capital ligature AE with acute"],
		recipe: ["AE" . GetChar("acute"), Chr(0x00C6) GetChar("acute"), "A" Chr(0x00C9)],
	},
	"lat_s_lig_ae_acute", {
		unicode: "{U+01FD}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".aea", "строчная лигатура ae с акутом", "small ligature ae with acute"], recipe: ["ae" . GetChar("acute"), Chr(0x00E6) GetChar("acute"), "a" Chr(0x00E9)],
	},
	"lat_c_lig_ae_macron", {
		unicode: "{U+01E2}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!aem", "прописная лигатура AE с макроном", "capital ligature AE with macron"],
		recipe: ["AE" . GetChar("macron"), Chr(0x00C6) GetChar("macron"), "A" Chr(0x0112)],
	},
	"lat_s_lig_ae_macron", {
		unicode: "{U+01E3}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".aem", "строчная лигатура ae с макроном", "small ligature ae with macron"],
		recipe: ["ae" . GetChar("macron"), Chr(0x00E6) GetChar("macron"), "a" Chr(0x0113)],
	},
	"lat_c_lig_ao", {
		unicode: "{U+A734}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!ao", "прописная лигатура AO", "capital ligature AO"],
		recipe: "AO",
	},
	"lat_s_lig_ao", {
		unicode: "{U+A735}",
		combiningForm: "{U+1DD5}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ao", "строчная лигатура ao", "small ligature ao"],
		recipe: "ao",
	},
	"lat_c_lig_au", {
		unicode: "{U+A736}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!au", "прописная лигатура AU", "capital ligature AU"],
		recipe: "AU",
	},
	"lat_s_lig_au", {
		unicode: "{U+A737}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".au", "строчная лигатура au", "small ligature au"],
		recipe: "au",
	},
	"lat_c_lig_av", {
		unicode: "{U+A738}",
		combiningForm: "{U+1DD6}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!av", "прописная лигатура AV", "capital ligature AV"],
		recipe: "AV",
	},
	"lat_s_lig_av", {
		unicode: "{U+A739}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".av", "строчная лигатура av", "small ligature av"],
		recipe: "av",
	},
	"lat_c_lig_avi", {
		unicode: "{U+A73A}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!avi", "прописная лигатура AVI", "capital ligature AVI"],
		recipe: "AVI",
	},
	"lat_s_lig_avi", {
		unicode: "{U+A73B}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".avi", "строчная лигатура avi", "small ligature avi"],
		recipe: "avi",
	},
	"lat_c_lig_ay", {
		unicode: "{U+A73C}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!ay", "прописная лигатура AY", "capital ligature AY"],
		recipe: "AY",
	},
	"lat_s_lig_ay", {
		unicode: "{U+A73D}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ay", "строчная лигатура ay", "small ligature ay"],
		recipe: "ay",
	},
	"lat_s_lig_db", {
		unicode: "{U+0238}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".db", "строчная лигатура db", "small ligature db"],
		recipe: "db",
	},
	"lat_s_lig_et", {
		unicode: "{U+0026}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".et", "строчная лигатура et", "small ligature et", "амперсанд", "ampersand"],
		recipe: "et",
	},
	"lat_s_lig_et_turned", {
		unicode: "{U+214B}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ett", "лигатура перевёрнутый et", "ligature turned et", "перевёрнутый амперсанд", "turned ampersand"],
		recipe: ["et" Chr(0x21BA), "&" Chr(0x21BA)],
	},
	"lat_s_lig_ff", {
		unicode: "{U+FB00}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ff", "строчная лигатура ff", "small ligature ff"],
		recipe: "ff",
	},
	"lat_s_lig_fi", {
		unicode: "{U+FB01}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".fi", "строчная лигатура fi", "small ligature fi"],
		recipe: "fi",
	},
	"lat_s_lig_fl", {
		unicode: "{U+FB02}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".fl", "строчная лигатура fl", "small ligature fl"],
		recipe: "fl",
	},
	"lat_s_lig_ft", {
		unicode: "{U+FB05}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ft", "строчная лигатура ft", "small ligature ft"],
		recipe: ["ft", Chr(0x017F) . "t"],
	},
	"lat_s_lig_ffi", {
		unicode: "{U+FB03}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ffi", "строчная лигатура ffi", "small ligature ffi"],
		recipe: "ffi",
	},
	"lat_s_lig_ffl", {
		unicode: "{U+FB04}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ffl", "строчная лигатура ffl", "small ligature ffl"],
		recipe: "ffl",
	},
	"lat_c_lig_ij", {
		unicode: "{U+0132}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!ij", "прописная лигатура IJ", "capital ligature IJ"],
		recipe: "IJ",
	},
	"lat_s_lig_ij", {
		unicode: "{U+0133}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ij", "строчная лигатура ij", "small ligature ij"],
		recipe: "ij",
	},
	"lat_s_lig_lb", {
		unicode: "{U+2114}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".lb", "строчная лигатура lb", "small ligature lb"],
		recipe: "lb",
	},
	"lat_c_lig_ll", {
		unicode: "{U+1EFA}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!ll", "прописная лигатура lL", "capital ligature lL"],
		recipe: "lL",
	},
	"lat_s_lig_ll", {
		unicode: "{U+1EFB}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ll", "строчная лигатура ll", "small ligature ll"],
		recipe: "ll",
	},
	"lat_c_lig_oi", {
		unicode: "{U+01A2}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!oi", "прописная лигатура OI", "capital ligature OI"],
		recipe: "OI",
	},
	"lat_s_lig_oi", {
		unicode: "{U+01A3}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".oi", "строчная лигатура oi", "small ligature oi"],
		recipe: "oi",
	},
	"lat_c_lig_oe", {
		unicode: "{U+0152}",
		modifierForm: "{U+A7F9}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!oe", "прописная лигатура OE", "capital ligature OE"],
		recipe: "OE",
	},
	"lat_s_lig_oe", {
		unicode: "{U+0153}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".oe", "строчная лигатура oe", "small ligature oe"],
		recipe: "oe",
	},
	"lat_s_lig_oe_turned", {
		unicode: "{U+0153}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["строчная лигатура перевёрнутое oe", "small ligature turned oe"],
		recipe: ["oe" GetChar("arrow_left_circle"), Chr(0x0153) GetChar("arrow_left_circle")],
	},
	"lat_c_lig_oo", {
		unicode: "{U+A74E}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!oo", "прописная лигатура OO", "capital ligature OO"],
		recipe: "OO",
	},
	"lat_s_lig_oo", {
		unicode: "{U+A74F}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".oo", "строчная лигатура oo", "small ligature oo"],
		recipe: "oo",
	},
	"lat_c_lig_ou", {
		unicode: "{U+0222}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!ou", "прописная лигатура OU", "capital ligature OU"],
		recipe: "OU",
	},
	"lat_s_lig_ou", {
		unicode: "{U+0223}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ou", "строчная лигатура ou", "small ligature ou"],
		recipe: "ou",
	},
	"lat_c_lig_pl", {
		unicode: "{U+214A}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!pl", "лигатура PL", "ligature PL", "Property Line"],
		recipe: "PL",
	},
	"lat_s_lig_ue", {
		unicode: "{U+1D6B}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ue", "строчная лигатура ue", "small ligature ue"],
		recipe: "ue",
	},
	"lat_c_lig_eszett", {
		unicode: "{U+1E9E}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!ss", "прописная лигатура SS", "capital ligature SS", "прописная буква Эсцет", "capital letter Eszett"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [S]",
		recipe: ["SS", Chr(0x017F) . "S"],
	},
	"lat_s_lig_eszett", {
		unicode: "{U+00DF}",
		titlesAlt: True,
		group: [["Latin Ligatures"]],
		tags: [".ss", "строчная лигатура ss", "small ligature ss", "строчная буква эсцет", "small letter eszett"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [s]",
		recipe: ["ss", Chr(0x017F) . "s"],
	},
	"lat_c_lig_vy", {
		unicode: "{U+A760}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!vy", "прописная лигатура VY", "capital ligature VY"],
		recipe: "VY",
	},
	"lat_s_lig_vy", {
		unicode: "{U+A761}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".vy", "строчная лигатура vy", "small ligature vy"],
		recipe: "vy",
	},
	;
	;
	; * Latin Digraphs
	"lat_c_dig_dz", {
		unicode: "{U+01F1}",
		titlesAlt: True,
		group: ["Latin Digraphs"],
		tags: ["!dz", "диграф DZ", "diagraph DZ"],
		recipe: "DZ",
	},
	"lat_cs_dig_dz", {
		unicode: "{U+01F2}",
		titlesAlt: True,
		group: ["Latin Digraphs"],
		tags: ["!.dz", "диграф Dz", "diagraph Dz"],
		recipe: "Dz",
	},
	"lat_s_dig_dz", {
		unicode: "{U+01F3}",
		titlesAlt: True,
		group: ["Latin Digraphs"],
		tags: [".dz", "диграф dz", "diagraph dz"],
		recipe: "dz",
	},
	"lat_c_dig_dz_caron", {
		unicode: "{U+01C4}",
		titlesAlt: True,
		group: ["Latin Digraphs"],
		tags: ["!dzh", "диграф DZ с гачеком", "diagraph DZ with caron"],
		recipe: ["DZ" GetChar("caron"), Chr(0x01F1) GetChar("caron")],
	},
	"lat_cs_dig_dz_caron", {
		unicode: "{U+01C5}",
		titlesAlt: True,
		group: ["Latin Digraphs"],
		tags: ["!.dzh", "диграф Dz с гачеком", "diagraph Dz with caron"],
		recipe: ["Dz" . GetChar("caron"), Chr(0x01F2) . GetChar("caron")],
	},
	"lat_s_dig_dz_caron", {
		unicode: "{U+01C6}",
		titlesAlt: True,
		group: ["Latin Digraphs"],
		tags: [".dzh", "диграф dz с гачеком", "diagraph dz with caron"],
		recipe: ["dz" GetChar("caron"), Chr(0x01F3) GetChar("caron")],
	},
	"lat_s_dig_dz_curl", {
		unicode: "{U+02A5}",
		titlesAlt: True,
		group: ["Latin Digraphs"],
		tags: [".dzc", "диграф dz с завитком", "diagraph dz with curl"],
		recipe: ["dz" GetChar("arrow_left_ushaped"), Chr(0x01F3) GetChar("arrow_left_ushaped")],
	},
	"lat_s_dig_feng", {
		unicode: "{U+02A9}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".fnj", "диграф фэнг", "diagraph feng"],
		recipe: ["fnj", "fŋ"],
	},
	"lat_c_dig_lj", {
		unicode: "{U+01C7}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!lj", "диграф LJ", "diagraph LJ"],
		recipe: "LJ",
	},
	"lat_cs_dig_lj", {
		unicode: "{U+01C8}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!.lj", "диграф Lj", "diagraph Lj"],
		recipe: "Lj",
	},
	"lat_s_dig_lj", {
		unicode: "{U+01C9}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".lj", "диграф lj", "diagraph lj"],
		recipe: "lj",
	},
	"lat_s_dig_ls", {
		unicode: "{U+02AA}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ls", "диграф ls", "diagraph ls"],
		recipe: "ls",
	},
	"lat_s_dig_lz", {
		unicode: "{U+02AB}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".lz", "диграф lz", "diagraph lz"],
		recipe: "lz",
	},
	"lat_c_dig_nj", {
		unicode: "{U+01CA}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!nj", "диграф NJ", "diagraph NJ"],
		recipe: "N-J",
	},
	"lat_cs_dig_nj", {
		unicode: "{U+01CB}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: ["!.nj", "диграф Nj", "diagraph Nj"],
		recipe: "N-j",
	},
	"lat_s_dig_nj", {
		unicode: "{U+01CC}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".nj", "диграф nj", "diagraph nj"],
		recipe: "n-j",
	},
	"lat_s_dig_st", {
		unicode: "{U+FB06}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".st", "диграф st", "diagraph st"],
		recipe: "st",
	},
	"lat_s_dig_tc", {
		unicode: "{U+02A8}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".tc", "диграф tc", "diagraph tc"],
		recipe: ["tc", "t" Chr(0x0255)],
	},
	"lat_s_dig_tch", {
		unicode: "{U+02A7}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".tch", "диграф tch", "diagraph tch"],
		recipe: ["tch", "t" Chr(0x0283)],
	},
	"lat_s_dig_ts", {
		unicode: "{U+02A6}",
		titlesAlt: True,
		group: ["Latin Ligatures"],
		tags: [".ts", "диграф ts", "diagraph ts"],
		recipe: "ts",
	},
	;
	;
	; * Latin Letters
	"lat_c_let_d_insular", {
		unicode: "{U+A779}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная островная буква D", "capital insular letter D"],
		recipe: "D0",
	},
	"lat_s_let_d_insular", {
		unicode: "{U+A77A}",
		combiningForm: "{U+1DD8}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная островная буква d", "small insular letter d"],
		recipe: "d0",
	},
	"lat_c_let_f_insular", {
		unicode: "{U+A77B}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная островная буква F", "capital insular letter F"],
		recipe: "F0",
	},
	"lat_s_let_f_insular", {
		unicode: "{U+A77C}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная островная буква f", "small insular letter f"],
		recipe: "f0",
	},
	"lat_c_let_g_insular", {
		unicode: "{U+A77D}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		tags: ["прописная островная буква G", "capital insular letter G"],
		recipe: "G0",
	},
	"lat_s_let_g_insular", {
		unicode: "{U+1D79}",
		combiningForm: "{U+1ACC}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		tags: ["строчная островная буква g", "small insular letter g"],
		recipe: "g0",
	},
	"lat_c_let_g_insular_closed", {
		unicode: "{U+A7D0}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная островная буква закрытая G", "capital insular letter closed G"],
		recipe: "G-",
	},
	"lat_s_let_g_insular_closed", {
		unicode: "{U+A7D1}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная островная буква закрытая g", "small insular letter closed g"],
		recipe: "g-",
	},
	"lat_c_let_g_insular_turned", {
		unicode: "{U+A77E}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная островная буква G", "capital insular letter G"],
		recipe: ["G0" GetChar("arrow_left_circle"), Chr(0xA77D) GetChar("arrow_left_circle")],
	},
	"lat_s_let_g_insular_turned", {
		unicode: "{U+A77F}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная островная буква g", "small insular letter g"],
		recipe: ["g0" GetChar("arrow_left_circle"), Chr(0x1D79) GetChar("arrow_left_circle")],
	},
	"lat_c_let_o_open", {
		unicode: "{U+0186}",
		titlesAlt: True,
		group: ["Latin Extended"],
		recipe: "$-",
	},
	"lat_s_let_o_open", {
		unicode: "{U+0254}",
		titlesAlt: True,
		group: ["Latin Extended"],
		recipe: "$-",
	},
	"lat_s_let_o_open_sideways", {
		unicode: "{U+1D12}",
		titlesAlt: True,
		group: ["Latin Extended"],
		recipe: ["$-" GetChar("arrow_right_circle"), Chr(0x1DD8) GetChar("arrow_right_circle")],
	},
	"lat_s_let_o_sideways", {
		unicode: "{U+1D11}",
		titlesAlt: True,
		group: ["Latin Extended"],
		recipe: "$" GetChar("arrow_right_circle"),
	},
	"lat_c_let_r_rotunda", {
		unicode: "{U+A75A}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		tags: ["R$ ротунда", "E$ rotunda"],
		recipe: "$-",
	},
	"lat_s_let_r_rotunda", {
		unicode: "{U+A75B}",
		combiningForm: "{U+1DE3}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		tags: ["R$ ротунда", "E$ rotunda"],
		recipe: "$-",
	},
	"lat_s_let_i_dotless", {
		unicode: "{U+0131}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ $",
		tags: ["строчная бува і без точки", "small letter i dotless"],
		recipe: "i/",
	},
	"lat_s_let_ie", {
		unicode: "{U+AB61}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная ie", "small ie"],
		recipe: "ie",
	},
	"lat_c_let_thorn", {
		unicode: "{U+00DE}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [T]",
		tags: ["!th", "прописная буква Торн", "capital letter Thorn"],
		recipe: "TH",
	},
	"lat_s_let_thorn", {
		unicode: "{U+00FE}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [t]",
		tags: [".th", "строчныая буква торн", "small letter thorn"],
		recipe: "th",
	},
	"lat_c_let_et_tironian", {
		unicode: "{U+2E52}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [T]",
		tags: ["!tet", "прописной буква тиронская Эт", "capital letter tironian Et"],
		recipe: "TET",
	},
	"lat_s_let_et_tironian", {
		unicode: "{U+204A}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [t]",
		tags: [".tet", "строчная буква тиронская эт", "small letter tironian et"],
		recipe: "tet",
	},
	"lat_c_let_t_insular", {
		unicode: "{U+A786}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная островная буква T", "capital insular letter T"],
		recipe: "T0",
	},
	"lat_s_let_t_insular", {
		unicode: "{U+A77A}",
		combiningForm: "{U+1ACE}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная островная буква t", "small insular letter t"],
		recipe: "t0",
	},
	"lat_c_let_r_insular", {
		unicode: "{U+A782}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная островная буква R", "capital insular letter R"],
		recipe: "R0",
	},
	"lat_s_let_r_insular", {
		unicode: "{U+A783}",
		combiningForm: "{U+1ACD}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная островная буква r", "small insular letter r"],
		recipe: "r0",
	},
	"lat_c_let_s_insular", {
		unicode: "{U+A784}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная островная буква S", "capital insular letter S"],
		recipe: "S0",
	},
	"lat_s_let_s_insular", {
		unicode: "{U+A785}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная островная буква s", "small insular letter s"],
		recipe: "s0",
	},
	"lat_c_let_wynn", {
		unicode: "{U+01F7}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [W]",
		tags: ["!wy", "прописная буква винн", "capital letter wynn"],
		recipe: "WY",
	},
	"lat_s_let_wynn", {
		unicode: "{U+01BF}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [w]",
		tags: [".wy", "строчная буква винн", "small  wynn"],
		recipe: "wy",
	},
	"lat_c_let_vend", {
		unicode: "{U+A768}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [V]",
		tags: ["прописная буква Венд", "capital letter Vend"],
		recipe: "IV",
	},
	"lat_s_let_vend", {
		unicode: "{U+A769}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [V]",
		tags: ["строчная буква венд", "small letter vend"],
		recipe: "iv",
	},
	"lat_c_let_v_middle_welsh", {
		unicode: "{U+1EFC}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		tags: ["прописная буква V средневаллийского", "capital letter V middle-welsh"],
		recipe: "V6",
	},
	"lat_s_let_v_middle_welsh", {
		unicode: "{U+1EFD}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		tags: ["строчная буква v средневаллийского", "small letter v middle-welsh"],
		recipe: "v6",
	},
	"lat_c_let_w_anglicana", {
		unicode: "{U+A7C2}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		tags: ["прописная буква W англиканы", "capital letter W anglicana"],
		recipe: "W3",
	},
	"lat_s_let_w_anglicana", {
		unicode: "{U+A7C3}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		tags: ["строчная буква w англиканы", "small letter w anglicana"],
		recipe: "w3",
	},
	"lat_c_let_nj", {
		unicode: "{U+014A}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["!nj", "прописной энг", "capital eng"],
		recipe: "NJ",
	},
	"lat_s_let_nj", {
		unicode: "{U+014B}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: [".nj", "строчный энг", "small eng"],
		recipe: "nj",
	},
	"lat_s_let_s_long", {
		unicode: "{U+017F}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		tags: ["строчная буква s длинное", "small letter s long"],
		recipe: "fs",
	},
	"lat_c_let_gamma", {
		unicode: "{U+0194}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [G]",
		tags: ["прописная буква Гамма", "capital letter Gamma"],
		recipe: "V0",
	},
	"lat_s_let_gamma", {
		unicode: "{U+0263}",
		modifierForm: "{U+02E0}",
		titlesAlt: True,
		group: ["Latin Extended"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [g]",
		tags: ["строчныая буква гамма", "small letter gamma"],
		recipe: "v0",
	},
	"lat_c_let_upsilon", {
		unicode: "{U+01B1}",
		titlesAlt: True,
		group: [["Latin Extended", "IPA"]],
		tags: ["прописная буква перевёрнутая Омега", "capital letter inverted Omega"],
		alt_layout: "<!>! [U]",
		recipe: "-U-",
	},
	"lat_s_let_upsilon", {
		unicode: "{U+028A}",
		titlesAlt: True,
		group: [["Latin Extended", "IPA"]],
		tags: ["строчная буква перевёрнутая Омега", "small letter inverted Omega"],
		alt_layout: "<!>! [u]",
		recipe: "-u-",
	},
	"lat_c_let_s_esh", {
		unicode: "{U+01A9}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная буква Эщ", "capital letter Esh"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$3",
	},
	"lat_s_let_s_esh", {
		unicode: "{U+0283}",
		modifierForm: "{U+1DBE}",
		titlesAlt: True,
		group: [["Latin Extended", "IPA"]],
		tags: ["строчная буква эщ", "small letter esh", "глухой постальвеолярный сибилянт", "voiceless postalveolar fricative"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$3",
		alt_layout: ">+ [S]",
		alt_layout_title: true,
	},
	"lat_c_let_z_ezh", {
		unicode: "{U+01B7}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная буква Эж", "capital letter Ezh"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$3",
	},
	"lat_s_let_z_ezh", {
		unicode: "{U+0292}",
		modifierForm: "{U+1DBE}",
		titlesAlt: True,
		group: [["Latin Extended", "IPA"]],
		tags: ["строчная буква эж", "small letter ezh", "звонкий зубной щелевой согласный", "voiced postalveolar fricative"],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$3",
		alt_layout: "[Z]",
		alt_layout_title: true,
	},
	"lat_c_let_z_ezh_reversed", {
		unicode: "{U+01B8}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["прописная буква Эж зеркальная", "capital letter reversed Ezh"],
		recipe: "$" Chr(0x2B8E) "3",
	},
	"lat_s_let_z_ezh_reversed", {
		unicode: "{U+01B9}",
		titlesAlt: True,
		group: ["Latin Extended"],
		tags: ["строчная буква эж зеркальная", "small letter reversed ezh"],
		recipe: "$" Chr(0x2B8E) "3",
	},
	;
	;
	; * Small Capitals
	"lat_s_c_let_i", {
		unicode: "{U+026A}",
		titlesAlt: True,
		group: [["Latin Extended", "IPA"]],
		show_on_fast_keys: False,
		tags: ["капитель I", "small capital I", "ненапряжённый неогублённый гласный переднего ряда верхнего подъёма", "near-close near-front unrounded vowel"],
		recipe: "I↓",
		alt_layout: "[I]",
		alt_layout_title: True,
	},
	;
	;
	; * Accented Latin Letters
	"lat_c_let_a_acute", {
		unicode: "{U+00C1}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_a_acute", {
		unicode: "{U+00E1}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_a_breve", {
		unicode: "{U+0102}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_s_let_a_breve", {
		unicode: "{U+0103}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_c_let_a_breve_acute", {
		unicode: "{U+1EAE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "acute"), Chr(0x0102) GetChar("acute")],
	},
	"lat_s_let_a_breve_acute", {
		unicode: "{U+1EAF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "acute"), Chr(0x0103) GetChar("acute")],
	},
	"lat_c_let_a_breve_dot_below", {
		unicode: "{U+1EB6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "dot_below"), Chr(0x0102) GetChar("dot_below")],
	},
	"lat_s_let_a_breve_dot_below", {
		unicode: "{U+1EB7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "dot_below"), Chr(0x0103) GetChar("dot_below")],
	},
	"lat_c_let_a_breve_grave", {
		unicode: "{U+1EB0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "grave"), Chr(0x0102) GetChar("grave")],
	},
	"lat_s_let_a_breve_grave", {
		unicode: "{U+1EB1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "grave"), Chr(0x0103) GetChar("grave")],
	},
	"lat_c_let_a_breve_hook_above", {
		unicode: "{U+1EB2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "hook_above"), Chr(0x0102) GetChar("hook_above")],
	},
	"lat_s_let_a_breve_hook_above", {
		unicode: "{U+1EB3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "hook_above"), Chr(0x0103) GetChar("hook_above")],
	},
	"lat_c_let_a_breve_tilde", {
		unicode: "{U+1EB4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "tilde"), Chr(0x0102) GetChar("tilde")],
	},
	"lat_s_let_a_breve_tilde", {
		unicode: "{U+1EB5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "tilde"), Chr(0x0103) GetChar("tilde")],
	},
	"lat_c_let_a_breve_inverted", {
		unicode: "{U+0202}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_s_let_a_breve_inverted", {
		unicode: "{U+0203}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_c_let_a_circumflex", {
		unicode: "{U+00C2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_a_circumflex", {
		unicode: "{U+00E2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_a_circumflex_acute", {
		unicode: "{U+1EA4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "acute"), Chr(0x00C2) GetChar("acute")],
	},
	"lat_s_let_a_circumflex_acute", {
		unicode: "{U+1EA5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "acute"), Chr(0x00E2) GetChar("acute")],
	},
	"lat_c_let_a_circumflex_dot_below", {
		unicode: "{U+1EAC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "dot_below"), Chr(0x00C2) GetChar("dot_below")],
	},
	"lat_s_let_a_circumflex_dot_below", {
		unicode: "{U+1EAD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "dot_below"), Chr(0x00E2) GetChar("dot_below")],
	},
	"lat_c_let_a_circumflex_grave", {
		unicode: "{U+1EA6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "grave"), Chr(0x00C2) GetChar("grave")],
	},
	"lat_s_let_a_circumflex_grave", {
		unicode: "{U+1EA7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "grave"), Chr(0x00E2) GetChar("grave")],
	},
	"lat_c_let_a_circumflex_hook_above", {
		unicode: "{U+1EA8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "hook_above"), Chr(0x00C2) GetChar("hook_above")],
	},
	"lat_s_let_a_circumflex_hook_above", {
		unicode: "{U+1EA9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "hook_above"), Chr(0x00E2) GetChar("hook_above")],
	},
	"lat_c_let_a_circumflex_tilde", {
		unicode: "{U+1EAA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "tilde"), Chr(0x00C2) GetChar("tilde")],
	},
	"lat_s_let_a_circumflex_tilde", {
		unicode: "{U+1EAB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "tilde"), Chr(0x00E2) GetChar("tilde")],
	},
	"lat_c_let_a_caron", {
		unicode: "{U+01CD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_a_caron", {
		unicode: "{U+01CE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_a_dot_above", {
		unicode: "{U+0226}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_a_dot_above", {
		unicode: "{U+0227}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_a_dot_above_macron", {
		unicode: "{U+01E0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_above", "macron"), Chr(0x0226) GetChar("macron")],
	},
	"lat_s_let_a_dot_above_macron", {
		unicode: "{U+01E1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_above", "macron"), Chr(0x0227) GetChar("macron")],
	},
	"lat_c_let_a_dot_below", {
		unicode: "{U+1EA0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_a_dot_below", {
		unicode: "{U+1EA1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_a_diaeresis", {
		unicode: "{U+00C4}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_a_diaeresis", {
		unicode: "{U+00E4}",
		combiningForm: "{U+1DF2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_a_diaeresis_macron", {
		unicode: "{U+01DE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "macron"), Chr(0x00C4) GetChar("macron")],
	},
	"lat_s_let_a_diaeresis_macron", {
		unicode: "{U+01DF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "macron"), Chr(0x00E4) GetChar("macron")],
	},
	"lat_c_let_a_grave", {
		unicode: "{U+00C0}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_a_grave", {
		unicode: "{U+00E0}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_c_let_a_grave_double", {
		unicode: "{U+0200}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_s_let_a_grave_double", {
		unicode: "{U+0201}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_c_let_a_hook_above", {
		unicode: "{U+1EA2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_a_hook_above", {
		unicode: "{U+1EA3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_a_retroflex_hook", {
		unicode: "{U+1D8F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_c_let_a_macron", {
		unicode: "{U+0100}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_s_let_a_macron", {
		unicode: "{U+0101}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_c_let_a_ring_above", {
		unicode: "{U+00C5}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("ring_above"),
	},
	"lat_s_let_a_ring_above", {
		unicode: "{U+00E5}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("ring_above"),
	},
	"lat_c_let_a_ring_above_acute", {
		unicode: "{U+01FA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("ring_above", "acute"), Chr(0x00C5) GetChar("acute")],
	},
	"lat_s_let_a_ring_above_acute", {
		unicode: "{U+01FB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("ring_above", "acute"), Chr(0x00E5) GetChar("acute")],
	},
	"lat_c_let_a_ring_below", {
		unicode: "{U+1E00}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("ring_below"),
	},
	"lat_s_let_a_ring_below", {
		unicode: "{U+1E01}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("ring_below"),
	},
	"lat_c_let_a_solidus_long", {
		unicode: "{U+023A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_a_solidus_long", {
		unicode: "{U+2C65}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_a_ogonek", {
		unicode: "{U+0104}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_s_let_a_ogonek", {
		unicode: "{U+0105}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_c_let_a_tilde", {
		unicode: "{U+00C3}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_a_tilde", {
		unicode: "{U+00E3}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	;
	"lat_c_let_b_dot_above", {
		unicode: "{U+1E02}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_b_dot_above", {
		unicode: "{U+1E03}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_b_dot_below", {
		unicode: "{U+1E04}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_b_dot_below", {
		unicode: "{U+1E05}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_b_common_hook", {
		unicode: "{U+0181}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_b_common_hook", {
		unicode: "{U+0253}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_b_palatal_hook", {
		unicode: "{U+1D80}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_b_flourish", {
		unicode: "{U+A796}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_s_let_b_flourish", {
		unicode: "{U+A797}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_c_let_b_line_below", {
		unicode: "{U+1E06}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_b_line_below", {
		unicode: "{U+1E07}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_b_stroke_short", {
		unicode: "{U+0243}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_b_stroke_short", {
		unicode: "{U+0180}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_b_tilde_overlay", {
		unicode: "{U+1D6C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_c_let_b_topbar", {
		unicode: "{U+0182}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_b_topbar", {
		unicode: "{U+0183}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "b" . GetChar("arrow_up"),
	},
	;
	"lat_c_let_c_acute", {
		unicode: "{U+0106}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_c_acute", {
		unicode: "{U+0107}",
		titlesAlt: True,
		group: ["Latin Accented"],
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_c_circumflex", {
		unicode: "{U+0108}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_c_circumflex", {
		unicode: "{U+0109}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_c_caron", {
		unicode: "{U+010C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_c_caron", {
		unicode: "{U+010D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_c_cedilla", {
		unicode: "{U+00C7}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_c_cedilla", {
		unicode: "{U+00E7}",
		combiningForm: "{U+1DD7}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_c_let_c_cedilla_acute", {
		unicode: "{U+1E08}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("cedilla", "acute"), Chr(0x00C7) GetChar("acute")],
	},
	"lat_s_let_c_cedilla_acute", {
		unicode: "{U+1E09}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("cedilla", "acute"), Chr(0x00E7) GetChar("acute")],
	},
	"lat_s_let_c_curl", {
		unicode: "{U+0255}",
		modifierForm: "{U+1D9D}",
		titlesAlt: True,
		group: [["Latin Accented", "IPA"]],
		tags: ["R^$", "E^$", "глухой альвеоло-палатальный сибилянт", "voiceless alveolo-palatal fricative"],
		recipe: "$" GetChar("arrow_left_ushaped"),
		alt_layout: "[C]",
		alt_layout_title: true,
	},
	"lat_c_let_c_dot_above", {
		unicode: "{U+010A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_c_dot_above", {
		unicode: "{U+010B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_c_reversed_dot_middle", {
		unicode: "{U+A73E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["прописная обратная C с точкой", "capital reversed C with middle dot"],
		recipe: "$" GetChar("arrow_left_circle") "·",
	},
	"lat_s_let_c_reversed_dot_middle", {
		unicode: "{U+A73F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["строчная обратная c с точкой", "small reversed c with middle dot"],
		recipe: "$" GetChar("arrow_left_circle") "·",
	},
	"lat_c_let_c_common_hook", {
		unicode: "{U+0187}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "C" . GetChar("arrow_up"),
	},
	"lat_s_let_c_common_hook", {
		unicode: "{U+0188}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "c" . GetChar("arrow_up"),
	},
	"lat_c_let_c_palatal_hook", {
		unicode: "{U+A7C4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_s_let_c_palatal_hook", {
		unicode: "{U+A794}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_s_let_c_retroflex_hook", {
		unicode: "{U+1DF1D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_c_let_c_solidus_long", {
		unicode: "{U+023B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_c_solidus_long", {
		unicode: "{U+023C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_c_stroke_short", {
		unicode: "{U+A792}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_c_stroke_short", {
		unicode: "{U+A793}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	;
	"lat_c_let_d_circumflex_below", {
		unicode: "{U+1E12}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_s_let_d_circumflex_below", {
		unicode: "{U+1E13}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_c_let_d_caron", {
		unicode: "{U+010E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_d_caron", {
		unicode: "{U+010F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_d_cedilla", {
		unicode: "{U+1E10}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_d_cedilla", {
		unicode: "{U+1E11}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_d_curl", {
		unicode: "{U+0221}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_c_let_d_dot_above", {
		unicode: "{U+1E0A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_d_dot_above", {
		unicode: "{U+1E0B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_d_eth", {
		unicode: "{U+00D0}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		tags: ["прописная буква Эт", "capital letter Eth"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_short"),
	},
	"lat_s_let_d_eth", {
		unicode: "{U+00F0}",
		combiningForm: "{U+1DD9}",
		modifierForm: "{U+1D9E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary", "IPA"]],
		tags: ["строчная буква эт", "small letter eth", "звонкий зубной щелевой согласный", "voiced dental fricative"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_short"),
		alt_layout: "[D]",
		alt_layout_title: true,
	},
	"lat_c_let_d_dot_below", {
		unicode: "{U+1E0C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_d_dot_below", {
		unicode: "{U+1E0D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_d_common_hook", {
		unicode: "{U+018A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_d_common_hook", {
		unicode: "{U+0257}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_d_hook_retroflex_hook", {
		unicode: "{U+1D91}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left", "retroflex_hook_below"),
	},
	"lat_s_let_d_palatal_hook", {
		unicode: "{U+1D81}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_s_let_d_retroflex_hook", {
		unicode: "{U+0256}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_c_let_d_line_below", {
		unicode: "{U+1E0E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_d_line_below", {
		unicode: "{U+1E0F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_d_stroke_short", {
		unicode: "{U+0110}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_d_stroke_short", {
		unicode: "{U+0111}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_d_stroke_s2", {
		unicode: "{U+A7C7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_long"),
	},
	"lat_s_let_d_stroke_s2", {
		unicode: "{U+A7C8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_long"),
	},
	"lat_s_let_d_tilde_overlay", {
		unicode: "{U+1D6D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_c_let_d_topbar", {
		unicode: "{U+018B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_d_topbar", {
		unicode: "{U+018C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_c_let_e_acute", {
		unicode: "{U+00C9}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_e_acute", {
		unicode: "{U+00E9}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_e_breve", {
		unicode: "{U+0114}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_s_let_e_breve", {
		unicode: "{U+0115}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_c_let_e_breve_cedilla", {
		unicode: "{U+1E1C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "cedilla"), Chr(0x0114) GetChar("cedilla")],
	},
	"lat_s_let_e_breve_cedilla", {
		unicode: "{U+1E1D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("breve", "cedilla"), Chr(0x0115) GetChar("cedilla")],
	},
	"lat_c_let_e_breve_inverted", {
		unicode: "{U+0206}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_s_let_e_breve_inverted", {
		unicode: "{U+0207}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_c_let_e_circumflex", {
		unicode: "{U+00CA}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_e_circumflex", {
		unicode: "{U+00EA}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_e_circumflex_acute", {
		unicode: "{U+1EBE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "acute"), "$" GetChar("acute", "circumflex"), Chr(0x00CA) GetChar("acute"), Chr(0x00C9) GetChar("circumflex")],
	},
	"lat_s_let_e_circumflex_acute", {
		unicode: "{U+1EBF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "acute"), "$" GetChar("acute", "circumflex"), Chr(0x00EA) GetChar("acute"), Chr(0x00E9) GetChar("circumflex")],
	},
	"lat_c_let_e_circumflex_dot_below", {
		unicode: "{U+1EC6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "dot_below"), "$" GetChar("dot_below", "circumflex"), Chr(0x00CA) GetChar("dot_below"), Chr(0x1EB8) GetChar("circumflex")],
	},
	"lat_s_let_e_circumflex_dot_below", {
		unicode: "{U+1EC7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "dot_below"), "$" GetChar("dot_below", "circumflex"), Chr(0x00EA) GetChar("dot_below"), Chr(0x1EB9) GetChar("circumflex")],
	},
	"lat_c_let_e_circumflex_grave", {
		unicode: "{U+1EC0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "grave"), "$" GetChar("grave", "circumflex"), Chr(0x00CA) GetChar("grave"), Chr(0x00C8) GetChar("circumflex")],
	},
	"lat_s_let_e_circumflex_grave", {
		unicode: "{U+1EC1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "grave"), "$" GetChar("grave", "circumflex"), Chr(0x00EA) GetChar("grave"), Chr(0x00E8) GetChar("circumflex")],
	},
	"lat_c_let_e_circumflex_hook_above", {
		unicode: "{U+1EC2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "hook_above"), "$" GetChar("hook_above", "circumflex"), Chr(0x00CA) GetChar("hook_above"), Chr(0x1EBA) GetChar("circumflex")],
	},
	"lat_s_let_e_circumflex_hook_above", {
		unicode: "{U+1EC3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "hook_above"), "$" GetChar("hook_above", "circumflex"), Chr(0x00EA) GetChar("hook_above"), Chr(0x1EBB) GetChar("circumflex")],
	},
	"lat_c_let_e_circumflex_tilde", {
		unicode: "{U+1EC4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "tilde"), "$" GetChar("tilde", "circumflex"), Chr(0x00CA) GetChar("tilde"), Chr(0x1EBC) GetChar("circumflex")],
	},
	"lat_s_let_e_circumflex_tilde", {
		unicode: "{U+1EC5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "tilde"), "$" GetChar("tilde", "circumflex"), Chr(0x00EA) GetChar("tilde"), Chr(0x1EBD) GetChar("circumflex")],
	},
	"lat_c_let_e_circumflex_below", {
		unicode: "{U+1E18}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_s_let_e_circumflex_below", {
		unicode: "{U+1E19}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_c_let_e_caron", {
		unicode: "{U+011A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_e_caron", {
		unicode: "{U+011B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_e_cedilla", {
		unicode: "{U+0228}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_e_cedilla", {
		unicode: "{U+0229}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("cedilla"),
	},
	"lat_c_let_e_dot_above", {
		unicode: "{U+0116}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_e_dot_above", {
		unicode: "{U+0117}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_e_dot_below", {
		unicode: "{U+1EB8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_e_dot_below", {
		unicode: "{U+1EB9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_e_diaeresis", {
		unicode: "{U+00CB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		tags: ["R$ с диерезисом", "E$ with diaeresis"],
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_e_diaeresis", {
		unicode: "{U+00EB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_e_grave", {
		unicode: "{U+00C8}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_e_grave", {
		unicode: "{U+00E8}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_c_let_e_grave_double", {
		unicode: "{U+0204}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_s_let_e_grave_double", {
		unicode: "{U+0205}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_c_let_e_hook_above", {
		unicode: "{U+1EBA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_e_hook_above", {
		unicode: "{U+1EBB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_e_retroflex_hook", {
		unicode: "{U+1D92}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_s_let_e_notch", {
		unicode: "{U+2C78}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "e" . GetChar("arrow_right"),
	},
	"lat_c_let_e_macron", {
		unicode: "{U+0112}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_s_let_e_macron", {
		unicode: "{U+0113}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_c_let_e_macron_acute", {
		unicode: "{U+1E16}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "acute"), "$" GetChar("acute", "macron"), Chr(0x0112) GetChar("acute"), Chr(0x00C9) GetChar("macron")],
	},
	"lat_s_let_e_macron_acute", {
		unicode: "{U+1E17}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "acute"), "$" GetChar("acute", "macron"), Chr(0x0113) GetChar("acute"), Chr(0x00E9) GetChar("macron")],
	},
	"lat_c_let_e_macron_grave", {
		unicode: "{U+1E14}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "grave"), "$" GetChar("grave", "macron"), Chr(0x0112) GetChar("grave"), Chr(0x00C8) GetChar("macron")],
	},
	"lat_s_let_e_macron_grave", {
		unicode: "{U+1E15}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "grave"), "$" GetChar("grave", "macron"), Chr(0x0113) GetChar("grave"), Chr(0x00E8) GetChar("macron")],
	},
	"lat_c_let_e_solidus_long", {
		unicode: "{U+0246}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_e_solidus_long", {
		unicode: "{U+0247}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_e_ogonek", {
		unicode: "{U+0118}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_s_let_e_ogonek", {
		unicode: "{U+0119}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_c_let_e_tilde", {
		unicode: "{U+1EBC}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_e_tilde", {
		unicode: "{U+1EBD}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_c_let_e_tilde_below", {
		unicode: "{U+1E1A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_below"),
	},
	"lat_s_let_e_tilde_below", {
		unicode: "{U+1E1B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_below"),
	},
	"lat_c_let_f_dot_above", {
		unicode: "{U+1E1E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_f_dot_above", {
		unicode: "{U+1E1F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_f_common_hook", {
		unicode: "{U+0191}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_f_common_hook", {
		unicode: "{U+0192}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_f_palatal_hook", {
		unicode: "{U+1D82}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_f_stroke_short", {
		unicode: "{U+A798}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_f_stroke_short", {
		unicode: "{U+A799}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_f_tilde_overlay", {
		unicode: "{U+1D6E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_c_let_g_acute", {
		unicode: "{U+01F4}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_g_acute", {
		unicode: "{U+01F5}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_g_breve", {
		unicode: "{U+011E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_s_let_g_breve", {
		unicode: "{U+011F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_c_let_g_circumflex", {
		unicode: "{U+011C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_g_circumflex", {
		unicode: "{U+011D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_g_caron", {
		unicode: "{U+01E6}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_g_caron", {
		unicode: "{U+01E7}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_g_cedilla", {
		unicode: "{U+0122}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_g_cedilla", {
		unicode: "{U+0123}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_g_crossed_tail", {
		unicode: "{U+AB36}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_c_let_g_dot_above", {
		unicode: "{U+0120}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_g_dot_above", {
		unicode: "{U+0121}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_g_macron", {
		unicode: "{U+1E20}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_s_let_g_macron", {
		unicode: "{U+1E21}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_c_let_g_solidus_long", {
		unicode: "{U+A7A0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_g_solidus_long", {
		unicode: "{U+A7A1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_g_stroke_short", {
		unicode: "{U+01E4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_g_stroke_short", {
		unicode: "{U+01E5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_g_common_hook", {
		unicode: "{U+0193}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_g_common_hook", {
		unicode: "{U+0260}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_g_palatal_hook", {
		unicode: "{U+1D83}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_h_breve_below", {
		unicode: "{U+1E2A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		recipe: "$" GetChar("breve_below"),
	},
	"lat_s_let_h_breve_below", {
		unicode: "{U+1E2B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		recipe: "$" GetChar("breve_below"),
	},
	"lat_c_let_h_circumflex", {
		unicode: "{U+0124}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_h_circumflex", {
		unicode: "{U+0125}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_h_caron", {
		unicode: "{U+021E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_h_caron", {
		unicode: "{U+021F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_h_cedilla", {
		unicode: "{U+1E28}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_h_cedilla", {
		unicode: "{U+1E29}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_c_let_h_dot_above", {
		unicode: "{U+1E22}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_h_dot_above", {
		unicode: "{U+1E23}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_h_dot_below", {
		unicode: "{U+1E24}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_h_dot_below", {
		unicode: "{U+1E25}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_h_diaeresis", {
		unicode: "{U+1E26}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_h_diaeresis", {
		unicode: "{U+1E27}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_h_descender", {
		unicode: "{U+2C67}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_h_descender", {
		unicode: "{U+2C68}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "h" GetChar("arrow_down"),
	},
	"lat_c_let_h_common_hook", {
		unicode: "{U+A7AA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_h_common_hook", {
		unicode: "{U+0266}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "h" . GetChar("arrow_left"),
	},
	"lat_s_let_h_palatal_hook", {
		unicode: "{U+A795}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_h_hwair", {
		unicode: "{U+01F6}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		tags: ["прописная буква Хвайр", "capital letter Hwair"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("arrow_right"),
	},
	"lat_s_let_h_hwair", {
		unicode: "{U+0195}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		tags: ["строчная буква хвайр", "small letter hwair"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("arrow_right"),
	},
	"lat_c_let_h_halfleft", {
		unicode: "{U+2C75}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "H/",
	},
	"lat_s_let_h_halfleft", {
		unicode: "{U+2C76}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "h/",
	},
	"lat_c_let_h_halfright", {
		unicode: "{U+A7F5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "H/" GetChar("arrow_right"),
	},
	"lat_s_let_h_halfright", {
		unicode: "{U+A7F6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "h/" GetChar("arrow_right"),
	},
	"lat_c_let_h_stroke_short", {
		unicode: "{U+0126}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_h_stroke_short", {
		unicode: "{U+0127}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_i_acute", {
		unicode: "{U+00CD}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_i_acute", {
		unicode: "{U+00ED}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_i_breve", {
		unicode: "{U+012C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_s_let_i_breve", {
		unicode: "{U+012D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_c_let_i_breve_inverted", {
		unicode: "{U+020A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_s_let_i_breve_inverted", {
		unicode: "{U+020B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_c_let_i_circumflex", {
		unicode: "{U+00CE}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_i_circumflex", {
		unicode: "{U+00EE}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_i_caron", {
		unicode: "{U+01CF}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_i_caron", {
		unicode: "{U+01D0}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_i_dot_above", {
		unicode: "{U+0130}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ $",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_i_dot_below", {
		unicode: "{U+1ECA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_i_dot_below", {
		unicode: "{U+1ECB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_i_diaeresis", {
		unicode: "{U+00CF}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_i_diaeresis", {
		unicode: "{U+00EF}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_i_diaeresis_acute", {
		unicode: "{U+1E2F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "acute"), "$" GetChar("acute", "diaeresis"), Chr(0x00CF) GetChar("acute"), Chr(0x00CD) GetChar("diaeresis")],
	},
	"lat_s_let_i_diaeresis_acute", {
		unicode: "{U+1E2E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "acute"), "$" GetChar("acute", "diaeresis"), Chr(0x00EF) GetChar("acute"), Chr(0x00ED) GetChar("diaeresis")],
	},
	"lat_c_let_i_grave", {
		unicode: "{U+00CC}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_i_grave", {
		unicode: "{U+00EC}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_c_let_i_grave_double", {
		unicode: "{U+0208}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_s_let_i_grave_double", {
		unicode: "{U+0209}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_c_let_i_hook_above", {
		unicode: "{U+1EC8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_i_hook_above", {
		unicode: "{U+1EC9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_i_retroflex_hook", {
		unicode: "{U+1D96}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_c_let_i_macron", {
		unicode: "{U+012A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_s_let_i_macron", {
		unicode: "{U+012B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_c_let_i_stroke_short", {
		unicode: "{U+0197}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_i_stroke_short", {
		unicode: "{U+0268}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_c_let_i_stroke_short", {
		unicode: "{U+1D7B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["капитель I со штрихом", "small capital I with stroke"],
		recipe: ["$↓" GetChar("stroke_short"), Chr(0x026A) GetChar("stroke_short")],
	},
	"lat_s_let_i_stroke_short_retroflex_hook", {
		unicode: "{U+1DF1A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("stroke_short", "retroflex_hook_below"), Chr(0x0268) GetChar("retroflex_hook_below")],
	},
	"lat_c_let_i_ogonek", {
		unicode: "{U+012E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_s_let_i_ogonek", {
		unicode: "{U+012F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_c_let_i_tilde", {
		unicode: "{U+0128}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_i_tilde", {
		unicode: "{U+0129}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_c_let_i_tilde_below", {
		unicode: "{U+1E2C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_below"),
	},
	"lat_s_let_i_tilde_below", {
		unicode: "{U+1E2D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_below"),
	},
	;
	"lat_c_let_j_circumflex", {
		unicode: "{U+0134}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_j_circumflex", {
		unicode: "{U+0135}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_j_caron", {
		unicode: "{U+01F0}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_j_crossed_tail", {
		unicode: "{U+A7B2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_c_let_j_stroke_short", {
		unicode: "{U+0248}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_j_stroke_short", {
		unicode: "{U+0249}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_k_acute", {
		unicode: "{U+1E30}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_k_acute", {
		unicode: "{U+1E31}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_k_caron", {
		unicode: "{U+01E8}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_k_caron", {
		unicode: "{U+01E9}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_k_cedilla", {
		unicode: "{U+0136}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_k_cedilla", {
		unicode: "{U+0137}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_c_let_k_dot_below", {
		unicode: "{U+1E32}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_k_dot_below", {
		unicode: "{U+1E33}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_k_common_hook", {
		unicode: "{U+0199}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "K" . GetChar("arrow_up"),
	},
	"lat_s_let_k_common_hook", {
		unicode: "{U+0198}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "k" . GetChar("arrow_up"),
	},
	"lat_s_let_k_palatal_hook", {
		unicode: "{U+1D84}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_k_solidus_long", {
		unicode: "{U+A7A2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_k_solidus_long", {
		unicode: "{U+A7A3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_k_solidus_short", {
		unicode: "{U+A742}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_short"),
	},
	"lat_s_let_k_solidus_short", {
		unicode: "{U+A743}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_short"),
	},
	"lat_c_let_k_stroke_short", {
		unicode: "{U+A740}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_k_stroke_short", {
		unicode: "{U+A741}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_k_stroke_short_solidus_short", {
		unicode: "{U+A744}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short", "solidus_short"),
	},
	"lat_s_let_k_stroke_short_solidus_short", {
		unicode: "{U+A745}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short", "solidus_short"),
	},
	"lat_c_let_k_line_below", {
		unicode: "{U+1E34}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_k_line_below", {
		unicode: "{U+1E35}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_k_descender", {
		unicode: "{U+2C69}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_k_descender", {
		unicode: "{U+2C6A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "k" . GetChar("arrow_down"),
	},
	"lat_c_let_l_acute", {
		unicode: "{U+0139}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_l_acute", {
		unicode: "{U+013A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_l_circumflex_below", {
		unicode: "{U+1E3C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_s_let_l_circumflex_below", {
		unicode: "{U+1E3D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_c_let_l_caron", {
		unicode: "{U+013D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_l_caron", {
		unicode: "{U+013E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_l_cedilla", {
		unicode: "{U+013B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_l_cedilla", {
		unicode: "{U+013C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_l_curl", {
		unicode: "{U+0234}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_c_let_l_belt", {
		unicode: "{U+A7AD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_s_let_l_belt", {
		unicode: "{U+026C}",
		modifierForm: "{U+1079B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_s_let_l_palatal_hook_belt", {
		unicode: "{U+1DF13}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped", "palatal_hook_below"),
	},
	"lat_s_let_l_retroflex_hook_belt", {
		unicode: "{U+A78E}",
		modifierForm: "{U+1079D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped", "retroflex_hook_below"),
	},
	"lat_s_let_l_fishhook", {
		unicode: "{U+1DF11}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right"),
	},
	"lat_c_let_l_dot_below", {
		unicode: "{U+1E36}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_l_dot_below", {
		unicode: "{U+1E37}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_l_dot_middle", {
		unicode: "{U+013F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "L·",
	},
	"lat_s_let_l_dot_middle", {
		unicode: "{U+0140}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "l·",
	},
	"lat_s_let_l_palatal_hook", {
		unicode: "{U+1D85}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_s_let_l_retroflex_hook", {
		unicode: "{U+026D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_s_let_l_ring_middle", {
		unicode: "{U+AB39}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "l◦",
	},
	"lat_c_let_l_solidus_short", {
		unicode: "{U+0141}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_short"),
	},
	"lat_s_let_l_solidus_short", {
		unicode: "{U+0142}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_short"),
	},
	"lat_c_let_l_stroke_short", {
		unicode: "{U+023D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_l_stroke_short", {
		unicode: "{U+019A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_l_stroke_short_high", {
		unicode: "{U+A748}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["прописная буква L с штрихом сверху", "capital letter L with high stroke"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_l_stroke_short_high", {
		unicode: "{U+A749}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["строчная буква l с штрихом сверху", "small letter l with high stroke"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_l_stroke_short_double", {
		unicode: "{U+2C60}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("stroke_short", "stroke_short"), Chr(0x023D) GetChar("stroke_short")],
	},
	"lat_s_let_l_stroke_short_double", {
		unicode: "{U+2C61}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("stroke_short", "stroke_short"), Chr(0x019A) GetChar("stroke_short")],
	},
	"lat_c_let_l_macron_dot_below", {
		unicode: "{U+1E38}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron", "dot_below"),
	},
	"lat_s_let_l_macron_dot_below", {
		unicode: "{U+1E39}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron", "dot_below"),
	},
	"lat_c_let_l_line_below", {
		unicode: "{U+1E3A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_l_line_below", {
		unicode: "{U+1E3B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_l_tilde_overlay", {
		unicode: "{U+2C62}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_s_let_l_tilde_overlay", {
		unicode: "{U+026B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_s_let_l_tilde_overlay_double", {
		unicode: "{U+AB38}",
		combiningForm: "{U+1DEC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay", "tilde_overlay"),
	},
	"lat_s_let_l_inverted_lazy_s", {
		unicode: "{U+AB37}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("arrow_right_circle") "s", "$" GetChar("inverted_lazy_s")],
	},
	;
	"lat_c_let_m_acute", {
		unicode: "{U+1E3E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_m_acute", {
		unicode: "{U+1E3F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_m_dot_above", {
		unicode: "{U+1E40}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_m_dot_above", {
		unicode: "{U+1E41}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_m_dot_below", {
		unicode: "{U+1E42}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_m_dot_below", {
		unicode: "{U+1E43}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_m_crossed_tail", {
		unicode: "{U+AB3A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_c_let_m_common_hook", {
		unicode: "{U+2C6E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_m_common_hook", {
		unicode: "{U+0271}",
		modifierForm: "{U+1DAC}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_m_palatal_hook", {
		unicode: "{U+1D86}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_s_let_m_tilde_overlay", {
		unicode: "{U+1D6F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_s_let_m_turned_long_leg", {
		unicode: "{U+0270}",
		modifierForm: "{U+1DAD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["строчная буква m перевёрнутая с ножкой", "small letter m turned with long leg"],
		recipe: "$" GetChar("arrow_left_circle"),
	},
	;
	"lat_c_let_n_acute", {
		unicode: "{U+0143}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_n_acute", {
		unicode: "{U+0144}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_n_circumflex_below", {
		unicode: "{U+1E4A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_s_let_n_circumflex_below", {
		unicode: "{U+1E4B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_c_let_n_caron", {
		unicode: "{U+0147}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_n_caron", {
		unicode: "{U+0148}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_n_cedilla", {
		unicode: "{U+0145}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_n_cedilla", {
		unicode: "{U+0146}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_n_curl", {
		unicode: "{U+0235}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_s_let_n_crossed_tail", {
		unicode: "{U+AB3B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_c_let_n_dot_above", {
		unicode: "{U+1E44}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_n_dot_above", {
		unicode: "{U+1E45}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_n_dot_below", {
		unicode: "{U+1E46}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_n_dot_below", {
		unicode: "{U+1E47}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"let_c_let_n_descender", {
		unicode: "{U+A790}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"let_s_let_n_descender", {
		unicode: "{U+A791}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_c_let_n_grave", {
		unicode: "{U+01F8}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_n_grave", {
		unicode: "{U+01F9}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_c_let_n_common_hook", {
		unicode: "{U+019D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_n_common_hook", {
		unicode: "{U+0272}",
		modifierForm: "{U+1DAE}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_n_palatal_hook", {
		unicode: "{U+1D87}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_s_let_n_retroflex_hook", {
		unicode: "{U+0273}",
		modifierForm: "{U+1DAF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_c_let_n_line_below", {
		unicode: "{U+1E48}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_n_line_below", {
		unicode: "{U+1E49}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_n_solidus_long", {
		unicode: "{U+A7A4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_n_solidus_long", {
		unicode: "{U+A7A5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_n_tilde", {
		unicode: "{U+00D1}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_n_tilde", {
		unicode: "{U+00F1}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_n_tilde_overlay", {
		unicode: "{U+1D70}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_c_let_n_long_leg", {
		unicode: "{U+0220}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["R$ с ножкой", "E$ with long leg"],
		recipe: "$" GetChar("arrow_rightdown"),
	},
	"lat_s_let_n_long_leg", {
		unicode: "{U+019E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["R$ с ножкой", "E$ with long leg"],
		recipe: "$" GetChar("arrow_rightdown"),
	},
	;
	"lat_c_let_o_acute", {
		unicode: "{U+00D3}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_o_acute", {
		unicode: "{U+00F3}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_o_acute_horn", {
		unicode: "{U+1EDA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("acute", "horn"), "$" GetChar("horn", "acute"), Chr(0x00D3) GetChar("horn"), Chr(0x01A0) GetChar("acute")],
	},
	"lat_s_let_o_acute_horn", {
		unicode: "{U+1EDB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("acute", "horn"), "$" GetChar("horn", "acute"), Chr(0x00F3) GetChar("horn"), Chr(0x01A1) GetChar("acute")],
	},
	"lat_c_let_o_acute_double", {
		unicode: "{U+0150}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ $",
		recipe: "$" GetChar("acute_double"),
	},
	"lat_s_let_o_acute_double", {
		unicode: "{U+0151}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ $",
		recipe: "$" GetChar("acute_double"),
	},
	"lat_c_let_o_breve", {
		unicode: "{U+014E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve"),
	},
	"lat_s_let_o_breve", {
		unicode: "{U+014F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve"),
	},
	"lat_c_let_o_breve_inverted", {
		unicode: "{U+020E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_s_let_o_breve_inverted", {
		unicode: "{U+020F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_c_let_o_circumflex", {
		unicode: "{U+00D4}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_o_circumflex", {
		unicode: "{U+00F4}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_o_circumflex_acute", {
		unicode: "{U+1ED0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "acute"), "$" GetChar("acute", "circumflex"), Chr(0x00D4) GetChar("acute"), Chr(0x00D3) GetChar("circumflex")],
	},
	"lat_s_let_o_circumflex_acute", {
		unicode: "{U+1ED1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "acute"), "$" GetChar("acute", "circumflex"), Chr(0x00F4) GetChar("acute"), Chr(0x00F3) GetChar("circumflex")],
	},
	"lat_c_let_o_circumflex_dot_below", {
		unicode: "{U+1ED8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "dot_below"), "$" GetChar("dot_below", "circumflex"), Chr(0x00D4) GetChar("dot_below"), Chr(0x1ECC) GetChar("circumflex")],
	},
	"lat_s_let_o_circumflex_dot_below", {
		unicode: "{U+1ED9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "dot_below"), "$" GetChar("dot_below", "circumflex"), Chr(0x00F4) GetChar("dot_below"), Chr(0x1ECD) GetChar("circumflex")],
	},
	"lat_c_let_o_circumflex_grave", {
		unicode: "{U+1ED2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "grave"), "$" GetChar("grave", "circumflex"), Chr(0x00D4) GetChar("grave"), Chr(0x00D2) GetChar("circumflex")],
	},
	"lat_s_let_o_circumflex_grave", {
		unicode: "{U+1ED3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "grave"), "$" GetChar("grave", "circumflex"), Chr(0x00F4) GetChar("grave"), Chr(0x00F2) GetChar("circumflex")],
	},
	"lat_c_let_o_circumflex_hook_above", {
		unicode: "{U+1ED4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "hook_above"), "$" GetChar("hook_above", "circumflex"), Chr(0x00D4) GetChar("hook_above"), Chr(0x1ECE) GetChar("circumflex")],
	},
	"lat_s_let_o_circumflex_hook_above", {
		unicode: "{U+1ED5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "hook_above"), "$" GetChar("hook_above", "circumflex"), Chr(0x00F4) GetChar("hook_above"), Chr(0x1ECF) GetChar("circumflex")],
	},
	"lat_c_let_o_circumflex_tilde", {
		unicode: "{U+1ED6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "tilde"), "$" GetChar("tilde", "circumflex"), Chr(0x00D4) GetChar("tilde"), Chr(0x00D5) GetChar("circumflex")],
	},
	"lat_s_let_o_circumflex_tilde", {
		unicode: "{U+1ED7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("circumflex", "tilde"), "$" GetChar("tilde", "circumflex"), Chr(0x00F4) GetChar("tilde"), Chr(0x00F5) GetChar("circumflex")],
	},
	"lat_c_let_o_caron", {
		unicode: "{U+01D1}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_o_caron", {
		unicode: "{U+01D2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_o_dot_above", {
		unicode: "{U+022E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_o_dot_above", {
		unicode: "{U+022F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_o_dot_below", {
		unicode: "{U+1ECC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_o_dot_below", {
		unicode: "{U+1ECD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_o_dot_below_horn", {
		unicode: "{U+1EE2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_below", "horn"), "$" GetChar("horn", "dot_below"), Chr(0x1ECC) GetChar("horn"), Chr(0x01A0) GetChar("dot_below")],
	},
	"lat_s_let_o_dot_below_horn", {
		unicode: "{U+1EE3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_below", "horn"), "$" GetChar("horn", "dot_below"), Chr(0x1ECD) GetChar("horn"), Chr(0x01A1) GetChar("dot_below")],
	},
	"lat_c_let_o_diaeresis", {
		unicode: "{U+00D6}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_o_diaeresis", {
		unicode: "{U+00F6}",
		combiningForm: "{U+1DF3}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_o_grave", {
		unicode: "{U+00D2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_o_grave", {
		unicode: "{U+00F2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_c_let_o_grave_horn", {
		unicode: "{U+1EDC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("grave", "horn"), "$" GetChar("horn", "grave"), Chr(0x00D2) GetChar("horn"), Chr(0x01A0) GetChar("grave")],
	},
	"lat_s_let_o_grave_horn", {
		unicode: "{U+1EDD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("grave", "horn"), "$" GetChar("horn", "grave"), Chr(0x00F2) GetChar("horn"), Chr(0x01A1) GetChar("grave")],
	},
	"lat_c_let_o_grave_double", {
		unicode: "{U+020C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_s_let_o_grave_double", {
		unicode: "{U+020D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_c_let_o_loop", {
		unicode: "{U+A74C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up_ushaped"),
	},
	"lat_s_let_o_loop", {
		unicode: "{U+A74D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up_ushaped"),
	},
	"lat_c_let_o_hook_above", {
		unicode: "{U+1ECE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_o_hook_above", {
		unicode: "{U+1ECF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_c_let_o_hook_above_horn", {
		unicode: "{U+1EDE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("hook_above", "horn"), "$" GetChar("horn", "hook_above"), Chr(0x1ECE) GetChar("horn"), Chr(0x01A0) GetChar("hook_above")],
	},
	"lat_s_let_o_hook_above_horn", {
		unicode: "{U+1EDF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("hook_above", "horn"), "$" GetChar("horn", "hook_above"), Chr(0x1ECF) GetChar("horn"), Chr(0x01A1) GetChar("hook_above")],
	},
	"lat_s_let_o_retroflex_hook", {
		unicode: "{U+1DF1B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_s_let_o_retroflex_hook_open", {
		unicode: "{U+1D97}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$-" GetChar("retroflex_hook_below"), Chr(0x0254) GetChar("retroflex_hook_below")],
	},
	"lat_c_let_o_horn", {
		unicode: "{U+01A0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("horn"),
	},
	"lat_s_let_o_horn", {
		unicode: "{U+01A1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("horn"),
	},
	"lat_c_let_o_macron", {
		unicode: "{U+014C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_s_let_o_macron", {
		unicode: "{U+014D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_c_let_o_macron_acute", {
		unicode: "{U+1E52}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "acute"), "$" GetChar("acute", "macron"), Chr(0x014C) GetChar("acute"), Chr(0x00D3) GetChar("macron")],
	},
	"lat_s_let_o_macron_acute", {
		unicode: "{U+1E53}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "acute"), "$" GetChar("acute", "macron"), Chr(0x014D) GetChar("acute"), Chr(0x00F3) GetChar("macron")],
	},
	"lat_c_let_o_macron_dot_above", {
		unicode: "{U+0230}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "dot_above"), "$" GetChar("dot_above", "macron"), Chr(0x014C) GetChar("dot_above"), Chr(0x022E) GetChar("macron")],
	},
	"lat_s_let_o_macron_dot_above", {
		unicode: "{U+0231}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "dot_above"), "$" GetChar("dot_above", "macron"), Chr(0x014D) GetChar("dot_above"), Chr(0x022F) GetChar("macron")],
	},
	"lat_c_let_o_macron_diaeresis", {
		unicode: "{U+022A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "diaeresis"), "$" GetChar("diaeresis", "macron"), Chr(0x014C) GetChar("diaeresis"), Chr(0x00D6) GetChar("macron")],
	},
	"lat_s_let_o_macron_diaeresis", {
		unicode: "{U+022B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "diaeresis"), "$" GetChar("diaeresis", "macron"), Chr(0x014D) GetChar("diaeresis"), Chr(0x00F6) GetChar("macron")],
	},
	"lat_c_let_o_macron_grave", {
		unicode: "{U+1E50}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "grave"), "$" GetChar("grave", "macron"), Chr(0x014C) GetChar("grave"), Chr(0x00D2) GetChar("macron")],
	},
	"lat_s_let_o_macron_grave", {
		unicode: "{U+1E51}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "grave"), "$" GetChar("grave", "macron"), Chr(0x014D) GetChar("grave"), Chr(0x00F2) GetChar("macron")],
	},
	"lat_c_let_o_macron_ogonek", {
		unicode: "{U+01EC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "ogonek"), "$" GetChar("ogonek", "macron"), Chr(0x014C) GetChar("ogonek"), Chr(0x01EA) GetChar("macron")],
	},
	"lat_s_let_o_macron_ogonek", {
		unicode: "{U+01ED}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "ogonek"), "$" GetChar("ogonek", "macron"), Chr(0x014D) GetChar("ogonek"), Chr(0x01EB) GetChar("macron")],
	},
	"lat_c_let_o_macron_tilde", {
		unicode: "{U+022C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "tilde"), "$" GetChar("tilde", "macron"), Chr(0x014C) GetChar("tilde"), Chr(0x00D5) GetChar("macron")],
	},
	"lat_s_let_o_macron_tilde", {
		unicode: "{U+022D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "tilde"), "$" GetChar("tilde", "macron"), Chr(0x014D) GetChar("tilde"), Chr(0x00F5) GetChar("macron")],
	},
	"lat_c_let_o_solidus_long", {
		unicode: "{U+00D8}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_o_solidus_long", {
		unicode: "{U+00F8}",
		modifierForm: "{U+107A2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_o_solidus_long_acute", {
		unicode: "{U+01FE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("solidus_long", "acute"), "$" GetChar("acute", "solidus_long"), Chr(0x00D8) GetChar("acute"), Chr(0x00D3) GetChar("solidus_long")],
	},
	"lat_s_let_o_solidus_long_acute", {
		unicode: "{U+01FF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("solidus_long", "acute"), "$" GetChar("acute", "solidus_long"), Chr(0x00F8) GetChar("acute"), Chr(0x00F3) GetChar("solidus_long")],
	},
	"lat_s_let_o_solidus_long_open", {
		unicode: "{U+AB3F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$-" GetChar("solidus_long"), Chr(0x0254) GetChar("solidus_long")],
	},
	"lat_s_let_o_solidus_long_sideways", {
		unicode: "{U+1D13}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("arrow_right_circle", "solidus_long"), Chr(0x1D11) GetChar("solidus_long")],
	},
	"lat_c_let_o_stroke_long", {
		unicode: "{U+A74A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_long"),
	},
	"lat_s_let_o_stroke_long", {
		unicode: "{U+A74B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("stroke_long"),
	},
	"lat_c_let_o_ogonek", {
		unicode: "{U+01EA}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_s_let_o_ogonek", {
		unicode: "{U+01EB}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_c_let_o_tilde", {
		unicode: "{U+00D5}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_o_tilde", {
		unicode: "{U+00F5}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_c_let_o_tilde_acute", {
		unicode: "{U+1E4C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "acute"), "$" GetChar("acute", "tilde"), Chr(0x00D5) GetChar("acute"), Chr(0x00D3) GetChar("tilde")],
	},
	"lat_s_let_o_tilde_acute", {
		unicode: "{U+1E4D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "acute"), "$" GetChar("acute", "tilde"), Chr(0x00F5) GetChar("acute"), Chr(0x00F3) GetChar("tilde")],
	},
	"lat_c_let_o_tilde_diaeresis", {
		unicode: "{U+1E4E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "diaeresis"), "$" GetChar("diaeresis", "tilde"), Chr(0x00D5) GetChar("diaeresis"), Chr(0x00D6) GetChar("tilde")],
	},
	"lat_s_let_o_tilde_diaeresis", {
		unicode: "{U+1E4F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "diaeresis"), "$" GetChar("diaeresis", "tilde"), Chr(0x00F5) GetChar("diaeresis"), Chr(0x00F6) GetChar("tilde")],
	},
	"lat_c_let_o_tilde_horn", {
		unicode: "{U+1EE0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "horn"), "$" GetChar("horn", "tilde"), Chr(0x00D5) GetChar("horn"), Chr(0x01A0) GetChar("tilde")],
	},
	"lat_s_let_o_tilde_horn", {
		unicode: "{U+1EE1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "horn"), "$" GetChar("horn", "tilde"), Chr(0x00F5) GetChar("horn"), Chr(0x01A1) GetChar("tilde")],
	},
	"lat_c_let_o_tilde_overlay", {
		unicode: "{U+019F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_s_let_o_tilde_overlay", {
		unicode: "{U+0275}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	;
	"lat_c_let_p_acute", {
		unicode: "{U+1E54}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_p_acute", {
		unicode: "{U+1E55}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_p_dot_above", {
		unicode: "{U+1E56}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_p_dot_above", {
		unicode: "{U+1E57}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_p_squirrel_tail", {
		unicode: "{U+A754}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_p_squirrel_tail", {
		unicode: "{U+A755}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_c_let_p_common_hook", {
		unicode: "{U+01A4}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_p_common_hook", {
		unicode: "{U+01A5}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_p_palatal_hook", {
		unicode: "{U+1D88}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_p_flourish", {
		unicode: "{U+A752}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_s_let_p_flourish", {
		unicode: "{U+A753}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_c_let_p_stroke_short", {
		unicode: "{U+2C63}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_p_stroke_short", {
		unicode: "{U+1D7D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_p_stroke_short_down", {
		unicode: "{U+A750}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["R$ со штрихом снизу", "E$ with down stroke"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_p_stroke_short_down", {
		unicode: "{U+A751}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["R$ со штрихом снизу", "E$ with down stroke"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_p_tilde_overlay", {
		unicode: "{U+1D71}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	;
	"lat_c_let_q_common_hook", {
		unicode: "{U+024A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_right"),
	},
	"lat_s_let_q_common_hook", {
		unicode: "{U+024B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("arrow_right"),
	},
	"lat_s_let_q_common_hook_above", {
		unicode: "{U+02A0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_c_let_q_solidus_short", {
		unicode: "{U+A758}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_short"),
	},
	"lat_s_let_q_solidus_short", {
		unicode: "{U+A759}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_short"),
	},
	"lat_c_let_q_stroke_short_down", {
		unicode: "{U+A756}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["R$ со штрихом снизу", "E$ with down stroke"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_q_stroke_short_down", {
		unicode: "{U+A757}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["R$ со штрихом снизу", "E$ with down stroke"],
		recipe: "$" GetChar("stroke_short"),
	},
	;
	"lat_c_let_r_acute", {
		unicode: "{U+0154}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_r_acute", {
		unicode: "{U+0155}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_r_breve_inverted", {
		unicode: "{U+0212}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_s_let_r_breve_inverted", {
		unicode: "{U+0213}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_c_let_r_caron", {
		unicode: "{U+0158}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_r_caron", {
		unicode: "{U+0159}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_r_cedilla", {
		unicode: "{U+0156}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_r_cedilla", {
		unicode: "{U+0157}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_r_crossed_tail", {
		unicode: "{U+AB49}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_c_let_r_dot_above", {
		unicode: "{U+1E58}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_r_dot_above", {
		unicode: "{U+1E59}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_r_dot_below", {
		unicode: "{U+1E5A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_r_dot_below", {
		unicode: "{U+1E5B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_r_grave_double", {
		unicode: "{U+0210}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_s_let_r_grave_double", {
		unicode: "{U+0211}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_s_let_r_palatal_hook", {
		unicode: "{U+1D89}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_r_line_below", {
		unicode: "{U+1E5E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_r_line_below", {
		unicode: "{U+A7A7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_r_solidus_long", {
		unicode: "{U+A7A6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_r_solidus_long", {
		unicode: "{U+A7A7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_r_stroke_short", {
		unicode: "{U+024C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_r_stroke_short", {
		unicode: "{U+024D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_r_macron_dot_below", {
		unicode: "{U+1E5C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron", "dot_below"),
	},
	"lat_s_let_r_macron_dot_below", {
		unicode: "{U+1E5D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron", "dot_below"),
	},
	"lat_c_let_r_tail", {
		unicode: "{U+2C64}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_r_tail", {
		unicode: "{U+027D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_r_tilde_overlay", {
		unicode: "{U+1D72}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_s_let_r_long_leg", {
		unicode: "{U+027C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["R$ с ножкой", "E$ with long leg"],
		recipe: "$" GetChar("arrow_rightdown"),
	},
	;
	;
	"lat_c_let_s_acute", {
		unicode: "{U+015A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_s_acute", {
		unicode: "{U+015B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_s_acute_dot_above", {
		unicode: "{U+1E64}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("acute", "dot_above"), "$" GetChar("dot_above", "acute"), Chr(0x015A) GetChar("dot_above"), Chr(0x1E60) GetChar("dot_above")],
	},
	"lat_s_let_s_acute_dot_above", {
		unicode: "{U+1E65}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("acute", "dot_above"), "$" GetChar("dot_above", "acute"), Chr(0x015B) GetChar("dot_above"), Chr(0x1E61) GetChar("dot_above")],
	},
	"lat_c_let_s_comma_below", {
		unicode: "{U+0218}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("comma_below"),
	},
	"lat_s_let_s_comma_below", {
		unicode: "{U+0219}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("comma_below"),
	},
	"lat_c_let_s_circumflex", {
		unicode: "{U+015C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_s_circumflex", {
		unicode: "{U+015D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_s_caron", {
		unicode: "{U+0160}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_s_caron", {
		unicode: "{U+0161}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_s_caron_dot_above", {
		unicode: "{U+1E66}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("caron", "dot_above"), Chr(0x015A) GetChar("dot_above")],
	},
	"lat_s_let_s_caron_dot_above", {
		unicode: "{U+1E67}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("caron", "dot_above"), Chr(0x015B) GetChar("dot_above")],
	},
	"lat_c_let_s_cedilla", {
		unicode: "{U+015E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_s_cedilla", {
		unicode: "{U+015F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_s_curl", {
		unicode: "{U+1DF1E}",
		modifierForm: "{U+107BA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_c_let_s_dot_above", {
		unicode: "{U+1E60}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_s_dot_above", {
		unicode: "{U+1E61}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_s_dot_above_dot_below", {
		unicode: "{U+1E68}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_above", "dot_below"), "$" GetChar("dot_below", "dot_above"), Chr(0x1E62) GetChar("dot_below"), Chr(0x1E62) GetChar("dot_above")],
	},
	"lat_s_let_s_dot_above_dot_below", {
		unicode: "{U+1E69}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_above", "dot_below"), "$" GetChar("dot_below", "dot_above"), Chr(0x1E63) GetChar("dot_below"), Chr(0x1E63) GetChar("dot_above")],
	},
	"lat_c_let_s_dot_below", {
		unicode: "{U+1E62}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_s_dot_below", {
		unicode: "{U+1E63}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_s_common_hook", {
		unicode: "{U+A7C5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_s_let_s_common_hook", {
		unicode: "{U+0282}",
		modifierForm: "{U+1DB3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_c_let_s_swash_hook", {
		unicode: "{U+2C7E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_rightdown"),
	},
	"lat_s_let_s_swash_hook", {
		unicode: "{U+023F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_rightdown"),
	},
	"lat_s_let_s_palatal_hook", {
		unicode: "{U+1D8A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_s_solidus_long", {
		unicode: "{U+A7A8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_s_solidus_long", {
		unicode: "{U+A7A9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_s_stroke_short", {
		unicode: "{U+A7C9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_s_stroke_short", {
		unicode: "{U+A7CA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_s_tilde_overlay", {
		unicode: "{U+1D74}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	;
	;
	"lat_c_let_t_comma_below", {
		unicode: "{U+021A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("comma_below"),
	},
	"lat_s_let_t_comma_below", {
		unicode: "{U+021B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("comma_below"),
	},
	"lat_c_let_t_circumflex_below", {
		unicode: "{U+1E70}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_s_let_t_circumflex_below", {
		unicode: "{U+1E71}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("circumflex_below"),
	},
	"lat_c_let_t_caron", {
		unicode: "{U+0164}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_t_caron", {
		unicode: "{U+0165}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_t_cedilla", {
		unicode: "{U+0162}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_t_cedilla", {
		unicode: "{U+0163}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("cedilla"),
	},
	"lat_s_let_t_curl", {
		unicode: "{U+0255}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_c_let_t_dot_above", {
		unicode: "{U+1E6A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_t_dot_above", {
		unicode: "{U+1E6B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_t_dot_below", {
		unicode: "{U+1E6C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_t_dot_below", {
		unicode: "{U+1E6D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_t_diaeresis", {
		unicode: "{U+1E97}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_t_common_hook", {
		unicode: "{U+01AC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_t_common_hook", {
		unicode: "{U+01AD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left"),
	},
	"lat_s_let_t_palatal_hook", {
		unicode: "{U+01AB}",
		modifierForm: "{U+1DB5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_t_retroflex_hook", {
		unicode: "{U+01AE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_s_let_t_retroflex_hook", {
		unicode: "{U+0288}",
		modifierForm: "{U+107AF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_s_let_t_retroflex_hook_common_hook", {
		unicode: "{U+1DF09}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("retroflex_hook_below", "arrow_left"), Chr(0x0288) GetChar("arrow_left")],
	},
	"lat_c_let_t_line_below", {
		unicode: "{U+1E6E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_t_line_below", {
		unicode: "{U+1E6F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_t_solidus_long", {
		unicode: "{U+023E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_t_solidus_long", {
		unicode: "{U+2C66}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_t_stroke_short", {
		unicode: "{U+0166}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_t_stroke_short", {
		unicode: "{U+0167}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_t_tilde_overlay", {
		unicode: "{U+1D75}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	;
	"lat_c_let_u_acute", {
		unicode: "{U+00DA}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_u_acute", {
		unicode: "{U+00FA}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_u_acute_horn", {
		unicode: "{U+1EE8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("acute", "horn"), "$" GetChar("horn", "acute"), Chr(0x00DA) GetChar("horn"), Chr(0x01AF) GetChar("acute")],
	},
	"lat_s_let_u_acute_horn", {
		unicode: "{U+1EE9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("acute", "horn"), "$" GetChar("horn", "acute"), Chr(0x00FA) GetChar("horn"), Chr(0x01B0) GetChar("acute")],
	},
	"lat_c_let_u_acute_double", {
		unicode: "{U+0170}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ $",
		recipe: "$" GetChar("acute_double"),
	},
	"lat_s_let_u_acute_double", {
		unicode: "{U+0171}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ $",
		recipe: "$" GetChar("acute_double"),
	},
	"lat_c_let_u_breve", {
		unicode: "{U+016C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_s_let_u_breve", {
		unicode: "{U+016D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"lat_c_let_u_breve_inverted", {
		unicode: "{U+0216}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_s_let_u_breve_inverted", {
		unicode: "{U+0217}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("breve_inverted"),
	},
	"lat_c_let_u_circumflex", {
		unicode: "{U+00DB}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_u_circumflex", {
		unicode: "{U+00FB}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_u_caron", {
		unicode: "{U+01D3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_u_caron", {
		unicode: "{U+01D4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("caron"),
	},
	"lat_c_let_u_dot_below", {
		unicode: "{U+1EE4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_u_dot_below", {
		unicode: "{U+1EE5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_u_dot_below_horn", {
		unicode: "{U+1EF0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_below", "horn"), "$" GetChar("horn", "dot_below"), Chr(0x1EE4) GetChar("horn"), Chr(0x01AF) GetChar("dot_below")],
	},
	"lat_s_let_u_dot_below_horn", {
		unicode: "{U+1EF1}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("dot_below", "horn"), "$" GetChar("horn", "dot_below"), Chr(0x1EE5) GetChar("horn"), Chr(0x01B0) GetChar("dot_below")],
	},
	"lat_c_let_u_diaeresis", {
		unicode: "{U+00DC}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_u_diaeresis", {
		unicode: "{U+00FC}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_u_diaeresis_acute", {
		unicode: "{U+01D7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "acute"), "$" GetChar("acute", "diaeresis"), Chr(0x00DC) GetChar("acute"), Chr(0x00DA) GetChar("diaeresis")],
	},
	"lat_s_let_u_diaeresis_acute", {
		unicode: "{U+01D8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "acute"), "$" GetChar("acute", "diaeresis"), Chr(0x00FC) GetChar("acute"), Chr(0x00FA) GetChar("diaeresis")],
	},
	"lat_c_let_u_diaeresis_caron", {
		unicode: "{U+01D9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "caron"), "$" GetChar("caron", "diaeresis"), Chr(0x00DC) GetChar("caron"), Chr(0x01D9) GetChar("diaeresis")],
	},
	"lat_s_let_u_diaeresis_caron", {
		unicode: "{U+01DA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "caron"), "$" GetChar("caron", "diaeresis"), Chr(0x00FC) GetChar("caron"), Chr(0x01D4) GetChar("diaeresis")],
	},
	"lat_c_let_u_diaeresis_grave", {
		unicode: "{U+01DB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "grave"), "$" GetChar("grave", "diaeresis"), Chr(0x00DC) GetChar("grave"), Chr(0x00D9) GetChar("diaeresis")],
	},
	"lat_s_let_u_diaeresis_grave", {
		unicode: "{U+01DC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("diaeresis", "grave"), "$" GetChar("grave", "diaeresis"), Chr(0x00FC) GetChar("grave"), Chr(0x00F9) GetChar("diaeresis")],
	},
	"lat_c_let_u_diaeresis_below", {
		unicode: "{U+1E72}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("diaeresis_below"),
	},
	"lat_s_let_u_diaeresis_below", {
		unicode: "{U+1E73}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("diaeresis_below"),
	},
	"lat_c_let_u_grave", {
		unicode: "{U+00D9}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_u_grave", {
		unicode: "{U+00F9}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_c_let_u_grave_horn", {
		unicode: "{U+1EEA}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("grave", "horn"), "$" GetChar("horn", "grave"), Chr(0x00D9) GetChar("horn"), Chr(0x01AF) GetChar("grave")],
	},
	"lat_s_let_u_grave_horn", {
		unicode: "{U+1EEB}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("grave", "horn"), "$" GetChar("horn", "grave"), Chr(0x00F9) GetChar("horn"), Chr(0x01B0) GetChar("grave")],
	},
	"lat_c_let_u_grave_double", {
		unicode: "{U+0214}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_s_let_u_grave_double", {
		unicode: "{U+0215}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("grave_double"),
	},
	"lat_c_let_u_hook_above", {
		unicode: "{U+1EE6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_u_hook_above", {
		unicode: "{U+1EE7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_c_let_u_hook_above_horn", {
		unicode: "{U+1EEC}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("hook_above", "horn"), "$" GetChar("horn", "hook_above"), Chr(0x1EE6) GetChar("horn"), Chr(0x01AF) GetChar("hook_above")],
	},
	"lat_s_let_u_hook_above_horn", {
		unicode: "{U+1EED}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("hook_above", "horn"), "$" GetChar("horn", "hook_above"), Chr(0x1EE7) GetChar("horn"), Chr(0x01B0) GetChar("hook_above")],
	},
	"lat_s_let_u_retroflex_hook", {
		unicode: "{U+1D99}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	"lat_c_let_u_horn", {
		unicode: "{U+01AF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("horn"),
	},
	"lat_s_let_u_horn", {
		unicode: "{U+01B0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("horn"),
	},
	"lat_c_let_u_macron", {
		unicode: "{U+016A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_s_let_u_macron", {
		unicode: "{U+016B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	;
	;
	;
	;
	;
	;
	"lat_c_let_u_macron_diaeresis", {
		unicode: "{U+01D5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "diaeresis"), "$" GetChar("diaeresis", "macron"), Chr(0x016A) GetChar("diaeresis"), Chr(0x00DC) GetChar("macron")],
	},
	"lat_s_let_u_macron_diaeresis", {
		unicode: "{U+01D6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("macron", "diaeresis"), "$" GetChar("diaeresis", "macron"), Chr(0x016B) GetChar("diaeresis"), Chr(0x00FC) GetChar("macron")],
	},
	"lat_c_let_u_ring_above", {
		unicode: "{U+016E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("ring_above"),
	},
	"lat_s_let_u_ring_above", {
		unicode: "{U+016F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("ring_above"),
	},
	"lat_c_let_u_solidus_long", {
		unicode: "{U+A7B8}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_u_solidus_long", {
		unicode: "{U+A7B9}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_u_ogonek", {
		unicode: "{U+0172}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_s_let_u_ogonek", {
		unicode: "{U+0173}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("ogonek"),
	},
	"lat_c_let_u_tilde", {
		unicode: "{U+0168}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_u_tilde", {
		unicode: "{U+0169}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_c_let_u_tilde_acute", {
		unicode: "{U+1E78}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "acute"), "$" GetChar("acute", "tilde"), Chr(0x0168) GetChar("acute"), Chr(0x00DA) GetChar("tilde")],
	},
	"lat_s_let_u_tilde_acute", {
		unicode: "{U+1E79}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "acute"), "$" GetChar("acute", "tilde"), Chr(0x0169) GetChar("acute"), Chr(0x00FA) GetChar("tilde")],
	},
	"lat_c_let_u_tilde_horn", {
		unicode: "{U+1EEE}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "horn"), "$" GetChar("horn", "tilde"), Chr(0x0168) GetChar("horn"), Chr(0x01AF) GetChar("tilde")],
	},
	"lat_s_let_u_tilde_horn", {
		unicode: "{U+1EEF}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: ["$" GetChar("tilde", "horn"), "$" GetChar("horn", "tilde"), Chr(0x0169) GetChar("horn"), Chr(0x01B0) GetChar("tilde")],
	},
	"lat_c_let_u_tilde_below", {
		unicode: "{U+1E74}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_below"),
	},
	"lat_s_let_u_tilde_below", {
		unicode: "{U+1E75}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_below"),
	},
	;
	"lat_s_let_v_curl", {
		unicode: "{U+2C74}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_left_ushaped"),
	},
	"lat_c_let_v_dot_below", {
		unicode: "{U+1E7E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_v_dot_below", {
		unicode: "{U+1E7F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_v_common_hook", {
		unicode: "{U+01B2}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_v_common_hook", {
		unicode: "{U+028B}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_v_right_hook", {
		unicode: "{U+2C71}",
		modifierForm: "{U+107B0}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right"),
	},
	"lat_s_let_v_palatal_hook", {
		unicode: "{U+1D8C}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_v_solidus_long", {
		unicode: "{U+A75E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_s_let_v_solidus_long", {
		unicode: "{U+A75F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("solidus_long"),
	},
	"lat_c_let_v_tilde", {
		unicode: "{U+1E7C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_v_tilde", {
		unicode: "{U+1E7D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	;
	"lat_c_let_w_acute", {
		unicode: "{U+1E82}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_w_acute", {
		unicode: "{U+1E83}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_w_circumflex", {
		unicode: "{U+0174}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_w_circumflex", {
		unicode: "{U+0175}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_w_dot_above", {
		unicode: "{U+1E86}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_w_dot_above", {
		unicode: "{U+1E87}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_w_dot_below", {
		unicode: "{U+1E88}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_w_dot_below", {
		unicode: "{U+1E89}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_w_diaeresis", {
		unicode: "{U+1E84}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_w_diaeresis", {
		unicode: "{U+1E85}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_w_grave", {
		unicode: "{U+1E80}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_w_grave", {
		unicode: "{U+1E81}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_w_ring_above", {
		unicode: "{U+1E98}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("ring_above"),
	},
	;
	"lat_c_let_x_dot_above", {
		unicode: "{U+1E8A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_x_dot_above", {
		unicode: "{U+1E8B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_x_diaeresis", {
		unicode: "{U+1E8C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_x_diaeresis", {
		unicode: "{U+1E8D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_x_palatal_hook", {
		unicode: "{U+1D8D}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	;
	"lat_c_let_y_acute", {
		unicode: "{U+00DD}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_y_acute", {
		unicode: "{U+00FD}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_y_circumflex", {
		unicode: "{U+0176}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_y_circumflex", {
		unicode: "{U+0177}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_y_dot_above", {
		unicode: "{U+1E8E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_y_dot_above", {
		unicode: "{U+1E8F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_y_dot_below", {
		unicode: "{U+1EF4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_y_dot_below", {
		unicode: "{U+1EF5}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_c_let_y_diaeresis", {
		unicode: "{U+0178}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_s_let_y_diaeresis", {
		unicode: "{U+00FF}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"lat_c_let_y_grave", {
		unicode: "{U+1EF2}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_s_let_y_grave", {
		unicode: "{U+1EF3}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"lat_c_let_y_loop", {
		unicode: "{U+1EFE}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_up_ushaped"),
	},
	"lat_s_let_y_loop", {
		unicode: "{U+1EFF}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_up_ushaped"),
	},
	"lat_c_let_y_hook_above", {
		unicode: "{U+1EF6}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_s_let_y_hook_above", {
		unicode: "{U+1EF7}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("hook_above"),
	},
	"lat_c_let_y_common_hook", {
		unicode: "{U+01B3}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_y_common_hook", {
		unicode: "{U+01B4}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_up"),
	},
	"lat_s_let_y_ring_above", {
		unicode: "{U+1E99}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("ring_above"),
	},
	"lat_c_let_y_stroke_short", {
		unicode: "{U+024E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_y_stroke_short", {
		unicode: "{U+024F}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_c_let_y_macron", {
		unicode: "{U+0232}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_s_let_y_macron", {
		unicode: "{U+0233}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"lat_c_let_y_tilde", {
		unicode: "{U+1EF8}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	"lat_s_let_y_tilde", {
		unicode: "{U+1EF9}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ $",
		recipe: "$" GetChar("tilde"),
	},
	;
	"lat_c_let_z_acute", {
		unicode: "{U+0179}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_s_let_z_acute", {
		unicode: "{U+017A}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"lat_c_let_z_circumflex", {
		unicode: "{U+1E90}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_s_let_z_circumflex", {
		unicode: "{U+1E91}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("circumflex"),
	},
	"lat_c_let_z_caron", {
		unicode: "{U+017D}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_z_caron", {
		unicode: "{U+017E}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_z_curl", {
		unicode: "{U+0291}",
		modifierForm: "{U+1DBD}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_c_let_z_dot_above", {
		unicode: "{U+017B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_s_let_z_dot_above", {
		unicode: "{U+017C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("dot_above"),
	},
	"lat_c_let_z_dot_below", {
		unicode: "{U+1E92}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"lat_s_let_z_dot_below", {
		unicode: "{U+1E93}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("dot_below"),
	},
	"let_c_let_z_descender", {
		unicode: "{U+2C6B}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"let_s_let_z_descender", {
		unicode: "{U+2C6C}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("arrow_down"),
	},
	"lat_c_let_z_common_hook", {
		unicode: "{U+0224}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "C" . GetChar("arrow_down"),
	},
	"lat_s_let_z_common_hook", {
		unicode: "{U+0225}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "c" . GetChar("arrow_down"),
	},
	"lat_c_let_z_swash_hook", {
		unicode: "{U+2C7F}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_rightdown"),
	},
	"lat_s_let_z_swash_hook", {
		unicode: "{U+0240}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("arrow_rightdown"),
	},
	"lat_c_let_z_palatal_hook", {
		unicode: "{U+1D8E}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("palatal_hook_below"),
	},
	"lat_c_let_z_line_below", {
		unicode: "{U+1E94}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_s_let_z_line_below", {
		unicode: "{U+1E95}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("macron_below"),
	},
	"lat_c_let_z_stroke_short", {
		unicode: "{U+01B5}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_z_stroke_short", {
		unicode: "{U+01B6}",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"lat_s_let_z_tilde_overlay", {
		unicode: "{U+1D76}",
		titlesAlt: True,
		group: ["Latin Accented"],
		recipe: "$" GetChar("tilde_overlay"),
	},
	"lat_c_let_ezh_caron", {
		unicode: "{U+01EE}", LaTeX: "N/A",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		tags: ["прописная буква Эж с гачеком", "capital letter Ezh with caron"],
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_ezh_caron", {
		unicode: "{U+01EF}", LaTeX: "N/A",
		titlesAlt: True,
		group: [["Latin Accented", "Latin Accented Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+ $",
		tags: ["строчная буква эж с гачеком", "small letter ezh with caron"],
		recipe: "$" GetChar("caron"),
	},
	"lat_s_let_ezh_curl", {
		unicode: "{U+0293}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["строчная буква эж с завитком", "small letter ezh with curl"],
		recipe: "$" GetChar("arrow_right_ushaped"),
	},
	"lat_s_let_ezh_retroflex_hook", {
		unicode: "{U+1D9A}",
		titlesAlt: True,
		group: ["Latin Accented"],
		tags: ["строчная буква эж с ретрофлексным крюком", "small letter ezh with retroflex hook"],
		recipe: "$" GetChar("retroflex_hook_below"),
	},
	;
	;
	;
	;
	;
	; * Letters Cyriillic
	"cyr_c_let_ae", {
		unicode: "{U+04D4}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["прописная буква АЕ", "cyrillic capital letter AE"],
		recipe: "АЕ",
	},
	"cyr_s_let_ae", {
		unicode: "{U+04D5}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["строчная буква ае", "cyrillic capital letter ae"],
		recipe: "ае",
	},
	"cyr_c_let_a_iotified", {
		unicode: "{U+A656}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["!йа", "прописная буква А йотированное кириллицы", "cyrillic capital letter A iotified"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Я]",
		recipe: "ІА",
		letter: "а",
	},
	"cyr_s_let_a_iotified", {
		unicode: "{U+A657}",
		combiningForm: "{U+2DFC}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: [".йа", "строчная буква А йотированное кириллицы", "cyrillic capital letter A iotified"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [я]",
		recipe: "іа",
		letter: "а",
	},
	"cyr_c_let_e_iotified", {
		unicode: "{U+0464}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["!йэ", "!ie", "прописная буква Е йотированное кириллицы", "cyrillic capital letter E iotified"],
		recipe: ["ІЕ", "ІЄ"],
	},
	"cyr_s_let_e_iotified", {
		unicode: "{U+0465}",
		combiningForm: "{U+A69F}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: [".йэ", ".ie", "строчная буква е йотированное кириллицы", "cyrillic small letter e iotified"],
		recipe: ["іе", "іє"],
	},
	"cyr_c_let_yus_big", {
		unicode: "{U+046A}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters", "У"],
		tags: ["!юсб", "!yusb", "прописная буква Юс большой кириллицы", "cyrillic capital letter big Yus"],
		show_on_fast_keys: True,
		recipe: "УЖ",
	},
	"cyr_s_let_yus_big", {
		unicode: "{U+046B}",
		combiningForm: "{U+2DFE}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters", "у"],
		tags: [".юсб", ".yusb", "строчная буква юс большой кириллицы", "cyrillic small letter big yus"],
		show_on_fast_keys: True,
		recipe: "уж",
	},
	"cyr_c_let_yus_big_iotified", {
		unicode: "{U+046C}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["!йюсб", "!iyusb", "прописная буква Юс большой йотированный кириллицы", "cyrillic capital letter big Yus iotified"],
		recipe: ["ІУЖ", "І" . Chr(0x046A)],
	},
	"cyr_s_let_yus_big_iotified", {
		unicode: "{U+046D}",
		combiningForm: "{U+2DFF}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: [".йюсб", ".iyusb", "строчная буква юс большой йотированный кириллицы", "cyrillic small letter big yus iotified"],
		recipe: ["іуж", "і" . Chr(0x046B)],
	},
	"cyr_c_let_yus_little", {
		unicode: "{U+0466}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters", "Я"],
		tags: ["!юсм", "!yusm", "прописная буква Юс малый кириллицы", "cyrillic capital letter little Yus"],
		show_on_fast_keys: True,
		recipe: "АТ",
	},
	"cyr_s_let_yus_little", {
		unicode: "{U+0467}",
		combiningForm: "{U+2DFD}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters", "я"],
		tags: [".юсм", ".yusm", "строчная буква юс малый кириллицы", "cyrillic small letter little yus"],
		show_on_fast_keys: True,
		recipe: "ат",
	},
	"cyr_c_let_yus_little_iotified", {
		unicode: "{U+0468}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["!йюсм", "!iyusm", "прописная буква Юс малый йотированный кириллицы", "cyrillic capital letter little Yus iotified"],
		recipe: ["ІАТ", "І" Chr(0x0466)],
	},
	"cyr_s_let_yus_little_iotified", {
		unicode: "{U+0469}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: [".йюсм", ".iyusm", "строчная буква юс малый йотированный кириллицы", "cyrillic small letter little yus iotified"],
		recipe: ["іат", "і" Chr(0x0467)],
	},
	"cyr_c_let_yus_little_closed", {
		unicode: "{U+A658}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["!юсмз", "!yusmz", "прописная буква Юс малый закрытый кириллицы", "cyrillic capital letter little Yus closed"],
		recipe: ["_АТ", "_" Chr(0x0466)],
	},
	"cyr_s_let_yus_little_closed", {
		unicode: "{U+A659}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: [".юсмз", ".yusmz", "строчная буква юс малый закрытый кириллицы", "cyrillic small letter little yus closed"],
		recipe: ["_ат", "_" Chr(0x0467)],
	},
	"cyr_c_let_yus_little_closed_iotified", {
		unicode: "{U+A65C}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["!йюсмз", "!iyusmz", "прописная буква Юс малый закрытый йотированный кириллицы", "cyrillic capital letter little Yus closed iotified"],
		recipe: ["І_АТ", "І" Chr(0xA658), "І_" Chr(0x0466)],
	},
	"cyr_s_let_yus_little_closed_iotified", {
		unicode: "{U+A65D}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: [".йюсмз", ".iyusmz", "строчная буква юс малый закрытый йотированный кириллицы", "cyrillic small letter little yus closed iotified"],
		recipe: ["і_ат", "i" Chr(0xA659), "і_" Chr(0x0467)],
	},
	"cyr_c_let_yus_blended", {
		unicode: "{U+A65A}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["!юсс", "!yuss", "прописная буква Юс смешанный кириллицы", "cyrillic capital letter blended Yus"],
		recipe: ["УЖАТ", Chr(0x046A) . Chr(0x0466)],
	},
	"cyr_s_let_yus_blended", {
		unicode: "{U+A65B}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: [".юсс", ".yuss", "строчная буква юс смешанный кириллицы", "cyrillic small letter blended yus"],
		recipe: ["ужат", Chr(0x046B) . Chr(0x0467)],
	},
	"cyr_c_let_tse", {
		unicode: "{U+04B4}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["прописная буква Тцэ кириллицы", "cyrillic capital letter Tse cyrillic"],
		recipe: "ТЦ",
	},
	"cyr_s_let_tse", {
		unicode: "{U+04B5}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["строчная буква тцэ кириллицы", "cyrillic small letter tse cyrillic"],
		recipe: "тц",
	},
	"cyr_c_let_tche", {
		unicode: "{U+A692}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["прописная буква Тчэ кириллицы", "cyrillic capital letter Tche cyrillic"],
		recipe: "ТЧ",
	},
	"cyr_s_let_tche", {
		unicode: "{U+A693}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["строчная буква тчэ кириллицы", "cyrillic small letter tche cyrillic"],
		recipe: "тч",
	},
	"cyr_c_let_yat_iotified", {
		unicode: "{U+A652}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["прописная буква Ять йотированный кириллицы", "cyrillic capital letter Yat iotified"],
		recipe: ["ІТЬ", "І" . Chr(0x0462)],
	},
	"cyr_s_let_yat_iotified", {
		unicode: "{U+A653}",
		titlesAlt: True,
		group: ["Cyrillic Ligatures & Letters"],
		tags: ["строчная буква ять йотированный кириллицы", "cyrillic small letter yat iotified"],
		recipe: ["іть", "і" . Chr(0x0463)],
	},
	;
	"cyr_c_let_a_breve", { letter: "а",
		unicode: "{U+04D0}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_s_let_a_breve", { letter: "а",
		unicode: "{U+04D1}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_c_let_a_diaeresis", { letter: "а",
		unicode: "{U+04D2}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_a_diaeresis", { letter: "а",
		unicode: "{U+04D3}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_g_acute", { letter: "г",
		unicode: "{U+0403}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"cyr_s_let_g_acute", { letter: "г",
		unicode: "{U+0453}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"cyr_c_let_g_descender", { letter: "г",
		unicode: "{U+04F6}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_g_descender", { letter: "г",
		unicode: "{U+04F7}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_g_upturn", { letter: "г",
		unicode: "{U+0490}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("arrow_up"),
	},
	"cyr_s_let_g_upturn", { letter: "г",
		unicode: "{U+0491}",
		subscriptForm: "{U+1E067}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("arrow_up"),
	},
	"cyr_c_let_g_stroke_short", { letter: "г",
		unicode: "{U+0492}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"cyr_s_let_g_stroke_short", { letter: "г",
		unicode: "{U+0493}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("stroke_short"),
	},
	"cyr_c_let_g_stroke_short_palatal_hook", { letter: "г",
		unicode: "{U+04FA}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: ["$" GetChar("stroke_short", "palatal_hook_below"), Chr(0x0492) GetChar("palatal_hook_below")],
	},
	"cyr_s_let_g_stroke_short_palatal_hook", { letter: "г",
		unicode: "{U+04FB}",
		titlesAlt: True,
		group: ["Cyrillic Letters", "Cyrillic Secondary"],
		recipe: ["$" GetChar("stroke_short", "palatal_hook_below"), Chr(0x0493) GetChar("palatal_hook_below")],
	},
	"cyr_c_let_dwe", {
		unicode: "{U+A680}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: "Д" GetChar("arrow_up"),
	},
	"cyr_s_let_dwe", {
		unicode: "{U+A681}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: "д" GetChar("arrow_up"),
	},
	"cyr_c_let_e_breve", { letter: "е",
		unicode: "{U+04D6}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_s_let_e_breve", { letter: "е",
		unicode: "{U+04D7}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_c_let_e_grave", { letter: "е",
		unicode: "{U+0400}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"cyr_s_let_e_grave", { letter: "е",
		unicode: "{U+0450}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Tertiary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("grave"),
	},
	"cyr_c_let_e_diaeresis", { letter: "е",
		unicode: "{U+0401}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_e_diaeresis", { letter: "е",
		unicode: "{U+0451}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_zhe_breve", { letter: "ж",
		unicode: "{U+04C1}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_s_let_zhe_breve", { letter: "ж",
		unicode: "{U+04C2}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_c_let_zhe_diaeresis", { letter: "ж",
		unicode: "{U+04DC}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_zhe_diaeresis", { letter: "ж",
		unicode: "{U+04DD}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_zhe_descender", { letter: "ж",
		unicode: "{U+0496}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_zhe_descender", { letter: "ж",
		unicode: "{U+0497}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_z_diaeresis", { letter: "з",
		unicode: "{U+04DE}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_z_diaeresis", { letter: "з",
		unicode: "{U+04DF}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_z_descender", { letter: "з",
		unicode: "{U+0498}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_z_descender", { letter: "з",
		unicode: "{U+0499}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_i_breve", { letter: "и",
		unicode: "{U+0419}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		recipe: "$" GetChar("breve"),
	},
	"cyr_s_let_i_breve", { letter: "и",
		unicode: "{U+0439}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		recipe: "$" GetChar("breve"),
	},
	"cyr_c_let_i_breve_tail", {
		unicode: "{U+048A}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ [Й]",
		recipe: ["И" GetChar("breve", "arrow_leftdown"), "Й" GetChar("arrow_leftdown")],
	},
	"cyr_s_let_i_breve_tail", {
		unicode: "{U+048B}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ [й]",
		recipe: ["и" GetChar("breve", "arrow_leftdown"), "й" GetChar("arrow_leftdown")],
	},
	"cyr_c_let_i_diaeresis", { letter: "и",
		unicode: "{U+04E4}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_i_diaeresis", { letter: "и",
		unicode: "{U+04E5}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_i_macron", { letter: "и",
		unicode: "{U+04E2}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"cyr_s_let_i_macron", { letter: "и",
		unicode: "{U+04E3}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ $",
		recipe: "$" GetChar("macron"),
	},
	"cyr_c_let_k_acute", { letter: "к",
		unicode: "{U+040C}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"cyr_s_let_k_acute", { letter: "к",
		unicode: "{U+045C}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("acute"),
	},
	"cyr_c_let_k_descender", { letter: "к",
		unicode: "{U+049A}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_k_descender", { letter: "к",
		unicode: "{U+049B}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_l_descender", { letter: "л",
		unicode: "{U+052E}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_l_descender", { letter: "л",
		unicode: "{U+052F}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_l_tail", { letter: "л",
		unicode: "{U+04C5}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_leftdown"),
	},
	"cyr_s_let_l_tail", { letter: "л",
		unicode: "{U+04C6}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_leftdown"),
	},
	"cyr_c_let_m_tail", { letter: "м",
		unicode: "{U+04CD}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_leftdown"),
	},
	"cyr_s_let_m_tail", { letter: "м",
		unicode: "{U+04CE}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_leftdown"),
	},
	"cyr_c_let_soft_em", { letter: "м",
		unicode: "{U+A666}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: "$" GetChar("cyr_com_palatalization"),
	},
	"cyr_s_let_soft_em", { letter: "м",
		unicode: "{U+A667}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: "$" GetChar("cyr_com_palatalization"),
	},
	"cyr_c_let_n_descender", { letter: "н",
		unicode: "{U+04A2}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_n_descender", { letter: "н",
		unicode: "{U+04A3}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_n_tail", { letter: "н",
		unicode: "{U+04C9}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_leftdown"),
	},
	"cyr_s_let_n_tail", { letter: "н",
		unicode: "{U+04CA}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!>+ $",
		recipe: "$" GetChar("arrow_leftdown"),
	},
	"cyr_c_let_o_diaeresis", { letter: "о",
		unicode: "{U+04E6}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_o_diaeresis", { letter: "о",
		unicode: "{U+04E7}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_p_descender", { letter: "п",
		unicode: "{U+0524}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_p_descender", { letter: "п",
		unicode: "{U+0525}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_s_descender", { letter: "с",
		unicode: "{U+04AA}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_s_descender", { letter: "с",
		unicode: "{U+04AB}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_t_descender", { letter: "т",
		unicode: "{U+04AC}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_t_descender", { letter: "т",
		unicode: "{U+04AD}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_u_breve", { letter: "у",
		unicode: "{U+040E}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_s_let_u_breve", { letter: "у",
		unicode: "{U+045E}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Primary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("breve"),
	},
	"cyr_c_let_u_diaeresis", { letter: "у",
		unicode: "{U+04F0}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_u_diaeresis", { letter: "у",
		unicode: "{U+04F1}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_u_macron", { letter: "у",
		unicode: "{U+04EE}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("macron"),
	},
	"cyr_s_let_u_macron", { letter: "у",
		unicode: "{U+04EF}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("macron"),
	},
	"cyr_c_let_u_straight", {
		unicode: "{U+04AE}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Ъ]",
	},
	"cyr_s_let_u_straight", {
		unicode: "{U+04AF}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[ъ]",
	},
	"cyr_c_let_u_straight_stroke_short", {
		unicode: "{U+04B0}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [Ъ]",
		recipe: Chr(0x04AE) GetChar("stroke_short"),
	},
	"cyr_s_let_u_straight_stroke_short", {
		unicode: "{U+04B1}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [ъ]",
		recipe: Chr(0x04AF) GetChar("stroke_short"),
	},
	"cyr_c_let_h_descender", { letter: "х",
		unicode: "{U+04B2}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_h_descender", { letter: "х",
		unicode: "{U+04B3}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_ch_descender", { letter: "ч",
		unicode: "{U+04B6}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_s_let_ch_descender", { letter: "ч",
		unicode: "{U+04B7}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! $",
		recipe: "$" GetChar("arrow_down"),
	},
	"cyr_c_let_ch_diaeresis", { letter: "ч",
		unicode: "{U+04F4}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_ch_diaeresis", { letter: "ч",
		unicode: "{U+04F5}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "$",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_yery_diaeresis", { letter: "ы",
		unicode: "{U+04F8}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_yery_diaeresis", { letter: "ы",
		unicode: "{U+04F9}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_ye_diaeresis", { letter: "Э",
		unicode: "{U+04EC}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_s_let_ye_diaeresis", { letter: "Э",
		unicode: "{U+04ED}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ $",
		recipe: "$" GetChar("diaeresis"),
	},
	"cyr_c_let_dzhe", {
		unicode: "{U+040F}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Ж"],
		tags: ["прописная буква Дже кириллицы", "cyrillic capital letter Dzhe"],
		show_on_fast_keys: True,
		recipe: "ДЖ",
	},
	"cyr_s_let_dzhe", {
		unicode: "{U+045F}",
		subscriptForm: "{U+1E06A}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "ж"],
		tags: ["строчная буква дже кириллицы", "cyrillic small letter dzhe"],
		show_on_fast_keys: True,
		recipe: "дж",
	},
	"cyr_c_let_lje", {
		unicode: "{U+0409}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Л"],
		tags: ["прописная буква Ле (лигатура ЛЬ) кириллицы", "cyrillic capital letter Lje"],
		show_on_fast_keys: True,
		recipe: "ЛЬ",
	},
	"cyr_s_let_lje", {
		unicode: "{U+0459}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "л"],
		tags: ["строчная буква ле (лигатура ль) кириллицы", "cyrillic small letter lje"],
		show_on_fast_keys: True,
		recipe: "ль",
	},
	"cyr_c_let_nje", {
		unicode: "{U+040A}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Н"],
		tags: ["прописная буква Не (лигатура НЬ) кириллицы", "cyrillic capital letter Nje"],
		show_on_fast_keys: True,
		recipe: "НЬ",
	},
	"cyr_s_let_nje", {
		unicode: "{U+045A}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "н"],
		tags: ["строчная буква не (лигатура нь) кириллицы", "cyrillic small letter nje"],
		show_on_fast_keys: True,
		recipe: "нь",
	},
	"cyr_c_let_tshe", {
		unicode: "{U+040B}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Ч"],
		tags: ["прописная буква Гервь кириллицы", "cyrillic capital letter Tshe"],
		show_on_fast_keys: True,
		recipe: ["ТЬЧ", "Т" Chr(0x04BA)],
	},
	"cyr_s_let_tshe", {
		unicode: "{U+045B}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "ч"],
		tags: ["строчная буква гервь кириллицы", "cyrillic small letter tshe"],
		show_on_fast_keys: True,
		recipe: ["тьч", "т" Chr(0x04BB)],
	},
	"cyr_c_let_djerv", {
		unicode: "{U+A648}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		tags: ["прописная буква Джье кириллицы", "cyrillic capital letter Djerv"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+<! [Ч]",
		recipe: "ЧДЖ",
	},
	"cyr_s_let_djerv", {
		unicode: "{U+A649}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		tags: ["строчная буква джье кириллицы", "cyrillic small letter djerv"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+<! [ч]",
		recipe: "чдж",
	},
	"cyr_c_let_dje", {
		unicode: "{U+0402}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Ж"],
		tags: ["прописная буква Джье кириллицы", "cyrillic capital letter Dje"],
		show_on_fast_keys: True,
		modifier: RightShift,
		recipe: "ДЬЖ",
	},
	"cyr_s_let_dje", {
		unicode: "{U+0452}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "ж"],
		tags: ["строчная буква джье кириллицы", "cyrillic small letter dje"],
		show_on_fast_keys: True,
		modifier: RightShift,
		recipe: "дьж",
	},
	"cyr_c_let_dzelo", {
		unicode: "{U+0405}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "З"],
		tags: ["прописная буква Дзе (Зело) кириллицы", "cyrillic capital letter Dzelo"],
		show_on_fast_keys: True,
		recipe: "ДЗ",
	},
	"cyr_s_let_dzelo", {
		unicode: "{U+0455}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "з"],
		tags: ["строчная буква дзе (зело) кириллицы", "cyrillic small letter dzelo"],
		show_on_fast_keys: True,
		recipe: "дз",
	},
	"cyr_c_let_dzelo_reversed", {
		unicode: "{U+A644}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["прописная буква обратное Дзе (Зело) кириллицы", "cyrillic capital letter reversed Dzelo"],
		recipe: ["ДЗ" GetChar("arrow_left"), Chr(0x0405) GetChar("arrow_left")],
	},
	"cyr_s_let_dzelo_reversed", {
		unicode: "{U+A645}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная буква обратное дзе (зело) кириллицы", "cyrillic small letter reversed dzelo"],
		recipe: ["дз" GetChar("arrow_left"), Chr(0x0455) GetChar("arrow_left")],
	},
	"cyr_c_let_shha", {
		unicode: "{U+04BA}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Х"],
		tags: ["прописная буква Шха кириллицы", "cyrillic capital letter Shha"],
		show_on_fast_keys: True,
		recipe: "ХХ",
	},
	"cyr_s_let_shha", {
		unicode: "{U+04BB}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "х"],
		tags: ["строчная буква шха кириллицы", "cyrillic small letter shha"],
		show_on_fast_keys: True,
		recipe: "хх",
	},
	"cyr_c_let_shha_descender", {
		unicode: "{U+0526}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: ["ХХ" GetChar("arrow_down"), Chr(0x04BA) GetChar("arrow_down")],
	},
	"cyr_s_let_shha_descender", {
		unicode: "{U+0527}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		recipe: ["хх" GetChar("arrow_down"), Chr(0x04BB) GetChar("arrow_down")],
	},
	"cyr_c_let_palochka", {
		unicode: "{U+04C0}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		tags: ["прописная буква Палочка кириллицы", "cyrillic capital letter Palochka"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+<! [Л]",
	},
	"cyr_s_let_palochka", {
		unicode: "{U+04CF}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		tags: ["строчная буква палочка кириллицы", "cyrillic small letter palochka"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+<! [л]",
	},
	"cyr_c_let_i", {
		unicode: "{U+0406}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "И"],
		show_on_fast_keys: True,
		tags: ["прописная буква И десятиричное кириллицы", "cyrillic capital letter I"],
	},
	"cyr_s_let_i", {
		unicode: "{U+0456}",
		combiningForm: "{U+1E08F}",
		modifierForm: "{U+1E04C}",
		subscriptForm: "{U+1E068}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "и"],
		show_on_fast_keys: True,
		tags: ["строчная буква и десятиричное кириллицы", "cyrillic small letter i"],
	},
	"cyr_c_let_yi", {
		unicode: "{U+0407}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Й"],
		show_on_fast_keys: True,
		tags: ["прописная буква ЙИ десятиричное кириллицы", "cyrillic capital letter YI"],
		recipe: "І" GetChar("diaeresis"),
	},
	"cyr_s_let_yi", {
		unicode: "{U+0457}",
		combiningForm: "{U+A676}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "й"],
		show_on_fast_keys: True,
		tags: ["строчная буква йи десятиричное кириллицы", "cyrillic small letter yi"],
		recipe: "і" GetChar("diaeresis"),
	},
	"cyr_c_let_iota", {
		unicode: "{U+A646}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ [И]",
		tags: ["прописная буква Йота кириллицы", "cyrillic capital letter Iota"],
	},
	"cyr_s_let_iota", {
		unicode: "{U+A647}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<!<+>+ [и]",
		tags: ["строчная буква йота кириллицы", "cyrillic small letter iota"],
	},
	"cyr_c_let_izhitsa", {
		unicode: "{U+0474}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		alt_on_fast_keys: "<! [И]",
		show_on_fast_keys: True,
		tags: ["прописная буква Ижица кириллицы", "cyrillic capital letter Izhitsa"],
	},
	"cyr_s_let_izhitsa", {
		unicode: "{U+0475}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		alt_on_fast_keys: "<! [и]",
		show_on_fast_keys: True,
		tags: ["строчная буква ижица кириллицы", "cyrillic small letter izhitsa"],
	},
	"cyr_c_let_izhitsa_kendema", {
		unicode: "{U+0476}", LaTeX: "N/A",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["прописная буква Ижица с кендемой кириллицы", "cyrillic capital letter Izhitsa with kendema"],
		recipe: Chr(0x0474) GetChar("grave_double"),
	},
	"cyr_s_let_izhitsa_kendema", {
		unicode: "{U+0477}", LaTeX: "N/A",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная буква ижица с кендемой кириллицы", "cyrillic small letter izhitsa with kendema"],
		recipe: Chr(0x0475) GetChar("grave_double"),
	},
	"cyr_c_let_j", {
		unicode: "{U+0408}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Й"],
		modifier: LeftAlt,
		show_on_fast_keys: True,
		tags: ["прописная буква ЙЕ кириллицы", "cyrillic capital letter J"],
	},
	"cyr_s_let_j", {
		unicode: "{U+0458}",
		modifierForm: "{U+1E04D}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "й"],
		modifier: LeftAlt,
		show_on_fast_keys: True,
		tags: ["строчная буква йе кириллицы", "cyrillic small letter j"],
	},
	"cyr_c_let_ksi", {
		unicode: "{U+046E}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "К"],
		show_on_fast_keys: True,
		tags: ["прописная буква Кси кириллицы", "cyrillic capital letter Ksi"],
		recipe: "КС",
	},
	"cyr_s_let_ksi", {
		unicode: "{U+046F}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "к"],
		show_on_fast_keys: True,
		tags: ["строчная буква кси кириллицы", "cyrillic small letter ksi"],
		recipe: "кс",
	},
	"cyr_c_let_omega", {
		unicode: "{U+0460}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "О"],
		show_on_fast_keys: True,
		tags: ["прописная буква Омега кириллицы", "cyrillic capital letter Omega"],
	},
	"cyr_s_let_omega", {
		unicode: "{U+0461}",
		combiningForm: "{U+A67B}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "о"],
		show_on_fast_keys: True,
		tags: ["строчная буква омега кириллицы", "cyrillic small letter omega"],
	},
	"cyr_c_let_omega_titlo", {
		unicode: "{U+047C}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["прописная буква Омега с титло кириллицы", "cyrillic capital letter Omega with titlo"],
		recipe: Chr(0x0460) Chr(0x0483),
	},
	"cyr_s_let_omega_titlo", {
		unicode: "{U+047D}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная буква омега с титло кириллицы", "cyrillic small letter omega with titlo"],
		recipe: Chr(0x0461) Chr(0x0483),
	},
	"cyr_c_let_ot", {
		unicode: "{U+047E}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["прописная буква От кириллицы", "cyrillic capital letter Ot"],
		recipe: Chr(0x0460) "Т",
	},
	"cyr_s_let_ot", {
		unicode: "{U+047F}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная буква от кириллицы", "cyrillic small letter ot"],
		recipe: Chr(0x0461) "т",
	},
	"cyr_c_let_omega_round", {
		unicode: "{U+047A}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["прописная буква широкая О кириллицы", "cyrillic capital letter broad On"],
		recipe: ["О:", ".О."],
	},
	"cyr_s_let_omega_round", {
		unicode: "{U+047B}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная буква широкая о кириллицы", "cyrillic small letter broad on"],
		recipe: ["о:", ".о."],
	},
	"cyr_c_let_psi", {
		unicode: "{U+0470}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "П"],
		show_on_fast_keys: True,
		tags: ["прописная буква Пси кириллицы", "cyrillic capital letter Psi"],
		recipe: "ПС",
	},
	"cyr_s_let_psi", {
		unicode: "{U+0471}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "п"],
		show_on_fast_keys: True,
		tags: ["строчная буква пси кириллицы", "cyrillic small letter psi"],
		recipe: "пс",
	},
	"cyr_c_let_koppa", {
		unicode: "{U+0480}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["прописная буква коппа кириллицы", "cyrillic capital letter Koppa"],
		recipe: "КО",
	},
	"cyr_s_let_koppa", {
		unicode: "{U+0481}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная буква коппа кириллицы", "cyrillic small letter koppa"],
		recipe: "ко",
	},
	"cyr_c_let_fita", {
		unicode: "{U+0472}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Ф"],
		show_on_fast_keys: True,
		tags: ["прописная буква Фита кириллицы", "cyrillic capital letter Fita"],
	},
	"cyr_s_let_fita", {
		unicode: "{U+0473}",
		combiningForm: "{U+2DF4}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "ф"],
		show_on_fast_keys: True,
		tags: ["строчная буква фита кириллицы", "cyrillic small letter fita"],
	},
	"cyr_c_let_ukr_e", {
		unicode: "{U+0404}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Э"],
		show_on_fast_keys: True,
		tags: ["прописная буква Э якорное кириллицы", "cyrillic capital letter E ukrainian"],
	},
	"cyr_s_let_ukr_e", {
		unicode: "{U+0454}",
		combiningForm: "{U+A674}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "э"],
		show_on_fast_keys: True,
		tags: ["строчная буква э якорное кириллицы", "cyrillic small letter e ukrainian"],
	},
	"cyr_c_let_schwa", {
		unicode: "{U+04D8}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Э"],
		show_on_fast_keys: True,
		modifier: RightShift,
		tags: ["прописная буква Шва кириллицы", "cyrillic capital letter Schwa"],
		recipe: "Е" GetChar("arrow_left_circle"),
	},
	"cyr_s_let_schwa", {
		unicode: "{U+04D9}",
		modifierForm: "{U+1E04B}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "э"],
		show_on_fast_keys: True,
		modifier: RightShift,
		tags: ["строчная буква шва с кириллицы", "cyrillic small letter schwa"],
		recipe: "e" GetChar("arrow_left_circle"),
	},
	"cyr_c_let_schwa_diaeresis", {
		unicode: "{U+04DA}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [Э]",
		tags: ["прописная буква Шва с диерезисом кириллицы", "cyrillic capital letter Schwa with diaeresis"],
		recipe: ["Е" GetChar("arrow_left_circle", "diaeresis"), Chr(0x04D8) GetChar("diaeresis")],
	},
	"cyr_s_let_schwa_diaeresis", {
		unicode: "{U+04DB}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+>+ [э]",
		tags: ["строчная буква шва с диерезисом кириллицы", "cyrillic small letter schwa with diaeresis"],
		recipe: ["e" GetChar("arrow_left_circle", "diaeresis"), Chr(0x04D9) GetChar("diaeresis")],
	},
	"cyr_c_let_yat", {
		unicode: "{U+0462}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "Е"],
		show_on_fast_keys: True,
		tags: ["прописная буква Ять кириллицы", "cyrillic capital letter Yat"],
		recipe: "ТЬ",
	},
	"cyr_s_let_yat", {
		unicode: "{U+0463}",
		combiningForm: "{U+2DFA}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "е"],
		show_on_fast_keys: True,
		tags: ["строчная буква ять кириллицы", "cyrillic small letter yat"],
		recipe: "ть",
	},
	"cyr_c_let_yeru_back_yer", {
		unicode: "{U+A650}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [Ы]",
		tags: ["прописная буква древняя Ы кириллицы", "Ы с твёрдым знаком кириллицы", "cyrillic capital letter Yeru with back Yer"],
		recipe: "ЪІ",
	},
	"cyr_s_let_yeru_back_yer", {
		unicode: "{U+A651}",
		modifierForm: "{U+1E06C}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: ">+ [ы]",
		tags: ["строчная буква древняя ы кириллицы", "ы с твёрдым знаком кириллицы", "cyrillic small letter yeru with back yer"],
		recipe: "ъі",
	},
	"cyr_c_let_semiyeri", {
		unicode: "{U+048C}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Ь]",
		tags: ["прописная буква Полумягкий знак кириллицы", "cyrillic capital letter Semisoft sign"],
		recipe: "Ь" GetChar("stroke_short"),
	},
	"cyr_s_let_semiyeri", {
		unicode: "{U+048D}",
		modifierForm: "{U+1E06C}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[ь]",
		tags: ["строчная буква полумягкий знак кириллицы", "cyrillic small letter semisoft sign"],
		recipe: "ь" GetChar("stroke_short"),
	},
	"cyr_c_let_yn", {
		unicode: "{U+A65E}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! [Ы]",
		tags: ["прописная буква валахо-молдавская Ын кириллицы", "cyrillic capital letter romanian Yn"],
		recipe: "ІѴ",
	},
	"cyr_s_let_yn", {
		unicode: "{U+A65F}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"]],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<! [ы]",
		tags: ["строчная буква валахо-молдавская ын кириллицы", "cyrillic small letter romanian yn"],
		recipe: "іѵ",
	},
	"cyr_c_dig_uk", {
		unicode: "{U+0478}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["прописная диграф Ук кириллицы", "cyrillic capital letter digraph Uk"],
		recipe: ["Оу", "Оѵ"],
	},
	"cyr_s_dig_uk", {
		unicode: "{U+0479}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная диграф ук кириллицы", "cyrillic small letter digraph uk"],
		recipe: ["оу", "оѵ"],
	},
	"cyr_c_let_uk_monograph", {
		unicode: "{U+A64A}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "У"],
		show_on_fast_keys: True,
		modifier: LeftAlt,
		tags: ["прописная буква Ук кириллицы", "cyrillic capital letter monograph Uk"],
	},
	"cyr_s_let_uk_monograph", {
		unicode: "{U+A64B}",
		titlesAlt: True,
		group: [["Cyrillic Letters", "Cyrillic Secondary"], "У"],
		show_on_fast_keys: True,
		modifier: LeftAlt,
		tags: ["строчная буква ук кириллицы", "cyrillic small letter monograph uk"],
	},
	"cyr_s_let_uk_unblended", {
		unicode: "{U+1C88}",
		titlesAlt: True,
		group: ["Cyrillic Letters"],
		tags: ["строчная буква ук кириллицы", "cyrillic small letter unblended uk"],
		recipe: ["о↑у", "о↑ѵ"],
	},
	;
	;
	;
	;
	;
	; * Greek Letters
	"gre_c_let_lamda", {
		unicode: "{U+039B}",
		titlesAlt: True,
		group: ["Greek Letters"],
		tags: ["прописная буква Лямбда греческая", "greek capital letter Lamda"],
	},
	"gre_s_let_lamda", {
		unicode: "{U+03BB}",
		titlesAlt: True,
		group: [["Greek Letters", "Smelting Special", "Math"]],
		tags: ["строчная буква лямбда греческая", "greek small letter lamda"],
		alt_layout: "[l]",
		alt_layout_title: true,
		recipe: ["lam", "лям"],
	},
	"gre_c_let_pi", {
		unicode: "{U+03A0}",
		titlesAlt: True,
		group: ["Greek Letters"],
		tags: ["прописная буква Пи греческая", "greek capital letter Pi"],
	},
	"gre_s_let_pi", {
		unicode: "{U+03C0}",
		titlesAlt: True,
		group: [["Greek Letters", "Smelting Special", "Math"]],
		tags: ["строчная буква пи греческая", "greek small letter pi"],
		alt_layout: "[p]",
		alt_layout_title: true,
		recipe: ["pi", "пи"],
	},
	;
	;
	"glagolitic_c_let_az", {
		unicode: "{U+2C00}",
		combiningForm: "{U+1E000}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "А"],
		tags: ["прописная буква Аз глаголицы", "capital letter Az glagolitic"],
	},
	"glagolitic_s_let_az", {
		unicode: "{U+2C30}",
		combiningForm: "{U+1E000}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "а"],
		tags: ["строчная буква аз глаголицы", "small letter az glagolitic"],
	},
	"glagolitic_c_let_buky", {
		unicode: "{U+2C01}",
		combiningForm: "{U+1E001}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Б"],
		tags: ["прописная буква Буки глаголицы", "capital letter Buky glagolitic"],
	},
	"glagolitic_s_let_buky", {
		unicode: "{U+2C31}",
		combiningForm: "{U+1E001}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "б"],
		tags: ["строчная буква буки глаголицы", "small letter buky glagolitic"],
	},
	"glagolitic_c_let_vede", {
		unicode: "{U+2C02}",
		combiningForm: "{U+1E002}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "В"],
		tags: ["прописная буква Веди глаголицы", "capital letter Vede glagolitic"],
	},
	"glagolitic_s_let_vede", {
		unicode: "{U+2C32}",
		combiningForm: "{U+1E002}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "в"],
		tags: ["строчная буква веди глаголицы", "small letter vede glagolitic"],
	},
	"glagolitic_c_let_glagoli", {
		unicode: "{U+2C03}",
		combiningForm: "{U+1E003}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Г"],
		tags: ["прописная буква Глаголи глаголицы", "capital letter Glagoli glagolitic"],
	},
	"glagolitic_s_let_glagoli", {
		unicode: "{U+2C33}",
		combiningForm: "{U+1E003}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "г"],
		tags: ["строчная буква глаголи глаголицы", "small letter glagoli glagolitic"],
	},
	"glagolitic_c_let_dobro", {
		unicode: "{U+2C04}",
		combiningForm: "{U+1E004}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Д"],
		tags: ["прописная буква Добро глаголицы", "capital letter Dobro glagolitic"],
	},
	"glagolitic_s_let_dobro", {
		unicode: "{U+2C34}",
		combiningForm: "{U+1E004}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "д"],
		tags: ["строчная буква добро глаголицы", "small letter dobro glagolitic"],
	},
	"glagolitic_c_let_yestu", {
		unicode: "{U+2C05}",
		combiningForm: "{U+1E005}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Е"],
		tags: ["прописная буква Есть глаголицы", "capital letter Yestu glagolitic"],
	},
	"glagolitic_s_let_yestu", {
		unicode: "{U+2C35}",
		combiningForm: "{U+1E005}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "е"],
		tags: ["строчная буква есть глаголицы", "small letter yestu glagolitic"],
	},
	"glagolitic_c_let_zhivete", {
		unicode: "{U+2C06}",
		combiningForm: "{U+1E006}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ж"],
		tags: ["прописная буква Живете глаголицы", "capital letter Zhivete glagolitic"],
	},
	"glagolitic_s_let_zhivete", {
		unicode: "{U+2C36}",
		combiningForm: "{U+1E006}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ж"],
		tags: ["строчная буква живете глаголицы", "small letter zhivete glagolitic"],
	},
	"glagolitic_c_let_dzelo", {
		unicode: "{U+2C07}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["прописная буква Зело глаголицы", "capital letter Dzelo glagolitic"],
		alt_layout: ">! [С]",
	},
	"glagolitic_s_let_dzelo", {
		unicode: "{U+2C37}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["строчная буква зело глаголицы", "small letter dzelo glagolitic"],
		alt_layout: ">! [с]",
	},
	"glagolitic_c_let_zemlja", {
		unicode: "{U+2C08}",
		combiningForm: "{U+1E008}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "З"],
		tags: ["прописная буква Земля глаголицы", "capital letter Zemlja glagolitic"],
	},
	"glagolitic_s_let_zemlja", {
		unicode: "{U+2C38}",
		combiningForm: "{U+1E008}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "з"],
		tags: ["строчная буква земля глаголицы", "small letter zemlja glagolitic"],
	},
	"glagolitic_c_let_initial_izhe", {
		unicode: "{U+2C0A}",
		combiningForm: "{U+1E00A}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [И]",
		tags: ["прописная буква начальное Иже глаголицы", "capital letter initial Izhe glagolitic"],
	},
	"glagolitic_s_let_initial_izhe", {
		unicode: "{U+2C3A}",
		combiningForm: "{U+1E00A}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [и]",
		tags: ["строчная буква начальное иже глаголицы", "small letter initial izhe glagolitic"],
	},
	"glagolitic_c_let_izhe", {
		unicode: "{U+2C09}",
		combiningForm: "{U+1E009}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: "<+ [И], [Й]",
		tags: ["прописная буква Иже глаголицы", "capital letter Izhe glagolitic"],
	},
	"glagolitic_s_let_izhe", {
		unicode: "{U+2C39}",
		combiningForm: "{U+1E009}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: "<+ [и], [й]",
		tags: ["строчная буква иже глаголицы", "small letter izhe glagolitic"],
	},
	"glagolitic_c_let_i", {
		unicode: "{U+2C0B}",
		combiningForm: "{U+1E00B}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "И"],
		tags: ["прописная буква Ие глаголицы", "capital letter I glagolitic"],
	},
	"glagolitic_s_let_i", {
		unicode: "{U+2C3B}",
		combiningForm: "{U+1E00B}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "и"],
		tags: ["строчная буква и глаголицы", "small letter i glagolitic"],
	},
	"glagolitic_c_let_djervi", {
		unicode: "{U+2C0C}",
		combiningForm: "{U+1E00C}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [Ж]",
		tags: ["прописная буква Гюрв глаголицы", "capital letter Djervi glagolitic"],
	},
	"glagolitic_s_let_djervi", {
		unicode: "{U+2C3C}",
		combiningForm: "{U+1E00C}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [ж]",
		tags: ["строчная буква гюрв глаголицы", "small letter djervi glagolitic"],
	},
	"glagolitic_c_let_kako", {
		unicode: "{U+2C0D}",
		combiningForm: "{U+1E00D}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "К"],
		tags: ["прописная буква Како глаголицы", "capital letter Kako glagolitic"],
	},
	"glagolitic_s_let_kako", {
		unicode: "{U+2C3D}",
		combiningForm: "{U+1E00D}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "к"],
		tags: ["строчная буква како глаголицы", "small letter kako glagolitic"],
	},
	"glagolitic_c_let_ljudije", {
		unicode: "{U+2C0E}",
		combiningForm: "{U+1E00E}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Л"],
		tags: ["прописная буква Люди глаголицы", "capital letter Ljudije glagolitic"],
	},
	"glagolitic_s_let_ljudije", {
		unicode: "{U+2C3E}",
		combiningForm: "{U+1E00E}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "л"],
		tags: ["строчная буква люди глаголицы", "small letter ljudije glagolitic"],
	},
	"glagolitic_c_let_myslite", {
		unicode: "{U+2C0F}",
		combiningForm: "{U+1E00F}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "М"],
		tags: ["прописная буква Мыслете глаголицы", "capital letter Myslite glagolitic"],
	},
	"glagolitic_s_let_myslite", {
		unicode: "{U+2C3F}",
		combiningForm: "{U+1E00F}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "м"],
		tags: ["строчная буква мыслете глаголицы", "small letter myslite glagolitic"],
	},
	"glagolitic_c_let_nashi", {
		unicode: "{U+2C10}",
		combiningForm: "{U+1E010}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Н"],
		tags: ["прописная буква Наш глаголицы", "capital letter Nashi glagolitic"],
	},
	"glagolitic_s_let_nashi", {
		unicode: "{U+2C40}",
		combiningForm: "{U+1E010}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "н"],
		tags: ["строчная буква наш глаголицы", "small letter nashi glagolitic"],
	},
	"glagolitic_c_let_onu", {
		unicode: "{U+2C11}",
		combiningForm: "{U+1E011}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "О"],
		tags: ["прописная буква Он глаголицы", "capital letter Onu glagolitic"],
	},
	"glagolitic_s_let_onu", {
		unicode: "{U+2C41}",
		combiningForm: "{U+1E011}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "о"],
		tags: ["строчная буква он глаголицы", "small letter onu glagolitic"],
	},
	"glagolitic_c_let_pokoji", {
		unicode: "{U+2C12}",
		combiningForm: "{U+1E012}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "П"],
		tags: ["прописная буква Покой глаголицы", "capital letter Pokoji glagolitic"],
	},
	"glagolitic_s_let_pokoji", {
		unicode: "{U+2C42}",
		combiningForm: "{U+1E012}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "п"],
		tags: ["строчная буква покой глаголицы", "small letter pokoji glagolitic"],
	},
	"glagolitic_c_let_ritsi", {
		unicode: "{U+2C13}",
		combiningForm: "{U+1E013}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Р"],
		tags: ["прописная буква Рцы глаголицы", "capital letter Ritsi glagolitic"],
	},
	"glagolitic_s_let_ritsi", {
		unicode: "{U+2C43}",
		combiningForm: "{U+1E013}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "р"],
		tags: ["строчная буква рцы глаголицы", "small letter ritsi glagolitic"],
	},
	"glagolitic_c_let_slovo", {
		unicode: "{U+2C14}",
		combiningForm: "{U+1E014}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "С"],
		tags: ["прописная буква Слово глаголицы", "capital letter Slovo glagolitic"],
	},
	"glagolitic_s_let_slovo", {
		unicode: "{U+2C44}",
		combiningForm: "{U+1E014}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "с"],
		tags: ["строчная буква слово глаголицы", "small letter slovo glagolitic"],
	},
	"glagolitic_c_let_tvrido", {
		unicode: "{U+2C15}",
		combiningForm: "{U+1E015}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Т"],
		tags: ["прописная Твердо глаголицы", "capital letter Tvrido glagolitic"],
	},
	"glagolitic_s_let_tvrido", {
		unicode: "{U+2C45}",
		combiningForm: "{U+1E015}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "т"],
		tags: ["строчная твердо глаголицы", "small letter tvrido glagolitic"],
	},
	"glagolitic_c_let_izhitsa", {
		unicode: "{U+2C2B}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">!<+ [И]",
		tags: ["прописная буква начальное Иже глаголицы", "capital letter Izhitsae glagolitic"],
	},
	"glagolitic_s_let_izhitsa", {
		unicode: "{U+2C5B}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">!<+ [и]",
		tags: ["строчная буква начальное иже глаголицы", "small letter izhitsa glagolitic"],
	},
	"glagolitic_c_let_uku", {
		unicode: "{U+2C16}",
		combiningForm: "{U+1E016}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "У"],
		tags: ["прописная буква Ук глаголицы", "capital letter Uku glagolitic"],
	},
	"glagolitic_s_let_uku", {
		unicode: "{U+2C46}",
		combiningForm: "{U+1E016}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "у"],
		tags: ["строчная буква ук глаголицы", "small letter uku glagolitic"],
	},
	"glagolitic_c_let_fritu", {
		unicode: "{U+2C17}",
		combiningForm: "{U+1E017}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ф"],
		tags: ["прописная буква Ферт глаголицы", "capital letter Fritu glagolitic"],
	},
	"glagolitic_s_let_fritu", {
		unicode: "{U+2C47}",
		combiningForm: "{U+1E017}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ф"],
		tags: ["строчная буква ферт глаголицы", "small letter fritu glagolitic"],
	},
	"glagolitic_c_let_heru", {
		unicode: "{U+2C18}",
		combiningForm: "{U+1E018}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Х"],
		tags: ["прописная буква Хер глаголицы", "capital letter Heru glagolitic"],
	},
	"glagolitic_s_let_heru", {
		unicode: "{U+2C48}",
		combiningForm: "{U+1E018}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "х"],
		tags: ["строчная буква хер глаголицы", "small letter heru glagolitic"],
	},
	"glagolitic_c_let_otu", {
		unicode: "{U+2C19}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [О]",
		tags: ["прописная буква От глаголицы", "capital letter Otu glagolitic"],
	},
	"glagolitic_s_let_otu", {
		unicode: "{U+2C49}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [о]",
		tags: ["строчная буква от глаголицы", "small letter otu glagolitic"],
	},
	"glagolitic_c_let_pe", {
		unicode: "{U+2C1A}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [П]",
		tags: ["прописная буква Пе глаголицы", "capital letter Pe glagolitic"],
	},
	"glagolitic_s_let_pe", {
		unicode: "{U+2C4A}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [п]",
		tags: ["строчная буква пе глаголицы", "small letter pe glagolitic"],
	},
	"glagolitic_c_let_tsi", {
		unicode: "{U+2C1C}",
		combiningForm: "{U+1E01C}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ц"],
		tags: ["прописная буква Цы глаголицы", "capital letter Tsi glagolitic"],
	},
	"glagolitic_s_let_tsi", {
		unicode: "{U+2C4C}",
		combiningForm: "{U+1E01C}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ц"],
		tags: ["строчная буква цы глаголицы", "small letter tsi glagolitic"],
	},
	"glagolitic_c_let_chrivi", {
		unicode: "{U+2C1D}",
		combiningForm: "{U+1E01D}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ч"],
		tags: ["прописная буква Червь глаголицы", "capital letter Chrivi glagolitic"],
	},
	"glagolitic_s_let_chrivi", {
		unicode: "{U+2C4D}",
		combiningForm: "{U+1E01D}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ч"],
		tags: ["строчная буква червь глаголицы", "small letter chrivi glagolitic"],
	},
	"glagolitic_c_let_sha", {
		unicode: "{U+2C1E}",
		combiningForm: "{U+1E01E}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ш"],
		tags: ["прописная буква Ша глаголицы", "capital letter Sha glagolitic"],
	},
	"glagolitic_s_let_sha", {
		unicode: "{U+2C4E}",
		combiningForm: "{U+1E01E}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ш"],
		tags: ["строчная буква ша глаголицы", "small letter sha glagolitic"],
	},
	"glagolitic_c_let_shta", {
		unicode: "{U+2C1B}",
		combiningForm: "{U+1E01B}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Щ"],
		tags: ["прописная буква Шта глаголицы", "capital letter Shta glagolitic"],
	},
	"glagolitic_s_let_shta", {
		unicode: "{U+2C4B}",
		combiningForm: "{U+1E01B}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "щ"],
		tags: ["строчная буква шта глаголицы", "small letter shta glagolitic"],
	},
	"glagolitic_c_let_yeru", {
		unicode: "{U+2C1F}",
		combiningForm: "{U+1E01F}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ъ"],
		tags: ["прописная буква Еръ глаголицы", "capital letter Yeru glagolitic"],
	},
	"glagolitic_s_let_yeru", {
		unicode: "{U+2C4F}",
		combiningForm: "{U+1E01F}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ъ"],
		tags: ["строчная буква еръ глаголицы", "small letter yeru glagolitic"],
	},
	"glagolitic_c_let_yery", {
		unicode: "{U+2C1F}",
		uniSequence: ["{U+2C1F}", "{U+2C0A}"],
		combiningForm: ["{U+1E01F}", "{U+1E00A}"],
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ы"],
		tags: ["прописная буква Еры глаголицы", "capital letter Yery glagolitic"],
		symbolCustom: "s36"
	},
	"glagolitic_s_let_yery", {
		unicode: "{U+2C4F}",
		uniSequence: ["{U+2C4F}", "{U+2C3A}"],
		combiningForm: ["{U+1E01F}", "{U+1E00A}"],
		titlesAlt: True,
		group: ["Glagolitic Letters", "ы"],
		tags: ["строчная буква еры глаголицы", "small letter yery glagolitic"],
		symbolCustom: "s36"
	},
	"glagolitic_c_let_yeri", {
		unicode: "{U+2C20}",
		combiningForm: "{U+1E020}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ь"],
		tags: ["прописная буква Ерь глаголицы", "capital letter Yeri glagolitic"],
	},
	"glagolitic_s_let_yeri", {
		unicode: "{U+2C50}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ь"],
		tags: ["строчная буква ерь глаголицы", "small letter yeri glagolitic"],
	},
	"glagolitic_c_let_yati", {
		unicode: "{U+2C21}",
		combiningForm: "{U+1E021}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Я"],
		tags: ["прописная буква Ять глаголицы", "capital letter Yati glagolitic"],
	},
	"glagolitic_s_let_yati", {
		unicode: "{U+2C51}",
		combiningForm: "{U+1E021}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "я"],
		tags: ["строчная буква ять глаголицы", "small letter yati glagolitic"],
	},
	"glagolitic_c_let_yo", {
		unicode: "{U+2C26}",
		combiningForm: "{U+1E026}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ё"],
		tags: ["прописная буква Ё глаголицы", "capital letter Yo glagolitic"],
	},
	"glagolitic_s_let_yo", {
		unicode: "{U+2C56}",
		combiningForm: "{U+1E026}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ё"],
		tags: ["строчная буква ё глаголицы", "small letter yo glagolitic"],
	},
	"glagolitic_c_let_spider_ha", {
		unicode: "{U+2C22}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["прописная буква Хлъмъ глаголицы", "capital letter spider Ha glagolitic"],
		alt_layout: ">! [Х]",
	},
	"glagolitic_s_let_spider_ha", {
		unicode: "{U+2C52}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["строчная буква хлъмъ глаголицы", "small letter spider ha glagolitic"],
		alt_layout: ">! [х]",
	},
	"glagolitic_c_let_yu", {
		unicode: "{U+2C23}",
		combiningForm: "{U+1E023}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Ю"],
		tags: ["прописная буква Ю глаголицы", "capital letter Yu glagolitic"],
	},
	"glagolitic_s_let_yu", {
		unicode: "{U+2C53}",
		combiningForm: "{U+1E023}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "ю"],
		tags: ["строчная буква ю глаголицы", "small letter yu glagolitic"],
	},
	"glagolitic_c_let_small_yus", {
		unicode: "{U+2C24}",
		combiningForm: "{U+1E024}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "Э"],
		tags: ["прописная буква Юс малый глаголицы", "capital letter small letter Yus glagolitic"],
	},
	"glagolitic_s_let_small_yus", {
		unicode: "{U+2C54}",
		combiningForm: "{U+1E024}",
		titlesAlt: True,
		group: ["Glagolitic Letters", "э"],
		tags: ["строчная буква юс малый глаголицы", "small letter small letter yus glagolitic"],
	},
	"glagolitic_c_let_small_yus_iotified", {
		unicode: "{U+2C27}",
		combiningForm: "{U+1E027}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["прописная буква Юс малый йотированный глаголицы", "capital letter small letter Yus iotified glagolitic"],
		alt_layout: ">! [Э]",
		recipe: Chr(0x2C05) Chr(0x2C24),
	},
	"glagolitic_s_let_small_yus_iotified", {
		unicode: "{U+2C57}",
		combiningForm: "{U+1E027}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["строчная буква юс малый йотированный глаголицы", "small letter small letter yus iotified glagolitic"],
		alt_layout: ">! [э]",
		recipe: Chr(0x2C35) Chr(0x2C54),
	},
	"glagolitic_c_let_big_yus", {
		unicode: "{U+2C28}",
		combiningForm: "{U+1E028}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["прописная буква Юс большой глаголицы", "capital letter big Yus glagolitic"],
		alt_layout: "<! [О]",
		recipe: Chr(0x2C11) Chr(0x2C24),
	},
	"glagolitic_s_let_big_yus", {
		unicode: "{U+2C58}",
		combiningForm: "{U+1E028}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["строчная буква юс большой глаголицы", "small letter big yus glagolitic"],
		alt_layout: "<! [о]",
		recipe: Chr(0x2C41) Chr(0x2C54),
	},
	"glagolitic_c_let_big_yus_iotified", {
		unicode: "{U+2C29}",
		combiningForm: "{U+1E029}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["прописная буква Юс большой йотированный глаголицы", "capital letter big Yus iotified glagolitic"],
		alt_layout: "<! [Ё]",
		recipe: Chr(0x2C26) Chr(0x2C24),
	},
	"glagolitic_s_let_big_yus_iotified", {
		unicode: "{U+2C59}",
		combiningForm: "{U+1E029}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		tags: ["строчная буква юс большой йотированный глаголицы", "small letter big yus iotified glagolitic"],
		alt_layout: "<! [ё]",
		recipe: Chr(0x2C56) Chr(0x2C54),
	},
	"glagolitic_c_let_fita", {
		unicode: "{U+2C2A}",
		combiningForm: "{U+1E02A}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [Ф]",
		tags: ["прописная буква Фита глаголицы", "capital letter Fita glagolitic"],
	},
	"glagolitic_s_let_fita", {
		unicode: "{U+2C5A}",
		combiningForm: "{U+1E02A}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [ф]",
		tags: ["строчная буква фита глаголицы", "small letter fita glagolitic"],
	},
	"glagolitic_c_let_shtapic", {
		unicode: "{U+2C2C}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [Ъ]",
		tags: ["прописная буква Штапик глаголицы", "capital letter Shtapic glagolitic"],
	},
	"glagolitic_s_let_shtapic", {
		unicode: "{U+2C5C}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [ъ]",
		tags: ["строчная буква штапик глаголицы", "small letter shtapic glagolitic"],
	},
	"glagolitic_c_let_trokutasti_a", {
		unicode: "{U+2C2D}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [А]",
		tags: ["прописная треугольная А глаголицы", "capital letter trokutasti A glagolitic"],
	},
	"glagolitic_s_let_trokutasti_a", {
		unicode: "{U+2C5D}",
		titlesAlt: True,
		group: ["Glagolitic Letters"],
		alt_layout: ">! [А]",
		tags: ["строчная треугольная a глаголицы", "small letter trokutasti a glagolitic"],
	},
	;
	;
	;
	"futhark_ansuz", {
		unicode: "{U+16A8}",
		titlesAlt: True,
		group: ["Futhark Runes", "A"],
		tags: ["старший футарк ансуз", "elder futhark ansuz"],
	},
	"futhark_berkanan", {
		unicode: "{U+16D2}",
		titlesAlt: True,
		group: ["Futhark Runes", "B"],
		tags: ["старший футарк беркана", "elder futhark berkanan", "futhork beorc", "younger futhark bjarkan"],
	},
	"futhark_dagaz", {
		unicode: "{U+16DE}",
		titlesAlt: True,
		group: ["Futhark Runes", "D"],
		tags: ["старший футарк дагаз", "elder futhark dagaz", "futhork daeg", "futhork dæg"],
	},
	"futhark_ehwaz", {
		unicode: "{U+16D6}",
		titlesAlt: True,
		group: ["Futhark Runes", "E"],
		tags: ["старший футарк эваз", "elder futhark ehwaz", "futhork eh"],
	},
	"futhark_fehu", {
		unicode: "{U+16A0}",
		titlesAlt: True,
		group: ["Futhark Runes", "F"],
		tags: ["старший футарк феху", "elder futhark fehu", "futhork feoh", "younger futhark fe", "younger futhark fé"],
	},
	"futhark_gebo", {
		unicode: "{U+16B7}",
		titlesAlt: True,
		group: ["Futhark Runes", "G"],
		tags: ["старший футарк гебо", "elder futhark gebo", "futhork gyfu", "elder futhark gebō"],
	},
	"futhark_haglaz", {
		unicode: "{U+16BA}",
		titlesAlt: True,
		group: ["Futhark Runes", "H"],
		tags: ["старший футарк хагалаз", "elder futhark hagalaz"],
	},
	"futhark_isaz", {
		unicode: "{U+16C1}",
		titlesAlt: True,
		group: ["Futhark Runes", "I"],
		tags: ["старший футарк исаз", "elder futhark isaz", "futhork is", "younger futhark iss", "futhork īs", "younger futhark íss"],
	},
	"futhark_eihwaz", {
		unicode: "{U+16C7}",
		titlesAlt: True,
		group: ["Futhark Runes"],
		alt_layout: ">+ [I]",
		tags: ["старший футарк эваз", "elder futhark eihwaz", "elder futhark iwaz", "elder futhark ēihwaz", "futhork eoh", "futhork ēoh"],
	},
	"futhark_jeran", {
		unicode: "{U+16C3}",
		titlesAlt: True,
		group: ["Futhark Runes", "J"],
		tags: ["старший футарк йера", "elder futhark jeran", "elder futhark jēra"],
	},
	"futhark_kauna", {
		unicode: "{U+16B2}",
		titlesAlt: True,
		group: ["Futhark Runes", "K"],
		tags: ["старший футарк кеназ", "elder futhark kauna", "elder futhark kenaz", "elder futhark kauną"],
	},
	"futhark_laguz", {
		unicode: "{U+16DA}",
		titlesAlt: True,
		group: ["Futhark Runes", "L"],
		tags: ["старший футарк лагуз", "elder futhark laukaz", "elder futhark laguz", "futhork lagu", "futhork logr", "futhork lögr"],
	},
	"futhark_mannaz", {
		unicode: "{U+16D7}",
		titlesAlt: True,
		group: ["Futhark Runes", "M"],
		tags: ["старший футарк манназ", "elder futhark mannaz", "futhork mann"],
	},
	"futhark_naudiz", {
		unicode: "{U+16BE}",
		titlesAlt: True,
		group: ["Futhark Runes", "N"],
		tags: ["старший футарк наудиз", "elder futhark naudiz", "futhork nyd", "younger futhark naudr", "younger futhark nauðr"],
	},
	"futhark_ingwaz", {
		unicode: "{U+16DC}",
		titlesAlt: True,
		group: ["Futhark Runes"],
		alt_layout: ">+ [N]",
		tags: ["старший футарк ингваз", "elder futhark ingwaz"],
	},
	"futhark_odal", {
		unicode: "{U+16DF}",
		titlesAlt: True,
		group: ["Futhark Runes", "O"],
		tags: ["старший футарк одал", "elder futhark othala", "futhork edel", "elder futhark ōþala", "futhork ēðel"],
	},
	"futhark_pertho", {
		unicode: "{U+16C8}",
		titlesAlt: True,
		group: ["Futhark Runes", "P"],
		tags: ["старший футарк перто", "elder futhark pertho", "futhork peord", "elder futhark perþō", "futhork peorð"],
	},
	"futhark_raido", {
		unicode: "{U+16B1}",
		titlesAlt: True,
		group: ["Futhark Runes", "R"],
		tags: ["старший футарк райдо", "elder futhark raido", "futhork rad", "younger futhark reid", "elder futhark raidō", "futhork rād", "younger futhark reið"],
	},
	"futhark_sowilo", {
		unicode: "{U+16CA}",
		titlesAlt: True,
		group: ["Futhark Runes", "S"],
		tags: ["старший футарк совило", "elder futhark sowilo", "elder futhark sōwilō"],
	},
	"futhark_tiwaz", {
		unicode: "{U+16CF}",
		titlesAlt: True,
		group: ["Futhark Runes", "T"],
		tags: ["старший футарк тейваз", "elder futhark tiwaz", "futhork ti", "futhork tir", "younger futhark tyr", "elder futhark tēwaz", "futhork tī", "futhork tīr", "younger futhark týr"],
	},
	"futhark_thurisaz", {
		unicode: "{U+16A6}",
		titlesAlt: True,
		group: ["Futhark Runes"],
		alt_layout: ">+[T]",
		tags: ["старший футарк турисаз", "elder futhark thurisaz", "futhork thorn", "younger futhark thurs", "elder futhark þurisaz", "futhork þorn", "younger futhark þurs"],
	},
	"futhark_uruz", {
		unicode: "{U+16A2}",
		titlesAlt: True,
		group: ["Futhark Runes", "U"],
		tags: ["старший футарк уруз", "elder futhark uruz", "elder futhark ura", "futhork ur", "younger futhark ur", "elder futhark ūrą", "elder futhark ūruz", "futhork ūr", "younger futhark úr"],
	},
	"futhark_wunjo", {
		unicode: "{U+16B9}",
		titlesAlt: True,
		group: ["Futhark Runes", "W"],
		tags: ["старший футарк вуньо", "elder futhark wunjo", "futhork wynn", "elder futhark wunjō", "elder futhark ƿunjō", "futhork ƿynn"],
	},
	"futhark_algiz", {
		unicode: "{U+16C9}",
		titlesAlt: True,
		group: ["Futhark Runes", "Z"],
		tags: ["старший футарк альгиз", "elder futhark algiz", "futhork eolhx"],
	},
	"futhork_as", {
		unicode: "{U+16AA}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [A]",
		tags: ["футорк ас", "futhork as", "futhork ās"],
	},
	"futhork_aesc", {
		unicode: "{U+16AB}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: ">+ [A]",
		tags: ["футорк эск", "futhork aesc", "futhork æsc"],
		recipe: Chr(0x16A8) Chr(0x16D6),
	},
	"futhork_cen", {
		unicode: "{U+16B3}",
		titlesAlt: True,
		group: ["Futhork Runes", "C"],
		tags: ["футорк кен", "futhork cen", "futhork cēn"],
	},
	"futhork_ear", {
		unicode: "{U+16E0}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [E]",
		tags: ["футорк эар", "ear"],
	},
	"futhork_gar", {
		unicode: "{U+16B8}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [G]",
		tags: ["футорк гар", "futhork gar", "futhork gār"],
	},
	"futhork_haegl", {
		unicode: "{U+16BB}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [H]",
		tags: ["футорк хегль", "futhork haegl", "futhork hægl"],
	},
	"futhork_ger", {
		unicode: "{U+16C4}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [J]",
		tags: ["футорк гер", "futhork ger", "futhork gēr"],
	},
	"futhork_ior", {
		unicode: "{U+16E1}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: ">+ [J]",
		tags: ["футорк йор", "futhork gerx", "futhork ior", "younger futhark arx", "futhork gērx", "futhork īor", "youner futhark árx"],
	},
	"futhork_cealc", {
		unicode: "{U+16E4}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [K]",
		tags: ["футорк келк", "futhork cealc"],
	},
	"futhork_calc", {
		unicode: "{U+16E3}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: ">+ [K]",
		tags: ["футорк калк", "futhork calc"],
	},
	"futhork_ing", {
		unicode: "{U+16DD}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [N]",
		tags: ["футорк инг", "futhork ing"],
	},
	"futhork_os", {
		unicode: "{U+16A9}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [O]",
		tags: ["футорк ос", "futhork os", "futhork ōs"],
	},
	"futhork_cweorth", {
		unicode: "{U+16E2}",
		titlesAlt: True,
		group: ["Futhork Runes", "Q"],
		tags: ["футорк квирд", "futhark cweorth", "futhork cƿeorð"],
	},
	"futhork_sigel", {
		unicode: "{U+16CB}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [S]",
		tags: ["футорк сигель", "futhork sigel", "younger futhark sól"],
	},
	"futhork_stan", {
		unicode: "{U+16E5}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: ">+ [S]",
		tags: ["футорк стан", "futhork stan"],
	},
	"futhork_yr", {
		unicode: "{U+16A3}",
		titlesAlt: True,
		group: ["Futhork Runes"],
		alt_layout: "<+ [Y]",
		tags: ["футорк ир", "futhork yr", "futhork ȳr"],
	},
	"futhark_younger_jera", {
		unicode: "{U+16C5}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">! [A]",
		tags: ["младший футарк йера", "younger futhark jera", "younger futhark ar", "younger futhark ár"],
	},
	"futhark_younger_jera_short_twig", {
		unicode: "{U+16C6}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [A]",
		tags: ["младший футарк короткая йера", "younger futhark short twig jera"],
	},
	"futhark_younger_bjarkan_short_twig", {
		unicode: "{U+16D3}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [B]",
		tags: ["младший футарк короткая беркана", "younger futhark short twig bjarkan"],
	},
	"futhark_younger_hagall", {
		unicode: "{U+16BC}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">! [H]",
		tags: ["младший футарк хагал", "younger futhark hagall"],
	},
	"futhark_younger_hagall_short_twig", {
		unicode: "{U+16BD}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [H]",
		tags: ["младший футарк короткий хагал", "younger futhark short twig hagall"],
	},
	"futhark_younger_kaun", {
		unicode: "{U+16B4}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">! [K]",
		tags: ["младший футарк каун", "younger futhark kaun"],
	},
	"futhark_younger_madr", {
		unicode: "{U+16D8}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">! [M]",
		tags: ["младший футарк мадр", "younger futhark madr", "younger futhark maðr"],
	},
	"futhark_younger_madr_short_twig", {
		unicode: "{U+16D9}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [M]",
		tags: ["младший футарк короткий мадр", "younger futhark short twig madr", "younger futhark short twig maðr"],
	},
	"futhark_younger_naud_short_twig", {
		unicode: "{U+16BF}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [N]",
		tags: ["младший футарк короткий науд", "younger futhark short twig naud", "younger futhark short twig nauðr"],
	},
	"futhark_younger_oss", {
		unicode: "{U+16AC}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">! [O]",
		tags: ["младший футарк осс", "younger futhark oss", "younger futhark óss"],
	},
	"futhark_younger_oss_short_twig", {
		unicode: "{U+16AD}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [O]",
		tags: ["младший футарк короткий осс", "younger futhark short twig oss", "younger futhark short twig óss"],
	},
	"futhark_younger_sol_short_twig", {
		unicode: "{U+16CC}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [S]",
		tags: ["младший футарк короткий сол", "younger futhark short twig sol", "younger futhark short twig sól"],
	},
	"futhark_younger_tyr_short_twig", {
		unicode: "{U+16D0}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [T]",
		tags: ["младший футарк короткий тир", "younger futhark short twig tyr", "younger futhark short twig týr"],
	},
	"futhark_younger_ur", {
		unicode: "{U+16A4}",
		titlesAlt: True,
		group: ["Younger Futhark Runes", "Y"],
		tags: ["младший футарк ур", "younger futhark ur"],
	},
	"futhark_younger_yr", {
		unicode: "{U+16E6}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">![Y]",
		tags: ["младший футарк короткий тис", "younger futhark yr"],
	},
	"futhark_younger_yr_short_twig", {
		unicode: "{U+16E7}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">!<+ [Y]",
		tags: ["младший футарк короткий тис", "younger futhark short twig yr"],
	},
	"futhark_younger_icelandic_yr", {
		unicode: "{U+16E8}",
		titlesAlt: True,
		group: ["Younger Futhark Runes"],
		alt_layout: ">+ [Y]",
		tags: ["младший футарк исладнский тис", "younger futhark icelandic yr"],
	},
	"futhark_almanac_arlaug", {
		unicode: "{U+16EE}",
		titlesAlt: True,
		group: ["Almanac Runes"],
		alt_layout: ">! [7]",
		tags: ["золотой номер 17 арлауг", "golden number 17 arlaug"],
	},
	"futhark_almanac_tvimadur", {
		unicode: "{U+16EF}",
		titlesAlt: True,
		group: ["Almanac Runes"],
		alt_layout: ">! [8]",
		tags: ["золотой номер 18 твимадур", "golden number 18 tvimadur", "golden number 18 tvímaður"],
	},
	"futhark_almanac_belgthor", {
		unicode: "{U+16F0}",
		titlesAlt: True,
		group: ["Almanac Runes"],
		alt_layout: ">! [9]",
		tags: ["золотой номер 19 белгтор", "golden number 19 belgthor"],
	},
	"futhark_younger_later_e", {
		unicode: "{U+16C2}",
		titlesAlt: True,
		group: ["Later Younger Futhark Runes"],
		alt_layout: ">! [E]",
		tags: ["младшяя поздняя е", "later younger futhark e"],
	},
	"futhark_younger_later_eth", {
		unicode: "{U+16A7}",
		titlesAlt: True,
		group: ["Later Younger Futhark Runes"],
		alt_layout: ">! [D]",
		tags: ["поздний младший футарк эт", "later younger futhark eth"],
	},
	"futhark_younger_later_d", {
		unicode: "{U+16D1}",
		titlesAlt: True,
		group: ["Later Younger Futhark Runes"],
		alt_layout: ">!<+ [D]",
		tags: ["поздний младший футарк д", "later younger futhark d"],
	},
	"futhark_younger_later_l", {
		unicode: "{U+16DB}",
		titlesAlt: True,
		group: ["Later Younger Futhark Runes"],
		alt_layout: ">! [L]",
		tags: ["поздний младший футарк л", "later younger futhark l"],
	},
	"futhark_younger_later_p", {
		unicode: "{U+16D4}",
		titlesAlt: True,
		group: ["Later Younger Futhark Runes"],
		alt_layout: ">! [P]",
		tags: ["младшяя поздняя п", "later younger futhark p"],
	},
	"futhark_younger_later_v", {
		unicode: "{U+16A1}",
		titlesAlt: True,
		group: ["Later Younger Futhark Runes", "V"],
		tags: ["поздний младший футарк в", "later younger futhark v"],
	},
	"medieval_c", {
		unicode: "{U+16CD}",
		titlesAlt: True,
		group: ["Medieval Runes"],
		alt_layout: ">!<! [C]",
		tags: ["средневековый си", "medieval с"],
	},
	"medieval_en", {
		unicode: "{U+16C0}",
		titlesAlt: True,
		group: ["Medieval Runes"],
		alt_layout: ">!<! [N]",
		tags: ["средневековый эн", "medieval en"],
	},
	"medieval_on", {
		unicode: "{U+16B0}",
		titlesAlt: True,
		group: ["Medieval Runes"],
		alt_layout: ">!<! [O]",
		tags: ["средневековый он", "medieval on"],
	},
	"medieval_o", {
		unicode: "{U+16AE}",
		titlesAlt: True,
		group: ["Medieval Runes"],
		alt_layout: ">!<!>+ [O]",
		tags: ["средневековый о", "medieval o"],
	},
	"medieval_x", {
		unicode: "{U+16EA}",
		titlesAlt: True,
		group: ["Medieval Runes"],
		alt_layout: ">!<! [X]",
		tags: ["средневековый экс", "medieval ex"],
	},
	"medieval_z", {
		unicode: "{U+16CE}",
		titlesAlt: True,
		group: ["Medieval Runes"],
		alt_layout: ">!<! [Z]",
		tags: ["средневековый зе", "medieval ze"],
	},
	"runic_single_punctuation", {
		unicode: "{U+16EB}",
		titlesAlt: True,
		group: ["Runic Punctuation"],
		alt_layout: ">! [.]",
		tags: ["руническая одиночное препинание", "runic single punctuation"],
	},
	"runic_multiple_punctuation", {
		unicode: "{U+16EC}",
		titlesAlt: True,
		group: ["Runic Punctuation"],
		alt_layout: ">! [Space]",
		tags: ["руническое двойное препинание", "runic multiple punctuation"],
	},
	"runic_cruciform_punctuation", {
		unicode: "{U+16ED}",
		titlesAlt: True,
		group: ["Runic Punctuation"],
		alt_layout: ">! [,]",
		tags: ["руническое крестовидное препинание", "runic cruciform punctuation"],
	},
	;
	"turkic_orkhon_a", {
		unicode: "{U+10C00}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[A]",
		tags: ["древнетюркская орхонская буква а", "old turkic orkhon letter a"],
	},
	"turkic_yenisei_a", {
		unicode: "{U+10C01}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [A]",
		tags: ["древнетюркская енисейская буква а", "old turkic yenisei letter a"],
	},
	"turkic_yenisei_ae", {
		unicode: "{U+10C02}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: ">! [A]",
		tags: ["древнетюркская енисейская буква я", "old turkic yenisei letter ae"],
	},
	"turkic_yenisei_e", {
		unicode: "{U+10C05}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "[E]",
		tags: ["древнетюркская енисейская буква е", "old turkic yenisei letter e"],
	},
	"turkic_orkhon_i", {
		unicode: "{U+10C03}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[I]",
		tags: ["древнетюркская орхонская буква и", "old turkic orkhon letter i"],
	},
	"turkic_yenisei_i", {
		unicode: "{U+10C04}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [I]",
		tags: ["древнетюркская енисейская буква и", "old turkic yenisei letter i"],
	},
	"turkic_orkhon_o", {
		unicode: "{U+10C06}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[O]",
		tags: ["древнетюркская орхонская буква о", "old turkic orkhon letter o"],
	},
	"turkic_orkhon_oe", {
		unicode: "{U+10C07}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [O]",
		tags: ["древнетюркская орхонская буква ё", "old turkic orkhon letter oe"],
	},
	"turkic_yenisei_oe", {
		unicode: "{U+10C08}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [O]",
		tags: ["древнетюркская енисейская буква ё", "old turkic yenisei letter oe"],
	},
	"turkic_orkhon_ec", {
		unicode: "{U+10C32}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[C]",
		tags: ["древнетюркская орхонская буква эч", "old turkic orkhon letter ec"],
	},
	"turkic_yenisei_ec", {
		unicode: "{U+10C33}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [C]",
		tags: ["древнетюркская енисейская буква эч", "old turkic yenisei letter ec"],
	},
	"turkic_orkhon_em", {
		unicode: "{U+10C22}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[M]",
		tags: ["древнетюркская орхонская буква эм", "old turkic orkhon letter em"],
	},
	"turkic_orkhon_eng", {
		unicode: "{U+10C2D}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<! [N]",
		tags: ["древнетюркская орхонская буква энг", "old turkic orkhon letter eng"],
	},
	"turkic_orkhon_ep", {
		unicode: "{U+10C2F}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[P]",
		tags: ["древнетюркская орхонская буква эп", "old turkic orkhon letter ep"],
	},
	"turkic_orkhon_esh", {
		unicode: "{U+10C41}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<! [S]",
		tags: ["древнетюркская орхонская буква эш", "old turkic orkhon letter esh"],
	},
	"turkic_yenisei_esh", {
		unicode: "{U+10C42}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*<! [S]",
		tags: ["древнетюркская енисейская буква эш", "old turkic yenisei letter esh"],
	},
	"turkic_orkhon_ez", {
		unicode: "{U+10C14}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[Z]",
		tags: ["древнетюркская орхонская буква эз", "old turkic orkhon letter ez"],
	},
	"turkic_yenisei_ez", {
		unicode: "{U+10C15}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [Z]",
		tags: ["древнетюркская енисейская буква эз", "old turkic yenisei letter ez"],
	},
	"turkic_orkhon_elt", {
		unicode: "{U+10C21}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">!>+ [T]",
		tags: ["древнетюркская орхонская буква элт", "old turkic orkhon letter elt"],
	},
	"turkic_orkhon_enc", {
		unicode: "{U+10C28}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">+ [N]",
		tags: ["древнетюркская орхонская буква энч", "old turkic orkhon letter enc"],
	},
	"turkic_yenisei_enc", {
		unicode: "{U+10C29}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>+ [N]",
		tags: ["древнетюркская енисейская буква энч", "old turkic yenisei letter enc"],
	},
	"turkic_orkhon_eny", {
		unicode: "{U+10C2A}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<+ [N]",
		tags: ["древнетюркская орхонская буква энь", "old turkic orkhon letter eny"],
	},
	"turkic_yenisei_eny", {
		unicode: "{U+10C2B}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*<+ [N]",
		tags: ["древнетюркская енисейская буква энь", "old turkic yenisei letter eny"],
	},
	"turkic_orkhon_ent", {
		unicode: "{U+10C26}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">!>+ [N]",
		tags: ["древнетюркская орхонская буква энт", "old turkic orkhon letter ent"],
	},
	"turkic_yenisei_ent", {
		unicode: "{U+10C27}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>!>+ [N]",
		tags: ["древнетюркская енисейская буква энт", "old turkic yenisei letter ent"],
	},
	"turkic_orkhon_bash", {
		unicode: "{U+10C48}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<! [R]",
		tags: ["древнетюркская орхонская буква баш", "old turkic orkhon letter bash"],
	},
	"turkic_orkhon_ab", {
		unicode: "{U+10C09}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[B]",
		tags: ["древнетюркская орхонская буква аб", "old turkic orkhon letter ab"],
	},
	"turkic_yenisei_ab", {
		unicode: "{U+10C0A}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [B]",
		tags: ["древнетюркская енисейская буква аб", "old turkic yenisei letter ab"],
	},
	"turkic_orkhon_aeb", {
		unicode: "{U+10C0B}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [B]",
		tags: ["древнетюркская орхонская буква ябь", "old turkic orkhon letter aeb"],
	},
	"turkic_yenisei_aeb", {
		unicode: "{U+10C0C}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [B]",
		tags: ["древнетюркская енисейская буква ябь", "old turkic yenisei letter aeb"],
	},
	"turkic_orkhon_ad", {
		unicode: "{U+10C11}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[D]",
		tags: ["древнетюркская орхонская буква ад", "old turkic orkhon letter ad"],
	},
	"turkic_yenisei_ad", {
		unicode: "{U+10C12}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [D]",
		tags: ["древнетюркская енисейская буква ад", "old turkic yenisei letter ad"],
	},
	"turkic_orkhon_aed", {
		unicode: "{U+10C13}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [D]",
		tags: ["древнетюркская орхонская буква ядь", "old turkic orkhon letter aed"],
	},
	"turkic_orkhon_al", {
		unicode: "{U+10C1E}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[L]",
		tags: ["древнетюркская орхонская буква ал", "old turkic orkhon letter al"],
	},
	"turkic_yenisei_al", {
		unicode: "{U+10C1F}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [L]",
		tags: ["древнетюркская енисейская буква ал", "old turkic yenisei letter al"],
	},
	"turkic_orkhon_ael", {
		unicode: "{U+10C20}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [L]",
		tags: ["древнетюркская орхонская буква яль", "old turkic orkhon letter ael"],
	},
	"turkic_orkhon_an", {
		unicode: "{U+10C23}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[N]",
		tags: ["древнетюркская орхонская буква ан", "old turkic orkhon letter an"],
	},
	"turkic_orkhon_aen", {
		unicode: "{U+10C24}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [N]",
		tags: ["древнетюркская орхонская буква янь", "old turkic orkhon letter aen"],
	},
	"turkic_yenisei_aen", {
		unicode: "{U+10C25}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [N]",
		tags: ["древнетюркская енисейская буква янь", "old turkic yenisei letter aen"],
	},
	"turkic_orkhon_ar", {
		unicode: "{U+10C3A}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[R]",
		tags: ["древнетюркская орхонская буква ар", "old turkic orkhon letter ar"],
	},
	"turkic_yenisei_ar", {
		unicode: "{U+10C3B}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [R]",
		tags: ["древнетюркская енисейская буква ар", "old turkic yenisei letter ar"],
	},
	"turkic_orkhon_aer", {
		unicode: "{U+10C3C}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [R]",
		tags: ["древнетюркская орхонская буква ярь", "old turkic orkhon letter aer"],
	},
	"turkic_orkhon_as", {
		unicode: "{U+10C3D}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[S]",
		tags: ["древнетюркская орхонская буква ар", "old turkic orkhon letter as"],
	},
	"turkic_orkhon_aes", {
		unicode: "{U+10C3E}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [S]",
		tags: ["древнетюркская орхонская буква ярь", "old turkic orkhon letter aes"],
	},
	"turkic_orkhon_at", {
		unicode: "{U+10C43}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[T]",
		tags: ["древнетюркская орхонская буква ат", "old turkic orkhon letter at"],
	},
	"turkic_yenisei_at", {
		unicode: "{U+10C44}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [T]",
		tags: ["древнетюркская енисейская буква ат", "old turkic yenisei letter at"],
	},
	"turkic_orkhon_aet", {
		unicode: "{U+10C45}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [T]",
		tags: ["древнетюркская орхонская буква ять", "old turkic orkhon letter aet"],
	},
	"turkic_yenisei_aet", {
		unicode: "{U+10C46}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [T]",
		tags: ["древнетюркская енисейская буква ять", "old turkic yenisei letter aet"],
	},
	"turkic_orkhon_ay", {
		unicode: "{U+10C16}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[Y]",
		tags: ["древнетюркская орхонская буква ай", "old turkic orkhon letter ay"],
	},
	"turkic_yenisei_ay", {
		unicode: "{U+10C17}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [Y]",
		tags: ["древнетюркская енисейская буква ай", "old turkic yenisei letter ay"],
	},
	"turkic_orkhon_aey", {
		unicode: "{U+10C18}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [Y], [J]",
		tags: ["древнетюркская орхонская буква яй", "old turkic orkhon letter aey"],
	},
	"turkic_yenisei_aey", {
		unicode: "{U+10C19}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [Y], [J]",
		tags: ["древнетюркская енисейская буква яй", "old turkic yenisei letter aey"],
	},
	"turkic_orkhon_ag", {
		unicode: "{U+10C0D}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[G]",
		tags: ["древнетюркская орхонская буква агх", "old turkic orkhon letter ag"],
	},
	"turkic_yenisei_ag", {
		unicode: "{U+10C0E}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [G]",
		tags: ["древнетюркская енисейская буква агх", "old turkic yenisei letter ag"],
	},
	"turkic_orkhon_aeg", {
		unicode: "{U+10C0F}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [G]",
		tags: ["древнетюркская орхонская буква ягь", "old turkic orkhon letter aeg"],
	},
	"turkic_yenisei_aeg", {
		unicode: "{U+10C10}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [G]",
		tags: ["древнетюркская енисейская буква ягь", "old turkic yenisei letter aeg"],
	},
	"turkic_orkhon_aq", {
		unicode: "{U+10C34}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[K]",
		tags: ["древнетюркская орхонская буква акх", "old turkic orkhon letter aq"],
	},
	"turkic_yenisei_aq", {
		unicode: "{U+10C35}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [K]",
		tags: ["древнетюркская енисейская буква акх", "old turkic yenisei letter aq"],
	},
	"turkic_orkhon_aek", {
		unicode: "{U+10C1A}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [K]",
		tags: ["древнетюркская орхонская буква якь", "old turkic orkhon letter aek"],
	},
	"turkic_yenisei_aek", {
		unicode: "{U+10C1B}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [K]",
		tags: ["древнетюркская енисейская буква якь", "old turkic yenisei letter aek"],
	},
	"turkic_orkhon_oq", {
		unicode: "{U+10C38}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "[Q]",
		tags: ["древнетюркская орхонская буква окх", "old turkic orkhon letter oq"],
	},
	"turkic_yenisei_oq", {
		unicode: "{U+10C39}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c* [Q]",
		tags: ["древнетюркская енисейская буква окх", "old turkic yenisei letter oq"],
	},
	"turkic_orkhon_oek", {
		unicode: "{U+10C1C}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [Q]",
		tags: ["древнетюркская орхонская буква ёкь", "old turkic orkhon letter oek"],
	},
	"turkic_yenisei_oek", {
		unicode: "{U+10C1D}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*>! [Q]",
		tags: ["древнетюркская енисейская буква ёкь", "old turkic yenisei letter oek"],
	},
	"turkic_orkhon_iq", {
		unicode: "{U+10C36}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<! [Q]",
		tags: ["древнетюркская орхонская буква ыкх", "old turkic orkhon letter iq"],
	},
	"turkic_yenisei_iq", {
		unicode: "{U+10C37}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*<!  [Q]",
		tags: ["древнетюркская енисейская буква ыкх", "old turkic yenisei letter iq"],
	},
	"turkic_orkhon_ic", {
		unicode: "{U+10C31}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: ">! [C]",
		tags: ["древнетюркская орхонская буква ичь", "old turkic orkhon letter ic"],
	},
	"turkic_orkhon_ash", {
		unicode: "{U+10C3F}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<! [A]",
		tags: ["древнетюркская орхонская буква аш", "old turkic orkhon letter ash"],
	},
	"turkic_yenisei_ash", {
		unicode: "{U+10C40}",
		titlesAlt: True,
		group: ["Old Turkic Yenisei"],
		alt_layout: "c*<! [A]",
		tags: ["древнетюркская енисейская буква аш", "old turkic yenisei letter ash"],
	},
	"turkic_orkhon_op", {
		unicode: "{U+10C30}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<! [P]",
		tags: ["древнетюркская орхонская буква оп", "old turkic orkhon letter op"],
	},
	"turkic_orkhon_ot", {
		unicode: "{U+10C47}",
		titlesAlt: True,
		group: ["Old Turkic Orkhon"],
		alt_layout: "<! [T]",
		tags: ["древнетюркская орхонская буква от", "old turkic orkhon letter ot"],
	},
	;
	"permic_an", {
		unicode: "{U+10350}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[A]",
		tags: ["древнепермская буква ан", "old permic letter an"],
	},
	"permic_bur", {
		unicode: "{U+10351}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Б]",
		tags: ["древнепермская буква бур", "old permic letter bur"],
	},
	"permic_gai", {
		unicode: "{U+10352}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Г]",
		tags: ["древнепермская буква гай", "old permic letter gai"],
	},
	"permic_doi", {
		unicode: "{U+10353}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Д]",
		tags: ["древнепермская буква дой", "old permic letter doi"],
	},
	"permic_e", {
		unicode: "{U+10354}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Е]",
		tags: ["древнепермская буква э", "old permic letter e"],
	},
	"permic_zhoi", {
		unicode: "{U+10355}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ж]",
		tags: ["древнепермская буква жой", "old permic letter zhoi"],
	},
	"permic_dzhoi", {
		unicode: "{U+10356}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: ">! [Ж]",
		tags: ["древнепермская буква джой", "old permic letter dzhoi"],
	},
	"permic_zata", {
		unicode: "{U+10357}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[З]",
		tags: ["древнепермская буква зата", "old permic letter zata"],
	},
	"permic_dzita", {
		unicode: "{U+10358}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: ">! [З]",
		tags: ["древнепермская буква дзита", "old permic letter dzita"],
	},
	"permic_i", {
		unicode: "{U+10359}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[И]",
		tags: ["древнепермская буква и", "old permic letter i"],
	},
	"permic_koke", {
		unicode: "{U+1035A}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[К]",
		tags: ["древнепермская буква кокэ", "old permic letter koke"],
	},
	"permic_lei", {
		unicode: "{U+1035B}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Л]",
		tags: ["древнепермская буква лэй", "old permic letter lei"],
	},
	"permic_menoe", {
		unicode: "{U+1035C}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[М]",
		tags: ["древнепермская буква мэно", "древнепермская буква мэнӧ", "old permic letter menoe"],
	},
	"permic_nenoe", {
		unicode: "{U+1035D}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Н]",
		tags: ["древнепермская буква нэно", "древнепермская буква нэнӧ", "old permic letter nenoe"],
	},
	"permic_vooi", {
		unicode: "{U+1035E}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[О]",
		tags: ["древнепермская буква вой", "древнепермская буква во̂й", "old permic letter vooi"],
	},
	"permic_peei", {
		unicode: "{U+1035F}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[П]",
		tags: ["древнепермская буква пэй", "древнепермская буква пэ̂й", "old permic letter peei"],
	},
	"permic_rei", {
		unicode: "{U+10360}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Р]",
		tags: ["древнепермская буква пэй", "old permic letter rei"],
	},
	"permic_sii", {
		unicode: "{U+10361}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[С]",
		tags: ["древнепермская буква сий", "old permic letter sii"],
	},
	"permic_tai", {
		unicode: "{U+10362}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Т]",
		tags: ["древнепермская буква тай", "old permic letter tai"],
	},
	"permic_u", {
		unicode: "{U+10363}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[У]",
		tags: ["древнепермская буква у", "old permic letter u"],
	},
	"permic_chery", {
		unicode: "{U+10364}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ч]",
		tags: ["древнепермская буква чэры", "old permic letter chery"],
	},
	"permic_shooi", {
		unicode: "{U+10365}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ш]",
		tags: ["древнепермская буква шой", "древнепермская буква шо̂й", "old permic letter shooi"],
	},
	"permic_shchooi", {
		unicode: "{U+10366}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Щ]",
		tags: ["древнепермская буква тшой", "древнепермская буква тшо̂й", "old permic letter shchooi"],
	},
	"permic_yery", {
		unicode: "{U+10368}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ы]",
		tags: ["древнепермская буква еры", "old permic letter yery"],
	},
	"permic_yry", {
		unicode: "{U+10367}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: ">! [Ы]",
		tags: ["древнепермская буква ыры", "old permic letter yry"],
	},
	"permic_o", {
		unicode: "{U+10369}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: ">! [О]",
		tags: ["древнепермская буква о", "old permic letter o"],
	},
	"permic_oo", {
		unicode: "{U+1036A}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ё]",
		tags: ["древнепермская буква оо", "old permic letter oo"],
	},
	"permic_ef", {
		unicode: "{U+1036B}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ф]",
		tags: ["древнепермская буква эф", "old permic letter ef"],
	},
	"permic_ha", {
		unicode: "{U+1036C}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Х]",
		tags: ["древнепермская буква ха", "old permic letter ha"],
	},
	"permic_tsiu", {
		unicode: "{U+1036D}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ц]",
		tags: ["древнепермская буква цю", "old permic letter tsiu"],
	},
	"permic_ver", {
		unicode: "{U+1036E}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[В]",
		tags: ["древнепермская буква вэр", "old permic letter ver"],
	},
	"permic_yeru", {
		unicode: "{U+1036F}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ъ]",
		tags: ["древнепермская буква ер", "old permic letter yeru"],
	},
	"permic_yeri", {
		unicode: "{U+10370}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ь]",
		tags: ["древнепермская буква ери", "old permic letter yeri"],
	},
	"permic_yat", {
		unicode: "{U+10371}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Э]",
		tags: ["древнепермская буква ять", "old permic letter yat"],
	},
	"permic_ie", {
		unicode: "{U+10372}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Й]",
		tags: ["древнепермская буква йэ", "old permic letter ie"],
	},
	"permic_yu", {
		unicode: "{U+10373}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Ю]",
		tags: ["древнепермская буква ю", "old permic letter yu"],
	},
	"permic_ia", {
		unicode: "{U+10375}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: "[Я]",
		tags: ["древнепермская буква йа", "old permic letter ia"],
	},
	"permic_ya", {
		unicode: "{U+10374}",
		titlesAlt: True,
		group: ["Old Permic"],
		alt_layout: ">! [Я]",
		tags: ["древнепермская буква я", "old permic letter ya"],
	},
	;
	;
	"hungarian_c_let_a", {
		unicode: "{U+10C80}",
		titlesAlt: True,
		group: ["Old Hungarian", "A"],
		tags: ["прописная руна А секельская", "capital rune A old hungarian"],
	},
	"hungarian_s_let_a", {
		unicode: "{U+10CC0}",
		titlesAlt: True,
		group: ["Old Hungarian", "a"],
		tags: ["строчная руна а секельская", "small rune a old hungarian"],
	},
	"hungarian_c_let_aa", {
		unicode: "{U+10C81}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [A]",
		tags: ["прописная руна Аа секельская", "capital rune Aa old hungarian"],
	},
	"hungarian_s_let_aa", {
		unicode: "{U+10CC1}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [a]",
		tags: ["строчная руна аа секельская", "small rune aa old hungarian"],
	},
	"hungarian_c_let_eb", {
		unicode: "{U+10C82}",
		titlesAlt: True,
		group: ["Old Hungarian", "B"],
		tags: ["прописная руна Эб секельская", "capital rune Eb old hungarian"],
	},
	"hungarian_s_let_eb", {
		unicode: "{U+10CC2}",
		titlesAlt: True,
		group: ["Old Hungarian", "b"],
		tags: ["строчная руна эб секельская", "small rune eb old hungarian"],
	},
	"hungarian_c_let_ec", {
		unicode: "{U+10C84}",
		titlesAlt: True,
		group: ["Old Hungarian", "C"],
		tags: ["прописная руна Эц секельская", "capital rune Ec old hungarian"],
	},
	"hungarian_s_let_ec", {
		unicode: "{U+10CC4}",
		titlesAlt: True,
		group: ["Old Hungarian", "c"],
		tags: ["строчная руна эц секельская", "small rune ec old hungarian"],
	},
	"hungarian_c_let_ecs", {
		unicode: "{U+10C86}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [C]",
		tags: ["прописная руна Эч секельская", "capital rune Ecs old hungarian"],
	},
	"hungarian_s_let_ecs", {
		unicode: "{U+10CC6}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [c]",
		tags: ["строчная руна эч секельская", "small rune ecs old hungarian"],
	},
	"hungarian_c_let_ed", {
		unicode: "{U+10C87}",
		titlesAlt: True,
		group: ["Old Hungarian", "D"],
		tags: ["прописная руна Эд секельская", "capital rune Ed old hungarian"],
	},
	"hungarian_s_let_ed", {
		unicode: "{U+10CC7}",
		titlesAlt: True,
		group: ["Old Hungarian", "d"],
		tags: ["строчная руна эд секельская", "small rune ed old hungarian"],
	},
	"hungarian_c_let_e", {
		unicode: "{U+10C89}",
		titlesAlt: True,
		group: ["Old Hungarian", "E"],
		tags: ["прописная руна Е секельская", "capital rune E old hungarian"],
	},
	"hungarian_s_let_e", {
		unicode: "{U+10CC9}",
		titlesAlt: True,
		group: ["Old Hungarian", "e"],
		tags: ["строчная руна е секельская", "small rune e old hungarian"],
	},
	"hungarian_c_let_ee", {
		unicode: "{U+10C8B}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [E]",
		tags: ["прописная руна Ее секельская", "capital rune Ee old hungarian"],
	},
	"hungarian_s_let_ee", {
		unicode: "{U+10CCB}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [e]",
		tags: ["строчная руна ее секельская", "small rune ee old hungarian"],
	},
	"hungarian_c_let_ef", {
		unicode: "{U+10C8C}",
		titlesAlt: True,
		group: ["Old Hungarian", "F"],
		tags: ["прописная руна Эф секельская", "capital rune Ef old hungarian"],
	},
	"hungarian_s_let_ef", {
		unicode: "{U+10CCC}",
		titlesAlt: True,
		group: ["Old Hungarian", "f"],
		tags: ["строчная руна эф секельская", "small rune ef old hungarian"],
	},
	"hungarian_c_let_eg", {
		unicode: "{U+10C8D}",
		titlesAlt: True,
		group: ["Old Hungarian", "G"],
		tags: ["прописная руна Эг секельская", "capital rune Eg old hungarian"],
	},
	"hungarian_s_let_eg", {
		unicode: "{U+10CCD}",
		titlesAlt: True,
		group: ["Old Hungarian", "g"],
		tags: ["строчная руна эг секельская", "small rune eg old hungarian"],
	},
	"hungarian_c_let_egy", {
		unicode: "{U+10C8E}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [G]",
		tags: ["прописная руна Эгй секельская", "capital rune Egy old hungarian"],
	},
	"hungarian_s_let_egy", {
		unicode: "{U+10CCE}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [g]",
		tags: ["строчная руна эгй секельская", "small rune egy old hungarian"],
	},
	"hungarian_c_let_eh", {
		unicode: "{U+10C8F}",
		titlesAlt: True,
		group: ["Old Hungarian", "H"],
		tags: ["прописная руна Эх секельская", "capital rune Eh old hungarian"],
	},
	"hungarian_s_let_eh", {
		unicode: "{U+10CCF}",
		titlesAlt: True,
		group: ["Old Hungarian", "h"],
		tags: ["строчная руна эх секельская", "small rune eh old hungarian"],
	},
	"hungarian_c_let_i", {
		unicode: "{U+10C90}",
		titlesAlt: True,
		group: ["Old Hungarian", "I"],
		tags: ["прописная руна и секельская", "capital rune I old hungarian"],
	},
	"hungarian_s_let_i", {
		unicode: "{U+10CD0}",
		titlesAlt: True,
		group: ["Old Hungarian", "i"],
		tags: ["строчная руна и секельская", "small rune i old hungarian"],
	},
	"hungarian_c_let_ii", {
		unicode: "{U+10C91}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [I]",
		tags: ["прописная руна Ии секельская", "capital rune Ii old hungarian"],
	},
	"hungarian_s_let_ii", {
		unicode: "{U+10CD1}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [i]",
		tags: ["строчная руна ии секельская", "small rune ii old hungarian"],
	},
	"hungarian_c_let_ej", {
		unicode: "{U+10C92}",
		titlesAlt: True,
		group: ["Old Hungarian", "J"],
		tags: ["прописная руна Эј секельская", "capital rune Ej old hungarian"],
	},
	"hungarian_s_let_ej", {
		unicode: "{U+10CD2}",
		titlesAlt: True,
		group: ["Old Hungarian", "j"],
		tags: ["строчная руна эј секельская", "small rune ej old hungarian"],
	},
	"hungarian_c_let_ek", {
		unicode: "{U+10C93}",
		titlesAlt: True,
		group: ["Old Hungarian", "K"],
		tags: ["прописная руна Эк секельская", "capital rune Ek old hungarian"],
	},
	"hungarian_s_let_ek", {
		unicode: "{U+10CD3}",
		titlesAlt: True,
		group: ["Old Hungarian", "k"],
		tags: ["строчная руна эк секельская", "small rune ek old hungarian"],
	},
	"hungarian_c_let_ak", {
		unicode: "{U+10C94}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [K]",
		tags: ["прописная руна Ак секельская", "capital rune Ak old hungarian"],
	},
	"hungarian_s_let_ak", {
		unicode: "{U+10CD4}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [k]",
		tags: ["строчная руна ак секельская", "small rune ak old hungarian"],
	},
	"hungarian_c_let_el", {
		unicode: "{U+10C96}",
		titlesAlt: True,
		group: ["Old Hungarian", "L"],
		tags: ["прописная руна Эл секельская", "capital rune El old hungarian"],
	},
	"hungarian_s_let_el", {
		unicode: "{U+10CD6}",
		titlesAlt: True,
		group: ["Old Hungarian", "l"],
		tags: ["строчная руна эл секельская", "small rune el old hungarian"],
	},
	"hungarian_c_let_ely", {
		unicode: "{U+10C97}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [L]",
		tags: ["прописная руна Элй секельская", "capital rune Ely old hungarian"],
	},
	"hungarian_s_let_ely", {
		unicode: "{U+10CD7}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [l]",
		tags: ["строчная руна элй секельская", "small rune ely old hungarian"],
	},
	"hungarian_c_let_em", {
		unicode: "{U+10C98}",
		titlesAlt: True,
		group: ["Old Hungarian", "M"],
		tags: ["прописная руна Эм секельская", "capital rune Em old hungarian"],
	},
	"hungarian_s_let_em", {
		unicode: "{U+10CD8}",
		titlesAlt: True,
		group: ["Old Hungarian", "m"],
		tags: ["строчная руна эм секельская", "small rune em old hungarian"],
	},
	"hungarian_c_let_en", {
		unicode: "{U+10C99}",
		titlesAlt: True,
		group: ["Old Hungarian", "N"],
		tags: ["прописная руна Эн секельская", "capital rune En old hungarian"],
	},
	"hungarian_s_let_en", {
		unicode: "{U+10CD9}",
		titlesAlt: True,
		group: ["Old Hungarian", "n"],
		tags: ["строчная руна эн секельская", "small rune en old hungarian"],
	},
	"hungarian_c_let_eny", {
		unicode: "{U+10C9A}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [N]",
		tags: ["прописная руна Энй секельская", "capital rune Eny old hungarian"],
	},
	"hungarian_s_let_eny", {
		unicode: "{U+10CDA}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [n]",
		tags: ["строчная руна энй секельская", "small rune eny old hungarian"],
	},
	"hungarian_c_let_o", {
		unicode: "{U+10C9B}",
		titlesAlt: True,
		group: ["Old Hungarian", "O"],
		tags: ["прописная руна О секельская", "capital rune O old hungarian"],
	},
	"hungarian_s_let_o", {
		unicode: "{U+10CD9}",
		titlesAlt: True,
		group: ["Old Hungarian", "o"],
		tags: ["строчная руна о секельская", "small rune o old hungarian"],
	},
	"hungarian_c_let_oo", {
		unicode: "{U+10C9C}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [O]",
		tags: ["прописная руна Оо секельская", "capital rune Oo old hungarian"],
	},
	"hungarian_s_let_oo", {
		unicode: "{U+10CDC}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [o]",
		tags: ["строчная руна оо секельская", "small rune oo old hungarian"],
	},
	"hungarian_c_let_oe", {
		unicode: "{U+10C9E}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [O]",
		tags: ["прописная руна рудиментарная Ое секельская", "capital rune rudimentar Oe old hungarian"],
	},
	"hungarian_s_let_oe", {
		unicode: "{U+10CDE}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [o]",
		tags: ["строчная руна рудиментарная ое секельская", "small rune rudimentar oe old hungarian"],
	},
	"hungarian_c_let_oe_nik", {
		unicode: "{U+10C9D}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">!<+ [O]",
		tags: ["прописная руна никольсбургская Ое секельская", "capital rune nikolsburg Oe old hungarian"],
	},
	"hungarian_s_let_oe_nik", {
		unicode: "{U+10CDD}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">!<+ [o]",
		tags: ["строчная руна никольсбургская ое секельская", "small rune nikolsburg oe old hungarian"],
	},
	"hungarian_c_let_oee", {
		unicode: "{U+10C9F}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">+ [O]",
		tags: ["прописная руна Оее секельская", "capital rune Oee old hungarian"],
	},
	"hungarian_s_let_oee", {
		unicode: "{U+10CDF}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">+ [o]",
		tags: ["строчная руна оее секельская", "small rune oee old hungarian"],
	},
	"hungarian_c_let_ep", {
		unicode: "{U+10CA0}",
		titlesAlt: True,
		group: ["Old Hungarian", "P"],
		tags: ["прописная руна Эп секельская", "capital rune Ep old hungarian"],
	},
	"hungarian_s_let_ep", {
		unicode: "{U+10CE0}",
		titlesAlt: True,
		group: ["Old Hungarian", "p"],
		tags: ["строчная руна эп секельская", "small rune ep old hungarian"],
	},
	"hungarian_c_let_er", {
		unicode: "{U+10CA2}",
		titlesAlt: True,
		group: ["Old Hungarian", "R"],
		tags: ["прописная руна Эр секельская", "capital rune Er old hungarian"],
	},
	"hungarian_s_let_er", {
		unicode: "{U+10CE2}",
		titlesAlt: True,
		group: ["Old Hungarian", "r"],
		tags: ["строчная руна эр секельская", "small rune er old hungarian"],
	},
	"hungarian_c_let_short_er", {
		unicode: "{U+10CA3}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [R]",
		tags: ["прописная руна короткая Эр секельская", "capital rune short Er old hungarian"],
	},
	"hungarian_s_let_short_er", {
		unicode: "{U+10CE3}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [r]",
		tags: ["строчная руна короткая эр секельская", "small rune short er old hungarian"],
	},
	"hungarian_c_let_es", {
		unicode: "{U+10CA4}",
		titlesAlt: True,
		group: ["Old Hungarian", "S"],
		tags: ["прописная руна Эщ секельская", "capital rune Es old hungarian"],
	},
	"hungarian_s_let_es", {
		unicode: "{U+10CE4}",
		titlesAlt: True,
		group: ["Old Hungarian", "s"],
		tags: ["строчная руна эщ секельская", "small rune es old hungarian"],
	},
	"hungarian_c_let_esz", {
		unicode: "{U+10CA5}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [S]",
		tags: ["прописная руна Эс секельская", "capital rune Esz old hungarian"],
	},
	"hungarian_s_let_esz", {
		unicode: "{U+10CE5}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [s]",
		tags: ["строчная руна эс секельская", "small rune esz old hungarian"],
	},
	"hungarian_c_let_et", {
		unicode: "{U+10CA6}",
		titlesAlt: True,
		group: ["Old Hungarian", "T"],
		tags: ["прописная руна Эт секельская", "capital rune Et old hungarian"],
	},
	"hungarian_s_let_et", {
		unicode: "{U+10CE6}",
		titlesAlt: True,
		group: ["Old Hungarian", "t"],
		tags: ["строчная руна эт секельская", "small rune et old hungarian"],
	},
	"hungarian_c_let_ety", {
		unicode: "{U+10CA8}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [T]",
		tags: ["прописная руна Этй секельская", "capital rune Ety old hungarian"],
	},
	"hungarian_s_let_ety", {
		unicode: "{U+10CE8}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [t]",
		tags: ["строчная руна этй секельская", "small rune ety old hungarian"],
	},
	"hungarian_c_let_u", {
		unicode: "{U+10CAA}",
		titlesAlt: True,
		group: ["Old Hungarian", "U"],
		tags: ["прописная руна У секельская", "capital rune U old hungarian"],
	},
	"hungarian_s_let_u", {
		unicode: "{U+10CEA}",
		titlesAlt: True,
		group: ["Old Hungarian", "u"],
		tags: ["строчная руна у секельская", "small rune u old hungarian"],
	},
	"hungarian_c_let_uu", {
		unicode: "{U+10CAB}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [U]",
		tags: ["прописная руна Уу секельская", "capital rune Uu old hungarian"],
	},
	"hungarian_s_let_uu", {
		unicode: "{U+10CEB}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [u]",
		tags: ["строчная руна уу секельская", "small rune uu old hungarian"],
	},
	"hungarian_c_let_ue", {
		unicode: "{U+10CAD}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[Y]",
		tags: ["прописная руна рудиментарная Уе секельская", "capital rune rudimentar Ue old hungarian"],
	},
	"hungarian_s_let_ue", {
		unicode: "{U+10CED}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[y]",
		tags: ["строчная руна рудиментарная Уе секельская", "small rune rudimentar ue old hungarian"],
	},
	"hungarian_c_let_ue_nik", {
		unicode: "{U+10CAC}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [Y]",
		tags: ["прописная руна никольсбургская Уе секельская", "capital rune nikolsburg Ue old hungarian"],
	},
	"hungarian_s_let_ue_nik", {
		unicode: "{U+10CEC}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [y]",
		tags: ["строчная руна никольсбургская Уе секельская", "small rune nikolsburg ue old hungarian"],
	},
	"hungarian_c_let_ev", {
		unicode: "{U+10CAE}",
		titlesAlt: True,
		group: ["Old Hungarian", "V"],
		tags: ["прописная руна Эв секельская", "capital rune Ev old hungarian"],
	},
	"hungarian_s_let_ev", {
		unicode: "{U+10CEE}",
		titlesAlt: True,
		group: ["Old Hungarian", "v"],
		tags: ["строчная руна эв секельская", "small rune ev old hungarian"],
	},
	"hungarian_c_let_ez", {
		unicode: "{U+10CAF}",
		titlesAlt: True,
		group: ["Old Hungarian", "Z"],
		tags: ["прописная руна Эз секельская", "capital rune Ez old hungarian"],
	},
	"hungarian_s_let_ez", {
		unicode: "{U+10CEF}",
		titlesAlt: True,
		group: ["Old Hungarian", "z"],
		tags: ["строчная руна эз секельская", "small rune ez old hungarian"],
	},
	"hungarian_c_let_ezs", {
		unicode: "{U+10CB0}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [Z]",
		tags: ["прописная руна Эж секельская", "capital rune Ezs old hungarian"],
	},
	"hungarian_s_let_ezs", {
		unicode: "{U+10CF0}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">! [z]",
		tags: ["строчная руна эж секельская", "small rune ezs old hungarian"],
	},
	"hungarian_c_let_ent", {
		unicode: "{U+10CA7}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [T]",
		tags: ["прописная руна Энт секельская", "capital rune Ent old hungarian"],
	},
	"hungarian_s_let_ent", {
		unicode: "{U+10CE7}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [t]",
		tags: ["строчная руна энт секельская", "small rune ent old hungarian"],
	},
	"hungarian_c_let_ent_shaped", {
		unicode: "{U+10CB1}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">+ [T]",
		tags: ["прописная руна Энт-подобный знак секельский", "capital rune Ent-shaped sign old hungarian"],
	},
	"hungarian_s_let_ent_shaped", {
		unicode: "{U+10CF1}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: ">+ [t]",
		tags: ["строчная руна энт-подобный знак секельский", "small rune ent-shaped sign old hungarian"],
	},
	"hungarian_c_let_emp", {
		unicode: "{U+10CA1}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [P]",
		tags: ["прописная руна Эмп секельская", "capital rune Emp old hungarian"],
	},
	"hungarian_s_let_emp", {
		unicode: "{U+10CE1}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [p]",
		tags: ["строчная руна эмп секельская", "small rune emp old hungarian"],
	},
	"hungarian_c_let_unk", {
		unicode: "{U+10C95}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [K]",
		tags: ["прописная руна Унк секельская", "capital rune Unk old hungarian"],
	},
	"hungarian_s_let_unk", {
		unicode: "{U+10CD5}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [k]",
		tags: ["строчная руна унк секельская", "small rune unk old hungarian"],
	},
	"hungarian_c_let_us", {
		unicode: "{U+10CB2}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [S]",
		tags: ["прописная руна Ус секельская", "capital rune Us old hungarian"],
	},
	"hungarian_s_let_us", {
		unicode: "{U+10CF2}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [s]",
		tags: ["строчная руна ус секельская", "small rune us old hungarian"],
	},
	"hungarian_c_let_amb", {
		unicode: "{U+10C83}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [B]",
		tags: ["прописная руна Амб секельская", "capital rune Amb old hungarian"],
	},
	"hungarian_s_let_amb", {
		unicode: "{U+10CC3}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [b]",
		tags: ["строчная руна амб секельская", "small rune amb old hungarian"],
	},
	"hungarian_c_let_enk", {
		unicode: "{U+10C85}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [E]",
		tags: ["прописная руна Энк секельская", "capital rune Enk old hungarian"],
	},
	"hungarian_s_let_enk", {
		unicode: "{U+10CC5}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [e]",
		tags: ["строчная руна энк секельская", "small rune enk old hungarian"],
	},
	"hungarian_c_let_ech", {
		unicode: "{U+10CA9}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [C]",
		tags: ["прописная руна Эч секельская", "capital rune Ech old hungarian"],
	},
	"hungarian_s_let_ech", {
		unicode: "{U+10CE9}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "<+ [c]",
		tags: ["строчная руна эч секельская", "small rune ech old hungarian"],
	},
	"hungarian_num_one", {
		unicode: "{U+10CFA}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[1]",
		tags: ["цифра 1 секельская", "number 1 hungarian"],
	},
	"hungarian_num_five", {
		unicode: "{U+10CFB}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[2]",
		tags: ["цифра 5 секельская", "number 5 hungarian"],
	},
	"hungarian_num_ten", {
		unicode: "{U+10CFC}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[3]",
		tags: ["цифра 10 секельская", "number 10 hungarian"],
	},
	"hungarian_num_fifty", {
		unicode: "{U+10CFD}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[4]",
		tags: ["цифра 50 секельская", "number 50 hungarian"],
	},
	"hungarian_num_one_hundred", {
		unicode: "{U+10CFE}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[5]",
		tags: ["цифра 100 секельская", "number 100 hungarian"],
	},
	"hungarian_num_one_thousand", {
		unicode: "{U+10CFF}",
		titlesAlt: True,
		group: ["Old Hungarian"],
		alt_layout: "[6]",
		tags: ["цифра 1000 секельская", "number 1000 hungarian"],
	},
	;
	;
	"gothic_ahza", {
		unicode: "{U+10330}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[A]",
		tags: ["готская буква аза", "gothic letter ahsa"],
	},
	"gothic_bairkan", {
		unicode: "{U+10331}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[B]",
		tags: ["готская буква беркна", "gothic letter bairkan", "gothic letter baírkan"],
	},
	"gothic_giba", {
		unicode: "{U+10332}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[G]",
		tags: ["готская буква гиба", "gothic letter giba"],
	},
	"gothic_dags", {
		unicode: "{U+10333}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[D]",
		tags: ["готская буква дааз", "gothic letter dags"],
	},
	"gothic_aihvus", {
		unicode: "{U+10334}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[E]",
		tags: ["готская буква эзй", "gothic letter aihvus", "gothic letter eíƕs"],
	},
	"gothic_qairthra", {
		unicode: "{U+10335}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[Q]",
		tags: ["готская буква квертра", "gothic letter qairthra", "gothic letter qaírþra"],
	},
	"gothic_ezek", {
		unicode: "{U+10336}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[Z]",
		tags: ["готская буква эзек", "gothic letter ezek"],
	},
	"gothic_hagl", {
		unicode: "{U+10337}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[H]",
		tags: ["готская буква хаал", "gothic letter hagl"],
	},
	"gothic_thiuth", {
		unicode: "{U+10338}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: ">! [T], [C]",
		tags: ["готская буква сюс", "gothic letter thiuth", "gothic letter þiuþ"],
	},
	"gothic_eis", {
		unicode: "{U+10339}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[I]",
		tags: ["готская буква ииз", "gothic letter eis"],
	},
	"gothic_kusma", {
		unicode: "{U+1033A}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[K]",
		tags: ["готская буква козма", "gothic letter kusma"],
	},
	"gothic_lagus", {
		unicode: "{U+1033B}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[L]",
		tags: ["готская буква лааз", "gothic letter lagus"],
	},
	"gothic_manna", {
		unicode: "{U+1033C}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[M]",
		tags: ["готская буква манна", "gothic letter manna"],
	},
	"gothic_nauths", {
		unicode: "{U+1033D}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[N]",
		tags: ["готская буква нойкз", "gothic letter nauths", "gothic letter nauþs"],
	},
	"gothic_jer", {
		unicode: "{U+1033E}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[J]",
		tags: ["готская буква гаар", "gothic letter jer", "gothic letter jēr"],
	},
	"gothic_urus", {
		unicode: "{U+1033F}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[U]",
		tags: ["готская буква ураз", "gothic letter urus", "gothic letter ūrus"],
	},
	"gothic_pairthra", {
		unicode: "{U+10340}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[P]",
		tags: ["готская буква пертра", "gothic letter pairthra", "gothic letter ūrus"],
	},
	"gothic_ninety", {
		unicode: "{U+10341}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: ">! [P]",
		tags: ["готская буква-число 90", "gothic letter ninety"],
	},
	"gothic_raida", {
		unicode: "{U+10342}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[R]",
		tags: ["готская буква райда", "gothic letter raida"],
	},
	"gothic_sugil", {
		unicode: "{U+10343}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[S]",
		tags: ["готская буква сугил", "gothic letter sugil"],
	},
	"gothic_teiws", {
		unicode: "{U+10344}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[T]",
		tags: ["готская буква тюз", "gothic letter teiws"],
	},
	"gothic_winja", {
		unicode: "{U+10345}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[W], [Y]",
		tags: ["готская буква винья", "gothic letter winja"],
	},
	"gothic_faihu", {
		unicode: "{U+10346}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[F]",
		tags: ["готская буква файху", "gothic letter faihu"],
	},
	"gothic_iggws", {
		unicode: "{U+10347}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[X]",
		tags: ["готская буква энкуз", "gothic letter iggws"],
	},
	"gothic_hwair", {
		unicode: "{U+10348}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: ">! [H], [V]",
		tags: ["готская буква хвайр", "gothic letter hwair", "gothic letter ƕaír"],
	},
	"gothic_othal", {
		unicode: "{U+10349}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: "[O]",
		tags: ["готская буква отал", "gothic letter othal", "gothic letter ōþal"],
	},
	"gothic_nine_hundred", {
		unicode: "{U+1034A}",
		titlesAlt: True,
		group: ["Gothic Alphabet"],
		alt_layout: ">! [S]",
		tags: ["готская буква-число 900", "gothic letter nine hundred"],
	},
	;
	;
	; * Wallet Signs
	"wallet_sign", {
		unicode: "{U+00A4}",
		group: ["Wallet Signs"],
		tags: ["знак валюты", "currency sign"],
		recipe: ["XO"],
	},
	"wallet_austral", {
		unicode: "{U+20B3}",
		group: ["Wallet Signs"],
		tags: ["аустраль", "austral"],
		recipe: ["A=", "ARA"],
	},
	"wallet_dollar", {
		unicode: "{U+0024}",
		group: ["Wallet Signs"],
		tags: ["доллар", "dollar"],
		recipe: ["S|", "USD", "DLR"],
	},
	"wallet_cent", {
		unicode: "{U+00A2}",
		group: ["Wallet Signs"],
		tags: ["цент", "cent"],
		recipe: ["c|", "CNT"],
	},
	"wallet_pound", {
		unicode: "{U+00A3}",
		group: ["Wallet Signs"],
		tags: ["фунт", "pound"],
		recipe: ["f_", "GBP"],
	},
	"wallet_eur", {
		unicode: "{U+20AC}",
		group: ["Wallet Signs"],
		tags: ["евро", "euro"],
		recipe: ["C=", "EUR"],
	},
	"wallet_franc", {
		unicode: "{U+20A3}",
		group: ["Wallet Signs"],
		tags: ["франк", "franc"],
		recipe: ["F=", "FRF"],
	},
	"wallet_tournois", {
		unicode: "{U+20B6}",
		group: ["Wallet Signs"],
		tags: ["турский ливр", "tournois"],
		recipe: ["lt", "LTF"],
	},
	"wallet_rub", {
		unicode: "{U+20BD}",
		group: ["Wallet Signs"],
		tags: ["рубль", "ruble"],
		recipe: ["Р=", "RUB", "РУБ"],
	},
	"wallet_hryvnia", {
		unicode: "{U+20B4}",
		group: ["Wallet Signs"],
		tags: ["гривна", "hryvnia"],
		recipe: ["S=", "UAH", "ГРН"],
	},
	"wallet_lira", {
		unicode: "{U+20A4}",
		group: ["Wallet Signs"],
		tags: ["лира", "lira"],
		recipe: ["f=", "LIR"],
	},
	"wallet_turkish_lira", {
		unicode: "{U+20BA}",
		group: ["Wallet Signs"],
		tags: ["лира", "lira"],
		recipe: ["L=", "TRY"],
	},
	"wallet_rupee", {
		unicode: "{U+20B9}",
		group: ["Wallet Signs"],
		tags: ["рупия", "rupee"],
		recipe: ["R=", "INR", "RUP"],
	},
	"wallet_won", {
		unicode: "{U+20A9}",
		group: ["Wallet Signs"],
		tags: ["вон", "won"],
		recipe: ["W=", "WON", "KRW"],
	},
	"wallet_yen", {
		unicode: "{U+00A5}",
		group: ["Wallet Signs"],
		tags: ["знак йены", "yen sign"],
		recipe: ["Y=", "YEN"],
	},
	"wallet_jpy_yen", {
		unicode: "{U+5186}",
		group: ["Wallet Signs"],
		tags: ["йена", "yen"],
		recipe: ["JPY"],
	},
	"wallet_cny_yuan", {
		unicode: "{U+5143}",
		group: ["Wallet Signs"],
		tags: ["юань", "yuan"],
		recipe: ["CNY"],
	},
	"wallet_viet_dong", {
		unicode: "{U+20AB}",
		group: ["Wallet Signs"],
		tags: ["вьетнамский донг", "vietnamese dong"],
		recipe: ["VND", "DNG"],
	},
	"wallet_mongol_tugrik", {
		unicode: "{U+20AE}",
		group: ["Wallet Signs"],
		tags: ["монгольский тугрик", "mongolian tugrik"],
		recipe: ["T//", "MNT", "TGK"],
	},
	"wallet_qazaq_tenge", {
		unicode: "{U+20B8}",
		group: ["Wallet Signs"],
		tags: ["казахский тенге", "kazakh tenge"],
		recipe: ["T=", "KZT", "TNG"],
	},
	"wallet_new_sheqel", {
		unicode: "{U+20AA}",
		group: ["Wallet Signs"],
		tags: ["новый шекель", "new sheqel"],
		recipe: ["NZD", "SHQ"],
	},
	"wallet_philippine_peso", {
		unicode: "{U+20B1}",
		group: ["Wallet Signs"],
		tags: ["филиппинский песо", "philippine peso"],
		recipe: ["P=", "PHP"],
	},
	"wallet_roman_denarius", {
		unicode: "{U+10196}",
		group: ["Wallet Signs"],
		tags: ["римский денарий", "roman denarius"],
		recipe: ["X-", "DIN"],
	},
	"wallet_bitcoin", {
		unicode: "{U+20BF}",
		group: ["Wallet Signs"],
		tags: ["биткоин", "bitcoin"],
		recipe: ["B||", "BTC"],
	},
	;
	"copyright", {
		unicode: "{U+00A9}",
		group: ["Other Signs", "2"],
		show_on_fast_keys: True,
		tags: ["копирайт", "copyright"],
		recipe: ["copy", "cri"],
	},
	"copyleft", {
		unicode: "{U+1F12F}",
		group: ["Other Signs"],
		tags: ["копилефт", "copyleft"],
		recipe: "cft",
	},
	"registered", {
		unicode: "{U+00AE}",
		group: ["Other Signs", "2"],
		modifier: CapsLock,
		show_on_fast_keys: True,
		tags: ["зарегистрированный", "registered"],
		recipe: "reg",
	},
	"trademark", {
		unicode: "{U+2122}",
		group: ["Other Signs", "2"],
		modifier: LeftShift,
		show_on_fast_keys: True,
		tags: ["торговый знак", "trademark"],
		recipe: ["TM", "tm"],
	},
	"servicemark", {
		unicode: "{U+2120}",
		group: ["Other Signs", "2"],
		modifier: CapsLock LeftShift,
		show_on_fast_keys: True,
		tags: ["знак обслуживания", "servicemark"],
		recipe: ["SM", "sm"],
	},
	"sound_recording_copyright", {
		unicode: "{U+2117}",
		group: ["Other Signs", "2"],
		show_on_fast_keys: True,
		modifier: RightShift,
		tags: ["копирайт фонограммы", "sound recording copyright"],
		recipe: ["Pcopy"],
	},
)


MapInsert(Characters,
	"lat_c_let_a", { group: ["Default Letters"], calcOff: "", unicode: "{U+0041}", modifierForm: "{U+1D2C}",
		italicForm: "{U+1D434}", italicBoldForm: "{U+1D468}", boldForm: "{U+1D400}",
		frakturForm: "{U+1D504}", frakturBoldForm: "{U+1D56C}",
		scriptForm: "{U+1D49C}", scriptBoldForm: "{U+1D4D0}",
		doubleStruckForm: "{U+1D538}",
		sansSerifForm: "{U+1D5A0}", sansSerifItalicForm: "{U+1D608}", sansSerifItalicBoldForm: "{U+1D63C}", sansSerifBoldForm: "{U+1D5D4}",
		monospaceForm: "{U+1D670}" },
	"lat_s_let_a", { calcOff: "", unicode: "{U+0061}", combiningForm: "{U+0363}", modifierForm: "{U+1D43}", subscriptForm: "{U+2090}",
		italicForm: "{U+1D44E}", italicBoldForm: "{U+1D482}", boldForm: "{U+1D41A}",
		frakturForm: "{U+1D51E}", frakturBoldForm: "{U+1D586}",
		scriptForm: "{U+1D4B6}", scriptBoldForm: "{U+1D4EA}",
		doubleStruckForm: "{U+1D552}",
		sansSerifForm: "{U+1D5BA}", sansSerifItalicForm: "{U+1D622}", sansSerifItalicBoldForm: "{U+1D656}", sansSerifBoldForm: "{U+1D5EE}",
		monospaceForm: "{U+1D68A}" },
	"lat_c_let_b", { calcOff: "", unicode: "{U+0042}", modifierForm: "{U+1D2E}",
		italicForm: "{U+1D435}", italicBoldForm: "{U+1D469}", boldForm: "{U+1D401}",
		frakturForm: "{U+1D505}", frakturBoldForm: "{U+1D56D}",
		scriptForm: "{U+212C}", scriptBoldForm: "{U+1D4D1}",
		doubleStruckForm: "{U+1D539}",
		sansSerifForm: "{U+1D5A1}", sansSerifItalicForm: "{U+1D609}", sansSerifItalicBoldForm: "{U+1D63D}", sansSerifBoldForm: "{U+1D5D5}",
		monospaceForm: "{U+1D671}" },
	"lat_s_let_b", { calcOff: "", unicode: "{U+0062}", combiningForm: "{U+1DE8}", modifierForm: "{U+1D47}",
		italicForm: "{U+1D44F}", italicBoldForm: "{U+1D483}", boldForm: "{U+1D41B}",
		frakturForm: "{U+1D51F}", frakturBoldForm: "{U+1D587}",
		scriptForm: "{U+1D4B7}", scriptBoldForm: "{U+1D4EB}",
		doubleStruckForm: "{U+1D553}",
		sansSerifForm: "{U+1D5BB}", sansSerifItalicForm: "{U+1D623}", sansSerifItalicBoldForm: "{U+1D657}", sansSerifBoldForm: "{U+1D5EF}",
		monospaceForm: "{U+1D68B}" },
	"lat_c_let_c", { calcOff: "", unicode: "{U+0043}", modifierForm: "{U+A7F2}",
		italicForm: "{U+1D436}", italicBoldForm: "{U+1D46A}", boldForm: "{U+1D402}",
		frakturForm: "{U+212D}", frakturBoldForm: "{U+1D56E}",
		scriptForm: "{U+1D49E}", scriptBoldForm: "{U+1D4D2}",
		doubleStruckForm: "{U+2102}",
		sansSerifForm: "{U+1D5A2}", sansSerifItalicForm: "{U+1D60A}", sansSerifItalicBoldForm: "{U+1D63E}", sansSerifBoldForm: "{U+1D5D6}",
		monospaceForm: "{U+1D672}" },
	"lat_s_let_c", { calcOff: "", unicode: "{U+0063}", combiningForm: "{U+0368}", modifierForm: "{U+1D9C}",
		italicForm: "{U+1D450}", italicBoldForm: "{U+1D484}", boldForm: "{U+1D41C}",
		frakturForm: "{U+1D520}", frakturBoldForm: "{U+1D588}",
		scriptForm: "{U+1D4B8}", scriptBoldForm: "{U+1D4EC}",
		doubleStruckForm: "{U+1D554}",
		sansSerifForm: "{U+1D5BC}", sansSerifItalicForm: "{U+1D624}", sansSerifItalicBoldForm: "{U+1D658}", sansSerifBoldForm: "{U+1D5F0}",
		monospaceForm: "{U+1D68C}" },
	"lat_c_let_d", { calcOff: "", unicode: "{U+0044}", modifierForm: "{U+1D30}",
		italicForm: "{U+1D437}", italicBoldForm: "{U+1D46B}", boldForm: "{U+1D403}",
		frakturForm: "{U+1D507}", frakturBoldForm: "{U+1D56F}",
		scriptForm: "{U+1D49F}", scriptBoldForm: "{U+1D4D3}",
		doubleStruckForm: "{U+1D53B}", doubleStruckItalicForm: "{U+2145}",
		sansSerifForm: "{U+1D5A3}", sansSerifItalicForm: "{U+1D60B}", sansSerifItalicBoldForm: "{U+1D63F}", sansSerifBoldForm: "{U+1D5D7}",
		monospaceForm: "{U+1D673}" },
	"lat_s_let_d", { calcOff: "", unicode: "{U+0064}", combiningForm: "{U+0369}", modifierForm: "{U+1D48}",
		italicForm: "{U+1D451}", italicBoldForm: "{U+1D485}", boldForm: "{U+1D41D}",
		frakturForm: "{U+1D521}", frakturBoldForm: "{U+1D589}",
		scriptForm: "{U+1D4B9}", scriptBoldForm: "{U+1D4ED}",
		doubleStruckForm: "{U+1D555}", doubleStruckItalicForm: "{U+2146}",
		sansSerifForm: "{U+1D5BD}", sansSerifItalicForm: "{U+1D625}", sansSerifItalicBoldForm: "{U+1D659}", sansSerifBoldForm: "{U+1D5F1}",
		monospaceForm: "{U+1D68D}" },
	"lat_c_let_e", { calcOff: "", unicode: "{U+0045}", modifierForm: "{U+1D31}",
		italicForm: "{U+1D438}", italicBoldForm: "{U+1D46C}", boldForm: "{U+1D404}",
		frakturForm: "{U+1D508}", frakturBoldForm: "{U+1D570}",
		scriptForm: "{U+2130}", scriptBoldForm: "{U+1D4D4}",
		doubleStruckForm: "{U+1D53C}",
		sansSerifForm: "{U+1D5A4}", sansSerifItalicForm: "{U+1D60C}", sansSerifItalicBoldForm: "{U+1D640}", sansSerifBoldForm: "{U+1D5D8}",
		monospaceForm: "{U+1D674}" },
	"lat_s_let_e", { calcOff: "", unicode: "{U+0065}", combiningForm: "{U+0364}", modifierForm: "{U+1D49}", subscriptForm: "{U+2091}",
		italicForm: "{U+1D452}", italicBoldForm: "{U+1D486}", boldForm: "{U+1D41E}",
		frakturForm: "{U+1D522}", frakturBoldForm: "{U+1D58A}",
		scriptForm: "{U+212F}", scriptBoldForm: "{U+1D4EE}",
		doubleStruckForm: "{U+1D556}", doubleStruckItalicForm: "{U+2147}",
		sansSerifForm: "{U+1D5BE}", sansSerifItalicForm: "{U+1D626}", sansSerifItalicBoldForm: "{U+1D65A}", sansSerifBoldForm: "{U+1D5F2}",
		monospaceForm: "{U+1D68E}" },
	"lat_c_let_f", { calcOff: "", unicode: "{U+0046}", modifierForm: "{U+A7F3}",
		italicForm: "{U+1D439}", italicBoldForm: "{U+1D46D}", boldForm: "{U+1D405}",
		frakturForm: "{U+1D509}", frakturBoldForm: "{U+1D571}",
		scriptForm: "{U+2131}", scriptBoldForm: "{U+1D4D5}",
		doubleStruckForm: "{U+1D53D}",
		sansSerifForm: "{U+1D5A5}", sansSerifItalicForm: "{U+1D60D}", sansSerifItalicBoldForm: "{U+1D641}", sansSerifBoldForm: "{U+1D5D9}",
		monospaceForm: "{U+1D675}" },
	"lat_s_let_f", { calcOff: "", unicode: "{U+0066}", combiningForm: "{U+1DEB}", modifierForm: "{U+1DA0}",
		italicForm: "{U+1D453}", italicBoldForm: "{U+1D487}", boldForm: "{U+1D41F}",
		frakturForm: "{U+1D523}", frakturBoldForm: "{U+1D58B}",
		scriptForm: "{U+1D4BB}", scriptBoldForm: "{U+1D4EF}",
		doubleStruckForm: "{U+1D557}",
		sansSerifForm: "{U+1D5BF}", sansSerifItalicForm: "{U+1D627}", sansSerifItalicBoldForm: "{U+1D65B}", sansSerifBoldForm: "{U+1D5F3}",
		monospaceForm: "{U+1D68F}" },
	"lat_c_let_g", { calcOff: "", unicode: "{U+0047}", combiningForm: "{U+1DDB}", modifierForm: "{U+1D33}",
		italicForm: "{U+1D43A}", italicBoldForm: "{U+1D46E}", boldForm: "{U+1D406}",
		frakturForm: "{U+1D50A}", frakturBoldForm: "{U+1D572}",
		scriptForm: "{U+1D4A2}", scriptBoldForm: "{U+1D4D6}",
		doubleStruckForm: "{U+1D53E}",
		sansSerifForm: "{U+1D5A6}", sansSerifItalicForm: "{U+1D60E}", sansSerifItalicBoldForm: "{U+1D642}", sansSerifBoldForm: "{U+1D5DA}",
		monospaceForm: "{U+1D676}" },
	"lat_s_let_g", { calcOff: "", unicode: "{U+0067}", combiningForm: "{U+1DDA}", modifierForm: "{U+1D4D}",
		italicForm: "{U+1D454}", italicBoldForm: "{U+1D488}", boldForm: "{U+1D420}",
		frakturForm: "{U+1D524}", frakturBoldForm: "{U+1D58C}",
		scriptForm: "{U+210A}", scriptBoldForm: "{U+1D4F0}",
		doubleStruckForm: "{U+1D558}",
		sansSerifForm: "{U+1D5C0}", sansSerifItalicForm: "{U+1D628}", sansSerifItalicBoldForm: "{U+1D65C}", sansSerifBoldForm: "{U+1D5F4}",
		monospaceForm: "{U+1D690}" },
	"lat_c_let_h", { calcOff: "", unicode: "{U+0048}", modifierForm: "{U+1D34}",
		italicForm: "{U+1D43B}", italicBoldForm: "{U+1D46F}", boldForm: "{U+1D407}",
		frakturForm: "{U+210C}", frakturBoldForm: "{U+1D573}",
		scriptForm: "{U+210B}", scriptBoldForm: "{U+1D4D7}",
		doubleStruckForm: "{U+210D}",
		sansSerifForm: "{U+1D5A7}", sansSerifItalicForm: "{U+1D60F}", sansSerifItalicBoldForm: "{U+1D643}", sansSerifBoldForm: "{U+1D5DB}",
		monospaceForm: "{U+1D677}" },
	"lat_s_let_h", { calcOff: "", unicode: "{U+0068}", combiningForm: "{U+036A}", modifierForm: "{U+02B0}", subscriptForm: "{U+2095}",
		italicForm: "{U+210E}", italicBoldForm: "{U+1D489}", boldForm: "{U+1D421}",
		frakturForm: "{U+1D525}", frakturBoldForm: "{U+1D58D}",
		scriptForm: "{U+1D4BD}", scriptBoldForm: "{U+1D4F1}",
		doubleStruckForm: "{U+1D559}",
		sansSerifForm: "{U+1D5C1}", sansSerifItalicForm: "{U+1D629}", sansSerifItalicBoldForm: "{U+1D65D}", sansSerifBoldForm: "{U+1D5F5}",
		monospaceForm: "{U+1D691}" },
	"lat_c_let_i", { calcOff: "", unicode: "{U+0049}", modifierForm: "{U+1D35}",
		italicForm: "{U+1D43C}", italicBoldForm: "{U+1D470}", boldForm: "{U+1D408}",
		frakturForm: "{U+2111}", frakturBoldForm: "{U+1D574}",
		scriptForm: "{U+2110}", scriptBoldForm: "{U+1D4D8}",
		doubleStruckForm: "{U+1D540}",
		sansSerifForm: "{U+1D5A8}", sansSerifItalicForm: "{U+1D610}", sansSerifItalicBoldForm: "{U+1D644}", sansSerifBoldForm: "{U+1D5DC}",
		monospaceForm: "{U+1D678}" },
	"lat_s_let_i", { calcOff: "", unicode: "{U+0069}", combiningForm: "{U+0365}", subscriptForm: "{U+1D62}",
		italicForm: "{U+1D456}", italicBoldForm: "{U+1D48A}", boldForm: "{U+1D422}",
		frakturForm: "{U+1D526}", frakturBoldForm: "{U+1D58E}",
		scriptForm: "{U+1D4BE}", scriptBoldForm: "{U+1D4F2}",
		doubleStruckForm: "{U+1D55A}", doubleStruckItalicForm: "{U+2148}",
		sansSerifForm: "{U+1D5C2}", sansSerifItalicForm: "{U+1D62A}", sansSerifItalicBoldForm: "{U+1D65E}", sansSerifBoldForm: "{U+1D5F6}",
		monospaceForm: "{U+1D692}" },
	"lat_c_let_j", { calcOff: "", unicode: "{U+004A}", modifierForm: "{U+1D36}",
		italicForm: "{U+1D43D}", italicBoldForm: "{U+1D471}", boldForm: "{U+1D409}",
		frakturForm: "{U+1D50D}", frakturBoldForm: "{U+1D575}",
		scriptForm: "{U+1D4A5}", scriptBoldForm: "{U+1D4D9}",
		doubleStruckForm: "{U+1D541}",
		sansSerifForm: "{U+1D5A9}", sansSerifItalicForm: "{U+1D611}", sansSerifItalicBoldForm: "{U+1D645}", sansSerifBoldForm: "{U+1D5DD}",
		monospaceForm: "{U+1D679}" },
	"lat_s_let_j", { calcOff: "", unicode: "{U+006A}", modifierForm: "{U+02B2}", subscriptForm: "{U+2C7C}",
		italicForm: "{U+1D457}", italicBoldForm: "{U+1D48B}", boldForm: "{U+1D423}",
		frakturForm: "{U+1D527}", frakturBoldForm: "{U+1D58F}",
		scriptForm: "{U+1D4BF}", scriptBoldForm: "{U+1D4F3}",
		doubleStruckForm: "{U+1D55B}", doubleStruckItalicForm: "{U+2149}",
		sansSerifForm: "{U+1D5C3}", sansSerifItalicForm: "{U+1D62B}", sansSerifItalicBoldForm: "{U+1D65F}", sansSerifBoldForm: "{U+1D5F7}",
		monospaceForm: "{U+1D693}" },
	"lat_c_let_k", { calcOff: "", unicode: "{U+004B}", modifierForm: "{U+1D37}",
		italicForm: "{U+1D43E}", italicBoldForm: "{U+1D472}", boldForm: "{U+1D40A}",
		frakturForm: "{U+1D50E}", frakturBoldForm: "{U+1D576}",
		scriptForm: "{U+1D4A6}", scriptBoldForm: "{U+1D4DA}",
		doubleStruckForm: "{U+1D542}",
		sansSerifForm: "{U+1D5AA}", sansSerifItalicForm: "{U+1D612}", sansSerifItalicBoldForm: "{U+1D646}", sansSerifBoldForm: "{U+1D5DE}",
		monospaceForm: "{U+1D67A}" },
	"lat_s_let_k", { calcOff: "", unicode: "{U+006B}", combiningForm: "{U+1DDC}", modifierForm: "{U+1D4F}", subscriptForm: "{U+2096}",
		italicForm: "{U+1D458}", italicBoldForm: "{U+1D48C}", boldForm: "{U+1D424}",
		frakturForm: "{U+1D528}", frakturBoldForm: "{U+1D590}",
		scriptForm: "{U+1D4C0}", scriptBoldForm: "{U+1D4F4}",
		doubleStruckForm: "{U+1D55C}",
		sansSerifForm: "{U+1D5C4}", sansSerifItalicForm: "{U+1D62C}", sansSerifItalicBoldForm: "{U+1D660}", sansSerifBoldForm: "{U+1D5F8}",
		monospaceForm: "{U+1D694}" },
	"lat_c_let_l", { calcOff: "", unicode: "{U+004C}", combiningForm: "{U+1DDE}", modifierForm: "{U+1D38}",
		italicForm: "{U+1D43F}", italicBoldForm: "{U+1D473}", boldForm: "{U+1D40B}",
		frakturForm: "{U+1D50F}", frakturBoldForm: "{U+1D577}",
		scriptForm: "{U+2112}", scriptBoldForm: "{U+1D4DB}",
		doubleStruckForm: "{U+1D543}",
		sansSerifForm: "{U+1D5AB}", sansSerifItalicForm: "{U+1D613}", sansSerifItalicBoldForm: "{U+1D647}", sansSerifBoldForm: "{U+1D5DF}",
		monospaceForm: "{U+1D67B}" },
	"lat_s_let_l", { calcOff: "", unicode: "{U+006C}", combiningForm: "{U+1DDD}", modifierForm: "{U+02E1}", subscriptForm: "{U+2097}",
		italicForm: "{U+1D459}", italicBoldForm: "{U+1D48D}", boldForm: "{U+1D425}",
		frakturForm: "{U+1D529}", frakturBoldForm: "{U+1D591}",
		scriptForm: "{U+1D4C1}", scriptBoldForm: "{U+1D4F5}",
		doubleStruckForm: "{U+1D55D}",
		sansSerifForm: "{U+1D5C5}", sansSerifItalicForm: "{U+1D62D}", sansSerifItalicBoldForm: "{U+1D661}", sansSerifBoldForm: "{U+1D5F9}",
		monospaceForm: "{U+1D695}" },
	"lat_c_let_m", { calcOff: "", unicode: "{U+004D}", combiningForm: "{U+1DDF}", modifierForm: "{U+1D39}",
		italicForm: "{U+1D440}", italicBoldForm: "{U+1D474}", boldForm: "{U+1D40C}",
		frakturForm: "{U+1D510}", frakturBoldForm: "{U+1D578}",
		scriptForm: "{U+2133}", scriptBoldForm: "{U+1D4DC}",
		doubleStruckForm: "{U+1D544}",
		sansSerifForm: "{U+1D5AC}", sansSerifItalicForm: "{U+1D614}", sansSerifItalicBoldForm: "{U+1D648}", sansSerifBoldForm: "{U+1D5E0}",
		monospaceForm: "{U+1D67C}" },
	"lat_s_let_m", { calcOff: "", unicode: "{U+006D}", combiningForm: "{U+036B}", modifierForm: "{U+1D50}", subscriptForm: "{U+2098}",
		italicForm: "{U+1D45A}", italicBoldForm: "{U+1D48E}", boldForm: "{U+1D426}",
		frakturForm: "{U+1D52A}", frakturBoldForm: "{U+1D592}",
		scriptForm: "{U+1D4C2}", scriptBoldForm: "{U+1D4F6}",
		doubleStruckForm: "{U+1D55E}",
		sansSerifForm: "{U+1D5C6}", sansSerifItalicForm: "{U+1D62E}", sansSerifItalicBoldForm: "{U+1D662}", sansSerifBoldForm: "{U+1D5FA}",
		monospaceForm: "{U+1D696}" },
	"lat_c_let_n", { calcOff: "", unicode: "{U+004E}", combiningForm: "{U+1DE1}", modifierForm: "{U+1D3A}",
		italicForm: "{U+1D441}", italicBoldForm: "{U+1D475}", boldForm: "{U+1D40D}",
		frakturForm: "{U+1D511}", frakturBoldForm: "{U+1D579}",
		scriptForm: "{U+1D4A9}", scriptBoldForm: "{U+1D4DD}",
		doubleStruckForm: "{U+2115}",
		sansSerifForm: "{U+1D5AD}", sansSerifItalicForm: "{U+1D615}", sansSerifItalicBoldForm: "{U+1D649}", sansSerifBoldForm: "{U+1D5E1}",
		monospaceForm: "{U+1D67D}" },
	"lat_s_let_n", { calcOff: "", unicode: "{U+006E}", combiningForm: "{U+1DE0}", subscriptForm: "{U+2099}",
		italicForm: "{U+1D45B}", italicBoldForm: "{U+1D48F}", boldForm: "{U+1D427}",
		frakturForm: "{U+1D52B}", frakturBoldForm: "{U+1D593}",
		scriptForm: "{U+1D4C3}", scriptBoldForm: "{U+1D4F7}",
		doubleStruckForm: "{U+1D55F}",
		sansSerifForm: "{U+1D5C7}", sansSerifItalicForm: "{U+1D62F}", sansSerifItalicBoldForm: "{U+1D663}", sansSerifBoldForm: "{U+1D5FB}",
		monospaceForm: "{U+1D697}" },
	"lat_c_let_o", { calcOff: "", unicode: "{U+004F}", modifierForm: "{U+1D3C}",
		italicForm: "{U+1D442}", italicBoldForm: "{U+1D476}", boldForm: "{U+1D40E}",
		frakturForm: "{U+1D512}", frakturBoldForm: "{U+1D57A}",
		scriptForm: "{U+1D4AA}", scriptBoldForm: "{U+1D4DE}",
		doubleStruckForm: "{U+1D546}",
		sansSerifForm: "{U+1D5AE}", sansSerifItalicForm: "{U+1D616}", sansSerifItalicBoldForm: "{U+1D64A}", sansSerifBoldForm: "{U+1D5E2}",
		monospaceForm: "{U+1D67E}" },
	"lat_s_let_o", { calcOff: "", unicode: "{U+006F}", combiningForm: "{U+0366}", modifierForm: "{U+1D52}", subscriptForm: "{U+2092}",
		italicForm: "{U+1D45C}", italicBoldForm: "{U+1D490}", boldForm: "{U+1D428}",
		frakturForm: "{U+1D52C}", frakturBoldForm: "{U+1D594}",
		scriptForm: "{U+2134}", scriptBoldForm: "{U+1D4F8}",
		doubleStruckForm: "{U+1D560}",
		sansSerifForm: "{U+1D5C8}", sansSerifItalicForm: "{U+1D630}", sansSerifItalicBoldForm: "{U+1D664}", sansSerifBoldForm: "{U+1D5FC}",
		monospaceForm: "{U+1D698}" },
	"lat_c_let_p", { calcOff: "", unicode: "{U+0050}", modifierForm: "{U+1D3E}",
		italicForm: "{U+1D443}", italicBoldForm: "{U+1D477}", boldForm: "{U+1D40F}",
		frakturForm: "{U+1D513}", frakturBoldForm: "{U+1D57B}",
		scriptForm: "{U+1D4AB}", scriptBoldForm: "{U+1D4DF}",
		doubleStruckForm: "{U+2119}",
		sansSerifForm: "{U+1D5AF}", sansSerifItalicForm: "{U+1D617}", sansSerifItalicBoldForm: "{U+1D64B}", sansSerifBoldForm: "{U+1D5E3}",
		monospaceForm: "{U+1D67F}" },
	"lat_s_let_p", { calcOff: "", unicode: "{U+0070}", combiningForm: "{U+1DEE}", modifierForm: "{U+1D56}", subscriptForm: "{U+209A}",
		italicForm: "{U+1D45D}", italicBoldForm: "{U+1D491}", boldForm: "{U+1D429}",
		frakturForm: "{U+1D52D}", frakturBoldForm: "{U+1D595}",
		scriptForm: "{U+1D4C5}", scriptBoldForm: "{U+1D4F9}",
		doubleStruckForm: "{U+1D561}",
		sansSerifForm: "{U+1D5C9}", sansSerifItalicForm: "{U+1D631}", sansSerifItalicBoldForm: "{U+1D665}", sansSerifBoldForm: "{U+1D5FD}",
		monospaceForm: "{U+1D699}" },
	"lat_c_let_q", { calcOff: "", unicode: "{U+0051}", modifierForm: "{U+A7F4}",
		italicForm: "{U+1D444}", italicBoldForm: "{U+1D478}", boldForm: "{U+1D410}",
		frakturForm: "{U+1D514}", frakturBoldForm: "{U+1D57C}",
		scriptForm: "{U+1D4AC}", scriptBoldForm: "{U+1D4E0}",
		doubleStruckForm: "{U+211A}",
		sansSerifForm: "{U+1D5B0}", sansSerifItalicForm: "{U+1D618}", sansSerifItalicBoldForm: "{U+1D64C}", sansSerifBoldForm: "{U+1D5E4}",
		monospaceForm: "{U+1D680}" },
	"lat_s_let_q", { calcOff: "", unicode: "{U+0071}",
		italicForm: "{U+1D45E}", italicBoldForm: "{U+1D492}", boldForm: "{U+1D42A}",
		frakturForm: "{U+1D52E}", frakturBoldForm: "{U+1D596}",
		scriptForm: "{U+1D4C6}", scriptBoldForm: "{U+1D4FA}",
		doubleStruckForm: "{U+1D562}",
		sansSerifForm: "{U+1D5CA}", sansSerifItalicForm: "{U+1D632}", sansSerifItalicBoldForm: "{U+1D666}", sansSerifBoldForm: "{U+1D5FE}",
		monospaceForm: "{U+1D69A}" },
	"lat_c_let_r", { calcOff: "", unicode: "{U+0052}", combiningForm: "{U+1DE2}", modifierForm: "{U+1D3F}",
		italicForm: "{U+1D445}", italicBoldForm: "{U+1D479}", boldForm: "{U+1D411}",
		frakturForm: "{U+211C}", frakturBoldForm: "{U+1D57D}",
		scriptForm: "{U+211B}", scriptBoldForm: "{U+1D4E1}",
		doubleStruckForm: "{U+211D}",
		sansSerifForm: "{U+1D5B1}", sansSerifItalicForm: "{U+1D619}", sansSerifItalicBoldForm: "{U+1D64D}", sansSerifBoldForm: "{U+1D5E5}",
		monospaceForm: "{U+1D681}" },
	"lat_s_let_r", { calcOff: "", unicode: "{U+0072}", combiningForm: "{U+036C}", modifierForm: "{U+02B3}", subscriptForm: "{U+1D63}",
		italicForm: "{U+1D45F}", italicBoldForm: "{U+1D493}", boldForm: "{U+1D42B}",
		frakturForm: "{U+1D52F}", frakturBoldForm: "{U+1D597}",
		scriptForm: "{U+1D4C7}", scriptBoldForm: "{U+1D4FB}",
		doubleStruckForm: "{U+1D563}",
		sansSerifForm: "{U+1D5CB}", sansSerifItalicForm: "{U+1D633}", sansSerifItalicBoldForm: "{U+1D667}", sansSerifBoldForm: "{U+1D5FF}",
		monospaceForm: "{U+1D69B}" },
	"lat_c_let_s", { calcOff: "", unicode: "{U+0053}",
		italicForm: "{U+1D446}", italicBoldForm: "{U+1D47A}", boldForm: "{U+1D412}",
		frakturForm: "{U+1D516}", frakturBoldForm: "{U+1D57E}",
		scriptForm: "{U+1D4AE}", scriptBoldForm: "{U+1D4E2}",
		doubleStruckForm: "{U+1D54A}",
		sansSerifForm: "{U+1D5B2}", sansSerifItalicForm: "{U+1D61A}", sansSerifItalicBoldForm: "{U+1D64E}", sansSerifBoldForm: "{U+1D5E6}",
		monospaceForm: "{U+1D682}" },
	"lat_s_let_s", { calcOff: "", unicode: "{U+0073}", combiningForm: "{U+1DE4}", modifierForm: "{U+02E2}", subscriptForm: "{U+209B}",
		italicForm: "{U+1D460}", italicBoldForm: "{U+1D494}", boldForm: "{U+1D42C}",
		frakturForm: "{U+1D530}", frakturBoldForm: "{U+1D598}",
		scriptForm: "{U+1D4C8}", scriptBoldForm: "{U+1D4FC}",
		doubleStruckForm: "{U+1D564}",
		sansSerifForm: "{U+1D5CC}", sansSerifItalicForm: "{U+1D634}", sansSerifItalicBoldForm: "{U+1D668}", sansSerifBoldForm: "{U+1D600}",
		monospaceForm: "{U+1D69C}" },
	"lat_c_let_t", { calcOff: "", unicode: "{U+0054}", modifierForm: "{U+1D40}",
		italicForm: "{U+1D447}", italicBoldForm: "{U+1D47B}", boldForm: "{U+1D413}",
		frakturForm: "{U+1D517}", frakturBoldForm: "{U+1D57F}",
		scriptForm: "{U+1D4AF}", scriptBoldForm: "{U+1D4E3}",
		doubleStruckForm: "{U+1D54B}",
		sansSerifForm: "{U+1D5B3}", sansSerifItalicForm: "{U+1D61B}", sansSerifItalicBoldForm: "{U+1D64F}", sansSerifBoldForm: "{U+1D5E7}",
		monospaceForm: "{U+1D683}" },
	"lat_s_let_t", { calcOff: "", unicode: "{U+0074}", combiningForm: "{U+036D}", modifierForm: "{U+1D57}", subscriptForm: "{U+209C}",
		italicForm: "{U+1D461}", italicBoldForm: "{U+1D495}", boldForm: "{U+1D42D}",
		frakturForm: "{U+1D531}", frakturBoldForm: "{U+1D599}",
		scriptForm: "{U+1D4C9}", scriptBoldForm: "{U+1D4FD}",
		doubleStruckForm: "{U+1D565}",
		sansSerifForm: "{U+1D5CD}", sansSerifItalicForm: "{U+1D635}", sansSerifItalicBoldForm: "{U+1D669}", sansSerifBoldForm: "{U+1D601}",
		monospaceForm: "{U+1D69D}" },
	"lat_c_let_u", { calcOff: "", unicode: "{U+0055}", modifierForm: "{U+1D41}",
		italicForm: "{U+1D448}", italicBoldForm: "{U+1D47C}", boldForm: "{U+1D414}",
		frakturForm: "{U+1D518}", frakturBoldForm: "{U+1D580}",
		scriptForm: "{U+1D4B0}", scriptBoldForm: "{U+1D4E4}",
		doubleStruckForm: "{U+1D54C}",
		sansSerifForm: "{U+1D5B4}", sansSerifItalicForm: "{U+1D61C}", sansSerifItalicBoldForm: "{U+1D650}", sansSerifBoldForm: "{U+1D5E8}",
		monospaceForm: "{U+1D684}" },
	"lat_s_let_u", { calcOff: "", unicode: "{U+0075}", combiningForm: "{U+0367}", modifierForm: "{U+1D58}", subscriptForm: "{U+1D64}",
		italicForm: "{U+1D462}", italicBoldForm: "{U+1D496}", boldForm: "{U+1D42E}",
		frakturForm: "{U+1D532}", frakturBoldForm: "{U+1D59A}",
		scriptForm: "{U+1D4CA}", scriptBoldForm: "{U+1D4FE}",
		doubleStruckForm: "{U+1D566}",
		sansSerifForm: "{U+1D5CE}", sansSerifItalicForm: "{U+1D636}", sansSerifItalicBoldForm: "{U+1D66A}", sansSerifBoldForm: "{U+1D602}",
		monospaceForm: "{U+1D69E}" },
	"lat_c_let_v", { calcOff: "", unicode: "{U+0056}", modifierForm: "{U+2C7D}",
		italicForm: "{U+1D449}", italicBoldForm: "{U+1D47D}", boldForm: "{U+1D415}",
		frakturForm: "{U+1D519}", frakturBoldForm: "{U+1D581}",
		scriptForm: "{U+1D4B1}", scriptBoldForm: "{U+1D4E5}",
		doubleStruckForm: "{U+1D54D}",
		sansSerifForm: "{U+1D5B5}", sansSerifItalicForm: "{U+1D61D}", sansSerifItalicBoldForm: "{U+1D651}", sansSerifBoldForm: "{U+1D5E9}",
		monospaceForm: "{U+1D685}" },
	"lat_s_let_v", { calcOff: "", unicode: "{U+0076}", combiningForm: "{U+036E}", modifierForm: "{U+1D5B}", subscriptForm: "{U+1D65}",
		italicForm: "{U+1D463}", italicBoldForm: "{U+1D497}", boldForm: "{U+1D42F}",
		frakturForm: "{U+1D533}", frakturBoldForm: "{U+1D59B}",
		scriptForm: "{U+1D4CB}", scriptBoldForm: "{U+1D4FF}",
		doubleStruckForm: "{U+1D567}",
		sansSerifForm: "{U+1D5CF}", sansSerifItalicForm: "{U+1D637}", sansSerifItalicBoldForm: "{U+1D66B}", sansSerifBoldForm: "{U+1D603}",
		monospaceForm: "{U+1D69F}" },
	"lat_c_let_w", { calcOff: "", unicode: "{U+0057}", modifierForm: "{U+1D42}",
		italicForm: "{U+1D44A}", italicBoldForm: "{U+1D47E}", boldForm: "{U+1D416}",
		frakturForm: "{U+1D51A}", frakturBoldForm: "{U+1D582}",
		scriptForm: "{U+1D4B2}", scriptBoldForm: "{U+1D4E6}",
		doubleStruckForm: "{U+1D54E}",
		sansSerifForm: "{U+1D5B6}", sansSerifItalicForm: "{U+1D61E}", sansSerifItalicBoldForm: "{U+1D652}", sansSerifBoldForm: "{U+1D5EA}",
		monospaceForm: "{U+1D686}" },
	"lat_s_let_w", { calcOff: "", unicode: "{U+0077}", combiningForm: "{U+1DF1}", modifierForm: "{U+02B7}",
		italicForm: "{U+1D464}", italicBoldForm: "{U+1D498}", boldForm: "{U+1D430}",
		frakturForm: "{U+1D534}", frakturBoldForm: "{U+1D59C}",
		scriptForm: "{U+1D4CC}", scriptBoldForm: "{U+1D500}",
		doubleStruckForm: "{U+1D568}",
		sansSerifForm: "{U+1D5D0}", sansSerifItalicForm: "{U+1D638}", sansSerifItalicBoldForm: "{U+1D66C}", sansSerifBoldForm: "{U+1D604}",
		monospaceForm: "{U+1D6A0}" },
	"lat_c_let_x", { calcOff: "", unicode: "{U+0058}",
		italicForm: "{U+1D44B}", italicBoldForm: "{U+1D47F}", boldForm: "{U+1D417}",
		frakturForm: "{U+1D51B}", frakturBoldForm: "{U+1D583}",
		scriptForm: "{U+1D4B3}", scriptBoldForm: "{U+1D4E7}",
		doubleStruckForm: "{U+1D54F}",
		sansSerifForm: "{U+1D5B7}", sansSerifItalicForm: "{U+1D61F}", sansSerifItalicBoldForm: "{U+1D653}", sansSerifBoldForm: "{U+1D5EB}",
		monospaceForm: "{U+1D687}" },
	"lat_s_let_x", { calcOff: "", unicode: "{U+0078}", combiningForm: "{U+036F}", modifierForm: "{U+02E3}", subscriptForm: "{U+2093}",
		italicForm: "{U+1D465}", italicBoldForm: "{U+1D499}", boldForm: "{U+1D431}",
		frakturForm: "{U+1D535}", frakturBoldForm: "{U+1D59D}",
		scriptForm: "{U+1D4CD}", scriptBoldForm: "{U+1D501}",
		doubleStruckForm: "{U+1D569}",
		sansSerifForm: "{U+1D5D1}", sansSerifItalicForm: "{U+1D639}", sansSerifItalicBoldForm: "{U+1D66D}", sansSerifBoldForm: "{U+1D605}",
		monospaceForm: "{U+1D6A1}" },
	"lat_c_let_y", { calcOff: "", unicode: "{U+0059}",
		italicForm: "{U+1D44C}", italicBoldForm: "{U+1D480}", boldForm: "{U+1D418}",
		frakturForm: "{U+1D51C}", frakturBoldForm: "{U+1D584}",
		scriptForm: "{U+1D4B4}", scriptBoldForm: "{U+1D4E8}",
		doubleStruckForm: "{U+1D550}",
		sansSerifForm: "{U+1D5B8}", sansSerifItalicForm: "{U+1D620}", sansSerifItalicBoldForm: "{U+1D654}", sansSerifBoldForm: "{U+1D5EC}",
		monospaceForm: "{U+1D688}" },
	"lat_s_let_y", { calcOff: "", unicode: "{U+0079}", modifierForm: "{U+02B8}",
		italicForm: "{U+1D466}", italicBoldForm: "{U+1D49A}", boldForm: "{U+1D432}",
		frakturForm: "{U+1D536}", frakturBoldForm: "{U+1D59E}",
		scriptForm: "{U+1D4CE}", scriptBoldForm: "{U+1D502}",
		doubleStruckForm: "{U+1D56A}",
		sansSerifForm: "{U+1D5D2}", sansSerifItalicForm: "{U+1D63A}", sansSerifItalicBoldForm: "{U+1D66E}", sansSerifBoldForm: "{U+1D606}",
		monospaceForm: "{U+1D6A2}" },
	"lat_c_let_z", { calcOff: "", unicode: "{U+005A}",
		italicForm: "{U+1D44D}", italicBoldForm: "{U+1D481}", boldForm: "{U+1D419}",
		frakturForm: "{U+2128}", frakturBoldForm: "{U+1D585}",
		scriptForm: "{U+1D4B5}", scriptBoldForm: "{U+1D4E9}",
		doubleStruckForm: "{U+2124}",
		sansSerifForm: "{U+1D5B9}", sansSerifItalicForm: "{U+1D621}", sansSerifItalicBoldForm: "{U+1D655}", sansSerifBoldForm: "{U+1D5ED}",
		monospaceForm: "{U+1D689}" },
	"lat_s_let_z", { calcOff: "", unicode: "{U+007A}", combiningForm: "{U+1DE6}", modifierForm: "{U+02E3}",
		italicForm: "{U+1D467}", italicBoldForm: "{U+1D49B}", boldForm: "{U+1D433}",
		frakturForm: "{U+1D537}", frakturBoldForm: "{U+1D59F}",
		scriptForm: "{U+1D4CF}", scriptBoldForm: "{U+1D503}",
		doubleStruckForm: "{U+1D56B}",
		sansSerifForm: "{U+1D5D3}", sansSerifItalicForm: "{U+1D63B}", sansSerifItalicBoldForm: "{U+1D66F}", sansSerifBoldForm: "{U+1D607}",
		monospaceForm: "{U+1D6A3}" },
	;
	"cyr_c_let_a", { calcOff: "", unicode: "{U+0410}" }, ; А
	"cyr_s_let_a", { calcOff: "", unicode: "{U+0430}", combiningForm: "{U+2DF6}", modifierForm: "{U+1E030}", subscriptForm: "{U+1E051}" }, ; а
	"cyr_c_let_b", { calcOff: "", unicode: "{U+0411}" }, ; Б
	"cyr_s_let_b", { calcOff: "", unicode: "{U+0431}", combiningForm: "{U+2DE0}", modifierForm: "{U+1E031}", subscriptForm: "{U+1E052}" }, ; б
	"cyr_c_let_v", { calcOff: "", unicode: "{U+0412}" }, ; В
	"cyr_s_let_v", { calcOff: "", unicode: "{U+0432}", combiningForm: "{U+2DE1}", modifierForm: "{U+1E032}", subscriptForm: "{U+1E053}" }, ; в
	"cyr_c_let_g", { calcOff: "", unicode: "{U+0413}" }, ; Г
	"cyr_s_let_g", { calcOff: "", unicode: "{U+0433}", combiningForm: "{U+2DE2}", modifierForm: "{U+1E033}", subscriptForm: "{U+1E054}" }, ; г
	"cyr_c_let_d", { calcOff: "", unicode: "{U+0414}" }, ; Д
	"cyr_s_let_d", { calcOff: "", unicode: "{U+0434}", combiningForm: "{U+2DE3}", modifierForm: "{U+1E034}", subscriptForm: "{U+1E055}" }, ; д
	"cyr_c_let_e", { calcOff: "", unicode: "{U+0415}" }, ; Е
	"cyr_s_let_e", { calcOff: "", unicode: "{U+0435}", combiningForm: "{U+2DF7}", modifierForm: "{U+1E035}", subscriptForm: "{U+1E056}" }, ; е
	"cyr_c_let_yo", { calcOff: "", unicode: "{U+0401}" }, ; Ё
	"cyr_s_let_yo", { calcOff: "", unicode: "{U+0451}" }, ; ё
	"cyr_c_let_zh", { calcOff: "", unicode: "{U+0416}" }, ; Ж
	"cyr_s_let_zh", { calcOff: "", unicode: "{U+0436}", combiningForm: "{U+2DE4}", modifierForm: "{U+1E036}", subscriptForm: "{U+1E057}" }, ; ж
	"cyr_c_let_z", { calcOff: "", unicode: "{U+0417}" }, ; З
	"cyr_s_let_z", { calcOff: "", unicode: "{U+0437}", combiningForm: "{U+2DE5}", modifierForm: "{U+1E037}", subscriptForm: "{U+1E058}" }, ; з
	"cyr_c_let_и", { calcOff: "", unicode: "{U+0418}" }, ; И
	"cyr_s_let_и", { calcOff: "", unicode: "{U+0438}", combiningForm: "{U+A675}", modifierForm: "{U+1E038}", subscriptForm: "{U+1E059}" }, ; и
	"cyr_c_let_iy", { calcOff: "", unicode: "{U+0419}" }, ; Й
	"cyr_s_let_iy", { calcOff: "", unicode: "{U+0439}" }, ; й
	"cyr_c_let_k", { calcOff: "", unicode: "{U+041A}" }, ; К
	"cyr_s_let_k", { calcOff: "", unicode: "{U+043A}", combiningForm: "{U+2DE6}", modifierForm: "{U+1E039}", subscriptForm: "{U+1E05A}" }, ; к
	"cyr_c_let_l", { calcOff: "", unicode: "{U+041B}" }, ; Л
	"cyr_s_let_l", { calcOff: "", unicode: "{U+043B}", combiningForm: "{U+2DE7}", modifierForm: "{U+1E03A}", subscriptForm: "{U+1E05B}" }, ; л
	"cyr_c_let_m", { calcOff: "", unicode: "{U+041C}" }, ; М
	"cyr_s_let_m", { calcOff: "", unicode: "{U+043C}", combiningForm: "{U+2DE8}", modifierForm: "{U+1E03B}" }, ; м
	"cyr_c_let_n", { calcOff: "", unicode: "{U+041D}" }, ; Н
	"cyr_s_let_n", { calcOff: "", unicode: "{U+043D}", combiningForm: "{U+2DE9}", modifierForm: "{U+1D78}" }, ; н
	"cyr_c_let_o", { calcOff: "", unicode: "{U+041E}" }, ; О
	"cyr_s_let_o", { calcOff: "", unicode: "{U+043E}", combiningForm: "{U+2DEA}", modifierForm: "{U+1E03C}", subscriptForm: "{U+1E05C}" }, ; о
	"cyr_c_let_p", { calcOff: "", unicode: "{U+041F}" }, ; П
	"cyr_s_let_p", { calcOff: "", unicode: "{U+043F}", combiningForm: "{U+2DEB}", modifierForm: "{U+1E03D}", subscriptForm: "{U+1E05D}" }, ; п
	"cyr_c_let_r", { calcOff: "", unicode: "{U+0420}" }, ; Р
	"cyr_s_let_r", { calcOff: "", unicode: "{U+0440}", combiningForm: "{U+2DEC}", modifierForm: "{U+1E03E}" }, ; р
	"cyr_c_let_s", { calcOff: "", unicode: "{U+0421}" }, ; С
	"cyr_s_let_s", { calcOff: "", unicode: "{U+0441}", combiningForm: "{U+2DED}", modifierForm: "{U+1E03F}", subscriptForm: "{U+1E05E}" }, ; с
	"cyr_c_let_t", { calcOff: "", unicode: "{U+0422}" }, ; Т
	"cyr_s_let_t", { calcOff: "", unicode: "{U+0442}", combiningForm: "{U+2DEE}", modifierForm: "{U+1E040}" }, ; т
	"cyr_c_let_u", { calcOff: "", unicode: "{U+0423}" }, ; У
	"cyr_s_let_u", { calcOff: "", unicode: "{U+0443}", combiningForm: "{U+A677}", modifierForm: "{U+1E041}", subscriptForm: "{U+1E05F}" }, ; у
	"cyr_c_let_f", { calcOff: "", unicode: "{U+0424}" }, ; Ф
	"cyr_s_let_f", { calcOff: "", unicode: "{U+0444}", combiningForm: "{U+A69E}", modifierForm: "{U+1E042}", subscriptForm: "{U+1E060}" }, ; ф
	"cyr_c_let_h", { calcOff: "", unicode: "{U+0425}" }, ; Х
	"cyr_s_let_h", { calcOff: "", unicode: "{U+0445}", combiningForm: "{U+2DEF}", modifierForm: "{U+1E043}", subscriptForm: "{U+1E061}" }, ; х
	"cyr_c_let_ts", { calcOff: "", unicode: "{U+0426}" }, ; Ц
	"cyr_s_let_ts", { calcOff: "", unicode: "{U+0446}", combiningForm: "{U+2DF0}", modifierForm: "{U+1E044}", subscriptForm: "{U+1E062}" }, ; ц
	"cyr_c_let_ch", { calcOff: "", unicode: "{U+0427}" }, ; Ч
	"cyr_s_let_ch", { calcOff: "", unicode: "{U+0447}", combiningForm: "{U+2DF1}", modifierForm: "{U+1E045}", subscriptForm: "{U+1E063}" }, ; ч
	"cyr_c_let_sh", { calcOff: "", unicode: "{U+0428}" }, ; Ш
	"cyr_s_let_sh", { calcOff: "", unicode: "{U+0448}", combiningForm: "{U+2DF2}", modifierForm: "{U+1E046}", subscriptForm: "{U+1E064}" }, ; ш
	"cyr_c_let_shch", { calcOff: "", unicode: "{U+0429}" }, ; Щ
	"cyr_s_let_shch", { calcOff: "", unicode: "{U+0449}", combiningForm: "{U+2DF3}" }, ; щ
	"cyr_c_let_yeru", { calcOff: "", unicode: "{U+042A}" }, ; Ъ
	"cyr_s_let_yeru", { calcOff: "", unicode: "{U+044A}", combiningForm: "{U+A678}", modifierForm: "{U+A69C}", subscriptForm: "{U+1E065}" }, ; ъ
	"cyr_c_let_yery", { calcOff: "", unicode: "{U+042B}" }, ; Ы
	"cyr_s_let_yery", { calcOff: "", unicode: "{U+044B}", combiningForm: "{U+A679}", modifierForm: "{U+1E047}", subscriptForm: "{U+1E066}" }, ; ы
	"cyr_c_let_yeri", { calcOff: "", unicode: "{U+042C}" }, ; Ь
	"cyr_s_let_yeri", { calcOff: "", unicode: "{U+044C}", combiningForm: "{U+A67A}", modifierForm: "{U+A69D}" }, ; ь
	"cyr_c_let_э", { calcOff: "", unicode: "{U+042D}" }, ; Э
	"cyr_s_let_э", { calcOff: "", unicode: "{U+044D}", modifierForm: "{U+1E048}" }, ; э
	"cyr_c_let_yu", { calcOff: "", unicode: "{U+042E}" }, ; Ю
	"cyr_s_let_yu", { calcOff: "", unicode: "{U+044E}", combiningForm: "{U+2DFB}", modifierForm: "{U+1E049}" }, ; ю
	"cyr_c_let_ya", { calcOff: "", unicode: "{U+042F}" }, ; Я
	"cyr_s_let_ya", { calcOff: "", unicode: "{U+044F}" } ; я
)

MapInsert(Characters,
	"num_sup_0", { unicode: "{U+2070}" },
	"num_sup_1", { unicode: "{U+00B9}" },
	"num_sup_2", { unicode: "{U+00B2}" },
	"num_sup_3", { unicode: "{U+00B3}" },
	"num_sup_4", { unicode: "{U+2074}" },
	"num_sup_5", { unicode: "{U+2075}" },
	"num_sup_6", { unicode: "{U+2076}" },
	"num_sup_7", { unicode: "{U+2077}" },
	"num_sup_8", { unicode: "{U+2078}" },
	"num_sup_9", { unicode: "{U+2079}" },
	"num_sup_minus", { unicode: "{U+207B}" },
	"num_sup_equals", { unicode: "{U+207C}" },
	"num_sup_plus", { unicode: "{U+207A}" },
	"num_sup_left_parenthesis", { unicode: "{U+207D}" },
	"num_sup_right_parenthesis", { unicode: "{U+207E}" },
	"num_sub_0", { unicode: "{U+2080}" },
	"num_sub_1", { unicode: "{U+2081}" },
	"num_sub_2", { unicode: "{U+2082}" },
	"num_sub_3", { unicode: "{U+2083}" },
	"num_sub_4", { unicode: "{U+2084}" },
	"num_sub_5", { unicode: "{U+2085}" },
	"num_sub_6", { unicode: "{U+2086}" },
	"num_sub_7", { unicode: "{U+2087}" },
	"num_sub_8", { unicode: "{U+2088}" },
	"num_sub_9", { unicode: "{U+2089}" },
	"num_sub_minus", { unicode: "{U+208B}" },
	"num_sub_equals", { unicode: "{U+208C}" },
	"num_sub_plus", { unicode: "{U+208A}" },
	"num_sub_left_parenthesis", { unicode: "{U+208D}" },
	"num_sub_right_parenthesis", { unicode: "{U+208E}" },
)

MapInsert(Characters,
	"kkey_0", { calcOff: "", unicode: "{U+0030}", sup: "num_sup_0", sub: "num_sub_0", doubleStruckForm: "{U+1D7D8}", boldForm: "{U+1D7CE}",
		sansSerifForm: "{U+1D7E2}",
		sansSerifBoldForm: "{U+1D7EC}",
		monospaceForm: "{U+1D7F6}" },
	"kkey_1", { calcOff: "", unicode: "{U+0031}", sup: "num_sup_1", sub: "num_sub_1", doubleStruckForm: "{U+1D7D9}", boldForm: "{U+1D7CF}",
		sansSerifForm: "{U+1D7E3}",
		sansSerifBoldForm: "{U+1D7ED}",
		monospaceForm: "{U+1D7F7}" },
	"kkey_2", { calcOff: "", unicode: "{U+0032}", sup: "num_sup_2", sub: "num_sub_2", doubleStruckForm: "{U+1D7DA}", boldForm: "{U+1D7D0}",
		sansSerifForm: "{U+1D7E4}",
		sansSerifBoldForm: "{U+1D7EE}",
		monospaceForm: "{U+1D7F8}" },
	"kkey_3", { calcOff: "", unicode: "{U+0033}", sup: "num_sup_3", sub: "num_sub_3", doubleStruckForm: "{U+1D7DB}", boldForm: "{U+1D7D1}",
		sansSerifForm: "{U+1D7E5}",
		sansSerifBoldForm: "{U+1D7EF}",
		monospaceForm: "{U+1D7F9}" },
	"kkey_4", { calcOff: "", unicode: "{U+0034}", sup: "num_sup_4", sub: "num_sub_4", doubleStruckForm: "{U+1D7DC}", boldForm: "{U+1D7D2}",
		sansSerifForm: "{U+1D7E6}",
		sansSerifBoldForm: "{U+1D7F0}",
		monospaceForm: "{U+1D7FA}" },
	"kkey_5", { calcOff: "", unicode: "{U+0035}", sup: "num_sup_5", sub: "num_sub_5", doubleStruckForm: "{U+1D7DD}", boldForm: "{U+1D7D3}",
		sansSerifForm: "{U+1D7E7}",
		sansSerifBoldForm: "{U+1D7F1}",
		monospaceForm: "{U+1D7FB}" },
	"kkey_6", { calcOff: "", unicode: "{U+0036}", sup: "num_sup_6", sub: "num_sub_6", doubleStruckForm: "{U+1D7DE}", boldForm: "{U+1D7D4}",
		sansSerifForm: "{U+1D7E8}",
		sansSerifBoldForm: "{U+1D7F2}",
		monospaceForm: "{U+1D7FC}" },
	"kkey_7", { calcOff: "", unicode: "{U+0037}", sup: "num_sup_7", sub: "num_sub_7", doubleStruckForm: "{U+1D7DF}", boldForm: "{U+1D7D5}",
		sansSerifForm: "{U+1D7E9}",
		sansSerifBoldForm: "{U+1D7F3}",
		monospaceForm: "{U+1D7FD}" },
	"kkey_8", { calcOff: "", unicode: "{U+0038}", sup: "num_sup_8", sub: "num_sub_8", doubleStruckForm: "{U+1D7E0}", boldForm: "{U+1D7D6}",
		sansSerifForm: "{U+1D7EA}",
		sansSerifBoldForm: "{U+1D7F4}",
		monospaceForm: "{U+1D7FE}" },
	"kkey_9", { calcOff: "", unicode: "{U+0039}", sup: "num_sup_9", sub: "num_sub_9", doubleStruckForm: "{U+1D7E1}", boldForm: "{U+1D7D7}",
		sansSerifForm: "{U+1D7EB}",
		sansSerifBoldForm: "{U+1D7F5}",
		monospaceForm: "{U+1D7FF}" },
	"kkey_minus", { calcOff: "", unicode: "{U+002D}", sup: "num_sup_minus", sub: "num_sub_minus" },
	"kkey_equals", { calcOff: "", unicode: "{U+003D}", sup: "num_sup_equals", sub: "num_sub_equals" },
	"kkey_asterisk", { calcOff: "", unicode: "{U+002A}" },
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
	"kkey_commercial_at", { calcOff: "", unicode: "{U+0040}" },
	"kkey_numero_sign", { calcOff: "", unicode: "{U+2116}" },
	"kkey_number_sign", { calcOff: "", unicode: "{U+0023}" },
	"kkey_percent_sign", { calcOff: "", unicode: "{U+0025}" },
	"kkey_circumflex_accent", { calcOff: "", unicode: "{U+005E}" },
)

StaticCount := GetMapCount(Characters)
CharactersCount := StaticCount

GetCountDifference() {
	Output := StaticCount
	CurrentCount := GetMapCount(Characters)
	if CurrentCount > StaticCount {
		Output := StaticCount " +" (CurrentCount - StaticCount) " " ReadLocale("with_my_recipes")
	}
	return Output
}

MapInsert(Characters,
	"misc_crlf_emspace", {
		calcOff: "",
		unicode: CallChar("carriage_return", "unicode"),
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
		calcOff: "",
		unicode: CallChar("new_line", "unicode"),
		group: ["Misc"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [Enter]",
		symbolAlt: CallChar("new_line", "symbolAlt")
	},
	"ipa_a-z", {
		calcOff: "",
		unicode: "{U+0041}", html: "N/A",
		uniSequence: ["{U+0061}", "{U+0062}", "{U+0063}", "{U+0064}", "{U+0065}", "{U+0066}", "{U+0067}", "{U+0068}", "{U+0069}", "{U+006A}", "{U+006B}", "{U+006C}", "{U+006D}", "{U+006E}", "{U+006F}", "{U+0070}", "{U+0071}", "{U+0072}", "{U+0073}", "{U+0074}", "{U+0075}", "{U+0076}", "{U+0077}", "{U+0078}", "{U+0079}", "{U+007A}"],
		group: ["IPA"],
		alt_layout: "<+ [a-z]",
		symbolAlt: "a-z",
	},
	"ipa_a-z_cap", {
		calcOff: "",
		unicode: "{U+0041}", html: "N/A",
		uniSequence: ["{U+0041}", "{U+0042}", "{U+0043}", "{U+0044}", "{U+0045}", "{U+0046}", "{U+0047}", "{U+0048}", "{U+0049}", "{U+004A}", "{U+004B}", "{U+004C}", "{U+004D}", "{U+004E}", "{U+004F}", "{U+0050}", "{U+0051}", "{U+0052}", "{U+0053}", "{U+0054}", "{U+0055}", "{U+0056}", "{U+0057}", "{U+0058}", "{U+0059}", "{U+005A}"],
		group: ["IPA"],
		alt_layout: "c*<+ [a-z]",
		symbolAlt: "A-Z",
	},
	"ipa_combining_mode", {
		calcOff: "",
		unicode: "{U+0041}", html: "N/A",
		uniSequence: ["{U+25CC}", "{U+0363}", "{U+25CC}", "{U+1DE8}", "{U+25CC}", "{U+0369}", "{U+25CC}", "{U+1DF1}"],
		group: ["IPA"],
		alt_layout: "RAlt F2",
		symbolAlt: GetChar("dotted_circle") Chr(0x0363) "-" GetChar("dotted_circle") Chr(0x1DE6),
	},
	"ipa_modifiers_mode", {
		calcOff: "",
		unicode: "{U+0041}", html: "N/A",
		uniSequence: ["{U+02B0}", "{U+02B1}", "{U+02B2}", "{U+02B3}", "{U+02B7}", "{U+02B8}"],
		group: ["IPA"],
		alt_layout: "RAlt F3",
		symbolAlt: Chr(0x02B0) "-" Chr(0x02B8),
	},
	"ipa_subscript_mode", {
		calcOff: "",
		unicode: "{U+0041}", html: "N/A",
		uniSequence: ["{U+2090}", "{U+2091}", "{U+2095}", "{U+2C7C}", "{U+2096}", "{U+2097}"],
		group: ["IPA"],
		alt_layout: "RAlt RShift F3",
		symbolAlt: Chr(0x2090) "-" Chr(0x2095),
	},
)

CustomComposeFile := WorkingDir "\CustomCompose.ini"
if !FileExist(CustomComposeFile) {
	IniWrite("Символ кандзи «Ёси»", CustomComposeFile, "kanji_yoshi", "name")
	IniWrite("ёси|yoshi", CustomComposeFile, "kanji_yoshi", "recipe")
	IniWrite(Chr(0x7FA9), CustomComposeFile, "kanji_yoshi", "result")
}

FillWithCustomRecipes() {
	global Characters, CharactersCount
	try {
		ComposesFile := FileRead(CustomComposeFile, "UTF-8")
		Sections := []

		for line in StrSplit(ComposesFile, "`n") {
			if RegExMatch(line, "^\[(.*)\]$", &match) {
				Sections.Push(match[1])
			}
		}

		for section in Sections {
			try {
				RecipeTitle := IniRead(CustomComposeFile, section, "name")
				Recipe := IniRead(CustomComposeFile, section, "recipe")
				RecipeResult := IniRead(CustomComposeFile, section, "result")


				if InStr(Recipe, "|") {
					Recipe := StrSplit(Recipe, "|")
				}

				Escapes := ["\n", "`n", "\r", "`r", "\t", "`t"]
				for i, replaces in Escapes {
					if Mod(i, 2) = 1 {
						RecipeResult := StrReplace(RecipeResult, replaces, Escapes[i + 1])
					}
				}


				RefinedResult := []
				i := 1
				while (i <= StrLen(RecipeResult)) {
					char := SubStr(RecipeResult, i, 1)
					code := Ord(char)

					if (code >= 0xD800 && code <= 0xDBFF) {
						nextChar := SubStr(RecipeResult, i + 1, 1)
						char .= nextChar
						i += 1
					}

					RefinedResult.Push("{U+" GetCharacterUnicode(char) "}")
					i += 1
				}

				MapInsert(Characters,
					section, {
						unicode: RefinedResult[1],
						uniSequence: RefinedResult,
						titles: Map("ru", RecipeTitle, "en", RecipeTitle),
						recipe: Recipe,
						group: ["Custom Composes"],
					}
				)
			} catch {
				MsgBox()
				continue
			}
		}
		CharactersCount := GetCountDifference()
	} catch {
		return
	}
}


FillWithCustomRecipes()

UpdateCustomRecipes(*) {
	global Characters
	toDelete := []

	try {
		for characterEntry, value in Characters {
			if HasProp(value, "group") && value.group[1] = "Custom Composes" {
				toDelete.Push(characterEntry)
			}
		}

		for key in toDelete {
			Characters.Delete(key)
		}

	} finally {
		FillWithCustomRecipes()
		ProcessMapAfter("Custom Composes")
		UpdateRecipeValidator()
	}
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
		}

		for i, pair in LocalEntitiesLibrary {
			if Mod(i, 2) = 1 {
				Symbol := pair
				Entity := LocalEntitiesLibrary[i + 1]

				if EntryCharacter = Symbol {
					value.entity := Entity
					break
				}
			}
		}

		for i, pair in LocalAltCodesLibrary {
			if Mod(i, 2) = 1 {
				Symbol := pair
				AltCode := LocalAltCodesLibrary[i + 1]

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

		Alterations := ["combining", "modifier", "subscript", "italic", "italicBold", "bold", "script", "fraktur", "scriptBold", "frakturBold", "doubleStruck", "doubleStruckBold", "doubleStruckItalic", "doubleStruckItalicBold", "sansSerif", "sansSerifItalic", "sansSerifItalicBold", "sansSerifBold", "monospace"]

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
				}


			} else {
				if EntryParts.script != "" {
					ValueLetter := HasProp(value, "letter") ? value.letter : EntryParts.letter
					LetterVar := (EntryParts.cap = "c" || EntryParts.case = "c") ? StrUpper(ValueLetter) : ValueLetter
					value.recipe := RegExReplace(value.recipe, "^\$", LetterVar)
				}

				ModifiedRecipe := ""
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
		MsgBox(ReadLocale("message_character_not_found"), DSLPadTitle, "Icon!")
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

Class CharacterInserter {

	__New(insertType) {
		this.insertType := insertType
		this.lastPrompt := IniRead(ConfigFile, "LatestPrompts", insertType, "")
	}

	InputDialog(UseHWND := True) {
		hwnd := WinActive('A')

		IB := InputBox(ReadLocale("symbol_code_prompt"), ReadLocale("symbol_" StrLower(this.insertType)), "w256 h92", this.lastPrompt)
		this.lastPrompt := IB.Value

		if IB.Result = "Cancel"
			return

		output := ""
		try {

			splittedPrompt := StrSplit(this.lastPrompt, " ")
			for charCode in splittedPrompt {
				if charCode != "" {
					charCode := RegExReplace(charCode, "^(U\+|u\+|Alt\+|alt\+)", "")

					if !%this.insertType%Validate(charCode)
						throw

					output .= %this.insertType%(charCode)

				}
			}
			IniWrite(this.lastPrompt, ConfigFile, "LatestPrompts", this.insertType)
		} catch {
			MsgBox(ReadLocale("message_wrong_format") "`n`n" ReadLocale("message_wrong_format_" StrLower(this.insertType)), DSLPadTitle, "Icon!")
			return
		}

		try {
			if UseHWND && !WinActive('ahk_id ' hwnd) {
				WinActivate('ahk_id ' hwnd)
				WinWaitActive(hwnd)
			}

			Send(output)
		}
		return

		Altcode(charCode) {
			return "{ASC " charCode "}"
		}

		Unicode(charCode) {
			charCode := Format("0x" charCode, "d")
			return Chr(charCode)
		}

		AltcodeValidate(charCode) {
			return IsInteger(charCode) && ((RegExMatch(charCode, "^0") ? charCode >= 128 : charCode > 0) && charCode <= 255)
		}

		UnicodeValidate(charCode) {
			return RegExMatch(charCode, "^[0-9a-fA-F]+$")
		}
	}
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
CallBuffer(Time := -25, Callback := "") {
	if Callback != ""
		SetTimer(Callback, Time)
}

ChangeTrayIconOnLanguage() {
	LanguageCode := GetLanguageCode()
	CurrentLayout := GetLayoutLocale()

	if DisabledAllKeys {
		TraySetIcon(InternalFiles["AppIcoDLL"].File, 9)
		A_IconTip := DSLPadTitle " (" ReadLocale("tray_tooltip_disabled") ")"
		return
	}

	ActiveLatin := IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY")
	ActiveCyrillic := IniRead(ConfigFile, "Settings", "CyrillicLayout", "ЙЦУКЕН")

	TitleCompose := DSLPadTitle "`n" ActiveLatin " – " ActiveCyrillic

	IconMap := Map(
		"Glagolitic Futhark", {
			CodeEn: 2, CodeRu: 3, Default: 1,
			TitleEn: ReadLocale("tray_tooltip_futhark"),
			TitleRu: ReadLocale("tray_tooltip_glagolitic"),
		},
		"Old Turkic Old Permic", {
			CodeEn: 4, CodeRu: 5, Default: 1,
			TitleEn: ReadLocale("tray_tooltip_turkic"),
			TitleRu: ReadLocale("tray_tooltip_permic"),
		},
		"Old Hungarian", {
			CodeEn: 6, CodeRu: 6, Default: 1,
			TitleEn: ReadLocale("tray_tooltip_hungarian"),
			TitleRu: ReadLocale("tray_tooltip_hungarian"),
		},
		"Gothic", {
			CodeEn: 7, CodeRu: 7, Default: 1,
			TitleEn: ReadLocale("tray_tooltip_gothic"),
			TitleRu: ReadLocale("tray_tooltip_gothic"),
		},
		"IPA", {
			CodeEn: 8, CodeRu: 8, Default: 1,
			TitleEn: ReadLocale("tray_tooltip_ipa"),
			TitleRu: ReadLocale("tray_tooltip_ipa"),
		},
		"Maths", {
			CodeEn: 10, CodeRu: 10, Default: 1,
			TitleEn: ReadLocale("tray_tooltip_maths"),
			TitleRu: ReadLocale("tray_tooltip_maths"),
		}
	)

	if IconMap.Has(ActiveScriptName) {
		TrayTitle := TitleCompose (CurrentLayout = CodeEn ? "`n" IconMap[ActiveScriptName].TitleEn :
			CurrentLayout = CodeRu ? "`n" IconMap[ActiveScriptName].TitleRu : 1)

		IconCode := (CurrentLayout = CodeEn ? IconMap[ActiveScriptName].CodeEn :
			CurrentLayout = CodeRu ? IconMap[ActiveScriptName].CodeRu : 1)
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
	LanguageCode := GetLanguageCode()
	CurrentLayout := GetLayoutLocale()
	global ActiveScriptName, ConfigFile, PreviousScriptName
	CurrentActive := ScriptName = ActiveScriptName

	LocalesPairs := [
		"Glagolitic Futhark", "script_glagolitic_futhark",
		"Old Turkic Old Permic", "script_turkic_perimc",
		"Old Hungarian", "script_hungarian",
		"Gothic", "script_gothic",
		"IPA", "script_ipa",
		"Maths", "script_maths",
	]

	if !CurrentActive {
		if ScriptName = "Glagolitic Futhark" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, CurrentLayout = CodeEn ? 2 : CurrentLayout = CodeRu ? 3 : 1)
		} else if ScriptName = "Old Turkic Old Permic" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, CurrentLayout = CodeEn ? 4 : CurrentLayout = CodeRu ? 5 : 1)
		} else if ScriptName = "Old Hungarian" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 6 : 1)
		} else if ScriptName = "Gothic" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 7 : 1)
		} else if ScriptName = "IPA" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 8 : 1)
		} else if ScriptName = "Maths" {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, (CurrentLayout = CodeEn || CurrentLayout = CodeRu) ? 10 : 1)
		} else {
			TraySetIcon(InternalFiles["AppIcoDLL"].File, 1)
		}
		if !DisabledAllKeys {
			UnregisterKeysLayout()
		}
		ActiveScriptName := ""
		if !DisabledAllKeys {
			RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], ScriptName), True)
		}
		ActiveScriptName := ScriptName
	} else {
		TraySetIcon(InternalFiles["AppIcoDLL"].File, 1)
		if !DisabledAllKeys {
			UnregisterKeysLayout()
		}
		ActiveScriptName := ""
		if !DisabledAllKeys {
			RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
			RegisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()]))
		}
	}

	if !HideMessage {
		for i, pair in LocalesPairs {
			if (Mod(i, 2) == 1) {
				key := pair
				locale := LocalesPairs[i + 1]
				if ScriptName = key {
					MsgBox(CurrentActive ? SetStringVars(ReadLocale("script_mode_deactivated"), ReadLocale(locale)) : SetStringVars(ReadLocale("script_mode_activated"), ReadLocale(locale)), DSLPadTitle, 0x40)
					break
				}
			}
		}
	}
	return
}

ChangeScriptInput(ScriptMode) {
	PreviousScriptMode := IniRead(ConfigFile, "Settings", "ScriptInput", "Default")

	IsAlterationsActive := AlterationActiveName != "" ? True : False

	if (ScriptMode != "Default" && (ScriptMode = PreviousScriptMode)) {
		IniWrite("Default", ConfigFile, "Settings", "ScriptInput")
		UnregisterHotKeys(GetKeyBindings(LayoutsPresets[CheckQWERTY()], "Cleanscript"))
		RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"), , IsAlterationsActive)
	} else {
		IniWrite(ScriptMode, ConfigFile, "Settings", "ScriptInput")
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


SendAltNumpad(CharacterCode) {
	Send("{Alt Down}")
	Loop Parse, CharacterCode
		Send("{Numpad" A_LoopField "}")
	Send("{Alt Up}")
}

Class TemperatureConversion {
	#Requires Autohotkey v2.0+

	static scales := {
		C: [GetChar("celsius"), GetChar("degree") "C"],
		F: [GetChar("fahrenheit"), GetChar("degree") "F"],
		K: [GetChar("kelvin"), "K"],
		R: "R",
		N: "N",
		D: "D",
		H: "H",
		L: "L",
		W: "W",
		ME: "Me",
		RO: "R" GetChar("lat_s_let_o_solidus_long"),
		RE: "R" GetChar("lat_s_let_e_acute"),
	}

	static typographyTypes := Map(
		"Deutsch", [".,", (T) => RegExReplace(T, "\.,", ".")],
		"Canada", ["..", (T) => RegExReplace(T, "\.\.", ".")],
		"Switzerland-Comma", ["''", (T) => RegExReplace(T, "\'\'", ".")],
		"Switzerland-Dot", ["'", (T) => RegExReplace(T, "\'", ".")],
		"Russian", [",", (T) => RegExReplace(T, ",", ".")],
	)

	static __New() {
		this.RegistryHotstrings()
	}

	static RegistryHotstrings() {
		hsKeys := [
			'cd', 'cf', 'ck', 'cn', 'cr', "cl", "cw", "cro", "cre", 'ch', ; Celsius
			'fc', 'fd', 'fk', 'fn', 'fr', 'fl', 'fw', 'fro', 'fre', ; Fahrenheit
			'kc', 'kd', 'kf', 'kn', 'kr', 'kl', 'kw', 'kro', 'kre', ; Kelvin
			'nc', 'nd', 'nf', 'nk', 'nr', 'nl', 'nw', 'nro', 'nre', ; Newton
			'rc', 'rd', 'rf', 'rk', 'rn', 'rl', 'rw', 'rro', 'rre', ; Rankine
			'dc', 'df', 'dk', 'dn', 'dr', 'dl', 'dw', 'dro', 'dre', ; Delisle
			'lc', 'lf', 'lk', 'ln', 'lr', 'ld', 'lw', 'lro', 'lre', ; Leiden
			'wc', 'wf', 'wk', 'wn', 'wr', 'wd', 'wl', 'wro', 'wre', ; Wedgwood
			'roc', 'rof', 'rok', 'ron', 'ror', 'rod', 'rol', 'row', 'rore', ; Romer
			'rec', 'ref', 'rek', 'ren', 'rer', 'red', 'rel', 'rew', 'rero', ; Reaumur
			'hc', ; Hooke
			'mec', 'cme', 'mek', 'kme', ; Special Custom, Mercuric
		]

		callback := ObjBindMethod(this, 'Converter')

		for hsKey in hsKeys {
			HotString(":C?0:ct" hsKey, callback)
		}
	}

	static Converter(conversionType) {
		hwnd := WinActive('A')

		conversionFromTo := RegExReplace(conversionType, "^.*t", "")

		labelFrom := (RegExMatch(conversionFromTo, "^ro|^re|^me")) ? SubStr(conversionFromTo, 1, 2) : SubStr(conversionFromTo, 1, 1)
		labelTo := (RegExMatch(conversionFromTo, "ro$|re$|me$")) ? SubStr(conversionFromTo, -2) : SubStr(conversionFromTo, -1, 1)


		conversionLabel := "[" (IsObject(this.scales.%labelFrom%) ? this.scales.%labelFrom%[2] : GetChar("degree") this.scales.%labelFrom%) " " GetChar("arrow_right") " " (IsObject(this.scales.%labelTo%) ? this.scales.%labelTo%[2] : GetChar("degree") this.scales.%labelTo%) "]"

		CaretTooltip(conversionLabel)
		numberValue := this.GetNumber(conversionLabel)

		try {
			regionalType := "English"
			for region, value in this.typographyTypes {
				if InStr(numberValue, value[1]) {
					numberValue := value[2](numberValue)
					regionalType := region
					break
				}
			}

			numberValue := %conversionFromTo%(StrReplace(numberValue, GetChar("minus"), "-"))

			(SubStr(numberValue, 1, 1) = "-") ? (numberValue := SubStr(numberValue, 2), negativePoint := True) : (negativePoint := False)

			temperatureValue := this.PostFormatting(numberValue, labelTo, negativePoint, regionalType)

			if !WinActive('ahk_id ' hwnd) {
				WinActivate('ahk_id ' hwnd)
				WinWaitActive(hwnd)
			}

			SendText(temperatureValue)
		} catch {
			SendText(RegExReplace(conversionType, "^.*?:.*?:", ""))
		}
		return

		; Celsius
		CF(G) => (G * 9 / 5) + 32
		CK(G) => G + 273.15
		CR(G) => (G + 273.15) * 1.8
		CN(G) => G * 33 / 100
		CD(G) => (100 - G) * 3 / 2
		CH(G) => G * 5 / 12
		CL(G) => G + 253
		CW(G) => (G / 24.857191) - 10.821818
		CRO(G) => (G / 1.904762) + 7.5
		CRE(G) => G / 1.25

		; Fahrenheit
		FC(G) => (G - 32) * 5 / 9
		FK(G) => (G - 32) * 5 / 9 + 273.15
		FR(G) => G + 459.67
		FN(G) => (G - 32) * 11 / 60
		FD(G) => (212 - G) * 5 / 6
		FL(G) => (G / 1.8) + 235.222222
		FW(G) => (G / 44.742943) - 11.537015
		FRO(G) => (G / 3.428571) - 1.833333
		FRE(G) => (G / 2.25) - 14.222222

		; Kelvin
		KC(G) => G - 273.15
		KF(G) => (G - 273.15) * 9 / 5 + 32
		KR(G) => G * 1.8
		KN(G) => (G - 273.15) * 33 / 100
		KD(G) => (373.15 - G) * 3 / 2
		KL(G) => G - 20.15
		KW(G) => (G / 24.857191) - 21.81059
		KRO(G) => (G / 1.904762) - 135.90375
		KRE(G) => (G / 1.25) - 218.52

		; Rankine
		RC(G) => (G / 1.8) - 273.15
		RF(G) => G - 459.67
		RK(G) => G / 1.8
		RN(G) => (G / 1.8 - 273.15) * 33 / 100
		RD(G) => (671.67 - G) * 5 / 6
		RL(G) => (G / 1.8) - 20.15
		RW(G) => (G / 44.742943) - 21.81059
		RRO(G) => (G / 3.428571) - 135.90375
		RRE(G) => (G / 2.25) - 218.52

		; Newton
		NC(G) => G * 100 / 33
		NF(G) => (G * 60 / 11) + 32
		NK(G) => (G * 100 / 33) + 273.15
		NR(G) => (G * 100 / 33 + 273.15) * 1.8
		ND(G) => (33 - G) * 50 / 11
		NL(G) => (3.030303 * G) + 253
		NW(G) => (G / 8.202873) - 10.821818
		NRO(G) => (1.590909 * G) + 7.5
		NRE(G) => 2.424242 * G

		; Delisle
		DC(G) => 100 - (G * 2 / 3)
		DF(G) => 212 - (G * 6 / 5)
		DK(G) => 373.15 - (G * 2 / 3)
		DR(G) => 671.67 - (G * 6 / 5)
		DN(G) => 33 - (G * 11 / 50)
		DL(G) => (-G / 1.5) + 353
		DW(G) => (-G / 37.285786) - 6.798838
		DRO(G) => (-G / 2.857143) + 60
		DRE(G) => (-G / 1.875) + 80

		; Hooke
		HC(G) => (G * 12 / 5)

		; Leiden
		LC(G) => G - 253
		LF(G) => (1.8 * G) - 423.4
		LK(G) => G + 20.15
		LR(G) => (1.8 * G) + 36.27
		LN(G) => (G / 3.030303) - 83.49
		LD(G) => (-1.5 * G) + 529.5
		LW(G) => (G / 24.857191) - 21
		LRO(G) => (G / 1.904762) - 125.325
		LRE(G) => (G / 1.25) - 202.4

		; Wedgwood
		WC(G) => (24.857191 * G) + 269
		WF(G) => (44.742943 * G) + 516.2
		WK(G) => (24.857191 * G) + 542.15
		WR(G) => (44.742943 * G) + 975.87
		WD(G) => (-37.285786 * G) - 253.5
		WN(G) => (8.202873 * G) + 88.77
		WL(G) => (24.857191 * G) + 522
		WRO(G) => (13.050025 * G) + 148.725
		WRE(G) => (19.885753 * G) + 215.2

		; Romer
		ROC(G) => (1.904762 * G) - 14.285714
		ROF(G) => (3.428571 * G) + 6.285714
		ROK(G) => (1.904762 * G) + 258.864286
		ROR(G) => (3.428571 * G) + 465.955714
		RON(G) => (G / 1.590909) - 4.714286
		ROD(G) => (-2.857143 * G) + 171.428571
		ROL(G) => (1.904762 * G) + 238.7142861
		ROW(G) => (G / 13.050025) - 11.39653
		RORE(G) => (1.52381 * G) - 11.428571

		; Reaumur
		REC(G) => 1.25 * G
		REF(G) => (2.25 * G) + 32
		REK(G) => (1.25 * G) + 273.15
		RER(G) => (2.25 * G) + 491.67
		REN(G) => G / 2.424242
		RED(G) => (-1.875 * G) + 150
		REL(G) => (1.25 * G) + 253
		REW(G) => (G / 19.885753) - 10.821818
		RERO(G) => (G / 1.52381) + 7.5

		; Special Custom, Mercuric
		MEC(G) => (G / 100) * 395.56 - 38.83
		MEK(G) => (G / 100) * 395.56 + 234.32
		CME(G) => (G + 38.83) * 100 / 395.56
		KME(G) => (G - 234.32) * 100 / 395.56
	}

	static GetNumber(conversionLabel) {
		static validator := "v1234567890,.-'" GetChar("minus")
		static expression := "^[1234567890,.'\- " GetChar("minus") "]+$"

		numberValue := ""

		PH := InputHook("L0", "{Escape}")
		PH.Start()

		Loop {
			IH := InputHook("L1", "{Escape}{Backspace}")
			IH.Start(), IH.Wait()

			if (IH.EndKey = "Escape") {
				numberValue := ""
				break
			} else if (IH.EndKey = "Backspace") {
				if StrLen(numberValue) > 0
					numberValue := SubStr(numberValue, 1, -1)
			} else if InStr(validator, IH.Input) {
				if InStr(IH.Input, "v") {
					ClipWait(0.5, 1)
					if RegExMatch(A_Clipboard, expression) {
						numberValue .= A_Clipboard
					}
				} else
					numberValue .= IH.Input
			} else break

			CaretTooltip(conversionLabel " " numberValue)
		}

		ToolTip()

		PH.Stop()

		return numberValue
	}

	static PostFormatting(temperatureValue, scale, negativePoint := False, regionalType := "English") {
		chars := {
			numberSpace: GetChar(IniRead(ConfigFile, "CustomRules", "TemperatureCalcExtendedFormattingSpaceType", "thinspace")),
			degreeSpace: GetChar(IniRead(ConfigFile, "CustomRules", "TemperatureCalcSpaceType", "narrow_no_break_space")),
		}

		isDedicatedUnicodeChars := IniRead(ConfigFile, "Settings", "TemperatureCalcDedicatedUnicodeChars", "True") = "True"
		isExtendedFormattingEnabled := IniRead(ConfigFile, "Settings", "TemperatureCalcExtendedFormatting", "True") = "True"
		extendedFormattingFromCount := Integer(IniRead(ConfigFile, "CustomRules", "TemperatureCalcExtendedFormattingFrom", "5"))
		calcRoundValue := Integer(IniRead(ConfigFile, "CustomRules", "TemperatureCalcRoundValue", "2"))

		if !(GetKeyState("CapsLock", "T"))
			temperatureValue := Round(temperatureValue, Integer(calcRoundValue))

		if (Mod(temperatureValue, 1) = 0)
			temperatureValue := Round(temperatureValue)

		if (regionalType = "Russian" || regionalType = "Deutsch" || regionalType = "Switzerland-Comma")
			temperatureValue := RegExReplace(temperatureValue, "\.", ",")

		integerPart := RegExReplace(temperatureValue, "(\..*)|([,].*)", "")

		if (isExtendedFormattingEnabled && StrLen(integerPart) >= extendedFormattingFromCount) {
			decimalSeparators := Map(
				"English", ",",
				"Deutsch", ".",
				"Russian", chars.numberSpace,
				"Canada", chars.numberSpace,
				"Switzerland-Comma", GetChar("quote_right_single"),
				"Switzerland-Dot", GetChar("quote_right_single"),
			)

			integerPart := RegExReplace(integerPart, "\B(?=(\d{3})+(?!\d))", decimalSeparators[regionalType])
			temperatureValue := RegExReplace(temperatureValue, "^\d+", integerPart)
		}

		temperatureValue := (negativePoint ? GetChar("minus") : "") temperatureValue chars.degreeSpace (IsObject(this.scales.%scale%) ? (isDedicatedUnicodeChars ? this.scales.%scale%[1] : this.scales.%scale%[2]) : GetChar("degree") this.scales.%scale%)
		return temperatureValue
	}
}

favoriteCharsList := Map()

Class FavoriteChars {

	static favesPath := A_ScriptDir "/FavoriteChars.txt"

	static __New() {
		if !FileExist(this.favesPath) {
			FileAppend("", this.favesPath, "UTF-8")
		}

		this.UpdateVar()
	}

	static Add(fave) {
		fave := RegExReplace(fave, "^.*\s", "")

		newContent := ""
		alreadyExists := false

		for line in this.ReadList() {
			if line == fave {
				alreadyExists := true
			}
			newContent .= line "`n"
		}

		if !alreadyExists {
			newContent .= fave "`n"
		}

		FileDelete(this.favesPath)
		FileAppend(RTrim(newContent, "`n"), this.favesPath, "UTF-8")

		Sleep 100

		if !favoriteCharsList.Has(fave) {
			favoriteCharsList.Set(fave, True)
		}
	}

	static Remove(fave) {
		fave := RegExReplace(fave, "^.*\s", "")

		newContent := ""
		for line in this.ReadList() {
			if line != fave {
				newContent .= line "`n"
			}
		}

		FileDelete(this.favesPath)
		FileAppend(RTrim(newContent, "`n"), this.favesPath, "UTF-8")

		Sleep 100

		if favoriteCharsList.Has(fave) {
			favoriteCharsList.Delete(fave)
		}
	}

	static Check(fave) {
		fave := RegExReplace(fave, "^.*\s", "")

		for line in this.ReadList() {
			if line == fave {
				return True
			}
		}

		return False
	}

	static ReadList() {
		fileContent := FileRead(this.favesPath, "UTF-8")
		return StrSplit(fileContent, "`n", "`r")
	}

	static CheckVar(fave) {
		fave := RegExReplace(fave, "^.*\s", "")
		return favoriteCharsList.Has(fave)
	}

	static UpdateVar() {
		global favoriteCharsList
		faveList := FavoriteChars.ReadList()

		for fave in faveList {
			favoriteCharsList.Set(fave, True)
		}
	}
}

CaretTooltip(tooltipText) {
	if CaretGetPos(&x, &y)
		ToolTip(tooltipText, x, y + 20)
	else if CaretGetPosAlternative(&x, &y)
		ToolTip(tooltipText, x, y + 20)
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
					for j, entity in LocalEntitiesLibrary {
						if (Mod(j, 2) = 1 && entity = Symbol) {
							Output .= LocalEntitiesLibrary[j + 1]
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


Class Ligaturiser {

	__New(compositingMode := "InputBox") {
		this.compositingMode := compositingMode
		this.modifiedCharsType := GetModifiedCharsType()

		this.prompt := ConvertFromHexaDecimal(IniRead(ConfigFile, "LatestPrompts", "Ligature", ""))

		try {
			this.%this.compositingMode%Mode()
		} catch {
			if this.compositingMode = "InputBox"
				MsgBox(ReadLocale("warning_recipe_absent"), ReadLocale("symbol_smelting"), 0x30)
			else
				ShowInfoMessage("warning_recipe_absent", , , SkipGroupMessage, True)
		}
	}

	InputBoxMode() {
		IB := InputBox(ReadLocale("symbol_smelting_prompt"), ReadLocale("symbol_smelting"), "w256 h92", this.prompt)
		if IB.Result = "Cancel"
			return
		else
			this.prompt := IB.Value

		if this.prompt != "" {
			try {
				output := ""
				for prompt in StrSplit(this.prompt, " ") {
					output .= this.EntriesWalk(prompt, , True) " "
				}

				if output = "" || RegExMatch(output, "^\s+$")
					throw

				output := RegExReplace(output, "\s+$", "")
				this.SendOutput(RegExReplace(output, "#", ""))

				IniWrite(ConvertToHexaDecimal(SubStr(this.prompt, 1, 128)), ConfigFile, "LatestPrompts", "Ligature")
			} catch {
				throw
			}
		}

		return
	}

	ComposeMode() {

		output := ""
		input := ""
		previousInput := ""
		pastInput := ""
		tooltipSuggestions := ""
		favoriteSuggestions := this.ReadFavorites()
		favoriteSuggestions := favoriteSuggestions != "" ? ("`n" Chrs([0x2E3B, 10]) "`n" Chr(0x2605) " " ReadLocale("func_label_favorites") "`n" RegExReplace(favoriteSuggestions, ",\s+$", "") "`n" Chrs([0x2E3B, 10])) : ""

		pauseOn := False
		cleanPastInput := False

		PH := InputHook("L0", "{Escape}")
		PH.Start()

		CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input (favoriteSuggestions))

		Loop {

			IH := InputHook("L1", "{Escape}{Backspace}{Enter}{Pause}{Tab}")
			IH.Start(), IH.Wait()

			if (IH.EndKey = "Escape") {
				input := ""
				break

			} else if (IH.EndKey = "Pause") {
				pauseOn := pauseOn ? False : True

			} else if (IH.EndKey = "Backspace") {
				if StrLen(input) > 0
					input := SubStr(input, 1, -1)

			} else if IH.Input != "" {
				input .= IH.Input

				if interceptionInputMode != "" && StrLen(input) > 1 {
					charPair := StrLen(input) > 2 && previousInput = "\" ? pastInput previousInput IH.Input : previousInput IH.Input
					telexChar := AsianInterceptionInput.TelexReturn(charPair)

					if telexChar != charPair {
						input := SubStr(input, 1, previousInput = "\" ? -3 : -2) telexChar
						cleanPastInput := True
					}
				}

				pastInput := previousInput
				previousInput := IH.Input
			}

			if cleanPastInput {
				pastInput := ""
				previousInput := ""
				cleanPastInput := False
			}

			tooltipSuggestions := input != "" ? this.FormatSuggestions(this.EntriesWalk(input, True)) : ""


			CaretTooltip((pauseOn ? Chr(0x23F8) : Chr(0x2B1C)) " " input (favoriteSuggestions) ((StrLen(tooltipSuggestions) > 0 && !RegExMatch(input, "^\(\~\)\s")) ? "`n" tooltipSuggestions : ""))

			if !pauseOn || (IH.EndKey = "Enter") {
				try {
					intermediateValue := this.EntriesWalk(RegExReplace(input, "^\(\~\)\s", ""), , RegExMatch(input, "^\(\~\)\s"))
					if intermediateValue != "" {
						output := intermediateValue
						break
					}
				}
			}
		}

		PH.Stop()

		if output = "N/A" {
			CaretTooltip(Chr(0x26A0) " " ReadLocale("warning_recipe_absent"))
			SetTimer(Tooltip, -1000)

		} else {
			CaretTooltip(Chr(0x2705) " " input " " Chr(0x2192) " " this.FormatSingleString(output))
			SetTimer(Tooltip, -500)
			this.SendOutput(RegExReplace(output, "#", ""))
		}
		return
	}

	SendOutput(output) {
		if StrLen(output) > 36
			ClipSend(output)
		else
			SendText(output)
	}

	EntriesWalk(prompt, getSuggestions := False, breakSkip := False) {
		promptBackup := prompt
		output := ""

		promptValidator := RegExEscape(prompt)
		breakValidate := True
		monoCaseRecipe := False

		charFound := False

		for validatingValue in RecipeValidatorArray {
			if (RegExMatch(validatingValue, "^" promptValidator)) {
				breakValidate := False
				break
			}
		}

		if breakValidate {
			for validatingValue in RecipeValidatorArray {
				if (RegExMatch(StrLower(validatingValue), "^" StrLower(promptValidator))) {
					monoCaseRecipe := True
					breakValidate := False
					break
				}
			}
		}

		if breakValidate && !breakSkip
			return "N/A"

		for characterEntry, value in Characters {
			if !HasProp(value, "recipe") || (HasProp(value, "recipe") && value.recipe == "") {
				continue
			} else {
				recipe := value.recipe

				if IsObject(recipe) {
					for _, recipeEntry in recipe {
						if (getSuggestions && RegExMatch(recipeEntry, "^" RegExEscape(prompt))) || (!monoCaseRecipe && prompt == recipeEntry) || (monoCaseRecipe && prompt = recipeEntry) {
							charFound := True

							if getSuggestions {
								output .= this.GetRecipesString(value)

							} else {
								output := this.GetComparedChar(value)
								break 2
							}
						}
					}
				} else if (getSuggestions && RegExMatch(recipe, "^" RegExEscape(prompt))) || (!monoCaseRecipe && prompt == recipe) || (monoCaseRecipe && prompt = recipe) {
					charFound := True

					if getSuggestions {
						output .= this.GetRecipesString(value)

					} else {
						output := this.GetComparedChar(value)
						break
					}
				}
			}
		}

		if !charFound {
			IntermediateValue := prompt
			for characterEntry, value in Characters {
				if !HasProp(value, "recipe") || (HasProp(value, "recipe") && value.recipe == "") {
					continue
				} else {
					recipe := value.recipe

					if IsObject(recipe) {
						for _, recipeEntry in recipe {
							if InStr(IntermediateValue, recipeEntry, true) {
								IntermediateValue := StrReplace(IntermediateValue, recipeEntry, this.GetComparedChar(value))
							}
						}
					} else {
						if InStr(IntermediateValue, recipe, true) {
							IntermediateValue := StrReplace(IntermediateValue, recipe, this.GetComparedChar(value))
						}
					}
				}
			}

			if IntermediateValue != prompt {
				output := IntermediateValue
				charFound := True
			}
		}

		return output
	}

	ReadFavorites() {
		output := ""

		getList := FavoriteChars.ReadList()

		for line in getList {
			if StrLen(line) > 0 {
				characterEntry := GetCharacterEntry(line)

				if !HasProp(characterEntry, "recipe") || (HasProp(characterEntry, "recipe") && characterEntry.recipe == "") {
					continue
				} else {
					output .= this.GetRecipesString(characterEntry)
				}
			}
		}

		if StrLen(output) > 0 {
			output := this.FormatSuggestions(output)
		}

		return output
	}

	FormatSuggestions(suggestions, maxLength := 72) {
		if suggestions = "N/A"
			return suggestions

		output := ""
		currentLine := ""
		parts := StrSplit(suggestions, "), ")

		uniqueParts := []
		for index, part in parts {
			part := part ")"

			isUnique := true
			for uniquePart in uniqueParts {
				if (part == uniquePart) {
					isUnique := false
					break
				}
			}

			if StrLen(part) > 2 && (isUnique) {
				uniqueParts.Push(part)
			}
		}

		for part in uniqueParts {
			if (StrLen(currentLine) + StrLen(part) + 2 <= maxLength) {
				currentLine .= part ", "
			} else {
				output .= currentLine "`n"
				currentLine := part ", "
			}
		}

		if (currentLine != "") {
			output .= currentLine
		}

		output := RegExReplace(output, ",\s$", "")

		return output
	}


	FormatSingleString(str, maxLength := 32) {
		return StrLen(str) > maxLength ? "[ " SubStr(str, 1, maxLength) " " Chr(0x2026) " ]" : str
	}

	GetRecipesString(value) {
		output := ""

		recipe := HasProp(value, "recipeAlt") ? value.recipeAlt : value.recipe
		uniSequence := this.FormatSingleString(this.GetUniChar(value, True))

		if IsObject(recipe) {
			intermediateValue := ""

			for _, recipeEntry in recipe {
				intermediateValue .= " " recipeEntry " |"
			}

			output .= uniSequence " (" RegExReplace(intermediateValue, "(^\s|\s\|$)", "") "), "
		} else {
			output .= uniSequence " (" recipe "), "
		}

		return output
	}

	GetComparedChar(value) {
		output := ""
		if InputMode = "HTML" && HasProp(value, "html") {
			output :=
				(this.modifiedCharsType && HasProp(value, this.modifiedCharsType "HTML")) ? value.%this.modifiedCharsType%HTML :
					(value.HasProp("entity") ? value.entity : value.html)

		} else if InputMode = "LaTeX" && HasProp(value, "LaTeX") {
			output := IsObject(value.LaTeX) ? (LaTeXMode = "Math" ? value.LaTeX[2] : value.LaTeX[1]) : value.LaTeX

		} else {
			output := this.GetUniChar(value)
		}
		return output
	}

	GetUniChar(value, forceDefault := False) {
		output := ""
		if this.modifiedCharsType && HasProp(value, this.modifiedCharsType "Form") && !forceDefault {
			if IsObject(value.%this.modifiedCharsType%Form) {
				TempValue := ""
				for modifier in value.%this.modifiedCharsType%Form {
					TempValue .= PasteUnicode(modifier)
				}
				output := TempValue
			} else {
				output := PasteUnicode(value.%this.modifiedCharsType%Form)
			}
		} else if HasProp(value, "uniSequence") && IsObject(value.uniSequence) {
			for unicode in value.uniSequence {
				output .= PasteUnicode(unicode)
			}
		} else {
			output := PasteUnicode(value.unicode)
		}
		return output
	}
}

Global interceptionInputMode := ""

Class AsianInterceptionInput {

	static vietNam := Map(
		"aa", Chr(0x00E2),
		"AA", Chr(0x00C2),
		"af", Chr(0x00E0),
		"AF", Chr(0x00C0),
		"as", Chr(0x00E1),
		"AS", Chr(0x00C1),
		"aw", Chr(0x0103),
		"AW", Chr(0x0102),
		"ax", Chr(0x00E3),
		"AX", Chr(0x00C3),
		"aj", Chr(0x1EA1),
		"AJ", Chr(0x1EA0),
		"ar", Chr(0x1EA3),
		"AR", Chr(0x1EA2),
		;
		"ăf", Chr(0x1EB1), ; ằ
		"ĂF", Chr(0x1EB0), ; Ằ
		"ăj", Chr(0x1EB7),
		"ĂJ", Chr(0x1EB6),
		"ăr", Chr(0x1EB3),
		"ĂR", Chr(0x1EB2),
		;
		"dd", Chr(0x0111),
		"DD", Chr(0x0110),
		;
		"ee", Chr(0x00EA),
		"EE", Chr(0x00CA),
		"ef", Chr(0x00E8),
		"EF", Chr(0x00C8),
		"es", Chr(0x00E9),
		"ES", Chr(0x00C9),
		"ex", Chr(0x1EBD),
		"EX", Chr(0x1EBC),
		"ej", Chr(0x1EB9),
		"EJ", Chr(0x1EB8),
		"er", Chr(0x1EBB),
		"ER", Chr(0x1EBA),
		;
		"if", Chr(0x00EC),
		"IF", Chr(0x00CC),
		"is", Chr(0x00ED),
		"IS", Chr(0x00CD),
		"ix", Chr(0x0129),
		"IX", Chr(0x0128),
		"ij", Chr(0x1ECB),
		"IJ", Chr(0x1ECA),
		"ir", Chr(0x1EC9),
		"IR", Chr(0x1EC8),
		;
		"oo", Chr(0x00F4),
		"OO", Chr(0x00D4),
		"of", Chr(0x00F2),
		"OF", Chr(0x00D2),
		"os", Chr(0x00F3),
		"OS", Chr(0x00D3),
		"ow", Chr(0x01A1),
		"OW", Chr(0x01A0),
		"ox", Chr(0x00F5),
		"OX", Chr(0x00D5),
		"oj", Chr(0x1ECD),
		"OJ", Chr(0x1ECC),
		"or", Chr(0x1ECF),
		"OR", Chr(0x1ECE),
		;
		"uf", Chr(0x00F9),
		"UF", Chr(0x00D9),
		"us", Chr(0x00FA),
		"US", Chr(0x00DA),
		"uw", Chr(0x01B0),
		"UW", Chr(0x01AF),
		"ux", Chr(0x0169),
		"UX", Chr(0x0168),
		"uj", Chr(0x1EE5),
		"UJ", Chr(0x1EE4),
		"ur", Chr(0x1EE7),
		"UR", Chr(0x1EE6),
		;
	)

	static pinYin := Map(
		"aa", Chr(0x0101),
		"AA", Chr(0x0100),
		"af", Chr(0x00E0),
		"AF", Chr(0x00C0),
		"as", Chr(0x00E1),
		"AS", Chr(0x00C1),
		"av", Chr(0x01CE),
		"AV", Chr(0x01CD),
		;
		"ee", Chr(0x0113),
		"EE", Chr(0x0112),
		"ef", Chr(0x00E8),
		"EF", Chr(0x00C8),
		"es", Chr(0x00E9),
		"ES", Chr(0x00C9),
		"ev", Chr(0x011B),
		"EV", Chr(0x011A),
		;
		"ii", Chr(0x012B),
		"II", Chr(0x012A),
		"if", Chr(0x00EC),
		"IF", Chr(0x00CC),
		"is", Chr(0x00ED),
		"IS", Chr(0x00CD),
		"iv", Chr(0x01D0),
		"IV", Chr(0x01CF),
		;
		"oo", Chr(0x014D),
		"OO", Chr(0x014C),
		"of", Chr(0x00F2),
		"OF", Chr(0x00D2),
		"os", Chr(0x00F3),
		"OS", Chr(0x00D3),
		"ov", Chr(0x01D2),
		"OV", Chr(0x01D1),
		;
		"uu", Chr(0x016B),
		"UU", Chr(0x016A),
		"uf", Chr(0x00F9),
		"UF", Chr(0x00D9),
		"us", Chr(0x00FA),
		"US", Chr(0x00DA),
		"uv", Chr(0x01D4),
		"UV", Chr(0x01D3),
	)

	static karaShiki := Map(
		"ее", Chrs(0x0451, 0x0304),
		"ЕЕ", Chrs(0x0401, 0x0304),
		"ии", Chr(0x04E3),
		"ИИ", Chr(0x04E3),
		"оо", Chrs(0x043E, 0x0304),
		"ОО", Chrs(0x041E, 0x0304),
		"сс", Chr(0x04AB),
		"СС", Chr(0x04AA),
		"уу", Chr(0x04EF),
		"УУ", Chr(0x04EE),
		"уй", Chr(0x045E),
		"УЙ", Chr(0x040E),
		"юю", Chrs(0x044E, 0x0304),
		"ЮЮ", Chrs(0x042E, 0x0304),
	)

	__New(mode := "vietNam") {
		this.mode := mode
		this.RegistryHotstrings(mode)
	}

	RegistryHotstrings(mode) {
		global interceptionInputMode

		previousMode := interceptionInputMode

		interceptionInputMode := (mode != interceptionInputMode ? mode : "")
		isEnabled := (interceptionInputMode != "" ? True : False)

		if previousMode != "" && isEnabled {
			for key, value in AsianInterceptionInput.%previousMode% {
				HotString(":*C?:" key, "", False)
				HotString(":*C?:" SubStr(key, 1, 1) "\" SubStr(key, 2), "", False)
			}
		}

		for key, value in AsianInterceptionInput.%this.mode% {
			HotString(":*C?:" key, ObjBindMethod(AsianInterceptionInput, "Telexiser", value), isEnabled ? True : False)
			HotString(":*C?:" SubStr(key, 1, 1) "\" SubStr(key, 2), ObjBindMethod(AsianInterceptionInput, "Telexiser", value), isEnabled ? True : False)
		}

		ShowInfoMessage(SetStringVars((ReadLocale("script_mode_" (isEnabled ? "" : "de") "activated")), ReadLocale("script_" this.mode)), , , SkipGroupMessage, True, True)
	}

	static Telexiser(_, input) {
		input := RegExReplace(input, "^.*?:.*?:", "")

		if InStr(input, "\") {
			SendText(RegExReplace(input, "\\", ""))
			return
		}

		for key, value in AsianInterceptionInput.%interceptionInputMode% {
			if (input == key) {

				SendText(value)
				break
			}
		}
		return ""
	}

	static TelexReturn(input) {
		output := input

		for key, value in AsianInterceptionInput.%interceptionInputMode% {
			if (input == key) {
				output := value
				break
			} else if InStr(input, "\") && (key == (SubStr(input, 1, 1) SubStr(input, 3))) {
				output := key
				break
			}
		}
		return output
	}
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
	;if GetKeyState("Ctrl", "P")
	SetTimer((*) => Send("{Ctrl Up}"), -250)
	Sleep 500
	A_Clipboard := BackupClipboard

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

RegExEscape(str) {
	static specialChars := "\.-*+?^${}()[]|/"

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
		"SymblCC", "https://symbl.cc/" GetLanguageCode() "/" PromptValue,
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

ContainsEmoji(StringInput) {
	EmojisPattern := "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{1F700}-\x{1F77F}\x{1F900}-\x{1F9FF}\x{2700}-\x{27BF}\x{1F1E6}-\x{1F1FF}]"
	return RegExMatch(StringInput, EmojisPattern)
}


AlphabetCoverage := ["pl", "ro", "es"]
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

	LanguageCode := GetLanguageCode()

	DSLPadGUI := Gui()

	DSLTabs := []
	DSLCols := { default: [], smelting: [] }

	for _, localeKey in ["diacritics", "spaces", "smelting", "fastkeys", "scripts", "commands", "about", "useful", "changelog"] {
		DSLTabs.Push(ReadLocale("tab_" . localeKey))
	}

	for _, localeKey in ["name", "key", "view", "unicode", "entryid", "entry_title"] {
		DSLCols.default.Push(ReadLocale("col_" . localeKey))
	}

	for _, localeKey in ["name", "recipe", "result", "unicode", "entryid", "entry_title"] {
		DSLCols.smelting.Push(ReadLocale("col_" . localeKey))
	}

	DSLContent := {}
	DSLContent[] := Map()
	DSLContent["BindList"] := {}

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
		alert: "x655 y333 w190 h40 readonly Center -VScroll -HScroll -E0x200",
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
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Custom Composes", ReadLocale("symbol_custom_compose"), True, "Recipes")

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
							: (groupName = "Special Fast") ? ReadLocale("symbol_special_key")
								: ""

		BlackList := groupName = "Spaces" ? ["emsp13", "emsp14", "emsp16", "narrow_no_break_space"] : []
		FastSpecial := groupName = "Special Fast" ? True : False

		InsertCharactersGroups(DSLContent["BindList"].TabFastKeys, groupName, GroupHotKey, AddSeparator, InsertingOption, BlackList)
	}

	DSLContent["BindList"].TabGlagoKeys := []

	AltLayouts := [
		"Fake GlagoRunes", RightControl " 1",
		"Futhark Runes", ReadLocale("symbol_futhark"),
		"Futhork Runes", ReadLocale("symbol_futhork"),
		"Younger Futhark Runes", ReadLocale("symbol_futhark_younger"),
		"Almanac Runes", ReadLocale("symbol_futhark_almanac"),
		"Later Younger Futhark Runes", ReadLocale("symbol_futhark_younger_later"),
		"Medieval Runes", ReadLocale("symbol_medieval_runes"),
		"Runic Punctuation", ReadLocale("symbol_runic_punctuation"),
		"Glagolitic Letters", ReadLocale("symbol_glagolitic"),
		"Cyrillic Diacritics", "",
		"Fake TurkoPermic", RightControl " 2",
		"Old Turkic", ReadLocale("symbol_turkic"),
		"Old Turkic Orkhon", ReadLocale("symbol_turkic_orkhon"),
		"Old Turkic Yenisei", ReadLocale("symbol_turkic_yenisei"),
		"Runic Punctuation", ReadLocale("symbol_runic_punctuation"),
		"Old Permic", ReadLocale("symbol_permic"),
		"Fake Hungarian", RightControl " 3",
		"Old Hungarian", ReadLocale("symbol_hungarian"),
		"Runic Punctuation", ReadLocale("symbol_runic_punctuation"),
		"Fake Gothic", RightControl " 4",
		"Gothic Alphabet", ReadLocale("symbol_gothic"),
		"Runic Punctuation", ReadLocale("symbol_runic_punctuation"),
		"Fake IPA", RightControl " 0",
		"IPA", ReadLocale("symbol_ipa"),
		"Fake Math", RightControl RightShift " 0",
		"Mathematical", ReadLocale("symbol_maths"),
		"Math", "",
		"Math Spaces", "",
	]

	for i, groupName in AltLayouts {
		if Mod(i, 2) = 1 {
			AddSeparator := (groupName = "Fake GlagoRunes" || groupName = "Futhark Runes" || groupName = "Old Turkic" || groupName = "Old Turkic Orkhon" || groupName = "Old Hungarian" || groupName = "Gothic Alphabet" || groupName = "IPA" || groupName = "Mathematical") ? False : True
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

	Command_controls := CommandsTree.Add(ReadLocale("func_label_controls"))
	Command_disable := CommandsTree.Add(ReadLocale("func_label_disable"))
	Command_gotopage := CommandsTree.Add(ReadLocale("func_label_gotopage"))
	Command_selgoto := CommandsTree.Add(ReadLocale("func_label_selgoto"))
	Command_copylist := CommandsTree.Add(ReadLocale("func_label_favorites"))
	Command_copylist := CommandsTree.Add(ReadLocale("func_label_copylist"))
	Command_tagsearch := CommandsTree.Add(ReadLocale("func_label_tagsearch"))
	Command_uninsert := CommandsTree.Add(ReadLocale("func_label_uninsert"))
	Command_altcode := CommandsTree.Add(ReadLocale("func_label_altcode"))
	Command_smelter := CommandsTree.Add(ReadLocale("func_label_smelter"), , "Expand")
	Command_compose := CommandsTree.Add(ReadLocale("func_label_compose"), Command_smelter)
	Command_num_superscript := CommandsTree.Add(ReadLocale("func_label_num_superscript"))
	Command_num_roman := CommandsTree.Add(ReadLocale("func_label_num_roman"))
	Command_fastkeys := CommandsTree.Add(ReadLocale("func_label_fastkeys"))
	Command_extralayouts := CommandsTree.Add(ReadLocale("func_label_scripts"))
	Command_glagokeys := CommandsTree.Add(ReadLocale("func_label_glagolitic_futhark"), Command_extralayouts)
	Command_oldturkic := CommandsTree.Add(ReadLocale("func_label_old_permic_old_turkic"), Command_extralayouts)
	Command_oldhungary := CommandsTree.Add(ReadLocale("func_label_old_hungarian"), Command_extralayouts)
	Command_gothic := CommandsTree.Add(ReadLocale("func_label_gothic"), Command_extralayouts)
	Command_func_label_maths := CommandsTree.Add(ReadLocale("func_label_maths"), Command_extralayouts)
	Command_func_label_ipa := CommandsTree.Add(ReadLocale("func_label_ipa"), Command_extralayouts)
	Command_alterations := CommandsTree.Add(ReadLocale("func_label_alterations"))
	Command_alterations_combining := CommandsTree.Add(ReadLocale("func_label_alterations_combining"), Command_alterations)
	Command_alterations_modifier := CommandsTree.Add(ReadLocale("func_label_alterations_modifier"), Command_alterations)
	Command_alterations_italic_to_bold := CommandsTree.Add(ReadLocale("func_label_alterations_italic_to_bold"), Command_alterations)
	Command_alterations_fraktur_script_struck := CommandsTree.Add(ReadLocale("func_label_alterations_fraktur_script_struck"), Command_alterations)
	Command_alterations_sans_serif := CommandsTree.Add(ReadLocale("func_label_alterations_sans_serif"), Command_alterations)
	Command_alterations_monospace := CommandsTree.Add(ReadLocale("func_label_alterations_monospace"), Command_alterations)
	Command_inputtoggle := CommandsTree.Add(ReadLocale("func_label_input_toggle"))
	Command_layouttoggle := CommandsTree.Add(ReadLocale("func_label_layout_toggle"))
	Command_notifs := CommandsTree.Add(ReadLocale("func_label_notifications"))
	Command_textprocessing := CommandsTree.Add(ReadLocale("func_label_text_processing"))
	Command_tp_paragraph := CommandsTree.Add(ReadLocale("func_label_tp_paragraph"), Command_textprocessing)
	Command_tp_grep := CommandsTree.Add(ReadLocale("func_label_tp_grep"), Command_textprocessing)
	Command_tp_quotes := CommandsTree.Add(ReadLocale("func_label_tp_quotes"), Command_textprocessing)
	Command_tp_html := CommandsTree.Add(ReadLocale("func_label_tp_html"), Command_textprocessing)
	Command_tp_unicode := CommandsTree.Add(ReadLocale("func_label_tp_unicode"), Command_textprocessing)
	Command_lcoverage := CommandsTree.Add(ReadLocale("func_label_coverage"))


	for coverage in AlphabetCoverage {
		CommandsTree.Add(ReadLocale("func_label_coverage_" coverage), Command_lcoverage)
	}


	DSLPadGUI.SetFont("s9")

	BtnAutoLoad := DSLPadGUI.Add("Button", "x577 y527 w200 h32", ReadLocale("autoload_add"))
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
			SetStringVars(ReadLocale("update_available"), UpdateVersionString) ' (<a href="' RepoSource '">GitHub</a>)'
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
		'<a href="https://github.com/DemerNkardaz/DSL-KeyPad">' ReadLocale("about_repository") '</a>'
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

	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , ReadLocale("typography"))
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", ReadLocale("typography_layout"))
	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , ReadLocale("unicode_resources"))
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", '<a href="https://symbl.cc/">Symbl.cc</a> <a href="https://www.compart.com/en/unicode/">Compart</a>')
	DSLPadGUI.SetFont("s13")
	DSLPadGUI.Add("Text", , ReadLocale("dictionaries"))
	DSLPadGUI.SetFont("s11")
	DSLPadGUI.Add("Link", "w600", ReadLocale("dictionaries_japanese") '<a href="https://yarxi.ru">ЯРКСИ</a> <a href="https://www.warodai.ruu">Warodai</a>')
	DSLPadGUI.Add("Link", "w600", ReadLocale("dictionaries_chinese") '<a href="https://bkrs.info">БКРС</a>')
	DSLPadGUI.Add("Link", "w600", ReadLocale("dictionaries_vietnamese") '<a href="https://chunom.org">Chữ Nôm</a>')

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

HasPermicFont := IsFont("Noto Sans Old Permic") ? True : "Noto Sans Old Permic"
HasHungarianFont := IsFont("Noto Sans Old Hungarian") ? True : "Noto Sans Old Hungarian"

SetCharacterInfoPanel(EntryIDKey, EntryNameKey, TargetGroup, PreviewObject, PreviewTitle, PreviewLaTeX, PreviewLaTeXPackage, PreviewAlt, PreviewUnicode, PreviewHTML, PreviewTags, PreviewGroupTitle, PreviewGroup, PreviewAlert := "") {
	LanguageCode := GetLanguageCode()
	if (EntryNameKey != "" && EntryIDKey != "") {
		GetEntry := Characters[EntryIDKey " " EntryNameKey]

		characterTitle := ""
		if (HasProp(GetEntry, "titlesAlt") && GetEntry.titlesAlt == True && !InStr(ReadLocale(EntryNameKey "_alt", "chars"), "NOT FOUND")) {
			characterTitle := ReadLocale(EntryNameKey . "_alt", "chars")
		} else if !InStr(ReadLocale(EntryNameKey, "chars"), "NOT FOUND") {
			characterTitle := ReadLocale(EntryNameKey, "chars")
		} else if (HasProp(GetEntry, "titlesAltOnEntry")) {
			characterTitle := GetEntry.titlesAltOnEntry[LanguageCode]
		} else if (HasProp(GetEntry, "titles") &&
		(!HasProp(GetEntry, "titlesAlt") || HasProp(GetEntry, "titlesAlt") && GetEntry.titlesAlt == True)) {
			characterTitle := GetEntry.titles[LanguageCode]
		} else {
			characterTitle := ReadLocale(EntryNameKey, "chars")
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

		EntryString := ReadLocale("entry") ": " EntryNameKey
		TagsString := ""
		if (HasProp(GetEntry, "tags")) {
			TagsString := ReadLocale("tags") . ": "

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
				GroupTitle .= GetChar("dotted_circle") Chr(value[2]) " "
			}
		}


		TargetGroup[PreviewGroupTitle].Text := GroupTitle (IsDiacritic ? ReadLocale("character_combining") : ReadLocale("character"))

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
			TargetGroup[PreviewAlert].Text := SetStringVars(ReadLocale("warning_nofont"), HasPermicFont)
		}
		else if RegExMatch(EntryNameKey, "^hungarian") && HasHungarianFont = "Noto Sans Old Hungarian" {
			TargetGroup[PreviewAlert].Text := SetStringVars(ReadLocale("warning_nofont"), HasHungarianFont)
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
		"func_label_glagolitic_futhark",
		"func_label_old_permic_old_turkic",
		"func_label_old_hungarian",
		"func_label_gothic",
		"func_label_maths",
		"func_label_ipa",
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
		if (ReadLocale(label) = SelectedLabel) {
			TargetTextBox.Text := ReadLocale(label . "_description")
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
	LanguageCode := GetLanguageCode()
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
	LanguageCode := GetLanguageCode()
	global FastKeysIsActive, ActiveScriptName, ConfigFile
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
		RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
	}
	ManageTrayItems()
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

HandleFastKey(combo := "", characterNames*) {
	isLayoutValid := CheckLayoutValid()

	if isLayoutValid {
		output := ""

		for _, character in characterNames {
			output .= GetCharacterSequence(character)
		}
		SendInput(output)

	} else {
		if combo != "" {
			Send(ConvertComboKeys(combo))
		}
	}
	return
}

GetCharacterEntry(CharacterName) {
	for characterEntry, value in Characters {
		entryID := ""
		entryName := ""
		if RegExMatch(characterEntry, "^\s*(\d+)\s+(.+)", &match) {
			entryID := match[1]
			entryName := match[2]

			if entryName == CharacterName {
				return value
			}
		}
	}
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
				"Flat:<^>!<!<+>+", "zero_width_space",
				"Flat:<!", "emsp13",
				;"Flat:<+", "emsp14",
				"Flat:>+", "emsp16",
				"Flat:<+>+", "narrow_no_break_space",
			),
		)
		SpecialsSlots := GetLayoutImprovedCyrillic([
			"noequals", MapMerge(GetModifiers("<^>!"), KeySeqSlot["="]),
			"almostequals", MapMerge(GetModifiers("<^>!<+>+"), KeySeqSlot["="]),
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
			"1", Map("Flat:<!", "section", "Flat:<^>!", "inverted_exclamation", "Flat:<^>!<+", "double_exclamation_question", "Flat:<^>!>+", "double_exclamation", "Caps:<^>!<+>+", ["interrobang_inverted", "interrobang"]),
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
			"=", Map("<^>!", "noequals", "<^>!<+>+", "almostequals", "<^>!<+", "plusminus"),
			"-", Map("<^>!>+", "hyphenation_point"),
			"/", Map("<^>!", "ellipsis", "<^>!<+", "tricolon", "<^>!<+>+", "quartocolon", "<!", "two_dot_punctuation", "<^>!>+", "fraction_slash"),
		)
		LettersSlots := GetLayoutImprovedCyrillic([
			["cyr_c_let_fita", "cyr_s_let_fita"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["A"]),
			["cyr_c_let_i", "cyr_s_let_i"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["B"]),
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
			["cyr_c_let_dzelo", "cyr_s_let_dzelo"], MapMerge(GetModifiers("<^>!"), KeySeqSlot["P"]),
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
			"A", Map("<!", ["lat_c_let_a_acute", "lat_s_let_a_acute"],
			"<^>!", ["lat_c_let_a_breve", "lat_s_let_a_breve"],
			"<^>!<!", ["lat_c_let_a_circumflex", "lat_s_let_a_circumflex"],
			"<^>!<!<+", ["lat_c_let_a_ring_above", "lat_s_let_a_ring_above"],
			"<^>!<!>+", ["lat_c_let_a_ogonek", "lat_s_let_a_ogonek"],
			"<^>!>+", ["lat_c_let_a_macron", "lat_s_let_a_macron"],
			"<^>!<+", ["lat_c_let_a_diaeresis", "lat_s_let_a_diaeresis"],
			"<^>!<+>+", ["lat_c_let_a_tilde", "lat_s_let_a_tilde"],
			">+", ["lat_c_let_a_grave", "lat_s_let_a_grave"],
			"<+>+", ["lat_c_let_a_grave_double", "lat_s_let_a_grave_double"]),
			"B", Map(
				"<^>!", ["lat_c_let_b_dot_above", "lat_s_let_b_dot_above"],
				"<^>!<!", ["lat_c_let_b_dot_below", "lat_s_let_b_dot_below"],
				"<^>!<!<+", ["lat_c_let_b_flourish", "lat_s_let_b_flourish"],
				"<^>!<+", ["lat_c_let_b_stroke_short", "lat_s_let_b_stroke_short"],
				"<^>!>+", ["lat_c_let_b_common_hook", "lat_s_let_b_common_hook"]),
			"C", Map("<!", ["lat_c_let_c_acute", "lat_s_let_c_acute"],
			"<^>!", ["lat_c_let_c_dot_above", "lat_s_let_c_dot_above"],
			"<^>!<!", ["lat_c_let_c_circumflex", "lat_s_let_c_circumflex"],
			"<^>!<!<+", ["lat_c_let_c_caron", "lat_s_let_c_caron"],
			"<^>!<!>+", ["lat_c_let_c_cedilla", "lat_s_let_c_cedilla"],
			"Flat:>+", "celsius"),
			"D", Map(
				"<^>!", ["lat_c_let_d_eth", "lat_s_let_d_eth"],
				"<^>!<!", ["lat_c_let_d_stroke_short", "lat_s_let_d_stroke_short"],
				"<^>!<!<+", ["lat_c_let_d_caron", "lat_s_let_d_caron"],
				"<^>!<!>+", ["lat_c_let_d_cedilla", "lat_s_let_d_cedilla"],
				"<^>!<+>+", ["lat_c_let_d_circumflex_below", "lat_s_let_d_circumflex_below"]),
			"E", Map("<!", ["lat_c_let_e_acute", "lat_s_let_e_acute"],
			"<^>!", ["lat_c_let_e_breve", "lat_s_let_e_breve"],
			"<^>!<!", ["lat_c_let_e_circumflex", "lat_s_let_e_circumflex"],
			"<^>!<!<+", ["lat_c_let_e_caron", "lat_s_let_e_caron"],
			"<^>!<!>+", ["lat_c_let_e_ogonek", "lat_s_let_e_ogonek"],
			"<^>!>+", ["lat_c_let_e_macron", "lat_s_let_e_macron"],
			"<^>!<+", ["lat_c_let_e_diaeresis", "lat_s_let_e_diaeresis"],
			"<^>!<+>+", ["lat_c_let_e_tilde", "lat_s_let_e_tilde"],
			">+", ["lat_c_let_e_grave", "lat_s_let_e_grave"],
			"<+>+", ["lat_c_let_e_grave_double", "lat_s_let_e_grave_double"]),
			"F", Map(
				"<^>!", ["lat_c_let_f_dot_above", "lat_s_let_f_dot_above"],
				"Flat:>+", "fahrenheit"),
			"G", Map("<!", ["lat_c_let_g_acute", "lat_s_let_g_acute"],
			"<^>!", ["lat_c_let_g_breve", "lat_s_let_g_breve"],
			"<^>!<!", ["lat_c_let_g_circumflex", "lat_s_let_g_circumflex"],
			"<^>!<!<+", ["lat_c_let_g_caron", "lat_s_let_g_caron"],
			"<^>!<!>+", ["lat_c_let_g_cedilla", "lat_s_let_g_cedilla"],
			"<^>!<+", ["lat_c_let_g_insular", "lat_s_let_g_insular"],
			"<^>!>+", ["lat_c_let_g_macron", "lat_s_let_g_macron"],
			"<^>!<+>+", ["lat_c_let_gamma", "lat_s_let_gamma"]),
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
				"<^>!<!", ["lat_c_let_j_circumflex", "lat_s_let_j_circumflex"],
				"<^>!<!<+", ["lat_c_let_j", "lat_s_let_j_caron"],),
			"K", Map("<!", ["lat_c_let_k_acute", "lat_s_let_k_acute"],
			"<^>!<!", ["lat_c_let_k_dot_below", "lat_s_let_k_dot_below"],
			"<^>!<!<+", ["lat_c_let_k_caron", "lat_s_let_k_caron"],
			"<^>!<!>+", ["lat_c_let_k_cedilla", "lat_s_let_k_cedilla"],
			"Flat:>+", "kelvin"),
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
				"<^>!>+", ["lat_c_let_q_common_hook", "lat_s_let_q_common_hook"]),
			"R", Map("<!", ["lat_c_let_r_acute", "lat_s_let_r_acute"],
			"<^>!", ["lat_c_let_r_dot_above", "lat_s_let_r_dot_above"],
			"<^>!<!", ["lat_c_let_r_dot_below", "lat_s_let_r_dot_below"],
			"<^>!<!<+", ["lat_c_let_r_caron", "lat_s_let_r_caron"],
			"<^>!<!>+", ["lat_c_let_r_cedilla", "lat_s_let_r_cedilla"],
			"<^>!>+", ["lat_c_let_r_rotunda", "lat_s_let_r_rotunda"],
			"<+>+", ["lat_c_let_r_grave_double", "lat_s_let_r_grave_double"]),
			"S", Map("<!", ["lat_c_let_s_acute", "lat_s_let_s_acute"],
			"<^>!", ["lat_c_let_s_comma_below", "lat_s_let_s_comma_below"],
			"<^>!<!", ["lat_c_let_s_circumflex", "lat_s_let_s_circumflex"],
			"<^>!<!<+", ["lat_c_let_s_caron", "lat_s_let_s_caron"],
			"<^>!<!>+", ["lat_c_let_s_cedilla", "lat_s_let_s_cedilla"],
			"<^>!>+", "lat_s_let_s_long",
			"<^>!<+>+", ["lat_c_let_s_esh", "lat_s_let_s_esh"],
			"<^>!<+", ["lat_c_lig_eszett", "lat_s_lig_eszett"]),
			"T", Map(
				"<^>!", ["lat_c_let_t_comma_below", "lat_s_let_t_comma_below"],
				"<^>!<!", ["lat_c_let_t_dot_below", "lat_s_let_t_dot_below"],
				"<^>!<!<+", ["lat_c_let_t_caron", "lat_s_let_t_caron"],
				"<^>!<!>+", ["lat_c_let_t_cedilla", "lat_s_let_t_cedilla"],
				"<^>!>+", ["lat_c_let_thorn", "lat_s_let_thorn"],
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
			"<^>!>+", ["lat_c_let_wynn", "lat_s_let_wynn"],
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
		LayoutArray := ArrayMerge(
			GetBindingsArray(, SlotModdedDiacritics),
			GetBindingsArray(, SlotModdedQuotes, QuotesSlots),
			GetBindingsArray(, SlotModdedSpaces, SpacesSlots),
			GetBindingsArray(, SlotModdedSpecials, SpecialsSlots),
			GetBindingsArray(, SlotModdedDashes, DashesSlots),
			GetBindingsArray(, SlotModdedLetters, LettersSlots),
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
				),*/
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
			["cyr_c_let_и", "cyr_s_let_и"], KeySeqSlot["B"],
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
			["cyr_c_let_e", "cyr_s_let_e"], KeySeqSlot["T"],
			["cyr_c_let_g", "cyr_s_let_g"], KeySeqSlot["U"],
			["cyr_c_let_m", "cyr_s_let_m"], KeySeqSlot["V"],
			["cyr_c_let_ts", "cyr_s_let_ts"], KeySeqSlot["W"],
			["cyr_c_let_ch", "cyr_s_let_ch"], KeySeqSlot["X"],
			["cyr_c_let_n", "cyr_s_let_n"], KeySeqSlot["Y"],
			["cyr_c_let_ya", "cyr_s_let_ya"], KeySeqSlot["Z"],
			["cyr_c_let_b", "cyr_s_let_b"], KeySeqSlot[","],
			["cyr_c_let_yu", "cyr_s_let_yu"], KeySeqSlot["."],
			["cyr_c_let_zh", "cyr_s_let_zh"], KeySeqSlot[";"],
			["cyr_c_let_э", "cyr_s_let_э"], KeySeqSlot["'"],
			["cyr_c_let_h", "cyr_s_let_h"], KeySeqSlot["["],
			["cyr_c_let_yeru", "cyr_s_let_yeru"], MapMerge(GetModifiers("D:<!"), KeySeqSlot["]"]),
			["cyr_c_let_yo", "cyr_s_let_yo"], KeySeqSlot["~"],
			"kkey_1", KeySeqSlot["1"],
			"kkey_2", KeySeqSlot["2"],
			"kkey_3", KeySeqSlot["3"],
			"kkey_4", KeySeqSlot["4"],
			"kkey_5", KeySeqSlot["5"],
			"kkey_6", KeySeqSlot["6"],
			"kkey_7", KeySeqSlot["7"],
			"kkey_8", KeySeqSlot["8"],
			"kkey_9", KeySeqSlot["9"],
			"kkey_0", KeySeqSlot["0"],
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
				LatinLayout = "Dvorak" ? "," : "W", ["cyr_c_let_i", "cyr_s_let_i"],
				LatinLayout = "Dvorak" ? "J" : "C", ["cyr_c_let_yat", "cyr_s_let_yat"]
			)
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
			"1", "kkey_1",
			"2", "kkey_2",
			"3", "kkey_3",
			"4", "kkey_4",
			"5", "kkey_5",
			"6", "kkey_6",
			"7", "kkey_7",
			"8", "kkey_8",
			"9", "kkey_9",
			"0", "kkey_0",
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
			"S", Map("<^>!>+", "lat_s_let_s_esh"),
			"U", Map("<^>!<!", ["lat_c_let_upsilon", "lat_s_let_upsilon"]),
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
			"<+" UseKey["9"], "Off",
			"<+" UseKey["0"], "Off",
			"<+" UseKey["Equals"], "Off",
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
			"<#<!" UseKey["F"], (*) => SearchKey(),
			"<#<!" UseKey["U"], (*) => CharacterInserter("Unicode").InputDialog(),
			"<#<!" UseKey["A"], (*) => CharacterInserter("Altcode").InputDialog(),
			"<#<!" UseKey["L"], (*) => Ligaturiser(),
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
			"<^>!" UseKey["F2"], (*) => AsianInterceptionInput(),
			"<^>!>+" UseKey["F2"], (*) => AsianInterceptionInput("pinYin"),
			"<^>!<+" UseKey["F2"], (*) => AsianInterceptionInput("karaShiki"),
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
			"<#<!" UseKey["ArrUp"], (*) => ChangeScriptInput("sup"),
			"<#<!" UseKey["ArrDown"], (*) => ChangeScriptInput("sub"),
			">^" UseKey["1"], (*) => ToggleLetterScript(, "Glagolitic Futhark"),
			">^" UseKey["2"], (*) => ToggleLetterScript(, "Old Turkic Old Permic"),
			">^" UseKey["3"], (*) => ToggleLetterScript(, "Old Hungarian"),
			">^" UseKey["4"], (*) => ToggleLetterScript(, "Gothic"),
			">^" UseKey["0"], (*) => ToggleLetterScript(, "IPA"),
			">^" UseKey["9"], (*) => ToggleLetterScript(, "Maths"),
			;
			"RAlt", (*) => ProceedCompose(),
			;"RCtrl", (*) => ProceedCombining(),
			;"RShift", (*) => ProceedModifiers(),
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
		Ligaturiser("Compose")
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
		ShowInfoMessage("message_" ModeName, , , SkipGroupMessage, True)
	} else {
		RegisterLayout(IniRead(ConfigFile, "Settings", "LatinLayout", "QWERTY"))
		ShowInfoMessage("message_" ModeName "_disabled", , , SkipGroupMessage, True)
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
	LanguageCode := GetLanguageCode()
	Muting := Mute ? " Mute" : ""
	Ico := MessageIcon == "Info" ? "Iconi" :
		MessageIcon == "Warning" ? "Icon!" :
			MessageIcon == "Error" ? "Iconx" : 0x0
	TrayTip(NoReadLocale ? MessagePost : ReadLocale(MessagePost), MessageTitle, Ico . Muting)

}

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
		"custom_compose", ReadLocale("tray_func_custom_compose"),
		"custom_compose_update", ReadLocale("tray_func_custom_compose_update"),
		"exit", ReadLocale("tray_func_exit") "`t" LeftControl RightShift "Esc",
		"panel", ReadLocale("tray_func_panel") "`t" Window LeftAlt "Home",
		"install", ReadLocale("tray_func_install"),
		"search", ReadLocale("tray_func_search") "`t" Window LeftAlt "F",
		"open_folder", ReadLocale("tray_func_open_folder"),
		"smelter", ReadLocale("tray_func_smelter") "`t" Window LeftAlt "L",
		"unicode", ReadLocale("tray_func_unicode") "`t" Window LeftAlt "U",
		"altcode", ReadLocale("tray_func_altcode") "`t" Window LeftAlt "A",
		"notif", ReadLocale("tray_func_notif") "`t" Window LeftAlt "M",
		"disable", ReadLocale("tray_func_disable") "`t" RightControl "F10",
		"enable", ReadLocale("tray_func_enable") "`t" RightControl "F10",
		"glagolitic", ReadLocale("tray_func_glagolitic_runic") "`t" RightControl "1",
		"turkic", ReadLocale("tray_func_tukic_permic") "`t" RightControl "2",
		"hungarian", ReadLocale("tray_func_hungarian") "`t" RightControl "3",
		"gothic", ReadLocale("tray_func_gothic") "`t" RightControl "4",
		"maths", ReadLocale("tray_func_maths") "`t" RightControl "9",
		"ipa", ReadLocale("tray_func_ipa") "`t" RightControl "0",
		"script", ReadLocale("func_label_scripts"),
		"layouts", ReadLocale("func_label_layouts"),
		"alterations", ReadLocale("func_label_alterations"),
		"combining_alteration", ReadLocale("tray_func_combining_alteration") "`t" LeftControl LeftAlt "Num1",
		"modifier_alteration", ReadLocale("tray_func_modifier_alteration") "`t" LeftControl LeftAlt LeftShift "Num1",
		"subscript_alteration", ReadLocale("tray_func_subscript_alteration") "`t" LeftControl LeftAlt RightShift "Num1",
		"italic_alteration", ReadLocale("tray_func_italic_alteration") "`t" LeftControl LeftAlt "Num2",
		"bold_alteration", ReadLocale("tray_func_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num2",
		"italic_bold_alteration", ReadLocale("tray_func_italic_bold_alteration") "`t" LeftControl LeftAlt RightShift "Num2",
		"fraktur_alteration", ReadLocale("tray_func_fraktur_alteration") "`t" LeftControl LeftAlt "Num3",
		"fraktur_bold_alteration", ReadLocale("tray_func_fraktur_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num3",
		"script_alteration", ReadLocale("tray_func_script_alteration") "`t" LeftControl LeftAlt "Num4",
		"script_bold_alteration", ReadLocale("tray_func_script_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num4",
		"double_struck_alteration", ReadLocale("tray_func_double_struck_alteration") "`t" LeftControl LeftAlt "Num5",
		"double_struck_italic_alteration", ReadLocale("tray_func_double_struck_italic_alteration") "`t" LeftControl LeftAlt LeftShift "Num5",
		"sans_serif_italic_alteration", ReadLocale("tray_func_sans_serif_italic_alteration") "`t" LeftControl LeftAlt "Num6",
		"sans_serif_bold_alteration", ReadLocale("tray_func_sans_serif_bold_alteration") "`t" LeftControl LeftAlt LeftShift "Num6",
		"sans_serif_italic_bold_alteration", ReadLocale("tray_func_sans_serif_italic_bold_alteration") "`t" LeftControl LeftAlt RightShift "Num6",
		"sans_serif_alteration", ReadLocale("tray_func_sans_serif_alteration") "`t" LeftControl LeftAlt LeftShift RightShift "Num6",
		"monospace_alteration", ReadLocale("tray_func_monospace_alteration") "`t" LeftControl LeftAlt "Num7",
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

	ScriptsSubMenu := Menu()
	ScriptsSubMenu.Add(Labels["glagolitic"], (*) => ToggleLetterScript(, "Glagolitic Futhark"))
	ScriptsSubMenu.Add(Labels["turkic"], (*) => ToggleLetterScript(, "Old Turkic Old Permic"))
	ScriptsSubMenu.Add(Labels["hungarian"], (*) => ToggleLetterScript(, "Old Hungarian"))
	ScriptsSubMenu.Add(Labels["gothic"], (*) => ToggleLetterScript(, "Gothic"))
	ScriptsSubMenu.Add(Labels["ipa"], (*) => ToggleLetterScript(, "IPA"))
	ScriptsSubMenu.Add(Labels["maths"], (*) => ToggleLetterScript(, "Maths"))

	ScriptsSubMenu.SetIcon(Labels["glagolitic"], InternalFiles["AppIcoDLL"].File, 2)
	ScriptsSubMenu.SetIcon(Labels["turkic"], InternalFiles["AppIcoDLL"].File, 4)
	ScriptsSubMenu.SetIcon(Labels["hungarian"], InternalFiles["AppIcoDLL"].File, 6)
	ScriptsSubMenu.SetIcon(Labels["gothic"], InternalFiles["AppIcoDLL"].File, 7)
	ScriptsSubMenu.SetIcon(Labels["maths"], InternalFiles["AppIcoDLL"].File, 10)
	ScriptsSubMenu.SetIcon(Labels["ipa"], InternalFiles["AppIcoDLL"].File, 8)

	DSLTray.Add(Labels["script"], ScriptsSubMenu)

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

	DSLTray.Add(Labels["alterations"], AlterationSubMenu)

	LayoutsSubMenu := Menu()
	LayoutsSubMenu.Add("QWERTY", (*) => RegisterLayout("QWERTY"))
	LayoutsSubMenu.Add("Dvorak", (*) => RegisterLayout("Dvorak"))
	LayoutsSubMenu.Add("Colemak", (*) => RegisterLayout("Colemak"))
	LayoutsSubMenu.Add()
	LayoutsSubMenu.Add("ЙЦУКЕН", (*) => RegisterLayout("ЙЦУКЕН"))
	LayoutsSubMenu.Add("Диктор", (*) => RegisterLayout("Диктор"))
	LayoutsSubMenu.Add("ЙІУКЕН (1907)", (*) => RegisterLayout("ЙІУКЕН (1907)"))

	DSLTray.Add(Labels["layouts"], LayoutsSubMenu)

	DSLTray.Add()
	DSLTray.Add(Labels["search"], (*) => SearchKey())
	DSLTray.Add(Labels["unicode"], (*) => CharacterInserter("Unicode").InputDialog(False))
	DSLTray.Add(Labels["altcode"], (*) => CharacterInserter("Altcode").InputDialog(False))
	DSLTray.Add(Labels["smelter"], (*) => Ligaturiser())
	DSLTray.Add(Labels["open_folder"], OpenScriptFolder)
	DSLTray.Add()
	DSLTray.Add(Labels["notif"], (*) => ToggleGroupMessage())
	DSLTray.Add()
	DSLTray.Add(Labels["reload"], ReloadApplication)
	DSLTray.Add(Labels["config"], OpenConfigFile)
	DSLTray.Add(Labels["locale"], OpenLocalesFile)
	DSLTray.Add()
	DSLTray.Add(Labels["custom_compose"], OpenRecipesFile)
	DSLTray.Add(Labels["custom_compose_update"], UpdateCustomRecipes)
	DSLTray.Add()
	if DisabledAllKeys {
		DSLTray.Add(Labels["enable"], (*) => DisableAllKeys())
		DSLTray.SetIcon(Labels["enable"], InternalFiles["AppIcoDLL"].File, 9)
	} else {

		DSLTray.Add(Labels["disable"], (*) => DisableAllKeys())
		DSLTray.SetIcon(Labels["disable"], InternalFiles["AppIcoDLL"].File, 9)
	}
	DSLTray.Add()
	DSLTray.Add(Labels["exit"], ExitApplication)
	DSLTray.Add()

	DSLTray.SetIcon(Labels["panel"], InternalFiles["AppIco"].File)
	DSLTray.SetIcon(Labels["search"], ImageRes, 169)
	DSLTray.SetIcon(Labels["unicode"], Shell32, 225)
	DSLTray.SetIcon(Labels["altcode"], Shell32, 313)
	DSLTray.SetIcon(Labels["smelter"], ImageRes, 151)
	DSLTray.SetIcon(Labels["open_folder"], ImageRes, 180)
	DSLTray.SetIcon(Labels["notif"], ImageRes, 016)
	DSLTray.SetIcon(Labels["reload"], ImageRes, 229)
	DSLTray.SetIcon(Labels["config"], ImageRes, 065)
	DSLTray.SetIcon(Labels["locale"], ImageRes, 015)
	DSLTray.SetIcon(Labels["custom_compose"], ImageRes, 188)
	DSLTray.SetIcon(Labels["custom_compose_update"], ImageRes, 268)
	DSLTray.SetIcon(Labels["exit"], ImageRes, 085)

}

ManageTrayItems()

ShowInfoMessage("tray_app_started")

<^>+Esc:: ExitApp

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

;
; Caret get from https://www.autohotkey.com/boards/viewtopic.php?t=114802

CaretGetPosAlternative(&x?, &y?) {
	static OBJID_CARET := 0xFFFFFFF8
	CoordMode 'Caret'
	if !CaretGetPos(&x, &y) {
		AccObject := AccObjectFromWindow(WinExist('A'), OBJID_CARET)
		Pos := AccLocation(AccObject)
		try x := Pos.x, y := Pos.y
		if !(x && y) {
			Pos := UIA_CaretPos()
			try x := Pos.x, y := Pos.y
		}
	}
	Return !!(x && y)
}

UIA_CaretPos() {
	static CLSID_CUIAutomation8 := '{E22AD333-B25F-460C-83D0-0581107395C9}'
		, IID_IUIAutomation2 := '{34723AFF-0C9D-49D0-9896-7AB52DF8CD8A}'
		, IUIA := ComObject(CLSID_CUIAutomation8, IID_IUIAutomation2)
		, TextPatternElement2 := 10024

	try {
		ComCall(8, IUIA, 'ptr*', &FocusedEl := 0) ; GetFocusedElement
		ComCall(16, FocusedEl, 'int', TextPatternElement2, 'ptr*', &TextPattern2 := 0) ; GetCurrentPattern
		if TextPattern2 {
			ComCall(10, TextPattern2, 'int*', 1, 'ptr*', &caretRange := 0) ; GetCaretRange
			ComCall(10, caretRange, 'ptr*', &boundingRects := 0) ; GetBoundingRectangles
			ObjRelease(FocusedEl), ObjRelease(TextPattern2), ObjRelease(caretRange)
			Rect := ComValue(0x2005, boundingRects)
			if Rect.MaxIndex() = 3
				return { X: Round(Rect[0]), Y: Round(Rect[1]), W: Round(Rect[2]), H: Round(Rect[3]) }
		}
	}
}

AccObjectFromWindow(hWnd, idObject := 0) {
	static IID_IDispatch := '{00020400-0000-0000-C000-000000000046}'
		, IID_IAccessible := '{618736E0-3C3D-11CF-810C-00AA00389B71}'
		, OBJID_NATIVEOM := 0xFFFFFFF0, VT_DISPATCH := 9, F_OWNVALUE := 1
		, h := DllCall('LoadLibrary', 'Str', 'Oleacc', 'Ptr')

	idObject &= 0xFFFFFFFF, AccObject := 0
	DllCall('Ole32\CLSIDFromString', 'Str', idObject = OBJID_NATIVEOM ? IID_IDispatch : IID_IAccessible, 'Ptr', CLSID := Buffer(16))
	if DllCall('Oleacc\AccessibleObjectFromWindow', 'Ptr', hWnd, 'UInt', idObject, 'Ptr', CLSID, 'PtrP', &pAcc := 0) = 0
		AccObject := ComObjFromPtr(pAcc), ComObjFlags(AccObject, F_OWNVALUE, F_OWNVALUE)
	return AccObject
}

AccLocation(Acc, ChildId := 0, &Position := '') {
	static type := (VT_BYREF := 0x4000) | (VT_I4 := 3)
	x := Buffer(4, 0), y := Buffer(4, 0), w := Buffer(4, 0), h := Buffer(4, 0)
	try Acc.accLocation(ComValue(type, x.Ptr), ComValue(type, y.Ptr),
	ComValue(type, w.Ptr), ComValue(type, h.Ptr), ChildId)
	catch
		return
	return { x: NumGet(x, 'int'), y: NumGet(y, 'int'), w: NumGet(w, 'int'), h: NumGet(h, 'int') }
}
;
;
;
;
;


;
; Code parts get from https://github.com/Axlefublr/lib-v2/tree/main


ClipSend(toSend, endChar := "", isClipReverted := true, untilRevert := 300) {
	if isClipReverted
		prevClip := ClipboardAll()

	A_Clipboard := ""
	A_Clipboard := toSend endChar
	ClipWait(1)
	Send("{Shift Down}{Insert}{Shift Up}")

	if isClipReverted
		SetTimer(() => A_Clipboard := prevClip, -untilRevert)
}


GetInput(options?, endKeys?) {
	inputHookObject := InputHook(options?, endKeys?)
	inputHookObject.Start()
	inputHookObject.Wait()
	return inputHookObject
}

_ArrayToString(this, char := ", ") {
	for index, value in this {
		if index = this.Length {
			str .= value
			break
		}
		str .= value char
	}
	return str
}

_ArrayHasValue(this, valueToFind) {
	for index, value in this {
		if value = valueToFind
			return true
	}
	return false
}

;
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
