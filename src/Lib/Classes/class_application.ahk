Class App {
	static PID := WinGetPID(A_ScriptHwnd)

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
		data: A_ScriptDir "\Data",
		dumps: A_ScriptDir "\Data\Dumps",
		lib: A_ScriptDir "\Lib",
		sidProc: A_ScriptDir "\Lib\SideProcesses",
		pwsh: A_ScriptDir "\Lib\powershell",
		loc: A_ScriptDir "\Locale",
		bin: A_ScriptDir "\Bin",
		user: A_ScriptDir "\User",
		profile: A_ScriptDir "\User\profile-" this.profileName,
		layouts: A_ScriptDir "\User\profile-" this.profileName "\CustomLayouts",
		binds: A_ScriptDir "\User\profile-" this.profileName "\CustomBindings",
		temp: A_Temp "\DSLKeyPad",
	}

	static icoDLL := this.paths.bin "\DSLKeyPad_App_Icons.dll"
	static indexIcos := Map()


	static __New() {
		for i, ico in [
			"app", "germanic", "glagolitic", "turkic", "permic", "hungarian", "gothic", "ipa", "disabled", "math", "tieng_viet", "hanyu_pinyin", "italic", "phoenician", "south_arabian", "north_arabian", "carian", "lycian", "tifinagh", "ugaritic", "persian", "hellenic", "latin", "cyrillic",
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
			"deseret",
			"shavian",
			"blank",
			"support",
			"reload",
			"exit",
			"settings",
			"about",
			"forge",
			"my_recipes",
			"legend",
			"mods",
			"update",
		] {
			this.indexIcos.Set(ico, i)
		}
		this.Init()
		return
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
		return
	}

	static DeleteINI() {
		if FileExist(this.desktopINI) {
			RunWait('cmd.exe /c attrib -s -h "' this.desktopINI '"')
			FileDelete(this.desktopINI)
		}
		return
	}

	static ReadProfiles() {
		Loop Files App.paths.user "\profile-*", "D" {
			name := A_LoopFileName
			if name != "profile-default" {
				this.profileList.Push(RegExReplace(name, "profile-", ""))
			}
		}
		return
	}

	static SetProfile(profile) {
		profile := profile = Locale.Read("profile.default") ? "default" : profile
		IniWrite(profile, this.profileFile, "data", "profile")
		Reload
	}

	static GetProfile() {
		profile := IniRead(this.profileFile, "data", "profile", "default")
		return profile = "default" ? Locale.Read("profile.default") : profile
	}

	static Title(options := ["title"]) {
		static titleItems := [
			"decoded", "Diacritic-Spaces-Letters KeyPad",
			"title", "DSL KeyPad",
			"status", "α",
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
		static version := ["major", 0, "minor", 1, "patch", 3, "hotfix", 2,
			"postfix", "", "pre-release", True]

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
Event.Trigger("Application Class", "Initialized")