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
	http.Send()
	http.WaitForResponse()

	if http.Status != 200 {
		MsgBox(ErrMessages[GetLanguageCode()] "`nHTTP Status: " http.Status, DSLPadTitle)
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
	http.Send()
	http.WaitForResponse()

	if http.Status != 200 {
		MsgBox(ErrMessages[GetLanguageCode()] "`nHTTP Status: " http.Status, DSLPadTitle)
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
InputMode := "Default"
LaTeXMode := "common"

DefaultConfig := [
	["Settings", "FastKeysIsActive", "False"],
	["Settings", "SkipGroupMessage", "False"],
	["Settings", "InputMode", "Default"],
	["Settings", "ScriptInput", "Default"],
	["Settings", "UserLanguage", ""],
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
	http.Send()
	http.WaitForResponse()

	if (http.Status != 200) {
		MsgBox("Can’t download font.`nHTTP Status: " http.Status, "Font Installer")
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
		return
	}

	for language, url in ChangeLogRaw {
		http.Open("GET", url, true)
		http.Send()
		http.WaitForResponse()

		if http.Status != 200 || Cancelled {
			if Cancelled
				http.Abort()
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

	for language, _ in Changes {
		IsEmpty := False
		break
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
			content := RegExReplace(content, "m)^\s\s\s- (.*)", "   ⁃ $1")
			content := RegExReplace(content, "m)^---", " " . GetChar("emdash×84"))

			TargetGUI.Add("Edit", "x30 y58 w810 h485 readonly Left Wrap -HScroll -E0x200", content)
		}
	}
}

GetTimeString() {
	return FormatTime(A_Now, "yyyy-MM-dd_HH-mm-ss")
}

GetUpdate(TimeOut := 0, RepairMode := False) {
	Sleep TimeOut
	global AppVersion, RawSource

	if RepairMode == True {
		IB := InputBox(ReadLocale("update_repair"), ReadLocale("update_repair_title"), "w256", "")
		if IB.Result = "Cancel" || IB.Value != "y" {
			return
		}
	}

	if UpdateAvailable || RepairMode == True {
		http := ComObject("WinHttp.WinHttpRequest.5.1")
		http.Open("GET", RawSource, true)
		http.Send()
		http.WaitForResponse()

		if http.Status != 200 {
			MsgBox(ReadLocale("update_failed") "`nHTTP Status: " http.Status, DSLPadTitle)
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
		FileDelete(UpdateFilePath)
		MsgBox(ReadLocale("update_absent"), DSLPadTitle)
	}
	return
}


CheckUpdate() {
	global AppVersion, RawSource, UpdateAvailable, UpdateVersionString
	http := ComObject("WinHttp.WinHttpRequest.5.1")
	http.Open("GET", RawSource, true)
	http.Send()
	http.WaitForResponse()

	if http.Status != 200 {
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

SCKeys := Map(
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
	"Space", "SC039",
	"Tab", "SC00F",
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
	"5", "SC006",
	"6", "SC007",
	"7", "SC008",
	"8", "SC009",
	"9", "SC00A",
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
)


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

GetMapCount(MapObj, SortGroups := "") {
	if !IsObject(SortGroups) {
		return MapObj.Count
	} else {
		keyCount := 0
		for characterEntry, value in MapObj {
			for group in SortGroups {
				groupsEntry := value.group[1]

				if IsObject(groupsEntry) {
					for subGroup in groupsEntry {
						if IsObject(subGroup) {
							for nestedGroup in subGroup {
								if (nestedGroup = group) {
									keyCount++
									break
								}
							}
						} else if (subGroup = group) {
							keyCount++
							break
						}
					}
				} else if (groupsEntry = group) {
					keyCount++
					break
				}
			}
		}

		return keyCount
	}
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
		symbol: DottedCircle Chr(0x0301),
		symbolCustom: "s72",
		symbolFont: "Cambria"
	},
		"acute_double", {
			unicode: "{U+030B}", html: "&#779;",
			tags: ["double acute", "двойной акут", "двойное ударение"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["A", "Ф"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x030B),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"acute_below", {
			unicode: "{U+0317}", html: "&#791;",
			tags: ["acute below", "акут снизу"],
			group: ["Diacritics Secondary", ["a", "ф"]],
			symbol: DottedCircle Chr(0x0317),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"acute_tone_vietnamese", {
			unicode: "{U+0341}", html: "&#833;",
			tags: ["acute tone", "акут тона"],
			group: ["Diacritics Secondary", ["A", "Ф"]],
			symbol: DottedCircle Chr(0x0341),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"asterisk_above", {
			unicode: "{U+20F0}", html: "&#8432;",
			tags: ["asterisk above", "астериск сверху"],
			group: ["Diacritics Tertiary", ["a", "ф"]],
			symbol: DottedCircle Chr(0x20F0),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"asterisk_below", {
			unicode: "{U+0359}", html: "&#857;",
			tags: ["asterisk below", "астериск снизу"],
			group: ["Diacritics Tertiary", ["A", "Ф"]],
			symbol: DottedCircle Chr(0x0359),
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
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0306),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"breve_inverted", {
			unicode: "{U+0311}", html: "&#785;",
			tags: ["inverted breve", "перевёрнутое бреве", "перевёрнутая кратка"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["B", "И"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0311),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"breve_below", {
			unicode: "{U+032E}", html: "&#814;",
			tags: ["breve below", "бреве снизу", "кратка снизу"],
			group: ["Diacritics Secondary", ["b", "и"]],
			symbol: DottedCircle Chr(0x032E),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"breve_inverted_below", {
			unicode: "{U+032F}", html: "&#815;",
			tags: ["inverted breve below", "перевёрнутое бреве снизу", "перевёрнутая кратка снизу"],
			group: ["Diacritics Secondary", ["B", "И"]],
			symbol: DottedCircle Chr(0x032F),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"bridge_above", {
			unicode: "{U+0346}", html: "&#838;",
			tags: ["bridge above", "мостик сверху"],
			group: ["Diacritics Tertiary", ["b", "и"]],
			symbol: DottedCircle Chr(0x0346),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"bridge_below", {
			unicode: "{U+032A}", html: "&#810;",
			tags: ["bridge below", "мостик снизу"],
			group: ["Diacritics Tertiary", ["B", "И"]],
			symbol: DottedCircle Chr(0x032A),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"bridge_inverted_below", {
			unicode: "{U+033A}", html: "&#825;",
			tags: ["inverted bridge below", "перевёрнутый мостик снизу"],
			group: ["Diacritics Tertiary", CtrlB],
			symbol: DottedCircle Chr(0x033A),
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
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0302),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"caron", {
			unicode: "{U+030C}", html: "&#780;",
			LaTeX: "\v",
			tags: ["caron", "hachek", "карон", "гачек"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["C", "С"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x030C),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"circumflex_below", {
			unicode: "{U+032D}", html: "&#813;",
			tags: ["circumflex below", "циркумфлекс снизу"],
			group: ["Diacritics Secondary", ["c", "с"]],
			symbol: DottedCircle Chr(0x032D),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"caron_below", {
			unicode: "{U+032C}", html: "&#812;",
			tags: ["caron below", "карон снизу", "гачек снизу"],
			group: ["Diacritics Secondary", ["C", "С"]],
			symbol: DottedCircle Chr(0x032C),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"cedilla", {
			unicode: "{U+0327}", html: "&#807;",
			LaTeX: "\c",
			tags: ["cedilla", "седиль"],
			group: [["Diacritics Tertiary", "Diacritics Fast Secondary"], ["c", "с"]],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0327),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above", {
			unicode: "{U+0313}", html: "&#787;",
			tags: ["comma above", "запятая сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], [",", "б"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0313),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_below", {
			unicode: "{U+0326}", html: "&#806;",
			tags: ["comma below", "запятая снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["<", "Б"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0326),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above_turned", {
			unicode: "{U+0312}", html: "&#786;",
			tags: ["turned comma above", "перевёрнутая запятая сверху"],
			group: ["Diacritics Secondary", [",", "б"]],
			symbol: DottedCircle Chr(0x0312),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above_reversed", {
			unicode: "{U+0314}", html: "&#788;",
			tags: ["reversed comma above", "зеркальная запятая сверху"],
			group: [["Diacritics Secondary", "Diacritics Fast Secondary"], ["<", "Б"]],
			symbol: DottedCircle Chr(0x0314),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"comma_above_right", {
			unicode: "{U+0315}", html: "&#789;",
			tags: ["comma above right", "запятая сверху справа"],
			group: [["Diacritics Tertiary", "Diacritics Fast Secondary"], [",", "б"]],
			symbol: DottedCircle Chr(0x0315),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"candrabindu", {
			unicode: "{U+0310}", html: "&#784;",
			tags: ["candrabindu", "карон снизу"],
			group: ["Diacritics Tertiary", ["C", "С"]],
			symbol: DottedCircle Chr(0x0310),
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
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0307),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"diaeresis", {
			unicode: "{U+0308}", html: "&#776;",
			LaTeX: ["\" . QuotationDouble, "\ddot"],
			tags: ["diaeresis", "диерезис"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["D", "В"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0308),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"dot_below", {
			unicode: "{U+0323}", html: "&#803;",
			tags: ["dot below", "точка снизу"],
			group: ["Diacritics Secondary", ["d", "в"]],
			symbol: DottedCircle Chr(0x0323),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"diaeresis_below", {
			unicode: "{U+0324}", html: "&#804;",
			tags: ["diaeresis below", "диерезис снизу"],
			group: ["Diacritics Secondary", ["D", "В"]],
			symbol: DottedCircle Chr(0x0324),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"fermata", {
			unicode: "{U+0352}", html: "&#850;",
			tags: ["fermata", "фермата"],
			group: [["Diacritics Tertiary", "Diacritics Fast Primary"], ["F", "А"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0352),
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
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0300),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"grave_double", {
			unicode: "{U+030F}", html: "&#783;",
			tags: ["double grave", "двойной гравис"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["G", "П"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x030F),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"grave_below", {
			unicode: "{U+0316}", html: "&#790;",
			tags: ["grave below", "гравис снизу"],
			group: ["Diacritics Secondary", ["g", "п"]],
			symbol: DottedCircle Chr(0x0316),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"grave_tone_vietnamese", {
			unicode: "{U+0340}", html: "&#832;",
			tags: ["grave tone", "гравис тона"],
			group: ["Diacritics Secondary", ["G", "П"]],
			symbol: DottedCircle Chr(0x0340),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"hook_above", {
			unicode: "{U+0309}", html: "&#777;",
			tags: ["hook above", "хвостик сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["h", "р"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0309),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"horn", {
			unicode: "{U+031B}", html: "&#795;",
			tags: ["horn", "рожок"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["H", "Р"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x031B),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"palatal_hook_below", {
			unicode: "{U+0321}", html: "&#801;",
			tags: ["palatal hook below", "палатальный крюк"],
			group: ["Diacritics Secondary", ["h", "р"]],
			symbol: DottedCircle Chr(0x0321),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"retroflex_hook_below", {
			unicode: "{U+0322}", html: "&#802;",
			tags: ["retroflex hook below", "ретрофлексный крюк"],
			group: ["Diacritics Secondary", ["H", "Р"]],
			symbol: DottedCircle Chr(0x0322),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		"macron", {
			unicode: "{U+0304}", html: "&#772;",
			tags: ["macron", "макрон"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["m", "ь"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0304),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"macron_below", {
			unicode: "{U+0331}", html: "&#817;",
			tags: ["macron below", "макрон снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["M", "Ь"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0331),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ogonek", {
			unicode: "{U+0328}", html: "&#808;",
			tags: ["ogonek", "огонэк"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["o", "щ"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0328),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ogonek_above", {
			unicode: "{U+1DCE}", html: "&#7630;",
			tags: ["ogonek above", "огонэк сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["O", "Щ"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x1DCE)
		},
		"overline", {
			unicode: "{U+0305}", html: "&#773;",
			tags: ["overline", "черта сверху"],
			group: ["Diacritics Secondary", ["o", "щ"]],
			symbol: DottedCircle Chr(0x0305),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"overline_double", {
			unicode: "{U+033F}", html: "&#831;",
			tags: ["overline", "черта сверху"],
			group: ["Diacritics Secondary", ["O", "Щ"]],
			symbol: DottedCircle Chr(0x033F),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"low_line", {
			unicode: "{U+0332}", html: "&#818;",
			tags: ["low line", "черта снизу"],
			group: ["Diacritics Tertiary", ["o", "щ"]],
			symbol: DottedCircle Chr(0x0332),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"low_line_double", {
			unicode: "{U+0333}", html: "&#819;",
			tags: ["dobule low line", "двойная черта снизу"],
			group: ["Diacritics Tertiary", ["O", "Щ"]],
			symbol: DottedCircle Chr(0x0333),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ring_above", {
			unicode: "{U+030A}", html: "&#778;",
			tags: ["ring above", "кольцо сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["r", "к"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x030A),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ring_below", {
			unicode: "{U+0325}", html: "&#805;",
			tags: ["ring below", "кольцо снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["R", "К"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0325),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"ring_below_double", {
			unicode: "{U+035A}", html: "&#858;",
			tags: ["double ring below", "двойное кольцо снизу"],
			group: ["Diacritics Primary", CtrlR],
			symbol: DottedCircle Chr(0x035A),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical", {
			unicode: "{U+030D}", html: "&#781;",
			tags: ["vertical line", "вертикальная черта"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["v", "м"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x030D),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical_double", {
			unicode: "{U+030E}", html: "&#782;",
			tags: ["double vertical line", "двойная вертикальная черта"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["V", "М"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x030E),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical_below", {
			unicode: "{U+0329}", html: "&#809;",
			tags: ["vertical line below", "вертикальная черта снизу"],
			group: ["Diacritics Secondary", ["v", "м"]],
			symbol: DottedCircle Chr(0x0329),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"line_vertical_double_below", {
			unicode: "{U+0348}", html: "&#840;",
			tags: ["dobule vertical line below", "двойная вертикальная черта снизу"],
			group: ["Diacritics Secondary", ["V", "М"]],
			symbol: DottedCircle Chr(0x0348),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"stroke_short", {
			unicode: "{U+0335}", html: "&#821;",
			tags: ["short stroke", "короткое перечёркивание"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], ["s", "ы"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0335),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"stroke_long", {
			unicode: "{U+0336}", html: "&#822;",
			tags: ["long stroke", "длинное перечёркивание"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], ["S", "Ы"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0336),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"solidus_short", {
			unicode: "{U+0337}", html: "&#823;",
			tags: ["short solidus", "короткая косая черта"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], "\"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[/]",
			symbol: DottedCircle Chr(0x0337),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"solidus_long", {
			unicode: "{U+0338}", html: "&#824;",
			tags: ["long solidus", "длинная косая черта"],
			group: [["Diacritics Quatemary", "Diacritics Fast Primary"], "/"],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0338),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde", {
			unicode: "{U+0303}", html: "&#771;",
			tags: ["tilde", "тильда"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["t", "е"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0303),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_vertical", {
			unicode: "{U+033E}", html: "&#830;",
			tags: ["tilde vertical", "вертикальная тильда"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["T", "Е"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x033E),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_below", {
			unicode: "{U+0330}", html: "&#816;",
			tags: ["tilde below", "тильда снизу"],
			group: ["Diacritics Secondary", ["t", "е"]],
			symbol: DottedCircle Chr(0x0330),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_not", {
			unicode: "{U+034A}", html: "&#842;",
			tags: ["not tilde", "перечёрнутая тильда"],
			group: ["Diacritics Secondary", ["T", "Е"]],
			symbol: DottedCircle Chr(0x034A),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"tilde_overlay", {
			unicode: "{U+0334}", html: "&#820;",
			tags: ["tilde overlay", "тильда посередине"],
			group: ["Diacritics Quatemary", ["t", "е"]],
			symbol: DottedCircle Chr(0x0334),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"x_above", {
			unicode: "{U+033D}", html: "&#829;",
			tags: ["x above", "x сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["x", "ч"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x033D),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"x_below", {
			unicode: "{U+0353}", html: "&#851;",
			tags: ["x below", "x снизу"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["X", "Ч"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x0353),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		"zigzag_above", {
			unicode: "{U+035B}", html: "&#859;",
			tags: ["zigzag above", "зигзаг сверху"],
			group: [["Diacritics Primary", "Diacritics Fast Primary"], ["z", "я"]],
			show_on_fast_keys: True,
			symbol: DottedCircle Chr(0x035B),
			symbolCustom: "s72",
			symbolFont: "Cambria"
		},
		;
		;
		; ? Шпации
		"space", {
			unicode: "{U+0020}", html: "&#32;",
			symbol: Chr(0x0020)
		},
		"emsp", {
			unicode: "{U+2003}", html: "&#8195;", entity: "&emsp;",
			tags: ["em space", "emspace", "emsp", "круглая шпация"],
			group: ["Spaces", "1"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2003) "]",
			symbolAlt: Chr(0x2003),
			symbolCustom: "underline"
		},
		"ensp", {
			unicode: "{U+2002}", html: "&#8194;", entity: "&ensp;",
			tags: ["en space", "enspace", "ensp", "полукруглая шпация"],
			group: ["Spaces", "2"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2002) "]",
			symbolAlt: Chr(0x2002),
			symbolCustom: "underline"
		},
		"emsp13", {
			unicode: "{U+2004}", html: "&#8196;", entity: "&emsp13;",
			tags: ["emsp13", "1/3emsp", "1/3 круглой Шпации"],
			group: ["Spaces", "3"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2004) "]",
			symbolAlt: Chr(0x2004),
			symbolCustom: "underline"
		},
		"emsp14", {
			unicode: "{U+2005}", html: "&#8196;", entity: "&emsp14;",
			tags: ["emsp14", "1/4emsp", "1/4 круглой Шпации"],
			group: ["Spaces", "4"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2005) "]",
			symbolAlt: Chr(0x2005),
			symbolCustom: "underline"
		},
		"thinspace", {
			unicode: "{U+2009}", html: "&#8201;", entity: "&thinsp;",
			tags: ["thinsp", "thin space", "узкий пробел", "тонкий пробел"],
			group: ["Spaces", "5"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2009) "]",
			symbolAlt: Chr(0x2009),
			symbolCustom: "underline"
		},
		"emsp16", {
			unicode: "{U+2006}", html: "&#8198;",
			tags: ["emsp16", "1/6emsp", "1/6 круглой Шпации"],
			group: ["Spaces", "6"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2006) "]",
			symbolAlt: Chr(0x2006),
			symbolCustom: "underline"
		},
		"narrow_no_break_space", {
			unicode: "{U+202F}", html: "&#8239;",
			tags: ["nnbsp", "narrow no-break space", "узкий неразрывный пробел", "тонкий неразрывный пробел"],
			group: ["Spaces", "7"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x202F) "]",
			symbolAlt: Chr(0x202F),
			symbolCustom: "underline"
		},
		"hairspace", {
			unicode: "{U+200A}", html: "&#8202;", entity: "&hairsp;",
			tags: ["hsp", "hairsp", "hair space", "волосяная шпация"],
			group: ["Spaces", "8"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x200A) "]",
			symbolAlt: Chr(0x200A),
			symbolCustom: "underline"
		},
		"punctuation_space", {
			unicode: "{U+2008}", html: "&#8200;", entity: "&puncsp;",
			tags: ["psp", "puncsp", "punctuation space", "пунктуационный пробел"],
			group: ["Spaces", "9"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2008) "]",
			symbolAlt: Chr(0x2008),
			symbolCustom: "underline"
		},
		"zero_width_space", {
			unicode: "{U+200B}", html: "&#8200;", entity: "&NegativeVeryThinSpace;",
			tags: ["zwsp", "zero-width space", "пробел нулевой ширины"],
			group: ["Spaces", "0"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x200B) "]",
			symbolAlt: Chr(0x200B),
			symbolCustom: "underline"
		},
		"word_joiner", {
			unicode: "{U+2060}", html: "&#8288;", entity: "&NoBreak;",
			tags: ["wj", "word joiner", "соединитель слов"],
			group: ["Spaces", "-"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2060) "]",
			symbolAlt: Chr(0x2060),
			symbolCustom: "underline"
		},
		"figure_space", {
			unicode: "{U+2007}", html: "&#8199;", entity: "&numsp;",
			tags: ["nsp", "numsp", "figure space", "цифровой пробел"],
			group: ["Spaces", "="],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: "[" Chr(0x2007) "]",
			symbolAlt: Chr(0x2007),
			symbolCustom: "underline"
		},
		"no_break_space", {
			unicode: "{U+00A0}", html: "&#160;", entity: "&nbsp;",
			altcode: "0160",
			LaTeX: "~",
			tags: ["nbsp", "no-break space", "неразрывный пробел"],
			group: ["Spaces", SpaceKey],
			show_on_fast_keys: True,
			symbol: "[" Chr(0x00A0) "]",
			symbolAlt: Chr(0x00A0),
			symbolCustom: "underline"
		},
		"tabulation", {
			unicode: "{U+0009}", html: "&#9;", entity: "&Tab;",
			tags: ["tab", "tabulation", "табуляция"],
			group: ["Spaces", Tabulation],
			show_on_fast_keys: True,
			symbol: "[" Chr(0x0009) "]",
			symbolAlt: Chr(0x0009),
			symbolCustom: "underline"
		},
		"emquad", {
			unicode: "{U+2001}", html: "&#8193;",
			LaTeX: "\qquad",
			tags: ["em quad", "emquad", "emqd", "em-квадрат"],
			group: ["Spaces", ExclamationMark],
			symbol: "[" Chr(0x2001) "]",
			symbolAlt: Chr(0x2001),
			symbolCustom: "underline"
		},
		"enquad", {
			unicode: "{U+2000}", html: "&#8192;",
			LaTeX: "\quad",
			tags: ["en quad", "enquad", "enqd", "en-квадрат"],
			group: ["Spaces", [CommercialAt, QuotationDouble]],
			symbol: "[" Chr(0x2000) "]",
			symbolAlt: Chr(0x2000),
			symbolCustom: "underline"
		},
		;
		;
		; ? Sys Group
		"carriage_return", {
			unicode: "{U+000D}", html: "&#13;",
			tags: ["carriage return", "возврат каретки"],
			group: ["Sys Group"],
			show_on_fast_keys: True,
			symbol: Chr(0x21B5),
		},
		"new_line", {
			unicode: "{U+000A}", html: "&#10;",
			tags: ["new line", "перевод строки"],
			group: ["Sys Group"],
			show_on_fast_keys: True,
			symbol: Chr(0x21B4),
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
			symbol: Chr(0x2190)
		},
		"arrow_right", {
			unicode: "{U+2192}", html: "&#8594;",
			altCode: "26",
			tags: ["right arrow", "стрелка вправо"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2192) "]",
			symbol: Chr(0x2192)
		},
		"arrow_up", {
			unicode: "{U+2191}", html: "&#8593;",
			altCode: "25",
			tags: ["up arrow", "стрелка вверх"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2191) "]",
			symbol: Chr(0x2191)
		},
		"arrow_down", {
			unicode: "{U+2193}", html: "&#8595;",
			altCode: "24",
			tags: ["down arrow", "стрелка вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[" Chr(0x2193) "]",
			symbol: Chr(0x2193)
		},
		"arrow_left_circle", {
			unicode: "{U+21BA}", html: "&#8634;", entity: "&olarr;",
			tags: ["left circle arrow", "округлая стрелка влево"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [" Chr(0x2190) "]",
			symbol: Chr(0x21BA)
		},
		"arrow_right_circle", {
			unicode: "{U+21BB}", html: "&#8635;", entity: "&orarr;",
			tags: ["right circle arrow", "округлая стрелка вправо"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [" Chr(0x2192) "]",
			symbol: Chr(0x21BB)
		},
		"arrow_left_ushaped", {
			unicode: "{U+2B8C}", html: "&#11148;",
			tags: ["left u-arrow", "u-образная стрелка влево"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2190) "]",
			symbol: Chr(0x2B8C)
		},
		"arrow_right_ushaped", {
			unicode: "{U+2B8E}", html: "&#11150;",
			tags: ["right u-arrow", "u-образная стрелка вправо"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2192) "]",
			symbol: Chr(0x2B8E)
		},
		"arrow_up_ushaped", {
			unicode: "{U+2B8D}", html: "&#11149;",
			tags: ["up u-arrow", "u-образная стрелка вверх"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2190) "]",
			symbol: Chr(0x2B8D)
		},
		"arrow_down_ushaped", {
			unicode: "{U+2B8F}", html: "&#11151;",
			tags: ["down u-arrow", "u-образная стрелка вниз"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Chr(0x2192) "]",
			symbol: Chr(0x2B8F)
		},
		"asterisk_low", {
			unicode: "{U+204E}", html: "&#8270;",
			tags: ["low asterisk", "нижний астериск"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], ["a", "ф"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Num*]",
			recipe: "*",
			symbol: Chr(0x204E)
		},
		"asterisk_two", {
			unicode: "{U+2051}", html: "&#8273;",
			tags: ["two asterisks", "два астериска"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], ["A", "Ф"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num*]",
			recipe: ["**", "2*"],
			symbol: Chr(0x2051)
		},
		"asterism", {
			unicode: "{U+2042}", html: "&#8258;",
			tags: ["asterism", "астеризм"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], CtrlA],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Num*]",
			recipe: ["***", "3*"],
			symbol: Chr(0x2042)
		},
		"bullet", {
			unicode: "{U+2022}", html: "&#8226;", entity: "&bull;",
			altCode: "0149 7",
			tags: ["bullet", "булит"],
			group: [["Special Characters", "Special Fast Secondary"], Backquote],
			show_on_fast_keys: True,
			symbol: Chr(0x2022)
		},
		"bullet_hyphen", {
			unicode: "{U+2043}", html: "&#8259;", entity: "&hybull;",
			altCode: "0149 7",
			tags: ["hyphen bullet", "чёрточный булит"],
			group: [["Special Characters", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [" Backquote "]",
			symbol: Chr(0x2043)
		},
		"interpunct", {
			unicode: "{U+00B7}", html: "&#183;", entity: "&middot;",
			altCode: "0183 250",
			tags: ["middle dot", "точка по центру", "интерпункт"],
			group: [["Special Characters", "Special Fast Secondary"], '~'],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [" Backquote "]",
			symbol: Chr(0x00B7)
		},
		"colon_triangle", {
			unicode: "{U+02D0}", html: "&#720;",
			tags: ["triangle colon", "знак долготы"],
			group: ["Special Characters", [";", "ж"]],
			symbol: Chr(0x02D0)
		},
		"colon_triangle_half", {
			unicode: "{U+02D1}", html: "&#721;",
			tags: ["half triangle colon", "знак полудолготы"],
			group: ["Special Characters", [":", "Ж"]],
			symbol: Chr(0x02D1)
		},
		"degree", {
			unicode: "{U+00B0}", html: "&#176;", entity: "&deg;",
			tags: ["degree", "градус"],
			group: [["Special Characters", "Special Fast Secondary"], ["d", "в"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[0]",
			symbol: Chr(0x00B0)
		},
		"celsius", {
			unicode: "{U+2103}", html: "&#8451;",
			tags: ["celsius", "градус Цельсия"],
			group: [["Special Characters", "Smelting Special"]],
			recipe: Chr(0x00B0) . "C",
			symbol: Chr(0x2103)
		},
		"fahrenheit", {
			unicode: "{U+2109}", html: "&#8457;",
			tags: ["fahrenheit", "градус по Фаренгейту"],
			group: [["Special Characters", "Smelting Special"]],
			recipe: Chr(0x00B0) . "F",
			symbol: Chr(0x2109)
		},
		"kelvin", {
			unicode: "{U+212A}", html: "&#8490;",
			tags: ["kelvin", "Кельвин"],
			group: [["Special Characters", "Smelting Special"]],
			recipe: Chr(0x00B0) . "K",
			symbol: Chr(0x212A)
		},
		"dagger", {
			unicode: "{U+2020}", html: "&#8224;", entity: "&dagger;",
			LaTeX: "\dagger",
			tags: ["dagger", "даггер", "крест"],
			group: [["Special Characters", "Special Fast Secondary"], ["t", "е"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num/]",
			symbol: Chr(0x2020)
		},
		"dagger_double", {
			unicode: "{U+2021}", html: "&#8225;", entity: "&Dagger;",
			LaTeX: "\ddagger",
			tags: ["double dagger", "двойной даггер", "двойной крест"],
			group: [["Special Characters", "Special Fast Secondary"], ["T", "Е"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Num/]",
			symbol: Chr(0x2021)
		},
		"dagger_tripple", {
			unicode: "{U+2E4B}", html: "&#11851;",
			tags: ["tripple dagger", "тройной даггер", "тройной крест"],
			group: ["Special Characters", CtrlT],
			symbol: Chr(0x2E4B)
		},
		"fraction_slash", {
			unicode: "{U+2044}", html: "&#8260;",
			tags: ["fraction slash", "дробная черта"],
			group: [["Special Characters", "Special Fast Secondary"], "/"],
			modifier: RightShift,
			show_on_fast_keys: True,
			symbol: Chr(0x2044)
		},
		"grapheme_joiner", {
			unicode: "{U+034F}", html: "&#847;",
			tags: ["grapheme joiner", "соединитель графем"],
			group: ["Special Characters", ["g", "п"]],
			symbol: DottedCircle . Chr(0x034F)
		},
		"infinity", {
			unicode: "{U+221E}", html: "&#8734;", entity: "&infin;",
			tags: ["fraction slash", "дробная черта"],
			group: [["Special Characters", "Special Fast Secondary"], "9"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [8]",
			symbol: Chr(0x221E)
		},
		"multiplication", {
			unicode: "{U+00D7}", html: "&#215;", entity: "&times;",
			altcode: "0215",
			tags: ["multiplication", "умножение"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "8"],
			show_on_fast_keys: True,
			alt_special: "[Num*]",
			recipe: "-x",
			symbol: Chr(0x00D7)
		},
		"prime_single", {
			unicode: "{U+2032}", html: "&#8242;", entity: "&prime;",
			LaTeX: "\prime",
			tags: ["prime", "штрих"],
			group: ["Special Characters", ["p", "з"]],
			symbol: Chr(0x2032)
		},
		"prime_double", {
			unicode: "{U+2033}", html: "&#8243;", entity: "&Prime;",
			LaTeX: "\prime\prime",
			tags: ["double prime", "двойной штрих"],
			group: ["Special Characters", ["P", "З"]],
			symbol: Chr(0x2033)
		},
		"permille", {
			unicode: "{U+2030}", html: "&#8240;", entity: "&permil;",
			altcode: "0137",
			LaTeX: "\permil",
			LaTeXPackage: "wasysym",
			tags: ["per mille", "промилле"],
			group: [["Special Characters", "Special Fast Secondary"], "5"],
			show_on_fast_keys: True,
			symbol: Chr(0x2030)
		},
		"pertenthousand", {
			unicode: "{U+2031}", html: "&#8241;", entity: "&pertenk;",
			LaTeX: "\textpertenthousand",
			LaTeXPackage: "textcomp",
			tags: ["per ten thousand", "промилле", "базисный пункт", "basis point"],
			group: [["Special Characters", "Special Fast Secondary"], "%"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [5]",
			symbol: Chr(0x2031)
		},
		"section", {
			unicode: "{U+00A7}", html: "&#167;", entity: "&sect;",
			altCode: "21",
			tags: ["section", "параграф"],
			group: [["Special Characters", "Special Fast Secondary"], ["s", "ы"]],
			show_on_fast_keys: True,
			symbol: Chr(0x00A7)
		},
		"noequals", {
			unicode: "{U+2260}", html: "&#8800;", entity: "&ne;",
			tags: ["plus minus", "плюс-минус"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Fast"], "="],
			show_on_fast_keys: True,
			alt_special: "[/=]",
			recipe: "/=",
			symbol: Chr(0x2260)
		},
		"almostequals", {
			unicode: "{U+2248}", html: "&#8776;", entity: "&asymp;",
			tags: ["almost equals", "примерно равно"],
			group: [["Smelting Special", "Special Fast Secondary", "Special Fast"], "="],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [=]",
			alt_special: "[``=]",
			recipe: "~=",
			symbol: Chr(0x2248)
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
			symbol: Chr(0x00B1)
		},
		"dotted_circle", {
			unicode: "{U+25CC}", html: "&#9676;",
			tags: ["пунктирный круг", "dottet circle"],
			group: ["Special Fast Primary", "Num0"],
			show_on_fast_keys: True,
			symbol: DottedCircle
		},
		"ellipsis", {
			unicode: "{U+2026}", html: "&#8230;", entity: "&hellip;",
			altcode: "0133",
			tags: ["ellipsis", "многоточие"],
			group: [["Special Characters", "Smelting Special", "Special Fast Secondary"], "."],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[/]",
			recipe: "...",
			symbol: Chr(0x2026)
		},
		"two_dot_leader", {
			unicode: "{U+2025}", html: "&#8229;",
			tags: ["two dot leader", "двухточечный пунктир"],
			group: [["Smelting Special", "Special Fast Secondary"], "."],
			recipe: "..",
			symbol: Chr(0x2025)
		},
		"exclamation", {
			unicode: "{U+0021}", html: "&#33;", entity: "&excl;",
			symbol: Chr(0x0021)
		},
		"question", {
			unicode: "{U+003F}", html: "&#63;", entity: "&quest;",
			symbol: Chr(0x003F)
		},
		"reversed_question", {
			unicode: "{U+2E2E}", html: "&#11822;",
			tags: ["reversed ?", "обратный ?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [1]",
			recipe: Chr(0x2B8C) "?",
			symbol: Chr(0x2E2E)
		},
		"inverted_exclamation", {
			unicode: "{U+00A1}", html: "&#161;", entity: "&iexcl;",
			tags: ["inverted !", "перевёрнутый !"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[1]",
			recipe: Chr(0x2B8F) "!",
			symbol: Chr(0x00A1)
		},
		"inverted_question", {
			unicode: "{U+00BF}", html: "&#191;", entity: "&iquest;",
			tags: ["inverted ?", "перевёрнутый ?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[7]",
			recipe: Chr(0x2B8F) "?",
			symbol: Chr(0x00BF)
		},
		"double_exclamation", {
			unicode: "{U+203C}", html: "&#8252;",
			altcode: "19",
			tags: ["double !!", "двойной !!"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock RightShift " [1]",
			recipe: "!!",
			symbol: Chr(0x203C)
		},
		"double_exclamation_question", {
			unicode: "{U+2049}", html: "&#8265;",
			tags: ["double !?", "двойной !?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [1]",
			recipe: "!?",
			symbol: Chr(0x2049)
		},
		"double_question", {
			unicode: "{U+2047}", html: "&#8263;",
			tags: ["double ??", "двойной ??"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock RightShift " [7]",
			recipe: "??",
			symbol: Chr(0x2047)
		},
		"double_question_exclamation", {
			unicode: "{U+2048}", html: "&#8264;",
			tags: ["double ?!", "двойной ?!"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [7]",
			recipe: "?!",
			symbol: Chr(0x2048)
		},
		"interrobang", {
			unicode: "{U+203D}", html: "&#8253;",
			tags: ["interrobang", "интерробанг", "лигатура !?", "ligature !?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [1]",
			recipe: "!+?",
			symbol: Chr(0x203D)
		},
		"interrobang_inverted", {
			unicode: "{U+2E18}", html: "&#11800;",
			tags: ["inverted interrobang", "перевёрнутый интерробанг", "лигатура перевёрнутый !?", "ligature inverted !?"],
			group: [["Smelting Special", "Special Fast Secondary"]],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock LeftShift RightShift " [1]",
			recipe: Chr(0x2B8F) "!+?",
			symbol: Chr(0x2E18)
		},
		"emdash", {
			unicode: "{U+2014}", html: "&#8212;", entity: "&mdash;",
			altcode: "0151",
			tags: ["em dash", "длинное тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "1"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[-]",
			recipe: "---",
			symbol: Chr(0x2014)
		},
		"emdash_vertical", {
			unicode: "{U+FE31}", html: "&#65073;",
			tags: ["vertical em dash", "вертикальное длинное тире"],
			group: ["Smelting Special"],
			recipe: Chr(0x2B8F) "—",
			symbol: Chr(0xFE31)
		},
		"endash", {
			unicode: "{U+2013}", html: "&#8211;", entity: "&ndash;",
			altcode: "0150",
			tags: ["en dash", "короткое тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "2"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [-]",
			recipe: "--",
			symbol: Chr(0x2013)
		},
		"endash_vertical", {
			unicode: "{U+FE32}", html: "&#65074;",
			tags: ["vertical en dash", "вертикальное короткое тире"],
			group: ["Smelting Special"],
			recipe: Chr(0x2B8F) "–",
			symbol: Chr(0xFE32)
		},
		"three_emdash", {
			unicode: "{U+2E3B}", html: "&#11835;",
			tags: ["three-em dash", "тройное тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "3"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [-]",
			recipe: ["-----", "3-"],
			symbol: Chr(0x2E3B)
		},
		"two_emdash", {
			unicode: "{U+2E3A}", html: "&#11834;",
			tags: ["two-em dash", "двойное тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "4"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock LeftShift " [-]",
			recipe: ["----", "2-"],
			symbol: Chr(0x2E3A)
		},
		"softhyphen", {
			unicode: "{U+00AD}", html: "&#173;", entity: "&shy;",
			altcode: "0173",
			tags: ["soft hyphen", "мягкий перенос"],
			group: [["Dashes", "Smelting Special", "Special Fast Primary"], "5"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[-]",
			recipe: ".-",
			symbol: Chr(0x00AD)
		},
		"figure_dash", {
			unicode: "{U+2012}", html: "&#8210;",
			tags: ["figure dash", "цифровое тире"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "6"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [-]",
			recipe: "n-",
			symbol: Chr(0x2012)
		},
		"hyphen", {
			unicode: "{U+2010}", html: "&#8208;", entity: "&hyphen;",
			tags: ["hyphen", "дефис"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "7"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [-]",
			recipe: "-",
			symbol: Chr(0x2010)
		},
		"no_break_hyphen", {
			unicode: "{U+2011}", html: "&#8209;",
			tags: ["no-break hyphen", "неразрывный дефис"],
			group: [["Dashes", "Smelting Special", "Special Fast Secondary"], "8"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [-]",
			recipe: "0-",
			symbol: Chr(0x2011)
		},
		"minus", {
			unicode: "{U+2212}", html: "&#8722;", entity: "&minus;",
			tags: ["minus", "минус"],
			group: [["Dashes", "Smelting Special", "Special Fast Primary", "Special Fast"], "9"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [-]",
			alt_special: "[Num-]",
			recipe: "m-",
			symbol: Chr(0x2212)
		},
		"horbar", {
			unicode: "{U+2015}", html: "&#8213;", entity: "&horbar;",
			tags: ["horbar", "горизонтальная черта"],
			group: [["Dashes", "Smelting Special"], "0"],
			recipe: "h-",
			symbol: Chr(0x2015)
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
			symbol: Chr(0x00AB)
		},
		"france_right", {
			unicode: "{U+00BB}", html: "&#187;", entity: "&raquo;",
			altcode: "0172",
			tags: ["right guillemets", "правая ёлочка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "2"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[ю]",
			recipe: [">>", "2>"],
			symbol: Chr(0x00BB)
		},
		"france_single_left", {
			unicode: "{U+2039}", html: "&#8249;", entity: "&lsaquo;",
			altcode: "0139",
			tags: ["left single guillemet", "левая одиночная ёлочка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "2"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Б]",
			recipe: "<",
			symbol: Chr(0x2039)
		},
		"france_single_right", {
			unicode: "{U+203A}", html: "&#8250;", entity: "&rsaquo;",
			altcode: "0155",
			tags: ["right single guillemet", "правая одиночная ёлочка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "3"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [Ю]",
			recipe: ">",
			symbol: Chr(0x203A)
		},
		"quote_left_double", {
			unicode: "{U+201C}", html: "&#8220;", entity: "&ldquo;",
			altcode: "0147",
			tags: ["left quotes", "левая кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "4"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[<]",
			recipe: QuotationDouble . "<",
			symbol: Chr(0x201C)
		},
		"quote_right_double", {
			unicode: "{U+201D}", html: "&#8221;", entity: "&rdquo;",
			altcode: "0148",
			tags: ["right quotes", "правая кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "5"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[>]",
			recipe: QuotationDouble . ">",
			symbol: Chr(0x201D)
		},
		"quote_left_single", {
			unicode: "{U+2018}", html: "&#8216;", entity: "&lsquo;",
			altcode: "0145",
			tags: ["left quote", "левая одинарная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "6"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [<]",
			recipe: ApostropheMark . "<",
			symbol: Chr(0x2018)
		},
		"quote_right_single", {
			unicode: "{U+2019}", html: "&#8217;", entity: "&rsquo;",
			altcode: "0146",
			tags: ["right quote", "правая одинарная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "7"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [>] " RightShift " [" Backquote "][Ё]",
			recipe: ApostropheMark ">",
			symbol: Chr(0x2019)
		},
		"quote_low_9_single", {
			unicode: "{U+201A}", html: "&#8218;", entity: "&sbquo;",
			tags: ["single low-9", "нижняя открывающая кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "8"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift "  [<]",
			recipe: ApostropheMark Chr(0x2193) "<",
			symbol: Chr(0x201A)
		},
		"quote_low_9_double", {
			unicode: "{U+201E}", html: "&#8222;", entity: "&bdquo;",
			altcode: "0132",
			tags: ["low-9 quotes", "нижняя открывающая двойная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "0"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [<]",
			recipe: QuotationDouble Chr(0x2193) "<",
			symbol: Chr(0x201E)
		},
		"quote_low_9_double_reversed", {
			unicode: "{U+2E42}", html: "&#11842;",
			tags: ["low-9 reversed quotes", "нижняя двойная кавычка"],
			group: [["Quotes", "Smelting Special", "Special Fast Secondary"], "-"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [>]",
			recipe: QuotationDouble Chr(0x2193) ">",
			symbol: Chr(0x2E42)
		},
		"quote_left_double_ghost_ru", {
			unicode: "{U+201E}", html: "&#8222;", entity: "&bdquo;",
			altcode: "0132",
			tags: ["left low quotes", "левая нижняя кавычка"],
			group: ["Special Fast Secondary"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Б]",
			symbol: Chr(0x201E)
		},
		"quote_right_double_ghost_ru", {
			unicode: "{U+201C}", html: "&#8220;", entity: "&ldquo;",
			altcode: "0147",
			tags: ["left quotes", "левая кавычка"],
			group: ["Special Fast Secondary"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Ю]",
			symbol: Chr(0x201C)
		},
		"asian_left_quote", {
			unicode: "{U+300C}", html: "#12300;",
			tags: ["asian left quote", "левая азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num4]",
			symbol: Chr(0x300C)
		},
		"asian_right_quote", {
			unicode: "{U+300D}", html: "#12301;",
			tags: ["asian right quote", "правая азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num6]",
			symbol: Chr(0x300D)
		},
		"asian_up_quote", {
			unicode: "{U+FE41}", html: "&#65089;",
			tags: ["asian up quote", "верхняя азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num8]",
			symbol: Chr(0xFE41)
		},
		"asian_down_quote", {
			unicode: "{U+FE42}", html: "&#65090;",
			tags: ["asian down quote", "нижняя азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[Num2]",
			symbol: Chr(0xFE42)
		},
		"asian_double_left_quote", {
			unicode: "{U+300E}", html: "&#12302;",
			tags: ["asian double left quote", "левая двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num4]",
			symbol: Chr(0x300E)
		},
		"asian_double_right_quote", {
			unicode: "{U+300F}", html: "&#12303;",
			tags: ["asian double right quote", "правая двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num6]",
			symbol: Chr(0x300F)
		},
		"asian_double_up_quote", {
			unicode: "{U+FE43}", html: "&#65091;",
			tags: ["asian double up quote", "верхняя двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num8]",
			symbol: Chr(0xFE43)
		},
		"asian_double_down_quote", {
			unicode: "{U+FE44}", html: "&#65092;",
			tags: ["asian double down quote", "нижняя двойная азиатская кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: CapsLock " [Num2]",
			symbol: Chr(0xFE44)
		},
		"asian_double_left_title", {
			unicode: "{U+300A}", html: "&#12298;",
			tags: ["asian double left title", "двойная левая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [<][Б]",
			symbol: Chr(0x300A)
		},
		"asian_double_right_title", {
			unicode: "{U+300B}", html: "&#12299;",
			tags: ["asian double right title", "двойная правая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [>][Ю]",
			symbol: Chr(0x300B)
		},
		"asian_left_title", {
			unicode: "{U+3008}", html: "&#12296;",
			tags: ["asian left title", "левая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [<][Б]",
			symbol: Chr(0x3008)
		},
		"asian_right_title", {
			unicode: "{U+3009}", html: "&#12297;",
			tags: ["asian right title", "правая титульная кавычка"],
			group: ["Asian Quotes"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [>][Ю]",
			symbol: Chr(0x3009)
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
		symbol: Chr(0xA732)
	},
		"lat_s_lig_aa", {
			unicode: "{U+A733}", html: "&#42803;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".aa", "лигатура aa", "ligature aa"],
			recipe: "aa",
			symbol: Chr(0xA733)
		},
		"lat_c_lig_ae", {
			unicode: "{U+00C6}", html: "&#198;", entity: "&AElig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ae", "лигатура AE", "ligature AE"],
			recipe: "AE",
			symbol: Chr(0x00C6)
		},
		"lat_s_lig_ae", {
			unicode: "{U+00E6}", html: "&#230;", entity: "&aelig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ae", "лигатура ae", "ligature ae"],
			recipe: "ae",
			symbol: Chr(0x00E6)
		},
		"lat_c_lig_ae_acute", {
			unicode: "{U+01FC}", html: "&#508;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!aea", "лигатура AE с акутом", "ligature AE with acute"],
			recipe: ["AE" . GetChar("acute"), Chr(0x00C6) GetChar("acute"), "A" Chr(0x00C9)],
			recipeAlt: ["AE" GetChar("dotted_circle", "acute"),
				Chr(0x00C6) GetChar("dotted_circle", "acute"),
				"A" Chr(0x00C9)
			],
			symbol: Chr(0x01FC)
		},
		"lat_s_lig_ae_acute", {
			unicode: "{U+01FD}", html: "&#509;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".aea", "лигатура ae с акутом", "ligature ae with acute"], recipe: ["ae" . GetChar("acute"), Chr(0x00E6) GetChar("acute"), "a" Chr(0x00E9)],
			recipeAlt: ["ae" GetChar("dotted_circle", "acute"),
				Chr(0x00E6) GetChar("dotted_circle", "acute"),
				"a" Chr(0x00E9)
			],
			symbol: Chr(0x01FD)
		},
		"lat_c_lig_ae_macron", {
			unicode: "{U+01E2}", html: "&#482;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!aem", "лигатура AE с макроном", "ligature AE with macron"],
			recipe: ["AE" . GetChar("macron"), Chr(0x00C6) GetChar("macron"), "A" Chr(0x0112)],
			recipeAlt: ["AE" GetChar("dotted_circle", "macron"),
				Chr(0x00C6) GetChar("dotted_circle", "macron"),
				"A" Chr(0x0112)
			],
			symbol: Chr(0x01E2)
		},
		"lat_s_lig_ae_macron", {
			unicode: "{U+01E3}", html: "&#483;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".aem", "лигатура ae с макроном", "ligature ae with macron"],
			recipe: ["ae" . GetChar("macron"), Chr(0x00E6) GetChar("macron"), "a" Chr(0x0113)],
			recipeAlt: ["ae" GetChar("dotted_circle", "macron"),
				Chr(0x00E6) GetChar("dotted_circle", "macron"),
				"a" Chr(0x0113)
			],
			symbol: Chr(0x01E3)
		},
		"lat_c_lig_ao", {
			unicode: "{U+A734}", html: "&#42804;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ao", "лигатура AO", "ligature AO"],
			recipe: "AO",
			symbol: Chr(0xA734)
		},
		"lat_s_lig_ao", {
			unicode: "{U+A735}", html: "&#42805;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ao", "лигатура ao", "ligature ao"],
			recipe: "ao",
			symbol: Chr(0xA735)
		},
		"lat_c_lig_au", {
			unicode: "{U+A736}", html: "&#42806;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!au", "лигатура AU", "ligature AU"],
			recipe: "AU",
			symbol: Chr(0xA736)
		},
		"lat_s_lig_au", {
			unicode: "{U+A737}", html: "&#42807;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".au", "лигатура au", "ligature au"],
			recipe: "au",
			symbol: Chr(0xA737)
		},
		"lat_c_lig_av", {
			unicode: "{U+A738}", html: "&#42808;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!av", "лигатура AV", "ligature AV"],
			recipe: "AV",
			symbol: Chr(0xA738)
		},
		"lat_s_lig_av", {
			unicode: "{U+A739}", html: "&#42809;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".av", "лигатура av", "ligature av"],
			recipe: "av",
			symbol: Chr(0xA739)
		},
		"lat_c_lig_avi", {
			unicode: "{U+A73A}", html: "&#42810;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!avi", "лигатура AVI", "ligature AVI"],
			recipe: "AVI",
			symbol: Chr(0xA73A)
		},
		"lat_s_lig_avi", {
			unicode: "{U+A73B}", html: "&#42811;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".avi", "лигатура avi", "ligature avi"],
			recipe: "avi",
			symbol: Chr(0xA73B)
		},
		"lat_c_lig_ay", {
			unicode: "{U+A73C}", html: "&#42812;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ay", "лигатура AY", "ligature AY"],
			recipe: "AY",
			symbol: Chr(0xA73C)
		},
		"lat_s_lig_ay", {
			unicode: "{U+A73D}", html: "&#42813;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ay", "лигатура ay", "ligature ay"],
			recipe: "ay",
			symbol: Chr(0xA73D)
		},
		"lat_s_lig_db", {
			unicode: "{U+0238}", html: "&#568;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".db", "лигатура db", "ligature db"],
			recipe: "db",
			symbol: Chr(0x0238)
		},
		"lat_s_lig_et", {
			unicode: "{U+0026}", html: "&#38;", entity: "&amp;",
			altCode: "38",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".et", "лигатура et", "ligature et", "амперсанд", "ampersand"],
			recipe: "et",
			symbol: Chr(0x0026)
		},
		"lat_s_lig_et_turned", {
			unicode: "{U+214B}", html: "&#8523;",
			altCode: "38",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ett", "лигатура перевёрнутый et", "ligature turned et", "перевёрнутый амперсанд", "turned ampersand"],
			recipe: ["et" . Chr(0x21BA), "&" . Chr(0x21BA)],
			symbol: Chr(0x214B)
		},
		"lat_s_lig_ff", {
			unicode: "{U+FB00}", html: "&#64256;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ff", "лигатура ff", "ligature ff"],
			recipe: "ff",
			symbol: Chr(0xFB00)
		},
		"lat_s_lig_fi", {
			unicode: "{U+FB01}", html: "&#64257;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".fi", "лигатура fi", "ligature fi"],
			recipe: "fi",
			symbol: Chr(0xFB01)
		},
		"lat_s_lig_fl", {
			unicode: "{U+FB02}", html: "&#64258;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".fl", "лигатура fl", "ligature fl"],
			recipe: "fl",
			symbol: Chr(0xFB02)
		},
		"lat_s_lig_ft", {
			unicode: "{U+FB05}", html: "&#64261;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ft", "лигатура ft", "ligature ft"],
			recipe: ["ft", Chr(0x017F) . "t"],
			symbol: Chr(0xFB05)
		},
		"lat_s_lig_ffi", {
			unicode: "{U+FB03}", html: "&#64259;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ffi", "лигатура ffi", "ligature ffi"],
			recipe: "ffi",
			symbol: Chr(0xFB03)
		},
		"lat_s_lig_ffl", {
			unicode: "{U+FB04}", html: "&#64260;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ffl", "лигатура ffl", "ligature ffl"],
			recipe: "ffl",
			symbol: Chr(0xFB04)
		},
		"lat_c_lig_ij", {
			unicode: "{U+0132}", html: "&#306;", entity: "&IJlig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ij", "лигатура IJ", "ligature IJ"],
			recipe: "IJ",
			symbol: Chr(0x0132)
		},
		"lat_s_lig_ij", {
			unicode: "{U+0133}", html: "&#307;", entity: "&ijlig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ij", "лигатура ij", "ligature ij"],
			recipe: "ij",
			symbol: Chr(0x0133)
		},
		"lat_s_lig_lb", {
			unicode: "{U+2114}", html: "&#8468;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".lb", "лигатура lb", "ligature lb"],
			recipe: "lb",
			symbol: Chr(0x2114)
		},
		"lat_c_lig_ll", {
			unicode: "{U+1EFA}", html: "&#7930;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ll", "лигатура lL", "ligature lL"],
			recipe: "lL",
			symbol: Chr(0x1EFA)
		},
		"lat_s_lig_ll", {
			unicode: "{U+1EFB}", html: "&#7931;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ll", "лигатура ll", "ligature ll"],
			recipe: "ll",
			symbol: Chr(0x1EFB)
		},
		"lat_c_lig_oi", {
			unicode: "{U+01A2}", html: "&#418;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!oi", "лигатура OI", "ligature OI"],
			recipe: "OI",
			symbol: Chr(0x01A2)
		},
		"lat_s_lig_oi", {
			unicode: "{U+01A3}", html: "&#419;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".oi", "лигатура oi", "ligature oi"],
			recipe: "oi",
			symbol: Chr(0x01A3)
		},
		"lat_c_lig_oe", {
			unicode: "{U+0152}", html: "&#338;", entity: "&OElig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!oe", "лигатура OE", "ligature OE"],
			recipe: "OE",
			symbol: Chr(0x0152)
		},
		"lat_s_lig_oe", {
			unicode: "{U+0153}", html: "&#339;", entity: "&oelig;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".oe", "лигатура oe", "ligature oe"],
			recipe: "oe",
			symbol: Chr(0x0153)
		},
		"lat_c_lig_oo", {
			unicode: "{U+A74E}", html: "&#42830;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!oo", "лигатура OO", "ligature OO"],
			recipe: "OO",
			symbol: Chr(0xA74E)
		},
		"lat_s_lig_oo", {
			unicode: "{U+A74F}", html: "&#42831;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".oo", "лигатура oo", "ligature oo"],
			recipe: "oo",
			symbol: Chr(0xA74F)
		},
		"lat_c_lig_pl", {
			unicode: "{U+214A}", html: "&#8522;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!pl", "лигатура PL", "ligature PL", "Property Line"],
			recipe: "PL",
			symbol: Chr(0x214A)
		},
		"lat_s_lig_ue", {
			unicode: "{U+1D6B}", html: "&#7531;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ue", "лигатура ue", "ligature ue"],
			recipe: "ue",
			symbol: Chr(0x1D6B)
		},
		"lat_c_lig_eszett", {
			unicode: "{U+1E9E}", html: "&#7838;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!ss", "лигатура SS", "ligature SS", "прописной эсцет", "capital eszett"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [S]",
			recipe: ["SS", Chr(0x017F) . "S"],
			symbol: Chr(0x1E9E)
		},
		"lat_s_lig_eszett", {
			unicode: "{U+00DF}", html: "&#223;", entity: "&szlig;",
			titlesAlt: True,
			group: [["Latin Ligatures"]],
			tags: [".ss", "лигатура ss", "ligature ss", "строчный эсцет", "small eszett"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [s]",
			recipe: ["ss", Chr(0x017F) . "s"],
			symbol: Chr(0x00DF)
		},
		"lat_c_lig_vy", {
			unicode: "{U+A760}", html: "&#42848;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!vy", "лигатура VY", "ligature VY"],
			recipe: "VY",
			symbol: Chr(0xA760)
		},
		"lat_s_lig_vy", {
			unicode: "{U+A761}", html: "&#42849;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".vy", "лигатура vy", "ligature vy"],
			recipe: "vy",
			symbol: Chr(0xA761)
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
			symbol: Chr(0x01F1)
		},
		"lat_cs_dig_dz", {
			unicode: "{U+01F2}", html: "&#498;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: ["!.dz", "диграф Dz", "diagraph Dz"],
			recipe: "Dz",
			symbol: Chr(0x01F2)
		},
		"lat_s_dig_dz", {
			unicode: "{U+01F3}", html: "&#499;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: [".dz", "диграф dz", "diagraph dz"],
			recipe: "dz",
			symbol: Chr(0x01F3)
		},
		"lat_c_dig_dz_caron", {
			unicode: "{U+01C4}", html: "&#452;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: ["!dzh", "диграф DZ с гачеком", "diagraph DZ with caron"],
			recipe: ["DZ" GetChar("caron"), Chr(0x01F1) GetChar("caron")],
			recipeAlt: [
				"DZ" GetChar("dotted_circle", "caron"),
				Chr(0x01F1) GetChar("dotted_circle", "caron")
			],
			symbol: Chr(0x01C4)
		},
		"lat_cs_dig_dz_caron", {
			unicode: "{U+01C5}", html: "&#453;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: ["!.dzh", "диграф Dz с гачеком", "diagraph Dz with caron"],
			recipe: ["Dz" . GetChar("caron"), Chr(0x01F2) . GetChar("caron")],
			recipeAlt: [
				"Dz" GetChar("dotted_circle", "caron"),
				Chr(0x01F2) GetChar("dotted_circle", "caron")
			],
			symbol: Chr(0x01C5)
		},
		"lat_s_dig_dz_caron", {
			unicode: "{U+01C6}", html: "&#454;",
			titlesAlt: True,
			group: ["Latin Digraphs"],
			tags: [".dzh", "диграф dz с гачеком", "diagraph dz with caron"],
			recipe: ["dz" GetChar("caron"), Chr(0x01F3) GetChar("caron")],
			recipeAlt: [
				"dz" GetChar("dotted_circle", "caron"),
				Chr(0x01F3) GetChar("dotted_circle", "caron")
			],
			symbol: Chr(0x01C6)
		},
		"lat_s_dig_feng", {
			unicode: "{U+02A9}", html: "&#681;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".fnj", "диграф фэнг", "diagraph feng"],
			recipe: ["fnj", "fŋ"],
			symbol: Chr(0x02A9)
		},
		"lat_c_dig_lj", {
			unicode: "{U+01C7}", html: "&#455;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!lj", "диграф LJ", "diagraph LJ"],
			recipe: "LJ",
			symbol: Chr(0x01C7)
		},
		"lat_cs_dig_lj", {
			unicode: "{U+01C8}", html: "&#456;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!.lj", "диграф Lj", "diagraph Lj"],
			recipe: "Lj",
			symbol: Chr(0x01C8)
		},
		"lat_s_dig_lj", {
			unicode: "{U+01C9}", html: "&#457;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".lj", "диграф lj", "diagraph lj"],
			recipe: "lj",
			symbol: Chr(0x01C9)
		},
		"lat_s_dig_ls", {
			unicode: "{U+02AA}", html: "&#682;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ls", "диграф ls", "diagraph ls"],
			recipe: "ls",
			symbol: Chr(0x02AA)
		},
		"lat_s_dig_lz", {
			unicode: "{U+02AB}", html: "&#683;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".lz", "диграф lz", "diagraph lz"],
			recipe: "lz",
			symbol: Chr(0x02AB)
		},
		"lat_c_dig_nj", {
			unicode: "{U+01CA}", html: "&#458;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!nj", "диграф NJ", "diagraph NJ"],
			recipe: "N-J",
			symbol: Chr(0x01CA)
		},
		"lat_cs_dig_nj", {
			unicode: "{U+01CB}", html: "&#459;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: ["!.nj", "диграф Nj", "diagraph Nj"],
			recipe: "N-j",
			symbol: Chr(0x01CB)
		},
		"lat_s_dig_nj", {
			unicode: "{U+01CC}", html: "&#460;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".nj", "диграф nj", "diagraph nj"],
			recipe: "n-j",
			symbol: Chr(0x01CC)
		},
		"lat_s_dig_st", {
			unicode: "{U+FB06}", html: "&#64262;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".st", "диграф st", "diagraph st"],
			recipe: "st",
			symbol: Chr(0xFB06)
		},
		"lat_s_dig_tc", {
			unicode: "{U+02A8}", html: "&#680;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".tc", "диграф tc", "diagraph tc"],
			recipe: ["tc", "t" Chr(0x0255)],
			symbol: Chr(0x02A8)
		},
		"lat_s_dig_tch", {
			unicode: "{U+02A7}", html: "&#679;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".tch", "диграф tch", "diagraph tch"],
			recipe: ["tch", "t" Chr(0x0283)],
			symbol: Chr(0x02A7)
		},
		"lat_s_dig_ts", {
			unicode: "{U+02A6}", html: "&#678;",
			titlesAlt: True,
			group: ["Latin Ligatures"],
			tags: [".ts", "диграф ts", "diagraph ts"],
			recipe: "ts",
			symbol: Chr(0x02A6)
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
			symbol: Chr(0xA779)
		},
		"lat_s_let_d_insular", {
			unicode: "{U+A77A}", html: "&#42874;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["строчная замкнутая d", "small insular d"],
			recipe: "d0",
			symbol: Chr(0xA77A)
		},
		"lat_s_let_i_dotless", {
			unicode: "{U+0131}", html: "&#305;", entity: "&imath;",
			titlesAlt: True,
			group: ["Latin Extended", "i"],
			show_on_fast_keys: False,
			tags: ["і без точки", "i dotless"],
			symbol: Chr(0x0131)
		},
		"lat_s_let_ie", {
			unicode: "{U+AB61}", html: "&#43873;;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["строчная ie", "small ie"],
			recipe: "ie",
			symbol: Chr(0xAB61)
		},
		"lat_c_let_thorn", {
			unicode: "{U+00DE}", html: "&#222;", entity: "&THORN;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["!th", "прописной торн", "capital thorn"],
			recipe: "TH",
			symbol: Chr(0x00DE)
		},
		"lat_s_let_thorn", {
			unicode: "{U+00FE}", html: "&#254;", entity: "&thorn;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: [".th", "строчный торн", "small thorn"],
			recipe: "th",
			symbol: Chr(0x00FE)
		},
		"lat_c_let_wynn", {
			unicode: "{U+01F7}", html: "&#503;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["!wy", "прописной винн", "capital wynn"],
			recipe: "WY",
			symbol: Chr(0x01F7)
		},
		"lat_s_let_wynn", {
			unicode: "{U+01BF}", html: "&#447;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: [".wy", "строчный винн", "small wynn"],
			recipe: "wy",
			symbol: Chr(0x01BF)
		},
		"lat_c_let_nj", {
			unicode: "{U+014A}", html: "&#330;", entity: "&ENG;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["!nj", "прописной энг", "capital eng"],
			recipe: "NJ",
			symbol: Chr(0x014A)
		},
		"lat_s_let_nj", {
			unicode: "{U+014B}", html: "&#331;", entity: "&eng;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: [".nj", "строчный энг", "small eng"],
			recipe: "nj",
			symbol: Chr(0x014B)
		},
		"lat_s_let_s_long", {
			unicode: "{U+017F}", html: "&#383;",
			titlesAlt: True,
			group: ["Latin Extended"],
			tags: ["строчное s длинное", "small s long"],
			recipe: "fs",
			symbol: Chr(0x017F)
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
			recipeAlt: "A" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x00C1)
		},
		"lat_s_let_a_acute", {
			unicode: "{U+00E1}", html: "&#225;", entity: "&aacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная a с акутом", "small a with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[a]",
			recipe: "a" GetChar("acute"),
			recipeAlt: "a" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x00E1)
		},
		"lat_c_let_a_breve", {
			unicode: "{U+0102}", html: "&#258;", entity: "&Abreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с краткой", "capital A with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[A]",
			recipe: "A" GetChar("breve"),
			recipeAlt: "A" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x0102)
		},
		"lat_s_let_a_breve", {
			unicode: "{U+0103}", html: "&#259;", entity: "&abreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с краткой", "small a with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[a]",
			recipe: "a" GetChar("breve"),
			recipeAlt: "a" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x0103)
		},
		"lat_c_let_a_breve_acute", {
			unicode: "{U+1EAE}", html: "&#7854;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и акутом", "capital A with breve and acute"],
			recipe: ["A" GetChar("breve", "acute"), Chr(0x0102) GetChar("acute")],
			recipeAlt: ["A" GetChar("dotted_circle", "breve", "dotted_circle", "acute"), Chr(0x0102) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1EAE)
		},
		"lat_s_let_a_breve_acute", {
			unicode: "{U+1EAF}", html: "&#7855;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и акутом", "small a with breve and acute"],
			recipe: ["a" GetChar("breve", "acute"), Chr(0x0103) GetChar("acute")],
			recipeAlt: ["a" GetChar("dotted_circle", "breve", "dotted_circle", "acute"), Chr(0x0103) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1EAF)
		},
		"lat_c_let_a_breve_dot_below", {
			unicode: "{U+1EB6}", html: "&#7862;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и точкой снизу", "capital A with breve and dot below"],
			recipe: ["A" GetChar("breve", "dot_below"), Chr(0x0102) GetChar("dot_below")],
			recipeAlt: ["A" GetChar("dotted_circle", "breve", "dotted_circle", "dot_below"), Chr(0x0102) GetChar("dotted_circle", "dot_below")],
			symbol: Chr(0x1EB6)
		},
		"lat_s_let_a_breve_dot_below", {
			unicode: "{U+1EB7}", html: "&#7863;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и точкой снизу", "small a with breve and dot below"],
			recipe: ["a" GetChar("breve", "dot_below"), Chr(0x0103) GetChar("dot_below")],
			recipeAlt: ["a" GetChar("dotted_circle", "breve", "dotted_circle", "dot_below"), Chr(0x0103) GetChar("dotted_circle", "dot_below")],
			symbol: Chr(0x1EB7)
		},
		"lat_c_let_a_breve_grave", {
			unicode: "{U+1EB0}", html: "&#7856;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и грависом", "capital A with breve and grave"],
			recipe: ["A" GetChar("breve", "grave"), Chr(0x0102) GetChar("grave")],
			recipeAlt: ["A" GetChar("dotted_circle", "breve", "dotted_circle", "grave"), Chr(0x0102) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1EB0)
		},
		"lat_s_let_a_breve_grave", {
			unicode: "{U+1EB1}", html: "&#7857;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и грависом", "small a with breve and grave"],
			recipe: ["a" GetChar("breve", "grave"), Chr(0x0103) GetChar("grave")],
			recipeAlt: ["a" GetChar("dotted_circle", "breve", "dotted_circle", "grave"), Chr(0x0103) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1EB1)
		},
		"lat_c_let_a_breve_hook_above", {
			unicode: "{U+1EB2}", html: "&#7858;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и хвостиком сверху", "capital A with breve and hook_above"],
			recipe: ["A" GetChar("breve", "hook_above"), Chr(0x0102) GetChar("hook_above")],
			recipeAlt: ["A" GetChar("dotted_circle", "breve", "dotted_circle", "hook_above"), Chr(0x0102) GetChar("dotted_circle", "hook_above")],
			symbol: Chr(0x1EB2)
		},
		"lat_s_let_a_breve_hook_above", {
			unicode: "{U+1EB3}", html: "&#7859;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и хвостиком сверху", "small a with breve and hook_above"],
			recipe: ["a" GetChar("breve", "hook_above"), Chr(0x0103) GetChar("hook_above")],
			recipeAlt: ["a" GetChar("dotted_circle", "breve", "dotted_circle", "hook_above"), Chr(0x0103) GetChar("dotted_circle", "hook_above")],
			symbol: Chr(0x1EB3)
		},
		"lat_c_let_a_breve_tilde", {
			unicode: "{U+1EB4}", html: "&#7860;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с краткой и тильдой", "capital A with breve and tilde"],
			recipe: ["A" GetChar("breve", "tilde"), Chr(0x0102) GetChar("tilde")],
			recipeAlt: ["A" GetChar("dotted_circle", "breve", "dotted_circle", "tilde"), Chr(0x0102) GetChar("dotted_circle", "tilde")],
			symbol: Chr(0x1EB4)
		},
		"lat_s_let_a_breve_tilde", {
			unicode: "{U+1EB5}", html: "&#7861;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с краткой и тильдой", "small a with breve and tilde"],
			recipe: ["a" GetChar("breve", "tilde"), Chr(0x0103) GetChar("tilde")],
			recipeAlt: ["a" GetChar("dotted_circle", "breve", "dotted_circle", "tilde"), Chr(0x0103) GetChar("dotted_circle", "tilde")],
			symbol: Chr(0x1EB5)
		},
		"lat_c_let_a_breve_inverted", {
			unicode: "{U+0202}", html: "&#514;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с перевёрнутой краткой", "capital A with inverted breve"],
			recipe: "A" GetChar("breve_inverted"),
			recipeAlt: "A" GetChar("dotted_circle", "breve_inverted"),
			symbol: Chr(0x0202)
		},
		"lat_s_let_a_breve_inverted", {
			unicode: "{U+0203}", html: "&#515;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с перевёрнутой краткой", "small a with inverted breve"],
			recipe: "a" GetChar("breve_inverted"),
			recipeAlt: "a" GetChar("dotted_circle", "breve_inverted"),
			symbol: Chr(0x0203)
		},
		"lat_c_let_a_circumflex", {
			unicode: "{U+00C2}", html: "&#194;", entity: "&Acirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с циркумфлексом", "capital A with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [A]",
			recipe: "A" GetChar("circumflex"),
			recipeAlt: "A" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x00C2)
		},
		"lat_s_let_a_circumflex", {
			unicode: "{U+00E2}", html: "&#226;", entity: "&acirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с циркумфлексом", "small a with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [a]",
			recipe: "a" GetChar("circumflex"),
			recipeAlt: "a" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x00E2)
		},
		"lat_c_let_a_circumflex_acute", {
			unicode: "{U+1EA4}", html: "&#7844;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и акутом", "capital A with circumflex and acute"],
			recipe: ["A" GetChar("circumflex", "acute"), Chr(0x00C2) GetChar("acute")],
			recipeAlt: ["A" GetChar("dotted_circle", "circumflex", "dotted_circle", "acute"), Chr(0x00C2) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1EA4)
		},
		"lat_s_let_a_circumflex_acute", {
			unicode: "{U+1EA5}", html: "&#7845;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и акутом", "small a with circumflex and acute"],
			recipe: ["a" GetChar("circumflex", "acute"), Chr(0x00E2) GetChar("acute")],
			recipeAlt: ["a" GetChar("dotted_circle", "circumflex", "dotted_circle", "acute"), Chr(0x00E2) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1EA5)
		},
		"lat_c_let_a_circumflex_dot_below", {
			unicode: "{U+1EAC}", html: "&#7852;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и точкой снизу", "capital A with circumflex and dot below"],
			recipe: ["A" GetChar("circumflex", "dot_below"), Chr(0x00C2) GetChar("dot_below")],
			recipeAlt: ["A" GetChar("dotted_circle", "circumflex", "dotted_circle", "dot_below"), Chr(0x00C2) GetChar("dotted_circle", "dot_below")],
			symbol: Chr(0x1EAC)
		},
		"lat_s_let_a_circumflex_dot_below", {
			unicode: "{U+1EAD}", html: "&#7853;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и точкой снизу", "small a with circumflex and dot below"],
			recipe: ["a" GetChar("circumflex", "dot_below"), Chr(0x00E2) GetChar("dot_below")],
			recipeAlt: ["a" GetChar("dotted_circle", "circumflex", "dotted_circle", "dot_below"), Chr(0x00E2) GetChar("dotted_circle", "dot_below")],
			symbol: Chr(0x1EAD)
		},
		"lat_c_let_a_circumflex_grave", {
			unicode: "{U+1EA6}", html: "&#7846;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и грависом", "capital A with circumflex and grave"],
			recipe: ["A" GetChar("circumflex", "grave"), Chr(0x00C2) GetChar("grave")],
			recipeAlt: ["A" GetChar("dotted_circle", "circumflex", "dotted_circle", "grave"), Chr(0x00C2) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1EA6)
		},
		"lat_s_let_a_circumflex_grave", {
			unicode: "{U+1EA7}", html: "&#7847;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и грависом", "small a with circumflex and grave"],
			recipe: ["a" GetChar("circumflex", "grave"), Chr(0x00E2) GetChar("grave")],
			recipeAlt: ["a" GetChar("dotted_circle", "circumflex", "dotted_circle", "grave"), Chr(0x00E2) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1EA7)
		},
		"lat_c_let_a_circumflex_hook_above", {
			unicode: "{U+1EA8}", html: "&#7848;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и хвостиком сверху", "capital A with circumflex and hook above"],
			recipe: ["A" GetChar("circumflex", "hook_above"), Chr(0x00C2) GetChar("hook_above")],
			recipeAlt: ["A" GetChar("dotted_circle", "circumflex", "dotted_circle", "hook_above"), Chr(0x00C2) GetChar("dotted_circle", "hook_above")],
			symbol: Chr(0x1EA8)
		},
		"lat_s_let_a_circumflex_hook_above", {
			unicode: "{U+1EA9}", html: "&#7849;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и хвостиком сверху", "small a with circumflex and hook above"],
			recipe: ["a" GetChar("circumflex", "hook_above"), Chr(0x00E2) GetChar("hook_above")],
			recipeAlt: ["a" GetChar("dotted_circle", "circumflex", "dotted_circle", "hook_above"), Chr(0x00E2) GetChar("dotted_circle", "hook_above")],
			symbol: Chr(0x1EA9)
		},
		"lat_c_let_a_circumflex_tilde", {
			unicode: "{U+1EAA}", html: "&#7850;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с циркумфлексом и тильдой", "capital A with circumflex and tilde"],
			recipe: ["A" GetChar("circumflex", "tilde"), Chr(0x00C2) GetChar("tilde")],
			recipeAlt: ["A" GetChar("dotted_circle", "circumflex", "dotted_circle", "tilde"), Chr(0x00C2) GetChar("dotted_circle", "tilde")],
			symbol: Chr(0x1EAA)
		},
		"lat_s_let_a_circumflex_tilde", {
			unicode: "{U+1EAB}", html: "&#7851;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с циркумфлексом и тильдой", "small a with circumflex and tilde"],
			recipe: ["a" GetChar("circumflex", "tilde"), Chr(0x00E2) GetChar("tilde")],
			recipeAlt: ["a" GetChar("dotted_circle", "circumflex", "dotted_circle", "tilde"), Chr(0x00E2) GetChar("dotted_circle", "tilde")],
			symbol: Chr(0x1EAB)
		},
		"lat_c_let_a_caron", {
			unicode: "{U+01CD}", html: "&#461;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с гачеком", "capital A with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [A]",
			recipe: "A" GetChar("caron"),
			recipeAlt: "A" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x01CD)
		},
		"lat_s_let_a_caron", {
			unicode: "{U+01CE}", html: "&#462;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с гачеком", "small a with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [a]",
			recipe: "a" GetChar("caron"),
			recipeAlt: "a" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x01CE)
		},
		"lat_c_let_a_dot_above", {
			unicode: "{U+0226}", html: "&#550;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с точкой сверху", "capital A with dot above"],
			recipe: "A" GetChar("dot_above"),
			recipeAlt: "A" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x0226)
		},
		"lat_s_let_a_dot_above", {
			unicode: "{U+0227}", html: "&#551;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с точкой сверху", "small a with dot above"],
			recipe: "a" GetChar("dot_above"),
			recipeAlt: "a" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x0227)
		},
		"lat_c_let_a_dot_above_macron", {
			unicode: "{U+01E0}", html: "&#480;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с точкой сверху и макроном", "capital A with dot above and macron"],
			recipe: ["A" GetChar("dot_above", "macron"), Chr(0x0226) GetChar("macron")],
			recipeAlt: ["A" GetChar("dotted_circle", "dot_above", "dotted_circle", "macron"), Chr(0x0226) GetChar("dotted_circle", "macron")],
			symbol: Chr(0x01E0)
		},
		"lat_s_let_a_dot_above_macron", {
			unicode: "{U+01E1}", html: "&#481;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с точкой сверху и макроном", "small a with dot above and macron"],
			recipe: ["a" GetChar("dot_above", "macron"), Chr(0x0227) GetChar("macron")],
			recipeAlt: ["a" GetChar("dotted_circle", "dot_above", "dotted_circle", "macron"), Chr(0x0227) GetChar("dotted_circle", "macron")],
			symbol: Chr(0x01E1)
		},
		"lat_c_let_a_dot_below", {
			unicode: "{U+1EA0}", html: "&#7840;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с точкой снизу", "capital A with dot below"],
			recipe: "A" GetChar("dot_below"),
			recipeAlt: "A" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1EA0)
		},
		"lat_s_let_a_dot_below", {
			unicode: "{U+1EA1}", html: "&#7841;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с точкой снизу", "small a with dot below"],
			recipe: "a" GetChar("dot_below"),
			recipeAlt: "a" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1EA1)
		},
		"lat_c_let_a_diaeresis", {
			unicode: "{U+00C4}", html: "&#196;", entity: "&Auml;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с диерезисом", "capital A with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [A]",
			recipe: "A" GetChar("diaeresis"),
			recipeAlt: "A" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x00C4)
		},
		"lat_s_let_a_diaeresis", {
			unicode: "{U+00E4}", html: "&#228;", entity: "&auml;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с диерезисом", "small a with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [a]",
			recipe: "a" GetChar("diaeresis"),
			recipeAlt: "a" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x00E4)
		},
		"lat_c_let_a_diaeresis_macron", {
			unicode: "{U+01DE}", html: "&#478;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с диерезисом и макроном", "capital A with diaeresis and macron"],
			recipe: ["A" GetChar("diaeresis", "macron"), Chr(0x00C4) GetChar("macron")],
			recipeAlt: ["A" GetChar("dotted_circle", "diaeresis", "dotted_circle", "macron"), Chr(0x00C4) GetChar("dotted_circle", "macron")],
			symbol: Chr(0x01DE)
		},
		"lat_s_let_a_diaeresis_macron", {
			unicode: "{U+01DF}", html: "&#479;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с диерезисом и макроном", "small a with diaeresis and macron"],
			recipe: ["a" GetChar("diaeresis", "macron"), Chr(0x00E4) GetChar("macron")],
			recipeAlt: ["a" GetChar("dotted_circle", "diaeresis", "dotted_circle", "macron"), Chr(0x00E4) GetChar("dotted_circle", "macron")],
			symbol: Chr(0x01DF)
		},
		"lat_c_let_a_grave", {
			unicode: "{U+00C0}", html: "&#192;", entity: "&Agrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с грависом", "capital A with grave"],
			recipe: "A" GetChar("grave"),
			recipeAlt: "A" GetChar("dotted_circle", "grave"),
			symbol: Chr(0x00C0)
		},
		"lat_s_let_a_grave", {
			unicode: "{U+00E0}", html: "&#224;", entity: "&agrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с грависом", "small a with grave"],
			recipe: "a" GetChar("grave"),
			recipeAlt: "a" GetChar("dotted_circle", "grave"),
			symbol: Chr(0x00E0)
		},
		"lat_c_let_a_grave_double", {
			unicode: "{U+0200}", html: "&#512;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с двойным грависом", "capital A with double grave"],
			recipe: "A" GetChar("grave_double"),
			recipeAlt: "A" GetChar("dotted_circle", "grave_double"),
			symbol: Chr(0x0200)
		},
		"lat_s_let_a_grave_double", {
			unicode: "{U+0201}", html: "&#513;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с двойным грависом", "small a with double grave"],
			recipe: "a" GetChar("grave_double"),
			recipeAlt: "a" GetChar("dotted_circle", "grave_double"),
			symbol: Chr(0x0201)
		},
		"lat_c_let_a_hook_above", {
			unicode: "{U+1EA2}", html: "&#7842;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с хвостиком сверху", "capital A with hook above"],
			recipe: "A" GetChar("hook_above"),
			recipeAlt: "A" GetChar("dotted_circle", "hook_above"),
			symbol: Chr(0x1EA2)
		},
		"lat_s_let_a_hook_above", {
			unicode: "{U+1EA3}", html: "&#7843;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с хвостиком сверху", "small a with hook above"],
			recipe: "a" GetChar("hook_above"),
			recipeAlt: "a" GetChar("dotted_circle", "hook_above"),
			symbol: Chr(0x1EA3)
		},
		"lat_s_let_a_retroflex_hook", {
			unicode: "{U+1D8F}", html: "&#7567;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с ретрофлексным крюком", "small a with retroflex hook"],
			recipe: "a" GetChar("retroflex_hook_below"),
			recipeAlt: "a" GetChar("dotted_circle", "retroflex_hook_below"),
			symbol: Chr(0x1D8F)
		},
		"lat_c_let_a_macron", {
			unicode: "{U+0100}", html: "&#256;", entity: "&Amacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с макроном", "capital A with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [A]",
			recipe: "A" GetChar("macron"),
			recipeAlt: "A" GetChar("dotted_circle", "macron"),
			symbol: Chr(0x0100)
		},
		"lat_s_let_a_macron", {
			unicode: "{U+0101}", html: "&#257;", entity: "&amacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с макроном", "small a with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [a]",
			recipe: "a" GetChar("macron"),
			recipeAlt: "a" GetChar("dotted_circle", "macron"),
			symbol: Chr(0x0101)
		},
		"lat_c_let_a_ring_above", {
			unicode: "{U+00C5}", html: "&#197;", entity: "&Aring;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с кольцом сверху", "capital A with ring above"],
			recipe: "A" GetChar("ring_above"),
			recipeAlt: "A" GetChar("dotted_circle", "ring_above"),
			symbol: Chr(0x00C5)
		},
		"lat_s_let_a_ring_above", {
			unicode: "{U+00E5}", html: "&#229;", entity: "&aring;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с кольцом сверху", "small a with ring above"],
			recipe: "a" GetChar("ring_above"),
			recipeAlt: "a" GetChar("dotted_circle", "ring_above"),
			symbol: Chr(0x00E5)
		},
		"lat_c_let_a_ring_above_acute", {
			unicode: "{U+01FA}", html: "&#506;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с кольцом сверху и акутом", "capital A with ring above and acute"],
			recipe: ["A" GetChar("ring_above", "acute"), Chr(0x00C5) GetChar("acute")],
			recipeAlt: ["A" GetChar("dotted_circle", "ring_above", "dotted_circle", "acute"), Chr(0x00C5) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x01FA)
		},
		"lat_s_let_a_ring_above_acute", {
			unicode: "{U+01FB}", html: "&#507;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с кольцом сверху и акутом", "small a with ring above and acute"],
			recipe: ["a" GetChar("ring_above", "acute"), Chr(0x00E5) GetChar("acute")],
			recipeAlt: ["a" GetChar("dotted_circle", "ring_above", "dotted_circle", "acute"), Chr(0x00E5) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x01FB)
		},
		"lat_c_let_a_ring_below", {
			unicode: "{U+1E00}", html: "&#7680;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с кольцом снизу", "capital A with ring below"],
			recipe: "A" GetChar("ring_below"),
			recipeAlt: "A" GetChar("dotted_circle", "ring_below"),
			symbol: Chr(0x1E00)
		},
		"lat_s_let_a_ring_below", {
			unicode: "{U+1E01}", html: "&#7681;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с кольцом снизу", "small a with ring below"],
			recipe: "a" GetChar("ring_below"),
			recipeAlt: "a" GetChar("dotted_circle", "ring_below"),
			symbol: Chr(0x1E01)
		},
		"lat_c_let_a_solidus_long", {
			unicode: "{U+023A}", html: "&#570;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная A с наклонной чертой", "capital A with solidus"],
			recipe: "A" GetChar("solidus_long"),
			recipeAlt: "A" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0x023A)
		},
		"lat_s_let_a_solidus_long", {
			unicode: "{U+2C65}", html: "&#11365;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная a с наклонной чертой", "small a with solidus"],
			recipe: "a" GetChar("solidus_long"),
			recipeAlt: "a" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0x2C65)
		},
		"lat_c_let_a_ogonek", {
			unicode: "{U+0104}", html: "&#260;", entity: "&Aogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с огонэком", "capital A with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [A]",
			recipe: "A" GetChar("ogonek"),
			recipeAlt: "A" GetChar("dotted_circle", "ogonek"),
			symbol: Chr(0x0104)
		},
		"lat_s_let_a_ogonek", {
			unicode: "{U+0105}", html: "&#261;", entity: "&aogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с огонэком", "small a with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [a]",
			recipe: "a" GetChar("ogonek"),
			recipeAlt: "a" GetChar("dotted_circle", "ogonek"),
			symbol: Chr(0x0105)
		},
		"lat_c_let_a_tilde", {
			unicode: "{U+00C3}", html: "&#195;", entity: "&Atilde;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная A с тильдой", "capital A with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [A]",
			recipe: "A" GetChar("tilde"),
			recipeAlt: "A" GetChar("dotted_circle", "tilde"),
			symbol: Chr(0x00C3)
		},
		"lat_s_let_a_tilde", {
			unicode: "{U+00E3}", html: "&#227;", entity: "&atilde;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная a с тильдой", "small a with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [a]",
			recipe: "a" GetChar("tilde"),
			recipeAlt: "a" GetChar("dotted_circle", "tilde"),
			symbol: Chr(0x00E3)
		},
		;
		"lat_c_let_b_dot_above", {
			unicode: "{U+1E02}", html: "&#7682;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с точкой сверху", "capital B with dot above"],
			recipe: "B" GetChar("dot_above"),
			recipeAlt: "B" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E02)
		},
		"lat_s_let_b_dot_above", {
			unicode: "{U+1E03}", html: "&#7683;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с точкой сверху", "small b with dot above"],
			recipe: "b" GetChar("dot_above"),
			recipeAlt: "b" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E03)
		},
		"lat_c_let_b_dot_below", {
			unicode: "{U+1E04}", html: "&#7684;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с точкой снизу", "capital B with dot below"],
			recipe: "B" GetChar("dot_below"),
			recipeAlt: "B" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1E04)
		},
		"lat_s_let_b_dot_below", {
			unicode: "{U+1E05}", html: "&#7685;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с точкой снизу", "small b with dot below"],
			recipe: "b" GetChar("dot_below"),
			recipeAlt: "b" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1E05)
		},
		"lat_c_let_b_hook", {
			unicode: "{U+0181}", html: "&#385;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная B с крючком", "capital B with hook"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift "[B]",
			recipe: "B" GetChar("arrow_left"),
			symbol: Chr(0x0181)
		},
		"lat_s_let_b_hook", {
			unicode: "{U+0253}", html: "&#595;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная b с крючком", "small b with hook"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift "[b]",
			recipe: "b" . GetChar("arrow_left"),
			symbol: Chr(0x0253)
		},
		"lat_s_let_b_palatal_hook", {
			unicode: "{U+1D80}", html: "&#7552;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с палатальным крюком", "small b with palatal hook"],
			recipe: "b" GetChar("palatal_hook_below"),
			recipeAlt: "b" GetChar("dotted_circle", "palatal_hook_below"),
			symbol: Chr(0x1D80)
		},
		"lat_c_let_b_flourish", {
			unicode: "{U+A796}", html: "&#42902;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с завитком", "capital B with flourish"],
			recipe: "B" . GetChar("arrow_left_ushaped"),
			symbol: Chr(0xA796)
		},
		"lat_s_let_b_flourish", {
			unicode: "{U+A797}", html: "&#42903;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с завитком", "small b with flourish"],
			recipe: "b" . GetChar("arrow_left_ushaped"),
			symbol: Chr(0xA797)
		},
		"lat_c_let_b_line_below", {
			unicode: "{U+1E06}", html: "&#7686;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с чертой снизу", "capital B with line below"],
			recipe: "B" GetChar("macron_below"),
			recipeAlt: "B" GetChar("dotted_circle", "macron_below"),
			symbol: Chr(0x1E06)
		},
		"lat_s_let_b_line_below", {
			unicode: "{U+1E07}", html: "&#7687;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с чертой снизу", "small b with line below"],
			recipe: "b" GetChar("macron_below"),
			recipeAlt: "b" GetChar("dotted_circle", "macron_below"),
			symbol: Chr(0x1E07)
		},
		"lat_c_let_b_stroke_short", {
			unicode: "{U+0243}", html: "&#579;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная B со штрихом", "capital B with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[B]",
			recipe: "B" GetChar("stroke_short"),
			recipeAlt: "B" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x0243)
		},
		"lat_s_let_b_stroke_short", {
			unicode: "{U+0180}", html: "&#384;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная b со штрихом", "small b with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[b]",
			recipe: "b" GetChar("stroke_short"),
			recipeAlt: "b" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x0180)
		},
		"lat_s_let_b_tilde_overlay", {
			unicode: "{U+1D6C}", html: "&#7532;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b со тильдой посередине", "small b with middle tilde"],
			recipe: "b" GetChar("tilde_overlay"),
			recipeAlt: "b" GetChar("dotted_circle", "tilde_overlay"),
			symbol: Chr(0x1D6C)
		},
		"lat_c_let_b_topbar", {
			unicode: "{U+0182}", html: "&#386;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная B с чертой сверху", "capital B with topbar"],
			recipe: "B" . GetChar("arrow_up"),
			symbol: Chr(0x0182)
		},
		"lat_s_let_b_topbar", {
			unicode: "{U+0183}", html: "&#387;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная b с чертой сверху", "small b with topbar"],
			recipe: "b" . GetChar("arrow_up"),
			symbol: Chr(0x0183)
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
			recipeAlt: "C" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x0106)
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
			recipeAlt: "c" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x0107)
		},
		"lat_c_let_c_circumflex", {
			unicode: "{U+0108}", html: "&#264;", entity: "&Ccirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная C с циркумфлексом", "capital C with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [C]",
			recipe: "C" GetChar("circumflex"),
			recipeAlt: "C" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x0108)
		},
		"lat_s_let_c_circumflex", {
			unicode: "{U+0109}", html: "&#265;", entity: "&ccirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная c с циркумфлексом", "small c with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [c]",
			recipe: "c" GetChar("circumflex"),
			recipeAlt: "c" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x0109)
		},
		"lat_c_let_c_caron", {
			unicode: "{U+010C}", html: "&#268;", entity: "&Ccaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная C с гачеком", "capital C with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [C]",
			recipe: "C" GetChar("caron"),
			recipeAlt: "C" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x010C)
		},
		"lat_s_let_c_caron", {
			unicode: "{U+010D}", html: "&#269;", entity: "&ccaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная c с гачеком", "small c with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [c]",
			recipe: "c" GetChar("caron"),
			recipeAlt: "c" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x010D)
		},
		"lat_c_let_c_cedilla", {
			unicode: "{U+00C7}", html: "&#199;", entity: "&Ccedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная C с седилью", "capital C with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [C]",
			recipe: "C" GetChar("cedilla"),
			recipeAlt: "C" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x00C7)
		},
		"lat_s_let_c_cedilla", {
			unicode: "{U+00E7}", html: "&#231;", entity: "&ccedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная c с седилью", "small c with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [c]",
			recipe: "c" GetChar("cedilla"),
			recipeAlt: "c" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x00E7)
		},
		"lat_c_let_c_cedilla_acute", {
			unicode: "{U+1E08}", html: "&#7688;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с седилью", "capital C with cedilla"],
			recipe: ["C" GetChar("cedilla", "acute"), Chr(0x00C7) GetChar("acute")],
			recipeAlt: ["C" GetChar("dotted_circle", "cedilla", "dotted_circle", "acute"), Chr(0x00C7) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1E08)
		},
		"lat_s_let_c_cedilla_acute", {
			unicode: "{U+1E09}", html: "&#7689;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с седилью", "small c with cedilla"],
			recipe: ["c" GetChar("cedilla", "acute"), Chr(0x00E7) GetChar("acute")],
			recipeAlt: ["c" GetChar("dotted_circle", "cedilla", "dotted_circle", "acute"), Chr(0x00E7) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1E09)
		},
		"lat_s_let_c_curl", {
			unicode: "{U+0255}", html: "&#597;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с завитком", "small c with curl"],
			recipe: "c" GetChar("arrow_left_ushaped"),
			symbol: Chr(0x0255)
		},
		"lat_c_let_c_dot_above", {
			unicode: "{U+010A}", html: "&#266;", entity: "&Cdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с точкой сверху", "capital C with dot above"],
			recipe: "C" GetChar("dot_above"),
			recipeAlt: "C" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x010A)
		},
		"lat_s_let_c_dot_above", {
			unicode: "{U+010B}", html: "&#267;", entity: "&cdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с точкой сверху", "small c with dot above"],
			recipe: "c" GetChar("dot_above"),
			recipeAlt: "c" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x010B)
		},
		"lat_c_let_c_reversed_dot_middle", {
			unicode: "{U+A73E}", html: "&#42814;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная обратная C с точкой", "capital reversed C with middle dot"],
			recipe: "C" GetChar("arrow_left_circle") ".",
			symbol: Chr(0xA73E)
		},
		"lat_s_let_c_reversed_dot_middle", {
			unicode: "{U+A73F}", html: "&#42815;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная обратная c с точкой", "small reversed c with middle dot"],
			recipe: "c" GetChar("arrow_left_circle") ".",
			symbol: Chr(0xA73F)
		},
		"lat_c_let_c_hook", {
			unicode: "{U+0187}", html: "&#391;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G с крючком", "capital G with hook"],
			recipe: "G" . GetChar("arrow_up"),
			symbol: Chr(0x0187)
		},
		"lat_s_let_c_hook", {
			unicode: "{U+0188}", html: "&#392;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с крючком", "small c with hook"],
			recipe: "c" . GetChar("arrow_up"),
			symbol: Chr(0x0188)
		},
		"lat_c_let_c_palatal_hook", {
			unicode: "{U+A7C4}", html: "&#42948;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с палатальным крюком", "capital C with palatal hook"],
			recipe: "C" GetChar("palatal_hook_below"),
			recipeAlt: "C" GetChar("dotted_circle", "palatal_hook_below"),
			symbol: Chr(0xA7C4)
		},
		"lat_s_let_c_palatal_hook", {
			unicode: "{U+A794}", html: "&#42900;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с палатальным крюком", "small c with palatal hook"],
			recipe: "c" GetChar("palatal_hook_below"),
			recipeAlt: "c" GetChar("dotted_circle", "palatal_hook_below"),
			symbol: Chr(0xA794)
		},
		"lat_s_let_c_retroflex_hook", {
			unicode: "{U+1DF1D}", html: "&#122653;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с ретрофлксным крюком", "small c with retroflex hook"],
			recipe: "c" GetChar("retroflex_hook_below"),
			recipeAlt: "c" GetChar("dotted_circle", "retroflex_hook_below"),
			symbol: Chr(0x1DF1D)
		},
		"lat_c_let_c_solidus_long", {
			unicode: "{U+023B}", html: "&#571;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C с косой чертой", "capital C with solidus"],
			recipe: "C" GetChar("solidus_long"),
			recipeAlt: "C" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0x023B)
		},
		"lat_s_let_c_solidus_long", {
			unicode: "{U+023C}", html: "&#572;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c с косой чертой", "small c with solidus"],
			recipe: "c" GetChar("solidus_long"),
			recipeAlt: "c" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0x023C)
		},
		"lat_c_let_c_stroke_short", {
			unicode: "{U+A792}", html: "&#42898;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная C со штрихом", "capital C with stroke"],
			recipe: "C" GetChar("stroke_short"),
			recipeAlt: "C" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0xA792)
		},
		"lat_s_let_c_stroke_short", {
			unicode: "{U+A793}", html: "&#42899;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная c со штрихом", "small c with stroke"],
			recipe: "c" GetChar("stroke_short"),
			recipeAlt: "c" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0xA793)
		},
		;
		"lat_c_let_d_circumflex_below", {
			unicode: "{U+1E12}", html: "&#7698;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D с циркумфлексом снизу", "capital D with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift RightShift " [D]",
			recipe: "D" GetChar("circumflex_below"),
			recipeAlt: "D" GetChar("dotted_circle", "circumflex_below"),
			symbol: Chr(0x1E12)
		},
		"lat_s_let_d_circumflex_below", {
			unicode: "{U+1E13}", html: "&#7699;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d с циркумфлексом снизу", "small d with circumflex below"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift RightShift " [d]",
			recipe: "d" GetChar("circumflex_below"),
			recipeAlt: "d" GetChar("dotted_circle", "circumflex_below"),
			symbol: Chr(0x1E13)
		},
		"lat_c_let_d_caron", {
			unicode: "{U+010E}", html: "&#270;", entity: "&Dcaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D с гачеком", "capital D with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [D]",
			recipe: "D" GetChar("caron"),
			recipeAlt: "D" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x010E)
		},
		"lat_s_let_d_caron", {
			unicode: "{U+010F}", html: "&#271;", entity: "&dcaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d с гачеком", "small d with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [d]",
			recipe: "d" GetChar("caron"),
			recipeAlt: "d" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x010F)
		},
		"lat_c_let_d_cedilla", {
			unicode: "{U+1E10}", html: "&#7696;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D с седилью", "capital D with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [D]",
			recipe: "D" GetChar("cedilla"),
			recipeAlt: "D" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x1E10)
		},
		"lat_s_let_d_cedilla", {
			unicode: "{U+1E11}", html: "&#7697;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d с седилью", "small d with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [d]",
			recipe: "d" GetChar("cedilla"),
			recipeAlt: "d" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x1E11)
		},
		"lat_s_let_d_curl", {
			unicode: "{U+0221}", html: "&#545;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с завитком", "small d with curl"],
			recipe: "d" GetChar("arrow_left_ushaped"),
			symbol: Chr(0x0221)
		},
		"lat_c_let_d_dot_above", {
			unicode: "{U+1E0A}", html: "&#7690;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с точкой сверху", "capital D with dot above"],
			recipe: "D" GetChar("dot_above"),
			recipeAlt: "D" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E0A)
		},
		"lat_s_let_d_dot_above", {
			unicode: "{U+1E0B}", html: "&#7691;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с точкой сверху", "small d with dot above"],
			recipe: "d" GetChar("dot_above"),
			recipeAlt: "d" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E0B)
		},
		"lat_c_let_d_eth", {
			unicode: "{U+00D0}", html: "&#208;", entity: "&ETH;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная Эт", "capital Eth"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [D]",
			recipe: "D" GetChar("solidus_short"),
			recipeAlt: "D" GetChar("dotted_circle", "solidus_short"),
			symbol: Chr(0x00D0)
		},
		"lat_s_let_d_eth", {
			unicode: "{U+00F0}", html: "&#240;", entity: "&eth;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная эт", "small eth"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [d]",
			recipe: "d" GetChar("solidus_short"),
			recipeAlt: "d" GetChar("dotted_circle", "solidus_short"),
			symbol: Chr(0x00F0)
		},
		"lat_c_let_d_dot_below", {
			unicode: "{U+1E0C}", html: "&#7692;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с точкой снизу", "capital D with dot below"],
			recipe: "D" GetChar("dot_below"),
			recipeAlt: "D" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1E0C)
		},
		"lat_s_let_d_dot_below", {
			unicode: "{U+1E0D}", html: "&#7693;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с точкой снизу", "small d with dot below"],
			recipe: "d" GetChar("dot_below"),
			recipeAlt: "d" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1E0D)
		},
		"lat_c_let_d_hook", {
			unicode: "{U+018A}", html: "&#394;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с крючком", "capital D with hook"],
			recipe: "D" GetChar("arrow_left"),
			symbol: Chr(0x018A)
		},
		"lat_s_let_d_hook", {
			unicode: "{U+0257}", html: "&#599;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с крючком", "small d with hook"],
			recipe: "d" GetChar("arrow_left"),
			symbol: Chr(0x0257)
		},
		"lat_s_let_d_hook_retroflex_hook", {
			unicode: "{U+1D91}", html: "&#7569;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с хвостиком и ретрофлексным крюком", "small d with hook and retroflex hook"],
			recipe: "d" GetChar("arrow_left", "retroflex_hook_below"),
			recipeAlt: "d" GetChar("arrow_left", "dotted_circle", "retroflex_hook_below"),
			symbol: Chr(0x1D91)
		},
		"lat_s_let_d_palatal_hook", {
			unicode: "{U+1D81}", html: "&#7553;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с палатальным крюком", "small d with palatal hook"],
			recipe: "d" GetChar("palatal_hook_below"),
			recipeAlt: "d" GetChar("dotted_circle", "palatal_hook_below"),
			symbol: Chr(0x1D81)
		},
		"lat_s_let_d_retroflex_hook", {
			unicode: "{U+0256}", html: "&#598;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с ретрофлексным крюком", "small d with retroflex hook"],
			recipe: "d" GetChar("retroflex_hook_below"),
			recipeAlt: "d" GetChar("dotted_circle", "retroflex_hook_below"),
			symbol: Chr(0x0256)
		},
		"lat_c_let_d_line_below", {
			unicode: "{U+1E0E}", html: "&#7694;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с чертой снизу", "capital D with line below"],
			recipe: "D" GetChar("macron_below"),
			recipeAlt: "D" GetChar("dotted_circle", "macron_below"),
			symbol: Chr(0x1E0E)
		},
		"lat_s_let_d_line_below", {
			unicode: "{U+1E0F}", html: "&#7695;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с чертой снизу", "small d with line below"],
			recipe: "d" GetChar("macron_below"),
			recipeAlt: "d" GetChar("dotted_circle", "macron_below"),
			symbol: Chr(0x1E0F)
		},
		"lat_c_let_d_stroke_short", {
			unicode: "{U+0110}", html: "&#272;", entity: "&Dstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная D со штрихом", "capital D with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[D]",
			recipe: "D" GetChar("stroke_short"),
			recipeAlt: "D" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x0110)
		},
		"lat_s_let_d_stroke_short", {
			unicode: "{U+0111}", html: "&#273;", entity: "&dstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная d со штрихом", "small d with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[d]",
			recipe: "d" GetChar("stroke_short"),
			recipeAlt: "d" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x0111)
		},
		"lat_c_let_d_stroke_s2", {
			unicode: "{U+A7C7}", html: "&#42951;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D со штрихом посередине", "capital D with short stroke overlay"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[D]",
			recipe: "D" GetChar("stroke_long"),
			recipeAlt: "D" GetChar("dotted_circle", "stroke_long"),
			symbol: Chr(0xA7C7)
		},
		"lat_s_let_d_stroke_s2", {
			unicode: "{U+A7C8}", html: "&#42952;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d со штрихом посередине", "small d with short stroke overlay"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[d]",
			recipe: "d" GetChar("stroke_long"),
			recipeAlt: "d" GetChar("dotted_circle", "stroke_long"),
			symbol: Chr(0xA7C8)
		},
		"lat_s_let_d_tilde_overlay", {
			unicode: "{U+1D6D}", html: "&#7533;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d со тильдой посередине", "small d with middle tilde"],
			recipe: "d" GetChar("tilde_overlay"),
			recipeAlt: "d" GetChar("dotted_circle", "tilde_overlay"),
			symbol: Chr(0x1D6D)
		},
		"lat_c_let_d_topbar", {
			unicode: "{U+018B}", html: "&#395;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная D с чертой сверху", "capital D with topbar"],
			recipe: "D" . GetChar("arrow_up"),
			symbol: Chr(0x018B)
		},
		"lat_s_let_d_topbar", {
			unicode: "{U+018C}", html: "&#396;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная d с чертой сверху", "small d with topbar"],
			recipe: "d" . GetChar("arrow_up"),
			symbol: Chr(0x018C)
		},
		"lat_c_let_e_acute", {
			unicode: "{U+00C9}", html: "&#201;", entity: "&Eacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная E с акутом", "capital E with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[E]",
			recipe: "E" GetChar("acute"),
			recipeAlt: "E" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x00C9)
		},
		"lat_s_let_e_acute", {
			unicode: "{U+00E9}", html: "&#233;", entity: "&eacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная e с акутом", "small e with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[e]",
			recipe: "e" GetChar("acute"),
			recipeAlt: "e" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x00E9)
		},
		"lat_c_let_e_breve", {
			unicode: "{U+0114}", html: "&#276;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с краткой", "capital E with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[E]",
			recipe: "E" GetChar("breve"),
			recipeAlt: "E" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x0114)
		},
		"lat_s_let_e_breve", {
			unicode: "{U+0115}", html: "&#277;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с краткой", "small e with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[e]",
			recipe: "e" GetChar("breve"),
			recipeAlt: "e" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x0115)
		},
		"lat_c_let_e_breve_cedilla", {
			unicode: "{U+1E1C}", html: "&#7708;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с краткой и акутом", "capital E with breve and cedilla"],
			recipe: ["E" GetChar("breve", "cedilla"), Chr(0x0114) GetChar("cedilla")],
			recipeAlt: ["E" GetChar("dotted_circle", "breve", "dotted_circle", "cedilla"), Chr(0x0114) GetChar("dotted_circle", "cedilla")],
			symbol: Chr(0x1E1C)
		},
		"lat_s_let_e_breve_cedilla", {
			unicode: "{U+1E1D}", html: "&#7709;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с краткой и акутом", "small e with breve and cedilla"],
			recipe: ["e" GetChar("breve", "cedilla"), Chr(0x0115) GetChar("cedilla")],
			recipeAlt: ["e" GetChar("dotted_circle", "breve", "dotted_circle", "cedilla"), Chr(0x0115) GetChar("dotted_circle", "cedilla")],
			symbol: Chr(0x1E1D)
		},
		"lat_c_let_e_breve_inverted", {
			unicode: "{U+0206}", html: "&#518;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с перевёрнутой краткой", "capital E with inverted breve"],
			recipe: "E" GetChar("breve_inverted"),
			recipeAlt: "E" GetChar("dotted_circle", "breve_inverted"),
			symbol: Chr(0x0206)
		},
		"lat_s_let_e_breve_inverted", {
			unicode: "{U+0207}", html: "&#519;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с перевёрнутой краткой", "small e with inverted breve"],
			recipe: "e" GetChar("breve_inverted"),
			recipeAlt: "e" GetChar("dotted_circle", "breve_inverted"),
			symbol: Chr(0x0207)
		},
		"lat_c_let_e_circumflex", {
			unicode: "{U+00CA}", html: "&#202;", entity: "&Ecirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с циркумфлексом", "capital E with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [E]",
			recipe: "E" GetChar("circumflex"),
			recipeAlt: "E" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x00CA)
		},
		"lat_s_let_e_circumflex", {
			unicode: "{U+00EA}", html: "&#234;", entity: "&ecirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с циркумфлексом", "small e with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [e]",
			recipe: "e" GetChar("circumflex"),
			recipeAlt: "e" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x00EA)
		},
		"lat_c_let_e_circumflex_acute", {
			unicode: "{U+1EBE}", html: "&#7870;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и акутом", "capital E with circumflex and acute"],
			recipe: ["E" GetChar("circumflex", "acute"), Chr(0x00CA) GetChar("acute")],
			recipeAlt: ["E" GetChar("dotted_circle", "circumflex", "dotted_circle", "acute"), Chr(0x00CA) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1EBE)
		},
		"lat_s_let_e_circumflex_acute", {
			unicode: "{U+1EBF}", html: "&#7871;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и акутом", "small e with circumflex and acute"],
			recipe: ["e" GetChar("circumflex", "acute"), Chr(0x00EA) GetChar("acute")],
			recipeAlt: ["e" GetChar("dotted_circle", "circumflex", "dotted_circle", "acute"), Chr(0x00EA) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1EBF)
		},
		"lat_c_let_e_circumflex_dot_below", {
			unicode: "{U+1EC6}", html: "&#7878;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и точкой снизу", "capital E with circumflex and dot below"],
			recipe: ["E" GetChar("circumflex", "dot_below"), Chr(0x00CA) GetChar("dot_below")],
			recipeAlt: ["E" GetChar("dotted_circle", "circumflex", "dotted_circle", "dot_below"), Chr(0x00CA) GetChar("dotted_circle", "dot_below")],
			symbol: Chr(0x1EC6)
		},
		"lat_s_let_e_circumflex_dot_below", {
			unicode: "{U+1EC7}", html: "&#7879;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и точкой снизу", "small e with circumflex and dot below"],
			recipe: ["e" GetChar("circumflex", "dot_below"), Chr(0x00EA) GetChar("dot_below")],
			recipeAlt: ["e" GetChar("dotted_circle", "circumflex", "dotted_circle", "dot_below"), Chr(0x00EA) GetChar("dotted_circle", "dot_below")],
			symbol: Chr(0x1EC7)
		},
		"lat_c_let_e_circumflex_grave", {
			unicode: "{U+1EC0}", html: "&#7872;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и грависом", "capital E with circumflex and grave"],
			recipe: ["E" GetChar("circumflex", "grave"), Chr(0x00CA) GetChar("grave")],
			recipeAlt: ["E" GetChar("dotted_circle", "circumflex", "dotted_circle", "grave"), Chr(0x00CA) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1EC0)
		},
		"lat_s_let_e_circumflex_grave", {
			unicode: "{U+1EC1}", html: "&#7873;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и грависом", "small e with circumflex and grave"],
			recipe: ["e" GetChar("circumflex", "grave"), Chr(0x00EA) GetChar("grave")],
			recipeAlt: ["e" GetChar("dotted_circle", "circumflex", "dotted_circle", "grave"), Chr(0x00EA) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1EC1)
		},
		"lat_c_let_e_circumflex_hook_above", {
			unicode: "{U+1EC2}", html: "&#7874;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и хвостиком сверху", "capital E with circumflex and hook above"],
			recipe: ["E" GetChar("circumflex", "hook_above"), Chr(0x00CA) GetChar("hook_above")],
			recipeAlt: ["E" GetChar("dotted_circle", "circumflex", "dotted_circle", "hook_above"), Chr(0x00CA) GetChar("dotted_circle", "hook_above")],
			symbol: Chr(0x1EC2)
		},
		"lat_s_let_e_circumflex_hook_above", {
			unicode: "{U+1EC3}", html: "&#7875;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и хвостиком сверху", "small e with circumflex and hook above"],
			recipe: ["e" GetChar("circumflex", "hook_above"), Chr(0x00EA) GetChar("hook_above")],
			recipeAlt: ["e" GetChar("dotted_circle", "circumflex", "dotted_circle", "hook_above"), Chr(0x00EA) GetChar("dotted_circle", "hook_above")],
			symbol: Chr(0x1EC3)
		},
		"lat_c_let_e_circumflex_tilde", {
			unicode: "{U+1EC4}", html: "&#7876;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с циркумфлексом и тильдой", "capital E with circumflex and tilde"],
			recipe: ["E" GetChar("circumflex", "tilde"), Chr(0x00CA) GetChar("tilde")],
			recipeAlt: ["E" GetChar("dotted_circle", "circumflex", "dotted_circle", "tilde"), Chr(0x00CA) GetChar("dotted_circle", "tilde")],
			symbol: Chr(0x1EC4)
		},
		"lat_s_let_e_circumflex_tilde", {
			unicode: "{U+1EC5}", html: "&#7877;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с циркумфлексом и тильдой", "small e with circumflex and tilde"],
			recipe: ["e" GetChar("circumflex", "tilde"), Chr(0x00EA) GetChar("tilde")],
			recipeAlt: ["e" GetChar("dotted_circle", "circumflex", "dotted_circle", "tilde"), Chr(0x00EA) GetChar("dotted_circle", "tilde")],
			symbol: Chr(0x1EC5)
		},
		"lat_c_let_e_caron", {
			unicode: "{U+011A}", html: "&#282;", entity: "&Ecaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с гачеком", "capital E with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [E]",
			recipe: "E" GetChar("caron"),
			recipeAlt: "E" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x011A)
		},
		"lat_s_let_e_caron", {
			unicode: "{U+011B}", html: "&#283;", entity: "&ecaron;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с гачеком", "small e with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [e]",
			recipe: "e" GetChar("caron"),
			recipeAlt: "e" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x011B)
		},
		"lat_c_let_e_cedilla", {
			unicode: "{U+0228}", html: "&#552;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с седилью", "capital E with cedilla"],
			recipe: "E" GetChar("cedilla"),
			recipeAlt: "E" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x0228)
		},
		"lat_s_let_e_cedilla", {
			unicode: "{U+0229}", html: "&#553;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с седилью", "small e with cedilla"],
			recipe: "e" GetChar("cedilla"),
			recipeAlt: "e" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x0229)
		},
		"lat_c_let_e_dot_above", {
			unicode: "{U+0116}", html: "&#278;", entity: "&Edot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с точкой сверху", "capital E with dot above"],
			recipe: "E" GetChar("dot_above"),
			recipeAlt: "E" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x0116)
		},
		"lat_s_let_e_dot_above", {
			unicode: "{U+0117}", html: "&#279;", entity: "&edot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с точкой сверху", "small e with dot above"],
			recipe: "e" GetChar("dot_above"),
			recipeAlt: "e" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x0117)
		},
		"lat_c_let_e_dot_below", {
			unicode: "{U+1EB8}", html: "&#7864;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с точкой снизу", "capital E with dot below"],
			recipe: "E" GetChar("dot_below"),
			recipeAlt: "E" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1EB8)
		},
		"lat_s_let_e_dot_below", {
			unicode: "{U+1EB9}", html: "&#7865;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с точкой снизу", "small e with dot below"],
			recipe: "e" GetChar("dot_below"),
			recipeAlt: "e" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1EB9)
		},
		"lat_c_let_e_diaeresis", {
			unicode: "{U+00CB}", html: "&#203;", entity: "&Euml;",
			titlesAlt: True,
			group: ["Latin Accented"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [E]",
			tags: ["прописная E с диерезисом", "capital EA with diaeresis"],
			recipe: "E" GetChar("diaeresis"),
			recipeAlt: "E" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x00CB)
		},
		"lat_s_let_e_diaeresis", {
			unicode: "{U+00EB}", html: "&#235;", entity: "&euml;",
			titlesAlt: True,
			group: ["Latin Accented"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [e]",
			tags: ["строчная e с диерезисом", "small e with diaeresis"],
			recipe: "e" GetChar("diaeresis"),
			recipeAlt: "e" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x00EB)
		},
		"lat_c_let_e_grave", {
			unicode: "{U+00C8}", html: "&#200;", entity: "&Egrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с грависом", "capital E with grave"],
			recipe: "E" GetChar("grave"),
			recipeAlt: "E" GetChar("dotted_circle", "grave"),
			symbol: Chr(0x00C8)
		},
		"lat_s_let_e_grave", {
			unicode: "{U+00E8}", html: "&#232;", entity: "&egrave;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с грависом", "small e with grave"],
			recipe: "e" GetChar("grave"),
			recipeAlt: "e" GetChar("dotted_circle", "grave"),
			symbol: Chr(0x00E8)
		},
		"lat_c_let_e_grave_double", {
			unicode: "{U+0204}", html: "&#516;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с двойным грависом", "capital E with double grave"],
			recipe: "E" GetChar("grave_double"),
			recipeAlt: "E" GetChar("dotted_circle", "grave_double"),
			symbol: Chr(0x0204)
		},
		"lat_s_let_e_grave_double", {
			unicode: "{U+0205}", html: "&#517;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с двойным грависом", "small e with double grave"],
			recipe: "e" GetChar("grave_double"),
			recipeAlt: "e" GetChar("dotted_circle", "grave_double"),
			symbol: Chr(0x0205)
		},
		"lat_c_let_e_hook_above", {
			unicode: "{U+1EBA}", html: "&#7866;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с хвостиком сверху", "capital E with hook above"],
			recipe: "E" GetChar("hook_above"),
			recipeAlt: "E" GetChar("dotted_circle", "hook_above"),
			symbol: Chr(0x1EBA)
		},
		"lat_s_let_e_hook_above", {
			unicode: "{U+1EBB}", html: "&#7867;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с хвостиком сверху", "small e with hook above"],
			recipe: "e" GetChar("hook_above"),
			recipeAlt: "e" GetChar("dotted_circle", "hook_above"),
			symbol: Chr(0x1EBB)
		},
		"lat_s_let_e_retroflex_hook", {
			unicode: "{U+1D92}", html: "&#7570;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с ретрофлексным крюком", "small e with retroflex hook"],
			recipe: "e" GetChar("retroflex_hook_below"),
			recipeAlt: "e" GetChar("dotted_circle", "retroflex_hook_below"),
			symbol: Chr(0x1D92)
		},
		"lat_s_let_e_notch", {
			unicode: "{U+2C78}", html: "&#11384;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с бороздой", "small e with notch"],
			recipe: "e" . GetChar("arrow_right"),
			symbol: Chr(0x2C78)
		},
		"lat_c_let_e_macron", {
			unicode: "{U+0112}", html: "&#274;", entity: "&Emacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с макроном", "capital E with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [E]",
			recipe: "E" GetChar("macron"),
			recipeAlt: "E" GetChar("dotted_circle", "macron"),
			symbol: Chr(0x0112)
		},
		"lat_s_let_e_macron", {
			unicode: "{U+0113}", html: "&#275;", entity: "&emacr;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с макроном", "small e with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [e]",
			recipe: "e" GetChar("macron"),
			recipeAlt: "e" GetChar("dotted_circle", "macron"),
			symbol: Chr(0x0113)
		},
		"lat_c_let_e_macron_acute", {
			unicode: "{U+1E16}", html: "&#7702;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с макроном и акутом", "capital E with macron and acute"],
			recipe: ["E" GetChar("macron", "acute"), Chr(0x0112) GetChar("acute")],
			recipeAlt: ["E" GetChar("dotted_circle", "macron", "dotted_circle", "acute"), Chr(0x0112) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1E16)
		},
		"lat_s_let_e_macron_acute", {
			unicode: "{U+1E17}", html: "&#7703;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с макроном и акутом", "small e with macron and acute"],
			recipe: ["e" GetChar("macron", "acute"), Chr(0x0113) GetChar("acute")],
			recipeAlt: ["e" GetChar("dotted_circle", "macron", "dotted_circle", "acute"), Chr(0x0113) GetChar("dotted_circle", "acute")],
			symbol: Chr(0x1E17)
		},
		"lat_c_let_e_macron_grave", {
			unicode: "{U+1E14}", html: "&#7700;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с макроном и грависом", "capital E with macron and grave"],
			recipe: ["E" GetChar("macron", "grave"), Chr(0x0112) GetChar("grave")],
			recipeAlt: ["E" GetChar("dotted_circle", "macron", "dotted_circle", "grave"), Chr(0x0112) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1E14)
		},
		"lat_s_let_e_macron_grave", {
			unicode: "{U+1E15}", html: "&#7701;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с макроном и грависом", "small e with macron and grave"],
			recipe: ["e" GetChar("macron", "grave"), Chr(0x0113) GetChar("grave")],
			recipeAlt: ["e" GetChar("dotted_circle", "macron", "dotted_circle", "grave"), Chr(0x0113) GetChar("dotted_circle", "grave")],
			symbol: Chr(0x1E15)
		},
		"lat_c_let_e_solidus_long", {
			unicode: "{U+0246}", html: "&#582;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с наклонной чертой", "capital E with solidus"],
			recipe: "E" GetChar("solidus_long"),
			recipeAlt: "E" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0x0246)
		},
		"lat_s_let_e_solidus_long", {
			unicode: "{U+0247}", html: "&#583;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с наклонной чертой", "small e with solidus"],
			recipe: "e" GetChar("solidus_long"),
			recipeAlt: "e" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0x0247)
		},
		"lat_c_let_e_ogonek", {
			unicode: "{U+0118}", html: "&#280;", entity: "&Eogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с огонэком", "capital E with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [E]",
			recipe: "E" GetChar("ogonek"),
			recipeAlt: "E" GetChar("dotted_circle", "ogonek"),
			symbol: Chr(0x0118)
		},
		"lat_s_let_e_ogonek", {
			unicode: "{U+0119}", html: "&#281;", entity: "&eogon;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с огонэком", "small e with ogonek"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [e]",
			recipe: "e" GetChar("ogonek"),
			recipeAlt: "e" GetChar("dotted_circle", "ogonek"),
			symbol: Chr(0x0119)
		},
		"lat_c_let_e_tilde", {
			unicode: "{U+1EBC}", html: "&#7868;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная E с тильдой", "capital E with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [E]",
			recipe: "E" GetChar("tilde"),
			recipeAlt: "E" GetChar("dotted_circle", "tilde"),
			symbol: Chr(0x1EBC)
		},
		"lat_s_let_e_tilde", {
			unicode: "{U+1EBD}", html: "&#7869;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная e с тильдой", "small e with tilde"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift RightShift " [e]",
			recipe: "e" GetChar("tilde"),
			recipeAlt: "e" GetChar("dotted_circle", "tilde"),
			symbol: Chr(0x1EBD)
		},
		"lat_c_let_e_tilde_below", {
			unicode: "{U+1E1A}", html: "&#7706;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная E с тильдой", "capital E with tilde"],
			recipe: "A" GetChar("tilde_below"),
			recipeAlt: "E" GetChar("dotted_circle", "tilde_below"),
			symbol: Chr(0x1E1A)
		},
		"lat_s_let_e_tilde_below", {
			unicode: "{U+1E1B}", html: "&#7707;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная e с тильдой", "small e with tilde"],
			recipe: "e" GetChar("tilde_below"),
			recipeAlt: "e" GetChar("dotted_circle", "tilde_below"),
			symbol: Chr(0x1E1B)
		},
		"lat_c_let_f_dot_above", {
			unicode: "{U+1E1E}", html: "&#7710;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная F с точкой сверху", "capital F with dot above"],
			recipe: "F" GetChar("dot_above"),
			recipeAlt: "F" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E1E)
		},
		"lat_s_let_f_dot_above", {
			unicode: "{U+1E1F}", html: "&#7711;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с точкой сверху", "small f with dot above"],
			recipe: "f" GetChar("dot_above"),
			recipeAlt: "f" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E1F)
		},
		"lat_c_let_f_hook", {
			unicode: "{U+0191}", html: "&#401;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная F с крюком", "capital F with hook"],
			recipe: "F" GetChar("arrow_down"),
			symbol: Chr(0x0191)
		},
		"lat_s_let_f_hook", {
			unicode: "{U+0192}", html: "&#402;", entity: "&fnof;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с крюком", "small f with hook"],
			recipe: "f" GetChar("arrow_down"),
			symbol: Chr(0x0192)
		},
		"lat_s_let_f_palatal_hook", {
			unicode: "{U+1D82}", html: "&#7554;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с палатальным крюком", "small f with palatal hook"],
			recipe: "f" GetChar("palatal_hook_below"),
			recipeAlt: "f" GetChar("dotted_circle", "palatal_hook_below"),
			symbol: Chr(0x1D82)
		},
		"lat_c_let_f_stroke_short", {
			unicode: "{U+A798}", html: "&#42904;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная F со штрихом", "capital F with stroke"],
			recipe: "F" GetChar("stroke_short"),
			recipeAlt: "F" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0xA798)
		},
		"lat_s_let_f_stroke_short", {
			unicode: "{U+A799}", html: "&#42905;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f со штрихом", "small f with stroke"],
			recipe: "f" GetChar("stroke_short"),
			recipeAlt: "f" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0xA799)
		},
		"lat_s_let_f_tilde_overlay", {
			unicode: "{U+1D6E}", html: "&#7534;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная f с тильдой посередине", "small f with tilde overlay"],
			recipe: "f" GetChar("tilde_overlay"),
			recipeAlt: "f" GetChar("dotted_circle", "tilde_overlay"),
			symbol: Chr(0x1D6E)
		},
		"lat_c_let_g_acute", {
			unicode: "{U+01F4}", html: "&#500;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная G с акутом", "capital G with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[G]",
			recipe: "G" GetChar("acute"),
			recipeAlt: "G" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x01F4)
		},
		"lat_s_let_g_acute", {
			unicode: "{U+01F5}", html: "&#501;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная g с акутом", "small g with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[g]",
			recipe: "g" GetChar("acute"),
			recipeAlt: "g" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x01F5)
		},
		"lat_c_let_g_breve", {
			unicode: "{U+011E}", html: "&#286;", entity: "&Gbreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с краткой", "capital G with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[G]",
			recipe: "G" GetChar("breve"),
			recipeAlt: "G" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x011E)
		},
		"lat_s_let_g_breve", {
			unicode: "{U+011F}", html: "&#287;", entity: "&gbreve;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с краткой", "small g with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[g]",
			recipe: "g" GetChar("breve"),
			recipeAlt: "g" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x011F)
		},
		"lat_c_let_g_circumflex", {
			unicode: "{U+011C}", html: "&#284;", entity: "&Gcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с циркумфлексом", "capital G with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [G]",
			recipe: "G" GetChar("circumflex"),
			recipeAlt: "G" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x011C)
		},
		"lat_s_let_g_circumflex", {
			unicode: "{U+011D}", html: "&#285;", entity: "&gcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с циркумфлексом", "small g with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [g]",
			recipe: "g" GetChar("circumflex"),
			recipeAlt: "g" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x011D)
		},
		"lat_c_let_g_caron", {
			unicode: "{U+01E6}", html: "&#486;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с гачеком", "capital G with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [G]",
			recipe: "G" GetChar("caron"),
			recipeAlt: "G" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x01E6)
		},
		"lat_s_let_g_caron", {
			unicode: "{U+01E7}", html: "&#487;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с гачеком", "small g with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [g]",
			recipe: "g" GetChar("caron"),
			recipeAlt: "g" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x01E7)
		},
		"lat_c_let_g_cedilla", {
			unicode: "{U+0122}", html: "&#290;", entity: "&Gcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с седилью", "capital G with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [G]",
			recipe: "G" GetChar("cedilla"),
			recipeAlt: "G" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x0122)
		},
		"lat_s_let_g_cedilla", {
			unicode: "{U+0123}", html: "&#291;", entity: "&gcedil;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с седилью", "small g with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [g]",
			recipe: "g" GetChar("cedilla"),
			recipeAlt: "g" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x0123)
		},
		"lat_s_let_g_curl_right", {
			unicode: "{U+AB36}", html: "&#43830;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с завитком", "small g with curl"],
			recipe: "g" GetChar("arrow_right_ushaped"),
			symbol: Chr(0xAB36)
		},
		"lat_c_let_g_dot_above", {
			unicode: "{U+0120}", html: "&#288;", entity: "&Gdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G с точкой сверху", "capital G with dot above"],
			recipe: "G" GetChar("dot_above"),
			recipeAlt: "G" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x0120)
		},
		"lat_s_let_g_dot_above", {
			unicode: "{U+0121}", html: "&#289;", entity: "&gdot;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с точкой сверху", "small g with dot above"],
			recipe: "g" GetChar("dot_above"),
			recipeAlt: "g" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x0121)
		},
		"lat_c_let_g_macron", {
			unicode: "{U+1E20}", html: "&#7712;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная G с макроном", "capital G with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [G]",
			recipe: "G" GetChar("macron"),
			recipeAlt: "G" GetChar("dotted_circle", "macron"),
			symbol: Chr(0x1E20)
		},
		"lat_s_let_g_macron", {
			unicode: "{U+1E21}", html: "&#7713;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная g с макроном", "small g with macron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: RightShift " [g]",
			recipe: "g" GetChar("macron"),
			recipeAlt: "g" GetChar("dotted_circle", "macron"),
			symbol: Chr(0x1E21)
		},
		"lat_c_let_g_solidus_long", {
			unicode: "{U+A7A0}", html: "&#42912;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G с косой чертой", "capital G with solidus"],
			recipe: "G" GetChar("solidus_long"),
			recipeAlt: "G" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0xA7A0)
		},
		"lat_s_let_g_solidus_long", {
			unicode: "{U+A7A1}", html: "&#42913;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с косой чертой", "small g with solidus"],
			recipe: "g" GetChar("solidus_long"),
			recipeAlt: "g" GetChar("dotted_circle", "solidus_long"),
			symbol: Chr(0xA7A1)
		},
		"lat_c_let_g_stroke_short", {
			unicode: "{U+01E4}", html: "&#484;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G со штрихом", "capital G with stroke"],
			recipe: "G" GetChar("stroke_short"),
			recipeAlt: "G" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x01E4)
		},
		"lat_s_let_g_stroke_short", {
			unicode: "{U+01E5}", html: "&#485;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g со штрихом", "small g with stroke"],
			recipe: "g" GetChar("stroke_short"),
			recipeAlt: "g" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x01E5)
		},
		"lat_c_let_g_hook", {
			unicode: "{U+0193}", html: "&#403;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная G с крючком", "capital G with hook"],
			recipe: "G" . GetChar("arrow_up"),
			symbol: Chr(0x0193)
		},
		"lat_s_let_g_hook", {
			unicode: "{U+0260}", html: "&#608;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с крючком", "small g with hook"],
			recipe: "g" . GetChar("arrow_up"),
			symbol: Chr(0x0260)
		},
		"lat_s_let_g_palatal_hook", {
			unicode: "{U+1D83}", html: "&#7555;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная g с палатальным крюком", "small g with palatal hook"],
			recipe: "g" GetChar("palatal_hook_below"),
			recipeAlt: "g" GetChar("dotted_circle", "palatal_hook_below"),
			symbol: Chr(0x1D83)
		},
		"lat_c_let_h_breve_below", {
			unicode: "{U+1E2A}", html: "&#7722;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с краткой снизу", "capital H with breve below"],
			recipe: "H" GetChar("breve"),
			recipeAlt: "H" GetChar("dotted_circle", "breve_below"),
			symbol: Chr(0x1E2A)
		},
		"lat_s_let_h_breve_below", {
			unicode: "{U+1E2B}", html: "&#7723;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с краткой снизу", "small h with breve below"],
			recipe: "h" GetChar("breve"),
			recipeAlt: "h" GetChar("dotted_circle", "breve_below"),
			symbol: Chr(0x1E2B)
		},
		"lat_c_let_h_circumflex", {
			unicode: "{U+0124}", html: "&#292;", entity: "&Hcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с циркумфлексом", "capital H with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [H]",
			recipe: "H" GetChar("circumflex"),
			recipeAlt: "H" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x0124)
		},
		"lat_s_let_h_circumflex", {
			unicode: "{U+0125}", html: "&#293;", entity: "&hcirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с циркумфлексом", "small h with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [h]",
			recipe: "h" GetChar("circumflex"),
			recipeAlt: "h" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x0125)
		},
		"lat_c_let_h_caron", {
			unicode: "{U+021E}", html: "&#542;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с гачеком", "capital H with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [H]",
			recipe: "H" GetChar("caron"),
			recipeAlt: "H" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x021E)
		},
		"lat_s_let_h_caron", {
			unicode: "{U+021F}", html: "&#543;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с гачеком", "small h with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [h]",
			recipe: "h" GetChar("caron"),
			recipeAlt: "h" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x021F)
		},
		"lat_c_let_h_cedilla", {
			unicode: "{U+1E28}", html: "&#7720;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с седилью", "capital H with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [H]",
			recipe: "H" GetChar("cedilla"),
			recipeAlt: "H" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x1E28)
		},
		"lat_s_let_h_cedilla", {
			unicode: "{U+1E29}", html: "&#7721;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с седилью", "small h with cedilla"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt RightShift " [h]",
			recipe: "h" GetChar("cedilla"),
			recipeAlt: "h" GetChar("dotted_circle", "cedilla"),
			symbol: Chr(0x1E29)
		},
		"lat_c_let_h_dot_above", {
			unicode: "{U+1E22}", html: "&#7714;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная H с точкой сверху", "capital H with dot above"],
			recipe: "H" GetChar("dot_above"),
			recipeAlt: "H" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E22)
		},
		"lat_s_let_h_dot_above", {
			unicode: "{U+1E23}", html: "&#7715;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с точкой сверху", "small h with dot above"],
			recipe: "h" GetChar("dot_above"),
			recipeAlt: "h" GetChar("dotted_circle", "dot_above"),
			symbol: Chr(0x1E23)
		},
		"lat_c_let_h_dot_below", {
			unicode: "{U+1E24}", html: "&#7716;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописная H с точкой снизу", "capital H with dot below"],
			recipe: "H" GetChar("dot_below"),
			recipeAlt: "H" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1E24)
		},
		"lat_s_let_h_dot_below", {
			unicode: "{U+1E25}", html: "&#7717;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с точкой снизу", "small h with dot below"],
			recipe: "h" GetChar("dot_below"),
			recipeAlt: "h" GetChar("dotted_circle", "dot_below"),
			symbol: Chr(0x1E25)
		},
		"lat_c_let_h_diaeresis", {
			unicode: "{U+1E26}", html: "&#7718;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H с диерезисом", "capital H with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [H]",
			recipe: "H" GetChar("diaeresis"),
			recipeAlt: "H" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x1E26)
		},
		"lat_s_let_h_diaeresis", {
			unicode: "{U+1E27}", html: "&#7719;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h с диерезисом", "small h with diaeresis"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [h]",
			recipe: "h" GetChar("diaeresis"),
			recipeAlt: "h" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x1E27)
		},
		"lat_c_let_h_descender", {
			unicode: "{U+2C67}", html: "&#11367;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная H с нижним выносным элементом", "capital H with descender"],
			recipe: "H" GetChar("arrow_down"),
			symbol: Chr(0x2C67)
		},
		"lat_s_let_h_descender", {
			unicode: "{U+2C68}", html: "&#11368;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с нижним выносным элементом", "small h with descender"],
			recipe: "h" . GetChar("arrow_down"),
			symbol: Chr(0x2C68)
		},
		"lat_c_let_h_hook", {
			unicode: "{U+A7AA}", html: "&#42922;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная H с крючком", "capital H with hook"],
			recipe: "H" GetChar("arrow_left"),
			symbol: Chr(0xA7AA)
		},
		"lat_s_let_h_hook", {
			unicode: "{U+0266}", html: "&#614;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с крючком", "small h with hook"],
			recipe: "h" . GetChar("arrow_left"),
			symbol: Chr(0x0266)
		},
		"lat_s_let_h_palatal_hook", {
			unicode: "{U+A795}", html: "&#42901;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчная h с палатальным крюком", "small h with palatal hook"],
			recipe: "h" GetChar("palatal_hook_below"),
			recipeAlt: "h" GetChar("dotted_circle", "palatal_hook_below"),
			symbol: Chr(0xA795)
		},
		"lat_c_let_h_hwair", {
			unicode: "{U+01F6}", html: "&#502;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["прописной хвайр", "capital hwair"],
			recipe: "H" GetChar("arrow_right"),
			symbol: Chr(0x01F6)
		},
		"lat_s_let_h_hwair", {
			unicode: "{U+0195}", html: "&#405;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["строчный хвайр", "small hwair"],
			recipe: "h" GetChar("arrow_right"),
			symbol: Chr(0x0195)
		},
		"lat_c_let_h_halfleft", {
			unicode: "{U+2C75}", html: "&#11381;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["половинная прописная H", "capital half H"],
			recipe: "H/",
			symbol: Chr(0x2C75)
		},
		"lat_s_let_h_halfleft", {
			unicode: "{U+2C76}", html: "&#11382;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["половинная строчная h", "small half h"],
			recipe: "h/",
			symbol: Chr(0x2C76)
		},
		"lat_c_let_h_halfright", {
			unicode: "{U+A7F5}", html: "&#42997;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["перевёрнутая половинная прописная H", "capital reversed half H"],
			recipe: "H/" GetChar("arrow_right"),
			symbol: Chr(0xA7F5)
		},
		"lat_s_let_h_halfright", {
			unicode: "{U+A7F6}", html: "&#42998;",
			titlesAlt: True,
			group: ["Latin Accented"],
			tags: ["перевёрнутая половинная строчная h", "small reversed half h"],
			recipe: "h/" GetChar("arrow_right"),
			symbol: Chr(0xA7F6)
		},
		"lat_c_let_h_stroke_short", {
			unicode: "{U+0126}", html: "&#294;", entity: "&Hstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная H со штрихом", "capital H with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[H]",
			recipe: "H" GetChar("stroke_short"),
			recipeAlt: "H" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x0126)
		},
		"lat_s_let_h_stroke_short", {
			unicode: "{U+0127}", html: "&#295;", entity: "&hstrok;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная h со штрихом", "small h with stroke"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[h]",
			recipe: "h" GetChar("stroke_short"),
			recipeAlt: "h" GetChar("dotted_circle", "stroke_short"),
			symbol: Chr(0x0127)
		},
		"lat_c_let_i_acute", {
			unicode: "{U+00CD}", html: "&#205;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["прописная I с акутом", "capital I with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[I]",
			recipe: "I" GetChar("acute"),
			recipeAlt: "I" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x00CD)
		},
		"lat_s_let_i_acute", {
			unicode: "{U+00ED}", html: "&#237;", entity: "&iacute;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Primary"]],
			tags: ["строчная i с акутом", "small i with acute"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[i]",
			recipe: "i" GetChar("acute"),
			recipeAlt: "i" GetChar("dotted_circle", "acute"),
			symbol: Chr(0x00ED)
		},
		"lat_c_let_i_breve", {
			unicode: "{U+012C}", html: "&#300;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с краткой", "capital I with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[I]",
			recipe: "I" GetChar("breve"),
			recipeAlt: "I" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x012C)
		},
		"lat_s_let_i_breve", {
			unicode: "{U+012D}", html: "&#301;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с краткой", "small i with breve"],
			show_on_fast_keys: True,
			alt_on_fast_keys: "[i]",
			recipe: "i" GetChar("breve"),
			recipeAlt: "i" GetChar("dotted_circle", "breve"),
			symbol: Chr(0x012D)
		},
		"lat_c_let_i_circumflex", {
			unicode: "{U+00CE}", html: "&#206;", entity: "&Icirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с циркумфлексом", "capital I with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [I]",
			recipe: "I" GetChar("circumflex"),
			recipeAlt: "I" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x00CE)
		},
		"lat_s_let_i_circumflex", {
			unicode: "{U+00EE}", html: "&#238;", entity: "&icirc;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с циркумфлексом", "small i with circumflex"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt " [i]",
			recipe: "i" GetChar("circumflex"),
			recipeAlt: "i" GetChar("dotted_circle", "circumflex"),
			symbol: Chr(0x00EE)
		},
		"lat_c_let_i_caron", {
			unicode: "{U+01CF}", html: "&#463;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["прописная I с гачеком", "capital I with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [I]",
			recipe: "I" GetChar("caron"),
			recipeAlt: "I" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x01CF)
		},
		"lat_s_let_i_caron", {
			unicode: "{U+01D0}", html: "&#464;",
			titlesAlt: True,
			group: [["Latin Accented", "Latin Accented Secondary"]],
			tags: ["строчная i с гачеком", "small i with caron"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftAlt LeftShift " [i]",
			recipe: "i" GetChar("caron"),
			recipeAlt: "i" GetChar("dotted_circle", "caron"),
			symbol: Chr(0x01D0)
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
		;
		; * Letters Cyriillic
		"cyr_c_a_iotified", {
			unicode: "{U+A656}", html: "&#42582;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йа", "!ia", "А йотированное", "A iotified"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Я]",
			recipe: "ІА",
			symbol: Chr(0xA656)
		},
		"cyr_s_a_iotified", {
			unicode: "{U+A657}", html: "&#42583;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йа", ".ia", "а йотированное", "a iotified"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [я]",
			recipe: "іа",
			symbol: Chr(0xA657)
		},
		"cyr_c_e_iotified", {
			unicode: "{U+0464}", html: "&#1124;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йэ", "!ie", "Е йотированное", "E iotified"],
			recipe: ["ІЕ", "ІЄ"],
			symbol: Chr(0x0464)
		},
		"cyr_s_e_iotified", {
			unicode: "{U+0465}", html: "&#1125;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йэ", ".ie", "е йотированное", "e iotified"],
			recipe: ["іе", "іє"],
			symbol: Chr(0x0465)
		},
		"cyr_c_yus_big", {
			unicode: "{U+046A}", html: "&#1130;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "У"],
			tags: ["!юсб", "!yusb", "Юс большой", "big Yus"],
			show_on_fast_keys: True,
			recipe: "УЖ",
			symbol: Chr(0x046A)
		},
		"cyr_s_yus_big", {
			unicode: "{U+046B}", html: "&#046B;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "у"],
			tags: [".юсб", ".yusb", "юс большой", "big yus"],
			show_on_fast_keys: True,
			recipe: "уж",
			symbol: Chr(0x046B)
		},
		"cyr_c_yus_big_iotified", {
			unicode: "{U+046C}", html: "&#1132;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йюсб", "!iyusb", "Юс большой йотированный", "big Yus iotified"],
			recipe: ["ІУЖ", "І" . Chr(0x046A)],
			symbol: Chr(0x046C)
		},
		"cyr_s_yus_big_iotified", {
			unicode: "{U+046D}", html: "&#1133;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йюсб", ".iyusb", "юс большой йотированный", "big yus iotified"],
			recipe: ["іуж", "і" . Chr(0x046B)],
			symbol: Chr(0x046D)
		},
		"cyr_c_yus_little", {
			unicode: "{U+0466}", html: "&#1126;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "Я"],
			tags: ["!юсм", "!yusm", "Юс малый", "little Yus"],
			show_on_fast_keys: True,
			recipe: "АТ",
			symbol: Chr(0x0466)
		},
		"cyr_s_yus_little", {
			unicode: "{U+0467}", html: "&#1127;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters", "я"],
			tags: [".юсм", ".yusm", "юс малый", "little yus"],
			show_on_fast_keys: True,
			recipe: "ат",
			symbol: Chr(0x0467)
		},
		"cyr_c_yus_little_iotified", {
			unicode: "{U+0468}", html: "&#1128;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йюсм", "!iyusm", "Юс малый йотированный", "little Yus iotified"],
			recipe: ["ІАТ", "І" Chr(0x0466)],
			symbol: Chr(0x0468)
		},
		"cyr_s_yus_little_iotified", {
			unicode: "{U+0469}", html: "&#1129;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йюсм", ".iyusm", "юс малый йотированный", "little yus iotified"],
			recipe: ["іат", "і" Chr(0x0467)],
			symbol: Chr(0x0469)
		},
		"cyr_c_yus_little_closed", {
			unicode: "{U+A658}", html: "&#42584;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!юсмз", "!yusmz", "Юс малый закрытый", "little Yus closed"],
			recipe: ["_АТ", "_" Chr(0x0466)],
			symbol: Chr(0xA658)
		},
		"cyr_s_yus_little_closed", {
			unicode: "{U+A659}", html: "&#42585;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".юсмз", ".yusmz", "юс малый закрытый", "little yus closed"],
			recipe: ["_ат", "_" Chr(0x0467)],
			symbol: Chr(0xA659)
		},
		"cyr_c_yus_little_closed_iotified", {
			unicode: "{U+A65C}", html: "&#42588;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!йюсмз", "!iyusmz", "Юс малый закрытый йотированный", "little Yus closed iotified"],
			recipe: ["І_АТ", "І" Chr(0xA658), "І_" Chr(0x0466)],
			symbol: Chr(0xA65C)
		},
		"cyr_s_yus_little_closed_iotified", {
			unicode: "{U+A65D}", html: "&#42589;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".йюсмз", ".iyusmz", "юс малый закрытый йотированный", "little yus closed iotified"],
			recipe: ["і_ат", "І" Chr(0xA659), "і_" Chr(0x0467)],
			symbol: Chr(0xA65D)
		},
		"cyr_c_yus_blended", {
			unicode: "{U+A65A}", html: "&#42586;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["!юсс", "!yuss", "Юс смешанный", "blended Yus"],
			recipe: ["УЖАТ", Chr(0x046A) . Chr(0x0466)],
			symbol: Chr(0xA65A)
		},
		"cyr_s_yus_blended", {
			unicode: "{U+A65B}", html: "&#42587;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: [".юсс", ".yuss", "юс смешанный", "blended yus"],
			recipe: ["ужат", Chr(0x046B) . Chr(0x0467)],
			symbol: Chr(0xA65B)
		},
		"cyr_c_tse", {
			unicode: "{U+04B4}", html: "&#1204;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["Тцэ", "Tse cyrillic"],
			recipe: "ТЦ",
			symbol: Chr(0x04B4)
		},
		"cyr_s_tse", {
			unicode: "{U+04B5}", html: "&#1205;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["тцэ", "tse cyrillic"],
			recipe: "тц",
			symbol: Chr(0x04B5)
		},
		"cyr_c_tche", {
			unicode: "{U+A692}", html: "&#42642;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["Тчэ", "Tche cyrillic"],
			recipe: "ТЧ",
			symbol: Chr(0xA692)
		},
		"cyr_s_tche", {
			unicode: "{U+A693}", html: "&#42643;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["тчэ", "tche cyrillic"],
			recipe: "тч",
			symbol: Chr(0xA693)
		},
		"cyr_c_yat_iotified", {
			unicode: "{U+A652}", html: "&#42578;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["Ять йотированный", "Yat iotified"],
			recipe: ["ІТЬ", "І" . Chr(0x0462)],
			symbol: Chr(0xA652)
		},
		"cyr_s_yat_iotified", {
			unicode: "{U+A653}", html: "&#42579;",
			titlesAlt: True,
			group: ["Cyrillic Ligatures & Letters"],
			tags: ["ять йотированный", "yat iotified"],
			recipe: ["іть", "і" . Chr(0x0463)],
			symbol: Chr(0xA653)
		},
		"cyr_c_let_dzhe", {
			unicode: "{U+040F}", html: "&#1039;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["Дже", "Dzhe cyrillic"],
			recipe: "ДЖ",
			symbol: Chr(0x040F)
		},
		"cyr_s_let_dzhe", {
			unicode: "{U+045F}", html: "&#1119;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["дже", "dzhe cyrillic"],
			recipe: "дж",
			symbol: Chr(0x045F)
		},
		"cyr_c_let_i", {
			unicode: "{U+0406}", html: "&#1030;",
			altCode: "0178 RU" Chr(0x2328),
			titlesAlt: True,
			group: ["Cyrillic Letters", "И"],
			show_on_fast_keys: True,
			tags: ["И десятиричное", "I cyrillic"],
			symbol: Chr(0x0406)
		},
		"cyr_s_let_i", {
			unicode: "{U+0456}", html: "&#1110;",
			altCode: "0179 RU" Chr(0x2328),
			titlesAlt: True,
			group: ["Cyrillic Letters", "и"],
			show_on_fast_keys: True,
			tags: ["и десятиричное", "i cyrillic"],
			symbol: Chr(0x0456)
		},
		"cyr_c_let_izhitsa", {
			unicode: "{U+0474}", html: "&#1140;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "И"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["Ижица", "Izhitsa cyrillic"],
			symbol: Chr(0x0474)
		},
		"cyr_s_let_izhitsa", {
			unicode: "{U+0475}", html: "&#1141;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "и"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["ижица", "izhitsa cyrillic"],
			symbol: Chr(0x0475)
		},
		"cyr_c_let_yi", {
			unicode: "{U+0407}", html: "&#1031;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Й"],
			show_on_fast_keys: True,
			tags: ["ЙИ десятиричное", "YI cyrillic"],
			recipe: "І" GetChar("diaeresis"),
			recipeAlt: "І" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x0407)
		},
		"cyr_s_let_yi", {
			unicode: "{U+0457}", html: "&#1111;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "й"],
			show_on_fast_keys: True,
			tags: ["йи десятиричное", "yi cyrillic"],
			recipe: "і" GetChar("diaeresis"),
			recipeAlt: "і" GetChar("dotted_circle", "diaeresis"),
			symbol: Chr(0x0457)
		},
		"cyr_c_let_j", {
			unicode: "{U+0408}", html: "&#1032;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Й"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["ЙЕ", "J cyrillic"],
			symbol: Chr(0x0408)
		},
		"cyr_s_let_j", {
			unicode: "{U+0458}", html: "&#1112;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "й"],
			modifier: LeftAlt,
			show_on_fast_keys: True,
			tags: ["йе", "j cyrillic"],
			symbol: Chr(0x0458)
		},
		"cyr_c_let_ksi", {
			unicode: "{U+046E}", html: "&#1134;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["Кси", "Ksi cyrillic"],
			recipe: "КС",
			symbol: Chr(0x046E)
		},
		"cyr_s_let_ksi", {
			unicode: "{U+046F}", html: "&#1135;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["кси", "ksi cyrillic"],
			recipe: "кс",
			symbol: Chr(0x046F)
		},
		"cyr_c_let_omega", {
			unicode: "{U+0460}", html: "&#1120;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "О"],
			show_on_fast_keys: True,
			tags: ["Омега", "Omega cyrillic"],
			symbol: Chr(0x0460)
		},
		"cyr_s_let_omega", {
			unicode: "{U+0461}", html: "&#1121;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "о"],
			show_on_fast_keys: True,
			tags: ["омега", "omega cyrillic"],
			symbol: Chr(0x0461)
		},
		"cyr_c_let_psi", {
			unicode: "{U+0470}", html: "&#1136;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["Пси", "Psi cyrillic"],
			recipe: "ПС",
			symbol: Chr(0x0470)
		},
		"cyr_s_let_psi", {
			unicode: "{U+0471}", html: "&#1137;",
			titlesAlt: True,
			group: ["Cyrillic Letters"],
			tags: ["пси", "psi cyrillic"],
			recipe: "пс",
			symbol: Chr(0x0471)
		},
		"cyr_c_let_fita", {
			unicode: "{U+0472}", html: "&#1138;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Ф"],
			show_on_fast_keys: True,
			tags: ["Фита", "Fita cyrillic"],
			symbol: Chr(0x0472)
		},
		"cyr_s_let_fita", {
			unicode: "{U+0473}", html: "&#1139;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "ф"],
			show_on_fast_keys: True,
			tags: ["фита", "fita cyrillic"],
			symbol: Chr(0x0473)
		},
		"cyr_c_let_ukr_e", {
			unicode: "{U+0404}", html: "&#1028;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Э"],
			show_on_fast_keys: True,
			tags: ["Э якорное", "E ukrainian"],
			symbol: Chr(0x0404)
		},
		"cyr_s_let_ukr_e", {
			unicode: "{U+0454}", html: "&#1108;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "э"],
			show_on_fast_keys: True,
			tags: ["э якорное", "e ukrainian"],
			symbol: Chr(0x0454)
		},
		"cyr_c_let_yat", {
			unicode: "{U+0462}", html: "&#1122;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "Е"],
			show_on_fast_keys: True,
			tags: ["Ять", "Yat"],
			recipe: "ТЬ",
			symbol: Chr(0x0462)
		},
		"cyr_s_let_yat", {
			unicode: "{U+0463}", html: "&#1123;",
			titlesAlt: True,
			group: ["Cyrillic Letters", "е"],
			show_on_fast_keys: True,
			tags: ["ять", "yat"],
			recipe: "ть",
			symbol: Chr(0x0463)
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
			symbol: Chr(0x2C00)
		},
		"glagolitic_s_let_az", {
			unicode: "{U+2C30}", html: "&#11312;",
			combiningForm: "{U+1E000}",
			combiningHTML: "&#122880;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "а"],
			tags: ["строчный аз глаголицы", "small az glagolitic"],
			symbol: Chr(0x2C30)
		},
		"glagolitic_c_let_buky", {
			unicode: "{U+2C01}", html: "&#11265;",
			combiningForm: "{U+1E001}",
			combiningHTML: "&#122881;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Б"],
			tags: ["прописной Буки глаголицы", "capital Buky glagolitic"],
			symbol: Chr(0x2C01)
		},
		"glagolitic_s_let_buky", {
			unicode: "{U+2C31}", html: "&#11313;",
			combiningForm: "{U+1E001}",
			combiningHTML: "&#122881;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "б"],
			tags: ["строчный буки глаголицы", "small buky glagolitic"],
			symbol: Chr(0x2C31)
		},
		"glagolitic_c_let_vede", {
			unicode: "{U+2C02}", html: "&#11266;",
			combiningForm: "{U+1E002}",
			combiningHTML: "&#122882;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "В"],
			tags: ["прописной Веди глаголицы", "capital Vede glagolitic"],
			symbol: Chr(0x2C02)
		},
		"glagolitic_s_let_vede", {
			unicode: "{U+2C32}", html: "&#11314;",
			combiningForm: "{U+1E002}",
			combiningHTML: "&#122882;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "в"],
			tags: ["строчный веди глаголицы", "small vede glagolitic"],
			symbol: Chr(0x2C32)
		},
		"glagolitic_c_let_glagoli", {
			unicode: "{U+2C03}", html: "&#11267;",
			combiningForm: "{U+1E003}",
			combiningHTML: "&#122883;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Г"],
			tags: ["прописной Глаголи глаголицы", "capital Glagoli glagolitic"],
			symbol: Chr(0x2C03)
		},
		"glagolitic_s_let_glagoli", {
			unicode: "{U+2C33}", html: "&#11315;",
			combiningForm: "{U+1E003}",
			combiningHTML: "&#122883;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "г"],
			tags: ["строчный глаголи глаголицы", "small glagoli glagolitic"],
			symbol: Chr(0x2C33)
		},
		"glagolitic_c_let_dobro", {
			unicode: "{U+2C04}", html: "&#11268;",
			combiningForm: "{U+1E004}",
			combiningHTML: "&#122884;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Д"],
			tags: ["прописной Добро глаголицы", "capital Dobro glagolitic"],
			symbol: Chr(0x2C04)
		},
		"glagolitic_s_let_dobro", {
			unicode: "{U+2C34}", html: "&#11316;",
			combiningForm: "{U+1E004}",
			combiningHTML: "&#122884;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "д"],
			tags: ["строчный добро глаголицы", "small dobro glagolitic"],
			symbol: Chr(0x2C34)
		},
		"glagolitic_c_let_yestu", {
			unicode: "{U+2C05}", html: "&#11269;",
			combiningForm: "{U+1E005}",
			combiningHTML: "&#122885;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Е"],
			tags: ["прописной Есть глаголицы", "capital Yestu glagolitic"],
			symbol: Chr(0x2C05)
		},
		"glagolitic_s_let_yestu", {
			unicode: "{U+2C35}", html: "&#11317;",
			combiningForm: "{U+1E005}",
			combiningHTML: "&#122885;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "е"],
			tags: ["строчный есть глаголицы", "small yestu glagolitic"],
			symbol: Chr(0x2C35)
		},
		"glagolitic_c_let_zhivete", {
			unicode: "{U+2C06}", html: "&#11270;",
			combiningForm: "{U+1E006}",
			combiningHTML: "&#122886;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ж"],
			tags: ["прописной Живете глаголицы", "capital Zhivete glagolitic"],
			symbol: Chr(0x2C06)
		},
		"glagolitic_s_let_zhivete", {
			unicode: "{U+2C36}", html: "&#11318;",
			combiningForm: "{U+1E006}",
			combiningHTML: "&#122886;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ж"],
			tags: ["строчный живете глаголицы", "small zhivete glagolitic"],
			symbol: Chr(0x2C36)
		},
		"glagolitic_c_let_dzelo", {
			unicode: "{U+2C07}", html: "&#11271;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописной Зело глаголицы", "capital Dzelo glagolitic"],
			alt_layout: RightAlt " [С]",
			symbol: Chr(0x2C07)
		},
		"glagolitic_s_let_dzelo", {
			unicode: "{U+2C37}", html: "&#11319;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["строчный зело глаголицы", "small dzelo glagolitic"],
			alt_layout: RightAlt " [с]",
			symbol: Chr(0x2C37)
		},
		"glagolitic_c_let_zemlja", {
			unicode: "{U+2C08}", html: "&#11272;",
			combiningForm: "{U+1E008}",
			combiningHTML: "&#122888;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "З"],
			tags: ["прописная Земля глаголицы", "capital Zemlja glagolitic"],
			symbol: Chr(0x2C08)
		},
		"glagolitic_s_let_zemlja", {
			unicode: "{U+2C38}", html: "&#11320;",
			combiningForm: "{U+1E008}",
			combiningHTML: "&#122888;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "з"],
			tags: ["строчная земля глаголицы", "small zemlja glagolitic"],
			symbol: Chr(0x2C38)
		},
		"glagolitic_c_let_initial_izhe", {
			unicode: "{U+2C0A}", html: "&#11274;",
			combiningForm: "{U+1E00A}",
			combiningHTML: "&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [И]",
			tags: ["прописное начальное Иже глаголицы", "capital initial Izhe glagolitic"],
			symbol: Chr(0x2C0A)
		},
		"glagolitic_s_let_initial_izhe", {
			unicode: "{U+2C3A}", html: "&#11322;",
			combiningForm: "{U+1E00A}",
			combiningHTML: "&#122890;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [и]",
			tags: ["строчное начальное иже глаголицы", "small initial izhe glagolitic"],
			symbol: Chr(0x2C3A)
		},
		"glagolitic_c_let_izhe", {
			unicode: "{U+2C09}", html: "&#11273;",
			combiningForm: "{U+1E009}",
			combiningHTML: "&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: LeftShift " [И], [Й]",
			tags: ["прописная Иже глаголицы", "capital Izhe glagolitic"],
			symbol: Chr(0x2C09)
		},
		"glagolitic_s_let_izhe", {
			unicode: "{U+2C39}", html: "&#11321;",
			combiningForm: "{U+1E009}",
			combiningHTML: "&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: LeftShift " [и], [й]",
			tags: ["строчная иже глаголицы", "small izhe glagolitic"],
			symbol: Chr(0x2C39)
		},
		"glagolitic_c_let_i", {
			unicode: "{U+2C0B}", html: "&#11275;",
			combiningForm: "{U+1E00B}",
			combiningHTML: "&#122891;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "И"],
			tags: ["прописная Ие глаголицы", "capital I glagolitic"],
			symbol: Chr(0x2C0B)
		},
		"glagolitic_s_let_i", {
			unicode: "{U+2C3B}", html: "&#11323;",
			combiningForm: "{U+1E00B}",
			combiningHTML: "&#122891;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "и"],
			tags: ["строчная и глаголицы", "small i glagolitic"],
			symbol: Chr(0x2C3B)
		},
		"glagolitic_c_let_djervi", {
			unicode: "{U+2C0C}", html: "&#11276;",
			combiningForm: "{U+1E00C}",
			combiningHTML: "&#122892;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [Ж]",
			tags: ["прописной Гюрв глаголицы", "capital Djervi glagolitic"],
			symbol: Chr(0x2C0C)
		},
		"glagolitic_s_let_djervi", {
			unicode: "{U+2C3C}", html: "&#11324;",
			combiningForm: "{U+1E00C}",
			combiningHTML: "&#122892;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [ж]",
			tags: ["строчной гюрв глаголицы", "small djervi glagolitic"],
			symbol: Chr(0x2C3C)
		},
		"glagolitic_c_let_kako", {
			unicode: "{U+2C0D}", html: "&#11277;",
			combiningForm: "{U+1E00D}",
			combiningHTML: "&#122893;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "К"],
			tags: ["прописная Како глаголицы", "capital Kako glagolitic"],
			symbol: Chr(0x2C0D)
		},
		"glagolitic_s_let_kako", {
			unicode: "{U+2C3D}", html: "&#11325;",
			combiningForm: "{U+1E00D}",
			combiningHTML: "&#122893;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "к"],
			tags: ["строчная како глаголицы", "small kako glagolitic"],
			symbol: Chr(0x2C3D)
		},
		"glagolitic_c_let_ljudije", {
			unicode: "{U+2C0E}", html: "&#11278;",
			combiningForm: "{U+1E00E}",
			combiningHTML: "&#122894;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Л"],
			tags: ["прописная Люди глаголицы", "capital Ljudije glagolitic"],
			symbol: Chr(0x2C0E)
		},
		"glagolitic_s_let_ljudije", {
			unicode: "{U+2C3E}", html: "&#11326;",
			combiningForm: "{U+1E00E}",
			combiningHTML: "&#122894;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "л"],
			tags: ["строчная люди глаголицы", "small ljudije glagolitic"],
			symbol: Chr(0x2C3E)
		},
		"glagolitic_c_let_myslite", {
			unicode: "{U+2C0F}", html: "&#11279;",
			combiningForm: "{U+1E00F}",
			combiningHTML: "&#122895;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "М"],
			tags: ["прописная Мыслете глаголицы", "capital Myslite glagolitic"],
			symbol: Chr(0x2C0F)
		},
		"glagolitic_s_let_myslite", {
			unicode: "{U+2C3F}", html: "&#11327;",
			combiningForm: "{U+1E00F}",
			combiningHTML: "&#122895;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "м"],
			tags: ["строчная мыслете глаголицы", "small myslite glagolitic"],
			symbol: Chr(0x2C3F)
		},
		"glagolitic_c_let_nashi", {
			unicode: "{U+2C10}", html: "&#11280;",
			combiningForm: "{U+1E010}",
			combiningHTML: "&#122896;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Н"],
			tags: ["прописная Наш глаголицы", "capital Nashi glagolitic"],
			symbol: Chr(0x2C10)
		},
		"glagolitic_s_let_nashi", {
			unicode: "{U+2C40}", html: "&#11328;",
			combiningForm: "{U+1E010}",
			combiningHTML: "&#122896;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "н"],
			tags: ["строчная наш глаголицы", "small nashi glagolitic"],
			symbol: Chr(0x2C40)
		},
		"glagolitic_c_let_onu", {
			unicode: "{U+2C11}", html: "&#11281;",
			combiningForm: "{U+1E011}",
			combiningHTML: "&#122897;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "О"],
			tags: ["прописная Он глаголицы", "capital Onu glagolitic"],
			symbol: Chr(0x2C11)
		},
		"glagolitic_s_let_onu", {
			unicode: "{U+2C41}", html: "&#11329;",
			combiningForm: "{U+1E011}",
			combiningHTML: "&#122897;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "о"],
			tags: ["строчная он глаголицы", "small onu glagolitic"],
			symbol: Chr(0x2C41)
		},
		"glagolitic_c_let_pokoji", {
			unicode: "{U+2C12}", html: "&#11282;",
			combiningForm: "{U+1E012}",
			combiningHTML: "&#122898;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "П"],
			tags: ["прописная Покой глаголицы", "capital Pokoji glagolitic"],
			symbol: Chr(0x2C12)
		},
		"glagolitic_s_let_pokoji", {
			unicode: "{U+2C42}", html: "&#11330;",
			combiningForm: "{U+1E012}",
			combiningHTML: "&#122898;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "п"],
			tags: ["строчная покой глаголицы", "small pokoji glagolitic"],
			symbol: Chr(0x2C42)
		},
		"glagolitic_c_let_ritsi", {
			unicode: "{U+2C13}", html: "&#11283;",
			combiningForm: "{U+1E013}",
			combiningHTML: "&#122899;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Р"],
			tags: ["прописная Рцы глаголицы", "capital Ritsi glagolitic"],
			symbol: Chr(0x2C13)
		},
		"glagolitic_s_let_ritsi", {
			unicode: "{U+2C43}", html: "&#11331;",
			combiningForm: "{U+1E013}",
			combiningHTML: "&#122899;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "р"],
			tags: ["строчная рцы глаголицы", "small ritsi glagolitic"],
			symbol: Chr(0x2C43)
		},
		"glagolitic_c_let_slovo", {
			unicode: "{U+2C14}", html: "&#11284;",
			combiningForm: "{U+1E014}",
			combiningHTML: "&#122900;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "С"],
			tags: ["прописная Слово глаголицы", "capital Slovo glagolitic"],
			symbol: Chr(0x2C14)
		},
		"glagolitic_s_let_slovo", {
			unicode: "{U+2C44}", html: "&#11332;",
			combiningForm: "{U+1E014}",
			combiningHTML: "&#122900;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "с"],
			tags: ["строчная слово глаголицы", "small slovo glagolitic"],
			symbol: Chr(0x2C44)
		},
		"glagolitic_c_let_tvrido", {
			unicode: "{U+2C15}", html: "&#11285;",
			combiningForm: "{U+1E015}",
			combiningHTML: "&#122901;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Т"],
			tags: ["прописная Твердо глаголицы", "capital Tvrido glagolitic"],
			symbol: Chr(0x2C15)
		},
		"glagolitic_s_let_tvrido", {
			unicode: "{U+2C45}", html: "&#11333;",
			combiningForm: "{U+1E015}",
			combiningHTML: "&#122901;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "т"],
			tags: ["строчная твердо глаголицы", "small tvrido glagolitic"],
			symbol: Chr(0x2C45)
		},
		"glagolitic_c_let_izhitsa", {
			unicode: "{U+2C2B}", html: "&#11307;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt LeftShift " [И]",
			tags: ["прописное начальное Иже глаголицы", "capital Izhitsae glagolitic"],
			symbol: Chr(0x2C2B)
		},
		"glagolitic_s_let_izhitsa", {
			unicode: "{U+2C5B}", html: "&#11355;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt LeftShift " [и]",
			tags: ["строчное начальное иже глаголицы", "small izhitsa glagolitic"],
			symbol: Chr(0x2C5B)
		},
		"glagolitic_c_let_uku", {
			unicode: "{U+2C16}", html: "&#11286;",
			combiningForm: "{U+1E016}",
			combiningHTML: "&#122902;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "У"],
			tags: ["прописная Ук глаголицы", "capital Uku glagolitic"],
			symbol: Chr(0x2C16)
		},
		"glagolitic_s_let_uku", {
			unicode: "{U+2C46}", html: "&#11334;",
			combiningForm: "{U+1E016}",
			combiningHTML: "&#122902;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "у"],
			tags: ["строчная ук глаголицы", "small uku glagolitic"],
			symbol: Chr(0x2C46)
		},
		"glagolitic_c_let_fritu", {
			unicode: "{U+2C17}", html: "&#11287;",
			combiningForm: "{U+1E017}",
			combiningHTML: "&#122903;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ф"],
			tags: ["прописной Ферт глаголицы", "capital Fritu glagolitic"],
			symbol: Chr(0x2C17)
		},
		"glagolitic_s_let_fritu", {
			unicode: "{U+2C47}", html: "&#11335;",
			combiningForm: "{U+1E017}",
			combiningHTML: "&#122903;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ф"],
			tags: ["строчный ферт глаголицы", "small fritu glagolitic"],
			symbol: Chr(0x2C47)
		},
		"glagolitic_c_let_heru", {
			unicode: "{U+2C18}", html: "&#11288;",
			combiningForm: "{U+1E018}",
			combiningHTML: "&#122904;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Х"],
			tags: ["прописной Хер глаголицы", "capital Heru glagolitic"],
			symbol: Chr(0x2C18)
		},
		"glagolitic_s_let_heru", {
			unicode: "{U+2C48}", html: "&#11336;",
			combiningForm: "{U+1E018}",
			combiningHTML: "&#122904;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "х"],
			tags: ["строчный хер глаголицы", "small heru glagolitic"],
			symbol: Chr(0x2C48)
		},
		"glagolitic_c_let_otu", {
			unicode: "{U+2C19}", html: "&#11289;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [О]",
			tags: ["прописная От глаголицы", "capital Otu glagolitic"],
			symbol: Chr(0x2C19)
		},
		"glagolitic_s_let_otu", {
			unicode: "{U+2C49}", html: "&#11337;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [о]",
			tags: ["строчная от глаголицы", "small otu glagolitic"],
			symbol: Chr(0x2C49)
		},
		"glagolitic_c_let_pe", {
			unicode: "{U+2C1A}", html: "&#11290;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [П]",
			tags: ["прописная Пе глаголицы", "capital Pe glagolitic"],
			symbol: Chr(0x2C1A)
		},
		"glagolitic_s_let_pe", {
			unicode: "{U+2C4A}", html: "&#11338;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [п]",
			tags: ["строчная пе глаголицы", "small pe glagolitic"],
			symbol: Chr(0x2C4A)
		},
		"glagolitic_c_let_tsi", {
			unicode: "{U+2C1C}", html: "&#11292;",
			combiningForm: "{U+1E01C}",
			combiningHTML: "&#122908;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ц"],
			tags: ["прописная Цы глаголицы", "capital Tsi glagolitic"],
			symbol: Chr(0x2C1C)
		},
		"glagolitic_s_let_tsi", {
			unicode: "{U+2C4C}", html: "&#11340;",
			combiningForm: "{U+1E01C}",
			combiningHTML: "&#122908;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ц"],
			tags: ["строчная цы глаголицы", "small tsi glagolitic"],
			symbol: Chr(0x2C4C)
		},
		"glagolitic_c_let_chrivi", {
			unicode: "{U+2C1D}", html: "&#11293;",
			combiningForm: "{U+1E01D}",
			combiningHTML: "&#122909;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ч"],
			tags: ["прописная Червь глаголицы", "capital Chrivi glagolitic"],
			symbol: Chr(0x2C1D)
		},
		"glagolitic_s_let_chrivi", {
			unicode: "{U+2C4D}", html: "&#11341;",
			combiningForm: "{U+1E01D}",
			combiningHTML: "&#122909;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ч"],
			tags: ["строчная червь глаголицы", "small chrivi glagolitic"],
			symbol: Chr(0x2C4D)
		},
		"glagolitic_c_let_sha", {
			unicode: "{U+2C1E}", html: "&#11294;",
			combiningForm: "{U+1E01E}",
			combiningHTML: "&#122910;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ш"],
			tags: ["прописная Ша глаголицы", "capital Sha glagolitic"],
			symbol: Chr(0x2C1E)
		},
		"glagolitic_s_let_sha", {
			unicode: "{U+2C4E}", html: "&#11342;",
			combiningForm: "{U+1E01E}",
			combiningHTML: "&#122910;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ш"],
			tags: ["строчная ша глаголицы", "small sha glagolitic"],
			symbol: Chr(0x2C4E)
		},
		"glagolitic_c_let_shta", {
			unicode: "{U+2C1B}", html: "&#11291;",
			combiningForm: "{U+1E01B}",
			combiningHTML: "&#122907;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Щ"],
			tags: ["прописная Шта глаголицы", "capital Shta glagolitic"],
			symbol: Chr(0x2C1B)
		},
		"glagolitic_s_let_shta", {
			unicode: "{U+2C4B}", html: "&#11339;",
			combiningForm: "{U+1E01B}",
			combiningHTML: "&#122907;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "щ"],
			tags: ["строчная шта глаголицы", "small shta glagolitic"],
			symbol: Chr(0x2C4B)
		},
		"glagolitic_c_let_yeru", {
			unicode: "{U+2C1F}", html: "&#11295;",
			combiningForm: "{U+1E01F}",
			combiningHTML: "&#122911;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ъ"],
			tags: ["прописный Ер глаголицы", "capital Yeru glagolitic"],
			symbol: Chr(0x2C1F)
		},
		"glagolitic_s_let_yeru", {
			unicode: "{U+2C4F}", html: "&#11343;",
			combiningForm: "{U+1E01F}",
			combiningHTML: "&#122911;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ъ"],
			tags: ["строчный ер глаголицы", "small yeru glagolitic"],
			symbol: Chr(0x2C4F)
		},
		"glagolitic_c_let_yery", {
			unicode: "{U+2C1F}", html: "&#11295;&#11274;",
			uniSequence: ["{U+2C1F}", "{U+2C0A}"],
			combiningForm: ["{U+1E01F}", "{U+1E00A}"],
			combiningHTML: "&#122911;&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ы"],
			tags: ["прописные Еры глаголицы", "capital Yery glagolitic"],
			symbol: Chr(0x2C1F) Chr(0x2C0A),
			symbolCustom: "s36"
		},
		"glagolitic_s_let_yery", {
			unicode: "{U+2C4F}", html: "&#11343;&#11322;",
			uniSequence: ["{U+2C4F}", "{U+2C3A}"],
			combiningForm: ["{U+1E01F}", "{U+1E00A}"],
			combiningHTML: "&#122911;&#122889;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ы"],
			tags: ["строчные еры глаголицы", "small yery glagolitic"],
			symbol: Chr(0x2C4F) Chr(0x2C3A),
			symbolCustom: "s36"
		},
		"glagolitic_c_let_yeri", {
			unicode: "{U+2C20}", html: "&#11296;",
			combiningForm: "{U+1E020}",
			combiningHTML: "&#122912;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ь"],
			tags: ["прописный Ерь глаголицы", "capital Yeri glagolitic"],
			symbol: Chr(0x2C20)
		},
		"glagolitic_s_let_yeri", {
			unicode: "{U+2C50}", html: "&#11344;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ь"],
			tags: ["строчный ерь глаголицы", "small yeri glagolitic"],
			symbol: Chr(0x2C50)
		},
		"glagolitic_c_let_yati", {
			unicode: "{U+2C21}", html: "&#11297;",
			combiningForm: "{U+1E021}",
			combiningHTML: "&#122913;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Я"],
			tags: ["прописный Ять глаголицы", "capital Yati glagolitic"],
			symbol: Chr(0x2C21)
		},
		"glagolitic_s_let_yati", {
			unicode: "{U+2C51}", html: "&#11345;",
			combiningForm: "{U+1E021}",
			combiningHTML: "&#122913;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "я"],
			tags: ["строчный ять глаголицы", "small yati glagolitic"],
			symbol: Chr(0x2C51)
		},
		"glagolitic_c_let_yo", {
			unicode: "{U+2C26}", html: "&#11302;",
			combiningForm: "{U+1E026}",
			combiningHTML: "&#122918;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ё"],
			tags: ["прописная Ё глаголицы", "capital Yo glagolitic"],
			symbol: Chr(0x2C26)
		},
		"glagolitic_s_let_yo", {
			unicode: "{U+2C56}", html: "&#11350;",
			combiningForm: "{U+1E026}",
			combiningHTML: "&#122918;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ё"],
			tags: ["строчная ё глаголицы", "small yo glagolitic"],
			symbol: Chr(0x2C56)
		},
		"glagolitic_c_let_spider_ha", {
			unicode: "{U+2C22}", html: "&#11298;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["прописный Хлъмъ глаголицы", "capital spider Ha glagolitic"],
			alt_layout: RightAlt " [Х]",
			symbol: Chr(0x2C22)
		},
		"glagolitic_s_let_spider_ha", {
			unicode: "{U+2C52}", html: "&#11346;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			tags: ["строчный хлъмъ глаголицы", "small spider ha glagolitic"],
			alt_layout: RightAlt " [х]",
			symbol: Chr(0x2C52)
		},
		"glagolitic_c_let_yu", {
			unicode: "{U+2C23}", html: "&#11299;",
			combiningForm: "{U+1E023}",
			combiningHTML: "&#122915;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Ю"],
			tags: ["прописная Ю глаголицы", "capital Yu glagolitic"],
			symbol: Chr(0x2C23)
		},
		"glagolitic_s_let_yu", {
			unicode: "{U+2C53}", html: "&#11347;",
			combiningForm: "{U+1E023}",
			combiningHTML: "&#122915;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "ю"],
			tags: ["строчная ю глаголицы", "small yu glagolitic"],
			symbol: Chr(0x2C53)
		},
		"glagolitic_c_let_small_yus", {
			unicode: "{U+2C24}", html: "&#11300;",
			combiningForm: "{U+1E024}",
			combiningHTML: "&#122916;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "Э"],
			tags: ["прописной малый Юс глаголицы", "capital small Yus glagolitic"],
			symbol: Chr(0x2C24)
		},
		"glagolitic_s_let_small_yus", {
			unicode: "{U+2C54}", html: "&#11348;",
			combiningForm: "{U+1E024}",
			combiningHTML: "&#122916;",
			titlesAlt: True,
			group: ["Glagolitic Letters", "э"],
			tags: ["прописной малый юс глаголицы", "capital small yus glagolitic"],
			symbol: Chr(0x2C54)
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
			symbol: Chr(0x2C27)
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
			symbol: Chr(0x2C57)
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
			symbol: Chr(0x2C28)
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
			symbol: Chr(0x2C58)
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
			symbol: Chr(0x2C29)
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
			symbol: Chr(0x2C59)
		},
		"glagolitic_c_let_fita", {
			unicode: "{U+2C2A}", html: "&#11306;",
			combiningForm: "{U+1E02A}",
			combiningHTML: "&#122922;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [Ф]",
			tags: ["прописная Фита глаголицы", "capital Fita glagolitic"],
			symbol: Chr(0x2C2A)
		},
		"glagolitic_s_let_fita", {
			unicode: "{U+2C5A}", html: "&#11354;",
			combiningForm: "{U+1E02A}",
			combiningHTML: "&#122922;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [ф]",
			tags: ["строчная фита глаголицы", "small fita glagolitic"],
			symbol: Chr(0x2C5A)
		},
		"glagolitic_c_let_shtapic", {
			unicode: "{U+2C2C}", html: "&#11308;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [Ъ]",
			tags: ["прописной Штапик глаголицы", "capital Shtapic glagolitic"],
			symbol: Chr(0x2C2C)
		},
		"glagolitic_s_let_shtapic", {
			unicode: "{U+2C5C}", html: "&#11356;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [ъ]",
			tags: ["строчной штапик глаголицы", "small shtapic glagolitic"],
			symbol: Chr(0x2C5C)
		},
		"glagolitic_c_let_trokutasti_a", {
			unicode: "{U+2C2D}", html: "&#11309;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [А]",
			tags: ["прописная треугольная А глаголицы", "capital trokutasti A glagolitic"],
			symbol: Chr(0x2C2D)
		},
		"glagolitic_s_let_trokutasti_a", {
			unicode: "{U+2C5D}", html: "&#11357;",
			titlesAlt: True,
			group: ["Glagolitic Letters"],
			alt_layout: RightAlt " [А]",
			tags: ["строчная треугольная a глаголицы", "small trokutasti a glagolitic"],
			symbol: Chr(0x2C5D)
		},
		;
		"cyr_com_vzmet", {
			unicode: "{U+A66F}", html: "&#42607;",
			group: [["Diacritics Primary", "Cyrillic Diacritics"], CtrlD],
			alt_layout: LeftControl LeftAlt " [в]",
			tags: ["взмет", "vzmet"],
			symbol: DottedCircle Chr(0xA66F)
		},
		"cyr_com_titlo", {
			unicode: "{U+0483}", html: "&#1155;",
			group: [["Diacritics Primary", "Cyrillic Diacritics"], ["n", "т"]],
			alt_layout: LeftControl LeftAlt " [т]",
			tags: ["титло", "titlo"],
			symbol: DottedCircle Chr(0x0483)
		},
		;
		;
		"futhark_ansuz", {
			unicode: "{U+16A8}", html: "&#5800;",
			titlesAlt: True,
			group: ["Futhark Runes", "A"],
			tags: ["ансуз", "ansuz"],
			symbol: Chr(0x16A8)
		},
		"futhark_bjarkan", {
			unicode: "{U+16D2}", html: "&#5842;",
			titlesAlt: True,
			group: ["Futhark Runes", "B"],
			tags: ["беркана", "bjarkan"],
			symbol: Chr(0x16D2)
		},
		"futhark_dagaz", {
			unicode: "{U+16DE}", html: "&#5854;",
			titlesAlt: True,
			group: ["Futhark Runes", "D"],
			tags: ["дагаз", "dagaz"],
			symbol: Chr(0x16DE)
		},
		"futhark_ehwaz", {
			unicode: "{U+16D6}", html: "&#5846;",
			titlesAlt: True,
			group: ["Futhark Runes", "E"],
			tags: ["эваз", "ehwaz"],
			symbol: Chr(0x16D6)
		},
		"futhark_fehu", {
			unicode: "{U+16A0}", html: "&#5792;",
			titlesAlt: True,
			group: ["Futhark Runes", "F"],
			tags: ["феху", "fehu"],
			symbol: Chr(0x16A0)
		},
		"futhark_gebo", {
			unicode: "{U+16B7}", html: "&#5815;",
			titlesAlt: True,
			group: ["Futhark Runes", "G"],
			tags: ["гебо", "gebo"],
			symbol: Chr(0x16B7)
		},
		"futhark_haglaz", {
			unicode: "{U+16BA}", html: "&#5818;",
			titlesAlt: True,
			group: ["Futhark Runes", "H"],
			tags: ["хагалаз", "haglaz"],
			symbol: Chr(0x16BA)
		},
		"futhark_isaz", {
			unicode: "{U+16C1}", html: "&#5825;",
			titlesAlt: True,
			group: ["Futhark Runes", "I"],
			tags: ["исаз", "isaz"],
			symbol: Chr(0x16C1)
		},
		"futhark_eihwaz", {
			unicode: "{U+16C7}", html: "&#5831;",
			titlesAlt: True,
			group: ["Futhark Runes"],
			alt_layout: RightShift " [I]",
			tags: ["эваз", "eihwaz"],
			symbol: Chr(0x16C7)
		},
		"futhark_jeran", {
			unicode: "{U+16C3}", html: "&#5827;",
			titlesAlt: True,
			group: ["Futhark Runes", "J"],
			tags: ["йера", "jeran"],
			symbol: Chr(0x16C3)
		},
		"futhark_kauna", {
			unicode: "{U+16B2}", html: "&#5810;",
			titlesAlt: True,
			group: ["Futhark Runes", "K"],
			tags: ["кеназ", "kauna"],
			symbol: Chr(0x16B2)
		},
		"futhark_laguz", {
			unicode: "{U+16DA}", html: "&#5850;",
			titlesAlt: True,
			group: ["Futhark Runes", "L"],
			tags: ["лагуз", "laukaz"],
			symbol: Chr(0x16DA)
		},
		"futhark_mannaz", {
			unicode: "{U+16D7}", html: "&#5847;",
			titlesAlt: True,
			group: ["Futhark Runes", "M"],
			tags: ["манназ", "mannaz"],
			symbol: Chr(0x16D7)
		},
		"futhark_naudiz", {
			unicode: "{U+16BE}", html: "&#5822;",
			titlesAlt: True,
			group: ["Futhark Runes", "N"],
			tags: ["наудиз", "naudiz"],
			symbol: Chr(0x16BE)
		},
		"futhark_ingwaz", {
			unicode: "{U+16DC}", html: "&#5852;",
			titlesAlt: True,
			group: ["Futhark Runes"],
			alt_layout: RightShift " [N]",
			tags: ["ингваз", "ingwaz"],
			symbol: Chr(0x16DC)
		},
		"futhark_odal", {
			unicode: "{U+16DF}", html: "&#5855;",
			titlesAlt: True,
			group: ["Futhark Runes", "O"],
			tags: ["одал", "odal"],
			symbol: Chr(0x16DF)
		},
		"futhark_pertho", {
			unicode: "{U+16C8}", html: "&#5832;",
			titlesAlt: True,
			group: ["Futhark Runes", "P"],
			tags: ["одал", "pertho"],
			symbol: Chr(0x16C8)
		},
		"futhark_raido", {
			unicode: "{U+16B1}", html: "&#5809;",
			titlesAlt: True,
			group: ["Futhark Runes", "R"],
			tags: ["райдо", "raido"],
			symbol: Chr(0x16B1)
		},
		"futhark_sowilo", {
			unicode: "{U+16CA}", html: "&#5834;",
			titlesAlt: True,
			group: ["Futhark Runes", "S"],
			tags: ["совило", "sowilo"],
			symbol: Chr(0x16CA)
		},
		"futhark_tiwaz", {
			unicode: "{U+16CF}", html: "&#5839;",
			titlesAlt: True,
			group: ["Futhark Runes", "T"],
			tags: ["тейваз", "tiwaz"],
			symbol: Chr(0x16CF)
		},
		"futhark_thurisaz", {
			unicode: "{U+16A6}", html: "&#5798;",
			titlesAlt: True,
			group: ["Futhark Runes"],
			alt_layout: RightShift "[T]",
			tags: ["турисаз", "thurisaz"],
			symbol: Chr(0x16A6)
		},
		"futhark_uruz", {
			unicode: "{U+16A2}", html: "&#5794;",
			titlesAlt: True,
			group: ["Futhark Runes", "U"],
			tags: ["уруз", "uruz"],
			symbol: Chr(0x16A2)
		},
		"futhark_wunjo", {
			unicode: "{U+16B9}", html: "&#5817;",
			titlesAlt: True,
			group: ["Futhark Runes", "W"],
			tags: ["вуньо", "wunjo"],
			symbol: Chr(0x16B9)
		},
		"futhark_algiz", {
			unicode: "{U+16C9}", html: "&#5833;",
			titlesAlt: True,
			group: ["Futhark Runes", "Z"],
			tags: ["альгиз", "algiz"],
			symbol: Chr(0x16C9)
		},
		"futhork_as", {
			unicode: "{U+16AA}", html: "&#5802;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [A]",
			tags: ["ас", "as"],
			symbol: Chr(0x16AA)
		},
		"futhork_aesc", {
			unicode: "{U+16AB}", html: "&#5803;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift " [A]",
			tags: ["эск", "aesc"],
			symbol: Chr(0x16AB)
		},
		"futhork_cen", {
			unicode: "{U+16B3}", html: "&#5811;",
			titlesAlt: True,
			group: ["Futhork Runes", "C"],
			tags: ["кен", "cen"],
			symbol: Chr(0x16B3)
		},
		"futhork_ear", {
			unicode: "{U+16E0}", html: "&#5820;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [E]",
			tags: ["эар", "ear"],
			symbol: Chr(0x16E0)
		},
		"futhork_gar", {
			unicode: "{U+16B8}", html: "&#5816;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [G]",
			tags: ["гар", "gar"],
			symbol: Chr(0x16B8)
		},
		"futhork_haegl", {
			unicode: "{U+16BB}", html: "&#5819;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [H]",
			tags: ["хегль", "haegl"],
			symbol: Chr(0x16BB)
		},
		"futhork_ger", {
			unicode: "{U+16C4}", html: "&#5828;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [J]",
			tags: ["гер", "ger"],
			symbol: Chr(0x16C4)
		},
		"futhork_ior", {
			unicode: "{U+16E1}", html: "&#5857;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift "[J]",
			tags: ["йор", "ior"],
			symbol: Chr(0x16E1)
		},
		"futhork_cealc", {
			unicode: "{U+16E4}", html: "&#5860;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [K]",
			tags: ["келк", "cealc"],
			symbol: Chr(0x16E4)
		},
		"futhork_calc", {
			unicode: "{U+16E3}", html: "&#5859;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift " [K]",
			tags: ["калк", "calc"],
			symbol: Chr(0x16E3)
		},
		"futhork_ing", {
			unicode: "{U+16DD}", html: "&#5853;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [N]",
			tags: ["инг", "ing"],
			symbol: Chr(0x16DD)
		},
		"futhork_os", {
			unicode: "{U+16A9}", html: "&#5801;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [O]",
			tags: ["ос", "os"],
			symbol: Chr(0x16A9)
		},
		"futhork_cweorth", {
			unicode: "{U+16E2}", html: "&#5801;",
			titlesAlt: True,
			group: ["Futhork Runes", "Q"],
			tags: ["квирд", "cweorth"],
			symbol: Chr(0x16E2)
		},
		"futhork_sigel", {
			unicode: "{U+16CB}", html: "&#5835;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [S]",
			tags: ["сигель", "sigel"],
			symbol: Chr(0x16CB)
		},
		"futhork_stan", {
			unicode: "{U+16E5}", html: "&#5861;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: RightShift " [S]",
			tags: ["стан", "stan"],
			symbol: Chr(0x16E5)
		},
		"futhork_yr", {
			unicode: "{U+16A3}", html: "&#5795;",
			titlesAlt: True,
			group: ["Futhork Runes"],
			alt_layout: LeftShift " [Y]",
			tags: ["ир", "yr"],
			symbol: Chr(0x16A3)
		},
		"futhark_younger_jera", {
			unicode: "{U+16C5}", html: "&#5829;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [A]",
			tags: ["младшая йера", "younger jera"],
			symbol: Chr(0x16C5)
		},
		"futhark_younger_jera_short_twig", {
			unicode: "{U+16C6}", html: "&#5830;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [A]",
			tags: ["младшая короткая йера", "younger short twig jera"],
			symbol: Chr(0x16C6)
		},
		"futhark_younger_bjarkan_short_twig", {
			unicode: "{U+16D3}", html: "&#5843;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [B]",
			tags: ["младшая короткая беркана", "younger short twig bjarkan"],
			symbol: Chr(0x16D3)
		},
		"futhark_younger_hagall", {
			unicode: "{U+16BC}", html: "&#5820;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [H]",
			tags: ["младшая хагал", "younger hagall"],
			symbol: Chr(0x16BC)
		},
		"futhark_younger_hagall_short_twig", {
			unicode: "{U+16BD}", html: "&#5821;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [H]",
			tags: ["младший короткий хагал", "younger short twig hagall"],
			symbol: Chr(0x16BD)
		},
		"futhark_younger_kaun", {
			unicode: "{U+16B4}", html: "&#5812;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [K]",
			tags: ["младший каун", "younger kaun"],
			symbol: Chr(0x16B4)
		},
		"futhark_younger_madr", {
			unicode: "{U+16D8}", html: "&#5848;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [M]",
			tags: ["младший мадр", "younger madr"],
			symbol: Chr(0x16D8)
		},
		"futhark_younger_madr_short_twig", {
			unicode: "{U+16D9}", html: "&#5849;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [M]",
			tags: ["младший короткий мадр", "younger short twig madr"],
			symbol: Chr(0x16D9)
		},
		"futhark_younger_naud_short_twig", {
			unicode: "{U+16BF}", html: "&#5823;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [N]",
			tags: ["младший короткий науд", "younger short twig naud"],
			symbol: Chr(0x16BF)
		},
		"futhark_younger_oss", {
			unicode: "{U+16AC}", html: "&#5804;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt " [O]",
			tags: ["младший осс", "younger oss"],
			symbol: Chr(0x16AC)
		},
		"futhark_younger_oss_short_twig", {
			unicode: "{U+16AD}", html: "&#5805;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [O]",
			tags: ["младший короткий осс", "younger short twig oss"],
			symbol: Chr(0x16AD)
		},
		"futhark_younger_sol_short_twig", {
			unicode: "{U+16CC}", html: "&#5836;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [S]",
			tags: ["младший короткий сол", "younger short twig sol"],
			symbol: Chr(0x16CC)
		},
		"futhark_younger_tyr_short_twig", {
			unicode: "{U+16D0}", html: "&#5840;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [T]",
			tags: ["младший короткий тир", "younger short twig tyr"],
			symbol: Chr(0x16D0)
		},
		"futhark_younger_ur", {
			unicode: "{U+16A4}", html: "&#5804;",
			titlesAlt: True,
			group: ["Younger Futhark Runes", "Y"],
			tags: ["младший ур", "younger ur"],
			symbol: Chr(0x16A4)
		},
		"futhark_younger_yr", {
			unicode: "{U+16E6}", html: "&#5862;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt "[Y]",
			tags: ["младший короткий тис", "younger yr"],
			symbol: Chr(0x16E6)
		},
		"futhark_younger_yr_short_twig", {
			unicode: "{U+16E7}", html: "&#5863;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [Y]",
			tags: ["младший короткий тис", "younger short twig yr"],
			symbol: Chr(0x16E7)
		},
		"futhark_younger_icelandic_yr", {
			unicode: "{U+16E8}", html: "&#5864;",
			titlesAlt: True,
			group: ["Younger Futhark Runes"],
			alt_layout: RightShift " [Y]",
			tags: ["исладнский тис", "icelandic yr"],
			symbol: Chr(0x16E8)
		},
		"futhark_almanac_arlaug", {
			unicode: "{U+16EE}", html: "&#5870;",
			titlesAlt: True,
			group: ["Almanac Runes"],
			alt_layout: RightAlt " [7]",
			tags: ["арлауг", "arlaug"],
			symbol: Chr(0x16EE)
		},
		"futhark_almanac_tvimadur", {
			unicode: "{U+16EF}", html: "&#5871;",
			titlesAlt: True,
			group: ["Almanac Runes"],
			alt_layout: RightAlt " [8]",
			tags: ["твимадур", "tvimadur"],
			symbol: Chr(0x16EF)
		},
		"futhark_almanac_belgthor", {
			unicode: "{U+16F0}", html: "&#5872;",
			titlesAlt: True,
			group: ["Almanac Runes"],
			alt_layout: RightAlt " [9]",
			tags: ["белгтор", "belgthor"],
			symbol: Chr(0x16F0)
		},
		"futhark_younger_later_e", {
			unicode: "{U+16C2}", html: "&#5826;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [E]",
			tags: ["младшяя поздняя е", "younger later e"],
			symbol: Chr(0x16C2)
		},
		"futhark_younger_later_eth", {
			unicode: "{U+16A7}", html: "&#5799;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [D]",
			tags: ["младший поздний эт", "younger later eth"],
			symbol: Chr(0x16A7)
		},
		"futhark_younger_later_d", {
			unicode: "{U+16D1}", html: "&#5841;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt LeftShift " [D]",
			tags: ["младший поздний д", "younger later d"],
			symbol: Chr(0x16D1)
		},
		"futhark_younger_later_l", {
			unicode: "{U+16DB}", html: "&#5851;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [L]",
			tags: ["младший поздний л", "younger later l"],
			symbol: Chr(0x16DB)
		},
		"futhark_younger_later_p", {
			unicode: "{U+16D4}", html: "&#5844;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes"],
			alt_layout: RightAlt " [P]",
			tags: ["младшяя поздняя п", "younger later p"],
			symbol: Chr(0x16D4)
		},
		"futhark_younger_later_v", {
			unicode: "{U+16A1}", html: "&#5793;",
			titlesAlt: True,
			group: ["Later Younger Futhark Runes", "V"],
			tags: ["младший поздний в", "younger later v"],
			symbol: Chr(0x16A1)
		},
		"medieval_c", {
			unicode: "{U+16CD}", html: "&#5837;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [C]",
			tags: ["средневековый си", "medieval с"],
			symbol: Chr(0x16CD)
		},
		"medieval_en", {
			unicode: "{U+16C0}", html: "&#5824;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [N]",
			tags: ["средневековый эн", "medieval en"],
			symbol: Chr(0x16C0)
		},
		"medieval_on", {
			unicode: "{U+16B0}", html: "&#5808;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [O]",
			tags: ["средневековый он", "medieval on"],
			symbol: Chr(0x16B0)
		},
		"medieval_o", {
			unicode: "{U+16AE}", html: "&#5806;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt RightShift " [O]",
			tags: ["средневековый о", "medieval o"],
			symbol: Chr(0x16AE)
		},
		"medieval_x", {
			unicode: "{U+16EA}", html: "&#5866;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [X]",
			tags: ["средневековый экс", "medieval ex"],
			symbol: Chr(0x16EA)
		},
		"medieval_z", {
			unicode: "{U+16CE}", html: "&#5838;",
			titlesAlt: True,
			group: ["Medieval Runes"],
			alt_layout: RightAlt LeftAlt " [Z]",
			tags: ["средневековый зе", "medieval ze"],
			symbol: Chr(0x16CE)
		},
		"runic_single_punctuation", {
			unicode: "{U+16EB}", html: "&#5867;",
			titlesAlt: True,
			group: ["Runic Punctuation"],
			alt_layout: RightAlt " [.]",
			tags: ["руническая одиночное препинание", "runic single punctuation"],
			symbol: Chr(0x16EB)
		},
		"runic_multiple_punctuation", {
			unicode: "{U+16EC}", html: "&#5868;",
			titlesAlt: True,
			group: ["Runic Punctuation"],
			alt_layout: RightAlt " [Space]",
			tags: ["руническое двойное препинание", "runic multiple punctuation"],
			symbol: Chr(0x16EC)
		},
		"runic_cruciform_punctuation", {
			unicode: "{U+16ED}", html: "&#5869;",
			titlesAlt: True,
			group: ["Runic Punctuation"],
			alt_layout: RightAlt " [,]",
			tags: ["руническое крестовидное препинание", "runic cruciform punctuation"],
			symbol: Chr(0x16ED)
		},
		;
		;
		; * Wallet Signs
		"wallet_sign", {
			unicode: "{U+00A4}", html: "&#164;", entity: "&curren;",
			group: ["Wallet Signs"],
			tags: ["знак валюты", "currency sign"],
			recipe: ["XO"],
			symbol: Chr(0x00A4)
		},
		"wallet_dollar", {
			unicode: "{U+0024}", html: "&#36;", entity: "&dollar;",
			group: ["Wallet Signs"],
			tags: ["доллар", "dollar"],
			recipe: ["USD", "DLR"],
			symbol: Chr(0x0024)
		},
		"wallet_cent", {
			unicode: "{U+00A2}", html: "&cent;",
			group: ["Wallet Signs"],
			tags: ["цент", "cent"],
			recipe: ["c|", "CNT"],
			symbol: Chr(0x00A2)
		},
		"wallet_pound", {
			unicode: "{U+00A3}", html: "&#163;", entity: "&pound;",
			group: ["Wallet Signs"],
			tags: ["фунт", "pound"],
			recipe: ["f_", "GBP"],
			symbol: Chr(0x00A3)
		},
		"wallet_eur", {
			unicode: "{U+20AC}", html: "&#8364;",
			group: ["Wallet Signs"],
			tags: ["евро", "euro"],
			recipe: ["C=", "EUR"],
			symbol: Chr(0x20AC)
		},
		"wallet_franc", {
			unicode: "{U+20A3}", html: "&#8353;",
			group: ["Wallet Signs"],
			tags: ["франк", "franc"],
			recipe: ["F=", "FRF"],
			symbol: Chr(0x20A3)
		},
		"wallet_rub", {
			unicode: "{U+20BD}", html: "&#8381;",
			group: ["Wallet Signs"],
			tags: ["рубль", "ruble"],
			recipe: ["Р=", "RUB", "РУБ"],
			symbol: Chr(0x20BD)
		},
		"wallet_hryvnia", {
			unicode: "{U+20B4}", html: "&#8372;",
			group: ["Wallet Signs"],
			tags: ["гривна", "hryvnia"],
			recipe: ["S=", "UAH", "ГРН"],
			symbol: Chr(0x20B4)
		},
		"wallet_lira", {
			unicode: "{U+20A4}", html: "&#8356;",
			group: ["Wallet Signs"],
			tags: ["лира", "lira"],
			recipe: ["f=", "LIR"],
			symbol: Chr(0x20A4)
		},
		"wallet_turkish_lira", {
			unicode: "{U+20BA}", html: "&#8378;",
			group: ["Wallet Signs"],
			tags: ["лира", "lira"],
			recipe: ["L=", "TRY"],
			symbol: Chr(0x20BA)
		},
		"wallet_rupee", {
			unicode: "{U+20B9}", html: "&#8377;",
			group: ["Wallet Signs"],
			tags: ["рупия", "rupee"],
			recipe: ["R=", "INR", "RUP"],
			symbol: Chr(0x20B9)
		},
		"wallet_won", {
			unicode: "{U+20A9}", html: "&#8361;",
			group: ["Wallet Signs"],
			tags: ["вон", "won"],
			recipe: ["W=", "WON", "KRW"],
			symbol: Chr(0x20A9)
		},
		"wallet_yen", {
			unicode: "{U+00A5}", html: "&#165;", entity: "&yen;",
			group: ["Wallet Signs"],
			tags: ["знак йены", "yen sign"],
			recipe: ["Y=", "YEN"],
			symbol: Chr(0x00A5)
		},
		"wallet_jpy_yen", {
			unicode: "{U+5186}", html: "&#20870;",
			group: ["Wallet Signs"],
			tags: ["йена", "yen"],
			recipe: ["JPY"],
			symbol: Chr(0x5186)
		},
		"wallet_cny_yuan", {
			unicode: "{U+5143}", html: "&#20803;",
			group: ["Wallet Signs"],
			tags: ["юань", "yuan"],
			recipe: ["CNY"],
			symbol: Chr(0x5143)
		},
		"wallet_viet_dong", {
			unicode: "{U+20AB}", html: "&#8363;",
			group: ["Wallet Signs"],
			tags: ["вьетнамский донг", "vietnamese dong"],
			recipe: ["VND", "DNG"],
			symbol: Chr(0x20AB)
		},
		"wallet_mongol_tugrik", {
			unicode: "{U+20AE}", html: "&#8366;",
			group: ["Wallet Signs"],
			tags: ["монгольский тугрик", "mongolian tugrik"],
			recipe: ["T//", "MNT", "TGK"],
			symbol: Chr(0x20AE)
		},
		"wallet_qazaq_tenge", {
			unicode: "{U+20B8}", html: "&#8376;",
			group: ["Wallet Signs"],
			tags: ["казахский тенге", "kazakh tenge"],
			recipe: ["T=", "KZT", "TNG"],
			symbol: Chr(0x20B8)
		},
		"wallet_new_sheqel", {
			unicode: "{U+20AA}", html: "&#8362;",
			group: ["Wallet Signs"],
			tags: ["новый шекель", "new sheqel"],
			recipe: ["NZD", "SHQ"],
			symbol: Chr(0x20AA)
		},
		"wallet_philippine_peso", {
			unicode: "{U+20B1}", html: "&#8369;",
			group: ["Wallet Signs"],
			tags: ["филиппинский песо", "philippine peso"],
			recipe: ["P=", "PHP"],
			symbol: Chr(0x20B1)
		},
		"wallet_roman_denarius", {
			unicode: "{U+10196}", html: "&#65942;",
			group: ["Wallet Signs"],
			tags: ["римский денарий", "roman denarius"],
			recipe: ["X-", "DIN"],
			symbol: Chr(0x10196)
		},
		"wallet_bitcoin", {
			unicode: "{U+20BF}", html: "&#8383;",
			group: ["Wallet Signs"],
			tags: ["биткоин", "bitcoin"],
			recipe: ["B||", "BTC"],
			symbol: Chr(0x20BF)
		},
		;
		"copyright", {
			unicode: "{U+00A9}", html: "&#169;", entity: "&copy;",
			altCode: "0169",
			group: ["Other Signs", ["c", "с"]],
			show_on_fast_keys: True,
			tags: ["копирайт", "copyright"],
			recipe: ["copy", "cri"],
			symbol: Chr(0x00A9)
		},
		"copyleft", {
			unicode: "{U+1F12F}", html: "&#127279;",
			group: ["Other Signs"],
			tags: ["копилефт", "copyleft"],
			recipe: "cft",
			symbol: Chr(0x1F12F)
		},
		"registered", {
			unicode: "{U+00AE}", html: "&#174;", entity: "&reg;",
			altCode: "0174",
			group: ["Other Signs", ["c", "с"]],
			modifier: CapsLock,
			show_on_fast_keys: True,
			tags: ["зарегистрированный", "registered"],
			recipe: "reg",
			symbol: Chr(0x00AE)
		},
		"trademark", {
			unicode: "{U+2122}", html: "&#8482;", entity: "&trade;",
			altCode: "0153",
			group: ["Other Signs", ["c", "с"]],
			modifier: LeftShift,
			show_on_fast_keys: True,
			tags: ["торговый знак", "trademark"],
			recipe: ["TM", "tm"],
			symbol: Chr(0x2122)
		},
		"servicemark", {
			unicode: "{U+2120}", html: "&#8480;",
			group: ["Other Signs", ["c", "с"]],
			modifier: CapsLock LeftShift,
			show_on_fast_keys: True,
			tags: ["знак обслуживания", "servicemark"],
			recipe: ["SM", "sm"],
			symbol: Chr(0x2120)
		},
)

MapInsert(Characters,
	"num_sup_0", { unicode: "{U+2070}", html: "&#8304;", symbol: Chr(0x2070) },
		"num_sup_1", { unicode: "{U+00B9}", html: "&#185;", entity: "&sup1;", symbol: Chr(0x00B9) },
		"num_sup_2", { unicode: "{U+00B2}", html: "&#178;", entity: "&sup2;", symbol: Chr(0x00B2) },
		"num_sup_3", { unicode: "{U+00B3}", html: "&#179;", entity: "&sup3;", symbol: Chr(0x00B3) },
		"num_sup_4", { unicode: "{U+2074}", html: "&#8308;", symbol: Chr(0x2074) },
		"num_sup_5", { unicode: "{U+2075}", html: "&#8309;", symbol: Chr(0x2075) },
		"num_sup_6", { unicode: "{U+2076}", html: "&#8310;", symbol: Chr(0x2076) },
		"num_sup_7", { unicode: "{U+2077}", html: "&#8311;", symbol: Chr(0x2077) },
		"num_sup_8", { unicode: "{U+2078}", html: "&#8312;", symbol: Chr(0x2078) },
		"num_sup_9", { unicode: "{U+2079}", html: "&#8313;", symbol: Chr(0x2079) },
		"num_sup_minus", { unicode: "{U+207B}", html: "&#8315;", symbol: Chr(0x207B) },
		"num_sup_equals", { unicode: "{U+207C}", html: "&#8316;", symbol: Chr(0x207C) },
		"num_sup_plus", { unicode: "{U+207A}", html: "&#8314;", symbol: Chr(0x207A) },
		"num_sup_left_parenthesis", { unicode: "{U+207D}", html: "&#8317;", symbol: Chr(0x207D) },
		"num_sup_right_parenthesis", { unicode: "{U+207E}", html: "&#8318;", symbol: Chr(0x207E) },
		"num_sub_0", { unicode: "{U+2080}", html: "&#8320;", symbol: Chr(0x2080) },
		"num_sub_1", { unicode: "{U+2081}", html: "&#8321;", symbol: Chr(0x2081) },
		"num_sub_2", { unicode: "{U+2082}", html: "&#8322;", symbol: Chr(0x2082) },
		"num_sub_3", { unicode: "{U+2083}", html: "&#8323;", symbol: Chr(0x2083) },
		"num_sub_4", { unicode: "{U+2084}", html: "&#8324;", symbol: Chr(0x2084) },
		"num_sub_5", { unicode: "{U+2085}", html: "&#8325;", symbol: Chr(0x2085) },
		"num_sub_6", { unicode: "{U+2086}", html: "&#8326;", symbol: Chr(0x2086) },
		"num_sub_7", { unicode: "{U+2087}", html: "&#8327;", symbol: Chr(0x2087) },
		"num_sub_8", { unicode: "{U+2088}", html: "&#8328;", symbol: Chr(0x2088) },
		"num_sub_9", { unicode: "{U+2089}", html: "&#8329;", symbol: Chr(0x2089) },
		"num_sub_minus", { unicode: "{U+208B}", html: "&#8331;", symbol: Chr(0x208B) },
		"num_sub_equals", { unicode: "{U+208C}", html: "&#8332;", symbol: Chr(0x208C) },
		"num_sub_plus", { unicode: "{U+208A}", html: "&#8330;", symbol: Chr(0x208A) },
		"num_sub_left_parenthesis", { unicode: "{U+208D}", html: "&#8333;", symbol: Chr(0x208D) },
		"num_sub_right_parenthesis", { unicode: "{U+208E}", html: "&#8334;", symbol: Chr(0x208E) },
)

MapInsert(Characters,
	"kkey_0", { unicode: "{U+0030}", html: "&#48;", sup: "num_sup_0", sub: "num_sub_0", symbol: "0" },
		"kkey_1", { unicode: "{U+0031}", html: "&#49;", sup: "num_sup_1", sub: "num_sub_1", symbol: "1" },
		"kkey_2", { unicode: "{U+0032}", html: "&#50;", sup: "num_sup_2", sub: "num_sub_2", symbol: "2" },
		"kkey_3", { unicode: "{U+0033}", html: "&#51;", sup: "num_sup_3", sub: "num_sub_3", symbol: "3" },
		"kkey_4", { unicode: "{U+0034}", html: "&#52;", sup: "num_sup_4", sub: "num_sub_4", symbol: "4" },
		"kkey_5", { unicode: "{U+0035}", html: "&#53;", sup: "num_sup_5", sub: "num_sub_5", symbol: "5" },
		"kkey_6", { unicode: "{U+0036}", html: "&#54;", sup: "num_sup_6", sub: "num_sub_6", symbol: "6" },
		"kkey_7", { unicode: "{U+0037}", html: "&#55;", sup: "num_sup_7", sub: "num_sub_7", symbol: "7" },
		"kkey_8", { unicode: "{U+0038}", html: "&#56;", sup: "num_sup_8", sub: "num_sub_8", symbol: "8" },
		"kkey_9", { unicode: "{U+0039}", html: "&#57;", sup: "num_sup_9", sub: "num_sub_9", symbol: "9" },
		"kkey_minus", { unicode: "{U+002D}", html: "&#45;", sup: "num_sup_minus", sub: "num_sub_minus", symbol: "-" },
		"kkey_equals", { unicode: "{U+003D}", html: "&#61;", sup: "num_sup_equals", sub: "num_sub_equals", symbol: "=" },
		"kkey_plus", { unicode: "{U+002B}", html: "&#43;", sup: "num_sup_plus", sub: "num_sub_plus", symbol: "+" },
		"kkey_left_parenthesis", { unicode: "{U+0028}", html: "&#40;", sup: "num_sup_left_parenthesis", sub: "num_sub_left_parenthesis", symbol: "(" },
		"kkey_right_parenthesis", { unicode: "{U+0029}", html: "&#41;", sup: "num_sup_right_parenthesis", sub: "num_sub_right_parenthesis", symbol: ")" },
		"kkey_comma", { unicode: "{U+002C}", html: "&#44;", symbol: "," },
		"kkey_dot", { unicode: "{U+002E}", html: "&#46;", symbol: "." },
		"kkey_semicolon", { unicode: "{U+003B}", html: "&#59;", symbol: ";" },
		"kkey_apostrophe", { unicode: "{U+0027}", html: "&#39;", symbol: "'" },
		"kkey_l_square_bracket", { unicode: "{U+005B}", html: "&#91;", symbol: "[" },
		"kkey_r_square_bracket", { unicode: "{U+005D}", html: "&#93;", symbol: "]" },
		"kkey_grave_accent", { unicode: "{U+0060}", html: "&#96;", symbol: "``" },
)

CharactersCount := GetMapCount(Characters) - 2 - 21

MapInsert(Characters,
	"misc_crlf_emspace", {
		unicode: CallChar("carriage_return", "unicode"), html:
			CallChar("carriage_return", "html") .
			CallChar("new_line", "html") .
			CallChar("emsp", "html"),
		group: ["Misc"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "[Enter]",
		symbol: CallChar("carriage_return", "symbol")
	},
		"misc_lf_emspace", {
			unicode: CallChar("new_line", "unicode"), html:
				CallChar("new_line", "html") .
				CallChar("emsp", "html"),
			group: ["Misc"],
			show_on_fast_keys: True,
			alt_on_fast_keys: LeftShift " [Enter]",
			symbol: CallChar("new_line", "symbol")
		},
)

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
			characterEntity := (HasProp(value, "entity")) ? value.entity : value.html
			characterLaTeX := (HasProp(value, "LaTeX")) ? value.LaTeX : ""

			if IsObject(characterKeys) {
				for _, key in characterKeys {
					if (keyPressed == key) {
						if InputMode = "HTML" {
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
					if InputMode = "HTML" {
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
SearchKey() {

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

	IsSensitive := !(SubStr(PromptValue, 1, 1) = "*")
	if !IsSensitive
		PromptValue := SubStr(PromptValue, 2)

	Found := False
	for characterEntry, value in Characters {
		if !HasProp(value, "tags") {
			continue
		}
		characterEntity := (HasProp(value, "entity")) ? value.entity : value.html
		characterLaTeX := (HasProp(value, "LaTeX")) ? value.LaTeX : ""

		for _, tag in value.tags {
			IsEqualNonSensitive := IsSensitive && (StrLower(PromptValue) = StrLower(tag))
			IsEqualSensitive := !IsSensitive && (PromptValue == tag)

			if (IsEqualSensitive || IsEqualNonSensitive) {
				if InputMode = "HTML" {
					SendValue := CombiningEnabled && HasProp(value, "combiningHTML") ? value.combiningHTML : characterEntity
					SendText(SendValue)
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
				IniWrite !IsSensitive ? "*" . PromptValue : PromptValue, ConfigFile, "LatestPrompts", "Search"
				Found := True
				break 2
			}
		}
	}

	if !Found {
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

ToggleLetterScript() {
	KeysArray := [
		SCKeys["A"], (*) => EmptyFunc(),
		SCKeys["B"], (*) => EmptyFunc(),
		SCKeys["C"], (*) => EmptyFunc(),
		SCKeys["D"], (*) => EmptyFunc(),
		SCKeys["E"], (*) => EmptyFunc(),
		SCKeys["F"], (*) => EmptyFunc(),
		SCKeys["G"], (*) => EmptyFunc(),
		SCKeys["H"], (*) => EmptyFunc(),
		SCKeys["I"], (*) => EmptyFunc(),
		SCKeys["J"], (*) => EmptyFunc(),
		SCKeys["K"], (*) => EmptyFunc(),
		SCKeys["L"], (*) => EmptyFunc(),
		SCKeys["M"], (*) => EmptyFunc(),
		SCKeys["N"], (*) => EmptyFunc(),
		SCKeys["O"], (*) => EmptyFunc(),
		SCKeys["P"], (*) => EmptyFunc(),
		SCKeys["Q"], (*) => EmptyFunc(),
		SCKeys["R"], (*) => EmptyFunc(),
		SCKeys["S"], (*) => EmptyFunc(),
		SCKeys["T"], (*) => EmptyFunc(),
		SCKeys["U"], (*) => EmptyFunc(),
		SCKeys["V"], (*) => EmptyFunc(),
		SCKeys["W"], (*) => EmptyFunc(),
		SCKeys["X"], (*) => EmptyFunc(),
		SCKeys["Y"], (*) => EmptyFunc(),
		SCKeys["Z"], (*) => EmptyFunc(),
		SCKeys["LSquareBracket"], (*) => EmptyFunc(),
		SCKeys["RSquareBracket"], (*) => EmptyFunc(),
		SCKeys["Tilde"], (*) => EmptyFunc(),
		SCKeys["Comma"], (*) => EmptyFunc(),
		SCKeys["Dot"], (*) => EmptyFunc(),
		SCKeys["Semicolon"], (*) => EmptyFunc(),
		SCKeys["Apostrophe"], (*) => EmptyFunc(),
	]
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
	MsgBox(GlagoFutharkActive ? ActivationMessage[LanguageCode].Active : ActivationMessage[LanguageCode].Deactive, "Glagolitic/Futhark", 0x40)


	Sleep 25
	RegisterHotKeys(GlagoliticFuthark, GlagoFutharkActive)
	if !GlagoFutharkActive {
		Sleep 25
		RegisterHotKeys(FastKeysList)
	}
	return
}

GlagoliticFuthark := [
	SCKeys["A"], (*) => LangSeparatedKey("futhark_ansuz", ["glagolitic_c_let_fritu", "glagolitic_s_let_fritu"], True),
	"<+" SCKeys["A"], (*) => LangSeparatedKey("futhork_as", ["", ""], True),
	">+" SCKeys["A"], (*) => LangSeparatedKey("futhork_aesc", ["", ""], True),
	"<^>!" SCKeys["A"], (*) => LangSeparatedKey("futhark_younger_jera", ["glagolitic_c_let_fita", "glagolitic_s_let_fita"], True),
	"<^>!<+" SCKeys["A"], (*) => LangSeparatedKey("futhark_younger_jera_short_twig", ["", ""], True),
	SCKeys["B"], (*) => LangSeparatedKey("futhark_bjarkan", ["glagolitic_c_let_i", "glagolitic_s_let_i"], True),
	"<^>!" SCKeys["B"], (*) => LangSeparatedKey("", ["glagolitic_c_let_initial_izhe", "glagolitic_s_let_initial_izhe"], True),
	"<+" SCKeys["B"], (*) => LangSeparatedKey("", ["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"], True),
	"<^>!<+" SCKeys["B"], (*) => LangSeparatedKey("futhark_younger_bjarkan_short_twig", ["glagolitic_c_let_izhitsa", "glagolitic_s_let_izhitsa"], True),
	SCKeys["C"], (*) => LangSeparatedKey("futhork_cen", ["glagolitic_c_let_slovo", "glagolitic_s_let_slovo"], True),
	"<^>!" SCKeys["C"], (*) => LangSeparatedKey("", ["glagolitic_c_let_dzelo", "glagolitic_s_let_dzelo"], True),
	"<^>!<!" SCKeys["C"], (*) => LangSeparatedKey("medieval_c", ["", ""], True),
	SCKeys["D"], (*) => LangSeparatedKey("futhark_dagaz", ["glagolitic_c_let_vede", "glagolitic_s_let_vede"], True),
	"<^>!" SCKeys["D"], (*) => LangSeparatedKey("futhark_younger_later_eth", ["", ""], True),
	"<^>!<+" SCKeys["D"], (*) => LangSeparatedKey("futhark_younger_later_d", ["", ""], True),
	SCKeys["E"], (*) => LangSeparatedKey("futhark_ehwaz", ["glagolitic_c_let_uku", "glagolitic_s_let_uku"], True),
	"<+" SCKeys["E"], (*) => LangSeparatedKey("futhork_ear", ["", ""], True),
	"<^>!" SCKeys["E"], (*) => LangSeparatedKey("futhark_younger_later_e", ["", ""], True),
	"<^>!<!" SCKeys["E"], (*) => LangSeparatedKey("medieval_en", ["", ""], True),
	SCKeys["F"], (*) => LangSeparatedKey("futhark_fehu", ["glagolitic_c_let_az", "glagolitic_s_let_az"], True),
	"<^>!" SCKeys["F"], (*) => LangSeparatedKey("", ["glagolitic_c_let_trokutasti_a", "glagolitic_s_let_trokutasti_a"], True),
	SCKeys["G"], (*) => LangSeparatedKey("futhark_gebo", ["glagolitic_c_let_pokoji", "glagolitic_s_let_pokoji"], True),
	"<^>!" SCKeys["G"], (*) => LangSeparatedKey("", ["glagolitic_c_let_pe", "glagolitic_s_let_pe"], True),
	"<+" SCKeys["G"], (*) => LangSeparatedKey("futhork_gar", ["", ""], True),
	SCKeys["H"], (*) => LangSeparatedKey("futhark_haglaz", ["glagolitic_c_let_ritsi", "glagolitic_s_let_ritsi"], True),
	"<+" SCKeys["H"], (*) => LangSeparatedKey("futhork_haegl", ["", ""], True),
	"<^>!" SCKeys["H"], (*) => LangSeparatedKey("futhark_younger_hagall", ["", ""], True),
	"<^>!<+" SCKeys["H"], (*) => LangSeparatedKey("futhark_younger_hagall_short_twig", ["", ""], True),
	SCKeys["I"], (*) => LangSeparatedKey("futhark_isaz", ["glagolitic_c_let_sha", "glagolitic_s_let_sha"], True),
	">+" SCKeys["I"], (*) => LangSeparatedKey("futhark_eihwaz", ["", ""], True),
	"<^>!" SCKeys["J"], (*) => LangSeparatedKey("", ["glagolitic_c_let_otu", "glagolitic_s_let_otu"], True),
	SCKeys["J"], (*) => LangSeparatedKey("futhark_jeran", ["glagolitic_c_let_onu", "glagolitic_s_let_onu"], True),
	"<!" SCKeys["J"], (*) => LangSeparatedKey("", ["glagolitic_c_let_big_yus", "glagolitic_s_let_big_yus"], True),
	"<+" SCKeys["J"], (*) => LangSeparatedKey("futhork_ger", ["", ""], True),
	">+" SCKeys["J"], (*) => LangSeparatedKey("futhork_ior", ["", ""], True),
	SCKeys["L"], (*) => LangSeparatedKey("futhark_laguz", ["glagolitic_c_let_dobro", "glagolitic_s_let_dobro"], True),
	"<^>!" SCKeys["L"], (*) => LangSeparatedKey("futhark_younger_later_l", ["", ""], True),
	SCKeys["K"], (*) => LangSeparatedKey("futhark_kauna", ["glagolitic_c_let_ljudije", "glagolitic_s_let_ljudije"], True),
	"<+" SCKeys["K"], (*) => LangSeparatedKey("futhork_cealc", ["", ""], True),
	">+" SCKeys["K"], (*) => LangSeparatedKey("futhork_calc", ["", ""], True),
	"<^>!" SCKeys["K"], (*) => LangSeparatedKey("futhark_younger_kaun", ["", ""], True),
	"<^>!" SCKeys["K"], (*) => LangSeparatedKey("futhark_younger_kaun", ["", ""], True),
	SCKeys["M"], (*) => LangSeparatedKey("futhark_mannaz", ["glagolitic_c_let_yeri", "glagolitic_s_let_yeri"], True),
	"<^>!" SCKeys["M"], (*) => LangSeparatedKey("futhark_younger_madr", ["", ""], True),
	"<^>!<+" SCKeys["M"], (*) => LangSeparatedKey("futhark_younger_madr_short_twig", ["", ""], True),
	SCKeys["N"], (*) => LangSeparatedKey("futhark_naudiz", ["glagolitic_c_let_tvrido", "glagolitic_s_let_tvrido"], True),
	">+" SCKeys["N"], (*) => LangSeparatedKey("futhark_ingwaz", ["", ""], True),
	"<+" SCKeys["N"], (*) => LangSeparatedKey("futhork_ing", ["", ""], True),
	"<^>!<+" SCKeys["N"], (*) => LangSeparatedKey("futhark_younger_naud_short_twig", ["", ""], True),
	SCKeys["O"], (*) => LangSeparatedKey("futhark_odal", ["glagolitic_c_let_shta", "glagolitic_s_let_shta"], True),
	"<+" SCKeys["O"], (*) => LangSeparatedKey("futhork_os", ["", ""], True),
	"<^>!" SCKeys["O"], (*) => LangSeparatedKey("futhark_younger_oss", ["", ""], True),
	"<^>!<+" SCKeys["O"], (*) => LangSeparatedKey("futhark_younger_oss_short_twig", ["", ""], True),
	"<^>!<!" SCKeys["O"], (*) => LangSeparatedKey("medieval_on", ["", ""], True),
	"<^>!<!>+" SCKeys["O"], (*) => LangSeparatedKey("medieval_o", ["", ""], True),
	SCKeys["P"], (*) => LangSeparatedKey("futhark_pertho", ["glagolitic_c_let_zemlja", "glagolitic_c_let_zemlja"], True),
	"<^>!" SCKeys["P"], (*) => LangSeparatedKey("futhark_younger_later_p", ["", ""], True),
	SCKeys["Q"], (*) => LangSeparatedKey("futhork_cweorth", ["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"], True),
	SCKeys["R"], (*) => LangSeparatedKey("futhark_raido", ["glagolitic_c_let_kako", "glagolitic_s_let_kako"], True),
	SCKeys["S"], (*) => LangSeparatedKey("futhark_sowilo", ["glagolitic_c_let_yery", "glagolitic_s_let_yery"], True),
	"<+" SCKeys["S"], (*) => LangSeparatedKey("futhork_sigel", ["", ""], True),
	">+" SCKeys["S"], (*) => LangSeparatedKey("futhork_stan", ["", ""], True),
	"<^>!<+" SCKeys["S"], (*) => LangSeparatedKey("futhark_younger_sol_short_twig", ["", ""], True),
	SCKeys["T"], (*) => LangSeparatedKey("futhark_tiwaz", ["glagolitic_c_let_yestu", "glagolitic_s_let_yestu"], True),
	">+" SCKeys["T"], (*) => LangSeparatedKey("futhark_thurisaz", ["", ""], True),
	"<^>!<+" SCKeys["T"], (*) => LangSeparatedKey("futhark_younger_tyr_short_twig", ["", ""], True),
	SCKeys["U"], (*) => LangSeparatedKey("futhark_uruz", ["glagolitic_c_let_glagoli", "glagolitic_s_let_glagoli"], True),
	SCKeys["Y"], (*) => LangSeparatedKey("futhark_younger_ur", ["glagolitic_c_let_nashi", "glagolitic_s_let_nashi"], True),
	">+" SCKeys["Y"], (*) => LangSeparatedKey("futhark_younger_icelandic_yr", ["", ""], True),
	"<^>!" SCKeys["Y"], (*) => LangSeparatedKey("futhark_younger_yr", ["", ""], True),
	"<^>!<+" SCKeys["Y"], (*) => LangSeparatedKey("futhark_younger_yr_short_twig", ["", ""], True),
	"<+" SCKeys["Y"], (*) => LangSeparatedKey("futhork_yr", ["", ""], True),
	SCKeys["V"], (*) => LangSeparatedKey("futhark_younger_later_v", ["glagolitic_c_let_myslite", "glagolitic_s_let_myslite"], True),
	SCKeys["W"], (*) => LangSeparatedKey("futhark_wunjo", ["glagolitic_c_let_tsi", "glagolitic_s_let_tsi"], True),
	SCKeys["Z"], (*) => LangSeparatedKey("futhark_algiz", ["glagolitic_c_let_yati", "glagolitic_s_let_yati"], True),
	"<^>!<!" SCKeys["Z"], (*) => LangSeparatedKey("medieval_x", ["", ""], True),
	SCKeys["X"], (*) => LangSeparatedKey("", ["glagolitic_c_let_chrivi", "glagolitic_s_let_chrivi"], True),
	"<^>!<!" SCKeys["X"], (*) => LangSeparatedKey("medieval_z", ["", ""], True),
	;
	SCKeys["Tilde"], (*) => LangSeparatedKey("kkey_grave_accent", ["glagolitic_c_let_yo", "glagolitic_s_let_yo"], True),
	"<!" SCKeys["Tilde"], (*) => LangSeparatedKey("", ["glagolitic_c_let_big_yus_iotified", "glagolitic_s_let_big_yus_iotified"], True),
	SCKeys["Comma"], (*) => LangSeparatedKey("kkey_comma", ["glagolitic_c_let_buky", "glagolitic_s_let_buky"], True),
	SCKeys["Dot"], (*) => LangSeparatedKey("kkey_dot", ["glagolitic_c_let_yu", "glagolitic_s_let_yu"], True),
	"<^>!" SCKeys["Comma"], (*) => LangSeparatedKey("runic_cruciform_punctuation", ["", ""], True),
	"<^>!" SCKeys["Dot"], (*) => LangSeparatedKey("runic_single_punctuation", ["", ""], True),
	"<^>!" SCKeys["Space"], (*) => LangSeparatedKey("runic_multiple_punctuation", ["", ""], True),
	SCKeys["Semicolon"], (*) => LangSeparatedKey("kkey_semicolon", ["glagolitic_c_let_zhivete", "glagolitic_s_let_zhivete"], True),
	"<^>!" SCKeys["Semicolon"], (*) => LangSeparatedKey("kkey_semicolon", ["glagolitic_c_let_djervi", "glagolitic_s_let_djervi"], True),
	SCKeys["Apostrophe"], (*) => LangSeparatedKey("kkey_apostrophe", ["glagolitic_c_let_small_yus", "glagolitic_s_let_small_yus"], True),
	"<^>!" SCKeys["Apostrophe"], (*) => LangSeparatedKey("kkey_apostrophe", ["glagolitic_c_let_small_yus_iotified", "glagolitic_s_let_small_yus_iotified"], True),
	SCKeys["LSquareBracket"], (*) => LangSeparatedKey("kkey_l_square_bracket", ["glagolitic_c_let_heru", "glagolitic_s_let_heru"], True),
	"<^>!" SCKeys["LSquareBracket"], (*) => LangSeparatedKey("", ["glagolitic_c_let_spider_ha", "glagolitic_s_let_spider_ha"], True),
	SCKeys["RSquareBracket"], (*) => LangSeparatedKey("kkey_r_square_bracket", ["glagolitic_c_let_yeru", "glagolitic_s_let_yeru"], True),
	"<^>!" SCKeys["RSquareBracket"], (*) => LangSeparatedKey("", ["glagolitic_c_let_shtapic", "glagolitic_s_let_shtapic"], True),
	;
	"<^>!" SCKeys["7"], (*) => LangSeparatedKey("futhark_almanac_arlaug", ["", ""], True),
	"<^>!" SCKeys["8"], (*) => LangSeparatedKey("futhark_almanac_tvimadur", ["", ""], True),
	"<^>!" SCKeys["9"], (*) => LangSeparatedKey("futhark_almanac_belgthor", ["", ""], True),
	;
	"<^<!" SCKeys["D"], (*) => HandleFastKey("cyr_com_vzmet"),
]

ChangeScriptInput(ScriptMode) {
	PreviousScriptMode := IniRead(ConfigFile, "Settings", "ScriptInput", "Default")
	KeysArray := [
		SCKeys["1"], (*) => EmptyFunc(),
		SCKeys["2"], (*) => EmptyFunc(),
		SCKeys["3"], (*) => EmptyFunc(),
		SCKeys["4"], (*) => EmptyFunc(),
		SCKeys["5"], (*) => EmptyFunc(),
		SCKeys["6"], (*) => EmptyFunc(),
		SCKeys["7"], (*) => EmptyFunc(),
		SCKeys["8"], (*) => EmptyFunc(),
		SCKeys["9"], (*) => EmptyFunc(),
		SCKeys["0"], (*) => EmptyFunc(),
		SCKeys["Minus"], (*) => EmptyFunc(),
		SCKeys["Equals"], (*) => EmptyFunc(),
		"<+" SCKeys["9"], (*) => EmptyFunc(),
		"<+" SCKeys["0"], (*) => EmptyFunc(),
		"<+" SCKeys["Equals"], (*) => EmptyFunc(),
	]

	if (ScriptMode != "Default" && (ScriptMode = PreviousScriptMode)) {
		IniWrite("Default", ConfigFile, "Settings", "ScriptInput")
		RegisterHotKeys(KeysArray, False)
	} else {
		IniWrite(ScriptMode, ConfigFile, "Settings", "ScriptInput")
		RegisterHotKeys(ScriptMode == "sup" ? SuperscriptList : SubscriptList, True)
	}
}

SuperscriptList := [
	SCKeys["1"], (*) => HandleFastKey("num_sup_1"),
	SCKeys["2"], (*) => HandleFastKey("num_sup_2"),
	SCKeys["3"], (*) => HandleFastKey("num_sup_3"),
	SCKeys["4"], (*) => HandleFastKey("num_sup_4"),
	SCKeys["5"], (*) => HandleFastKey("num_sup_5"),
	SCKeys["6"], (*) => HandleFastKey("num_sup_6"),
	SCKeys["7"], (*) => HandleFastKey("num_sup_7"),
	SCKeys["8"], (*) => HandleFastKey("num_sup_8"),
	SCKeys["9"], (*) => HandleFastKey("num_sup_9"),
	SCKeys["0"], (*) => HandleFastKey("num_sup_0"),
	SCKeys["Minus"], (*) => HandleFastKey("num_sup_minus"),
	SCKeys["Equals"], (*) => HandleFastKey("num_sup_equals"),
	"<+" SCKeys["9"], (*) => HandleFastKey("num_sup_left_parenthesis"),
	"<+" SCKeys["0"], (*) => HandleFastKey("num_sup_right_parenthesis"),
	"<+" SCKeys["Equals"], (*) => HandleFastKey("num_sup_plus"),
]

SubscriptList := [
	SCKeys["1"], (*) => HandleFastKey("num_sub_1"),
	SCKeys["2"], (*) => HandleFastKey("num_sub_2"),
	SCKeys["3"], (*) => HandleFastKey("num_sub_3"),
	SCKeys["4"], (*) => HandleFastKey("num_sub_4"),
	SCKeys["5"], (*) => HandleFastKey("num_sub_5"),
	SCKeys["6"], (*) => HandleFastKey("num_sub_6"),
	SCKeys["7"], (*) => HandleFastKey("num_sub_7"),
	SCKeys["8"], (*) => HandleFastKey("num_sub_8"),
	SCKeys["9"], (*) => HandleFastKey("num_sub_9"),
	SCKeys["0"], (*) => HandleFastKey("num_sub_0"),
	SCKeys["Minus"], (*) => HandleFastKey("num_sub_minus"),
	SCKeys["Equals"], (*) => HandleFastKey("num_sub_equals"),
	"<+" SCKeys["9"], (*) => HandleFastKey("num_sub_left_parenthesis"),
	"<+" SCKeys["0"], (*) => HandleFastKey("num_sub_right_parenthesis"),
	"<+" SCKeys["Equals"], (*) => HandleFastKey("num_sub_plus"),
]

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
		ClipWait(50, 1)
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
		ClipWait(250, 1)
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
	ClipWait(50, 1)
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
			ClipWait(250, 1)
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
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	ClipWait(50, 1)
	PromptValue := A_Clipboard
	A_Clipboard := ""

	if (PromptValue != "") {
		france_left := GetChar("france_left")
		france_right := GetChar("france_right")
		quote_low_9_double := GetChar("quote_low_9_double")
		quote_left_double := GetChar("quote_left_double")
		quote_right_double := GetChar("quote_right_double")
		quote_left_single := GetChar("quote_left_single")
		quote_right_single := GetChar("quote_right_single")


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
		ClipWait(250, 1)
		Sleep 250
		Send("^v")

		;SendText(PromptValue)
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
									if InputMode = "HTML" {
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
							if InputMode = "HTML" {
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
						if InputMode = "HTML" {
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
				if InputMode = "HTML" {
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

Hotkey("<#<!" SCKeys["F1"], (*) => GroupActivator("Diacritics Primary", "F1"))
Hotkey("<#<!" SCKeys["F2"], (*) => GroupActivator("Diacritics Secondary", "F2"))
Hotkey("<#<!" SCKeys["F3"], (*) => GroupActivator("Diacritics Tertiary", "F3"))
Hotkey("<#<!" SCKeys["F6"], (*) => GroupActivator("Diacritics Quatemary", "F6"))
Hotkey("<#<!" SCKeys["F7"], (*) => GroupActivator("Special Characters", "F7"))
Hotkey("<#<!" SCKeys["Space"], (*) => GroupActivator("Spaces"))
Hotkey("<#<!" SCKeys["Minus"], (*) => GroupActivator("Dashes", "-"))
Hotkey("<#<!" SCKeys["Apostrophe"], (*) => GroupActivator("Quotes", "'"))
GroupActivator(GroupName, KeyValue := "") {
	LocaleMark := KeyValue != "" && RegExMatch(KeyValue, "^F") ? KeyValue : GroupName
	MsgTitle := "[" LocaleMark "] " DSLPadTitle

	ShowInfoMessage("tray_active_" . StrLower(LocaleMark), , MsgTitle, SkipGroupMessage, True)
	InputBridge(GroupName)
}
Hotkey("<#<!" SCKeys["F"], (*) => SearchKey())
Hotkey("<#<!" SCKeys["U"], (*) => InsertUnicodeKey())
Hotkey("<#<!" SCKeys["A"], (*) => InsertAltCodeKey())
Hotkey("<#<!" SCKeys["L"], (*) => Ligaturise())
Hotkey(">+" SCKeys["L"], (*) => Ligaturise("Clipboard"))
Hotkey(">+" SCKeys["Backspace"], (*) => Ligaturise("Backspace"))
Hotkey("<#<^>!" SCKeys["1"], (*) => SwitchToScript("sup"))
Hotkey("<#<^>!" SCKeys["2"], (*) => SwitchToScript("sub"))
Hotkey("<#<^>!" SCKeys["3"], (*) => SwitchToRoman())
Hotkey("<#<!" SCKeys["M"], (*) => ToggleGroupMessage())
Hotkey("<#<!" SCKeys["PgUp"], (*) => FindCharacterPage())
Hotkey("<#<!" SCKeys["PgDn"], (*) => ReplaceWithUnicode())
Hotkey("<#<+" SCKeys["PgDn"], (*) => ReplaceWithUnicode("Hex"))
Hotkey("<#<!" SCKeys["Home"], (*) => OpenPanel())
Hotkey("<^>!>+" SCKeys["Home"], (*) => ToggleInputMode())
Hotkey("<^>!" SCKeys["Home"], (*) => ToggleFastKeys())


Hotkey("<#<!" SCKeys["Q"], (*) => LangSeparatedCall(
	() => QuotatizeSelection("Double"),
	() => QuotatizeSelection("France")))
Hotkey("<#<!<+" SCKeys["Q"], (*) => LangSeparatedCall(
	() => QuotatizeSelection("Single"),
	() => QuotatizeSelection("Paw")))
Hotkey("<#<!" SCKeys["NumpadEnter"], (*) => ParagraphizeSelection())
Hotkey("<#<!" SCKeys["NumpadDot"], (*) => GREPizeSelection())
Hotkey("<^>!" SCKeys["NumpadDot"], (*) => GREPizeSelection(True))

HotKey("<#<!" SCKeys["ArrUp"], (*) => ChangeScriptInput("sup"))
HotKey("<#<!" SCKeys["ArrDown"], (*) => ChangeScriptInput("sub"))
HotKey(">^" SCKeys["1"], (*) => ToggleLetterScript())

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
	xPos := screenWidth - windowWidth - 45
	yPos := screenHeight - windowHeight - 90

	DSLTabs := []
	DSLCols := { default: [], smelting: [] }

	for _, localeKey in ["diacritics", "spaces", "commands", "smelting", "fastkeys", "runica", "about", "useful", "changelog"] {
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

	Tab.UseTab(3)
	CommandsTree := DSLPadGUI.AddTreeView("x25 y43 w256 h510 -HScroll")

	CommandsTree.OnEvent("ItemSelect", (TV, Item) => TV_InsertCommandsDesc(TV, Item, GroupBoxCommands.text))

	CommandsInfoBox := {
		body: "x300 y35 w540 h450",
		bodyText: Map("ru", "Команда", "en", "Command"),
		text: "vCommandDescription x310 y65 w520 h400 BackgroundTrans",
	}

	GroupBoxCommands := {
		group: DSLPadGUI.Add("GroupBox", CommandsInfoBox.body, CommandsInfoBox.bodyText[LanguageCode]),
		text: DSLPadGUI.Add("Text", CommandsInfoBox.text),
	}

	Command_controls := CommandsTree.Add(ReadLocale("func_label_controls"))
	Command_gotopage := CommandsTree.Add(ReadLocale("func_label_gotopage"))
	Command_selgoto := CommandsTree.Add(ReadLocale("func_label_selgoto"))
	Command_copylist := CommandsTree.Add(ReadLocale("func_label_copylist"))
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
	Command_glagokeys := CommandsTree.Add(ReadLocale("func_label_glagokeys"))
	Command_inputtoggle := CommandsTree.Add(ReadLocale("func_label_inputtoggle"))
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

	DSLPadGUI.SetFont("s11")


	Tab.UseTab(4)


	DSLContent["BindList"].TabSmelter := []

	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Ligatures", , False, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Digraphs", , False, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Extended", , True, , True, ["lat_s_let_i_dotless"])
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Latin Accented", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Cyrillic Ligatures & Letters", , True, , True)
	InsertCharactersGroups(DSLContent["BindList"].TabSmelter, "Cyrillic Letters", , True, , True)
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


	Tab.UseTab(5)

	DSLContent["BindList"].TabFastKeys := []

	for groupName in [
		"Diacritics Fast Primary",
		"Special Fast Primary",
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
			: (groupName = "Latin Accented Primary") ? LeftAlt
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

	Tab.UseTab(6)

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
		"FastKeys", GetRandomByGroups(["Diacritics Fast Primary", "Special Fast Primary", "Latin Accented Primary", "Latin Accented Secondary", "Diacritics Fast Secondary", "Asian Quotes"]),
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

				TargetGroup[PreviewUnicode].Text := SubStr(value.unicode, 2, StrLen(value.unicode) - 2)

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


TV_InsertCommandsDesc(TV, Item, TargetTextBox) {
	if !Item {
		return
	}

	LabelValidator := [
		"func_label_controls",
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
		"func_label_glagokeys",
		"func_label_inputtoggle",
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
						if InputMode = "HTML" {
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
	RegisterHotKeys(FastKeysList)
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


HandleFastKey(CharacterNames*) {
	global FastKeysIsActive
	IsLayoutValid := CheckLayoutValid()

	if IsLayoutValid {
		Output := ""

		for _, Character in CharacterNames {
			GetCharacterSequence(Character)
		}

		GetCharacterSequence(CharacterName) {
			for characterEntry, value in Characters {
				entryName := RegExReplace(characterEntry, "^\S+\s+")

				if (entryName = CharacterName) {
					characterEntity := (HasProp(value, "entity")) ? value.entity : value.html
					characterLaTeX := (HasProp(value, "LaTeX")) ? value.LaTeX : ""

					if InputMode = "HTML" {
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
							for unicode in value.uniSequence {
								Output .= PasteUnicode(unicode)
							}
						} else {
							Output .= PasteUnicode(value.unicode)
						}
					}
				}
			}
		}
		SendText(Output)
	}
	return
}

CapsSeparatedKey(CapitalCharacter, SmallCharacter) {
	if (GetKeyState("CapsLock", "T")) {
		HandleFastKey(CapitalCharacter)
	} else {
		HandleFastKey(SmallCharacter)
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

LangSeparatedKey(LatinCharacter, CyrillicCharacter, UseCaps := False) {
	Character := (GetLayoutLocale() == CodeEn) ? LatinCharacter : CyrillicCharacter
	if UseCaps {
		HandleFastKey(CapsSeparatedKey(IsObject(Character) ? Character[1] : Character, IsObject(Character) ? Character[2] : Character))
	} else {
		HandleFastKey(IsObject(Character) ? Character[1] : Character)
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

FastKeysList :=
	[
		"<^<!" SCKeys["A"], (*) => HandleFastKey("acute"),
		"<^<+<!" SCKeys["A"], (*) => HandleFastKey("acute_double"),
		"<^<!" SCKeys["B"], (*) => HandleFastKey("breve"),
		"<^<+<!" SCKeys["B"], (*) => HandleFastKey("breve_inverted"),
		"<^<!" SCKeys["C"], (*) => HandleFastKey("circumflex"),
		"<^<+<!" SCKeys["C"], (*) => HandleFastKey("caron"),
		"<^<!" SCKeys["Comma"], (*) => HandleFastKey("comma_above"),
		"<^<+<!" SCKeys["Comma"], (*) => HandleFastKey("comma_below"),
		"<^<!" SCKeys["D"], (*) => HandleFastKey("dot_above"),
		"<^<+<!" SCKeys["D"], (*) => HandleFastKey("diaeresis"),
		"<^<!" SCKeys["F"], (*) => HandleFastKey("fermata"),
		"<^<!" SCKeys["G"], (*) => HandleFastKey("grave"),
		"<^<+<!" SCKeys["G"], (*) => HandleFastKey("grave_double"),
		"<^<!" SCKeys["H"], (*) => HandleFastKey("hook_above"),
		"<^<+<!" SCKeys["H"], (*) => HandleFastKey("horn"),
		"<^<!" SCKeys["M"], (*) => HandleFastKey("macron"),
		"<^<+<!" SCKeys["M"], (*) => HandleFastKey("macron_below"),
		"<^<!" SCKeys["N"], (*) => HandleFastKey("cyr_com_titlo"),
		"<^<!" SCKeys["O"], (*) => HandleFastKey("ogonek"),
		"<^<!<+" SCKeys["O"], (*) => HandleFastKey("ogonek_above"),
		"<^<!" SCKeys["R"], (*) => HandleFastKey("ring_above"),
		"<^<!<+" SCKeys["R"], (*) => HandleFastKey("ring_below"),
		"<^<!" SCKeys["V"], (*) => HandleFastKey("line_vertical"),
		"<^<!<+" SCKeys["V"], (*) => HandleFastKey("line_vertical_double"),
		"<^<!" SCKeys["T"], (*) => HandleFastKey("tilde"),
		"<^<!<+" SCKeys["T"], (*) => HandleFastKey("tilde_overlay"),
		"<^<!" SCKeys["S"], (*) => HandleFastKey("stroke_short"),
		"<^<!<+" SCKeys["S"], (*) => HandleFastKey("stroke_long"),
		"<^<!" SCKeys["Slash"], (*) => HandleFastKey("solidus_short"),
		"<^<!<+" SCKeys["Slash"], (*) => HandleFastKey("solidus_long"),
		"<^<!" SCKeys["X"], (*) => HandleFastKey("x_above"),
		"<^<!<+" SCKeys["X"], (*) => HandleFastKey("x_below"),
		"<^<!" SCKeys["Z"], (*) => HandleFastKey("zigzag_above"),
		;
		;"<^<!" SCKeys["Numpad1"], (*) => QuotatizeSelection("France"),
		;"<^<!" SCKeys["Numpad2"], (*) => QuotatizeSelection("Paw"),
		;"<^<!" SCKeys["Numpad3"], (*) => QuotatizeSelection("Double"),
		;"<^<!" SCKeys["Numpad4"], (*) => QuotatizeSelection("Single"),
		;
		"<^<!" SCKeys["Minus"], (*) => HandleFastKey("softhyphen"),
		"<^<!<+" SCKeys["Minus"], (*) => HandleFastKey("minus"),
		;
		"<^>!" SCKeys["Comma"], (*) => LangSeparatedKey("quote_left_double", "france_left"),
		"<^>!" SCKeys["Dot"], (*) => LangSeparatedKey("quote_right_double", "france_right"),
		"<^>!<+" SCKeys["Comma"], (*) => LangSeparatedKey("quote_left_single", "quote_low_9_double"),
		"<^>!<+" SCKeys["Dot"], (*) => LangSeparatedKey("quote_right_single", "quote_left_double"),
		"<^>!>+" SCKeys["Comma"], (*) => LangSeparatedKey("quote_low_9_double", "france_single_left"),
		"<^>!<+>+" SCKeys["Comma"], (*) => LangSeparatedKey("quote_low_9_single", ""),
		"<^>!>+" SCKeys["Dot"], (*) => LangSeparatedKey("quote_low_9_double_reversed", "france_single_right"),
		"<^>!>+" SCKeys["Tilde"], (*) => HandleFastKey("quote_right_single"),
		"<^>!>+" SCKeys["C"], (*) => HandleFastKey("cedilla"),
		;
		"<^>!>+" SCKeys["1"], (*) => CapsSeparatedKey("double_exclamation", "emsp"),
		"<^>!>+" SCKeys["2"], (*) => HandleFastKey("ensp"),
		"<^>!>+" SCKeys["3"], (*) => HandleFastKey("emsp13"),
		"<^>!>+" SCKeys["4"], (*) => HandleFastKey("emsp14"),
		"<^>!>+" SCKeys["5"], (*) => HandleFastKey("thinspace"),
		"<^>!>+" SCKeys["6"], (*) => HandleFastKey("emsp16"),
		"<^>!>+" SCKeys["7"], (*) => CapsSeparatedKey("double_question", "narrow_no_break_space"),
		"<^>!>+" SCKeys["8"], (*) => HandleFastKey("hairspace"),
		"<^>!>+" SCKeys["9"], (*) => HandleFastKey("punctuation_space"),
		"<^>!>+" SCKeys["0"], (*) => HandleFastKey("zero_width_space"),
		"<^>!>+" SCKeys["Minus"], (*) => HandleFastKey("word_joiner"),
		"<^>!>+" SCKeys["Equals"], (*) => HandleFastKey("figure_space"),
		"<^>!>+" SCKeys["Tab"], (*) => HandleFastKey("tabulation"),
		;
		"<^>!" SCKeys["Space"], (*) => HandleFastKey("no_break_space"),
		;
		"<^<!" SCKeys["Numpad0"], (*) => HandleFastKey("dotted_circle"),
		"<^>!" SCKeys["NumpadMult"], (*) => HandleFastKey("asterisk_two"),
		"<^>!>+" SCKeys["NumpadMult"], (*) => HandleFastKey("asterism"),
		"<^>!<+" SCKeys["NumpadMult"], (*) => HandleFastKey("asterisk_low"),
		"<^>!" SCKeys["NumpadDiv"], (*) => HandleFastKey("dagger"),
		"<^>!>+" SCKeys["NumpadDiv"], (*) => HandleFastKey("dagger_double"),
		;
		"<!" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_acute", "lat_s_let_a_acute"], ["", ""], True),
		"<^>!" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_breve", "lat_s_let_a_breve"], ["cyr_c_let_fita", "cyr_s_let_fita"], True),
		"<^>!<!" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_circumflex", "lat_s_let_a_circumflex"], ["", ""], True),
		"<^>!<!<+" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_caron", "lat_s_let_a_caron"], ["", ""], True),
		"<^>!<!>+" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_ogonek", "lat_s_let_a_ogonek"], ["", ""], True),
		"<^>!>+" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_macron", "lat_s_let_a_macron"], ["", ""], True),
		"<^>!<+" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_diaeresis", "lat_s_let_a_diaeresis"], ["", ""], True),
		"<^>!<+>+" SCKeys["A"], (*) => LangSeparatedKey(["lat_c_let_a_tilde", "lat_s_let_a_tilde"], ["", ""], True),
		;
		"<^>!" SCKeys["B"], (*) => LangSeparatedKey(["lat_c_let_b_stroke_short", "lat_s_let_b_stroke_short"], ["cyr_c_let_i", "cyr_s_let_i"], True),
		"<^>!<+" SCKeys["B"], (*) => LangSeparatedKey(["lat_c_let_b_hook", "lat_s_let_b_hook"], ["cyr_c_let_izhitsa", "cyr_s_let_izhitsa"], True),
		;
		"<!" SCKeys["C"], (*) => LangSeparatedKey(["lat_c_let_c_acute", "lat_s_let_c_acute"], ["", ""], True),
		"<^>!<!" SCKeys["C"], (*) => LangSeparatedKey(["lat_c_let_c_circumflex", "lat_s_let_c_circumflex"], ["", ""], True),
		"<^>!<!<+" SCKeys["C"], (*) => LangSeparatedKey(["lat_c_let_c_caron", "lat_s_let_c_caron"], ["", ""], True),
		"<^>!<!>+" SCKeys["C"], (*) => LangSeparatedKey(["lat_c_let_c_cedilla", "lat_s_let_c_cedilla"], ["", ""], True),
		;
		"<^>!" SCKeys["D"], (*) => LangSeparatedKey(["lat_c_let_d_stroke_short", "lat_s_let_d_stroke_short"], ["", ""], True),
		"<^>!<!" SCKeys["D"], (*) => LangSeparatedKey(["lat_c_let_d_eth", "lat_s_let_d_eth"], ["", ""], True),
		"<^>!<!>+" SCKeys["D"], (*) => LangSeparatedKey(["lat_c_let_d_cedilla", "lat_s_let_d_cedilla"], ["", ""], True),
		"<^>!<!<+" SCKeys["D"], (*) => LangSeparatedKey(["lat_c_let_d_caron", "lat_s_let_d_caron"], ["", ""], True),
		"<^>!<+>+" SCKeys["D"], (*) => LangSeparatedKey(["lat_c_let_d_circumflex_below", "lat_s_let_d_circumflex_below"], ["", ""], True),
		;
		"<^>!" SCKeys["S"], (*) => HandleFastKey("section"),
		"<^>!<+" SCKeys["S"], (*) => LangSeparatedKey(["lat_c_lig_eszett", "lat_s_lig_eszett"], ["", ""], True),
		;
		"<!" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_acute", "lat_s_let_e_acute"], ["", ""], True),
		"<^>!" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_breve", "lat_s_let_e_breve"], ["cyr_c_yus_big", "cyr_s_yus_big"], True),
		"<^>!<!" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_circumflex", "lat_s_let_e_circumflex"], ["", ""], True),
		"<^>!<!<+" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_caron", "lat_s_let_e_caron"], ["", ""], True),
		"<^>!<!>+" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_ogonek", "lat_s_let_e_ogonek"], ["", ""], True),
		"<^>!>+" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_macron", "lat_s_let_e_macron"], ["", ""], True),
		"<^>!<+" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_diaeresis", "lat_s_let_e_diaeresis"], ["", ""], True),
		"<^>!<+>+" SCKeys["E"], (*) => LangSeparatedKey(["lat_c_let_e_tilde", "lat_s_let_e_tilde"], ["", ""], True),
		;
		"<!" SCKeys["G"], (*) => LangSeparatedKey(["lat_c_let_g_acute", "lat_s_let_g_acute"], ["", ""], True),
		"<^>!" SCKeys["G"], (*) => LangSeparatedKey(["lat_c_let_g_breve", "lat_s_let_g_breve"], ["", ""], True),
		"<^>!<!" SCKeys["G"], (*) => LangSeparatedKey(["lat_c_let_g_circumflex", "lat_s_let_g_circumflex"], ["", ""], True),
		"<^>!<!<+" SCKeys["G"], (*) => LangSeparatedKey(["lat_c_let_g_caron", "lat_s_let_g_caron"], ["", ""], True),
		"<^>!<!>+" SCKeys["G"], (*) => LangSeparatedKey(["lat_c_let_g_cedilla", "lat_s_let_g_cedilla"], ["", ""], True),
		"<^>!>+" SCKeys["G"], (*) => LangSeparatedKey(["lat_c_let_g_macron", "lat_s_let_g_macron"], ["", ""], True),
		;
		"<^>!" SCKeys["H"], (*) => LangSeparatedKey(["lat_c_let_h_stroke_short", "lat_s_let_h_stroke_short"], ["", ""], True),
		"<^>!<!" SCKeys["H"], (*) => LangSeparatedKey(["lat_c_let_h_circumflex", "lat_s_let_h_circumflex"], ["", ""], True),
		"<^>!<!<+" SCKeys["H"], (*) => LangSeparatedKey(["lat_c_let_h_caron", "lat_s_let_h_caron"], ["", ""], True),
		"<^>!<!>+" SCKeys["H"], (*) => LangSeparatedKey(["lat_c_let_h_cedilla", "lat_s_let_h_cedilla"], ["", ""], True),
		"<^>!<+" SCKeys["H"], (*) => LangSeparatedKey(["lat_c_let_h_diaeresis", "lat_s_let_h_diaeresis"], ["", ""], True),
		;
		"<!" SCKeys["I"], (*) => LangSeparatedKey(["lat_c_let_i_acute", "lat_s_let_i_acute"], ["", ""], True),
		"<^>!" SCKeys["I"], (*) => LangSeparatedKey(["lat_c_let_i_breve", "lat_s_let_i_breve"], ["", ""], True),
		"<^>!<!" SCKeys["I"], (*) => LangSeparatedKey(["lat_c_let_i_circumflex", "lat_s_let_i_circumflex"], ["", ""], True),
		"<^>!<!<+" SCKeys["I"], (*) => LangSeparatedKey(["lat_c_let_i_caron", "lat_s_let_i_caron"], ["", ""], True),
		"<^>!<+" SCKeys["I"], (*) => LangSeparatedKey(["", ""], ["", ""], True),
		;
		"<^>!" SCKeys["J"], (*) => LangSeparatedKey(["", ""], ["cyr_c_let_omega", "cyr_s_let_omega"], True),
		;
		"<^>!" SCKeys["Q"], (*) => LangSeparatedKey(["", ""], ["cyr_c_let_yi", "cyr_s_let_yi"], True),
		"<^>!<!" SCKeys["Q"], (*) => LangSeparatedKey(["", ""], ["cyr_c_let_j", "cyr_s_let_j"], True),
		;
		"<^>!" SCKeys["Z"], (*) => LangSeparatedKey(["", ""], ["cyr_c_yus_little", "cyr_s_yus_little"], True),
		"<^>!<+" SCKeys["Z"], (*) => LangSeparatedKey(["", ""], ["cyr_c_a_iotified", "cyr_s_a_iotified"], True),
		"<^>!" SCKeys["T"], (*) => LangSeparatedKey(["", ""], ["cyr_c_let_yat", "cyr_s_let_yat"], True),
		"<^>!" SCKeys["Apostrophe"], (*) => LangSeparatedKey(["", ""], ["cyr_c_let_ukr_e", "cyr_s_let_ukr_e"], True),
		"<^>!" SCKeys["C"], (*) => CapsSeparatedKey("registered", "copyright"),
		"<^>!<+" SCKeys["C"], (*) => CapsSeparatedKey("servicemark", "trademark"),
		"<^>!" SCKeys["P"], (*) => HandleFastKey("prime_single"),
		"<^>!+" SCKeys["P"], (*) => HandleFastKey("prime_double"),
		"<^>!" SCKeys["Equals"], (*) => HandleFastKey("noequals"),
		"<^>!>+" SCKeys["Equals"], (*) => HandleFastKey("almostequals"),
		"<^>!<+" SCKeys["Equals"], (*) => HandleFastKey("plusminus"),
		"<^>!" SCKeys["Minus"], (*) => CapsSeparatedKey("three_emdash", "emdash"),
		"<^>!<+" SCKeys["Minus"], (*) => CapsSeparatedKey("two_emdash", "endash"),
		"<^>!<!" SCKeys["Minus"], (*) => CapsSeparatedKey("", "hyphen"),
		"<^>!<!<+" SCKeys["Minus"], (*) => CapsSeparatedKey("", "no_break_hyphen"),
		"<^>!<!>+" SCKeys["Minus"], (*) => CapsSeparatedKey("", "figure_dash"),
		"<^>!" SCKeys["Slash"], (*) => HandleFastKey("ellipsis"),
		"<^>!>+" SCKeys["Slash"], (*) => HandleFastKey("fraction_slash"),
		"<^>!" SCKeys["8"], (*) => HandleFastKey("multiplication"),
		"<^>!" SCKeys["Tilde"], (*) => HandleFastKey("bullet"),
		"<^>!<!" SCKeys["Tilde"], (*) => HandleFastKey("bullet_hyphen"),
		"<^>!<+" SCKeys["Tilde"], (*) => HandleFastKey("interpunct"),
		;
		"<^>!" SCKeys["ArrLeft"], (*) => HandleFastKey("arrow_left"),
		"<^>!" SCKeys["ArrRight"], (*) => HandleFastKey("arrow_right"),
		"<^>!" SCKeys["ArrUp"], (*) => HandleFastKey("arrow_up"),
		"<^>!" SCKeys["ArrDown"], (*) => HandleFastKey("arrow_down"),
		"<^>!<+" SCKeys["ArrLeft"], (*) => HandleFastKey("arrow_left_ushaped"),
		"<^>!<+" SCKeys["ArrRight"], (*) => HandleFastKey("arrow_right_ushaped"),
		"<^>!<+" SCKeys["ArrUp"], (*) => HandleFastKey("arrow_up_ushaped"),
		"<^>!<+" SCKeys["ArrDown"], (*) => HandleFastKey("arrow_down_ushaped"),
		"<^>!>+" SCKeys["ArrLeft"], (*) => HandleFastKey("arrow_left_circle"),
		"<^>!>+" SCKeys["ArrRight"], (*) => HandleFastKey("arrow_right_circle"),
		;
		"<^>!" SCKeys["Numpad4"], (*) => CapsSeparatedKey("asian_double_left_quote", "asian_left_quote"),
		"<^>!" SCKeys["Numpad6"], (*) => CapsSeparatedKey("asian_double_right_quote", "asian_right_quote"),
		"<^>!" SCKeys["Numpad8"], (*) => CapsSeparatedKey("asian_double_up_quote", "asian_up_quote"),
		"<^>!" SCKeys["Numpad2"], (*) => CapsSeparatedKey("asian_double_down_quote", "asian_down_quote"),
		"<^>!<!" SCKeys["Comma"], (*) => HandleFastKey("asian_double_left_title"),
		"<^>!<!<+" SCKeys["Comma"], (*) => HandleFastKey("asian_left_title"),
		"<^>!<!" SCKeys["Dot"], (*) => HandleFastKey("asian_double_right_title"),
		"<^>!<!<+" SCKeys["Dot"], (*) => HandleFastKey("asian_right_title"),
		"<^>!" SCKeys["0"], (*) => HandleFastKey("degree"),
		"<^>!<!" SCKeys["0"], (*) => HandleFastKey("infinity"),
		;
		"<^>!" SCKeys["Enter"], (*) => HandleFastKey("carriage_return", "new_line", "emsp"),
		"<^>!<+" SCKeys["Enter"], (*) => SendPaste("+{Enter}", (*) => HandleFastKey("emsp")),
		"<^>!>+" SCKeys["Enter"], (*) => HandleFastKey("carriage_return", "new_line", "emsp", "emsp"),
		;
		"<^>!" SCKeys["1"], (*) => HandleFastKey("inverted_exclamation"),
		"<^>!<+" SCKeys["1"], (*) => HandleFastKey("double_exclamation_question"),
		"<^>!<+>+" SCKeys["1"], (*) => CapsSeparatedKey("interrobang_inverted", "interrobang"),
		"<^>!" SCKeys["5"], (*) => HandleFastKey("permille"),
		"<^>!<+" SCKeys["5"], (*) => HandleFastKey("pertenthousand"),
		"<^>!" SCKeys["7"], (*) => HandleFastKey("inverted_question"),
		"<^>!<+" SCKeys["7"], (*) => HandleFastKey("double_question_exclamation"),
		"<^>!<!" SCKeys["7"], (*) => HandleFastKey("reversed_question"),
		;
		SCKeys["NumpadMult"], (*) => HandleFastKey("multiplication"),
		SCKeys["NumpadSub"], (*) => TimedKeyCombinations("NumpadSub", SCKeys["NumpadAdd"], (*) => HandleFastKey("plusminus"), (*) => HandleFastKey("minus")),
		SCKeys["NumpadAdd"], (*) => TimedKeyCombinations("NumpadAdd", SCKeys["NumpadSub"], (*) => EmptyFunc()),
		SCKeys["Equals"], (*) =>
			TimedKeyCombinations("Equals",
				[SCKeys["Slash"], SCKeys["Tilde"]],
				[(*) => HandleFastKey("noequals"), (*) => HandleFastKey("almostequals")],
			),
		SCKeys["Slash"], (*) => TimedKeyCombinations("Slash", SCKeys["Equals"], (*) => EmptyFunc()),
		SCKeys["Tilde"], (*) => TimedKeyCombinations("Tilde", SCKeys["Equals"], (*) => EmptyFunc()),
		;
		"RAlt", (*) => ProceedCompose(),
		"RCtrl", (*) => ProceedCombining(),
	]

RecoveryKey(KeySC, Shift := False) {
	KeySCCode := RegExReplace(SCKeys[KeySC], "SC")

	if Shift {
		Send("{Blind}+{sc" KeySCCode "}")
	} else {
		Send("{Blind}{sc" KeySCCode "}")
	}
}

EmptyFunc() {
	return
}

TimedKeyCombinations(StartKey, SecondKeys, Callbacks, DefaultCallback := False) {
	global IsCombinationPressed
	SCEntry := RegExReplace(StartKey, "^\+")
	IsShiftOn := RegExMatch(StartKey, "^\+")
	IsCombinationPressed := False

	if IsObject(SecondKeys) {
		for i, SecondKey in SecondKeys {
			if (GetKeyState(SecondKey, "P")) {
				Callbacks[i]()
				IsCombinationPressed := True
				SetTimer(ResetDefault, 0)
				return
			}
		}
	} else {
		if (GetKeyState(SecondKeys, "P")) {
			Callbacks()
			IsCombinationPressed := True
			SetTimer(ResetDefault, 0)
			return
		}
	}

	SetTimer(ResetDefault, -25)

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

RegisterHotKeys(FastKeysList)
;<^<!1:: HandleFastKey("{U+00B9}") ; Superscript 1
;<^<!2:: HandleFastKey("{U+00B2}") ; Superscript 2
;<^<!3:: HandleFastKey("{U+00B3}") ; Superscript 3
;<^<!4:: HandleFastKey("{U+2074}") ; Superscript 4
;<^<!5:: HandleFastKey("{U+2075}") ; Superscript 5
;<^<!6:: HandleFastKey("{U+2076}") ; Superscript 6
;<^<!7:: HandleFastKey("{U+2077}") ; Superscript 7
;<^<!8:: HandleFastKey("{U+2078}") ; Superscript 8
;<^<!9:: HandleFastKey("{U+2079}") ; Superscript 9
;<^<!0:: HandleFastKey("{U+2070}") ; Superscript 0
;<^<+<!1:: HandleFastKey("{U+2081}") ; Subscript 1
;<^<+<!2:: HandleFastKey("{U+2082}") ; Subscript 2
;<^<+<!3:: HandleFastKey("{U+2083}") ; Subscript 3
;<^<+<!4:: HandleFastKey("{U+2084}") ; Subscript 4
;<^<+<!5:: HandleFastKey("{U+2085}") ; Subscript 5
;<^<+<!6:: HandleFastKey("{U+2086}") ; Subscript 6
;<^<+<!7:: HandleFastKey("{U+2087}") ; Subscript 7
;<^<+<!8:: HandleFastKey("{U+2088}") ; Subscript 8
;<^<+<!9:: HandleFastKey("{U+2089}") ; Subscript 9
;<^<+<!0:: HandleFastKey("{U+2080}") ; Subscript 0
;<^<!e:: Send("{U+045E}") ; Cyrillic u with breve
;<^<+<!e:: Send("{U+040E}") ; Cyrillic cap u with breve
;<^<!w:: Send("{U+04EF}") ; Cyrillic u with macron
;<^<+<!w:: Send("{U+04EE}") ; Cyrillic cap u with macron
;<^<!q:: Send("{U+04E3}") ; Cyrillic i with macron
;<^<+<!q:: Send("{U+04E2}") ; Cyrillic cap i with macron
;<^<!x:: Send("{U+04AB}") ; CYRILLIC SMALL LETTER ES WITH DESCENDER
;<^<+<!x:: Send("{U+04AA}") ; CYRILLIC CAPITAL LETTER ES WITH DESCENDER
;>+<+g:: HandleFastKey(CharCodes.grapjoiner[1], True)
;<^<!NumpadDiv:: HandleFastKey(CharCodes.fractionslash[1], True)
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


HotKey("<#<+" SCKeys["PgUp"], (*) => SendCharToPy())
HotKey("<#<^<+" SCKeys["PgUp"], (*) => SendCharToPy("Copy"))

;ApplicationEnd
