Class Update {
	static releasesJson := "https://data.jsdelivr.com/v1/package/gh/DemerNkardaz/DSL-KeyPad"
	static available := False
	static availableVersion := ""

	static __New() {
		this.Check()
	}

	static Repair() {
		this.Get(True)
	}
	static Get(force := False) {
		if !this.available && !force {
			MsgBox(Locale.Read("update_absent"))
			return
		} else {
			if force {
				acceptBox := MsgBox(Locale.Read("update_repair"), App.title " — " Locale.Read("update_repair_title"), "YesNo")
				if acceptBox = "No" || acceptBox = "Cancel" {
					return
				}
				this.CompareVersions(force)
			}
			this.Download()
		}
	}

	static Bundler() {
		Dev.SetSrc()
		try {
			exitCode := RunWait(Format(
				'powershell -ExecutionPolicy Bypass -NoProfile -File "{}" "{}" "{}"',
				App.paths.lib "\powershell\pack_bundle.ps1", A_ScriptDir, App.Ver("+hotfix+postfix")
			), , "Show")

			if exitCode != 0 {
				MsgBox(Util.StrVarsInject(Locale.Read("bundle_creation_failed_pshell"), exitCode))
			}

		} catch {
			MsgBox(Locale.Read("bundle_creation_failed"))
		}
	}

	static Download(version := this.availableVersion) {
		try {
			zipSource := "https://github.com/DemerNkardaz/DSL-KeyPad/releases/download/" version "/DSL-KeyPad-" version ".zip"
			downloadPath := App.paths.temp "\DSL-KeyPad.zip"

			Download(zipSource, downloadPath)

			exitCode := RunWait(Format(
				'powershell -ExecutionPolicy Bypass -NoProfile -File "{}" -ZipPath "{}" -Destination "{}" -Version "{}"',
				App.paths.lib "\powershell\update_supporter.ps1", downloadPath, App.paths.dir, version
			), , "Show")

			if exitCode != 0 {
				MsgBox(Util.StrVarsInject(Locale.Read("update_failed_pshell"), exitCode))
			} else {
				MsgBox(Util.StrVarsInject(Locale.Read("update_successful"), App.Ver("+hotfix+postfix"), version))
				Reload
			}
		} catch {
			MsgBox(Locale.Read("update_failed"))
		}
	}

	static Check() {
		this.versions := this.ChekVersions()
		this.CompareVersions()
	}

	static CompareVersions(force := False) {
		currentVersion := App.Ver("+hotfix", [])
		for version in this.versions {
			if RegExMatch(version, "(\d+)\.(\d+)\.(\d+)\.(\d+)", &digitMatches) {
				shouldUpdate := False
				if !force {
					Loop 4 {
						v := Number(digitMatches[A_Index])
						if v > currentVersion[A_Index] {
							shouldUpdate := True
							break
						} else if v < currentVersion[A_Index] {
							break
						}
					}
				} else {
					match := True
					Loop 4 {
						v := Number(digitMatches[A_Index])
						if v != currentVersion[A_Index] {
							match := False
							break
						}
					}
					if match {
						shouldUpdate := True
					}
				}

				if shouldUpdate {
					this.available := True
					this.availableVersion := version
					break
				}
			}
		}
	}

	static ChekVersions() {
		whr := ComObject("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", this.releasesJson, true)

		try {
			whr.Send()
			whr.WaitForResponse()
		}
		catch {
			MsgBox Locale.Read("update_check_failed")
			return []
		}

		if (whr.Status != 200) {
			MsgBox Locale.Read("update_check_failed")
			return []
		}

		responseText := whr.ResponseText
		versions := this.ExtractVersionsArray(responseText)
		return versions
	}

	static ExtractVersionsArray(jsonStr) {
		if (!jsonStr)
			return []

		startPattern := '"versions":\s*\['
		endPattern := '\]'

		startPos := RegExMatch(jsonStr, startPattern)
		if (!startPos)
			return []

		endPos := RegExMatch(jsonStr, endPattern, , startPos + StrLen('"versions": ['))
		if (!endPos)
			return []

		arrayContent := SubStr(jsonStr, startPos + 14, endPos - startPos - 14)

		versions := []

		vMatch := ""
		versionRegex := '"([^"]*)"'
		searchPos := 1

		while (RegExMatch(arrayContent, versionRegex, &vMatch, searchPos)) {
			if (vMatch[1] != "") {
				versions.Push(vMatch[1])
			}
			searchPos := vMatch.Pos + vMatch.Len
		}

		return versions
	}
}