Class Fonts {
	static fontFaces := Map(
		"Default", { name: "Noto Serif", src: "https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSerif/googlefonts/variable-ttf/NotoSerif%5Bwdth%2Cwght%5D.ttf", required: True },
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
				srcsToInstall.Push(font.src)
				namesToInstall .= font.name "`n"
			}
		}

		if !found {
			MsgBox(Locale.Read("prepare_fonts") namesToInstall, App.title)

			for _, fontSource in srcsToInstall {
				this.Download(fontSource)
			}
		}
	}

	static IsInstalled(fontName) {
		for suffix in ["", " Regular", " Regular (TrueType)"] {
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
		http.Open("GET", fontSource, true)
		try {
			http.Send()
			http.WaitForResponse()
		} catch {
			MsgBox("Can’t download font.`n" Locale.Read("prepare_fonts"), "Font Installer")
		}

		if (http.Status != 200) {
			MsgBox("Can’t download font.", "Font Installer")
			return
		}

		fontTitle := RegExReplace(StrSplit(fontSource, "/").Pop(), "[^a-zA-Z]+.*$", "") ".ttf"
		fontPath := tempFolder "\" fontTitle
		Download(fontSource, fontPath)
		RunWait(fontPath)
		FileDelete(fontPath)
	}
}