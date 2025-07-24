Class ModsGUI {
	static title := ""

	__New() {
		if ModsGUI.title != "" && WinExist(ModsGUI.title)
			WinActivate(ModsGUI.title)
		else
			this.Constructor()
	}

	Constructor() {
		local languageCode := Language.Get()

		local title := App.Title("+status+version") " — " Locale.Read("dictionary.mods")
		ModsGUI.title := title

		local w := 900
		local h := 600

		local xPos := (A_ScreenWidth - w) / 2
		local yPos := (A_ScreenHeight - h) / 2

		local lvW := 400
		local lvH := h - 20
		local lvX := 10
		local lvY := 10
		local lvCols := [lvW * 0.60, lvW * 0.14, lvW * 0.25, 0, 0]

		local reloadBtnW := 128
		local reloadBtnH := 32
		local reloadBtnX := w - reloadBtnW - 10
		local reloadBtnY := h - 40

		local infoGroupX := lvX + lvW + 10
		local infoGroupY := 10
		local infoGroupW := w - 10 - infoGroupX
		local infoGroupH := (h - reloadBtnH) - 21

		local previewImageW := 96
		local previewImageH := 96
		local previewImageX := infoGroupX + 10
		local previewImageY := infoGroupY + 35

		local versionX := previewImageX + previewImageW + 10
		local versionY := previewImageY + 10
		local versionW := infoGroupX + infoGroupW - versionX - 10
		local versionH := 20

		local authorX := versionX
		local authorY := versionY + versionH + 8
		local authorW := versionW
		local authorH := versionH

		local modPageX := versionX
		local modPageY := authorY + authorH + 8
		local modPageW := versionW
		local modPageH := versionH * 2.7

		local descriptionX := previewImageX
		local descriptionY := previewImageY + previewImageH + 25
		local descriptionW := infoGroupX + infoGroupW - descriptionX - 10
		local descriptionH := infoGroupY + infoGroupH - descriptionY - 10

		local panel := Gui()
		panel.title := ModsGUI.title

		local listTitles := []
		for each in ["dictionary.title", "dictionary.version", "init", "dictionary.folder"]
			listTitles.Push(Locale.Read(each))
		listTitles.Push("")

		local modListLV := panel.AddListview(Format("vModsList w{} h{} x{} y{} Checked +NoSort -Multi", lvW, lvH, lvX, lvY), listTitles)
		modListLV.OnEvent("ItemCheck", (LV, Item, Checked) => this.ToggleMod(&LV, &Item, &Checked))
		modListLV.OnEvent("ItemFocus", (LV, Item) => this.SetInfo(&LV, &Item, &panel))

		local reloadBtn := panel.AddButton(Format("vReloadBtn w{} h{} x{} y{}", reloadBtnW, reloadBtnH, reloadBtnX, reloadBtnY), Locale.Read("dictionary.reload"))
		reloadBtn.OnEvent("Click", (*) => Reload())

		for i, each in lvCols
			modListLV.ModifyCol(i, lvCols[i])

		local modsRead := ModsInjector.Read()
		local modsList := []

		local imgList := IL_Create()
		IL_Add(imgList, App.icoDLL, App.indexIcos.Get("blank"))

		local idx := 1
		for each in ["pre_init", "post_init"] {
			for key, value in modsRead[each].OwnProps() {
				local path := mods[key]
				local modData := this.ReadData(&path, &key)
				local previewImg := this.GetPreview(&path, , True)

				if previewImg is String {
					idx++
					IL_Add(imgList, previewImg)
				}

				modsList.Push([
					(
						(modData["options"]["status"] = 1 ? "Check " : "")
						("Icon" (previewImg is String ? idx : 1))
					),
					modData[modData.Has(languageCode) ? languageCode : "options"]["title"],
					modData["options"]["version"],
					modData["options"]["type"] = "pre_init" ? Locale.Read("init.before_start") : Locale.Read("init.after_start"),
					modData["options"]["folder"],
					modData["options"]["type"],
				])
			}
		}

		modListLV.SetImageList(imgList)

		for item in modsList
			modListLV.Add(item*)

		local infoGroup := panel.AddGroupBox(Format("vInfoGroup w{} h{} x{} y{}", infoGroupW, infoGroupH, infoGroupX, infoGroupY))
		infoGroup.SetFont("s14 c333333")

		local previewImage := panel.AddPicture(Format("vPreviewImage w{} h{} x{} y{}", previewImageW, previewImageH, previewImageX, previewImageY), this.GetPreview())

		local versionLabel := panel.AddText(Format("vVersionLabel w{} h{} x{} y{}", versionW, versionH, versionX, versionY), "")
		versionLabel.SetFont("s12 c333333")
		local authorLabel := panel.AddLink(Format("vAuthorLabel w{} h{} x{} y{}", authorW, authorH, authorX, authorY), "")
		authorLabel.SetFont("s12 c333333")
		local modPage := panel.AddLink(Format("vModPage w{} h{} x{} y{} +Wrap", modPageW, modPageH, modPageX, modPageY), "")
		modPage.SetFont("s10 c333333")
		local descritpion := panel.AddText(Format("vDescription w{} h{} x{} y{} +Wrap", descriptionW, descriptionH, descriptionX, descriptionY), "")
		descritpion.SetFont("s11 c333333")

		panel.Show(Format("w{} h{} x{} y{}", w, h, xPos, yPos))

		if modListLV.GetCount() > 0 {
			modListLV.Modify(1, "+Focus +Select")
			local item := modListLV.GetNext(0)
			this.SetInfo(&modListLV, &item, &panel)
		}
		return panel
	}

	ToggleMod(&LV, &Item, &Checked) {
		if !item
			return

		local modFolder := LV.GetText(Item, 4)
		local modType := LV.GetText(Item, 5)

		if !FileExist(ModsInjector.registryINI)
			FileAppend("[pre_init]`n`n[post_init]`n", ModsInjector.registryINI, "UTF-16")
		IniWrite(Checked, ModsInjector.registryINI, modType, modFolder)
		return
	}

	ReadData(&modPath, &modFolder) {
		local output := Map(
			"options", Map(
				"title", "",
				"version", "",
				"type", "",
				"author", "",
				"url", "",
				"description", "",
				"folder", modFolder,
			)
		)

		local options := Util.INIToMap(modPath "\options")

		for section, keys in options {
			if !output.Has(section)
				output.Set(section, Map())
			for key, value in keys
				output[section].Set(key, value)
		}

		output["options"].Set("status", IniRead(ModsInjector.registryINI, output["options"]["type"], modFolder, 1))

		return output
	}

	SetInfo(&LV, &Item, &panel) {
		if !item
			return

		local languageCode := Language.Get()
		local modFolder := LV.GetText(Item, 4)
		local modType := LV.GetText(Item, 5)
		local modPath := mods[modFolder]
		local optionsMap := this.ReadData(&modPath, &modFolder)

		local title := optionsMap[(
			optionsMap.Has(languageCode)
			&& optionsMap[languageCode].Has("title")
				? languageCode : "options"
		)]["title"]

		if title = ""
			title := modFolder

		local url := optionsMap["options"]["url"] != "" ? Format('<a href="{}" target="_blank">{}</a>', optionsMap["options"]["url"], optionsMap["options"]["url"]) : ""

		local author := optionsMap[(optionsMap.Has(languageCode) && optionsMap[languageCode].Has("author") ? languageCode : "options")]["author"]

		if RegExMatch(author, "^(.*)@(https.*)$", &match)
			author := Format('<a href="{}" target="_blank">{}</a>', match[2], match[1])

		local description := optionsMap[(optionsMap.Has(languageCode) && optionsMap[languageCode].Has("description") ? languageCode : "options")]["description"]

		panel["PreviewImage"].Value := this.GetPreview(&modPath)
		panel["InfoGroup"].Text := title

		panel["VersionLabel"].Text := Locale.ReadInject("gui.mods.version", [optionsMap["options"]["version"]])
		panel["AuthorLabel"].Text := Locale.ReadInject("gui.mods.author", [author])
		panel["ModPage"].Text := Locale.ReadInject("gui.mods.homepage", [url])
		panel["Description"].Text := Locale.HandleString(description)
	}

	GetPreview(&modPath?, sizes := 96, returnArray := False) {
		if IsSet(modPath)
			Loop Files modPath "\preview.*", "F"
				if A_LoopFileExt ~= "(ico|png|jpg|jpeg)"
					return A_LoopFileFullPath

		return returnArray ? [App.icoDLL, App.indexIcos.Get("blank")] : "HBITMAP:*" LoadPicture(App.icoDLL, "Icon" App.indexIcos.Get("blank") " " Format("w{} h{}", sizes, sizes))
	}
}