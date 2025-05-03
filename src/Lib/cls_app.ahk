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

	static paths := {
		dir: A_ScriptDir,
		lib: A_ScriptDir "\Lib",
		loc: A_ScriptDir "\Locale",
		bin: A_ScriptDir "\Bin",
		user: A_ScriptDir "\User",
		profile: A_ScriptDir "\User\profile-" this.profileName,
		temp: A_Temp "\DSLKeyPad",
	}

	static icoDLL := this.paths.bin "\DSLKeyPad_App_Icons.dll"
	static indexIcos := Map()


	static __New() {
		for i, ico in ["app", "norse", "glagolitic", "turkic", "permic", "hungarian", "gothic", "ipa", "disabled", "math", "viet", "pinyin", "italic", "phoenician", "south_arabian", "north_arabian", "carian", "lycian", "tifinagh", "ugaritic", "persian"] {
			this.indexIcos.Set(ico, i)
		}

		this.Init()
	}

	static Init() {
		TraySetIcon(App.icoDLL, App.indexIcos["app"])
		for key, dir in this.paths.OwnProps() {
			if !DirExist(dir) {
				DirCreate(dir)
			}
		}

		if !FileExist(this.profileFile)
			IniWrite("default", this.profileFile, "data", "profile")

		this.ReadProfiles()
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

	static Title(options := ["title"]) {
		static titleItems := [
			"decoded", "Diacritics-Spaces-Letters KeyPad",
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
		static version := ["major", 0, "minor", 1, "patch", 1, "hotfix", 2,
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

A_IconTip := App.Title("+status+version")