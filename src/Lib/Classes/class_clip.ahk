Class Clip {
	static stored := ""
	static timerActive := False
	static bridgeBind := this.ReleaseBridge.Bind(this)

	static Backup() {
		if this.stored = ""
			this.stored := ClipboardAll()
		return
	}

	static ReleaseBridge() {
		A_Clipboard := this.stored
		this.stored := ""
		this.timerActive := False
		return
	}

	static Release(timer := 300) {
		if this.timerActive
			SetTimer(this.bridgeBind, 0)

		if this.stored != "" {
			this.timerActive := True
			SetTimer(this.bridgeBind, -timer)
		}
		return
	}

	static CopySelected(&text := "", wait := 0.5, actions := "", keys := ["Shift", "Delete"]) {
		if GetKeyState("Alt", "P")
			Send("{Alt Up}")

		if InStr(actions, "Backup")
			this.Backup()
		A_Clipboard := ""

		Send("{" keys[1] " Down}{" keys[2] "}{" keys[1] " Up}")
		ClipWait(wait, 1)

		text := A_Clipboard
		A_Clipboard := ""

		if InStr(actions, "Release")
			this.Release()
		return
	}

	static Send(&text := "", endText := "", wait := 0.5, actions := "", keys := ["Shift", "Insert"]) {
		if GetKeyState("Alt", "P")
			Send("{Alt Up}")

		if InStr(actions, "Backup")
			this.Backup()

		if text != "" {
			A_Clipboard := text endText
			ClipWait(wait, 1)
			Send("{" keys[1] " Down}{" keys[2] "}{" keys[1] " Up}")
		}

		if InStr(actions, "Release")
			this.Release()

		return
	}
}