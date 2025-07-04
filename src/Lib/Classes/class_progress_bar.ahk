Class PorgressBar {
	data := {
		maxCountOfEntries: 0,
		progressBarCurrent: 0,
		progressBarAddition: 0,
		progressPercent: 0,
		progressName: "",
		typeOfInit: "",
		progressBarTitle: Locale.Read("init")
	}

	__New(data := {}) {
		for k, v in data.OwnProps()
			this.data.%k% := v

		this.Constructor()
		return
	}

	Constructor() {
		this.GUI := Gui()
		this.GUI.title := this.data.progressBarTitle

		local windowWidth := 400
		local windowHeight := 80
		local xPos := (A_ScreenWidth - windowWidth) / 2
		local yPos := (A_ScreenHeight - windowHeight) / 2

		local prgBarW := windowWidth - 20
		local prgBarH := 24
		local prgBarY := (windowHeight - 32)
		local prgBarX := (windowWidth - prgBarW) / 2

		this.GUI.AddProgress("vInitProgressBar w" prgBarW " h" prgBarH " x" prgBarX " y" prgBarY, 0)

		this.GUI.AddText("vInitPorgressCounter w" prgBarW " h" 16 " x" prgBarX " y" (prgBarY - 40), Locale.ReadInject("init.elements", [0, this.data.maxCountOfEntries], "default"))
		this.GUI.AddText("vInitPorgressEntryName w" prgBarW " h" 16 " x" prgBarX " y" (prgBarY - 20), "")

		this.GUI.Show("w" windowWidth " h" windowHeight " x" xPos " y" yPos)
		return
	}

	SetProgressBarValue() {
		if WinExist(this.data.progressBarTitle) {
			this.GUI["InitPorgressCounter"].Text := Locale.ReadInject("init.elements", [this.data.progressBarCurrent, this.data.maxCountOfEntries], "default") (this.data.typeOfInit = "Custom" ? " : " Locale.Read("init.custom_recipes") : " : " Locale.Read("init.internal_library"))
			this.GUI["InitPorgressEntryName"].Text := Locale.ReadInject("init.entry", [this.data.progressName])

			this.GUI["InitProgressBar"].Value := this.data.progressPercent
			this.GUI.Show("NoActivate")
		}
		return
	}

	SetProgressBarZero() {
		this.data.progressBarAddition := 0
		this.data.maxCountOfEntries := 0
		this.data.progressBarCurrent := 0
		this.data.progressPercent := 0
		this.data.progressName := ""
		this.data.typeOfInit := ""
		return
	}

	Destroy() {
		if WinExist(this.data.progressBarTitle) {
			this.GUI.Destroy()
			this.SetProgressBarZero()
		}
		return
	}
}