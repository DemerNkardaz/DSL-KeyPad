Class App {

	static title := "DSL KeyPad (αλφα)"
	static version := [0, 1, 1, 0]
	static versionText := this.formatVersion(this.version)

	static git := {
		repo: "https://raw.githubusercontent.com/DemerNkardaz/DSL-KeyPad/main/",
		;: "https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/DSLKeyPad.ahk",
	}

	static paths := {
		dir: A_ScriptDir,
		lib: A_ScriptDir "\Lib",
		ufile: A_ScriptDir "\UtilityFiles",
		temp: A_Temp "\DSLKeyPad",
	}

	static usr := {
		sid: PowerShell_UserSID(),
	}


	static __New() {
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
		if !DirExist(this.paths.temp)
			DirCreate(this.paths.temp)

	}

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