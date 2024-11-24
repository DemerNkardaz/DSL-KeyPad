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