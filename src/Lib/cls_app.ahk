Class App {
	static tray := A_TrayMenu

	static profileFile := A_ScriptDir "\User\Profile.ini"
	static profileName := IniRead(this.profileFile, "data", "profile", "default")
	static profileList := ["default"]
	static repository := "DemerNkardaz/DSL-KeyPad"
	static URL := "https://github.com/" this.repository
	static API := "https://api.github.com/repos/" this.repository
	static gitUserContent := "https://raw.githubusercontent.com/" this.repository
	static branch := Map("main", this.URL "/tree/main", "dev", this.URL "/tree/dev")
	static refsHeads := Map("main", this.gitUserContent "/refs/heads/main", "dev", this.gitUserContent "/refs/heads/dev")
	static desktopINI := A_ScriptDir "\desktop.ini"

	static paths := {
		dir: A_ScriptDir,
		lib: A_ScriptDir "\Lib",
		pwsh: A_ScriptDir "\Lib\powershell",
		loc: A_ScriptDir "\Locale",
		bin: A_ScriptDir "\Bin",
		user: A_ScriptDir "\User",
		profile: A_ScriptDir "\User\profile-" this.profileName,
		temp: A_Temp "\DSLKeyPad",
	}

	static icoDLL := this.paths.bin "\DSLKeyPad_App_Icons.dll"
	static indexIcos := Map()


	static __New() {
		for i, ico in [
			"app", "germanic", "glagolitic", "turkic", "permic", "hungarian", "gothic", "ipa", "disabled", "math", "vietNam", "pinYin", "italic", "phoenician", "south_arabian", "north_arabian", "carian", "lycian", "tifinagh", "ugaritic", "persian", "hellenic", "latin", "cyrillic",
			"glyph_combining",
			"glyph_superscript",
			"glyph_subscript",
			"glyph_italic",
			"glyph_bold",
			"glyph_italic_bold",
			"glyph_sans_serif",
			"glyph_sans_serif_italic",
			"glyph_sans_serif_bold",
			"glyph_sans_serif_italic_bold",
			"glyph_monospace",
			"glyph_small_capital",
			"glyph_fraktur",
			"glyph_fraktur_bold",
			"glyph_script",
			"glyph_script_bold",
			"glyph_double_struck",
			"glyph_double_struck_italic",
			"glyph_uncombined",
			"glyph_fullwidth",
			"lydian",
			"sidetic",
			"cypriot_syllabary",
		] {
			this.indexIcos.Set(ico, i)
		}
		this.Init()
	}

	static Init() {
		for key, dir in this.paths.OwnProps() {
			if !DirExist(dir) {
				DirCreate(dir)
			}
		}

		if !FileExist(this.profileFile)
			IniWrite("default", this.profileFile, "data", "profile")

		Run(Format('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "{}" -IniPath {}',
			this.paths.pwsh "\set_folder_data.ps1", this.desktopINI), , "Hide")

		this.ReadProfiles()
		this.SetTray()
	}

	static DeleteDINI() {
		if FileExist(this.desktopINI) {
			RunWait('cmd.exe /c attrib -s -h "' this.desktopINI '"')
			FileDelete(this.desktopINI)
		}
	}

	static ReadProfiles() {
		Loop Files App.paths.user "\profile-*", "D" {
			name := A_LoopFileName
			if name != "profile-default" {
				this.profileList.Push(RegExReplace(name, "profile-", ""))
			}
		}
	}

	static SetProfile(profile) {
		profile := profile = Locale.Read("profile_default") ? "default" : profile
		IniWrite(profile, this.profileFile, "data", "profile")
		Reload
	}

	static GetProfile() {
		profile := IniRead(this.profileFile, "data", "profile", "default")
		return profile = "default" ? Locale.Read("profile_default") : profile
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
			options: Locale.Read("gui_options"),
			scriptForms: Locale.Read("tray_menu_item_scripts"),
			glyphForms: Locale.Read("tray_menu_item_glyphs"),
			layouts: Locale.Read("tray_menu_item_layouts"),
			IPS_TELEX: Locale.Read("tray_menu_item_script_processor"),
			IPS_TiengViet: Locale.Read("tray_menu_item_script_processor_vietnamese") "`t" RightAlt "F2",
			IPS_HanYuPinYin: Locale.Read("tray_menu_item_script_processor_chinese_romanization") "`t" RightAlt RightShift "F2",
			IPS_AdvancedMode: Locale.Read("tray_menu_item_script_processor_advanced_mode"),
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
			enableBinds: Locale.Read("tray_menu_item_enable_binds") "`t" RightControl "F10",
			disableBinds: Locale.Read("tray_menu_item_disable_binds") "`t" RightControl "F10",
			exit: Locale.Read("tray_menu_item_exit"),
		}

		return labels
	}

	static SetTrayItems() {
		labels := this.TrayLabels()

		App.tray.Delete()
		App.tray.Add(labels.app, (*) => Run(App.URL)), App.tray.SetIcon(labels.app, App.icoDLL, App.indexIcos["app"])

		if Update.available
			App.tray.Add(labels.update, (*) => Update.Check(True)), App.tray.SetIcon(labels.update, ImageRes, 176)

		App.tray.Add()
		App.tray.Add(labels.openPanel, (*) => Panel.Panel())
		App.tray.Add(labels.options, (*) => Cfg.Editor()), App.tray.SetIcon(labels.options, ImageRes, 63)
		App.tray.Add()

		sciptsMenu := Menu()

		sciptsMenu.Add(labels.IPS_TELEX, (*) => []), sciptsMenu.Disable(labels.IPS_TELEX)
		sciptsMenu.Add(labels.IPS_AdvancedMode, (*) => Cfg.SwitchSet(["True", "False"], "Advanced_Mode", "ScriptProcessor", "bind"))
		sciptsMenu.Add(labels.IPS_TiengViet, (*) => InputScriptProcessor()),
			sciptsMenu.SetIcon(labels.IPS_TiengViet, App.icoDLL, App.indexIcos["vietNam"])
		sciptsMenu.Add(labels.IPS_HanYuPinYin, (*) => InputScriptProcessor("pinYin")),
			sciptsMenu.SetIcon(labels.IPS_HanYuPinYin, App.icoDLL, App.indexIcos["pinYin"])
		sciptsMenu.Add()
		sciptsMenu.Add(labels.Scripter_AlternativeInput, (*) => []), sciptsMenu.Disable(labels.Scripter_AlternativeInput)

		scripterAlts := Scripter.data["Alternative Modes"].Length // 2
		Loop scripterAlts {
			i := A_Index * 2 - 1
			dataName := Scripter.data["Alternative Modes"][i]
			dataValue := Scripter.data["Alternative Modes"][i + 1]
			AddScripts(dataName, dataValue)
		}

		AddScripts(dataName, dataValue) {
			sciptsMenu.Add(Locale.Read(dataValue.locale), (*) => Scripter.OptionSelect(dataName))
			sciptsMenu.SetIcon(Locale.Read(dataValue.locale), App.icoDLL, App.indexIcos[dataValue.icons[1]])
		}

		App.tray.Add(labels.scriptForms, sciptsMenu)

		glyphVariantsMenu := Menu()

		glyphVariantsMenu.Add(Locale.Read("gui_scripter_glyph_variation_panel"), (*) => GlyphsPanel.Panel())
		glyphVariantsMenu.Add()

		glyphVariants := Scripter.data["Glyph Variations"].Length // 2
		Loop glyphVariants {
			i := A_Index * 2 - 1
			dataName := Scripter.data["Glyph Variations"][i]
			dataValue := Scripter.data["Glyph Variations"][i + 1]
			AddGlyphVariatns(dataName, dataValue)
		}

		AddGlyphVariatns(dataName, dataValue) {
			glyphVariantsMenu.Add(Locale.Read(dataValue.locale), (*) => Scripter.OptionSelect(dataName, "Glyph Variations"))
			glyphVariantsMenu.SetIcon(Locale.Read(dataValue.locale), App.icoDLL, App.indexIcos[dataValue.icons[1]])
		}

		App.tray.Add(labels.glyphForms, glyphVariantsMenu)

		layoutsMenu := Menu()
		layoutist := [KeyboardBinder.layouts.latin.Keys(), KeyboardBinder.layouts.cyrillic.Keys()]

		for i, layout in layoutist {
			if i > 1
				layoutsMenu.Add()
			for each in layout {
				layoutsMenu.Add(each, (*) => this.KeyboardBinder.SetLayout(each))
				layoutsMenu.SetIcon(each, App.icoDLL, App.indexIcos[i > 1 ? "cyrillic" : "latin"])
			}
		}

		App.tray.Add(labels.layouts, layoutsMenu)

		App.tray.Add()
		App.tray.Add(labels.userRecipes, (*) => Cfg.SubGUIs("Recipes")), App.tray.SetIcon(labels.userRecipes, ImageRes, 188)
		App.tray.Add()
		App.tray.Add(labels.search, (*) => ChrLib.SearchPrompt().send()), App.tray.SetIcon(labels.search, ImageRes, 169)
		App.tray.Add(labels.unicode, (*) => CharacterInserter("Unicode").InputDialog(False)),
			App.tray.SetIcon(labels.unicode, Shell32, 225)
		App.tray.Add(labels.altcode, (*) => CharacterInserter("Altcode").InputDialog(False)),
			App.tray.SetIcon(labels.altcode, Shell32, 313)
		App.tray.Add(labels.forge, (*) => ChrCrafter()), App.tray.SetIcon(labels.forge, ImageRes, 151)
		App.tray.Add(labels.folder, (*) => Run(A_ScriptDir)), App.tray.SetIcon(labels.folder, ImageRes, 180)
		App.tray.Add()
		App.tray.Add(labels.reload, (*) => Reload()), App.tray.SetIcon(labels.reload, ImageRes, 229)
		; App.tray.Add(labels.pause, (*) => Suspend(-1))
		App.tray.Add()

		if KeyboardBinder.disabledByMonitor || KeyboardBinder.disabledByUser {
			App.tray.Add(labels.enableBinds (*) => KeyboardBinder.MonitorToggler(KeyboardBinder.disabledByUser = !False ? True : False, "User", "Monitor"))
			App.tray.SetIcon(labels.enableBinds, App.icoDLL, App.indexIcos["disabled"])
		} else {

			App.tray.Add(labels.disableBinds, (*) => KeyboardBinder.MonitorToggler(KeyboardBinder.disabledByUser = !False ? True : False, "User", "Monitor"))
			App.tray.SetIcon(labels.disableBinds, App.icoDLL, App.indexIcos["disabled"])
		}

		App.tray.Add()
		App.tray.Add(labels.exit, (*) => ExitApp()), App.tray.SetIcon(labels.exit, ImageRes, 085)


	}

	static EditTrayItem(label, iconSource := this.icoDLL, iconIndex := -1) {
	}

	static Title(options := ["title"]) {
		static titleItems := [
			"decoded", "Diacritic-Spaces-Letters KeyPad",
			"title", "DSL KeyPad",
			"status", "(αλφα)",
			"version", "— " this.Ver(),
		]

		output := ""

		if options is String {
			fields := StrSplit(options, "+")
			options := ["title"]

			for each in fields {
				options.Push(each)
			}
		}

		for i, _ in titleItems {
			if Mod(i, 2) = 1 {
				len := options.Length + 1
				if options.HasValue(titleItems[i]) {
					output .= titleItems[i + 1] ((i <= len) ? " " : "")
				}
			}
		}

		return output
	}

	static Ver(includedFields := ["major", "minor", "patch"], output := "") {
		static version := ["major", 0, "minor", 1, "patch", 2, "hotfix", 2,
			"postfix", "-alpha-testing", "pre-release", True]

		if includedFields is String {
			fields := StrSplit(includedFields, "+")
			includedFields := ["major", "minor", "patch"]

			for each in fields {
				includedFields.Push(each)
			}
		}

		if output is String {
			len := includedFields.Length - (includedFields.HasValue("postfix") ? 1 : 0)
			for i, _ in version {
				if Mod(i, 2) = 1 {
					if includedFields.HasValue(version[i]) {
						output .= version[i + 1] ((i <= len) ? "." : "")
					}
				}
			}
		} else if output is Array {
			for i, _ in version {
				if Mod(i, 2) = 1 {
					if includedFields.HasValue(version[i]) {
						output.Push(version[i + 1])
					}
				}
			}
		}

		return output
	}

	; static UUID() {
	; For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" A_ComputerName "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
	; return obj.UUID
	; }

	; static SID() {
	; username := A_UserName
	; query := "SELECT SID FROM Win32_UserAccount WHERE Name='" username "' AND Domain='" A_ComputerName "'"
	; for obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" A_ComputerName "\root\cimv2").ExecQuery(query)
	; return obj.SID
	; return ""
	; }

}