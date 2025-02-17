Class ChrLegend {

	static UISets := {
		infoBox: {
			body: "x20 y35 w830 h510",
			previewFrame: "x621 y80 w192 h192 Center",
			preview: "x621 y80 w192 h192 readonly Center -VScroll -HScroll",
			topbarID: "x20 y10 w75 h24 readonly -VScroll -HScroll",
			topbarEntry: "x100 y10 w320 h24 readonly -VScroll -HScroll",
			topbarUnicode: "x425 y10 w75 h24 readonly Center -VScroll -HScroll",
			topbarHTML: "x505 y10 w75 h24 readonly Center -VScroll -HScroll",
			mainTitle: "x35 y75 w450 h42 readonly -VScroll -HScroll -E0x200",
			unicodeLabel: "x45 y135 w75 h20 BackgroundTrans",
			unicode: "x120 y135 w450 h20 readonly -VScroll -HScroll -E0x200",
			subTitlesLabel: "x45 y155 w75 h20 BackgroundTrans",
			subTitles: "x120 y155 w450 h20 readonly -VScroll -HScroll -E0x200",
			IPALabel: "x45 y175 w75 h20 BackgroundTrans",
			IPA: "x120 y175 w450 h20 readonly -VScroll -HScroll -E0x200",
			transcriptionLabel: "x45 y195 w75 h20 BackgroundTrans",
			transcription: "x120 y195 w450 h20 readonly -VScroll -HScroll -E0x200",
			languagesLabel: "x45 y215 w75 h20 BackgroundTrans",
			languages: "x120 y215 w450 h20 readonly -VScroll -HScroll -E0x200",
			description: "x45 y255 w550 h320 R20 readonly +Multi +Wrap -HScroll -E0x200",
			authorLabel: "x45 y550 w75 h20 BackgroundTrans",
			author: "x120 y550 w600 h20 readonly -VScroll -HScroll -E0x200",
		},
	}

	__New(data) {
		ChrLegend.Panel(data)
	}

	static ReadLegend(path) {
		Legend := Util.INIToObj(A_ScriptDir "\UtilityFiles\ChrLegend\" path)

		return Legend
	}

	static Panel(data) {
		Constructor() {
			value := ChrLib.GetEntry(data.entry)
			legendData := this.ReadLegend(value.options.legend)
			languageCode := Language.Get()

			panelTitle := App.winTitle " — " Util.StrVarsInject(Locale.Read("gui_legend"), Locale.Read(data.entry, "chars"))

			screenWidth := A_ScreenWidth
			screenHeight := A_ScreenHeight

			windowWidth := 870
			windowHeight := 570

			resolutions := [
				[1080, 1920],
				[1440, 2560],
				[1800, 3200],
				[2160, 3840],
				[2880, 5120],
				[4320, 7680]
			]

			for res in resolutions {
				if screenHeight = res[1] && screenWidth > res[2] {
					screenWidth := res[2]
					break
				}
			}

			xPos := screenWidth - windowWidth - 50
			yPos := screenHeight - windowHeight - 92


			panelWindow := Gui()
			panelWindow.title := panelTitle

			GroupBoxOptions := {
				topbarID: panelWindow.AddEdit("vLegendID " this.UISets.infoBox.topbarID),
				topbarEntry: panelWindow.AddEdit("vLegendEntry " this.UISets.infoBox.topbarEntry),
				topbarUnicode: panelWindow.AddEdit("vLegendUnicode " this.UISets.infoBox.topbarUnicode),
				topbarHTML: panelWindow.AddEdit("vLegendHTML " this.UISets.infoBox.topbarHTML),
				group: panelWindow.Add("GroupBox", "vLegendGroup " this.UISets.infoBox.body),
				groupFrame: panelWindow.Add("GroupBox", this.UISets.infoBox.previewFrame),
				preview: panelWindow.AddEdit("vLegendSymbol " this.UISets.infoBox.preview),
				mainTitle: panelWindow.AddEdit("vLegendTitle " this.UISets.infoBox.mainTitle),
				unicodeLabel: panelWindow.AddText("vLegendUnicodeLabel " this.UISets.infoBox.unicodeLabel),
				unicode: panelWindow.AddEdit("vLegendUnicodeName " this.UISets.infoBox.unicode),
				subTitlesLabel: panelWindow.AddText("vLegendSubTitlesLabel " this.UISets.infoBox.subTitlesLabel),
				subTitles: panelWindow.AddEdit("vLegendSubTitles " this.UISets.infoBox.subTitles),
				IPALabel: panelWindow.AddText("vLegendIPALabel " this.UISets.infoBox.IPALabel),
				IPA: panelWindow.AddEdit("vLegendIPA " this.UISets.infoBox.IPA),
				transcriptionLabel: panelWindow.AddText("vLegendTranscriptionLabel " this.UISets.infoBox.transcriptionLabel),
				transcription: panelWindow.AddEdit("vLegendTranscription " this.UISets.infoBox.transcription),
				languagesLabel: panelWindow.AddText("vLegendlanguagesLabel " this.UISets.infoBox.languagesLabel),
				languages: panelWindow.AddEdit("vLegendlanguages " this.UISets.infoBox.languages),
				description: panelWindow.AddEdit("vLegenddescription " this.UISets.infoBox.description),
				authorLabel: panelWindow.AddText("vLegendAuthorLabel " this.UISets.infoBox.authorLabel),
				author: panelWindow.AddLink("vLegendAuthor " this.UISets.infoBox.author),
			}

			GroupBoxOptions.preview.Text := value.symbol.HasOwnProp("alt") ? value.symbol.alt : value.symbol.set
			GroupBoxOptions.preview.SetFont(, value.symbol.HasOwnProp("font") ? value.symbol.font : Panel.UISets.infoFonts.fontFace["serif"].name)
			GroupBoxOptions.preview.SetFont("s" (Panel.UISets.infoFonts.previewSize * 1.5) " norm cDefault")
			GroupBoxOptions.preview.SetFont(, value.symbol.HasOwnProp("font") ? value.symbol.font : Panel.UISets.infoFonts.fontFace["serif"].name)
			GroupBoxOptions.preview.SetFont(value.symbol.HasOwnProp("customs") ? value.symbol.customs : StrLen(GroupBoxOptions.preview.Text) > 2 ? "s" (Panel.UISets.infoFonts.previewSmaller * 1.5) " norm cDefault" : "s" (Panel.UISets.infoFonts.previewSize * 1.5) " norm cDefault")


			GroupBoxOptions.topbarID.Text := value.index
			GroupBoxOptions.topbarEntry.Text := data.entry
			GroupBoxOptions.topbarUnicode.Text := value.HasOwnProp("sequence") ? Util.StrCutBrackets(value.sequence.ToString(" ")) : Util.StrCutBrackets(value.unicode)
			GroupBoxOptions.topbarHTML.Text := value.HasOwnProp("entity") ? [value.html, value.entity].ToString(" ") : value.html
			GroupBoxOptions.topbarID.SetFont("s12")
			GroupBoxOptions.topbarEntry.SetFont("s12")
			GroupBoxOptions.topbarUnicode.SetFont(StrLen(GroupBoxOptions.topbarUnicode.Text) > 6 ? "s9" : "s12")
			GroupBoxOptions.topbarHTML.SetFont(StrLen(GroupBoxOptions.topbarHTML.Text) > 7 ? "s9" : "s12")


			GroupBoxOptions.mainTitle.Text := legendData.%languageCode%.title
			GroupBoxOptions.mainTitle.SetFont("s24 bold", Panel.UISets.infoFonts.fontFace["serif"].name)

			GroupBoxOptions.unicodeLabel.Text := Locale.Read("gui_legend_unicode") ChrLib.Get("emsp")
			GroupBoxOptions.unicodeLabel.SetFont("s11 bold")
			GroupBoxOptions.unicode.Text := legendData.legend.unicode_name
			GroupBoxOptions.unicode.SetFont("s11")

			GroupBoxOptions.subTitlesLabel.Text := Locale.Read("gui_legend_alts") ChrLib.Get("emsp")
			GroupBoxOptions.subTitlesLabel.SetFont("s11 bold")
			GroupBoxOptions.subTitles.Text := legendData.%languageCode%.alts
			GroupBoxOptions.subTitles.SetFont("s11")

			GroupBoxOptions.IPALabel.Text := Locale.Read("gui_legend_ipa") ChrLib.Get("emsp")
			GroupBoxOptions.IPALabel.SetFont("s11 bold")
			GroupBoxOptions.IPA.Text := legendData.%languageCode%.ipa
			GroupBoxOptions.IPA.SetFont("s11")

			GroupBoxOptions.transcriptionLabel.Text := Locale.Read("gui_legend_transcription") ChrLib.Get("emsp")
			GroupBoxOptions.transcriptionLabel.SetFont("s11 bold")
			GroupBoxOptions.transcription.Text := legendData.%languageCode%.transcription
			GroupBoxOptions.transcription.SetFont("s11")

			GroupBoxOptions.languagesLabel.Text := Locale.Read("gui_legend_langs") ChrLib.Get("emsp")
			GroupBoxOptions.languagesLabel.SetFont("s11 bold")
			GroupBoxOptions.languages.Text := legendData.%languageCode%.langs
			GroupBoxOptions.languages.SetFont("s11")

			GroupBoxOptions.description.Text := Locale.HandleString(legendData.%languageCode%.description)
			GroupBoxOptions.description.SetFont("s11")


			defaultAuthor := Map("ru", "<a href=`"https://nkardaz.carrd.co`">Ялла Нкардаз</a>", "en", "<a href=`"https://nkardaz.carrd.co`">Yalla Nkardaz</a>")

			GroupBoxOptions.authorLabel.Text := Locale.Read("gui_legend_author") ChrLib.Get("emsp")
			GroupBoxOptions.authorLabel.SetFont("bold")
			GroupBoxOptions.author.Text := legendData.%languageCode%.hasOwnProp("author") ? legendData.%languageCode%.author : defaultAuthor[LanguageCode]


			panelWindow.Show("w" windowWidth " h" windowHeight "x" xPos " y" yPos)

			return panelWindow
		}

		PanelGUI := Constructor()
		PanelGUI.Show()
	}
}