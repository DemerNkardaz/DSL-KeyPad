Class App {
	static PID := WinGetPID(A_ScriptHwnd)

	static PROFILE_FILE := A_ScriptDir "\User\Profile.ini"
	static PROFILE_NAME := IniRead(this.PROFILE_FILE, "data", "profile", "default")
	static REPOSITORY := "DemerNkardaz/DSL-KeyPad"
	static URL := "https://github.com/" this.REPOSITORY
	static GITHUB_PAGE := "https://demernkardaz.github.io/DSL-KeyPad-Docs"
	static API := "https://api.github.com/repos/" this.REPOSITORY
	static GIT_USER_CONTENT := "https://raw.githubusercontent.com/" this.REPOSITORY
	static BRANCH := Map("main", this.URL "/tree/main", "dev", this.URL "/tree/dev")
	static REFS_HEADS := Map("main", this.GIT_USER_CONTENT "/refs/heads/main", "dev", this.GIT_USER_CONTENT "/refs/heads/dev")
	static DESKTOP_INI := A_ScriptDir "\desktop.ini"

	static PATHS := {
		DIR: A_ScriptDir,
		DATA: A_ScriptDir "\Data",
		DUMPS: A_ScriptDir "\Data\Dumps",
		LIB: A_ScriptDir "\Lib",
		SIDE_PROCESSES: A_ScriptDir "\Lib\SideProcesses",
		PWSH: A_ScriptDir "\Lib\powershell",
		LOC: A_ScriptDir "\Locale",
		BIN: A_ScriptDir "\Bin",
		USER: A_ScriptDir "\User",
		MODS: A_ScriptDir "\Mods",
		PROFILE: A_ScriptDir "\User\profile-" this.PROFILE_NAME,
		LAYOUTS: A_ScriptDir "\User\profile-" this.PROFILE_NAME "\CustomLayouts",
		BINDS: A_ScriptDir "\User\profile-" this.PROFILE_NAME "\CustomBindings",
		TEMP: A_Temp "\DSLKeyPad",
	}

	static ICONS_DLL := this.PATHS.BIN "\DSLKeyPad_App_Icons.dll"

	static indexIcos := Map()
	static profileList := ["default"]

	static __New() {
		this.IconsIndexing()
		this.Init()
		return
	}

	static IconsIndexing() {
		local labelsData := JSON.LoadFile(this.PATHS.DATA "\icon_labels_index.json", "UTF-8")
		for i, ico in labelsData {
			this.indexIcos.Set(ico, i)
		}
		return
	}

	static Init() {
		for key, dir in this.PATHS.OwnProps()
			if !DirExist(dir)
				DirCreate(dir)

		if !FileExist(this.PROFILE_FILE)
			IniWrite("default", this.PROFILE_FILE, "data", "profile")

		Run(Format('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "{}" -IniPath {}',
			this.PATHS.PWSH "\set_folder_data.ps1", this.DESKTOP_INI), , "Hide")

		this.ReadProfiles()

		TooltipPresets.Select()
		return
	}

	static DeleteINI() {
		if FileExist(this.DESKTOP_INI) {
			RunWait('cmd.exe /c attrib -s -h "' this.DESKTOP_INI '"')
			FileDelete(this.DESKTOP_INI)
		}
		return
	}

	static ReadProfiles() {
		Loop Files App.PATHS.USER "\profile-*", "D" {
			name := A_LoopFileName
			if name != "profile-default" {
				this.profileList.Push(RegExReplace(name, "profile-", ""))
			}
		}
		return
	}

	static SetProfile(profile) {
		profile := profile = Locale.Read("profile.default") ? "default" : profile
		IniWrite(profile, this.PROFILE_FILE, "data", "profile")
		Reload
	}

	static GetProfile() {
		profile := IniRead(this.PROFILE_FILE, "data", "profile", "default")
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
		static version := ["major", 0, "minor", 1, "patch", 7, "hotfix", 4,
			"postfix", "", "pre-release", False]

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
