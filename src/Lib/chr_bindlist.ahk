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
				"C", Map(
					"<^>!<!", ["medieval_c"],
				),
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
				"I", Map(
					">+", ["futhark_eihwaz"],
				),
				"J", Map(
					"<+", ["futhork_ger"],
					">+", ["futhork_ior"],
				),
				"K", Map(
					"<+", ["futhork_cealc"],
					">+", ["futhork_calc"],
					"<^>!", ["futhark_younger_kaun"],
				),
				"L", Map(
					"<^>!", ["futhark_younger_later_l"],
				),
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
				"P", Map(
					"<^>!", ["futhark_younger_later_p"],
				),
				"S", Map(
					"<+", ["futhork_sigel"],
					">+", ["futhork_stan"],
					"<^>!<+", ["futhark_younger_sol_short_twig"],
				),
				"T", Map(
					">+", ["futhark_thurisaz"],
					"<^>!<+", ["futhark_younger_tyr_short_twig"],
				),
				"X", Map(
					"<^>!<!", ["medieval_x"],
				),
				"Y", Map(
					">+", ["futhark_younger_icelandic_yr"],
					"<^>!", ["futhark_younger_yr"],
					"<^>!<+", ["futhark_younger_yr_short_twig"],
					"<+", ["futhork_yr"],
				),
				"Z", Map(
					"<^>!<!", ["medieval_z"],
				),
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
				"А", ["glagolitic_c_let_az", "glagolitic_s_let_az"],
				"Б", ["glagolitic_c_let_buky", "glagolitic_s_let_buky"],
				"В", ["glagolitic_c_let_vede", "glagolitic_s_let_vede"],
				"Г", ["glagolitic_c_let_glagoli", "glagolitic_s_let_glagoli"],
				"Д", ["glagolitic_c_let_dobro", "glagolitic_s_let_dobro"],
				"Е", ["glagolitic_c_let_yestu", "glagolitic_s_let_yestu"],
				"Ё", ["glagolitic_c_let_yo", "glagolitic_s_let_yo"],
				"Ж", ["glagolitic_c_let_zhivete", "glagolitic_s_let_zhivete"],
				"З", ["glagolitic_c_let_zemlja", "glagolitic_s_let_zemlja"],
				"И", ["glagolitic_c_let_i", "glagolitic_s_let_i"],
				"Й", ["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"],
				"К", ["glagolitic_c_let_kako", "glagolitic_s_let_kako"],
				"Л", ["glagolitic_c_let_ljudije", "glagolitic_s_let_ljudije"],
				"М", ["glagolitic_c_let_myslite", "glagolitic_s_let_myslite"],
				"Н", ["glagolitic_c_let_nashi", "glagolitic_s_let_nashi"],
				"О", ["glagolitic_c_let_onu", "glagolitic_s_let_onu"],
				"П", ["glagolitic_c_let_pokoji", "glagolitic_s_let_pokoji"],
				"Р", ["glagolitic_c_let_ritsi", "glagolitic_s_let_ritsi"],
				"С", ["glagolitic_c_let_slovo", "glagolitic_s_let_slovo"],
				"Т", ["glagolitic_c_let_tvrido", "glagolitic_s_let_tvrido"],
				"У", ["glagolitic_c_let_uku", "glagolitic_s_let_uku"],
				"Ф", ["glagolitic_c_let_fritu", "glagolitic_s_let_fritu"],
				"Х", ["glagolitic_c_let_heru", "glagolitic_s_let_heru"],
				"Ц", ["glagolitic_c_let_tsi", "glagolitic_s_let_tsi"],
				"Ч", ["glagolitic_c_let_chrivi", "glagolitic_s_let_chrivi"],
				"Ш", ["glagolitic_c_let_sha", "glagolitic_s_let_sha"],
				"Щ", ["glagolitic_c_let_shta", "glagolitic_s_let_shta"],
				"Ъ", ["glagolitic_c_let_yeru", "glagolitic_s_let_yeru"],
				"Ы", ["glagolitic_c_let_yery", "glagolitic_s_let_yery"],
				"Ь", ["glagolitic_c_let_yeri", "glagolitic_s_let_yeri"],
				"Э", ["glagolitic_c_let_small_yus", "glagolitic_s_let_small_yus"],
				"Ю", ["glagolitic_c_let_yu", "glagolitic_s_let_yu"],
				"Я", ["glagolitic_c_let_yati", "glagolitic_s_let_yati"],
			),
			"Moded", Map(
				"А", Map(
					"<^>!", ["glagolitic_c_let_trokutasti_a", "glagolitic_s_let_trokutasti_a"]
				),
				"Ё", Map(
					"<!", ["glagolitic_c_let_big_yus_iotified", "glagolitic_s_let_big_yus_iotified"]
				),
				"Ж", Map(
					"<^>!", ["glagolitic_c_let_djervi", "glagolitic_s_let_djervi"]
				),
				"И", Map(
					"<^>!", ["glagolitic_c_let_initial_izhe", "glagolitic_s_let_initial_izhe"],
					"<+", ["glagolitic_c_let_izhe", "glagolitic_s_let_izhe"],
					"<^>!<+", ["glagolitic_c_let_izhitsa", "glagolitic_s_let_izhitsa"],
				),
				"О", Map(
					"<^>!", ["glagolitic_c_let_otu", "glagolitic_s_let_otu"],
					"<!", ["glagolitic_c_let_big_yus", "glagolitic_s_let_big_yus"],
				),
				"П", Map(
					"<^>!", ["glagolitic_c_let_pe", "glagolitic_s_let_pe"]
				),
				"С", Map(
					"<^>!", ["glagolitic_c_let_dzelo", "glagolitic_s_let_dzelo"]
				),
				"Х", Map(
					"<^>!", ["glagolitic_c_let_spider_ha", "glagolitic_s_let_spider_ha"]
				),
				"Ф", Map(
					"<^>!", ["glagolitic_c_let_fita", "glagolitic_s_let_fita"]
				),
				"Ъ", Map(
					"<^>!", ["glagolitic_c_let_shtapic", "glagolitic_s_let_shtapic"]
				),
				"Э", Map(
					"<^>!", ["glagolitic_c_let_small_yus_iotified", "glagolitic_s_let_small_yus_iotified"]
				),
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
				"<#<!", (*) => GroupActivator("Diacritics Primary", "F1"),
				"<^>!", (*) => KeyboardBinder.ToggleDefaultMode(),
				"<^>!<!", (*) => KeyboardBinder.ToggleLigaturedMode(),
				"<^>!>+", (*) => Auxiliary.ToggleInputMode(),
			),
			"F2", Map(
				"<#<!", (*) => GroupActivator("Diacritics Secondary", "F2"),
				"<^>!", (*) => InputScriptProcessor(),
				"<^>!>+", (*) => InputScriptProcessor("pinYin"),
				"<^>!<+", (*) => InputScriptProcessor("karaShiki"),
				"<^>!<!", (*) => InputScriptProcessor("autoDiacritics"),
			),
			"F3", Map(
				"<#<!", (*) => GroupActivator("Diacritics Tertiary", "F3"),
			),
			"F6", Map(
				"<#<!", (*) => GroupActivator("Diacritics Quatemary", "F6"),
			),
			"F7", Map(
				"<#<!", (*) => GroupActivator("Special Characters", "F7"),
			),
			"F12", Map(
				">^", (*) => KeyboardBinder.SwitchLayout("Latin"),
				">+", (*) => KeyboardBinder.SwitchLayout("Cyrillic")
			),
			"Up", Map(
				"<#<!", (*) => KeyboardBinder.ToggleNumStyle("Superscript"),
				"<#<!>+", (*) => KeyboardBinder.ToggleNumStyle("Roman"),
			),
			"Down", Map(
				"<#<!", (*) => KeyboardBinder.ToggleNumStyle("Subscript"),
			),
			"PgUp", Map("<#<!", (*) => FindCharacterPage(),),
			"Home", Map("<#<!", (*) => Panel.Panel(), "<^>!<#<!", (*) => OpenPanel()),
			"Space", Map("<#<!", (*) => GroupActivator("Spaces"),),
			"HyphenMinus", Map("<#<!", (*) => GroupActivator("Dashes", "-"),),
			"Apostrophe", Map("<#<!", (*) => GroupActivator("Quotes", "'"),),
			"A", Map("<#<!", (*) => Scripter.SelectorPanel("Glyph Variations")),
			"S", Map("<#<!", (*) => Scripter.SelectorPanel()),
			"F", Map("<#<!", (*) => ChrLib.SearchPrompt().send(),),
			"H", Map(
				">^", (*) => Util.StrSelToHTML("Entities"),
				">^>+", (*) => Util.StrSelToHTML(),
			),
			"J", Map(
				">^", (*) => Util.StrSelToHTML("Entities", True),
			),
			"L", Map("<#<!", (*) => ChrCrafter(),),
			"Comma", Map("<#<!", (*) => GetKeyScanCode()),
			"M", Map("<#<!", (*) => ToggleGroupMessage()),
			"Q", Map("<!", (*) => LangSeparatedCall(
				() => QuotatizeSelection("Double"),
				() => QuotatizeSelection("France")),
				"<!<+", (*) => LangSeparatedCall(
					() => QuotatizeSelection("Single"),
					() => QuotatizeSelection("Paw"))),
			"Y", Map(
				">^", (*) => ReplaceWithUnicode("CSS"),
			),
			"U", Map(
				"<#<!", (*) => CharacterInserter("Unicode").InputDialog(),
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
			"A", ["lat_c_let_a", "lat_s_let_a"],
			"B", ["lat_c_let_b", "lat_s_let_b"],
			"C", ["lat_c_let_c", "lat_s_let_c"],
			"D", ["lat_c_let_d", "lat_s_let_d"],
			"E", ["lat_c_let_e", "lat_s_let_e"],
			"F", ["lat_c_let_f", "lat_s_let_f"],
			"G", ["lat_c_let_g", "lat_s_let_g"],
			"H", ["lat_c_let_h", "lat_s_let_h"],
			"I", ["lat_c_let_i", "lat_s_let_i"],
			"J", ["lat_c_let_j", "lat_s_let_j"],
			"K", ["lat_c_let_k", "lat_s_let_k"],
			"L", ["lat_c_let_l", "lat_s_let_l"],
			"M", ["lat_c_let_m", "lat_s_let_m"],
			"N", ["lat_c_let_n", "lat_s_let_n"],
			"O", ["lat_c_let_o", "lat_s_let_o"],
			"P", ["lat_c_let_p", "lat_s_let_p"],
			"Q", ["lat_c_let_q", "lat_s_let_q"],
			"R", ["lat_c_let_r", "lat_s_let_r"],
			"S", ["lat_c_let_s", "lat_s_let_s"],
			"T", ["lat_c_let_t", "lat_s_let_t"],
			"U", ["lat_c_let_u", "lat_s_let_u"],
			"V", ["lat_c_let_v", "lat_s_let_v"],
			"W", ["lat_c_let_w", "lat_s_let_w"],
			"X", ["lat_c_let_x", "lat_s_let_x"],
			"Y", ["lat_c_let_y", "lat_s_let_y"],
			"Z", ["lat_c_let_z", "lat_s_let_z"],
			; Cyrillic alphabet (А-Я)
			"А", ["cyr_c_let_a", "cyr_s_let_a"],
			"Б", ["cyr_c_let_b", "cyr_s_let_b"],
			"В", ["cyr_c_let_v", "cyr_s_let_v"],
			"Г", ["cyr_c_let_g", "cyr_s_let_g"],
			"Д", ["cyr_c_let_d", "cyr_s_let_d"],
			"Е", ["cyr_c_let_ye", "cyr_s_let_ye"],
			"Ё", ["cyr_c_let_ye__diaeresis", "cyr_s_let_ye__diaeresis"],
			"Ж", ["cyr_c_let_zh", "cyr_s_let_zh"],
			"З", ["cyr_c_let_z", "cyr_s_let_z"],
			"И", ["cyr_c_let_i", "cyr_s_let_i"],
			"Й", ["cyr_c_let_i__breve", "cyr_s_let_i__breve"],
			"К", ["cyr_c_let_k", "cyr_s_let_k"],
			"Л", ["cyr_c_let_l", "cyr_s_let_l"],
			"М", ["cyr_c_let_m", "cyr_s_let_m"],
			"Н", ["cyr_c_let_n", "cyr_s_let_n"],
			"О", ["cyr_c_let_o", "cyr_s_let_o"],
			"П", ["cyr_c_let_p", "cyr_s_let_p"],
			"Р", ["cyr_c_let_r", "cyr_s_let_r"],
			"С", ["cyr_c_let_s", "cyr_s_let_s"],
			"Т", ["cyr_c_let_t", "cyr_s_let_t"],
			"У", ["cyr_c_let_u", "cyr_s_let_u"],
			"Ф", ["cyr_c_let_f", "cyr_s_let_f"],
			"Х", ["cyr_c_let_h", "cyr_s_let_h"],
			"Ц", ["cyr_c_let_ts", "cyr_s_let_ts"],
			"Ч", ["cyr_c_let_ch", "cyr_s_let_ch"],
			"Ш", ["cyr_c_let_sh", "cyr_s_let_sh"],
			"Щ", ["cyr_c_let_shch", "cyr_s_let_shch"],
			"Ъ", ["cyr_c_let_yer", "cyr_s_let_yer"],
			"Ы", ["cyr_c_let_yery", "cyr_s_let_yery"],
			"Ь", ["cyr_c_let_yeri", "cyr_s_let_yeri"],
			"Э", ["cyr_c_let_e", "cyr_s_let_e"],
			"Ю", ["cyr_c_let_yu", "cyr_s_let_yu"],
			"Я", ["cyr_c_let_ya", "cyr_s_let_ya"],
			"І", ["cyr_c_let_i_decimal", "cyr_s_let_i_decimal"],
			"Ѣ", ["cyr_c_let_yat", "cyr_s_let_yat"]
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
			"1:Caps", ["lat_c_num_1", "lat_s_num_1"],
			"2:Caps", ["lat_c_num_2", "lat_s_num_2"],
			"3:Caps", ["lat_c_num_3", "lat_s_num_3"],
			"4:Caps", ["lat_c_num_4", "lat_s_num_4"],
			"5:Caps", ["lat_c_num_5", "lat_s_num_5"],
			"6:Caps", ["lat_c_num_6", "lat_s_num_6"],
			"7:Caps", ["lat_c_num_7", "lat_s_num_7"],
			"8:Caps", ["lat_c_num_8", "lat_s_num_8"],
			"9:Caps", ["lat_c_num_9", "lat_s_num_9"],
			"0:Caps", ["lat_c_num_10", "lat_s_num_10"],
		),
		"Moded", Map(
			; Digits
			"1", Map("<+:Caps", ["lat_c_num_11", "lat_s_num_11"]),
			"2", Map("<+:Caps", ["lat_c_num_12", "lat_s_num_12"]),
			"5", Map(
				"<+:Caps", ["lat_c_num_50", "lat_s_num_50"],
				">+:Caps", ["lat_c_num_500", "lat_s_num_500"],
				"<^>!", "lat_c_num_5000",
				"<^>!>+", "lat_c_num_50000",
				"<^>!<!", "lat_c_num_50_early",
			),
			"6", Map("<^>!<!", "lat_c_num_6_late"),
			"0", Map(
				">+:Caps", ["lat_c_num_100", "lat_s_num_100"],
				"<^>!:Caps", ["lat_c_num_1000", "lat_s_num_1000"],
				"<^>!>+", "lat_c_num_10000",
				"<^>!<+", "lat_c_num_100000",
			),
		),
	),
	"Subscript Digits", Map(
		"Flat", Map(
			; Digits
			"0:Caps", ["digit_0::modifier", "digit_0::subscript"],
			"1:Caps", ["digit_1::modifier", "digit_1::subscript"],
			"2:Caps", ["digit_2::modifier", "digit_2::subscript"],
			"3:Caps", ["digit_3::modifier", "digit_3::subscript"],
			"4:Caps", ["digit_4::modifier", "digit_4::subscript"],
			"5:Caps", ["digit_5::modifier", "digit_5::subscript"],
			"6:Caps", ["digit_6::modifier", "digit_6::subscript"],
			"7:Caps", ["digit_7::modifier", "digit_7::subscript"],
			"8:Caps", ["digit_8::modifier", "digit_8::subscript"],
			"9:Caps", ["digit_9::modifier", "digit_9::subscript"],
			"Equals:Caps", ["equals::modifier", "equals::subscript"],
			"HyphenMinus:Caps", ["minus::modifier", "minus::subscript"],
		),
		"Moded", Map(
			; Digits
			"9", Map("+:Caps", ["left_parenthesis::modifier", "left_parenthesis::subscript"]),
			"0", Map("+:Caps", ["right_parenthesis::modifier", "right_parenthesis::subscript"]),
			"Equals", Map("+:Caps", ["plus::modifier", "plus::subscript"]),
		)
	),
	"Superscript Digits", Map(
		"Flat", Map(
			; Digits
			"0:Caps", ["digit_0::subscript", "digit_0::modifier"],
			"1:Caps", ["digit_1::subscript", "digit_1::modifier"],
			"2:Caps", ["digit_2::subscript", "digit_2::modifier"],
			"3:Caps", ["digit_3::subscript", "digit_3::modifier"],
			"4:Caps", ["digit_4::subscript", "digit_4::modifier"],
			"5:Caps", ["digit_5::subscript", "digit_5::modifier"],
			"6:Caps", ["digit_6::subscript", "digit_6::modifier"],
			"7:Caps", ["digit_7::subscript", "digit_7::modifier"],
			"8:Caps", ["digit_8::subscript", "digit_8::modifier"],
			"9:Caps", ["digit_9::subscript", "digit_9::modifier"],
			"Equals:Caps", ["equals::subscript", "equals::modifier"],
			"HyphenMinus:Caps", ["minus::subscript", "minus::modifier"],
		),
		"Moded", Map(
			; Digits
			"9", Map("+:Caps", ["left_parenthesis::subscript", "left_parenthesis::modifier"]),
			"0", Map("+:Caps", ["right_parenthesis::subscript", "right_parenthesis::modifier"]),
			"Equals", Map("+:Caps", ["plus::subscript", "plus::modifier"]),
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
			"NumpadDiv", (K) => BindHandler.TimeSend(K, Map(),
				(*) => BindHandler.Send(K, "division")),
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
				"<^>!:Caps", ["prime_reversed_single", "prime_single"],
				"<^>!>+:Caps", ["prime_reversed_double", "prime_double"],
				"<^>!<+:Caps", ["prime_reversed_triple", "prime_triple"],
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
				"<^>!", ["left_bracket_with_quill"],
				"<^>!>+", ["left_white_bracket"],
				"<^>!<+", ["left_white_tortoise_shell"],
			),
			"RightBracket", Map(
				"<^>!<!", ["right_cjk_tortoise_shell"],
				"<^>!<!<+", ["right_cjk_corner_bracket"],
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
				"<^>!<+", ["quote_left_single"],
				"<^>!>+", ["quote_low_9_double"],
				"<^>!<+>+", ["quote_low_9_single"],
				"<^>!<!", ["france_left"],
				"<^>!<!<+", ["france_single_left"]
			),
			"Dot", Map(
				"<^>!", ["quote_right_double"],
				"<^>!<+", ["quote_right_single"],
				"<^>!>+", ["quote_low_9_double_reversed"],
				"<^>!<!", ["france_right"],
				"<^>!<!<+", ["france_single_right"]
			),
			"Tilde", Map(
				"<^>!", "bullet",
				"<^>!<!", "bullet_hyphen",
				"<^>!<+", "interpunct",
				"<^>!>+", "quote_right_single",
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
				"<!", ["lat_c_let_a__acute", "lat_s_let_a__acute"],
				"<^>!", ["lat_c_let_a__breve", "lat_s_let_a__breve"],
				"<^>!<!", ["lat_c_let_a__circumflex", "lat_s_let_a__circumflex"],
				"<^>!<!<+", ["lat_c_let_a__ring_above", "lat_s_let_a__ring_above"],
				"<^>!<!>+", ["lat_c_let_a__ogonek", "lat_s_let_a__ogonek"],
				"<^>!>+", ["lat_c_let_a__macron", "lat_s_let_a__macron"],
				"<^>!<+", ["lat_c_let_a__diaeresis", "lat_s_let_a__diaeresis"],
				"<^>!<+>+", ["lat_c_let_a__tilde_above", "lat_s_let_a__tilde_above"],
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
				"<!", "degree",
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
				"<^>!<+>+", ["lat_c_let_e__tilde_above", "lat_s_let_e__tilde_above"],
				">+", ["lat_c_let_e__grave", "lat_s_let_e__grave"],
				"<+>+", ["lat_c_let_e__grave_double", "lat_s_let_e__grave_double"]),
			"F", Map(
				"<^>!", ["lat_c_let_f__dot_above", "lat_s_let_f__dot_above"],
				">+", "fahrenheit"),
			"G", Map("<!", ["lat_c_let_g__acute", "lat_s_let_g__acute"],
				"<^>!", ["lat_c_let_g__breve", "lat_s_let_g__breve"],
				"<^>!<!", ["lat_c_let_g__circumflex", "lat_s_let_g__circumflex"],
				"<^>!<!<+", ["lat_c_let_g__caron", "lat_s_let_g__caron"],
				"<^>!<!>+", ["lat_c_let_g__cedilla", "lat_s_let_g__cedilla"],
				"<^>!<+", ["lat_c_let_g_insular", "lat_s_let_g_insular"],
				"<^>!>+", ["lat_c_let_g__macron", "lat_s_let_g__macron"],
				"<^>!<+>+", ["lat_c_let_gamma", "lat_s_let_gamma"],
				">+", ["lat_c_let_g__dot_above", "lat_s_let_g__dot_above"]),
			"H", Map(
				"<!", ["lat_c_let_h_hwair", "lat_s_let_h_hwair"],
				"<^>!", ["lat_c_let_h__stroke_short", "lat_s_let_h__stroke_short"],
				"<^>!<!", ["lat_c_let_h__circumflex", "lat_s_let_h__circumflex"],
				"<^>!<!<+", ["lat_c_let_h__caron", "lat_s_let_h__caron"],
				"<^>!<!>+", ["lat_c_let_h__cedilla", "lat_s_let_h__cedilla"],
				"<^>!<+", ["lat_c_let_h__diaeresis", "lat_s_let_h__diaeresis"]),
			"I", Map("<!", ["lat_c_let_i__acute", "lat_s_let_i__acute"],
				"<^>!", ["lat_c_let_i__breve", "lat_s_let_i__breve"],
				"<^>!<!", ["lat_c_let_i__circumflex", "lat_s_let_i__circumflex"],
				"<^>!<!<+", ["lat_c_let_i__caron", "lat_s_let_i__caron"],
				"<^>!<!>+", ["lat_c_let_i__ogonek", "lat_s_let_i__ogonek"],
				"<^>!>+", ["lat_c_let_i__macron", "lat_s_let_i__macron"],
				"<^>!<+", ["lat_c_let_i__diaeresis", "lat_s_let_i__diaeresis"],
				"<^>!<+>+", ["lat_c_let_i__tilde_above", "lat_s_let_i__tilde_above"],
				">+", ["lat_c_let_i__grave", "lat_s_let_i__grave"],
				"<+>+", ["lat_c_let_i__grave_double", "lat_s_let_i__grave_double"],
				"<^>!<!<+>+", ["lat_c_let_i__dot_above", "lat_s_let_i_dotless"]),
			"J", Map(
				"<^>!", ["lat_c_let_j__stroke_short", "lat_s_let_j__stroke_short"],
				"<^>!>+", ["lat_c_let_j_yogh", "lat_s_let_j_yogh"],
				"<^>!<!", ["lat_c_let_j__circumflex", "lat_s_let_j__circumflex"],
				"<^>!<!<+", ["lat_c_let_j", "lat_s_let_j__caron"],
			),
			"K", Map("<!", ["lat_c_let_k__acute", "lat_s_let_k__acute"],
				"<^>!<!", ["lat_c_let_k__dot_below", "lat_s_let_k__dot_below"],
				"<^>!<!<+", ["lat_c_let_k__caron", "lat_s_let_k__caron"],
				"<^>!<!>+", ["lat_c_let_k__cedilla", "lat_s_let_k__cedilla"],
				"<^>!<+", ["lat_c_let_k_cuatrillo", "lat_s_let_k_cuatrillo"],
				">+", "kelvin"
			),
			"L", Map(
				"<!", ["lat_c_let_l__acute", "lat_s_let_l__acute"],
				"<^>!", ["lat_c_let_l__solidus_short", "lat_s_let_l__solidus_short"],
				"<^>!<!<+", ["lat_c_let_l__caron", "lat_s_let_l__caron"],
				"<^>!<!>+", ["lat_c_let_l__cedilla", "lat_s_let_l__cedilla"],
				"<^>!<+>+", ["lat_c_let_l__circumflex_below", "lat_s_let_l__circumflex_below"]),
			"M", Map("<!", ["lat_c_let_m__acute", "lat_s_let_m__acute"],
				"<^>!", ["lat_c_let_m__dot_above", "lat_s_let_m__dot_above"],
				"<^>!<!", ["lat_c_let_m__dot_below", "lat_s_let_m__dot_below"],
				"<^>!>+", ["lat_c_let_m__common_hook", "lat_s_let__m_common_hook"]),
			"N", Map("<!", ["lat_c_let_n__acute", "lat_s_let_n__acute"],
				"<^>!", ["lat_c_let_n__tilde_above", "lat_s_let_n__tilde_above"],
				"<^>!<!", ["lat_c_let_n__dot_below", "lat_s_let_n__dot_below"],
				"<^>!<!<+", ["lat_c_let_n__caron", "lat_s_let_n__caron"],
				"<^>!<!>+", ["lat_c_let_n__cedilla", "lat_s_let_n__cedilla"],
				"<^>!>+", ["lat_c_let_n__common_hook", "lat_s_let_n_common_hook"],
				"<^>!<+", ["let_c_let_n__descender", "let_s_let_n__descender"],
				"<^>!<+>+", ["lat_c_let_n__dot_above", "lat_s_let_n__dot_above"],
				">+", ["lat_c_let_n__grave", "lat_s_let_n__grave"]),
			"O", Map("<!", ["lat_c_let_o__acute", "lat_s_let_o__acute"],
				"<^>!", ["lat_c_let_o__solidus_long", "lat_s_let_o__solidus_long"],
				"<^>!<!", ["lat_c_let_o__circumflex", "lat_s_let_o__circumflex"],
				"<^>!<!<+", ["lat_c_let_o__caron", "lat_s_let_o__caron"],
				"<^>!<!>+", ["lat_c_let_o__ogonek", "lat_s_let_o__ogonek"],
				"<^>!>+", ["lat_c_let_o__macron", "lat_s_let_o__macron"],
				"<^>!<+", ["lat_c_let_o__diaeresis", "lat_s_let_o__diaeresis"],
				"<^>!<+>+", ["lat_c_let_o__tilde_above", "lat_s_let_o__tilde_above"],
				">+", ["lat_c_let_o__grave", "lat_s_let_o__grave"],
				"<+>+", ["lat_c_let_o__grave_double", "lat_s_let_o__grave_double"],
				"<^>!<!<+>+", ["lat_c_let_o__acute_double", "lat_s_let_o__acute_double"]),
			"P", Map("<!", ["lat_c_let_p__acute", "lat_s_let_p__acute"],
				"<^>!", ["lat_c_let_p__dot_above", "lat_s_let_p_dot__above"],
				"<^>!<!", ["lat_c_let_p__squirrel_tail", "lat_s_let_p__squirrel_tail"],
				"<^>!<!<+", ["lat_c_let_p__flourish", "lat_s_let_p__flourish"],
				"<^>!<+", ["lat_c_let_p__stroke_short", "lat_s_let_p__stroke_short"],
				"<^>!>+", ["lat_c_let_p__common_hook", "lat_s_let_p__common_hook"]),
			"Q", Map(
				"<^>!<+", ["lat_c_let_q_tresillo", "lat_s_let_q_tresillo"],
				"<^>!>+", ["lat_c_let_q__common_hook", "lat_s_let_q__common_hook"]),
			"R", Map("<!", ["lat_c_let_r__acute", "lat_s_let_r__acute"],
				"<^>!", ["lat_c_let_r__dot_above", "lat_s_let_r__dot_above"],
				"<^>!<!", ["lat_c_let_r_dot_below", "lat_s_let_r__dot_below"],
				"<^>!<!<+", ["lat_c_let_r__caron", "lat_s_let_r__caron"],
				"<^>!<!>+", ["lat_c_let_r__cedilla", "lat_s_let_r__cedilla"],
				"<^>!<+", ["lat_c_let_yr", "lat_s_let_yr"],
				"<^>!>+", ["lat_c_let_r_rotunda", "lat_s_let_r_rotunda"],
				"<+>+", ["lat_c_let_r__grave_double", "lat_s_let_r__grave_double"]),
			"S", Map("<!", ["lat_c_let_s__acute", "lat_s_let_s__acute"],
				"<^>!", ["lat_c_let_s__comma_below", "lat_s_let_s__comma_below"],
				"<^>!<!", ["lat_c_let_s__circumflex", "lat_s_let_s__circumflex"],
				"<^>!<!<+", ["lat_c_let_s__caron", "lat_s_let_s__caron"],
				"<^>!<!>+", ["lat_c_let_s__cedilla", "lat_s_let_s__cedilla"],
				"<^>!>+", "lat_s_let_s_long",
				"<^>!<+>+", ["lat_c_let_s_sigma", "lat_s_let_s_sigma"],
				"<^>!<+", ["lat_c_lig_s_eszett", "lat_s_lig_s_eszett"]),
			"T", Map(
				"<^>!", ["lat_c_let_t__comma_below", "lat_s_let_t__comma_below"],
				"<^>!<!", ["lat_c_let_t__dot_below", "lat_s_let_t__dot_below"],
				"<^>!<!<+", ["lat_c_let_t__caron", "lat_s_let_t__caron"],
				"<^>!<!>+", ["lat_c_let_t__cedilla", "lat_s_let_t__cedilla"],
				"<^>!>+", ["lat_c_let_t_thorn", "lat_s_let_t_thorn"],
				"<^>!<+", ["lat_c_let_t__dot_above", "lat_s_let_t__dot_above"],
				"<^>!<+>+", ["lat_c_let_et_tironian", "lat_s_let_et_tironian"]),
			"U", Map(
				"<!", ["lat_c_let_u__acute", "lat_s_let_u__acute"],
				"<^>!", ["lat_c_let_u__breve", "lat_s_let_u__breve"],
				"<^>!<!", ["lat_c_let_u__circumflex", "lat_s_let_u__circumflex"],
				"<^>!<!<+", ["lat_c_let_u__ring_above", "lat_s_let_u__ring_above"],
				"<^>!<!>+", ["lat_c_let_u__ogonek", "lat_s_let_u__ogonek"],
				"<^>!>+", ["lat_c_let_u__macron", "lat_s_let_u__macron"],
				"<^>!<+", ["lat_c_let_u__diaeresis", "lat_s_let_u__diaeresis"],
				"<^>!<+>+", ["lat_c_let_u__tilde_above", "lat_s_let_u__tilde_above"],
				">+", ["lat_c_let_u__grave", "lat_s_let_u__grave"],
				"<+>+", ["lat_c_let_u__grave_double", "lat_s_let_u__grave_double"],
				"<^>!<!<+>+", ["lat_c_let_u__acute_double", "lat_s_let_u__acute_double"]),
			"V", Map(
				"<^>!", ["lat_c_let_v__solidus_long", "lat_s_let_v__solidus_long"],
				"<^>!<!", ["lat_c_let_v__dot_below", "lat_s_let_v__dot_below"],
				"<^>!<+", ["lat_c_let_v_middle_welsh", "lat_s_let_v_middle_welsh"],
				"<^>!>+", ["lat_c_let_vend", "lat_s_let_vend"],
				"<^>!<+>+", ["lat_c_let_v__tilde_above", "lat_s_let_v__tilde_above"]),
			"W", Map("<!", ["lat_c_let_w__acute", "lat_s_let_w__acute"],
				"<^>!", ["lat_c_let_w__dot_above", "lat_s_let_w__dot_above"],
				"<^>!<!", ["lat_c_let_w__circumflex", "lat_s_let_w__circumflex"],
				"<^>!<!<+", ["lat_c_let_w__dot_below", "lat_s_let_w__dot_below"],
				"<^>!<+", ["lat_c_let_w__diaeresis", "lat_s_let_w__diaeresis"],
				"<^>!>+", ["lat_c_let_w_wynn", "lat_s_let_w_wynn"],
				"<^>!<!>+", ["lat_c_let_w_anglicana", "lat_s_let_w_anglicana"],
				">+", ["lat_c_let_w__grave", "lat_s_let_w_grave"]),
			"X", Map(
				"<^>!", ["lat_c_let_x__dot_above", "lat_s_let_x__dot_above"],
				"<^>!<+", ["lat_c_let_x__diaeresis", "lat_s_let_x__diaeresis"]),
			"Y", Map("<!", ["lat_c_let_y_acute", "lat_s_let_y_acute"],
				"<^>!", ["lat_c_let_y_dot_above", "lat_s_let_y_dot_above"],
				"<^>!<!", ["lat_c_let_y_circumflex", "lat_s_let_y_circumflex"],
				"<^>!<!<+", ["lat_c_let_y_stroke_short", "lat_s_let_y__stroke_short"],
				"<^>!<!>+", ["lat_c_let_y__loop", "lat_s_let_y__loop"],
				"<^>!>+", ["lat_c_let_y__macron", "lat_s_let_y__macron"],
				"<^>!<+", ["lat_c_let_y__diaeresis", "lat_s_let_y__diaeresis"],
				"<^>!<+>+", ["lat_c_let_y__tilde_above", "lat_s_let_y__tilde_above"],
				">+", ["lat_c_let_y__grave", "lat_s_let_y__grave"]),
			"Z", Map("<!", ["lat_c_let_z__acute", "lat_s_let_z__acute"],
				"<^>!", ["lat_c_let_z__dot_above", "lat_s_let_z__dot_above"],
				"<^>!<!", ["lat_c_let_z__circumflex", "lat_s_let_z__circumflex"],
				"<^>!<!<+", ["lat_c_let_z__caron", "lat_s_let_z__caron"],
				"<^>!>+", ["lat_c_let_z_ezh", "lat_s_let_z_ezh"],
				"<^>!<+", ["lat_c_let_z__stroke_short", "lat_s_let_z__stroke_short"]),
			; Russian-Modifiers Keyboard Layout
			"А", Map(
				"<^>!", ["cyr_c_let_a__breve", "cyr_s_let_a__breve"],
				"<^>!<+", ["cyr_c_let_a__diaeresis", "cyr_s_let_a__diaeresis"]
			),
			"Б", Map(
				"<^>!", ["france_left"],
				"<^>!<+", ["quote_low_9_double"],
				"<^>!>+", ["quote_low_9_double"],
				"<^>!<!", ["quote_left_double"],
				"<^>!<!<+", ["france_single_left"],
				"<^>!<+>+", ["quote_low_9_single"]
			),
			"В", Map(),
			"Г", Map(
				"<!", ["cyr_c_let_g__acute", "cyr_s_let_g__acute"],
				"<^>!", ["cyr_c_let_g_upturn", "cyr_s_let_g_upturn"],
				"<^>!<+", ["cyr_c_let_g_stroke_short", "cyr_s_let_g_stroke_short"],
				"<^>!<!", ["cyr_c_let_g_descender", "cyr_s_let_g_descender"],
			),
			"Д", Map(),
			"Е", Map(
				"<!", ["cyr_c_let_e_breve", "cyr_s_let_e_breve"],
				">+", ["cyr_c_let_e_grave", "cyr_s_let_e_grave"],
				"<^>!", ["cyr_c_let_ye_yat", "cyr_s_let_ye_yat"],
				"<^>!<!", ["cyr_c_let_i_izhitsa", "cyr_s_let_i_izhitsa"]
			),
			"Ё", Map(),
			"Ж", Map(
				"<!", ["cyr_c_let_zhe_breve", "cyr_s_let_zhe_breve"],
				"<^>!", ["cyr_c_let_zh_dzhe", "cyr_s_let_zh_dzhe"],
				"<^>!<+", ["cyr_c_let_zhe_diaeresis", "cyr_s_let_zhe_diaeresis"],
				"<^>!>+", ["cyr_c_let_zh_dje", "cyr_s_let_zh_dje"],
				"<^>!<!", ["cyr_c_let_zhe_descender", "cyr_s_let_zhe_descender"],
			),
			"З", Map(
				"<^>!", ["cyr_c_let_z_dzelo", "cyr_s_let_z_dzelo"],
				"<^>!>+", ["cyr_c_let_z_zemlya", "cyr_s_let_z_zemlya"],
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
				"<^>!", ["cyr_c_let_i__breve", "cyr_s_let_i__breve"],
				"<^>!<!", ["cyr_c_let_j", "cyr_s_let_j"],
				"<^>!<!>+", ["cyr_c_let_i_breve_tail", "cyr_s_let_i_breve_tail"],
			),
			"К", Map(
				"<!", ["cyr_c_let_k_acute", "cyr_s_let_k_acute"],
				"<^>!", ["cyr_c_let_ksi", "cyr_s_let_ksi"],
				"<^>!<!", ["cyr_c_let_k_descender", "cyr_s_let_k_descender"],
			),
			"Л", Map(
				"<^>!", ["cyr_c_lig_lje", "cyr_s_lig_lje"],
				"<^>!<!", ["cyr_c_let_l_descender", "cyr_s_let_l_descender"],
				"<^>!<!>+", ["cyr_c_let_l_tail", "cyr_s_let_l_tail"],
				"<^>!<!<+", ["cyr_c_let_l_palochka", "cyr_s_let_l_palochka"]
			),
			"М", Map(
				"<^>!<!<+>+", ["cyr_c_let_m_tail", "cyr_s_let_m_tail"]
			),
			"Н", Map(
				"<^>!", ["cyr_c_lig_nje", "cyr_s_lig_nje"],
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
				"<^>!<!", ["cyr_c_lig_uk", "cyr_s_lig_uk"],
			),
			"Ф", Map(
				"<^>!", ["cyr_c_let_fita", "cyr_s_let_fita"]
			),
			"Х", Map(
				"<^>!", ["cyr_c_let_h_shha", "cyr_s_let_h_shha"],
				"<^>!<!", ["cyr_c_let_h_descender", "cyr_s_let_h_descender"],
			),
			"Ц", Map(),
			"Ч", Map(
				"<^>!", ["cyr_c_let_tshe", "cyr_s_let_tshe"],
				"<^>!<+", ["cyr_c_let_ch_diaeresis", "cyr_s_let_ch_diaeresis"],
				"<^>!<!", ["cyr_c_let_ch_descender", "cyr_s_let_ch_descender"],
				"<^>!<!<+", ["cyr_c_let_ch_djerv", "cyr_s_let_ch_djerv"],
			),
			"Ш", Map(),
			"Щ", Map(),
			"Ъ", Map(
				"<^>!", ["cyr_c_let_u_straight", "cyr_s_let_u_straight"],
				"<^>!>+", ["cyr_c_let_u_straight_stroke_short", "cyr_s_let_u_straight_stroke_short"],
			),
			"Ы", Map(
				"<^>!", ["cyr_c_dig_yeru_with_back_yer", "cyr_s_dig_yeru_with_back_yer"],
				"<^>!<!", ["cyr_c_let_yn", "cyr_s_let_yn"],
				"<^>!<+", ["cyr_c_let_yery_diaeresis", "cyr_s_let_yery_diaeresis"]
			),
			"Ь", Map(
				"<^>!<!", ["cyr_c_let_semisoft_sign", "cyr_s_let_semisoft_sign"]
			),
			"Э", Map(
				"<^>!", ["cyr_c_let_ye_anchor", "cyr_s_let_ye_anchor"],
				"<^>!<+", ["cyr_c_let_ye_diaeresis", "cyr_s_let_ye_diaeresis"],
				"<^>!>+", ["cyr_c_let_schwa", "cyr_s_let_schwa"],
				"<^>!<+>+", ["cyr_c_let_schwa_diaeresis", "cyr_s_let_schwa_diaeresis"],
			),
			"Ю", Map(
				"<^>!", ["france_right"],
				"<^>!<+", ["quote_right_double_ghost_ru"],
				"<^>!>+", ["quote_low_9_double_reversed"],
				"<^>!<!", ["quote_right_double"],
				"<^>!<!<+", ["france_single_right"]
			),
			"Я", Map(
				"<^>!", ["cyr_c_let_yus_little", "cyr_s_let_yus_little"],
				"<^>!<+", ["cyr_c_lig_a_iotified", "cyr_s_lig_a_iotified"],
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