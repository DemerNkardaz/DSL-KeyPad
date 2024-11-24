Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })

_ArrayMaxIndex(this) {
	indexes := 0
	for i, v in this {
		indexes++
	}

	return indexes
}

ClipSendProcessed(callback, noSendRestore := False, isClipReverted := True, untilRevert := 300) {
	if isClipReverted
		prevClip := ClipboardAll()

	A_Clipboard := ""
	ClipWait(1)
	Send("{Shift Down}{Delete}{Shift Up}")
	ClipWait(1)

	copyBackup := A_Clipboard

	if A_Clipboard != "" {
		A_Clipboard := callback(A_Clipboard)
	}

	if !noSendRestore {
		Send("{Shift Down}{Insert}{Shift Up}")

		if isClipReverted
			SetTimer(() => A_Clipboard := prevClip, -untilRevert)
	} else {
		SendText(copyBackup)
	}
}