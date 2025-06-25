Class ModsGUI {
	static title := ""

	__New() {
		if ModsGUI.title != "" && WinExist(ModsGUI.title)
			WinActivate(ModsGUI.title)
		else
			this.Constructor()
	}

	Constructor() {
		local title := App.Title() " — " Locale.Read("gui_mods")
		ModsGUI.title := title

		local w := 550
		local h := 600

		local xPos := (A_ScreenWidth - w) / 2
		local yPos := (A_ScreenHeight - h) / 2

		local lvW := w - 20
		local lvH := h - 20 - 34
		local lvX := (w - lvW) / 2
		local lvY := 10
		local lvCols := [lvW * 0.40, lvW * 0.10, lvW * 0.25, lvW * 0.24, 0, 0]

		local reloadBtnW := w - 20
		local reloadBtnH := 32
		local reloadBtnX := (w - reloadBtnW) / 2
		local reloadBtnY := h - 40

		local panel := Gui()
		panel.title := ModsGUI.title

		local listTitles := []
		for each in ["gui_mod_name", "gui_mod_version", "gui_mod_init", "gui_mod_author", "gui_mod_folder"]
			listTitles.Push(Locale.Read(each))
		listTitles.Push("")

		local modListLV := panel.AddListview(Format("vModsList w{} h{} x{} y{} Checked +NoSort -Multi", lvW, lvH, lvX, lvY), listTitles)
		modListLV.OnEvent("ItemCheck", (LV, Item, Checked) => ModsGUI.ToggleMod(&LV, &Item, &Checked))

		local reloadBtn := panel.AddButton(Format("vReloadBtn w{} h{} x{} y{}", reloadBtnW, reloadBtnH, reloadBtnX, reloadBtnY), Locale.Read("gui_mod_reload_button"))
		reloadBtn.OnEvent("Click", (*) => Reload())

		for i, each in lvCols
			modListLV.ModifyCol(i, lvCols[i])

		local mods := ModsInjector.Read()
		local modList := []

		for each in ["pre_init", "post_init"] {
			for key, value in mods[each].OwnProps() {
				local modData := ModsInjector.ReadModData(key)
				modList.Push([
					modData.status = 1 ? "Check" : "",
					modData.title,
					modData.version,
					modData.type = "pre_init" ? Locale.Read("gui_mod_init_on_start") : Locale.Read("gui_mod_init_at_end"),
					modData.author,
					modData.folder,
					modData.type,
				])
			}
		}

		for item in modList
			modListLV.Add(item*)

		panel.Show(Format("w{} h{} x{} y{}", w, h, xPos, yPos))
		return panel
	}

	static ToggleMod(&LV, &Item, &Checked) {
		if !item
			return

		local modFolder := LV.GetText(Item, 5)
		local modType := LV.GetText(Item, 6)

		if !FileExist(ModsInjector.registryINI)
			FileAppend("[pre_init]`n`n[post_init]`n", ModsInjector.registryINI, "UTF-16")
		IniWrite(Checked, ModsInjector.registryINI, modType, modFolder)
		return
	}
}