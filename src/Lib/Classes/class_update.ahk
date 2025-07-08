Class Update {
	static jsDelivr := "https://cdn.jsdelivr.net/gh/DemerNkardaz/DSL-KeyPad"
	static releasesJson := "https://data.jsdelivr.com/v1/package/gh/DemerNkardaz/DSL-KeyPad"
	static fallbackReleases := App.API "/releases"
	static filesManifest := "DSLKeyPad-FilesManifest.txt"
	static filesManifestPath := App.paths.temp "\" this.filesManifest
	static available := False
	static availableVersion := ""
	static versions := []

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
			MsgBox(Locale.Read("gui.options.update_absent"), App.Title(), "Iconi")
			return
		} else {
			if force {
				acceptBox := MsgBox(Locale.Read("gui.options.update_repair.description"), App.Title() " — " Locale.Read("gui.options.update_repair"), "YesNo Icon!")
				if acceptBox = "No" || acceptBox = "Cancel" {
					return
				}
				this.CompareVersions(force)
			}

			if (this.versions is Integer || this.versions is Array && this.versions.Length == 0) {
				MsgBox(Locale.Read("warnings.cannot_be_executed"), App.Title() " — " Locale.Read("gui.options.update_repair"), "Iconx")
				return
			} else
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
		} catch as e {
			MsgBox(Locale.Read("bundle_creation_failed") "`n`n" e.Message, App.Title(), "Iconx")
		}
	}

	static Download(version := this.availableVersion, fallbackSourceForge := False) {
		failed := False
		failedMessage := Locale.Read("gui.options.update_failed")

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
				failedMessage := Locale.ReadInject("gui.options.update_failed_pshell", [exitCode])
			}
		} catch
			failed := True

		if failed {
			if !fallbackSourceForge {
				Update.Download(version, True)
			} else {
				MsgBox(failedMessage, App.Title(), "Iconx")
			}
		}

		if !failed {
			MsgBox(Locale.ReadInject("gui.options.update_successful", [App.Ver("+hotfix+postfix"), version]), App.Title(), "Iconi")
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
				if (!split.HasValue(currentFilePath)
					&& !whitelist.HasValue(currentFilePath))
					&& !InStr(A_LoopFileFullPath, App.paths.dir "\User")
					&& !InStr(A_LoopFileFullPath, App.paths.dir "\Mods") {
					filesToDelete.Push(currentFilePath)
				}
			}

			if filesToDelete.Length > 0 {
				MB := MsgBox(Locale.ReadInject("gui.options.update_found_legacy_files", [filesToDelete.ToString('`n')]), App.Title(), "YesNo Icon!")
				if MB = "Yes" {
					for relative in filesToDelete
						FileDelete(App.paths.dir relative)
					MsgBox(Locale.ReadInject("gui.options.update_found_legacy_files_deleted"), App.Title(), "Iconi")
				}
				return
			}

			FileDelete(this.filesManifestPath)
		}
	}

	static Check(withAcceptUpdate := False) {
		this.versions := this.ChekVersions()
		if this.versions is Integer
			return this.versions

		this.CompareVersions()

		if withAcceptUpdate {
			if this.available {
				acceptBox := MsgBox(Locale.ReadInject("gui.options.update_get_acception", [this.availableVersion]), App.Title(), "YesNo Iconi")
				if acceptBox = "Yes" || acceptBox = "OK"
					this.Get()
			} else
				MsgBox(Locale.Read("gui.options.update_absent"), App.Title())
		}
	}

	static CompareVersions(force := False) {
		currentVersion := App.Ver("+hotfix", [])
		if this.versions is Integer
			return
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
		http := ComObject("WinHttp.WinHttpRequest.5.1")
		http.SetTimeouts(1500, 1500, 1500, 1500)
		http.Open("GET", useFallback ? this.fallbackReleases : this.releasesJson, true)
		failed := False

		try {
			http.Send()
			http.WaitForResponse(1.5)
			if (http.Status != 200)
				failed := True
		}
		catch
			failed := True

		if failed {
			if !useFallback {
				return this.ChekVersions(True)
			} else {
				MsgBox(Locale.Read("gui.options.update_check_failed"), App.Title(), "Iconx")
				return 1
			}
		}

		responseText := http.ResponseText
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
}

Class Changelog {

	static PanelGUI := Gui()
	static panelTitle := ""

	static Panel() {
		this.panelTitle := App.Title() " — " Locale.Read("gui.changelog")

		panelW := 600
		panelH := 800

		posX := (A_ScreenWidth - panelW) / 2
		posY := (A_ScreenHeight - panelH) / 2

		clBoxW := panelW - 20
		clBoxH := panelH - 20
		clBoxX := (panelW - clBoxW) / 2
		clBoxY := (panelH - clBoxH) / 2

		clContentW := clBoxW - 20
		clContentH := clBoxH - 20 - 5
		clContentX := clBoxX + (clBoxW - clContentW) / 2
		clContentY := (clBoxY + (clBoxH - clContentH) / 2) + 5

		Constructor() {
			changelogPanel := Gui()
			changelogPanel.title := this.panelTitle

			changelogPanel.AddGroupBox(Format("vChangelogBox w{} h{} x{} y{}", clBoxW, clBoxH, clBoxX, clBoxY), Chr(0x1F310) " " Locale.Read("gui.changelog"))

			changelogPanel.Show(Format("w{} h{} x{} y{}", panelW, panelH, posX, posY))
			return changelogPanel
		}

		if WinExist(this.panelTitle) {
			WinActivate(this.panelTitle)
		} else {
			this.PanelGUI := Constructor()
			this.PanelGUI.Show()

			WinExist(this.panelTitle) && PostConstructor()
		}

		PostConstructor() {
			changelogPanel := this.PanelGUI

			this.InsertChangelog(changelogPanel, Format("vChangelogInfoBoxContent w{} h{} x{} y{} readonly Left Wrap -HScroll -E0x200", clContentW, clContentH, clContentX, clContentY))
		}
	}

	static InsertChangelog(targetGUI, UISettings) {
		if this.FormatChangelog(this.GetChangelog(), &changelog)
			targetGUI.AddEdit(UISettings, changelog)
		else
			targetGUI.AddEdit(UISettings, Locale.Read("warnings.nointernet"))
	}

	static GetChangelog(url := Update.jsDelivr "@latest/CHANGELOG.md") {
		static fallbackURL := App.refsHeads["main"] "/CHANGELOG.md"
		failed := False

		languageCode := Language.Get(, , 2)
		http := ComObject("WinHttp.WinHttpRequest.5.1")
		http.SetTimeouts(1500, 1500, 1500, 1500)
		http.Open("GET", url, True)
		try {
			http.Send()
			http.WaitForResponse(1.5)
			if http.Status != 200
				failed := True
		}
		catch
			failed := True

		if failed && url != fallbackURL
			return this.GetChangelog(fallbackURL)
		else {
			content := http.ResponseText
			pattern := '<details[^>]*lang="' LanguageCode '"[^>]*>[\s\S]*?<summary>[\s\S]*?</summary>([\s\S]*?)</details>'

			if RegExMatch(content, pattern, &match) {
				return match[1]
			}
		}
		return False
	}

	static FormatChangelog(str, &output?) {
		if !str || StrLen(str) == 0
			return False

		labels := {
			ver: Locale.Read("dictionary.version"),
			date: Locale.Read("dictionary.date"),
			link: Locale.Read("dictionary.release_link")
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
