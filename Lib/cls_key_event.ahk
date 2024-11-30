Class KeyEvent {

	__New(sequence) {

		KeyEvent.DoubleClick(sequence, &isDoubleClicked)


		if isDoubleClicked {
		}
	}


	static DoubleClick(scanCode, &returnValue := False) {
		if KeyWait(scanCode, "T.2")
			if KeyWait(scanCode, "D T.1")
				returnValue := True
		KeyWait(scanCode)
	}
}

;SetTimer((*) => Hotkey(LayoutsPresets["QWERTY"]["Space"], (K) => KeyEvent(K)), -8000)
