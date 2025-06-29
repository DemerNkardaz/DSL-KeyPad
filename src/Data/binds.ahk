bindingMaps := JSON.LoadFile(dataDir "\binds.json", "UTF-8")["entries"].DeepMergeBinds(Map(
	"Script Specified", Map(
		"Cypriot Syllabary", Map(
			"Flat", Map(
				"K", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_k_k[a,e,i,o,u]"], (*) => [], "1", True),
				"L", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_l_l[a,e,i,o,u]"], (*) => [], "1", True),
				"M", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_m_m[a,e,i,o,u]"], (*) => [], "1", True),
				"N", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_n_n[a,e,i,o,u]"], (*) => [], "1", True),
				"P", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_p_p[a,e,i,o,u]"], (*) => [], "1", True),
				"R", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_r_r[a,e,i,o,u]"], (*) => [], "1", True),
				"S", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_s_s[a,e,i,o,u]"], (*) => [], "1", True),
				"T", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O,U]", "cypriot_syllabary_n_syl_t_t[a,e,i,o,u]"], (*) => [], "1", True),
				"W", (K) => BindHandler.TimeSend(K,
					["[A,E,I,O]", "cypriot_syllabary_n_syl_w_w[a,e,i,o]"], (*) => [], "1", True),
				"X", (K) => BindHandler.TimeSend(K,
					["[A,E]", "cypriot_syllabary_n_syl_x_x[a,e]"], (*) => [], "1", True),
				"Y", (K) => BindHandler.TimeSend(K,
					["[A,O]", "cypriot_syllabary_n_syl_y_j[a,o]"], (*) => [], "1", True),
				"Z", (K) => BindHandler.TimeSend(K,
					["[A,O]", "cypriot_syllabary_n_syl_z_z[a,o]"], (*) => [], "1", True),
			),
			"Moded", Map()
		),
		"Old Persian", Map(
			"Flat", Map(
				"D", (K) => BindHandler.TimeSend(K,
					["[A,I,U]", "old_persian_n_sign_d_d[a,i,u]"],
					(*) => [], "1", True),
				"G", (K) => BindHandler.TimeSend(K,
					["[A,U]", "old_persian_n_sign_g_g[a,u]"],
					(*) => [], "1", True),
				"J", (K) => BindHandler.TimeSend(K,
					["[A,I]", "old_persian_n_sign_j_j[a,i]"],
					(*) => [], "1", True),
				"K", (K) => BindHandler.TimeSend(K,
					["[A,I,U]", "old_persian_n_sign_k_k[a,i,u]"],
					(*) => [], "1", True),
				"M", (K) => BindHandler.TimeSend(K,
					["[A,I,U]", "old_persian_n_sign_m_m[a,i,u]"],
					(*) => [], "1", True),
				"N", (K) => BindHandler.TimeSend(K,
					["[A,I,U]", "old_persian_n_sign_n_n[a,i,u]"],
					(*) => [], "1", True),
				"R", (K) => BindHandler.TimeSend(K,
					["[A,I,U]", "old_persian_n_sign_r_r[a,i,u]"],
					(*) => [], "1", True),
				"T", (K) => BindHandler.TimeSend(K,
					["[A,I,U]", "old_persian_n_sign_t_t[a,i,u]"],
					(*) => [], "1", True),
				"V", (K) => BindHandler.TimeSend(K,
					["[A,I]", "old_persian_n_sign_v_v[a,i]"],
					(*) => [], "1", True),
			),
		),
	),
	"Important", Map(
		"Moded", Map(
			"2", Map(
				"<!", (*) => BindHandler.LangCall(Map(
					"en-US", TextHandlers.ToQuote.Bind(TextHandlers,
						[ChrLib.Get("quote_left_double"), ChrLib.Get("quote_right_double")],
						[ChrLib.Get("quote_left"), ChrLib.Get("quote_right")]
					),
					"ru-RU", TextHandlers.ToQuote.Bind(TextHandlers,
						[ChrLib.Get("quote_angle_left_double"), ChrLib.Get("quote_angle_right_double")],
						[ChrLib.Get("quote_left_double_ghost_ru"), ChrLib.Get("quote_right_double_ghost_ru")]
					)
				)),
			)
		)
	),
	"Common", Map(
		"Flat", Map(
			"NumpadAdd", (K) => BindHandler.TimeSend(K,
				["[NumpadSub]", "[minusplus]"]),
			"NumpadSub", (K) => BindHandler.TimeSend(K,
				["[NumpadAdd]", "[plusminus]"],
				(*) => BindHandler.Send(K, "minus")),
			"NumpadMult", (K) => BindHandler.TimeSend(K,
				["[NumpadDiv]", "[division_times]"],
				(*) => BindHandler.Send(K, "multiplication")),
			"NumpadDiv", (K) => BindHandler.TimeSend(K, Map(),
				(*) => BindHandler.Send(K, "division")),
		),
		"Moded", Map(
			"Left", Map(
				"<^>!", (K) => BindHandler.TimeSend(K,
					["[Up,Down,Right]", "arrow_[leftup,leftdown,leftright]"],
					(*) => BindHandler.Send(K, "arrow_left")),
			),
			"Right", Map(
				"<^>!", (K) => BindHandler.TimeSend(K,
					["[Up,Down,Left]", "arrow_[rightup,rightdown,leftright]"],
					(*) => BindHandler.Send(K, "arrow_right")),
			),
			"Up", Map(
				"<^>!", (K) => BindHandler.TimeSend(K,
					["[Left,Down,Right]", "arrow_[leftup,updown,rightup]"],
					(*) => BindHandler.Send(K, "arrow_up")),
			),
			"Down", Map(
				"<^>!", (K) => BindHandler.TimeSend(K,
					["[Left,Up,Right]", "arrow_[leftdown,updown,rightdown]"],
					(*) => BindHandler.Send(K, "arrow_down")),
			),
		),
	),
))