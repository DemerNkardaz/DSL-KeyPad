bindingMaps := {
	important: Map(
		"Flat", Map(
			"RAlt", (*) => ProceedCompose(),
		),
		"Moded", Map(
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
			"ArrUp", Map(
				"<#<!", (*) => KeyboardBinder.ToggleNumStyle("superscript"),
				"<#<!>+", (*) => KeyboardBinder.ToggleNumStyle("roman"),
			),
			"ArrDown", Map(
				"<#<!", (*) => KeyboardBinder.ToggleNumStyle("subscript"),
			),
			"PgUp", Map("<#<!", (*) => FindCharacterPage(),),
			"Home", Map("<#<!", (*) => Panel.Panel(), "<^>!<#<!", (*) => OpenPanel()),
			"Space", Map("<#<!", (*) => GroupActivator("Spaces"),),
			"HyphenMinus", Map("<#<!", (*) => GroupActivator("Dashes", "-"),),
			"Apostrophe", Map("<#<!", (*) => GroupActivator("Quotes", "'"),),
			"NumpadAdd", Map("<#<!", (*) => CharacterInserter().NumHook()),
			"NumpadDiv", Map("<#<!", (*) => CharacterInserter("Altcode").NumHook()),
			"A", Map("<#<!", (*) => CharacterInserter("Altcode").InputDialog(),),
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
		)),
	keyboardDefault: Map(
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
			"Ё", ["cyr_c_let_yo", "cyr_s_let_yo"],
			"Ж", ["cyr_c_let_zh", "cyr_s_let_zh"],
			"З", ["cyr_c_let_z", "cyr_s_let_z"],
			"И", ["cyr_c_let_i", "cyr_s_let_i"],
			"Й", ["cyr_c_let_iy", "cyr_s_let_iy"],
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
			"Ъ", ["cyr_c_let_yeru", "cyr_s_let_yeru"],
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
	romanDigits: Map(
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
			"ⅴ", Map(
				"<+:Caps", ["lat_c_num_50", "lat_s_num_50"],
				">+:Caps", ["lat_c_num_500", "lat_s_num_500"],
				"<^>!", "lat_c_num_5000",
				"<^>!>+", "lat_c_num_50000",
			),
			"0", Map(
				">+:Caps", ["lat_c_num_100", "lat_s_num_100"],
				"<^>!:Caps", ["lat_c_num_1000", "lat_s_num_1000"],
				"<^>!>+", "lat_c_num_10000",
				"<^>!<+", "lat_c_num_100000",
			),
		),
	),
	subscriptDigits: Map(
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
	superscriptDigits: Map(
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
	diacritic: Map(
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
	common: Map(
		"Flat", Map(
			"NumpadSub", "minus",
			"NumpadDiv", "division",
			"NumpadMult", "multiplication"
		),
		"Moded", Map(
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
				"<^>!", ["france_left"],
				"<^>!<+", ["quote_low_9_double"],
				"<^>!>+", ["quote_low_9_double"],
				"<^>!<!", ["quote_left_double"],
				"<^>!<!<+", ["france_single_left"],
				"<^>!<+>+", ["quote_low_9_single"]
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
			"Ю", Map(
				"<^>!", ["france_right"],
				"<^>!<+", ["quote_right_double_ghost_ru"],
				"<^>!>+", ["quote_low_9_double_reversed"],
				"<^>!<!", ["quote_right_double"],
				"<^>!<!<+", ["france_single_right"]
			),
			"Я", Map(
				"<^>!", ["cyr_c_let_yus_little", "cyr_s_let_yus_little"],
				"<^>!<+", ["cyr_c_let_a_iotified", "cyr_s_let_a_iotified"],
			)
		)
	),
}