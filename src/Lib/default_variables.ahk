controlTypes := Map(
	50000, "Button",
	50001, "Calendar",
	50002, "CheckBox",
	50003, "ComboBox",
	50004, "Edit",
	50005, "Hyperlink",
	50006, "Image",
	50007, "ListItem",
	50008, "List",
	50009, "Menu",
	50010, "MenuBar",
	50011, "MenuItem",
	50012, "ProgressBar",
	50013, "RadioButton",
	50014, "ScrollBar",
	50015, "Slider",
	50016, "Spinner",
	50017, "StatusBar",
	50018, "Tab",
	50019, "TabItem",
	50020, "Text",
	50021, "ToolBar",
	50022, "ToolTip",
	50023, "Tree",
	50024, "TreeItem",
	50025, "Custom",
	50026, "Group",
	50027, "Thumb",
	50028, "DataGrid",
	50029, "DataItem",
	50030, "Document",
	50031, "SplitButton",
	50032, "Window",
	50033, "Pane",
	50034, "Header",
	50035, "HeaderItem",
	50036, "Table",
	50037, "TitleBar",
	50038, "Separator",
	50039, "SemanticZoom",
	50040, "AppBar"
)

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

LeftControl := Chr(0x21D0)
RightControl := Chr(0x21D2)
LeftShift := Chr(0x1F844)
RightShift := Chr(0x1F846)
LeftAlt := Chr(0x25C1)
RightAlt := Chr(0x25B7)
Window := Chr(0x229E)
CapsLock := Chr(0x2B9D)

ChracterMap := "C:\Windows\System32\charmap.exe"
ImageRes := "C:\Windows\System32\imageres.dll"
Shell32 := "C:\Windows\SysWOW64\shell32.dll"

regExChars := "\.-*+?^${}()[]|/"

latinRange := "\x{0041}-\x{005A}\x{0061}-\x{007A}\x{0080}-\x{00FF}\x{0100}-\x{017F}\x{0180}-\x{024F}\x{A720}-\x{A7FF}\x{AB30}-\x{AB6F}"
cyrillicRange := "\x{0400}-\x{04FF}\x{0500}-\x{052F}\x{A640}-\x{A69F}\x{1C80}-\x{1C8F}"
hellenicRange := "\x{0370}-\x{03FF}\x{1F00}-\x{1FFF}"

enExt := "\x{00DE}\x{00FE}\x{01F7}\x{01BF}\x{A768}\x{A769}\x{01B7}\x{0292}\x{021C}\x{021D}\x{1E9E}\x{00DF}\x{0194}\x{0263}"
ruExt := "\x{0406}\x{0456}\x{0462}\x{0463}\x{046A}\x{046B}\x{0466}\x{0467}\x{0470}\x{0471}\x{046E}\x{046F}\x{0460}\x{0461}\x{0472}\x{0473}\x{051C}\x{051D}\x{051A}\x{051B}\x{A65E}\x{A65F}"

mods := Map()

globalInstances := { MainGUI: {}, crafter: {} }

dataDir := A_ScriptDir "\Data"
dataDumps := A_ScriptDir "\Data\Dumps"
if !DirExist(dataDumps)
	DirCreate(dataDumps)
dataTemp := A_Temp "\DSLKeyPad"

characters := {
	data: ArrayMerge(JSONExt.BulkLoad(App.paths.data "\characters", "UTF-8"), GeneratedEntries()),
	supplementaryData: JSON.LoadFile(App.paths.data "\supplementary.json", "UTF-8"),
	blocksData: JSON.LoadFile(App.paths.data "\character_blocks.json", "UTF-8"),
}