Class App {

	static title := "DSL KeyPad"
	static status := "(αλφα)"
	static decodedTitle := "Diacritics-Spaces-Letters KeyPad"
	static version := [0, 1, 1, 0]
	static versionText := this.formatVersion(this.version.Clone())
	static winTitle := this.title " " this.status " — " this.versionText
	static tray := A_TrayMenu
	static indexIcos := Map()

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


	static gitBranches := Map(
		"Stable", "main",
		"Dev", "dev",
	)

	static __New() {
		this.git := {}
		this.git.repo := "https://raw.githubusercontent.com/DemerNkardaz/DSL-KeyPad/" this.gitBranches.Get("Stable") "/"
		this.git.src := this.git.repo "DSLKeyPad.ahk"
		this.git.files := this.git.repo "UtilityFiles/"

		this.internal := Map(
			"ico_dll", { repo: this.git.files "DSLKeyPad_App_Icons.dll", file: this.paths.bin "\DSLKeyPad_App_Icons.dll" },
			"exe", { repo: this.git.files "DSLKeyPad.exe", file: this.paths.dir "\DSLKeyPad.exe" },
		)

		for i, ico in ["app", "norse", "glagolitic", "turkic", "permic", "hungarian", "gothic", "ipa", "disabled", "math", "viet", "pinyin", "italic", "phoenician", "south_arabian", "north_arabian", "carian", "lycian", "tifinagh", "ugaritic", "persian"] {
			this.indexIcos.Set(ico, i)
		}

		this.Init()
	}

	static Init() {
		TraySetIcon(App.internal["ico_dll"].file, App.indexIcos["app"])
		for dir in ["lib", "bin", "user", "temp", "profile"] {
			if !DirExist(this.paths.%dir%)
				DirCreate(this.paths.%dir%)
		}

		if !FileExist(this.profileFile)
			IniWrite("default", this.profileFile, "data", "profile")
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

	static Update(timeOut := 0, forceUpdate := False) {

	}

	static CheckUpdate() {

	}

	static formatVersion(arr, length := 3) {
		for i, value in arr {
			if i > length
				break
			result .= (i > 1 ? "." : "") value
		}
		return result
	}
}

A_IconTip := App.winTitle