Class TooltipPresets {
	static presetList := Map(
		"Compose", [
			[(*) => Format("norm s{}", Cfg.Get("Font_Size", "Compose", 12, "int")), (*) => Cfg.Get("Font_Name", "Compose", "Noto Sans")],
			[(*) => Cfg.Get("Background_Color", "Compose", "White"), (*) => Cfg.Get("Font_Color", "Compose", "333333")],
			[4, 4, 4, 4]
		],
		"Compose Success", [
			[(*) => Format("bold s{}", Cfg.Get("Font_Size", "Compose", 12, "int")), (*) => Cfg.Get("Font_Name", "Compose", "Noto Sans")],
			["00cb00", "eeeeee"],
			[4, 4, 4, 4]
		],
		"Compose Cancelled", [
			[(*) => Format("bold s{}", Cfg.Get("Font_Size", "Compose", 12, "int")), (*) => Cfg.Get("Font_Name", "Compose", "Noto Sans")],
			["3c63f3", "eeeeee"],
			[4, 4, 4, 4]
		],
		"Compose Absent", [
			[(*) => Format("bold s{}", Cfg.Get("Font_Size", "Compose", 12, "int")), (*) => Cfg.Get("Font_Name", "Compose", "Noto Sans")],
			["f7d810", "333333"],
			[4, 4, 4, 4]
		],
		"TELEX", [
			[(*) => Format("norm s{}", Cfg.Get("Font_Size", "Compose", 12, "int")), (*) => Cfg.Get("Font_Name", "Compose", "Noto Sans")],
			[(*) => Cfg.Get("Background_Color", "Compose", "White"), (*) => Cfg.Get("Font_Color", "Compose", "333333")],
			[4, 4, 4, 4]
		],
		"Default", [
			["norm s8", "Noto Sans"],
			["White", "333333"],
			[2, 2, 2, 2]
		]
	)

	static selected := "Default"

	static Select(presetName := "Default") {
		ToolTipOptions.Reset()
		TooltipOptions.Init()

		local options := this.presetList.Get(presetName).DeepClone()
		options := {
			font: options[1],
			colors: options[2],
			margins: options[3]
		}

		for propName in options.OwnProps() {
			for i, each in options.%propName% {
				if each is Func
					options.%propName%[i] := each()
			}
		}

		ToolTipOptions.SetFont(options.font*)
		ToolTipOptions.SetColors(options.colors*)
		ToolTipOptions.SetMargins(options.margins*)

		this.selected := presetName
		return
	}
}