Class BindList {
	mapping := []

	__New(mapping := Map(), modMapping := Map()) {
		this.mapping := mapping.Clone()

		if modMapping.Count > 0 {
			for letterKey, binds in modMapping {
				for modifier, value in binds {
					this.mapping.Set(modifier "[" letterKey "]", value)
				}
			}
		}

		return this
	}
}

importantBindsMap := Map("Flat", Map(
	"RAlt", (*) => ProceedCompose(),
), "Moded", Map(
	; Functional
	"F1", Map(
		"<#<!", (*) => GroupActivator("Diacritics Primary", "F1"),
		"<^>!", (*) => KeyboardBinder.ToggleDefaultMode(),
		"<^>!>+", (*) => ToggleInputMode(),
	),
	"F2", Map(
		"<#<!", (*) => GroupActivator("Diacritics Secondary", "F2"),
		"<^>!", (*) => InputScriptProcessor(),
		"<^>!>+", (*) => InputScriptProcessor("pinYin"),
		"<^>!<+", (*) => InputScriptProcessor("karaShiki"),
		"<^>!<!", (*) => InputScriptProcessor("autoDiacritics"),
	),
	"F2", Map(
		"<#<!", (*) => GroupActivator("Diacritics Tertiary", "F3"),
	),
	"F6", Map(
		"<#<!", (*) => GroupActivator("Diacritics Quatemary", "F6"),
	),
	"F7", Map(
		"<#<!", (*) => GroupActivator("Special Characters", "F7"),
	),
	"PgUp", Map("<#<!", (*) => FindCharacterPage(),),
	"Home", Map("<#<!", (*) => Panel.Panel(), "<^>!<#<!", (*) => OpenPanel()),
	"Space", Map("<#<!", (*) => GroupActivator("Spaces"),),
	"Hyphen-minus", Map("<#<!", (*) => GroupActivator("Dashes", "-"),),
	"Apostrophe", Map("<#<!", (*) => GroupActivator("Quotes", "'"),),
	"NumpadAdd", Map("<#<!", (*) => CharacterInserter().NumHook()),
	"NumHook", Map("<#<!", (*) => CharacterInserter("Altcode").NumHook()),
	"A", Map("<#<!", (*) => CharacterInserter("Altcode").InputDialog(),),
	"F", Map("<#<!", (*) => ChrLib.SearchPrompt().send(),),
	"H", Map(
		">^", (*) => TranslateSelectionToHTML("Entities"),
		">^>+", (*) => TranslateSelectionToHTML(),
	),
	"J", Map(
		">^", (*) => TranslateSelectionToHTML("Entities", True),
	),
	"L", Map("<#<!", (*) => ChrCrafter(),),
	"M", Map("<#<!", (*) => ToggleGroupMessage()),
	"U", Map(
		"<#<!", (*) => CharacterInserter("Unicode").InputDialog(),
		">^", (*) => ReplaceWithUnicode(),
		">^", (*) => ReplaceWithUnicode("CSS"),
		">^", (*) => ReplaceWithUnicode("Hex"),
	),
))

defaultBinds := Map(
	"Flat", Map(
		"NumpadSub", "minus",
		"NumpadDiv", "division",
		"NumpadMult", "multiplication"
	),
	"Moded", Map(
		; Latin-Modifiers Keyboard Layout
		"A", Map(
			"<!", ["lat_c_let_a__acute", "lat_s_let_a__acute"],
			"<^>!", ["lat_c_let_a__breve", "lat_s_let_a__breve"],
			"<^>!<!", ["lat_c_let_a__circumflex", "lat_s_let_a__circumflex"],
			"<^>!<!<+", ["lat_c_let_a__ring_above", "lat_s_let_a__ring_above"],
			"<^>!<!>+", ["lat_c_let_a__ogonek", "lat_s_let_a__ogonek"],
			"<^>!>+", ["lat_c_let_a__macron", "lat_s_let_a__macron"],
			"<^>!<+", ["lat_c_let_a__diaeresis", "lat_s_let_a__diaeresis"],
			"<^>!<+>+", ["lat_c_let_a__tilde", "lat_s_let_a__tilde"],
			">+", ["lat_c_let_a__grave", "lat_s_let_a__grave"],
			"<+>+", ["lat_c_let_a__grave_double", "lat_s_let_a__grave_double"]),
		"B", Map(
			"<^>!", ["lat_c_let_b__dot_above", "lat_s_let_b__dot_above"],
			"<^>!<!", ["lat_c_let_b__dot_below", "lat_s_let_b__dot_below"],
			"<^>!<!<+", ["lat_c_let_b__flourish", "lat_s_let_b_flourish"],
			"<^>!<+", ["lat_c_let_b__stroke_short", "lat_s_let_b_stroke_short"],
			"<^>!>+", ["lat_c_let_b__common_hook", "lat_s_let_b__common_hook"]),
		"C", Map("<!", ["lat_c_let_c__acute", "lat_s_let_c__acute"],
			"<^>!", ["lat_c_let_c__dot_above", "lat_s_let_c__dot_above"],
			"<^>!<!", ["lat_c_let_c__circumflex", "lat_s_let_c__circumflex"],
			"<^>!<!<+", ["lat_c_let_c__caron", "lat_s_let_c__caron"],
			"<^>!<!>+", ["lat_c_let_c__cedilla", "lat_s_let_c__cedilla"],
			">+", "celsius"),
		"D", Map(
			"<^>!", ["lat_c_let_d_eth", "lat_s_let_d_eth"],
			"<^>!<!", ["lat_c_let_d__stroke_short", "lat_s_let_d__stroke_short"],
			"<^>!<!<+", ["lat_c_let_d__caron", "lat_s_let_d__caron"],
			"<^>!<!>+", ["lat_c_let_d__cedilla", "lat_s_let_d__cedilla"],
			"<^>!<+>+", ["lat_c_let_d__circumflex_below", "lat_s_let_d__circumflex_below"]),
		"E", Map("<!", ["lat_c_let_e__acute", "lat_s_let_e__acute"],
			"<^>!", ["lat_c_let_schwa", "lat_s_let_schwa"],
			"<^>!<!", ["lat_c_let_e__circumflex", "lat_s_let_e__circumflex"],
			"<^>!<!<+", ["lat_c_let_e__caron", "lat_s_let_e__caron"],
			"<^>!<!>+", ["lat_c_let_e__ogonek", "lat_s_let_e__ogonek"],
			"<^>!>+", ["lat_c_let_e__macron", "lat_s_let_e__macron"],
			"<^>!<+", ["lat_c_let_e__diaeresis", "lat_s_let_e__diaeresis"],
			"<^>!<+>+", ["lat_c_let_e__tilde", "lat_s_let_e__tilde"],
			">+", ["lat_c_let_e__grave", "lat_s_let_e__grave"],
			"<+>+", ["lat_c_let_e__grave_double", "lat_s_let_e__grave_double"]),
		"F", Map(
			"<^>!", ["lat_c_let_f__dot_above", "lat_s_let_f__dot_above"],
			">+", "fahrenheit"),
		"G", Map("<!", ["lat_c_let_g_acute", "lat_s_let_g_acute"],
			"<^>!", ["lat_c_let_g_breve", "lat_s_let_g_breve"],
			"<^>!<!", ["lat_c_let_g_circumflex", "lat_s_let_g_circumflex"],
			"<^>!<!<+", ["lat_c_let_g_caron", "lat_s_let_g_caron"],
			"<^>!<!>+", ["lat_c_let_g_cedilla", "lat_s_let_g_cedilla"],
			"<^>!<+", ["lat_c_let_g_insular", "lat_s_let_g_insular"],
			"<^>!>+", ["lat_c_let_g_macron", "lat_s_let_g_macron"],
			"<^>!<+>+", ["lat_c_let_gamma", "lat_s_let_gamma"],
			">+", ["lat_c_let_g_dot_above", "lat_s_let_g_dot_above"]),
		"H", Map(
			"<!", ["lat_c_let_h_hwair", "lat_s_let_h_hwair"],
			"<^>!", ["lat_c_let_h_stroke_short", "lat_s_let_h_stroke_short"],
			"<^>!<!", ["lat_c_let_h_circumflex", "lat_s_let_h_circumflex"],
			"<^>!<!<+", ["lat_c_let_h_caron", "lat_s_let_h_caron"],
			"<^>!<!>+", ["lat_c_let_h_cedilla", "lat_s_let_h_cedilla"],
			"<^>!<+", ["lat_c_let_h_diaeresis", "lat_s_let_h_diaeresis"]),
		"I", Map("<!", ["lat_c_let_i_acute", "lat_s_let_i_acute"],
			"<^>!", ["lat_c_let_i_breve", "lat_s_let_i_breve"],
			"<^>!<!", ["lat_c_let_i_circumflex", "lat_s_let_i_circumflex"],
			"<^>!<!<+", ["lat_c_let_i_caron", "lat_s_let_i_caron"],
			"<^>!<!>+", ["lat_c_let_i_ogonek", "lat_s_let_i_ogonek"],
			"<^>!>+", ["lat_c_let_i_macron", "lat_s_let_i_macron"],
			"<^>!<+", ["lat_c_let_i_diaeresis", "lat_s_let_i_diaeresis"],
			"<^>!<+>+", ["lat_c_let_i_tilde", "lat_s_let_i_tilde"],
			">+", ["lat_c_let_i_grave", "lat_s_let_i_grave"],
			"<+>+", ["lat_c_let_i_grave_double", "lat_s_let_i_grave_double"],
			"<^>!<!<+>+", ["lat_c_let_i_dot_above", "lat_s_let_i_dotless"]),
		"J", Map(
			"<^>!", ["lat_c_let_j_stroke_short", "lat_s_let_j_stroke_short"],
			"<^>!>+", ["lat_c_let_j_yogh", "lat_s_let_j_yogh"],
			"<^>!<!", ["lat_c_let_j_circumflex", "lat_s_let_j_circumflex"],
			"<^>!<!<+", ["lat_c_let_j", "lat_s_let_j_caron"],
		),
		"K", Map("<!", ["lat_c_let_k_acute", "lat_s_let_k_acute"],
			"<^>!<!", ["lat_c_let_k_dot_below", "lat_s_let_k_dot_below"],
			"<^>!<!<+", ["lat_c_let_k_caron", "lat_s_let_k_caron"],
			"<^>!<!>+", ["lat_c_let_k_cedilla", "lat_s_let_k_cedilla"],
			"<^>!<+", ["lat_c_let_k_cuatrillo", "lat_s_let_k_cuatrillo"],
			">+", "kelvin"
		),
		"L", Map(
			"<!", ["lat_c_let_l_acute", "lat_s_let_l_acute"],
			"<^>!", ["lat_c_let_l_solidus_short", "lat_s_let_l_solidus_short"],
			"<^>!<!<+", ["lat_c_let_l_caron", "lat_s_let_l_caron"],
			"<^>!<!>+", ["lat_c_let_l_cedilla", "lat_s_let_l_cedilla"],
			"<^>!<+>+", ["lat_c_let_l_circumflex_below", "lat_s_let_l_circumflex_below"]),
		"M", Map("<!", ["lat_c_let_m_acute", "lat_s_let_m_acute"],
			"<^>!", ["lat_c_let_m_dot_above", "lat_s_let_m_dot_above"],
			"<^>!<!", ["lat_c_let_m_dot_below", "lat_s_let_m_dot_below"],
			"<^>!>+", ["lat_c_let_m_common_hook", "lat_s_let_m_common_hook"]),
		"N", Map("<!", ["lat_c_let_n_acute", "lat_s_let_n_acute"],
			"<^>!", ["lat_c_let_n_tilde", "lat_s_let_n_tilde"],
			"<^>!<!", ["lat_c_let_n_dot_below", "lat_s_let_n_dot_below"],
			"<^>!<!<+", ["lat_c_let_n_caron", "lat_s_let_n_caron"],
			"<^>!<!>+", ["lat_c_let_n_cedilla", "lat_s_let_n_cedilla"],
			"<^>!>+", ["lat_c_let_n_common_hook", "lat_s_let_n_common_hook"],
			"<^>!<+", ["let_c_let_n_descender", "let_s_let_n_descender"],
			"<^>!<+>+", ["lat_c_let_n_dot_above", "lat_s_let_n_dot_above"],
			">+", ["lat_c_let_n_grave", "lat_s_let_n_grave"]),
		"O", Map("<!", ["lat_c_let_o_acute", "lat_s_let_o_acute"],
			"<^>!", ["lat_c_let_o_solidus_long", "lat_s_let_o_solidus_long"],
			"<^>!<!", ["lat_c_let_o_circumflex", "lat_s_let_o_circumflex"],
			"<^>!<!<+", ["lat_c_let_o_caron", "lat_s_let_o_caron"],
			"<^>!<!>+", ["lat_c_let_o_ogonek", "lat_s_let_o_ogonek"],
			"<^>!>+", ["lat_c_let_o_macron", "lat_s_let_o_macron"],
			"<^>!<+", ["lat_c_let_o_diaeresis", "lat_s_let_o_diaeresis"],
			"<^>!<+>+", ["lat_c_let_o_tilde", "lat_s_let_o_tilde"],
			">+", ["lat_c_let_o_grave", "lat_s_let_o_grave"],
			"<+>+", ["lat_c_let_o_grave_double", "lat_s_let_o_grave_double"],
			"<^>!<!<+>+", ["lat_c_let_o_acute_double", "lat_s_let_o_acute_double"]),
		"P", Map("<!", ["lat_c_let_p_acute", "lat_s_let_p_acute"],
			"<^>!", ["lat_c_let_p_dot_above", "lat_s_let_p_dot_above"],
			"<^>!<!", ["lat_c_let_p_squirrel_tail", "lat_s_let_p_squirrel_tail"],
			"<^>!<!<+", ["lat_c_let_p_flourish", "lat_s_let_p_flourish"],
			"<^>!<+", ["lat_c_let_p_stroke_short", "lat_s_let_p_stroke_short"],
			"<^>!>+", ["lat_c_let_p_common_hook", "lat_s_let_p_common_hook"]),
		"Q", Map(
			"<^>!<+", ["lat_c_let_q_tresillo", "lat_s_let_q_tresillo"],
			"<^>!>+", ["lat_c_let_q_common_hook", "lat_s_let_q_common_hook"]),
		"R", Map("<!", ["lat_c_let_r_acute", "lat_s_let_r_acute"],
			"<^>!", ["lat_c_let_r_dot_above", "lat_s_let_r_dot_above"],
			"<^>!<!", ["lat_c_let_r_dot_below", "lat_s_let_r_dot_below"],
			"<^>!<!<+", ["lat_c_let_r_caron", "lat_s_let_r_caron"],
			"<^>!<!>+", ["lat_c_let_r_cedilla", "lat_s_let_r_cedilla"],
			"<^>!<+", ["lat_c_let_yr", "lat_s_let_yr"],
			"<^>!>+", ["lat_c_let_r_rotunda", "lat_s_let_r_rotunda"],
			"<+>+", ["lat_c_let_r_grave_double", "lat_s_let_r_grave_double"]),
		"S", Map("<!", ["lat_c_let_s_acute", "lat_s_let_s_acute"],
			"<^>!", ["lat_c_let_s_comma_below", "lat_s_let_s_comma_below"],
			"<^>!<!", ["lat_c_let_s_circumflex", "lat_s_let_s_circumflex"],
			"<^>!<!<+", ["lat_c_let_s_caron", "lat_s_let_s_caron"],
			"<^>!<!>+", ["lat_c_let_s_cedilla", "lat_s_let_s_cedilla"],
			"<^>!>+", "lat_s_let_s_long",
			"<^>!<+>+", ["lat_c_let_s_sigma", "lat_s_let_s_sigma"],
			"<^>!<+", ["lat_c_lig_s_eszett", "lat_s_lig_s_eszett"]),
		"T", Map(
			"<^>!", ["lat_c_let_t_comma_below", "lat_s_let_t_comma_below"],
			"<^>!<!", ["lat_c_let_t_dot_below", "lat_s_let_t_dot_below"],
			"<^>!<!<+", ["lat_c_let_t_caron", "lat_s_let_t_caron"],
			"<^>!<!>+", ["lat_c_let_t_cedilla", "lat_s_let_t_cedilla"],
			"<^>!>+", ["lat_c_let_t_thorn", "lat_s_let_t_thorn"],
			"<^>!<+", ["lat_c_let_t_dot_above", "lat_s_let_t_dot_above"],
			"<^>!<+>+", ["lat_c_let_et_tironian", "lat_s_let_et_tironian"]),
		"U", Map(
			"<!", ["lat_c_let_u_acute", "lat_s_let_u_acute"],
			"<^>!", ["lat_c_let_u_breve", "lat_s_let_u_breve"],
			"<^>!<!", ["lat_c_let_u_circumflex", "lat_s_let_u_circumflex"],
			"<^>!<!<+", ["lat_c_let_u_ring_above", "lat_s_let_u_ring_above"],
			"<^>!<!>+", ["lat_c_let_u_ogonek", "lat_s_let_u_ogonek"],
			"<^>!>+", ["lat_c_let_u_macron", "lat_s_let_u_macron"],
			"<^>!<+", ["lat_c_let_u_diaeresis", "lat_s_let_u_diaeresis"],
			"<^>!<+>+", ["lat_c_let_u_tilde", "lat_s_let_u_tilde"],
			">+", ["lat_c_let_u_grave", "lat_s_let_u_grave"],
			"<+>+", ["lat_c_let_u_grave_double", "lat_s_let_u_grave_double"],
			"<^>!<!<+>+", ["lat_c_let_u_acute_double", "lat_s_let_u_acute_double"]),
		"V", Map(
			"<^>!", ["lat_c_let_v_solidus_long", "lat_s_let_v_solidus_long"],
			"<^>!<!", ["lat_c_let_v_dot_below", "lat_s_let_v_dot_below"],
			"<^>!<+", ["lat_c_let_v_middle_welsh", "lat_s_let_v_middle_welsh"],
			"<^>!>+", ["lat_c_let_vend", "lat_s_let_vend"],
			"<^>!<+>+", ["lat_c_let_v_tilde", "lat_s_let_v_tilde"]),
		"W", Map("<!", ["lat_c_let_w_acute", "lat_s_let_w_acute"],
			"<^>!", ["lat_c_let_w_dot_above", "lat_s_let_w_dot_above"],
			"<^>!<!", ["lat_c_let_w_circumflex", "lat_s_let_w_circumflex"],
			"<^>!<!<+", ["lat_c_let_w_dot_below", "lat_s_let_w_dot_below"],
			"<^>!<+", ["lat_c_let_w_diaeresis", "lat_s_let_w_diaeresis"],
			"<^>!>+", ["lat_c_let_w_wynn", "lat_s_let_w_wynn"],
			"<^>!<!>+", ["lat_c_let_w_anglicana", "lat_s_let_w_anglicana"],
			">+", ["lat_c_let_w_grave", "lat_s_let_w_grave"]),
		"X", Map(
			"<^>!", ["lat_c_let_x_dot_above", "lat_s_let_x_dot_above"],
			"<^>!<+", ["lat_c_let_x_diaeresis", "lat_s_let_x_diaeresis"]),
		"Y", Map("<!", ["lat_c_let_y_acute", "lat_s_let_y_acute"],
			"<^>!", ["lat_c_let_y_dot_above", "lat_s_let_y_dot_above"],
			"<^>!<!", ["lat_c_let_y_circumflex", "lat_s_let_y_circumflex"],
			"<^>!<!<+", ["lat_c_let_y_stroke_short", "lat_s_let_y_stroke_short"],
			"<^>!<!>+", ["lat_c_let_y_loop", "lat_s_let_y_loop"],
			"<^>!>+", ["lat_c_let_y_macron", "lat_s_let_y_macron"],
			"<^>!<+", ["lat_c_let_y_diaeresis", "lat_s_let_y_diaeresis"],
			"<^>!<+>+", ["lat_c_let_y_tilde", "lat_s_let_y_tilde"],
			">+", ["lat_c_let_y_grave", "lat_s_let_y_grave"]),
		"Z", Map("<!", ["lat_c_let_z_acute", "lat_s_let_z_acute"],
			"<^>!", ["lat_c_let_z_dot_above", "lat_s_let_z_dot_above"],
			"<^>!<!", ["lat_c_let_z_circumflex", "lat_s_let_z_circumflex"],
			"<^>!<!<+", ["lat_c_let_z_caron", "lat_s_let_z_caron"],
			"<^>!>+", ["lat_c_let_z_ezh", "lat_s_let_z_ezh"],
			"<^>!<+", ["lat_c_let_z_stroke_short", "lat_s_let_z_stroke_short"]),
		; Russian-Modifiers Keyboard Layout
		"А", Map(
			"<^>!", ["cyr_c_let_a_breve", "cyr_s_let_a_breve"],
			"<^>!<+", ["cyr_c_let_a_diaeresis", "cyr_s_let_a_diaeresis"],
			"<^>!>+", ["cyr_c_let_i_macron", "cyr_s_let_i_macron"],
			"<^>!<!<+>+", ["cyr_c_let_iota", "cyr_s_let_iota"]
		),
		"Б", Map(
			"<!", ["", ""],
			"<^>!", ["", ""],
			"<^>!<+", ["", ""],
			"<^>!>+", ["", ""],
			"<^>!<+>+", ["", ""],
			"<^>!<!", ["", ""],
			"<^>!<!<+", ["", ""],
			"<^>!<!>+", ["", ""],
			"<^>!<!<+>+", ["", ""],
		),
		"В", Map(),
		"Г", Map(
			"<!", ["cyr_c_let_g_acute", "cyr_s_let_g_acute"],
			"<^>!", ["cyr_c_let_g_upturn", "cyr_s_let_g_upturn"],
			"<^>!<+", ["cyr_c_let_g_stroke_short", "cyr_s_let_g_stroke_short"],
			"<^>!<!", ["cyr_c_let_g_descender", "cyr_s_let_g_descender"],
		),
		"Д", Map(),
		"Е", Map(
			"<!", ["cyr_c_let_e_breve", "cyr_s_let_e_breve"],
			">+", ["cyr_c_let_e_grave", "cyr_s_let_e_grave"],
			"<^>!", ["cyr_c_let_yat", "cyr_s_let_yat"],
			"<^>!<!", ["cyr_c_let_izhitsa", "cyr_s_let_izhitsa"]
		),
		"Ё", Map(),
		"Ж", Map(
			"<!", ["cyr_c_let_zhe_breve", "cyr_s_let_zhe_breve"],
			"<^>!", ["cyr_c_let_dzhe", "cyr_s_let_dzhe"],
			"<^>!<+", ["cyr_c_let_zhe_diaeresis", "cyr_s_let_zhe_diaeresis"],
			"<^>!>+", ["cyr_c_let_dje", "cyr_s_let_dje"],
			"<^>!<!", ["cyr_c_let_zhe_descender", "cyr_s_let_zhe_descender"],
		),
		"З", Map(
			"<^>!", ["cyr_c_let_dze", "cyr_s_let_dze"],
			"<^>!>+", ["cyr_c_let_zemlya", "cyr_s_let_zemlya"],
			"<^>!<+", ["cyr_c_let_z_diaeresis", "cyr_s_let_z_diaeresis"],
			"<^>!<!", ["cyr_c_let_z_descender", "cyr_s_let_z_descender"],
		),
		"И", Map(
			"<^>!", ["cyr_c_let_i_decimal", "cyr_s_let_i_decimal"],
			"<^>!<+", ["cyr_c_let_i_diaeresis", "cyr_s_let_i_diaeresis"],
			"<^>!>+", ["cyr_c_let_i_macron", "cyr_s_let_i_macron"],
			"<^>!<!", ["cyr_c_let_izhitsa", "cyr_s_let_izhitsa"],
			"<^>!<!<+>+", ["cyr_c_let_iota", "cyr_s_let_iota"]
		),
		"Й", Map(
			"<^>!", ["cyr_c_let_yi", "cyr_s_let_yi"],
			"<^>!<!", ["cyr_c_let_j", "cyr_s_let_j"],
			"<^>!<!>+", ["cyr_c_let_i_breve_tail", "cyr_s_let_i_breve_tail"],
		),
		"К", Map(
			"<!", ["cyr_c_let_k_acute", "cyr_s_let_k_acute"],
			"<^>!", ["cyr_c_let_ksi", "cyr_s_let_ksi"],
			"<^>!<!", ["cyr_c_let_k_descender", "cyr_s_let_k_descender"],
		),
		"Л", Map(
			"<^>!<!", ["cyr_c_let_l_descender", "cyr_s_let_l_descender"],
			"<^>!<!>+", ["cyr_c_let_l_tail", "cyr_s_let_l_tail"],
			"<^>!<!<+", ["cyr_c_let_palochka", "cyr_s_let_palochka"]
		),
		"М", Map(
			"<^>!<!<+>+", ["cyr_c_let_m_tail", "cyr_s_let_m_tail"]
		),
		"Н", Map(
			"<^>!", ["cyr_c_let_nje", "cyr_s_let_nje"],
			"<^>!<!", ["cyr_c_let_n_descender", "cyr_s_let_n_descender"],
			"<^>!<!>+", ["cyr_c_let_n_tail", "cyr_s_let_n_tail"],
		),
		"О", Map(
			"<^>!", ["cyr_c_let_omega", "cyr_s_let_omega"],
			"<^>!<+", ["cyr_c_let_o_diaeresis", "cyr_s_let_o_diaeresis"]
		),
		"П", Map(
			"<^>!", ["cyr_c_let_psi", "cyr_s_let_psi"],
			"<^>!<!", ["cyr_c_let_p_descender", "cyr_s_let_p_descender"]
		),
		"Р", Map(),
		"С", Map(
			"<^>!<!", ["cyr_c_let_s_descender", "cyr_s_let_s_descender"]
		),
		"Т", Map(
			"<^>!", ["cyr_c_let_tje", "cyr_s_let_tje"],
			"<^>!<!", ["cyr_c_let_t_descender", "cyr_s_let_t_descender"]
		),
		"У", Map(
			"<!", ["cyr_c_let_u_breve", "cyr_s_let_u_breve"],
			"<^>!", ["cyr_c_let_yus_big", "cyr_s_let_yus_big"],
			"<^>!<+", ["cyr_c_let_u_diaeresis", "cyr_s_let_u_diaeresis"],
			"<^>!>+", ["cyr_c_let_u_macron", "cyr_s_let_u_macron"],
			"<^>!<!", ["cyr_c_let_uk_monograph", "cyr_s_let_uk_monograph"],
		),
		"Ф", Map(
			"<^>!", ["cyr_c_let_fita", "cyr_s_let_fita"]
		),
		"Х", Map(
			"<^>!", ["cyr_c_let_shha", "cyr_s_let_shha"],
			"<^>!<!", ["cyr_c_let_h_descender", "cyr_s_let_h_descender"],
		),
		"Ц", Map(),
		"Ч", Map(
			"<^>!", ["cyr_c_let_tshe", "cyr_s_let_tshe"],
			"<^>!<+", ["cyr_c_let_ch_diaeresis", "cyr_s_let_ch_diaeresis"],
			"<^>!<!", ["cyr_c_let_ch_descender", "cyr_s_let_ch_descender"],
			"<^>!<!<+", ["cyr_c_let_djerv", "cyr_s_let_djerv"],
		),
		"Ш", Map(),
		"Щ", Map(),
		"Ъ", Map(
			"<^>!", ["cyr_c_let_u_straight", "cyr_s_let_u_straight"],
			"<^>!>+", ["cyr_c_let_u_straight_stroke_short", "cyr_s_let_u_straight_stroke_short"],
		),
		"Ы", Map(
			"<^>!", ["cyr_c_let_yeru_back_yer", "cyr_s_let_yeru_back_yer"],
			"<^>!<!", ["cyr_c_let_yn", "cyr_s_let_yn"],
			"<^>!<+", ["cyr_c_let_yery_diaeresis", "cyr_s_let_yery_diaeresis"]
		),
		"Ь", Map(
			"<^>!<!", ["cyr_c_let_semiyeri", "cyr_s_let_semiyeri"]
		),
		"Э", Map(
			"<^>!", ["cyr_c_let_ukr_e", "cyr_s_let_ukr_e"],
			"<^>!<+", ["cyr_c_let_ye_diaeresis", "cyr_s_let_ye_diaeresis"],
			"<^>!>+", ["cyr_c_let_schwa", "cyr_s_let_schwa"],
			"<^>!<+>+", ["cyr_c_let_schwa_diaeresis", "cyr_s_let_schwa_diaeresis"],
		),
		"Ю", Map(),
		"Я", Map(
			"<^>!", ["cyr_c_let_yus_little", "cyr_s_let_yus_little"],
			"<^>!<+", ["cyr_c_let_a_iotified", "cyr_s_let_a_iotified"],
		)
	)
)

defaultBindsOptions() {
	letterI_Option := Cfg.Get("I_Dot_Shift_I_Dotless", "Characters", "Default")

	if letterI_Option = "Separated" {
		defaultBinds["Moded"]["I"].Set("<+", ["lat_c_let_i", "lat_s_let_i_dotless"])
		defaultBinds["Flat"].Set("I", ["lat_c_let_i_dot_above", "lat_s_let_i"])
	} else if letterI_Option = "Hybrid" {
		defaultBinds["Moded"]["I"].Set("<+", ["lat_c_let_i_dot_above", "lat_s_let_i_dotless"])
	}
} ;defaultBindsOptions()

importantBindsMap := BindList(importantBindsMap["Flat"], importantBindsMap["Moded"])
defaultBinds := BindList(defaultBinds["Flat"], defaultBinds["Moded"])