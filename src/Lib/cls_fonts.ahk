Class Fonts {
	static fontFaces := Map(
		"Default", { name: "Noto Serif", src: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSerif/googlefonts/variable-ttf/NotoSerif%5Bwdth%2Cwght%5D.ttf", required: True },
		"Sans-Serif", { name: "Noto Sans", src: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSans/googlefonts/variable-ttf/NotoSans%5Bwdth%2Cwght%5D.ttf" },
		"Noto Sans Old Permic", { name: "Noto Sans Old Permic", src: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSansOldPermic/full/ttf/NotoSansOldPermic-Regular.ttf" },
		"Noto Sans Old North Arabian", { name: "Noto Sans Old North Arabian", src: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSansOldNorthArabian/full/ttf/NotoSansOldNorthArabian-Regular.ttf" },
		"Noto Sans Old South Arabian", { name: "Noto Sans Old South Arabian", src: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSansOldSouthArabian/full/ttf/NotoSansOldSouthArabian-Regular.ttf" },
		"Noto Sans Chorasmian", { name: "Noto Sans Chorasmian", src: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSansChorasmian/full/ttf/NotoSansChorasmian-Regular.ttf" },
	)

	static __New() {
		this.Validate()
	}

	static Validate() {
		namesToInstall := "`n"
		srcsToInstall := []
		found := False

		for _, font in this.fontFaces {
			if this.IsInstalled(font.name)
				found := True
			else {
				if font.HasOwnProp("required") && font.required {
					srcsToInstall.Push(font.src)
					namesToInstall .= font.name "`n"
				}
			}
		}

		if !found {
			MsgBox(Locale.Read("prepare_fonts") namesToInstall, App.Title())

			for _, fontSource in srcsToInstall {
				this.Download(fontSource)
			}
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

		if FileExist(App.paths.temp "\font-install.log")
			FileDelete(App.paths.temp "\font-install.log")


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
			MsgBox("Can’t download font.`n" Locale.Read("prepare_fonts"), "Font Installer")
		}


		fontTitle := RegExReplace(StrSplit(fontSource, "/").Pop(), "[^a-zA-Z]+.*$", "") ".ttf"
		fontPath := tempFolder "\" fontTitle
		Download(fontSource, fontPath)
		RunWait(fontPath)
		FileDelete(fontPath)
	}
}