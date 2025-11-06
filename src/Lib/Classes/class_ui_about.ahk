Class AboutPanel {
	static __New() {
		globalInstances.AboutGUI := this()
		return
	}

	setCached := False
	title := ""

	w := 1200
	h := 600

	xPos := 0
	yPos := 0

	resolutions := [
		[1080, 1920],
		[1440, 2560],
		[1800, 3200],
		[2160, 3840],
		[2880, 5120],
		[4320, 7680]
	]

	fontFamily := Fonts.Get()

	bgX := 10
	bgY := 10
	bgW := this.w - 20
	bgH := this.h - 20

	aboutLeftPanelW := 280
	aboutLeftPanelH := this.bgH - 10
	aboutLeftPanelX := this.bgX + 10
	aboutLeftPanelY := this.bgY + ((this.bgH - this.aboutLeftPanelH) / 2) - 2

	defaultGrpH := this.aboutLeftPanelH
	defaultGrpY := this.aboutLeftPanelY

	defaultTitleW := this.aboutLeftPanelW - 10
	defaultTitleX := this.aboutLeftPanelX + ((this.aboutLeftPanelW - this.defaultTitleW) / 2)

	aboutLeftPanelFrameW := 170
	aboutLeftPanelFrameH := 170
	aboutLeftPanelFrameX := this.aboutLeftPanelX + (this.aboutLeftPanelW - this.aboutLeftPanelFrameW) / 2
	aboutLeftPanelFrameY := this.aboutLeftPanelY + 20

	aboutLeftIconW := 128
	aboutLeftIconH := 128
	aboutLeftIconX := this.aboutLeftPanelFrameX + (this.aboutLeftPanelFrameW - this.aboutLeftIconW) / 2
	aboutLeftIconY := this.aboutLeftPanelFrameY + (this.aboutLeftPanelFrameH - this.aboutLeftIconH) / 2

	aboutTitleW := this.defaultTitleW
	aboutTitleH := 32
	aboutTitleX := this.defaultTitleX
	aboutTitleY := this.aboutLeftPanelFrameY + this.aboutLeftPanelFrameH + 10

	aboutVersionW := this.defaultTitleW
	aboutVersionH := this.aboutTitleH
	aboutVersionX := this.defaultTitleX
	aboutVersionY := this.aboutTitleY + this.aboutTitleH + 10

	aboutRepoLinkW := this.defaultTitleW
	aboutRepoLinkH := this.aboutTitleH
	aboutRepoLinkX := this.defaultTitleX
	aboutRepoLinkY := (this.aboutVersionY + this.aboutVersionH) + 14

	aboutAuthorW := this.defaultTitleW
	aboutAuthorH := this.aboutTitleH
	aboutAuthorX := this.defaultTitleX
	aboutAuthorY := this.aboutLeftPanelH - 35

	aboutDescBoxW := 515
	aboutDescBoxH := this.defaultGrpH
	aboutDescBoxX := (this.aboutLeftPanelX + this.aboutLeftPanelW) + 10
	aboutDescBoxY := this.defaultGrpY

	aboutDescBoxPadding := 12

	aboutDescriptionW := this.aboutDescBoxW - (this.aboutDescBoxPadding * 2)
	aboutDescriptionH := this.aboutDescBoxH - 60
	aboutDescriptionX := this.aboutDescBoxX + this.aboutDescBoxPadding
	aboutDescriptionY := this.aboutDescBoxY + 38

	aboutChrCountW := this.aboutDescriptionW
	aboutChrCountH := (18 * 5) + 5
	aboutChrCountX := this.aboutDescriptionX
	aboutChrCountY := (this.aboutDescBoxY + this.aboutDescBoxH) - this.aboutChrCountH - 14

	aboutSampleWordsW := this.w - (this.aboutDescBoxX + this.aboutDescBoxW) - 30
	aboutSampleWordsH := this.defaultGrpH
	aboutSampleWordsX := this.aboutDescBoxX + this.aboutDescBoxW + 10
	aboutSampleWordsY := this.defaultGrpY

	aboutSampleWordsContentX := this.aboutSampleWordsX + 14
	aboutSampleWordsContentY := this.aboutSampleWordsY + 30
	aboutSampleWordsContentW := (this.aboutSampleWordsX + this.aboutSampleWordsW) - this.aboutSampleWordsContentX - 16
	aboutSampleWordsContentH := this.aboutSampleWordsH - 40


	__New() {
		this.Constructor()
		Event.OnEvent("UI Data", "Changed", () => this.setCached := False)
		Event.OnEvent("UI Language", "Switched", () => this.setCached := False)
		return
	}

	Constructor() {
		local screenWidth := A_ScreenWidth
		local screenHeight := A_ScreenHeight

		for res in this.resolutions {
			if screenHeight = res[1] && screenWidth > res[2] {
				screenWidth := res[2]
				break
			}
		}

		this.xPos := screenWidth - this.w - 50
		this.yPos := screenHeight - this.h - 92

		this.title := App.Title("+status+version") " — " Locale.Read("dictionary.about")

		local aboutWindow := Gui()
		aboutWindow.Title := this.title

		local background := aboutWindow.AddText(Format("vBackground BackgroundWhite x{} y{} w{} h{}", this.bgX, this.bgY, this.bgW, this.bgH))

		local aboutLeftPanel := aboutWindow.AddGroupBox(Format("vAboutLeftPanel BackgroundWhite x{} y{} w{} h{}", this.aboutLeftPanelX, this.aboutLeftPanelY, this.aboutLeftPanelW, this.aboutLeftPanelH))

		local aboutLeftPanelFrame := aboutWindow.AddGroupBox(Format("vAboutLeftPanelFrame BackgroundWhite x{} y{} w{} h{}", this.aboutLeftPanelFrameX, this.aboutLeftPanelFrameY, this.aboutLeftPanelFrameW, this.aboutLeftPanelFrameH))

		local aboutLeftIcon := aboutWindow.AddPicture(Format("vAboutLeftIcon BackgroundWhite x{} y{} w{} h{}", this.aboutLeftIconX, this.aboutLeftIconY, this.aboutLeftIconW, this.aboutLeftIconH), App.ICONS_DLL)

		local aboutTitle := aboutWindow.AddText(Format("vAboutTitle BackgroundWhite x{} y{} w{} h{} Center", this.aboutTitleX, this.aboutTitleY, this.aboutTitleW, this.aboutTitleH), App.Title())

		local aboutVersion := aboutWindow.AddText(Format("vAboutVersion BackgroundWhite x{} y{} w{} h{} Center", this.aboutVersionX, this.aboutVersionY, this.aboutVersionW, this.aboutVersionH), App.Ver())

		local aboutRepoLink := aboutWindow.AddText(Format("vAboutRepoLink BackgroundWhite  x{} y{} w{} h{} c5088c8 Center", this.aboutRepoLinkX, this.aboutRepoLinkY, this.aboutRepoLinkW, this.aboutRepoLinkH), Locale.Read("dictionary.repository"))

		local aboutAuthor := aboutWindow.AddText(Format("vAboutAuthor BackgroundTrans x{} y{} w{} h{} Center", this.aboutAuthorX, this.aboutAuthorY, this.aboutAuthorW, this.aboutAuthorH), Locale.Read("gui.about.author_name"))

		local chrCount := Format(Locale.Read("gui.about.library_count"),
			ChrLib.countOf.entries,
			ChrLib.countOf.glyphVariations,
			ChrLib.countOf.allKeys,
			ChrLib.countOf.fastKeys,
			ChrLib.countOf.recipes,
			ChrLib.countOf.uniqueRecipes,
			ChrLib.countOf.userRecipes,
			ChrLib.countOf.uniqueUserRecipes
		)

		local aboutDescBox := aboutWindow.AddGroupBox(Format("vAboutDescBox BackgroundWhite x{} y{} w{} h{}", this.aboutDescBoxX, this.aboutDescBoxY, this.aboutDescBoxW, this.aboutDescBoxH), App.Title(["decoded"]))

		local aboutDescription := aboutWindow.AddText(Format("vAboutDescription BackgroundWhite x{} y{} w{} h{}", this.aboutDescriptionX, this.aboutDescriptionY, this.aboutDescriptionW, this.aboutDescriptionH), Locale.ReadInject("gui.about.description", [App.Ver("+hotfix+postfix") " " App.Title(["status"])]))

		local aboutChrCount := aboutWindow.AddText(Format("vAboutChrCount BackgroundWhite x{} y{} w{} h{}", this.aboutChrCountX, this.aboutChrCountY, this.aboutChrCountW, this.aboutChrCountH), chrCount)

		local aboutSampleWords := aboutWindow.AddGroupBox(Format("vAboutSampleWords BackgroundWhite x{} y{} w{} h{}", this.aboutSampleWordsX, this.aboutSampleWordsY, this.aboutSampleWordsW, this.aboutSampleWordsH))

		local aboutSampleWordsContent := aboutWindow.AddText(Format("vAboutSampleWordsContent BackgroundWhite x{} y{} w{} h{}", this.aboutSampleWordsContentX, this.aboutSampleWordsContentY, this.aboutSampleWordsContentW, this.aboutSampleWordsContentH), Locale.Read("about.scripts_words", "default"))

		aboutTitle.SetFont("s18 c333333", this.fontFamily)
		aboutVersion.SetFont("s11 c333333", this.fontFamily)
		aboutRepoLink.SetFont("s11", this.fontFamily)
		aboutAuthor.SetFont("s11 c333333", this.fontFamily)
		aboutDescBox.SetFont("s11 c333333", this.fontFamily)
		aboutDescription.SetFont("s11 c333333", this.fontFamily)
		aboutChrCount.SetFont("s10 c333333", this.fontFamily)
		aboutSampleWordsContent.SetFont("s11 c555555", this.fontFamily)

		aboutRepoLink.OnEvent("Click", (*) => Run(Locale.Read("gui.about.repository_url")))
		return aboutWindow
	}

	Show() {
		if this.title != "" && WinExist(this.title) {
			WinActivate(this.title)
		} else {

			if !this.setCached
				this.GUI := this.Constructor()
			this.GUI.Show(Format("w{} h{} x{} y{}", this.w, this.h, this.xPos, this.yPos))

			this.setCached := True
		}
		return
	}
}