Class App {
	static tray := A_TrayMenu

	static profileFile := A_ScriptDir "\User\Profile.ini"
	static profileName := IniRead(this.profileFile, "data", "profile", "default")
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
		for dir in ["lib", "bin", "user", "temp", "profile"] {
			if !DirExist(this.paths.%dir%)
				DirCreate(this.paths.%dir%)
		}

		if !FileExist(this.profileFile)
			IniWrite("default", this.profileFile, "data", "profile")
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
		static version := ["major", 0, "minor", 1, "patch", 1, "hotfix", 0, "postfix", "-alpha-testing"]

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