bindingMaps := Map(
	"User", Map(),
	"Script Specified", Map(
		"Hellenic", Map(
			"Flat", Map(),
			"Moded", Map()
		),
		"Germanic Runes", Map(
			"Flat", Map(
				"A", ["futhark_ansuz"],
				"B", ["futhark_berkanan"],
				"C", ["futhork_cen"],
				"D", ["futhark_dagaz"],
				"E", ["futhark_ehwaz"],
				"F", ["futhark_fehu"],
				"G", ["futhark_gebo"],
				"H", ["futhark_haglaz"],
				"I", ["futhark_isaz"],
				"J", ["futhark_jeran"],
				"K", ["futhark_kauna"],
				"L", ["futhark_laguz"],
				"M", ["futhark_mannaz"],
				"N", ["futhark_naudiz"],
				"O", ["futhark_odal"],
				"P", ["futhark_pertho"],
				"Q", ["futhork_cweorth"],
				"R", ["futhark_raido"],
				"S", ["futhark_sowilo"],
				"T", ["futhark_tiwaz"],
				"U", ["futhark_uruz"],
				"V", ["futhark_younger_later_v"],
				"W", ["futhark_wunjo"],
				"X", [""],
				"Y", ["futhark_younger_ur"],
				"Z", ["futhark_algiz"],
				"Equals", ["equals"],
				"HyphenMinus", ["hyphen_minus"],
				"Dot", ["dot"],
				"Comma", ["comma"],
				"Slash", ["solidus"],
				"Backslash", ["reverse_solidus"],
				"Semicolon", ["semicolon"],
				"Apostrophe", ["apostrophe"],
				"LeftBracket", ["left_bracket"],
				"RightBracket", ["right_bracket"],
				"Tilde", ["grave_accent"],
			),
			"Moded", Map(
				"A", Map(
					"<+", ["futhork_as"],
					">+", ["futhork_aesc"],
					"<^>!", ["futhark_younger_jera"],
					"<^>!<+", ["futhark_younger_jera_short_twig"],
				),
				"B", Map(
					"<^>!<+", ["futhark_younger_bjarkan_short_twig"],
				),
				"C", Map("<^>!<!", ["medieval_c"]),
				"D", Map(
					"<^>!", ["futhark_younger_later_eth"],
					"<^>!<+", ["futhark_younger_later_d"],
					"<^<!", ["cyr_com_vzmet"],
				),
				"E", Map(
					"<+", ["futhork_ear"],
					"<^>!", ["futhark_younger_later_e"],
					"<^>!<!", ["medieval_en"],
				),
				"G", Map(
					"<+", ["futhork_gar"],
					"<^<!", ["cyr_com_palatalization"],
					"<^<!<+", ["cyr_com_pokrytie"],
					"<^<!>+", ["cyr_com_dasia_pneumata"],
					"<^<!<+>+", ["cyr_com_psili_pneumata"],
				),
				"H", Map(
					"<+", ["futhork_haegl"],
					"<^>!", ["futhark_younger_hagall"],
					"<^>!<+", ["futhark_younger_hagall_short_twig"],
				),
				"I", Map(">+", ["futhark_eihwaz"]),
				"J", Map(
					"<+", ["futhork_ger"],
					">+", ["futhork_ior"],
				),
				"K", Map(
					"<+", ["futhork_cealc"],
					">+", ["futhork_calc"],
					"<^>!", ["futhark_younger_kaun"],
				),
				"L", Map("<^>!", ["futhark_younger_later_l"]),
				"M", Map(
					"<^>!", ["futhark_younger_madr"],
					"<^>!<+", ["futhark_younger_madr_short_twig"],
				),
				"N", Map(
					">+", ["futhark_ingwaz"],
					"<+", ["futhork_ing"],
					"<^>!<+", ["futhark_younger_naud_short_twig"],
					"<^>!<!", ["medieval_en"],
				),
				"O", Map(
					"<+", ["futhork_os"],
					"<^>!", ["futhark_younger_oss"],
					"<^>!<+", ["futhark_younger_oss_short_twig"],
					"<^>!<!", ["medieval_on"],
					"<^>!<!>+", ["medieval_o"],
				),
				"P", Map("<^>!", ["futhark_younger_later_p"]),
				"S", Map(
					"<+", ["futhork_sigel"],
					">+", ["futhork_stan"],
					"<^>!<+", ["futhark_younger_sol_short_twig"],
				),
				"T", Map(
					">+", ["futhark_thurisaz"],
					"<^>!<+", ["futhark_younger_tyr_short_twig"],
				),
				"X", Map("<^>!<!", ["medieval_x"]),
				"Y", Map(
					">+", ["futhark_younger_icelandic_yr"],
					"<^>!", ["futhark_younger_yr"],
					"<^>!<+", ["futhark_younger_yr_short_twig"],
					"<+", ["futhork_yr"],
				),
				"Z", Map("<^>!<!", ["medieval_z"]),
				"Equals", Map("+", ["plus"]),
				"HyphenMinus", Map("+", ["underscore"]),
				"Slash", Map("+", ["question"]),
				"Backslash", Map("+", ["vertical_line"]),
				"Semicolon", Map("+", ["colon"]),
				"Apostrophe", Map("+", ["quote"]),
				"Tilde", Map("+", ["tilde"]),
				"LeftBracket", Map("+", ["left_brace"]),
				"RightBracket", Map("+", ["right_brace"]),
				"Comma", Map("<^>!", ["runic_cruciform_punctuation"]),
				"Dot", Map("<^>!", ["runic_single_punctuation"]),
				"Space", Map("<^>!", ["runic_multiple_punctuation"]),
				"7", Map("<^>!", ["futhark_almanac_arlaug"]),
				"8", Map("<^>!", ["futhark_almanac_tvimadur"]),
				"9", Map("<^>!", ["futhark_almanac_belgthor"]),
			)
		),
		"Glagolitic", Map(
			"Flat", Map(
				"А", ["glagolitic_[c,s]_let_az"],
				"Б", ["glagolitic_[c,s]_let_buky"],
				"В", ["glagolitic_[c,s]_let_vede"],
				"Г", ["glagolitic_[c,s]_let_glagoli"],
				"Д", ["glagolitic_[c,s]_let_dobro"],
				"Е", ["glagolitic_[c,s]_let_yestu"],
				"Ё", ["glagolitic_[c,s]_let_yo"],
				"Ж", ["glagolitic_[c,s]_let_zhivete"],
				"З", ["glagolitic_[c,s]_let_zemlja"],
				"И", ["glagolitic_[c,s]_let_i"],
				"Й", ["glagolitic_[c,s]_let_izhe"],
				"К", ["glagolitic_[c,s]_let_kako"],
				"Л", ["glagolitic_[c,s]_let_ljudije"],
				"М", ["glagolitic_[c,s]_let_myslite"],
				"Н", ["glagolitic_[c,s]_let_nashi"],
				"О", ["glagolitic_[c,s]_let_onu"],
				"П", ["glagolitic_[c,s]_let_pokoji"],
				"Р", ["glagolitic_[c,s]_let_ritsi"],
				"С", ["glagolitic_[c,s]_let_slovo"],
				"Т", ["glagolitic_[c,s]_let_tvrido"],
				"У", ["glagolitic_[c,s]_let_uku"],
				"Ф", ["glagolitic_[c,s]_let_fritu"],
				"Х", ["glagolitic_[c,s]_let_heru"],
				"Ц", ["glagolitic_[c,s]_let_tsi"],
				"Ч", ["glagolitic_[c,s]_let_chrivi"],
				"Ш", ["glagolitic_[c,s]_let_sha"],
				"Щ", ["glagolitic_[c,s]_let_shta"],
				"Ъ", ["glagolitic_[c,s]_let_yeru"],
				"Ы", ["glagolitic_[c,s]_let_yery"],
				"Ь", ["glagolitic_[c,s]_let_yeri"],
				"Э", ["glagolitic_[c,s]_let_small_yus"],
				"Ю", ["glagolitic_[c,s]_let_yu"],
				"Я", ["glagolitic_[c,s]_let_yati"],
			),
			"Moded", Map(
				"А", Map("<^>!", ["glagolitic_[c,s]_let_trokutasti_a"]),
				"Ё", Map("<!", ["glagolitic_[c,s]_let_big_yus_iotified"]),
				"Ж", Map("<^>!", ["glagolitic_[c,s]_let_djervi"]),
				"И", Map(
					"<^>!", ["glagolitic_[c,s]_let_initial_izhe"],
					"<+", ["glagolitic_[c,s]_let_izhe"],
					"<^>!<+", ["glagolitic_[c,s]_let_izhitsa"],
				),
				"О", Map(
					"<^>!", ["glagolitic_[c,s]_let_otu"],
					"<!", ["glagolitic_[c,s]_let_big_yus"],
				),
				"П", Map("<^>!", ["glagolitic_[c,s]_let_pe"]),
				"С", Map("<^>!", ["glagolitic_[c,s]_let_dzelo"]),
				"Х", Map("<^>!", ["glagolitic_[c,s]_let_spider_ha"]),
				"Ф", Map("<^>!", ["glagolitic_[c,s]_let_fita"]),
				"Ъ", Map("<^>!", ["glagolitic_[c,s]_let_shtapic"]),
				"Э", Map("<^>!", ["glagolitic_[c,s]_let_small_yus_iotified"]),
			)
		),
		"Old Turkic", Map(
			"Flat", Map(),
			"Moded", Map()
		),
		"Old Permic", Map(
			"Flat", Map(),
			"Moded", Map()
		),
	),
	"Important", Map(
		"Flat", Map(
			"RAlt", (*) => ChrCrafter.ComposeActivate(),
		),
		"Moded", Map(
			; Functional
			"F1", Map(
				; "<#<!", (*) => GroupActivator("Diacritics Primary", "F1"),
				"<^>!", (*) => KeyboardBinder.ToggleDefaultMode(),
				"<^>!<!", (*) => KeyboardBinder.ToggleLigaturedMode(),
				"<^>!>+", (*) => Auxiliary.ToggleInputMode(),
			),
			"F2", Map(
				; "<#<!", (*) => GroupActivator("Diacritics Secondary", "F2"),
				"<^>!", (*) => InputScriptProcessor(),
				"<^>!>+", (*) => InputScriptProcessor("pinYin"),
				"<^>!<+", (*) => InputScriptProcessor("karaShiki"),
				"<^>!<!", (*) => InputScriptProcessor("autoDiacritics"),
			),
			"F3", Map(
				; "<#<!", (*) => GroupActivator("Diacritics Tertiary", "F3"),
			),
			"F6", Map(
				; "<#<!", (*) => GroupActivator("Diacritics Quatemary", "F6"),
			),
			"F7", Map(
				; "<#<!", (*) => GroupActivator("Special Characters", "F7"),
			),
			"F12", Map(
				; ">^", (*) => KeyboardBinder.SwitchLayout("Latin"),
				; ">+", (*) => KeyboardBinder.SwitchLayout("Cyrillic")
			),
			"Up", Map(
				"<#<!", (*) => KeyboardBinder.ToggleNumStyle("Superscript"),
				"<#<!>+", (*) => KeyboardBinder.ToggleNumStyle("Roman"),
			),
			"Down", Map(
				"<#<!", (*) => KeyboardBinder.ToggleNumStyle("Subscript"),
			),
			"PgUp", Map("<#<!", (*) => UnicodeWebResource()),
			"Home", Map("<#<!", (*) => Panel.Panel()),
			; "Space", Map("<#<!", (*) => GroupActivator("Spaces")),
			; "HyphenMinus", Map("<#<!", (*) => GroupActivator("Dashes", "-")),
			; "Apostrophe", Map("<#<!", (*) => GroupActivator("Quotes", "'")),
			"A", Map("<#<!", (*) => Scripter.SelectorPanel("Glyph Variations")),
			"S", Map("<#<!", (*) => Scripter.SelectorPanel()),
			"F", Map("<#<!", (*) => ChrLib.SearchPrompt().send()),
			"H", Map(
				">^", (*) => Util.StrSelToHTML("Entities"),
				">^>+", (*) => Util.StrSelToHTML(),
			),
			"J", Map(
				">^", (*) => Util.StrSelToHTML("Entities", True),
			),
			"Comma", Map("<#<!", (*) => GetKeyScanCode()),
			"Q", Map("<!", (*) => BindHandler.LangCall(
				() => QuotatizeSelection("Double"),
				() => QuotatizeSelection("France")),
				"<!<+", (*) => BindHandler.LangCall(
					() => QuotatizeSelection("Single"),
					() => QuotatizeSelection("Paw"))),
			"Y", Map(
				">^", (*) => ReplaceWithUnicode("CSS"),
			),
			"U", Map(
				">^", (*) => ReplaceWithUnicode(),
			),
			"I", Map(
				">^", (*) => ReplaceWithUnicode("Hex"),
			),
		)
	),
	"Keyboard Default", Map(
		"Flat", Map(
			; Digits
			"0", "digit_0",
			"1", "digit_1",
			"2", "digit_2",
			"3", "digit_3",
			"4", "digit_4",
			"5", "digit_5",
			"6", "digit_6",
			"7", "digit_7",
			"8", "digit_8",
			"9", "digit_9",
			"Equals", ["equals"],
			"HyphenMinus", ["hyphen_minus"],
			"Dot", ["dot"],
			"Comma", ["comma"],
			"Slash", ["solidus"],
			"Backslash", ["reverse_solidus"],
			"Semicolon", ["semicolon"],
			"Apostrophe", ["apostrophe"],
			"LeftBracket", ["left_bracket"],
			"RightBracket", ["right_bracket"],
			"Tilde", ["grave_accent"],
			"Равно", ["equals"],
			"ДефисоМинус", ["hyphen_minus"],
			"Точка", ["dot"],
			"ОбратныйСлэш", ["reverse_solidus"],
			; Latin alphabet (A-Z)
			"A", ["lat_[c,s]_let_a"],
			"B", ["lat_[c,s]_let_b"],
			"C", ["lat_[c,s]_let_c"],
			"D", ["lat_[c,s]_let_d"],
			"E", ["lat_[c,s]_let_e"],
			"F", ["lat_[c,s]_let_f"],
			"G", ["lat_[c,s]_let_g"],
			"H", ["lat_[c,s]_let_h"],
			"I", ["lat_[c,s]_let_i"],
			"J", ["lat_[c,s]_let_j"],
			"K", ["lat_[c,s]_let_k"],
			"L", ["lat_[c,s]_let_l"],
			"M", ["lat_[c,s]_let_m"],
			"N", ["lat_[c,s]_let_n"],
			"O", ["lat_[c,s]_let_o"],
			"P", ["lat_[c,s]_let_p"],
			"Q", ["lat_[c,s]_let_q"],
			"R", ["lat_[c,s]_let_r"],
			"S", ["lat_[c,s]_let_s"],
			"T", ["lat_[c,s]_let_t"],
			"U", ["lat_[c,s]_let_u"],
			"V", ["lat_[c,s]_let_v"],
			"W", ["lat_[c,s]_let_w"],
			"X", ["lat_[c,s]_let_x"],
			"Y", ["lat_[c,s]_let_y"],
			"Z", ["lat_[c,s]_let_z"],
			; Cyrillic alphabet (А-Я)
			"А", ["cyr_[c,s]_let_a"],
			"Б", ["cyr_[c,s]_let_b"],
			"В", ["cyr_[c,s]_let_v"],
			"Г", ["cyr_[c,s]_let_g"],
			"Д", ["cyr_[c,s]_let_d"],
			"Е", ["cyr_[c,s]_let_ye"],
			"Ё", ["cyr_[c,s]_let_ye__diaeresis"],
			"Ж", ["cyr_[c,s]_let_zh"],
			"З", ["cyr_[c,s]_let_z"],
			"И", ["cyr_[c,s]_let_i"],
			"Й", ["cyr_[c,s]_let_i__breve"],
			"К", ["cyr_[c,s]_let_k"],
			"Л", ["cyr_[c,s]_let_l"],
			"М", ["cyr_[c,s]_let_m"],
			"Н", ["cyr_[c,s]_let_n"],
			"О", ["cyr_[c,s]_let_o"],
			"П", ["cyr_[c,s]_let_p"],
			"Р", ["cyr_[c,s]_let_r"],
			"С", ["cyr_[c,s]_let_s"],
			"Т", ["cyr_[c,s]_let_t"],
			"У", ["cyr_[c,s]_let_u"],
			"Ф", ["cyr_[c,s]_let_f"],
			"Х", ["cyr_[c,s]_let_h"],
			"Ц", ["cyr_[c,s]_let_ts"],
			"Ч", ["cyr_[c,s]_let_ch"],
			"Ш", ["cyr_[c,s]_let_sh"],
			"Щ", ["cyr_[c,s]_let_shch"],
			"Ъ", ["cyr_[c,s]_let_yer"],
			"Ы", ["cyr_[c,s]_let_yery"],
			"Ь", ["cyr_[c,s]_let_yeri"],
			"Э", ["cyr_[c,s]_let_e"],
			"Ю", ["cyr_[c,s]_let_yu"],
			"Я", ["cyr_[c,s]_let_ya"],
			"І", ["cyr_[c,s]_let_i_decimal"],
			"Ѣ", ["cyr_[c,s]_let_yat"]
		),
		"Moded", Map(
			; Digits
			"1", Map("+", "exclamation"),
			"2", Map("+:LangFlat", ["commercial_at", "quote"]),
			"3", Map("+:LangFlat", ["number_sign", "numero_sign"]),
			"4", Map("+:LangFlat", ["wallet_dollar", "semicolon"]),
			"5", Map("+", "percent"),
			"6", Map("+:LangFlat", ["circumflex_accent", "colon"]),
			"7", Map("+:LangFlat", ["lat_s_lig_et", "question"]),
			"8", Map("+", "asterisk"),
			"9", Map("+", "left_parenthesis"),
			"0", Map("+", "right_parenthesis"),
			"Equals", Map("+", ["plus"]),
			"HyphenMinus", Map("+", ["underscore"]),
			"Slash", Map("+", ["question"]),
			"Backslash", Map("+", ["vertical_line"]),
			"Semicolon", Map("+", ["colon"]),
			"Apostrophe", Map("+", ["quote"]),
			"Tilde", Map("+", ["tilde"]),
			"LeftBracket", Map("+", ["left_brace"]),
			"RightBracket", Map("+", ["right_brace"]),
			"Равно", Map("+", ["plus"]),
			"ДефисоМинус", Map("+", ["underscore"]),
			"Точка", Map("+", ["comma"]),
			"ОбратныйСлэш", Map("+", ["solidus"]),
		)
	),
	"Roman Digits", Map(
		"Flat", Map(
			; Digits
			"1:Caps", ["lat_[c,s]_num_1"],
			"2:Caps", ["lat_[c,s]_num_2"],
			"3:Caps", ["lat_[c,s]_num_3"],
			"4:Caps", ["lat_[c,s]_num_4"],
			"5:Caps", ["lat_[c,s]_num_5"],
			"6:Caps", ["lat_[c,s]_num_6"],
			"7:Caps", ["lat_[c,s]_num_7"],
			"8:Caps", ["lat_[c,s]_num_8"],
			"9:Caps", ["lat_[c,s]_num_9"],
			"0:Caps", ["lat_[c,s]_num_10"],
		),
		"Moded", Map(
			; Digits
			"1", Map("<+:Caps", ["lat_[c,s]_num_11"]),
			"2", Map("<+:Caps", ["lat_[c,s]_num_12"]),
			"5", Map(
				"<+:Caps", ["lat_[c,s]_num_50"],
				">+:Caps", ["lat_[c,s]_num_500"],
				"<^>!", "lat_c_num_5000",
				"<^>!>+", "lat_c_num_50000",
				"<^>!<!", "lat_c_num_50_early",
			),
			"6", Map("<^>!<!", "lat_c_num_6_late"),
			"0", Map(
				">+:Caps", ["lat_[c,s]_num_100"],
				"<^>!:Caps", ["lat_[c,s]_num_1000"],
				"<^>!>+", "lat_c_num_10000",
				"<^>!<+", "lat_c_num_100000",
			),
		),
	),
	"Subscript Digits", Map(
		"Flat", Map(
			; Digits
			"0:Caps", ["digit_0::[modifier,subscript]"],
			"1:Caps", ["digit_1::[modifier,subscript]"],
			"2:Caps", ["digit_2::[modifier,subscript]"],
			"3:Caps", ["digit_3::[modifier,subscript]"],
			"4:Caps", ["digit_4::[modifier,subscript]"],
			"5:Caps", ["digit_5::[modifier,subscript]"],
			"6:Caps", ["digit_6::[modifier,subscript]"],
			"7:Caps", ["digit_7::[modifier,subscript]"],
			"8:Caps", ["digit_8::[modifier,subscript]"],
			"9:Caps", ["digit_9::[modifier,subscript]"],
			"Equals:Caps", ["equals::[modifier,subscript]"],
			"HyphenMinus:Caps", ["minus::[modifier,subscript]"],
		),
		"Moded", Map(
			; Digits
			"9", Map("+:Caps", ["left_parenthesis::[modifier,subscript]"]),
			"0", Map("+:Caps", ["right_parenthesis::[modifier,subscript]"]),
			"Equals", Map("+:Caps", ["plus::[modifier,subscript]"]),
		)
	),
	"Superscript Digits", Map(
		"Flat", Map(
			; Digits
			"0:Caps", ["digit_0::[subscript,modifier]"],
			"1:Caps", ["digit_1::[subscript,modifier]"],
			"2:Caps", ["digit_2::[subscript,modifier]"],
			"3:Caps", ["digit_3::[subscript,modifier]"],
			"4:Caps", ["digit_4::[subscript,modifier]"],
			"5:Caps", ["digit_5::[subscript,modifier]"],
			"6:Caps", ["digit_6::[subscript,modifier]"],
			"7:Caps", ["digit_7::[subscript,modifier]"],
			"8:Caps", ["digit_8::[subscript,modifier]"],
			"9:Caps", ["digit_9::[subscript,modifier]"],
			"Equals:Caps", ["equals::[subscript,modifier]"],
			"HyphenMinus:Caps", ["minus::[subscript,modifier]"],
		),
		"Moded", Map(
			; Digits
			"9", Map("+:Caps", ["left_parenthesis::[subscript,modifier]"]),
			"0", Map("+:Caps", ["right_parenthesis::[subscript,modifier]"]),
			"Equals", Map("+:Caps", ["plus::[subscript,modifier]"]),
		)
	),
	"Diacritic", Map(
		"Flat", Map(),
		"Moded", Map(
			"A", Map(
				"<^<!", "acute",
				"<^<!<+", "acute_double",
				"<^<!>+", "acute_below"
			),
			"B", Map(
				"<^<!", "breve",
				"<^<!<+", "breve_inverted",
				"<^<!>+", "breve_below",
				"<^<!<+>+", "breve_inverted_below"
			),
			"C", Map(
				"<^<!", "circumflex",
				"<^<!<+", "caron",
				"<^<!>+", "cedilla",
				"<^<!<+>+", "circumflex_below"
			),
			"D", Map(
				"<^<!", "dot_above",
				"<^<!<+", "diaeresis",
				"<^<!>+", "dot_below",
				"<^<!<+>+", "diaeresis_below"
			),
			"F", Map(
				"<^<!", "fermata"
			),
			"G", Map(
				"<^<!", "grave",
				"<^<!<+", "grave_double",
				"<^<!>+", "cyr_com_dasia_pneumata",
				"<^<!<+>+", "cyr_com_psili_pneumata"
			),
			"H", Map(
				"<^<!", "hook_above",
				"<^<!<+", "horn",
				"<^<!>+", "palatal_hook_below",
				"<^<!<+>+", "retroflex_hook_below"
			),
			"M", Map(
				"<^<!", "macron",
				"<^<!<+", "macron_below"
			),
			"N", Map(
				"<^<!", "cyr_com_titlo"
			),
			"O", Map(
				"<^<!", "ogonek",
				"<^<!<+", "ogonek_above"
			),
			"R", Map(
				"<^<!", "ring_above",
				"<^<!<+", "ring_below"
			),
			"S", Map(
				"<^<!", "stroke_short",
				"<^<!<+", "stroke_long"
			),
			"T", Map(
				"<^<!", "tilde_above",
				"<^<!<+", "tilde_overlay"
			),
			"V", Map(
				"<^<!", "line_vertical",
				"<^<!<+", "line_vertical_double"
			),
			"X", Map(
				"<^<!", "x_above",
				"<^<!<+", "x_below"
			),
			"Z", Map(
				"<^<!", "zigzag_above"
			),
			"Slash", Map(
				"<^<!", "solidus_short",
				"<^<!<+", "solidus_long"
			),
			"Comma", Map(
				"<^<!", "comma_above",
				"<^<!<+", "comma_below"
			),
			"Dot", Map(
				"<^<!", "dot_above",
				"<^<!<+", "diaeresis"
			)
		)
	),
	"Common", Map(
		"Flat", Map(
			"NumpadAdd", (K) => BindHandler.TimeSend(K, Map(
				"NumpadSub", (*) => BindHandler.Send(K, "minusplus"),
			)),
			"NumpadSub", (K) => BindHandler.TimeSend(K, Map(
				"NumpadAdd", (*) => BindHandler.Send(K, "plusminus"),
			), (*) => BindHandler.Send(K, "minus")),
			"NumpadMult", (K) => BindHandler.TimeSend(K, Map(
				"NumpadDiv", (*) => BindHandler.Send(K, "division_times"),
			), (*) => BindHandler.Send(K, "multiplication")),
		),
		"Moded", Map(
			; Numpad
			"Numpad0", Map(
				"<^<!", "dotted_circle",
				"<^>!", "empty_set",
			),
			"NumpadMult", Map(
				"<^>!", "asterisk_two",
				"<^>!>+", "asterism",
				"<^>!<+", "asterisk_low",
			),
			"NumpadDiv", Map(
				"<^>!", "dagger",
				"<^>!>+", "dagger_double",
				"<^<!", "asterisk_operator",
				"<^<!<+", "bullet_operator",
			),
			; Arrows
			"Left", Map(
				"<^>!", (K) => BindHandler.TimeSend(K, Map(
					"Up", (*) => BindHandler.Send(K, "arrow_leftup"),
					"Down", (*) => BindHandler.Send(K, "arrow_leftdown"),
					"Right", (*) => BindHandler.Send(K, "arrow_leftright"),
				), (*) => BindHandler.Send(K, "arrow_left")),
				"<^>!<+", "arrow_left_ushaped",
				"<^>!>+", "arrow_left_circle",
			),
			"Right", Map(
				"<^>!", (K) => BindHandler.TimeSend(K, Map(
					"Up", (*) => BindHandler.Send(K, "arrow_rightup"),
					"Down", (*) => BindHandler.Send(K, "arrow_rightdown"),
					"Left", (*) => BindHandler.Send(K, "arrow_leftright"),
				), (*) => BindHandler.Send(K, "arrow_right")),
				"<^>!<+", "arrow_right_ushaped",
				"<^>!>+", "arrow_right_circle",
			),
			"Up", Map(
				"<^>!", (K) => BindHandler.TimeSend(K, Map(
					"Left", (*) => BindHandler.Send(K, "arrow_leftup"),
					"Down", (*) => BindHandler.Send(K, "arrow_updown"),
					"Right", (*) => BindHandler.Send(K, "arrow_rightup"),
				), (*) => BindHandler.Send(K, "arrow_up")),
				"<^>!<+", "arrow_up_ushaped",
			),
			"Down", Map(
				"<^>!", (K) => BindHandler.TimeSend(K, Map(
					"Left", (*) => BindHandler.Send(K, "arrow_leftdown"),
					"Up", (*) => BindHandler.Send(K, "arrow_updown"),
					"Right", (*) => BindHandler.Send(K, "arrow_rightdown"),
				), (*) => BindHandler.Send(K, "arrow_down")),
				"<^>!<+", "arrow_down_ushaped",
			),
			; Digit & Misc Layout
			"1", Map(
				"<!", "section",
				"<^>!", "inverted_exclamation",
				"<^>!<+", "double_exclamation_question",
				"<^>!>+", "double_exclamation",
				">+:Caps", ["interrobang_inverted", "interrobang"]
			),
			"2", Map(
				"<^>!:Caps", ["registered", "copyright"],
				"<^>!<+:Caps", ["servicemark", "trademark"],
				"<^>!>+", "sound_recording_copyright"
			),
			"3", Map(
				"<^>!:Caps", ["prime_single[_reversed,]"],
				"<^>!>+:Caps", ["prime_double[_reversed,]"],
				"<^>!<+:Caps", ["prime_triple[_reversed,]"],
				"<^>!<+>+", "prime_quadruple"
			),
			"4", Map("<^>!", "division"),
			"5", Map("<^>!", "permille", "<^>!<+", "pertenthousand"),
			"6", Map(),
			"7", Map(
				"<^>!", "inverted_question",
				"<^>!>+", "double_question",
				"<^>!<+", "double_question_exclamation",
				"<^>!<!", "reversed_question"
			),
			"8", Map(
				"<^>!", "multiplication",
				"<^>!<!", "infinity"
			),
			"9", Map(
				"<^>!", "left_chevron",
				"<!", "left_bracket",
				"<!<+", "left_brace"
			),
			"0", Map(
				"<^>!", "right_chevron",
				"<!", "right_bracket",
				"<!<+", "right_brace"
			),
			"Equals", Map(
				"<^>!", ["noequals"],
				"<^>!<!", ["almostequals"],
				"<^>!<+", ["plusminus"]
			),
			"HyphenMinus", Map(
				"<^>!>+", ["hyphenation_point"],
				"<^<!", ["softhyphen"],
				"<^<!<+", ["minus"],
				"<^>!", ["emdash"],
				"<^>!<+", ["endash"],
				"<!:Caps", ["two_emdash", "three_emdash"],
				"<^>!<!", ["hyphen"],
				"<^>!<!<+", ["no_break_hyphen"],
				"<^>!<!>+", ["figure_dash"]
			),
			"LeftBracket", Map(
				"<^>!<!", ["left_cjk_tortoise_shell"],
				"<^>!<!<+", ["left_cjk_corner_bracket"],
				"<^>!<!>+", ["left_cjk_title_bracket"],
				"<^>!<!<+>+", ["left_double_cjk_title_bracket"],
				"<^>!", ["left_bracket_with_quill"],
				"<^>!>+", ["left_white_bracket"],
				"<^>!<+", ["left_white_tortoise_shell"],
			),
			"RightBracket", Map(
				"<^>!<!", ["right_cjk_tortoise_shell"],
				"<^>!<!<+", ["right_cjk_corner_bracket"],
				"<^>!<!>+", ["right_cjk_title_bracket"],
				"<^>!<!<+>+", ["right_double_cjk_title_bracket"],
				"<^>!", ["right_bracket_with_quill"],
				"<^>!>+", ["right_white_bracket"],
				"<^>!<+", ["right_white_tortoise_shell"],
			),
			"Slash", Map(
				"<^>!", "ellipsis",
				"<^>!<+", "tricolon",
				"<^>!<+>+", "quartocolon",
				"<!", "two_dot_punctuation",
				"<^>!>+", "fraction_slash"
			),
			"Comma", Map(
				"<^>!", ["quote_left_double"],
				"<^>!<+", ["quote_left"],
				"<^>!>+", ["quote_low_9_double"],
				"<^>!<+>+", ["quote_low_9"],
				"<^>!<!", ["quote_angle_left_double"],
				"<^>!<!<+", ["quote_angle_left"]
			),
			"Dot", Map(
				"<^>!", ["quote_right_double"],
				"<^>!<+", ["quote_right"],
				"<^>!>+", ["quote_low_9_double_reversed"],
				"<^>!<!", ["quote_angle_right_double"],
				"<^>!<!<+", ["quote_angle_right"]
			),
			"Tilde", Map(
				"<^>!", "bullet",
				"<^>!<!", "bullet_hyphen",
				"<^>!<+", "interpunct",
				"<^>!>+", "quote_right",
				"<^>!<!<+", "bullet_triangle",
				"<^>!<!>+", "bullet_white",
				">+", "tilde_reversed"
			),
			"Apostrophe", Map(),
			"Space", Map(
				"<^>!", "no_break_space",
				"<^>!>+", "emsp",
				"<^>!<+", "ensp",
				"<^>!<+>+", "figure_space",
				"<^>!<!", "thinspace",
				"<^>!<!<+", "hairspace",
				"<^>!<!>+", "punctuation_space",
				;"<^>!<!<+>+", "zero_width_space",
				"<!", "emsp13",
				"<^>!>^", "zero_width_space",
				"<^<!", "zero_width_no_break_space",
				;"<+", "emsp14",
				">+", "emsp16",
				"<+>+", "narrow_no_break_space",
			),
			"Tab", Map(
				"<^>!", "zero_width_joiner",
				"<^>!>+", "zero_width_non_joiner",
				"<^>!<+", "word_joiner"
			),
			"ДефисоМинус", Map(
				"<^>!>+", ["hyphenation_point"],
				"<^<!", ["softhyphen"],
				"<^<!<+", ["minus"],
				"<^>!", ["emdash"],
				"<^>!<+", ["endash"],
				"<!:Caps", ["two_emdash", "three_emdash"],
				"<^>!<!", ["hyphen"],
				"<^>!<!<+", ["no_break_hyphen"],
				"<^>!<!>+", ["figure_dash"]
			),
			; Latin-Modifiers Keyboard Layout
			"A", Map(
				"<!", ["lat_[c,s]_let_a__acute"],
				"<^>!", ["lat_[c,s]_let_a__breve"],
				"<^>!<!", ["lat_[c,s]_let_a__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_a__ring_above"],
				"<^>!<!>+", ["lat_[c,s]_let_a__ogonek"],
				"<^>!>+", ["lat_[c,s]_let_a__macron"],
				"<^>!<+", ["lat_[c,s]_let_a__diaeresis"],
				"<^>!<+>+", ["lat_[c,s]_let_a__tilde_above"],
				">+", ["lat_[c,s]_let_a__grave"],
				"<+>+", ["lat_[c,s]_let_a__grave_double"]),
			"B", Map(
				"<^>!", ["lat_[c,s]_let_b__dot_above"],
				"<^>!<!", ["lat_[c,s]_let_b__dot_below"],
				"<^>!<!<+", ["lat_[c,s]_let_b__flourish"],
				"<^>!<+", ["lat_[c,s]_let_b__stroke_short"],
				"<^>!>+", ["lat_[c,s]_let_b__common_hook"]),
			"C", Map("<!", ["lat_[c,s]_let_c__acute"],
				"<^>!", ["lat_[c,s]_let_c__dot_above"],
				"<^>!<!", ["lat_[c,s]_let_c__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_c__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_c__cedilla"],
				">+", "celsius"),
			"D", Map(
				"<!", "degree",
				"<^>!", ["lat_[c,s]_let_d_eth"],
				"<^>!<!", ["lat_[c,s]_let_d__stroke_short"],
				"<^>!<!<+", ["lat_[c,s]_let_d__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_d__cedilla"],
				"<^>!<+>+", ["lat_[c,s]_let_d__circumflex_below"]),
			"E", Map("<!", ["lat_[c,s]_let_e__acute"],
				"<^>!", ["lat_[c,s]_let_schwa"],
				"<^>!<!", ["lat_[c,s]_let_e__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_e__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_e__ogonek"],
				"<^>!>+", ["lat_[c,s]_let_e__macron"],
				"<^>!<+", ["lat_[c,s]_let_e__diaeresis"],
				"<^>!<+>+", ["lat_[c,s]_let_e__tilde_above"],
				">+", ["lat_[c,s]_let_e__grave"],
				"<+>+", ["lat_[c,s]_let_e__grave_double"]),
			"F", Map(
				"<^>!", ["lat_[c,s]_let_f__dot_above"],
				">+", "fahrenheit"),
			"G", Map("<!", ["lat_[c,s]_let_g__acute"],
				"<^>!", ["lat_[c,s]_let_g__breve"],
				"<^>!<!", ["lat_[c,s]_let_g__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_g__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_g__cedilla"],
				"<^>!<+", ["lat_[c,s]_let_g_insular"],
				"<^>!>+", ["lat_[c,s]_let_g__macron"],
				"<^>!<+>+", ["lat_[c,s]_let_gamma"],
				">+", ["lat_[c,s]_let_g__dot_above"]),
			"H", Map(
				"<!", ["lat_[c,s]_let_h_hwair"],
				"<^>!", ["lat_[c,s]_let_h__stroke_short"],
				"<^>!<!", ["lat_[c,s]_let_h__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_h__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_h__cedilla"],
				"<^>!<+", ["lat_[c,s]_let_h__diaeresis"]),
			"I", Map("<!", ["lat_[c,s]_let_i__acute"],
				"<^>!", ["lat_[c,s]_let_i__breve"],
				"<^>!<!", ["lat_[c,s]_let_i__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_i__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_i__ogonek"],
				"<^>!>+", ["lat_[c,s]_let_i__macron"],
				"<^>!<+", ["lat_[c,s]_let_i__diaeresis"],
				"<^>!<+>+", ["lat_[c,s]_let_i__tilde_above"],
				">+", ["lat_[c,s]_let_i__grave"],
				"<+>+", ["lat_[c,s]_let_i__grave_double"],
				"<^>!<!<+>+", ["lat_[c,s]_let_i__dot_above"]),
			"J", Map(
				"<^>!", ["lat_[c,s]_let_j__stroke_short"],
				"<^>!>+", ["lat_[c,s]_let_j_yogh"],
				"<^>!<!", ["lat_[c,s]_let_j__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_j__caron"],
			),
			"K", Map("<!", ["lat_[c,s]_let_k__acute"],
				"<^>!<!", ["lat_[c,s]_let_k__dot_below"],
				"<^>!<!<+", ["lat_[c,s]_let_k__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_k__cedilla"],
				"<^>!<+", ["lat_[c,s]_let_k_cuatrillo"],
				">+", "kelvin"
			),
			"L", Map(
				"<!", ["lat_[c,s]_let_l__acute"],
				"<^>!", ["lat_[c,s]_let_l__solidus_short"],
				"<^>!<!<+", ["lat_[c,s]_let_l__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_l__cedilla"],
				"<^>!<+>+", ["lat_[c,s]_let_l__circumflex_below"]),
			"M", Map("<!", ["lat_[c,s]_let_m__acute"],
				"<^>!", ["lat_[c,s]_let_m__dot_above"],
				"<^>!<!", ["lat_[c,s]_let_m__dot_below"],
				"<^>!>+", ["lat_[c,s]_let_m__common_hook"]),
			"N", Map("<!", ["lat_[c,s]_let_n__acute"],
				"<^>!", ["lat_[c,s]_let_n__tilde_above"],
				"<^>!<!", ["lat_[c,s]_let_n__dot_below"],
				"<^>!<!<+", ["lat_[c,s]_let_n__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_n__cedilla"],
				"<^>!>+", ["lat_[c,s]_let_n__common_hook"],
				"<^>!<+", ["let_[c,s]_let_n__descender"],
				"<^>!<+>+", ["lat_[c,s]_let_n__dot_above"],
				">+", ["lat_[c,s]_let_n__grave"]),
			"O", Map("<!", ["lat_[c,s]_let_o__acute"],
				"<^>!", ["lat_[c,s]_let_o__solidus_long"],
				"<^>!<!", ["lat_[c,s]_let_o__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_o__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_o__ogonek"],
				"<^>!>+", ["lat_[c,s]_let_o__macron"],
				"<^>!<+", ["lat_[c,s]_let_o__diaeresis"],
				"<^>!<+>+", ["lat_[c,s]_let_o__tilde_above"],
				">+", ["lat_[c,s]_let_o__grave"],
				"<+>+", ["lat_[c,s]_let_o__grave_double"],
				"<^>!<!<+>+", ["lat_[c,s]_let_o__acute_double"]),
			"P", Map("<!", ["lat_[c,s]_let_p__acute"],
				"<^>!", ["lat_[c,s]_let_p__dot_above"],
				"<^>!<!", ["lat_[c,s]_let_p__squirrel_tail"],
				"<^>!<!<+", ["lat_[c,s]_let_p__flourish"],
				"<^>!<+", ["lat_[c,s]_let_p__stroke_short"],
				"<^>!>+", ["lat_[c,s]_let_p__common_hook"]),
			"Q", Map(
				"<^>!<+", ["lat_[c,s]_let_q_tresillo"],
				"<^>!>+", ["lat_[c,s]_let_q__common_hook"]),
			"R", Map("<!", ["lat_[c,s]_let_r__acute"],
				"<^>!", ["lat_[c,s]_let_r__dot_above"],
				"<^>!<!", ["lat_[c,s]_let_r_dot_below"],
				"<^>!<!<+", ["lat_[c,s]_let_r__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_r__cedilla"],
				"<^>!<+", ["lat_[c,s]_let_yr"],
				"<^>!>+", ["lat_[c,s]_let_r_rotunda"],
				"<+>+", ["lat_[c,s]_let_r__grave_double"]),
			"S", Map("<!", ["lat_[c,s]_let_s__acute"],
				"<^>!", ["lat_[c,s]_let_s__comma_below"],
				"<^>!<!", ["lat_[c,s]_let_s__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_s__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_s__cedilla"],
				"<^>!>+", ["lat_s_let_s_long"],
				"<^>!<+>+", ["lat_[c,s]_let_s_sigma"],
				"<^>!<+", ["lat_[c,s]_lig_s_eszett"]),
			"T", Map(
				"<^>!", ["lat_[c,s]_let_t__comma_below"],
				"<^>!<!", ["lat_[c,s]_let_t__dot_below"],
				"<^>!<!<+", ["lat_[c,s]_let_t__caron"],
				"<^>!<!>+", ["lat_[c,s]_let_t__cedilla"],
				"<^>!>+", ["lat_[c,s]_let_t_thorn"],
				"<^>!<+", ["lat_[c,s]_let_t__dot_above"],
				"<^>!<+>+", ["lat_[c,s]_let_et_tironian"]),
			"U", Map(
				"<!", ["lat_[c,s]_let_u__acute"],
				"<^>!", ["lat_[c,s]_let_u__breve"],
				"<^>!<!", ["lat_[c,s]_let_u__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_u__ring_above"],
				"<^>!<!>+", ["lat_[c,s]_let_u__ogonek"],
				"<^>!>+", ["lat_[c,s]_let_u__macron"],
				"<^>!<+", ["lat_[c,s]_let_u__diaeresis"],
				"<^>!<+>+", ["lat_[c,s]_let_u__tilde_above"],
				">+", ["lat_[c,s]_let_u__grave"],
				"<+>+", ["lat_[c,s]_let_u__grave_double"],
				"<^>!<!<+>+", ["lat_[c,s]_let_u__acute_double"]),
			"V", Map(
				"<^>!", ["lat_[c,s]_let_v__solidus_long"],
				"<^>!<!", ["lat_[c,s]_let_v__dot_below"],
				"<^>!<+", ["lat_[c,s]_let_v_middle_welsh"],
				"<^>!>+", ["lat_[c,s]_let_vend"],
				"<^>!<+>+", ["lat_[c,s]_let_v__tilde_above"]),
			"W", Map("<!", ["lat_[c,s]_let_w__acute"],
				"<^>!", ["lat_[c,s]_let_w__dot_above"],
				"<^>!<!", ["lat_[c,s]_let_w__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_w__dot_below"],
				"<^>!<+", ["lat_[c,s]_let_w__diaeresis"],
				"<^>!>+", ["lat_[c,s]_let_w_wynn"],
				"<^>!<!>+", ["lat_[c,s]_let_w_anglicana"],
				">+", ["lat_[c,s]_let_w__grave"]),
			"X", Map(
				"<^>!", ["lat_[c,s]_let_x__dot_above"],
				"<^>!<+", ["lat_[c,s]_let_x__diaeresis"]),
			"Y", Map("<!", ["lat_[c,s]_let_y_acute"],
				"<^>!", ["lat_[c,s]_let_y_dot_above"],
				"<^>!<!", ["lat_[c,s]_let_y_circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_y_stroke_short"],
				"<^>!<!>+", ["lat_[c,s]_let_y__loop"],
				"<^>!>+", ["lat_[c,s]_let_y__macron"],
				"<^>!<+", ["lat_[c,s]_let_y__diaeresis"],
				"<^>!<+>+", ["lat_[c,s]_let_y__tilde_above"],
				">+", ["lat_[c,s]_let_y__grave"]),
			"Z", Map("<!", ["lat_[c,s]_let_z__acute"],
				"<^>!", ["lat_[c,s]_let_z__dot_above"],
				"<^>!<!", ["lat_[c,s]_let_z__circumflex"],
				"<^>!<!<+", ["lat_[c,s]_let_z__caron"],
				"<^>!>+", ["lat_[c,s]_let_z_ezh"],
				"<^>!<+", ["lat_[c,s]_let_z__stroke_short"]),
			; Russian-Modifiers Keyboard Layout
			"А", Map(
				"<^>!", ["cyr_[c,s]_let_a__breve"],
				"<^>!<+", ["cyr_[c,s]_let_a__diaeresis"],
			),
			"Б", Map(
				"<^>!", ["quote_angle_left_double"],
				"<^>!<+", ["quote_left_double_ghost_ru"],
				"<^>!>+", ["quote_low_9_double"],
				"<^>!<!", ["quote_left_double"],
				"<^>!<!<+", ["quote_angle_left"],
				"<^>!<+>+", ["quote_low_9"],
			),
			"В", Map(),
			"Г", Map(
				"<!", ["cyr_[c,s]_let_g__acute"],
				"<^>!", ["cyr_[c,s]_let_g_upturn"],
				"<^>!<+", ["cyr_[c,s]_let_g_stroke_short"],
				"<^>!<!", ["cyr_[c,s]_let_g_descender"],
			),
			"Д", Map(),
			"Е", Map(
				"<!", ["cyr_[c,s]_let_e_breve"],
				">+", ["cyr_[c,s]_let_e_grave"],
				"<^>!", ["cyr_[c,s]_let_ye_yat"],
			),
			"Ё", Map(),
			"Ж", Map(
				"<!", ["cyr_[c,s]_let_zhe_breve"],
				"<^>!", ["cyr_[c,s]_let_zh_dzhe"],
				"<^>!<+", ["cyr_[c,s]_let_zhe_diaeresis"],
				"<^>!>+", ["cyr_[c,s]_let_zh_dje"],
				"<^>!<!", ["cyr_[c,s]_let_zhe_descender"],
			),
			"З", Map(
				"<^>!", ["cyr_[c,s]_let_z_dzelo"],
				"<^>!>+", ["cyr_[c,s]_let_z_zemlya"],
				"<^>!<+", ["cyr_[c,s]_let_z_diaeresis"],
				"<^>!<!", ["cyr_[c,s]_let_z_descender"],
			),
			"И", Map(
				"<^>!", ["cyr_[c,s]_let_i_decimal"],
				"<^>!<+", ["cyr_[c,s]_let_i_diaeresis"],
				"<^>!>+", ["cyr_[c,s]_let_i_macron"],
				"<^>!<!", ["cyr_[c,s]_let_i_izhitsa"],
				"<^>!<!<+>+", ["cyr_[c,s]_let_iota"]
			),
			"Й", Map(
				"<^>!", ["cyr_[c,s]_let_i__breve"],
				"<^>!<!", ["cyr_[c,s]_let_j"],
				"<^>!<!>+", ["cyr_[c,s]_let_i_breve_tail"],
			),
			"К", Map(
				"<!", ["cyr_[c,s]_let_k_acute"],
				"<^>!", ["cyr_[c,s]_let_ksi"],
				"<^>!<!", ["cyr_[c,s]_let_k_descender"],
			),
			"Л", Map(
				"<^>!", ["cyr_[c,s]_lig_lje"],
				"<^>!<!", ["cyr_[c,s]_let_l_descender"],
				"<^>!<!>+", ["cyr_[c,s]_let_l_tail"],
				"<^>!<!<+", ["cyr_[c,s]_let_l_palochka"]
			),
			"М", Map(
				"<^>!<!<+>+", ["cyr_[c,s]_let_m_tail"]
			),
			"Н", Map(
				"<^>!", ["cyr_[c,s]_lig_nje"],
				"<^>!<!", ["cyr_[c,s]_let_n_descender"],
				"<^>!<!>+", ["cyr_[c,s]_let_n_tail"],
			),
			"О", Map(
				"<^>!", ["cyr_[c,s]_let_omega"],
				"<^>!<+", ["cyr_[c,s]_let_o_diaeresis"]
			),
			"П", Map(
				"<^>!", ["cyr_[c,s]_let_psi"],
				"<^>!<!", ["cyr_[c,s]_let_p_descender"]
			),
			"Р", Map(),
			"С", Map(
				"<^>!<!", ["cyr_[c,s]_let_s_descender"]
			),
			"Т", Map(
				"<^>!", ["cyr_[c,s]_let_tje"],
				"<^>!<!", ["cyr_[c,s]_let_t_descender"]
			),
			"У", Map(
				"<!", ["cyr_[c,s]_let_u_breve"],
				"<^>!", ["cyr_[c,s]_let_yus_big"],
				"<^>!<+", ["cyr_[c,s]_let_u_diaeresis"],
				"<^>!>+", ["cyr_[c,s]_let_u_macron"],
				"<^>!<!", ["cyr_[c,s]_lig_uk"],
			),
			"Ф", Map(
				"<^>!", ["cyr_[c,s]_let_fita"]
			),
			"Х", Map(
				"<^>!", ["cyr_[c,s]_let_h_shha"],
				"<^>!<!", ["cyr_[c,s]_let_h_descender"],
			),
			"Ц", Map(),
			"Ч", Map(
				"<^>!", ["cyr_[c,s]_let_tshe"],
				"<^>!<+", ["cyr_[c,s]_let_ch_diaeresis"],
				"<^>!<!", ["cyr_[c,s]_let_ch_descender"],
				"<^>!<!<+", ["cyr_[c,s]_let_ch_djerv"],
			),
			"Ш", Map(),
			"Щ", Map(),
			"Ъ", Map(
				"<^>!", ["cyr_[c,s]_let_u_straight"],
				"<^>!>+", ["cyr_[c,s]_let_u_straight_stroke_short"],
			),
			"Ы", Map(
				"<^>!", ["cyr_[c,s]_dig_yeru_with_back_yer"],
				"<^>!<!", ["cyr_[c,s]_let_y_yn"],
				"<^>!<+", ["cyr_[c,s]_let_yery_diaeresis"]
			),
			"Ь", Map(
				"<^>!<!", ["cyr_[c,s]_let_semisoft_sign"]
			),
			"Э", Map(
				"<^>!", ["cyr_[c,s]_let_ye_anchor"],
				"<^>!<+", ["cyr_[c,s]_let_ye_diaeresis"],
				"<^>!>+", ["cyr_[c,s]_let_schwa"],
				"<^>!<+>+", ["cyr_[c,s]_let_schwa_diaeresis"],
			),
			"Ю", Map(
				"<^>!", ["quote_angle_right_double"],
				"<^>!<+", ["quote_right_double_ghost_ru"],
				"<^>!>+", ["quote_low_9_double_reversed"],
				"<^>!<!", ["quote_right_double"],
				"<^>!<!<+", ["quote_angle_right"]
			),
			"Я", Map(
				"<^>!", ["cyr_[c,s]_let_yus_little"],
				"<^>!<+", ["cyr_[c,s]_lig_a_iotified"],
			)
		)
	),
	"Ligatured", Map(
		"Flat", Map(
			"A", (K) => BindHandler.TimeSend(K, Map(
				"A", (*) => BindHandler.CapsSend(K, ["lat_c_lig_aa", "lat_s_lig_aa"]),
				"E", (*) => BindHandler.CapsSend(K, ["lat_c_lig_ae", "lat_s_lig_ae"]),
				"U", (*) => BindHandler.CapsSend(K, ["lat_c_lig_au", "lat_s_lig_au"]),
				"O", (*) => BindHandler.CapsSend(K, ["lat_c_lig_ao", "lat_s_lig_ao"]),
				"V", (*) => BindHandler.CapsSend(K, ["lat_c_lig_av", "lat_s_lig_av"]),
				"Y", (*) => BindHandler.CapsSend(K, ["lat_c_lig_ay", "lat_s_lig_ay"]),
			), (*) => BindHandler.CapsSend(K, ["lat_c_let_a", "lat_s_let_a"])),
			"O", (K) => BindHandler.TimeSend(K, Map(
				"E", (*) => BindHandler.CapsSend(K, ["lat_c_lig_oe", "lat_s_lig_oe"]),
				"U", (*) => BindHandler.CapsSend(K, ["lat_c_lig_ou", "lat_s_lig_ou"]),
				"O", (*) => BindHandler.CapsSend(K, ["lat_c_lig_oo", "lat_s_lig_oo"]),
				"I", (*) => BindHandler.CapsSend(K, ["lat_c_lig_oi", "lat_s_lig_oi"]),
			), (*) => BindHandler.CapsSend(K, ["lat_c_let_o", "lat_s_let_o"])),
			"S", (K) => BindHandler.TimeSend(K, Map(
				"S", (*) => BindHandler.CapsSend(K, ["lat_c_lig_s_eszett", "lat_s_lig_s_eszett"]),
			), (*) => BindHandler.CapsSend(K, ["lat_c_let_s", "lat_s_let_s"])),
		),
		"Moded", Map()
	)
)