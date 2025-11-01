Class Fonts {
	static fontFaces := JSON.LoadFile(App.paths.data "\font_faces.json", "UTF-8")
	static fallbackFont := "Segoe UI"

	static Get(fontType := "Default", variant?) {
		local output := this.fallbackFont

		local useVariants := IsSet(variant) && variant is Integer
		local usedData := useVariants ? "variants" : "name"

		if this.fontFaces["GUI Common"].Has(fontType) {
			output := this.fontFaces["GUI Common"][fontType][usedData]
			output := output is Array ? output[useVariants ? variant : 1] : output
		}

		return output
	}

	static Set(fontName, fontType := "Default", variant?) {
		local useVariants := IsSet(variant) && variant is Integer
		local usedData := useVariants ? "variants" : "name"

		if this.fontFaces["GUI Common"].Has(fontType) {
			if useVariants
				this.fontFaces["GUI Common"][fontType][usedData][variant] := fontName
			else
				this.fontFaces["GUI Common"][fontType][usedData] := fontName
		}

		return
	}

	static GetFontByAssignation(assignationScriptContext) {
		for fontName, assignedContextes in this.fontFaces["Assignation"]
			if assignedContextes.HasRegEx(assignationScriptContext)
				return fontName

		return ""
	}

	static GetFontByCodePoint(codePoint, defaultFont := this.fallbackFont) {
		local num := Number("0x" codePoint)

		for fontName, rangeStrings in this.fontFaces["Code Points"] {
			for each in rangeStrings {
				local range := StrSplit(each, "-").StringsPrepend("0x").StringsToNumbers()

				if num >= range[1] && num <= range[2]
					return fontName
			}
		}

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

		return
	}

	static GetListedFontsNames(variants := "Required") {
		local output := []

		for _, font in this.fontFaces["GUI Common"] {
			local wasSetRequired := font.Has("required") && font["required"]

			if (variants = "All" || wasSetRequired = (variants = "Required"))
				output.Push(font["name"])
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

		local url := "https://google.com/search?q="

		if this.fontFaces["URLs"]["Google Fonts"].HasRegEx(fontName)
			url := "https://fonts.google.com/specimen/" StrReplace(fontName, " ", "+")
		else if this.fontFaces["URLs"].Has(fontName) && this.fontFaces["URLs"][fontName] is String
			url := this.fontFaces["URLs"].Get(fontName)
		else
			url .= fontName

		Run(url)
		return
	}
}

Fonts.CheckRequiredFontsAvailability()