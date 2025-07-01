Class FuncBindStore {
	static storedData := Map(
		"ToQuote", {
			func: BindHandler.LangCall,
			args: [
				Map(
					"en-US", TextHandlers.ToQuote.Bind(TextHandlers,
						[ChrLib.Get("quote_left_double"), ChrLib.Get("quote_right_double")],
						[ChrLib.Get("quote_left"), ChrLib.Get("quote_right")]
					),
					"ru-RU", TextHandlers.ToQuote.Bind(TextHandlers,
						[ChrLib.Get("quote_angle_left_double"), ChrLib.Get("quote_angle_right_double")],
						[ChrLib.Get("quote_left_double_ghost_ru"), ChrLib.Get("quote_right_double_ghost_ru")]
					),
					"el-GR", TextHandlers.ToQuote.Bind(TextHandlers,
						[ChrLib.Get("quote_angle_left_double"), ChrLib.Get("quote_angle_right_double")],
						[ChrLib.Get("quote_left_double"), ChrLib.Get("quote_right_double")]
					)
				),
				[ ;
					{ if: (*) => Scripter.selectedMode.Get("Alternative Modes") = "Hellenic", then: "el-GR" }, ;
				] ;
			]
		},
		"minus", {
			func: BindHandler.TimeSend,
			arrowArg: "%K%",
			args: ["%K%", ["[NumpadSub]", "[minusplus]"]]
		}
	)

	static Get(key) {
		local output := (*) => []
		local storedFunction := this.storedData.Get(key)
		if (storedFunction is Object && storedFunction.HasOwnProp("func") && storedFunction.HasOwnProp("args"))
			output := (*) => storedFunction.func(storedFunction.args*)

		return output
	}
}