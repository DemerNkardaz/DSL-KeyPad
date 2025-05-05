Class Update {
	static releasesJson := "https://data.jsdelivr.com/v1/package/gh/DemerNkardaz/DSL-KeyPad"
	static fallbackReleases := App.API "/releases"
	static filesManifest := "DSLKeyPad-FilesManifest.txt"
	static filesManifestPath := App.paths.temp "\" this.filesManifest
	static available := False
	static availableVersion := ""

	static __New() {
		autocheckOff := Cfg.Get("Turn_Off_Autocheck_Update", , False, "bool")
		if !autocheckOff
			Update.Check()
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
				acceptBox := MsgBox(Locale.Read("update_repair"), App.Title() " — " Locale.Read("update_repair_title"), "YesNo")
				if acceptBox = "No" || acceptBox = "Cancel" {
					return
				}
				this.CompareVersions(force)
			}
			this.Download()
		}
	}

	static Build() {
		try {
			Dev.SetSrc()
			/*
			exitCode := RunWait(Format(
				'powershell -ExecutionPolicy Bypass -NoProfile -File "{}" "{}" "{}"',
				App.paths.lib "\powershell\pack_bundle.ps1", A_ScriptDir, App.Ver("+hotfix+postfix")
			), , "Show")
			
			if exitCode != 0 {
				MsgBox(Locale.ReadInject("bundle_creation_failed_pshell", [exitCode]), App.Title())
			}
			*/
		} catch {
			MsgBox(Locale.Read("bundle_creation_failed"), App.Title())
		}
	}

	static Download(version := this.availableVersion, fallbackSourceForge := False) {
		failed := False
		failedMessage := Locale.Read("update_failed")

		gitRelease := App.URL "/releases/download/" version "/DSL-KeyPad-" version ".zip"
		sourceForgeRelease := "https://deac-ams.dl.sourceforge.net/project/dsl-keypad/" version "/DSL-KeyPad-" version ".zip?viasf=1"

		zipSource := fallbackSourceForge ? sourceForgeRelease : gitRelease
		downloadPath := App.paths.temp
		downloadName := "DSL-KeyPad.zip"

		if FileExist(downloadPath "\" downloadName)
			FileDelete(downloadPath "\" downloadName)

		try {
			exitCode := RunWait(Format(
				'powershell -ExecutionPolicy Bypass -NoProfile -File "{}" -Url "{}" -Destination "{}" -FileName "{}"',
				App.paths.lib "\powershell\download.ps1", zipSource, downloadPath, downloadName
			), , "Show")

			exitCode := RunWait(Format(
				'powershell -ExecutionPolicy Bypass -NoProfile -File "{}" -ZipPath "{}" -Destination "{}" -Version "{}" -ManifestName "{}"',
				App.paths.lib "\powershell\update_supporter.ps1", downloadPath "\" downloadName, App.paths.dir, version, this.filesManifest
			), , "Show")

			if exitCode != 0 {
				failed := True
				failedMessage := Locale.ReadInject("update_failed_pshell", [exitCode])
			}
		} catch
			failed := True

		if failed {
			if !fallbackSourceForge {
				Update.Download(version, True)
			} else {
				MsgBox(failedMessage, App.Title())
			}
		}

		if !failed {
			MsgBox(Locale.ReadInject("update_successful", [App.Ver("+hotfix+postfix"), version]), App.Title())
			this.RemoveLegacyAssets()
			Reload
		}
	}

	static RemoveLegacyAssets() {
		if FileExist(this.filesManifestPath) {
			content := FileRead(this.filesManifestPath, "UTF-8")
			split := StrSplit(content, "`n", "`r")
			filesToDelete := []
			whitelist := ["\workflow.ps1"]

			Loop Files, App.paths.dir "\*.*", "FR" {
				currentFilePath := StrReplace(A_LoopFileFullPath, App.paths.dir)
				if (!split.HasValue(currentFilePath) && !whitelist.HasValue(currentFilePath)) && !InStr(A_LoopFileFullPath, App.paths.dir "\User") {
					filesToDelete.Push(currentFilePath)
				}
			}

			if filesToDelete.Length > 0 {
				MB := MsgBox(Locale.ReadInject("update_found_legacy_files", [filesToDelete.ToString('`n')]), App.Title(), "YesNo")
				if MB = "Yes" {
					for relative in filesToDelete
						FileDelete(App.paths.dir relative)
					MsgBox(Locale.ReadInject("update_found_legacy_files_deleted"), App.Title())
				}
				return
			}

			FileDelete(this.filesManifestPath)
		}
	}

	static Check(withAcceptUpdate := False) {
		this.versions := this.ChekVersions()
		this.CompareVersions()

		if withAcceptUpdate {
			if this.available {
				acceptBox := MsgBox(Locale.ReadInject("gui_options_get_update_acception", [this.availableVersion]), App.Title(), "YesNo")
				if acceptBox = "Yes" || acceptBox = "OK"
					this.Get()
			} else
				MsgBox(Locale.Read("gui_options_update_absent"))
		}
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

	static ChekVersions(useFallback := False) {
		whr := ComObject("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", useFallback ? this.fallbackReleases : this.releasesJson, true)
		failed := False

		try {
			whr.Send()
			whr.WaitForResponse()
		}
		catch
			failed := True

		if (whr.Status != 200)
			failed := True

		if failed {
			if !useFallback {
				return this.ChekVersions(True)
			} else {
				MsgBox Locale.Read("update_check_failed")
				return []
			}
		}

		responseText := whr.ResponseText
		versions := this.ExtractVersionsArray(responseText, useFallback)
		return versions
	}

	static ExtractVersionsArray(jsonStr, useFallback := False) {
		if (!jsonStr)
			return []

		versions := []

		if (useFallback) {
			tagRegex := '"tag_name"\s*:\s*"([^"]+)"'
			searchPos := 1
			while (RegExMatch(jsonStr, tagRegex, &vMatch, searchPos)) {
				if (vMatch[1] != "") {
					versions.Push(vMatch[1])
				}
				searchPos := vMatch.Pos + vMatch.Len
			}
		} else {
			versionPattern := '"versions":\s*\[([^\]]*)\]'
			if (RegExMatch(jsonStr, versionPattern, &versionsMatch)) {
				versionRegex := '"([^"]+)"'
				searchPos := 1
				while (RegExMatch(versionsMatch[1], versionRegex, &vMatch, searchPos)) {
					versions.Push(vMatch[1])
					searchPos := vMatch.Pos + vMatch.Len
				}
			}
		}

		return versions
	}

	static InsertChangelog(targetGUI, UISettings) {
		if this.FormatChangelog(this.GetChangelog(), &changelog)
			targetGUI.AddEdit(UISettings, changelog)
		else
			targetGUI.AddEdit(UISettings, Locale.Read("warning_nointernet"))
	}

	static GetChangelog(url := App.refsHeads["main"] "/CHANGELOG.md") {
		languageCode := Language.Get()
		http := ComObject("WinHttp.WinHttpRequest.5.1")
		http.Open("GET", url, true)
		try {
			http.Send()
			http.WaitForResponse()
		}
		catch
			return False
		if (http.Status != 200)
			return False

		content := http.ResponseText
		pattern := '<details[^>]*lang="' LanguageCode '"[^>]*>[\s\S]*?<summary>[\s\S]*?</summary>([\s\S]*?)</details>'

		if RegExMatch(content, pattern, &match) {
			return match[1]
		}
		return False
	}

	static FormatChangelog(str, &output?) {
		if !str || StrLen(str) == 0
			return False

		labels := {
			ver: Locale.Read("version"),
			date: Locale.Read("date"),
			link: Locale.Read("release_link")
		}

		str := RegExReplace(str, "m)^\s*$\R", "")
		str := RegExReplace(str, "m)^###\s+\[(.*?)\s+—\s+(.*?)\]\((.*?)\)", "`n" labels.ver ": $1`n" labels.date ": $2`n" labels.link ": $3`n")

		str := RegExReplace(str, "m)^- (.*)", " • $1")
		str := RegExReplace(str, "m)^\s\s- (.*)", "  ‣ $1")
		str := RegExReplace(str, "m)^\s\s\s\s- (.*)", "   ⁃ $1")

		str := RegExReplace(str, "m)^---", " " Util.StrRepeat(ChrLib.Get("emdash"), 84))
		output := str
		return str
	}

}

; MsgBox("jsDelivr: " Update.ChekVersions().ToString())
; MsgBox("GitHub: " Update.ChekVersions(True).ToString() "`njsDelivr: " Update.ChekVersions().ToString())
