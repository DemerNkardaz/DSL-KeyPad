Class Fonts {
	static fontFaces := Map(
		"Default", { name: "Noto Serif", required: True },
		"Symbols", { name: "Noto Sans Symbols", required: True },
		"Sans-Serif", { name: "Noto Sans", required: True },
	)

	static URLData := JSON.LoadFile(App.paths.data "\fonts_url_data.json", "UTF-8")
	static fontByCodePoint := JSON.LoadFile(App.paths.data "\font_by_code_points.json", "UTF-8")


	static __New() {
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

	static CheckRequiredFontsAvailability(showMissedFontsMessage := True) {
		local requiredFonts := this.GetListedFontsNames("Required")
		local missedRequiredFontNames := []

		this.IsFontsInstalled(requiredFonts, missedRequiredFontNames)

		if showMissedFontsMessage && missedRequiredFontNames.Length > 0
			this.RequiredFontsInstallationMessage(missedRequiredFontNames)

		return missedRequiredFontNames
	}

	static RequiredFontsInstallationMessage(fontNames) {
		local messageStatus := MsgBox(Locale.Read("prepare.fonts_not_found") "`n" fontNames.ToString("`n"), App.Title(), "Icon! OKCancel")

		if messageStatus = "OK"
			for _, fontSource in fontNames
				Run("https://fonts.google.com/download?family=" StrReplace(fontSource, " ", "+"))
	}

	static GetListedFontsNames(variants := "Required") {
		local output := []

		for _, font in this.fontFaces {
			local wasSetRequired := font.HasOwnProp("required") && font.required

			if (variants = "All" || wasSetRequired = (variants = "Required"))
				output.Push(font.name)
		}

		return output
	}

	static IsFontsInstalled(fontNames, missingNamesArray?, foundNamesArray?) {
		if fontNames is String
			fontNames := [fontNames]

		local result := Map()
		local hDC := Gdi.GetDC(0)
		local allFontNames := Map()

		local lf := LOGFONTW()
		lf.lfFaceName := ""
		lf.lfCharSet := FONT_CHARSET.DEFAULT_CHARSET

		local callback := CallbackCreate((lpelfe, lpntme, fontType, lparam) => (ObjFromPtrAddRef(lparam)[LOGFONTW(lpelfe).lfFaceName] := True, 1), "Fast", 4)

		Gdi.EnumFontFamiliesExW(hDC, lf, callback, ObjPtr(allFontNames), 0)
		CallbackFree(callback)
		Gdi.ReleaseDC(0, hDC)

		for fontName in fontNames {
			local found := allFontNames.Has(fontName)
			result[fontName] := found

			if (!found && IsSet(missingNamesArray))
				missingNamesArray.Push(fontName)
			else if (found && IsSet(foundNamesArray))
				foundNamesArray.Push(fontName)
		}

		return result.Count = 1 ? result.Values()[1] : result
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

Fonts.CheckRequiredFontsAvailability()