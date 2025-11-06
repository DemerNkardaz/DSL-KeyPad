Class ModsGUI {
	static title := ""

	selectedMod := ""

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

		local BtnW := 128
		local BtnH := 32
		local BtnY := h - 40

		local lvW := 400
		local lvH := (h - BtnH) - 21
		local lvX := 10
		local lvY := 10
		local lvCols := [lvW * 0.60, lvW * 0.14, lvW * 0.25, 0, 0]

		local infoGroupX := lvX + lvW + 10
		local infoGroupY := 10
		local infoGroupW := w - 10 - infoGroupX
		local infoGroupH := (h - BtnH) - 21

		local reloadBtnX := w - BtnW - 10
		local createModBtnX := lvX
		local optionsBtnX := infoGroupX

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

		local createModBtn := panel.AddButton(Format("vCreateModBtn w{} h{} x{} y{}", BtnW, BtnH, createModBtnX, BtnY), Locale.Read("gui.mods.creation.short"))
		createModBtn.OnEvent("Click", (*) => ModsGUI.ModCreation(&panel))

		local optionsBtn := panel.AddButton(Format("vOptionsBtn w{} h{} x{} y{}", BtnW, BtnH, optionsBtnX, BtnY), Locale.Read("gui.options"))
		optionsBtn.OnEvent("Click", (*) => ModTools.OptionsEditor(this.selectedMod, &panel))
		optionsBtn.Enabled := False

		local reloadBtn := panel.AddButton(Format("vReloadBtn w{} h{} x{} y{}", BtnW, BtnH, reloadBtnX, BtnY), Locale.Read("dictionary.reload"))
		reloadBtn.OnEvent("Click", (*) => Reload())

		for i, each in lvCols
			modListLV.ModifyCol(i, lvCols[i])

		local modsRead := ModsInjector.Read()
		local modsList := []

		local imgList := IL_Create()
		IL_Add(imgList, App.ICONS_DLL, App.indexIcos.Get("mods_flat"))

		local idx := 1
		for each in ["pre_init", "post_init"] {
			for key, value in modsRead[each].OwnProps() {
				local path := App.PATHS.MODS "\" key
				local modData := ModsInjector.ReadModManifest(key)
				local previewImg := this.GetPreview(&path, , True, "-16")

				if previewImg is String {
					idx++
					IL_Add(imgList, previewImg)
				}

				modsList.Push([
					(
						(modData["status"] = 1 ? "Check " : "")
						("Icon" (previewImg is String ? idx : 1))
					),
					modData.Has(languageCode) && modData[languageCode].Has("title") && modData[languageCode]["title"] != "" ? modData[languageCode]["title"] : modData["title"],
					modData["version"],
					modData["type"] = "pre_init" ? Locale.Read("init.before_start") : Locale.Read("init.after_start"),
					modData["folder"],
					modData["type"],
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

	SetInfo(&LV, &Item, &panel) {
		if !item
			return

		local languageCode := Language.Get()
		local modFolder := LV.GetText(Item, 4)
		local modType := LV.GetText(Item, 5)
		local modPath := App.PATHS.MODS "\" modFolder
		local optionsMap := ModsInjector.ReadModManifest(modFolder)
		local className := "Mod__" ModTools.FolderToClassName(modFolder)

		local title := optionsMap.Has(languageCode) && optionsMap[languageCode].Has("title") && optionsMap[languageCode]["title"] != "" ? optionsMap[languageCode]["title"] : optionsMap["title"]

		if title = ""
			title := modFolder

		local homepage := optionsMap.Has(languageCode) && optionsMap[languageCode].Has("homepage") && optionsMap[languageCode]["homepage"] != "" ? optionsMap[languageCode]["homepage"] : optionsMap["homepage"]
		homepage := homepage != "" ? Format('<a href="{}" target="_blank">{}</a>', homepage, homepage) : homepage

		local author := optionsMap.Has(languageCode) && optionsMap[languageCode].Has("author") && optionsMap[languageCode]["author"] != "" ? optionsMap[languageCode]["author"] : optionsMap["author"]

		if RegExMatch(author, "^(.*)@(https.*)$", &match)
			author := Format('<a href="{}" target="_blank">{}</a>', match[2], match[1])

		local description := optionsMap.Has(languageCode) && optionsMap[languageCode].Has("description") && optionsMap[languageCode]["description"] != "" ? optionsMap[languageCode]["description"] : optionsMap["description"]
		if description is Array
			description := description.ToString("")

		panel["PreviewImage"].Value := this.GetPreview(&modPath)
		panel["InfoGroup"].Text := title

		panel["VersionLabel"].Text := Locale.ReadInject("gui.mods.version", [optionsMap["version"]])
		panel["AuthorLabel"].Text := Locale.ReadInject("gui.mods.author", [author])
		panel["ModPage"].Text := Locale.ReadInject("gui.mods.homepage", [homepage])
		panel["Description"].Text := Locale.HandleString(description)

		panel["OptionsBtn"].Enabled := IsSet(%className%) && %className%.HasOwnProp("tools") && %className%.tools.HasOwnProp("config_editor") && %className%.tools.config_editor is Gui

		return this.selectedMod := modFolder
	}

	GetPreview(&modPath?, sizes := 96, returnArray := False, postfix := "") {
		if IsSet(modPath) {
			for suffix in (postfix ? [postfix, ""] : [""])
				Loop Files modPath "\preview" suffix ".*", "F"
					if A_LoopFileExt ~= "(ico|png|jpg)"
						return A_LoopFileFullPath
		}

		return returnArray ? [App.ICONS_DLL, App.indexIcos.Get("mods")] : "HBITMAP:*" LoadPicture(App.ICONS_DLL, "Icon" App.indexIcos.Get("mods") " " Format("w{} h{}", sizes, sizes))
	}

	Class ModCreation {
		title := ""

		defW := 500
		defH := 700
		w := this.defW
		h := this.defH

		fieldStep := 30
		fieldH := 24

		data := Map(
			"title", "My Mod",
			"folder", "My_Mod",
			"version", "1.0.0",
			"author", "Mod's author",
			"description", "My Mod's description",
			"type", "pre_init",
			"homepage", ""
		)

		changeFolderNameTriggered := False

		supportedLocales := Language.GetSupported()
		locales := this.supportedLocales.DraftMap(default := Map(
			"title", "",
			"version", "",
			"author", "",
			"description", "",
			"homepage", ""
		))

		currentLocale := False

		CalcSizes() {
			local fieldsCount := 7
			local minRequiredHeight := (fieldsCount - 1) * this.fieldStep + this.fieldH * 7 + 120

			if (this.h < minRequiredHeight) {
				this.h := minRequiredHeight
			}

			this.grpBoxW := this.w - 20
			this.grpBoxH := this.h - 20
			this.grpBoxX := (this.w - this.grpBoxW) / 2
			this.grpBoxY := (this.h - this.grpBoxH) / 2

			this.btnW := 100
			this.btnH := 32
			this.btnY := this.grpBoxY + this.grpBoxH - this.btnH - 10

			this.fieldW := this.grpBoxW - 20
			this.fieldX := this.grpBoxX + (this.grpBoxW - this.fieldW) / 2

			this.fieldTitleW := this.fieldW
			this.fieldTitleH := 14
			this.fieldTitleX := this.fieldX

			this.fieldTitleY := this.grpBoxY + 20
			this.fieldY := (this.fieldTitleY + this.fieldTitleH) + 6

		}

		btnX(multi := 1) => (this.grpBoxX + 10 + (this.btnW * (multi - 1)))

		incrementField(stepsCount := 1, extraHeight := 1, verticalExpand := False) {
			local x := this.fieldX
			local y := this.fieldY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
			local w := this.fieldW
			local h := (this.fieldH * (extraHeight)) + (verticalExpand ? (this.h - this.defH) : 0)
			local field := [x, y, w, h]

			local x := this.fieldTitleX
			local y := this.fieldTitleY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
			local w := this.fieldTitleW
			local h := this.fieldTitleH
			local fieldTitle := [x, y, w, h]
			return [field, fieldTitle]
		}

		Resize(modWindow, MinMax, W, H) {
			this.w := W
			this.h := H
			this.CalcSizes()

			modWindow["ModGrpBox"].Move(this.grpBoxX, this.grpBoxY, this.grpBoxW, this.grpBoxH)
			modWindow["TitleTitle"].Move(this.incrementField(1)[2]*)
			modWindow["TitleField"].Move(this.incrementField(1)[1]*)
			modWindow["FolderTitle"].Move(this.incrementField(2)[2]*)
			modWindow["FolderField"].Move(this.incrementField(2)[1]*)
			modWindow["VersionTitle"].Move(this.incrementField(3)[2]*)
			modWindow["VersionField"].Move(this.incrementField(3)[1]*)
			modWindow["AuthorTitle"].Move(this.incrementField(4)[2]*)
			modWindow["AuthorField"].Move(this.incrementField(4)[1]*)
			modWindow["TypeTitle"].Move(this.incrementField(5)[2]*)
			modWindow["TypeField"].Move(this.incrementField(5)[1]*)
			modWindow["HomepageTitle"].Move(this.incrementField(6)[2]*)
			modWindow["HomepageField"].Move(this.incrementField(6)[1]*)
			modWindow["DescriptionTitle"].Move(this.incrementField(7)[2]*)
			modWindow["DescriptionField"].Move(this.incrementField(7, 6 * 12, True)[1]*)
			modWindow["CreateBtn"].Move(this.btnX(1), this.btnY, this.btnW, this.btnH)
			modWindow["CancelBtn"].Move(this.btnX(2), this.btnY, this.btnW, this.btnH)

			return
		}

		__New(&parentGUI?) {
			this.CalcSizes()

			if IsSet(parentGUI) {
				parentGUI.GetPos(&parentX, &parentY, &parentW, &parentH)

				this.xPos := parentX + ((parentW - this.w) / 2)
				this.yPos := parentY + ((parentH - this.h) / 2)
			} else {
				this.xPos := (A_ScreenWidth - this.w) / 2
				this.yPos := (A_ScreenHeight - this.h) / 2
			}

			this.Show()
			return
		}

		Constructor() {
			this.title := App.Title("+status+version") " — " Locale.Read("gui.mods.creation")

			local modWindow := Gui()
			modWindow.Title := this.title

			local grpBox := modWindow.AddGroupBox(Format("vModGrpBox x{} y{} w{} h{}", this.grpBoxX, this.grpBoxY, this.grpBoxW, this.grpBoxH), Locale.Read("gui.mods.creation"))

			local titleTitle := modWindow.AddText(Format("vTitleTitle x{} y{} w{} h{}", this.incrementField(1)[2]*), "* " Locale.Read("dictionary.title"))
			local titleField := modWindow.AddEdit(Format("vTitleField x{} y{} w{} h{} -Multi", this.incrementField(1)[1]*), this.data.Get("title"))

			local folderTitle := modWindow.AddText(Format("vFolderTitle x{} y{} w{} h{}", this.incrementField(2)[2]*), "* " Locale.Read("dictionary.folder"))
			local folderField := modWindow.AddEdit(Format("vFolderField x{} y{} w{} h{} -Multi", this.incrementField(2)[1]*), this.data.Get("folder"))

			local versionTitle := modWindow.AddText(Format("vVersionTitle x{} y{} w{} h{}", this.incrementField(3)[2]*), "* " Locale.Read("dictionary.version"))
			local versionField := modWindow.AddEdit(Format("vVersionField x{} y{} w{} h{} -Multi", this.incrementField(3)[1]*), this.data.Get("version"))

			local authorTitle := modWindow.AddText(Format("vAuthorTitle x{} y{} w{} h{} ", this.incrementField(4)[2]*), Locale.Read("dictionary.author"))
			local authorField := modWindow.AddEdit(Format("vAuthorField x{} y{} w{} h{} -Multi", this.incrementField(4)[1]*), this.data.Get("author"))

			local typeFieldOptions := Map(
				"pre_init", Locale.Read("gui.mods.pre_init"),
				"post_init", Locale.Read("gui.mods.post_init")
			)

			local typeTitle := modWindow.AddText(Format("vTypeTitle x{} y{} w{} h{}", this.incrementField(5)[2]*), Locale.Read("dictionary.initialization"))
			local typeField := modWindow.AddDropDownList(Format("vTypeField x{} y{} w{} h{}", this.incrementField(5)[1]*) Format(" R{}", typeFieldOptions.Count), typeFieldOptions.Values())
			PostMessage(0x0153, -1, 15, typeField)
			typeField.Choose(typeFieldOptions.Get(this.data.Get("type")))

			local homepageTitle := modWindow.AddText(Format("vHomepageTitle x{} y{} w{} h{}", this.incrementField(6)[2]*), Locale.Read("dictionary.homepage"))
			local homepageField := modWindow.AddEdit(Format("vHomepageField x{} y{} w{} h{} -Multi", this.incrementField(6)[1]*), this.data.Get("homepage"))

			local descriptionTitle := modWindow.AddText(Format("vDescriptionTitle x{} y{} w{} h{}", this.incrementField(7)[2]*), Locale.Read("dictionary.description"))
			local descriptionField := modWindow.AddEdit(Format("vDescriptionField x{} y{} w{} h{} Multi WantTab", this.incrementField(7, 10)[1]*), JSONExt.EscapeString(this.data.Get("description"), True))

			titleField.OnEvent("Change", (*) => SetTitleField(titleField.Value))
			folderField.OnEvent("Change", (*) => SetFolderField(folderField.Value))
			versionField.OnEvent("Change", (*) => this.data.Set("version", versionField.Value))
			authorField.OnEvent("Change", (*) => this.data.Set("author", authorField.Value))
			typeField.OnEvent("Change", (*) => SetTypeField(typeField.Text))
			homepageField.OnEvent("Change", (*) => this.data.Set("homepage", homepageField.Value))
			descriptionField.OnEvent("Change", (*) => this.data.Set("description", descriptionField.Value))

			local createButton := modWindow.AddButton(Format("vCreateBtn x{} y{} w{} h{}", this.btnX(1), this.btnY, this.btnW, this.btnH), Locale.Read("dictionary.create"))
			local cancelButton := modWindow.AddButton(Format("vCancelBtn x{} y{} w{} h{}", this.btnX(2), this.btnY, this.btnW, this.btnH), Locale.Read("dictionary.cancel"))

			createButton.OnEvent("Click", (*) => this.ModCreate())
			cancelButton.OnEvent("Click", (*) => WinExist(this.title) && WinClose(this.title))

			return modWindow

			SetTitleField(value) {
				this.data.Set("title", titleField.Value)
				local folder := ModTools.FolderToClassName(titleField.Value)

				if !this.changeFolderNameTriggered {
					folderField.Value := folder
					this.data.Set("folder", folder)
				}

				return
			}

			SetFolderField(value) {
				this.changeFolderNameTriggered := True
				this.data.Set("folder", folderField.Value)
				return
			}

			SetTypeField(displayValue) {
				for key, displayText in typeFieldOptions {
					if (displayText = displayValue) {
						this.data.Set("type", key)
						break
					}
				}
				return
			}
		}

		Show() {
			if this.title != "" && WinExist(this.title)
				WinActivate(this.title)
			else {
				this.GUI := this.Constructor()
				this.GUI.Show(Format("x{} y{} w{} h{}", this.xPos, this.yPos, this.w, this.h))
			}

			return
		}

		ModCreate() {
			if this.data.Get("title") = "" || this.data.Get("folder") = "" || this.data.Get("version") = "" {
				local fieldToBeFocused := this.data.Get("title") = "" ? "TitleField" : this.data.Get("folder") = "" ? "FolderField" : "VersionField"
				this.GUI[fieldToBeFocused].Focus()
			} else if ModTools.CreateMod(this.data, this.locales) {
				WinExist(this.title) && WinClose(this.title)
				ModTools.OpenModFolder(this.data)
			}
			return
		}
	}
}