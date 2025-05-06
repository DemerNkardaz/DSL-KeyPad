LibRegistrate(this) {
	local D := "dotted_circle"

	rawEntries := [
		;
		;
		; * Diacritics
		;
		;
		"acute", {
			unicode: "{U+0301}",
			tags: ["acute", "акут", "ударение"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			alterations: { uncombined: "{U+00B4}" },
			options: { groupKey: ["a", "ф"], fastKey: "A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"acute_double", {
			unicode: "{U+030B}",
			tags: ["double acute", "двойной акут", "двойное ударение"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			alterations: { uncombined: "{U+02DD}", modifier: "{U+02F6}" },
			options: { groupKey: ["A", "Ф"], fastKey: "<+ A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"acute_below", {
			unicode: "{U+0317}",
			tags: ["acute below", "акут снизу"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["a", "ф"], fastKey: ">+ A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"acute_tone_vietnamese", {
			unicode: "{U+0341}",
			tags: ["acute tone", "акут тона"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["A", "Ф"] },
			symbol: { category: "Diacritic Mark" },
		},
		"asterisk_above", {
			unicode: "{U+20F0}",
			tags: ["asterisk above", "астериск сверху"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: ["a", "ф"] },
			symbol: { category: "Diacritic Mark" },
		},
		"asterisk_below", {
			unicode: "{U+0359}",
			tags: ["asterisk below", "астериск снизу"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: ["A", "Ф"] },
			symbol: { category: "Diacritic Mark" },
		},
		"breve", {
			unicode: "{U+0306}", LaTeX: ["\u", "\breve"],
			tags: ["breve", "бреве", "кратка"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			alterations: { uncombined: "{U+02D8}" },
			options: { groupKey: ["b", "и"], fastKey: "B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"breve_inverted", {
			unicode: "{U+0311}",
			tags: ["inverted breve", "перевёрнутое бреве", "перевёрнутая кратка"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["B", "И"], fastKey: "<+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"breve_below", {
			unicode: "{U+032E}",
			tags: ["breve below", "бреве снизу", "кратка снизу"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["b", "и"], fastKey: ">+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"breve_inverted_below", {
			unicode: "{U+032F}",
			tags: ["inverted breve below", "перевёрнутое бреве снизу", "перевёрнутая кратка снизу"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["B", "И"], fastKey: "<+>+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"bridge_above", {
			unicode: "{U+0346}",
			tags: ["bridge above", "мостик сверху"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: ["b", "и"] },
			symbol: { category: "Diacritic Mark" },
		},
		"bridge_below", {
			unicode: "{U+032A}",
			tags: ["bridge below", "мостик снизу"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: ["B", "И"] },
			symbol: { category: "Diacritic Mark" },
		},
		"bridge_inverted_below", {
			unicode: "{U+033A}",
			tags: ["inverted bridge below", "перевёрнутый мостик снизу"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: [CtrlB] },
			symbol: { category: "Diacritic Mark" },
		},
		"circumflex", {
			unicode: "{U+0302}", LaTeX: ["\^", "\hat"],
			tags: ["circumflex", "циркумфлекс"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["c", "с"], fastKey: "C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"caron", {
			unicode: "{U+030C}", LaTeX: ["\v", "\check"],
			tags: ["caron", "hachek", "карон", "гачек"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["C", "С"], fastKey: "<+ C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"circumflex_below", {
			unicode: "{U+032D}",
			tags: ["circumflex below", "циркумфлекс снизу"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["c", "с"], fastKey: "<+>+ C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"caron_below", {
			unicode: "{U+032C}",
			tags: ["caron below", "карон снизу", "гачек снизу"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["C", "С"] },
			symbol: { category: "Diacritic Mark" },
		},
		"cedilla", {
			unicode: "{U+0327}", LaTeX: ["\c"],
			alterations: {
				uncombined: "{U+00B8}",
			},
			tags: ["cedilla", "седиль"],
			groups: ["Diacritics Tertiary", "Diacritics Fast Primary"],
			options: { groupKey: ["c", "с"], fastKey: ">+ C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above", {
			unicode: "{U+0313}",
			tags: ["comma above", "запятая сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: [",", "б"], fastKey: ", Б" },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_below", {
			unicode: "{U+0326}",
			tags: ["comma below", "запятая снизу"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["<", "Б"], fastKey: "<+ , Б" },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above_turned", {
			unicode: "{U+0312}",
			tags: ["turned comma above", "перевёрнутая запятая сверху"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: [",", "б"] },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above_reversed", {
			unicode: "{U+0314}",
			tags: ["reversed comma above", "зеркальная запятая сверху"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["<", "Б"] },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above_right", {
			unicode: "{U+0315}",
			tags: ["comma above right", "запятая сверху справа"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: [",", "б"] },
			symbol: { category: "Diacritic Mark" },
		},
		"candrabindu", {
			unicode: "{U+0310}",
			tags: ["candrabindu", "чандрабинду"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: ["C", "С"] },
			symbol: { category: "Diacritic Mark" },
		},
		"dot_above", {
			unicode: "{U+0307}", LaTeX: ["\.", "\dot"],
			alterations: {
				uncombined: "{U+02D9}",
			},
			tags: ["dot above", "точка сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["d", "в"], fastKey: "D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"diaeresis", {
			unicode: "{U+0308}", LaTeX: ["\`"", "\ddot"],
			alterations: {
				uncombined: "{U+00A8}",
			},
			tags: ["diaeresis", "диерезис"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["D", "В"], fastKey: "<+ D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"dot_below", {
			unicode: "{U+0323}", LaTeX: ["\d"],
			tags: ["dot below", "точка снизу"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["d", "в"], fastKey: ">+ D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"diaeresis_below", {
			unicode: "{U+0324}",
			tags: ["diaeresis below", "диерезис снизу"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["D", "В"], fastKey: "<+>+ D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"fermata", {
			unicode: "{U+0352}",
			tags: ["fermata", "фермата"],
			groups: ["Diacritics Tertiary", "Diacritics Fast Primary"],
			options: { groupKey: ["F", "А"], fastKey: "F А" },
			symbol: { category: "Diacritic Mark" },
		},
		"grave", {
			unicode: "{U+0300}", LaTeX: ["\``", "\grave"],
			alterations: {
				modifier: "{U+02F4}",
				uncombined: "{U+0060}",
			},
			tags: ["grave", "гравис"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["g", "п"], fastKey: "G П" },
			symbol: { category: "Diacritic Mark" },
		},
		"grave_double", {
			unicode: "{U+030F}",
			alterations: {
				modifier: "{U+02F5}",
			},
			tags: ["double grave", "двойной гравис"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["G", "П"], fastKey: "<+ G П" },
			symbol: { category: "Diacritic Mark" },
		},
		"grave_below", {
			unicode: "{U+0316}",
			tags: ["grave below", "гравис снизу"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["g", "п"] },
			symbol: { category: "Diacritic Mark" },
		},
		"grave_tone_vietnamese", {
			unicode: "{U+0340}",
			tags: ["grave tone", "гравис тона"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["G", "П"] },
			symbol: { category: "Diacritic Mark" },
		},
		"hook_above", {
			unicode: "{U+0309}",
			tags: ["hook above", "хвостик сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["h", "р"], fastKey: "H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"horn", {
			unicode: "{U+031B}",
			tags: ["horn", "рожок"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["H", "Р"], fastKey: "<+ H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"palatal_hook", {
			unicode: "{U+0321}",
			tags: ["palatal hook below", "палатальный крюк"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["h", "р"], fastKey: ">+ H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"retroflex_hook", {
			unicode: "{U+0322}",
			tags: ["retroflex hook below", "ретрофлексный крюк"],
			groups: ["Diacritics Secondary", "Diacritics Fast Primary"],
			options: { groupKey: ["H", "Р"], fastKey: "<+>+ H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"macron", {
			unicode: "{U+0304}", LaTeX: ["\=", "\bar"],
			alterations: {
				uncombined: "{U+00AF}",
			},
			tags: ["macron", "макрон"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["m", "ь"], fastKey: "M Ь" },
			symbol: { category: "Diacritic Mark" },
		},
		"macron_below", {
			unicode: "{U+0331}",
			tags: ["macron below", "макрон снизу"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["M", "Ь"], fastKey: "<+ M Ь" },
			symbol: { category: "Diacritic Mark" },
		},
		"ogonek", {
			unicode: "{U+0328}", LaTeX: ["\k"],
			alterations: {
				uncombined: "{U+02DB}",
			},
			tags: ["ogonek", "огонэк"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["o", "щ"], fastKey: "O Щ" },
			symbol: { category: "Diacritic Mark" },
		},
		"ogonek_above", {
			unicode: "{U+1DCE}",
			tags: ["ogonek above", "огонэк сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["O", "Щ"], fastKey: "<+ O Щ" },
			symbol: { category: "Diacritic Mark", font: "Noto Serif" },
		},
		"overline", {
			unicode: "{U+0305}",
			tags: ["overline", "черта сверху"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["o", "щ"] },
			symbol: { category: "Diacritic Mark" },
		},
		"overline_double", {
			unicode: "{U+033F}",
			tags: ["overline", "черта сверху"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["O", "Щ"] },
			symbol: { category: "Diacritic Mark" },
		},
		"low_line", {
			unicode: "{U+0332}",
			tags: ["low line", "черта снизу"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: ["o", "щ"] },
			symbol: { category: "Diacritic Mark" },
		},
		"low_line_double", {
			unicode: "{U+0333}",
			tags: ["dobule low line", "двойная черта снизу"],
			groups: ["Diacritics Tertiary"],
			options: { groupKey: ["O", "Щ"] },
			symbol: { category: "Diacritic Mark" },
		},
		"ring_above", {
			unicode: "{U+030A}",
			alterations: {
				uncombined: "{U+02DA}",
			},
			tags: ["ring above", "кольцо сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["r", "к"], fastKey: "R К" },
			symbol: { category: "Diacritic Mark" },
		},
		"ring_below", {
			unicode: "{U+0325}",
			alterations: {
				modifier: "{U+02F3}",
			},
			tags: ["ring above", "кольцо сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["R", "К"], fastKey: "<+ R К" },
			symbol: { category: "Diacritic Mark" },
		},
		"ring_below_double", {
			unicode: "{U+035A}",
			tags: ["double ring below", "двойное кольцо снизу"],
			groups: ["Diacritics Primary"],
			options: { groupKey: [CtrlR] },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical", {
			unicode: "{U+030D}",
			tags: ["vertical line", "вертикальная черта"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["v", "м"], fastKey: "V М" },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical_double", {
			unicode: "{U+030E}",
			tags: ["double vertical line", "двойная вертикальная черта"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["V", "М"], fastKey: "<+ V М" },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical_below", {
			unicode: "{U+0329}",
			tags: ["vertical line below", "вертикальная черта снизу"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["v", "м"] },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical_double_below", {
			unicode: "{U+0348}",
			tags: ["dobule vertical line below", "двойная вертикальная черта снизу"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["V", "М"] },
			symbol: { category: "Diacritic Mark" },
		},
		"stroke_short", {
			unicode: "{U+0335}",
			tags: ["short stroke", "короткое перечёркивание"],
			groups: ["Diacritics Quatemary", "Diacritics Fast Primary"],
			options: { groupKey: ["s", "ы"], fastKey: "S Ы" },
			symbol: { category: "Diacritic Mark" },
		},
		"stroke_long", {
			unicode: "{U+0336}",
			tags: ["long stroke", "длинное перечёркивание"],
			groups: ["Diacritics Quatemary", "Diacritics Fast Primary"],
			options: { groupKey: ["S", "Ы"], fastKey: "<+ S Ы" },
			symbol: { category: "Diacritic Mark" },
		},
		"solidus_short", {
			unicode: "{U+0337}",
			tags: ["short solidus", "короткая косая черта"],
			groups: ["Diacritics Quatemary", "Diacritics Fast Primary"],
			options: { groupKey: ["/"], fastKey: "/ ." },
			symbol: { category: "Diacritic Mark" },
		},
		"solidus_long", {
			unicode: "{U+0338}",
			tags: ["long solidus", "длинная косая черта"],
			groups: ["Diacritics Quatemary", "Diacritics Fast Primary"],
			options: { groupKey: ["/"], fastKey: "<+ / ." },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_above", {
			unicode: "{U+0303}", LaTeX: ["\~", "\tilde"],
			alterations: {
				modifier: "{U+02F7}",
				uncombined: "{U+02DC}",
			},
			tags: ["tilde", "тильда"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["t", "е"], fastKey: "T Е" },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_vertical", {
			unicode: "{U+033E}",
			tags: ["tilde vertical", "вертикальная тильда"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["T", "Е"], fastKey: "<+ T Е" },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_below", {
			unicode: "{U+0330}",
			tags: ["tilde below", "тильда снизу"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["t", "е"] },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_not", {
			unicode: "{U+034A}",
			tags: ["not tilde", "перечёрнутая тильда"],
			groups: ["Diacritics Secondary"],
			options: { groupKey: ["T", "Е"] },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_overlay", {
			unicode: "{U+0334}",
			tags: ["tilde overlay", "тильда посередине"],
			groups: ["Diacritics Quatemary"],
			options: { groupKey: ["t", "е"] },
			symbol: { category: "Diacritic Mark" },
		},
		"x_above", {
			unicode: "{U+033D}",
			tags: ["x above", "x сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["x", "ч"], fastKey: "X Ч" },
			symbol: { category: "Diacritic Mark" },
		},
		"x_below", {
			unicode: "{U+0353}",
			tags: ["x below", "x снизу"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["X", "Ч"], fastKey: "<+ X Ч" },
			symbol: { category: "Diacritic Mark" },
		},
		"zigzag_above", {
			unicode: "{U+035B}",
			tags: ["zigzag above", "зигзаг сверху"],
			groups: ["Diacritics Primary", "Diacritics Fast Primary"],
			options: { groupKey: ["z", "я"], fastKey: "Z Я" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_vzmet", {
			unicode: "{U+A66F}",
			tags: ["взмет кириллицы", "cyrillic vzmet"],
			groups: ["Diacritics Primary", "Cyrillic Diacritics"],
			options: { groupKey: [CtrlD], altLayoutKey: "<^<! В" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_titlo", {
			unicode: "{U+0483}",
			tags: ["титло кириллицы", "cyrillic titlo"],
			groups: ["Diacritics Primary", "Cyrillic Diacritics"],
			options: { groupKey: ["n", "т"], altLayoutKey: "<^<! Т" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_palatalization", {
			unicode: "{U+0484}",
			tags: ["палатализация кириллицы", "cyrillic palatalization"],
			groups: ["Diacritics Tertiary", "Cyrillic Diacritics"],
			options: { groupKey: ["g", "п"], altLayoutKey: "<^<! П" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_pokrytie", {
			unicode: "{U+0487}",
			tags: ["покрытие кириллицы", "cyrillic pokrytie"],
			groups: ["Diacritics Tertiary", "Cyrillic Diacritics"],
			options: { groupKey: ["G", "П"], altLayoutKey: "<^<!<+ П" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_dasia_pneumata", {
			unicode: "{U+0485}",
			tags: ["густое придыхание кириллицы", "cyrillic dasia pneumata"],
			groups: ["Diacritics Quatemary", "Cyrillic Diacritics", "Diacritics Fast Primary"],
			options: { groupKey: ["g", "п"], fastKey: ">+ G П", altLayoutKey: "<^<!>+ П" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_psili_pneumata", {
			unicode: "{U+0486}",
			tags: ["тонкое придыхание кириллицы", "cyrillic psili pneumata"],
			groups: ["Diacritics Quatemary", "Cyrillic Diacritics", "Diacritics Fast Primary"],
			options: { groupKey: ["G", "П"], fastKey: "<+>+ G П", altLayoutKey: "<^<!<+>+ П" },
			symbol: { category: "Diacritic Mark" },
		},
		;
		;
		; * Default Math & Puncuation
		;
		;
		"digit_[0,1,2,3,4,5,6,7,8,9]", {
			unicode: [
				"{U+0030}",
				"{U+0031}",
				"{U+0032}",
				"{U+0033}",
				"{U+0034}",
				"{U+0035}",
				"{U+0036}",
				"{U+0037}",
				"{U+0038}",
				"{U+0039}"
			],
			alterations: [{
				doubleStruck: "{U+1D7D8}",
				bold: "{U+1D7CE}",
				sansSerif: "{U+1D7E2}",
				sansSerifBold: "{U+1D7EC}",
				monospace: "{U+1D7F6}",
				modifier: "{U+2070}",
				subscript: "{U+2080}"
			}, {
				doubleStruck: "{U+1D7D9}",
				bold: "{U+1D7CF}",
				sansSerif: "{U+1D7E3}",
				sansSerifBold: "{U+1D7ED}",
				monospace: "{U+1D7F7}",
				modifier: "{U+00B9}",
				subscript: "{U+2081}"
			}, {
				doubleStruck: "{U+1D7DA}",
				bold: "{U+1D7D0}",
				sansSerif: "{U+1D7E4}",
				sansSerifBold: "{U+1D7EE}",
				monospace: "{U+1D7F8}",
				modifier: "{U+00B2}",
				subscript: "{U+2082}"
			}, {
				doubleStruck: "{U+1D7DB}",
				bold: "{U+1D7D1}",
				sansSerif: "{U+1D7E5}",
				sansSerifBold: "{U+1D7EF}",
				monospace: "{U+1D7F9}",
				modifier: "{U+00B3}",
				subscript: "{U+2083}"
			}, {
				doubleStruck: "{U+1D7DC}",
				bold: "{U+1D7D2}",
				sansSerif: "{U+1D7E6}",
				sansSerifBold: "{U+1D7F0}",
				monospace: "{U+1D7FA}",
				modifier: "{U+2074}",
				subscript: "{U+2084}"
			}, {
				doubleStruck: "{U+1D7DD}",
				bold: "{U+1D7D3}",
				sansSerif: "{U+1D7E7}",
				sansSerifBold: "{U+1D7F1}",
				monospace: "{U+1D7FB}",
				modifier: "{U+2075}",
				subscript: "{U+2085}"
			}, {
				doubleStruck: "{U+1D7DE}",
				bold: "{U+1D7D4}",
				sansSerif: "{U+1D7E8}",
				sansSerifBold: "{U+1D7F2}",
				monospace: "{U+1D7FC}",
				modifier: "{U+2076}",
				subscript: "{U+2086}"
			}, {
				doubleStruck: "{U+1D7DF}",
				bold: "{U+1D7D5}",
				sansSerif: "{U+1D7E9}",
				sansSerifBold: "{U+1D7F3}",
				monospace: "{U+1D7FD}",
				modifier: "{U+2077}",
				subscript: "{U+2087}"
			}, {
				doubleStruck: "{U+1D7E0}",
				bold: "{U+1D7D6}",
				sansSerif: "{U+1D7EA}",
				sansSerifBold: "{U+1D7F4}",
				monospace: "{U+1D7FE}",
				modifier: "{U+2078}",
				subscript: "{U+2088}"
			}, {
				doubleStruck: "{U+1D7E1}",
				bold: "{U+1D7D7}",
				sansSerif: "{U+1D7EB}",
				sansSerifBold: "{U+1D7F5}",
				monospace: "{U+1D7FF}",
				modifier: "{U+2079}",
				subscript: "{U+2089}"
			}],
			options: { noCalc: True }
		},
		;
		;
		; * Default Latin
		;
		;
		"lat_[c,s]_let_a", {
			unicode: ["{U+0041}", "{U+0061}"],
			alterations: [{
				modifier: "{U+1D2C}",
				italic: "{U+1D434}",
				italicBold: "{U+1D468}",
				bold: "{U+1D400}",
				fraktur: "{U+1D504}",
				frakturBold: "{U+1D56C}",
				script: "{U+1D49C}",
				scriptBold: "{U+1D4D0}",
				doubleStruck: "{U+1D538}",
				sansSerif: "{U+1D5A0}",
				sansSerifItalic: "{U+1D608}",
				sansSerifItalicBold: "{U+1D63C}",
				sansSerifBold: "{U+1D5D4}",
				monospace: "{U+1D670}",
				smallCapital: "{U+1D00}"
			}, {
				combining: "{U+0363}",
				modifier: "{U+1D43}",
				subscript: "{U+2090}",
				italic: "{U+1D44E}",
				italicBold: "{U+1D482}",
				bold: "{U+1D41A}",
				fraktur: "{U+1D51E}",
				frakturBold: "{U+1D586}",
				script: "{U+1D4B6}",
				scriptBold: "{U+1D4EA}",
				doubleStruck: "{U+1D552}",
				sansSerif: "{U+1D5BA}",
				sansSerifItalic: "{U+1D622}",
				sansSerifItalicBold: "{U+1D656}",
				sansSerifBold: "{U+1D5EE}",
				monospace: "{U+1D68A}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_b", {
			unicode: ["{U+0042}", "{U+0062}"],
			alterations: [{
				modifier: "{U+1D2E}",
				italic: "{U+1D435}",
				italicBold: "{U+1D469}",
				bold: "{U+1D401}",
				fraktur: "{U+1D505}",
				frakturBold: "{U+1D56D}",
				script: "{U+212C}",
				scriptBold: "{U+1D4D1}",
				doubleStruck: "{U+1D539}",
				sansSerif: "{U+1D5A1}",
				sansSerifItalic: "{U+1D609}",
				sansSerifItalicBold: "{U+1D63D}",
				sansSerifBold: "{U+1D5D5}",
				monospace: "{U+1D671}",
				smallCapital: "{U+0299}"
			}, {
				combining: "{U+1DE8}",
				modifier: "{U+1D47}",
				italic: "{U+1D44F}",
				italicBold: "{U+1D483}",
				bold: "{U+1D41B}",
				fraktur: "{U+1D51F}",
				frakturBold: "{U+1D587}",
				script: "{U+1D4B7}",
				scriptBold: "{U+1D4EB}",
				doubleStruck: "{U+1D553}",
				sansSerif: "{U+1D5BB}",
				sansSerifItalic: "{U+1D623}",
				sansSerifItalicBold: "{U+1D657}",
				sansSerifBold: "{U+1D5EF}",
				monospace: "{U+1D68B}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_c", {
			unicode: ["{U+0043}", "{U+0063}"],
			alterations: [{
				modifier: "{U+A7F2}",
				italic: "{U+1D436}",
				italicBold: "{U+1D46A}",
				bold: "{U+1D402}",
				fraktur: "{U+212D}",
				frakturBold: "{U+1D56E}",
				script: "{U+1D49E}",
				scriptBold: "{U+1D4D2}",
				doubleStruck: "{U+2102}",
				sansSerif: "{U+1D5A2}",
				sansSerifItalic: "{U+1D60A}",
				sansSerifItalicBold: "{U+1D63E}",
				sansSerifBold: "{U+1D5D6}",
				monospace: "{U+1D672}",
				smallCapital: "{U+1D04}"
			}, {
				combining: "{U+0368}",
				modifier: "{U+1D9C}",
				italic: "{U+1D450}",
				italicBold: "{U+1D484}",
				bold: "{U+1D41C}",
				fraktur: "{U+1D520}",
				frakturBold: "{U+1D588}",
				script: "{U+1D4B8}",
				scriptBold: "{U+1D4EC}",
				doubleStruck: "{U+1D554}",
				sansSerif: "{U+1D5BC}",
				sansSerifItalic: "{U+1D624}",
				sansSerifItalicBold: "{U+1D658}",
				sansSerifBold: "{U+1D5F0}",
				monospace: "{U+1D68C}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_d", {
			unicode: ["{U+0044}", "{U+0064}"],
			alterations: [{
				modifier: "{U+1D30}",
				italic: "{U+1D437}",
				italicBold: "{U+1D46B}",
				bold: "{U+1D403}",
				fraktur: "{U+1D507}",
				frakturBold: "{U+1D56F}",
				script: "{U+1D49F}",
				scriptBold: "{U+1D4D3}",
				doubleStruck: "{U+1D53B}",
				doubleStruckItalic: "{U+2145}",
				sansSerif: "{U+1D5A3}",
				sansSerifItalic: "{U+1D60B}",
				sansSerifItalicBold: "{U+1D63F}",
				sansSerifBold: "{U+1D5D7}",
				monospace: "{U+1D673}",
				smallCapital: "{U+1D05}"
			}, {
				combining: "{U+0369}",
				modifier: "{U+1D48}",
				italic: "{U+1D451}",
				italicBold: "{U+1D485}",
				bold: "{U+1D41D}",
				fraktur: "{U+1D521}",
				frakturBold: "{U+1D589}",
				script: "{U+1D4B9}",
				scriptBold: "{U+1D4ED}",
				doubleStruck: "{U+1D555}",
				doubleStruckItalic: "{U+2146}",
				sansSerif: "{U+1D5BD}",
				sansSerifItalic: "{U+1D625}",
				sansSerifItalicBold: "{U+1D659}",
				sansSerifBold: "{U+1D5F1}",
				monospace: "{U+1D68D}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_e", {
			unicode: ["{U+0045}", "{U+0065}"],
			alterations: [{
				modifier: "{U+1D31}",
				italic: "{U+1D438}",
				italicBold: "{U+1D46C}",
				bold: "{U+1D404}",
				fraktur: "{U+1D508}",
				frakturBold: "{U+1D570}",
				script: "{U+2130}",
				scriptBold: "{U+1D4D4}",
				doubleStruck: "{U+1D53C}",
				sansSerif: "{U+1D5A4}",
				sansSerifItalic: "{U+1D60C}",
				sansSerifItalicBold: "{U+1D640}",
				sansSerifBold: "{U+1D5D8}",
				monospace: "{U+1D674}",
				smallCapital: "{U+1D07}"
			}, {
				combining: "{U+0364}",
				modifier: "{U+1D49}",
				subscript: "{U+2091}",
				italic: "{U+1D452}",
				italicBold: "{U+1D486}",
				bold: "{U+1D41E}",
				fraktur: "{U+1D522}",
				frakturBold: "{U+1D58A}",
				script: "{U+212F}",
				scriptBold: "{U+1D4EE}",
				doubleStruck: "{U+1D556}",
				doubleStruckItalic: "{U+2147}",
				sansSerif: "{U+1D5BE}",
				sansSerifItalic: "{U+1D626}",
				sansSerifItalicBold: "{U+1D65A}",
				sansSerifBold: "{U+1D5F2}",
				monospace: "{U+1D68E}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_f", {
			unicode: ["{U+0046}", "{U+0066}"],
			alterations: [{
				modifier: "{U+A7F3}",
				italic: "{U+1D439}",
				italicBold: "{U+1D46D}",
				bold: "{U+1D405}",
				fraktur: "{U+1D509}",
				frakturBold: "{U+1D571}",
				script: "{U+2131}",
				scriptBold: "{U+1D4D5}",
				doubleStruck: "{U+1D53D}",
				sansSerif: "{U+1D5A5}",
				sansSerifItalic: "{U+1D60D}",
				sansSerifItalicBold: "{U+1D641}",
				sansSerifBold: "{U+1D5D9}",
				monospace: "{U+1D675}",
				smallCapital: "{U+A730}"
			}, {
				combining: "{U+1DEB}",
				modifier: "{U+1DA0}",
				italic: "{U+1D453}",
				italicBold: "{U+1D487}",
				bold: "{U+1D41F}",
				fraktur: "{U+1D523}",
				frakturBold: "{U+1D58B}",
				script: "{U+1D4BB}",
				scriptBold: "{U+1D4EF}",
				doubleStruck: "{U+1D557}",
				sansSerif: "{U+1D5BF}",
				sansSerifItalic: "{U+1D627}",
				sansSerifItalicBold: "{U+1D65B}",
				sansSerifBold: "{U+1D5F3}",
				monospace: "{U+1D68F}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_g", {
			unicode: ["{U+0047}", "{U+0067}"],
			alterations: [{
				combining: "{U+1DDB}",
				modifier: "{U+1D33}",
				italic: "{U+1D43A}",
				italicBold: "{U+1D46E}",
				bold: "{U+1D406}",
				fraktur: "{U+1D50A}",
				frakturBold: "{U+1D572}",
				script: "{U+1D4A2}",
				scriptBold: "{U+1D4D6}",
				doubleStruck: "{U+1D53E}",
				sansSerif: "{U+1D5A6}",
				sansSerifItalic: "{U+1D60E}",
				sansSerifItalicBold: "{U+1D642}",
				sansSerifBold: "{U+1D5DA}",
				monospace: "{U+1D676}",
				smallCapital: "{U+0262}"
			}, {
				combining: "{U+1DDA}",
				modifier: "{U+1D4D}",
				italic: "{U+1D454}",
				italicBold: "{U+1D488}",
				bold: "{U+1D420}",
				fraktur: "{U+1D524}",
				frakturBold: "{U+1D58C}",
				script: "{U+210A}",
				scriptBold: "{U+1D4F0}",
				doubleStruck: "{U+1D558}",
				sansSerif: "{U+1D5C0}",
				sansSerifItalic: "{U+1D628}",
				sansSerifItalicBold: "{U+1D65C}",
				sansSerifBold: "{U+1D5F4}",
				monospace: "{U+1D690}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_h", {
			unicode: ["{U+0048}", "{U+0068}"],
			alterations: [{
				modifier: "{U+1D34}",
				italic: "{U+1D43B}",
				italicBold: "{U+1D46F}",
				bold: "{U+1D407}",
				fraktur: "{U+210C}",
				frakturBold: "{U+1D573}",
				script: "{U+210B}",
				scriptBold: "{U+1D4D7}",
				doubleStruck: "{U+210D}",
				sansSerif: "{U+1D5A7}",
				sansSerifItalic: "{U+1D60F}",
				sansSerifItalicBold: "{U+1D643}",
				sansSerifBold: "{U+1D5DB}",
				monospace: "{U+1D677}",
				smallCapital: "{U+029C}"
			}, {
				combining: "{U+036A}",
				modifier: "{U+02B0}",
				subscript: "{U+2095}",
				italic: "{U+210E}",
				italicBold: "{U+1D489}",
				bold: "{U+1D421}",
				fraktur: "{U+1D525}",
				frakturBold: "{U+1D58D}",
				script: "{U+1D4BD}",
				scriptBold: "{U+1D4F1}",
				doubleStruck: "{U+1D559}",
				sansSerif: "{U+1D5C1}",
				sansSerifItalic: "{U+1D629}",
				sansSerifItalicBold: "{U+1D65D}",
				sansSerifBold: "{U+1D5F5}",
				monospace: "{U+1D691}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_i", {
			unicode: ["{U+0049}", "{U+0069}"],
			alterations: [{
				modifier: "{U+1D35}",
				italic: "{U+1D43C}",
				italicBold: "{U+1D470}",
				bold: "{U+1D408}",
				fraktur: "{U+2111}",
				frakturBold: "{U+1D574}",
				script: "{U+2110}",
				scriptBold: "{U+1D4D8}",
				doubleStruck: "{U+1D540}",
				sansSerif: "{U+1D5A8}",
				sansSerifItalic: "{U+1D610}",
				sansSerifItalicBold: "{U+1D644}",
				sansSerifBold: "{U+1D5DC}",
				monospace: "{U+1D678}",
				smallCapital: "{U+026A}"
			}, {
				combining: "{U+0365}",
				subscript: "{U+1D62}",
				italic: "{U+1D456}",
				italicBold: "{U+1D48A}",
				bold: "{U+1D422}",
				fraktur: "{U+1D526}",
				frakturBold: "{U+1D58E}",
				script: "{U+1D4BE}",
				scriptBold: "{U+1D4F2}",
				doubleStruck: "{U+1D55A}",
				doubleStruckItalic: "{U+2148}",
				sansSerif: "{U+1D5C2}",
				sansSerifItalic: "{U+1D62A}",
				sansSerifItalicBold: "{U+1D65E}",
				sansSerifBold: "{U+1D5F6}",
				monospace: "{U+1D692}"
			}],
			options: { noCalc: True },
			recipe: [[Chr(0x0130) "/"], [Chr(0x0131) "${dot_above}"]],
		},
		"lat_[c,s]_let_j", {
			unicode: ["{U+004A}", "{U+006A}"],
			alterations: [{
				modifier: "{U+1D36}",
				italic: "{U+1D43D}",
				italicBold: "{U+1D471}",
				bold: "{U+1D409}",
				fraktur: "{U+1D50D}",
				frakturBold: "{U+1D575}",
				script: "{U+1D4A5}",
				scriptBold: "{U+1D4D9}",
				doubleStruck: "{U+1D541}",
				sansSerif: "{U+1D5A9}",
				sansSerifItalic: "{U+1D611}",
				sansSerifItalicBold: "{U+1D645}",
				sansSerifBold: "{U+1D5DD}",
				monospace: "{U+1D679}",
				smallCapital: "{U+1D0A}"
			}, {
				modifier: "{U+02B2}",
				subscript: "{U+2C7C}",
				italic: "{U+1D457}",
				italicBold: "{U+1D48B}",
				bold: "{U+1D423}",
				fraktur: "{U+1D527}",
				frakturBold: "{U+1D58F}",
				script: "{U+1D4BF}",
				scriptBold: "{U+1D4F3}",
				doubleStruck: "{U+1D55B}",
				doubleStruckItalic: "{U+2149}",
				sansSerif: "{U+1D5C3}",
				sansSerifItalic: "{U+1D62B}",
				sansSerifItalicBold: "{U+1D65F}",
				sansSerifBold: "{U+1D5F7}",
				monospace: "{U+1D693}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_k", {
			unicode: ["{U+004B}", "{U+006B}"],
			alterations: [{
				modifier: "{U+1D37}",
				italic: "{U+1D43E}",
				italicBold: "{U+1D472}",
				bold: "{U+1D40A}",
				fraktur: "{U+1D50E}",
				frakturBold: "{U+1D576}",
				script: "{U+1D4A6}",
				scriptBold: "{U+1D4DA}",
				doubleStruck: "{U+1D542}",
				sansSerif: "{U+1D5AA}",
				sansSerifItalic: "{U+1D612}",
				sansSerifItalicBold: "{U+1D646}",
				sansSerifBold: "{U+1D5DE}",
				monospace: "{U+1D67A}",
				smallCapital: "{U+1D0B}"
			}, {
				combining: "{U+1DDC}",
				modifier: "{U+1D4F}",
				subscript: "{U+2096}",
				italic: "{U+1D458}",
				italicBold: "{U+1D48C}",
				bold: "{U+1D424}",
				fraktur: "{U+1D528}",
				frakturBold: "{U+1D590}",
				script: "{U+1D4C0}",
				scriptBold: "{U+1D4F4}",
				doubleStruck: "{U+1D55C}",
				sansSerif: "{U+1D5C4}",
				sansSerifItalic: "{U+1D62C}",
				sansSerifItalicBold: "{U+1D660}",
				sansSerifBold: "{U+1D5F8}",
				monospace: "{U+1D694}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_l", {
			unicode: ["{U+004C}", "{U+006C}"],
			alterations: [{
				combining: "{U+1DDE}",
				modifier: "{U+1D38}",
				italic: "{U+1D43F}",
				italicBold: "{U+1D473}",
				bold: "{U+1D40B}",
				fraktur: "{U+1D50F}",
				frakturBold: "{U+1D577}",
				script: "{U+2112}",
				scriptBold: "{U+1D4DB}",
				doubleStruck: "{U+1D543}",
				sansSerif: "{U+1D5AB}",
				sansSerifItalic: "{U+1D613}",
				sansSerifItalicBold: "{U+1D647}",
				sansSerifBold: "{U+1D5DF}",
				monospace: "{U+1D67B}",
				smallCapital: "{U+029F}"
			}, {
				combining: "{U+1DDD}",
				modifier: "{U+02E1}",
				subscript: "{U+2097}",
				italic: "{U+1D459}",
				italicBold: "{U+1D48D}",
				bold: "{U+1D425}",
				fraktur: "{U+1D529}",
				frakturBold: "{U+1D591}",
				script: "{U+1D4C1}",
				scriptBold: "{U+1D4F5}",
				doubleStruck: "{U+1D55D}",
				sansSerif: "{U+1D5C5}",
				sansSerifItalic: "{U+1D62D}",
				sansSerifItalicBold: "{U+1D661}",
				sansSerifBold: "{U+1D5F9}",
				monospace: "{U+1D695}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_m", {
			unicode: ["{U+004D}", "{U+006D}"],
			alterations: [{
				combining: "{U+1DDF}",
				modifier: "{U+1D39}",
				italic: "{U+1D440}",
				italicBold: "{U+1D474}",
				bold: "{U+1D40C}",
				fraktur: "{U+1D510}",
				frakturBold: "{U+1D578}",
				script: "{U+2133}",
				scriptBold: "{U+1D4DC}",
				doubleStruck: "{U+1D544}",
				sansSerif: "{U+1D5AC}",
				sansSerifItalic: "{U+1D614}",
				sansSerifItalicBold: "{U+1D648}",
				sansSerifBold: "{U+1D5E0}",
				monospace: "{U+1D67C}",
				smallCapital: "{U+1D0D}"
			}, {
				combining: "{U+036B}",
				modifier: "{U+1D50}",
				subscript: "{U+2098}",
				italic: "{U+1D45A}",
				italicBold: "{U+1D48E}",
				bold: "{U+1D426}",
				fraktur: "{U+1D52A}",
				frakturBold: "{U+1D592}",
				script: "{U+1D4C2}",
				scriptBold: "{U+1D4F6}",
				doubleStruck: "{U+1D55E}",
				sansSerif: "{U+1D5C6}",
				sansSerifItalic: "{U+1D62E}",
				sansSerifItalicBold: "{U+1D662}",
				sansSerifBold: "{U+1D5FA}",
				monospace: "{U+1D696}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_n", {
			unicode: ["{U+004E}", "{U+006E}"],
			alterations: [{
				combining: "{U+1DE1}",
				modifier: "{U+1D3A}",
				italic: "{U+1D441}",
				italicBold: "{U+1D475}",
				bold: "{U+1D40D}",
				fraktur: "{U+1D511}",
				frakturBold: "{U+1D579}",
				script: "{U+1D4A9}",
				scriptBold: "{U+1D4DD}",
				doubleStruck: "{U+2115}",
				sansSerif: "{U+1D5AD}",
				sansSerifItalic: "{U+1D615}",
				sansSerifItalicBold: "{U+1D649}",
				sansSerifBold: "{U+1D5E1}",
				monospace: "{U+1D67D}",
				smallCapital: "{U+0274}"
			}, {
				combining: "{U+1DE0}",
				subscript: "{U+2099}",
				italic: "{U+1D45B}",
				italicBold: "{U+1D48F}",
				bold: "{U+1D427}",
				fraktur: "{U+1D52B}",
				frakturBold: "{U+1D593}",
				script: "{U+1D4C3}",
				scriptBold: "{U+1D4F7}",
				doubleStruck: "{U+1D55F}",
				sansSerif: "{U+1D5C7}",
				sansSerifItalic: "{U+1D62F}",
				sansSerifItalicBold: "{U+1D663}",
				sansSerifBold: "{U+1D5FB}",
				monospace: "{U+1D697}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_o", {
			unicode: ["{U+004F}", "{U+006F}"],
			alterations: [{
				modifier: "{U+1D3C}",
				italic: "{U+1D442}",
				italicBold: "{U+1D476}",
				bold: "{U+1D40E}",
				fraktur: "{U+1D512}",
				frakturBold: "{U+1D57A}",
				script: "{U+1D4AA}",
				scriptBold: "{U+1D4DE}",
				doubleStruck: "{U+1D546}",
				sansSerif: "{U+1D5AE}",
				sansSerifItalic: "{U+1D616}",
				sansSerifItalicBold: "{U+1D64A}",
				sansSerifBold: "{U+1D5E2}",
				monospace: "{U+1D67E}",
				smallCapital: "{U+1D0F}"
			}, {
				combining: "{U+0366}",
				modifier: "{U+1D52}",
				subscript: "{U+2092}",
				italic: "{U+1D45C}",
				italicBold: "{U+1D490}",
				bold: "{U+1D428}",
				fraktur: "{U+1D52C}",
				frakturBold: "{U+1D594}",
				script: "{U+2134}",
				scriptBold: "{U+1D4F8}",
				doubleStruck: "{U+1D560}",
				sansSerif: "{U+1D5C8}",
				sansSerifItalic: "{U+1D630}",
				sansSerifItalicBold: "{U+1D664}",
				sansSerifBold: "{U+1D5FC}",
				monospace: "{U+1D698}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_p", {
			unicode: ["{U+0050}", "{U+0070}"],
			alterations: [{
				modifier: "{U+1D3E}",
				italic: "{U+1D443}",
				italicBold: "{U+1D477}",
				bold: "{U+1D40F}",
				fraktur: "{U+1D513}",
				frakturBold: "{U+1D57B}",
				script: "{U+1D4AB}",
				scriptBold: "{U+1D4DF}",
				doubleStruck: "{U+2119}",
				sansSerif: "{U+1D5AF}",
				sansSerifItalic: "{U+1D617}",
				sansSerifItalicBold: "{U+1D64B}",
				sansSerifBold: "{U+1D5E3}",
				monospace: "{U+1D67F}",
				smallCapital: "{U+1D18}"
			}, {
				combining: "{U+1DEE}",
				modifier: "{U+1D56}",
				subscript: "{U+209A}",
				italic: "{U+1D45D}",
				italicBold: "{U+1D491}",
				bold: "{U+1D429}",
				fraktur: "{U+1D52D}",
				frakturBold: "{U+1D595}",
				script: "{U+1D4C5}",
				scriptBold: "{U+1D4F9}",
				doubleStruck: "{U+1D561}",
				sansSerif: "{U+1D5C9}",
				sansSerifItalic: "{U+1D631}",
				sansSerifItalicBold: "{U+1D665}",
				sansSerifBold: "{U+1D5FD}",
				monospace: "{U+1D699}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_q", {
			unicode: ["{U+0051}", "{U+0071}"],
			alterations: [{
				modifier: "{U+A7F4}",
				italic: "{U+1D444}",
				italicBold: "{U+1D478}",
				bold: "{U+1D410}",
				fraktur: "{U+1D514}",
				frakturBold: "{U+1D57C}",
				script: "{U+1D4AC}",
				scriptBold: "{U+1D4E0}",
				doubleStruck: "{U+211A}",
				sansSerif: "{U+1D5B0}",
				sansSerifItalic: "{U+1D618}",
				sansSerifItalicBold: "{U+1D64C}",
				sansSerifBold: "{U+1D5E4}",
				monospace: "{U+1D680}",
				smallCapital: "{U+A7AF}"
			}, {
				italic: "{U+1D45E}",
				italicBold: "{U+1D492}",
				bold: "{U+1D42A}",
				fraktur: "{U+1D52E}",
				frakturBold: "{U+1D596}",
				script: "{U+1D4C6}",
				scriptBold: "{U+1D4FA}",
				doubleStruck: "{U+1D562}",
				sansSerif: "{U+1D5CA}",
				sansSerifItalic: "{U+1D632}",
				sansSerifItalicBold: "{U+1D666}",
				sansSerifBold: "{U+1D5FE}",
				monospace: "{U+1D69A}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_r", {
			unicode: ["{U+0052}", "{U+0072}"],
			alterations: [{
				combining: "{U+1DE2}",
				modifier: "{U+1D3F}",
				italic: "{U+1D445}",
				italicBold: "{U+1D479}",
				bold: "{U+1D411}",
				fraktur: "{U+211C}",
				frakturBold: "{U+1D57D}",
				script: "{U+211B}",
				scriptBold: "{U+1D4E1}",
				doubleStruck: "{U+211D}",
				sansSerif: "{U+1D5B1}",
				sansSerifItalic: "{U+1D619}",
				sansSerifItalicBold: "{U+1D64D}",
				sansSerifBold: "{U+1D5E5}",
				monospace: "{U+1D681}",
				smallCapital: "{U+0280}"
			}, {
				combining: "{U+036C}",
				modifier: "{U+02B3}",
				subscript: "{U+1D63}",
				italic: "{U+1D45F}",
				italicBold: "{U+1D493}",
				bold: "{U+1D42B}",
				fraktur: "{U+1D52F}",
				frakturBold: "{U+1D597}",
				script: "{U+1D4C7}",
				scriptBold: "{U+1D4FB}",
				doubleStruck: "{U+1D563}",
				sansSerif: "{U+1D5CB}",
				sansSerifItalic: "{U+1D633}",
				sansSerifItalicBold: "{U+1D667}",
				sansSerifBold: "{U+1D5FF}",
				monospace: "{U+1D69B}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_s", {
			unicode: ["{U+0053}", "{U+0073}"],
			alterations: [{
				italic: "{U+1D446}",
				italicBold: "{U+1D47A}",
				bold: "{U+1D412}",
				fraktur: "{U+1D516}",
				frakturBold: "{U+1D57E}",
				script: "{U+1D4AE}",
				scriptBold: "{U+1D4E2}",
				doubleStruck: "{U+1D54A}",
				sansSerif: "{U+1D5B2}",
				sansSerifItalic: "{U+1D61A}",
				sansSerifItalicBold: "{U+1D64E}",
				sansSerifBold: "{U+1D5E6}",
				monospace: "{U+1D682}",
				smallCapital: "{U+A731}"
			}, {
				combining: "{U+1DE4}",
				modifier: "{U+02E2}",
				subscript: "{U+209B}",
				italic: "{U+1D460}",
				italicBold: "{U+1D494}",
				bold: "{U+1D42C}",
				fraktur: "{U+1D530}",
				frakturBold: "{U+1D598}",
				script: "{U+1D4C8}",
				scriptBold: "{U+1D4FC}",
				doubleStruck: "{U+1D564}",
				sansSerif: "{U+1D5CC}",
				sansSerifItalic: "{U+1D634}",
				sansSerifItalicBold: "{U+1D668}",
				sansSerifBold: "{U+1D600}",
				monospace: "{U+1D69C}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_t", {
			unicode: ["{U+0054}", "{U+0074}"],
			alterations: [{
				modifier: "{U+1D40}",
				italic: "{U+1D447}",
				italicBold: "{U+1D47B}",
				bold: "{U+1D413}",
				fraktur: "{U+1D517}",
				frakturBold: "{U+1D57F}",
				script: "{U+1D4AF}",
				scriptBold: "{U+1D4E3}",
				doubleStruck: "{U+1D54B}",
				sansSerif: "{U+1D5B3}",
				sansSerifItalic: "{U+1D61B}",
				sansSerifItalicBold: "{U+1D64F}",
				sansSerifBold: "{U+1D5E7}",
				monospace: "{U+1D683}",
				smallCapital: "{U+1D1B}"
			}, {
				combining: "{U+036D}",
				modifier: "{U+1D57}",
				subscript: "{U+209C}",
				italic: "{U+1D461}",
				italicBold: "{U+1D495}",
				bold: "{U+1D42D}",
				fraktur: "{U+1D531}",
				frakturBold: "{U+1D599}",
				script: "{U+1D4C9}",
				scriptBold: "{U+1D4FD}",
				doubleStruck: "{U+1D565}",
				sansSerif: "{U+1D5CD}",
				sansSerifItalic: "{U+1D635}",
				sansSerifItalicBold: "{U+1D669}",
				sansSerifBold: "{U+1D601}",
				monospace: "{U+1D69D}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_u", {
			unicode: ["{U+0055}", "{U+0075}"],
			alterations: [{
				modifier: "{U+1D41}",
				italic: "{U+1D448}",
				italicBold: "{U+1D47C}",
				bold: "{U+1D414}",
				fraktur: "{U+1D518}",
				frakturBold: "{U+1D580}",
				script: "{U+1D4B0}",
				scriptBold: "{U+1D4E4}",
				doubleStruck: "{U+1D54C}",
				sansSerif: "{U+1D5B4}",
				sansSerifItalic: "{U+1D61C}",
				sansSerifItalicBold: "{U+1D650}",
				sansSerifBold: "{U+1D5E8}",
				monospace: "{U+1D684}",
				smallCapital: "{U+1D1C}"
			}, {
				combining: "{U+0367}",
				modifier: "{U+1D58}",
				subscript: "{U+1D64}",
				italic: "{U+1D462}",
				italicBold: "{U+1D496}",
				bold: "{U+1D42E}",
				fraktur: "{U+1D532}",
				frakturBold: "{U+1D59A}",
				script: "{U+1D4CA}",
				scriptBold: "{U+1D4FE}",
				doubleStruck: "{U+1D566}",
				sansSerif: "{U+1D5CE}",
				sansSerifItalic: "{U+1D636}",
				sansSerifItalicBold: "{U+1D66A}",
				sansSerifBold: "{U+1D602}",
				monospace: "{U+1D69E}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_v", {
			unicode: ["{U+0056}", "{U+0076}"],
			alterations: [{
				modifier: "{U+2C7D}",
				italic: "{U+1D449}",
				italicBold: "{U+1D47D}",
				bold: "{U+1D415}",
				fraktur: "{U+1D519}",
				frakturBold: "{U+1D581}",
				script: "{U+1D4B1}",
				scriptBold: "{U+1D4E5}",
				doubleStruck: "{U+1D54D}",
				sansSerif: "{U+1D5B5}",
				sansSerifItalic: "{U+1D61D}",
				sansSerifItalicBold: "{U+1D651}",
				sansSerifBold: "{U+1D5E9}",
				monospace: "{U+1D685}",
				smallCapital: "{U+1D20}"
			}, {
				combining: "{U+036E}",
				modifier: "{U+1D5B}",
				subscript: "{U+1D65}",
				italic: "{U+1D463}",
				italicBold: "{U+1D497}",
				bold: "{U+1D42F}",
				fraktur: "{U+1D533}",
				frakturBold: "{U+1D59B}",
				script: "{U+1D4CB}",
				scriptBold: "{U+1D4FF}",
				doubleStruck: "{U+1D567}",
				sansSerif: "{U+1D5CF}",
				sansSerifItalic: "{U+1D637}",
				sansSerifItalicBold: "{U+1D66B}",
				sansSerifBold: "{U+1D603}",
				monospace: "{U+1D69F}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_w", {
			unicode: ["{U+0057}", "{U+0077}"],
			alterations: [{
				modifier: "{U+1D42}",
				italic: "{U+1D44A}",
				italicBold: "{U+1D47E}",
				bold: "{U+1D416}",
				fraktur: "{U+1D51A}",
				frakturBold: "{U+1D582}",
				script: "{U+1D4B2}",
				scriptBold: "{U+1D4E6}",
				doubleStruck: "{U+1D54E}",
				sansSerif: "{U+1D5B6}",
				sansSerifItalic: "{U+1D61E}",
				sansSerifItalicBold: "{U+1D652}",
				sansSerifBold: "{U+1D5EA}",
				monospace: "{U+1D686}",
				smallCapital: "{U+1D21}"
			}, {
				combining: "{U+1DF1}",
				modifier: "{U+02B7}",
				italic: "{U+1D464}",
				italicBold: "{U+1D498}",
				bold: "{U+1D430}",
				fraktur: "{U+1D534}",
				frakturBold: "{U+1D59C}",
				script: "{U+1D4CC}",
				scriptBold: "{U+1D500}",
				doubleStruck: "{U+1D568}",
				sansSerif: "{U+1D5D0}",
				sansSerifItalic: "{U+1D638}",
				sansSerifItalicBold: "{U+1D66C}",
				sansSerifBold: "{U+1D604}",
				monospace: "{U+1D6A0}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_x", {
			unicode: ["{U+0058}", "{U+0078}"],
			alterations: [{
				italic: "{U+1D44B}",
				italicBold: "{U+1D47F}",
				bold: "{U+1D417}",
				fraktur: "{U+1D51B}",
				frakturBold: "{U+1D583}",
				script: "{U+1D4B3}",
				scriptBold: "{U+1D4E7}",
				doubleStruck: "{U+1D54F}",
				sansSerif: "{U+1D5B7}",
				sansSerifItalic: "{U+1D61F}",
				sansSerifItalicBold: "{U+1D653}",
				sansSerifBold: "{U+1D5EB}",
				monospace: "{U+1D687}",
				smallCapital: "{U+0078}"
			}, {
				combining: "{U+036F}",
				modifier: "{U+02E3}",
				subscript: "{U+2093}",
				italic: "{U+1D465}",
				italicBold: "{U+1D499}",
				bold: "{U+1D431}",
				fraktur: "{U+1D535}",
				frakturBold: "{U+1D59D}",
				script: "{U+1D4CD}",
				scriptBold: "{U+1D501}",
				doubleStruck: "{U+1D569}",
				sansSerif: "{U+1D5D1}",
				sansSerifItalic: "{U+1D639}",
				sansSerifItalicBold: "{U+1D66D}",
				sansSerifBold: "{U+1D605}",
				monospace: "{U+1D6A1}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_y", {
			unicode: ["{U+0059}", "{U+0079}"],
			alterations: [{
				italic: "{U+1D44C}",
				italicBold: "{U+1D480}",
				bold: "{U+1D418}",
				fraktur: "{U+1D51C}",
				frakturBold: "{U+1D584}",
				script: "{U+1D4B4}",
				scriptBold: "{U+1D4E8}",
				doubleStruck: "{U+1D550}",
				sansSerif: "{U+1D5B8}",
				sansSerifItalic: "{U+1D620}",
				sansSerifItalicBold: "{U+1D654}",
				sansSerifBold: "{U+1D5EC}",
				monospace: "{U+1D688}",
				smallCapital: "{U+028F}"
			}, {
				modifier: "{U+02B8}",
				italic: "{U+1D466}",
				italicBold: "{U+1D49A}",
				bold: "{U+1D432}",
				fraktur: "{U+1D536}",
				frakturBold: "{U+1D59E}",
				script: "{U+1D4CE}",
				scriptBold: "{U+1D502}",
				doubleStruck: "{U+1D56A}",
				sansSerif: "{U+1D5D2}",
				sansSerifItalic: "{U+1D63A}",
				sansSerifItalicBold: "{U+1D66E}",
				sansSerifBold: "{U+1D606}",
				monospace: "{U+1D6A2}"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_z", {
			unicode: ["{U+005A}", "{U+007A}"],
			alterations: [{
				italic: "{U+1D44D}",
				italicBold: "{U+1D481}",
				bold: "{U+1D419}",
				fraktur: "{U+2128}",
				frakturBold: "{U+1D585}",
				script: "{U+1D4B5}",
				scriptBold: "{U+1D4E9}",
				doubleStruck: "{U+2124}",
				sansSerif: "{U+1D5B9}",
				sansSerifItalic: "{U+1D621}",
				sansSerifItalicBold: "{U+1D655}",
				sansSerifBold: "{U+1D5ED}",
				monospace: "{U+1D689}",
				smallCapital: "{U+1D22}"
			}, {
				combining: "{U+1DE6}",
				modifier: "{U+1DBB}",
				italic: "{U+1D467}",
				italicBold: "{U+1D49B}",
				bold: "{U+1D433}",
				fraktur: "{U+1D537}",
				frakturBold: "{U+1D59F}",
				script: "{U+1D4CF}",
				scriptBold: "{U+1D503}",
				doubleStruck: "{U+1D56B}",
				sansSerif: "{U+1D5D3}",
				sansSerifItalic: "{U+1D63B}",
				sansSerifItalicBold: "{U+1D66F}",
				sansSerifBold: "{U+1D607}",
				monospace: "{U+1D6A3}"
			}],
			options: { noCalc: True }
		},
		;
		;
		; * Default Cyrillic
		;
		;
		"cyr_[c,s]_let_a", {
			unicode: ["{U+0410}", "{U+0430}"],
			alterations: [{}, { combining: "{U+2DF6}", modifier: "{U+1E030}", subscript: "{U+1E051}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_b", {
			unicode: ["{U+0411}", "{U+0431}"],
			alterations: [{}, { combining: "{U+2DE0}", modifier: "{U+1E031}", subscript: "{U+1E052}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_v", {
			unicode: ["{U+0412}", "{U+0432}"],
			alterations: [{}, { combining: "{U+2DE1}", modifier: "{U+1E032}", subscript: "{U+1E053}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_g", {
			unicode: ["{U+0413}", "{U+0433}"],
			alterations: [{}, { combining: "{U+2DE2}", modifier: "{U+1E033}", subscript: "{U+1E054}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_d", {
			unicode: ["{U+0414}", "{U+0434}"],
			alterations: [{}, { combining: "{U+2DE3}", modifier: "{U+1E034}", subscript: "{U+1E055}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ye", {
			unicode: ["{U+0415}", "{U+0435}"],
			alterations: [{}, { combining: "{U+2DF7}", modifier: "{U+1E035}", subscript: "{U+1E056}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_zh", {
			unicode: ["{U+0416}", "{U+0436}"],
			alterations: [{}, { combining: "{U+2DE4}", modifier: "{U+1E036}", subscript: "{U+1E057}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_z", {
			unicode: ["{U+0417}", "{U+0437}"],
			alterations: [{}, { combining: "{U+2DE5}", modifier: "{U+1E037}", subscript: "{U+1E058}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_i", {
			unicode: ["{U+0418}", "{U+0438}"],
			alterations: [{}, { combining: "{U+A675}", modifier: "{U+1E038}", subscript: "{U+1E059}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_k", {
			unicode: ["{U+041A}", "{U+043A}"],
			alterations: [{}, { combining: "{U+2DE6}", modifier: "{U+1E039}", subscript: "{U+1E05A}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_l", {
			unicode: ["{U+041B}", "{U+043B}"],
			alterations: [{}, { combining: "{U+2DE7}", modifier: "{U+1E03A}", subscript: "{U+1E05B}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_m", {
			unicode: ["{U+041C}", "{U+043C}"],
			alterations: [{}, { combining: "{U+2DE8}", modifier: "{U+1E03B}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_n", {
			unicode: ["{U+041D}", "{U+043D}"],
			alterations: [{}, { combining: "{U+2DE9}", modifier: "{U+1D78}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_o", {
			unicode: ["{U+041E}", "{U+043E}"],
			alterations: [{}, { combining: "{U+2DEA}", modifier: "{U+1E03C}", subscript: "{U+1E05C}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_p", {
			unicode: ["{U+041F}", "{U+043F}"],
			alterations: [{}, { combining: "{U+2DEB}", modifier: "{U+1E03D}", subscript: "{U+1E05D}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_r", {
			unicode: ["{U+0420}", "{U+0440}"],
			alterations: [{}, { combining: "{U+2DEC}", modifier: "{U+1E03E}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_s", {
			unicode: ["{U+0421}", "{U+0441}"],
			alterations: [{}, { combining: "{U+2DED}", modifier: "{U+1E03F}", subscript: "{U+1E05E}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_t", {
			unicode: ["{U+0422}", "{U+0442}"],
			alterations: [{}, { combining: "{U+2DEE}", modifier: "{U+1E040}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_u", {
			unicode: ["{U+0423}", "{U+0443}"],
			alterations: [{}, { combining: "{U+A677}", modifier: "{U+1E041}", subscript: "{U+1E05F}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_f", {
			unicode: ["{U+0424}", "{U+0444}"],
			alterations: [{}, { combining: "{U+A69E}", modifier: "{U+1E042}", subscript: "{U+1E060}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_h", {
			unicode: ["{U+0425}", "{U+0445}"],
			alterations: [{}, { combining: "{U+2DEF}", modifier: "{U+1E043}", subscript: "{U+1E061}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ts", {
			unicode: ["{U+0426}", "{U+0446}"],
			alterations: [{}, { combining: "{U+2DF0}", modifier: "{U+1E044}", subscript: "{U+1E062}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ch", {
			unicode: ["{U+0427}", "{U+0447}"],
			alterations: [{}, { combining: "{U+2DF1}", modifier: "{U+1E045}", subscript: "{U+1E063}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_sh", {
			unicode: ["{U+0428}", "{U+0448}"],
			alterations: [{}, { combining: "{U+2DF2}", modifier: "{U+1E046}", subscript: "{U+1E064}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_shch", {
			unicode: ["{U+0429}", "{U+0449}"],
			alterations: [{}, { combining: "{U+2DF3}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_yer", {
			unicode: ["{U+042A}", "{U+044A}"],
			alterations: [{}, { combining: "{U+A678}", modifier: "{U+A69C}", subscript: "{U+1E065}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_yeri", {
			unicode: ["{U+042C}", "{U+044C}"],
			alterations: [{}, { combining: "{U+A67A}", modifier: "{U+A69D}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_e", {
			unicode: ["{U+042D}", "{U+044D}"],
			alterations: [{}, { modifier: "{U+1E048}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_yu", {
			unicode: ["{U+042E}", "{U+044E}"],
			alterations: [{}, { combining: "{U+2DFB}", modifier: "{U+1E049}" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ya", {
			unicode: ["{U+042F}", "{U+044F}"],
			options: { noCalc: True },
		},
		;
		;
		; * Misc
		;
		;
		"num_sup_[0,1,2,3,4,5,6,7,8,9]", {
			unicode: ["{U+2070}", "{U+00B9}", "{U+00B2}", "{U+00B3}", "{U+2074}",
				"{U+2075}", "{U+2076}", "{U+2077}", "{U+2078}", "{U+2079}"]
		},
		"num_sup_[minus,equals,plus,left_parenthesis,right_parenthesis]", {
			unicode: ["{U+207B}", "{U+207C}", "{U+207A}", "{U+207D}", "{U+207E}"]
		},
		"num_sub_[0,1,2,3,4,5,6,7,8,9]", {
			unicode: ["{U+2080}", "{U+2081}", "{U+2082}", "{U+2083}", "{U+2084}",
				"{U+2085}", "{U+2086}", "{U+2087}", "{U+2088}", "{U+2089}"]
		},
		"num_sub_[minus,equals,plus,left_parenthesis,right_parenthesis]", {
			unicode: ["{U+208B}", "{U+208C}", "{U+208A}", "{U+208D}", "{U+208E}"]
		},
		"kkey_0", { unicode: "{U+0030}", sup: "num_sup_0", sub: "num_sub_0", alterations: { doubleStruck: "{U+1D7D8}", bold: "{U+1D7CE}", sansSerif: "{U+1D7E2}", sansSerifBold: "{U+1D7EC}", monospace: "{U+1D7F6}" }, options: { noCalc: True } },
		"kkey_1", { unicode: "{U+0031}", sup: "num_sup_1", sub: "num_sub_1", alterations: { doubleStruck: "{U+1D7D9}", bold: "{U+1D7CF}", sansSerif: "{U+1D7E3}", sansSerifBold: "{U+1D7ED}", monospace: "{U+1D7F7}" }, options: { noCalc: True } },
		"kkey_2", { unicode: "{U+0032}", sup: "num_sup_2", sub: "num_sub_2", alterations: { doubleStruck: "{U+1D7DA}", bold: "{U+1D7D0}", sansSerif: "{U+1D7E4}", sansSerifBold: "{U+1D7EE}", monospace: "{U+1D7F8}" }, options: { noCalc: True } },
		"kkey_3", { unicode: "{U+0033}", sup: "num_sup_3", sub: "num_sub_3", alterations: { doubleStruck: "{U+1D7DB}", bold: "{U+1D7D1}", sansSerif: "{U+1D7E5}", sansSerifBold: "{U+1D7EF}", monospace: "{U+1D7F9}" }, options: { noCalc: True } },
		"kkey_4", { unicode: "{U+0034}", sup: "num_sup_4", sub: "num_sub_4", alterations: { doubleStruck: "{U+1D7DC}", bold: "{U+1D7D2}", sansSerif: "{U+1D7E6}", sansSerifBold: "{U+1D7F0}", monospace: "{U+1D7FA}" }, options: { noCalc: True } },
		"kkey_5", { unicode: "{U+0035}", sup: "num_sup_5", sub: "num_sub_5", alterations: { doubleStruck: "{U+1D7DD}", bold: "{U+1D7D3}", sansSerif: "{U+1D7E7}", sansSerifBold: "{U+1D7F1}", monospace: "{U+1D7FB}" }, options: { noCalc: True } },
		"kkey_6", { unicode: "{U+0036}", sup: "num_sup_6", sub: "num_sub_6", alterations: { doubleStruck: "{U+1D7DE}", bold: "{U+1D7D4}", sansSerif: "{U+1D7E8}", sansSerifBold: "{U+1D7F2}", monospace: "{U+1D7FC}" }, options: { noCalc: True } },
		"kkey_7", { unicode: "{U+0037}", sup: "num_sup_7", sub: "num_sub_7", alterations: { doubleStruck: "{U+1D7DF}", bold: "{U+1D7D5}", sansSerif: "{U+1D7E9}", sansSerifBold: "{U+1D7F3}", monospace: "{U+1D7FD}" }, options: { noCalc: True } },
		"kkey_8", { unicode: "{U+0038}", sup: "num_sup_8", sub: "num_sub_8", alterations: { doubleStruck: "{U+1D7E0}", bold: "{U+1D7D6}", sansSerif: "{U+1D7EA}", sansSerifBold: "{U+1D7F4}", monospace: "{U+1D7FE}" }, options: { noCalc: True } },
		"kkey_9", { unicode: "{U+0039}", sup: "num_sup_9", sub: "num_sub_9", alterations: { doubleStruck: "{U+1D7E1}", bold: "{U+1D7D7}", sansSerif: "{U+1D7EB}", sansSerifBold: "{U+1D7F5}", monospace: "{U+1D7FF}" }, options: { noCalc: True } },
		"kkey_minus", { unicode: "{U+002D}", sup: "num_sup_minus", sub: "num_sub_minus", options: { noCalc: True } },
		"kkey_equals", { unicode: "{U+003D}", sup: "num_sup_equals", sub: "num_sub_equals", alterations: { modifier: "{U+02ED}" }, options: { noCalc: True } },
		"kkey_asterisk", { unicode: "{U+002A}", options: { noCalc: True } },
		"kkey_underscore", { unicode: "{U+005F}", options: { noCalc: True } },
		"kkey_hyphen_minus", { unicode: "{U+002D}", options: { noCalc: True } },
		"kkey_plus", { unicode: "{U+002B}", sup: "num_sup_plus", sub: "num_sub_plus", alterations: { modifier: "{U+02D6}" }, options: { noCalc: True } },
		"kkey_left_parenthesis", { unicode: "{U+0028}", sup: "num_sup_left_parenthesis", sub: "num_sub_left_parenthesis", options: { noCalc: True } },
		"kkey_right_parenthesis", { unicode: "{U+0029}", sup: "num_sup_right_parenthesis", sub: "num_sub_right_parenthesis", options: { noCalc: True } },
		"kkey_comma", { unicode: "{U+002C}", options: { noCalc: True } },
		"kkey_dot", { unicode: "{U+002E}", options: { noCalc: True } },
		"kkey_semicolon", { unicode: "{U+003B}", options: { noCalc: True } },
		"kkey_colon", { unicode: "{U+003A}", alterations: { modifier: "{U+02F8}" }, options: { noCalc: True } },
		"kkey_apostrophe", { unicode: "{U+0027}", options: { noCalc: True } },
		"kkey_quotation", { unicode: "{U+0022}", options: { noCalc: True } },
		"kkey_l_square_bracket", { unicode: "{U+005B}", options: { noCalc: True } },
		"kkey_r_square_bracket", { unicode: "{U+005D}", options: { noCalc: True } },
		"kkey_l_curly_bracket", { unicode: "{U+007B}", options: { noCalc: True } },
		"kkey_r_curly_bracket", { unicode: "{U+007D}", options: { noCalc: True } },
		"kkey_grave_accent", { unicode: "{U+0060}", options: { noCalc: True } },
		"kkey_tilde", { unicode: "{U+007E}", options: { noCalc: True } },
		"kkey_slash", { unicode: "{U+002F}", options: { noCalc: True } },
		"kkey_backslash", { unicode: "{U+005C}", options: { noCalc: True } },
		"kkey_verticalline", { unicode: "{U+007C}", options: { noCalc: True } },
		"kkey_lessthan", { unicode: "{U+003C}", options: { noCalc: True } },
		"kkey_greaterthan", { unicode: "{U+003E}", options: { noCalc: True } },
		"kkey_commercial_at", { unicode: "{U+0040}", options: { noCalc: True } },
		"kkey_numero_sign", { unicode: "{U+2116}", options: { noCalc: True } },
		"kkey_number_sign", { unicode: "{U+0023}", options: { noCalc: True } },
		"kkey_percent_sign", { unicode: "{U+0025}", options: { noCalc: True } },
		"kkey_circumflex_accent", { unicode: "{U+005E}", options: { noCalc: True } },
		;
		;
		; * Spaces
		;
		;
		"space", {
			unicode: "{U+0020}",
			options: { noCalc: True },
			symbol: { category: "Spaces" },
		},
		"emsp", {
			unicode: "{U+2003}",
			tags: ["em space", "emspace", "emsp", "круглая шпация"],
			groups: ["Spaces"],
			options: { groupKey: ["1"], fastKey: ">+ Space" },
			symbol: { category: "Spaces" },
		},
		"ensp", {
			unicode: "{U+2002}",
			tags: ["en space", "enspace", "ensp", "полукруглая шпация"],
			groups: ["Spaces"],
			options: { groupKey: ["2"], fastKey: "<+ Space" },
			symbol: { category: "Spaces" },
		},
		"emsp13", {
			unicode: "{U+2004}",
			tags: ["emsp13", "1/3emsp", "1/3 круглой Шпации"],
			groups: ["Spaces", "Spaces Left Alt"],
			options: { groupKey: ["3"], fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"emsp14", {
			unicode: "{U+2005}",
			tags: ["emsp14", "1/4emsp", "1/4 круглой Шпации"],
			groups: ["Spaces", "Spaces Left Shift"],
			options: { groupKey: ["4"] },
			symbol: { category: "Spaces" },
		},
		"thinspace", {
			unicode: "{U+2009}",
			tags: ["thinsp", "thin space", "узкий пробел", "тонкий пробел"],
			groups: ["Spaces"],
			options: { groupKey: ["5"], fastKey: "<! Space" },
			symbol: { category: "Spaces" },
		},
		"emsp16", {
			unicode: "{U+2006}",
			tags: ["emsp16", "1/6emsp", "1/6 круглой Шпации"],
			groups: ["Spaces", "Spaces Right Shift"],
			options: { groupKey: ["6"], fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"narrow_no_break_space", {
			unicode: "{U+202F}", LaTeX: ["\,"],
			tags: ["nnbsp", "narrow no-break space", "узкий неразрывный пробел", "тонкий неразрывный пробел"],
			groups: ["Spaces", "Spaces Right Shift"],
			options: { groupKey: ["7"], fastKey: "<+ Space" },
			symbol: { category: "Spaces" },
		},
		"hairspace", {
			unicode: "{U+200A}",
			tags: ["hsp", "hairsp", "hair space", "волосяная шпация"],
			groups: ["Spaces"],
			options: { groupKey: ["8"], fastKey: "<!<+ Space" },
			symbol: { category: "Spaces" },
		},
		"punctuation_space", {
			unicode: "{U+2008}",
			tags: ["psp", "puncsp", "punctuation space", "пунктуационный пробел"],
			groups: ["Spaces"],
			options: { groupKey: ["9"], fastKey: "<!>+ Space" },
			symbol: { category: "Spaces" },
		},
		"zero_width_space", {
			unicode: "{U+200B}",
			tags: ["zwsp", "zero-width space", "пробел нулевой ширины"],
			groups: ["Spaces"],
			options: { groupKey: ["0"], fastKey: ">^ Space" },
			symbol: { category: "Spaces" },
		},
		"zero_width_no_break_space", {
			unicode: "{U+FEFF}",
			tags: ["zwnbsp", "zero-width no-break space", "неразрывный пробел нулевой ширины"],
			groups: ["Spaces", "Spaces Primary"],
			options: { groupKey: [")"], fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"figure_space", {
			unicode: "{U+2007}",
			tags: ["nsp", "numsp", "figure space", "цифровой пробел"],
			groups: ["Spaces"],
			options: { groupKey: ["="], fastKey: "<+>+ Space" },
			symbol: { category: "Spaces" },
		},
		"no_break_space", {
			unicode: "{U+00A0}", LaTeX: ["~"],
			tags: ["nbsp", "no-break space", "неразрывный пробел"],
			groups: ["Spaces"],
			options: { groupKey: ["Space"], fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"medium_math_space", {
			unicode: "{U+205F}",
			tags: ["mmsp", "mathsp", "medium math space", "средний математический пробел"],
			groups: ["Spaces", "Math Spaces"],
			options: { altLayoutKey: "<! Space" },
			symbol: { category: "Spaces" },
		},
		"tabulation", {
			unicode: "{U+0009}",
			tags: ["tab", "tabulation", "табуляция"],
			groups: ["Spaces"],
			options: { noCalc: True },
			symbol: { category: "Spaces" },
		},
		"emquad", {
			unicode: "{U+2001}", LaTeX: ["\qquad"],
			tags: ["em quad", "emquad", "emqd", "em-квадрат"],
			groups: ["Spaces"],
			options: { groupKey: ["!"] },
			symbol: { category: "Spaces" },
		},
		"enquad", {
			unicode: "{U+2000}", LaTeX: ["\quad"],
			tags: ["en quad", "enquad", "enqd", "en-квадрат"],
			groups: ["Spaces"],
			options: { groupKey: ["@", "`""] },
			symbol: { category: "Spaces" },
		},
		"word_joiner", {
			unicode: "{U+2060}",
			tags: ["wj", "word joiner", "соединитель слов"],
			groups: ["Format Characters"],
			options: { groupKey: ["-"], fastKey: "<+ Tab" },
			symbol: { category: "Format Character" },
		},
		"zero_width_joiner", {
			unicode: "{U+200D}",
			tags: ["zwj", "zero-width joiner", "соединитель нулевой ширины"],
			groups: ["Format Characters"],
			options: { fastKey: "Tab" },
			symbol: { category: "Format Character" },
		},
		"zero_width_non_joiner", {
			unicode: "{U+200C}",
			tags: ["zwj", "zero-width non-joiner", "разъединитель нулевой ширины"],
			groups: ["Format Characters"],
			options: { fastKey: ">+ Tab" },
			symbol: { category: "Format Character" },
		},
		;
		;
		; * Miscellaneous Characters
		;
		;
		"carriage_return", {
			unicode: "{U+000D}",
			tags: ["carriage return", "возврат каретки"],
			groups: ["Sys Group"],
			symbol: { set: Chr(0x21B5) },
		},
		"new_line", {
			unicode: "{U+000A}",
			tags: ["new line", "перевод строки"],
			groups: ["Sys Group"],
			symbol: { set: Chr(0x21B4) },
		},
		;
		;
		; * Special Characters
		;
		;
		"arrow_left", {
			unicode: "{U+2190}",
			tags: ["left arrow", "стрелка влево"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2190) },
			recipe: ["<-"],
		},
		"arrow_right", {
			unicode: "{U+2192}",
			tags: ["right arrow", "стрелка вправо"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2192) },
			recipe: ["->"],
		},
		"arrow_up", {
			unicode: "{U+2191}",
			tags: ["up arrow", "стрелка вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) },
		},
		"arrow_down", {
			unicode: "{U+2193}",
			tags: ["down arrow", "стрелка вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2193) },
		},
		"arrow_leftup", {
			unicode: "{U+2196}",
			tags: ["left up arrow", "стрелка влево-вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) " " Chr(0x2190) },
		},
		"arrow_rightup", {
			unicode: "{U+2197}",
			tags: ["right up arrow", "стрелка вправо-вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) " " Chr(0x2192) },
		},
		"arrow_leftdown", {
			unicode: "{U+2199}",
			tags: ["left down arrow", "стрелка влево-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2193) " " Chr(0x2190) },
		},
		"arrow_rightdown", {
			unicode: "{U+2198}",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2193) " " Chr(0x2192) },
		},
		"arrow_leftright", {
			unicode: "{U+2194}",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2190) " " Chr(0x2192) },
		},
		"arrow_updown", {
			unicode: "{U+2195}",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) " " Chr(0x2193) },
		},
		"arrow_left_circle", {
			unicode: "{U+21BA}",
			tags: ["left circle arrow", "округлая стрелка влево"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: ">+ " Chr(0x2190) },
		},
		"arrow_right_circle", {
			unicode: "{U+21BB}",
			tags: ["right circle arrow", "округлая стрелка вправо"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: ">+ " Chr(0x2192) },
		},
		"arrow_left_ushaped", {
			unicode: "{U+2B8C}",
			tags: ["left u-arrow", "u-образная стрелка влево"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Chr(0x2190) },
		},
		"arrow_right_ushaped", {
			unicode: "{U+2B8E}",
			tags: ["right u-arrow", "u-образная стрелка вправо"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Chr(0x2192) },
		},
		"arrow_up_ushaped", {
			unicode: "{U+2B8D}",
			tags: ["up u-arrow", "u-образная стрелка вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Chr(0x2190) },
		},
		"arrow_down_ushaped", {
			unicode: "{U+2B8F}",
			tags: ["down u-arrow", "u-образная стрелка вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Chr(0x2192) },
		},
		;
		;
		; * Proxies
		;
		;
		"line_below", { proxy: "macron_below",
			groups: [], options: { noCalc: True },
			symbol: { category: "Diacritic Mark" }
		},
		"descender", { proxy: "arrow_down",
			groups: [], options: { noCalc: True },
		},
		;
		;
		; * Various
		;
		;
		"asterisk", {
			unicode: "{U+002A}",
			alterations: { small: "{U+FE61}" },
			options: { noCalc: True },
		},
		"asterisk_low", {
			unicode: "{U+204E}",
			tags: ["low asterisk", "нижний астериск"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["a", "ф"], fastKey: "<+ NumMult" },
			recipe: ["${asterisk}${arrow_down}"],
		},
		"asterisk_two", {
			unicode: "{U+2051}",
			tags: ["two asterisks", "два астериска"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["A", "Ф"], fastKey: "NumMult" },
			recipe: ["${asterisk×2}", "2*"],
		},
		"asterism", {
			unicode: "{U+2042}",
			tags: ["asterism", "астеризм"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: [CtrlA], fastKey: ">+ NumMult" },
			recipe: ["${asterisk×3}", "3*"],
		},
		"bullet", {
			unicode: "{U+2022}",
			tags: ["bullet", "булит"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { groupKey: [Backquote], fastKey: Backquote },
		},
		"bullet_hyphen", {
			unicode: "{U+2043}",
			tags: ["hyphen bullet", "чёрточный булит"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<! " Backquote },
		},
		"interpunct", {
			unicode: "{U+00B7}",
			tags: ["middle dot", "точка по центру", "интерпункт"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { groupKey: ["~"], fastKey: "<+ " Backquote },
		},
		"bullet_white", {
			unicode: "{U+25E6}",
			tags: ["white bullet", "прозрачный булит"],
			groups: ["Special Fast Secondary"],
			options: { fastKey: "<!>+ " Backquote },
		},
		"bullet_triangle", {
			unicode: "{U+2023}",
			tags: ["triangular bullet", "треугольный булит"],
			groups: ["Special Fast Secondary"],
			options: { fastKey: "<!<+ " Backquote },
		},
		"hyphenation_point", {
			unicode: "{U+2027}",
			tags: ["hyphenation point", "точка переноса"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { groupKey: ["-"], fastKey: ">+ -" },
		},
		"colon_triangle", {
			unicode: "{U+02D0}",
			tags: ["triangle colon", "знак долготы"],
			groups: ["Special Characters", "IPA"],
			options: { groupKey: [";", "ж"], altLayoutKey: ";" },
		},
		"colon_triangle_half", {
			unicode: "{U+02D1}",
			tags: ["half triangle colon", "знак полудолготы"],
			groups: ["Special Characters", "IPA"],
			options: { groupKey: [":", "Ж"], altLayoutKey: ">! `;" },
		},
		"degree", {
			unicode: "{U+00B0}",
			tags: ["degree", "градус"],
			groups: ["Special Characters", "Special Fast Left"],
			options: { groupKey: ["d", "в"], fastKey: "D" },
		},
		"celsius", {
			unicode: "{U+2103}",
			tags: ["celsius", "градус Цельсия"],
			groups: ["Special Characters", "Smelting Special", "Special Right Shift"],
			options: { fastKey: "C" },
			recipe: ["${degree}C"],
		},
		"fahrenheit", {
			unicode: "{U+2109}",
			tags: ["fahrenheit", "градус по Фаренгейту"],
			groups: ["Special Characters", "Smelting Special", "Special Right Shift"],
			options: { fastKey: "F" },
			recipe: ["${degree}F"],
		},
		"kelvin", {
			unicode: "{U+212A}",
			tags: ["kelvin", "Кельвин"],
			groups: ["Special Characters", "Smelting Special", "Special Right Shift"],
			options: { fastKey: "K" },
			recipe: ["${degree}K"],
		},
		"rankine", {
			unicode: "{U+0052}",
			sequence: ["{U+00B0}", "{U+0052}"],
			options: { noCalc: True },
		},
		"newton", {
			unicode: "{U+004E}",
			sequence: ["{U+00B0}", "{U+004E}"],
			options: { noCalc: True },
		},
		"delisle", {
			unicode: "{U+0044}",
			sequence: ["{U+00B0}", "{U+0044}"],
			options: { noCalc: True },
		},
		"dagger", {
			unicode: "{U+2020}", LaTeX: ["\dagger"],
			tags: ["dagger", "даггер", "крест"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { groupKey: ["t", "е"], fastKey: "NumDiv" },
		},
		"dagger_double", {
			unicode: "{U+2021}", LaTeX: ["\ddagger"],
			tags: ["double dagger", "двойной даггер", "двойной крест"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { groupKey: ["T", "Е"], fastKey: ">+ NumDiv" },
		},
		"dagger_tripple", {
			unicode: "{U+2E4B}",
			tags: ["tripple dagger", "тройной даггер", "тройной крест"],
			groups: ["Special Characters"],
			options: { groupKey: [CtrlT] },
		},
		"fraction_slash", {
			unicode: "{U+2044}",
			tags: ["fraction slash", "дробная черта"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { groupKey: ["/"], fastKey: ">+ /" },
		},
		"grapheme_joiner", {
			unicode: "{U+034F}",
			tags: ["grapheme joiner", "соединитель графем"],
			groups: ["Special Characters"],
			options: { groupKey: ["g", "п"] },
		},
		"infinity", {
			unicode: "{U+221E}",
			tags: ["fraction slash", "дробная черта"],
			groups: ["Special Characters"],
			options: { groupKey: ["9"], fastKey: "<! 8" },
		},
		"dotted_circle", {
			unicode: "{U+25CC}",
			tags: ["пунктирный круг", "dotted circle"],
			groups: ["Special Fast Primary"],
			options: { fastKey: "Num0" },
		},
		"ellipsis", {
			unicode: "{U+2026}",
			tags: ["ellipsis", "многоточие"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["."], fastKey: "/ ." },
			recipe: ["..."],
		},
		"two_dot_leader", {
			unicode: "{U+2025}",
			tags: ["two dot leader", "двухточечный пунктир"],
			groups: ["Smelting Special"],
			recipe: ["/.."],
		},
		"two_dot_punctuation", {
			unicode: "{U+205A}",
			tags: ["two dot punctuation", "двухточечная пунктуация"],
			groups: ["Smelting Special", "Special Fast Left"],
			options: { fastKey: "/ ." },
			recipe: [".."],
		},
		"tricolon", {
			unicode: "{U+205D}",
			tags: ["tricolon", "троеточие"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ / ." },
			recipe: [":↑."],
		},
		"quartocolon", {
			unicode: "{U+205E}",
			tags: ["vertical four dots", "четвероточие"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+>+ / ." },
			recipe: [":↑:"],
		},
		"reference_mark", {
			unicode: "{U+203B}",
			tags: ["reference mark", "знак сноски", "komejirushi", "комэдзируси"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["..×..", ":×:"],
		},
		"numero_sign", {
			unicode: "{U+2116}",
			tags: ["numero sign", "знак номера"],
			groups: ["Smelting Special"],
			recipe: ["no"],
		},
		"number_sign", {
			unicode: "{U+0023}",
			alterations: { small: "{U+FE5F}" },
			options: { noCalc: True, send: "Text" },
		},
		"section", {
			unicode: "{U+00A7}", LaTeX: ["\S"],
			tags: ["section", "параграф"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Left"],
			options: { groupKey: ["s", "с"], fastKey: "1" },
			recipe: ["sec", "пар"],
		},
		"comma", {
			unicode: "{U+002C}",
			alterations: { small: "{U+FE50}" },
			options: { noCalc: True },
		},
		"dot", {
			unicode: "{U+002E}",
			alterations: { small: "{U+FE52}" },
			options: { noCalc: True },
		},
		"exclamation", {
			unicode: "{U+0021}",
			alterations: { modifier: "{U+A71D}", small: "{U+FE57}" },
			options: { noCalc: True, send: "Text" },
		},
		"question", {
			unicode: "{U+003F}",
			alterations: { small: "{U+FE56}" },
			options: { noCalc: True },
		},
		"reversed_question", {
			unicode: "{U+2E2E}",
			tags: ["reversed ?", "обратный ?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<! 7" },
			recipe: ["${arrow_left_ushaped}?"],
		},
		"inverted_exclamation", {
			unicode: "{U+00A1}",
			alterations: { modifier: "{U+A71E}", subscript: "{U+A71F}" },
			tags: ["inverted !", "перевёрнутый !"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "1" },
			recipe: ["${arrow_down_ushaped}!"],
		},
		"inverted_question", {
			unicode: "{U+00BF}",
			tags: ["inverted ?", "перевёрнутый ?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "7" },
			recipe: ["${arrow_down_ushaped}?"],
		},
		"double_exclamation", {
			unicode: "{U+203C}",
			tags: ["double !", "двойной !"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "c*>+ 1" },
			recipe: ["!!"],
		},
		"double_exclamation_question", {
			unicode: "{U+2049}",
			tags: ["blended !?", "смешанный !?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ 1" },
			recipe: ["!?"],
		},
		"double_question", {
			unicode: "{U+2047}",
			tags: ["double ?", "двойной ?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "c*>+ 7" },
			recipe: ["??"],
		},
		"double_question_exclamation", {
			unicode: "{U+2048}",
			tags: ["blended ?!", "смешанный ?!"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ 7" },
			recipe: ["?!"],
		},
		"interrobang", {
			unicode: "{U+203D}",
			tags: ["interrobang", "интерробанг", "лигатура !?", "ligature !?"],
			groups: ["Smelting Special", "Special Fast RShift"],
			options: { fastKey: "1" },
			recipe: ["!+?"],
		},
		"interrobang_inverted", {
			unicode: "{U+2E18}",
			tags: ["inverted interrobang", "перевёрнутый интерробанг", "лигатура перевёрнутый !?", "ligature inverted !?"],
			groups: ["Smelting Special", "Special Fast RShift"],
			options: { fastKey: "c* 1" },
			recipe: ["${arrow_down_ushaped}${interrobang}", "${arrow_down_ushaped}!+?"],
		},
		"grave_accent", {
			unicode: "{U+0060}",
			alterations: { modifier: "{U+02CB}" },
			options: { noCalc: True },
		},
		"circumflex_accent", {
			unicode: "{U+005E}",
			alterations: { modifier: "{U+02C6}" },
			options: { noCalc: True, send: "Text" },
		},
		"semicolon", {
			unicode: "{U+003B}",
			alterations: { small: "{U+FE54}" },
			options: { noCalc: True },
		},
		"colon", {
			unicode: "{U+003A}",
			alterations: { small: "{U+FE55}" },
			options: { noCalc: True },
		},
		"apostrophe", {
			unicode: "{U+0027}",
			options: { noCalc: True },
		},
		"quote", {
			unicode: "{U+0022}",
			options: { noCalc: True },
		},
		"solidus", {
			unicode: "{U+002F}",
			options: { noCalc: True, send: "Text" },
		},
		"reverse_solidus", {
			unicode: "{U+005C}",
			alterations: { small: "{U+FE68}" },
			options: { noCalc: True, send: "Text" },
		},
		"vertical_line", {
			unicode: "{U+007C}",
			options: { noCalc: True, send: "Text" },
		},
		"commercial_at", {
			unicode: "{U+0040}",
			alterations: { small: "{U+FE6B}" },
			options: { noCalc: True },
		},
		;
		;
		; * Dashes
		;
		;
		"emdash", {
			unicode: "{U+2014}", LaTeX: ["---"],
			alterations: { small: "{U+FE58}" },
			tags: ["em dash", "длинное тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["1"], fastKey: "-" },
			recipe: ["---"],
		},
		"emdash_vertical", {
			unicode: "{U+FE31}",
			tags: ["vertical em dash", "вертикальное длинное тире"],
			groups: ["Smelting Special"],
			recipe: ["${arrow_down_ushaped}${emdash}"],
		},
		"endash", {
			unicode: "{U+2013}",
			tags: ["en dash", "короткое тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["2"], fastKey: "<+ -" },
			recipe: ["--"],
		},
		"endash_vertical", {
			unicode: "{U+FE32}",
			tags: ["vertical en dash", "вертикальное короткое тире"],
			groups: ["Smelting Special"],
			recipe: ["${arrow_down_ushaped}${endash}"],
		},
		"three_emdash", {
			unicode: "{U+2E3B}",
			tags: ["three-em dash", "тройное тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Left"],
			options: { groupKey: ["3"], fastKey: "-" },
			recipe: ["-----", "${emdash×3}"],
		},
		"two_emdash", {
			unicode: "{U+2E3A}",
			tags: ["two-em dash", "двойное тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Left"],
			options: { groupKey: ["4"], fastKey: "c* -" },
			recipe: ["----", "${emdash×2}"],
		},
		"softhyphen", {
			unicode: "{U+00AD}",
			tags: ["soft hyphen", "мягкий перенос"],
			groups: ["Dashes", "Smelting Special", "Special Fast Primary"],
			options: { groupKey: ["5"], fastKey: "-" },
			recipe: [".-"],
		},
		"figure_dash", {
			unicode: "{U+2012}",
			tags: ["figure dash", "цифровое тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["6"], fastKey: "<!>+ -" },
			recipe: ["n-"],
		},
		"hyphen", {
			unicode: "{U+2010}",
			tags: ["hyphen", "дефис"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["7"], fastKey: "<! -" },
			recipe: ["1-"],
		},
		"no_break_hyphen", {
			unicode: "{U+2011}",
			tags: ["no-break hyphen", "неразрывный дефис"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["8"], fastKey: "<!<+ -" },
			recipe: ["0-"],
		},
		"hyphen_minus", {
			unicode: "{U+002D}",
			alterations: { small: "{U+FE63}" },
			options: { noCalc: True },
		},
		"underscore", {
			unicode: "{U+005F}",
			options: { noCalc: True },
		},
		"inverted_lazy_s", {
			unicode: "{U+223E}",
			tags: ["inverted lazy s", "перевёрнутая плавная s"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["s${arrow_right_circle}"],
		},
		;
		;
		; * Mathematical Symbols
		;
		;
		"percent", {
			unicode: "{U+0025}",
			alterations: { small: "{U+FE6A}" },
			options: { noCalc: True },
		},
		"permille", {
			unicode: "{U+2030}",
			LaTeX: ["\permil"],
			LaTeXPackage: "wasysym",
			tags: ["per mille", "промилле"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["5"], fastKey: "5" },
			recipe: ["${percent}0"],
		},
		"pertenthousand", {
			unicode: "{U+2031}",
			LaTeX: ["\textpertenthousand"],
			LaTeXPackage: "textcomp",
			tags: ["per ten thousand", "промилле", "basis point", "базисный пункт"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { groupKey: ["%"], fastKey: "<+ 5" },
			recipe: ["${percent}00", "${permille}0"],
		},
		"equals", {
			unicode: "{U+003D}",
			alterations: { modifier: "{U+207C}", subscript: "{U+208C}", small: "{U+FE66}" },
			options: { noCalc: True },
		},
		"plus", {
			unicode: "{U+002B}",
			alterations: { modifier: "{U+207A}", subscript: "{U+208A}", small: "{U+FE62}" },
			options: { noCalc: True, send: "Text" },
		},
		"minus", {
			unicode: "{U+2212}",
			alterations: { modifier: "{U+207B}", subscript: "{U+208B}" },
			tags: ["minus", "минус"],
			groups: ["Dashes", "Smelting Special", "Special Fast Primary", "Special Combinations"],
			options: { groupKey: ["9"], altSpecialKey: "NumSub", fastKey: "<+ -" },
			recipe: ["min"],
		},
		"plusminus", {
			unicode: "{U+00B1}",
			tags: ["plus minus", "плюс-минус"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Combinations"],
			options: { groupKey: ["+"], altSpecialKey: "NumSub NumAdd", fastKey: "<+ =" },
			recipe: ["+-", "${plus}${minus}"],
		},
		"minusplus", {
			unicode: "{U+2213}",
			tags: ["minus plus", "минус-плюс"],
			groups: ["Special Characters", "Smelting Special", "Special Combinations"],
			options: { altSpecialKey: "NumAdd NumSub" },
			recipe: ["-+", "${minus}${plus}"],
		},
		"multiplication", {
			unicode: "{U+00D7}",
			alterations: { modifier: "{U+02DF}" },
			tags: ["multiplication", "умножение"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Combinations"],
			options: { groupKey: ["8"], altSpecialKey: "NumMult", fastKey: "8" },
			recipe: ["-x"],
		},
		"division", {
			unicode: "{U+00F7}",
			tags: ["деление", "обелюс", "division", "obelus"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Combinations"],
			options: { groupKey: ["4"], altSpecialKey: "NumDiv", fastKey: "4" },
			recipe: ["-:"],
		},
		"division_times", {
			unicode: "{U+22C7}",
			tags: ["кратность деления", "division times"],
			groups: ["Special Characters", "Smelting Special", "Special Combinations"],
			options: { altSpecialKey: "NumMult NumDiv" },
			recipe: ["${multiplication}-:", "${multiplication}${multiplication}"],
		},
		"tilde", {
			unicode: "{U+007E}",
			options: { noCalc: True },
		},
		"less_than", {
			unicode: "{U+003C}",
			alterations: { small: "{U+FE64}" },
			options: { noCalc: True },
		},
		"greater_than", {
			unicode: "{U+003E}",
			alterations: { small: "{U+FE65}" },
			options: { noCalc: True },
		},
		"integral", {
			unicode: "{U+222B}", LaTeX: ["\int"],
			tags: ["integral", "интеграл"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: "i" },
			recipe: ["int", "инт"],
		},
		"integral_double", {
			unicode: "{U+222C}", LaTeX: ["\iint"],
			tags: ["double integral", "двойной интеграл"],
			groups: ["Smelting Special", "Math"],
			recipe: ["${integral×2}", "iint", "иинт"],
		},
		"integral_triple", {
			unicode: "{U+222D}", LaTeX: ["\iiint"],
			tags: ["triple integral", "тройной интеграл"],
			groups: ["Smelting Special", "Math"],
			recipe: ["${integral×3}", "tint", "тинт"],
		},
		"integral_quadruple", {
			unicode: "{U+2A0C}",
			tags: ["quadruple integral", "четверной интеграл"],
			groups: ["Smelting Special", "Math"],
			recipe: ["${integral×4}", "qint", "чинт"],
		},
		"left_parenthesis", {
			unicode: "{U+0028}",
			alterations: { modifier: "{U+207D}", subscript: "{U+208D}", small: "{U+FE59}" },
			options: { noCalc: True, send: "Text" },
		},
		"right_parenthesis", {
			unicode: "{U+0029}",
			alterations: { modifier: "{U+207E}", subscript: "{U+208E}", small: "{U+FE5A}" },
			options: { noCalc: True, send: "Text" },
		},
		"top_parenthesis", {
			unicode: "{U+23DC}",
			tags: ["top parenthesis", "верхняя круглая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_parenthesis}${arrow_up}"],
		},
		"bottom_parenthesis", {
			unicode: "{U+23DD}",
			tags: ["bottom parenthesis", "нижняя круглая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_parenthesis}${arrow_down}"],
		},
		"left_parenthesis_upper_hook", {
			unicode: "{U+239B}",
			tags: ["left parenthesis upper hook", "верхний крюк левой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_parenthesis}${arrow_leftup}"],
		},
		"right_parenthesis_upper_hook", {
			unicode: "{U+239E}",
			tags: ["right parenthesis upper hook", "верхний крюк правой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_parenthesis}${arrow_rightup}"],
		},
		"left_parenthesis_extension", {
			unicode: "{U+239C}",
			tags: ["left parenthesis extension", "расширение левой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_parenthesis}/${arrow_left}"],
		},
		"right_parenthesis_extension", {
			unicode: "{U+239F}",
			tags: ["right parenthesis extension", "расширение правой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_parenthesis}\${arrow_right}"],
		},
		"left_parenthesis_lower_hook", {
			unicode: "{U+239D}",
			tags: ["left parenthesis lower hook", "нижний крюк левой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_parenthesis}${arrow_leftdown}"],
		},
		"right_parenthesis_lower_hook", {
			unicode: "{U+23A0}",
			tags: ["right parenthesis lower hook", "нижний крюк правой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_parenthesis}${arrow_rightdown}"],
		},
		"left_bracket", {
			unicode: "{U+005B}",
			options: { noCalc: True, send: "Text" },
		},
		"right_bracket", {
			unicode: "{U+005D}",
			options: { noCalc: True, send: "Text" },
		},
		"top_bracket", {
			unicode: "{U+23B4}",
			tags: ["top bracket", "верхняя квадратная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_bracket}${arrow_up}"],
		},
		"bottom_bracket", {
			unicode: "{U+23B5}",
			tags: ["bottom bracket", "нижняя квадратная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_bracket}${arrow_down}"],
		},
		"left_bracket_with_quill", {
			unicode: "{U+2045}",
			tags: ["left bracket with quill", "левая квадратная скобка с чертой"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "[" },
		},
		"right_bracket_with_quill", {
			unicode: "{U+2046}",
			tags: ["right bracket with quill", "правая квадратная скобка с чертой"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "" },
		},
		"left_white_bracket", {
			unicode: "{U+27E6}",
			tags: ["left white bracket", "левая квадратная полая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: ">+ [" },
		},
		"right_white_bracket", {
			unicode: "{U+27E7}",
			tags: ["right white bracket", "правая квадратная полая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: ">+ ]" },
		},
		"left_white_tortoise_shell", {
			unicode: "{U+27EC}",
			tags: ["left white tortoise shell", "левая полая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<+ [" },
		},
		"right_white_tortoise_shell", {
			unicode: "{U+27ED}",
			tags: ["right white tortoise shell", "правая полая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<+ " },
		},
		"left_bracket_upper_corner", {
			unicode: "{U+23A1}",
			tags: ["left bracket upper corner", "верхний угол левой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_bracket}${arrow_leftup}"],
		},
		"right_bracket_upper_corner", {
			unicode: "{U+23A4}",
			tags: ["right bracket upper corner", "верхний угол правой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_bracket}${arrow_rightup}"],
		},
		"left_bracket_extension", {
			unicode: "{U+23A2}",
			tags: ["left bracket extension", "расширение левой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_bracket}/${arrow_left}"],
		},
		"right_bracket_extension", {
			unicode: "{U+23A5}",
			tags: ["right bracket extension", "расширение правой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_bracket}\${arrow_right}"],
		},
		"left_bracket_lower_corner", {
			unicode: "{U+23A3}",
			tags: ["left bracket lower corner", "нижний угол левой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_bracket}${arrow_leftdown}"],
		},
		"right_bracket_lower_corner", {
			unicode: "{U+23A6}",
			tags: ["right bracket lower corner", "нижний угол правой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_bracket}${arrow_rightdown}"],
		},
		"left_brace", {
			unicode: "{U+007B}",
			alterations: { small: "{U+FE5C}" },
			options: { noCalc: True, send: "Text" },
		},
		"right_brace", {
			unicode: "{U+007D}",
			alterations: { small: "{U+FE5D}" },
			options: { noCalc: True, send: "Text" },
		},
		"top_brace", {
			unicode: "{U+23DE}",
			tags: ["top brace", "верхняя фигурная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_brace}${arrow_up}"],
		},
		"bottom_brace", {
			unicode: "{U+23DF}",
			tags: ["bottom brace", "нижняя фигурная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_brace}${arrow_down}"],
		},
		"left_brace_upper_hook", {
			unicode: "{U+23A7}",
			tags: ["left brace upper hook", "верхний крюк левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}${arrow_leftup}"],
		},
		"right_brace_upper_hook", {
			unicode: "{U+23AB}",
			tags: ["right brace upper hook", "верхний крюк правой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_brace}${arrow_rightup}"],
		},
		"brace_extension", {
			unicode: "{U+23AA}",
			tags: ["left brace extension", "расширение левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}/${arrow_left}", "${right_brace}\${arrow_right}"],
		},
		"left_brace_middle_piece", {
			unicode: "{U+23A8}",
			tags: ["left brace middle piece", "средняя часть левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}${arrow_left}"],
		},
		"right_brace_middle_piece", {
			unicode: "{U+23AC}",
			tags: ["right brace middle piece", "средняя часть правой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_brace}${arrow_right}"],
		},
		"left_brace_lower_hook", {
			unicode: "{U+23A9}",
			tags: ["left brace lower hook", "нижний крюк левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}${arrow_leftdown}"],
		},
		"right_brace_lower_hook", {
			unicode: "{U+23AD}",
			tags: ["right brace lower hook", "нижний крюк правой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_brace}${arrow_rightdown}"],
		},
		"left_chevron", {
			unicode: "{U+27E8}",
			LaTeX: ["\langle"],
			tags: ["mathematical left angle bracket", "математическая левая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { groupKey: ["9"], fastKey: "9" },
		},
		"right_chevron", {
			unicode: "{U+27E9}",
			LaTeX: ["\rangle"],
			tags: ["mathematical right angle bracket", "математическая правая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { groupKey: ["0"], fastKey: "0" },
		},
		"left_chevron_with_dot", {
			unicode: "{U+2991}",
			tags: ["mathematical left angle bracket with dot", "математическая левая угловая скобка с точкой"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_chevron}."],
		},
		"right_chevron_with_dot", {
			unicode: "{U+2992}",
			tags: ["mathematical right angle bracket with dot", "математическая правая угловая скобка с точкой"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_chevron}."],
		},
		"left_chevron_double", {
			unicode: "{U+27EA}",
			tags: ["mathematical double left angle bracket", "математическая двойная левая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_chevron×2}"],
		},
		"right_chevron_double", {
			unicode: "{U+27EB}",
			tags: ["mathematical double right angle bracket", "математическая двойная правая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_chevron×2}"],
		},
		"left_chevron", {
			unicode: "{U+27E8}",
			LaTeX: ["\langle"],
			tags: ["mathematical left angle bracket", "математическая левая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "9" },
		},
		"left_cjk_tortoise_shell", {
			unicode: "{U+3014}",
			tags: ["cjk left tortoise shell bracket", "восточная левая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<! [" },
		},
		"right_cjk_tortoise_shell", {
			unicode: "{U+3015}",
			tags: ["cjk right tortoise shell bracket", "восточная правая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<! " },
		},
		"top_cjk_tortoise_shell", {
			unicode: "{U+FE39}",
			tags: ["cjk top tortoise shell bracket", "восточная верхняя панцирная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_tortoise_shell}${arrow_up}"],
		},
		"bottom_cjk_tortoise_shell", {
			unicode: "{U+FE3A}",
			tags: ["cjk bottom tortoise shell bracket", "восточная нижняя панцирная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_tortoise_shell}${arrow_down}"],
		},
		"left_cjk_corner_bracket", {
			unicode: "{U+300C}",
			tags: ["cjk left corner bracket", "восточная левая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!<+ [" },
		},
		"right_cjk_corner_bracket", {
			unicode: "{U+300D}",
			tags: ["cjk right corner bracket", "восточная правая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!<+ ]" },
		},
		"top_cjk_corner_bracket", {
			unicode: "{U+FE41}",
			tags: ["cjk top corner bracket", "восточная верхняя угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_corner_bracket}${arrow_up}"],
		},
		"bottom_cjk_corner_bracket", {
			unicode: "{U+FE42}",
			tags: ["cjk bottom corner bracket", "восточная нижняя угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_corner_bracket}${arrow_down}"],
		},
		"left_cjk_white_corner_bracket", {
			unicode: "{U+300E}",
			tags: ["cjk left white corner bracket", "восточная левая полая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!>+ [" },
		},
		"right_cjk_white_corner_bracket", {
			unicode: "{U+300F}",
			tags: ["cjk right white corner bracket", "восточная правая полая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!>+ ]" },
		},
		"top_cjk_white_corner_bracket", {
			unicode: "{U+FE43}",
			tags: ["cjk top white corner bracket", "восточная верхняя полая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_white_corner_bracket}${arrow_up}"],
		},
		"bottom_cjk_white_corner_bracket", {
			unicode: "{U+FE44}",
			tags: ["cjk bottom white corner bracket", "восточная нижняя полая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_white_corner_bracket}${arrow_down}"],
		},
		;
		;
		; * Default Hellenic
		;
		;
		"hel_[c,s]_let_a_alpha", {
			unicode: ["{U+0391}", "{U+03B1}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_b_beta", {
			unicode: ["{U+0392}", "{U+03B2}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_g_gamma", {
			unicode: ["{U+0393}", "{U+03B3}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_d_delta", {
			unicode: ["{U+0394}", "{U+03B4}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_e_epsilon", {
			unicode: ["{U+0395}", "{U+03B5}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_z_zeta", {
			unicode: ["{U+0396}", "{U+03B6}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_h_eta", {
			unicode: ["{U+0397}", "{U+03B7}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_t_theta", {
			unicode: ["{U+0398}", "{U+03B8}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_i_iota", {
			unicode: ["{U+0399}", "{U+03B9}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_k_kappa", {
			unicode: ["{U+039A}", "{U+03BA}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_l_lambda", {
			unicode: ["{U+039B}", "{U+03BB}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_m_mu", {
			unicode: ["{U+039C}", "{U+03BC}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_n_nu", {
			unicode: ["{U+039D}", "{U+03BD}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_x_xi", {
			unicode: ["{U+039E}", "{U+03BE}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_o_omicron", {
			unicode: ["{U+039F}", "{U+03BF}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_p_pi", {
			unicode: ["{U+03A0}", "{U+03C0}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_r_rho", {
			unicode: ["{U+03A1}", "{U+03C1}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_s_sigma", {
			unicode: ["{U+03A3}", "{U+03C3}"],
			options: { altLayoutKey: "$" },
		},
		"hel_s_let_s_sigma_final", {
			unicode: "{U+03C2}",
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_t_tau", {
			unicode: ["{U+03A4}", "{U+03C4}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_u_upsilon", {
			unicode: ["{U+03A5}", "{U+03C5}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_f_phi", {
			unicode: ["{U+03A6}", "{U+03C6}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_h_chi", {
			unicode: ["{U+03A7}", "{U+03C7}"],
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_p_psi", {
			unicode: ["{U+03A8}", "{U+03C8}"],
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_q_koppa_archaic", {
			unicode: ["{U+03D8}", "{U+03D9}"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_q_koppa", {
			unicode: ["{U+03DE}", "{U+03DF}"],
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_o_omega", {
			unicode: ["{U+03A9}", "{U+03C9}"],
			options: { altLayoutKey: ">! $" },
		},
		;
		;
		; * Hellenic Ligatures
		;
		;
		"hel_[c,s]_lig_st_stigma", {
			unicode: ["{U+03DA}", "{U+03DB}"],
			recipe: ["${hel_[c,s]_let_s_sigma}${hel_[c,s]_let_t_tau}"]
		},
		"hel_[c,s]_lig_k_kai", {
			unicode: ["{U+03CF}", "{U+03D7}"],
			recipe: ["${hel_[c,s]_let_k_kappa}${hel_[c,s]_let_a_alpha}${hel_[c,s]_let_i_iota}"]
		},
		;
		;
		; * Latin Numberals
		;
		;
		"lat_c_num_[1,2,3,4,5,6,7,8,9,10,11,12,50,100,500,1000,5000,10000,50000,100000]", {
			unicode: [
				"{U+2160}", "{U+2161}", "{U+2162}", "{U+2163}", "{U+2164}",
				"{U+2165}", "{U+2166}", "{U+2167}", "{U+2168}", "{U+2169}",
				"{U+216A}", "{U+216B}", "{U+216C}", "{U+216D}", "{U+216E}",
				"{U+216F}", "{U+2181}", "{U+2182}", "{U+2187}", "{U+2188}"
			],
			options: {
				useLetterLocale: True,
				numericValue: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 50, 100, 500, 1000, 5000, 10000, 50000, 100000],
			},
			recipe: [
				["RN 1"],
				["RN 2"],
				["RN 3"],
				["RN 4"],
				["RN 5"],
				["RN 6"],
				["RN 7"],
				["RN 8"],
				["RN 9"],
				["RN 10"],
				["RN 11"],
				["RN 12"],
				["RN 50"],
				["RN 100"],
				["RN 500"],
				["RN 1K"],
				["RN 5K"],
				["RN 10K"],
				["RN 50K"],
				["RN 100K"]
			]
		},
		"lat_s_num_[1,2,3,4,5,6,7,8,9,10,11,12,50,100,500,1000]", {
			unicode: [
				"{U+2170}", "{U+2171}", "{U+2172}", "{U+2173}", "{U+2174}",
				"{U+2175}", "{U+2176}", "{U+2177}", "{U+2178}", "{U+2179}",
				"{U+217A}", "{U+217B}", "{U+217C}", "{U+217D}", "{U+217E}",
				"{U+217F}"
			],
			options: {
				useLetterLocale: True,
				numericValue: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 50, 100, 500, 1000],
			},
			recipe: [
				["rn 1"],
				["rn 2"],
				["rn 3"],
				["rn 4"],
				["rn 5"],
				["rn 6"],
				["rn 7"],
				["rn 8"],
				["rn 9"],
				["rn 10"],
				["rn 11"],
				["rn 12"],
				["rn 50"],
				["rn 100"],
				["rn 500"],
				["rn 1k"]
			]
		},
		"lat_c_num_[6_late,50_early]", {
			unicode: ["{U+2185}", "{U+2186}"],
			options: { useLetterLocale: True, numericValue: [6, 50], },
			recipe: [["RN L6"], ["RN E50"]],
			symbol: { afterLetter: ["late", "early"] }
		},
		"lat_c_num_100_reversed", {
			unicode: "{U+2183}",
			options: { useLetterLocale: True, numericValue: 100, },
			recipe: ["RN 100${arrow_left_circle}", "${lat_c_num_100}${arrow_right_circle}"],
			symbol: { beforeLetter: "reversed" }
		},
		;
		;
		; * Uncommon Latin Letters
		;
		;
		"lat_[c,s]_let_0_tone_two", {
			unicode: ["{U+01A7}", "{U+01A8}"],
			options: { useLetterLocale: True },
			recipe: [["`"2"], ["'2"]],
		},
		"lat_[c,s]_let_0_tone_five", {
			unicode: ["{U+01BC}", "{U+01BD}"],
			options: { useLetterLocale: True },
			recipe: [["`"5"], ["'5"]],
		},
		"lat_[c,s]_let_0_tone_six", {
			unicode: ["{U+0184}", "{U+0185}"],
			options: { useLetterLocale: True },
			recipe: [["`"6"], ["'6"]],
		},
		"lat_s_let_a_ain", {
			unicode: "{U+1D25}",
			alterations: { modifier: "{U+1D5C}" },
			options: { useLetterLocale: True },
			recipe: ["$in"],
		},
		"lat_[c,s]_let_h_hwair", {
			unicode: ["{U+01F6}", "{U+0195}"],
			options: { useLetterLocale: True, fastKey: "$?Primary" },
			recipe: ["$${arrow_right}"],
		},
		"lat_[c,s]_let_h_half", {
			unicode: ["{U+2C75}", "{U+2C76}"],
			recipe: ["$/"],
			symbol: { beforeLetter: "half" }
		},
		"lat_[c,s]_let_h_half_reversed", {
			unicode: ["{U+A7F5}", "{U+A7F6}"],
			recipe: ["$/${arrow_right}"],
			symbol: { beforeLetter: "reversed, half" }
		},
		"lat_s_let_i_yat_sakha", {
			unicode: "{U+AB60}",
			options: { useLetterLocale: True },
			recipe: ["$ь"],
		},
		"lat_[c,s]_let_j_yogh", {
			unicode: ["{U+021C}", "{U+021D}"],
			options: { useLetterLocale: True, fastKey: ">+ $?Secondary" },
			recipe: ["/yog/"],
		},
		"lat_[c,s]_let_k_cuatrillo", {
			unicode: ["{U+A72C}", "{U+A72D}"],
			options: { useLetterLocale: True, fastKey: "<+ $?Secondary" },
			recipe: ["$4"],
		},
		"lat_[c,s]_let_o_rams_horn", {
			unicode: ["{U+A7CB}", "{U+0264}"],
			tags: [[], ["close-mid back unrounded vowel", "неогублённый гласный заднего ряда средне-верхнего подъёма"]],
			groups: [[], ["Latin", "IPA"]],
			alterations: [{}, { modifier: "{U+10791}" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"],
				useLetterLocale: True
			},
			recipe: ["/ram/"],
		},
		"lat_[c,s]_let_q_tresillo", {
			unicode: ["{U+A72A}", "{U+A72B}"],
			options: { useLetterLocale: True, fastKey: "<+ $?Secondary" },
			recipe: ["$3"],
		},
		"lat_s_let_s_long", {
			unicode: "{U+017F}",
			options: { useLetterLocale: True, fastKey: ">+ $?Secondary" },
			recipe: ["fs"]
		},
		"lat_[c,s]_let_t_thorn", {
			unicode: ["{U+00DE}", "{U+00FE}"],
			options: { useLetterLocale: True, fastKey: ">+ ~?Secondary" },
			recipe: ["$"],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_t_thorn__stroke_short", {
			unicode: ["{U+A764}", "{U+A765}"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			recipe: ["$${stroke_short}", "${lat_[c,s]_let_@_thorn}${stroke_short}"],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_t_thorn__stroke_down", {
			unicode: ["{U+A766}", "{U+A767}"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			recipe: ["$${arrow_down}${stroke_short}", "${lat_[c,s]_let_@_thorn}${arrow_down}${stroke_short}"],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_t_thorn_double", {
			unicode: ["{U+A7D2}", "{U+A7D3}"],
			options: { useLetterLocale: True },
			recipe: ["$$", "${lat_[c,s]_let_@_thorn×2}"],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_w_wynn", {
			unicode: ["{U+01F7}", "{U+01BF}"],
			options: { useLetterLocale: True, fastKey: ">+ ~?Secondary" },
			recipe: ["$"],
			symbol: { letter: ["WY", "wy"] },
		},
		"lat_[c,s]_let_w_wynn_double", {
			unicode: ["{U+A7D4}", "{U+A7D5}"],
			options: { useLetterLocale: True },
			recipe: ["$$", "${lat_[c,s]_let_@_wynn×2}"],
			symbol: { letter: ["WY", "wy"] },
		},
		"lat_[c,s]_let_z_ezh", {
			unicode: ["{U+01B7}", "{U+0292}"],
			tags: [[], ["voiced postalveolar fricative", "звонкий зубной щелевой согласный"]],
			groups: [[], ["Latin", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"], useLetterLocale: True, fastKey: ">+ ~?Secondary"
			},
			recipe: ["/E/zh"],
		},
		"lat_[c,s]_let_z_ezh__caron", {
			unicode: ["{U+01EE}", "{U+01EF}"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			symbol: { letter: "${lat_[c,s]_let_z_ezh}" }
		},
		"lat_s_let_z_ezh__curl", {
			unicode: "{U+0293}",
			recipe: ["$${arrow_right_ushaped}"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			symbol: { letter: "${lat_s_let_z_ezh}" }
		},
		"lat_s_let_z_ezh__retroflex_hook", {
			unicode: "{U+1D9A}",
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			symbol: { letter: "${lat_s_let_z_ezh}" }
		},
		"lat_[c,s]_let_a_alpha", {
			unicode: ["{U+2C6D}", "{U+0251}"],
			alterations: [{}, { combining: "{U+1DE7}", modifier: "{U+1D45}" }],
			tags: [[], ["open back unrounded vowel", "неогублённый гласный заднего ряда нижнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"], useLetterLocale: True
			},
			recipe: ["$lp"],
		},
		"lat_s_let_a_alpha__retroflex_hook", {
			unicode: "{U+1D90}",
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: "Origin" },
			recipe: ["$lp${retroflex_hook}", "${lat_s_let_a_alpha}${retroflex_hook}"],
		},
		"lat_s_let_a_alpha_barred", {
			unicode: "{U+AB30}",
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$lp${emdash}", "${lat_s_let_a_alpha}${emdash}"],
			symbol: { beforeLetter: "barred" },
		},
		"lat_[c,s]_let_a_alpha_turned", {
			unicode: ["{U+2C70}", "{U+0252}"],
			alterations: [{}, { modifier: "{U+1D9B}" }],
			tags: [[], ["open back rounded vowel", "огублённый гласный заднего ряда нижнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"], useLetterLocale: True
			},
			recipe: ["$lp${arrow_left_circle}", "${lat_[c,s]_let_@_alpha}${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_let_b_beta", {
			unicode: ["{U+A7B4}", "{U+A7B5}"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$et"],
		},
		"lat_s_let_d_delta", {
			unicode: "{U+1E9F}",
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$el"],
		},
		"lat_[c,s]_let_e_epsilon", {
			unicode: ["{U+0190}", "{U+025B}"],
			tags: [[], ["open-mid front unrounded vowel", "неогублённый гласный переднего ряда средне-нижнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"], useLetterLocale: True
			},
			recipe: ["$ps", "$3"],
		},
		"lat_s_let_f_phi", {
			unicode: "{U+0278}",
			tags: ["voiceless bilabial fricative", "глухой губно-губной спирант"],
			groups: ["Latino-Hellenic", "IPA"],
			options: {
				layoutTitles: True, altLayoutKey: "$",
				useLetterLocale: True
			},
			recipe: ["phi"],
		},
		"lat_[c,s]_let_g_gamma", {
			unicode: ["{U+0194}", "{U+0263}"],
			tags: [[], ["voiced velar fricative", "звонкий велярный спирант"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"], useLetterLocale: True, fastKey: "<+>+ $?Secondary"
			},
			recipe: ["$am", "$y"],
		},
		"lat_[c,s]_let_h_chi", {
			unicode: ["{U+A7B3}", "{U+AB53}"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["/chi/"],
		},
		"lat_[c,s]_let_i_iota", {
			unicode: ["{U+0196}", "{U+0269}"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$ot"],
		},
		"lat_[c,s]_let_l_lambda", {
			unicode: ["{U+A7DA}", "{U+A7DB}"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$am"],
		},
		"lat_[c,s]_let_l_lambda__stroke_short", {
			unicode: ["{U+A7DC}", "{U+019B}"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: "Origin" },
			recipe: ["$am${stroke_short}", "${lat_[c,s]_let_@_lambda}${stroke_short}"],
		},
		"lat_[c,s]_let_o_omega", {
			unicode: ["{U+A7B6}", "{U+A7B7}"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$mg"],
		},
		"lat_[c,s]_let_s_sigma", {
			unicode: ["{U+01A9}", "{U+0283}"],
			tags: [[], ["voiceless postalveolar fricative", "звонкий велярный спирант"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"], useLetterLocale: True, fastKey: "<+>+ $?Secondary"
			},
			recipe: ["$ig", "/esh/"],
		},
		"lat_[c,s]_let_u_upsilon", {
			unicode: ["{U+01B1}", "{U+028A}"],
			tags: [[], ["near-close near-back vowel", "ненапряжённый огублённый гласный заднего ряда верхнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"], useLetterLocale: True
			},
			recipe: ["$ps", "-$-"],
		},
		;
		;
		; * Turned Latin Letters
		;
		;
		"lat_[c,s]_let_a_turned", {
			unicode: ["{U+2C6F}", "{U+0250}"],
			recipe: ["$${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_let_e_turned", {
			unicode: ["{U+018E}", "{U+01DD}"],
			recipe: ["$${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		;
		;
		; * Latin Ligatures
		;
		;
		"lat_[c,s]_lig_aa", { unicode: ["{U+A732}", "{U+A733}"] },
		"lat_[c,s]_lig_ae", {
			unicode: ["{U+00C6}", "{U+00E6}"],
			alterations: [{ modifier: "{U+1D2D}", smallCapital: "{U+1D01}" }, { combining: "{U+1DD4}", modifier: "{U+10783}" }],
			recipe: [["$", "${lat_[c,s]_let_a::smallCapital}${lat_[c,s]_let_e::smallCapital}"], ["$"]],
		},
		"lat_[c,s]_lig_ae__acute", {
			unicode: ["{U+01FC}", "{U+01FD}"],
		},
		"lat_[c,s]_lig_ae__macron", {
			unicode: ["{U+01E2}", "{U+01E3}"],
		},
		"lat_[s]_lig_ae_turned", {
			unicode: ["{U+1D02}"],
			recipe: ["$${arrow_left_circle}", "${lat_s_lig_ae}${arrow_left_circle}", "${lat_s_let_e_turned}${lat_s_let_a_turned}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_lig_ao", {
			unicode: ["{U+A734}", "{U+A735}"],
			alterations: [{}, { combining: "{U+1DD5}" }]
		},
		"lat_[c,s]_lig_au", { unicode: ["{U+A736}", "{U+A737}"], recipe: ["$"] },
		"lat_[c,s]_lig_av", {
			unicode: ["{U+A738}", "{U+A739}"],
			alterations: [{}, { combining: "{U+1DD6}" }]
		},
		"lat_[c,s]_lig_av__stroke_short", {
			unicode: ["{U+A73A}", "{U+A73B}"]
		},
		"lat_[c,s]_lig_ay", { unicode: ["{U+A73C}", "{U+A73D}"] },
		"lat_[s]_lig_db", { unicode: ["{U+0238}"] },
		"lat_[s]_lig_et", {
			unicode: ["{U+0026}"],
			alterations: { small: "{U+FE60}" },
			tags: ["амперсанд", "ampersand"],
			groups: ["Latin Ligatures"]
		},
		"lat_[s]_lig_et_turned", {
			unicode: ["{U+214B}"],
			tags: ["перевёрнутый амперсанд", "turned ampersand"],
			recipe: ["$${arrow_left_circle}", "${lat_s_lig_et}${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_ie", { unicode: ["{U+AB61}"] },
		"lat_[s]_lig_ff", { unicode: ["{U+FB00}"] },
		"lat_[s]_lig_fi", { unicode: ["{U+FB01}"] },
		"lat_[s]_lig_fl", { unicode: ["{U+FB02}"] },
		"lat_[s]_lig_ffi", {
			unicode: ["{U+FB04}"],
			recipe: ["$", "${lat_s_lig_ff}i"]
		},
		"lat_[s]_lig_ffl", {
			unicode: ["{U+FB03}"],
			recipe: ["$", "${lat_s_lig_ff}l"]
		},
		"lat_[c,s]_lig_ij", { unicode: ["{U+0132}", "{U+0133}"] },
		"lat_[s]_lig_lb", { unicode: ["{U+2114}"] },
		"lat_[c,s]_lig_ll", { unicode: ["{U+1EFA}", "{U+1EFB}"] },
		"lat_[c,s]_lig_oi", { unicode: ["{U+01A2}", "{U+01A3}"] },
		"lat_[c,s]_lig_oe", {
			unicode: ["{U+0152}", "{U+0153}"],
			alterations: [{}, { modifier: "{U+A7F9}" }]
		},
		"lat_[s]_lig_oe_turned", {
			unicode: ["{U+1D14}"],
			recipe: ["$${arrow_left_circle}", "${lat_s_lig_oe}${arrow_left_circle}", "${lat_s_let_e_turned}o"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_oe_turned__stroke_short", {
			unicode: ["{U+AB42}"],
			recipe: ["$${arrow_left_circle}${stroke_short}", "${lat_s_lig_oe}${arrow_left_circle}${stroke_short}", "${lat_s_lig_oe_turned}${stroke_short}", "${lat_s_let_e_turned}o${stroke_short}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_oe_turned__solidus_long", {
			unicode: ["{U+AB41}"],
			recipe: ["$${arrow_left_circle}${solidus_long}", "${lat_s_lig_oe}${arrow_left_circle}${solidus_long}", "${lat_s_lig_oe_turned}${solidus_long}", "${lat_s_let_e_turned}o${solidus_long}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_oe_inverted", {
			unicode: ["{U+AB40}"],
			recipe: ["$${arrow_up_ushaped}", "${lat_s_lig_oe}${arrow_up_ushaped}"],
			symbol: { beforeLetter: "inverted" },
		},
		"lat_[c,s]_lig_oo", {
			unicode: ["{U+A74E}", "{U+A74F}"]
		},
		"lat_[c,s]_lig_ou", {
			unicode: ["{U+0222}", "{U+0223}"]
		},
		"lat_[s]_lig_pl", { unicode: ["{U+214A}"] },
		"lat_[s]_lig_st", { unicode: ["{U+FB05}"], recipe: ["$", "${lat_s_let_s_long}t"] },
		"lat_[s]_lig_ue", { unicode: ["{U+1D6B}"] },
		"lat_[s]_lig_uo", { unicode: ["{U+AB63}"] },
		"lat_[c,s]_lig_s_eszett", {
			unicode: ["{U+1E9E}", "{U+00DF}"],
			options: { useLetterLocale: True, fastKey: "<+ ~?Secondary" },
			recipe: ["$", "${lat_s_let_s_long}${lat_[c,s]_let_s}", "${lat_s_let_s_long}${lat_[c,s]_let_z_ezh}"],
			symbol: { letter: ["SS", "ss"] },
		},
		;
		;
		; * Latin Digraphs
		;
		;
		"lat_[c,i,s]_dig_dz", {
			unicode: ["{U+01F1}", "{U+01F2}", "{U+01F3}"],
			symbol: { letter: "${lat_[c,c,s]_let_d}${lat_[c,s,s]_let_z}" }
		},
		"lat_[c,i,s]_dig_dz__caron", {
			unicode: ["{U+01C4}", "{U+01C5}", "{U+01C6}"],
			symbol: { letter: "${lat_[c,c,s]_let_d}${lat_[c,s,s]_let_z}" },
		},
		"lat_[s]_dig_dz__curl", {
			unicode: ["{U+02A5}"],
			recipe: ["$${arrow_left_ushaped}", "${lat_s_dig_dz}${arrow_left_ushaped}"],
		},
		;
		;
		; * Accented Latin
		;
		;
		"lat_[c,s]_let_a__acute", {
			unicode: ["{U+00C1}", "{U+00E1}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_a__breve", {
			unicode: ["{U+0102}", "{U+0103}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_a__breve_inverted", {
			unicode: ["{U+0202}", "{U+0203}"]
		},
		"lat_[c,s]_let_a__circumflex", {
			unicode: ["{U+00C2}", "{U+00E2}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_a__caron", {
			unicode: ["{U+01CD}", "{U+01CE}"]
		},
		"lat_[c,s]_let_a__dot_above", {
			unicode: ["{U+0226}", "{U+0227}"]
		},
		"lat_[c,s]_let_a__dot_below", {
			unicode: ["{U+1EA0}", "{U+1EA1}"]
		},
		"lat_[c,s]_let_a__diaeresis", {
			unicode: ["{U+00C4}", "{U+00E4}"],
			options: { fastKey: "<+ $?Secondary" },
			alterations: [{}, { combining: "{U+1DF2}" }]
		},
		"lat_[c,s]_let_a__grave", {
			unicode: ["{U+00C0}", "{U+00E0}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_a__grave_double", {
			unicode: ["{U+0200}", "{U+0201}"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_a__hook_above", {
			unicode: ["{U+1EA2}", "{U+1EA3}"]
		},
		"lat_[s]_let_a__retroflex_hook", {
			unicode: ["{U+1D8F}"]
		},
		"lat_[c,s]_let_a__macron", {
			unicode: ["{U+0100}", "{U+0101}"],
			options: { fastKey: ">+ $?Secondary" }
		},
		"lat_[c,s]_let_a__ring_above", {
			unicode: ["{U+00C5}", "{U+00E5}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_a__ring_below", {
			unicode: ["{U+1E00}", "{U+1E01}"]
		},
		"lat_[c,s]_let_a__solidus_long", {
			unicode: ["{U+023A}", "{U+2C65}"]
		},
		"lat_[c,s]_let_a__ogonek", {
			unicode: ["{U+0104}", "{U+0105}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_a__tilde_above", {
			unicode: ["{U+00C3}", "{U+00E3}"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_a__breve__acute", {
			unicode: ["{U+1EAE}", "{U+1EAF}"]
		},
		"lat_[c,s]_let_a__breve__grave", {
			unicode: ["{U+1EB0}", "{U+1EB1}"]
		},
		"lat_[c,s]_let_a__breve__dot_below", {
			unicode: ["{U+1EB6}", "{U+1EB7}"]
		},
		"lat_[c,s]_let_a__breve__hook_above", {
			unicode: ["{U+1EB2}", "{U+1EB3}"]
		},
		"lat_[c,s]_let_a__breve__tilde_above", {
			unicode: ["{U+1EB4}", "{U+1EB5}"]
		},
		"lat_[c,s]_let_a__circumflex__acute", {
			unicode: ["{U+1EA4}", "{U+1EA5}"]
		},
		"lat_[c,s]_let_a__circumflex__dot_below", {
			unicode: ["{U+1EAC}", "{U+1EAD}"]
		},
		"lat_[c,s]_let_a__circumflex__grave", {
			unicode: ["{U+1EA6}", "{U+1EA7}"]
		},
		"lat_[c,s]_let_a__circumflex__hook_above", {
			unicode: ["{U+1EA8}", "{U+1EA9}"]
		},
		"lat_[c,s]_let_a__circumflex__tilde_above", {
			unicode: ["{U+1EAA}", "{U+1EAB}"]
		},
		"lat_[c,s]_let_a__dot_above__macron", {
			unicode: ["{U+01E0}", "{U+01E1}"]
		},
		"lat_[c,s]_let_a__diaeresis__macron", {
			unicode: ["{U+01DE}", "{U+01DF}"]
		},
		"lat_[c,s]_let_a__ring_above__acute", {
			unicode: ["{U+01FA}", "{U+01FB}"]
		},
		; Latin Letter “B”
		"lat_[c,s]_let_b__dot_above", {
			unicode: ["{U+1E02}", "{U+1E03}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_b__dot_below", {
			unicode: ["{U+1E04}", "{U+1E05}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_b__common_hook", {
			unicode: ["{U+0181}", "{U+0253}"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_left}"]
		},
		"lat_[s]_let_b__palatal_hook", {
			unicode: ["{U+1D80}"]
		},
		"lat_[c,s]_let_b__flourish", {
			unicode: ["{U+A796}", "{U+A797}"],
			options: { fastKey: "<!<+ $?Secondary" },
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[c,s]_let_b__line_below", {
			unicode: ["{U+1E06}", "{U+1E07}"],
		},
		"lat_[c,s]_let_b__stroke_short", {
			unicode: ["{U+0243}", "{U+0180}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[s]_let_b__tilde_overlay", {
			unicode: ["{U+1D6C}"]
		},
		"lat_[c,s]_let_b__topbar", {
			unicode: ["{U+0182}", "{U+0183}"],
			recipe: ["$${arrow_up}"],
		},
		; Latin Letter “C”
		"lat_[c,s]_let_c__acute", {
			unicode: ["{U+0106}", "{U+0107}"],
			options: { fastKey: "$?Primary" },
		},
		"lat_[c,s]_let_c__circumflex", {
			unicode: ["{U+0108}", "{U+0109}"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_c__caron", {
			unicode: ["{U+010C}", "{U+010D}"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_c__cedilla", {
			unicode: ["{U+00C7}", "{U+00E7}"],
			alterations: [{}, { combining: "{U+1DD7}" }],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_c__curl", {
			unicode: ["{U+0255}"],
			tags: ["voiceless alveolo-palatal fricative", "глухой альвеоло-палатальный сибилянт"],
			groups: ["Latin Accented", "IPA"],
			alterations: { modifier: "{U+1D9D}" },
			options: { layoutTitles: True, altLayoutKey: "$" },
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_c__dot_above", {
			unicode: ["{U+010A}", "{U+010B}"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_c_reversed__dot_middle", {
			unicode: ["{U+A73E}", "{U+A73F}"],
			recipe: ["$${arrow_left_circle}${interpunct}"],
			symbol: { beforeLetter: "reversed" }
		},
		"lat_[c,s]_let_c__common_hook", {
			unicode: ["{U+0187}", "{U+0188}"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[c,s]_let_c__palatal_hook", {
			unicode: ["{U+A7C4}", "{U+A794}"],
		},
		"lat_[s]_let_c__retroflex_hook", {
			unicode: ["{U+1DF1D}"],
		},
		"lat_[c,s]_let_c__solidus_long", {
			unicode: ["{U+023B}", "{U+023C}"],
		},
		"lat_[c,s]_let_c__stroke_short", {
			unicode: ["{U+A792}", "{U+A793}"],
		},
		"lat_[c,s]_let_c__cedilla__acute", {
			unicode: ["{U+1E08}", "{U+1E09}"],
		},
		; Latin Letter “D”
		"lat_[c,s]_let_d__circumflex_below", {
			unicode: ["{U+1E12}", "{U+1E13}"],
			options: { fastKey: "<+>+ $?Secondary" },
		},
		"lat_[c,s]_let_d__caron", {
			unicode: ["{U+010E}", "{U+010F}"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_d__cedilla", {
			unicode: ["{U+1E10}", "{U+1E11}"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_d__curl", {
			unicode: ["{U+0221}"],
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_d__dot_above", {
			unicode: ["{U+1E0A}", "{U+1E0B}"],
		},
		"lat_[c,s]_let_d__dot_below", {
			unicode: ["{U+1E0C}", "{U+1E0D}"],
		},
		"lat_[c,s]_let_d__common_hook", {
			unicode: ["{U+018A}", "{U+0257}"],
			recipe: ["$${arrow_left}"],
		},
		"lat_[s]_let_d__hook__retroflex_hook", {
			unicode: ["{U+1D91}"],
			recipe: ["$${arrow_left}${retroflex_hook}"]
		},
		"lat_[s]_let_d__palatal_hook", {
			unicode: ["{U+1D81}"],
		},
		"lat_[s]_let_d__retroflex_hook", {
			unicode: ["{U+0256}"],
		},
		"lat_[c,s]_let_d__line_below", {
			unicode: ["{U+1E0E}", "{U+1E0F}"],
		},
		"lat_[c,s]_let_d__stroke_short", {
			unicode: ["{U+0110}", "{U+0111}"],
		},
		"lat_[c,s]_let_d_tau_gallicum", {
			unicode: ["{U+A7C7}", "{U+A7C8}"],
			groups: ["Latin Accented"],
			options: { useLetterLocale: True },
			recipe: ["$${arrow_down}${stroke_short}"]
		},
		"lat_[s]_let_d__tilde_overlay", {
			unicode: ["{U+1D6D}"],
		},
		"lat_[c,s]_let_d__topbar", {
			unicode: ["{U+018B}", "{U+018C}"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[c,s]_let_d_eth", {
			unicode: ["{U+00D0}", "{U+00F0}"],
			tags: [[], ["voiced dental fricative", "звонкий зубной щелевой согласный"]],
			groups: [["Latin Accented"], ["Latin Accented", "IPA"]],
			alterations: [{}, { combining: "{U+1DD9}", modifier: "{U+1D9E}" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "$"],
				useLetterLocale: True, fastKey: "$?Secondary" },
			recipe: ["$${solidus_short}"],
		},
		; Latin Letter “E”
		"lat_[c,s]_let_e__acute", {
			unicode: ["{U+00C9}", "{U+00E9}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_e__breve", {
			unicode: ["{U+0114}", "{U+0115}"]
		},
		"lat_[c,s]_let_e__breve_inverted", {
			unicode: ["{U+0206}", "{U+0207}"]
		},
		"lat_[c,s]_let_e__circumflex", {
			unicode: ["{U+00CA}", "{U+00EA}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_e__circumflex_below", {
			unicode: ["{U+1E18}", "{U+1E19}"]
		},
		"lat_[c,s]_let_e__caron", {
			unicode: ["{U+011A}", "{U+011B}"]
		},
		"lat_[c,s]_let_e__cedilla", {
			unicode: ["{U+0228}", "{U+0229}"]
		},
		"lat_[c,s]_let_e__dot_above", {
			unicode: ["{U+0116}", "{U+0117}"]
		},
		"lat_[c,s]_let_e__dot_below", {
			unicode: ["{U+1EB8}", "{U+1EB9}"]
		},
		"lat_[c,s]_let_e__diaeresis", {
			unicode: ["{U+00CB}", "{U+00EB}"],
			options: { fastKey: "<+ $?Secondary" },
		},
		"lat_[c,s]_let_e__grave", {
			unicode: ["{U+00C8}", "{U+00E8}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_e__grave_double", {
			unicode: ["{U+0204}", "{U+0205}"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_e__hook_above", {
			unicode: ["{U+1EBA}", "{U+1EBB}"]
		},
		"lat_[s]_let_e__retroflex_hook", {
			unicode: ["{U+1D92}"]
		},
		"lat_[s]_let_e__notch", {
			unicode: ["{U+2C78}"],
			recipe: ["$${arrow_right}"]
		},
		"lat_[c,s]_let_e__macron", {
			unicode: ["{U+0112}", "{U+0113}"],
			options: { fastKey: ">+ $?Secondary" }
		},
		"lat_[c,s]_let_e__solidus_long", {
			unicode: ["{U+0246}", "{U+0247}"]
		},
		"lat_[c,s]_let_e__ogonek", {
			unicode: ["{U+0118}", "{U+0119}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_e__tilde_above", {
			unicode: ["{U+1EBC}", "{U+1EBD}"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_e__tilde_below", {
			unicode: ["{U+1E1A}", "{U+1E1B}"]
		},
		"lat_[c,s]_let_e__breve__cedilla", {
			unicode: ["{U+1E1C}", "{U+1E1D}"]
		},
		"lat_[c,s]_let_e__circumflex__acute", {
			unicode: ["{U+1EBE}", "{U+1EBF}"]
		},
		"lat_[c,s]_let_e__circumflex__dot_below", {
			unicode: ["{U+1EC6}", "{U+1EC7}"]
		},
		"lat_[c,s]_let_e__circumflex__grave", {
			unicode: ["{U+1EC0}", "{U+1EC1}"]
		},
		"lat_[c,s]_let_e__circumflex__hook_above", {
			unicode: ["{U+1EC2}", "{U+1EC3}"]
		},
		"lat_[c,s]_let_e__circumflex__tilde_above", {
			unicode: ["{U+1EC4}", "{U+1EC5}"]
		},
		"lat_[c,s]_let_e__macron__acute", {
			unicode: ["{U+1E16}", "{U+1E17}"]
		},
		"lat_[c,s]_let_e__macron__grave", {
			unicode: ["{U+1E14}", "{U+1E15}"]
		},
		; Latin Letter “F”
		"lat_[c,s]_let_f__dot_above", {
			unicode: ["{U+1E1E}", "{U+1E1F}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_f__common_hook", {
			unicode: ["{U+0191}", "{U+0192}"],
			recipe: ["$${arrow_down}"]
		},
		"lat_[s]_let_f__palatal_hook", {
			unicode: ["{U+1D82}"]
		},
		"lat_[c,s]_let_f__stroke_short", {
			unicode: ["{U+A798}", "{U+A799}"],
		},
		"lat_[s]_let_f__tilde_overlay", {
			unicode: ["{U+1D6E}"],
		},
		; Latin Letter “G”
		"lat_[c,s]_let_g__acute", {
			unicode: ["{U+01F4}", "{U+01F5}"],
			options: { fastKey: "$?Primary" },
		},
		"lat_[c,s]_let_g__breve", {
			unicode: ["{U+011E}", "{U+011F}"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_g__circumflex", {
			unicode: ["{U+011C}", "{U+011D}"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_g__caron", {
			unicode: ["{U+01E6}", "{U+01E7}"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_g__cedilla", {
			unicode: ["{U+0122}", "{U+0123}"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_g__crossed_tail", {
			unicode: ["{U+AB36}"],
			recipe: ["$${arrow_right_ushaped}"],
		},
		"lat_[c,s]_let_g__dot_above", {
			unicode: ["{U+0120}", "{U+0121}"],
			options: { fastKey: "$?Tertiary" },
		},
		"lat_[c,s]_let_g__macron", {
			unicode: ["{U+1E20}", "{U+1E21}"],
			options: { fastKey: ">+ $?Secondary" },
		},
		"lat_[c,s]_let_g__solidus_long", {
			unicode: ["{U+A7A0}", "{U+A7A1}"],
		},
		"lat_[c,s]_let_g__stroke_short", {
			unicode: ["{U+01E4}", "{U+01E5}"],
		},
		"lat_[c,s]_let_g__common_hook", {
			unicode: ["{U+0193}", "{U+0260}"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[s]_let_g__palatal_hook", {
			unicode: ["{U+1D83}"],
		},
		; Latin Letter “H”
		"lat_[c,s]_let_h__breve_below", {
			unicode: ["{U+1E2A}", "{U+1E2B}"],
		},
		"lat_[c,s]_let_h__circumflex", {
			unicode: ["{U+0124}", "{U+0125}"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_h__caron", {
			unicode: ["{U+021E}", "{U+021F}"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_h__cedilla", {
			unicode: ["{U+1E28}", "{U+1E29}"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[c,s]_let_h__dot_above", {
			unicode: ["{U+1E22}", "{U+1E23}"],
		},
		"lat_[c,s]_let_h__dot_below", {
			unicode: ["{U+1E24}", "{U+1E25}"],
		},
		"lat_[c,s]_let_h__diaeresis", {
			unicode: ["{U+1E26}", "{U+1E27}"],
			options: { fastKey: "<+ $?Secondary" },
		},
		"lat_[c,s]_let_h__descender", {
			unicode: ["{U+2C67}", "{U+2C68}"],
		},
		"lat_[c,s]_let_h__common_hook", {
			unicode: ["{U+A7AA}", "{U+0266}"],
			recipe: ["$${arrow_left}"],
		},
		"lat_[s]_let_h__palatal_hook", {
			unicode: ["{U+A795}"],
		},
		"lat_[c,s]_let_h__stroke_short", {
			unicode: ["{U+0126}", "{U+0127}"],
			options: { fastKey: "$?Secondary" },
		},
		; Latin Letter “I”
		"lat_[c,s]_let_i__acute", {
			unicode: ["{U+00CD}", "{U+00ED}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_i__breve", {
			unicode: ["{U+012C}", "{U+012D}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_i__breve_inverted", {
			unicode: ["{U+020A}", "{U+020B}"],
		},
		"lat_[c,s]_let_i__circumflex", {
			unicode: ["{U+00CE}", "{U+00EE}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_i__caron", {
			unicode: ["{U+01CF}", "{U+01D0}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_c_let_i__dot_above", {
			unicode: "{U+0130}",
			options: { fastKey: "<!<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_i__dot_below", {
			unicode: ["{U+1ECA}", "{U+1ECB}"]
		},
		"lat_[c,s]_let_i__diaeresis", {
			unicode: ["{U+00CF}", "{U+00EF}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_i__grave", {
			unicode: ["{U+00CC}", "{U+00EC}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_i__grave_double", {
			unicode: ["{U+0208}", "{U+0209}"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_i__hook_above", {
			unicode: ["{U+1EC8}", "{U+1EC9}"]
		},
		"lat_[s]_let_i__retroflex_hook", {
			unicode: ["{U+1D96}"]
		},
		"lat_[c,s]_let_i__macron", {
			unicode: ["{U+012A}", "{U+012B}"],
			options: { fastKey: ">+ $?Secondary" }
		},
		"lat_[c,s]_let_i__stroke_short", {
			unicode: ["{U+0197}", "{U+0268}"],
			alterations: [{ smallCapital: "{U+1D7B}" }, {}]
		},
		"lat_[c,s]_let_i__ogonek", {
			unicode: ["{U+012E}", "{U+012F}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_i__tilde_above", {
			unicode: ["{U+0128}", "{U+0129}"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_i__tilde_below", {
			unicode: ["{U+1E2C}", "{U+1E2D}"]
		},
		"lat_[c,s]_let_i__diaeresis__acute", {
			unicode: ["{U+1E2E}", "{U+1E2F}"]
		},
		"lat_[s]_let_i__stroke_short__retroflex_hook", {
			unicode: ["{U+1DF1A}"]
		},
		; Latin Letter “J”
		"lat_[c,s]_let_j__circumflex", {
			unicode: ["{U+0134}", "{U+0135}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_j__caron", {
			unicode: ["{U+01F0}", "{U+01F0}"],
			groups: [["Latin Reserved"], []],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[s]_let_j__crossed_tail", {
			unicode: ["{U+A7B2}"],
			recipe: ["$${arrow_right_ushaped}"],
		},
		"lat_[c,s]_let_j__stroke_short", {
			unicode: ["{U+0248}", "{U+0249}"],
			options: { fastKey: "$?Secondary" }
		},
		; Latin Letter “K”
		"lat_[c,s]_let_k__acute", {
			unicode: ["{U+1E30}", "{U+1E31}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_k__caron", {
			unicode: ["{U+01E8}", "{U+01E9}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_k__cedilla", {
			unicode: ["{U+0136}", "{U+0137}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_k__dot_below", {
			unicode: ["{U+1E32}", "{U+1E33}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_k__common_hook", {
			unicode: ["{U+0199}", "{U+0198}"],
			recipe: ["$${arrow_up}"]
		},
		"lat_[s]_let_k__palatal_hook", {
			unicode: ["{U+1D84}"]
		},
		"lat_[c,s]_let_k__solidus_long", {
			unicode: ["{U+A7A2}", "{U+A7A3}"]
		},
		"lat_[c,s]_let_k__solidus_short", {
			unicode: ["{U+A742}", "{U+A743}"]
		},
		"lat_[c,s]_let_k__stroke_short", {
			unicode: ["{U+A740}", "{U+A741}"]
		},
		"lat_[c,s]_let_k__line_below", {
			unicode: ["{U+1E34}", "{U+1E35}"]
		},
		"lat_[c,s]_let_k__descender", {
			unicode: ["{U+2C69}", "{U+2C6A}"],
		},
		"lat_[c,s]_let_k__stroke_short__solidus_short", {
			unicode: ["{U+A744}", "{U+A745}"]
		},
		; Latin Letter “L”
		"lat_[c,s]_let_l__acute", {
			unicode: ["{U+0139}", "{U+013A}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_l__circumflex_below", {
			unicode: ["{U+1E3C}", "{U+1E3D}"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_l__caron", {
			unicode: ["{U+013D}", "{U+013E}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_l__cedilla", {
			unicode: ["{U+013B}", "{U+013C}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[s]_let_l__curl", {
			unicode: ["{U+0234}"],
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[c,s]_let_l__belt", {
			unicode: ["{U+A7AD}", "{U+026C}"],
			alterations: [{}, { modifier: "{U+1079B}" }],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[s]_let_l__fishhook", {
			unicode: ["{U+1DF11}"],
			recipe: ["$${arrow_right}"]
		},
		"lat_[c,s]_let_l__dot_below", {
			unicode: ["{U+1E36}", "{U+1E37}"]
		},
		"lat_[c,s]_let_l__dot_middle", {
			unicode: ["{U+013F}", "{U+0140}"],
			recipe: ["$${interpunct}"]
		},
		"lat_[s]_let_l__palatal_hook", {
			unicode: ["{U+1D85}"]
		},
		"lat_[s]_let_l__retroflex_hook", {
			unicode: ["{U+026D}"]
		},
		"lat_[s]_let_l__ring_middle", {
			unicode: ["{U+AB39}"],
			recipe: ["$${bullet_white}"]
		},
		"lat_[c,s]_let_l__solidus_short", {
			unicode: ["{U+0141}", "{U+0142}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_l__stroke_short", {
			unicode: ["{U+023D}", "{U+019A}"],
		},
		"lat_[c,s]_let_l__stroke_short_high", {
			unicode: ["{U+A748}", "{U+A749}"],
			recipe: ["$${stroke_short}${arrow_up}"]
		},
		"lat_[c,s]_let_l__stroke_short_double", {
			unicode: ["{U+2C60}", "{U+2C61}"],
			recipe: ["$${stroke_short×2}"]
		},
		"lat_[c,s]_let_l__line_below", {
			unicode: ["{U+1E3A}", "{U+1E3B}"]
		},
		"lat_[c,s]_let_l__tilde_overlay", {
			unicode: ["{U+2C62}", "{U+026B}"]
		},
		"lat_[s]_let_l__tilde_overlay_double", {
			unicode: ["{U+AB38}"],
			alterations: { combining: "{U+1DEC}" },
			recipe: ["$${tilde_overlay×2}"]
		},
		"lat_[s]_let_l__inverted_lazy_s", {
			unicode: ["{U+AB37}"],
			recipe: ["$${inverted_lazy_s}"]
		},
		"lat_[c,s]_let_l__macron__dot_below", {
			unicode: ["{U+1E38}", "{U+1E39}"],
			recipe: ["$${(macron|dot_below)}$(*)", "${lat_[c,s]_let_l__dot_below}${macron}"]
		},
		"lat_[s]_let_l__belt__palatal_hook", {
			unicode: ["{U+1DF13}"],
			recipe: ["$${arrow_right_ushaped}${palatal_hook}",
				"${lat_s_let_l__belt}${palatal_hook}",
				"${lat_s_let_l__palatal_hook}${arrow_right_ushaped}"
			]
		},
		"lat_[s]_let_l__belt__retroflex_hook", {
			unicode: ["{U+A78E}"],
			alterations: { modifier: "{U+1079D}" },
			recipe: [
				"$${arrow_right_ushaped}${retroflex_hook}",
				"${lat_s_let_l__belt}${retroflex_hook}",
				"${lat_s_let_l__retroflex_hook}${arrow_right_ushaped}"
			]
		},
		; Latin Letter “M”
		"lat_[c,s]_let_m__acute", {
			unicode: ["{U+1E3E}", "{U+1E3F}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_m__dot_above", {
			unicode: ["{U+1E40}", "{U+1E41}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_m__dot_below", {
			unicode: ["{U+1E42}", "{U+1E43}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[s]_let_m__crossed_tail", {
			unicode: ["{U+AB3A}"],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_m__common_hook", {
			unicode: ["{U+2C6E}", "{U+0271}"],
			alterations: [{}, { modifier: "{U+1DAC}" }],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_rightdown}"]
		},
		"lat_[s]_let_m__palatal_hook", {
			unicode: ["{U+1D86}"]
		},
		"lat_[s]_let_m__tilde_overlay", {
			unicode: ["{U+1D6F}"]
		},
		"lat_[s]_let_m_turned__long_leg", {
			unicode: ["{U+0270}"],
			alterations: { modifier: "{U+1DAD}" },
			recipe: ["$${arrow_left_circle}${arrow_down}"],
			symbol: { beforeLetter: "turned" }
		},
		; Latin Letter “N”
		"lat_[c,s]_let_n__acute", {
			unicode: ["{U+0143}", "{U+0144}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_n__circumflex_below", {
			unicode: ["{U+1E4A}", "{U+1E4B}"]
		},
		"lat_[c,s]_let_n__caron", {
			unicode: ["{U+0147}", "{U+0148}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_n__cedilla", {
			unicode: ["{U+0145}", "{U+0146}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[s]_let_n__curl", {
			unicode: ["{U+0235}"],
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[s]_let_n__crossed_tail", {
			unicode: ["{U+AB3B}"],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_n__dot_above", {
			unicode: ["{U+1E44}", "{U+1E45}"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_n__dot_below", {
			unicode: ["{U+1E46}", "{U+1E47}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_n__descender", {
			unicode: ["{U+A790}", "{U+A791}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_n__grave", {
			unicode: ["{U+01F8}", "{U+01F9}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_n__common_hook", {
			unicode: ["{U+019D}", "{U+0272}"],
			alterations: [{}, { modifier: "{U+1DAE}" }],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_leftdown}"]
		},
		"lat_[s]_let_n__palatal_hook", {
			unicode: ["{U+1D87}"]
		},
		"lat_[s]_let_n__retroflex_hook", {
			unicode: ["{U+0273}"],
			alterations: { modifier: "{U+1DAF}" }
		},
		"lat_[c,s]_let_n__line_below", {
			unicode: ["{U+1E48}", "{U+1E49}"]
		},
		"lat_[c,s]_let_n__solidus_long", {
			unicode: ["{U+A7A4}", "{U+A7A5}"],
			recipe: ["$${solidus_long}"]
		},
		"lat_[c,s]_let_n__tilde_above", {
			unicode: ["{U+00D1}", "{U+00F1}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[s]_let_n__tilde_overlay", {
			unicode: ["{U+1D70}"]
		},
		"lat_[c,s]_let_n__long_leg", {
			unicode: ["{U+0220}", "{U+019E}"],
			recipe: ["$${arrow_rightdown}"]
		},
		; Latin Letter “O”
		"lat_[c,s]_let_o__acute", {
			unicode: ["{U+00D3}", "{U+00F3}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_o__acute_double", {
			unicode: ["{U+0150}", "{U+0151}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__breve", {
			unicode: ["{U+014E}", "{U+014F}"]
		},
		"lat_[c,s]_let_o__breve_inverted", {
			unicode: ["{U+020E}", "{U+020F}"]
		},
		"lat_[c,s]_let_o__circumflex", {
			unicode: ["{U+00D4}", "{U+00F4}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__caron", {
			unicode: ["{U+01D1}", "{U+01D2}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__dot_above", {
			unicode: ["{U+022E}", "{U+022F}"]
		},
		"lat_[c,s]_let_o__dot_below", {
			unicode: ["{U+1ECC}", "{U+1ECD}"]
		},
		"lat_[c,s]_let_o__diaeresis", {
			unicode: ["{U+00D6}", "{U+00F6}"],
			alterations: [{}, { combining: "{U+1DF3}" }],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__grave", {
			unicode: ["{U+00D2}", "{U+00F2}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_o__grave_double", {
			unicode: ["{U+020C}", "{U+020D}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_o__loop", {
			unicode: ["{U+A74C}", "{U+A74D}"],
			recipe: ["$${arrow_up_ushaped}"]
		},
		"lat_[c,s]_let_o__hook_above", {
			unicode: ["{U+1ECE}", "{U+1ECF}"]
		},
		"lat_[s]_let_o__retroflex_hook", {
			unicode: ["{U+1DF1B}"]
		},
		"lat_[s]_let_o_open__retroflex_hook", {
			unicode: ["{U+1D97}"],
			recipe: ["$-${retroflex_hook}"],
			symbol: { beforeLetter: "open::3" }
		},
		"lat_[c,s]_let_o__horn", {
			unicode: ["{U+01A0}", "{U+01A1}"]
		},
		"lat_[c,s]_let_o__macron", {
			unicode: ["{U+014C}", "{U+014D}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__solidus_long", {
			unicode: ["{U+00D8}", "{U+00F8}"],
			alterations: [{}, { modifier: "{U+107A2}" }],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[s]_let_o_open__solidus_long", {
			unicode: ["{U+AB3F}"],
			recipe: ["$-${solidus_long}"],
			symbol: { beforeLetter: "open::3" }
		},
		"lat_[s]_let_o_sideways__solidus_long", {
			unicode: ["{U+1D13}"],
			recipe: ["${arrow_right_circle}${solidus_long}"],
			symbol: { beforeLetter: "sideways::3" }
		},
		"lat_[c,s]_let_o__stroke_long", {
			unicode: ["{U+A74A}", "{U+A74B}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__ogonek", {
			unicode: ["{U+01EA}", "{U+01EB}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__tilde_above", {
			unicode: ["{U+00D5}", "{U+00F5}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__tilde_overlay", {
			unicode: ["{U+019F}", "{U+0275}"]
		},
		"lat_[c,s]_let_o__acute__horn", {
			unicode: ["{U+1EDA}", "{U+1EDB}"]
		},
		"lat_[c,s]_let_o__circumflex__acute", {
			unicode: ["{U+1ED0}", "{U+1ED1}"]
		},
		"lat_[c,s]_let_o__circumflex__dot_below", {
			unicode: ["{U+1ED8}", "{U+1ED9}"]
		},
		"lat_[c,s]_let_o__circumflex__grave", {
			unicode: ["{U+1ED2}", "{U+1ED3}"]
		},
		"lat_[c,s]_let_o__circumflex__hook_above", {
			unicode: ["{U+1ED4}", "{U+1ED5}"]
		},
		"lat_[c,s]_let_o__circumflex__tilde_above", {
			unicode: ["{U+1ED6}", "{U+1ED7}"]
		},
		"lat_[c,s]_let_o__dot_below__horn", {
			unicode: ["{U+1EE2}", "{U+1EE3}"]
		},
		"lat_[c,s]_let_o__grave__horn", {
			unicode: ["{U+1EDC}", "{U+1EDD}"]
		},
		"lat_[c,s]_let_o__hook_above__horn", {
			unicode: ["{U+1EDE}", "{U+1EDF}"]
		},
		"lat_[c,s]_let_o__macron__acute", {
			unicode: ["{U+1E52}", "{U+1E53}"]
		},
		"lat_[c,s]_let_o__macron__dot_above", {
			unicode: ["{U+0230}", "{U+0231}"]
		},
		"lat_[c,s]_let_o__macron__diaeresis", {
			unicode: ["{U+022A}", "{U+022B}"]
		},
		"lat_[c,s]_let_o__macron__grave", {
			unicode: ["{U+1E50}", "{U+1E51}"]
		},
		"lat_[c,s]_let_o__macron__ogonek", {
			unicode: ["{U+01EC}", "{U+01ED}"]
		},
		"lat_[c,s]_let_o__macron__tilde_above", {
			unicode: ["{U+022C}", "{U+022D}"]
		},
		"lat_[c,s]_let_o__solidus_long__acute", {
			unicode: ["{U+01FE}", "{U+01FF}"]
		},
		"lat_[c,s]_let_o__tilde_above__acute", {
			unicode: ["{U+1E4C}", "{U+1E4D}"]
		},
		"lat_[c,s]_let_o__tilde_above__diaeresis", {
			unicode: ["{U+1E4E}", "{U+1E4F}"]
		},
		"lat_[c,s]_let_o__tilde_above__horn", {
			unicode: ["{U+1EE0}", "{U+1EE1}"]
		},
		; Latin Letter “P”
		"lat_[c,s]_let_p__acute", {
			unicode: ["{U+1E54}", "{U+1E55}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_p__dot_above", {
			unicode: ["{U+1E56}", "{U+1E57}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_p__squirrel_tail", {
			unicode: ["{U+A754}", "{U+A755}"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_leftup}"]
		},
		"lat_[c,s]_let_p__common_hook", {
			unicode: ["{U+01A4}", "{U+01A5}"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_left}"]
		},
		"lat_[s]_let_p__palatal_hook", {
			unicode: ["{U+1D88}"]
		},
		"lat_[c,s]_let_p__flourish", {
			unicode: ["{U+A752}", "{U+A753}"],
			options: { fastKey: "<!<+ $?Secondary" },
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[c,s]_let_p__stroke_short", {
			unicode: ["{U+2C63}", "{U+1D7D}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_p__stroke_short_down", {
			unicode: ["{U+A750}", "{U+A751}"],
			recipe: ["$${stroke_short}${arrow_down}"]
		},
		"lat_[s]_let_p__tilde_overlay", {
			unicode: ["{U+1D71}"]
		},
		; Latin Letter “Q”
		"lat_[c,s]_let_q__common_hook", {
			unicode: ["{U+024A}", "{U+024B}"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_right}"]
		},
		"lat_[s]_let_q__common_hook", {
			unicode: ["{U+02A0}"],
			recipe: ["$${arrow_up}"]
		},
		"lat_[c,s]_let_q__solidus_long", {
			unicode: ["{U+A758}", "{U+A759}"]
		},
		"lat_[c,s]_let_q__stroke_short_down", {
			unicode: ["{U+A756}", "{U+A757}"],
			recipe: ["$${stroke_short}${arrow_down}"]
		},
		; Latin Letter “R”
		"lat_[c,s]_let_r__acute", {
			unicode: ["{U+0154}", "{U+0155}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_r__breve_inverted", {
			unicode: ["{U+0212}", "{U+0213}"]
		},
		"lat_[c,s]_let_r__caron", {
			unicode: ["{U+0158}", "{U+0159}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_r__cedilla", {
			unicode: ["{U+0156}", "{U+0157}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[s]_let_r__crossed_tail", {
			unicode: ["{U+AB49}"],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_r__dot_above", {
			unicode: ["{U+1E58}", "{U+1E59}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_r__dot_below", {
			unicode: ["{U+1E5A}", "{U+1E5B}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_r__grave_double", {
			unicode: ["{U+0210}", "{U+0211}"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[s]_let_r__palatal_hook", {
			unicode: ["{U+1D89}"]
		},
		"lat_[c,s]_let_r__line_below", {
			unicode: ["{U+1E5E}", "{U+1E5F}"]
		},
		"lat_[c,s]_let_r__solidus_long", {
			unicode: ["{U+A7A6}", "{U+A7A7}"]
		},
		"lat_[c,s]_let_r__stroke_short", {
			unicode: ["{U+024C}", "{U+024D}"]
		},
		"lat_[c,s]_let_r__tail", {
			unicode: ["{U+2C64}", "{U+027D}"],
			recipe: ["$${arrow_down}"]
		},
		"lat_[s]_let_r__tilde_overlay", {
			unicode: ["{U+1D72}"]
		},
		"lat_[s]_let_r__long_leg", {
			unicode: ["{U+027C}"],
			recipe: ["$${arrow_rightdown}"]
		},
		"lat_[c,s]_let_r__macron__dot_below", {
			unicode: ["{U+1E5C}", "{U+1E5D}"],
			recipe: ["$${(macron|dot_below)}$(*)", "${lat_[c,s]_let_r__dot_below}${macron}"]
		},
		; Latin Letter “S”
		"lat_[c,s]_let_s__acute", {
			unicode: ["{U+015A}", "{U+015B}"],
			options: { fastKey: "$?Primary" },
		},
		"lat_[c,s]_let_s__comma_below", {
			unicode: ["{U+0218}", "{U+0219}"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_s__circumflex", {
			unicode: ["{U+015C}", "{U+015D}"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_s__caron", {
			unicode: ["{U+0160}", "{U+0161}"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_s__cedilla", {
			unicode: ["{U+015E}", "{U+015F}"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_s__curl", {
			unicode: ["{U+1DF1E}"],
			alterations: [{ modifier: "{U+107BA}" }],
			recipe: ["$${arrow_right_ushaped}"],
		},
		"lat_[c,s]_let_s__dot_above", {
			unicode: ["{U+1E60}", "{U+1E61}"],
		},
		"lat_[c,s]_let_s__dot_below", {
			unicode: ["{U+1E62}", "{U+1E63}"],
		},
		"lat_[c,s]_let_s__common_hook", {
			unicode: ["{U+A7C5}", "{U+0282}"],
			alterations: [{}, { modifier: "{U+1DB3}" }],
			recipe: ["$${arrow_down}"],
		},
		"lat_[c,s]_let_s__swash_tail", {
			unicode: ["{U+2C7E}", "{U+023F}"],
			recipe: ["$${arrow_rightdown}"],
		},
		"lat_[s]_let_s__palatal_hook", {
			unicode: ["{U+1D8A}"],
		},
		"lat_[c,s]_let_s__solidus_long", {
			unicode: ["{U+A7A8}", "{U+A7A9}"],
			recipe: ["$${solidus_long}"],
		},
		"lat_[c,s]_let_s__stroke_short", {
			unicode: ["{U+A7C9}", "{U+A7CA}"],
			recipe: ["$${stroke_short}"],
		},
		"lat_[s]_let_s__tilde_overlay", {
			unicode: ["{U+1D74}"],
			recipe: ["$${tilde_overlay}"],
		},
		"lat_[c,s]_let_s__acute__dot_above", {
			unicode: ["{U+1E64}", "{U+1E65}"],
		},
		"lat_[c,s]_let_s__caron__dot_above", {
			unicode: ["{U+1E66}", "{U+1E67}"],
		},
		"lat_[c,s]_let_s__dot_above__dot_below", {
			unicode: ["{U+1E68}", "{U+1E69}"],
		},
		; Latin Letter “T”
		"lat_[c,s]_let_t__comma_below", {
			unicode: ["{U+021A}", "{U+021B}"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_t__circumflex_below", {
			unicode: ["{U+1E70}", "{U+1E71}"],
		},
		"lat_[c,s]_let_t__caron", {
			unicode: ["{U+0164}", "{U+0165}"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_t__cedilla", {
			unicode: ["{U+0162}", "{U+0163}"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_t__curl", {
			unicode: ["{U+0236}"],
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_t__dot_above", {
			unicode: ["{U+1E6A}", "{U+1E6B}"],
			options: { fastKey: "<+ $?Secondary" },
		},
		"lat_[c,s]_let_t__dot_below", {
			unicode: ["{U+1E6C}", "{U+1E6D}"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[s]_let_t__diaeresis", {
			unicode: ["{U+1E97}"],
		},
		"lat_[c,s]_let_t__common_hook", {
			unicode: ["{U+01AC}", "{U+01AD}"],
			recipe: ["$${arrow_left}"],
		},
		"lat_[s]_let_t__palatal_hook", {
			unicode: ["{U+01AB}"],
			alterations: { modifier: "{U+1DB5}" },
		},
		"lat_[c,s]_let_t__retroflex_hook", {
			unicode: ["{U+01AE}", "{U+0288}"],
			alterations: [{}, { modifier: "{U+107AF}" }],
		},
		"lat_[s]_let_t__retroflex_hook__common_hook", {
			unicode: ["{U+1DF09}"],
			recipe: ["$${retroflex_hook}${arrow_left}", "${lat_s_let_t__retroflex_hook}${arrow_left}"],
		},
		"lat_[c,s]_let_t__line_below", {
			unicode: ["{U+1E6E}", "{U+1E6F}"],
		},
		"lat_[c,s]_let_t__solidus_long", {
			unicode: ["{U+023E}", "{U+2C66}"],
		},
		"lat_[c,s]_let_t__stroke_short", {
			unicode: ["{U+0166}", "{U+0167}"],
		},
		"lat_[s]_let_t__tilde_overlay", {
			unicode: ["{U+1D75}"],
		},
		; Latin Letter “U”
		"lat_[c,s]_let_u__acute", {
			unicode: ["{U+00DA}", "{U+00FA}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_u__acute_double", {
			unicode: ["{U+0170}", "{U+0171}"],
			options: { fastKey: "<!<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_u__breve", {
			unicode: ["{U+016C}", "{U+016D}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_u__breve_inverted", {
			unicode: ["{U+0216}", "{U+0217}"]
		},
		"lat_[c,s]_let_u__circumflex", {
			unicode: ["{U+00DB}", "{U+00FB}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_u__caron", {
			unicode: ["{U+01D3}", "{U+01D4}"]
		},
		"lat_[c,s]_let_u__dot_below", {
			unicode: ["{U+1EE4}", "{U+1EE5}"]
		},
		"lat_[c,s]_let_u__diaeresis", {
			unicode: ["{U+00DC}", "{U+00FC}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_u__diaeresis_below", {
			unicode: ["{U+1E72}", "{U+1E73}"]
		},
		"lat_[c,s]_let_u__grave", {
			unicode: ["{U+00D9}", "{U+00F9}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_u__grave_double", {
			unicode: ["{U+0214}", "{U+0215}"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_u__hook_above", {
			unicode: ["{U+1EE6}", "{U+1EE7}"]
		},
		"lat_[s]_let_u__retroflex_hook", {
			unicode: ["{U+1D99}"]
		},
		"lat_[c,s]_let_u__horn", {
			unicode: ["{U+01AF}", "{U+01B0}"]
		},
		"lat_[c,s]_let_u__macron", {
			unicode: ["{U+016A}", "{U+016B}"],
			options: { fastKey: ">+ $?Secondary" }
		},
		"lat_[c,s]_let_u__ring_above", {
			unicode: ["{U+016E}", "{U+016F}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_u__solidus_long", {
			unicode: ["{U+A7B8}", "{U+A7B9}"]
		},
		"lat_[c,s]_let_u__ogonek", {
			unicode: ["{U+0172}", "{U+0173}"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_u__tilde_above", {
			unicode: ["{U+0168}", "{U+0169}"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_u__tilde_below", {
			unicode: ["{U+1E74}", "{U+1E75}"]
		},
		"lat_[c,s]_let_u__acute__horn", {
			unicode: ["{U+1EE8}", "{U+1EE9}"]
		},
		"lat_[c,s]_let_u__dot_below__horn", {
			unicode: ["{U+1EF0}", "{U+1EF1}"]
		},
		"lat_[c,s]_let_u__diaeresis__acute", {
			unicode: ["{U+01D7}", "{U+01D8}"]
		},
		"lat_[c,s]_let_u__diaeresis__caron", {
			unicode: ["{U+01D9}", "{U+01DA}"]
		},
		"lat_[c,s]_let_u__diaeresis__grave", {
			unicode: ["{U+01DB}", "{U+01DC}"]
		},
		"lat_[c,s]_let_u__grave__horn", {
			unicode: ["{U+1EEA}", "{U+1EEB}"]
		},
		"lat_[c,s]_let_u__hook_above__horn", {
			unicode: ["{U+1EEC}", "{U+1EED}"]
		},
		"lat_[c,s]_let_u__macron__diaeresis", {
			unicode: ["{U+01D5}", "{U+01D6}"]
		},
		"lat_[c,s]_let_u__tilde_above__acute", {
			unicode: ["{U+1E78}", "{U+1E79}"]
		},
		"lat_[c,s]_let_u__tilde_above__horn", {
			unicode: ["{U+1EEE}", "{U+1EEF}"]
		},
		; Latin Letter “V”
		"lat_[s]_let_v__curl", {
			unicode: ["{U+2C74}"],
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_v__dot_below", {
			unicode: ["{U+1E7E}", "{U+1E7F}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_v__common_hook", {
			unicode: ["{U+01B2}", "{U+028B}"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[s]_let_v__right_hook", {
			unicode: ["{U+2C71}"],
			alterations: [{ modifier: "{U+107B0}" }],
			recipe: ["$${arrow_right}"],
		},
		"lat_[s]_let_v__palatal_hook", {
			unicode: ["{U+1D8C}"]
		},
		"lat_[c,s]_let_v__solidus_long", {
			unicode: ["{U+A75E}", "{U+A75F}"],
			options: { fastKey: "$?Secondary" },
			recipe: ["$${solidus_long}"],
		},
		"lat_[c,s]_let_v__tilde_above", {
			unicode: ["{U+1E7C}", "{U+1E7D}"],
			options: { fastKey: "$?Secondary" }
		},
		; Latin Letter “W”
		"lat_[c,s]_let_w__acute", {
			unicode: ["{U+1E82}", "{U+1E83}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_w__circumflex", {
			unicode: ["{U+0174}", "{U+0175}"],
			options: { fastKey: "<!$?Secondary" }
		},
		"lat_[c,s]_let_w__dot_above", {
			unicode: ["{U+1E86}", "{U+1E87}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_w__dot_below", {
			unicode: ["{U+1E88}", "{U+1E89}"],
			options: { fastKey: "<!<+$?Secondary" }
		},
		"lat_[c,s]_let_w__diaeresis", {
			unicode: ["{U+1E84}", "{U+1E85}"],
			options: { fastKey: "<+$?Secondary" }
		},
		"lat_[c,s]_let_w__grave", {
			unicode: ["{U+1E80}", "{U+1E81}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[s]_let_w__ring_above", {
			unicode: ["{U+1E98}"]
		},
		; Latin Letter “X”
		"lat_[c,s]_let_x__dot_above", {
			unicode: ["{U+1E8A}", "{U+1E8B}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_x__diaeresis", {
			unicode: ["{U+1E8C}", "{U+1E8D}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[s]_let_x__palatal_hook", {
			unicode: ["{U+1D8D}"]
		},
		; Latin Letter “Y”
		"lat_[c,s]_let_y__acute", {
			unicode: ["{U+00DD}", "{U+00FD}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_y__circumflex", {
			unicode: ["{U+0176}", "{U+0177}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_y__dot_above", {
			unicode: ["{U+1E8E}", "{U+1E8F}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_y__dot_below", {
			unicode: ["{U+1EF4}", "{U+1EF5}"]
		},
		"lat_[c,s]_let_y__diaeresis", {
			unicode: ["{U+0178}", "{U+00FF}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_y__grave", {
			unicode: ["{U+1EF2}", "{U+1EF3}"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_y__loop", {
			unicode: ["{U+1EFE}", "{U+1EFF}"],
			options: { fastKey: "<!>+ $?Secondary" },
			recipe: ["$${arrow_up_ushaped}"]
		},
		"lat_[c,s]_let_y__hook_above", {
			unicode: ["{U+1EF6}", "{U+1EF7}"]
		},
		"lat_[c,s]_let_y__common_hook", {
			unicode: ["{U+01B3}", "{U+01B4}"],
			recipe: ["$${arrow_up}"]
		},
		"lat_[s]_let_y__ring_above", {
			unicode: ["{U+1E99}"]
		},
		"lat_[c,s]_let_y__stroke_short", {
			unicode: ["{U+024E}", "{U+024F}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_y__macron", {
			unicode: ["{U+0232}", "{U+0233}"],
			options: { fastKey: ">+ $?Secondary" }
		},
		"lat_[c,s]_let_y__tilde_above", {
			unicode: ["{U+1EF8}", "{U+1EF9}"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		; Latin Letter “Z”
		"lat_[c,s]_let_z__acute", {
			unicode: ["{U+0179}", "{U+017A}"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_z__circumflex", {
			unicode: ["{U+1E90}", "{U+1E91}"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_z__caron", {
			unicode: ["{U+017D}", "{U+017E}"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[s]_let_z__curl", {
			unicode: ["{U+0291}"],
			alterations: [{ modifier: "{U+1DBD}" }],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_z__dot_above", {
			unicode: ["{U+017B}", "{U+017C}"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_z__dot_below", {
			unicode: ["{U+1E92}", "{U+1E93}"]
		},
		"lat_[c,s]_let_z__descender", {
			unicode: ["{U+2C6B}", "{U+2C6C}"]
		},
		"lat_[c,s]_let_z__common_hook", {
			unicode: ["{U+0224}", "{U+0225}"],
			recipe: ["$-${arrow_down}"]
		},
		"lat_[c,s]_let_z__swash_hook", {
			unicode: ["{U+2C7F}", "{U+0240}"],
			recipe: ["$${arrow_rightdown}"]
		},
		"lat_c_let_z__palatal_hook", {
			unicode: "{U+1D8E}"
		},
		"lat_[c,s]_let_z__line_below", {
			unicode: ["{U+1E94}", "{U+1E95}"]
		},
		"lat_[c,s]_let_z__stroke_short", {
			unicode: ["{U+01B5}", "{U+01B6}"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[s]_let_z__tilde_overlay", {
			unicode: ["{U+1D76}"]
		},
		;
		;
		; * Uncommon Cyrillic Letters
		;
		;
		"cyr_[c,s]_let_yus_little", {
			unicode: ["{U+0466}", "{U+0467}"],
			alterations: [{}, { combining: "{U+2DFD}", }],
			options: { useLetterLocale: True, fastKey: "/Я/?Secondary" },
			recipe: ["\ат\"]
		},
		"cyr_[c,s]_let_yus_little_closed", {
			unicode: ["{U+A658}", "{U+A659}"],
			options: { useLetterLocale: True },
			recipe: ["\а_т\", "${cyr_[c,s]_let_yus_little}_"]
		},
		"cyr_[c,s]_let_yus_big", {
			unicode: ["{U+046A}", "{U+046B}"],
			alterations: [{}, { combining: "{U+2DFE}", }],
			options: { useLetterLocale: True, fastKey: "/У/?Secondary" },
			recipe: ["\аж\"]
		},
		"cyr_[c,s]_let_yus_blended", {
			unicode: ["{U+A65A}", "{U+A65B}"],
			options: { useLetterLocale: True },
			recipe: ["\ажат\", "${(cyr_[c,s]_let_yus_big|cyr_[c,s]_let_yus_little)}$(*)"]
		},
		"cyr_[c,s]_let_ye_anchor", {
			unicode: ["{U+0404}", "{U+0454}"],
			alterations: [{}, { combining: "{U+A674}" }],
			options: { secondName: True, fastKey: "/Э/?Secondary" },
			symbol: { letter: "%self%" }
		},
		"cyr_[c,s]_let_ye_yat", {
			unicode: ["{U+0462}", "{U+0463}"],
			alterations: [{}, { combining: "{U+2DFA}" }],
			options: { useLetterLocale: True, fastKey: "/Е/?Secondary" },
			recipe: ["/Ь/${stroke_long}"]
		},
		"cyr_[s]_let_ye_yat_tall", {
			unicode: ["{U+1C87}"],
			options: { useLetterLocale: True },
			recipe: ["ь${stroke_long}${arrow_up}", "${cyr_s_let_ye_yat}${arrow_up}"],
		},
		"cyr_[c,s]_let_zh_dzhe", {
			unicode: ["{U+040F}", "{U+045F}"],
			alterations: [{}, { subscript: "{U+1E06A}" }],
			options: { useLetterLocale: True, fastKey: "/Ж/?Secondary" },
			recipe: ["\дзж\"]
		},
		"cyr_[c,s]_let_zh_dje", {
			unicode: ["{U+0402}", "{U+0452}"],
			options: { useLetterLocale: True, fastKey: ">+ /Ж/?Secondary" },
			recipe: ["\джь\"]
		},
		"cyr_[c,s]_let_z_dzelo", {
			unicode: ["{U+0405}", "{U+0455}"],
			options: { useLetterLocale: True, fastKey: "/З/?Secondary" },
			recipe: ["\зел\"]
		},
		"cyr_[c,s]_let_z_dzelo_reversed", {
			unicode: ["{U+A644}", "{U+A645}"],
			options: { useLetterLocale: "dzelo$" },
			recipe: ["\зел\${arrow_left}", "${cyr_[c,s]_let_z_dzelo}${arrow_left}"],
			symbol: { beforeLetter: "reversed" }
		},
		"cyr_[c,s]_let_z_zemlya", {
			unicode: ["{U+A640}", "{U+A641}"],
			options: { useLetterLocale: True, fastKey: ">+ /З/?Secondary" },
			recipe: ["\зем\"]
		},
		"cyr_[c,s]_let_z_dzelo_archaic", {
			unicode: ["{U+A642}", "{U+A643}"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_z_zemlya}-"]
		},
		"cyr_[c,s]_let_i_decimal", {
			unicode: ["{U+0406}", "{U+0456}"],
			alterations: [{}, { combining: "{U+1E08F}", modifier: "{U+1E04C}", subscript: "{U+1E068}" }],
			options: { secondName: True, fastKey: "/И/?Secondary" },
		},
		"cyr_[c,s]_let_i_izhitsa", {
			unicode: ["{U+0474}", "{U+0475}"],
			options: { secondName: True, fastKey: "<! /И/?Secondary" },
		},
		"cyr_[c,s]_let_l_palochka", {
			unicode: ["{U+04C0}", "{U+04CF}"],
			options: { useLetterLocale: True, fastKey: "<+<! /Л/?Secondary" }
		},
		"cyr_[c,s]_let_h_shha", {
			unicode: ["{U+04BA}", "{U+04BB}"],
			options: { useLetterLocale: True, fastKey: "/Х/?Secondary" },
			recipe: ["\хх\"]
		},
		"cyr_[c,s]_let_h_shha__descender", {
			unicode: ["{U+0526}", "{U+0527}"],
			groups: ["Cyrillic"],
			options: { useLetterLocale: "Origin" },
			recipe: ["${cyr_[c,s]_let_h_shha}${descender}"]
		},
		"cyr_[c,s]_let_ch_djerv", {
			unicode: ["{U+A648}", "{U+A649}"],
			options: { useLetterLocale: True, fastKey: "<+<! /Ч/?Secondary" },
			recipe: ["\чжь\"]
		},
		"cyr_[c,s]_let_semisoft_sign", {
			unicode: ["{U+048C}", "{U+048D}"],
			alterations: [{}, { modifier: "{U+1E06C}" }],
			options: { useLetterLocale: True, fastKey: "<! /Ь/?Secondary" },
			recipe: ["/Ь/${stroke_short}"]
		},
		"cyr_[c,s]_let_y_yn", {
			unicode: ["{U+A65E}", "{U+A65F}"],
			options: { useLetterLocale: True, fastKey: "<! /Ы/?Secondary" },
			recipe: ["${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_i_izhitsa}"]
		},
		;
		;
		; * Cyrillic Ligatures
		;
		;
		"cyr_[c,s]_lig_yus_little_iotified", {
			unicode: ["{U+0468}", "{U+0469}"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}\ат\", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_yus_little}"]
		},
		"cyr_[c,s]_lig_yus_big_iotified", {
			unicode: ["{U+046C}", "{U+046D}"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}\аж\", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_yus_big}"]
		},
		"cyr_[c,s]_lig_yus_little_closed_iotified", {
			unicode: ["{U+A65C}", "{U+A65D}"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}\а_т\", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_yus_little_closed}"]
		},
		"cyr_[c,s]_lig_ae", {
			unicode: ["{U+04D4}", "{U+04D5}"],
			symbol: { letter: "${cyr_[c,s]_let_a}${cyr_[c,s]_let_ye}" },
		},
		"cyr_[c,s]_lig_a_iotified", {
			unicode: ["{U+A656}", "{U+A657}"],
			options: { useLetterLocale: True, fastKey: "<+ /Я/?Secondary" },
			recipe: ["${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_a}"]
		},
		"cyr_[c,s]_lig_dche", {
			unicode: ["{U+052C}", "{U+052D}"],
			symbol: { letter: "${cyr_[c,s]_let_d}${cyr_[c,s]_let_ch}" },
		},
		"cyr_[c,s]_lig_dzzhe", {
			unicode: ["{U+052A}", "{U+052B}"],
			symbol: { letter: "${cyr_[c,s]_let_d}${cyr_[c,s]_let_zh}" },
		},
		"cyr_[c,s]_lig_ye_iotified", {
			unicode: ["{U+0464}", "{U+0465}"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_e}", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_ye_anchor}"]
		},
		"cyr_[c,s]_lig_ye_yat_iotified", {
			unicode: ["{U+A652}", "{U+A653}"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}/Ь/${stroke_long}", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_ye_yat}"]
		},
		"cyr_[c,s]_lig_zhwe", {
			unicode: ["{U+A684}", "{U+A685}"],
			symbol: { letter: "${cyr_[c,s]_let_z}${cyr_[c,s]_let_zh}" },
		},
		"cyr_[c,s]_lig_lha", {
			unicode: ["{U+0514}", "{U+0515}"],
			symbol: { letter: "${cyr_[c,s]_let_l}${cyr_[c,s]_let_h}" },
		},
		"cyr_[c,s]_lig_lje", {
			unicode: ["{U+0409}", "{U+0459}"],
			options: { fastKey: "/Л/?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_l}${cyr_[c,s]_let_yeri}" },
		},
		"cyr_[c,s]_lig_nje", {
			unicode: ["{U+040A}", "{U+045A}"],
			options: { fastKey: "/Н/?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_n}${cyr_[c,s]_let_yeri}" },
		},
		"cyr_[c,s]_lig_oo", {
			unicode: ["{U+A698}", "{U+A699}"],
			symbol: { letter: "${cyr_[c,s]_let_o×2}" },
		},
		"cyr_[c,s]_lig_rha", {
			unicode: ["{U+0516}", "{U+0517}"],
			symbol: { letter: "${cyr_[c,s]_let_r}${cyr_[c,s]_let_h}" },
		},
		"cyr_[c,s]_lig_tetse", {
			unicode: ["{U+04B4}", "{U+04B5}"],
			symbol: { letter: "${cyr_[c,s]_let_t}${cyr_[c,s]_let_ts}" },
		},
		"cyr_[c,s]_lig_tche", {
			unicode: ["{U+A692}", "{U+A693}"],
			symbol: { letter: "${cyr_[c,s]_let_t}${cyr_[c,s]_let_ch}" },
		},
		"cyr_[c,s]_lig_tje", {
			unicode: ["{U+1C89}", "{U+1C8A}"],
			symbol: { letter: "${cyr_[c,s]_let_t}${cyr_[c,s]_let_yeri}" },
		},
		"cyr_[c,s]_lig_uk", {
			unicode: ["{U+A64A}", "{U+A64B}"],
			options: { useLetterLocale: True, fastKey: "<! /У/?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_u}${cyr_s_let_o}" },
		},
		"cyr_[s]_lig_uk_unblended", {
			unicode: ["{U+1C88}"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_s_let_i_izhitsa}${cyr_s_let_o}"],
			symbol: { letter: "${cyr_[c,s]_let_u}${cyr_s_let_o}", afterLetter: "unblended" },
		},
		"cyr_[c,s]_lig_cche", {
			unicode: ["{U+A686}", "{U+A687}"],
			symbol: { letter: "${cyr_[c,s]_let_ch}${cyr_[c,s]_let_ch}" },
		},
		"cyr_[c,s]_lig_yae", {
			unicode: ["{U+0518}", "{U+0519}"],
			symbol: { letter: "${cyr_[c,s]_let_ya}${cyr_[c,s]_let_ye}" },
		},
		;
		;
		; * Cyrillic Digraphs
		;
		;
		"cyr_[c,s]_dig_uk", {
			unicode: ["{U+0478}", "{U+0479}"],
			options: { useLetterLocale: True },
			symbol: { letter: "${cyr_[c,s]_let_o}${cyr_s_let_u}" },
		},
		"cyr_[c,s]_dig_yeru", {
			unicode: ["{U+042B}", "{U+044B}"],
			alterations: [{}, { combining: "{U+A679}", modifier: "{U+1E047}", subscript: "{U+1E066}" }],
			options: { secondName: True, noCalc: True },
			recipe: ["${cyr_[c,s]_let_yeri}${cyr_[c,s]_let_i_decimal}"],
		},
		"cyr_[c,s]_dig_yeru_with_back_yer", {
			unicode: ["{U+A650}", "{U+A651}"],
			options: { secondName: True },
			alterations: [{}, { modifier: "{U+1E06C}" }],
			recipe: ["${cyr_[c,s]_let_yer}${cyr_[c,s]_let_i_decimal}"],
		},
		;
		;
		; * Accented Cyrillic
		;
		;
		"cyr_[c,s]_let_a__breve", {
			unicode: ["{U+04D0}", "{U+04D1}"],
			options: { fastKey: "$?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_a}" }
		},
		"cyr_[c,s]_let_a__diaeresis", {
			unicode: ["{U+04D2}", "{U+04D3}"],
			options: { fastKey: "<+ $?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_a}" }
		},
		"cyr_[c,s]_let_g__acute", {
			unicode: ["{U+0403}", "{U+0453}"],
			options: { fastKey: "$?Primary" },
			symbol: { letter: "${cyr_[c,s]_let_g}" }
		},
		"cyr_[c,s]_let_g__descender", {
			unicode: ["{U+04F6}", "{U+04F7}"],
			options: { fastKey: "<! $?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_g}" }
		},
		"cyr_[c,s]_let_ye__diaeresis", {
			unicode: ["{U+0401}", "{U+0451}"],
			options: { noCalc: True },
			symbol: { letter: "${cyr_[c,s]_let_ye}" }
		},
		"cyr_[c,s]_let_i__breve", {
			unicode: ["{U+0419}", "{U+0439}"],
			options: { noCalc: True },
			symbol: { letter: "${cyr_[c,s]_let_i}" }
		},
		;
		;
		; * Glagolitic
		;
		;
		"glagolitic_c_let_az", {
			unicode: "{U+2C00}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Аз глаголицы", "capital letter Az glagolitic"],
			options: { altLayoutKey: "А" },
			alterations: { combining: "{U+1E000}", },
		},
		"glagolitic_s_let_az", {
			unicode: "{U+2C30}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква аз глаголицы", "small letter az glagolitic"],
			options: { altLayoutKey: "а" },
			alterations: { combining: "{U+1E000}", },
		},
		"glagolitic_c_let_buky", {
			unicode: "{U+2C01}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Буки глаголицы", "capital letter Buky glagolitic"],
			options: { altLayoutKey: "Б" },
			alterations: { combining: "{U+1E001}", },
		},
		"glagolitic_s_let_buky", {
			unicode: "{U+2C31}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква буки глаголицы", "small letter buky glagolitic"],
			options: { altLayoutKey: "б" },
			alterations: { combining: "{U+1E001}", },
		},
		"glagolitic_c_let_vede", {
			unicode: "{U+2C02}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Веди глаголицы", "capital letter Vede glagolitic"],
			options: { altLayoutKey: "В" },
			alterations: { combining: "{U+1E002}" },
		},
		"glagolitic_s_let_vede", {
			unicode: "{U+2C32}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква веди глаголицы", "small letter vede glagolitic"],
			options: { altLayoutKey: "в" },
			alterations: { combining: "{U+1E002}" },
		},
		"glagolitic_c_let_glagoli", {
			unicode: "{U+2C03}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Глаголи глаголицы", "capital letter Glagoli glagolitic"],
			options: { altLayoutKey: "Г" },
			alterations: { combining: "{U+1E003}" },
		},
		"glagolitic_s_let_glagoli", {
			unicode: "{U+2C33}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква глаголи глаголицы", "small letter glagoli glagolitic"],
			options: { altLayoutKey: "г" },
			alterations: { combining: "{U+1E003}" },
		},
		"glagolitic_c_let_dobro", {
			unicode: "{U+2C04}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Добро глаголицы", "capital letter Dobro glagolitic"],
			options: { altLayoutKey: "Д" },
			alterations: { combining: "{U+1E004}" },
		},
		"glagolitic_s_let_dobro", {
			unicode: "{U+2C34}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква добро глаголицы", "small letter dobro glagolitic"],
			options: { altLayoutKey: "д" },
			alterations: { combining: "{U+1E004}" },
		},
		"glagolitic_c_let_yestu", {
			unicode: "{U+2C05}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Есть глаголицы", "capital letter Yestu glagolitic"],
			options: { altLayoutKey: "Е" },
			alterations: { combining: "{U+1E005}" },
		},
		"glagolitic_s_let_yestu", {
			unicode: "{U+2C35}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква есть глаголицы", "small letter yestu glagolitic"],
			options: { altLayoutKey: "е" },
			alterations: { combining: "{U+1E005}" },
		},
		"glagolitic_c_let_zhivete", {
			unicode: "{U+2C06}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Живете глаголицы", "capital letter Zhivete glagolitic"],
			options: { altLayoutKey: "Ж" },
			alterations: { combining: "{U+1E006}" },
		},
		"glagolitic_s_let_zhivete", {
			unicode: "{U+2C36}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква живете глаголицы", "small letter zhivete glagolitic"],
			options: { altLayoutKey: "ж" },
			alterations: { combining: "{U+1E006}" },
		},
		"glagolitic_c_let_dzelo", {
			unicode: "{U+2C07}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Зело глаголицы", "capital letter Dzelo glagolitic"],
			options: { altLayoutKey: ">! С" },
		},
		"glagolitic_s_let_dzelo", {
			unicode: "{U+2C37}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква зело глаголицы", "small letter dzelo glagolitic"],
			options: { altLayoutKey: ">! с" },
		},
		"glagolitic_c_let_zemlja", {
			unicode: "{U+2C08}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Земля глаголицы", "capital letter Zemlja glagolitic"],
			options: { altLayoutKey: "З" },
			alterations: { combining: "{U+1E008}" },
		},
		"glagolitic_s_let_zemlja", {
			unicode: "{U+2C38}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква земля глаголицы", "small letter zemlja glagolitic"],
			options: { altLayoutKey: "з" },
			alterations: { combining: "{U+1E008}" },
		},
		"glagolitic_c_let_initial_izhe", {
			unicode: "{U+2C0A}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква начальное Иже глаголицы", "capital letter initial Izhe glagolitic"],
			options: { altLayoutKey: ">! И" },
			alterations: { combining: "{U+1E00A}" },
		},
		"glagolitic_s_let_initial_izhe", {
			unicode: "{U+2C3A}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква начальное иже глаголицы", "small letter initial izhe glagolitic"],
			options: { altLayoutKey: ">! и" },
			alterations: { combining: "{U+1E00A}" },
		},
		"glagolitic_c_let_izhe", {
			unicode: "{U+2C09}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Иже глаголицы", "capital letter Izhe glagolitic"],
			options: { altLayoutKey: "<+ И], [Й" },
			alterations: { combining: "{U+1E009}" },
		},
		"glagolitic_s_let_izhe", {
			unicode: "{U+2C39}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква иже глаголицы", "small letter izhe glagolitic"],
			options: { altLayoutKey: "<+ и], [й" },
			alterations: { combining: "{U+1E009}" },
		},
		"glagolitic_c_let_i", {
			unicode: "{U+2C0B}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ие глаголицы", "capital letter I glagolitic"],
			options: { altLayoutKey: "И" },
			alterations: { combining: "{U+1E00B}" },
		},
		"glagolitic_s_let_i", {
			unicode: "{U+2C3B}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква и глаголицы", "small letter i glagolitic"],
			options: { altLayoutKey: "и" },
			alterations: { combining: "{U+1E00B}" },
		},
		"glagolitic_c_let_djervi", {
			unicode: "{U+2C0C}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Гюрв глаголицы", "capital letter Djervi glagolitic"],
			options: { altLayoutKey: ">! Ж" },
			alterations: { combining: "{U+1E00C}" },
		},
		"glagolitic_s_let_djervi", {
			unicode: "{U+2C3C}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква гюрв глаголицы", "small letter djervi glagolitic"],
			options: { altLayoutKey: ">! ж" },
			alterations: { combining: "{U+1E00C}" },
		},
		"glagolitic_c_let_kako", {
			unicode: "{U+2C0D}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Како глаголицы", "capital letter Kako glagolitic"],
			options: { altLayoutKey: "К" },
			alterations: { combining: "{U+1E00D}" },
		},
		"glagolitic_s_let_kako", {
			unicode: "{U+2C3D}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква како глаголицы", "small letter kako glagolitic"],
			options: { altLayoutKey: "к" },
			alterations: { combining: "{U+1E00D}" },
		},
		"glagolitic_c_let_ljudije", {
			unicode: "{U+2C0E}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Люди глаголицы", "capital letter Ljudije glagolitic"],
			options: { altLayoutKey: "Л" },
			alterations: { combining: "{U+1E00E}" },
		},
		"glagolitic_s_let_ljudije", {
			unicode: "{U+2C3E}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква люди глаголицы", "small letter ljudije glagolitic"],
			options: { altLayoutKey: "л" },
			alterations: { combining: "{U+1E00E}" },
		},
		"glagolitic_c_let_myslite", {
			unicode: "{U+2C0F}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Мыслете глаголицы", "capital letter Myslite glagolitic"],
			options: { altLayoutKey: "М" },
			alterations: { combining: "{U+1E00F}" },
		},
		"glagolitic_s_let_myslite", {
			unicode: "{U+2C3F}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква мыслете глаголицы", "small letter myslite glagolitic"],
			options: { altLayoutKey: "м" },
			alterations: { combining: "{U+1E00F}" },
		},
		"glagolitic_c_let_nashi", {
			unicode: "{U+2C10}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Наш глаголицы", "capital letter Nashi glagolitic"],
			options: { altLayoutKey: "Н" },
			alterations: { combining: "{U+1E010}" },
		},
		"glagolitic_s_let_nashi", {
			unicode: "{U+2C40}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква наш глаголицы", "small letter nashi glagolitic"],
			options: { altLayoutKey: "н" },
			alterations: { combining: "{U+1E010}" },
		},
		"glagolitic_c_let_onu", {
			unicode: "{U+2C11}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Он глаголицы", "capital letter Onu glagolitic"],
			options: { altLayoutKey: "О" },
			alterations: { combining: "{U+1E011}" },
		},
		"glagolitic_s_let_onu", {
			unicode: "{U+2C41}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква он глаголицы", "small letter onu glagolitic"],
			options: { altLayoutKey: "о" },
			alterations: { combining: "{U+1E011}" },
		},
		"glagolitic_c_let_pokoji", {
			unicode: "{U+2C12}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Покой глаголицы", "capital letter Pokoji glagolitic"],
			options: { altLayoutKey: "П" },
			alterations: { combining: "{U+1E012}" },
		},
		"glagolitic_s_let_pokoji", {
			unicode: "{U+2C42}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква покой глаголицы", "small letter pokoji glagolitic"],
			options: { altLayoutKey: "п" },
			alterations: { combining: "{U+1E012}" },
		},
		"glagolitic_c_let_ritsi", {
			unicode: "{U+2C13}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Рцы глаголицы", "capital letter Ritsi glagolitic"],
			options: { altLayoutKey: "Р" },
			alterations: { combining: "{U+1E013}" },
		},
		"glagolitic_s_let_ritsi", {
			unicode: "{U+2C43}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква рцы глаголицы", "small letter ritsi glagolitic"],
			options: { altLayoutKey: "р" },
			alterations: { combining: "{U+1E013}" },
		},
		"glagolitic_c_let_slovo", {
			unicode: "{U+2C14}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Слово глаголицы", "capital letter Slovo glagolitic"],
			options: { altLayoutKey: "С" },
			alterations: { combining: "{U+1E014}" },
		},
		"glagolitic_s_let_slovo", {
			unicode: "{U+2C44}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква слово глаголицы", "small letter slovo glagolitic"],
			options: { altLayoutKey: "с" },
			alterations: { combining: "{U+1E014}" },
		},
		"glagolitic_c_let_tvrido", {
			unicode: "{U+2C15}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная Твердо глаголицы", "capital letter Tvrido glagolitic"],
			options: { altLayoutKey: "Т" },
			alterations: { combining: "{U+1E015}" },
		},
		"glagolitic_s_let_tvrido", {
			unicode: "{U+2C45}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная твердо глаголицы", "small letter tvrido glagolitic"],
			options: { altLayoutKey: "т" },
			alterations: { combining: "{U+1E015}" },
		},
		"glagolitic_c_let_izhitsa", {
			unicode: "{U+2C2B}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква начальное Иже глаголицы", "capital letter Izhitsae glagolitic"],
			options: { altLayoutKey: ">!<+ И" },
		},
		"glagolitic_s_let_izhitsa", {
			unicode: "{U+2C5B}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква начальное иже глаголицы", "small letter izhitsa glagolitic"],
			options: { altLayoutKey: ">!<+ и" },
		},
		"glagolitic_c_let_uku", {
			unicode: "{U+2C16}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ук глаголицы", "capital letter Uku glagolitic"],
			options: { altLayoutKey: "У" },
			alterations: { combining: "{U+1E016}" },
		},
		"glagolitic_s_let_uku", {
			unicode: "{U+2C46}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ук глаголицы", "small letter uku glagolitic"],
			options: { altLayoutKey: "у" },
			alterations: { combining: "{U+1E016}" },
		},
		"glagolitic_c_let_fritu", {
			unicode: "{U+2C17}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ферт глаголицы", "capital letter Fritu glagolitic"],
			options: { altLayoutKey: "Ф" },
			alterations: { combining: "{U+1E017}" },
		},
		"glagolitic_s_let_fritu", {
			unicode: "{U+2C47}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ферт глаголицы", "small letter fritu glagolitic"],
			options: { altLayoutKey: "ф" },
			alterations: { combining: "{U+1E017}" },
		},
		"glagolitic_c_let_heru", {
			unicode: "{U+2C18}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Хер глаголицы", "capital letter Heru glagolitic"],
			options: { altLayoutKey: "Х" },
			alterations: { combining: "{U+1E018}" },
		},
		"glagolitic_s_let_heru", {
			unicode: "{U+2C48}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква хер глаголицы", "small letter heru glagolitic"],
			options: { altLayoutKey: "х" },
			alterations: { combining: "{U+1E018}" },
		},
		"glagolitic_c_let_otu", {
			unicode: "{U+2C19}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква От глаголицы", "capital letter Otu glagolitic"],
			options: { altLayoutKey: ">! О" },
		},
		"glagolitic_s_let_otu", {
			unicode: "{U+2C49}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква от глаголицы", "small letter otu glagolitic"],
			options: { altLayoutKey: ">! о" },
		},
		"glagolitic_c_let_pe", {
			unicode: "{U+2C1A}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Пе глаголицы", "capital letter Pe glagolitic"],
			options: { altLayoutKey: ">! П" },
		},
		"glagolitic_s_let_pe", {
			unicode: "{U+2C4A}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква пе глаголицы", "small letter pe glagolitic"],
			options: { altLayoutKey: ">! п" },
		},
		"glagolitic_c_let_tsi", {
			unicode: "{U+2C1C}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Цы глаголицы", "capital letter Tsi glagolitic"],
			options: { altLayoutKey: "Ц" },
			alterations: { combining: "{U+1E01C}" },
		},
		"glagolitic_s_let_tsi", {
			unicode: "{U+2C4C}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква цы глаголицы", "small letter tsi glagolitic"],
			options: { altLayoutKey: "ц" },
			alterations: { combining: "{U+1E01C}" },
		},
		"glagolitic_c_let_chrivi", {
			unicode: "{U+2C1D}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Червь глаголицы", "capital letter Chrivi glagolitic"],
			options: { altLayoutKey: "Ч" },
			alterations: { combining: "{U+1E01D}" },
		},
		"glagolitic_s_let_chrivi", {
			unicode: "{U+2C4D}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква червь глаголицы", "small letter chrivi glagolitic"],
			options: { altLayoutKey: "ч" },
			alterations: { combining: "{U+1E01D}" },
		},
		"glagolitic_c_let_sha", {
			unicode: "{U+2C1E}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ша глаголицы", "capital letter Sha glagolitic"],
			options: { altLayoutKey: "Ш" },
			alterations: { combining: "{U+1E01E}" },
		},
		"glagolitic_s_let_sha", {
			unicode: "{U+2C4E}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ша глаголицы", "small letter sha glagolitic"],
			options: { altLayoutKey: "ш" },
			alterations: { combining: "{U+1E01E}" },
		},
		"glagolitic_c_let_shta", {
			unicode: "{U+2C1B}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Шта глаголицы", "capital letter Shta glagolitic"],
			options: { altLayoutKey: "Щ" },
			alterations: { combining: "{U+1E01B}" },
		},
		"glagolitic_s_let_shta", {
			unicode: "{U+2C4B}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква шта глаголицы", "small letter shta glagolitic"],
			options: { altLayoutKey: "щ" },
			alterations: { combining: "{U+1E01B}" },
		},
		"glagolitic_c_let_yeru", {
			unicode: "{U+2C1F}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Еръ глаголицы", "capital letter Yeru glagolitic"],
			options: { altLayoutKey: "Ъ" },
			alterations: { combining: "{U+1E01F}" },
		},
		"glagolitic_s_let_yeru", {
			unicode: "{U+2C4F}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква еръ глаголицы", "small letter yeru glagolitic"],
			options: { altLayoutKey: "ъ" },
			alterations: { combining: "{U+1E01F}" },
		},
		"glagolitic_c_let_yery", {
			unicode: "{U+2C1F}",
			sequence: ["{U+2C1F}", "{U+2C0A}"],
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Еры глаголицы", "capital letter Yery glagolitic"],
			options: { altLayoutKey: "Ы" },
			alterations: { combining: ["{U+1E01F}", "{U+1E00A}"], },
			symbol: { custom: "s36" },
		},
		"glagolitic_s_let_yery", {
			unicode: "{U+2C4F}",
			sequence: ["{U+2C4F}", "{U+2C3A}"],
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква еры глаголицы", "small letter yery glagolitic"],
			options: { altLayoutKey: "ы" },
			alterations: { combining: ["{U+1E01F}", "{U+1E00A}"], },
			symbol: { custom: "s36" },
		},
		"glagolitic_c_let_yeri", {
			unicode: "{U+2C20}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ерь глаголицы", "capital letter Yeri glagolitic"],
			options: { altLayoutKey: "Ь" },
			alterations: { combining: "{U+1E020}" },
		},
		"glagolitic_s_let_yeri", {
			unicode: "{U+2C50}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ерь глаголицы", "small letter yeri glagolitic"],
			options: { altLayoutKey: "ь" },
		},
		"glagolitic_c_let_yati", {
			unicode: "{U+2C21}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ять глаголицы", "capital letter Yati glagolitic"],
			options: { altLayoutKey: "Я" },
			alterations: { combining: "{U+1E021}" },
		},
		"glagolitic_s_let_yati", {
			unicode: "{U+2C51}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ять глаголицы", "small letter yati glagolitic"],
			options: { altLayoutKey: "я" },
			alterations: { combining: "{U+1E021}" },
		},
		"glagolitic_c_let_yo", {
			unicode: "{U+2C26}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ё глаголицы", "capital letter Yo glagolitic"],
			options: { altLayoutKey: "Ё" },
			alterations: { combining: "{U+1E026}" },
		},
		"glagolitic_s_let_yo", {
			unicode: "{U+2C56}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ё глаголицы", "small letter yo glagolitic"],
			options: { altLayoutKey: "ё" },
			alterations: { combining: "{U+1E026}" },
		},
		"glagolitic_c_let_spider_ha", {
			unicode: "{U+2C22}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Хлъмъ глаголицы", "capital letter spider Ha glagolitic"],
			options: { altLayoutKey: ">! Х" },
		},
		"glagolitic_s_let_spider_ha", {
			unicode: "{U+2C52}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква хлъмъ глаголицы", "small letter spider ha glagolitic"],
			options: { altLayoutKey: ">! х" },
		},
		"glagolitic_c_let_yu", {
			unicode: "{U+2C23}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ю глаголицы", "capital letter Yu glagolitic"],
			options: { altLayoutKey: "Ю" },
			alterations: { combining: "{U+1E023}" },
		},
		"glagolitic_s_let_yu", {
			unicode: "{U+2C53}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ю глаголицы", "small letter yu glagolitic"],
			options: { altLayoutKey: "ю" },
			alterations: { combining: "{U+1E023}" },
		},
		"glagolitic_c_let_small_yus", {
			unicode: "{U+2C24}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс малый глаголицы", "capital letter small letter Yus glagolitic"],
			options: { altLayoutKey: "Э" },
			alterations: { combining: "{U+1E024}" },
		},
		"glagolitic_s_let_small_yus", {
			unicode: "{U+2C54}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс малый глаголицы", "small letter small letter yus glagolitic"],
			options: { altLayoutKey: "э" },
			alterations: { combining: "{U+1E024}" },
		},
		"glagolitic_c_let_small_yus_iotified", {
			unicode: "{U+2C27}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс малый йотированный глаголицы", "capital letter small letter Yus iotified glagolitic"],
			options: { altLayoutKey: ">! Э" },
			alterations: { combining: "{U+1E027}" },
			recipe: ["${glagolitic_c_let_yestu}${glagolitic_c_let_small_yus}"],
		},
		"glagolitic_s_let_small_yus_iotified", {
			unicode: "{U+2C57}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс малый йотированный глаголицы", "small letter small letter yus iotified glagolitic"],
			options: { altLayoutKey: ">! э" },
			alterations: { combining: "{U+1E027}" },
			recipe: ["${glagolitic_s_let_yestu}${glagolitic_s_let_small_yus}"],
		},
		"glagolitic_c_let_big_yus", {
			unicode: "{U+2C28}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс большой глаголицы", "capital letter big Yus glagolitic"],
			options: { altLayoutKey: "<! О" },
			alterations: { combining: "{U+1E028}" },
			recipe: ["${glagolitic_c_let_onu}${glagolitic_c_let_small_yus}"],
		},
		"glagolitic_s_let_big_yus", {
			unicode: "{U+2C58}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс большой глаголицы", "small letter big yus glagolitic"],
			options: { altLayoutKey: "<! о" },
			alterations: { combining: "{U+1E028}" },
			recipe: ["${glagolitic_s_let_onu}${glagolitic_s_let_small_yus}"],
		},
		"glagolitic_c_let_big_yus_iotified", {
			unicode: "{U+2C29}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс большой йотированный глаголицы", "capital letter big Yus iotified glagolitic"],
			options: { altLayoutKey: "<! Ё" },
			alterations: { combining: "{U+1E029}" },
			recipe: ["${glagolitic_c_let_yo}${glagolitic_c_let_small_yus}"],
		},
		"glagolitic_s_let_big_yus_iotified", {
			unicode: "{U+2C59}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс большой йотированный глаголицы", "small letter big yus iotified glagolitic"],
			options: { altLayoutKey: "<! ё" },
			alterations: { combining: "{U+1E029}" },
			recipe: ["${glagolitic_s_let_yo}${glagolitic_s_let_small_yus}"],
		},
		"glagolitic_c_let_fita", {
			unicode: "{U+2C2A}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Фита глаголицы", "capital letter Fita glagolitic"],
			options: { altLayoutKey: ">! Ф" },
			alterations: { combining: "{U+1E02A}" },
		},
		"glagolitic_s_let_fita", {
			unicode: "{U+2C5A}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква фита глаголицы", "small letter fita glagolitic"],
			options: { altLayoutKey: ">! ф" },
			alterations: { combining: "{U+1E02A}" },
		},
		"glagolitic_c_let_shtapic", {
			unicode: "{U+2C2C}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Штапик глаголицы", "capital letter Shtapic glagolitic"],
			options: { altLayoutKey: ">! Ъ" },
		},
		"glagolitic_s_let_shtapic", {
			unicode: "{U+2C5C}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква штапик глаголицы", "small letter shtapic glagolitic"],
			options: { altLayoutKey: ">! ъ" },
		},
		"glagolitic_c_let_trokutasti_a", {
			unicode: "{U+2C2D}",
			groups: ["Glagolitic Letters"],
			tags: ["прописная треугольная А глаголицы", "capital letter trokutasti A glagolitic"],
			options: { altLayoutKey: ">! А" },
		},
		"glagolitic_s_let_trokutasti_a", {
			unicode: "{U+2C5D}",
			groups: ["Glagolitic Letters"],
			tags: ["строчная треугольная a глаголицы", "small letter trokutasti a glagolitic"],
			options: { altLayoutKey: ">! а" },
		},
		;
		;
		; * Germanic Runes
		;
		;
		"futhark_ansuz", {
			unicode: "{U+16A8}",
			tags: ["старший футарк ансуз", "elder futhark ansuz"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "A" },
		},
		"futhark_berkanan", {
			unicode: "{U+16D2}",
			tags: ["старший футарк беркана", "elder futhark berkanan", "futhork beorc", "younger futhark bjarkan"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "B" },
		},
		"futhark_dagaz", {
			unicode: "{U+16DE}",
			tags: ["старший футарк дагаз", "elder futhark dagaz", "futhork daeg", "futhork dæg"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "D" },
		},
		"futhark_ehwaz", {
			unicode: "{U+16D6}",
			tags: ["старший футарк эваз", "elder futhark ehwaz", "futhork eh"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "E" },
		},
		"futhark_fehu", {
			unicode: "{U+16A0}",
			tags: ["старший футарк феху", "elder futhark fehu", "futhork feoh", "younger futhark fe", "younger futhark fé"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "F" },
		},
		"futhark_gebo", {
			unicode: "{U+16B7}",
			tags: ["старший футарк гебо", "elder futhark gebo", "futhork gyfu", "elder futhark gebō"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "G" },
		},
		"futhark_haglaz", {
			unicode: "{U+16BA}",
			tags: ["старший футарк хагалаз", "elder futhark hagalaz"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "H" },
		},
		"futhark_isaz", {
			unicode: "{U+16C1}",
			tags: ["старший футарк исаз", "elder futhark isaz", "futhork is", "younger futhark iss", "futhork īs", "younger futhark íss"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "I" },
		},
		"futhark_eihwaz", {
			unicode: "{U+16C7}",
			tags: ["старший футарк эваз", "elder futhark eihwaz", "elder futhark iwaz", "elder futhark ēihwaz", "futhork eoh", "futhork ēoh"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: ">+ I" },
		},
		"futhark_jeran", {
			unicode: "{U+16C3}",
			tags: ["старший футарк йера", "elder futhark jeran", "elder futhark jēra"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "J" },
		},
		"futhark_kauna", {
			unicode: "{U+16B2}",
			tags: ["старший футарк кеназ", "elder futhark kauna", "elder futhark kenaz", "elder futhark kauną"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "K" },
		},
		"futhark_laguz", {
			unicode: "{U+16DA}",
			tags: ["старший футарк лагуз", "elder futhark laukaz", "elder futhark laguz", "futhork lagu", "futhork logr", "futhork lögr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "L" },
		},
		"futhark_mannaz", {
			unicode: "{U+16D7}",
			tags: ["старший футарк манназ", "elder futhark mannaz", "futhork mann"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "M" },
		},
		"futhark_naudiz", {
			unicode: "{U+16BE}",
			tags: ["старший футарк наудиз", "elder futhark naudiz", "futhork nyd", "younger futhark naudr", "younger futhark nauðr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "N" },
		},
		"futhark_ingwaz", {
			unicode: "{U+16DC}",
			tags: ["старший футарк ингваз", "elder futhark ingwaz"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: ">+ N" },
		},
		"futhark_odal", {
			unicode: "{U+16DF}",
			tags: ["старший футарк одал", "elder futhark othala", "futhork edel", "elder futhark ōþala", "futhork ēðel"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "O", legend: "NorseRunes\othala" },
		},
		"futhark_pertho", {
			unicode: "{U+16C8}",
			tags: ["старший футарк перто", "elder futhark pertho", "futhork peord", "elder futhark perþō", "futhork peorð"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "P" },
		},
		"futhark_raido", {
			unicode: "{U+16B1}",
			tags: ["старший футарк райдо", "elder futhark raido", "futhork rad", "younger futhark reid", "elder futhark raidō", "futhork rād", "younger futhark reið"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "R" },
		},
		"futhark_sowilo", {
			unicode: "{U+16CA}",
			tags: ["старший футарк совило", "elder futhark sowilo", "elder futhark sōwilō"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "S" },
		},
		"futhark_tiwaz", {
			unicode: "{U+16CF}",
			tags: ["старший футарк тейваз", "elder futhark tiwaz", "futhork ti", "futhork tir", "younger futhark tyr", "elder futhark tēwaz", "futhork tī", "futhork tīr", "younger futhark týr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "T" },
		},
		"futhark_thurisaz", {
			unicode: "{U+16A6}",
			tags: ["старший футарк турисаз", "elder futhark thurisaz", "futhork thorn", "younger futhark thurs", "elder futhark þurisaz", "futhork þorn", "younger futhark þurs"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: ">+T" },
		},
		"futhark_uruz", {
			unicode: "{U+16A2}",
			tags: ["старший футарк уруз", "elder futhark uruz", "elder futhark ura", "futhork ur", "younger futhark ur", "elder futhark ūrą", "elder futhark ūruz", "futhork ūr", "younger futhark úr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "U" },
		},
		"futhark_wunjo", {
			unicode: "{U+16B9}",
			tags: ["старший футарк вуньо", "elder futhark wunjo", "futhork wynn", "elder futhark wunjō", "elder futhark ƿunjō", "futhork ƿynn"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "W" },
		},
		"futhark_algiz", {
			unicode: "{U+16C9}",
			tags: ["старший футарк альгиз", "elder futhark algiz", "futhork eolhx"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "Z" },
		},
		"futhork_as", {
			unicode: "{U+16AA}",
			tags: ["футорк ас", "futhork as", "futhork ās"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ A" },
		},
		"futhork_aesc", {
			unicode: "{U+16AB}",
			tags: ["футорк эск", "futhork aesc", "futhork æsc"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ A" },
			recipe: ["${futhark_ansuz}${futhark_ehwaz}"],
		},
		"futhork_cen", {
			unicode: "{U+16B3}",
			tags: ["футорк кен", "futhork cen", "futhork cēn"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "C" },
		},
		"futhork_ear", {
			unicode: "{U+16E0}",
			tags: ["футорк эар", "ear"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ E" },
		},
		"futhork_gar", {
			unicode: "{U+16B8}",
			tags: ["футорк гар", "futhork gar", "futhork gār"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ G" },
		},
		"futhork_haegl", {
			unicode: "{U+16BB}",
			tags: ["футорк хегль", "futhork haegl", "futhork hægl"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ H" },
		},
		"futhork_ger", {
			unicode: "{U+16C4}",
			tags: ["футорк гер", "futhork ger", "futhork gēr"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ J" },
		},
		"futhork_ior", {
			unicode: "{U+16E1}",
			tags: ["футорк йор", "futhork gerx", "futhork ior", "younger futhark arx", "futhork gērx", "futhork īor", "youner futhark árx"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ J" },
		},
		"futhork_cealc", {
			unicode: "{U+16E4}",
			tags: ["футорк келк", "futhork cealc"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ K" },
		},
		"futhork_calc", {
			unicode: "{U+16E3}",
			tags: ["футорк калк", "futhork calc"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ K" },
		},
		"futhork_ing", {
			unicode: "{U+16DD}",
			tags: ["футорк инг", "futhork ing"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ N" },
		},
		"futhork_os", {
			unicode: "{U+16A9}",
			tags: ["футорк ос", "futhork os", "futhork ōs"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ O" },
		},
		"futhork_cweorth", {
			unicode: "{U+16E2}",
			tags: ["футорк квирд", "futhark cweorth", "futhork cƿeorð"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "Q" },
		},
		"futhork_sigel", {
			unicode: "{U+16CB}",
			tags: ["футорк сигель", "futhork sigel", "younger futhark sól"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ S" },
		},
		"futhork_stan", {
			unicode: "{U+16E5}",
			tags: ["футорк стан", "futhork stan"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ S" },
		},
		"futhork_yr", {
			unicode: "{U+16A3}",
			tags: ["футорк ир", "futhork yr", "futhork ȳr"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ Y" },
		},
		"futhark_younger_jera", {
			unicode: "{U+16C5}",
			tags: ["младший футарк йера", "younger futhark jera", "younger futhark ar", "younger futhark ár"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! A" },
		},
		"futhark_younger_jera_short_twig", {
			unicode: "{U+16C6}",
			tags: ["младший футарк короткая йера", "younger futhark short twig jera"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ A" },
		},
		"futhark_younger_bjarkan_short_twig", {
			unicode: "{U+16D3}",
			tags: ["младший футарк короткая беркана", "younger futhark short twig bjarkan"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ B" },
		},
		"futhark_younger_hagall", {
			unicode: "{U+16BC}",
			tags: ["младший футарк хагал", "younger futhark hagall"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! H" },
		},
		"futhark_younger_hagall_short_twig", {
			unicode: "{U+16BD}",
			tags: ["младший футарк короткий хагал", "younger futhark short twig hagall"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ H" },
		},
		"futhark_younger_kaun", {
			unicode: "{U+16B4}",
			tags: ["младший футарк каун", "younger futhark kaun"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! K" },
		},
		"futhark_younger_madr", {
			unicode: "{U+16D8}",
			tags: ["младший футарк мадр", "younger futhark madr", "younger futhark maðr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! M" },
		},
		"futhark_younger_madr_short_twig", {
			unicode: "{U+16D9}",
			tags: ["младший футарк короткий мадр", "younger futhark short twig madr", "younger futhark short twig maðr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ M" },
		},
		"futhark_younger_naud_short_twig", {
			unicode: "{U+16BF}",
			tags: ["младший футарк короткий науд", "younger futhark short twig naud", "younger futhark short twig nauðr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ N" },
		},
		"futhark_younger_oss", {
			unicode: "{U+16AC}",
			tags: ["младший футарк осс", "younger futhark oss", "younger futhark óss"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! O" },
		},
		"futhark_younger_oss_short_twig", {
			unicode: "{U+16AD}",
			tags: ["младший футарк короткий осс", "younger futhark short twig oss", "younger futhark short twig óss"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ O" },
		},
		"futhark_younger_sol_short_twig", {
			unicode: "{U+16CC}",
			tags: ["младший футарк короткий сол", "younger futhark short twig sol", "younger futhark short twig sól"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ S" },
		},
		"futhark_younger_tyr_short_twig", {
			unicode: "{U+16D0}",
			tags: ["младший футарк короткий тир", "younger futhark short twig tyr", "younger futhark short twig týr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ T" },
		},
		"futhark_younger_ur", {
			unicode: "{U+16A4}",
			tags: ["младший футарк ур", "younger futhark ur"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: "Y" },
		},
		"futhark_younger_yr", {
			unicode: "{U+16E6}",
			tags: ["младший футарк короткий тис", "younger futhark yr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!Y" },
		},
		"futhark_younger_yr_short_twig", {
			unicode: "{U+16E7}",
			tags: ["младший футарк короткий тис", "younger futhark short twig yr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ Y" },
		},
		"futhark_younger_icelandic_yr", {
			unicode: "{U+16E8}",
			tags: ["младший футарк исладнский тис", "younger futhark icelandic yr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">+ Y" },
		},
		"futhark_almanac_arlaug", {
			unicode: "{U+16EE}",
			tags: ["золотой номер 17 арлауг", "golden number 17 arlaug"],
			groups: ["Almanac Runes"],
			options: { altLayoutKey: ">! 7" },
		},
		"futhark_almanac_tvimadur", {
			unicode: "{U+16EF}",
			tags: ["золотой номер 18 твимадур", "golden number 18 tvimadur", "golden number 18 tvímaður"],
			groups: ["Almanac Runes"],
			options: { altLayoutKey: ">! 8" },
		},
		"futhark_almanac_belgthor", {
			unicode: "{U+16F0}",
			tags: ["золотой номер 19 белгтор", "golden number 19 belgthor"],
			groups: ["Almanac Runes"],
			options: { altLayoutKey: ">! 9" },
		},
		"futhark_younger_later_e", {
			unicode: "{U+16C2}",
			tags: ["младшяя поздняя е", "later younger futhark e"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! E" },
		},
		"futhark_younger_later_eth", {
			unicode: "{U+16A7}",
			tags: ["поздний младший футарк эт", "later younger futhark eth"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! D" },
		},
		"futhark_younger_later_d", {
			unicode: "{U+16D1}",
			tags: ["поздний младший футарк д", "later younger futhark d"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ D" },
		},
		"futhark_younger_later_l", {
			unicode: "{U+16DB}",
			tags: ["поздний младший футарк л", "later younger futhark l"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! L" },
		},
		"futhark_younger_later_p", {
			unicode: "{U+16D4}",
			tags: ["младшяя поздняя п", "later younger futhark p"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! P" },
		},
		"futhark_younger_later_v", {
			unicode: "{U+16A1}",
			tags: ["поздний младший футарк в", "later younger futhark v"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: "V" },
		},
		"medieval_c", {
			unicode: "{U+16CD}",
			tags: ["средневековый си", "medieval с"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! C" },
		},
		"medieval_en", {
			unicode: "{U+16C0}",
			tags: ["средневековый эн", "medieval en"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! N" },
		},
		"medieval_on", {
			unicode: "{U+16B0}",
			tags: ["средневековый он", "medieval on"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! O" },
		},
		"medieval_o", {
			unicode: "{U+16AE}",
			tags: ["средневековый о", "medieval o"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<!>+ O" },
		},
		"medieval_x", {
			unicode: "{U+16EA}",
			tags: ["средневековый экс", "medieval ex"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! X" },
		},
		"medieval_z", {
			unicode: "{U+16CE}",
			tags: ["средневековый зе", "medieval ze"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! Z" },
		},
		"runic_single_punctuation", {
			unicode: "{U+16EB}",
			tags: ["руническая одиночное препинание", "runic single punctuation"],
			groups: ["Runic Punctuation"],
			options: { altLayoutKey: ">! ." },
		},
		"runic_multiple_punctuation", {
			unicode: "{U+16EC}",
			tags: ["руническое двойное препинание", "runic multiple punctuation"],
			groups: ["Runic Punctuation"],
			options: { altLayoutKey: ">! Space" },
		},
		"runic_cruciform_punctuation", {
			unicode: "{U+16ED}",
			tags: ["руническое крестовидное препинание", "runic cruciform punctuation"],
			groups: ["Runic Punctuation"],
			options: { altLayoutKey: ">! ," },
		},
		;
		;
		; * Old Turkic
		;
		;
		"turkic_orkhon_a", {
			unicode: "{U+10C00}",
			tags: ["древнетюркская орхонская буква а", "old turkic orkhon letter a"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "A" },
		},
		"turkic_yenisei_a", {
			unicode: "{U+10C01}",
			tags: ["древнетюркская енисейская буква а", "old turkic yenisei letter a"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* A" },
		},
		"turkic_yenisei_ae", {
			unicode: "{U+10C02}",
			tags: ["древнетюркская енисейская буква я", "old turkic yenisei letter ae"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: ">! A" },
		},
		"turkic_yenisei_e", {
			unicode: "{U+10C05}",
			tags: ["древнетюркская енисейская буква е", "old turkic yenisei letter e"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "E" },
		},
		"turkic_orkhon_i", {
			unicode: "{U+10C03}",
			tags: ["древнетюркская орхонская буква и", "old turkic orkhon letter i"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "I" },
		},
		"turkic_yenisei_i", {
			unicode: "{U+10C04}",
			tags: ["древнетюркская енисейская буква и", "old turkic yenisei letter i"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* I" },
		},
		"turkic_orkhon_o", {
			unicode: "{U+10C06}",
			tags: ["древнетюркская орхонская буква о", "old turkic orkhon letter o"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "O" },
		},
		"turkic_orkhon_oe", {
			unicode: "{U+10C07}",
			tags: ["древнетюркская орхонская буква ё", "old turkic orkhon letter oe"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! O" },
		},
		"turkic_yenisei_oe", {
			unicode: "{U+10C08}",
			tags: ["древнетюркская енисейская буква ё", "old turkic yenisei letter oe"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! O" },
		},
		"turkic_orkhon_ec", {
			unicode: "{U+10C32}",
			tags: ["древнетюркская орхонская буква эч", "old turkic orkhon letter ec"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "C" },
		},
		"turkic_yenisei_ec", {
			unicode: "{U+10C33}",
			tags: ["древнетюркская енисейская буква эч", "old turkic yenisei letter ec"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* C" },
		},
		"turkic_orkhon_em", {
			unicode: "{U+10C22}",
			tags: ["древнетюркская орхонская буква эм", "old turkic orkhon letter em"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "M" },
		},
		"turkic_orkhon_eng", {
			unicode: "{U+10C2D}",
			tags: ["древнетюркская орхонская буква энг", "old turkic orkhon letter eng"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! N" },
		},
		"turkic_orkhon_ep", {
			unicode: "{U+10C2F}",
			tags: ["древнетюркская орхонская буква эп", "old turkic orkhon letter ep"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "P" },
		},
		"turkic_orkhon_esh", {
			unicode: "{U+10C41}",
			tags: ["древнетюркская орхонская буква эш", "old turkic orkhon letter esh"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! S" },
		},
		"turkic_yenisei_esh", {
			unicode: "{U+10C42}",
			tags: ["древнетюркская енисейская буква эш", "old turkic yenisei letter esh"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<! S" },
		},
		"turkic_orkhon_ez", {
			unicode: "{U+10C14}",
			tags: ["древнетюркская орхонская буква эз", "old turkic orkhon letter ez"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "Z" },
		},
		"turkic_yenisei_ez", {
			unicode: "{U+10C15}",
			tags: ["древнетюркская енисейская буква эз", "old turkic yenisei letter ez"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* Z" },
		},
		"turkic_orkhon_elt", {
			unicode: "{U+10C21}",
			tags: ["древнетюркская орхонская буква элт", "old turkic orkhon letter elt"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">!>+ T" },
		},
		"turkic_orkhon_enc", {
			unicode: "{U+10C28}",
			tags: ["древнетюркская орхонская буква энч", "old turkic orkhon letter enc"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">+ N" },
		},
		"turkic_yenisei_enc", {
			unicode: "{U+10C29}",
			tags: ["древнетюркская енисейская буква энч", "old turkic yenisei letter enc"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>+ N" },
		},
		"turkic_orkhon_eny", {
			unicode: "{U+10C2A}",
			tags: ["древнетюркская орхонская буква энь", "old turkic orkhon letter eny"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<+ N" },
		},
		"turkic_yenisei_eny", {
			unicode: "{U+10C2B}",
			tags: ["древнетюркская енисейская буква энь", "old turkic yenisei letter eny"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<+ N" },
		},
		"turkic_orkhon_ent", {
			unicode: "{U+10C26}",
			tags: ["древнетюркская орхонская буква энт", "old turkic orkhon letter ent"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">!>+ N" },
		},
		"turkic_yenisei_ent", {
			unicode: "{U+10C27}",
			tags: ["древнетюркская енисейская буква энт", "old turkic yenisei letter ent"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>!>+ N" },
		},
		"turkic_orkhon_bash", {
			unicode: "{U+10C48}",
			tags: ["древнетюркская орхонская буква баш", "old turkic orkhon letter bash"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! R" },
		},
		"turkic_orkhon_ab", {
			unicode: "{U+10C09}",
			tags: ["древнетюркская орхонская буква аб", "old turkic orkhon letter ab"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "B" },
		},
		"turkic_yenisei_ab", {
			unicode: "{U+10C0A}",
			tags: ["древнетюркская енисейская буква аб", "old turkic yenisei letter ab"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* B" },
		},
		"turkic_orkhon_aeb", {
			unicode: "{U+10C0B}",
			tags: ["древнетюркская орхонская буква ябь", "old turkic orkhon letter aeb"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! B" },
		},
		"turkic_yenisei_aeb", {
			unicode: "{U+10C0C}",
			tags: ["древнетюркская енисейская буква ябь", "old turkic yenisei letter aeb"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! B" },
		},
		"turkic_orkhon_ad", {
			unicode: "{U+10C11}",
			tags: ["древнетюркская орхонская буква ад", "old turkic orkhon letter ad"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "D" },
		},
		"turkic_yenisei_ad", {
			unicode: "{U+10C12}",
			tags: ["древнетюркская енисейская буква ад", "old turkic yenisei letter ad"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* D" },
		},
		"turkic_orkhon_aed", {
			unicode: "{U+10C13}",
			tags: ["древнетюркская орхонская буква ядь", "old turkic orkhon letter aed"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! D" },
		},
		"turkic_orkhon_al", {
			unicode: "{U+10C1E}",
			tags: ["древнетюркская орхонская буква ал", "old turkic orkhon letter al"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "L" },
		},
		"turkic_yenisei_al", {
			unicode: "{U+10C1F}",
			tags: ["древнетюркская енисейская буква ал", "old turkic yenisei letter al"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* L" },
		},
		"turkic_orkhon_ael", {
			unicode: "{U+10C20}",
			tags: ["древнетюркская орхонская буква яль", "old turkic orkhon letter ael"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! L" },
		},
		"turkic_orkhon_an", {
			unicode: "{U+10C23}",
			tags: ["древнетюркская орхонская буква ан", "old turkic orkhon letter an"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "N" },
		},
		"turkic_orkhon_aen", {
			unicode: "{U+10C24}",
			tags: ["древнетюркская орхонская буква янь", "old turkic orkhon letter aen"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! N" },
		},
		"turkic_yenisei_aen", {
			unicode: "{U+10C25}",
			tags: ["древнетюркская енисейская буква янь", "old turkic yenisei letter aen"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! N" },
		},
		"turkic_orkhon_ar", {
			unicode: "{U+10C3A}",
			tags: ["древнетюркская орхонская буква ар", "old turkic orkhon letter ar"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "R" },
		},
		"turkic_yenisei_ar", {
			unicode: "{U+10C3B}",
			tags: ["древнетюркская енисейская буква ар", "old turkic yenisei letter ar"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* R" },
		},
		"turkic_orkhon_aer", {
			unicode: "{U+10C3C}",
			tags: ["древнетюркская орхонская буква ярь", "old turkic orkhon letter aer"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! R" },
		},
		"turkic_orkhon_as", {
			unicode: "{U+10C3D}",
			tags: ["древнетюркская орхонская буква ар", "old turkic orkhon letter as"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "S" },
		},
		"turkic_orkhon_aes", {
			unicode: "{U+10C3E}",
			tags: ["древнетюркская орхонская буква ярь", "old turkic orkhon letter aes"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! S" },
		},
		"turkic_orkhon_at", {
			unicode: "{U+10C43}",
			tags: ["древнетюркская орхонская буква ат", "old turkic orkhon letter at"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "T" },
		},
		"turkic_yenisei_at", {
			unicode: "{U+10C44}",
			tags: ["древнетюркская енисейская буква ат", "old turkic yenisei letter at"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* T" },
		},
		"turkic_orkhon_aet", {
			unicode: "{U+10C45}",
			tags: ["древнетюркская орхонская буква ять", "old turkic orkhon letter aet"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! T" },
		},
		"turkic_yenisei_aet", {
			unicode: "{U+10C46}",
			tags: ["древнетюркская енисейская буква ять", "old turkic yenisei letter aet"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! T" },
		},
		"turkic_orkhon_ay", {
			unicode: "{U+10C16}",
			tags: ["древнетюркская орхонская буква ай", "old turkic orkhon letter ay"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "Y" },
		},
		"turkic_yenisei_ay", {
			unicode: "{U+10C17}",
			tags: ["древнетюркская енисейская буква ай", "old turkic yenisei letter ay"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* Y" },
		},
		"turkic_orkhon_aey", {
			unicode: "{U+10C18}",
			tags: ["древнетюркская орхонская буква яй", "old turkic orkhon letter aey"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! Y], [J" },
		},
		"turkic_yenisei_aey", {
			unicode: "{U+10C19}",
			tags: ["древнетюркская енисейская буква яй", "old turkic yenisei letter aey"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! Y], [J" },
		},
		"turkic_orkhon_ag", {
			unicode: "{U+10C0D}",
			tags: ["древнетюркская орхонская буква агх", "old turkic orkhon letter ag"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "G" },
		},
		"turkic_yenisei_ag", {
			unicode: "{U+10C0E}",
			tags: ["древнетюркская енисейская буква агх", "old turkic yenisei letter ag"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* G" },
		},
		"turkic_orkhon_aeg", {
			unicode: "{U+10C0F}",
			tags: ["древнетюркская орхонская буква ягь", "old turkic orkhon letter aeg"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! G" },
		},
		"turkic_yenisei_aeg", {
			unicode: "{U+10C10}",
			tags: ["древнетюркская енисейская буква ягь", "old turkic yenisei letter aeg"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! G" },
		},
		"turkic_orkhon_aq", {
			unicode: "{U+10C34}",
			tags: ["древнетюркская орхонская буква акх", "old turkic orkhon letter aq"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "K" },
		},
		"turkic_yenisei_aq", {
			unicode: "{U+10C35}",
			tags: ["древнетюркская енисейская буква акх", "old turkic yenisei letter aq"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* K" },
		},
		"turkic_orkhon_aek", {
			unicode: "{U+10C1A}",
			tags: ["древнетюркская орхонская буква якь", "old turkic orkhon letter aek"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! K" },
		},
		"turkic_yenisei_aek", {
			unicode: "{U+10C1B}",
			tags: ["древнетюркская енисейская буква якь", "old turkic yenisei letter aek"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! K" },
		},
		"turkic_orkhon_oq", {
			unicode: "{U+10C38}",
			tags: ["древнетюркская орхонская буква окх", "old turkic orkhon letter oq"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "Q" },
		},
		"turkic_yenisei_oq", {
			unicode: "{U+10C39}",
			tags: ["древнетюркская енисейская буква окх", "old turkic yenisei letter oq"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* Q" },
		},
		"turkic_orkhon_oek", {
			unicode: "{U+10C1C}",
			tags: ["древнетюркская орхонская буква ёкь", "old turkic orkhon letter oek"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! Q" },
		},
		"turkic_yenisei_oek", {
			unicode: "{U+10C1D}",
			tags: ["древнетюркская енисейская буква ёкь", "old turkic yenisei letter oek"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! Q" },
		},
		"turkic_orkhon_iq", {
			unicode: "{U+10C36}",
			tags: ["древнетюркская орхонская буква ыкх", "old turkic orkhon letter iq"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! Q" },
		},
		"turkic_yenisei_iq", {
			unicode: "{U+10C37}",
			tags: ["древнетюркская енисейская буква ыкх", "old turkic yenisei letter iq"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<!  Q" },
		},
		"turkic_orkhon_ic", {
			unicode: "{U+10C31}",
			tags: ["древнетюркская орхонская буква ичь", "old turkic orkhon letter ic"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! C" },
		},
		"turkic_orkhon_ash", {
			unicode: "{U+10C3F}",
			tags: ["древнетюркская орхонская буква аш", "old turkic orkhon letter ash"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! A" },
		},
		"turkic_yenisei_ash", {
			unicode: "{U+10C40}",
			tags: ["древнетюркская енисейская буква аш", "old turkic yenisei letter ash"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<! A" },
		},
		"turkic_orkhon_op", {
			unicode: "{U+10C30}",
			tags: ["древнетюркская орхонская буква оп", "old turkic orkhon letter op"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! P" },
		},
		"turkic_orkhon_ot", {
			unicode: "{U+10C47}",
			tags: ["древнетюркская орхонская буква от", "old turkic orkhon letter ot"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! T" },
		},
		;
		;
		; * Old Permic
		;
		;
		"permic_an", {
			unicode: "{U+10350}",
			tags: ["древнепермская буква ан", "old permic letter an"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "A" },
		},
		"permic_bur", {
			unicode: "{U+10351}",
			tags: ["древнепермская буква бур", "old permic letter bur"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Б" },
		},
		"permic_gai", {
			unicode: "{U+10352}",
			tags: ["древнепермская буква гай", "old permic letter gai"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Г" },
		},
		"permic_doi", {
			unicode: "{U+10353}",
			tags: ["древнепермская буква дой", "old permic letter doi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Д" },
		},
		"permic_e", {
			unicode: "{U+10354}",
			tags: ["древнепермская буква э", "old permic letter e"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Е" },
		},
		"permic_zhoi", {
			unicode: "{U+10355}",
			tags: ["древнепермская буква жой", "old permic letter zhoi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ж" },
		},
		"permic_dzhoi", {
			unicode: "{U+10356}",
			tags: ["древнепермская буква джой", "old permic letter dzhoi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! Ж" },
		},
		"permic_zata", {
			unicode: "{U+10357}",
			tags: ["древнепермская буква зата", "old permic letter zata"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "З" },
		},
		"permic_dzita", {
			unicode: "{U+10358}",
			tags: ["древнепермская буква дзита", "old permic letter dzita"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! З" },
		},
		"permic_i", {
			unicode: "{U+10359}",
			tags: ["древнепермская буква и", "old permic letter i"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "И" },
		},
		"permic_koke", {
			unicode: "{U+1035A}",
			tags: ["древнепермская буква кокэ", "old permic letter koke"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "К" },
		},
		"permic_lei", {
			unicode: "{U+1035B}",
			tags: ["древнепермская буква лэй", "old permic letter lei"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Л" },
		},
		"permic_menoe", {
			unicode: "{U+1035C}",
			tags: ["древнепермская буква мэно", "древнепермская буква мэнӧ", "old permic letter menoe"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "М" },
		},
		"permic_nenoe", {
			unicode: "{U+1035D}",
			tags: ["древнепермская буква нэно", "древнепермская буква нэнӧ", "old permic letter nenoe"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Н" },
			alterations: { combining: "{U+10379}" },
		},
		"permic_vooi", {
			unicode: "{U+1035E}",
			tags: ["древнепермская буква вой", "древнепермская буква во̂й", "old permic letter vooi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "О" },
		},
		"permic_peei", {
			unicode: "{U+1035F}",
			tags: ["древнепермская буква пэй", "древнепермская буква пэ̂й", "old permic letter peei"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "П" },
		},
		"permic_rei", {
			unicode: "{U+10360}",
			tags: ["древнепермская буква пэй", "old permic letter rei"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Р" },
		},
		"permic_sii", {
			unicode: "{U+10361}",
			tags: ["древнепермская буква сий", "old permic letter sii"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "С" },
			alterations: { combining: "{U+1037A}" },
		},
		"permic_tai", {
			unicode: "{U+10362}",
			tags: ["древнепермская буква тай", "old permic letter tai"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Т" },
		},
		"permic_u", {
			unicode: "{U+10363}",
			tags: ["древнепермская буква у", "old permic letter u"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "У" },
		},
		"permic_chery", {
			unicode: "{U+10364}",
			tags: ["древнепермская буква чэры", "old permic letter chery"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ч" },
		},
		"permic_shooi", {
			unicode: "{U+10365}",
			tags: ["древнепермская буква шой", "древнепермская буква шо̂й", "old permic letter shooi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ш" },
		},
		"permic_shchooi", {
			unicode: "{U+10366}",
			tags: ["древнепермская буква тшой", "древнепермская буква тшо̂й", "old permic letter shchooi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Щ" },
		},
		"permic_yery", {
			unicode: "{U+10368}",
			tags: ["древнепермская буква еры", "old permic letter yery"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ы" },
		},
		"permic_yry", {
			unicode: "{U+10367}",
			tags: ["древнепермская буква ыры", "old permic letter yry"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! Ы" },
		},
		"permic_o", {
			unicode: "{U+10369}",
			tags: ["древнепермская буква о", "old permic letter o"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! О" },
		},
		"permic_oo", {
			unicode: "{U+1036A}",
			tags: ["древнепермская буква оо", "old permic letter oo"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ё" },
		},
		"permic_ef", {
			unicode: "{U+1036B}",
			tags: ["древнепермская буква эф", "old permic letter ef"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ф" },
		},
		"permic_ha", {
			unicode: "{U+1036C}",
			tags: ["древнепермская буква ха", "old permic letter ha"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Х" },
		},
		"permic_tsiu", {
			unicode: "{U+1036D}",
			tags: ["древнепермская буква цю", "old permic letter tsiu"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ц" },
		},
		"permic_ver", {
			unicode: "{U+1036E}",
			tags: ["древнепермская буква вэр", "old permic letter ver"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "В" },
		},
		"permic_yeru", {
			unicode: "{U+1036F}",
			tags: ["древнепермская буква ер", "old permic letter yeru"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ъ" },
		},
		"permic_yeri", {
			unicode: "{U+10370}",
			tags: ["древнепермская буква ери", "old permic letter yeri"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ь" },
		},
		"permic_yat", {
			unicode: "{U+10371}",
			tags: ["древнепермская буква ять", "old permic letter yat"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Э" },
		},
		"permic_ie", {
			unicode: "{U+10372}",
			tags: ["древнепермская буква йэ", "old permic letter ie"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Й" },
		},
		"permic_yu", {
			unicode: "{U+10373}",
			tags: ["древнепермская буква ю", "old permic letter yu"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ю" },
		},
		"permic_ia", {
			unicode: "{U+10375}",
			tags: ["древнепермская буква йа", "old permic letter ia"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Я" },
		},
		"permic_ya", {
			unicode: "{U+10374}",
			tags: ["древнепермская буква я", "old permic letter ya"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! Я" },
		},
		;
		;
		; * Old Hungarian
		;
		;
		"hungarian_c_let_a", {
			unicode: "{U+10C80}",
			tags: ["прописная руна А секельская", "capital rune A old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "A" },
		},
		"hungarian_s_let_a", {
			unicode: "{U+10CC0}",
			tags: ["строчная руна а секельская", "small rune a old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "a" },
		},
		"hungarian_c_let_aa", {
			unicode: "{U+10C81}",
			tags: ["прописная руна Аа секельская", "capital rune Aa old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! A" },
		},
		"hungarian_s_let_aa", {
			unicode: "{U+10CC1}",
			tags: ["строчная руна аа секельская", "small rune aa old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! a" },
		},
		"hungarian_c_let_eb", {
			unicode: "{U+10C82}",
			tags: ["прописная руна Эб секельская", "capital rune Eb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "B" },
		},
		"hungarian_s_let_eb", {
			unicode: "{U+10CC2}",
			tags: ["строчная руна эб секельская", "small rune eb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "b" },
		},
		"hungarian_c_let_ec", {
			unicode: "{U+10C84}",
			tags: ["прописная руна Эц секельская", "capital rune Ec old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "C" },
		},
		"hungarian_s_let_ec", {
			unicode: "{U+10CC4}",
			tags: ["строчная руна эц секельская", "small rune ec old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "c" },
		},
		"hungarian_c_let_ecs", {
			unicode: "{U+10C86}",
			tags: ["прописная руна Эч секельская", "capital rune Ecs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! C" },
		},
		"hungarian_s_let_ecs", {
			unicode: "{U+10CC6}",
			tags: ["строчная руна эч секельская", "small rune ecs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! c" },
		},
		"hungarian_c_let_ed", {
			unicode: "{U+10C87}",
			tags: ["прописная руна Эд секельская", "capital rune Ed old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "D" },
		},
		"hungarian_s_let_ed", {
			unicode: "{U+10CC7}",
			tags: ["строчная руна эд секельская", "small rune ed old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "d" },
		},
		"hungarian_c_let_e", {
			unicode: "{U+10C89}",
			tags: ["прописная руна Е секельская", "capital rune E old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "E" },
		},
		"hungarian_s_let_e", {
			unicode: "{U+10CC9}",
			tags: ["строчная руна е секельская", "small rune e old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "e" },
		},
		"hungarian_c_let_ee", {
			unicode: "{U+10C8B}",
			tags: ["прописная руна Ее секельская", "capital rune Ee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! E" },
		},
		"hungarian_s_let_ee", {
			unicode: "{U+10CCB}",
			tags: ["строчная руна ее секельская", "small rune ee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! e" },
		},
		"hungarian_c_let_ef", {
			unicode: "{U+10C8C}",
			tags: ["прописная руна Эф секельская", "capital rune Ef old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "F" },
		},
		"hungarian_s_let_ef", {
			unicode: "{U+10CCC}",
			tags: ["строчная руна эф секельская", "small rune ef old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "f" },
		},
		"hungarian_c_let_eg", {
			unicode: "{U+10C8D}",
			tags: ["прописная руна Эг секельская", "capital rune Eg old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "G" },
		},
		"hungarian_s_let_eg", {
			unicode: "{U+10CCD}",
			tags: ["строчная руна эг секельская", "small rune eg old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "g" },
		},
		"hungarian_c_let_egy", {
			unicode: "{U+10C8E}",
			tags: ["прописная руна Эгй секельская", "capital rune Egy old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! G" },
		},
		"hungarian_s_let_egy", {
			unicode: "{U+10CCE}",
			tags: ["строчная руна эгй секельская", "small rune egy old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! g" },
		},
		"hungarian_c_let_eh", {
			unicode: "{U+10C8F}",
			tags: ["прописная руна Эх секельская", "capital rune Eh old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "H" },
		},
		"hungarian_s_let_eh", {
			unicode: "{U+10CCF}",
			tags: ["строчная руна эх секельская", "small rune eh old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "h" },
		},
		"hungarian_c_let_i", {
			unicode: "{U+10C90}",
			tags: ["прописная руна и секельская", "capital rune I old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "I" },
		},
		"hungarian_s_let_i", {
			unicode: "{U+10CD0}",
			tags: ["строчная руна и секельская", "small rune i old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "i" },
		},
		"hungarian_c_let_ii", {
			unicode: "{U+10C91}",
			tags: ["прописная руна Ии секельская", "capital rune Ii old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! I" },
		},
		"hungarian_s_let_ii", {
			unicode: "{U+10CD1}",
			tags: ["строчная руна ии секельская", "small rune ii old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! i" },
		},
		"hungarian_c_let_ej", {
			unicode: "{U+10C92}",
			tags: ["прописная руна Эј секельская", "capital rune Ej old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "J" },
		},
		"hungarian_s_let_ej", {
			unicode: "{U+10CD2}",
			tags: ["строчная руна эј секельская", "small rune ej old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "j" },
		},
		"hungarian_c_let_ek", {
			unicode: "{U+10C93}",
			tags: ["прописная руна Эк секельская", "capital rune Ek old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "K" },
		},
		"hungarian_s_let_ek", {
			unicode: "{U+10CD3}",
			tags: ["строчная руна эк секельская", "small rune ek old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "k" },
		},
		"hungarian_c_let_ak", {
			unicode: "{U+10C94}",
			tags: ["прописная руна Ак секельская", "capital rune Ak old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! K" },
		},
		"hungarian_s_let_ak", {
			unicode: "{U+10CD4}",
			tags: ["строчная руна ак секельская", "small rune ak old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! k" },
		},
		"hungarian_c_let_el", {
			unicode: "{U+10C96}",
			tags: ["прописная руна Эл секельская", "capital rune El old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "L" },
		},
		"hungarian_s_let_el", {
			unicode: "{U+10CD6}",
			tags: ["строчная руна эл секельская", "small rune el old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "l" },
		},
		"hungarian_c_let_ely", {
			unicode: "{U+10C97}",
			tags: ["прописная руна Элй секельская", "capital rune Ely old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! L" },
		},
		"hungarian_s_let_ely", {
			unicode: "{U+10CD7}",
			tags: ["строчная руна элй секельская", "small rune ely old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! l" },
		},
		"hungarian_c_let_em", {
			unicode: "{U+10C98}",
			tags: ["прописная руна Эм секельская", "capital rune Em old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "M" },
		},
		"hungarian_s_let_em", {
			unicode: "{U+10CD8}",
			tags: ["строчная руна эм секельская", "small rune em old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "m" },
		},
		"hungarian_c_let_en", {
			unicode: "{U+10C99}",
			tags: ["прописная руна Эн секельская", "capital rune En old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "N" },
		},
		"hungarian_s_let_en", {
			unicode: "{U+10CD9}",
			tags: ["строчная руна эн секельская", "small rune en old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "n" },
		},
		"hungarian_c_let_eny", {
			unicode: "{U+10C9A}",
			tags: ["прописная руна Энй секельская", "capital rune Eny old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! N" },
		},
		"hungarian_s_let_eny", {
			unicode: "{U+10CDA}",
			tags: ["строчная руна энй секельская", "small rune eny old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! n" },
		},
		"hungarian_c_let_o", {
			unicode: "{U+10C9B}",
			tags: ["прописная руна О секельская", "capital rune O old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "O" },
		},
		"hungarian_s_let_o", {
			unicode: "{U+10CD9}",
			tags: ["строчная руна о секельская", "small rune o old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "o" },
		},
		"hungarian_c_let_oo", {
			unicode: "{U+10C9C}",
			tags: ["прописная руна Оо секельская", "capital rune Oo old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! O" },
		},
		"hungarian_s_let_oo", {
			unicode: "{U+10CDC}",
			tags: ["строчная руна оо секельская", "small rune oo old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! o" },
		},
		"hungarian_c_let_oe", {
			unicode: "{U+10C9E}",
			tags: ["прописная руна рудиментарная Ое секельская", "capital rune rudimentar Oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ O" },
		},
		"hungarian_s_let_oe", {
			unicode: "{U+10CDE}",
			tags: ["строчная руна рудиментарная ое секельская", "small rune rudimentar oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ o" },
		},
		"hungarian_c_let_oe_nik", {
			unicode: "{U+10C9D}",
			tags: ["прописная руна никольсбургская Ое секельская", "capital rune nikolsburg Oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">!<+ O" },
		},
		"hungarian_s_let_oe_nik", {
			unicode: "{U+10CDD}",
			tags: ["строчная руна никольсбургская ое секельская", "small rune nikolsburg oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">!<+ o" },
		},
		"hungarian_c_let_oee", {
			unicode: "{U+10C9F}",
			tags: ["прописная руна Оее секельская", "capital rune Oee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ O" },
		},
		"hungarian_s_let_oee", {
			unicode: "{U+10CDF}",
			tags: ["строчная руна оее секельская", "small rune oee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ o" },
		},
		"hungarian_c_let_ep", {
			unicode: "{U+10CA0}",
			tags: ["прописная руна Эп секельская", "capital rune Ep old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "P" },
		},
		"hungarian_s_let_ep", {
			unicode: "{U+10CE0}",
			tags: ["строчная руна эп секельская", "small rune ep old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "p" },
		},
		"hungarian_c_let_er", {
			unicode: "{U+10CA2}",
			tags: ["прописная руна Эр секельская", "capital rune Er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "R" },
		},
		"hungarian_s_let_er", {
			unicode: "{U+10CE2}",
			tags: ["строчная руна эр секельская", "small rune er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "r" },
		},
		"hungarian_c_let_short_er", {
			unicode: "{U+10CA3}",
			tags: ["прописная руна короткая Эр секельская", "capital rune short Er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ R" },
		},
		"hungarian_s_let_short_er", {
			unicode: "{U+10CE3}",
			tags: ["строчная руна короткая эр секельская", "small rune short er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ r" },
		},
		"hungarian_c_let_es", {
			unicode: "{U+10CA4}",
			tags: ["прописная руна Эщ секельская", "capital rune Es old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "S" },
		},
		"hungarian_s_let_es", {
			unicode: "{U+10CE4}",
			tags: ["строчная руна эщ секельская", "small rune es old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "s" },
		},
		"hungarian_c_let_esz", {
			unicode: "{U+10CA5}",
			tags: ["прописная руна Эс секельская", "capital rune Esz old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! S" },
		},
		"hungarian_s_let_esz", {
			unicode: "{U+10CE5}",
			tags: ["строчная руна эс секельская", "small rune esz old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! s" },
		},
		"hungarian_c_let_et", {
			unicode: "{U+10CA6}",
			tags: ["прописная руна Эт секельская", "capital rune Et old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "T" },
		},
		"hungarian_s_let_et", {
			unicode: "{U+10CE6}",
			tags: ["строчная руна эт секельская", "small rune et old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "t" },
		},
		"hungarian_c_let_ety", {
			unicode: "{U+10CA8}",
			tags: ["прописная руна Этй секельская", "capital rune Ety old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! T" },
		},
		"hungarian_s_let_ety", {
			unicode: "{U+10CE8}",
			tags: ["строчная руна этй секельская", "small rune ety old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! t" },
		},
		"hungarian_c_let_u", {
			unicode: "{U+10CAA}",
			tags: ["прописная руна У секельская", "capital rune U old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "U" },
		},
		"hungarian_s_let_u", {
			unicode: "{U+10CEA}",
			tags: ["строчная руна у секельская", "small rune u old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "u" },
		},
		"hungarian_c_let_uu", {
			unicode: "{U+10CAB}",
			tags: ["прописная руна Уу секельская", "capital rune Uu old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! U" },
		},
		"hungarian_s_let_uu", {
			unicode: "{U+10CEB}",
			tags: ["строчная руна уу секельская", "small rune uu old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! u" },
		},
		"hungarian_c_let_ue", {
			unicode: "{U+10CAD}",
			tags: ["прописная руна рудиментарная Уе секельская", "capital rune rudimentar Ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "Y" },
		},
		"hungarian_s_let_ue", {
			unicode: "{U+10CED}",
			tags: ["строчная руна рудиментарная Уе секельская", "small rune rudimentar ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "y" },
		},
		"hungarian_c_let_ue_nik", {
			unicode: "{U+10CAC}",
			tags: ["прописная руна никольсбургская Уе секельская", "capital rune nikolsburg Ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! Y" },
		},
		"hungarian_s_let_ue_nik", {
			unicode: "{U+10CEC}",
			tags: ["строчная руна никольсбургская Уе секельская", "small rune nikolsburg ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! y" },
		},
		"hungarian_c_let_ev", {
			unicode: "{U+10CAE}",
			tags: ["прописная руна Эв секельская", "capital rune Ev old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "V" },
		},
		"hungarian_s_let_ev", {
			unicode: "{U+10CEE}",
			tags: ["строчная руна эв секельская", "small rune ev old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "v" },
		},
		"hungarian_c_let_ez", {
			unicode: "{U+10CAF}",
			tags: ["прописная руна Эз секельская", "capital rune Ez old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "Z" },
		},
		"hungarian_s_let_ez", {
			unicode: "{U+10CEF}",
			tags: ["строчная руна эз секельская", "small rune ez old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "z" },
		},
		"hungarian_c_let_ezs", {
			unicode: "{U+10CB0}",
			tags: ["прописная руна Эж секельская", "capital rune Ezs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! Z" },
		},
		"hungarian_s_let_ezs", {
			unicode: "{U+10CF0}",
			tags: ["строчная руна эж секельская", "small rune ezs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! z" },
		},
		"hungarian_c_let_ent", {
			unicode: "{U+10CA7}",
			tags: ["прописная руна Энт секельская", "capital rune Ent old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ T" },
		},
		"hungarian_s_let_ent", {
			unicode: "{U+10CE7}",
			tags: ["строчная руна энт секельская", "small rune ent old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ t" },
		},
		"hungarian_c_let_ent_shaped", {
			unicode: "{U+10CB1}",
			tags: ["прописная руна Энт-подобный знак секельский", "capital rune Ent-shaped sign old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ T" },
		},
		"hungarian_s_let_ent_shaped", {
			unicode: "{U+10CF1}",
			tags: ["строчная руна энт-подобный знак секельский", "small rune ent-shaped sign old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ t" },
		},
		"hungarian_c_let_emp", {
			unicode: "{U+10CA1}",
			tags: ["прописная руна Эмп секельская", "capital rune Emp old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ P" },
		},
		"hungarian_s_let_emp", {
			unicode: "{U+10CE1}",
			tags: ["строчная руна эмп секельская", "small rune emp old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ p" },
		},
		"hungarian_c_let_unk", {
			unicode: "{U+10C95}",
			tags: ["прописная руна Унк секельская", "capital rune Unk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ K" },
		},
		"hungarian_s_let_unk", {
			unicode: "{U+10CD5}",
			tags: ["строчная руна унк секельская", "small rune unk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ k" },
		},
		"hungarian_c_let_us", {
			unicode: "{U+10CB2}",
			tags: ["прописная руна Ус секельская", "capital rune Us old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ S" },
		},
		"hungarian_s_let_us", {
			unicode: "{U+10CF2}",
			tags: ["строчная руна ус секельская", "small rune us old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ s" },
		},
		"hungarian_c_let_amb", {
			unicode: "{U+10C83}",
			tags: ["прописная руна Амб секельская", "capital rune Amb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ B" },
		},
		"hungarian_s_let_amb", {
			unicode: "{U+10CC3}",
			tags: ["строчная руна амб секельская", "small rune amb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ b" },
		},
		"hungarian_c_let_enk", {
			unicode: "{U+10C85}",
			tags: ["прописная руна Энк секельская", "capital rune Enk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ E" },
		},
		"hungarian_s_let_enk", {
			unicode: "{U+10CC5}",
			tags: ["строчная руна энк секельская", "small rune enk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ e" },
		},
		"hungarian_c_let_ech", {
			unicode: "{U+10CA9}",
			tags: ["прописная руна Эч секельская", "capital rune Ech old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ C" },
		},
		"hungarian_s_let_ech", {
			unicode: "{U+10CE9}",
			tags: ["строчная руна эч секельская", "small rune ech old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ c" },
		},
		"hungarian_num_one", {
			unicode: "{U+10CFA}",
			tags: ["цифра 1 секельская", "number 1 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "1" },
		},
		"hungarian_num_five", {
			unicode: "{U+10CFB}",
			tags: ["цифра 5 секельская", "number 5 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "2" },
		},
		"hungarian_num_ten", {
			unicode: "{U+10CFC}",
			tags: ["цифра 10 секельская", "number 10 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "3" },
		},
		"hungarian_num_fifty", {
			unicode: "{U+10CFD}",
			tags: ["цифра 50 секельская", "number 50 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "4" },
		},
		"hungarian_num_one_hundred", {
			unicode: "{U+10CFE}",
			tags: ["цифра 100 секельская", "number 100 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "5" },
		},
		"hungarian_num_one_thousand", {
			unicode: "{U+10CFF}",
			tags: ["цифра 1000 секельская", "number 1000 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "6" },
		},
		;
		;
		; * Gothic
		;
		;
		"gothic_ahza", {
			unicode: "{U+10330}",
			tags: ["готская буква аза", "gothic letter ahsa"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "A" },
		},
		"gothic_bairkan", {
			unicode: "{U+10331}",
			tags: ["готская буква беркна", "gothic letter bairkan", "gothic letter baírkan"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "B" },
		},
		"gothic_giba", {
			unicode: "{U+10332}",
			tags: ["готская буква гиба", "gothic letter giba"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "G" },
		},
		"gothic_dags", {
			unicode: "{U+10333}",
			tags: ["готская буква дааз", "gothic letter dags"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "D" },
		},
		"gothic_aihvus", {
			unicode: "{U+10334}",
			tags: ["готская буква эзй", "gothic letter aihvus", "gothic letter eíƕs"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "E" },
		},
		"gothic_qairthra", {
			unicode: "{U+10335}",
			tags: ["готская буква квертра", "gothic letter qairthra", "gothic letter qaírþra"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "Q" },
		},
		"gothic_ezek", {
			unicode: "{U+10336}",
			tags: ["готская буква эзек", "gothic letter ezek"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "Z" },
		},
		"gothic_hagl", {
			unicode: "{U+10337}",
			tags: ["готская буква хаал", "gothic letter hagl"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "H" },
		},
		"gothic_thiuth", {
			unicode: "{U+10338}",
			tags: ["готская буква сюс", "gothic letter thiuth", "gothic letter þiuþ"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: ">! T], [C" },
		},
		"gothic_eis", {
			unicode: "{U+10339}",
			tags: ["готская буква ииз", "gothic letter eis"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "I" },
		},
		"gothic_kusma", {
			unicode: "{U+1033A}",
			tags: ["готская буква козма", "gothic letter kusma"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "K" },
		},
		"gothic_lagus", {
			unicode: "{U+1033B}",
			tags: ["готская буква лааз", "gothic letter lagus"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "L" },
		},
		"gothic_manna", {
			unicode: "{U+1033C}",
			tags: ["готская буква манна", "gothic letter manna"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "M" },
		},
		"gothic_nauths", {
			unicode: "{U+1033D}",
			tags: ["готская буква нойкз", "gothic letter nauths", "gothic letter nauþs"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "N" },
		},
		"gothic_jer", {
			unicode: "{U+1033E}",
			tags: ["готская буква гаар", "gothic letter jer", "gothic letter jēr"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "J" },
		},
		"gothic_urus", {
			unicode: "{U+1033F}",
			tags: ["готская буква ураз", "gothic letter urus", "gothic letter ūrus"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "U" },
		},
		"gothic_pairthra", {
			unicode: "{U+10340}",
			tags: ["готская буква пертра", "gothic letter pairthra", "gothic letter ūrus"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "P" },
		},
		"gothic_ninety", {
			unicode: "{U+10341}",
			tags: ["готская буква-число 90", "gothic letter ninety"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: ">! P" },
		},
		"gothic_raida", {
			unicode: "{U+10342}",
			tags: ["готская буква райда", "gothic letter raida"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "R" },
		},
		"gothic_sugil", {
			unicode: "{U+10343}",
			tags: ["готская буква сугил", "gothic letter sugil"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "S" },
		},
		"gothic_teiws", {
			unicode: "{U+10344}",
			tags: ["готская буква тюз", "gothic letter teiws"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "T" },
		},
		"gothic_winja", {
			unicode: "{U+10345}",
			tags: ["готская буква винья", "gothic letter winja"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "W], [Y" },
		},
		"gothic_faihu", {
			unicode: "{U+10346}",
			tags: ["готская буква файху", "gothic letter faihu"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "F" },
		},
		"gothic_iggws", {
			unicode: "{U+10347}",
			tags: ["готская буква энкуз", "gothic letter iggws"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "X" },
		},
		"gothic_hwair", {
			unicode: "{U+10348}",
			tags: ["готская буква хвайр", "gothic letter hwair", "gothic letter ƕaír"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: ">! H], [V" },
		},
		"gothic_othal", {
			unicode: "{U+10349}",
			tags: ["готская буква отал", "gothic letter othal", "gothic letter ōþal"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "O" },
		},
		"gothic_nine_hundred", {
			unicode: "{U+1034A}",
			tags: ["готская буква-число 900", "gothic letter nine hundred"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: ">! S" },
		},
		;
		;
		; * Old Italic
		;
		;
		"italic_let_a", {
			unicode: "{U+10300}",
			tags: ["древнеиталийская буква А", "old italic letter A"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "A" },
		},
		"italic_let_be", {
			unicode: "{U+10301}",
			tags: ["древнеиталийская буква Бе", "old italic letter Be"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "B" },
		},
		"italic_let_ke", {
			unicode: "{U+10302}",
			tags: ["древнеиталийская буква Ке", "old italic letter Ke"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "C" },
		},
		"italic_let_che", {
			unicode: "{U+1031C}",
			tags: ["древнеиталийская буква Че", "old italic letter Che"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ C" },
		},
		"italic_let_de", {
			unicode: "{U+10303}",
			tags: ["древнеиталийская буква Де", "old italic letter De"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "D" },
		},
		"italic_let_e", {
			unicode: "{U+10304}",
			tags: ["древнеиталийская буква Е", "old italic letter E"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "E" },
		},
		"italic_let_ye", {
			unicode: "{U+1032D}",
			tags: ["древнеиталийская буква Йе", "old italic letter Ye"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "Y" },
		},
		"italic_let_ve", {
			unicode: "{U+10305}",
			tags: ["древнеиталийская буква Ве", "old italic letter Ve"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "F" },
		},
		"italic_let_ef", {
			unicode: "{U+1031A}",
			tags: ["древнеиталийская буква Эф", "old italic letter Ef"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ F" },
		},
		"italic_let_ze", {
			unicode: "{U+10306}",
			tags: ["древнеиталийская буква Зе", "old italic letter Ze"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "Z" },
		},
		"italic_let_he", {
			unicode: "{U+10307}",
			tags: ["древнеиталийская буква Хе", "old italic letter He"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "H" },
		},
		"italic_let_i", {
			unicode: "{U+10309}",
			tags: ["древнеиталийская буква И", "old italic letter I"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "I" },
		},
		"italic_let_ii", {
			unicode: "{U+1031D}",
			tags: ["древнеиталийская буква Ии", "old italic letter Ii"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ I" },
		},
		"italic_let_ka", {
			unicode: "{U+1030A}",
			tags: ["древнеиталийская буква Ка", "old italic letter Ka"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "K" },
		},
		"italic_let_khe", {
			unicode: "{U+10319}",
			tags: ["древнеиталийская буква Кхе", "old italic letter Khe"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ K" },
		},
		"italic_let_el", {
			unicode: "{U+1030B}",
			tags: ["древнеиталийская буква Эль", "old italic letter El"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "L" },
		},
		"italic_let_em", {
			unicode: "{U+1030C}",
			tags: ["древнеиталийская буква Эм", "old italic letter Em"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "M" },
		},
		"italic_let_en", {
			unicode: "{U+1030D}",
			tags: ["древнеиталийская буква Эн", "old italic letter En"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "N" },
		},
		"italic_let_o", {
			unicode: "{U+1030F}",
			tags: ["древнеиталийская буква О", "old italic letter O"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "O" },
		},
		"italic_let_pe", {
			unicode: "{U+10310}",
			tags: ["древнеиталийская буква Пе", "old italic letter Pe"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "P" },
		},
		"italic_let_phe", {
			unicode: "{U+10318}",
			tags: ["древнеиталийская буква Пхе", "old italic letter Phe"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ P" },
		},
		"italic_let_ku", {
			unicode: "{U+10312}",
			tags: ["древнеиталийская буква Ку", "old italic letter Ku"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "Q" },
		},
		"italic_let_er", {
			unicode: "{U+10313}",
			tags: ["древнеиталийская буква Эр", "old italic letter Er"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "R" },
		},
		"italic_let_ers", {
			unicode: "{U+1031B}",
			tags: ["древнеиталийская буква Эрс", "old italic letter Ers"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ R" },
		},
		"italic_let_es", {
			unicode: "{U+10314}",
			tags: ["древнеиталийская буква Эс", "old italic letter Es"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "S" },
		},
		"italic_let_esh", {
			unicode: "{U+1030E}",
			tags: ["древнеиталийская буква Эш", "old italic letter Esh"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ S" },
		},
		"italic_let_she", {
			unicode: "{U+10311}",
			tags: ["древнеиталийская буква Ше", "old italic letter She"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "<+ S" },
		},
		"italic_let_ess", {
			unicode: "{U+1031F}",
			tags: ["древнеиталийская буква Эсс", "old italic letter Ess"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "<! S" },
		},
		"italic_let_te", {
			unicode: "{U+10315}",
			tags: ["древнеиталийская буква Те", "old italic letter Te"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "T" },
		},
		"italic_let_the", {
			unicode: "{U+10308}",
			tags: ["древнеиталийская буква Зэ", "old italic letter The"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ T" },
		},
		"italic_let_u", {
			unicode: "{U+10316}",
			tags: ["древнеиталийская буква У", "old italic letter U"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "U" },
		},
		"italic_let_uu", {
			unicode: "{U+1031E}",
			tags: ["древнеиталийская буква Уу", "old italic letter Uu"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ U" },
		},
		"italic_let_eks", {
			unicode: "{U+10317}",
			tags: ["древнеиталийская буква Экс", "old italic letter Eks"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "X" },
		},
		"italic_let_northern_tse", {
			unicode: "{U+1032E}",
			tags: ["древнеиталийская буква Северная Це", "old italic letter Northern Tse"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "W" },
		},
		"italic_let_southern_tse", {
			unicode: "{U+1032F}",
			tags: ["древнеиталийская буква Южная Це", "old italic letter Southern Tse"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "<+ W" },
		},
		"italic_let_numeral_one", {
			unicode: "{U+10320}",
			tags: ["древнеиталийская числовая буква один", "old italic numeral letter one"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 1" },
		},
		"italic_let_numeral_five", {
			unicode: "{U+10321}",
			tags: ["древнеиталийская числовая буква пять", "old italic numeral letter five"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 2" },
		},
		"italic_let_numeral_ten", {
			unicode: "{U+10322}",
			tags: ["древнеиталийская числовая буква десять", "old italic numeral letter ten"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 3" },
		},
		"italic_let_numeral_fifty", {
			unicode: "{U+10323}",
			tags: ["древнеиталийская числовая буква пятьдесят", "old italic numeral letter fifty"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 4" },
		},
		;
		;
		; * Phoenician
		;
		;
		"phoenician_let_alef", {
			unicode: "{U+10900}",
			tags: ["финикийская буква Алеф", "phoenician letter Alef"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "A" },
		},
		"phoenician_let_ain", {
			unicode: "{U+1090F}",
			tags: ["финикийская буква Аин", "phoenician letter Ain"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "<+ A], [O" },
		},
		"phoenician_let_bet", {
			unicode: "{U+10901}",
			tags: ["финикийская буква Бет", "phoenician letter Bet"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "B" },
		},
		"phoenician_let_gaml", {
			unicode: "{U+10902}",
			tags: ["финикийская буква Гамл", "phoenician letter Gaml"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "G" },
		},
		"phoenician_let_delt", {
			unicode: "{U+10903}",
			tags: ["финикийская буква Делт", "phoenician letter Delt"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "D" },
		},
		"phoenician_let_he", {
			unicode: "{U+10904}",
			tags: ["финикийская буква Хе", "phoenician letter He"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "H" },
		},
		"phoenician_let_het", {
			unicode: "{U+10907}",
			tags: ["финикийская буква Хет", "phoenician letter Het"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">+ H" },
		},
		"phoenician_let_wau", {
			unicode: "{U+10905}",
			tags: ["финикийская буква Вав", "phoenician letter Wau"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "W" },
		},
		"phoenician_let_zai", {
			unicode: "{U+10906}",
			tags: ["финикийская буква Зен", "phoenician letter Zai"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "Z" },
		},
		"phoenician_let_yod", {
			unicode: "{U+10909}",
			tags: ["финикийская буква Йуд", "phoenician letter Yod"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "J], [Y" },
		},
		"phoenician_let_kaf", {
			unicode: "{U+1090A}",
			tags: ["финикийская буква Каф", "phoenician letter Kaf"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "K" },
		},
		"phoenician_let_lamd", {
			unicode: "{U+1090B}",
			tags: ["финикийская буква Ламд", "phoenician letter Lamd"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "L" },
		},
		"phoenician_let_mem", {
			unicode: "{U+1090C}",
			tags: ["финикийская буква Мем", "phoenician letter Mem"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "M" },
		},
		"phoenician_let_nun", {
			unicode: "{U+1090D}",
			tags: ["финикийская буква Нун", "phoenician letter Nun"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "N" },
		},
		"phoenician_let_semk", {
			unicode: "{U+1090E}",
			tags: ["финикийская буква Семк", "phoenician letter Semk"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "S" },
		},
		"phoenician_let_shin", {
			unicode: "{U+10914}",
			tags: ["финикийская буква Шин", "phoenician letter Shin"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">+ S" },
		},
		"phoenician_let_pe", {
			unicode: "{U+10910}",
			tags: ["финикийская буква Пе", "phoenician letter Pe"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "P" },
		},
		"phoenician_let_sade", {
			unicode: "{U+10911}",
			tags: ["финикийская буква Цади", "phoenician letter Sade"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "C" },
		},
		"phoenician_let_qof", {
			unicode: "{U+10912}",
			tags: ["финикийская буква Куф", "phoenician letter Qof"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "Q" },
		},
		"phoenician_let_rosh", {
			unicode: "{U+10913}",
			tags: ["финикийская буква Рош", "phoenician letter Rosh"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "R" },
		},
		"phoenician_let_tau", {
			unicode: "{U+10915}",
			tags: ["финикийская буква Тав", "phoenician letter Tau"],
			groups: ["Phoenician"],
			options: { altLayoutKey: "T" },
		},
		"phoenician_let_tet", {
			unicode: "{U+10908}",
			tags: ["финикийская буква Тет", "phoenician letter Tet"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">+ T" },
		},
		"phoenician_let_numeral_one", {
			unicode: "{U+10916}",
			tags: ["финикийская числовая буква один", "phoenician numeral letter one"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! 1" },
		},
		"phoenician_let_numeral_two", {
			unicode: "{U+1091A}",
			tags: ["финикийская числовая буква два", "phoenician numeral letter two"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! 2" },
		},
		"phoenician_let_numeral_three", {
			unicode: "{U+1091B}",
			tags: ["финикийская числовая буква три", "phoenician numeral letter three"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! 3" },
		},
		"phoenician_let_numeral_ten", {
			unicode: "{U+10917}",
			tags: ["финикийская числовая буква десять", "phoenician numeral letter ten"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! 4" },
		},
		"phoenician_let_numeral_twenty", {
			unicode: "{U+10918}",
			tags: ["финикийская числовая буква двадцать", "phoenician numeral letter twenty"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! 5" },
		},
		"phoenician_let_numeral_hundred", {
			unicode: "{U+10919}",
			tags: ["финикийская числовая буква сто", "phoenician numeral letter one hundred"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! 6" },
		},
		"phoenician_word_separator", {
			unicode: "{U+1091F}",
			tags: ["финикийская разделитель слов", "phoenician word separator"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! Space" },
		},
		;
		;
		; * Ancient South Arabian
		;
		;
		"south_arabian_let_he", {
			unicode: "{U+10A60}",
			tags: ["южноаравийская буква Хе", "south arabian letter He"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "H" },
		},
		"south_arabian_let_lamedh", {
			unicode: "{U+10A61}",
			tags: ["южноаравийская буква Ламед", "south arabian letter Lamedh"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "L" },
		},
		"south_arabian_let_heth", {
			unicode: "{U+10A62}",
			tags: ["южноаравийская буква Хет", "south arabian letter Heth"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">+ H" },
		},
		"south_arabian_let_mem", {
			unicode: "{U+10A63}",
			tags: ["южноаравийская буква Мем", "south arabian letter Mem"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "M" },
		},
		"south_arabian_let_qoph", {
			unicode: "{U+10A64}",
			tags: ["южноаравийская буква Куф", "south arabian letter Qoph"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "Q" },
		},
		"south_arabian_let_waw", {
			unicode: "{U+10A65}",
			tags: ["южноаравийская буква Уав", "south arabian letter Waw"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "W" },
		},
		"south_arabian_let_shin", {
			unicode: "{U+10A66}",
			tags: ["южноаравийская буква Шин", "south arabian letter Shin"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">+ S" },
		},
		"south_arabian_let_resh", {
			unicode: "{U+10A67}",
			tags: ["южноаравийская буква Реш", "south arabian letter Resh"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "R" },
		},
		"south_arabian_let_beth", {
			unicode: "{U+10A68}",
			tags: ["южноаравийская буква Бет", "south arabian letter Beth"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "B" },
		},
		"south_arabian_let_taw", {
			unicode: "{U+10A69}",
			tags: ["южноаравийская буква Тау", "south arabian letter Taw"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "T" },
		},
		"south_arabian_let_sat", {
			unicode: "{U+10A6A}",
			tags: ["южноаравийская буква Сат", "south arabian letter Sat"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "S" },
		},
		"south_arabian_let_kaph", {
			unicode: "{U+10A6B}",
			tags: ["южноаравийская буква Каф", "south arabian letter Kaph"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "K" },
		},
		"south_arabian_let_nun", {
			unicode: "{U+10A6C}",
			tags: ["южноаравийская буква Нун", "south arabian letter Nun"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "N" },
		},
		"south_arabian_let_kheth", {
			unicode: "{U+10A6D}",
			tags: ["южноаравийская буква Хеф", "south arabian letter Kheth"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! H], [X" },
		},
		"south_arabian_let_sadhe", {
			unicode: "{U+10A6E}",
			tags: ["южноаравийская буква Садхе", "south arabian letter Sadhe"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! S" },
		},
		"south_arabian_let_samekh", {
			unicode: "{U+10A6F}",
			tags: ["южноаравийская буква Самек", "south arabian letter Samekh"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "<+ S" },
		},
		"south_arabian_let_fe", {
			unicode: "{U+10A70}",
			tags: ["южноаравийская буква Фе", "south arabian letter Fe"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "F" },
		},
		"south_arabian_let_alef", {
			unicode: "{U+10A71}",
			tags: ["южноаравийская буква Алеф", "south arabian letter Alef"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "A" },
		},
		"south_arabian_let_ayn", {
			unicode: "{U+10A72}",
			tags: ["южноаравийская буква Аин", "south arabian letter Ayn"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! A" },
		},
		"south_arabian_let_dhadhe", {
			unicode: "{U+10A73}",
			tags: ["южноаравийская буква Дадхе", "south arabian letter Dhadhe"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! D" },
		},
		"south_arabian_let_gimel", {
			unicode: "{U+10A74}",
			tags: ["южноаравийская буква Гимель", "south arabian letter Gimel"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "G" },
		},
		"south_arabian_let_daleth", {
			unicode: "{U+10A75}",
			tags: ["южноаравийская буква Далет", "south arabian letter Daleth"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "D" },
		},
		"south_arabian_let_ghayn", {
			unicode: "{U+10A76}",
			tags: ["южноаравийская буква Гаин", "south arabian letter Ghayn"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "Y" },
		},
		"south_arabian_let_teth", {
			unicode: "{U+10A77}",
			tags: ["южноаравийская буква Тет", "south arabian letter Teth"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! T" },
		},
		"south_arabian_let_zayn", {
			unicode: "{U+10A78}",
			tags: ["южноаравийская буква Зайн", "south arabian letter Zayn"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "Z" },
		},
		"south_arabian_let_dhaleth", {
			unicode: "{U+10A79}",
			tags: ["южноаравийская буква Дхалет", "south arabian letter Dhaleth"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">!>+ D" },
		},
		"south_arabian_let_yodh", {
			unicode: "{U+10A7A}",
			tags: ["южноаравийская буква Йод", "south arabian letter Yodh"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "J" },
		},
		"south_arabian_let_thaw", {
			unicode: "{U+10A7B}",
			tags: ["южноаравийская буква Тав", "south arabian letter Thaw"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">!>+ T" },
		},
		"south_arabian_let_theth", {
			unicode: "{U+10A7C}",
			tags: ["южноаравийская буква Тхет", "south arabian letter Theth"],
			groups: ["South Arabian"],
			options: { altLayoutKey: "<+ T" },
		},
		"south_arabian_let_numeral_one", {
			unicode: "{U+10A7D}",
			tags: ["южноаравийская числовая буква один", "south arabian numeral letter one"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! 1" },
		},
		"south_arabian_let_numeral_fifty", {
			unicode: "{U+10A7E}",
			tags: ["южноаравийская числовая буква пятьдесят", "south arabian numeral letter fifty"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! 5" },
		},
		"south_arabian_let_numeral_bracket", {
			unicode: "{U+10A7F}",
			tags: ["южноаравийская числовая скобка", "south arabian numeral bracket"],
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! 0" },
		},
		;
		;
		; * Ancient North Arabian
		;
		;
		"north_arabian_let_heh", {
			unicode: "{U+10A80}",
			tags: ["североаравийская буква Хе", "old north arabian letter Heh"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "H" },
		},
		"north_arabian_let_lam", {
			unicode: "{U+10A81}",
			tags: ["североаравийская буква Лам", "old north arabian letter Lam"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "L" },
		},
		"north_arabian_let_hah", {
			unicode: "{U+10A82}",
			tags: ["североаравийская буква Хах", "old north arabian letter Hah"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! H" },
		},
		"north_arabian_let_meem", {
			unicode: "{U+10A83}",
			tags: ["североаравийская буква Мим", "old north arabian letter Meem"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "M" },
		},
		"north_arabian_let_qaf", {
			unicode: "{U+10A84}",
			tags: ["североаравийская буква Каф", "old north arabian letter Qaf"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "Q" },
		},
		"north_arabian_let_waw", {
			unicode: "{U+10A85}",
			tags: ["североаравийская буква Вав", "old north arabian letter Waw"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "W" },
		},
		"north_arabian_let_es_2", {
			unicode: "{U+10A86}",
			tags: ["североаравийская буква Эс-2", "old north arabian letter Es-2"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">+ S" },
		},
		"north_arabian_let_reh", {
			unicode: "{U+10A87}",
			tags: ["североаравийская буква Рех", "old north arabian letter Reh"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "R" },
		},
		"north_arabian_let_beh", {
			unicode: "{U+10A88}",
			tags: ["североаравийская буква Бех", "old north arabian letter Beh"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "B" },
		},
		"north_arabian_let_teh", {
			unicode: "{U+10A89}",
			tags: ["североаравийская буква Тех", "old north arabian letter Teh"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "T" },
		},
		"north_arabian_let_es_1", {
			unicode: "{U+10A8A}",
			tags: ["североаравийская буква Эс-1", "old north arabian letter Es-1"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "S" },
		},
		"north_arabian_let_kaf", {
			unicode: "{U+10A8B}",
			tags: ["североаравийская буква Каф", "old north arabian letter Kaf"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "K" },
		},
		"north_arabian_let_noon", {
			unicode: "{U+10A8C}",
			tags: ["североаравийская буква Нун", "old north arabian letter Noon"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "N" },
		},
		"north_arabian_let_khah", {
			unicode: "{U+10A8D}",
			tags: ["североаравийская буква Хах", "old north arabian letter Khah"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">+ H" },
		},
		"north_arabian_let_sad", {
			unicode: "{U+10A8E}",
			tags: ["североаравийская буква Сад", "old north arabian letter Sad"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! S" },
		},
		"north_arabian_let_es_3", {
			unicode: "{U+10A8F}",
			tags: ["североаравийская буква Эс-3", "old north arabian letter Es-3"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "<+ S" },
		},
		"north_arabian_let_feh", {
			unicode: "{U+10A90}",
			tags: ["североаравийская буква Фех", "old north arabian letter Feh"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "F" },
		},
		"north_arabian_let_alef", {
			unicode: "{U+10A91}",
			tags: ["североаравийская буква Алеф", "old north arabian letter Alef"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "A" },
		},
		"north_arabian_let_ain", {
			unicode: "{U+10A92}",
			tags: ["североаравийская буква Айн", "old north arabian letter Ain"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! A" },
		},
		"north_arabian_let_dad", {
			unicode: "{U+10A93}",
			tags: ["североаравийская буква Дад", "old north arabian letter Dad"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! D" },
		},
		"north_arabian_let_geem", {
			unicode: "{U+10A94}",
			tags: ["североаравийская буква Джим", "old north arabian letter Geem"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "G" },
		},
		"north_arabian_let_dal", {
			unicode: "{U+10A95}",
			tags: ["североаравийская буква Даль", "old north arabian letter Dal"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "D" },
		},
		"north_arabian_let_ghain", {
			unicode: "{U+10A96}",
			tags: ["североаравийская буква Гайн", "old north arabian letter Ghain"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "Y" },
		},
		"north_arabian_let_tah", {
			unicode: "{U+10A97}",
			tags: ["североаравийская буква Тах", "old north arabian letter Tah"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! T" },
		},
		"north_arabian_let_zain", {
			unicode: "{U+10A98}",
			tags: ["североаравийская буква Зайн", "old north arabian letter Zain"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "Z" },
		},
		"north_arabian_let_thal", {
			unicode: "{U+10A99}",
			tags: ["североаравийская буква Заль", "old north arabian letter Thal"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">!>+ D" },
		},
		"north_arabian_let_yeh", {
			unicode: "{U+10A9A}",
			tags: ["североаравийская буква Йех", "old north arabian letter Yeh"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "J" },
		},
		"north_arabian_let_theh", {
			unicode: "{U+10A9B}",
			tags: ["североаравийская буква Тех", "old north arabian letter Theh"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">!>+ T" },
		},
		"north_arabian_let_zah", {
			unicode: "{U+10A9C}",
			tags: ["североаравийская буква Зах", "old north arabian letter Zah"],
			groups: ["North Arabian"],
			options: { altLayoutKey: "<+ Z" },
		},
		"north_arabian_num_one", {
			unicode: "{U+10A9D}",
			tags: ["североаравийская числовая буква один", "old north arabian number one"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! 1" },
		},
		"north_arabian_num_ten", {
			unicode: "{U+10A9E}",
			tags: ["североаравийская числовая буква десять", "old north arabian number ten"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! 2" },
		},
		"north_arabian_num_twenty", {
			unicode: "{U+10A9F}",
			tags: ["североаравийская числовая буква двадцать", "old north arabian number twenty"],
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! 3" },
		},
		;
		;
		; * Sidetic Script ; Finish when Unicode 17 releases on September 9th
		;
		;
		"sidetic_let_n01", {
			unicode: "{U+10940}",
			tags: ["сидетская буква а", "sidetic letter a"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "A" },
		},
		"sidetic_let_n02_e", {
			unicode: "{U+10941}",
			tags: ["сидетская буква е", "sidetic letter e"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "E" },
		},
		"sidetic_let_n03_i", {
			unicode: "{U+10942}",
			tags: ["сидетская буква и", "sidetic letter i"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "I" },
		},
		"sidetic_let_n04_o", {
			unicode: "{U+10943}",
			tags: ["сидетская буква о", "sidetic letter o"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "O" },
		},
		"sidetic_let_n05_u", {
			unicode: "{U+10944}",
			tags: ["сидетская буква у", "sidetic letter u"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "U" },
		},
		"sidetic_let_n06_v", {
			unicode: "{U+10945}",
			tags: ["сидетская буква в", "sidetic letter v"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "V" },
		},
		"sidetic_let_n07_j", {
			unicode: "{U+10946}",
			tags: ["сидетская буква й", "sidetic letter j"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "J" },
		},
		"sidetic_let_n08_p", {
			unicode: "{U+10947}",
			tags: ["сидетская буква п", "sidetic letter p"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "P" },
		},
		"sidetic_let_n09_ts", {
			unicode: "{U+10948}",
			tags: ["сидетская буква тс", "sidetic letter ts"],
			groups: ["Sidetic"],
			options: { altLayoutKey: ">! T" },
		},
		"sidetic_let_n10_m", {
			unicode: "{U+10949}",
			tags: ["сидетская буква м", "sidetic letter m"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "M" },
		},
		"sidetic_let_n11_t", {
			unicode: "{U+1094A}",
			tags: ["сидетская буква т", "sidetic letter t"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "T" },
		},
		"sidetic_let_n12_d", {
			unicode: "{U+1094B}",
			tags: ["сидетская буква д", "sidetic letter d"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "D" },
		},
		"sidetic_let_n13_th", {
			unicode: "{U+1094C}",
			tags: ["сидетская буква тх", "sidetic letter th"],
			groups: ["Sidetic"],
			options: { altLayoutKey: ">!>+ T" },
		},
		"sidetic_let_n14_z", {
			unicode: "{U+1094D}",
			tags: ["сидетская буква з", "sidetic letter z"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "Z" },
		},
		"sidetic_let_n15_s", {
			unicode: "{U+1094E}",
			tags: ["сидетская буква с", "sidetic letter s"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "S" },
		},
		"sidetic_let_n16_n", {
			unicode: "{U+1094F}",
			tags: ["сидетская буква н", "sidetic letter n"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "N" },
		},
		"sidetic_let_n17_l", {
			unicode: "{U+10950}",
			tags: ["сидетская буква л", "sidetic letter l"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "L" },
		},
		"sidetic_let_n18_tsh", {
			unicode: "{U+10951}",
			tags: ["сидетская буква тш", "sidetic letter tsh"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "C" },
		},
		"sidetic_let_n19_g", {
			unicode: "{U+10952}",
			tags: ["сидетская буква г", "sidetic letter g"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "G" },
		},
		"sidetic_let_n20_khi", {
			unicode: "{U+10953}",
			tags: ["сидетская буква кхи", "sidetic letter khi"],
			groups: ["Sidetic"],
			options: { altLayoutKey: ">! K" },
		},
		"sidetic_let_n21_r", {
			unicode: "{U+10954}",
			tags: ["сидетская буква р", "sidetic letter r"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "R" },
		},
		"sidetic_let_n22", {
			unicode: "{U+10955}",
			groups: ["Sidetic"],
		},
		"sidetic_let_n22_k", {
			unicode: "{U+10956}",
			tags: ["сидетская буква к", "sidetic letter k"],
			groups: ["Sidetic"],
			options: { altLayoutKey: "K" },
		},
		"sidetic_let_n23_nj", {
			unicode: "{U+10957}",
			tags: ["сидетская буква нй", "sidetic letter nj"],
			groups: ["Sidetic"],
			options: { altLayoutKey: ">! N" },
		},
		"sidetic_let_n25_dzh", {
			unicode: "{U+10958}",
			tags: ["сидетская буква дж", "sidetic letter dzh"],
			groups: ["Sidetic"],
			options: { altLayoutKey: ">! J" },
		},
		"sidetic_let_n26_dz", {
			unicode: "{U+10959}",
			tags: ["сидетская буква дз", "sidetic letter dz"],
			groups: ["Sidetic"],
			options: { altLayoutKey: ">! Z" },
		},
		"sidetic_let_n27", {
			unicode: "{U+1095A}",
			groups: ["Sidetic"],
		},
		"sidetic_let_n28", {
			unicode: "{U+1095B}",
			groups: ["Sidetic"],
		},
		"sidetic_let_n29", {
			unicode: "{U+1095C}",
			groups: ["Sidetic"],
		},
		;
		;
		; * Ugaritic Script
		;
		;
		"ugaritic_let_alpa", {
			unicode: "{U+10380}",
			tags: ["угаритская буква альпа", "ugaritic letter alpa"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "A" },
		},
		"ugaritic_let_beta", {
			unicode: "{U+10381}",
			tags: ["угаритская буква бета", "ugaritic letter beta"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "B" },
		},
		"ugaritic_let_gamla", {
			unicode: "{U+10382}",
			tags: ["угаритская буква гамла", "ugaritic letter gamla"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "G" },
		},
		"ugaritic_let_kha", {
			unicode: "{U+10383}",
			tags: ["угаритская буква ха", "ugaritic letter kha"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">! H" },
		},
		"ugaritic_let_delta", {
			unicode: "{U+10384}",
			tags: ["угаритская буква дельта", "ugaritic letter delta"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "D" },
		},
		"ugaritic_let_ho", {
			unicode: "{U+10385}",
			tags: ["угаритская буква хо", "ugaritic letter ho"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "H" },
		},
		"ugaritic_let_wo", {
			unicode: "{U+10386}",
			tags: ["угаритская буква во", "ugaritic letter wo"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "W" },
		},
		"ugaritic_let_zeta", {
			unicode: "{U+10387}",
			tags: ["угаритская буква зета", "ugaritic letter zeta"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "Z" },
		},
		"ugaritic_let_hota", {
			unicode: "{U+10388}",
			tags: ["угаритская буква хота", "ugaritic letter hota"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">!>+ H" },
		},
		"ugaritic_let_tet", {
			unicode: "{U+10389}",
			tags: ["угаритская буква тет", "ugaritic letter tet"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">!>+ T" },
		},
		"ugaritic_let_yod", {
			unicode: "{U+1038A}",
			tags: ["угаритская буква йод", "ugaritic letter yod"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "Y" },
		},
		"ugaritic_let_kaf", {
			unicode: "{U+1038B}",
			tags: ["угаритская буква каф", "ugaritic letter kaf"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "K" },
		},
		"ugaritic_let_shin", {
			unicode: "{U+1038C}",
			tags: ["угаритская буква шин", "ugaritic letter shin"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "S" },
		},
		"ugaritic_let_lamda", {
			unicode: "{U+1038D}",
			tags: ["угаритская буква ламда", "ugaritic letter lamda"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "L" },
		},
		"ugaritic_let_mem", {
			unicode: "{U+1038E}",
			tags: ["угаритская буква мем", "ugaritic letter mem"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "M" },
		},
		"ugaritic_let_dhal", {
			unicode: "{U+1038F}",
			tags: ["угаритская буква дхал", "ugaritic letter dhal"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">! D" },
		},
		"ugaritic_let_nun", {
			unicode: "{U+10390}",
			tags: ["угаритская буква нун", "ugaritic letter nun"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "N" },
		},
		"ugaritic_let_zu", {
			unicode: "{U+10391}",
			tags: ["угаритская буква зу", "ugaritic letter zu"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">!>+ Z" },
		},
		"ugaritic_let_samka", {
			unicode: "{U+10392}",
			tags: ["угаритская буква самка", "ugaritic letter samka"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "<+ S" },
		},
		"ugaritic_let_ain", {
			unicode: "{U+10393}",
			tags: ["угаритская буква айн", "ugaritic letter ain"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">! A" },
		},
		"ugaritic_let_pu", {
			unicode: "{U+10394}",
			tags: ["угаритская буква пу", "ugaritic letter pu"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "P" },
		},
		"ugaritic_let_sade", {
			unicode: "{U+10395}",
			tags: ["угаритская буква цаде", "ugaritic letter sade"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">! S" },
		},
		"ugaritic_let_qopa", {
			unicode: "{U+10396}",
			tags: ["угаритская буква копа", "ugaritic letter qopa"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "Q" },
		},
		"ugaritic_let_rasha", {
			unicode: "{U+10397}",
			tags: ["угаритская буква раша", "ugaritic letter rasha"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "R" },
		},
		"ugaritic_let_thanna", {
			unicode: "{U+10398}",
			tags: ["угаритская буква танна", "ugaritic letter thanna"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">!>+ S" },
		},
		"ugaritic_let_ghain", {
			unicode: "{U+10399}",
			tags: ["угаритская буква гайн", "ugaritic letter ghain"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: ">! G" },
		},
		"ugaritic_let_to", {
			unicode: "{U+1039A}",
			tags: ["угаритская буква то", "ugaritic letter to"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "T" },
		},
		"ugaritic_let_i", {
			unicode: "{U+1039B}",
			tags: ["угаритская буква и", "ugaritic letter i"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "I" },
		},
		"ugaritic_let_u", {
			unicode: "{U+1039C}",
			tags: ["угаритская буква у", "ugaritic letter u"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "U" },
		},
		"ugaritic_let_ssu", {
			unicode: "{U+1039D}",
			tags: ["угаритская буква ссу", "ugaritic letter ssu"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "<+ U" },
		},
		"ugaritic_word_divider", {
			unicode: "{U+1039F}",
			tags: ["угаритский разделитель слов", "ugaritic word divider"],
			groups: ["Ugaritic"],
			options: { altLayoutKey: "Space" },
		},
		;
		;
		; * Wallet Signs
		;
		;
		"wallet_sign", {
			unicode: "{U+00A4}",
			tags: ["знак валюты", "currency sign"],
			groups: ["Wallet Signs"],
			recipe: ["XO"],
		},
		"wallet_austral", {
			unicode: "{U+20B3}",
			tags: ["аустраль", "austral"],
			groups: ["Wallet Signs"],
			recipe: ["A=", "ARA"],
		},
		"wallet_cent", {
			unicode: "{U+00A2}",
			tags: ["цент", "cent"],
			groups: ["Wallet Signs"],
			recipe: ["c|", "CNT"],
		},
		"wallet_cedi", {
			unicode: "{U+20B5}",
			tags: ["седи", "cedi"],
			groups: ["Wallet Signs"],
			recipe: ["C|", "GHS", "CED"],
		},
		"wallet_colon", {
			unicode: "{U+20A1}",
			tags: ["колон", "colon"],
			groups: ["Wallet Signs"],
			recipe: ["C//", "CRC", "SVC"],
		},
		"wallet_dollar", {
			unicode: "{U+0024}",
			alterations: { small: "{U+FE69}" },
			tags: ["доллар", "dollar"],
			groups: ["Wallet Signs"],
			recipe: ["S|", "USD", "DLR"],
		},
		"wallet_dram", {
			unicode: "{U+058F}",
			tags: ["драм", "dram"],
			groups: ["Wallet Signs"],
			recipe: ["AMD", "DRM"],
		},
		"wallet_doromi", {
			unicode: "{U+07FE}",
			tags: ["дороми", "doromi"],
			groups: ["Wallet Signs"],
			recipe: ["DOR"],
		},
		"wallet_eur", {
			unicode: "{U+20AC}",
			tags: ["евро", "euro"],
			groups: ["Wallet Signs"],
			recipe: ["C=", "EUR"],
		},
		"wallet_franc", {
			unicode: "{U+20A3}",
			tags: ["франк", "franc"],
			groups: ["Wallet Signs"],
			recipe: ["F=", "FRF"],
		},
		"wallet_guarani", {
			unicode: "{U+20B2}",
			tags: ["гуарани", "guarani"],
			groups: ["Wallet Signs"],
			recipe: ["G/", "PYG", "GNF"],
		},
		"wallet_kip", {
			unicode: "{U+20AD}",
			tags: ["кип", "kip"],
			groups: ["Wallet Signs"],
			recipe: ["K-", "LAK", "KIP"],
		},
		"wallet_lari", {
			unicode: "{U+20BE}",
			tags: ["лари", "lari"],
			groups: ["Wallet Signs"],
			recipe: ["GEL", "LAR"],
		},
		"wallet_naira", {
			unicode: "{U+20A6}",
			tags: ["наира", "naira"],
			groups: ["Wallet Signs"],
			recipe: ["N=", "NGN", "NAR"],
		},
		"wallet_pound", {
			unicode: "{U+00A3}",
			tags: ["фунт", "pound"],
			groups: ["Wallet Signs"],
			recipe: ["f_", "GBP"],
		},
		"wallet_tournois", {
			unicode: "{U+20B6}",
			tags: ["турский ливр", "tournois"],
			groups: ["Wallet Signs"],
			recipe: ["lt", "LTF"],
		},
		"wallet_rub", {
			unicode: "{U+20BD}",
			tags: ["рубль", "ruble"],
			groups: ["Wallet Signs"],
			recipe: ["Р=", "RUB", "РУБ"],
		},
		"wallet_hryvnia", {
			unicode: "{U+20B4}",
			tags: ["гривна", "hryvnia"],
			groups: ["Wallet Signs"],
			recipe: ["S=", "UAH", "ГРН"],
		},
		"wallet_lira", {
			unicode: "{U+20A4}",
			tags: ["лира", "lira"],
			groups: ["Wallet Signs"],
			recipe: ["f=", "LIR"],
		},
		"wallet_turkish_lira", {
			unicode: "{U+20BA}",
			tags: ["лира", "lira"],
			groups: ["Wallet Signs"],
			recipe: ["L=", "TRY"],
		},
		"wallet_rupee", {
			unicode: "{U+20B9}",
			tags: ["рупия", "rupee"],
			groups: ["Wallet Signs"],
			recipe: ["R=", "INR", "RUP"],
		},
		"wallet_won", {
			unicode: "{U+20A9}",
			tags: ["вон", "won"],
			groups: ["Wallet Signs"],
			recipe: ["W=", "WON", "KRW"],
		},
		"wallet_yen", {
			unicode: "{U+00A5}",
			tags: ["знак йены", "yen sign"],
			groups: ["Wallet Signs"],
			recipe: ["Y=", "YEN"],
		},
		"wallet_jpy_yen", {
			unicode: "{U+5186}",
			tags: ["йена", "yen"],
			groups: ["Wallet Signs"],
			recipe: ["JPY"],
		},
		"wallet_cny_yuan", {
			unicode: "{U+5143}",
			tags: ["юань", "yuan"],
			groups: ["Wallet Signs"],
			recipe: ["CNY"],
		},
		"wallet_viet_dong", {
			unicode: "{U+20AB}",
			tags: ["вьетнамский донг", "vietnamese dong"],
			groups: ["Wallet Signs"],
			recipe: [
				"d${(stroke_short|macron_below)}$(*)",
				"${lat_s_let_d__(stroke_short|line_below)}$(*)",
				"VND", "DNG"
			],
		},
		"wallet_mongol_tugrik", {
			unicode: "{U+20AE}",
			tags: ["монгольский тугрик", "mongolian tugrik"],
			groups: ["Wallet Signs"],
			recipe: ["T//", "MNT", "TGK"],
		},
		"wallet_qazaq_tenge", {
			unicode: "{U+20B8}",
			tags: ["казахский тенге", "kazakh tenge"],
			groups: ["Wallet Signs"],
			recipe: ["T=", "KZT", "TNG"],
		},
		"wallet_new_sheqel", {
			unicode: "{U+20AA}",
			tags: ["новый шекель", "new sheqel"],
			groups: ["Wallet Signs"],
			recipe: ["NZD", "SHQ"],
		},
		"wallet_philippine_peso", {
			unicode: "{U+20B1}",
			tags: ["филиппинский песо", "philippine peso"],
			groups: ["Wallet Signs"],
			recipe: ["P=", "PHP"],
		},
		"wallet_roman_[denarius,quinarius,sestertius,dupondius,as]", {
			unicode: ["{U+10196}", "{U+10197}", "{U+10198}", "{U+10199}", "{U+1019A}"],
			tags: [
				["римский денарий", "roman denarius"],
				["римский квинарий", "roman quinarius"],
				["римский сестерций", "roman sestertius"],
				["римский дупондий", "roman dupondius"],
				["римский асс", "roman as"],
			],
			groups: ["Wallet Signs"],
			recipe: [
				["X-", "DIN"],
				["V-", "QIN"],
				["H-S", "SES"],
				["I-I", "DUP"],
				["/-", "ASE"],
			],
		},
		"wallet_bitcoin", {
			unicode: "{U+20BF}",
			tags: ["биткоин", "bitcoin"],
			groups: ["Wallet Signs"],
			recipe: ["B||", "BTC"],
		},
		;
		;
		; * Extra Symbolistics
		;
		;
		"symbolistics_rod_of_asclepius", {
			unicode: "{U+2695}",
			tags: ["rod of Asclepius", "посох Асклепия"],
			groups: ["Extra Symbolistics"],
			recipe: ["ascl", "аскл"],
		},
		"symbolistics_caduceus", {
			unicode: "{U+2624}",
			tags: ["Caduceus", "Кадуцей"],
			groups: ["Extra Symbolistics"],
			recipe: ["cadu", "каду"],
		},
		"symbolistics_staff_of_hermes", {
			unicode: "{U+269A}",
			tags: ["staff of Hermes", "посох Гермеса"],
			groups: ["Extra Symbolistics"],
			recipe: ["herms", "гермс"],
		},
		"symbolistics_ankh", {
			unicode: "{U+2625}",
			tags: ["Ankh", "Анх"],
			groups: ["Extra Symbolistics"],
			recipe: ["ankh", "анх"],
		},
		;
		;
		; * Alchemical
		;
		;
		"alchemical_element_air", {
			unicode: "{U+1F701}",
			tags: ["alchemical air", "алхимический воздух"],
			groups: ["Alchemical"],
			recipe: ["alc air"],
		},
		"alchemical_element_fire", {
			unicode: "{U+1F702}",
			tags: ["alchemical fire", "алхимический огонь"],
			groups: ["Alchemical"],
			recipe: ["alc fire"],
		},
		"alchemical_element_earth", {
			unicode: "{U+1F703}",
			tags: ["alchemical earth", "алхимическая земля"],
			groups: ["Alchemical"],
			recipe: ["alc earth"],
		},
		"alchemical_element_water", {
			unicode: "{U+1F704}",
			tags: ["alchemical water", "алхимическая вода"],
			groups: ["Alchemical"],
			recipe: ["alc water"],
		},
		"alchemical_acid_nitric", {
			unicode: "{U+1F705}",
			tags: ["alchemical nitric acid", "alchemical aqua fortis", "алхимическая азотная кислота"],
			groups: ["Alchemical"],
			recipe: ["${alchemical_element_water}F", "alc nitric acid", "alc aqua fortis"],
		},
		"alchemical_acid_nitrohydrochloric", {
			unicode: "{U+1F706}",
			tags: ["alchemical nitrohydrochloric acid", "alchemical aqua regia", "алхимическая царская водка"],
			groups: ["Alchemical"],
			recipe: ["${alchemical_element_water}R", "alc aqua regia"],
		},
		"alchemical_acid_vinegar", {
			unicode: "{U+1F70A}",
			tags: ["alchemical acetic acid", "alchemical vinegar", "алхимическая уксусная кислота"],
			groups: ["Alchemical"],
			recipe: ["alc acetic acid", "alc vinegar"],
		},
		"alchemical_acid_vinegar_distilled_1", {
			unicode: "{U+1F70B}",
			tags: ["alchemical distilled acetic acid-1", "alchemical distilled vinegar-1", "алхимическая дистилированная уксусная кислота-1"],
			groups: ["Alchemical"],
			recipe: [":${alchemical_acid_vinegar}:", "alc dis vinegar-1"],
		},
		"alchemical_acid_vinegar_distilled_2", {
			unicode: "{U+1F70C}",
			tags: ["alchemical distilled acetic acid-2", "alchemical distilled vinegar-2", "алхимическая дистилированная уксусная кислота-2"],
			groups: ["Alchemical"],
			recipe: [":I:", "alc dis vinegar-2"],
		},
		"alchemical_sand_bath", {
			unicode: "{U+1F707}",
			tags: ["alchemical sand bath", "alchemical aqua regia-2", "алхимическая песчаная баня", "алхимическая царская водка-2"],
			groups: ["Alchemical"],
			recipe: ["AR", "alc sand bath"],
		},
		"alchemical_ethanol_1", {
			unicode: "{U+1F708}",
			tags: ["alchemical ethanol-1", "alchemical aqua vitae-1", "алхимический этанол-1"],
			groups: ["Alchemical"],
			recipe: ["alc ethanol-1"],
		},
		"alchemical_ethanol_2", {
			unicode: "{U+1F709}",
			tags: ["alchemical ethanol-2", "alchemical aqua vitae-2", "алхимический этанол-2"],
			groups: ["Alchemical"],
			recipe: ["alc ethanol-2"],
		},
		"alchemical_brimstone", {
			unicode: "{U+1F70D}",
			tags: ["alchemical brimstone", "alchemical sulfur", "alchemical sulphur", "алхимическая сера"],
			groups: ["Alchemical"],
			recipe: ["${alchemical_element_fire}${dagger}", "alc sulfur"],
		},
		"alchemical_brimstone_philosophers", {
			unicode: "{U+1F70E}",
			tags: ["alchemical philosophers brimstone", "alchemical philosophers sulfur", "alchemical philosophers sulphur", "алхимическая философская сера"],
			groups: ["Alchemical"],
			recipe: ["alc phi sulfur"],
		},
		"alchemical_brimstone_black", {
			unicode: "{U+1F70F}",
			tags: ["alchemical black brimstone", "alchemical black sulfur", "alchemical black sulphur", "алхимическая чёрная сера"],
			groups: ["Alchemical"],
			recipe: ["alc black sulfur"],
		},
		"alchemical_salt", {
			unicode: "{U+1F714}",
			tags: ["alchemical salt", "archaic astrological Earth", "алхимическая соль", "архаичное астрологическая Земля"],
			groups: ["Alchemical"],
			recipe: ["alc salt", "astrol arc Earth"],
		},
		"alchemical_potassium_nitrate", {
			unicode: "{U+1F715}",
			tags: ["alchemical potassium nitrate", "alchemical nitre", "алхимический нитрат калия"],
			groups: ["Alchemical"],
			recipe: ["alc nitre"],
		},
		"alchemical_vitriol_1", {
			unicode: "{U+1F716}",
			tags: ["alchemical metal sulfate-1", "alchemical vitriol-1", "алхимический сульфат металла-1"],
			groups: ["Alchemical"],
			recipe: ["alc vitriol-1"],
		},
		"alchemical_vitriol_2", {
			unicode: "{U+1F717}",
			tags: ["alchemical metal sulfate-2", "alchemical vitriol-2", "алхимический сульфат металла-2"],
			groups: ["Alchemical"],
			recipe: ["alc vitriol-2"],
		},
		"alchemical_rock_salt_1", {
			unicode: "{U+1F718}",
			tags: ["alchemical rock salt-1", "alchemical bismuth", "алхимическая каменная соль-1", "алхимический висмут"],
			groups: ["Alchemical"],
			recipe: ["alc rock salt-1", "alc bismuth"],
		},
		"alchemical_rock_salt_2", {
			unicode: "{U+1F719}",
			tags: ["alchemical rock salt-2", "алхимическая каменная соль-2"],
			groups: ["Alchemical"],
			recipe: ["alc rock salt-2"],
		},
		"alchemical_gold", {
			unicode: "{U+1F71A}",
			tags: ["alchemical gold", "алхимическое золото"],
			groups: ["Alchemical"],
			recipe: ["alc gold"],
		},
		"alchemical_silver", {
			unicode: "{U+1F71B}",
			tags: ["alchemical silver", "алхимическое серебро"],
			groups: ["Alchemical"],
			recipe: ["alc silver"],
		},
		"alchemical_iron_ore_1", {
			unicode: "{U+1F71C}",
			tags: ["alchemical iron ore-1", "алхимическая железая руда-1"],
			groups: ["Alchemical"],
			recipe: ["alc iron ore-1"],
		},
		"alchemical_iron_ore_2", {
			unicode: "{U+1F71D}",
			tags: ["alchemical iron ore-2", "алхимическая железая руда-2"],
			groups: ["Alchemical"],
			recipe: ["alc iron ore-2"],
		},
		"alchemical_copper_ore", {
			unicode: "{U+1F720}",
			tags: ["alchemical copper ore", "алхимическая медная руда"],
			groups: ["Alchemical"],
			recipe: ["alc cop ore"],
		},
		"alchemical_iron_copper_ore", {
			unicode: "{U+1F721}",
			tags: ["alchemical iron-copper ore", "алхимическая медно-железная руда"],
			groups: ["Alchemical"],
			recipe: ["alc iron cop ore"],
		},
		"alchemical_crocus_of_iron", {
			unicode: "{U+1F71E}",
			tags: ["alchemical crocus of iron", "алхимический крокус железа"],
			groups: ["Alchemical"],
			recipe: ["alc iron croc"],
		},
		"alchemical_regulus_of_iron", {
			unicode: "{U+1F71F}",
			tags: ["alchemical regulus of iron", "алхимический регулус железа"],
			groups: ["Alchemical"],
			recipe: ["alc iron regu"],
		},
		;
		;
		; * Astrology
		;
		;
		"astrological_earth", {
			unicode: "{U+1F728}",
			tags: ["alchemical copper acetate", "alchemical aes viride", "astrological Earth", "алхимический ацетат меди", "астрологическая Земля"],
			groups: ["Astrology"],
			recipe: ["astrol Earth", "alc cop acetate"],
		},
		"astrological_neptune", {
			unicode: "{U+2646}",
			tags: ["astrological Neptune", "астрологический Нептун"],
			groups: ["Astrology"],
			recipe: ["astrol Neptune"],
		},
		"astrological_uranus", {
			unicode: "{U+2645}",
			tags: ["astrological Uranus", "астрологический Уран"],
			groups: ["Astrology"],
			recipe: ["astrol Uranus"],
		},
		"astrological_pluto_1", {
			unicode: "{U+2647}",
			tags: ["astrological Pluto-1", "астрологическая Плутон-1"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-1"],
		},
		"astrological_pluto_2", {
			unicode: "{U+2BD3}",
			tags: ["astrological Pluto-2", "астрологическая Плутон-2"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-2"],
		},
		"astrological_pluto_3", {
			unicode: "{U+2BD4}",
			tags: ["astrological Pluto-3", "астрологическая Плутон-3"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-3"],
		},
		"astrological_pluto_4", {
			unicode: "{U+2BD5}",
			tags: ["astrological Pluto-4", "астрологическая Плутон-4"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-4"],
		},
		"astrological_pluto_5", {
			unicode: "{U+2BD6}",
			tags: ["astrological Pluto-5", "астрологическая Плутон-5"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-5"],
		},
		"astrological_transpluto", {
			unicode: "{U+2BD7}",
			tags: ["astrological Transpluto", "астрологическая Трансплутон"],
			groups: ["Astrology"],
			recipe: ["astrol Transpluto"],
		},
		"astrological_vesta", {
			unicode: "{U+26B6}",
			tags: ["astrological Vesta", "астрологическая Веста"],
			groups: ["Astrology"],
			recipe: ["astrol Vesta"],
		},
		"astrological_chiron", {
			unicode: "{U+26B7}",
			tags: ["astrological Chiron", "астрологическая Хирон"],
			groups: ["Astrology"],
			recipe: ["astrol Chiron"],
		},
		"astrological_proserpina", {
			unicode: "{U+2BD8}",
			tags: ["astrological Proserpina", "астрологическая Прозерпина"],
			groups: ["Astrology"],
			recipe: ["astrol Proserpina"],
		},
		"astrological_astraea", {
			unicode: "{U+2BD9}",
			tags: ["astrological Astraea", "астрологическая Астрея"],
			groups: ["Astrology"],
			recipe: ["astrol Astraea"],
		},
		"astrological_hygiea", {
			unicode: "{U+2BDA}",
			tags: ["astrological Hygiea", "астрологическая Гигея"],
			groups: ["Astrology"],
			recipe: ["astrol Hygiea"],
		},
		"astrological_pholus", {
			unicode: "{U+2BDB}",
			tags: ["astrological Pholus", "астрологическая Фол"],
			groups: ["Astrology"],
			recipe: ["astrol Pholus"],
		},
		"astrological_nessus", {
			unicode: "{U+2BDC}",
			tags: ["astrological Nessus", "астрологическая Несс"],
			groups: ["Astrology"],
			recipe: ["astrol Nessus"],
		},
		;
		;
		; * Astronomy
		;
		;
		"astronomical_earth", {
			unicode: "{U+2641}",
			tags: ["alchemical antimony trisulfide", "alchemical stibnite", "astronomical Earth", "алхимический стибнит", "алхимический сульфид сурьмы", "астрономическая Земля"],
			groups: ["Astronomy"],
			recipe: ["astron Earth", "alc stibnite"],
		},
		"astronomical_neptune", {
			unicode: "{U+2BC9}",
			tags: ["astronomical Neptune", "астрономический Нептун"],
			groups: ["Astrology"],
			recipe: ["astron Neptune"],
		},
		"astronomical_uranus", {
			unicode: "{U+26E2}",
			tags: ["astronomical Uranus", "астрономический Уран"],
			groups: ["Astronomy"],
			recipe: ["astron Uranus"],
		},
		;
		;
		; * Other Special Symbols
		;
		;
		"copyright", {
			unicode: "{U+00A9}",
			tags: ["копирайт", "copyright"],
			groups: ["Other Signs"],
			options: { fastKey: "2" },
			recipe: ["copy", "cri"],
		},
		"copyleft", {
			unicode: "{U+1F12F}",
			tags: ["копилефт", "copyleft"],
			groups: ["Other Signs"],
			recipe: ["cft"],
		},
		"registered", {
			unicode: "{U+00AE}",
			tags: ["зарегистрированный", "registered"],
			groups: ["Other Signs"],
			options: { fastKey: "c* 2", send: "Text" },
			recipe: ["reg"],
		},
		"trademark", {
			unicode: "{U+2122}",
			tags: ["торговый знак", "trademark"],
			groups: ["Other Signs"],
			options: { fastKey: "<+ 2" },
			recipe: ["TM", "tm"],
		},
		"servicemark", {
			unicode: "{U+2120}",
			tags: ["знак обслуживания", "servicemark"],
			groups: ["Other Signs"],
			options: { fastKey: "c*<+ 2" },
			recipe: ["SM", "sm"],
		},
		"sound_recording_copyright", {
			unicode: "{U+2117}",
			tags: ["копирайт фонограммы", "sound recording copyright"],
			groups: ["Other Signs"],
			options: { fastKey: ">+ 2" },
			recipe: ["Pcopy"],
		},
		"misc_crlf_emspace", {
			unicode: (*) => ChrLib.GetValue("carriage_return", "unicode"),
			sequence: [(*) => ChrLib.GetValue("carriage_return", "unicode"), (*) => ChrLib.GetValue("new_line", "unicode"), (*) => ChrLib.GetValue("emsp", "unicode")],
			groups: ["Misc"],
			options: { noCalc: True, fastKey: "Enter" }
		},
		"misc_lf_emspace", {
			unicode: (*) => ChrLib.GetValue("new_line", "unicode"),
			sequence: [(*) => ChrLib.GetValue("new_line", "unicode"), (*) => ChrLib.GetValue("emsp", "unicode")],
			groups: ["Misc"],
			options: { noCalc: True, fastKey: "<+ Enter" }
		},
		"ipa_a-z", { unicode: "{U+0061}", sequence: ["{U+0061}", "{U+0062}", "{U+0063}", "{U+0064}", "{U+0065}", "{U+0066}", "{U+0067}", "{U+0068}", "{U+0069}", "{U+006A}", "{U+006B}", "{U+006C}", "{U+006D}", "{U+006E}", "{U+006F}", "{U+0070}", "{U+0071}", "{U+0072}", "{U+0073}", "{U+0074}", "{U+0075}", "{U+0076}", "{U+0077}", "{U+0078}", "{U+0079}", "{U+007A}"], groups: ["IPA"], options: { noCalc: True, altLayoutKey: "<+ a-z" } },
		"ipa_a-z_cap", { unicode: "{U+0041}", sequence: ["{U+0041}", "{U+0042}", "{U+0043}", "{U+0044}", "{U+0045}", "{U+0046}", "{U+0047}", "{U+0048}", "{U+0049}", "{U+004A}", "{U+004B}", "{U+004C}", "{U+004D}", "{U+004E}", "{U+004F}", "{U+0050}", "{U+0051}", "{U+0052}", "{U+0053}", "{U+0054}", "{U+0055}", "{U+0056}", "{U+0057}", "{U+0058}", "{U+0059}", "{U+005A}"], groups: ["IPA"], options: { noCalc: True, altLayoutKey: "c*<+ a-z" } },
		"ipa_combining_mode", { unicode: "{U+0041}", sequence: ["{U+25CC}", "{U+0363}", "{U+25CC}", "{U+1DE8}", "{U+25CC}", "{U+0369}", "{U+25CC}", "{U+1DF1}"], groups: ["IPA"], options: { noCalc: True, altLayoutKey: "RAlt F2" } },
		"ipa_modifiers_mode", { unicode: "{U+0041}", sequence: ["{U+02B0}", "{U+02B1}", "{U+02B2}", "{U+02B3}", "{U+02B7}", "{U+02B8}"], groups: ["IPA"], options: { noCalc: True, altLayoutKey: "RAlt F3" } },
		"ipa_subscript_mode", { unicode: "{U+0041}", sequence: ["{U+2090}", "{U+2091}", "{U+2095}", "{U+2C7C}", "{U+2096}", "{U+2097}"], groups: ["IPA"], options: { noCalc: True, altLayoutKey: "RAlt RShift F3" } },
		;
		;
		; * Etc.
		;
		;
		"replacment_character", {
			titles: Map("ru", "Заменяющий символ", "en", "Replacement character"),
			unicode: "{U+FFFD}",
			options: { noCalc: True },
			recipe: ["null"]
		},
		"object_replacement_character", {
			titles: Map("ru", "Объекто-заменяющий символ", "en", "Object replacement character"),
			unicode: "{U+FFFC}",
			options: { noCalc: True },
			recipe: ["obj"]
		},
		"amogus", {
			titles: Map("ru", "Амогус", "en", "Amogus"),
			tags: ["амогус", "член экипажа", "amogus", "crewmate"],
			unicode: "{U+0D9E}",
			options: { noCalc: True, suggestionsAtEnd: True },
			recipe: ["sus", "сус"],
		}
	]

	Loop 256 {
		index := A_Index

		if (index <= 16) {
			unicodeValue := Format("FE{:02X}", index - 1)
		} else {
			offset := index - 17
			unicodeValue := Format("E01{:02X}", offset)
		}

		rawEntries.Push(
			"variantion_selector_" index, {
				titles: Map("ru", "Селектор варианта " index, "en", "Variation selector " index),
				unicode: "{U+" unicodeValue "}",
				options: { noCalc: True, suggestionsAtEnd: True },
				recipe: ["vs" index],
				symbol: { alt: "<VARIATION SELECTOR-" index ">" }
			}
		)
	}

	Loop 5 {
		index := A_Index
		unicodeValue := Format("{:X}", 0x1F3FA + index)

		if index > 1
			index++

		rawEntries.Push(
			"emoji_modifier_fitzpatrick_" index, {
				titles: Map("ru", "Модификатор Фицпатрика " index, "en", "Emoji Modifier Fitzpatrick " index),
				unicode: "{U+" unicodeValue "}",
				options: { noCalc: True, suggestionsAtEnd: True },
				recipe: ["ftz" index],
				symbol: { alt: "<EMOJI MODIFIER FITZPATRICK TYPE-" (index = 1 ? "1-2" : index) ">" }
			}
		)
	}

	emoji_hairs := Map(
		1, ["red_hair", "rh"],
		2, ["curly_hair", "ch"],
		3, ["bald", "ba"],
		4, ["white_hair", "wh"],
	)

	Loop 4 {
		index := A_Index
		unicodeValue := Format("{:X}", 0x1F9AF + index)
		entryPost := emoji_hairs[index][1]
		title := StrReplace(Util.StrUpper(entryPost, 1), "_", " ")

		rawEntries.Push(
			"emoji_component_" entryPost, {
				titles: Map("ru", "Компонент эмодзи " title, "en", "Emoji Component " title),
				unicode: "{U+" unicodeValue "}",
				options: { noCalc: True, suggestionsAtEnd: True },
				recipe: ["ecmp " emoji_hairs[index][2], "ecmp " StrReplace(entryPost, "_", " ")],
				symbol: { alt: "<EMOJI COMPONENT " StrUpper(title) ">" }
			}
		)
	}


	this.AddEntries(rawEntries)

	if this.duplicatesList.Length > 0
		TrayTip(Locale.ReadInject("warning_duplicate_recipe", [this.duplicatesList.ToString()]), App.Title("+status+version"), "Icon! Mute")
}