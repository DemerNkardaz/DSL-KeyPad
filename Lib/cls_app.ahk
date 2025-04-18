Class App {

	static title := "DSL KeyPad"
	static status := "(αλφα)"
	static decodedTitle := "Diacritics-Spaces-Letters KeyPad"
	static version := [0, 1, 1, 0]
	static versionText := this.formatVersion(this.version)
	static winTitle := this.title " " this.status " — " this.versionText
	static tray := A_TrayMenu

	static paths := {
		dir: A_ScriptDir,
		lib: A_ScriptDir "\Lib",
		loc: A_ScriptDir "\Locale",
		ufile: A_ScriptDir "\UtilityFiles",
		user: A_ScriptDir "\User",
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
			"locales", { repo: this.git.files "DSLKeyPad.locales.ini", file: this.paths.dir "\UtilityFiles\DSLKeyPad.locales.ini" },
			"app_ico", { repo: this.git.files "DSLKeyPad.app.ico", file: this.paths.dir "\UtilityFiles\DSLKeyPad.app.ico" },
			"ico_dll", { repo: this.git.files "DSLKeyPad_App_Icons.dll", file: this.paths.dir "\UtilityFiles\DSLKeyPad_App_Icons.dll" },
			"HTML_entities", { repo: this.git.files "entities_list.txt", file: this.paths.dir "\UtilityFiles\entities_list.txt" },
			"alt_codes", { repo: this.git.files "alt_codes_list.txt", file: this.paths.dir "\UtilityFiles\alt_codes_list.txt" },
			"exe", { repo: this.git.files "DSLKeyPad.exe", file: this.paths.dir "\DSLKeyPad.exe" },
		)

		this.icos := Map(
			"app", [this.internal["ico_dll"].file, 0],
		)

		this.Init()
	}

	static Init() {
		for dir in ["lib", "ufile", "user", "temp"] {
			if !DirExist(this.paths.%dir%)
				DirCreate(this.paths.%dir%)
		}

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