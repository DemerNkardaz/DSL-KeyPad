Class Fonts {
	static fontFaces := Map(
		"Default", { name: "Noto Serif", required: True },
		"Symbols", { name: "Noto Sans Symbols", required: True },
		"Sans-Serif", { name: "Noto Sans", required: True },
	)

	static URLData := JSON.LoadFile(App.paths.data "\fonts_url_data.json", "UTF-8")
	static fontByCodePoint := JSON.LoadFile(App.paths.data "\font_by_code_points.json", "UTF-8")


	static __New() {
		this.Validate()
		for fontName, pairs in this.fontByCodePoint
			for i, each in pairs
				this.fontByCodePoint[fontName][i] := Number("0x" each)
		return
	}

	static CompareByPair(codePoint, defaultFont := "Segoe UI") {
		local num := Number("0x" codePoint)

		for fontName, pairs in this.fontByCodePoint
			for i, pair in pairs
				if Mod(i, 2) = 1 && num >= pairs[i] && num <= pairs[i + 1]
					return fontName

		return defaultFont
	}

	static Validate() {
		namesToInstall := "`n"
		fontsToInstall := []

		for _, font in this.fontFaces {
			if !this.IsInstalled(font.name) && font.HasOwnProp("required") && font.required {
				fontsToInstall.Push(font.name)
				namesToInstall .= font.name "`n"
			}
		}

		if fontsToInstall.Length > 0 {
			local status := MsgBox(Locale.Read("prepare.fonts_not_found") namesToInstall, App.Title(), "Icon! OKCancel")

			if status = "OK"
				for _, fontSource in fontsToInstall
					Run("https://fonts.google.com/download?family=" StrReplace(fontSource, " ", "+"))
		}
	}

	static InstallRecommended() {
		sources := []

		for _, font in this.fontFaces {
			if !font.HasOwnProp("required") {
				src := font.src
				dest := App.paths.temp "\" StrSplit(src, "/").Pop()
				Download(src, dest)

			}
		}

		Sleep 1000

		; if FileExist(App.paths.temp "\font-install.log")
		; 	FileDelete(App.paths.temp "\font-install.log")


		/*
		
				shell := ComObject("Shell.Application")
				folder := shell.Namespace(App.paths.temp)
		
				Loop Files App.paths.temp "\*.ttf" {
		
					name := A_LoopFileName
					item := folder.ParseName(name)
		
					if item {
						item.InvokeVerb("Install")
						FileAppend "Installed: " name "`n", App.paths.temp "\font-install.log"
					} else {
						FileAppend "Failed to parse: " name "`n", App.paths.temp "\font-install.log"
					}
		
					Sleep 100
					FileDelete(App.paths.temp "\" name)
				}
		*/
	}

	static IsInstalled(fontName) {
		for suffix in [" Regular (TrueType)", " Regular", ""] {
			fullName := fontName suffix

			Loop Reg, "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" {
				if fullName = A_LoopRegName {
					return True
				}
			}
			Loop Reg, "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" {
				if fullName = A_LoopRegName {
					return True
				}
			}
		}

		return False
	}

	static Download(fontSource) {
		tempFolder := A_Temp "\DSLTemp"
		DirCreate(tempFolder)

		http := ComObject("WinHttp.WinHttpRequest.5.1")
		http.SetTimeouts(1500, 1500, 1500, 1500)
		http.Open("GET", fontSource, true)
		try {
			http.Send()
			http.WaitForResponse(4)
			if (http.Status != 200) {
				MsgBox("Can’t download font.", "Font Installer")
				return
			}
		} catch {
			MsgBox("Can’t download font.`n" Locale.Read("prepare.fonts_not_found"), "Font Installer")
		}


		fontTitle := RegExReplace(StrSplit(fontSource, "/").Pop(), "[^a-zA-Z]+.*$", "") ".ttf"
		fontPath := tempFolder "\" fontTitle
		Download(fontSource, fontPath)
		RunWait(fontPath)
		FileDelete(fontPath)
	}

	static OpenURL(fontName) {
		if fontName ~= "^" Chr(0x1D4D5)
			fontName := SubStr(fontName, 4)

		if this.URLData["Google Fonts"].HasRegEx(fontName) {
			fontName := StrReplace(fontName, " ", "+")
			Run("https://fonts.google.com/specimen/" fontName)
		} else if this.URLData.Has(fontName) && this.URLData[fontName] is String
			Run(this.URLData.Get(fontName))
		else
			Run("https://google.com/search?q=" fontName)

		return
	}
}