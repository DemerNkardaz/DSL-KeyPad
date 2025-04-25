Class Update {
	static releasesJson := "https://data.jsdelivr.com/v1/package/gh/DemerNkardaz/DSL-KeyPad"
	static available := False
	static availableVersion := ""

	static __New() {
		this.versions := this.ChekVersions()
		this.CompareVersions()

	}

	static DownloadLatestZip() {
		if !this.available
			return

		zipSource := "https://github.com/DemerNkardaz/DSL-KeyPad/releases/download/" this.availableVersion "/DSL-KeyPad-" this.availableVersion ".zip"
		downloadPath := App.paths.temp "\DSL-KeyPad.zip"
		destinationPath := App.paths.dir "\UnzipUpdateTesting"
		if !DirExist(destinationPath)
			DirCreate(destinationPath)

		Download(zipSource, downloadPath)
		powershellSupporter := A_ScriptDir "\Lib\powershell\update_supporter.ps1"

		exitCode := RunWait('powershell -ExecutionPolicy Bypass -NoProfile -File "' powershellSupporter '" "' downloadPath '" "' destinationPath '"', , "Hide")

		if exitCode != 0 {
			MsgBox("An error occurred during the update")
		}


	}

	static CompareVersions() {
		for version in this.versions {
			if RegExMatch(version, "(\d+)\.(\d+)\.(\d+)\.(\d+)", &digitMatches) {
				shouldUpdate := False
				Loop 4 {
					v := Number(digitMatches[A_Index])
					if v > App.version[A_Index] {
						shouldUpdate := True
						break
					} else if v < App.version[A_Index] {
						break
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
		whr.Send()
		whr.WaitForResponse()
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