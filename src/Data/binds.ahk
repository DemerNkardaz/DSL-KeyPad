BindReg(Map(
	"Script Specified", Map(
		"Cypriot Syllabary", Map(
			"Flat", Map(
				"K", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_k_k[a,e,i,o,u]"], (*) => [], "1", True),
				"L", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_l_l[a,e,i,o,u]"], (*) => [], "1", True),
				"M", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_m_m[a,e,i,o,u]"], (*) => [], "1", True),
				"N", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_n_n[a,e,i,o,u]"], (*) => [], "1", True),
				"P", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_p_p[a,e,i,o,u]"], (*) => [], "1", True),
				"R", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_r_r[a,e,i,o,u]"], (*) => [], "1", True),
				"S", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_s_s[a,e,i,o,u]"], (*) => [], "1", True),
				"T", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_t_t[a,e,i,o,u]"], (*) => [], "1", True),
				"W", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E,I,O]", "cypriot_syllabary_n_syl_w_w[a,e,i,o]"], (*) => [], "1", True),
				"X", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,E]", "cypriot_syllabary_n_syl_x_x[a,e]"], (*) => [], "1", True),
				"Y", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,O]", "cypriot_syllabary_n_syl_y_j[a,o]"], (*) => [], "1", True),
				"Z", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,O]", "cypriot_syllabary_n_syl_z_z[a,o]"], (*) => [], "1", True),
			),
			"Moded", Map()
		),
		"Old Persian", Map(
			"Flat", Map(
				"D", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,I,U]", "old_persian_n_sign_d_d[a,i,u]"], (*) => [], "1", True),
				"G", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,U]", "old_persian_n_sign_g_g[a,u]"], (*) => [], "1", True),
				"J", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,I]", "old_persian_n_sign_j_j[a,i]"], (*) => [], "1", True),
				"K", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,I,U]", "old_persian_n_sign_k_k[a,a,u]"], (*) => [], "1", True),
				"M", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,I,U]", "old_persian_n_sign_m_m[a,i,u]"], (*) => [], "1", True),
				"N", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,U]", "old_persian_n_sign_n_n[a,u]"], (*) => [], "1", True),
				"R", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,I,U]", "old_persian_n_sign_r_r[a,a,u]"], (*) => [], "1", True),
				"T", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,I,U]", "old_persian_n_sign_t_t[a,a,u]"], (*) => [], "1", True),
				"V", BindHandler.TimeSend.Bind(BindHandler, ,
					["[A,I]", "old_persian_n_sign_v_v[a,i]"], (*) => [], "1", True),
			),
		),
	),
	"Important", Map(
		"Flat", Map(),
		"Moded", Map(
			"H", Map(
				">^", (*) => UnicodeUtils.ConvertSelectedStrToCodePoints("Entities"),
				"<^>^", (*) => UnicodeUtils.ConvertSelectedStrToCodePoints("XML4")
			),
			"J", Map(
				">^", (*) => UnicodeUtils.ConvertSelectedStrToCodePoints("Entities", , , True),
				"<^>^", (*) => UnicodeUtils.ConvertSelectedStrToCodePoints("XML4", , , True)
			),
			"Y", Map(
				">^", (*) => UnicodeUtils.ConvertSelectedStrToCodePoints("JSON", , True)
			),
			"U", Map(
				">^", (*) => UnicodeUtils.ConvertSelectedStrToCodePoints("Default", " ")
			),
			"I", Map(
				">^", (*) => UnicodeUtils.ConvertSelectedStrToCodePoints("Hex4", " ")
			),
		)
	),
	"Common", Map(
		"Flat", Map(
			"NumpadAdd", BindHandler.TimeSend.Bind(BindHandler, , ["[NumpadSub]", "[minusplus]"]),
			"NumpadSub", BindHandler.TimeSend.Bind(BindHandler, , ["[NumpadAdd]", "[plusminus]"],
				BindHandler.Send.Bind(BindHandler, , "minus")),
			"NumpadMult", BindHandler.TimeSend.Bind(BindHandler, , ["[NumpadDiv]", "[division_times]"],
				BindHandler.Send.Bind(BindHandler, , "multiplication")),
			"NumpadDiv", BindHandler.TimeSend.Bind(BindHandler, , Map(),
				BindHandler.Send.Bind(BindHandler, , "division")),
		),
		"Moded", Map(
			"Left", Map(
				"<^>!", BindHandler.TimeSend.Bind(BindHandler, ,
					["[Up,Down,Right]", "arrow_[leftup,leftdown,leftright]"],
					BindHandler.Send.Bind(BindHandler, , "arrow_left")),
			),
			"Right", Map(
				"<^>!", BindHandler.TimeSend.Bind(BindHandler, ,
					["[Up,Down,Left]", "arrow_[rightup,rightdown,leftright]"],
					BindHandler.Send.Bind(BindHandler, , "arrow_right")),
			),
			"Up", Map(
				"<^>!", BindHandler.TimeSend.Bind(BindHandler, ,
					["[Left,Down,Right]", "arrow_[leftup,updown,rightup]"],
					BindHandler.Send.Bind(BindHandler, , "arrow_up")),
			),
			"Down", Map(
				"<^>!", BindHandler.TimeSend.Bind(BindHandler, ,
					["[Left,Up,Right]", "arrow_[leftdown,updown,rightdown]"],
					BindHandler.Send.Bind(BindHandler, , "arrow_down")),
			),
		),
	),
))