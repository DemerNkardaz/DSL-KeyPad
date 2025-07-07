Class TrayMenu {
	static tray := A_TrayMenu

	static __New() {
		this.SetTray()
		return
	}

	static SetTray() {
		A_IconTip := App.Title("+status+version")
		TraySetIcon(App.icoDLL, App.indexIcos["app"], True)
		OnMessage 0x404, Received_AHK_NOTIFYICON
		Received_AHK_NOTIFYICON(wParam, lParam, nMsg, hwnd) {
			if lParam = 0x202 {
				GetKeyState("Control", "P") && GetKeyState("Shift", "P") ? Scripter.SelectorPanel("Glyph Variations")
					: GetKeyState("Shift", "P") ? Scripter.SelectorPanel()
					: GetKeyState("Control", "P") ? Cfg.Editor()
					: GetKeyState("Alt", "P") ? Cfg.SubGUIs("Recipes")
					: Panel.Panel()
				return 1
			}
		}
	}

	static TrayLabels() {
		labels := {
			app: App.Title("+version"),
			update: Locale.ReadInject("update_available", [Update.availableVersion]),
			openPanel: Locale.Read("open_panel"),
			legend: Locale.Read("gui.panel.context_menu.legend"),
			mods: Locale.Read("gui.mods"),
			options: Locale.Read("gui.options"),
			changelogPanel: Locale.Read("gui.changelog"),
			scriptForms: Locale.Read("tray_menu_item_scripts"),
			glyphForms: Locale.Read("tray_menu_item_glyphs"),
			layouts: Locale.Read("tray_menu_item_layouts"),
			TSP_TELEX: Locale.Read("tray_menu_item_script_processor"),
			TSP_TiengViet: Locale.Read("telex_script_processor.labels.tieng_viet") "`t" RightAlt "F2",
			TSP_HanYuPinYin: Locale.Read("telex_script_processor.labels.hanyu_pinyin") "`t" RightAlt RightShift "F2",
			Scripter_AlternativeInput: Locale.Read("tray_menu_item_scripter_alternative_input"),
			;
			userRecipes: Locale.Read("tray_menu_item_user_recipes"),
			;
			search: Locale.Read("tray_menu_item_search") "`t" Window LeftAlt "F",
			unicode: Locale.Read("tray_menu_item_unicode"),
			altcode: Locale.Read("tray_menu_item_altcode"),
			forge: Locale.Read("tray_menu_item_forge"),
			folder: Locale.Read("tray_menu_item_folder"),
			notificationToggle: Locale.Read("tray_menu_item_notification_toggle"),
			reload: Locale.Read("tray_menu_item_reload"),
			pause: Locale.Read("tray_menu_item_pause"),
			enableBinds: Locale.Read("monitor.binds.enable") "`t" RightControl "F10",
			disableBinds: Locale.Read("monitor.binds.disable") "`t" RightControl "F10",
			exit: Locale.Read("tray_menu_item_exit"),
		}

		return labels
	}

	static SetTrayItems() {
		local labels := this.TrayLabels()

		this.tray.Delete()
		this.tray.Add(labels.app, (*) => Run(App.URL)), this.tray.SetIcon(labels.app, App.icoDLL, App.indexIcos["app"])

		if Update.available
			this.tray.Add(labels.update, (*) => Update.Check(True)), this.tray.SetIcon(labels.update, ImageRes, 176)

		this.tray.Add()
		this.tray.Add(labels.openPanel, (*) => Panel.Panel())
		this.tray.Add(labels.legend, (*) => ChrLegend())
		this.tray.Add(labels.mods, (*) => ModsGUI())
		this.tray.Add(labels.options, (*) => Cfg.Editor()), this.tray.SetIcon(labels.options, ImageRes, 63)
		this.tray.Add()
		this.tray.Add(labels.changelogPanel, (*) => Changelog.Panel())
		this.tray.Add()

		sciptsMenu := Menu()

		sciptsMenu.Add(labels.TSP_TELEX, (*) => []), sciptsMenu.Disable(labels.TSP_TELEX)

		TELEXModes := ScripterStore.storedData["TELEX"].Length // 2
		Loop TELEXModes {
			i := A_Index * 2 - 1
			dataName := ScripterStore.storedData["TELEX"][i]
			dataValue := ScripterStore.storedData["TELEX"][i + 1]
			if dataValue.Has("hidden") && dataValue["hidden"]
				continue
			this.AddScripterItems(sciptsMenu, dataName, dataValue, "TELEX")
		}

		sciptsMenu.Add()
		sciptsMenu.Add(labels.Scripter_AlternativeInput, (*) => []), sciptsMenu.Disable(labels.Scripter_AlternativeInput)

		scripterAlts := ScripterStore.storedData["Alternative Modes"].Length // 2
		Loop scripterAlts {
			i := A_Index * 2 - 1
			dataName := ScripterStore.storedData["Alternative Modes"][i]
			dataValue := ScripterStore.storedData["Alternative Modes"][i + 1]
			if dataValue.Has("hidden") && dataValue["hidden"]
				continue
			this.AddScripterItems(sciptsMenu, dataName, dataValue)
		}

		this.tray.Add(labels.scriptForms, sciptsMenu)

		glyphVariantsMenu := Menu()

		glyphVariantsMenu.Add(Locale.Read("gui.scripter.glyph_variations.gui_title"), (*) => GlyphsPanel.Panel())
		glyphVariantsMenu.Add()

		glyphVariants := ScripterStore.storedData["Glyph Variations"].Length // 2
		Loop glyphVariants {
			i := A_Index * 2 - 1
			dataName := ScripterStore.storedData["Glyph Variations"][i]
			dataValue := ScripterStore.storedData["Glyph Variations"][i + 1]
			if dataValue.Has("hidden") && dataValue["hidden"]
				continue
			this.AddScripterItems(glyphVariantsMenu, dataName, dataValue, "Glyph Variations")
		}

		this.tray.Add(labels.glyphForms, glyphVariantsMenu)

		layoutsMenu := Menu()
		layoutist := [KbdLayoutReg.storedData["latin"].Keys(), KbdLayoutReg.storedData["cyrillic"].Keys()]

		for i, layout in layoutist {
			if i > 1
				layoutsMenu.Add()
			for each in layout {
				layoutsMenu.Add(each, (*) => KbdBinder.SetLayout(each))
				layoutsMenu.SetIcon(each, App.icoDLL, App.indexIcos[i > 1 ? "cyrillic" : "latin"])
			}
		}

		this.tray.Add(labels.layouts, layoutsMenu)

		this.tray.Add()
		this.tray.Add(labels.userRecipes, (*) => Cfg.SubGUIs("Recipes")), this.tray.SetIcon(labels.userRecipes, ImageRes, 188)
		this.tray.Add()
		this.tray.Add(labels.search, (*) => Search()), this.tray.SetIcon(labels.search, ImageRes, 169)
		this.tray.Add(labels.unicode, (*) => CharacterInserter("Unicode").InputDialog(False)),
			this.tray.SetIcon(labels.unicode, Shell32, 225)
		this.tray.Add(labels.altcode, (*) => CharacterInserter("Altcode").InputDialog(False)),
			this.tray.SetIcon(labels.altcode, Shell32, 313)
		this.tray.Add(labels.forge, (*) => globalInstances.crafter.Start("InputBox")), this.tray.SetIcon(labels.forge, ImageRes, 151)
		this.tray.Add(labels.folder, (*) => Run(A_ScriptDir)), this.tray.SetIcon(labels.folder, ImageRes, 180)
		this.tray.Add()
		this.tray.Add(labels.reload, (*) => Reload()), this.tray.SetIcon(labels.reload, ImageRes, 229)
		; this.tray.Add(labels.pause, (*) => Suspend(-1))
		this.tray.Add()

		this.tray.Add(labels.disableBinds, toggleMonitor.Bind())
		this.tray.SetIcon(labels.disableBinds, App.icoDLL, App.indexIcos["disabled"])

		this.tray.Add()
		this.tray.Add(labels.exit, (*) => ExitApp()), this.tray.SetIcon(labels.exit, ImageRes, 085)

		HotKey(">^F10", (*) => toggleMonitor(KbdMonitor.Disabled("User") ? labels.enableBinds : labels.disableBinds, 0, this.tray), "On S")

		return

		toggleMonitor(itemName, itemPos, menuObj, *) {
			local isDisabled := KbdMonitor.Disabled("User")
			local toggled := KbdMonitor.Toggle(isDisabled = !False ? True : False, "User")

			if toggled {
				isDisabled := KbdMonitor.Disabled("User")
				menuObj.Rename(itemName, isDisabled ? labels.enableBinds : labels.disableBinds)
			}
		}
	}

	static EditTrayItem(label, iconSource := this.icoDLL, iconIndex := -1) {
	}

	static TrayIconSwitch() {
		KbdBinder.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)
		Keyboard.CheckLayout(&lang)

		if lang != "" && Language.supported[lang].parent != ""
			lang := Language.supported[lang].parent

		local iconCode := App.indexIcos["app"]
		local trayTitle := App.Title("+status+version") "`n" latinLayout "/" cyrillicLayout "/" hellenicLayout
		local iconFile := App.icoDLL
		local keyboardStatus := KbdMonitor.Disabled()
		if keyboardStatus is String
			keyboardStatus := StrLower(keyboardStatus)

		if KbdMonitor.Disabled() {
			iconCode := App.indexIcos["disabled"]
			trayTitle .= "`n" Locale.ReadInject("monitor.binds.disabled", [Locale.Read("monitor.binds.disabled.by_" keyboardStatus)])
		} else {
			local modeType := "Alternative Modes"
			local currentMode := Scripter.GetCurrentMode(modeType)
			local modeData := False

			if !currentMode {
				modeType := "TELEX"
				currentMode := Scripter.GetCurrentMode(modeType)
			}
			if !currentMode {
				modeType := "Glyph Variations"
				currentMode := Scripter.GetCurrentMode(modeType)
			}

			if currentMode
				modeData := Scripter.GetModeData(modeType, currentMode)

			if modeData {
				if !modeData.Has("hidden") || modeData.Has("hidden") && !modeData["hidden"] {
					local icons := modeData["icons"]
					local icon := icons.Length > 1 ? icons[lang = "ru-RU" ? 2 : 1] : icons[1]
					if icon ~= "file::" {
						iconFile := StrReplace(icon, "file::")
						iconCode := 1
					} else
						iconCode := App.indexIcos[icon]
					trayTitle .= "`n" Locale.Read("script_labels." modeData["locale"])
				}
			}
		}

		TraySetIcon(iconFile, iconCode, True)
		A_IconTip := RegExReplace(trayTitle, "\&", "&&&")
	}

	static AddScripterItems(menuElement, dataName, dataValue, mode := "Alternative Modes") {
		menuElement.Add(Locale.Read("script_labels." dataValue["locale"]), (*) => Scripter.ToggleSelectedOption(dataName, mode))
		if dataValue["icons"][1] ~= "file::" {
			menuElement.SetIcon(Locale.Read("script_labels." dataValue["locale"]), StrReplace(dataValue["icons"][1], "file::"))
		} else
			menuElement.SetIcon(Locale.Read("script_labels." dataValue["locale"]), App.icoDLL, App.indexIcos[dataValue["icons"][1]])
	}

}