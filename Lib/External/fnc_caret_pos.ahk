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