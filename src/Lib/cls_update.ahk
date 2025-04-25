Class Update {
	static releasesJson := "https://data.jsdelivr.com/v1/package/gh/DemerNkardaz/DSL-KeyPad"
	static available := False

	static __New() {
		this.versions := this.ChekVersions()
		this.CompareVersions()

	}

	static CompareVersions() {
		for version in this.versions {
			RegExMatch(version, "(\d+)\.(\d+)\.(\d+)\.(\d+)", &digitMatches)
			for i, digit in digitMatches {
				if (i == 0)
					continue
				if (Number(digit) > App.version[i]) {
					this.available := True
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