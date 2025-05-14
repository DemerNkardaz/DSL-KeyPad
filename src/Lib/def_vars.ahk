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

LeftControl := Chr(0x2388)
RightControl := Chr(0x2318)
LeftShift := Chr(0x1F844)
RightShift := Chr(0x1F846)
LeftAlt := Chr(0x2387)
RightAlt := Chr(0x2384)
Window := Chr(0x229E)
CapsLock := Chr(0x2B9D)

ChracterMap := "C:\Windows\System32\charmap.exe"
ImageRes := "C:\Windows\System32\imageres.dll"
Shell32 := "C:\Windows\SysWOW64\shell32.dll"

regExChars := "\.-*+?^${}()[]|/"