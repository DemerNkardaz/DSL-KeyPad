/*
	* < CHARACTER LIBRARY >
	* Entry variants:
	* Single Entry: "name",							{ ... }
	* Bulk Entry:		"[name,name,name]", { [..., ..., ...] }
*/
LibRegistrate(this) {
	local D := "dotted_circle"
	rawEntries := [
		;
		;
		; * Diacritics
		;
		;
		"acute", {
			unicode: "0301",
			tags: ["acute", "акут", "ударение"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			alterations: { uncombined: "00B4", modifier: "02CA" },
			options: { fastKey: "A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"acute_double", {
			unicode: "030B",
			tags: ["double acute", "двойной акут", "двойное ударение"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			alterations: { uncombined: "02DD", modifier: "02F6" },
			options: { fastKey: "<+ A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"acute_below", {
			unicode: "0317",
			tags: ["acute below", "акут снизу"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: ">+ A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"acute_tone_vietnamese", {
			unicode: "0341",
			tags: ["acute tone", "акут тона"],
			groups: [],
			options: {},
			symbol: { category: "Diacritic Mark" },
		},
		"asterisk_above", {
			unicode: "20F0",
			tags: ["asterisk above", "астериск сверху"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"asterisk_below", {
			unicode: "0359",
			tags: ["asterisk below", "астериск снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "<+ A Ф" },
			symbol: { category: "Diacritic Mark" },
		},
		"breve", {
			unicode: "0306", LaTeX: ["\u", "\breve"],
			tags: ["breve", "бреве", "кратка"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			alterations: { uncombined: "02D8" },
			options: { fastKey: "B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"breve_inverted", {
			unicode: "0311",
			tags: ["inverted breve", "перевёрнутое бреве", "перевёрнутая кратка"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"breve_below", {
			unicode: "032E",
			tags: ["breve below", "бреве снизу", "кратка снизу"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: ">+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"breve_inverted_below", {
			unicode: "032F",
			tags: ["inverted breve below", "перевёрнутое бреве снизу", "перевёрнутая кратка снизу"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: "<+>+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"bridge_above", {
			unicode: "0346",
			tags: ["bridge above", "мостик сверху"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"bridge_below", {
			unicode: "032A",
			tags: ["bridge below", "мостик снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "<+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"bridge_inverted_below", {
			unicode: "033A",
			tags: ["inverted bridge below", "перевёрнутый мостик снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: ">+ B И" },
			symbol: { category: "Diacritic Mark" },
		},
		"circumflex", {
			unicode: "0302", LaTeX: ["\^", "\hat"],
			tags: ["circumflex", "циркумфлекс"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"caron", {
			unicode: "030C", LaTeX: ["\v", "\check"],
			tags: ["caron", "hachek", "карон", "гачек"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"circumflex_below", {
			unicode: "032D",
			tags: ["circumflex below", "циркумфлекс снизу"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: "<+>+ C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"caron_below", {
			unicode: "032C",
			tags: ["caron below", "карон снизу", "гачек снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "<+>+ C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"cedilla", {
			unicode: "0327", LaTeX: ["\c"],
			alterations: {
				uncombined: "00B8",
			},
			tags: ["cedilla", "седиль"],
			groups: ["Diacritics Tertiary", "FK Diacritics Primary"],
			options: { fastKey: ">+ C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above", {
			unicode: "0313",
			tags: ["comma above", "запятая сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: ", Б" },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_below", {
			unicode: "0326",
			tags: ["comma below", "запятая снизу"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ , Б" },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above_turned", {
			unicode: "0312",
			alterations: { modifier: "02BB" },
			tags: ["turned comma above", "перевёрнутая запятая сверху"],
			groups: ["SK Diacritics Primary", "IPA"],
			options: { fastKey: ", Б", altLayoutKey: ">+ <", showOnAlt: "modifier", layoutTitles: True },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above_reversed", {
			unicode: "0314",
			tags: ["reversed comma above", "зеркальная запятая сверху"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "<+ , Б" },
			symbol: { category: "Diacritic Mark" },
		},
		"comma_above_right", {
			unicode: "0315",
			tags: ["comma above right", "запятая сверху справа"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: ">+ , Б" },
			symbol: { category: "Diacritic Mark" },
		},
		"candrabindu", {
			unicode: "0310",
			tags: ["candrabindu", "чандрабинду"],
			groups: ["TK Diacritics Primary"],
			options: { fastKey: "C С" },
			symbol: { category: "Diacritic Mark" },
		},
		"dot_above", {
			unicode: "0307", LaTeX: ["\.", "\dot"],
			alterations: {
				uncombined: "02D9",
			},
			tags: ["dot above", "точка сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"diaeresis", {
			unicode: "0308", LaTeX: ["\`"", "\ddot"],
			alterations: {
				uncombined: "00A8",
			},
			tags: ["diaeresis", "диерезис"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"dot_below", {
			unicode: "0323", LaTeX: ["\d"],
			tags: ["dot below", "точка снизу"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: ">+ D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"diaeresis_below", {
			unicode: "0324",
			tags: ["diaeresis below", "диерезис снизу"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: "<+>+ D В" },
			symbol: { category: "Diacritic Mark" },
		},
		"fermata", {
			unicode: "0352",
			tags: ["fermata", "фермата"],
			groups: ["Diacritics Tertiary", "FK Diacritics Primary"],
			options: { fastKey: "F А" },
			symbol: { category: "Diacritic Mark" },
		},
		"grave", {
			unicode: "0300", LaTeX: ["\``", "\grave"],
			alterations: {
				modifier: "02F4",
				uncombined: "0060",
			},
			tags: ["grave", "гравис"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "G П" },
			symbol: { category: "Diacritic Mark" },
		},
		"grave_double", {
			unicode: "030F",
			alterations: {
				modifier: "02F5",
			},
			tags: ["double grave", "двойной гравис"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ G П" },
			symbol: { category: "Diacritic Mark" },
		},
		"grave_below", {
			unicode: "0316",
			tags: ["grave below", "гравис снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "G П" },
			symbol: { category: "Diacritic Mark" },
		},
		"grave_tone_vietnamese", {
			unicode: "0340",
			tags: ["grave tone", "гравис тона"],
			groups: [],
			options: {},
			symbol: { category: "Diacritic Mark" },
		},
		"hook_above", {
			unicode: "0309",
			tags: ["hook above", "хвостик сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"horn", {
			unicode: "031B",
			tags: ["horn", "рожок"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"palatal_hook", {
			unicode: "0321",
			tags: ["palatal hook below", "палатальный крюк"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: ">+ H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"retroflex_hook", {
			unicode: "0322",
			tags: ["retroflex hook below", "ретрофлексный крюк"],
			groups: ["Diacritics Secondary", "FK Diacritics Primary"],
			options: { fastKey: "<+>+ H Р" },
			symbol: { category: "Diacritic Mark" },
		},
		"macron", {
			unicode: "0304", LaTeX: ["\=", "\bar"],
			alterations: {
				uncombined: "00AF",
				modifier: "02C9",
				fullwidth: "FFE3"
			},
			tags: ["macron", "макрон"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "M Ь" },
			symbol: { category: "Diacritic Mark" },
		},
		"macron_below", {
			unicode: "0331",
			alterations: {
				modifier: "02CD",
			},
			tags: ["macron below", "макрон снизу"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ M Ь" },
			symbol: { category: "Diacritic Mark" },
		},
		"ogonek", {
			unicode: "0328", LaTeX: ["\k"],
			alterations: {
				uncombined: "02DB",
			},
			tags: ["ogonek", "огонэк"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "O Щ" },
			symbol: { category: "Diacritic Mark" },
		},
		"ogonek_above", {
			unicode: "1DCE",
			tags: ["ogonek above", "огонэк сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ O Щ" },
			symbol: { category: "Diacritic Mark", font: "Noto Serif" },
		},
		"overline", {
			unicode: "0305",
			tags: ["overline", "черта сверху"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "O Щ" },
			symbol: { category: "Diacritic Mark" },
		},
		"overline_double", {
			unicode: "033F",
			tags: ["overline", "черта сверху"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "<+ O Щ" },
			symbol: { category: "Diacritic Mark" },
		},
		"low_line", {
			unicode: "0332",
			tags: ["low line", "черта снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: ">+ O Щ" },
			symbol: { category: "Diacritic Mark" },
		},
		"low_line_double", {
			unicode: "0333",
			tags: ["dobule low line", "двойная черта снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "<+>+ O Щ" },
			symbol: { category: "Diacritic Mark" },
		},
		"ring_above", {
			unicode: "030A",
			alterations: {
				uncombined: "02DA",
			},
			tags: ["ring above", "кольцо сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "R К" },
			symbol: { category: "Diacritic Mark" },
		},
		"ring_below", {
			unicode: "0325",
			alterations: {
				modifier: "02F3",
			},
			tags: ["ring above", "кольцо сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ R К" },
			symbol: { category: "Diacritic Mark" },
		},
		"ring_below_double", {
			unicode: "035A",
			tags: ["double ring below", "двойное кольцо снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "R К" },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical", {
			unicode: "030D",
			alterations: { modifier: "02C8" },
			tags: ["vertical line", "вертикальная черта"],
			groups: ["Diacritics Primary", "FK Diacritics Primary", "IPA"],
			options: { fastKey: "V М", altLayoutKey: "'", showOnAlt: "modifier", layoutTitles: True },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical_double", {
			unicode: "030E",
			tags: ["double vertical line", "двойная вертикальная черта"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ V М" },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical_below", {
			unicode: "0329",
			alterations: { modifier: "02CC" },
			tags: ["vertical line below", "вертикальная черта снизу"],
			groups: ["SK Diacritics Primary", "IPA"],
			options: { fastKey: "V М", altLayoutKey: ">! '", showOnAlt: "modifier", layoutTitles: True },
			symbol: { category: "Diacritic Mark" },
		},
		"line_vertical_double_below", {
			unicode: "0348",
			tags: ["dobule vertical line below", "двойная вертикальная черта снизу"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "<+ V М" },
			symbol: { category: "Diacritic Mark" },
		},
		"stroke_short", {
			unicode: "0335",
			tags: ["short stroke", "короткое перечёркивание"],
			groups: ["Diacritics Quatemary", "FK Diacritics Primary"],
			options: { fastKey: "S Ы" },
			symbol: { category: "Diacritic Mark" },
		},
		"stroke_long", {
			unicode: "0336",
			tags: ["long stroke", "длинное перечёркивание"],
			groups: ["Diacritics Quatemary", "FK Diacritics Primary"],
			options: { fastKey: "<+ S Ы" },
			symbol: { category: "Diacritic Mark" },
		},
		"solidus_short", {
			unicode: "0337",
			tags: ["short solidus", "короткая косая черта"],
			groups: ["Diacritics Quatemary", "FK Diacritics Primary"],
			options: { fastKey: "/ ." },
			symbol: { category: "Diacritic Mark" },
		},
		"solidus_long", {
			unicode: "0338",
			tags: ["long solidus", "длинная косая черта"],
			groups: ["Diacritics Quatemary", "FK Diacritics Primary"],
			options: { fastKey: "<+ / ." },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_above", {
			unicode: "0303", LaTeX: ["\~", "\tilde"],
			alterations: {
				modifier: "02F7",
				uncombined: "02DC",
			},
			tags: ["tilde", "тильда"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "T Е" },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_vertical", {
			unicode: "033E",
			tags: ["tilde vertical", "вертикальная тильда"],
			groups: ["FK Diacritics Primary"],
			options: { fastKey: "<+ T Е" },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_below", {
			unicode: "0330",
			tags: ["tilde below", "тильда снизу"],
			groups: ["FK Diacritics Primary"],
			options: { fastKey: "<+>+ T Е" },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_not", {
			unicode: "034A",
			tags: ["not tilde", "перечёрнутая тильда"],
			groups: ["SK Diacritics Primary"],
			options: { fastKey: "T Е" },
			symbol: { category: "Diacritic Mark" },
		},
		"tilde_overlay", {
			unicode: "0334",
			tags: ["tilde overlay", "тильда посередине"],
			groups: ["FK Diacritics Primary"],
			options: { fastKey: "<+ T Е" },
			symbol: { category: "Diacritic Mark" },
		},
		"x_above", {
			unicode: "033D",
			tags: ["x above", "x сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "X Ч" },
			symbol: { category: "Diacritic Mark" },
		},
		"x_below", {
			unicode: "0353",
			tags: ["x below", "x снизу"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "<+ X Ч" },
			symbol: { category: "Diacritic Mark" },
		},
		"zigzag_above", {
			unicode: "035B",
			tags: ["zigzag above", "зигзаг сверху"],
			groups: ["Diacritics Primary", "FK Diacritics Primary"],
			options: { fastKey: "Z Я" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_vzmet", {
			unicode: "A66F",
			tags: ["взмет кириллицы", "cyrillic vzmet"],
			groups: ["Diacritics Primary", "Cyrillic Diacritics"],
			options: { altLayoutKey: "<^<! В" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_titlo", {
			unicode: "0483",
			tags: ["титло кириллицы", "cyrillic titlo"],
			groups: ["Diacritics Primary", "Cyrillic Diacritics"],
			options: { altLayoutKey: "<^<! Т" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_palatalization", {
			unicode: "0484",
			tags: ["палатализация кириллицы", "cyrillic palatalization"],
			groups: ["Diacritics Tertiary", "Cyrillic Diacritics"],
			options: { altLayoutKey: "<^<! П" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_pokrytie", {
			unicode: "0487",
			tags: ["покрытие кириллицы", "cyrillic pokrytie"],
			groups: ["Diacritics Tertiary", "Cyrillic Diacritics"],
			options: { altLayoutKey: "<^<!<+ П" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_dasia_pneumata", {
			unicode: "0485",
			tags: ["густое придыхание кириллицы", "cyrillic dasia pneumata"],
			groups: ["Diacritics Quatemary", "Cyrillic Diacritics", "FK Diacritics Primary"],
			options: { fastKey: ">+ G П", altLayoutKey: "<^<!>+ П" },
			symbol: { category: "Diacritic Mark" },
		},
		"cyr_com_psili_pneumata", {
			unicode: "0486",
			tags: ["тонкое придыхание кириллицы", "cyrillic psili pneumata"],
			groups: ["Diacritics Quatemary", "Cyrillic Diacritics", "FK Diacritics Primary"],
			options: { fastKey: "<+>+ G П", altLayoutKey: "<^<!<+>+ П" },
			symbol: { category: "Diacritic Mark" },
		},
		;
		;
		; * Default Math & Puncuation
		;
		;
		"digit_[0,1,2,3,4,5,6,7,8,9]", {
			unicode: [
				"0030",
				"0031",
				"0032",
				"0033",
				"0034",
				"0035",
				"0036",
				"0037",
				"0038",
				"0039"
			],
			alterations: [{
				doubleStruck: "1D7D8",
				bold: "1D7CE",
				sansSerif: "1D7E2",
				sansSerifBold: "1D7EC",
				monospace: "1D7F6",
				superscript: "2070",
				subscript: "2080",
				fullwidth: "FF10"
			}, {
				doubleStruck: "1D7D9",
				bold: "1D7CF",
				sansSerif: "1D7E3",
				sansSerifBold: "1D7ED",
				monospace: "1D7F7",
				superscript: "00B9",
				subscript: "2081",
				fullwidth: "FF11"
			}, {
				doubleStruck: "1D7DA",
				bold: "1D7D0",
				sansSerif: "1D7E4",
				sansSerifBold: "1D7EE",
				monospace: "1D7F8",
				superscript: "00B2",
				subscript: "2082",
				fullwidth: "FF12"
			}, {
				doubleStruck: "1D7DB",
				bold: "1D7D1",
				sansSerif: "1D7E5",
				sansSerifBold: "1D7EF",
				monospace: "1D7F9",
				superscript: "00B3",
				subscript: "2083",
				fullwidth: "FF13"
			}, {
				doubleStruck: "1D7DC",
				bold: "1D7D2",
				sansSerif: "1D7E6",
				sansSerifBold: "1D7F0",
				monospace: "1D7FA",
				superscript: "2074",
				subscript: "2084",
				fullwidth: "FF14"
			}, {
				doubleStruck: "1D7DD",
				bold: "1D7D3",
				sansSerif: "1D7E7",
				sansSerifBold: "1D7F1",
				monospace: "1D7FB",
				superscript: "2075",
				subscript: "2085",
				fullwidth: "FF15"
			}, {
				doubleStruck: "1D7DE",
				bold: "1D7D4",
				sansSerif: "1D7E8",
				sansSerifBold: "1D7F2",
				monospace: "1D7FC",
				superscript: "2076",
				subscript: "2086",
				fullwidth: "FF176"
			}, {
				doubleStruck: "1D7DF",
				bold: "1D7D5",
				sansSerif: "1D7E9",
				sansSerifBold: "1D7F3",
				monospace: "1D7FD",
				superscript: "2077",
				subscript: "2087",
				fullwidth: "FF17"
			}, {
				doubleStruck: "1D7E0",
				bold: "1D7D6",
				sansSerif: "1D7EA",
				sansSerifBold: "1D7F4",
				monospace: "1D7FE",
				superscript: "2078",
				subscript: "2088",
				fullwidth: "FF18"
			}, {
				doubleStruck: "1D7E1",
				bold: "1D7D7",
				sansSerif: "1D7EB",
				sansSerifBold: "1D7F5",
				monospace: "1D7FF",
				superscript: "2079",
				subscript: "2089",
				fullwidth: "FF19"
			}],
			options: { noCalc: True }
		},
		;
		;
		; * Default Latin
		;
		;
		"lat_[c,s]_let_a", {
			unicode: ["0041", "0061"],
			alterations: [{
				modifier: "1D2C",
				italic: "1D434",
				italicBold: "1D468",
				bold: "1D400",
				fraktur: "1D504",
				frakturBold: "1D56C",
				script: "1D49C",
				scriptBold: "1D4D0",
				doubleStruck: "1D538",
				sansSerif: "1D5A0",
				sansSerifItalic: "1D608",
				sansSerifItalicBold: "1D63C",
				sansSerifBold: "1D5D4",
				monospace: "1D670",
				smallCapital: "1D00",
				fullwidth: "FF21"
			}, {
				combining: "0363",
				modifier: "1D43",
				subscript: "2090",
				italic: "1D44E",
				italicBold: "1D482",
				bold: "1D41A",
				fraktur: "1D51E",
				frakturBold: "1D586",
				script: "1D4B6",
				scriptBold: "1D4EA",
				doubleStruck: "1D552",
				sansSerif: "1D5BA",
				sansSerifItalic: "1D622",
				sansSerifItalicBold: "1D656",
				sansSerifBold: "1D5EE",
				monospace: "1D68A",
				fullwidth: "FF41"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_b", {
			unicode: ["0042", "0062"],
			alterations: [{
				modifier: "1D2E",
				italic: "1D435",
				italicBold: "1D469",
				bold: "1D401",
				fraktur: "1D505",
				frakturBold: "1D56D",
				script: "212C",
				scriptBold: "1D4D1",
				doubleStruck: "1D539",
				sansSerif: "1D5A1",
				sansSerifItalic: "1D609",
				sansSerifItalicBold: "1D63D",
				sansSerifBold: "1D5D5",
				monospace: "1D671",
				smallCapital: "0299",
				fullwidth: "FF22"
			}, {
				combining: "1DE8",
				modifier: "1D47",
				italic: "1D44F",
				italicBold: "1D483",
				bold: "1D41B",
				fraktur: "1D51F",
				frakturBold: "1D587",
				script: "1D4B7",
				scriptBold: "1D4EB",
				doubleStruck: "1D553",
				sansSerif: "1D5BB",
				sansSerifItalic: "1D623",
				sansSerifItalicBold: "1D657",
				sansSerifBold: "1D5EF",
				monospace: "1D68B",
				fullwidth: "FF42"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_c", {
			unicode: ["0043", "0063"],
			alterations: [{
				modifier: "A7F2",
				italic: "1D436",
				italicBold: "1D46A",
				bold: "1D402",
				fraktur: "212D",
				frakturBold: "1D56E",
				script: "1D49E",
				scriptBold: "1D4D2",
				doubleStruck: "2102",
				sansSerif: "1D5A2",
				sansSerifItalic: "1D60A",
				sansSerifItalicBold: "1D63E",
				sansSerifBold: "1D5D6",
				monospace: "1D672",
				smallCapital: "1D04",
				fullwidth: "FF23"
			}, {
				combining: "0368",
				modifier: "1D9C",
				italic: "1D450",
				italicBold: "1D484",
				bold: "1D41C",
				fraktur: "1D520",
				frakturBold: "1D588",
				script: "1D4B8",
				scriptBold: "1D4EC",
				doubleStruck: "1D554",
				sansSerif: "1D5BC",
				sansSerifItalic: "1D624",
				sansSerifItalicBold: "1D658",
				sansSerifBold: "1D5F0",
				monospace: "1D68C",
				fullwidth: "FF43"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_d", {
			unicode: ["0044", "0064"],
			alterations: [{
				modifier: "1D30",
				italic: "1D437",
				italicBold: "1D46B",
				bold: "1D403",
				fraktur: "1D507",
				frakturBold: "1D56F",
				script: "1D49F",
				scriptBold: "1D4D3",
				doubleStruck: "1D53B",
				doubleStruckItalic: "2145",
				sansSerif: "1D5A3",
				sansSerifItalic: "1D60B",
				sansSerifItalicBold: "1D63F",
				sansSerifBold: "1D5D7",
				monospace: "1D673",
				smallCapital: "1D05",
				fullwidth: "FF24"
			}, {
				combining: "0369",
				modifier: "1D48",
				italic: "1D451",
				italicBold: "1D485",
				bold: "1D41D",
				fraktur: "1D521",
				frakturBold: "1D589",
				script: "1D4B9",
				scriptBold: "1D4ED",
				doubleStruck: "1D555",
				doubleStruckItalic: "2146",
				sansSerif: "1D5BD",
				sansSerifItalic: "1D625",
				sansSerifItalicBold: "1D659",
				sansSerifBold: "1D5F1",
				monospace: "1D68D",
				fullwidth: "FF44"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_e", {
			unicode: ["0045", "0065"],
			alterations: [{
				modifier: "1D31",
				italic: "1D438",
				italicBold: "1D46C",
				bold: "1D404",
				fraktur: "1D508",
				frakturBold: "1D570",
				script: "2130",
				scriptBold: "1D4D4",
				doubleStruck: "1D53C",
				sansSerif: "1D5A4",
				sansSerifItalic: "1D60C",
				sansSerifItalicBold: "1D640",
				sansSerifBold: "1D5D8",
				monospace: "1D674",
				smallCapital: "1D07",
				fullwidth: "FF25"
			}, {
				combining: "0364",
				modifier: "1D49",
				subscript: "2091",
				italic: "1D452",
				italicBold: "1D486",
				bold: "1D41E",
				fraktur: "1D522",
				frakturBold: "1D58A",
				script: "212F",
				scriptBold: "1D4EE",
				doubleStruck: "1D556",
				doubleStruckItalic: "2147",
				sansSerif: "1D5BE",
				sansSerifItalic: "1D626",
				sansSerifItalicBold: "1D65A",
				sansSerifBold: "1D5F2",
				monospace: "1D68E",
				fullwidth: "FF45"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_f", {
			unicode: ["0046", "0066"],
			alterations: [{
				modifier: "A7F3",
				italic: "1D439",
				italicBold: "1D46D",
				bold: "1D405",
				fraktur: "1D509",
				frakturBold: "1D571",
				script: "2131",
				scriptBold: "1D4D5",
				doubleStruck: "1D53D",
				sansSerif: "1D5A5",
				sansSerifItalic: "1D60D",
				sansSerifItalicBold: "1D641",
				sansSerifBold: "1D5D9",
				monospace: "1D675",
				smallCapital: "A730",
				fullwidth: "FF26"
			}, {
				combining: "1DEB",
				modifier: "1DA0",
				italic: "1D453",
				italicBold: "1D487",
				bold: "1D41F",
				fraktur: "1D523",
				frakturBold: "1D58B",
				script: "1D4BB",
				scriptBold: "1D4EF",
				doubleStruck: "1D557",
				sansSerif: "1D5BF",
				sansSerifItalic: "1D627",
				sansSerifItalicBold: "1D65B",
				sansSerifBold: "1D5F3",
				monospace: "1D68F",
				fullwidth: "FF46"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_g", {
			unicode: ["0047", "0067"],
			alterations: [{
				combining: "1DDB",
				modifier: "1D33",
				italic: "1D43A",
				italicBold: "1D46E",
				bold: "1D406",
				fraktur: "1D50A",
				frakturBold: "1D572",
				script: "1D4A2",
				scriptBold: "1D4D6",
				doubleStruck: "1D53E",
				sansSerif: "1D5A6",
				sansSerifItalic: "1D60E",
				sansSerifItalicBold: "1D642",
				sansSerifBold: "1D5DA",
				monospace: "1D676",
				smallCapital: "0262",
				fullwidth: "FF27"
			}, {
				combining: "1DDA",
				modifier: "1D4D",
				italic: "1D454",
				italicBold: "1D488",
				bold: "1D420",
				fraktur: "1D524",
				frakturBold: "1D58C",
				script: "210A",
				scriptBold: "1D4F0",
				doubleStruck: "1D558",
				sansSerif: "1D5C0",
				sansSerifItalic: "1D628",
				sansSerifItalicBold: "1D65C",
				sansSerifBold: "1D5F4",
				monospace: "1D690",
				fullwidth: "FF47"
			}],
			groups: [["Latin", "IPA"], ["Latin"]],
			tags: [["voiced uvular plosive", "звонкий увулярный взрывной согласный"], []],
			options: { noCalc: True, altLayoutKey: ["c*>! $", ""], showOnAlt: ["smallCapital", ""], layoutTitles: [True, False] },
		},
		"lat_[c,s]_let_h", {
			unicode: ["0048", "0068"],
			alterations: [{
				modifier: "1D34",
				italic: "1D43B",
				italicBold: "1D46F",
				bold: "1D407",
				fraktur: "210C",
				frakturBold: "1D573",
				script: "210B",
				scriptBold: "1D4D7",
				doubleStruck: "210D",
				sansSerif: "1D5A7",
				sansSerifItalic: "1D60F",
				sansSerifItalicBold: "1D643",
				sansSerifBold: "1D5DB",
				monospace: "1D677",
				smallCapital: "029C",
				fullwidth: "FF28"
			}, {
				combining: "036A",
				modifier: "02B0",
				subscript: "2095",
				italic: "210E",
				italicBold: "1D489",
				bold: "1D421",
				fraktur: "1D525",
				frakturBold: "1D58D",
				script: "1D4BD",
				scriptBold: "1D4F1",
				doubleStruck: "1D559",
				sansSerif: "1D5C1",
				sansSerifItalic: "1D629",
				sansSerifItalicBold: "1D65D",
				sansSerifBold: "1D5F5",
				monospace: "1D691",
				fullwidth: "FF48"
			}],
			groups: [["Latin", "IPA"], ["Latin"]],
			tags: [["voiceless epiglottal fricative", "глухой эпиглоттальный спирант"], []],
			options: { noCalc: True, altLayoutKey: ["c*>! $", ""], showOnAlt: ["smallCapital", ""], layoutTitles: [True, False] },
		},
		"lat_[c,s]_let_i", {
			unicode: ["0049", "0069"],
			alterations: [{
				modifier: "1D35",
				italic: "1D43C",
				italicBold: "1D470",
				bold: "1D408",
				fraktur: "2111",
				frakturBold: "1D574",
				script: "2110",
				scriptBold: "1D4D8",
				doubleStruck: "1D540",
				sansSerif: "1D5A8",
				sansSerifItalic: "1D610",
				sansSerifItalicBold: "1D644",
				sansSerifBold: "1D5DC",
				monospace: "1D678",
				smallCapital: "026A",
				fullwidth: "FF29"
			}, {
				combining: "0365",
				subscript: "1D62",
				italic: "1D456",
				italicBold: "1D48A",
				bold: "1D422",
				fraktur: "1D526",
				frakturBold: "1D58E",
				script: "1D4BE",
				scriptBold: "1D4F2",
				doubleStruck: "1D55A",
				doubleStruckItalic: "2148",
				sansSerif: "1D5C2",
				sansSerifItalic: "1D62A",
				sansSerifItalicBold: "1D65E",
				sansSerifBold: "1D5F6",
				monospace: "1D692",
				fullwidth: "FF49"
			}],
			; alterationsEntries: [{ ; ? It is just a draft idea for separated info for symbols variations
			; smallCapital: {
			; groups: ["IPA"],
			; options: { altLayoutKey: ">! $", layoutTitles: True },
			; }
			; }, {}],
			groups: [["Latin", "IPA"], ["Latin"]],
			tags: [["near-close near-front unrounded vowel", "ненапряжённый неогублённый гласный переднего ряда верхнего подъёма"], []],
			options: { noCalc: True, altLayoutKey: ["c*>! $", ""], showOnAlt: ["smallCapital", ""], layoutTitles: [True, False] },
			recipe: [[Chr(0x0130) "/"], [Chr(0x0131) "${dot_above}"]],
		},
		"lat_[c,s]_let_j", {
			unicode: ["004A", "006A"],
			alterations: [{
				modifier: "1D36",
				italic: "1D43D",
				italicBold: "1D471",
				bold: "1D409",
				fraktur: "1D50D",
				frakturBold: "1D575",
				script: "1D4A5",
				scriptBold: "1D4D9",
				doubleStruck: "1D541",
				sansSerif: "1D5A9",
				sansSerifItalic: "1D611",
				sansSerifItalicBold: "1D645",
				sansSerifBold: "1D5DD",
				monospace: "1D679",
				smallCapital: "1D0A",
				fullwidth: "FF2A"
			}, {
				modifier: "02B2",
				subscript: "2C7C",
				italic: "1D457",
				italicBold: "1D48B",
				bold: "1D423",
				fraktur: "1D527",
				frakturBold: "1D58F",
				script: "1D4BF",
				scriptBold: "1D4F3",
				doubleStruck: "1D55B",
				doubleStruckItalic: "2149",
				sansSerif: "1D5C3",
				sansSerifItalic: "1D62B",
				sansSerifItalicBold: "1D65F",
				sansSerifBold: "1D5F7",
				monospace: "1D693",
				fullwidth: "FF4A"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_k", {
			unicode: ["004B", "006B"],
			alterations: [{
				modifier: "1D37",
				italic: "1D43E",
				italicBold: "1D472",
				bold: "1D40A",
				fraktur: "1D50E",
				frakturBold: "1D576",
				script: "1D4A6",
				scriptBold: "1D4DA",
				doubleStruck: "1D542",
				sansSerif: "1D5AA",
				sansSerifItalic: "1D612",
				sansSerifItalicBold: "1D646",
				sansSerifBold: "1D5DE",
				monospace: "1D67A",
				smallCapital: "1D0B",
				fullwidth: "FF2B"
			}, {
				combining: "1DDC",
				modifier: "1D4F",
				subscript: "2096",
				italic: "1D458",
				italicBold: "1D48C",
				bold: "1D424",
				fraktur: "1D528",
				frakturBold: "1D590",
				script: "1D4C0",
				scriptBold: "1D4F4",
				doubleStruck: "1D55C",
				sansSerif: "1D5C4",
				sansSerifItalic: "1D62C",
				sansSerifItalicBold: "1D660",
				sansSerifBold: "1D5F8",
				monospace: "1D694",
				fullwidth: "FF4B"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_l", {
			unicode: ["004C", "006C"],
			alterations: [{
				combining: "1DDE",
				modifier: "1D38",
				italic: "1D43F",
				italicBold: "1D473",
				bold: "1D40B",
				fraktur: "1D50F",
				frakturBold: "1D577",
				script: "2112",
				scriptBold: "1D4DB",
				doubleStruck: "1D543",
				sansSerif: "1D5AB",
				sansSerifItalic: "1D613",
				sansSerifItalicBold: "1D647",
				sansSerifBold: "1D5DF",
				monospace: "1D67B",
				smallCapital: "029F",
				fullwidth: "FF2C"
			}, {
				combining: "1DDD",
				modifier: "02E1",
				subscript: "2097",
				italic: "1D459",
				italicBold: "1D48D",
				bold: "1D425",
				fraktur: "1D529",
				frakturBold: "1D591",
				script: "1D4C1",
				scriptBold: "1D4F5",
				doubleStruck: "1D55D",
				sansSerif: "1D5C5",
				sansSerifItalic: "1D62D",
				sansSerifItalicBold: "1D661",
				sansSerifBold: "1D5F9",
				monospace: "1D695",
				fullwidth: "FF4C"
			}],
			groups: [["Latin", "IPA"], ["Latin"]],
			tags: [["voiced velar lateral approximant", "звонкий велярный латеральный аппроксимант"], []],
			options: { noCalc: True, altLayoutKey: ["c*>! $", ""], showOnAlt: ["smallCapital", ""], layoutTitles: [True, False] },
		},
		"lat_[c,s]_let_m", {
			unicode: ["004D", "006D"],
			alterations: [{
				combining: "1DDF",
				modifier: "1D39",
				italic: "1D440",
				italicBold: "1D474",
				bold: "1D40C",
				fraktur: "1D510",
				frakturBold: "1D578",
				script: "2133",
				scriptBold: "1D4DC",
				doubleStruck: "1D544",
				sansSerif: "1D5AC",
				sansSerifItalic: "1D614",
				sansSerifItalicBold: "1D648",
				sansSerifBold: "1D5E0",
				monospace: "1D67C",
				smallCapital: "1D0D",
				fullwidth: "FF2D"
			}, {
				combining: "036B",
				modifier: "1D50",
				subscript: "2098",
				italic: "1D45A",
				italicBold: "1D48E",
				bold: "1D426",
				fraktur: "1D52A",
				frakturBold: "1D592",
				script: "1D4C2",
				scriptBold: "1D4F6",
				doubleStruck: "1D55E",
				sansSerif: "1D5C6",
				sansSerifItalic: "1D62E",
				sansSerifItalicBold: "1D662",
				sansSerifBold: "1D5FA",
				monospace: "1D696",
				fullwidth: "FF4D"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_n", {
			unicode: ["004E", "006E"],
			alterations: [{
				combining: "1DE1",
				modifier: "1D3A",
				italic: "1D441",
				italicBold: "1D475",
				bold: "1D40D",
				fraktur: "1D511",
				frakturBold: "1D579",
				script: "1D4A9",
				scriptBold: "1D4DD",
				doubleStruck: "2115",
				sansSerif: "1D5AD",
				sansSerifItalic: "1D615",
				sansSerifItalicBold: "1D649",
				sansSerifBold: "1D5E1",
				monospace: "1D67D",
				smallCapital: "0274",
				fullwidth: "FF2E"
			}, {
				combining: "1DE0",
				subscript: "2099",
				italic: "1D45B",
				italicBold: "1D48F",
				bold: "1D427",
				fraktur: "1D52B",
				frakturBold: "1D593",
				script: "1D4C3",
				scriptBold: "1D4F7",
				doubleStruck: "1D55F",
				sansSerif: "1D5C7",
				sansSerifItalic: "1D62F",
				sansSerifItalicBold: "1D663",
				sansSerifBold: "1D5FB",
				monospace: "1D697",
				fullwidth: "FF4E"
			}],
			groups: [["Latin", "IPA"], ["Latin"]],
			tags: [["voiced uvular nasal", "увулярный носовой согласный"], []],
			options: { noCalc: True, altLayoutKey: ["c*>! $", ""], showOnAlt: ["smallCapital", ""], layoutTitles: [True, False] },
		},
		"lat_[c,s]_let_o", {
			unicode: ["004F", "006F"],
			alterations: [{
				modifier: "1D3C",
				italic: "1D442",
				italicBold: "1D476",
				bold: "1D40E",
				fraktur: "1D512",
				frakturBold: "1D57A",
				script: "1D4AA",
				scriptBold: "1D4DE",
				doubleStruck: "1D546",
				sansSerif: "1D5AE",
				sansSerifItalic: "1D616",
				sansSerifItalicBold: "1D64A",
				sansSerifBold: "1D5E2",
				monospace: "1D67E",
				smallCapital: "1D0F",
				fullwidth: "FF2F"
			}, {
				combining: "0366",
				modifier: "1D52",
				subscript: "2092",
				italic: "1D45C",
				italicBold: "1D490",
				bold: "1D428",
				fraktur: "1D52C",
				frakturBold: "1D594",
				script: "2134",
				scriptBold: "1D4F8",
				doubleStruck: "1D560",
				sansSerif: "1D5C8",
				sansSerifItalic: "1D630",
				sansSerifItalicBold: "1D664",
				sansSerifBold: "1D5FC",
				monospace: "1D698",
				fullwidth: "FF4F"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_p", {
			unicode: ["0050", "0070"],
			alterations: [{
				modifier: "1D3E",
				italic: "1D443",
				italicBold: "1D477",
				bold: "1D40F",
				fraktur: "1D513",
				frakturBold: "1D57B",
				script: "1D4AB",
				scriptBold: "1D4DF",
				doubleStruck: "2119",
				sansSerif: "1D5AF",
				sansSerifItalic: "1D617",
				sansSerifItalicBold: "1D64B",
				sansSerifBold: "1D5E3",
				monospace: "1D67F",
				smallCapital: "1D18",
				fullwidth: "FF30"
			}, {
				combining: "1DEE",
				modifier: "1D56",
				subscript: "209A",
				italic: "1D45D",
				italicBold: "1D491",
				bold: "1D429",
				fraktur: "1D52D",
				frakturBold: "1D595",
				script: "1D4C5",
				scriptBold: "1D4F9",
				doubleStruck: "1D561",
				sansSerif: "1D5C9",
				sansSerifItalic: "1D631",
				sansSerifItalicBold: "1D665",
				sansSerifBold: "1D5FD",
				monospace: "1D699",
				fullwidth: "FF50"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_q", {
			unicode: ["0051", "0071"],
			alterations: [{
				modifier: "A7F4",
				italic: "1D444",
				italicBold: "1D478",
				bold: "1D410",
				fraktur: "1D514",
				frakturBold: "1D57C",
				script: "1D4AC",
				scriptBold: "1D4E0",
				doubleStruck: "211A",
				sansSerif: "1D5B0",
				sansSerifItalic: "1D618",
				sansSerifItalicBold: "1D64C",
				sansSerifBold: "1D5E4",
				monospace: "1D680",
				smallCapital: "A7AF",
				fullwidth: "FF31"
			}, {
				italic: "1D45E",
				italicBold: "1D492",
				bold: "1D42A",
				fraktur: "1D52E",
				frakturBold: "1D596",
				script: "1D4C6",
				scriptBold: "1D4FA",
				doubleStruck: "1D562",
				sansSerif: "1D5CA",
				sansSerifItalic: "1D632",
				sansSerifItalicBold: "1D666",
				sansSerifBold: "1D5FE",
				monospace: "1D69A",
				fullwidth: "FF51"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_r", {
			unicode: ["0052", "0072"],
			alterations: [{
				combining: "1DE2",
				modifier: "1D3F",
				italic: "1D445",
				italicBold: "1D479",
				bold: "1D411",
				fraktur: "211C",
				frakturBold: "1D57D",
				script: "211B",
				scriptBold: "1D4E1",
				doubleStruck: "211D",
				sansSerif: "1D5B1",
				sansSerifItalic: "1D619",
				sansSerifItalicBold: "1D64D",
				sansSerifBold: "1D5E5",
				monospace: "1D681",
				smallCapital: "0280",
				fullwidth: "FF32"
			}, {
				combining: "036C",
				modifier: "02B3",
				subscript: "1D63",
				italic: "1D45F",
				italicBold: "1D493",
				bold: "1D42B",
				fraktur: "1D52F",
				frakturBold: "1D597",
				script: "1D4C7",
				scriptBold: "1D4FB",
				doubleStruck: "1D563",
				sansSerif: "1D5CB",
				sansSerifItalic: "1D633",
				sansSerifItalicBold: "1D667",
				sansSerifBold: "1D5FF",
				monospace: "1D69B",
				fullwidth: "FF52"
			}],
			groups: [["Latin", "IPA"], ["Latin"]],
			tags: [["voiced uvular trill", "увулярный дрожащий согласный"], []],
			options: { noCalc: True, altLayoutKey: ["c*>! $", ""], showOnAlt: ["smallCapital", ""], layoutTitles: [True, False] },
		},
		"lat_[c,s]_let_s", {
			unicode: ["0053", "0073"],
			alterations: [{
				italic: "1D446",
				italicBold: "1D47A",
				bold: "1D412",
				fraktur: "1D516",
				frakturBold: "1D57E",
				script: "1D4AE",
				scriptBold: "1D4E2",
				doubleStruck: "1D54A",
				sansSerif: "1D5B2",
				sansSerifItalic: "1D61A",
				sansSerifItalicBold: "1D64E",
				sansSerifBold: "1D5E6",
				monospace: "1D682",
				smallCapital: "A731",
				fullwidth: "FF33"
			}, {
				combining: "1DE4",
				modifier: "02E2",
				subscript: "209B",
				italic: "1D460",
				italicBold: "1D494",
				bold: "1D42C",
				fraktur: "1D530",
				frakturBold: "1D598",
				script: "1D4C8",
				scriptBold: "1D4FC",
				doubleStruck: "1D564",
				sansSerif: "1D5CC",
				sansSerifItalic: "1D634",
				sansSerifItalicBold: "1D668",
				sansSerifBold: "1D600",
				monospace: "1D69C",
				fullwidth: "FF53"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_t", {
			unicode: ["0054", "0074"],
			alterations: [{
				modifier: "1D40",
				italic: "1D447",
				italicBold: "1D47B",
				bold: "1D413",
				fraktur: "1D517",
				frakturBold: "1D57F",
				script: "1D4AF",
				scriptBold: "1D4E3",
				doubleStruck: "1D54B",
				sansSerif: "1D5B3",
				sansSerifItalic: "1D61B",
				sansSerifItalicBold: "1D64F",
				sansSerifBold: "1D5E7",
				monospace: "1D683",
				smallCapital: "1D1B",
				fullwidth: "FF34"
			}, {
				combining: "036D",
				modifier: "1D57",
				subscript: "209C",
				italic: "1D461",
				italicBold: "1D495",
				bold: "1D42D",
				fraktur: "1D531",
				frakturBold: "1D599",
				script: "1D4C9",
				scriptBold: "1D4FD",
				doubleStruck: "1D565",
				sansSerif: "1D5CD",
				sansSerifItalic: "1D635",
				sansSerifItalicBold: "1D669",
				sansSerifBold: "1D601",
				monospace: "1D69D",
				fullwidth: "FF54"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_u", {
			unicode: ["0055", "0075"],
			alterations: [{
				modifier: "1D41",
				italic: "1D448",
				italicBold: "1D47C",
				bold: "1D414",
				fraktur: "1D518",
				frakturBold: "1D580",
				script: "1D4B0",
				scriptBold: "1D4E4",
				doubleStruck: "1D54C",
				sansSerif: "1D5B4",
				sansSerifItalic: "1D61C",
				sansSerifItalicBold: "1D650",
				sansSerifBold: "1D5E8",
				monospace: "1D684",
				smallCapital: "1D1C",
				fullwidth: "FF35"
			}, {
				combining: "0367",
				modifier: "1D58",
				subscript: "1D64",
				italic: "1D462",
				italicBold: "1D496",
				bold: "1D42E",
				fraktur: "1D532",
				frakturBold: "1D59A",
				script: "1D4CA",
				scriptBold: "1D4FE",
				doubleStruck: "1D566",
				sansSerif: "1D5CE",
				sansSerifItalic: "1D636",
				sansSerifItalicBold: "1D66A",
				sansSerifBold: "1D602",
				monospace: "1D69E",
				fullwidth: "FF55"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_v", {
			unicode: ["0056", "0076"],
			alterations: [{
				modifier: "2C7D",
				italic: "1D449",
				italicBold: "1D47D",
				bold: "1D415",
				fraktur: "1D519",
				frakturBold: "1D581",
				script: "1D4B1",
				scriptBold: "1D4E5",
				doubleStruck: "1D54D",
				sansSerif: "1D5B5",
				sansSerifItalic: "1D61D",
				sansSerifItalicBold: "1D651",
				sansSerifBold: "1D5E9",
				monospace: "1D685",
				smallCapital: "1D20",
				fullwidth: "FF36"
			}, {
				combining: "036E",
				modifier: "1D5B",
				subscript: "1D65",
				italic: "1D463",
				italicBold: "1D497",
				bold: "1D42F",
				fraktur: "1D533",
				frakturBold: "1D59B",
				script: "1D4CB",
				scriptBold: "1D4FF",
				doubleStruck: "1D567",
				sansSerif: "1D5CF",
				sansSerifItalic: "1D637",
				sansSerifItalicBold: "1D66B",
				sansSerifBold: "1D603",
				monospace: "1D69F",
				fullwidth: "FF56"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_w", {
			unicode: ["0057", "0077"],
			alterations: [{
				modifier: "1D42",
				italic: "1D44A",
				italicBold: "1D47E",
				bold: "1D416",
				fraktur: "1D51A",
				frakturBold: "1D582",
				script: "1D4B2",
				scriptBold: "1D4E6",
				doubleStruck: "1D54E",
				sansSerif: "1D5B6",
				sansSerifItalic: "1D61E",
				sansSerifItalicBold: "1D652",
				sansSerifBold: "1D5EA",
				monospace: "1D686",
				smallCapital: "1D21",
				fullwidth: "FF37"
			}, {
				combining: "1DF1",
				modifier: "02B7",
				italic: "1D464",
				italicBold: "1D498",
				bold: "1D430",
				fraktur: "1D534",
				frakturBold: "1D59C",
				script: "1D4CC",
				scriptBold: "1D500",
				doubleStruck: "1D568",
				sansSerif: "1D5D0",
				sansSerifItalic: "1D638",
				sansSerifItalicBold: "1D66C",
				sansSerifBold: "1D604",
				monospace: "1D6A0",
				fullwidth: "FF57"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_x", {
			unicode: ["0058", "0078"],
			alterations: [{
				italic: "1D44B",
				italicBold: "1D47F",
				bold: "1D417",
				fraktur: "1D51B",
				frakturBold: "1D583",
				script: "1D4B3",
				scriptBold: "1D4E7",
				doubleStruck: "1D54F",
				sansSerif: "1D5B7",
				sansSerifItalic: "1D61F",
				sansSerifItalicBold: "1D653",
				sansSerifBold: "1D5EB",
				monospace: "1D687",
				smallCapital: "0078",
				fullwidth: "FF38"
			}, {
				combining: "036F",
				modifier: "02E3",
				subscript: "2093",
				italic: "1D465",
				italicBold: "1D499",
				bold: "1D431",
				fraktur: "1D535",
				frakturBold: "1D59D",
				script: "1D4CD",
				scriptBold: "1D501",
				doubleStruck: "1D569",
				sansSerif: "1D5D1",
				sansSerifItalic: "1D639",
				sansSerifItalicBold: "1D66D",
				sansSerifBold: "1D605",
				monospace: "1D6A1",
				fullwidth: "FF58"
			}],
			options: { noCalc: True }
		},
		"lat_[c,s]_let_y", {
			unicode: ["0059", "0079"],
			alterations: [{
				italic: "1D44C",
				italicBold: "1D480",
				bold: "1D418",
				fraktur: "1D51C",
				frakturBold: "1D584",
				script: "1D4B4",
				scriptBold: "1D4E8",
				doubleStruck: "1D550",
				sansSerif: "1D5B8",
				sansSerifItalic: "1D620",
				sansSerifItalicBold: "1D654",
				sansSerifBold: "1D5EC",
				monospace: "1D688",
				smallCapital: "028F",
				fullwidth: "FF39"
			}, {
				modifier: "02B8",
				italic: "1D466",
				italicBold: "1D49A",
				bold: "1D432",
				fraktur: "1D536",
				frakturBold: "1D59E",
				script: "1D4CE",
				scriptBold: "1D502",
				doubleStruck: "1D56A",
				sansSerif: "1D5D2",
				sansSerifItalic: "1D63A",
				sansSerifItalicBold: "1D66E",
				sansSerifBold: "1D606",
				monospace: "1D6A2",
				fullwidth: "FF59"
			}],
			groups: [["Latin", "IPA"], ["Latin"]],
			tags: [["near-close near-front rounded vowel", "ненапряжённый огублённый гласный переднего ряда верхнего подъёма"], []],
			options: { noCalc: True, altLayoutKey: ["c*>! $", ""], showOnAlt: ["smallCapital", ""], layoutTitles: [True, False] },
		},
		"lat_[c,s]_let_z", {
			unicode: ["005A", "007A"],
			alterations: [{
				italic: "1D44D",
				italicBold: "1D481",
				bold: "1D419",
				fraktur: "2128",
				frakturBold: "1D585",
				script: "1D4B5",
				scriptBold: "1D4E9",
				doubleStruck: "2124",
				sansSerif: "1D5B9",
				sansSerifItalic: "1D621",
				sansSerifItalicBold: "1D655",
				sansSerifBold: "1D5ED",
				monospace: "1D689",
				smallCapital: "1D22",
				fullwidth: "FF3A"
			}, {
				combining: "1DE6",
				modifier: "1DBB",
				italic: "1D467",
				italicBold: "1D49B",
				bold: "1D433",
				fraktur: "1D537",
				frakturBold: "1D59F",
				script: "1D4CF",
				scriptBold: "1D503",
				doubleStruck: "1D56B",
				sansSerif: "1D5D3",
				sansSerifItalic: "1D63B",
				sansSerifItalicBold: "1D66F",
				sansSerifBold: "1D607",
				monospace: "1D6A3",
				fullwidth: "FF5A"
			}],
			options: { noCalc: True }
		},
		;
		;
		; * Default Cyrillic
		;
		;
		"cyr_[c,s]_let_a", {
			unicode: ["0410", "0430"],
			alterations: [{}, { combining: "2DF6", modifier: "1E030", subscript: "1E051" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_b", {
			unicode: ["0411", "0431"],
			alterations: [{}, { combining: "2DE0", modifier: "1E031", subscript: "1E052" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_v", {
			unicode: ["0412", "0432"],
			alterations: [{}, { combining: "2DE1", modifier: "1E032", subscript: "1E053" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_g", {
			unicode: ["0413", "0433"],
			alterations: [{}, { combining: "2DE2", modifier: "1E033", subscript: "1E054" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_d", {
			unicode: ["0414", "0434"],
			alterations: [{}, { combining: "2DE3", modifier: "1E034", subscript: "1E055" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ye", {
			unicode: ["0415", "0435"],
			alterations: [{}, { combining: "2DF7", modifier: "1E035", subscript: "1E056" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_zh", {
			unicode: ["0416", "0436"],
			alterations: [{}, { combining: "2DE4", modifier: "1E036", subscript: "1E057" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_z", {
			unicode: ["0417", "0437"],
			alterations: [{}, { combining: "2DE5", modifier: "1E037", subscript: "1E058" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_i", {
			unicode: ["0418", "0438"],
			alterations: [{}, { combining: "A675", modifier: "1E038", subscript: "1E059" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_k", {
			unicode: ["041A", "043A"],
			alterations: [{}, { combining: "2DE6", modifier: "1E039", subscript: "1E05A" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_l", {
			unicode: ["041B", "043B"],
			alterations: [{}, { combining: "2DE7", modifier: "1E03A", subscript: "1E05B" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_m", {
			unicode: ["041C", "043C"],
			alterations: [{}, { combining: "2DE8", modifier: "1E03B" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_n", {
			unicode: ["041D", "043D"],
			alterations: [{}, { combining: "2DE9", modifier: "1D78" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_o", {
			unicode: ["041E", "043E"],
			alterations: [{}, { combining: "2DEA", modifier: "1E03C", subscript: "1E05C" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_p", {
			unicode: ["041F", "043F"],
			alterations: [{}, { combining: "2DEB", modifier: "1E03D", subscript: "1E05D" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_r", {
			unicode: ["0420", "0440"],
			alterations: [{}, { combining: "2DEC", modifier: "1E03E" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_s", {
			unicode: ["0421", "0441"],
			alterations: [{}, { combining: "2DED", modifier: "1E03F", subscript: "1E05E" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_t", {
			unicode: ["0422", "0442"],
			alterations: [{}, { combining: "2DEE", modifier: "1E040" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_u", {
			unicode: ["0423", "0443"],
			alterations: [{}, { combining: "A677", modifier: "1E041", subscript: "1E05F" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_f", {
			unicode: ["0424", "0444"],
			alterations: [{}, { combining: "A69E", modifier: "1E042", subscript: "1E060" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_h", {
			unicode: ["0425", "0445"],
			alterations: [{}, { combining: "2DEF", modifier: "1E043", subscript: "1E061" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ts", {
			unicode: ["0426", "0446"],
			alterations: [{}, { combining: "2DF0", modifier: "1E044", subscript: "1E062" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ch", {
			unicode: ["0427", "0447"],
			alterations: [{}, { combining: "2DF1", modifier: "1E045", subscript: "1E063" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_sh", {
			unicode: ["0428", "0448"],
			alterations: [{}, { combining: "2DF2", modifier: "1E046", subscript: "1E064" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_shch", {
			unicode: ["0429", "0449"],
			alterations: [{}, { combining: "2DF3" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_yer", {
			unicode: ["042A", "044A"],
			alterations: [{}, { combining: "A678", modifier: "A69C", subscript: "1E065" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_yeri", {
			unicode: ["042C", "044C"],
			alterations: [{}, { combining: "A67A", modifier: "A69D" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_e", {
			unicode: ["042D", "044D"],
			alterations: [{}, { modifier: "1E048" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_yu", {
			unicode: ["042E", "044E"],
			alterations: [{}, { combining: "2DFB", modifier: "1E049" }],
			options: { noCalc: True },
		},
		"cyr_[c,s]_let_ya", {
			unicode: ["042F", "044F"],
			options: { noCalc: True },
		},
		;
		;
		; * Misc
		;
		;
		; ? None
		;
		;
		; * Spaces
		;
		;
		"space", {
			unicode: "0020",
			options: { noCalc: True },
			symbol: { category: "Spaces" },
		},
		"emsp", {
			unicode: "2003",
			tags: ["em space", "emspace", "emsp", "круглая шпация"],
			groups: ["Spaces"],
			options: { fastKey: ">+ Space" },
			symbol: { category: "Spaces" },
		},
		"ensp", {
			unicode: "2002",
			tags: ["en space", "enspace", "ensp", "полукруглая шпация"],
			groups: ["Spaces"],
			options: { fastKey: "<+ Space" },
			symbol: { category: "Spaces" },
		},
		"emsp13", {
			unicode: "2004",
			tags: ["emsp13", "1/3emsp", "1/3 круглой Шпации"],
			groups: ["Spaces", "Spaces Left Alt"],
			options: { fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"emsp14", {
			unicode: "2005",
			tags: ["emsp14", "1/4emsp", "1/4 круглой Шпации"],
			groups: ["Spaces", "SK Spaces Left Alt"],
			options: { fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"thinspace", {
			unicode: "2009",
			tags: ["thinsp", "thin space", "узкий пробел", "тонкий пробел"],
			groups: ["Spaces"],
			options: { fastKey: "<! Space" },
			symbol: { category: "Spaces" },
		},
		"emsp16", {
			unicode: "2006",
			tags: ["emsp16", "1/6emsp", "1/6 круглой Шпации"],
			groups: ["Spaces", "Spaces Right Shift"],
			options: { fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"narrow_no_break_space", {
			unicode: "202F", LaTeX: ["\,"],
			tags: ["nnbsp", "narrow no-break space", "узкий неразрывный пробел", "тонкий неразрывный пробел"],
			groups: ["Spaces", "Spaces Right Shift"],
			options: { fastKey: "<+ Space" },
			symbol: { category: "Spaces" },
		},
		"hairspace", {
			unicode: "200A",
			tags: ["hsp", "hairsp", "hair space", "волосяная шпация"],
			groups: ["Spaces"],
			options: { fastKey: "<!<+ Space" },
			symbol: { category: "Spaces" },
		},
		"punctuation_space", {
			unicode: "2008",
			tags: ["psp", "puncsp", "punctuation space", "пунктуационный пробел"],
			groups: ["Spaces"],
			options: { fastKey: "<!>+ Space" },
			symbol: { category: "Spaces" },
		},
		"zero_width_space", {
			unicode: "200B",
			tags: ["zwsp", "zero-width space", "пробел нулевой ширины"],
			groups: ["Spaces"],
			options: { fastKey: ">^ Space" },
			symbol: { category: "Spaces" },
		},
		"zero_width_no_break_space", {
			unicode: "FEFF",
			tags: ["zwnbsp", "zero-width no-break space", "неразрывный пробел нулевой ширины"],
			groups: ["Spaces", "Spaces Primary"],
			options: { fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"figure_space", {
			unicode: "2007",
			tags: ["nsp", "numsp", "figure space", "цифровой пробел"],
			groups: ["Spaces"],
			options: { fastKey: "<+>+ Space" },
			symbol: { category: "Spaces" },
		},
		"no_break_space", {
			unicode: "00A0", LaTeX: ["~"],
			tags: ["nbsp", "no-break space", "неразрывный пробел"],
			groups: ["Spaces"],
			options: { fastKey: "Space" },
			symbol: { category: "Spaces" },
		},
		"medium_math_space", {
			unicode: "205F",
			tags: ["mmsp", "mathsp", "medium math space", "средний математический пробел"],
			groups: ["Spaces", "Math Spaces"],
			options: { altLayoutKey: "<! Space" },
			symbol: { category: "Spaces" },
		},
		"tabulation", {
			unicode: "0009",
			tags: ["tab", "tabulation", "табуляция"],
			groups: ["Spaces"],
			options: { noCalc: True },
			symbol: { category: "Spaces" },
		},
		"emquad", {
			unicode: "2001", LaTeX: ["\qquad"],
			tags: ["em quad", "emquad", "emqd", "em-квадрат"],
			groups: ["Spaces", "SK Spaces Secondary"],
			options: { fastKey: ">+ Space" },
			symbol: { category: "Spaces" },
		},
		"enquad", {
			unicode: "2000", LaTeX: ["\quad"],
			tags: ["en quad", "enquad", "enqd", "en-квадрат"],
			groups: ["Spaces", "SK Spaces Secondary"],
			options: { fastKey: "<+ Space" },
			symbol: { category: "Spaces" },
		},
		"word_joiner", {
			unicode: "2060",
			tags: ["wj", "word joiner", "соединитель слов"],
			groups: ["Format Characters"],
			options: { fastKey: "<+ Tab" },
			symbol: { category: "Format Character" },
		},
		"zero_width_joiner", {
			unicode: "200D",
			tags: ["zwj", "zero-width joiner", "соединитель нулевой ширины"],
			groups: ["Format Characters"],
			options: { fastKey: "Tab" },
			symbol: { category: "Format Character" },
		},
		"zero_width_non_joiner", {
			unicode: "200C",
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
			unicode: "000D",
			tags: ["carriage return", "возврат каретки"],
			groups: ["Sys Group"],
			symbol: { set: Chr(0x21B5) },
		},
		"new_line", {
			unicode: "000A",
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
			unicode: "2190",
			tags: ["left arrow", "стрелка влево"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2190) },
			recipe: ["<-"],
		},
		"arrow_right", {
			unicode: "2192",
			tags: ["right arrow", "стрелка вправо"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2192) },
			recipe: ["->"],
		},
		"arrow_up", {
			unicode: "2191",
			tags: ["up arrow", "стрелка вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) },
		},
		"arrow_down", {
			unicode: "2193",
			tags: ["down arrow", "стрелка вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2193) },
		},
		"arrow_leftup", {
			unicode: "2196",
			tags: ["left up arrow", "стрелка влево-вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) " " Chr(0x2190) },
		},
		"arrow_rightup", {
			unicode: "2197",
			tags: ["right up arrow", "стрелка вправо-вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) " " Chr(0x2192) },
		},
		"arrow_leftdown", {
			unicode: "2199",
			tags: ["left down arrow", "стрелка влево-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2193) " " Chr(0x2190) },
		},
		"arrow_rightdown", {
			unicode: "2198",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2193) " " Chr(0x2192) },
		},
		"arrow_leftright", {
			unicode: "2194",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2190) " " Chr(0x2192) },
		},
		"arrow_updown", {
			unicode: "2195",
			tags: ["right down arrow", "стрелка вправо-вниз"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Chr(0x2191) " " Chr(0x2193) },
		},
		"arrow_left_pair", {
			unicode: "2B84",
			tags: ["left paired arrows", "парные стрелки влево"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_left×2}"],
		},
		"arrow_right_pair", {
			unicode: "2B86",
			tags: ["right paired arrows", "парные стрелки вправо"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_right×2}"],
		},
		"arrow_up_pair", {
			unicode: "2B85",
			tags: ["up paired arrows", "парные стрелки вверх"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_up×2}"],
		},
		"arrow_down_pair", {
			unicode: "2B87",
			tags: ["down paired arrows", "парные стрелки вниз"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_down×2}"],
		},
		"arrow_left_right_pair", {
			unicode: "2B80",
			tags: ["left arrow over right arrow", "парные стрелки влево-вправо"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_left}${arrow_right}"],
		},
		"arrow_right_left_pair", {
			unicode: "2B82",
			tags: ["right arrow over left arrow", "парные стрелки вправо-влево"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_right}${arrow_left}"],
		},
		"arrow_up_down_pair", {
			unicode: "2B81",
			tags: ["up arrow leftwards of down arrow", "парные стрелки вверх-вниз"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_up}${arrow_down}"],
		},
		"arrow_down_up_pair", {
			unicode: "2B83",
			tags: ["down arrow leftwards of up arrow", "парные стрелки вниз-вверх"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_down}${arrow_up}"],
		},
		"arrow_left_triple", {
			unicode: "2B31",
			tags: ["left triple arrows", "тройные стрелки влево"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_left×3}", "${arrow_left_pair}${arrow_left}"],
		},
		"arrow_right_triple", {
			unicode: "21F6",
			tags: ["right triple arrows", "тройные стрелки вправо"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_right×3}", "${arrow_right_pair}${arrow_right}"],
		},
		"arrow_left_dashed", {
			unicode: "2B6A",
			tags: ["left dashed arrow", "пунктирная стрелка влево"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["-${arrow_left}"],
		},
		"arrow_right_dashed", {
			unicode: "2B6C",
			tags: ["right dashed arrow", "пунктирная стрелка вправо"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["-${arrow_right}"],
		},
		"arrow_up_dashed", {
			unicode: "2B6B",
			tags: ["up dashed arrow", "пунктирная стрелка вверх"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["-${arrow_up}"],
		},
		"arrow_down_dashed", {
			unicode: "2B6D",
			tags: ["down dashed arrow", "пунктирная стрелка вниз"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["-${arrow_down}"],
		},
		"arrow_left_dotted", {
			unicode: "2B38",
			tags: ["left dotted arrow", "точечная стрелка влево"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: [".${arrow_left}"],
		},
		"arrow_right_dotted", {
			unicode: "2911",
			tags: ["right dotted arrow", "точечная стрелка вправо"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: [".${arrow_right}"],
		},
		"arrow_down_zigzag", {
			unicode: "21AF",
			tags: ["down zigzag arrow", "зигзагообразная стрелка вниз"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_down}${arrow_right}${arrow_down}"],
		},
		"arrow_down_zigzag_2", {
			unicode: "2B4D",
			tags: ["down zigzag arrow-2", "зигзагообразная стрелка вниз-2"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["${arrow_down}${arrow_right}${arrow_down}2"],
		},
		"arrow_left_to_bar", {
			unicode: "2B70",
			tags: ["left arrow to bar", "стрелка влево ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_left}"],
		},
		"arrow_right_to_bar", {
			unicode: "2B72",
			tags: ["right arrow to bar", "стрелка вправо ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_right}"],
		},
		"arrow_up_to_bar", {
			unicode: "2B71",
			tags: ["up arrow to bar", "стрелка вверх ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_up}"],
		},
		"arrow_down_to_bar", {
			unicode: "2B73",
			tags: ["down arrow to bar", "стрелка вниз ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_down}"],
		},
		"arrow_leftup_to_bar", {
			unicode: "2B76",
			tags: ["left up arrow to bar", "стрелка влево-вверх ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_leftup}"],
		},
		"arrow_rightup_to_bar", {
			unicode: "2B77",
			tags: ["right up arrow to bar", "стрелка вправо-вверх ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_rightup}"],
		},
		"arrow_leftdown_to_bar", {
			unicode: "2B79",
			tags: ["left down arrow to bar", "стрелка влево-вниз ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_leftdown}"],
		},
		"arrow_rightdown_to_bar", {
			unicode: "2B78",
			tags: ["right down arrow to bar", "стрелка вправо-вниз ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_rightdown}"],
		},
		"arrow_downup_to_bar", {
			unicode: "2B7F",
			tags: ["down up arrow to bar", "стрелка вниз-вверх ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_down}${arrow_up}", "|${arrow_down_up_pair}", "${arrow_down_to_bar}${arrow_up_to_bar}"],
		},
		"arrow_leftright_to_bar", {
			unicode: "2B7E",
			tags: ["left right arrow to bar", "стрелка влево-вправо ко штриху"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["|${arrow_left}${arrow_right}", "|${arrow_left_right_pair}", "${arrow_left_to_bar}${arrow_right_to_bar}"],
		},
		"arrow_left_circle", {
			unicode: "21BA",
			tags: ["left circle arrow", "округлая стрелка влево"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: ">+ " Chr(0x2190) },
		},
		"arrow_right_circle", {
			unicode: "21BB",
			tags: ["right circle arrow", "округлая стрелка вправо"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: ">+ " Chr(0x2192) },
		},
		"arrow_left_ushaped", {
			unicode: "2B8C",
			tags: ["left u-arrow", "u-образная стрелка влево"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Chr(0x2190) },
		},
		"arrow_right_ushaped", {
			unicode: "2B8E",
			tags: ["right u-arrow", "u-образная стрелка вправо"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Chr(0x2192) },
		},
		"arrow_up_ushaped", {
			unicode: "2B8D",
			tags: ["up u-arrow", "u-образная стрелка вверх"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Chr(0x2190) },
		},
		"arrow_down_ushaped", {
			unicode: "2B8F",
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
		"trill", { proxy: "arrow_up",
			groups: [], options: { noCalc: True },
		},
		;
		;
		; * Various
		;
		;
		"asterisk", {
			unicode: "002A",
			alterations: {
				small: "FE61",
				fullwidth: "FF0A"
			},
			options: { noCalc: True },
		},
		"asterisk_low", {
			unicode: "204E",
			tags: ["low asterisk", "нижний астериск"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ NumMult" },
			recipe: ["${asterisk}${arrow_down}"],
		},
		"asterisk_two", {
			unicode: "2051",
			tags: ["two asterisks", "два астериска"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "NumMult" },
			recipe: ["${asterisk×2}", "2*"],
		},
		"asterism", {
			unicode: "2042",
			tags: ["asterism", "астеризм"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: ">+ NumMult" },
			recipe: ["${asterisk×3}", "3*"],
		},
		"bullet", {
			unicode: "2022",
			tags: ["bullet", "булит"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: Backquote },
		},
		"bullet_hyphen", {
			unicode: "2043",
			tags: ["hyphen bullet", "чёрточный булит"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<! " Backquote },
		},
		"interpunct", {
			unicode: "00B7",
			tags: ["middle dot", "точка по центру", "интерпункт"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "<+ " Backquote },
		},
		"bullet_white", {
			unicode: "25E6",
			tags: ["white bullet", "прозрачный булит"],
			groups: ["Special Fast Secondary"],
			options: { fastKey: "<!>+ " Backquote },
		},
		"bullet_triangle", {
			unicode: "2023",
			tags: ["triangular bullet", "треугольный булит"],
			groups: ["Special Fast Secondary"],
			options: { fastKey: "<!<+ " Backquote },
		},
		"hyphenation_point", {
			unicode: "2027",
			tags: ["hyphenation point", "точка переноса"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: ">+ -" },
		},
		"colon_triangle", {
			unicode: "02D0",
			tags: ["triangle colon", "знак долготы"],
			groups: ["Special Characters", "IPA"],
			options: { altLayoutKey: ";" },
		},
		"colon_triangle_half", {
			unicode: "02D1",
			tags: ["half triangle colon", "знак полудолготы"],
			groups: ["Special Characters", "IPA"],
			options: { altLayoutKey: ">! `;" },
		},
		"degree", {
			unicode: "00B0",
			tags: ["degree", "градус"],
			groups: ["Special Characters", "Special Fast Left"],
			options: { fastKey: "D" },
		},
		"celsius", {
			unicode: "2103",
			tags: ["celsius", "градус Цельсия"],
			groups: ["Special Characters", "Smelting Special", "Special Right Shift"],
			options: { fastKey: "C" },
			recipe: ["${degree}C"],
		},
		"fahrenheit", {
			unicode: "2109",
			tags: ["fahrenheit", "градус по Фаренгейту"],
			groups: ["Special Characters", "Smelting Special", "Special Right Shift"],
			options: { fastKey: "F" },
			recipe: ["${degree}F"],
		},
		"kelvin", {
			unicode: "212A",
			tags: ["kelvin", "Кельвин"],
			groups: ["Special Characters", "Smelting Special", "Special Right Shift"],
			options: { fastKey: "K" },
			recipe: ["${degree}K"],
		},
		"rankine", {
			unicode: "0052",
			sequence: ["00B0", "0052"],
			options: { noCalc: True },
		},
		"newton", {
			unicode: "004E",
			sequence: ["00B0", "004E"],
			options: { noCalc: True },
		},
		"delisle", {
			unicode: "0044",
			sequence: ["00B0", "0044"],
			options: { noCalc: True },
		},
		"dagger", {
			unicode: "2020", LaTeX: ["\dagger"],
			tags: ["dagger", "даггер", "крест"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: "NumDiv" },
		},
		"dagger_double", {
			unicode: "2021", LaTeX: ["\ddagger"],
			tags: ["double dagger", "двойной даггер", "двойной крест"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: ">+ NumDiv" },
			recipe: ["${dagger×2}"],
		},
		"dagger_tripple", {
			unicode: "2E4B",
			tags: ["tripple dagger", "тройной даггер", "тройной крест"],
			groups: ["Special Characters"],
			options: { fastKey: "<! NumDiv" },
			recipe: ["${dagger×3}", "${dagger_double}${dagger}"],
		},
		"fraction_slash", {
			unicode: "2044",
			tags: ["fraction slash", "форматирующий символ дроби", "дробная черта"],
			groups: ["Special Characters", "Special Fast Secondary"],
			options: { fastKey: ">+ /" },
		},
		"grapheme_joiner", {
			unicode: "034F",
			tags: ["grapheme joiner", "соединитель графем"],
			groups: ["Special Characters"],
			options: { fastKey: "\" },
		},
		"dotted_circle", {
			unicode: "25CC",
			tags: ["пунктирный круг", "dotted circle"],
			groups: ["Special Fast Primary"],
			options: { fastKey: "Num0" },
		},
		"ellipsis", {
			unicode: "2026",
			tags: ["ellipsis", "многоточие"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "/ ." },
			recipe: ["..."],
		},
		"two_dot_leader", {
			unicode: "2025",
			tags: ["two dot leader", "двухточечный пунктир"],
			groups: ["Smelting Special"],
			recipe: ["/.."],
		},
		"two_dot_punctuation", {
			unicode: "205A",
			tags: ["two dot punctuation", "двухточечная пунктуация"],
			groups: ["Smelting Special", "Special Fast Left"],
			options: { fastKey: "/ ." },
			recipe: [".."],
		},
		"tricolon", {
			unicode: "205D",
			tags: ["tricolon", "троеточие"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ / ." },
			recipe: [":↑."],
		},
		"quartocolon", {
			unicode: "205E",
			tags: ["vertical four dots", "четвероточие"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+>+ / ." },
			recipe: [":↑:"],
		},
		"reference_mark", {
			unicode: "203B",
			tags: ["reference mark", "знак сноски", "komejirushi", "комэдзируси"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["..×..", ":×:"],
		},
		"numero_sign", {
			unicode: "2116",
			tags: ["numero sign", "знак номера"],
			groups: ["Smelting Special"],
			recipe: ["no"],
		},
		"number_sign", {
			unicode: "0023",
			alterations: {
				small: "FE5F",
				fullwidth: "FF03"
			},
			options: { noCalc: True, send: "Text" },
		},
		"section", {
			unicode: "00A7", LaTeX: ["\S"],
			tags: ["section", "параграф"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Left"],
			options: { fastKey: "1" },
			recipe: ["sec", "пар"],
		},
		"comma", {
			unicode: "002C",
			alterations: {
				small: "FE50",
				fullwidth: "FF0C"
			},
			options: { noCalc: True },
		},
		"dot", {
			unicode: "002E",
			alterations: {
				small: "FE52",
				fullwidth: "FF0E"
			},
			options: { noCalc: True },
		},
		"exclamation", {
			unicode: "0021",
			alterations: {
				modifier: "A71D",
				small: "FE57",
				fullwidth: "FF01"
			},
			options: { noCalc: True, send: "Text" },
		},
		"question", {
			unicode: "003F",
			alterations: {
				small: "FE56",
				fullwidth: "FF1F"
			},
			options: { noCalc: True },
		},
		"reversed_question", {
			unicode: "2E2E",
			tags: ["reversed ?", "обратный ?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<! 7" },
			recipe: ["${arrow_left_ushaped}?"],
		},
		"inverted_exclamation", {
			unicode: "00A1",
			alterations: { modifier: "A71E", subscript: "A71F" },
			tags: ["inverted !", "перевёрнутый !"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "1" },
			recipe: ["${arrow_down_ushaped}!"],
		},
		"inverted_question", {
			unicode: "00BF",
			tags: ["inverted ?", "перевёрнутый ?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "7" },
			recipe: ["${arrow_down_ushaped}?"],
		},
		"double_exclamation", {
			unicode: "203C",
			tags: ["double !", "двойной !"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "c*>+ 1" },
			recipe: ["!!"],
		},
		"double_exclamation_question", {
			unicode: "2049",
			tags: ["blended !?", "смешанный !?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ 1" },
			recipe: ["!?"],
		},
		"double_question", {
			unicode: "2047",
			tags: ["double ?", "двойной ?"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "c*>+ 7" },
			recipe: ["??"],
		},
		"double_question_exclamation", {
			unicode: "2048",
			tags: ["blended ?!", "смешанный ?!"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ 7" },
			recipe: ["?!"],
		},
		"interrobang", {
			unicode: "203D",
			tags: ["interrobang", "интерробанг", "лигатура !?", "ligature !?"],
			groups: ["Smelting Special", "Special Fast RShift"],
			options: { fastKey: "1" },
			recipe: ["!+?"],
		},
		"interrobang_inverted", {
			unicode: "2E18",
			tags: ["inverted interrobang", "перевёрнутый интерробанг", "лигатура перевёрнутый !?", "ligature inverted !?"],
			groups: ["Smelting Special", "Special Fast RShift"],
			options: { fastKey: "c* 1" },
			recipe: ["${arrow_down_ushaped}${interrobang}", "${arrow_down_ushaped}!+?"],
		},
		"grave_accent", {
			unicode: "0060",
			alterations: {
				modifier: "02CB",
				fullwidth: "FF40"
			},
			options: { noCalc: True },
		},
		"circumflex_accent", {
			unicode: "005E",
			alterations: {
				modifier: "02C6",
				fullwidth: "FF3E"
			},
			options: { noCalc: True, send: "Text" },
		},
		"semicolon", {
			unicode: "003B",
			alterations: {
				small: "FE54",
				fullwidth: "FF1B"
			},
			options: { noCalc: True },
		},
		"colon", {
			unicode: "003A",
			alterations: {
				small: "FE55",
				fullwidth: "FF1A"
			},
			options: { noCalc: True },
		},
		"apostrophe", {
			unicode: "0027",
			alterations: {
				modifier: "02BC",
				fullwidth: "FF07"
			},
			groups: ["IPA"],
			options: { noCalc: True, altLayoutKey: ">+ '", showOnAlt: "modifier", layoutTitles: True },
		},
		"quote", {
			unicode: "0022",
			alterations: {
				modifier: "02EE",
				fullwidth: "FF02"
			},
			options: { noCalc: True },
		},
		"solidus", {
			unicode: "002F",
			alterations: {
				fullwidth: "FF0F"
			},
			options: { noCalc: True, send: "Text" },
		},
		"reverse_solidus", {
			unicode: "005C",
			alterations: {
				small: "FE68",
				fullwidth: "FF3C"
			},
			options: { noCalc: True, send: "Text" },
		},
		"vertical_line", {
			unicode: "007C",
			alterations: {
				fullwidth: "FF5C"
			},
			options: { noCalc: True, send: "Text" },
		},
		"commercial_at", {
			unicode: "0040",
			alterations: {
				small: "FE6B",
				fullwidth: "FF20"
			},
			options: { noCalc: True },
		},
		;
		;
		; * Dashes
		;
		;
		"emdash", {
			unicode: "2014", LaTeX: ["---"],
			alterations: { small: "FE58" },
			tags: ["em dash", "длинное тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "-" },
			recipe: ["---"],
		},
		"emdash_vertical", {
			unicode: "FE31",
			tags: ["vertical em dash", "вертикальное длинное тире"],
			groups: ["Smelting Special"],
			recipe: ["${arrow_down_ushaped}${emdash}"],
		},
		"endash", {
			unicode: "2013",
			tags: ["en dash", "короткое тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ -" },
			recipe: ["--"],
		},
		"endash_vertical", {
			unicode: "FE32",
			tags: ["vertical en dash", "вертикальное короткое тире"],
			groups: ["Smelting Special"],
			recipe: ["${arrow_down_ushaped}${endash}"],
		},
		"three_emdash", {
			unicode: "2E3B",
			tags: ["three-em dash", "тройное тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Left"],
			options: { fastKey: "-" },
			recipe: ["-----", "${emdash×3}"],
		},
		"two_emdash", {
			unicode: "2E3A",
			tags: ["two-em dash", "двойное тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Left"],
			options: { fastKey: "c* -" },
			recipe: ["----", "${emdash×2}"],
		},
		"softhyphen", {
			unicode: "00AD",
			tags: ["soft hyphen", "мягкий перенос"],
			groups: ["Dashes", "Smelting Special", "Special Fast Primary"],
			options: { fastKey: "-" },
			recipe: [".-"],
		},
		"figure_dash", {
			unicode: "2012",
			tags: ["figure dash", "цифровое тире"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<!>+ -" },
			recipe: ["n-"],
		},
		"hyphen", {
			unicode: "2010",
			tags: ["hyphen", "дефис"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<! -" },
			recipe: ["1-"],
		},
		"no_break_hyphen", {
			unicode: "2011",
			tags: ["no-break hyphen", "неразрывный дефис"],
			groups: ["Dashes", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<!<+ -" },
			recipe: ["0-"],
		},
		"horbar", {
			unicode: "2015",
			tags: ["horbar", "горизонтальная черта"],
			groups: ["Smelting Special"],
			recipe: ["h-"],
		},
		"hyphen_minus", {
			unicode: "002D",
			alterations: {
				small: "FE63",
				fullwidth: "FF0D"
			},
			options: { noCalc: True },
		},
		"underscore", {
			unicode: "005F",
			alterations: {
				fullwidth: "FF3F"
			},
			options: { noCalc: True },
		},
		"inverted_lazy_s", {
			unicode: "223E",
			tags: ["inverted lazy s", "перевёрнутая плавная s"],
			groups: ["Special Characters", "Smelting Special"],
			recipe: ["s${arrow_right_circle}"],
		},
		"prime_[single,double,triple,quadruple]", {
			unicode: [
				"2032",
				"2033",
				"2034",
				"2057",
			],
			alterations: [{ modifier: "02B9" }, { modifier: "02BA" }, {}, {}],
			tags: [
				["prime", "штрих"],
				["double prime", "двойной штрих"],
				["triple prime", "тройной штрих"],
				["quadruple prime", "четверной штрих"],
			],
			groups: ["Smelting Special", "Special Characters", "Special Fast Secondary"],
			options: {
				fastKey: [
					"3",
					">+ 3",
					"<+ 3",
					"<+>+ 3",
				],
			},
			recipe: [
				[],
				["${prime_single×2}"],
				["${prime_single×3}", "${prime_double}${prime_single}"],
				["${prime_single×4}", "${prime_double×2}", "${prime_triple}${prime_single}"],
			],
		},
		"prime_[single,double,triple]_reversed", {
			unicode: [
				"2035",
				"2036",
				"2037",
			],
			tags: [
				["reversed prime", "обратный штрих"],
				["reversed double prime", "обратный двойной штрих"],
				["reversed triple prime", "обратный тройной штрих"],
			],
			groups: ["Smelting Special", "Special Characters", "Special Fast Secondary"],
			options: {
				fastKey: [
					"c*3",
					"c*>+ 3",
					"c*<+ 3",
				],
			},
			recipe: [
				[],
				["${prime_single_reversed×2}"],
				["${prime_single_reversed×3}", "${prime_double_reversed}${prime_single_reversed}"],
			],
		},
		;
		;
		; * Miscellaneous Technical
		;
		;
		"benzene", {
			unicode: "232C",
			tags: ["benzene", "бензол"],
			groups: ["Miscellaneous Technical"],
			recipe: ["C${digit_6::subscript}H${digit_6::subscript}", "C6H6"],
		},
		;
		;
		; * Quotation Marks
		;
		;
		"quote_angle_[left,right,left_double,right_double]", {
			unicode: [
				"2039",
				"203A",
				"00AB",
				"00BB"
			],
			tags: [
				["left guillemet", "левая кавычка ёлочка"],
				["right guillemet", "правая кавычка ёлочка"],
				["left guillemets", "левая двойная кавычка ёлочка"],
				["right guillemets", "правая двойная кавычка ёлочка"]
			],
			groups: ["Quotes", "Smelting Special", "Special Fast Secondary"],
			options: {
				fastKey: [
					"<!<+ < Б",
					"<!<+ > Ю",
					"<! > | Б",
					"<! < | Ю",
				]
			},
			recipe: [
				["`"<"],
				["`">"],
				["`"<<", "${quote_angle_left×2}"],
				["`">>", "${quote_angle_right×2}"]
			],
		},
		"quote_[left,right,left_double,right_double,low_9,low_9_double,low_9_double_reversed]", {
			unicode: [
				"2018",
				"2019",
				"201C",
				"201D",
				"201A",
				"201E",
				"2E42",
			],
			tags: [
				["left quote", "левая кавычка"],
				["right quote", "правая кавычка"],
				["left quotes", "левая двойная кавычка"],
				["right quotes", "правая двойная кавычка"],
				["low-9 quote", "нижняя кавычка"],
				["low-9 quotes", "нижняя двойная кавычка"],
				["low-9 reversed quotes", "нижняя развёрнутая двойная кавычка"],
			],
			groups: ["Quotes", "Smelting Special", "Special Fast Secondary"],
			options: {
				fastKey: [
					"<+ <",
					"<+ > | >+ `` Ё",
					"< | <! Б | <+ Ю",
					"> | <! Ю",
					"<+>+ < Б",
					">+ < Б",
					">+ > Ю",
				]
			},
			recipe: [
				["`"'${arrow_left}"],
				["`"'${arrow_right}"],
				["`"`"${arrow_left}", "${quote_left×2}"],
				["`"`"${arrow_right}", "${quote_right×2}"],
				["`"'${arrow_down}", "${quote_right}${arrow_down}"],
				["`"`"${arrow_down}", "${quote_right×2}${arrow_down}", "${quote_right_double}${arrow_down}"],
				["`"`"${arrow_down}${arrow_left_ushaped}", "${quote_right×2}${arrow_down}${arrow_left_ushaped}", "${quote_low_9_double}${arrow_left_ushaped}"],
			],
		},
		"quote_left_double_ghost_ru", {
			proxy: "quote_low_9_double",
			tags: ["left paw quotes", "левая кавычка-лапка"],
			groups: ["Quotes", "Smelting Special", "Special Fast Secondary"],
			options: { noCalc: True, fastKey: "<+ Б" }
		},
		"quote_right_double_ghost_ru", {
			proxy: "quote_left_double",
			tags: ["right paw quotes", "правая кавычка-лапка"],
			groups: ["Quotes", "Smelting Special", "Special Fast Secondary"],
			options: { noCalc: True, fastKey: "<+ Ю" }
		},
		;
		;
		; * Mathematical Factions
		;
		;
		"vulgar_fraction_zero_[thirds]", {
			unicode: ["2189"],
			tagsPrefixes: ["vulgar fraction zero ", "дробь нуль "],
			tags: [
				["thirds", "трети"]
			],
			groups: ["Smelting Special"],
			recipePrefixes: ["0/"],
			recipe: [["3"]],
		},
		"vulgar_fraction_one_[half,third,quarter,fifth,sixth,seventh,eighth,ninth,tenth]", {
			unicode: [
				"00BD",
				"2153",
				"00BC",
				"2155",
				"2159",
				"2150",
				"215B",
				"2151",
				"2152",
			],
			tagsPrefixes: ["vulgar fraction one ", "дробь одна "],
			tags: [
				["half", "вторая"],
				["third", "треть"],
				["quarter", "четверть"],
				["fifth", "пятая"],
				["sixth", "шестая"],
				["seventh", "седьмая"],
				["eighth", "восьмая"],
				["ninth", "девятая"],
				["tenth", "десятая"],
			],
			groups: ["Smelting Special"],
			recipePrefixes: ["1/"],
			recipe: [["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"]],
		},
		"vulgar_fraction_two_[thirds,fifths]", {
			unicode: ["2154", "2156"],
			tagsPrefixes: ["vulgar fraction two ", "дробь две "],
			tags: [
				["thirds", "трети"],
				["fifths", "пятых"],
			],
			groups: ["Smelting Special"],
			recipePrefixes: ["2/"],
			recipe: [["3"], ["5"]],
		},
		"vulgar_fraction_three_[quarters,fifths,eighths]", {
			unicode: ["00BE", "2157", "215C"],
			tagsPrefixes: ["vulgar fraction three ", "дробь три "],
			tags: [
				["quarters", "четвёртых"],
				["fifths", "пятых"],
				["eights", "восьмых"],
			],
			groups: ["Smelting Special"],
			recipePrefixes: ["3/"],
			recipe: [["4"], ["5"], ["8"]],
		},
		"vulgar_fraction_four_[fifths]", {
			unicode: ["2158"],
			tagsPrefixes: ["vulgar fraction four ", "дробь четыре "],
			tags: [
				["fifths", "пятых"],
			],
			groups: ["Smelting Special"],
			recipePrefixes: ["4/"],
			recipe: [["5"]],
		},
		"vulgar_fraction_five_[sixths,eighths]", {
			unicode: ["215A", "215D"],
			tagsPrefixes: ["vulgar fraction five ", "дробь пять "],
			tags: [
				["sixths", "шестых"],
				["eighths", "восьмых"],
			],
			groups: ["Smelting Special"],
			recipePrefixes: ["5/"],
			recipe: [["6"], ["8"]],
		},
		"vulgar_fraction_seven_[eighths]", {
			unicode: ["215E"],
			tagsPrefixes: ["vulgar fraction seven ", "дробь семь "],
			tags: [
				["eighths", "восьмых"],
			],
			groups: ["Smelting Special"],
			recipePrefixes: ["7/"],
			recipe: [["8"]],
		},
		"fraction_numerator_one", {
			unicode: "215F",
			tags: ["fraction numerator one", "дробный числитель один"],
			groups: ["Smelting Special"],
			recipe: ["1//"],
		},
		;
		;
		; * Mathematical Symbols
		;
		;
		"asterisk_operator", {
			unicode: "2217",
			tags: ["оператор астериск", "asterisk operator"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Left"],
			options: { fastKey: "NumDiv" },
			recipe: ["^*"],
		},
		"bullet_operator", {
			unicode: "2219",
			tags: ["оператор буллит", "bullet operator"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Left"],
			options: { fastKey: "<+ NumDiv" },
			recipe: ["^."],
		},
		"infinity", {
			unicode: "221E",
			tags: ["infinity", "бесконечность"],
			groups: ["Special Characters"],
			options: { fastKey: "<! 8" },
		},
		"empty_set", {
			unicode: "2205",
			tags: ["пустое множество", "empty set"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "Num0" },
			recipe: ["0/"],
		},
		"percent", {
			unicode: "0025",
			alterations: {
				small: "FE6A",
				fullwidth: "FF05"
			},
			options: { noCalc: True },
		},
		"permille", {
			unicode: "2030",
			LaTeX: ["\permil"],
			LaTeXPackage: "wasysym",
			tags: ["per mille", "промилле"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "5" },
			recipe: ["${percent}0"],
		},
		"pertenthousand", {
			unicode: "2031",
			LaTeX: ["\textpertenthousand"],
			LaTeXPackage: "textcomp",
			tags: ["per ten thousand", "промилле", "basis point", "базисный пункт"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<+ 5" },
			recipe: ["${percent}00", "${permille}0"],
		},
		"equals", {
			unicode: "003D",
			alterations: {
				superscript: "207C",
				subscript: "208C",
				small: "FE66",
				fullwidth: "FF1D"
			},
			options: { noCalc: True },
		},
		"noequals", {
			unicode: "2260",
			tags: ["no equals", "не равно"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "=" },
			recipe: ["/="],
		},
		"almostequals", {
			unicode: "2248",
			tags: ["almost equals", "примерно равно"],
			groups: ["Smelting Special", "Special Fast Secondary"],
			options: { fastKey: "<! =" },
			recipe: ["~="],
		},
		"plus", {
			unicode: "002B",
			alterations: {
				modifier: "02D6",
				superscript: "207A",
				subscript: "208A",
				small: "FE62",
				fullwidth: "FF0B"
			},
			options: { noCalc: True, send: "Text" },
		},
		"minus", {
			unicode: "2212",
			alterations: {
				superscript: "02D7",
				superscript: "207B",
				subscript: "208B"
			},
			tags: ["minus", "минус"],
			groups: ["Dashes", "Smelting Special", "Special Fast Primary", "Special Combinations"],
			options: { altSpecialKey: "NumSub", fastKey: "<+ -" },
			recipe: ["min"],
		},
		"minusdot", {
			unicode: "2213",
			tags: ["dot minus", "минус с точкой"],
			groups: ["Smelting Special"],
			recipe: ["-."],
		},
		"plusminus", {
			unicode: "00B1",
			tags: ["plus minus", "плюс-минус"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Combinations"],
			options: { altSpecialKey: "NumSub NumAdd", fastKey: "<+ =" },
			recipe: ["+-", "${plus}${minus}"],
		},
		"minusplus", {
			unicode: "2213",
			tags: ["minus plus", "минус-плюс"],
			groups: ["Special Characters", "Smelting Special", "Special Combinations"],
			options: { altSpecialKey: "NumAdd NumSub" },
			recipe: ["-+", "${minus}${plus}"],
		},
		"plusdot", {
			unicode: "2214",
			tags: ["dot plus", "плюс с точкой"],
			groups: ["Smelting Special"],
			recipe: ["+."],
		},
		"plusequals_above", {
			unicode: "2A71",
			tags: ["plus with equals above", "плюс с равно сверху"],
			groups: ["Smelting Special"],
			recipe: ["+="],
		},
		"plusequals_below", {
			unicode: "2A72",
			tags: ["plus with equals below", "плюс с равно снизу"],
			groups: ["Smelting Special"],
			recipe: ["=+"],
		},
		"multiplication", {
			unicode: "00D7",
			alterations: { modifier: "02DF" },
			tags: ["multiplication", "умножение"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Combinations"],
			options: { altSpecialKey: "NumMult", fastKey: "8" },
			recipe: ["-x"],
		},
		"division", {
			unicode: "00F7",
			tags: ["деление", "обелюс", "division", "obelus"],
			groups: ["Special Characters", "Smelting Special", "Special Fast Secondary", "Special Combinations"],
			options: { altSpecialKey: "NumDiv", fastKey: "4" },
			recipe: ["-:"],
		},
		"division_times", {
			unicode: "22C7",
			tags: ["кратность деления", "division times"],
			groups: ["Special Characters", "Smelting Special", "Special Combinations"],
			options: { altSpecialKey: "NumMult NumDiv" },
			recipe: ["${multiplication}-:", "${multiplication}${multiplication}"],
		},
		"tilde", {
			unicode: "007E",
			alterations: {
				fullwidth: "FF5E"
			},
			options: { noCalc: True },
		},
		"nottilde", {
			unicode: "2241",
			tags: ["не эквивалентно", "not tilde"],
			groups: ["Smelting Special"],
			recipe: ["/~"],
		},
		"tilderising_dots", {
			unicode: "2A6B",
			tags: ["tilde operator with rising dots", "тильда точками"],
			groups: ["Smelting Special"],
			recipe: [".~."],
		},
		"homothetic", {
			unicode: "223B",
			tags: ["гомотетия", "homothetic"],
			groups: ["Smelting Special"],
			recipe: ["~:"],
		},
		"asymptotically_equal", {
			unicode: "2243",
			tags: ["асимптотически равно", "asymptotically equal"],
			groups: ["Smelting Special"],
			recipe: ["-~", "${minus}~"],
		},
		"tilde_tripple", {
			unicode: "224B",
			tags: ["тройная тильда", "triple tilde"],
			groups: ["Smelting Special"],
			recipe: ["~~~", "3~"],
		},
		"minustilde", {
			unicode: "2242",
			tags: ["minus tilde", "тильда с минусом"],
			groups: ["Smelting Special"],
			recipe: ["~-", "~${minus}"],
		},
		"tilde_reversed", {
			unicode: "223D",
			tags: ["обратная  тильда", "reversed tilde"],
			groups: ["Smelting Special", "Special Fast RShift"],
			options: { fastKey: "~" },
			recipe: ["${arrow_left_circle}~"],
		},
		"tilde_reversed_equals", {
			unicode: "22CD",
			tags: ["обратная тильда равно", "reversed tilde equal"],
			groups: ["Smelting Special"],
			recipe: ["=${arrow_left_circle}~", "=${tilde_reversed}"],
		},
		"less_than", {
			unicode: "003C",
			alterations: {
				small: "FE64",
				fullwidth: "FF1C"
			},
			options: { noCalc: True },
		},
		"less_or_equals", {
			unicode: "2264",
			tags: ["less than or equals", "меньше или равно"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: ">+ [<]" },
			recipe: ["<="],
		},
		"neither_less_nor_equals", {
			unicode: "2270",
			tags: ["neither less than nor equals", "ни меньше ни равно"],
			groups: ["Smelting Special"],
			recipe: ["/<="],
		},
		"less_over_equals", {
			unicode: "2266",
			tags: ["less than over equals", "меньше над равно"],
			groups: ["Smelting Special"],
			recipe: ["<==", "${less_or_equals}="],
		},
		"greater_than", {
			unicode: "003E",
			alterations: {
				small: "FE65",
				fullwidth: "FF1E"
			},
			options: { noCalc: True },
		},
		"greater_or_equals", {
			unicode: "2265",
			tags: ["greater than or equals", "больше или равно"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: ">+ [>]" },
			recipe: [">="],
		},
		"neither_greater_nor_equals", {
			unicode: "2271",
			tags: ["neither greater than nor equals", "ни больше ни равно"],
			groups: ["Smelting Special"],
			recipe: ["/>="],
		},
		"greater_over_equals", {
			unicode: "2267",
			tags: ["greater than over equals", "больше над равно"],
			groups: ["Smelting Special"],
			recipe: [">==", "${greater_or_equals}="],
		},
		"inverted_lazy_s", {
			unicode: "223E",
			tags: ["inverted lazy s", "перевёрнутая плавная s"],
			groups: ["Smelting Special"],
			recipe: ["s${arrow_right_circle}"],
		},
		"n_ary_summation", {
			unicode: "2211",
			tags: ["n-ary summation", "summation", "знак суммирования"],
			groups: ["Smelting Special", "Math"],
			alterations: { doubleStruck: "2140" },
			options: { altLayoutKey: "S" },
			recipe: ["sum", "сум"],
		},
		"modulo_two_sum", {
			unicode: "2A0A",
			tags: ["modulo two sum"],
			groups: ["Smelting Special"],
			recipe: ["msum", "мсум"],
		},
		"n_ary_product", {
			unicode: "220F",
			tags: ["n-ary product", "product", "знак произведения"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: ">+ P" },
			recipe: ["prod", "прод"],
		},
		"n_ary_union", {
			unicode: "222A",
			tags: ["n-ary union", "union", "знак объединения"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: "U" },
			recipe: ["uni", "обд"],
		},
		"delta", {
			unicode: "2206",
			tags: ["increment", "delta", "дельта"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: "D" },
			recipe: ["del", "дел"],
		},
		"nabla", {
			unicode: "2207",
			tags: ["nabla", "набла"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: "N" },
			recipe: ["nab", "наб"],
		},
		"integral", {
			unicode: "222B", LaTeX: ["\int"],
			tags: ["integral", "интеграл"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: "i" },
			recipe: ["int", "инт"],
		},
		"integral_double", {
			unicode: "222C", LaTeX: ["\iint"],
			tags: ["double integral", "двойной интеграл"],
			groups: ["Smelting Special", "Math"],
			recipe: ["${integral×2}", "iint", "иинт"],
		},
		"integral_triple", {
			unicode: "222D", LaTeX: ["\iiint"],
			tags: ["triple integral", "тройной интеграл"],
			groups: ["Smelting Special", "Math"],
			recipe: ["${integral×3}", "tint", "тинт"],
		},
		"integral_quadruple", {
			unicode: "2A0C",
			tags: ["quadruple integral", "четверной интеграл"],
			groups: ["Smelting Special", "Math"],
			recipe: ["${integral×4}", "qint", "чинт"],
		},
		"contour_integral", {
			unicode: "222E", LaTeX: ["\oint"],
			tags: ["contour integral", "интеграл по контуру"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: "I" },
			recipe: ["oint", "кинт"],
		},
		"surface_integral", {
			unicode: "222F", LaTeX: ["\oiint"], LaTeXPackage: "esint",
			tags: ["surface integral", "интеграл по поверхности"],
			groups: ["Smelting Special"],
			recipe: ["oiint", "киинт", "${contour_integral×2}"],
		},
		"volume_integral", {
			unicode: "2230", LaTeX: ["\oiiint"], LaTeXPackage: "esint",
			tags: ["volume integral", "тройной по объёму"],
			groups: ["Smelting Special"],
			recipe: ["otint", "ктинт", "${contour_integral×3}"],
		},
		"summation_integral", {
			unicode: "2A0B",
			tags: ["summation with integral", "суммирования с интегралом"],
			groups: ["Smelting Special"],
			recipe: ["sumint", "суминт", "${n_ary_summation}${integral}"],
		},
		"square_root", {
			unicode: "221A", LaTeX: ["\sqrt"],
			tags: ["square root", "квадратный корень"],
			groups: ["Smelting Special", "Math"],
			options: { altLayoutKey: "r" },
			recipe: ["sqrt", "квкр"],
		},
		"cube_root", {
			unicode: "221B", LaTeX: ["\sqrt[3]"],
			tags: ["cube root", "кубический корень"],
			groups: ["Smelting Special"],
			recipe: ["cbrt", "кубкр"],
		},
		"fourth_root", {
			unicode: "221C", LaTeX: ["\sqrt[4]"],
			tags: ["fourth root", "корень четвёртой степени"],
			groups: ["Smelting Special"],
			recipe: ["qurt", "чткр"],
		},
		"left_parenthesis", {
			unicode: "0028",
			alterations: {
				superscript: "207D",
				subscript: "208D",
				small: "FE59",
				fullwidth: "FF08"
			},
			options: { noCalc: True, send: "Text" },
		},
		"right_parenthesis", {
			unicode: "0029",
			alterations: {
				superscript: "207E",
				subscript: "208E",
				small: "FE5A",
				fullwidth: "FF09"
			},
			options: { noCalc: True, send: "Text" },
		},
		"top_parenthesis", {
			unicode: "23DC",
			tags: ["top parenthesis", "верхняя круглая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_parenthesis}${arrow_up}"],
		},
		"bottom_parenthesis", {
			unicode: "23DD",
			tags: ["bottom parenthesis", "нижняя круглая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_parenthesis}${arrow_down}"],
		},
		"left_parenthesis_upper_hook", {
			unicode: "239B",
			tags: ["left parenthesis upper hook", "верхний крюк левой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_parenthesis}${arrow_leftup}"],
		},
		"right_parenthesis_upper_hook", {
			unicode: "239E",
			tags: ["right parenthesis upper hook", "верхний крюк правой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_parenthesis}${arrow_rightup}"],
		},
		"left_parenthesis_extension", {
			unicode: "239C",
			tags: ["left parenthesis extension", "расширение левой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_parenthesis}/${arrow_left}"],
		},
		"right_parenthesis_extension", {
			unicode: "239F",
			tags: ["right parenthesis extension", "расширение правой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_parenthesis}\${arrow_right}"],
		},
		"left_parenthesis_lower_hook", {
			unicode: "239D",
			tags: ["left parenthesis lower hook", "нижний крюк левой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_parenthesis}${arrow_leftdown}"],
		},
		"right_parenthesis_lower_hook", {
			unicode: "23A0",
			tags: ["right parenthesis lower hook", "нижний крюк правой круглой скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_parenthesis}${arrow_rightdown}"],
		},
		"left_bracket", {
			unicode: "005B",
			alterations: {
				fullwidth: "FF3B"
			},
			options: { noCalc: True, send: "Text" },
		},
		"right_bracket", {
			unicode: "005D",
			alterations: {
				fullwidth: "FF3D"
			},
			options: { noCalc: True, send: "Text" },
		},
		"top_bracket", {
			unicode: "23B4",
			tags: ["top bracket", "верхняя квадратная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_bracket}${arrow_up}"],
		},
		"bottom_bracket", {
			unicode: "23B5",
			tags: ["bottom bracket", "нижняя квадратная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_bracket}${arrow_down}"],
		},
		"left_bracket_with_quill", {
			unicode: "2045",
			tags: ["left bracket with quill", "левая квадратная скобка с чертой"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "[" },
		},
		"right_bracket_with_quill", {
			unicode: "2046",
			tags: ["right bracket with quill", "правая квадратная скобка с чертой"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "]" },
		},
		"left_white_bracket", {
			unicode: "27E6",
			tags: ["left white bracket", "левая квадратная полая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: ">+ [" },
		},
		"right_white_bracket", {
			unicode: "27E7",
			tags: ["right white bracket", "правая квадратная полая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: ">+ ]" },
		},
		"left_white_tortoise_shell", {
			unicode: "27EC",
			tags: ["left white tortoise shell", "левая полая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<+ [" },
		},
		"right_white_tortoise_shell", {
			unicode: "27ED",
			tags: ["right white tortoise shell", "правая полая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<+ ]" },
		},
		"left_bracket_upper_corner", {
			unicode: "23A1",
			tags: ["left bracket upper corner", "верхний угол левой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_bracket}${arrow_leftup}"],
		},
		"right_bracket_upper_corner", {
			unicode: "23A4",
			tags: ["right bracket upper corner", "верхний угол правой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_bracket}${arrow_rightup}"],
		},
		"left_bracket_extension", {
			unicode: "23A2",
			tags: ["left bracket extension", "расширение левой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_bracket}/${arrow_left}"],
		},
		"right_bracket_extension", {
			unicode: "23A5",
			tags: ["right bracket extension", "расширение правой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_bracket}\${arrow_right}"],
		},
		"left_bracket_lower_corner", {
			unicode: "23A3",
			tags: ["left bracket lower corner", "нижний угол левой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_bracket}${arrow_leftdown}"],
		},
		"right_bracket_lower_corner", {
			unicode: "23A6",
			tags: ["right bracket lower corner", "нижний угол правой квадратной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_bracket}${arrow_rightdown}"],
		},
		"left_brace", {
			unicode: "007B",
			alterations: {
				small: "FE5C",
				fullwidth: "FF5B"
			},
			options: { noCalc: True, send: "Text" },
		},
		"right_brace", {
			unicode: "007D",
			alterations: {
				small: "FE5D",
				fullwidth: "FF5D"
			},
			options: { noCalc: True, send: "Text" },
		},
		"top_brace", {
			unicode: "23DE",
			tags: ["top brace", "верхняя фигурная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_brace}${arrow_up}"],
		},
		"bottom_brace", {
			unicode: "23DF",
			tags: ["bottom brace", "нижняя фигурная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_brace}${arrow_down}"],
		},
		"left_brace_upper_hook", {
			unicode: "23A7",
			tags: ["left brace upper hook", "верхний крюк левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}${arrow_leftup}"],
		},
		"right_brace_upper_hook", {
			unicode: "23AB",
			tags: ["right brace upper hook", "верхний крюк правой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_brace}${arrow_rightup}"],
		},
		"brace_extension", {
			unicode: "23AA",
			tags: ["left brace extension", "расширение левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}/${arrow_left}", "${right_brace}\${arrow_right}"],
		},
		"left_brace_middle_piece", {
			unicode: "23A8",
			tags: ["left brace middle piece", "средняя часть левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}${arrow_left}"],
		},
		"right_brace_middle_piece", {
			unicode: "23AC",
			tags: ["right brace middle piece", "средняя часть правой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_brace}${arrow_right}"],
		},
		"left_brace_lower_hook", {
			unicode: "23A9",
			tags: ["left brace lower hook", "нижний крюк левой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_brace}${arrow_leftdown}"],
		},
		"right_brace_lower_hook", {
			unicode: "23AD",
			tags: ["right brace lower hook", "нижний крюк правой фигурной скобки"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_brace}${arrow_rightdown}"],
		},
		"left_chevron", {
			unicode: "27E8",
			LaTeX: ["\langle"],
			tags: ["mathematical left angle bracket", "математическая левая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "9" },
		},
		"right_chevron", {
			unicode: "27E9",
			LaTeX: ["\rangle"],
			tags: ["mathematical right angle bracket", "математическая правая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "0" },
		},
		"left_chevron_with_dot", {
			unicode: "2991",
			tags: ["mathematical left angle bracket with dot", "математическая левая угловая скобка с точкой"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_chevron}."],
		},
		"right_chevron_with_dot", {
			unicode: "2992",
			tags: ["mathematical right angle bracket with dot", "математическая правая угловая скобка с точкой"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_chevron}."],
		},
		"left_chevron_double", {
			unicode: "27EA",
			tags: ["mathematical double left angle bracket", "математическая двойная левая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${left_chevron×2}"],
		},
		"right_chevron_double", {
			unicode: "27EB",
			tags: ["mathematical double right angle bracket", "математическая двойная правая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${right_chevron×2}"],
		},
		"left_chevron", {
			unicode: "27E8",
			LaTeX: ["\langle"],
			tags: ["mathematical left angle bracket", "математическая левая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "9" },
		},
		"left_cjk_tortoise_shell", {
			unicode: "3014",
			tags: ["cjk left tortoise shell bracket", "восточная левая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<! [" },
		},
		"right_cjk_tortoise_shell", {
			unicode: "3015",
			tags: ["cjk right tortoise shell bracket", "восточная правая панцирная скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<! ]" },
		},
		"top_cjk_tortoise_shell", {
			unicode: "FE39",
			tags: ["cjk top tortoise shell bracket", "восточная верхняя панцирная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_tortoise_shell}${arrow_up}"],
		},
		"bottom_cjk_tortoise_shell", {
			unicode: "FE3A",
			tags: ["cjk bottom tortoise shell bracket", "восточная нижняя панцирная скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_tortoise_shell}${arrow_down}"],
		},
		"left_cjk_corner_bracket", {
			unicode: "300C",
			tags: ["cjk left corner bracket", "восточная левая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!<+ [" },
		},
		"right_cjk_corner_bracket", {
			unicode: "300D",
			tags: ["cjk right corner bracket", "восточная правая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!<+ ]" },
		},
		"top_cjk_corner_bracket", {
			unicode: "FE41",
			tags: ["cjk top corner bracket", "восточная верхняя угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_corner_bracket}${arrow_up}"],
		},
		"bottom_cjk_corner_bracket", {
			unicode: "FE42",
			tags: ["cjk bottom corner bracket", "восточная нижняя угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_corner_bracket}${arrow_down}"],
		},
		"left_cjk_white_corner_bracket", {
			unicode: "300E",
			tags: ["cjk left white corner bracket", "восточная левая полая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!>+ [" },
		},
		"right_cjk_white_corner_bracket", {
			unicode: "300F",
			tags: ["cjk right white corner bracket", "восточная правая полая угловая скобка"],
			groups: ["Brackets", "Special Fast Secondary"],
			options: { fastKey: "<!>+ ]" },
		},
		"top_cjk_white_corner_bracket", {
			unicode: "FE43",
			tags: ["cjk top white corner bracket", "восточная верхняя полая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_white_corner_bracket}${arrow_up}"],
		},
		"bottom_cjk_white_corner_bracket", {
			unicode: "FE44",
			tags: ["cjk bottom white corner bracket", "восточная нижняя полая угловая скобка"],
			groups: ["Brackets", "Smelting Special"],
			recipe: ["${(left|right)_cjk_white_corner_bracket}${arrow_down}"],
		},
		"[left,right,left_double,right_double,top,bottom,top_double,bottom_double]_cjk_title_bracket", {
			unicode: [
				"3008",
				"3009",
				"300A",
				"300B",
				"FE3F",
				"FE40",
				"FE3D",
				"FE3E",
			],
			tags: [
				["cjk title left bracket", "восточная левая заголовочная кавычка"],
				["cjk title right bracket", "восточная правая заголовочная кавычка"],
				["cjk title left double bracket", "восточная левая двойная заголовочная кавычка"],
				["cjk title right double bracket", "восточная правая двойная заголовочная кавычка"],
				["cjk title top bracket", "восточная верхняя заголовочная кавычка"],
				["cjk title bottom bracket", "восточная нижняя заголовочная кавычка"],
				["cjk title top double bracket", "восточная верхняя двойная заголовочная кавычка"],
				["cjk title bottom double bracket", "восточная нижняя двойная заголовочная кавычка"],
			],
			groups: ["Brackets", "Smelting Special", "Special Fast Secondary"],
			options: {
				fastKey: [
					"<!>+ [",
					"<!>+ ]",
					"<!<+>+ [",
					"<!<+>+ ]",
					"",
					"",
					"",
					"",
				]
			},
			recipe: [
				[],
				[],
				["${left_cjk_title_bracket×2}"],
				["${right_cjk_title_bracket×2}"],
				["${(left|right)_cjk_title_bracket}${arrow_down}"],
				["${(left|right)_cjk_title_bracket}${arrow_up}"],
				["${top_cjk_title_bracket×2}", "${(left|right)_cjk_title_bracket×2}${arrow_down}"],
				["${bottom_cjk_title_bracket×2}", "${(left|right)_cjk_title_bracket×2}${arrow_up}"],
			],
		},
		;
		;
		; * Default Hellenic
		;
		;
		"hel_[c,s]_let_a_alpha", {
			unicode: ["0391", "03B1"],
			alterations: [{
				bold: "1D6A8",
				italic: "1D6E2",
				italicBold: "1D71C",
				sansSerifBold: "1D756",
				sansSerifItalicBold: "1D790",
			}, {
				bold: "1D6C2",
				italic: "1D6FC",
				italicBold: "1D736",
				sansSerifBold: "1D770",
				sansSerifItalicBold: "1D7AA",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_b_beta", {
			unicode: ["0392", "03B2"],
			alterations: [{
				bold: "1D6A9",
				italic: "1D6E3",
				italicBold: "1D71D",
				sansSerifBold: "1D757",
				sansSerifItalicBold: "1D791",
			}, {
				bold: "1D6C3",
				italic: "1D6FD",
				italicBold: "1D737",
				sansSerifBold: "1D771",
				sansSerifItalicBold: "1D7AB",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_g_gamma", {
			unicode: ["0393", "03B3"],
			alterations: [{
				bold: "1D6AA",
				italic: "1D6E4",
				italicBold: "1D71E",
				sansSerifBold: "1D758",
				sansSerifItalicBold: "1D792",
				smallCapital: "1D26",
			}, {
				bold: "1D6C4",
				italic: "1D6FE",
				italicBold: "1D738",
				sansSerifBold: "1D772",
				sansSerifItalicBold: "1D7AC",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_d_delta", {
			unicode: ["0394", "03B4"],
			alterations: [{
				bold: "1D6AB",
				italic: "1D6E5",
				italicBold: "1D71F",
				sansSerifBold: "1D759",
				sansSerifItalicBold: "1D793",
			}, {
				bold: "1D6C5",
				italic: "1D6FF",
				italicBold: "1D739",
				sansSerifBold: "1D773",
				sansSerifItalicBold: "1D7AD",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_e_epsilon", {
			unicode: ["0395", "03B5"],
			alterations: [{
				bold: "1D6AC",
				italic: "1D6E6",
				italicBold: "1D720",
				sansSerifBold: "1D75A",
				sansSerifItalicBold: "1D794",
			}, {
				bold: "1D6C6",
				italic: "1D700",
				italicBold: "1D73A",
				sansSerifBold: "1D774",
				sansSerifItalicBold: "1D7AE",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_z_zeta", {
			unicode: ["0396", "03B6"],
			alterations: [{
				bold: "1D6AD",
				italic: "1D6E7",
				italicBold: "1D721",
				sansSerifBold: "1D75B",
				sansSerifItalicBold: "1D795",
			}, {
				bold: "1D6C7",
				italic: "1D701",
				italicBold: "1D73B",
				sansSerifBold: "1D775",
				sansSerifItalicBold: "1D7AF",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_h_eta", {
			unicode: ["0397", "03B7"],
			alterations: [{
				bold: "1D6AE",
				italic: "1D6E8",
				italicBold: "1D722",
				sansSerifBold: "1D75C",
				sansSerifItalicBold: "1D796",
			}, {
				bold: "1D6C8",
				italic: "1D702",
				italicBold: "1D73C",
				sansSerifBold: "1D776",
				sansSerifItalicBold: "1D7B0",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_t_theta", {
			unicode: ["0398", "03B8"],
			alterations: [{
				bold: "1D6AF",
				italic: "1D6E9",
				italicBold: "1D723",
				sansSerifBold: "1D75D",
				sansSerifItalicBold: "1D797",
			}, {
				bold: "1D6C9",
				italic: "1D703",
				italicBold: "1D73D",
				sansSerifBold: "1D777",
				sansSerifItalicBold: "1D7B1",
			}],
			options: { altLayoutKey: "\U\ | >! $" },
		},
		"hel_[c,s]_let_i_iota", {
			unicode: ["0399", "03B9"],
			alterations: [{
				bold: "1D6B0",
				italic: "1D6EA",
				italicBold: "1D724",
				sansSerifBold: "1D75E",
				sansSerifItalicBold: "1D798",
			}, {
				bold: "1D6CA",
				italic: "1D704",
				italicBold: "1D73E",
				sansSerifBold: "1D778",
				sansSerifItalicBold: "1D7B2",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_k_kappa", {
			unicode: ["039A", "03BA"],
			alterations: [{
				bold: "1D6B1",
				italic: "1D6EB",
				italicBold: "1D725",
				sansSerifBold: "1D75F",
				sansSerifItalicBold: "1D799",
			}, {
				bold: "1D6CB",
				italic: "1D705",
				italicBold: "1D73F",
				sansSerifBold: "1D779",
				sansSerifItalicBold: "1D7B3",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_l_lambda", {
			unicode: ["039B", "03BB"],
			alterations: [{
				bold: "1D6B2",
				italic: "1D6EC",
				italicBold: "1D726",
				sansSerifBold: "1D760",
				sansSerifItalicBold: "1D79A",
				smallCapital: "1D27",
			}, {
				bold: "1D6CC",
				italic: "1D706",
				italicBold: "1D740",
				sansSerifBold: "1D77A",
				sansSerifItalicBold: "1D7B4",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_m_mu", {
			unicode: ["039C", "03BC"],
			alterations: [{
				bold: "1D6B3",
				italic: "1D6ED",
				italicBold: "1D727",
				sansSerifBold: "1D761",
				sansSerifItalicBold: "1D79B",
			}, {
				bold: "1D6CD",
				italic: "1D707",
				italicBold: "1D741",
				sansSerifBold: "1D77B",
				sansSerifItalicBold: "1D7B5",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_n_nu", {
			unicode: ["039D", "03BD"],
			alterations: [{
				bold: "1D6B4",
				italic: "1D6EE",
				italicBold: "1D728",
				sansSerifBold: "1D762",
				sansSerifItalicBold: "1D79C",
			}, {
				bold: "1D6CE",
				italic: "1D708",
				italicBold: "1D742",
				sansSerifBold: "1D77C",
				sansSerifItalicBold: "1D7B6",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_x_xi", {
			unicode: ["039E", "03BE"],
			alterations: [{
				bold: "1D6B5",
				italic: "1D6EF",
				italicBold: "1D729",
				sansSerifBold: "1D763",
				sansSerifItalicBold: "1D79D",
			}, {
				bold: "1D6CF",
				italic: "1D709",
				italicBold: "1D743",
				sansSerifBold: "1D77D",
				sansSerifItalicBold: "1D7B7",
			}],
			options: { altLayoutKey: "\J\" },
		},
		"hel_[c,s]_let_o_omicron", {
			unicode: ["039F", "03BF"],
			alterations: [{
				bold: "1D6B6",
				italic: "1D6F0",
				italicBold: "1D72A",
				sansSerifBold: "1D764",
				sansSerifItalicBold: "1D79E",
			}, {
				bold: "1D6D0",
				italic: "1D70A",
				italicBold: "1D744",
				sansSerifBold: "1D77E",
				sansSerifItalicBold: "1D7B8",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_p_pi", {
			unicode: ["03A0", "03C0"],
			alterations: [{
				bold: "1D6B7",
				italic: "1D6F1",
				italicBold: "1D72B",
				sansSerifBold: "1D765",
				sansSerifItalicBold: "1D79F",
				smallCapital: "1D28",
			}, {
				bold: "1D6D1",
				italic: "1D70B",
				italicBold: "1D745",
				sansSerifBold: "1D77F",
				sansSerifItalicBold: "1D7B9",
			}],
			options: { altLayoutKey: "\С\" },
		},
		"hel_[c,s]_let_r_rho", {
			unicode: ["03A1", "03C1"],
			alterations: [{
				bold: "1D6B8",
				italic: "1D6F2",
				italicBold: "1D72C",
				sansSerifBold: "1D766",
				sansSerifItalicBold: "1D7A0",
				smallCapital: "1D29",
			}, {
				bold: "1D6D2",
				italic: "1D70C",
				italicBold: "1D746",
				sansSerifBold: "1D780",
				sansSerifItalicBold: "1D7BA",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_s_sigma", {
			unicode: ["03A3", "03C3"],
			alterations: [{
				bold: "1D6BA",
				italic: "1D6F4",
				italicBold: "1D72E",
				sansSerifBold: "1D768",
				sansSerifItalicBold: "1D7A2",
			}, {
				bold: "1D6D4",
				italic: "1D70E",
				italicBold: "1D748",
				sansSerifBold: "1D782",
				sansSerifItalicBold: "1D7BC",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_s_let_s_sigma_final", {
			unicode: "03C2",
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_t_tau", {
			unicode: ["03A4", "03C4"],
			alterations: [{
				bold: "1D6BB",
				italic: "1D6F5",
				italicBold: "1D72F",
				sansSerifBold: "1D769",
				sansSerifItalicBold: "1D7A3",
			}, {
				bold: "1D6D5",
				italic: "1D70F",
				italicBold: "1D749",
				sansSerifBold: "1D783",
				sansSerifItalicBold: "1D7BD",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_y_upsilon", {
			unicode: ["03A5", "03C5"],
			alterations: [{
				bold: "1D6BC",
				italic: "1D6F6",
				italicBold: "1D730",
				sansSerifBold: "1D76A",
				sansSerifItalicBold: "1D7A4",
			}, {
				bold: "1D6D6",
				italic: "1D710",
				italicBold: "1D74A",
				sansSerifBold: "1D784",
				sansSerifItalicBold: "1D7BE",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_f_phi", {
			unicode: ["03A6", "03C6"],
			alterations: [{
				bold: "1D6BD",
				italic: "1D6F7",
				italicBold: "1D731",
				sansSerifBold: "1D76B",
				sansSerifItalicBold: "1D7A5",
			}, {
				bold: "1D6D7",
				italic: "1D711",
				italicBold: "1D74B",
				sansSerifBold: "1D785",
				sansSerifItalicBold: "1D7BF",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_h_chi", {
			unicode: ["03A7", "03C7"],
			alterations: [{
				bold: "1D6BE",
				italic: "1D6F8",
				italicBold: "1D732",
				sansSerifBold: "1D76C",
				sansSerifItalicBold: "1D7A6",
			}, {
				bold: "1D6D8",
				italic: "1D712",
				italicBold: "1D74C",
				sansSerifBold: "1D786",
				sansSerifItalicBold: "1D7C0",
			}],
			options: { altLayoutKey: "\X\" },
		},
		"hel_[c,s]_let_p_psi", {
			unicode: ["03A8", "03C8"],
			alterations: [{
				bold: "1D6BF",
				italic: "1D6F9",
				italicBold: "1D733",
				sansSerifBold: "1D76D",
				sansSerifItalicBold: "1D7A7",
				smallCapital: "1D2A",
			}, {
				bold: "1D6D9",
				italic: "1D713",
				italicBold: "1D74D",
				sansSerifBold: "1D787",
				sansSerifItalicBold: "1D7C1",
			}],
			options: { altLayoutKey: "\C\" },
		},
		"hel_[c,s]_let_o_omega", {
			unicode: ["03A9", "03C9"],
			alterations: [{
				bold: "1D6C0",
				italic: "1D6FA",
				italicBold: "1D734",
				sansSerifBold: "1D76E",
				sansSerifItalicBold: "1D7A8",
				smallCapital: "AB65",
			}, {
				bold: "1D6DA",
				italic: "1D714",
				italicBold: "1D74E",
				sansSerifBold: "1D788",
				sansSerifItalicBold: "1D7C2",
			}],
			options: { altLayoutKey: "\V\" },
		},
		"hel_[c,s]_let_i_jot", {
			unicode: ["037F", "03F3"],
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_h_heta", {
			unicode: ["0370", "0371"],
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_q_koppa", {
			unicode: ["03DE", "03DF"],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_q_koppa_archaic", {
			unicode: ["03D8", "03D9"],
			options: { altLayoutKey: ">! $" },
		},
		"hel_[c,s]_let_s_san", {
			unicode: ["03FA", "03FB"],
			options: { altLayoutKey: "<! $" },
		},
		"hel_[c,s]_let_s_sampi", {
			unicode: ["03E1", "03E0"],
			options: { altLayoutKey: ">!<! $" },
		},
		"hel_[c,s]_let_s_sampi_archaic", {
			unicode: ["0372", "0373"],
			options: { altLayoutKey: ">!<!<+ $" },
		},
		"hel_[c,s]_let_s_sho", {
			unicode: ["03F7", "03F8"],
			options: { altLayoutKey: ">!>+ $" },
		},
		"hel_[c,s]_let_w_digamma", {
			unicode: ["03DC", "03DD"],
			alterations: [{
				bold: "1D7CA",
			}, {
				bold: "1D7CB",
			}],
			options: { altLayoutKey: "$" },
		},
		"hel_[c,s]_let_w_digamma_pamphylian", {
			unicode: ["0376", "0377"],
			options: { altLayoutKey: ">! $" },
		},
		"hel_[s]_sym_b_beta", {
			unicode: ["03D0"],
			options: { referenceLocale: ":hel_s_let_b_beta", altLayoutKey: ">+ $" },
		},
		"hel_[c,s]_sym_t_theta", {
			unicode: ["03F4", "03D1"],
			alterations: [{
				bold: "1D6B9",
				italic: "1D6F3",
				italicBold: "1D72D",
				sansSerifBold: "1D767",
				sansSerifItalicBold: "1D7A1",
			}, {
				bold: "1D6DD",
				italic: "1D717",
				italicBold: "1D751",
				sansSerifBold: "1D78B",
				sansSerifItalicBold: "1D7C2",
			}],
			options: { referenceLocale: ":hel_[c,s]_let_t_theta*?", altLayoutKey: ">+ \U\" },
		},
		"hel_[s]_sym_f_phi", {
			unicode: ["03D5"],
			alterations: {
				bold: "1D6DF",
				italic: "1D719",
				italicBold: "1D753",
				sansSerifBold: "1D78D",
				sansSerifItalicBold: "1D7C7",
			},
			options: { referenceLocale: ":hel_s_let_f_phi", altLayoutKey: ">+ $" },
		},
		"hel_[s]_sym_r_rho", {
			unicode: ["03F1"],
			alterations: {
				bold: "1D6E0",
				italic: "1D71A",
				italicBold: "1D754",
				sansSerifBold: "1D78E",
				sansSerifItalicBold: "1D7C8",
			},
			options: { referenceLocale: ":hel_s_let_r_rho", altLayoutKey: ">+ $" },
		},
		"hel_[s]_sym_p_pi", {
			unicode: ["03D6"],
			alterations: {
				bold: "1D6E1",
				italic: "1D71B",
				italicBold: "1D755",
				sansSerifBold: "1D78F",
				sansSerifItalicBold: "1D7C9",
			},
			options: { referenceLocale: ":hel_s_let_p_pi", altLayoutKey: ">+ $" },
		},
		"hel_[s]_sym_k_kappa", {
			unicode: ["03F0"],
			alterations: {
				bold: "1D6DE",
				italic: "1D718",
				italicBold: "1D752",
				sansSerifBold: "1D78C",
				sansSerifItalicBold: "1D7C6",
			},
			options: { referenceLocale: ":hel_s_let_k_kappa", altLayoutKey: ">+ $" },
		},
		"hel_[c,s]_sym_s_sigma_lunate", {
			unicode: ["03F9", "03F2"],
			options: { referenceLocale: ":hel_[c,s]_let_s_sigma*?", altLayoutKey: ">+ $" },
			symbol: { beforeLetter: "lunate" },
		},
		"hel_[s]_sym_e_epsilon_lunate", {
			unicode: ["03F5"],
			alterations: {
				bold: "1D6DC",
				italic: "1D716",
				italicBold: "1D750",
				sansSerifBold: "1D78A",
				sansSerifItalicBold: "1D7C4",
			},
			options: { referenceLocale: ":hel_s_let_e_epsilon", altLayoutKey: ">+ $" },
			symbol: { beforeLetter: "lunate::2" },
		},
		;
		;
		; * Hellenic Ligatures
		;
		;
		"hel_[c,s]_lig_st_stigma", {
			unicode: ["03DA", "03DB"],
			recipe: ["${hel_[c,s]_let_s_sigma}${hel_[c,s]_let_t_tau}"]
		},
		"hel_[c,s]_lig_k_kai", {
			unicode: ["03CF", "03D7"],
			recipe: ["${hel_[c,s]_let_k_kappa}${hel_[c,s]_let_a_alpha}${hel_[c,s]_let_i_iota}"]
		},
		;
		;
		; * Latin Numberals
		;
		;
		"lat_c_num_[1,2,3,4,5,6,7,8,9,10,11,12,50,100,500,1000,5000,10000,50000,100000]", {
			unicode: [
				"2160", "2161", "2162", "2163", "2164",
				"2165", "2166", "2167", "2168", "2169",
				"216A", "216B", "216C", "216D", "216E",
				"216F", "2181", "2182", "2187", "2188"
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
				"2170", "2171", "2172", "2173", "2174",
				"2175", "2176", "2177", "2178", "2179",
				"217A", "217B", "217C", "217D", "217E",
				"217F"
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
			unicode: ["2185", "2186"],
			options: { useLetterLocale: True, numericValue: [6, 50], },
			recipe: [["RN L6"], ["RN E50"]],
			symbol: { afterLetter: ["late", "early"] }
		},
		"lat_c_num_100_reversed", {
			unicode: "2183",
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
			unicode: ["01A7", "01A8"],
			options: { useLetterLocale: True },
			recipe: [["`"2"], ["'2"]],
		},
		"lat_[c,s]_let_0_tone_five", {
			unicode: ["01BC", "01BD"],
			options: { useLetterLocale: True },
			recipe: [["`"5"], ["'5"]],
		},
		"lat_[c,s]_let_0_tone_six", {
			unicode: ["0184", "0185"],
			options: { useLetterLocale: True },
			recipe: [["`"6"], ["'6"]],
		},
		"lat_s_let_a_ain", {
			unicode: "1D25",
			alterations: { modifier: "1D5C" },
			options: { useLetterLocale: True },
			recipe: ["$in"],
		},
		"lat_[c,s]_let_a_schwa", {
			unicode: ["018F", "0259"],
			alterations: [{}, { modifier: "1D4A", subscript: "2094" }],
			tags: [[], ["mid central vowel", "неогублённый гласный среднего ряда среднего подъёма"]],
			groups: [[], ["Latin", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">!<! /E/"], useLetterLocale: True, fastKey: "/E/?Secondary"
			},
			recipe: ["/Sch/"],
		},
		"lat_[c,s]_let_h_hwair", {
			unicode: ["01F6", "0195"],
			options: { useLetterLocale: True, fastKey: "$?Primary" },
			recipe: ["$${arrow_right}"],
		},
		"lat_[c,s]_let_h_half", {
			unicode: ["2C75", "2C76"],
			recipe: ["$/"],
			symbol: { beforeLetter: "half" }
		},
		"lat_[c,s]_let_h_half_reversed", {
			unicode: ["A7F5", "A7F6"],
			recipe: ["$/${arrow_right}"],
			symbol: { beforeLetter: "reversed, half" }
		},
		"lat_s_let_i_yat_sakha", {
			unicode: "AB60",
			options: { useLetterLocale: True },
			recipe: ["$ь"],
		},
		"lat_[c,s]_let_j_yogh", {
			unicode: ["021C", "021D"],
			options: { useLetterLocale: True, fastKey: ">+ $?Secondary" },
			recipe: ["/yog/"],
		},
		"lat_[s]_let_i_dotless", {
			unicode: ["0131"],
			options: { fastKey: "<!<+>+ $?Secondary" },
			recipe: ["$//"],
			symbol: { afterLetter: "dotless" }
		},
		"lat_[c,s]_let_k_cuatrillo", {
			unicode: ["A72C", "A72D"],
			options: { useLetterLocale: True, fastKey: "<+ $?Secondary" },
			recipe: ["$4"],
		},
		"lat_[c,s]_let_o_rams_horn", {
			unicode: ["A7CB", "0264"],
			tags: [[], ["close-mid back unrounded vowel", "неогублённый гласный заднего ряда средне-верхнего подъёма"]],
			groups: [[], ["Latin", "IPA"]],
			alterations: [{}, { modifier: "10791" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"],
				useLetterLocale: True
			},
			recipe: ["/ram/"],
		},
		"lat_[c,s]_let_n_eng", {
			unicode: ["014A", "014B"],
			tags: [[], ["voiced velar nasal", "велярный носовой согласный"]],
			groups: [[], ["Latin", "IPA"]],
			alterations: [{}, { modifier: "1D51" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"],
				useLetterLocale: True
			},
			recipe: ["/Ng/"],
		},
		"lat_[c,s]_let_o_open", {
			unicode: ["0186", "0254"],
			tags: [[], ["open-mid back rounded vowel", "огублённый гласный заднего ряда средне-нижнего подъёма"]],
			groups: [[], ["Latin", "IPA"]],
			alterations: [{}, { modifier: "1D53" }],
			options: { referenceLocale: "o$", layoutTitles: ["", True], altLayoutKey: ["", ">!<+ $"] },
			recipe: ["$-"],
			symbol: { beforeLetter: "open" },
		},
		"lat_[s]_let_o_sideways", {
			unicode: ["1D11"],
			options: { referenceLocale: "o$" },
			recipe: ["$${arrow_right_circle}"],
			symbol: { beforeLetter: "sideways" },
		},
		"lat_[s]_let_o_open_sideways", {
			unicode: ["1D12"],
			options: { referenceLocale: "o$" },
			recipe: ["$-${arrow_right_circle}", "${lat_[s]_let_o_sideways}${arrow_left_circle}"],
			symbol: { beforeLetter: "sideways,open" },
		},
		"lat_[c,s]_let_q_tresillo", {
			unicode: ["A72A", "A72B"],
			options: { useLetterLocale: True, fastKey: "<+ $?Secondary" },
			recipe: ["$3"],
		},
		"lat_s_let_s_long", {
			unicode: "017F",
			options: { useLetterLocale: True, fastKey: ">+ $?Secondary" },
			recipe: ["fs"]
		},
		"lat_[c,s]_let_t_thorn", {
			unicode: ["00DE", "00FE"],
			options: { useLetterLocale: True, fastKey: ">+ ~?Secondary" },
			recipe: ["$"],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_t_thorn__stroke_short", {
			unicode: ["A764", "A765"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			recipe: [
				"$${stroke_short}", "${lat_[c,s]_let_@_thorn}${stroke_short}",
				"${stroke_short}$", "${stroke_short}${lat_[c,s]_let_@_thorn}",
			],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_t_thorn__stroke_down", {
			unicode: ["A766", "A767"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			recipe: [
				"$${arrow_down}${stroke_short}", "${lat_[c,s]_let_@_thorn}${arrow_down}${stroke_short}",
				"${arrow_down}${stroke_short}$", "${stroke_short}${lat_[c,s]_let_@_thorn}${arrow_down}",
			],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_t_thorn_double", {
			unicode: ["A7D2", "A7D3"],
			options: { useLetterLocale: True },
			recipe: ["$$", "${lat_[c,s]_let_@_thorn×2}"],
			symbol: { letter: ["TH", "th"] },
		},
		"lat_[c,s]_let_v_vend", {
			unicode: ["A768", "A769"],
			options: { useLetterLocale: True, fastKey: ">+ ~?Secondary" },
			recipe: ["$"],
			symbol: { letter: ["VE", "ve"] },
		},
		"lat_[c,s]_let_w_wynn", {
			unicode: ["01F7", "01BF"],
			options: { useLetterLocale: True, fastKey: ">+ ~?Secondary" },
			recipe: ["$"],
			symbol: { letter: ["WY", "wy"] },
		},
		"lat_[c,s]_let_w_wynn_double", {
			unicode: ["A7D4", "A7D5"],
			options: { useLetterLocale: True },
			recipe: ["$$", "${lat_[c,s]_let_@_wynn×2}"],
			symbol: { letter: ["WY", "wy"] },
		},
		"lat_[c,s]_let_z_ezh", {
			unicode: ["01B7", "0292"],
			tags: [[], ["voiced postalveolar fricative", "звонкий зубной щелевой согласный"]],
			groups: [[], ["Latin", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"], useLetterLocale: True, fastKey: ">+ ~?Secondary"
			},
			recipe: ["/E/zh"],
		},
		"lat_[c,s]_let_z_ezh__caron", {
			unicode: ["01EE", "01EF"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			symbol: { letter: "${lat_[c,s]_let_z_ezh}" }
		},
		"lat_s_let_z_ezh__curl", {
			unicode: "0293",
			recipe: ["$${arrow_right_ushaped}"],
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			symbol: { letter: "${lat_s_let_z_ezh}" }
		},
		"lat_s_let_z_ezh__retroflex_hook", {
			unicode: "1D9A",
			groups: ["Latin"],
			options: { useLetterLocale: "Origin" },
			symbol: { letter: "${lat_s_let_z_ezh}" }
		},
		;
		;
		; * Insular Latin
		;
		;
		"lat_[c,s]_let_d_insular", {
			unicode: ["A779", "A77A"],
			alterations: [{}, { combining: "1DD8" }],
			options: { useLetterLocale: True },
			recipe: ["$ ins"],
		},
		"lat_[c,s]_let_f_insular", {
			unicode: ["A77B", "A77C"],
			options: { useLetterLocale: True },
			recipe: ["$ ins"],
		},
		"lat_[c,s]_let_g_insular", {
			unicode: ["A77D", "1D79"],
			alterations: [{}, { combining: "1ACC" }],
			options: { useLetterLocale: True, fastKey: "<+ $?Secondary" },
			recipe: ["$ ins"],
		},
		"lat_[c,s]_let_g_insular_closed", {
			unicode: ["A7D0", "A7D1"],
			options: { useLetterLocale: True, referenceLocale: "insular$" },
			recipe: ["$- ins", "${lat_[c,s]_let_@_insular}-"],
			symbol: { beforeLetter: "closed" },
		},
		"lat_[c,s]_let_g_insular_turned", {
			unicode: ["A77E", "A77F"],
			options: { useLetterLocale: True, referenceLocale: "insular$" },
			recipe: ["$${arrow_left_circle} ins", "${lat_[c,s]_let_@_insular}${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_let_s_insular", {
			unicode: ["A784", "A785"],
			options: { useLetterLocale: True },
			recipe: ["$ ins"],
		},
		"lat_[c,s]_let_r_insular", {
			unicode: ["A782", "A783"],
			alterations: [{}, { combining: "1ACD" }],
			options: { useLetterLocale: True },
			recipe: ["$ ins"],
		},
		"lat_[c,s]_let_t_insular", {
			unicode: ["A786", "A787"],
			alterations: [{}, { combining: "1ACE" }],
			options: { useLetterLocale: True },
			recipe: ["$ ins"],
		},
		"lat_[c,s]_sign_et_tironian", {
			unicode: ["2E52", "204A"],
			options: { useLetterLocale: True, fastKey: "<+>+ /T/?Secondary" },
			recipe: ["$ ins", "& /ins/"],
		},
		"lat_[c,s]_let_r_rotunda", {
			unicode: ["A75A", "A75B"],
			alterations: [{}, { combining: "1DE3" }],
			options: { useLetterLocale: True },
			recipe: ["$ rot"],
		},
		"lat_[c,s]_let_rum_rotunda", {
			unicode: ["A75C", "A75D"],
			options: { useLetterLocale: True },
			recipe: ["/Rum/ rot"],
		},
		;
		;
		; * Middle-Welsh
		;
		;
		"lat_[c,s]_lig_ll_middle_welsh", {
			unicode: ["1EFA", "1EFB"],
			options: { referenceLocale: "_l$" },
			groups: ["Latin"],
			recipe: ["$ mw"],
			symbol: { beforeLetter: "middle_welsh" },
		},
		"lat_[c,s]_let_v_middle_welsh", {
			unicode: ["1EFC", "1EFD"],
			options: { referenceLocale: "v$", fastKey: "<+ $?Secondary" },
			recipe: ["$ mw"],
			symbol: { beforeLetter: "middle_welsh" },
		},
		;
		;
		; * Anglicana
		;
		;
		"lat_[c,s]_let_w_anglicana", {
			unicode: ["A7C2", "A7C3"],
			options: { referenceLocale: "w$", fastKey: "<!>+ $?Secondary" },
			recipe: ["$ ang"],
			symbol: { afterLetter: "anglicana" },
		},
		;
		;
		; * Latinized Hellenic
		;
		;
		"lat_[c,s]_let_a_alpha", {
			unicode: ["2C6D", "0251"],
			alterations: [{}, { combining: "1DE7", modifier: "1D45" }],
			tags: [[], ["open back unrounded vowel", "неогублённый гласный заднего ряда нижнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"], useLetterLocale: True
			},
			recipe: ["$lp"],
		},
		"lat_s_let_a_alpha__retroflex_hook", {
			unicode: "1D90",
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: "Origin" },
			recipe: ["$lp${retroflex_hook}", "${lat_s_let_a_alpha}${retroflex_hook}"],
		},
		"lat_s_let_a_alpha_barred", {
			unicode: "AB30",
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True, referenceLocale: "alpha$" },
			recipe: ["$lp${emdash}", "${lat_s_let_a_alpha}${emdash}"],
			symbol: { beforeLetter: "barred" },
		},
		"lat_[c,s]_let_a_alpha_turned", {
			unicode: ["2C70", "0252"],
			alterations: [{}, { modifier: "1D9B" }],
			tags: [[], ["open back rounded vowel", "огублённый гласный заднего ряда нижнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "c*>! $"], useLetterLocale: True, referenceLocale: "alpha$"
			},
			recipe: ["$lp${arrow_left_circle}", "${lat_[c,s]_let_@_alpha}${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_let_b_beta", {
			unicode: ["A7B4", "A7B5"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$et"],
		},
		"lat_s_let_d_delta", {
			unicode: "1E9F",
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$el"],
		},
		"lat_[c,s]_let_e_epsilon", {
			unicode: ["0190", "025B"],
			tags: [[], ["open-mid front unrounded vowel", "неогублённый гласный переднего ряда средне-нижнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			alterations: [{}, { modifier: "1D4B" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"], useLetterLocale: True
			},
			recipe: ["$ps", "$3"],
		},
		"lat_[c,s]_let_e_epsilon_reversed", {
			unicode: ["A7AB", "025C"],
			tags: [[], ["open-mid central unrounded vowel", "неогублённый гласный среднего ряда средне-нижнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			alterations: [{}, { modifier: "1D9F" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "c*>! $"], useLetterLocale: True, referenceLocale: "epsilon$"
			},
			recipe: ["$ps${arrow_right_circle}", "${lat_[c,s]_let_@_epsilon}${arrow_right_circle}"],
			symbol: { beforeLetter: "reversed" },
		},
		"lat_[s]_let_e_epsilon_closed", {
			unicode: ["029A"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True, referenceLocale: "epsilon$" },
			recipe: ["$ps-", "${lat_[c,s]_let_@_epsilon}-"],
			symbol: { beforeLetter: "closed" },
		},
		"lat_[s]_let_e_epsilon_closed_reversed", {
			unicode: ["025E"],
			tags: ["open-mid central rounded vowel", "огублённый гласный среднего ряда средне-нижнего подъёма"],
			groups: ["Latino-Hellenic", "IPA"],
			alterations: { modifier: "1078F" },
			options: {
				layoutTitles: True, altLayoutKey: ">!<+ $", useLetterLocale: True, referenceLocale: "epsilon$"
			},
			recipe: ["$ps-${arrow_right_circle}", "${lat_[c,s]_let_@_epsilon_closed}${arrow_right_circle}"],
			symbol: { beforeLetter: "closed,reversed" },
		},
		"lat_s_let_f_phi", {
			unicode: "0278",
			tags: ["voiceless bilabial fricative", "глухой губно-губной спирант"],
			groups: ["Latino-Hellenic", "IPA"],
			options: {
				layoutTitles: True, altLayoutKey: ">! $",
				useLetterLocale: True
			},
			recipe: ["phi"],
		},
		"lat_[c,s]_let_g_gamma", {
			unicode: ["0194", "0263"],
			alterations: [{}, { modifier: "02E0" }],
			tags: [[], ["voiced velar fricative", "звонкий велярный спирант"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"], useLetterLocale: True, fastKey: "<+>+ $?Secondary"
			},
			recipe: ["$am", "$y"],
		},
		"lat_[c,s]_let_h_chi", {
			unicode: ["A7B3", "AB53"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["/chi/"],
		},
		"lat_[c,s]_let_i_iota", {
			unicode: ["0196", "0269"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$ot"],
		},
		"lat_[c,s]_let_l_lambda", {
			unicode: ["A7DA", "A7DB"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$am"],
		},
		"lat_[c,s]_let_l_lambda__stroke_short", {
			unicode: ["A7DC", "019B"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: "Origin" },
			recipe: ["$am${stroke_short}", "${lat_[c,s]_let_@_lambda}${stroke_short}"],
		},
		"lat_[c,s]_let_o_omega", {
			unicode: ["A7B6", "A7B7"],
			groups: ["Latino-Hellenic"],
			options: { useLetterLocale: True },
			recipe: ["$mg"],
		},
		"lat_[c,s]_let_s_sigma", {
			unicode: ["01A9", "0283"],
			tags: [[], ["voiceless postalveolar fricative", "звонкий велярный спирант"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"], useLetterLocale: True, fastKey: "<+>+ $?Secondary"
			},
			recipe: ["$ig", "/esh/"],
		},
		"lat_[c,s]_let_u_upsilon", {
			unicode: ["01B1", "028A"],
			tags: [[], ["near-close near-back rounded vowel", "ненапряжённый огублённый гласный заднего ряда верхнего подъёма"]],
			groups: [["Latino-Hellenic"], ["Latino-Hellenic", "IPA"]],
			alterations: [{}, { modifier: "1DB7" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"], useLetterLocale: True
			},
			recipe: ["$ps", "-$-"],
		},
		;
		;
		; * Turned Latin Letters
		;
		;
		"lat_[c,s]_let_a_turned", {
			unicode: ["2C6F", "0250"],
			tags: [[], ["near-open central vowel", "ненапряжённый неогублённый гласный среднего ряда нижнего подъёма"]],
			groups: [[], ["Latin", "IPA"]],
			options: { layoutTitles: ["", True], altLayoutKey: ["", ">!<! $"] },
			alterations: [{}, { modifier: "1D44" }],
			recipe: ["$${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_let_e_turned", {
			unicode: ["018E", "01DD"],
			recipe: ["$${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_let_e_reversed", {
			unicode: ["0258"],
			tags: ["close-mid central unrounded vowel", "неогублённый гласный среднего ряда средне-верхнего подъёма"],
			groups: ["Latin", "IPA"],
			options: { layoutTitles: True, altLayoutKey: "c*>!<! $" },
			alterations: { modifier: "1078E" },
			recipe: ["$${arrow_right_circle}"],
			symbol: { beforeLetter: "reversed" },
		},
		"lat_[c,s]_let_m_turned", {
			unicode: ["019C", "026F"],
			tags: [[], ["close back unrounded vowel", "неогублённый гласный заднего ряда верхнего подъёма"]],
			groups: [[], ["Latin", "IPA"]],
			options: { layoutTitles: ["", True], altLayoutKey: ["", ">!<! /U/"] },
			alterations: [{}, { modifier: "1D5A" }],
			recipe: ["$${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_let_v_turned", {
			unicode: ["0245", "028C"],
			tags: [[], ["open-mid back unrounded vowel", "неогублённый гласный заднего ряда средне-нижнего подъёма"]],
			groups: [[], ["Latin", "IPA"]],
			options: { layoutTitles: ["", True], altLayoutKey: ["", ">! $"] },
			alterations: [{}, { modifier: "1DBA" }],
			recipe: ["$${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		;
		;
		; * Accented Latin
		;
		;
		"lat_[c,s]_let_a__acute", {
			unicode: ["00C1", "00E1"],
			options: {
				fastKey: "$?Primary",
				telex__vietnamese: "$ \S\",
				telex__chinese_romanization: "$ \S\",
			},
		},
		"lat_[c,s]_let_a__breve", {
			unicode: ["0102", "0103"],
			options: {
				fastKey: "$?Secondary",
				telex__vietnamese: "$ \W\",
			}
		},
		"lat_[c,s]_let_a__breve_inverted", {
			unicode: ["0202", "0203"]
		},
		"lat_[c,s]_let_a__circumflex", {
			unicode: ["00C2", "00E2"],
			options: {
				fastKey: "<! $?Secondary",
				telex__vietnamese: "$ $",
			}
		},
		"lat_[c,s]_let_a__caron", {
			unicode: ["01CD", "01CE"],
			options: {
				telex__chinese_romanization: "$ \V\",
			}
		},
		"lat_[c,s]_let_a__dot_above", {
			unicode: ["0226", "0227"]
		},
		"lat_[c,s]_let_a__dot_below", {
			unicode: ["1EA0", "1EA1"],
			options: {
				telex__vietnamese: "$ \S\",
			},
		},
		"lat_[c,s]_let_a__diaeresis", {
			unicode: ["00C4", "00E4"],
			tags: [[], ["open central unrounded vowel", "открытый средний неокруглённый гласный"]],
			groups: [[], ["Latin Accented", "IPA"]],
			options: { fastKey: "<+ $?Secondary", layoutTitles: ["", True], altLayoutKey: ["", ">!<+ $"] },
			alterations: [{}, { combining: "1DF2" }]
		},
		"lat_[c,s]_let_a__grave", {
			unicode: ["00C0", "00E0"],
			options: {
				fastKey: "$?Tertiary",
				telex__vietnamese: "$ \F\",
				telex__chinese_romanization: "$ \F\",
			}
		},
		"lat_[c,s]_let_a__grave_double", {
			unicode: ["0200", "0201"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_a__hook_above", {
			unicode: ["1EA2", "1EA3"],
			options: {
				telex__vietnamese: "$ \R\",
			},
		},
		"lat_[s]_let_a__retroflex_hook", {
			unicode: ["1D8F"]
		},
		"lat_[c,s]_let_a__macron", {
			unicode: ["0100", "0101"],
			options: {
				fastKey: ">+ $?Secondary",
				telex__chinese_romanization: "$ $",
			},
		},
		"lat_[c,s]_let_a__ring_above", {
			unicode: ["00C5", "00E5"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_a__ring_below", {
			unicode: ["1E00", "1E01"]
		},
		"lat_[c,s]_let_a__solidus_long", {
			unicode: ["023A", "2C65"]
		},
		"lat_[c,s]_let_a__ogonek", {
			unicode: ["0104", "0105"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_a__tilde_above", {
			unicode: ["00C3", "00E3"],
			options: {
				fastKey: "<+>+ $?Secondary",
				telex__vietnamese: "$ \X\",
			},
		},
		"lat_[c,s]_let_a__breve__acute", {
			unicode: ["1EAE", "1EAF"],
			options: {
				telex__vietnamese: "$ \W S\ | \Q\ 1 | ${lat_[c,s]_let_@__breve} \S\",
			},
		},
		"lat_[c,s]_let_a__breve__dot_below", {
			unicode: ["1EB6", "1EB7"],
			options: {
				telex__vietnamese: "$ \W J\ | \Q\ 4 | ${lat_[c,s]_let_@__breve} \J\",
			},
		},
		"lat_[c,s]_let_a__breve__grave", {
			unicode: ["1EB0", "1EB1"],
			options: {
				telex__vietnamese: "$ \W F\ | \Q\ 2 | ${lat_[c,s]_let_@__breve} \F\",
			},
		},
		"lat_[c,s]_let_a__breve__hook_above", {
			unicode: ["1EB2", "1EB3"],
			options: {
				telex__vietnamese: "$ \W R\ | \Q\ 3 | ${lat_[c,s]_let_@__breve} \R\",
			},
		},
		"lat_[c,s]_let_a__breve__tilde_above", {
			unicode: ["1EB4", "1EB5"],
			options: {
				telex__vietnamese: "$ \W X\ | \Q\ 5 | ${lat_[c,s]_let_@__breve} \X\",
			},
		},
		"lat_[c,s]_let_a__circumflex__acute", {
			unicode: ["1EA4", "1EA5"],
			options: {
				telex__vietnamese: "$ \W S\ | $ 1 | ${lat_[c,s]_let_a__circumflex} \S\",
			},
		},
		"lat_[c,s]_let_a__circumflex__dot_below", {
			unicode: ["1EAC", "1EAD"],
			options: {
				telex__vietnamese: "$ \W J\ | $ 4  | ${lat_[c,s]_let_@__circumflex} \J\",
			},
		},
		"lat_[c,s]_let_a__circumflex__grave", {
			unicode: ["1EA6", "1EA7"],
			options: {
				telex__vietnamese: "$ \W F\ | $ 2 | ${lat_[c,s]_let_@__circumflex} \F\",
			},
		},
		"lat_[c,s]_let_a__circumflex__hook_above", {
			unicode: ["1EA8", "1EA9"],
			options: {
				telex__vietnamese: "$ \W R\ | $ 3 | ${lat_[c,s]_let_@__circumflex} \R\",
			},
		},
		"lat_[c,s]_let_a__circumflex__tilde_above", {
			unicode: ["1EAA", "1EAB"],
			options: {
				telex__vietnamese: "$ \W X\ | $ 5 | ${lat_[c,s]_let_@__circumflex} \X\",
			},
		},
		"lat_[c,s]_let_a__dot_above__macron", {
			unicode: ["01E0", "01E1"]
		},
		"lat_[c,s]_let_a__diaeresis__macron", {
			unicode: ["01DE", "01DF"]
		},
		"lat_[c,s]_let_a__ring_above__acute", {
			unicode: ["01FA", "01FB"]
		},
		; Latin Letter “B”
		"lat_[c,s]_let_b__dot_above", {
			unicode: ["1E02", "1E03"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_b__dot_below", {
			unicode: ["1E04", "1E05"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_b__common_hook", {
			unicode: ["0181", "0253"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_left}"]
		},
		"lat_[s]_let_b__palatal_hook", {
			unicode: ["1D80"]
		},
		"lat_[c,s]_let_b__flourish", {
			unicode: ["A796", "A797"],
			options: { fastKey: "<!<+ $?Secondary" },
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[c,s]_let_b__line_below", {
			unicode: ["1E06", "1E07"],
		},
		"lat_[c,s]_let_b__stroke_short", {
			unicode: ["0243", "0180"],
			options: {
				fastKey: "<+ $?Secondary",
				telex__jorai: "\B B\",
			}
		},
		"lat_[s]_let_b__tilde_overlay", {
			unicode: ["1D6C"]
		},
		"lat_[c,s]_let_b__topbar", {
			unicode: ["0182", "0183"],
			recipe: ["$${arrow_up}"],
		},
		; Latin Letter “C”
		"lat_[c,s]_let_c__acute", {
			unicode: ["0106", "0107"],
			options: { fastKey: "$?Primary" },
		},
		"lat_[c,s]_let_c__circumflex", {
			unicode: ["0108", "0109"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_c__caron", {
			unicode: ["010C", "010D"],
			options: {
				fastKey: "<!<+ $?Secondary",
				telex__jorai: "$ \Z\",
			},
		},
		"lat_[c,s]_let_c__cedilla", {
			unicode: ["00C7", "00E7"],
			alterations: [{}, { combining: "1DD7" }],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_c__curl", {
			unicode: ["0255"],
			tags: ["voiceless alveolo-palatal fricative", "глухой альвеоло-палатальный сибилянт"],
			groups: ["Latin Accented", "IPA"],
			alterations: { modifier: "1D9D" },
			options: { layoutTitles: True, altLayoutKey: ">! $" },
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_c__dot_above", {
			unicode: ["010A", "010B"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_c_reversed__dot_middle", {
			unicode: ["A73E", "A73F"],
			recipe: ["$${arrow_right_circle}${interpunct}"],
			symbol: { beforeLetter: "reversed" }
		},
		"lat_[c,s]_let_c__common_hook", {
			unicode: ["0187", "0188"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[c,s]_let_c__palatal_hook", {
			unicode: ["A7C4", "A794"],
		},
		"lat_[s]_let_c__retroflex_hook", {
			unicode: ["1DF1D"],
		},
		"lat_[c,s]_let_c__solidus_long", {
			unicode: ["023B", "023C"],
		},
		"lat_[c,s]_let_c__stroke_short", {
			unicode: ["A792", "A793"],
		},
		"lat_[c,s]_let_c__cedilla__acute", {
			unicode: ["1E08", "1E09"],
		},
		; Latin Letter “D”
		"lat_[c,s]_let_d__circumflex_below", {
			unicode: ["1E12", "1E13"],
			options: { fastKey: "<+>+ $?Secondary" },
		},
		"lat_[c,s]_let_d__caron", {
			unicode: ["010E", "010F"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_d__cedilla", {
			unicode: ["1E10", "1E11"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_d__curl", {
			unicode: ["0221"],
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_d__dot_above", {
			unicode: ["1E0A", "1E0B"],
		},
		"lat_[c,s]_let_d__dot_below", {
			unicode: ["1E0C", "1E0D"],
		},
		"lat_[c,s]_let_d__common_hook", {
			unicode: ["018A", "0257"],
			recipe: ["$${arrow_left}"],
		},
		"lat_[s]_let_d__hook__retroflex_hook", {
			unicode: ["1D91"],
			recipe: ["$${arrow_left}${retroflex_hook}"]
		},
		"lat_[s]_let_d__palatal_hook", {
			unicode: ["1D81"],
		},
		"lat_[s]_let_d__retroflex_hook", {
			unicode: ["0256"],
		},
		"lat_[c,s]_let_d__line_below", {
			unicode: ["1E0E", "1E0F"],
		},
		"lat_[c,s]_let_d__stroke_short", {
			unicode: ["0110", "0111"],
			options: {
				telex__vietnamese: "$ $",
			},
		},
		"lat_[c,s]_let_d_tau_gallicum", {
			unicode: ["A7C7", "A7C8"],
			groups: ["Latin Accented"],
			options: { useLetterLocale: True },
			recipe: ["$${arrow_down}${stroke_short}"]
		},
		"lat_[s]_let_d__tilde_overlay", {
			unicode: ["1D6D"],
		},
		"lat_[c,s]_let_d__topbar", {
			unicode: ["018B", "018C"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[c,s]_let_d_eth", {
			unicode: ["00D0", "00F0"],
			tags: [[], ["voiced dental fricative", "звонкий зубной щелевой согласный"]],
			groups: [["Latin Accented"], ["Latin Accented", "IPA"]],
			alterations: [{ smallCapital: "1D06" }, { combining: "1DD9", modifier: "1D9E" }],
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", ">! $"],
				useLetterLocale: True, fastKey: "$?Secondary" },
			recipe: ["$${solidus_short}"],
		},
		; Latin Letter “E”
		"lat_[c,s]_let_e__acute", {
			unicode: ["00C9", "00E9"],
			options: {
				fastKey: "$?Primary",
				telex__vietnamese: "$ \S\",
				telex__chinese_romanization: "$ \S\",
			},
		},
		"lat_[c,s]_let_e__breve", {
			unicode: ["0114", "0115"]
		},
		"lat_[c,s]_let_e__breve_inverted", {
			unicode: ["0206", "0207"]
		},
		"lat_[c,s]_let_e__circumflex", {
			unicode: ["00CA", "00EA"],
			options: {
				fastKey: "<! $?Secondary",
				telex__vietnamese: "$ $",
			},
		},
		"lat_[c,s]_let_e__circumflex_below", {
			unicode: ["1E18", "1E19"]
		},
		"lat_[c,s]_let_e__caron", {
			unicode: ["011A", "011B"],
			options: {
				telex__jorai: "$ \Z\",
				telex__chinese_romanization: "$ \V\",
			}
		},
		"lat_[c,s]_let_e__cedilla", {
			unicode: ["0228", "0229"]
		},
		"lat_[c,s]_let_e__dot_above", {
			unicode: ["0116", "0117"]
		},
		"lat_[c,s]_let_e__dot_below", {
			unicode: ["1EB8", "1EB9"],
			options: {
				telex__vietnamese: "$ \J\",
			},
		},
		"lat_[c,s]_let_e__diaeresis", {
			unicode: ["00CB", "00EB"],
			options: { fastKey: "<+ $?Secondary" },
		},
		"lat_[c,s]_let_e__grave", {
			unicode: ["00C8", "00E8"],
			options: {
				fastKey: "$?Tertiary",
				telex__vietnamese: "$ \F\",
				telex__chinese_romanization: "$ \F\",
			},
		},
		"lat_[c,s]_let_e__grave_double", {
			unicode: ["0204", "0205"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_e__hook_above", {
			unicode: ["1EBA", "1EBB"],
			options: {
				telex__vietnamese: "$ \R\",
			},
		},
		"lat_[s]_let_e__retroflex_hook", {
			unicode: ["1D92"]
		},
		"lat_[s]_let_e__notch", {
			unicode: ["2C78"],
			recipe: ["$${arrow_right}"]
		},
		"lat_[c,s]_let_e__macron", {
			unicode: ["0112", "0113"],
			options: {
				fastKey: ">+ $?Secondary",
				telex__chinese_romanization: "$ \E\",
			},
		},
		"lat_[c,s]_let_e__solidus_long", {
			unicode: ["0246", "0247"]
		},
		"lat_[c,s]_let_e__ogonek", {
			unicode: ["0118", "0119"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_e__tilde_above", {
			unicode: ["1EBC", "1EBD"],
			options: {
				fastKey: "<+>+ $?Secondary",
				telex__vietnamese: "$ \X\",
			}
		},
		"lat_[c,s]_let_e__tilde_below", {
			unicode: ["1E1A", "1E1B"]
		},
		"lat_[c,s]_let_e__breve__cedilla", {
			unicode: ["1E1C", "1E1D"]
		},
		"lat_[c,s]_let_e__circumflex__acute", {
			unicode: ["1EBE", "1EBF"],
			options: {
				telex__vietnamese: "$ \W S\ | $ 1 | ${lat_[c,s]_let_@__circumflex} \S\",
			},
		},
		"lat_[c,s]_let_e__circumflex__dot_below", {
			unicode: ["1EC6", "1EC7"],
			options: {
				telex__vietnamese: "$ \W J\ | $ 4 | ${lat_[c,s]_let_@__circumflex} \J\",
			},
		},
		"lat_[c,s]_let_e__circumflex__grave", {
			unicode: ["1EC0", "1EC1"],
			options: {
				telex__vietnamese: "$ \W F\ | $ 2 | ${lat_[c,s]_let_@__circumflex} \F\",
			},
		},
		"lat_[c,s]_let_e__circumflex__hook_above", {
			unicode: ["1EC2", "1EC3"],
			options: {
				telex__vietnamese: "$ \W R\ | $ 3 | ${lat_[c,s]_let_@__circumflex} \R\",
			},
		},
		"lat_[c,s]_let_e__circumflex__tilde_above", {
			unicode: ["1EC4", "1EC5"],
			options: {
				telex__vietnamese: "$ \W X\ | $ 5 | ${lat_[c,s]_let_@__circumflex} \X\",
			},
		},
		"lat_[c,s]_let_e__macron__acute", {
			unicode: ["1E16", "1E17"]
		},
		"lat_[c,s]_let_e__macron__grave", {
			unicode: ["1E14", "1E15"]
		},
		; Latin Letter “F”
		"lat_[c,s]_let_f__dot_above", {
			unicode: ["1E1E", "1E1F"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_f__common_hook", {
			unicode: ["0191", "0192"],
			recipe: ["$${arrow_down}"]
		},
		"lat_[s]_let_f__palatal_hook", {
			unicode: ["1D82"]
		},
		"lat_[c,s]_let_f__stroke_short", {
			unicode: ["A798", "A799"],
		},
		"lat_[s]_let_f__tilde_overlay", {
			unicode: ["1D6E"],
		},
		; Latin Letter “G”
		"lat_[c,s]_let_g__acute", {
			unicode: ["01F4", "01F5"],
			options: { fastKey: "$?Primary" },
		},
		"lat_[c,s]_let_g__breve", {
			unicode: ["011E", "011F"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_g__circumflex", {
			unicode: ["011C", "011D"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_g__caron", {
			unicode: ["01E6", "01E7"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_g__cedilla", {
			unicode: ["0122", "0123"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_g__crossed_tail", {
			unicode: ["AB36"],
			recipe: ["$${arrow_right_ushaped}"],
		},
		"lat_[c,s]_let_g__dot_above", {
			unicode: ["0120", "0121"],
			options: { fastKey: "$?Tertiary" },
		},
		"lat_[c,s]_let_g__macron", {
			unicode: ["1E20", "1E21"],
			options: { fastKey: ">+ $?Secondary" },
		},
		"lat_[c,s]_let_g__solidus_long", {
			unicode: ["A7A0", "A7A1"],
		},
		"lat_[c,s]_let_g__stroke_short", {
			unicode: ["01E4", "01E5"],
		},
		"lat_[c,s]_let_g__common_hook", {
			unicode: ["0193", "0260"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[s]_let_g__palatal_hook", {
			unicode: ["1D83"],
		},
		; Latin Letter “H”
		"lat_[c,s]_let_h__breve_below", {
			unicode: ["1E2A", "1E2B"],
		},
		"lat_[c,s]_let_h__circumflex", {
			unicode: ["0124", "0125"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_h__caron", {
			unicode: ["021E", "021F"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_h__cedilla", {
			unicode: ["1E28", "1E29"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[c,s]_let_h__dot_above", {
			unicode: ["1E22", "1E23"],
		},
		"lat_[c,s]_let_h__dot_below", {
			unicode: ["1E24", "1E25"],
		},
		"lat_[c,s]_let_h__diaeresis", {
			unicode: ["1E26", "1E27"],
			options: { fastKey: "<+ $?Secondary" },
		},
		"lat_[c,s]_let_h__descender", {
			unicode: ["2C67", "2C68"],
		},
		"lat_[c,s]_let_h__common_hook", {
			unicode: ["A7AA", "0266"],
			recipe: ["$${arrow_left}"],
		},
		"lat_[s]_let_h__palatal_hook", {
			unicode: ["A795"],
		},
		"lat_[c,s]_let_h__stroke_short", {
			unicode: ["0126", "0127"],
			options: { fastKey: "$?Secondary" },
		},
		; Latin Letter “I”
		"lat_[c,s]_let_i__acute", {
			unicode: ["00CD", "00ED"],
			options: {
				fastKey: "$?Primary",
				telex__vietnamese: "$ \S\",
				telex__chinese_romanization: "$ \S\",
			},
		},
		"lat_[c,s]_let_i__breve", {
			unicode: ["012C", "012D"],
			options: {
				fastKey: "$?Secondary",
				telex__jorai: "$ \W\",
			}
		},
		"lat_[c,s]_let_i__breve_inverted", {
			unicode: ["020A", "020B"],
		},
		"lat_[c,s]_let_i__circumflex", {
			unicode: ["00CE", "00EE"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_i__caron", {
			unicode: ["01CF", "01D0"],
			options: {
				fastKey: "<!<+ $?Secondary",
				telex__chinese_romanization: "$ \V\",
			}
		},
		"lat_c_let_i__dot_above", {
			unicode: "0130",
			options: { fastKey: "<!<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_i__dot_below", {
			unicode: ["1ECA", "1ECB"],
			options: {
				telex__vietnamese: "$ \J\",
			},
		},
		"lat_[c,s]_let_i__diaeresis", {
			unicode: ["00CF", "00EF"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_i__grave", {
			unicode: ["00CC", "00EC"],
			options: {
				fastKey: "$?Tertiary",
				telex__vietnamese: "$ \F\",
				telex__chinese_romanization: "$ \F\",
			},
		},
		"lat_[c,s]_let_i__grave_double", {
			unicode: ["0208", "0209"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_i__hook_above", {
			unicode: ["1EC8", "1EC9"],
			options: {
				telex__vietnamese: "$ \R\",
			},
		},
		"lat_[s]_let_i__retroflex_hook", {
			unicode: ["1D96"]
		},
		"lat_[c,s]_let_i__macron", {
			unicode: ["012A", "012B"],
			options: {
				fastKey: ">+ $?Secondary",
				telex__chinese_romanization: "$ $",
			},
		},
		"lat_[c,s]_let_i__stroke_short", {
			unicode: ["0197", "0268"],
			tags: [[], ["close central unrounded vowel", "неогублённый гласный среднего ряда верхнего подъёма"]],
			groups: [["Latin Accented"], ["Latin Accented", "IPA"]],
			alterations: [{ smallCapital: "1D7B" }, {}],
			options: { altLayoutKey: ["", ">! $"], layoutTitles: ["", True] },
		},
		"lat_[c,s]_let_i__ogonek", {
			unicode: ["012E", "012F"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_i__tilde_above", {
			unicode: ["0128", "0129"],
			options: {
				fastKey: "<+>+ $?Secondary",
				telex__vietnamese: "$ \X\"
			},
		},
		"lat_[c,s]_let_i__tilde_below", {
			unicode: ["1E2C", "1E2D"]
		},
		"lat_[c,s]_let_i__diaeresis__acute", {
			unicode: ["1E2E", "1E2F"]
		},
		"lat_[s]_let_i__stroke_short__retroflex_hook", {
			unicode: ["1DF1A"]
		},
		; Latin Letter “J”
		"lat_[c,s]_let_j__circumflex", {
			unicode: ["0134", "0135"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_j__caron", {
			unicode: ["01F0", "01F0"],
			groups: [["Latin Reserved"], []],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[s]_let_j__crossed_tail", {
			unicode: ["A7B2"],
			recipe: ["$${arrow_right_ushaped}"],
		},
		"lat_[c,s]_let_j__stroke_short", {
			unicode: ["0248", "0249"],
			options: { fastKey: "$?Secondary" }
		},
		; Latin Letter “K”
		"lat_[c,s]_let_k__acute", {
			unicode: ["1E30", "1E31"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_k__caron", {
			unicode: ["01E8", "01E9"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_k__cedilla", {
			unicode: ["0136", "0137"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_k__dot_below", {
			unicode: ["1E32", "1E33"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_k__common_hook", {
			unicode: ["0199", "0198"],
			recipe: ["$${arrow_up}"]
		},
		"lat_[s]_let_k__palatal_hook", {
			unicode: ["1D84"]
		},
		"lat_[c,s]_let_k__solidus_long", {
			unicode: ["A7A2", "A7A3"]
		},
		"lat_[c,s]_let_k__solidus_short", {
			unicode: ["A742", "A743"]
		},
		"lat_[c,s]_let_k__stroke_short", {
			unicode: ["A740", "A741"]
		},
		"lat_[c,s]_let_k__line_below", {
			unicode: ["1E34", "1E35"]
		},
		"lat_[c,s]_let_k__descender", {
			unicode: ["2C69", "2C6A"],
		},
		"lat_[c,s]_let_k__stroke_short__solidus_short", {
			unicode: ["A744", "A745"]
		},
		; Latin Letter “L”
		"lat_[c,s]_let_l__acute", {
			unicode: ["0139", "013A"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_l__circumflex_below", {
			unicode: ["1E3C", "1E3D"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_l__caron", {
			unicode: ["013D", "013E"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_l__cedilla", {
			unicode: ["013B", "013C"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[s]_let_l__curl", {
			unicode: ["0234"],
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[c,s]_let_l__belt", {
			unicode: ["A7AD", "026C"],
			alterations: [{}, { modifier: "1079B" }],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[s]_let_l__fishhook", {
			unicode: ["1DF11"],
			recipe: ["$${arrow_right}"]
		},
		"lat_[c,s]_let_l__dot_below", {
			unicode: ["1E36", "1E37"]
		},
		"lat_[c,s]_let_l__dot_middle", {
			unicode: ["013F", "0140"],
			recipe: ["$${interpunct}"]
		},
		"lat_[s]_let_l__palatal_hook", {
			unicode: ["1D85"]
		},
		"lat_[s]_let_l__retroflex_hook", {
			unicode: ["026D"]
		},
		"lat_[s]_let_l__ring_middle", {
			unicode: ["AB39"],
			recipe: ["$${bullet_white}"]
		},
		"lat_[c,s]_let_l__solidus_short", {
			unicode: ["0141", "0142"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_l__stroke_short", {
			unicode: ["023D", "019A"],
		},
		"lat_[c,s]_let_l__stroke_short_high", {
			unicode: ["A748", "A749"],
			recipe: ["$${stroke_short}${arrow_up}"]
		},
		"lat_[c,s]_let_l__stroke_short_double", {
			unicode: ["2C60", "2C61"],
			recipe: ["$${stroke_short×2}"]
		},
		"lat_[c,s]_let_l__line_below", {
			unicode: ["1E3A", "1E3B"]
		},
		"lat_[c,s]_let_l__tilde_overlay", {
			unicode: ["2C62", "026B"]
		},
		"lat_[s]_let_l__tilde_overlay_double", {
			unicode: ["AB38"],
			alterations: { combining: "1DEC" },
			recipe: ["$${tilde_overlay×2}"]
		},
		"lat_[s]_let_l__inverted_lazy_s", {
			unicode: ["AB37"],
			recipe: ["$${inverted_lazy_s}"]
		},
		"lat_[c,s]_let_l__macron__dot_below", {
			unicode: ["1E38", "1E39"],
			recipe: ["$${(macron|dot_below)}$(*)", "${lat_[c,s]_let_l__dot_below}${macron}"]
		},
		"lat_[s]_let_l__belt__palatal_hook", {
			unicode: ["1DF13"],
			recipe: ["$${arrow_right_ushaped}${palatal_hook}",
				"${lat_s_let_l__belt}${palatal_hook}",
				"${lat_s_let_l__palatal_hook}${arrow_right_ushaped}"
			]
		},
		"lat_[s]_let_l__belt__retroflex_hook", {
			unicode: ["A78E"],
			alterations: { modifier: "1079D" },
			recipe: [
				"$${arrow_right_ushaped}${retroflex_hook}",
				"${lat_s_let_l__belt}${retroflex_hook}",
				"${lat_s_let_l__retroflex_hook}${arrow_right_ushaped}"
			]
		},
		; Latin Letter “M”
		"lat_[c,s]_let_m__acute", {
			unicode: ["1E3E", "1E3F"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_m__dot_above", {
			unicode: ["1E40", "1E41"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_m__dot_below", {
			unicode: ["1E42", "1E43"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[s]_let_m__crossed_tail", {
			unicode: ["AB3A"],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_m__common_hook", {
			unicode: ["2C6E", "0271"],
			alterations: [{}, { modifier: "1DAC" }],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_rightdown}"]
		},
		"lat_[s]_let_m__palatal_hook", {
			unicode: ["1D86"]
		},
		"lat_[s]_let_m__tilde_overlay", {
			unicode: ["1D6F"]
		},
		"lat_[s]_let_m_turned__long_leg", {
			unicode: ["0270"],
			alterations: { modifier: "1DAD" },
			recipe: ["$${arrow_left_circle}${arrow_down}"],
			symbol: { beforeLetter: "turned" }
		},
		; Latin Letter “N”
		"lat_[c,s]_let_n__acute", {
			unicode: ["0143", "0144"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_n__circumflex_below", {
			unicode: ["1E4A", "1E4B"]
		},
		"lat_[c,s]_let_n__caron", {
			unicode: ["0147", "0148"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_n__cedilla", {
			unicode: ["0145", "0146"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[s]_let_n__curl", {
			unicode: ["0235"],
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[s]_let_n__crossed_tail", {
			unicode: ["AB3B"],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_n__dot_above", {
			unicode: ["1E44", "1E45"],
			options: { fastKey: "<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_n__dot_below", {
			unicode: ["1E46", "1E47"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_n__descender", {
			unicode: ["A790", "A791"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_n__grave", {
			unicode: ["01F8", "01F9"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_n__common_hook", {
			unicode: ["019D", "0272"],
			alterations: [{}, { modifier: "1DAE" }],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_leftdown}"]
		},
		"lat_[s]_let_n__palatal_hook", {
			unicode: ["1D87"]
		},
		"lat_[s]_let_n__retroflex_hook", {
			unicode: ["0273"],
			alterations: { modifier: "1DAF" }
		},
		"lat_[c,s]_let_n__line_below", {
			unicode: ["1E48", "1E49"]
		},
		"lat_[c,s]_let_n__solidus_long", {
			unicode: ["A7A4", "A7A5"],
			recipe: ["$${solidus_long}"]
		},
		"lat_[c,s]_let_n__tilde_above", {
			unicode: ["00D1", "00F1"],
			options: {
				fastKey: "$?Secondary",
				telex__jorai: "$ $",
			}
		},
		"lat_[s]_let_n__tilde_overlay", {
			unicode: ["1D70"]
		},
		"lat_[c,s]_let_n__long_leg", {
			unicode: ["0220", "019E"],
			recipe: ["$${arrow_rightdown}"]
		},
		; Latin Letter “O”
		"lat_[c,s]_let_o__acute", {
			unicode: ["00D3", "00F3"],
			options: {
				fastKey: "$?Primary",
				telex__vietnamese: "$ \S\",
				telex__chinese_romanization: "$ \S\",
			},
		},
		"lat_[c,s]_let_o__acute_double", {
			unicode: ["0150", "0151"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__breve", {
			unicode: ["014E", "014F"],
			options: {
				telex__jorai: "$ \Q\",
			},
		},
		"lat_[c,s]_let_o__breve_inverted", {
			unicode: ["020E", "020F"]
		},
		"lat_[c,s]_let_o__circumflex", {
			unicode: ["00D4", "00F4"],
			options: {
				fastKey: "$?Secondary",
				telex__vietnamese: "$ $",
			},
		},
		"lat_[c,s]_let_o__caron", {
			unicode: ["01D1", "01D2"],
			options: {
				fastKey: "$?Secondary",
				telex__jorai: "$ \Z\",
				telex__chinese_romanization: "$ \V\",
			}
		},
		"lat_[c,s]_let_o__dot_above", {
			unicode: ["022E", "022F"]
		},
		"lat_[c,s]_let_o__dot_below", {
			unicode: ["1ECC", "1ECD"],
			options: {
				telex__vietnamese: "$ \J\",
			},
		},
		"lat_[c,s]_let_o__diaeresis", {
			unicode: ["00D6", "00F6"],
			alterations: [{}, { combining: "1DF3" }],
			options: {
				fastKey: "$?Secondary",
				telex__jorai: "$ 8",
			}
		},
		"lat_[c,s]_let_o__grave", {
			unicode: ["00D2", "00F2"],
			options: {
				fastKey: "$?Tertiary",
				telex__vietnamese: "$ \F\",
				telex__chinese_romanization: "$ \F\",
			},
		},
		"lat_[c,s]_let_o__grave_double", {
			unicode: ["020C", "020D"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[c,s]_let_o__loop", {
			unicode: ["A74C", "A74D"],
			recipe: ["$${arrow_up_ushaped}"]
		},
		"lat_[c,s]_let_o__hook_above", {
			unicode: ["1ECE", "1ECF"],
			options: {
				telex__vietnamese: "$ \R\",
			},
		},
		"lat_[s]_let_o__retroflex_hook", {
			unicode: ["1DF1B"]
		},
		"lat_[s]_let_o_open__retroflex_hook", {
			unicode: ["1D97"],
			recipe: ["$-${retroflex_hook}"],
			symbol: { beforeLetter: "open::3" }
		},
		"lat_[c,s]_let_o__horn", {
			unicode: ["01A0", "01A1"],
			options: {
				telex__vietnamese: "$ \W\",
			},
		},
		"lat_[c,s]_let_o__macron", {
			unicode: ["014C", "014D"],
			options: {
				fastKey: "$?Secondary",
				telex__chinese_romanization: "$ $",
			},
		},
		"lat_[c,s]_let_o__solidus_long", {
			unicode: ["00D8", "00F8"],
			tags: [[], ["close-mid front rounded vowel", "огублённый гласный переднего ряда средне-верхнего подъёма"]],
			alterations: [{}, { modifier: "107A2" }],
			groups: [["Latin Accented"], ["Latin Accented", "IPA"]],
			options: { fastKey: "$?Secondary", altLayoutKey: ["", ">!<! $"], layoutTitles: ["", True] }
		},
		"lat_[s]_let_o_open__solidus_long", {
			unicode: ["AB3F"],
			recipe: ["$-${solidus_long}"],
			symbol: { beforeLetter: "open::3" }
		},
		"lat_[s]_let_o_sideways__solidus_long", {
			unicode: ["1D13"],
			recipe: ["${arrow_right_circle}${solidus_long}"],
			symbol: { beforeLetter: "sideways::3" }
		},
		"lat_[c,s]_let_o__stroke_long", {
			unicode: ["A74A", "A74B"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__ogonek", {
			unicode: ["01EA", "01EB"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_o__tilde_above", {
			unicode: ["00D5", "00F5"],
			options: {
				fastKey: "$?Secondary",
				telex__vietnamese: "$ \X\",
			},
		},
		"lat_[c,s]_let_o__tilde_overlay", {
			unicode: ["019F", "0275"],
			tags: [[], ["close-mid central rounded vowel", "огублённый гласный среднего ряда средне-верхнего подъёма"]],
			alterations: [{}, { modifier: "1DB1" }],
			groups: [["Latin Accented"], ["Latin Accented", "IPA"]],
			options: { altLayoutKey: ["", "c*>!<! $"], layoutTitles: ["", True] }
		},
		"lat_[c,s]_let_o__circumflex__acute", {
			unicode: ["1ED0", "1ED1"],
			options: {
				telex__vietnamese: "$ \W S\ | $ 1 | ${lat_[c,s]_let_@__circumflex} \S\",
			},
		},
		"lat_[c,s]_let_o__circumflex__dot_below", {
			unicode: ["1ED8", "1ED9"],
			options: {
				telex__vietnamese: "$ \W J\ | $ 4 | ${lat_[c,s]_let_@__circumflex} \J\",
			},
		},
		"lat_[c,s]_let_o__circumflex__grave", {
			unicode: ["1ED2", "1ED3"],
			options: {
				telex__vietnamese: "$ \W F\ | $ 2 | ${lat_[c,s]_let_@__circumflex} \F\",
			},
		},
		"lat_[c,s]_let_o__circumflex__hook_above", {
			unicode: ["1ED4", "1ED5"],
			options: {
				telex__vietnamese: "$ \W R\ | $ 3 | ${lat_[c,s]_let_@__circumflex} \R\",
			},
		},
		"lat_[c,s]_let_o__circumflex__tilde_above", {
			unicode: ["1ED6", "1ED7"],
			options: {
				telex__vietnamese: "$ \W X\ | $ 5 | ${lat_[c,s]_let_@__circumflex} \X\",
			},
		},
		"lat_[c,s]_let_o__horn__acute", {
			unicode: ["1EDA", "1EDB"],
			options: {
				telex__vietnamese: "$ \W S\ | P 1 | ${lat_[c,s]_let_@__horn} \S\",
			},
		},
		"lat_[c,s]_let_o__horn__dot_below", {
			unicode: ["1EE2", "1EE3"],
			options: {
				telex__vietnamese: "$ \W J\ | P 4 | ${lat_[c,s]_let_@__horn} \J\",
			},
		},
		"lat_[c,s]_let_o__horn__grave", {
			unicode: ["1EDC", "1EDD"],
			options: {
				telex__vietnamese: "$ \W F\ | P 2 | ${lat_[c,s]_let_@__horn} \F\",
			},
		},
		"lat_[c,s]_let_o__horn__hook_above", {
			unicode: ["1EDE", "1EDF"],
			options: {
				telex__vietnamese: "$ \W R\ | P 3 | ${lat_[c,s]_let_@__horn} \R\",
			},
		},
		"lat_[c,s]_let_o__horn__tilde_above", {
			unicode: ["1EE0", "1EE1"],
			options: {
				telex__vietnamese: "$ \W X\ | P 5 | ${lat_[c,s]_let_@__horn} \X\",
			},
		},
		"lat_[c,s]_let_o__macron__acute", {
			unicode: ["1E52", "1E53"]
		},
		"lat_[c,s]_let_o__macron__dot_above", {
			unicode: ["0230", "0231"]
		},
		"lat_[c,s]_let_o__diaeresis__macron", {
			unicode: ["022A", "022B"]
		},
		"lat_[c,s]_let_o__macron__grave", {
			unicode: ["1E50", "1E51"]
		},
		"lat_[c,s]_let_o__macron__ogonek", {
			unicode: ["01EC", "01ED"]
		},
		"lat_[c,s]_let_o__macron__tilde_above", {
			unicode: ["022C", "022D"]
		},
		"lat_[c,s]_let_o__solidus_long__acute", {
			unicode: ["01FE", "01FF"]
		},
		"lat_[c,s]_let_o__tilde_above__acute", {
			unicode: ["1E4C", "1E4D"]
		},
		"lat_[c,s]_let_o__tilde_above__diaeresis", {
			unicode: ["1E4E", "1E4F"]
		},
		; Latin Letter “P”
		"lat_[c,s]_let_p__acute", {
			unicode: ["1E54", "1E55"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_p__dot_above", {
			unicode: ["1E56", "1E57"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_p__squirrel_tail", {
			unicode: ["A754", "A755"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_leftup}"]
		},
		"lat_[c,s]_let_p__common_hook", {
			unicode: ["01A4", "01A5"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_left}"]
		},
		"lat_[s]_let_p__palatal_hook", {
			unicode: ["1D88"]
		},
		"lat_[c,s]_let_p__flourish", {
			unicode: ["A752", "A753"],
			options: { fastKey: "<!<+ $?Secondary" },
			recipe: ["$${arrow_left_ushaped}"]
		},
		"lat_[c,s]_let_p__stroke_short", {
			unicode: ["2C63", "1D7D"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_p__stroke_short_down", {
			unicode: ["A750", "A751"],
			recipe: ["$${stroke_short}${arrow_down}"]
		},
		"lat_[s]_let_p__tilde_overlay", {
			unicode: ["1D71"]
		},
		; Latin Letter “Q”
		"lat_[c,s]_let_q__common_hook", {
			unicode: ["024A", "024B"],
			options: { fastKey: ">+ $?Secondary" },
			recipe: ["$${arrow_right}"]
		},
		"lat_[s]_let_q__common_hook", {
			unicode: ["02A0"],
			recipe: ["$${arrow_up}"]
		},
		"lat_[c,s]_let_q__solidus_long", {
			unicode: ["A758", "A759"]
		},
		"lat_[c,s]_let_q__stroke_short_down", {
			unicode: ["A756", "A757"],
			recipe: ["$${stroke_short}${arrow_down}"]
		},
		; Latin Letter “R”
		"lat_[c,s]_let_r__acute", {
			unicode: ["0154", "0155"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_r__breve_inverted", {
			unicode: ["0212", "0213"]
		},
		"lat_[c,s]_let_r__caron", {
			unicode: ["0158", "0159"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_r__cedilla", {
			unicode: ["0156", "0157"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[s]_let_r__crossed_tail", {
			unicode: ["AB49"],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_r__dot_above", {
			unicode: ["1E58", "1E59"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_r__dot_below", {
			unicode: ["1E5A", "1E5B"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_r__grave_double", {
			unicode: ["0210", "0211"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[s]_let_r__palatal_hook", {
			unicode: ["1D89"]
		},
		"lat_[c,s]_let_r__line_below", {
			unicode: ["1E5E", "1E5F"]
		},
		"lat_[c,s]_let_r__solidus_long", {
			unicode: ["A7A6", "A7A7"]
		},
		"lat_[c,s]_let_r__stroke_short", {
			unicode: ["024C", "024D"]
		},
		"lat_[c,s]_let_r__tail", {
			unicode: ["2C64", "027D"],
			recipe: ["$${arrow_down}"]
		},
		"lat_[s]_let_r__tilde_overlay", {
			unicode: ["1D72"]
		},
		"lat_[s]_let_r__long_leg", {
			unicode: ["027C"],
			recipe: ["$${arrow_rightdown}"]
		},
		"lat_[c,s]_let_r__macron__dot_below", {
			unicode: ["1E5C", "1E5D"],
			recipe: ["$${(macron|dot_below)}$(*)", "${lat_[c,s]_let_r__dot_below}${macron}"]
		},
		; Latin Letter “S”
		"lat_[c,s]_let_s__acute", {
			unicode: ["015A", "015B"],
			options: { fastKey: "$?Primary" },
		},
		"lat_[c,s]_let_s__comma_below", {
			unicode: ["0218", "0219"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_s__circumflex", {
			unicode: ["015C", "015D"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[c,s]_let_s__caron", {
			unicode: ["0160", "0161"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_s__cedilla", {
			unicode: ["015E", "015F"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_s__curl", {
			unicode: ["1DF1E"],
			alterations: [{ modifier: "107BA" }],
			recipe: ["$${arrow_right_ushaped}"],
		},
		"lat_[c,s]_let_s__dot_above", {
			unicode: ["1E60", "1E61"],
		},
		"lat_[c,s]_let_s__dot_below", {
			unicode: ["1E62", "1E63"],
		},
		"lat_[c,s]_let_s__common_hook", {
			unicode: ["A7C5", "0282"],
			alterations: [{}, { modifier: "1DB3" }],
			recipe: ["$${arrow_down}"],
		},
		"lat_[c,s]_let_s__swash_tail", {
			unicode: ["2C7E", "023F"],
			recipe: ["$${arrow_rightdown}"],
		},
		"lat_[s]_let_s__palatal_hook", {
			unicode: ["1D8A"],
		},
		"lat_[c,s]_let_s__solidus_long", {
			unicode: ["A7A8", "A7A9"],
			recipe: ["$${solidus_long}"],
		},
		"lat_[c,s]_let_s__stroke_short", {
			unicode: ["A7C9", "A7CA"],
			recipe: ["$${stroke_short}"],
		},
		"lat_[s]_let_s__tilde_overlay", {
			unicode: ["1D74"],
			recipe: ["$${tilde_overlay}"],
		},
		"lat_[c,s]_let_s__acute__dot_above", {
			unicode: ["1E64", "1E65"],
		},
		"lat_[c,s]_let_s__caron__dot_above", {
			unicode: ["1E66", "1E67"],
		},
		"lat_[c,s]_let_s__dot_above__dot_below", {
			unicode: ["1E68", "1E69"],
		},
		; Latin Letter “T”
		"lat_[c,s]_let_t__comma_below", {
			unicode: ["021A", "021B"],
			options: { fastKey: "$?Secondary" },
		},
		"lat_[c,s]_let_t__circumflex_below", {
			unicode: ["1E70", "1E71"],
		},
		"lat_[c,s]_let_t__caron", {
			unicode: ["0164", "0165"],
			options: { fastKey: "<!<+ $?Secondary" },
		},
		"lat_[c,s]_let_t__cedilla", {
			unicode: ["0162", "0163"],
			options: { fastKey: "<!>+ $?Secondary" },
		},
		"lat_[s]_let_t__curl", {
			unicode: ["0236"],
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_t__dot_above", {
			unicode: ["1E6A", "1E6B"],
			options: { fastKey: "<+ $?Secondary" },
		},
		"lat_[c,s]_let_t__dot_below", {
			unicode: ["1E6C", "1E6D"],
			options: { fastKey: "<! $?Secondary" },
		},
		"lat_[s]_let_t__diaeresis", {
			unicode: ["1E97"],
		},
		"lat_[c,s]_let_t__common_hook", {
			unicode: ["01AC", "01AD"],
			recipe: ["$${arrow_left}"],
		},
		"lat_[s]_let_t__palatal_hook", {
			unicode: ["01AB"],
			alterations: { modifier: "1DB5" },
		},
		"lat_[c,s]_let_t__retroflex_hook", {
			unicode: ["01AE", "0288"],
			alterations: [{}, { modifier: "107AF" }],
		},
		"lat_[s]_let_t__retroflex_hook__common_hook", {
			unicode: ["1DF09"],
			recipe: ["$${retroflex_hook}${arrow_left}", "${lat_s_let_t__retroflex_hook}${arrow_left}"],
		},
		"lat_[c,s]_let_t__line_below", {
			unicode: ["1E6E", "1E6F"],
		},
		"lat_[c,s]_let_t__solidus_long", {
			unicode: ["023E", "2C66"],
		},
		"lat_[c,s]_let_t__stroke_short", {
			unicode: ["0166", "0167"],
		},
		"lat_[s]_let_t__tilde_overlay", {
			unicode: ["1D75"],
		},
		; Latin Letter “U”
		"lat_[c,s]_let_u__acute", {
			unicode: ["00DA", "00FA"],
			options: {
				fastKey: "$?Primary",
				telex__vietnamese: "$ \S\",
				telex__chinese_romanization: "$ \S\",
			}
		},
		"lat_[c,s]_let_u__acute_double", {
			unicode: ["0170", "0171"],
			options: { fastKey: "<!<+>+ $?Secondary" }
		},
		"lat_[c,s]_let_u__breve", {
			unicode: ["016C", "016D"],
			options: {
				fastKey: "$?Secondary",
				telex__jorai: "$ \Q\",
			}
		},
		"lat_[c,s]_let_u__breve_inverted", {
			unicode: ["0216", "0217"]
		},
		"lat_[c,s]_let_u__circumflex", {
			unicode: ["00DB", "00FB"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_u__caron", {
			unicode: ["01D3", "01D4"],
			options: {
				telex__chinese_romanization: "$ \V\",
			}
		},
		"lat_[c,s]_let_u__dot_below", {
			unicode: ["1EE4", "1EE5"],
			options: {
				telex__vietnamese: "$ \J\",
			},
		},
		"lat_[c,s]_let_u__diaeresis", {
			unicode: ["00DC", "00FC"],
			options: {
				fastKey: "<+ $?Secondary",
				telex__jorai: "$ 8",
				telex__chinese_romanization: "$ 8",
			}
		},
		"lat_[c,s]_let_u__diaeresis_below", {
			unicode: ["1E72", "1E73"]
		},
		"lat_[c,s]_let_u__grave", {
			unicode: ["00D9", "00F9"],
			options: { fastKey: "$?Tertiary",
				telex__vietnamese: "$ \F\",
				telex__chinese_romanization: "$ \F\",
			}
		},
		"lat_[c,s]_let_u__grave_double", {
			unicode: ["0214", "0215"],
			options: { fastKey: "<+ $?Tertiary" }
		},
		"lat_[c,s]_let_u__hook_above", {
			unicode: ["1EE6", "1EE7"],
			options: {
				telex__vietnamese: "$ \R\",
			},
		},
		"lat_[s]_let_u__retroflex_hook", {
			unicode: ["1D99"]
		},
		"lat_[c,s]_let_u__horn", {
			unicode: ["01AF", "01B0"],
			options: {
				telex__vietnamese: "$ \W\",
			},
		},
		"lat_[c,s]_let_u__macron", {
			unicode: ["016A", "016B"],
			options: {
				fastKey: ">+ $?Secondary",
				telex__chinese_romanization: "$ $",
			}
		},
		"lat_[c,s]_let_u__ring_above", {
			unicode: ["016E", "016F"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_u__stroke_long", {
			unicode: ["0244", "0289"],
			tags: [[], ["close central rounded vowel", "огублённый гласный среднего ряда верхнего подъёма"]],
			alterations: [{}, { modifier: "1DB6" }],
			groups: [["Latin Accented"], ["Latin Accented", "IPA"]],
			options: { altLayoutKey: ["", ">!<!<+ $"], layoutTitles: ["", True] }
		},
		"lat_[c,s]_let_u__solidus_long", {
			unicode: ["A7B8", "A7B9"]
		},
		"lat_[c,s]_let_u__ogonek", {
			unicode: ["0172", "0173"],
			options: { fastKey: "<!>+ $?Secondary" }
		},
		"lat_[c,s]_let_u__tilde_above", {
			unicode: ["0168", "0169"],
			options: {
				fastKey: "<+>+ $?Secondary",
				telex__vietnamese: "$ \X\",
			}
		},
		"lat_[c,s]_let_u__tilde_below", {
			unicode: ["1E74", "1E75"]
		},
		"lat_[c,s]_let_u__horn__acute", {
			unicode: ["1EE8", "1EE9"],
			options: {
				telex__vietnamese: "$ \W S\ | $ 1 | ${lat_[c,s]_let_@__horn} \S\",
			},
		},
		"lat_[c,s]_let_u__horn__dot_below", {
			unicode: ["1EF0", "1EF1"],
			options: {
				telex__vietnamese: "$ \W J\ | $ 4 | ${lat_[c,s]_let_@__horn} \J\",
			},
		},
		"lat_[c,s]_let_u__horn__grave", {
			unicode: ["1EEA", "1EEB"],
			options: {
				telex__vietnamese: "$ \W F\ | $ 2 | ${lat_[c,s]_let_@__horn} \F\",
			},
		},
		"lat_[c,s]_let_u__horn__hook_above", {
			unicode: ["1EEC", "1EED"],
			options: {
				telex__vietnamese: "$ \W R\ | $ 3 | ${lat_[c,s]_let_@__horn} \R\",
			},
		},
		"lat_[c,s]_let_u__horn__tilde_above", {
			unicode: ["1EEE", "1EEF"],
			options: {
				telex__vietnamese: "$ \W X\ | $ 5 | ${lat_[c,s]_let_@__horn} \X\",
			},
		},
		"lat_[c,s]_let_u__diaeresis__acute", {
			unicode: ["01D7", "01D8"],
			options: {
				telex__chinese_romanization: "$ 1 | ${lat_[c,s]_let_@__diaeresis} \S\",
			},
		},
		"lat_[c,s]_let_u__diaeresis__caron", {
			unicode: ["01D9", "01DA"],
			options: {
				telex__chinese_romanization: "$ 3 | ${lat_[c,s]_let_@__diaeresis} \V\",
			},
		},
		"lat_[c,s]_let_u__diaeresis__grave", {
			unicode: ["01DB", "01DC"],
			options: {
				telex__chinese_romanization: "$ 2 | ${lat_[c,s]_let_@__diaeresis} \F\",
			},
		},
		"lat_[c,s]_let_u__diaeresis__macron", {
			unicode: ["01D5", "01D6"],
			options: {
				telex__chinese_romanization: "$ 4 | ${lat_[c,s]_let_@__diaeresis} $",
			},
		},
		"lat_[c,s]_let_u__tilde_above__acute", {
			unicode: ["1E78", "1E79"]
		},
		; Latin Letter “V”
		"lat_[s]_let_v__curl", {
			unicode: ["2C74"],
			recipe: ["$${arrow_left_ushaped}"],
		},
		"lat_[c,s]_let_v__dot_below", {
			unicode: ["1E7E", "1E7F"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_v__common_hook", {
			unicode: ["01B2", "028B"],
			recipe: ["$${arrow_up}"],
		},
		"lat_[s]_let_v__right_hook", {
			unicode: ["2C71"],
			alterations: [{ modifier: "107B0" }],
			recipe: ["$${arrow_right}"],
		},
		"lat_[s]_let_v__palatal_hook", {
			unicode: ["1D8C"]
		},
		"lat_[c,s]_let_v__solidus_long", {
			unicode: ["A75E", "A75F"],
			options: { fastKey: "$?Secondary" },
			recipe: ["$${solidus_long}"],
		},
		"lat_[c,s]_let_v__tilde_above", {
			unicode: ["1E7C", "1E7D"],
			options: { fastKey: "$?Secondary" }
		},
		; Latin Letter “W”
		"lat_[c,s]_let_w__acute", {
			unicode: ["1E82", "1E83"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_w__circumflex", {
			unicode: ["0174", "0175"],
			options: { fastKey: "<!$?Secondary" }
		},
		"lat_[c,s]_let_w__dot_above", {
			unicode: ["1E86", "1E87"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_w__dot_below", {
			unicode: ["1E88", "1E89"],
			options: { fastKey: "<!<+$?Secondary" }
		},
		"lat_[c,s]_let_w__diaeresis", {
			unicode: ["1E84", "1E85"],
			options: { fastKey: "<+$?Secondary" }
		},
		"lat_[c,s]_let_w__grave", {
			unicode: ["1E80", "1E81"],
			options: { fastKey: "$?Tertiary" }
		},
		"lat_[s]_let_w__ring_above", {
			unicode: ["1E98"]
		},
		; Latin Letter “X”
		"lat_[c,s]_let_x__dot_above", {
			unicode: ["1E8A", "1E8B"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_x__diaeresis", {
			unicode: ["1E8C", "1E8D"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[s]_let_x__palatal_hook", {
			unicode: ["1D8D"]
		},
		; Latin Letter “Y”
		"lat_[c,s]_let_y__acute", {
			unicode: ["00DD", "00FD"],
			options: {
				fastKey: "$?Primary",
				telex__vietnamese: "$ \S\",
			}
		},
		"lat_[c,s]_let_y__circumflex", {
			unicode: ["0176", "0177"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_y__dot_above", {
			unicode: ["1E8E", "1E8F"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_y__dot_below", {
			unicode: ["1EF4", "1EF5"],
			options: {
				telex__vietnamese: "$ \J\",
			},
		},
		"lat_[c,s]_let_y__diaeresis", {
			unicode: ["0178", "00FF"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[c,s]_let_y__grave", {
			unicode: ["1EF2", "1EF3"],
			options: {
				fastKey: "$?Tertiary",
				telex__vietnamese: "$ \F\",
			}
		},
		"lat_[c,s]_let_y__loop", {
			unicode: ["1EFE", "1EFF"],
			options: { fastKey: "<!>+ $?Secondary" },
			recipe: ["$${arrow_up_ushaped}"]
		},
		"lat_[c,s]_let_y__hook_above", {
			unicode: ["1EF6", "1EF7"],
			options: {
				telex__vietnamese: "$ \R\",
			},
		},
		"lat_[c,s]_let_y__common_hook", {
			unicode: ["01B3", "01B4"],
			recipe: ["$${arrow_up}"]
		},
		"lat_[s]_let_y__ring_above", {
			unicode: ["1E99"]
		},
		"lat_[c,s]_let_y__stroke_short", {
			unicode: ["024E", "024F"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[c,s]_let_y__macron", {
			unicode: ["0232", "0233"],
			options: { fastKey: ">+ $?Secondary" }
		},
		"lat_[c,s]_let_y__tilde_above", {
			unicode: ["1EF8", "1EF9"],
			options: {
				fastKey: "<+>+ $?Secondary",
				telex__vietnamese: "$ \X\",
			}
		},
		; Latin Letter “Z”
		"lat_[c,s]_let_z__acute", {
			unicode: ["0179", "017A"],
			options: { fastKey: "$?Primary" }
		},
		"lat_[c,s]_let_z__circumflex", {
			unicode: ["1E90", "1E91"],
			options: { fastKey: "<! $?Secondary" }
		},
		"lat_[c,s]_let_z__caron", {
			unicode: ["017D", "017E"],
			options: { fastKey: "<!<+ $?Secondary" }
		},
		"lat_[s]_let_z__curl", {
			unicode: ["0291"],
			alterations: [{ modifier: "1DBD" }],
			recipe: ["$${arrow_right_ushaped}"]
		},
		"lat_[c,s]_let_z__dot_above", {
			unicode: ["017B", "017C"],
			options: { fastKey: "$?Secondary" }
		},
		"lat_[c,s]_let_z__dot_below", {
			unicode: ["1E92", "1E93"]
		},
		"lat_[c,s]_let_z__descender", {
			unicode: ["2C6B", "2C6C"]
		},
		"lat_[c,s]_let_z__common_hook", {
			unicode: ["0224", "0225"],
			recipe: ["$-${arrow_down}"]
		},
		"lat_[c,s]_let_z__swash_hook", {
			unicode: ["2C7F", "0240"],
			recipe: ["$${arrow_rightdown}"]
		},
		"lat_c_let_z__palatal_hook", {
			unicode: "1D8E"
		},
		"lat_[c,s]_let_z__line_below", {
			unicode: ["1E94", "1E95"]
		},
		"lat_[c,s]_let_z__stroke_short", {
			unicode: ["01B5", "01B6"],
			options: { fastKey: "<+ $?Secondary" }
		},
		"lat_[s]_let_z__tilde_overlay", {
			unicode: ["1D76"]
		},
		;
		;
		; * Latin Ligatures
		;
		;
		"lat_[c,s]_lig_aa", { unicode: ["A732", "A733"] },
		"lat_[c,s]_lig_ae", {
			unicode: ["00C6", "00E6"],
			alterations: [{ modifier: "1D2D", smallCapital: "1D01" }, { combining: "1DD4", modifier: "10783" }],
			groups: [[], ["Latin Ligatures", "IPA"]],
			tags: [[], ["near-open front unrounded vowel", "ненапряжённый неогублённый гласный переднего ряда нижнего подъёма"]],
			options: { altLayoutKey: ["", ">!<!<+ /A/"], layoutTitles: [False, True] },
			recipe: ["$"],
		},
		"lat_[c,s]_lig_ae__acute", {
			unicode: ["01FC", "01FD"],
		},
		"lat_[c,s]_lig_ae__macron", {
			unicode: ["01E2", "01E3"],
		},
		"lat_[s]_lig_ae_turned", {
			unicode: ["1D02"],
			recipe: ["$${arrow_left_circle}", "${lat_s_lig_ae}${arrow_left_circle}", "${lat_s_let_e_turned}${lat_s_let_a_turned}"],
			alterations: [{}, { modifier: "1D46" }],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[c,s]_lig_ao", {
			unicode: ["A734", "A735"],
			alterations: [{}, { combining: "1DD5" }]
		},
		"lat_[c,s]_lig_au", { unicode: ["A736", "A737"], recipe: ["$"] },
		"lat_[c,s]_lig_av", {
			unicode: ["A738", "A739"],
			alterations: [{}, { combining: "1DD6" }]
		},
		"lat_[c,s]_lig_av__stroke_short", {
			unicode: ["A73A", "A73B"]
		},
		"lat_[c,s]_lig_ay", { unicode: ["A73C", "A73D"] },
		"lat_[s]_lig_db", { unicode: ["0238"] },
		"lat_[s]_lig_et", {
			unicode: ["0026"],
			alterations: {
				small: "FE60",
				fullwidth: "FF06"
			},
			tags: ["амперсанд", "ampersand"],
			groups: ["Latin Ligatures"]
		},
		"lat_[s]_lig_et_turned", {
			unicode: ["214B"],
			tags: ["перевёрнутый амперсанд", "turned ampersand"],
			recipe: ["$${arrow_left_circle}", "${lat_s_lig_et}${arrow_left_circle}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_ie", { unicode: ["AB61"] },
		"lat_[s]_lig_ff", { unicode: ["FB00"] },
		"lat_[s]_lig_fi", { unicode: ["FB01"] },
		"lat_[s]_lig_fl", { unicode: ["FB02"] },
		"lat_[s]_lig_ffi", {
			unicode: ["FB04"],
			recipe: ["$", "${lat_s_lig_ff}i"]
		},
		"lat_[s]_lig_ffl", {
			unicode: ["FB03"],
			recipe: ["$", "${lat_s_lig_ff}l"]
		},
		"lat_[c,s]_lig_ij", { unicode: ["0132", "0133"] },
		"lat_[s]_lig_lb", { unicode: ["2114"] },
		"lat_[c,s]_lig_oi", { unicode: ["01A2", "01A3"] },
		"lat_[c,s]_lig_oe", {
			unicode: ["0152", "0153"],
			groups: [["Latin Ligatures", "IPA"], ["Latin Ligatures", "IPA"]],
			tags: [["open front rounded vowel", "огублённый гласный переднего ряда нижнего подъёма"], ["open-mid front rounded vowel", "огублённый гласный переднего ряда средне-нижнего подъёма"]],
			options: { altLayoutKey: ["c*>!<!<+ /O/", ">!<!<+ /O/"], showOnAlt: ["smallCapital", ""], layoutTitles: [True, True] },
			alterations: [{ smallCapital: "0276" }, { modifier: "A7F9" }]
		},
		"lat_[s]_lig_oe_turned", {
			unicode: ["1D14"],
			recipe: ["$${arrow_left_circle}", "${lat_s_lig_oe}${arrow_left_circle}", "${lat_s_let_e_turned}o"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_oe_turned__stroke_short", {
			unicode: ["AB42"],
			recipe: ["$${arrow_left_circle}${stroke_short}", "${lat_s_lig_oe}${arrow_left_circle}${stroke_short}", "${lat_s_lig_oe_turned}${stroke_short}", "${lat_s_let_e_turned}o${stroke_short}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_oe_turned__solidus_long", {
			unicode: ["AB41"],
			recipe: ["$${arrow_left_circle}${solidus_long}", "${lat_s_lig_oe}${arrow_left_circle}${solidus_long}", "${lat_s_lig_oe_turned}${solidus_long}", "${lat_s_let_e_turned}o${solidus_long}"],
			symbol: { beforeLetter: "turned" },
		},
		"lat_[s]_lig_oe_inverted", {
			unicode: ["AB40"],
			recipe: ["$${arrow_up_ushaped}", "${lat_s_lig_oe}${arrow_up_ushaped}"],
			symbol: { beforeLetter: "inverted" },
		},
		"lat_[c,s]_lig_oo", {
			unicode: ["A74E", "A74F"]
		},
		"lat_[c,s]_lig_ou", {
			unicode: ["0222", "0223"]
		},
		"lat_[s]_lig_pl", { unicode: ["214A"] },
		"lat_[s]_lig_st_long", {
			unicode: ["FB05"],
			recipe: ["$"],
			symbol: { letter: "${lat_s_let_s_long}t" }
		},
		"lat_[s]_lig_st", { unicode: ["FB06"], recipe: ["$"] },
		"lat_[s]_lig_ue", { unicode: ["1D6B"] },
		"lat_[s]_lig_uo", { unicode: ["AB63"] },
		"lat_[c,s]_lig_s_eszett", {
			unicode: ["1E9E", "00DF"],
			options: { useLetterLocale: True, fastKey: "<+ ~?Secondary" },
			recipe: ["$", "${lat_s_let_s_long}${lat_[c,s]_let_s}", "${lat_s_let_s_long}${lat_[c,s]_let_z_ezh}"],
			symbol: { letter: ["SS", "ss"] },
		},
		"lat_[c,s]_lig_vy", {
			unicode: ["A760", "A761"]
		},
		;
		;
		; * Latin Digraphs
		;
		;
		"lat_[c,i,s]_dig_dz", {
			unicode: ["01F1", "01F2", "01F3"],
			symbol: { letter: "${lat_[c,c,s]_let_d}${lat_[c,s,s]_let_z}" }
		},
		"lat_[c,i,s]_dig_dz__caron", {
			unicode: ["01C4", "01C5", "01C6"],
			symbol: { letter: "${lat_[c,c,s]_let_d}${lat_[c,s,s]_let_z}" },
		},
		"lat_[s]_dig_dz__curl", {
			unicode: ["02A5"],
			recipe: ["$${arrow_left_ushaped}", "${lat_s_dig_dz}${arrow_left_ushaped}"],
		},
		"lat_[c,i,s]_dig_lj", {
			unicode: ["01C7", "01C8", "01C9"],
			symbol: { letter: "${lat_[c,c,s]_let_l}${lat_[c,s,s]_let_j}" }
		},
		"lat_[s]_dig_feng", {
			unicode: ["02A9"],
			tags: ["voiceless velopharyngeal fricative", "велофарингальный фрикативный согласный"],
			groups: [["Latin Digraphs", "IPA"]],
			alterations: { modifier: "10790" },
			options: {
				layoutTitles: ["", True], altLayoutKey: ["", "<!>! $"],
				useLetterLocale: True
			},
			recipe: ["fng", "f${lat_s_let_n_eng}"],
		},
		"lat_[s]_dig_feng__trill", {
			unicode: ["1DF00"],
			tags: ["voiceless velopharyngeal trill", "велофарингальный трелевой согласный"],
			options: { useLetterLocale: "Origin" },
			recipe: ["fng${arrow_up}", "f${lat_s_let_n_eng}${arrow_up}", "${lat_s_dig_feng}${arrow_up}"],
		},
		"lat_[s]_dig_ls", {
			unicode: ["02AA"],
		},
		"lat_[s]_dig_lz", {
			unicode: ["02AB"],
		},
		"lat_[c,i,s]_dig_nj", {
			unicode: ["01CA", "01CB", "01CC"],
			symbol: { letter: "${lat_[c,c,s]_let_n}${lat_[c,s,s]_let_j}" }
		},
		"lat_[s]_dig_tc__curl", {
			unicode: ["02A8"],
			recipe: ["$${arrow_left_ushaped}", "t${lat_s_let_c__curl}"],
		},
		"lat_[s]_dig_tch", {
			unicode: ["02A7"],
			recipe: ["$", "t${lat_s_let_s_sigma}"],
		},
		"lat_[s]_dig_th__solidus_long", {
			unicode: ["1D7A"],
			recipe: ["$${solidus_long}"],
		},
		"lat_[s]_dig_ts", {
			unicode: ["02A6"],
		},
		;
		;
		; * Uncommon Cyrillic Letters
		;
		;
		"cyr_[c,s]_let_yus_little", {
			unicode: ["0466", "0467"],
			alterations: [{}, { combining: "2DFD", }],
			options: { useLetterLocale: True, fastKey: "/Я/?Secondary" },
			recipe: ["\ат\"]
		},
		"cyr_[c,s]_let_yus_little_closed", {
			unicode: ["A658", "A659"],
			options: { useLetterLocale: True },
			recipe: ["\а_т\", "${cyr_[c,s]_let_yus_little}_"]
		},
		"cyr_[c,s]_let_yus_big", {
			unicode: ["046A", "046B"],
			alterations: [{}, { combining: "2DFE", }],
			options: { useLetterLocale: True, fastKey: "/У/?Secondary" },
			recipe: ["\аж\"]
		},
		"cyr_[c,s]_let_yus_blended", {
			unicode: ["A65A", "A65B"],
			options: { useLetterLocale: True },
			recipe: ["\ажат\", "${(cyr_[c,s]_let_yus_big|cyr_[c,s]_let_yus_little)}$(*)"]
		},
		"cyr_[c,s]_let_ye_anchor", {
			unicode: ["0404", "0454"],
			alterations: [{}, { combining: "A674" }],
			options: { secondName: True, fastKey: "/Э/?Secondary" },
			symbol: { letter: "%self%" }
		},
		"cyr_[c,s]_let_ye_yat", {
			unicode: ["0462", "0463"],
			alterations: [{}, { combining: "2DFA" }],
			options: { useLetterLocale: True, fastKey: "/Е/?Secondary" },
			recipe: ["/Ь/${stroke_long}"]
		},
		"cyr_[s]_let_ye_yat_tall", {
			unicode: ["1C87"],
			options: { useLetterLocale: True },
			recipe: ["ь${stroke_long}${arrow_up}", "${cyr_s_let_ye_yat}${arrow_up}"],
		},
		"cyr_[c,s]_let_zh_dzhe", {
			unicode: ["040F", "045F"],
			alterations: [{}, { subscript: "1E06A" }],
			options: { useLetterLocale: True, fastKey: "/Ж/?Secondary" },
			recipe: ["\дзж\"]
		},
		"cyr_[c,s]_let_zh_dje", {
			unicode: ["0402", "0452"],
			options: { useLetterLocale: True, fastKey: ">+ /Ж/?Secondary" },
			recipe: ["\джь\"]
		},
		"cyr_[c,s]_let_z_dzelo", {
			unicode: ["0405", "0455"],
			options: { useLetterLocale: True, fastKey: "/З/?Secondary" },
			recipe: ["\зел\"]
		},
		"cyr_[c,s]_let_z_dzelo_reversed", {
			unicode: ["A644", "A645"],
			options: { useLetterLocale: True, referenceLocale: "dzelo$" },
			recipe: ["\зел\${arrow_left}", "${cyr_[c,s]_let_z_dzelo}${arrow_left}"],
			symbol: { beforeLetter: "reversed" }
		},
		"cyr_[c,s]_let_z_zemlya", {
			unicode: ["A640", "A641"],
			options: { useLetterLocale: True, fastKey: ">+ /З/?Secondary" },
			recipe: ["\зем\"]
		},
		"cyr_[c,s]_let_z_dzelo_archaic", {
			unicode: ["A642", "A643"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_z_zemlya}-", "-${cyr_[c,s]_let_z_zemlya}"]
		},
		"cyr_[c,s]_let_i_decimal", {
			unicode: ["0406", "0456"],
			alterations: [{}, { combining: "1E08F", modifier: "1E04C", subscript: "1E068" }],
			options: { secondName: True, fastKey: "/И/?Secondary" },
		},
		"cyr_[c,s]_let_i_izhitsa", {
			unicode: ["0474", "0475"],
			options: { secondName: True, fastKey: "<! /И/?Secondary" },
		},
		"cyr_[c,s]_let_l_palochka", {
			unicode: ["04C0", "04CF"],
			options: { useLetterLocale: True, fastKey: "<+<! /Л/?Secondary" }
		},
		"cyr_[c,s]_let_h_shha", {
			unicode: ["04BA", "04BB"],
			options: { useLetterLocale: True, fastKey: "/Х/?Secondary" },
			recipe: ["\хх\"]
		},
		"cyr_[c,s]_let_h_shha__descender", {
			unicode: ["0526", "0527"],
			groups: ["Cyrillic"],
			options: { useLetterLocale: "Origin" },
			recipe: ["${cyr_[c,s]_let_h_shha}${descender}", "${descender}${cyr_[c,s]_let_h_shha}"]
		},
		"cyr_[c,s]_let_ch_djerv", {
			unicode: ["A648", "A649"],
			options: { useLetterLocale: True, fastKey: "<+<! /Ч/?Secondary" },
			recipe: ["\чжь\"]
		},
		"cyr_[c,s]_let_semisoft_sign", {
			unicode: ["048C", "048D"],
			alterations: [{}, { modifier: "1E06C" }],
			options: { useLetterLocale: True, fastKey: "<! /Ь/?Secondary" },
			recipe: ["/Ь/${stroke_short}"]
		},
		"cyr_[c,s]_let_y_yn", {
			unicode: ["A65E", "A65F"],
			options: { useLetterLocale: True, fastKey: "<! /Ы/?Secondary" },
			recipe: ["${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_i_izhitsa}"]
		},
		;
		;
		; * Cyrillic Ligatures
		;
		;
		"cyr_[c,s]_lig_yus_little_iotified", {
			unicode: ["0468", "0469"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}\ат\", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_yus_little}"]
		},
		"cyr_[c,s]_lig_yus_big_iotified", {
			unicode: ["046C", "046D"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}\аж\", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_yus_big}"]
		},
		"cyr_[c,s]_lig_yus_little_closed_iotified", {
			unicode: ["A65C", "A65D"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}\а_т\", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_yus_little_closed}"]
		},
		"cyr_[c,s]_lig_ae", {
			unicode: ["04D4", "04D5"],
			symbol: { letter: "${cyr_[c,s]_let_a}${cyr_[c,s]_let_ye}" },
		},
		"cyr_[c,s]_lig_a_iotified", {
			unicode: ["A656", "A657"],
			options: { useLetterLocale: True, fastKey: "<+ /Я/?Secondary" },
			recipe: ["${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_a}"]
		},
		"cyr_[c,s]_lig_dche", {
			unicode: ["052C", "052D"],
			symbol: { letter: "${cyr_[c,s]_let_d}${cyr_[c,s]_let_ch}" },
		},
		"cyr_[c,s]_lig_dzzhe", {
			unicode: ["052A", "052B"],
			symbol: { letter: "${cyr_[c,s]_let_d}${cyr_[c,s]_let_zh}" },
		},
		"cyr_[c,s]_lig_ye_iotified", {
			unicode: ["0464", "0465"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_e}", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_ye_anchor}"]
		},
		"cyr_[c,s]_lig_ye_yat_iotified", {
			unicode: ["A652", "A653"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_[c,s]_let_i_decimal}/Ь/${stroke_long}", "${cyr_[c,s]_let_i_decimal}${cyr_[c,s]_let_ye_yat}"]
		},
		"cyr_[c,s]_lig_zhwe", {
			unicode: ["A684", "A685"],
			symbol: { letter: "${cyr_[c,s]_let_z}${cyr_[c,s]_let_zh}" },
		},
		"cyr_[c,s]_lig_lha", {
			unicode: ["0514", "0515"],
			symbol: { letter: "${cyr_[c,s]_let_l}${cyr_[c,s]_let_h}" },
		},
		"cyr_[c,s]_lig_lje", {
			unicode: ["0409", "0459"],
			options: { fastKey: "/Л/?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_l}${cyr_[c,s]_let_yeri}" },
		},
		"cyr_[c,s]_lig_nje", {
			unicode: ["040A", "045A"],
			options: { fastKey: "/Н/?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_n}${cyr_[c,s]_let_yeri}" },
		},
		"cyr_[c,s]_lig_oo", {
			unicode: ["A698", "A699"],
			symbol: { letter: "${cyr_[c,s]_let_o×2}" },
		},
		"cyr_[c,s]_lig_rha", {
			unicode: ["0516", "0517"],
			symbol: { letter: "${cyr_[c,s]_let_r}${cyr_[c,s]_let_h}" },
		},
		"cyr_[c,s]_lig_tetse", {
			unicode: ["04B4", "04B5"],
			symbol: { letter: "${cyr_[c,s]_let_t}${cyr_[c,s]_let_ts}" },
		},
		"cyr_[c,s]_lig_tche", {
			unicode: ["A692", "A693"],
			symbol: { letter: "${cyr_[c,s]_let_t}${cyr_[c,s]_let_ch}" },
		},
		"cyr_[c,s]_lig_tje", {
			unicode: ["1C89", "1C8A"],
			symbol: { letter: "${cyr_[c,s]_let_t}${cyr_[c,s]_let_yeri}" },
		},
		"cyr_[c,s]_lig_uk", {
			unicode: ["A64A", "A64B"],
			options: { useLetterLocale: True, fastKey: "<! /У/?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_o}${cyr_s_let_u}" },
		},
		"cyr_[s]_lig_uk_unblended", {
			unicode: ["1C88"],
			options: { useLetterLocale: True },
			recipe: ["${cyr_s_let_i_izhitsa}${cyr_s_let_o}"],
			symbol: { letter: "${cyr_[c,s]_let_o}${cyr_s_let_u}", afterLetter: "unblended" },
		},
		"cyr_[c,s]_lig_cche", {
			unicode: ["A686", "A687"],
			symbol: { letter: "${cyr_[c,s]_let_ch}${cyr_[c,s]_let_ch}" },
		},
		"cyr_[c,s]_lig_yae", {
			unicode: ["0518", "0519"],
			symbol: { letter: "${cyr_[c,s]_let_ya}${cyr_[c,s]_let_ye}" },
		},
		;
		;
		; * Cyrillic Digraphs
		;
		;
		"cyr_[c,s]_dig_uk", {
			unicode: ["0478", "0479"],
			options: { useLetterLocale: True },
			symbol: { letter: "${cyr_[c,s]_let_o}${cyr_s_let_u}" },
		},
		"cyr_[c,s]_dig_yeru", {
			unicode: ["042B", "044B"],
			alterations: [{}, { combining: "A679", modifier: "1E047", subscript: "1E066" }],
			options: { secondName: True, noCalc: True },
			recipe: ["${cyr_[c,s]_let_yeri}${cyr_[c,s]_let_i_decimal}"],
		},
		"cyr_[c,s]_dig_yeru_with_back_yer", {
			unicode: ["A650", "A651"],
			options: { secondName: True, fastKey: "/Ы/?Secondary" },
			alterations: [{}, { modifier: "1E06C" }],
			recipe: ["${cyr_[c,s]_let_yer}${cyr_[c,s]_let_i_decimal}"],
		},
		;
		;
		; * Accented Cyrillic
		;
		;
		"cyr_[c,s]_let_a__breve", {
			unicode: ["04D0", "04D1"],
			options: { fastKey: "$?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_a}" }
		},
		"cyr_[c,s]_let_a__diaeresis", {
			unicode: ["04D2", "04D3"],
			options: { fastKey: "<+ $?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_a}" }
		},
		"cyr_[c,s]_let_g__acute", {
			unicode: ["0403", "0453"],
			options: { fastKey: "$?Primary" },
			symbol: { letter: "${cyr_[c,s]_let_g}" }
		},
		"cyr_[c,s]_let_g__descender", {
			unicode: ["04F6", "04F7"],
			options: { fastKey: "<! $?Secondary" },
			symbol: { letter: "${cyr_[c,s]_let_g}" }
		},
		"cyr_[c,s]_let_ye__diaeresis", {
			unicode: ["0401", "0451"],
			options: { noCalc: True },
			symbol: { letter: "${cyr_[c,s]_let_ye}" }
		},
		"cyr_[c,s]_let_i__breve", {
			unicode: ["0419", "0439"],
			options: { noCalc: True },
			symbol: { letter: "${cyr_[c,s]_let_i}" }
		},
		;
		;
		; * Glagolitic
		;
		;
		"glagolitic_c_let_az", {
			unicode: "2C00",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Аз глаголицы", "capital letter Az glagolitic"],
			options: { altLayoutKey: "А" },
			alterations: { combining: "1E000", },
		},
		"glagolitic_s_let_az", {
			unicode: "2C30",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква аз глаголицы", "small letter az glagolitic"],
			options: { altLayoutKey: "а" },
			alterations: { combining: "1E000", },
		},
		"glagolitic_c_let_buky", {
			unicode: "2C01",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Буки глаголицы", "capital letter Buky glagolitic"],
			options: { altLayoutKey: "Б" },
			alterations: { combining: "1E001", },
		},
		"glagolitic_s_let_buky", {
			unicode: "2C31",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква буки глаголицы", "small letter buky glagolitic"],
			options: { altLayoutKey: "б" },
			alterations: { combining: "1E001", },
		},
		"glagolitic_c_let_vede", {
			unicode: "2C02",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Веди глаголицы", "capital letter Vede glagolitic"],
			options: { altLayoutKey: "В" },
			alterations: { combining: "1E002" },
		},
		"glagolitic_s_let_vede", {
			unicode: "2C32",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква веди глаголицы", "small letter vede glagolitic"],
			options: { altLayoutKey: "в" },
			alterations: { combining: "1E002" },
		},
		"glagolitic_c_let_glagoli", {
			unicode: "2C03",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Глаголи глаголицы", "capital letter Glagoli glagolitic"],
			options: { altLayoutKey: "Г" },
			alterations: { combining: "1E003" },
		},
		"glagolitic_s_let_glagoli", {
			unicode: "2C33",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква глаголи глаголицы", "small letter glagoli glagolitic"],
			options: { altLayoutKey: "г" },
			alterations: { combining: "1E003" },
		},
		"glagolitic_c_let_dobro", {
			unicode: "2C04",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Добро глаголицы", "capital letter Dobro glagolitic"],
			options: { altLayoutKey: "Д" },
			alterations: { combining: "1E004" },
		},
		"glagolitic_s_let_dobro", {
			unicode: "2C34",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква добро глаголицы", "small letter dobro glagolitic"],
			options: { altLayoutKey: "д" },
			alterations: { combining: "1E004" },
		},
		"glagolitic_c_let_yestu", {
			unicode: "2C05",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Есть глаголицы", "capital letter Yestu glagolitic"],
			options: { altLayoutKey: "Е" },
			alterations: { combining: "1E005" },
		},
		"glagolitic_s_let_yestu", {
			unicode: "2C35",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква есть глаголицы", "small letter yestu glagolitic"],
			options: { altLayoutKey: "е" },
			alterations: { combining: "1E005" },
		},
		"glagolitic_c_let_zhivete", {
			unicode: "2C06",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Живете глаголицы", "capital letter Zhivete glagolitic"],
			options: { altLayoutKey: "Ж" },
			alterations: { combining: "1E006" },
		},
		"glagolitic_s_let_zhivete", {
			unicode: "2C36",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква живете глаголицы", "small letter zhivete glagolitic"],
			options: { altLayoutKey: "ж" },
			alterations: { combining: "1E006" },
		},
		"glagolitic_c_let_dzelo", {
			unicode: "2C07",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Зело глаголицы", "capital letter Dzelo glagolitic"],
			options: { altLayoutKey: ">! С" },
		},
		"glagolitic_s_let_dzelo", {
			unicode: "2C37",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква зело глаголицы", "small letter dzelo glagolitic"],
			options: { altLayoutKey: ">! с" },
		},
		"glagolitic_c_let_zemlja", {
			unicode: "2C08",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Земля глаголицы", "capital letter Zemlja glagolitic"],
			options: { altLayoutKey: "З" },
			alterations: { combining: "1E008" },
		},
		"glagolitic_s_let_zemlja", {
			unicode: "2C38",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква земля глаголицы", "small letter zemlja glagolitic"],
			options: { altLayoutKey: "з" },
			alterations: { combining: "1E008" },
		},
		"glagolitic_c_let_initial_izhe", {
			unicode: "2C0A",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква начальное Иже глаголицы", "capital letter initial Izhe glagolitic"],
			options: { altLayoutKey: ">! И" },
			alterations: { combining: "1E00A" },
		},
		"glagolitic_s_let_initial_izhe", {
			unicode: "2C3A",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква начальное иже глаголицы", "small letter initial izhe glagolitic"],
			options: { altLayoutKey: ">! и" },
			alterations: { combining: "1E00A" },
		},
		"glagolitic_c_let_izhe", {
			unicode: "2C09",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Иже глаголицы", "capital letter Izhe glagolitic"],
			options: { altLayoutKey: "<+ И], [Й" },
			alterations: { combining: "1E009" },
		},
		"glagolitic_s_let_izhe", {
			unicode: "2C39",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква иже глаголицы", "small letter izhe glagolitic"],
			options: { altLayoutKey: "<+ и], [й" },
			alterations: { combining: "1E009" },
		},
		"glagolitic_c_let_i", {
			unicode: "2C0B",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ие глаголицы", "capital letter I glagolitic"],
			options: { altLayoutKey: "И" },
			alterations: { combining: "1E00B" },
		},
		"glagolitic_s_let_i", {
			unicode: "2C3B",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква и глаголицы", "small letter i glagolitic"],
			options: { altLayoutKey: "и" },
			alterations: { combining: "1E00B" },
		},
		"glagolitic_c_let_djervi", {
			unicode: "2C0C",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Гюрв глаголицы", "capital letter Djervi glagolitic"],
			options: { altLayoutKey: ">! Ж" },
			alterations: { combining: "1E00C" },
		},
		"glagolitic_s_let_djervi", {
			unicode: "2C3C",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква гюрв глаголицы", "small letter djervi glagolitic"],
			options: { altLayoutKey: ">! ж" },
			alterations: { combining: "1E00C" },
		},
		"glagolitic_c_let_kako", {
			unicode: "2C0D",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Како глаголицы", "capital letter Kako glagolitic"],
			options: { altLayoutKey: "К" },
			alterations: { combining: "1E00D" },
		},
		"glagolitic_s_let_kako", {
			unicode: "2C3D",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква како глаголицы", "small letter kako glagolitic"],
			options: { altLayoutKey: "к" },
			alterations: { combining: "1E00D" },
		},
		"glagolitic_c_let_ljudije", {
			unicode: "2C0E",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Люди глаголицы", "capital letter Ljudije glagolitic"],
			options: { altLayoutKey: "Л" },
			alterations: { combining: "1E00E" },
		},
		"glagolitic_s_let_ljudije", {
			unicode: "2C3E",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква люди глаголицы", "small letter ljudije glagolitic"],
			options: { altLayoutKey: "л" },
			alterations: { combining: "1E00E" },
		},
		"glagolitic_c_let_myslite", {
			unicode: "2C0F",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Мыслете глаголицы", "capital letter Myslite glagolitic"],
			options: { altLayoutKey: "М" },
			alterations: { combining: "1E00F" },
		},
		"glagolitic_s_let_myslite", {
			unicode: "2C3F",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква мыслете глаголицы", "small letter myslite glagolitic"],
			options: { altLayoutKey: "м" },
			alterations: { combining: "1E00F" },
		},
		"glagolitic_c_let_nashi", {
			unicode: "2C10",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Наш глаголицы", "capital letter Nashi glagolitic"],
			options: { altLayoutKey: "Н" },
			alterations: { combining: "1E010" },
		},
		"glagolitic_s_let_nashi", {
			unicode: "2C40",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква наш глаголицы", "small letter nashi glagolitic"],
			options: { altLayoutKey: "н" },
			alterations: { combining: "1E010" },
		},
		"glagolitic_c_let_onu", {
			unicode: "2C11",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Он глаголицы", "capital letter Onu glagolitic"],
			options: { altLayoutKey: "О" },
			alterations: { combining: "1E011" },
		},
		"glagolitic_s_let_onu", {
			unicode: "2C41",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква он глаголицы", "small letter onu glagolitic"],
			options: { altLayoutKey: "о" },
			alterations: { combining: "1E011" },
		},
		"glagolitic_c_let_pokoji", {
			unicode: "2C12",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Покой глаголицы", "capital letter Pokoji glagolitic"],
			options: { altLayoutKey: "П" },
			alterations: { combining: "1E012" },
		},
		"glagolitic_s_let_pokoji", {
			unicode: "2C42",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква покой глаголицы", "small letter pokoji glagolitic"],
			options: { altLayoutKey: "п" },
			alterations: { combining: "1E012" },
		},
		"glagolitic_c_let_ritsi", {
			unicode: "2C13",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Рцы глаголицы", "capital letter Ritsi glagolitic"],
			options: { altLayoutKey: "Р" },
			alterations: { combining: "1E013" },
		},
		"glagolitic_s_let_ritsi", {
			unicode: "2C43",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква рцы глаголицы", "small letter ritsi glagolitic"],
			options: { altLayoutKey: "р" },
			alterations: { combining: "1E013" },
		},
		"glagolitic_c_let_slovo", {
			unicode: "2C14",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Слово глаголицы", "capital letter Slovo glagolitic"],
			options: { altLayoutKey: "С" },
			alterations: { combining: "1E014" },
		},
		"glagolitic_s_let_slovo", {
			unicode: "2C44",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква слово глаголицы", "small letter slovo glagolitic"],
			options: { altLayoutKey: "с" },
			alterations: { combining: "1E014" },
		},
		"glagolitic_c_let_tvrido", {
			unicode: "2C15",
			groups: ["Glagolitic Letters"],
			tags: ["прописная Твердо глаголицы", "capital letter Tvrido glagolitic"],
			options: { altLayoutKey: "Т" },
			alterations: { combining: "1E015" },
		},
		"glagolitic_s_let_tvrido", {
			unicode: "2C45",
			groups: ["Glagolitic Letters"],
			tags: ["строчная твердо глаголицы", "small letter tvrido glagolitic"],
			options: { altLayoutKey: "т" },
			alterations: { combining: "1E015" },
		},
		"glagolitic_c_let_izhitsa", {
			unicode: "2C2B",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква начальное Иже глаголицы", "capital letter Izhitsae glagolitic"],
			options: { altLayoutKey: ">!<+ И" },
		},
		"glagolitic_s_let_izhitsa", {
			unicode: "2C5B",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква начальное иже глаголицы", "small letter izhitsa glagolitic"],
			options: { altLayoutKey: ">!<+ и" },
		},
		"glagolitic_c_let_uku", {
			unicode: "2C16",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ук глаголицы", "capital letter Uku glagolitic"],
			options: { altLayoutKey: "У" },
			alterations: { combining: "1E016" },
		},
		"glagolitic_s_let_uku", {
			unicode: "2C46",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ук глаголицы", "small letter uku glagolitic"],
			options: { altLayoutKey: "у" },
			alterations: { combining: "1E016" },
		},
		"glagolitic_c_let_fritu", {
			unicode: "2C17",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ферт глаголицы", "capital letter Fritu glagolitic"],
			options: { altLayoutKey: "Ф" },
			alterations: { combining: "1E017" },
		},
		"glagolitic_s_let_fritu", {
			unicode: "2C47",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ферт глаголицы", "small letter fritu glagolitic"],
			options: { altLayoutKey: "ф" },
			alterations: { combining: "1E017" },
		},
		"glagolitic_c_let_heru", {
			unicode: "2C18",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Хер глаголицы", "capital letter Heru glagolitic"],
			options: { altLayoutKey: "Х" },
			alterations: { combining: "1E018" },
		},
		"glagolitic_s_let_heru", {
			unicode: "2C48",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква хер глаголицы", "small letter heru glagolitic"],
			options: { altLayoutKey: "х" },
			alterations: { combining: "1E018" },
		},
		"glagolitic_c_let_otu", {
			unicode: "2C19",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква От глаголицы", "capital letter Otu glagolitic"],
			options: { altLayoutKey: ">! О" },
		},
		"glagolitic_s_let_otu", {
			unicode: "2C49",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква от глаголицы", "small letter otu glagolitic"],
			options: { altLayoutKey: ">! о" },
		},
		"glagolitic_c_let_pe", {
			unicode: "2C1A",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Пе глаголицы", "capital letter Pe glagolitic"],
			options: { altLayoutKey: ">! П" },
		},
		"glagolitic_s_let_pe", {
			unicode: "2C4A",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква пе глаголицы", "small letter pe glagolitic"],
			options: { altLayoutKey: ">! п" },
		},
		"glagolitic_c_let_tsi", {
			unicode: "2C1C",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Цы глаголицы", "capital letter Tsi glagolitic"],
			options: { altLayoutKey: "Ц" },
			alterations: { combining: "1E01C" },
		},
		"glagolitic_s_let_tsi", {
			unicode: "2C4C",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква цы глаголицы", "small letter tsi glagolitic"],
			options: { altLayoutKey: "ц" },
			alterations: { combining: "1E01C" },
		},
		"glagolitic_c_let_chrivi", {
			unicode: "2C1D",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Червь глаголицы", "capital letter Chrivi glagolitic"],
			options: { altLayoutKey: "Ч" },
			alterations: { combining: "1E01D" },
		},
		"glagolitic_s_let_chrivi", {
			unicode: "2C4D",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква червь глаголицы", "small letter chrivi glagolitic"],
			options: { altLayoutKey: "ч" },
			alterations: { combining: "1E01D" },
		},
		"glagolitic_c_let_sha", {
			unicode: "2C1E",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ша глаголицы", "capital letter Sha glagolitic"],
			options: { altLayoutKey: "Ш" },
			alterations: { combining: "1E01E" },
		},
		"glagolitic_s_let_sha", {
			unicode: "2C4E",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ша глаголицы", "small letter sha glagolitic"],
			options: { altLayoutKey: "ш" },
			alterations: { combining: "1E01E" },
		},
		"glagolitic_c_let_shta", {
			unicode: "2C1B",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Шта глаголицы", "capital letter Shta glagolitic"],
			options: { altLayoutKey: "Щ" },
			alterations: { combining: "1E01B" },
		},
		"glagolitic_s_let_shta", {
			unicode: "2C4B",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква шта глаголицы", "small letter shta glagolitic"],
			options: { altLayoutKey: "щ" },
			alterations: { combining: "1E01B" },
		},
		"glagolitic_c_let_yeru", {
			unicode: "2C1F",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Еръ глаголицы", "capital letter Yeru glagolitic"],
			options: { altLayoutKey: "Ъ" },
			alterations: { combining: "1E01F" },
		},
		"glagolitic_s_let_yeru", {
			unicode: "2C4F",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква еръ глаголицы", "small letter yeru glagolitic"],
			options: { altLayoutKey: "ъ" },
			alterations: { combining: "1E01F" },
		},
		"glagolitic_c_let_yery", {
			unicode: "2C1F",
			sequence: ["2C1F", "2C0A"],
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Еры глаголицы", "capital letter Yery glagolitic"],
			options: { altLayoutKey: "Ы" },
			alterations: { combining: ["1E01F", "1E00A"], },
			symbol: { customs: "s60" },
		},
		"glagolitic_s_let_yery", {
			unicode: "2C4F",
			sequence: ["2C4F", "2C3A"],
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква еры глаголицы", "small letter yery glagolitic"],
			options: { altLayoutKey: "ы" },
			alterations: { combining: ["1E01F", "1E00A"], },
			symbol: { customs: "s60" },
		},
		"glagolitic_c_let_yeri", {
			unicode: "2C20",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ерь глаголицы", "capital letter Yeri glagolitic"],
			options: { altLayoutKey: "Ь" },
			alterations: { combining: "1E020" },
		},
		"glagolitic_s_let_yeri", {
			unicode: "2C50",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ерь глаголицы", "small letter yeri glagolitic"],
			options: { altLayoutKey: "ь" },
		},
		"glagolitic_c_let_yati", {
			unicode: "2C21",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ять глаголицы", "capital letter Yati glagolitic"],
			options: { altLayoutKey: "Я" },
			alterations: { combining: "1E021" },
		},
		"glagolitic_s_let_yati", {
			unicode: "2C51",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ять глаголицы", "small letter yati glagolitic"],
			options: { altLayoutKey: "я" },
			alterations: { combining: "1E021" },
		},
		"glagolitic_c_let_yo", {
			unicode: "2C26",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ё глаголицы", "capital letter Yo glagolitic"],
			options: { altLayoutKey: "Ё" },
			alterations: { combining: "1E026" },
		},
		"glagolitic_s_let_yo", {
			unicode: "2C56",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ё глаголицы", "small letter yo glagolitic"],
			options: { altLayoutKey: "ё" },
			alterations: { combining: "1E026" },
		},
		"glagolitic_c_let_spider_ha", {
			unicode: "2C22",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Хлъмъ глаголицы", "capital letter spider Ha glagolitic"],
			options: { altLayoutKey: ">! Х" },
		},
		"glagolitic_s_let_spider_ha", {
			unicode: "2C52",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква хлъмъ глаголицы", "small letter spider ha glagolitic"],
			options: { altLayoutKey: ">! х" },
		},
		"glagolitic_c_let_yu", {
			unicode: "2C23",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Ю глаголицы", "capital letter Yu glagolitic"],
			options: { altLayoutKey: "Ю" },
			alterations: { combining: "1E023" },
		},
		"glagolitic_s_let_yu", {
			unicode: "2C53",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква ю глаголицы", "small letter yu glagolitic"],
			options: { altLayoutKey: "ю" },
			alterations: { combining: "1E023" },
		},
		"glagolitic_c_let_small_yus", {
			unicode: "2C24",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс малый глаголицы", "capital letter small letter Yus glagolitic"],
			options: { altLayoutKey: "Э" },
			alterations: { combining: "1E024" },
		},
		"glagolitic_s_let_small_yus", {
			unicode: "2C54",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс малый глаголицы", "small letter small letter yus glagolitic"],
			options: { altLayoutKey: "э" },
			alterations: { combining: "1E024" },
		},
		"glagolitic_c_let_small_yus_iotified", {
			unicode: "2C27",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс малый йотированный глаголицы", "capital letter small letter Yus iotified glagolitic"],
			options: { altLayoutKey: ">! Э" },
			alterations: { combining: "1E027" },
			recipe: ["${glagolitic_c_let_yestu}${glagolitic_c_let_small_yus}"],
		},
		"glagolitic_s_let_small_yus_iotified", {
			unicode: "2C57",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс малый йотированный глаголицы", "small letter small letter yus iotified glagolitic"],
			options: { altLayoutKey: ">! э" },
			alterations: { combining: "1E027" },
			recipe: ["${glagolitic_s_let_yestu}${glagolitic_s_let_small_yus}"],
		},
		"glagolitic_c_let_big_yus", {
			unicode: "2C28",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс большой глаголицы", "capital letter big Yus glagolitic"],
			options: { altLayoutKey: "<! О" },
			alterations: { combining: "1E028" },
			recipe: ["${glagolitic_c_let_onu}${glagolitic_c_let_small_yus}"],
		},
		"glagolitic_s_let_big_yus", {
			unicode: "2C58",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс большой глаголицы", "small letter big yus glagolitic"],
			options: { altLayoutKey: "<! о" },
			alterations: { combining: "1E028" },
			recipe: ["${glagolitic_s_let_onu}${glagolitic_s_let_small_yus}"],
		},
		"glagolitic_c_let_big_yus_iotified", {
			unicode: "2C29",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Юс большой йотированный глаголицы", "capital letter big Yus iotified glagolitic"],
			options: { altLayoutKey: "<! Ё" },
			alterations: { combining: "1E029" },
			recipe: ["${glagolitic_c_let_yo}${glagolitic_c_let_small_yus}"],
		},
		"glagolitic_s_let_big_yus_iotified", {
			unicode: "2C59",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква юс большой йотированный глаголицы", "small letter big yus iotified glagolitic"],
			options: { altLayoutKey: "<! ё" },
			alterations: { combining: "1E029" },
			recipe: ["${glagolitic_s_let_yo}${glagolitic_s_let_small_yus}"],
		},
		"glagolitic_c_let_fita", {
			unicode: "2C2A",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Фита глаголицы", "capital letter Fita glagolitic"],
			options: { altLayoutKey: ">! Ф" },
			alterations: { combining: "1E02A" },
		},
		"glagolitic_s_let_fita", {
			unicode: "2C5A",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква фита глаголицы", "small letter fita glagolitic"],
			options: { altLayoutKey: ">! ф" },
			alterations: { combining: "1E02A" },
		},
		"glagolitic_c_let_shtapic", {
			unicode: "2C2C",
			groups: ["Glagolitic Letters"],
			tags: ["прописная буква Штапик глаголицы", "capital letter Shtapic glagolitic"],
			options: { altLayoutKey: ">! Ъ" },
		},
		"glagolitic_s_let_shtapic", {
			unicode: "2C5C",
			groups: ["Glagolitic Letters"],
			tags: ["строчная буква штапик глаголицы", "small letter shtapic glagolitic"],
			options: { altLayoutKey: ">! ъ" },
		},
		"glagolitic_c_let_trokutasti_a", {
			unicode: "2C2D",
			groups: ["Glagolitic Letters"],
			tags: ["прописная треугольная А глаголицы", "capital letter trokutasti A glagolitic"],
			options: { altLayoutKey: ">! А" },
		},
		"glagolitic_s_let_trokutasti_a", {
			unicode: "2C5D",
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
			unicode: "16A8",
			tags: ["старший футарк ансуз", "elder futhark ansuz"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "A" },
		},
		"futhark_berkanan", {
			unicode: "16D2",
			tags: ["старший футарк беркана", "elder futhark berkanan", "futhork beorc", "younger futhark bjarkan"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "B" },
		},
		"futhark_dagaz", {
			unicode: "16DE",
			tags: ["старший футарк дагаз", "elder futhark dagaz", "futhork daeg", "futhork dæg"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "D" },
		},
		"futhark_ehwaz", {
			unicode: "16D6",
			tags: ["старший футарк эваз", "elder futhark ehwaz", "futhork eh"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "E" },
		},
		"futhark_fehu", {
			unicode: "16A0",
			tags: ["старший футарк феху", "elder futhark fehu", "futhork feoh", "younger futhark fe", "younger futhark fé"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "F" },
		},
		"futhark_gebo", {
			unicode: "16B7",
			tags: ["старший футарк гебо", "elder futhark gebo", "futhork gyfu", "elder futhark gebō"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "G" },
		},
		"futhark_haglaz", {
			unicode: "16BA",
			tags: ["старший футарк хагалаз", "elder futhark hagalaz"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "H" },
		},
		"futhark_isaz", {
			unicode: "16C1",
			tags: ["старший футарк исаз", "elder futhark isaz", "futhork is", "younger futhark iss", "futhork īs", "younger futhark íss"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "I" },
		},
		"futhark_eihwaz", {
			unicode: "16C7",
			tags: ["старший футарк эваз", "elder futhark eihwaz", "elder futhark iwaz", "elder futhark ēihwaz", "futhork eoh", "futhork ēoh"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: ">+ I" },
		},
		"futhark_jeran", {
			unicode: "16C3",
			tags: ["старший футарк йера", "elder futhark jeran", "elder futhark jēra"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "J" },
		},
		"futhark_kauna", {
			unicode: "16B2",
			tags: ["старший футарк кеназ", "elder futhark kauna", "elder futhark kenaz", "elder futhark kauną"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "K" },
		},
		"futhark_laguz", {
			unicode: "16DA",
			tags: ["старший футарк лагуз", "elder futhark laukaz", "elder futhark laguz", "futhork lagu", "futhork logr", "futhork lögr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "L" },
		},
		"futhark_mannaz", {
			unicode: "16D7",
			tags: ["старший футарк манназ", "elder futhark mannaz", "futhork mann"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "M" },
		},
		"futhark_naudiz", {
			unicode: "16BE",
			tags: ["старший футарк наудиз", "elder futhark naudiz", "futhork nyd", "younger futhark naudr", "younger futhark nauðr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "N" },
		},
		"futhark_ingwaz", {
			unicode: "16DC",
			tags: ["старший футарк ингваз", "elder futhark ingwaz"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: ">+ N" },
		},
		"futhark_odal", {
			unicode: "16DF",
			tags: ["старший футарк одал", "elder futhark othala", "futhork edel", "elder futhark ōþala", "futhork ēðel"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "O", legend: "NorseRunes\othala" },
		},
		"futhark_pertho", {
			unicode: "16C8",
			tags: ["старший футарк перто", "elder futhark pertho", "futhork peord", "elder futhark perþō", "futhork peorð"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "P" },
		},
		"futhark_raido", {
			unicode: "16B1",
			tags: ["старший футарк райдо", "elder futhark raido", "futhork rad", "younger futhark reid", "elder futhark raidō", "futhork rād", "younger futhark reið"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "R" },
		},
		"futhark_sowilo", {
			unicode: "16CA",
			tags: ["старший футарк совило", "elder futhark sowilo", "elder futhark sōwilō"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "S" },
		},
		"futhark_tiwaz", {
			unicode: "16CF",
			tags: ["старший футарк тейваз", "elder futhark tiwaz", "futhork ti", "futhork tir", "younger futhark tyr", "elder futhark tēwaz", "futhork tī", "futhork tīr", "younger futhark týr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "T" },
		},
		"futhark_thurisaz", {
			unicode: "16A6",
			tags: ["старший футарк турисаз", "elder futhark thurisaz", "futhork thorn", "younger futhark thurs", "elder futhark þurisaz", "futhork þorn", "younger futhark þurs"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: ">+T" },
		},
		"futhark_uruz", {
			unicode: "16A2",
			tags: ["старший футарк уруз", "elder futhark uruz", "elder futhark ura", "futhork ur", "younger futhark ur", "elder futhark ūrą", "elder futhark ūruz", "futhork ūr", "younger futhark úr"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "U" },
		},
		"futhark_wunjo", {
			unicode: "16B9",
			tags: ["старший футарк вуньо", "elder futhark wunjo", "futhork wynn", "elder futhark wunjō", "elder futhark ƿunjō", "futhork ƿynn"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "W" },
		},
		"futhark_algiz", {
			unicode: "16C9",
			tags: ["старший футарк альгиз", "elder futhark algiz", "futhork eolhx"],
			groups: ["Futhark Runes"],
			options: { altLayoutKey: "Z" },
		},
		"futhork_as", {
			unicode: "16AA",
			tags: ["футорк ас", "futhork as", "futhork ās"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ A" },
		},
		"futhork_aesc", {
			unicode: "16AB",
			tags: ["футорк эск", "futhork aesc", "futhork æsc"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ A" },
			recipe: ["${futhark_ansuz}${futhark_ehwaz}"],
		},
		"futhork_cen", {
			unicode: "16B3",
			tags: ["футорк кен", "futhork cen", "futhork cēn"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "C" },
		},
		"futhork_ear", {
			unicode: "16E0",
			tags: ["футорк эар", "ear"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ E" },
		},
		"futhork_gar", {
			unicode: "16B8",
			tags: ["футорк гар", "futhork gar", "futhork gār"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ G" },
		},
		"futhork_haegl", {
			unicode: "16BB",
			tags: ["футорк хегль", "futhork haegl", "futhork hægl"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ H" },
		},
		"futhork_ger", {
			unicode: "16C4",
			tags: ["футорк гер", "futhork ger", "futhork gēr"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ J" },
		},
		"futhork_ior", {
			unicode: "16E1",
			tags: ["футорк йор", "futhork gerx", "futhork ior", "younger futhark arx", "futhork gērx", "futhork īor", "youner futhark árx"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ J" },
		},
		"futhork_cealc", {
			unicode: "16E4",
			tags: ["футорк келк", "futhork cealc"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ K" },
		},
		"futhork_calc", {
			unicode: "16E3",
			tags: ["футорк калк", "futhork calc"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ K" },
		},
		"futhork_ing", {
			unicode: "16DD",
			tags: ["футорк инг", "futhork ing"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ N" },
		},
		"futhork_os", {
			unicode: "16A9",
			tags: ["футорк ос", "futhork os", "futhork ōs"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ O" },
		},
		"futhork_cweorth", {
			unicode: "16E2",
			tags: ["футорк квирд", "futhark cweorth", "futhork cƿeorð"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "Q" },
		},
		"futhork_sigel", {
			unicode: "16CB",
			tags: ["футорк сигель", "futhork sigel", "younger futhark sól"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ S" },
		},
		"futhork_stan", {
			unicode: "16E5",
			tags: ["футорк стан", "futhork stan"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: ">+ S" },
		},
		"futhork_yr", {
			unicode: "16A3",
			tags: ["футорк ир", "futhork yr", "futhork ȳr"],
			groups: ["Futhork Runes"],
			options: { altLayoutKey: "<+ Y" },
		},
		"futhark_younger_jera", {
			unicode: "16C5",
			tags: ["младший футарк йера", "younger futhark jera", "younger futhark ar", "younger futhark ár"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! A" },
		},
		"futhark_younger_jera_short_twig", {
			unicode: "16C6",
			tags: ["младший футарк короткая йера", "younger futhark short twig jera"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ A" },
		},
		"futhark_younger_bjarkan_short_twig", {
			unicode: "16D3",
			tags: ["младший футарк короткая беркана", "younger futhark short twig bjarkan"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ B" },
		},
		"futhark_younger_hagall", {
			unicode: "16BC",
			tags: ["младший футарк хагал", "younger futhark hagall"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! H" },
		},
		"futhark_younger_hagall_short_twig", {
			unicode: "16BD",
			tags: ["младший футарк короткий хагал", "younger futhark short twig hagall"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ H" },
		},
		"futhark_younger_kaun", {
			unicode: "16B4",
			tags: ["младший футарк каун", "younger futhark kaun"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! K" },
		},
		"futhark_younger_madr", {
			unicode: "16D8",
			tags: ["младший футарк мадр", "younger futhark madr", "younger futhark maðr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! M" },
		},
		"futhark_younger_madr_short_twig", {
			unicode: "16D9",
			tags: ["младший футарк короткий мадр", "younger futhark short twig madr", "younger futhark short twig maðr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ M" },
		},
		"futhark_younger_naud_short_twig", {
			unicode: "16BF",
			tags: ["младший футарк короткий науд", "younger futhark short twig naud", "younger futhark short twig nauðr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ N" },
		},
		"futhark_younger_oss", {
			unicode: "16AC",
			tags: ["младший футарк осс", "younger futhark oss", "younger futhark óss"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">! O" },
		},
		"futhark_younger_oss_short_twig", {
			unicode: "16AD",
			tags: ["младший футарк короткий осс", "younger futhark short twig oss", "younger futhark short twig óss"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ O" },
		},
		"futhark_younger_sol_short_twig", {
			unicode: "16CC",
			tags: ["младший футарк короткий сол", "younger futhark short twig sol", "younger futhark short twig sól"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ S" },
		},
		"futhark_younger_tyr_short_twig", {
			unicode: "16D0",
			tags: ["младший футарк короткий тир", "younger futhark short twig tyr", "younger futhark short twig týr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ T" },
		},
		"futhark_younger_ur", {
			unicode: "16A4",
			tags: ["младший футарк ур", "younger futhark ur"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: "Y" },
		},
		"futhark_younger_yr", {
			unicode: "16E6",
			tags: ["младший футарк короткий тис", "younger futhark yr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!Y" },
		},
		"futhark_younger_yr_short_twig", {
			unicode: "16E7",
			tags: ["младший футарк короткий тис", "younger futhark short twig yr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ Y" },
		},
		"futhark_younger_icelandic_yr", {
			unicode: "16E8",
			tags: ["младший футарк исладнский тис", "younger futhark icelandic yr"],
			groups: ["Younger Futhark Runes"],
			options: { altLayoutKey: ">+ Y" },
		},
		"futhark_almanac_arlaug", {
			unicode: "16EE",
			tags: ["золотой номер 17 арлауг", "golden number 17 arlaug"],
			groups: ["Almanac Runes"],
			options: { altLayoutKey: ">! 7" },
		},
		"futhark_almanac_tvimadur", {
			unicode: "16EF",
			tags: ["золотой номер 18 твимадур", "golden number 18 tvimadur", "golden number 18 tvímaður"],
			groups: ["Almanac Runes"],
			options: { altLayoutKey: ">! 8" },
		},
		"futhark_almanac_belgthor", {
			unicode: "16F0",
			tags: ["золотой номер 19 белгтор", "golden number 19 belgthor"],
			groups: ["Almanac Runes"],
			options: { altLayoutKey: ">! 9" },
		},
		"futhark_younger_later_e", {
			unicode: "16C2",
			tags: ["младшяя поздняя е", "later younger futhark e"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! E" },
		},
		"futhark_younger_later_eth", {
			unicode: "16A7",
			tags: ["поздний младший футарк эт", "later younger futhark eth"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! D" },
		},
		"futhark_younger_later_d", {
			unicode: "16D1",
			tags: ["поздний младший футарк д", "later younger futhark d"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">!<+ D" },
		},
		"futhark_younger_later_l", {
			unicode: "16DB",
			tags: ["поздний младший футарк л", "later younger futhark l"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! L" },
		},
		"futhark_younger_later_p", {
			unicode: "16D4",
			tags: ["младшяя поздняя п", "later younger futhark p"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: ">! P" },
		},
		"futhark_younger_later_v", {
			unicode: "16A1",
			tags: ["поздний младший футарк в", "later younger futhark v"],
			groups: ["Later Younger Futhark Runes"],
			options: { altLayoutKey: "V" },
		},
		"medieval_c", {
			unicode: "16CD",
			tags: ["средневековый си", "medieval с"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! C" },
		},
		"medieval_en", {
			unicode: "16C0",
			tags: ["средневековый эн", "medieval en"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! N" },
		},
		"medieval_on", {
			unicode: "16B0",
			tags: ["средневековый он", "medieval on"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! O" },
		},
		"medieval_o", {
			unicode: "16AE",
			tags: ["средневековый о", "medieval o"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<!>+ O" },
		},
		"medieval_x", {
			unicode: "16EA",
			tags: ["средневековый экс", "medieval ex"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! X" },
		},
		"medieval_z", {
			unicode: "16CE",
			tags: ["средневековый зе", "medieval ze"],
			groups: ["Medieval Runes"],
			options: { altLayoutKey: ">!<! Z" },
		},
		"runic_single_punctuation", {
			unicode: "16EB",
			tags: ["руническая одиночное препинание", "runic single punctuation"],
			groups: ["Runic Punctuation"],
			options: { altLayoutKey: ">! ." },
		},
		"runic_multiple_punctuation", {
			unicode: "16EC",
			tags: ["руническое двойное препинание", "runic multiple punctuation"],
			groups: ["Runic Punctuation"],
			options: { altLayoutKey: ">! Space" },
		},
		"runic_cruciform_punctuation", {
			unicode: "16ED",
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
			unicode: "10C00",
			tags: ["древнетюркская орхонская буква а", "old turkic orkhon letter a"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "A" },
		},
		"turkic_yenisei_a", {
			unicode: "10C01",
			tags: ["древнетюркская енисейская буква а", "old turkic yenisei letter a"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* A" },
		},
		"turkic_yenisei_ae", {
			unicode: "10C02",
			tags: ["древнетюркская енисейская буква я", "old turkic yenisei letter ae"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: ">! A" },
		},
		"turkic_yenisei_e", {
			unicode: "10C05",
			tags: ["древнетюркская енисейская буква е", "old turkic yenisei letter e"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "E" },
		},
		"turkic_orkhon_i", {
			unicode: "10C03",
			tags: ["древнетюркская орхонская буква и", "old turkic orkhon letter i"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "I" },
		},
		"turkic_yenisei_i", {
			unicode: "10C04",
			tags: ["древнетюркская енисейская буква и", "old turkic yenisei letter i"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* I" },
		},
		"turkic_orkhon_o", {
			unicode: "10C06",
			tags: ["древнетюркская орхонская буква о", "old turkic orkhon letter o"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "O" },
		},
		"turkic_orkhon_oe", {
			unicode: "10C07",
			tags: ["древнетюркская орхонская буква ё", "old turkic orkhon letter oe"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! O" },
		},
		"turkic_yenisei_oe", {
			unicode: "10C08",
			tags: ["древнетюркская енисейская буква ё", "old turkic yenisei letter oe"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! O" },
		},
		"turkic_orkhon_ec", {
			unicode: "10C32",
			tags: ["древнетюркская орхонская буква эч", "old turkic orkhon letter ec"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "C" },
		},
		"turkic_yenisei_ec", {
			unicode: "10C33",
			tags: ["древнетюркская енисейская буква эч", "old turkic yenisei letter ec"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* C" },
		},
		"turkic_orkhon_em", {
			unicode: "10C22",
			tags: ["древнетюркская орхонская буква эм", "old turkic orkhon letter em"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "M" },
		},
		"turkic_orkhon_eng", {
			unicode: "10C2D",
			tags: ["древнетюркская орхонская буква энг", "old turkic orkhon letter eng"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! N" },
		},
		"turkic_orkhon_ep", {
			unicode: "10C2F",
			tags: ["древнетюркская орхонская буква эп", "old turkic orkhon letter ep"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "P" },
		},
		"turkic_orkhon_esh", {
			unicode: "10C41",
			tags: ["древнетюркская орхонская буква эш", "old turkic orkhon letter esh"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! S" },
		},
		"turkic_yenisei_esh", {
			unicode: "10C42",
			tags: ["древнетюркская енисейская буква эш", "old turkic yenisei letter esh"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<! S" },
		},
		"turkic_orkhon_ez", {
			unicode: "10C14",
			tags: ["древнетюркская орхонская буква эз", "old turkic orkhon letter ez"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "Z" },
		},
		"turkic_yenisei_ez", {
			unicode: "10C15",
			tags: ["древнетюркская енисейская буква эз", "old turkic yenisei letter ez"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* Z" },
		},
		"turkic_orkhon_elt", {
			unicode: "10C21",
			tags: ["древнетюркская орхонская буква элт", "old turkic orkhon letter elt"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">!>+ T" },
		},
		"turkic_orkhon_enc", {
			unicode: "10C28",
			tags: ["древнетюркская орхонская буква энч", "old turkic orkhon letter enc"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">+ N" },
		},
		"turkic_yenisei_enc", {
			unicode: "10C29",
			tags: ["древнетюркская енисейская буква энч", "old turkic yenisei letter enc"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>+ N" },
		},
		"turkic_orkhon_eny", {
			unicode: "10C2A",
			tags: ["древнетюркская орхонская буква энь", "old turkic orkhon letter eny"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<+ N" },
		},
		"turkic_yenisei_eny", {
			unicode: "10C2B",
			tags: ["древнетюркская енисейская буква энь", "old turkic yenisei letter eny"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<+ N" },
		},
		"turkic_orkhon_ent", {
			unicode: "10C26",
			tags: ["древнетюркская орхонская буква энт", "old turkic orkhon letter ent"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">!>+ N" },
		},
		"turkic_yenisei_ent", {
			unicode: "10C27",
			tags: ["древнетюркская енисейская буква энт", "old turkic yenisei letter ent"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>!>+ N" },
		},
		"turkic_orkhon_bash", {
			unicode: "10C48",
			tags: ["древнетюркская орхонская буква баш", "old turkic orkhon letter bash"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! R" },
		},
		"turkic_orkhon_ab", {
			unicode: "10C09",
			tags: ["древнетюркская орхонская буква аб", "old turkic orkhon letter ab"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "B" },
		},
		"turkic_yenisei_ab", {
			unicode: "10C0A",
			tags: ["древнетюркская енисейская буква аб", "old turkic yenisei letter ab"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* B" },
		},
		"turkic_orkhon_aeb", {
			unicode: "10C0B",
			tags: ["древнетюркская орхонская буква ябь", "old turkic orkhon letter aeb"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! B" },
		},
		"turkic_yenisei_aeb", {
			unicode: "10C0C",
			tags: ["древнетюркская енисейская буква ябь", "old turkic yenisei letter aeb"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! B" },
		},
		"turkic_orkhon_ad", {
			unicode: "10C11",
			tags: ["древнетюркская орхонская буква ад", "old turkic orkhon letter ad"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "D" },
		},
		"turkic_yenisei_ad", {
			unicode: "10C12",
			tags: ["древнетюркская енисейская буква ад", "old turkic yenisei letter ad"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* D" },
		},
		"turkic_orkhon_aed", {
			unicode: "10C13",
			tags: ["древнетюркская орхонская буква ядь", "old turkic orkhon letter aed"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! D" },
		},
		"turkic_orkhon_al", {
			unicode: "10C1E",
			tags: ["древнетюркская орхонская буква ал", "old turkic orkhon letter al"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "L" },
		},
		"turkic_yenisei_al", {
			unicode: "10C1F",
			tags: ["древнетюркская енисейская буква ал", "old turkic yenisei letter al"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* L" },
		},
		"turkic_orkhon_ael", {
			unicode: "10C20",
			tags: ["древнетюркская орхонская буква яль", "old turkic orkhon letter ael"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! L" },
		},
		"turkic_orkhon_an", {
			unicode: "10C23",
			tags: ["древнетюркская орхонская буква ан", "old turkic orkhon letter an"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "N" },
		},
		"turkic_orkhon_aen", {
			unicode: "10C24",
			tags: ["древнетюркская орхонская буква янь", "old turkic orkhon letter aen"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! N" },
		},
		"turkic_yenisei_aen", {
			unicode: "10C25",
			tags: ["древнетюркская енисейская буква янь", "old turkic yenisei letter aen"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! N" },
		},
		"turkic_orkhon_ar", {
			unicode: "10C3A",
			tags: ["древнетюркская орхонская буква ар", "old turkic orkhon letter ar"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "R" },
		},
		"turkic_yenisei_ar", {
			unicode: "10C3B",
			tags: ["древнетюркская енисейская буква ар", "old turkic yenisei letter ar"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* R" },
		},
		"turkic_orkhon_aer", {
			unicode: "10C3C",
			tags: ["древнетюркская орхонская буква ярь", "old turkic orkhon letter aer"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! R" },
		},
		"turkic_orkhon_as", {
			unicode: "10C3D",
			tags: ["древнетюркская орхонская буква ар", "old turkic orkhon letter as"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "S" },
		},
		"turkic_orkhon_aes", {
			unicode: "10C3E",
			tags: ["древнетюркская орхонская буква ярь", "old turkic orkhon letter aes"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! S" },
		},
		"turkic_orkhon_at", {
			unicode: "10C43",
			tags: ["древнетюркская орхонская буква ат", "old turkic orkhon letter at"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "T" },
		},
		"turkic_yenisei_at", {
			unicode: "10C44",
			tags: ["древнетюркская енисейская буква ат", "old turkic yenisei letter at"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* T" },
		},
		"turkic_orkhon_aet", {
			unicode: "10C45",
			tags: ["древнетюркская орхонская буква ять", "old turkic orkhon letter aet"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! T" },
		},
		"turkic_yenisei_aet", {
			unicode: "10C46",
			tags: ["древнетюркская енисейская буква ять", "old turkic yenisei letter aet"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! T" },
		},
		"turkic_orkhon_ay", {
			unicode: "10C16",
			tags: ["древнетюркская орхонская буква ай", "old turkic orkhon letter ay"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "Y" },
		},
		"turkic_yenisei_ay", {
			unicode: "10C17",
			tags: ["древнетюркская енисейская буква ай", "old turkic yenisei letter ay"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* Y" },
		},
		"turkic_orkhon_aey", {
			unicode: "10C18",
			tags: ["древнетюркская орхонская буква яй", "old turkic orkhon letter aey"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! Y], [J" },
		},
		"turkic_yenisei_aey", {
			unicode: "10C19",
			tags: ["древнетюркская енисейская буква яй", "old turkic yenisei letter aey"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! Y], [J" },
		},
		"turkic_orkhon_ag", {
			unicode: "10C0D",
			tags: ["древнетюркская орхонская буква агх", "old turkic orkhon letter ag"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "G" },
		},
		"turkic_yenisei_ag", {
			unicode: "10C0E",
			tags: ["древнетюркская енисейская буква агх", "old turkic yenisei letter ag"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* G" },
		},
		"turkic_orkhon_aeg", {
			unicode: "10C0F",
			tags: ["древнетюркская орхонская буква ягь", "old turkic orkhon letter aeg"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! G" },
		},
		"turkic_yenisei_aeg", {
			unicode: "10C10",
			tags: ["древнетюркская енисейская буква ягь", "old turkic yenisei letter aeg"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! G" },
		},
		"turkic_orkhon_aq", {
			unicode: "10C34",
			tags: ["древнетюркская орхонская буква акх", "old turkic orkhon letter aq"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "K" },
		},
		"turkic_yenisei_aq", {
			unicode: "10C35",
			tags: ["древнетюркская енисейская буква акх", "old turkic yenisei letter aq"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* K" },
		},
		"turkic_orkhon_aek", {
			unicode: "10C1A",
			tags: ["древнетюркская орхонская буква якь", "old turkic orkhon letter aek"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! K" },
		},
		"turkic_yenisei_aek", {
			unicode: "10C1B",
			tags: ["древнетюркская енисейская буква якь", "old turkic yenisei letter aek"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! K" },
		},
		"turkic_orkhon_oq", {
			unicode: "10C38",
			tags: ["древнетюркская орхонская буква окх", "old turkic orkhon letter oq"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "Q" },
		},
		"turkic_yenisei_oq", {
			unicode: "10C39",
			tags: ["древнетюркская енисейская буква окх", "old turkic yenisei letter oq"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c* Q" },
		},
		"turkic_orkhon_oek", {
			unicode: "10C1C",
			tags: ["древнетюркская орхонская буква ёкь", "old turkic orkhon letter oek"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! Q" },
		},
		"turkic_yenisei_oek", {
			unicode: "10C1D",
			tags: ["древнетюркская енисейская буква ёкь", "old turkic yenisei letter oek"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*>! Q" },
		},
		"turkic_orkhon_iq", {
			unicode: "10C36",
			tags: ["древнетюркская орхонская буква ыкх", "old turkic orkhon letter iq"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! Q" },
		},
		"turkic_yenisei_iq", {
			unicode: "10C37",
			tags: ["древнетюркская енисейская буква ыкх", "old turkic yenisei letter iq"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<!  Q" },
		},
		"turkic_orkhon_ic", {
			unicode: "10C31",
			tags: ["древнетюркская орхонская буква ичь", "old turkic orkhon letter ic"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: ">! C" },
		},
		"turkic_orkhon_ash", {
			unicode: "10C3F",
			tags: ["древнетюркская орхонская буква аш", "old turkic orkhon letter ash"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! A" },
		},
		"turkic_yenisei_ash", {
			unicode: "10C40",
			tags: ["древнетюркская енисейская буква аш", "old turkic yenisei letter ash"],
			groups: ["Old Turkic Yenisei"],
			options: { altLayoutKey: "c*<! A" },
		},
		"turkic_orkhon_op", {
			unicode: "10C30",
			tags: ["древнетюркская орхонская буква оп", "old turkic orkhon letter op"],
			groups: ["Old Turkic Orkhon"],
			options: { altLayoutKey: "<! P" },
		},
		"turkic_orkhon_ot", {
			unicode: "10C47",
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
			unicode: "10350",
			tags: ["древнепермская буква ан", "old permic letter an"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "A" },
		},
		"permic_bur", {
			unicode: "10351",
			tags: ["древнепермская буква бур", "old permic letter bur"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Б" },
		},
		"permic_gai", {
			unicode: "10352",
			tags: ["древнепермская буква гай", "old permic letter gai"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Г" },
		},
		"permic_doi", {
			unicode: "10353",
			tags: ["древнепермская буква дой", "old permic letter doi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Д" },
		},
		"permic_e", {
			unicode: "10354",
			tags: ["древнепермская буква э", "old permic letter e"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Е" },
		},
		"permic_zhoi", {
			unicode: "10355",
			tags: ["древнепермская буква жой", "old permic letter zhoi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ж" },
		},
		"permic_dzhoi", {
			unicode: "10356",
			tags: ["древнепермская буква джой", "old permic letter dzhoi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! Ж" },
		},
		"permic_zata", {
			unicode: "10357",
			tags: ["древнепермская буква зата", "old permic letter zata"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "З" },
		},
		"permic_dzita", {
			unicode: "10358",
			tags: ["древнепермская буква дзита", "old permic letter dzita"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! З" },
		},
		"permic_i", {
			unicode: "10359",
			tags: ["древнепермская буква и", "old permic letter i"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "И" },
		},
		"permic_koke", {
			unicode: "1035A",
			tags: ["древнепермская буква кокэ", "old permic letter koke"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "К" },
		},
		"permic_lei", {
			unicode: "1035B",
			tags: ["древнепермская буква лэй", "old permic letter lei"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Л" },
		},
		"permic_menoe", {
			unicode: "1035C",
			tags: ["древнепермская буква мэно", "древнепермская буква мэнӧ", "old permic letter menoe"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "М" },
		},
		"permic_nenoe", {
			unicode: "1035D",
			tags: ["древнепермская буква нэно", "древнепермская буква нэнӧ", "old permic letter nenoe"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Н" },
			alterations: { combining: "10379" },
		},
		"permic_vooi", {
			unicode: "1035E",
			tags: ["древнепермская буква вой", "древнепермская буква во̂й", "old permic letter vooi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "О" },
		},
		"permic_peei", {
			unicode: "1035F",
			tags: ["древнепермская буква пэй", "древнепермская буква пэ̂й", "old permic letter peei"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "П" },
		},
		"permic_rei", {
			unicode: "10360",
			tags: ["древнепермская буква пэй", "old permic letter rei"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Р" },
		},
		"permic_sii", {
			unicode: "10361",
			tags: ["древнепермская буква сий", "old permic letter sii"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "С" },
			alterations: { combining: "1037A" },
		},
		"permic_tai", {
			unicode: "10362",
			tags: ["древнепермская буква тай", "old permic letter tai"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Т" },
		},
		"permic_u", {
			unicode: "10363",
			tags: ["древнепермская буква у", "old permic letter u"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "У" },
		},
		"permic_chery", {
			unicode: "10364",
			tags: ["древнепермская буква чэры", "old permic letter chery"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ч" },
		},
		"permic_shooi", {
			unicode: "10365",
			tags: ["древнепермская буква шой", "древнепермская буква шо̂й", "old permic letter shooi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ш" },
		},
		"permic_shchooi", {
			unicode: "10366",
			tags: ["древнепермская буква тшой", "древнепермская буква тшо̂й", "old permic letter shchooi"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Щ" },
		},
		"permic_yery", {
			unicode: "10368",
			tags: ["древнепермская буква еры", "old permic letter yery"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ы" },
		},
		"permic_yry", {
			unicode: "10367",
			tags: ["древнепермская буква ыры", "old permic letter yry"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! Ы" },
		},
		"permic_o", {
			unicode: "10369",
			tags: ["древнепермская буква о", "old permic letter o"],
			groups: ["Old Permic"],
			options: { altLayoutKey: ">! О" },
		},
		"permic_oo", {
			unicode: "1036A",
			tags: ["древнепермская буква оо", "old permic letter oo"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ё" },
		},
		"permic_ef", {
			unicode: "1036B",
			tags: ["древнепермская буква эф", "old permic letter ef"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ф" },
		},
		"permic_ha", {
			unicode: "1036C",
			tags: ["древнепермская буква ха", "old permic letter ha"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Х" },
		},
		"permic_tsiu", {
			unicode: "1036D",
			tags: ["древнепермская буква цю", "old permic letter tsiu"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ц" },
		},
		"permic_ver", {
			unicode: "1036E",
			tags: ["древнепермская буква вэр", "old permic letter ver"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "В" },
		},
		"permic_yeru", {
			unicode: "1036F",
			tags: ["древнепермская буква ер", "old permic letter yeru"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ъ" },
		},
		"permic_yeri", {
			unicode: "10370",
			tags: ["древнепермская буква ери", "old permic letter yeri"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ь" },
		},
		"permic_yat", {
			unicode: "10371",
			tags: ["древнепермская буква ять", "old permic letter yat"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Э" },
		},
		"permic_ie", {
			unicode: "10372",
			tags: ["древнепермская буква йэ", "old permic letter ie"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Й" },
		},
		"permic_yu", {
			unicode: "10373",
			tags: ["древнепермская буква ю", "old permic letter yu"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Ю" },
		},
		"permic_ia", {
			unicode: "10375",
			tags: ["древнепермская буква йа", "old permic letter ia"],
			groups: ["Old Permic"],
			options: { altLayoutKey: "Я" },
		},
		"permic_ya", {
			unicode: "10374",
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
			unicode: "10C80",
			tags: ["прописная руна А секельская", "capital rune A old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "A" },
		},
		"hungarian_s_let_a", {
			unicode: "10CC0",
			tags: ["строчная руна а секельская", "small rune a old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "a" },
		},
		"hungarian_c_let_aa", {
			unicode: "10C81",
			tags: ["прописная руна Аа секельская", "capital rune Aa old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! A" },
		},
		"hungarian_s_let_aa", {
			unicode: "10CC1",
			tags: ["строчная руна аа секельская", "small rune aa old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! a" },
		},
		"hungarian_c_let_eb", {
			unicode: "10C82",
			tags: ["прописная руна Эб секельская", "capital rune Eb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "B" },
		},
		"hungarian_s_let_eb", {
			unicode: "10CC2",
			tags: ["строчная руна эб секельская", "small rune eb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "b" },
		},
		"hungarian_c_let_ec", {
			unicode: "10C84",
			tags: ["прописная руна Эц секельская", "capital rune Ec old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "C" },
		},
		"hungarian_s_let_ec", {
			unicode: "10CC4",
			tags: ["строчная руна эц секельская", "small rune ec old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "c" },
		},
		"hungarian_c_let_ecs", {
			unicode: "10C86",
			tags: ["прописная руна Эч секельская", "capital rune Ecs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! C" },
		},
		"hungarian_s_let_ecs", {
			unicode: "10CC6",
			tags: ["строчная руна эч секельская", "small rune ecs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! c" },
		},
		"hungarian_c_let_ed", {
			unicode: "10C87",
			tags: ["прописная руна Эд секельская", "capital rune Ed old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "D" },
		},
		"hungarian_s_let_ed", {
			unicode: "10CC7",
			tags: ["строчная руна эд секельская", "small rune ed old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "d" },
		},
		"hungarian_c_let_e", {
			unicode: "10C89",
			tags: ["прописная руна Е секельская", "capital rune E old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "E" },
		},
		"hungarian_s_let_e", {
			unicode: "10CC9",
			tags: ["строчная руна е секельская", "small rune e old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "e" },
		},
		"hungarian_c_let_ee", {
			unicode: "10C8B",
			tags: ["прописная руна Ее секельская", "capital rune Ee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! E" },
		},
		"hungarian_s_let_ee", {
			unicode: "10CCB",
			tags: ["строчная руна ее секельская", "small rune ee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! e" },
		},
		"hungarian_c_let_ef", {
			unicode: "10C8C",
			tags: ["прописная руна Эф секельская", "capital rune Ef old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "F" },
		},
		"hungarian_s_let_ef", {
			unicode: "10CCC",
			tags: ["строчная руна эф секельская", "small rune ef old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "f" },
		},
		"hungarian_c_let_eg", {
			unicode: "10C8D",
			tags: ["прописная руна Эг секельская", "capital rune Eg old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "G" },
		},
		"hungarian_s_let_eg", {
			unicode: "10CCD",
			tags: ["строчная руна эг секельская", "small rune eg old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "g" },
		},
		"hungarian_c_let_egy", {
			unicode: "10C8E",
			tags: ["прописная руна Эгй секельская", "capital rune Egy old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! G" },
		},
		"hungarian_s_let_egy", {
			unicode: "10CCE",
			tags: ["строчная руна эгй секельская", "small rune egy old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! g" },
		},
		"hungarian_c_let_eh", {
			unicode: "10C8F",
			tags: ["прописная руна Эх секельская", "capital rune Eh old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "H" },
		},
		"hungarian_s_let_eh", {
			unicode: "10CCF",
			tags: ["строчная руна эх секельская", "small rune eh old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "h" },
		},
		"hungarian_c_let_i", {
			unicode: "10C90",
			tags: ["прописная руна и секельская", "capital rune I old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "I" },
		},
		"hungarian_s_let_i", {
			unicode: "10CD0",
			tags: ["строчная руна и секельская", "small rune i old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "i" },
		},
		"hungarian_c_let_ii", {
			unicode: "10C91",
			tags: ["прописная руна Ии секельская", "capital rune Ii old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! I" },
		},
		"hungarian_s_let_ii", {
			unicode: "10CD1",
			tags: ["строчная руна ии секельская", "small rune ii old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! i" },
		},
		"hungarian_c_let_ej", {
			unicode: "10C92",
			tags: ["прописная руна Эј секельская", "capital rune Ej old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "J" },
		},
		"hungarian_s_let_ej", {
			unicode: "10CD2",
			tags: ["строчная руна эј секельская", "small rune ej old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "j" },
		},
		"hungarian_c_let_ek", {
			unicode: "10C93",
			tags: ["прописная руна Эк секельская", "capital rune Ek old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "K" },
		},
		"hungarian_s_let_ek", {
			unicode: "10CD3",
			tags: ["строчная руна эк секельская", "small rune ek old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "k" },
		},
		"hungarian_c_let_ak", {
			unicode: "10C94",
			tags: ["прописная руна Ак секельская", "capital rune Ak old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! K" },
		},
		"hungarian_s_let_ak", {
			unicode: "10CD4",
			tags: ["строчная руна ак секельская", "small rune ak old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! k" },
		},
		"hungarian_c_let_el", {
			unicode: "10C96",
			tags: ["прописная руна Эл секельская", "capital rune El old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "L" },
		},
		"hungarian_s_let_el", {
			unicode: "10CD6",
			tags: ["строчная руна эл секельская", "small rune el old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "l" },
		},
		"hungarian_c_let_ely", {
			unicode: "10C97",
			tags: ["прописная руна Элй секельская", "capital rune Ely old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! L" },
		},
		"hungarian_s_let_ely", {
			unicode: "10CD7",
			tags: ["строчная руна элй секельская", "small rune ely old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! l" },
		},
		"hungarian_c_let_em", {
			unicode: "10C98",
			tags: ["прописная руна Эм секельская", "capital rune Em old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "M" },
		},
		"hungarian_s_let_em", {
			unicode: "10CD8",
			tags: ["строчная руна эм секельская", "small rune em old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "m" },
		},
		"hungarian_c_let_en", {
			unicode: "10C99",
			tags: ["прописная руна Эн секельская", "capital rune En old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "N" },
		},
		"hungarian_s_let_en", {
			unicode: "10CD9",
			tags: ["строчная руна эн секельская", "small rune en old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "n" },
		},
		"hungarian_c_let_eny", {
			unicode: "10C9A",
			tags: ["прописная руна Энй секельская", "capital rune Eny old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! N" },
		},
		"hungarian_s_let_eny", {
			unicode: "10CDA",
			tags: ["строчная руна энй секельская", "small rune eny old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! n" },
		},
		"hungarian_c_let_o", {
			unicode: "10C9B",
			tags: ["прописная руна О секельская", "capital rune O old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "O" },
		},
		"hungarian_s_let_o", {
			unicode: "10CD9",
			tags: ["строчная руна о секельская", "small rune o old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "o" },
		},
		"hungarian_c_let_oo", {
			unicode: "10C9C",
			tags: ["прописная руна Оо секельская", "capital rune Oo old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! O" },
		},
		"hungarian_s_let_oo", {
			unicode: "10CDC",
			tags: ["строчная руна оо секельская", "small rune oo old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! o" },
		},
		"hungarian_c_let_oe", {
			unicode: "10C9E",
			tags: ["прописная руна рудиментарная Ое секельская", "capital rune rudimentar Oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ O" },
		},
		"hungarian_s_let_oe", {
			unicode: "10CDE",
			tags: ["строчная руна рудиментарная ое секельская", "small rune rudimentar oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ o" },
		},
		"hungarian_c_let_oe_nik", {
			unicode: "10C9D",
			tags: ["прописная руна никольсбургская Ое секельская", "capital rune nikolsburg Oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">!<+ O" },
		},
		"hungarian_s_let_oe_nik", {
			unicode: "10CDD",
			tags: ["строчная руна никольсбургская ое секельская", "small rune nikolsburg oe old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">!<+ o" },
		},
		"hungarian_c_let_oee", {
			unicode: "10C9F",
			tags: ["прописная руна Оее секельская", "capital rune Oee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ O" },
		},
		"hungarian_s_let_oee", {
			unicode: "10CDF",
			tags: ["строчная руна оее секельская", "small rune oee old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ o" },
		},
		"hungarian_c_let_ep", {
			unicode: "10CA0",
			tags: ["прописная руна Эп секельская", "capital rune Ep old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "P" },
		},
		"hungarian_s_let_ep", {
			unicode: "10CE0",
			tags: ["строчная руна эп секельская", "small rune ep old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "p" },
		},
		"hungarian_c_let_er", {
			unicode: "10CA2",
			tags: ["прописная руна Эр секельская", "capital rune Er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "R" },
		},
		"hungarian_s_let_er", {
			unicode: "10CE2",
			tags: ["строчная руна эр секельская", "small rune er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "r" },
		},
		"hungarian_c_let_short_er", {
			unicode: "10CA3",
			tags: ["прописная руна короткая Эр секельская", "capital rune short Er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ R" },
		},
		"hungarian_s_let_short_er", {
			unicode: "10CE3",
			tags: ["строчная руна короткая эр секельская", "small rune short er old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ r" },
		},
		"hungarian_c_let_es", {
			unicode: "10CA4",
			tags: ["прописная руна Эщ секельская", "capital rune Es old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "S" },
		},
		"hungarian_s_let_es", {
			unicode: "10CE4",
			tags: ["строчная руна эщ секельская", "small rune es old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "s" },
		},
		"hungarian_c_let_esz", {
			unicode: "10CA5",
			tags: ["прописная руна Эс секельская", "capital rune Esz old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! S" },
		},
		"hungarian_s_let_esz", {
			unicode: "10CE5",
			tags: ["строчная руна эс секельская", "small rune esz old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! s" },
		},
		"hungarian_c_let_et", {
			unicode: "10CA6",
			tags: ["прописная руна Эт секельская", "capital rune Et old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "T" },
		},
		"hungarian_s_let_et", {
			unicode: "10CE6",
			tags: ["строчная руна эт секельская", "small rune et old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "t" },
		},
		"hungarian_c_let_ety", {
			unicode: "10CA8",
			tags: ["прописная руна Этй секельская", "capital rune Ety old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! T" },
		},
		"hungarian_s_let_ety", {
			unicode: "10CE8",
			tags: ["строчная руна этй секельская", "small rune ety old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! t" },
		},
		"hungarian_c_let_u", {
			unicode: "10CAA",
			tags: ["прописная руна У секельская", "capital rune U old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "U" },
		},
		"hungarian_s_let_u", {
			unicode: "10CEA",
			tags: ["строчная руна у секельская", "small rune u old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "u" },
		},
		"hungarian_c_let_uu", {
			unicode: "10CAB",
			tags: ["прописная руна Уу секельская", "capital rune Uu old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! U" },
		},
		"hungarian_s_let_uu", {
			unicode: "10CEB",
			tags: ["строчная руна уу секельская", "small rune uu old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! u" },
		},
		"hungarian_c_let_ue", {
			unicode: "10CAD",
			tags: ["прописная руна рудиментарная Уе секельская", "capital rune rudimentar Ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "Y" },
		},
		"hungarian_s_let_ue", {
			unicode: "10CED",
			tags: ["строчная руна рудиментарная Уе секельская", "small rune rudimentar ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "y" },
		},
		"hungarian_c_let_ue_nik", {
			unicode: "10CAC",
			tags: ["прописная руна никольсбургская Уе секельская", "capital rune nikolsburg Ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! Y" },
		},
		"hungarian_s_let_ue_nik", {
			unicode: "10CEC",
			tags: ["строчная руна никольсбургская Уе секельская", "small rune nikolsburg ue old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! y" },
		},
		"hungarian_c_let_ev", {
			unicode: "10CAE",
			tags: ["прописная руна Эв секельская", "capital rune Ev old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "V" },
		},
		"hungarian_s_let_ev", {
			unicode: "10CEE",
			tags: ["строчная руна эв секельская", "small rune ev old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "v" },
		},
		"hungarian_c_let_ez", {
			unicode: "10CAF",
			tags: ["прописная руна Эз секельская", "capital rune Ez old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "Z" },
		},
		"hungarian_s_let_ez", {
			unicode: "10CEF",
			tags: ["строчная руна эз секельская", "small rune ez old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "z" },
		},
		"hungarian_c_let_ezs", {
			unicode: "10CB0",
			tags: ["прописная руна Эж секельская", "capital rune Ezs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! Z" },
		},
		"hungarian_s_let_ezs", {
			unicode: "10CF0",
			tags: ["строчная руна эж секельская", "small rune ezs old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">! z" },
		},
		"hungarian_c_let_ent", {
			unicode: "10CA7",
			tags: ["прописная руна Энт секельская", "capital rune Ent old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ T" },
		},
		"hungarian_s_let_ent", {
			unicode: "10CE7",
			tags: ["строчная руна энт секельская", "small rune ent old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ t" },
		},
		"hungarian_c_let_ent_shaped", {
			unicode: "10CB1",
			tags: ["прописная руна Энт-подобный знак секельский", "capital rune Ent-shaped sign old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ T" },
		},
		"hungarian_s_let_ent_shaped", {
			unicode: "10CF1",
			tags: ["строчная руна энт-подобный знак секельский", "small rune ent-shaped sign old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: ">+ t" },
		},
		"hungarian_c_let_emp", {
			unicode: "10CA1",
			tags: ["прописная руна Эмп секельская", "capital rune Emp old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ P" },
		},
		"hungarian_s_let_emp", {
			unicode: "10CE1",
			tags: ["строчная руна эмп секельская", "small rune emp old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ p" },
		},
		"hungarian_c_let_unk", {
			unicode: "10C95",
			tags: ["прописная руна Унк секельская", "capital rune Unk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ K" },
		},
		"hungarian_s_let_unk", {
			unicode: "10CD5",
			tags: ["строчная руна унк секельская", "small rune unk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ k" },
		},
		"hungarian_c_let_us", {
			unicode: "10CB2",
			tags: ["прописная руна Ус секельская", "capital rune Us old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ S" },
		},
		"hungarian_s_let_us", {
			unicode: "10CF2",
			tags: ["строчная руна ус секельская", "small rune us old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ s" },
		},
		"hungarian_c_let_amb", {
			unicode: "10C83",
			tags: ["прописная руна Амб секельская", "capital rune Amb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ B" },
		},
		"hungarian_s_let_amb", {
			unicode: "10CC3",
			tags: ["строчная руна амб секельская", "small rune amb old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ b" },
		},
		"hungarian_c_let_enk", {
			unicode: "10C85",
			tags: ["прописная руна Энк секельская", "capital rune Enk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ E" },
		},
		"hungarian_s_let_enk", {
			unicode: "10CC5",
			tags: ["строчная руна энк секельская", "small rune enk old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ e" },
		},
		"hungarian_c_let_ech", {
			unicode: "10CA9",
			tags: ["прописная руна Эч секельская", "capital rune Ech old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ C" },
		},
		"hungarian_s_let_ech", {
			unicode: "10CE9",
			tags: ["строчная руна эч секельская", "small rune ech old hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "<+ c" },
		},
		"hungarian_num_one", {
			unicode: "10CFA",
			tags: ["цифра 1 секельская", "number 1 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "1" },
		},
		"hungarian_num_five", {
			unicode: "10CFB",
			tags: ["цифра 5 секельская", "number 5 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "2" },
		},
		"hungarian_num_ten", {
			unicode: "10CFC",
			tags: ["цифра 10 секельская", "number 10 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "3" },
		},
		"hungarian_num_fifty", {
			unicode: "10CFD",
			tags: ["цифра 50 секельская", "number 50 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "4" },
		},
		"hungarian_num_one_hundred", {
			unicode: "10CFE",
			tags: ["цифра 100 секельская", "number 100 hungarian"],
			groups: ["Old Hungarian"],
			options: { altLayoutKey: "5" },
		},
		"hungarian_num_one_thousand", {
			unicode: "10CFF",
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
			unicode: "10330",
			tags: ["готская буква аза", "gothic letter ahsa"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "A" },
		},
		"gothic_bairkan", {
			unicode: "10331",
			tags: ["готская буква беркна", "gothic letter bairkan", "gothic letter baírkan"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "B" },
		},
		"gothic_giba", {
			unicode: "10332",
			tags: ["готская буква гиба", "gothic letter giba"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "G" },
		},
		"gothic_dags", {
			unicode: "10333",
			tags: ["готская буква дааз", "gothic letter dags"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "D" },
		},
		"gothic_aihvus", {
			unicode: "10334",
			tags: ["готская буква эзй", "gothic letter aihvus", "gothic letter eíƕs"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "E" },
		},
		"gothic_qairthra", {
			unicode: "10335",
			tags: ["готская буква квертра", "gothic letter qairthra", "gothic letter qaírþra"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "Q" },
		},
		"gothic_ezek", {
			unicode: "10336",
			tags: ["готская буква эзек", "gothic letter ezek"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "Z" },
		},
		"gothic_hagl", {
			unicode: "10337",
			tags: ["готская буква хаал", "gothic letter hagl"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "H" },
		},
		"gothic_thiuth", {
			unicode: "10338",
			tags: ["готская буква сюс", "gothic letter thiuth", "gothic letter þiuþ"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: ">! T], [C" },
		},
		"gothic_eis", {
			unicode: "10339",
			tags: ["готская буква ииз", "gothic letter eis"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "I" },
		},
		"gothic_kusma", {
			unicode: "1033A",
			tags: ["готская буква козма", "gothic letter kusma"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "K" },
		},
		"gothic_lagus", {
			unicode: "1033B",
			tags: ["готская буква лааз", "gothic letter lagus"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "L" },
		},
		"gothic_manna", {
			unicode: "1033C",
			tags: ["готская буква манна", "gothic letter manna"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "M" },
		},
		"gothic_nauths", {
			unicode: "1033D",
			tags: ["готская буква нойкз", "gothic letter nauths", "gothic letter nauþs"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "N" },
		},
		"gothic_jer", {
			unicode: "1033E",
			tags: ["готская буква гаар", "gothic letter jer", "gothic letter jēr"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "J" },
		},
		"gothic_urus", {
			unicode: "1033F",
			tags: ["готская буква ураз", "gothic letter urus", "gothic letter ūrus"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "U" },
		},
		"gothic_pairthra", {
			unicode: "10340",
			tags: ["готская буква пертра", "gothic letter pairthra", "gothic letter ūrus"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "P" },
		},
		"gothic_ninety", {
			unicode: "10341",
			tags: ["готская буква-число 90", "gothic letter ninety"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: ">! P" },
		},
		"gothic_raida", {
			unicode: "10342",
			tags: ["готская буква райда", "gothic letter raida"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "R" },
		},
		"gothic_sugil", {
			unicode: "10343",
			tags: ["готская буква сугил", "gothic letter sugil"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "S" },
		},
		"gothic_teiws", {
			unicode: "10344",
			tags: ["готская буква тюз", "gothic letter teiws"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "T" },
		},
		"gothic_winja", {
			unicode: "10345",
			tags: ["готская буква винья", "gothic letter winja"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "W], [Y" },
		},
		"gothic_faihu", {
			unicode: "10346",
			tags: ["готская буква файху", "gothic letter faihu"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "F" },
		},
		"gothic_iggws", {
			unicode: "10347",
			tags: ["готская буква энкуз", "gothic letter iggws"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "X" },
		},
		"gothic_hwair", {
			unicode: "10348",
			tags: ["готская буква хвайр", "gothic letter hwair", "gothic letter ƕaír"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: ">! H], [V" },
		},
		"gothic_othal", {
			unicode: "10349",
			tags: ["готская буква отал", "gothic letter othal", "gothic letter ōþal"],
			groups: ["Gothic Alphabet"],
			options: { altLayoutKey: "O" },
		},
		"gothic_nine_hundred", {
			unicode: "1034A",
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
			unicode: "10300",
			tags: ["древнеиталийская буква А", "old italic letter A"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "A" },
		},
		"italic_let_be", {
			unicode: "10301",
			tags: ["древнеиталийская буква Бе", "old italic letter Be"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "B" },
		},
		"italic_let_ke", {
			unicode: "10302",
			tags: ["древнеиталийская буква Ке", "old italic letter Ke"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "C" },
		},
		"italic_let_che", {
			unicode: "1031C",
			tags: ["древнеиталийская буква Че", "old italic letter Che"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ C" },
		},
		"italic_let_de", {
			unicode: "10303",
			tags: ["древнеиталийская буква Де", "old italic letter De"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "D" },
		},
		"italic_let_e", {
			unicode: "10304",
			tags: ["древнеиталийская буква Е", "old italic letter E"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "E" },
		},
		"italic_let_ye", {
			unicode: "1032D",
			tags: ["древнеиталийская буква Йе", "old italic letter Ye"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "Y" },
		},
		"italic_let_ve", {
			unicode: "10305",
			tags: ["древнеиталийская буква Ве", "old italic letter Ve"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "F" },
		},
		"italic_let_ef", {
			unicode: "1031A",
			tags: ["древнеиталийская буква Эф", "old italic letter Ef"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ F" },
		},
		"italic_let_ze", {
			unicode: "10306",
			tags: ["древнеиталийская буква Зе", "old italic letter Ze"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "Z" },
		},
		"italic_let_he", {
			unicode: "10307",
			tags: ["древнеиталийская буква Хе", "old italic letter He"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "H" },
		},
		"italic_let_i", {
			unicode: "10309",
			tags: ["древнеиталийская буква И", "old italic letter I"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "I" },
		},
		"italic_let_ii", {
			unicode: "1031D",
			tags: ["древнеиталийская буква Ии", "old italic letter Ii"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ I" },
		},
		"italic_let_ka", {
			unicode: "1030A",
			tags: ["древнеиталийская буква Ка", "old italic letter Ka"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "K" },
		},
		"italic_let_khe", {
			unicode: "10319",
			tags: ["древнеиталийская буква Кхе", "old italic letter Khe"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ K" },
		},
		"italic_let_el", {
			unicode: "1030B",
			tags: ["древнеиталийская буква Эль", "old italic letter El"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "L" },
		},
		"italic_let_em", {
			unicode: "1030C",
			tags: ["древнеиталийская буква Эм", "old italic letter Em"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "M" },
		},
		"italic_let_en", {
			unicode: "1030D",
			tags: ["древнеиталийская буква Эн", "old italic letter En"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "N" },
		},
		"italic_let_o", {
			unicode: "1030F",
			tags: ["древнеиталийская буква О", "old italic letter O"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "O" },
		},
		"italic_let_pe", {
			unicode: "10310",
			tags: ["древнеиталийская буква Пе", "old italic letter Pe"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "P" },
		},
		"italic_let_phe", {
			unicode: "10318",
			tags: ["древнеиталийская буква Пхе", "old italic letter Phe"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ P" },
		},
		"italic_let_ku", {
			unicode: "10312",
			tags: ["древнеиталийская буква Ку", "old italic letter Ku"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "Q" },
		},
		"italic_let_er", {
			unicode: "10313",
			tags: ["древнеиталийская буква Эр", "old italic letter Er"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "R" },
		},
		"italic_let_ers", {
			unicode: "1031B",
			tags: ["древнеиталийская буква Эрс", "old italic letter Ers"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ R" },
		},
		"italic_let_es", {
			unicode: "10314",
			tags: ["древнеиталийская буква Эс", "old italic letter Es"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "S" },
		},
		"italic_let_esh", {
			unicode: "1030E",
			tags: ["древнеиталийская буква Эш", "old italic letter Esh"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ S" },
		},
		"italic_let_she", {
			unicode: "10311",
			tags: ["древнеиталийская буква Ше", "old italic letter She"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "<+ S" },
		},
		"italic_let_ess", {
			unicode: "1031F",
			tags: ["древнеиталийская буква Эсс", "old italic letter Ess"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "<! S" },
		},
		"italic_let_te", {
			unicode: "10315",
			tags: ["древнеиталийская буква Те", "old italic letter Te"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "T" },
		},
		"italic_let_the", {
			unicode: "10308",
			tags: ["древнеиталийская буква Зэ", "old italic letter The"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ T" },
		},
		"italic_let_u", {
			unicode: "10316",
			tags: ["древнеиталийская буква У", "old italic letter U"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "U" },
		},
		"italic_let_uu", {
			unicode: "1031E",
			tags: ["древнеиталийская буква Уу", "old italic letter Uu"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">+ U" },
		},
		"italic_let_eks", {
			unicode: "10317",
			tags: ["древнеиталийская буква Экс", "old italic letter Eks"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "X" },
		},
		"italic_let_northern_tse", {
			unicode: "1032E",
			tags: ["древнеиталийская буква Северная Це", "old italic letter Northern Tse"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "W" },
		},
		"italic_let_southern_tse", {
			unicode: "1032F",
			tags: ["древнеиталийская буква Южная Це", "old italic letter Southern Tse"],
			groups: ["Old Italic"],
			options: { altLayoutKey: "<+ W" },
		},
		"italic_let_numeral_one", {
			unicode: "10320",
			tags: ["древнеиталийская числовая буква один", "old italic numeral letter one"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 1" },
		},
		"italic_let_numeral_five", {
			unicode: "10321",
			tags: ["древнеиталийская числовая буква пять", "old italic numeral letter five"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 2" },
		},
		"italic_let_numeral_ten", {
			unicode: "10322",
			tags: ["древнеиталийская числовая буква десять", "old italic numeral letter ten"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 3" },
		},
		"italic_let_numeral_fifty", {
			unicode: "10323",
			tags: ["древнеиталийская числовая буква пятьдесят", "old italic numeral letter fifty"],
			groups: ["Old Italic"],
			options: { altLayoutKey: ">! 4" },
		},
		;
		;
		; * Phoenician
		;
		;
		"phoenician_n_let_a_alef", {
			unicode: "10900",
			options: { altLayoutKey: "A" },
		},
		"phoenician_n_let_a_ain", {
			unicode: "1090F",
			options: { altLayoutKey: "<+ A, O" },
		},
		"phoenician_n_let_b_bet", {
			unicode: "10901",
			options: { altLayoutKey: "B" },
		},
		"phoenician_n_let_g_gaml", {
			unicode: "10902",
			options: { altLayoutKey: "G" },
		},
		"phoenician_n_let_d_delt", {
			unicode: "10903",
			options: { altLayoutKey: "D" },
		},
		"phoenician_n_let_h_he", {
			unicode: "10904",
			options: { altLayoutKey: "H" },
		},
		"phoenician_n_let_h_het", {
			unicode: "10907",
			options: { altLayoutKey: ">+ H" },
		},
		"phoenician_n_let_w_wau", {
			unicode: "10905",
			options: { altLayoutKey: "W" },
		},
		"phoenician_n_let_z_zai", {
			unicode: "10906",
			options: { altLayoutKey: "Z" },
		},
		"phoenician_n_let_y_yod", {
			unicode: "10909",
			options: { altLayoutKey: "J, Y" },
		},
		"phoenician_n_let_k_kaf", {
			unicode: "1090A",
			options: { altLayoutKey: "K" },
		},
		"phoenician_n_let_l_lamd", {
			unicode: "1090B",
			options: { altLayoutKey: "L" },
		},
		"phoenician_n_let_m_mem", {
			unicode: "1090C",
			options: { altLayoutKey: "M" },
		},
		"phoenician_n_let_n_nun", {
			unicode: "1090D",
			options: { altLayoutKey: "N" },
		},
		"phoenician_n_let_s_semk", {
			unicode: "1090E",
			options: { altLayoutKey: "S" },
		},
		"phoenician_n_let_s_shin", {
			unicode: "10914",
			options: { altLayoutKey: ">+ S" },
		},
		"phoenician_n_let_p_pe", {
			unicode: "10910",
			options: { altLayoutKey: "P" },
		},
		"phoenician_n_let_c_sade", {
			unicode: "10911",
			options: { altLayoutKey: "C" },
		},
		"phoenician_n_let_q_qof", {
			unicode: "10912",
			options: { altLayoutKey: "Q" },
		},
		"phoenician_n_let_r_rosh", {
			unicode: "10913",
			options: { altLayoutKey: "R" },
		},
		"phoenician_n_let_t_tau", {
			unicode: "10915",
			options: { altLayoutKey: "T" },
		},
		"phoenician_n_let_t_tet", {
			unicode: "10908",
			options: { altLayoutKey: ">+ T" },
		},
		"phoenician_n_num_one", {
			unicode: "10916",
			options: { altLayoutKey: ">! 1" },
		},
		"phoenician_n_num_two", {
			unicode: "1091A",
			options: { altLayoutKey: ">! 2" },
		},
		"phoenician_n_num_three", {
			unicode: "1091B",
			options: { altLayoutKey: ">! 3" },
		},
		"phoenician_n_num_ten", {
			unicode: "10917",
			options: { altLayoutKey: ">! 4" },
		},
		"phoenician_n_num_twenty", {
			unicode: "10918",
			options: { altLayoutKey: ">! 5" },
		},
		"phoenician_n_num_hundred", {
			unicode: "10919",
			options: { altLayoutKey: ">! 6" },
		},
		"phoenician_word_separator", {
			unicode: "1091F",
			tags: ["финикийский разделитель слов", "phoenician word separator"],
			groups: ["Phoenician"],
			options: { altLayoutKey: ">! Space" },
		},
		;
		;
		; * Ancient South Arabian
		;
		;
		"south_arabian_n_let_a_alef", {
			unicode: "10A71",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_a_ayn", {
			unicode: "10A72",
			options: { altLayoutKey: ">! $" },
		},
		"south_arabian_n_let_b_beth", {
			unicode: "10A68",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_d_daleth", {
			unicode: "10A75",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_d_dhadhe", {
			unicode: "10A73",
			options: { altLayoutKey: ">! $" },
		},
		"south_arabian_n_let_d_dhaleth", {
			unicode: "10A79",
			options: { altLayoutKey: ">!>+ $" },
		},
		"south_arabian_n_let_f_fe", {
			unicode: "10A70",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_g_gimel", {
			unicode: "10A74",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_g_ghayn", {
			unicode: "10A76",
			options: { altLayoutKey: ">! $" },
		},
		"south_arabian_n_let_h_he", {
			unicode: "10A60",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_h_heth", {
			unicode: "10A62",
			options: { altLayoutKey: ">+ $" },
		},
		"south_arabian_n_let_h_kheth", {
			unicode: "10A6D",
			options: { altLayoutKey: ">! $ | X" },
		},
		"south_arabian_n_let_k_kaph", {
			unicode: "10A6B",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_l_lamedh", {
			unicode: "10A61",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_m_mem", {
			unicode: "10A63",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_n_nun", {
			unicode: "10A6C",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_q_qoph", {
			unicode: "10A64",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_r_resh", {
			unicode: "10A67",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_s_sat", {
			unicode: "10A6A",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_s_samekh", {
			unicode: "10A6F",
			options: { altLayoutKey: "<+ $" },
		},
		"south_arabian_n_let_s_shin", {
			unicode: "10A66",
			options: { altLayoutKey: "<! $" },
		},
		"south_arabian_n_let_s_sadhe", {
			unicode: "10A6E",
			options: { altLayoutKey: ">! $" },
		},
		"south_arabian_n_let_t_taw", {
			unicode: "10A69",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_t_theth", {
			unicode: "10A7C",
			options: { altLayoutKey: "<+ $" },
		},
		"south_arabian_n_let_t_teth", {
			unicode: "10A77",
			options: { altLayoutKey: ">! $" },
		},
		"south_arabian_n_let_t_thaw", {
			unicode: "10A7B",
			options: { altLayoutKey: ">!>+ $" },
		},
		"south_arabian_n_let_w_waw", {
			unicode: "10A65",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_y_yodh", {
			unicode: "10A7A",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_let_z_zayn", {
			unicode: "10A78",
			options: { altLayoutKey: "$" },
		},
		"south_arabian_n_num_one", {
			unicode: "10A7D",
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! 1" },
		},
		"south_arabian_n_num_fifty", {
			unicode: "10A7E",
			groups: ["South Arabian"],
			options: { altLayoutKey: ">! 5" },
		},
		"south_arabian_n_sym_numeral_bracket", {
			unicode: "10A7F",
			options: { altLayoutKey: ">! 0" },
		},
		;
		;
		; * Ancient North Arabian
		;
		;
		"north_arabian_n_let_a_alef", {
			unicode: "10A91",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_a_ain", {
			unicode: "10A92",
			options: { altLayoutKey: ">! $" },
		},
		"north_arabian_n_let_b_beh", {
			unicode: "10A88",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_d_dal", {
			unicode: "10A95",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_d_thal", {
			unicode: "10A99",
			options: { altLayoutKey: ">! $" },
		},
		"north_arabian_n_let_d_dad", {
			unicode: "10A93",
			options: { altLayoutKey: ">!>+ $" },
		},
		"north_arabian_n_let_f_feh", {
			unicode: "10A90",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_g_geem", {
			unicode: "10A94",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_g_ghain", {
			unicode: "10A96",
			options: { altLayoutKey: ">! $" },
		},
		"north_arabian_n_let_h_heh", {
			unicode: "10A80",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_h_hah", {
			unicode: "10A82",
			options: { altLayoutKey: ">! $" },
		},
		"north_arabian_n_let_h_khah", {
			unicode: "10A8D",
			options: { altLayoutKey: ">+ $" },
		},
		"north_arabian_n_let_k_kaf", {
			unicode: "10A8B",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_l_lam", {
			unicode: "10A81",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_m_meem", {
			unicode: "10A83",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_n_noon", {
			unicode: "10A8C",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_q_qaf", {
			unicode: "10A84",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_r_reh", {
			unicode: "10A87",
			options: { altLayoutKey: "R" },
		},
		"north_arabian_n_let_s_es", {
			unicode: "10A8F",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_s_esh", {
			unicode: "10A8A",
			options: { altLayoutKey: "<! $" },
		},
		"north_arabian_n_let_s_sh", {
			unicode: "10A86",
			options: { altLayoutKey: "<+ $" },
		},
		"north_arabian_n_let_s_sad", {
			unicode: "10A8E",
			options: { altLayoutKey: ">! $" },
		},
		"north_arabian_n_let_t_teh", {
			unicode: "10A89",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_t_tah", {
			unicode: "10A97",
			options: { altLayoutKey: ">! $" },
		},
		"north_arabian_n_let_t_zah", {
			unicode: "10A9C",
			options: { altLayoutKey: "<+ $" },
		},
		"north_arabian_n_let_t_theh", {
			unicode: "10A9B",
			options: { altLayoutKey: ">!>+ $" },
		},
		"north_arabian_n_let_w_waw", {
			unicode: "10A85",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_y_yeh", {
			unicode: "10A9A",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_let_z_zain", {
			unicode: "10A98",
			options: { altLayoutKey: "$" },
		},
		"north_arabian_n_num_one", {
			unicode: "10A9D",
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! 1" },
		},
		"north_arabian_n_num_ten", {
			unicode: "10A9E",
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! 2" },
		},
		"north_arabian_n_num_twenty", {
			unicode: "10A9F",
			groups: ["North Arabian"],
			options: { altLayoutKey: ">! 3" },
		},
		;
		;
		; * Sidetic Script
		;
		;
		"sidetic_n_let_a_N01", {
			unicode: "10940",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_a_N22", {
			unicode: "10955",
			options: { altLayoutKey: "<! $" },
		},
		"sidetic_n_let_b_N24", {
			unicode: "10957",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_c_N09", {
			unicode: "10948",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_d_N12", {
			unicode: "1094B",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_e_N02", {
			unicode: "10941",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_g_N19", {
			unicode: "10952",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_h_N20", {
			unicode: "10953",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_i_N03", {
			unicode: "10942",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_k_N23", {
			unicode: "10956",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_l_N17", {
			unicode: "10950",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_m_N10", {
			unicode: "10949",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_n_N16", {
			unicode: "1094F",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_n_N25", {
			unicode: "10958",
			options: { altLayoutKey: ">! $" },
		},
		"sidetic_n_let_o_N04", {
			unicode: "10943",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_p_N08", {
			unicode: "10946",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_r_N21", {
			unicode: "10954",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_s_N14", {
			unicode: "1094D",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_s_N15", {
			unicode: "1094E",
			options: { altLayoutKey: "<! $" },
		},
		"sidetic_n_let_t_N11", {
			unicode: "1094A",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_t_N13", {
			unicode: "1094C",
			options: { altLayoutKey: ">! $" },
		},
		"sidetic_n_let_t_N18", {
			unicode: "10951",
			options: { altLayoutKey: ">!>+ $" },
		},
		"sidetic_n_let_u_N05", {
			unicode: "10944",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_w_N06", {
			unicode: "10945",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_y_N07", {
			unicode: "10946",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_z_N26", {
			unicode: "10959",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_unknown_N27", {
			unicode: "1095A",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_unknown_N28", {
			unicode: "1095B",
			options: { altLayoutKey: "$" },
		},
		"sidetic_n_let_unknown_N29", {
			unicode: "1095C",
			options: { altLayoutKey: "$" },
		},
		;
		;
		; * Ugaritic Script
		;
		;
		"ugaritic_n_let_a_alpa", {
			unicode: "10380",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_a_ain", {
			unicode: "10393",
			options: { altLayoutKey: ">! $" },
		},
		"ugaritic_n_let_b_beta", {
			unicode: "10381",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_d_delta", {
			unicode: "10384",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_d_dhal", {
			unicode: "1038F",
			options: { altLayoutKey: ">! $" },
		},
		"ugaritic_n_let_g_gamla", {
			unicode: "10382",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_g_ghain", {
			unicode: "10399",
			options: { altLayoutKey: ">! $" },
		},
		"ugaritic_n_let_h_ho", {
			unicode: "10385",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_h_kha", {
			unicode: "10383",
			options: { altLayoutKey: ">! $" },
		},
		"ugaritic_n_let_h_hota", {
			unicode: "10388",
			options: { altLayoutKey: ">!>+ $" },
		},
		"ugaritic_n_let_i", {
			unicode: "1039B",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_k_kaf", {
			unicode: "1038B",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_l_lamda", {
			unicode: "1038D",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_m_mem", {
			unicode: "1038E",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_n_nun", {
			unicode: "10390",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_p_pu", {
			unicode: "10394",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_q_qopa", {
			unicode: "10396",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_r_rasha", {
			unicode: "10397",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_s_shin", {
			unicode: "1038C",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_s_samka", {
			unicode: "10392",
			options: { altLayoutKey: "<+ $" },
		},
		"ugaritic_n_let_s_sade", {
			unicode: "10395",
			options: { altLayoutKey: ">! $" },
		},
		"ugaritic_n_let_s_ssu", {
			unicode: "1039D",
			options: { altLayoutKey: "<! $" },
		},
		"ugaritic_n_let_t_to", {
			unicode: "1039A",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_t_thanna", {
			unicode: "10398",
			options: { altLayoutKey: ">!>+ $" },
		},
		"ugaritic_n_let_t_tet", {
			unicode: "10389",
			options: { altLayoutKey: ">! $" },
		},
		"ugaritic_n_let_u", {
			unicode: "1039C",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_w_wo", {
			unicode: "10386",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_y_yod", {
			unicode: "1038A",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_z_zeta", {
			unicode: "10387",
			options: { altLayoutKey: "$" },
		},
		"ugaritic_n_let_z_zu", {
			unicode: "10391",
			options: { altLayoutKey: "<! $" },
		},
		"ugaritic_n_sym_word_divider", {
			unicode: "1039F",
			options: { altLayoutKey: "Space" },
		},
		;
		;
		; * Deseret ABC
		;
		;
		"deseret_[c,s]_let_a_short", {
			unicode: ["10408", "10430"],
			options: { altLayoutKey: "$" },
			symbol: { beforeLetter: "short" },
		},
		"deseret_[c,s]_let_a_long", {
			unicode: ["10402", "1042A"],
			options: { altLayoutKey: "<+ $" },
			symbol: { beforeLetter: "long" },
		},
		"deseret_[c,s]_let_a_ah_short", {
			unicode: ["10409", "10431"],
			options: { altLayoutKey: ">! $" },
			symbol: { beforeLetter: "short" },
		},
		"deseret_[c,s]_let_a_ah_long", {
			unicode: ["10403", "1042B"],
			options: { altLayoutKey: ">!<! $" },
			symbol: { beforeLetter: "long" },
		},
		"deseret_[c,s]_let_a_ow", {
			unicode: ["1040D", "10435"],
			options: { altLayoutKey: "<! /A/" },
			symbol: { letter: ["Ow", "ow"] },
		},
		"deseret_[c,s]_let_b_bee", {
			unicode: ["10412", "1043A"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_c_chee", {
			unicode: ["10415", "1043D"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_d_dee", {
			unicode: ["10414", "1043C"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_d_thee", {
			unicode: ["1041C", "10444"],
			options: { altLayoutKey: "<! $" },
		},
		"deseret_[c,s]_let_e_short", {
			unicode: ["10407", "1042F"],
			options: { altLayoutKey: "$" },
			symbol: { beforeLetter: "short" },
		},
		"deseret_[c,s]_let_e_long", {
			unicode: ["10401", "10429"],
			options: { altLayoutKey: "<+ $" },
			symbol: { beforeLetter: "long" },
		},
		"deseret_[c,s]_let_f_ef", {
			unicode: ["10419", "10441"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_g_gay", {
			unicode: ["10418", "10440"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_h", {
			unicode: ["10410", "10438"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_i_short", {
			unicode: ["10406", "1042E"],
			options: { altLayoutKey: "$" },
			symbol: { beforeLetter: "short" },
		},
		"deseret_[c,s]_let_i_long", {
			unicode: ["10400", "10428"],
			options: { altLayoutKey: ">! $" },
			symbol: { beforeLetter: "long" },
		},
		"deseret_[c,s]_let_i_ay", {
			unicode: ["1040C", "10434"],
			options: { altLayoutKey: "<! $" },
			symbol: { beforeLetter: "long" },
		},
		"deseret_[c,s]_let_j_jee", {
			unicode: ["10416", "1043E"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_k_kay", {
			unicode: ["10417", "1043F"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_l_el", {
			unicode: ["10422", "1044A"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_m_em", {
			unicode: ["10423", "1044B"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_n_en", {
			unicode: ["10424", "1044C"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_n_eng", {
			unicode: ["10425", "1044D"],
			options: { altLayoutKey: ">! $" },
		},
		"deseret_[c,s]_let_o_short", {
			unicode: ["1040A", "10432"],
			options: { altLayoutKey: "$" },
			symbol: { beforeLetter: "short" },
		},
		"deseret_[c,s]_let_o_long", {
			unicode: ["10404", "1042C"],
			options: { altLayoutKey: ">+ $" },
			symbol: { beforeLetter: "long" },
		},
		"deseret_[c,s]_let_o_oi", {
			unicode: ["10426", "1044E"],
			options: { altLayoutKey: ">! $" },
			symbol: { beforeLetter: "short" },
		},
		"deseret_[c,s]_let_p_pee", {
			unicode: ["10411", "10439"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_r_er", {
			unicode: ["10421", "10449"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_s_es", {
			unicode: ["1041D", "10445"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_s_esh", {
			unicode: ["1041F", "10447"],
			options: { altLayoutKey: "<! $" },
		},
		"deseret_[c,s]_let_t_tee", {
			unicode: ["10413", "1043B"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_t_eth", {
			unicode: ["1041B", "10443"],
			options: { altLayoutKey: ">! $" },
		},
		"deseret_[c,s]_let_u_oo_short", {
			unicode: ["1040B", "10433"],
			options: { altLayoutKey: "$" },
			symbol: { beforeLetter: "short" },
		},
		"deseret_[c,s]_let_u_oo_long", {
			unicode: ["10405", "1042D"],
			options: { altLayoutKey: ">! $" },
			symbol: { beforeLetter: "long" },
		},
		"deseret_[c,s]_let_u_ew", {
			unicode: ["10427", "1044F"],
			options: { altLayoutKey: "<! $" },
		},
		"deseret_[c,s]_let_v_vee", {
			unicode: ["1041A", "10442"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_w_wu", {
			unicode: ["1040E", "10436"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_y_yee", {
			unicode: ["1040F", "10437"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_z_zee", {
			unicode: ["1041E", "10446"],
			options: { altLayoutKey: "$" },
		},
		"deseret_[c,s]_let_z_zhee", {
			unicode: ["10420", "10448"],
			options: { altLayoutKey: "<! $" },
		},
		;
		;
		; * Shavian ABC
		;
		;
		"shavian_n_let_a_ash", {
			unicode: "10468",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_a_ice", {
			unicode: "10472",
			options: { altLayoutKey: "<! $" },
		},
		"shavian_n_let_a_ado", {
			unicode: "10469",
			options: { altLayoutKey: ">! $" },
		},
		"shavian_n_let_a_up", {
			unicode: "10473",
			options: { altLayoutKey: "<+ $" },
		},
		"shavian_n_let_a_ah", {
			unicode: "1046D",
			options: { altLayoutKey: ">!>+ $" },
		},
		"shavian_n_let_b_bib", {
			unicode: "1045A",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_c_church", {
			unicode: "10457",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_d_dead", {
			unicode: "1045B",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_d_they", {
			unicode: "1045E",
			options: { altLayoutKey: "<! $" },
		},
		"shavian_n_let_e_egg", {
			unicode: "10467",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_e_age", {
			unicode: "10471",
			options: { altLayoutKey: "<! $" },
		},
		"shavian_n_let_f_fee", {
			unicode: "10453",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_g_gag", {
			unicode: "1045C",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_h_ha_ha", {
			unicode: "10463",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_i_if", {
			unicode: "10466",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_i_eat", {
			unicode: "10470",
			options: { altLayoutKey: ">! $" },
		},
		"shavian_n_let_j_judge", {
			unicode: "10461",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_k_kick", {
			unicode: "10452",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_l_loll", {
			unicode: "10464",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_m_mime", {
			unicode: "10465",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_n_nun", {
			unicode: "1046F",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_n_hung", {
			unicode: "10459",
			options: { altLayoutKey: ">! $" },
		},
		"shavian_n_let_o_on", {
			unicode: "1046A",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_o_oak", {
			unicode: "10474",
			options: { altLayoutKey: ">! $" },
		},
		"shavian_n_let_o_awe", {
			unicode: "10477",
			options: { altLayoutKey: ">!>+ $" },
		},
		"shavian_n_let_p_peep", {
			unicode: "10450",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_r_roar", {
			unicode: "1046E",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_s_so", {
			unicode: "10455",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_s_sure", {
			unicode: "10456",
			options: { altLayoutKey: "<! $" },
		},
		"shavian_n_let_t_tot", {
			unicode: "10451",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_t_thigh", {
			unicode: "10454",
			options: { altLayoutKey: ">! $" },
		},
		"shavian_n_let_u_wool", {
			unicode: "1046B",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_u_ooze", {
			unicode: "10475",
			options: { altLayoutKey: ">! $" },
		},
		"shavian_n_let_v_vow", {
			unicode: "1045D",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_y_yea", {
			unicode: "10458",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_w_woe", {
			unicode: "10462",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_z_zoo", {
			unicode: "1045F",
			options: { altLayoutKey: "$" },
		},
		"shavian_n_let_z_measure", {
			unicode: "10460",
			options: { altLayoutKey: "<! $" },
		},
		"shavian_n_lig_are", {
			unicode: "10478",
			options: { altLayoutKey: ">!<! /A/" },
			recipe: ["${shavian_n_let_a_ah}${shavian_n_let_r_roar}"],
		},
		"shavian_n_lig_or", {
			unicode: "10479",
			options: { altLayoutKey: ">!<! /O/" },
			recipe: ["${shavian_n_let_o_awe}${shavian_n_let_r_roar}"],
		},
		"shavian_n_lig_air", {
			unicode: "1047A",
			options: { altLayoutKey: ">!<! /E/" },
			recipe: ["${shavian_n_let_e_egg×2}${shavian_n_let_r_roar}"],
		},
		"shavian_n_lig_err", {
			unicode: "1047B",
			options: { altLayoutKey: ">!<!<+ /E/" },
			recipe: ["${shavian_n_let_e_egg}${shavian_n_let_a_ado}${shavian_n_let_r_roar}"],
		},
		"shavian_n_lig_array", {
			unicode: "1047C",
			options: { altLayoutKey: ">!<! /R/" },
			recipe: ["${shavian_n_let_a_ado}${shavian_n_let_r_roar}"],
		},
		"shavian_n_lig_ear", {
			unicode: "1047D",
			options: { altLayoutKey: ">!<!<+ /R/" },
			recipe: ["${shavian_n_let_i_if}${shavian_n_let_a_ado}${shavian_n_let_r_roar}"],
		},
		"shavian_n_lig_ian", {
			unicode: "1047E",
			options: { altLayoutKey: ">!<! /I/" },
			recipe: ["${shavian_n_let_i_if}${shavian_n_let_a_ado}"],
		},
		"shavian_n_lig_yew", {
			unicode: "1047F",
			options: { altLayoutKey: ">!<! /J/" },
			recipe: ["${shavian_n_let_y_yea}${shavian_n_let_u_ooze}"],
		},
		;
		;
		; * Wallet Signs
		;
		;
		"wallet_sign", {
			unicode: "00A4",
			tags: ["знак валюты", "currency sign"],
			groups: ["Wallet Signs"],
			recipe: ["XO"],
		},
		"wallet_austral", {
			unicode: "20B3",
			tags: ["аустраль", "austral"],
			groups: ["Wallet Signs"],
			recipe: ["A=", "ARA"],
		},
		"wallet_cent", {
			unicode: "00A2",
			alterations: {
				fullwidth: "FFE0"
			},
			tags: ["цент", "cent"],
			groups: ["Wallet Signs"],
			recipe: ["c|", "CNT"],
		},
		"wallet_cedi", {
			unicode: "20B5",
			tags: ["седи", "cedi"],
			groups: ["Wallet Signs"],
			recipe: ["C|", "GHS", "CED"],
		},
		"wallet_colon", {
			unicode: "20A1",
			tags: ["колон", "colon"],
			groups: ["Wallet Signs"],
			recipe: ["C//", "CRC", "SVC"],
		},
		"wallet_dollar", {
			unicode: "0024",
			alterations: {
				small: "FE69",
				fullwidth: "FF04"
			},
			tags: ["доллар", "dollar"],
			groups: ["Wallet Signs"],
			recipe: ["S|", "USD", "DLR"],
		},
		"wallet_dram", {
			unicode: "058F",
			tags: ["драм", "dram"],
			groups: ["Wallet Signs"],
			recipe: ["AMD", "DRM"],
		},
		"wallet_doromi", {
			unicode: "07FE",
			tags: ["дороми", "doromi"],
			groups: ["Wallet Signs"],
			recipe: ["DOR"],
		},
		"wallet_eur", {
			unicode: "20AC",
			tags: ["евро", "euro"],
			groups: ["Wallet Signs"],
			recipe: ["C=", "EUR"],
		},
		"wallet_franc", {
			unicode: "20A3",
			tags: ["франк", "franc"],
			groups: ["Wallet Signs"],
			recipe: ["F=", "FRF"],
		},
		"wallet_guarani", {
			unicode: "20B2",
			tags: ["гуарани", "guarani"],
			groups: ["Wallet Signs"],
			recipe: ["G/", "PYG", "GNF"],
		},
		"wallet_kip", {
			unicode: "20AD",
			tags: ["кип", "kip"],
			groups: ["Wallet Signs"],
			recipe: ["K-", "LAK", "KIP"],
		},
		"wallet_lari", {
			unicode: "20BE",
			tags: ["лари", "lari"],
			groups: ["Wallet Signs"],
			recipe: ["GEL", "LAR"],
		},
		"wallet_naira", {
			unicode: "20A6",
			tags: ["наира", "naira"],
			groups: ["Wallet Signs"],
			recipe: ["N=", "NGN", "NAR"],
		},
		"wallet_pound", {
			unicode: "00A3",
			alterations: {
				fullwidth: "FFE1"
			},
			tags: ["фунт", "pound"],
			groups: ["Wallet Signs"],
			recipe: ["f_", "GBP"],
		},
		"wallet_tournois", {
			unicode: "20B6",
			tags: ["турский ливр", "tournois"],
			groups: ["Wallet Signs"],
			recipe: ["lt", "LTF"],
		},
		"wallet_rub", {
			unicode: "20BD",
			tags: ["рубль", "ruble"],
			groups: ["Wallet Signs"],
			recipe: ["Р=", "RUB", "РУБ"],
		},
		"wallet_hryvnia", {
			unicode: "20B4",
			tags: ["гривна", "hryvnia"],
			groups: ["Wallet Signs"],
			recipe: ["S=", "UAH", "ГРН"],
		},
		"wallet_lira", {
			unicode: "20A4",
			tags: ["лира", "lira"],
			groups: ["Wallet Signs"],
			recipe: ["f=", "LIR"],
		},
		"wallet_turkish_lira", {
			unicode: "20BA",
			tags: ["лира", "lira"],
			groups: ["Wallet Signs"],
			recipe: ["L=", "TRY"],
		},
		"wallet_rupee", {
			unicode: "20B9",
			tags: ["рупия", "rupee"],
			groups: ["Wallet Signs"],
			recipe: ["R=", "INR", "RUP"],
		},
		"wallet_won", {
			unicode: "20A9",
			alterations: {
				fullwidth: "FFE6"
			},
			tags: ["вон", "won"],
			groups: ["Wallet Signs"],
			recipe: ["W=", "WON", "KRW"],
		},
		"wallet_yen", {
			unicode: "00A5",
			alterations: {
				fullwidth: "FFE5"
			},
			tags: ["знак йены", "yen sign"],
			groups: ["Wallet Signs"],
			recipe: ["Y=", "YEN"],
		},
		"wallet_jpy_yen", {
			unicode: "5186",
			tags: ["йена", "yen"],
			groups: ["Wallet Signs"],
			recipe: ["JPY"],
		},
		"wallet_cny_yuan", {
			unicode: "5143",
			tags: ["юань", "yuan"],
			groups: ["Wallet Signs"],
			recipe: ["CNY"],
		},
		"wallet_viet_dong", {
			unicode: "20AB",
			tags: ["вьетнамский донг", "vietnamese dong"],
			groups: ["Wallet Signs"],
			recipe: [
				"d${(stroke_short|macron_below)}$(*)",
				"${lat_s_let_d__(stroke_short|line_below)}$(*)",
				"VND", "DNG"
			],
		},
		"wallet_mongol_tugrik", {
			unicode: "20AE",
			tags: ["монгольский тугрик", "mongolian tugrik"],
			groups: ["Wallet Signs"],
			recipe: ["T//", "MNT", "TGK"],
		},
		"wallet_qazaq_tenge", {
			unicode: "20B8",
			tags: ["казахский тенге", "kazakh tenge"],
			groups: ["Wallet Signs"],
			recipe: ["T=", "KZT", "TNG"],
		},
		"wallet_new_sheqel", {
			unicode: "20AA",
			tags: ["новый шекель", "new sheqel"],
			groups: ["Wallet Signs"],
			recipe: ["NZD", "SHQ"],
		},
		"wallet_philippine_peso", {
			unicode: "20B1",
			tags: ["филиппинский песо", "philippine peso"],
			groups: ["Wallet Signs"],
			recipe: ["P=", "PHP"],
		},
		"wallet_roman_[denarius,quinarius,sestertius,dupondius,as]", {
			unicode: ["10196", "10197", "10198", "10199", "1019A"],
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
			symbol: { font: "Catrinity" },
		},
		"wallet_bitcoin", {
			unicode: "20BF",
			tags: ["биткоин", "bitcoin"],
			groups: ["Wallet Signs"],
			recipe: ["B||", "BTC"],
		},
		;
		;
		; * Extra Symbolistics
		;
		;
		"symbolistics_chi_rho", {
			unicode: "2627",
			tags: ["Chi Rho", "Chrismon", "Хризма", "Хримсон", "Хи-Ро"],
			groups: ["Extra Symbolistics"],
			recipe: ["${hel_c_let_h_chi}${hel_c_let_r_rho}"]
		},
		"symbolistics_rod_of_asclepius", {
			unicode: "2695",
			tags: ["rod of Asclepius", "посох Асклепия"],
			groups: ["Extra Symbolistics"],
			recipe: ["ascl", "аскл"],
		},
		"symbolistics_caduceus", {
			unicode: "2624",
			tags: ["Caduceus", "Кадуцей"],
			groups: ["Extra Symbolistics"],
			recipe: ["cadu", "каду"],
		},
		"symbolistics_staff_of_hermes", {
			unicode: "269A",
			tags: ["staff of Hermes", "посох Гермеса"],
			groups: ["Extra Symbolistics"],
			recipe: ["herms", "гермс"],
		},
		"symbolistics_ankh", {
			unicode: "2625",
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
			unicode: "1F701",
			tags: ["alchemical air", "алхимический воздух"],
			groups: ["Alchemical"],
			recipe: ["alc air"],
		},
		"alchemical_element_fire", {
			unicode: "1F702",
			tags: ["alchemical fire", "алхимический огонь"],
			groups: ["Alchemical"],
			recipe: ["alc fire"],
		},
		"alchemical_element_earth", {
			unicode: "1F703",
			tags: ["alchemical earth", "алхимическая земля"],
			groups: ["Alchemical"],
			recipe: ["alc earth"],
		},
		"alchemical_element_water", {
			unicode: "1F704",
			tags: ["alchemical water", "алхимическая вода"],
			groups: ["Alchemical"],
			recipe: ["alc water"],
		},
		"alchemical_acid_nitric", {
			unicode: "1F705",
			tags: ["alchemical nitric acid", "alchemical aqua fortis", "алхимическая азотная кислота"],
			groups: ["Alchemical"],
			recipe: ["${alchemical_element_water}F", "alc nitric acid", "alc aqua fortis"],
		},
		"alchemical_acid_nitrohydrochloric", {
			unicode: "1F706",
			tags: ["alchemical nitrohydrochloric acid", "alchemical aqua regia", "алхимическая царская водка"],
			groups: ["Alchemical"],
			recipe: ["${alchemical_element_water}R", "alc aqua regia"],
		},
		"alchemical_acid_vinegar", {
			unicode: "1F70A",
			tags: ["alchemical acetic acid", "alchemical vinegar", "алхимическая уксусная кислота"],
			groups: ["Alchemical"],
			recipe: ["alc acetic acid", "alc vinegar"],
		},
		"alchemical_acid_vinegar_distilled_1", {
			unicode: "1F70B",
			tags: ["alchemical distilled acetic acid-1", "alchemical distilled vinegar-1", "алхимическая дистилированная уксусная кислота-1"],
			groups: ["Alchemical"],
			recipe: [":${alchemical_acid_vinegar}:", "alc dis vinegar-1"],
		},
		"alchemical_acid_vinegar_distilled_2", {
			unicode: "1F70C",
			tags: ["alchemical distilled acetic acid-2", "alchemical distilled vinegar-2", "алхимическая дистилированная уксусная кислота-2"],
			groups: ["Alchemical"],
			recipe: [":I:", "alc dis vinegar-2"],
		},
		"alchemical_sand_bath", {
			unicode: "1F707",
			tags: ["alchemical sand bath", "alchemical aqua regia-2", "алхимическая песчаная баня", "алхимическая царская водка-2"],
			groups: ["Alchemical"],
			recipe: ["AR", "alc sand bath"],
		},
		"alchemical_ethanol_1", {
			unicode: "1F708",
			tags: ["alchemical ethanol-1", "alchemical aqua vitae-1", "алхимический этанол-1"],
			groups: ["Alchemical"],
			recipe: ["alc ethanol-1"],
		},
		"alchemical_ethanol_2", {
			unicode: "1F709",
			tags: ["alchemical ethanol-2", "alchemical aqua vitae-2", "алхимический этанол-2"],
			groups: ["Alchemical"],
			recipe: ["alc ethanol-2"],
		},
		"alchemical_brimstone", {
			unicode: "1F70D",
			tags: ["alchemical brimstone", "alchemical sulfur", "alchemical sulphur", "алхимическая сера"],
			groups: ["Alchemical"],
			recipe: ["${alchemical_element_fire}${dagger}", "alc sulfur"],
		},
		"alchemical_brimstone_philosophers", {
			unicode: "1F70E",
			tags: ["alchemical philosophers brimstone", "alchemical philosophers sulfur", "alchemical philosophers sulphur", "алхимическая философская сера"],
			groups: ["Alchemical"],
			recipe: ["alc phi sulfur"],
		},
		"alchemical_brimstone_black", {
			unicode: "1F70F",
			tags: ["alchemical black brimstone", "alchemical black sulfur", "alchemical black sulphur", "алхимическая чёрная сера"],
			groups: ["Alchemical"],
			recipe: ["alc black sulfur"],
		},
		"alchemical_salt", {
			unicode: "1F714",
			tags: ["alchemical salt", "archaic astrological Earth", "алхимическая соль", "архаичное астрологическая Земля"],
			groups: ["Alchemical"],
			recipe: ["alc salt", "astrol arc Earth"],
		},
		"alchemical_potassium_nitrate", {
			unicode: "1F715",
			tags: ["alchemical potassium nitrate", "alchemical nitre", "алхимический нитрат калия"],
			groups: ["Alchemical"],
			recipe: ["alc nitre"],
		},
		"alchemical_vitriol_1", {
			unicode: "1F716",
			tags: ["alchemical metal sulfate-1", "alchemical vitriol-1", "алхимический сульфат металла-1"],
			groups: ["Alchemical"],
			recipe: ["alc vitriol-1"],
		},
		"alchemical_vitriol_2", {
			unicode: "1F717",
			tags: ["alchemical metal sulfate-2", "alchemical vitriol-2", "алхимический сульфат металла-2"],
			groups: ["Alchemical"],
			recipe: ["alc vitriol-2"],
		},
		"alchemical_rock_salt_1", {
			unicode: "1F718",
			tags: ["alchemical rock salt-1", "alchemical bismuth", "алхимическая каменная соль-1", "алхимический висмут"],
			groups: ["Alchemical"],
			recipe: ["alc rock salt-1", "alc bismuth"],
		},
		"alchemical_rock_salt_2", {
			unicode: "1F719",
			tags: ["alchemical rock salt-2", "алхимическая каменная соль-2"],
			groups: ["Alchemical"],
			recipe: ["alc rock salt-2"],
		},
		"alchemical_gold", {
			unicode: "1F71A",
			tags: ["alchemical gold", "алхимическое золото"],
			groups: ["Alchemical"],
			recipe: ["alc gold"],
		},
		"alchemical_silver", {
			unicode: "1F71B",
			tags: ["alchemical silver", "алхимическое серебро"],
			groups: ["Alchemical"],
			recipe: ["alc silver"],
		},
		"alchemical_iron_ore_1", {
			unicode: "1F71C",
			tags: ["alchemical iron ore-1", "алхимическая железая руда-1"],
			groups: ["Alchemical"],
			recipe: ["alc iron ore-1"],
		},
		"alchemical_iron_ore_2", {
			unicode: "1F71D",
			tags: ["alchemical iron ore-2", "алхимическая железая руда-2"],
			groups: ["Alchemical"],
			recipe: ["alc iron ore-2"],
		},
		"alchemical_copper_ore", {
			unicode: "1F720",
			tags: ["alchemical copper ore", "алхимическая медная руда"],
			groups: ["Alchemical"],
			recipe: ["alc cop ore"],
		},
		"alchemical_iron_copper_ore", {
			unicode: "1F721",
			tags: ["alchemical iron-copper ore", "алхимическая медно-железная руда"],
			groups: ["Alchemical"],
			recipe: ["alc iron cop ore"],
		},
		"alchemical_crocus_of_iron", {
			unicode: "1F71E",
			tags: ["alchemical crocus of iron", "алхимический крокус железа"],
			groups: ["Alchemical"],
			recipe: ["alc iron croc"],
		},
		"alchemical_regulus_of_iron", {
			unicode: "1F71F",
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
			unicode: "1F728",
			tags: ["alchemical copper acetate", "alchemical aes viride", "astrological Earth", "алхимический ацетат меди", "астрологическая Земля"],
			groups: ["Astrology"],
			recipe: ["astrol Earth", "alc cop acetate"],
		},
		"astrological_neptune", {
			unicode: "2646",
			tags: ["astrological Neptune", "астрологический Нептун"],
			groups: ["Astrology"],
			recipe: ["astrol Neptune"],
		},
		"astrological_uranus", {
			unicode: "2645",
			tags: ["astrological Uranus", "астрологический Уран"],
			groups: ["Astrology"],
			recipe: ["astrol Uranus"],
		},
		"astrological_pluto_1", {
			unicode: "2647",
			tags: ["astrological Pluto-1", "астрологическая Плутон-1"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-1"],
		},
		"astrological_pluto_2", {
			unicode: "2BD3",
			tags: ["astrological Pluto-2", "астрологическая Плутон-2"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-2"],
		},
		"astrological_pluto_3", {
			unicode: "2BD4",
			tags: ["astrological Pluto-3", "астрологическая Плутон-3"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-3"],
		},
		"astrological_pluto_4", {
			unicode: "2BD5",
			tags: ["astrological Pluto-4", "астрологическая Плутон-4"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-4"],
		},
		"astrological_pluto_5", {
			unicode: "2BD6",
			tags: ["astrological Pluto-5", "астрологическая Плутон-5"],
			groups: ["Astrology"],
			recipe: ["astrol Pluto-5"],
		},
		"astrological_transpluto", {
			unicode: "2BD7",
			tags: ["astrological Transpluto", "астрологическая Трансплутон"],
			groups: ["Astrology"],
			recipe: ["astrol Transpluto"],
		},
		"astrological_vesta", {
			unicode: "26B6",
			tags: ["astrological Vesta", "астрологическая Веста"],
			groups: ["Astrology"],
			recipe: ["astrol Vesta"],
		},
		"astrological_chiron", {
			unicode: "26B7",
			tags: ["astrological Chiron", "астрологическая Хирон"],
			groups: ["Astrology"],
			recipe: ["astrol Chiron"],
		},
		"astrological_proserpina", {
			unicode: "2BD8",
			tags: ["astrological Proserpina", "астрологическая Прозерпина"],
			groups: ["Astrology"],
			recipe: ["astrol Proserpina"],
		},
		"astrological_astraea", {
			unicode: "2BD9",
			tags: ["astrological Astraea", "астрологическая Астрея"],
			groups: ["Astrology"],
			recipe: ["astrol Astraea"],
		},
		"astrological_hygiea", {
			unicode: "2BDA",
			tags: ["astrological Hygiea", "астрологическая Гигея"],
			groups: ["Astrology"],
			recipe: ["astrol Hygiea"],
		},
		"astrological_pholus", {
			unicode: "2BDB",
			tags: ["astrological Pholus", "астрологическая Фол"],
			groups: ["Astrology"],
			recipe: ["astrol Pholus"],
		},
		"astrological_nessus", {
			unicode: "2BDC",
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
			unicode: "2641",
			tags: ["alchemical antimony trisulfide", "alchemical stibnite", "astronomical Earth", "алхимический стибнит", "алхимический сульфид сурьмы", "астрономическая Земля"],
			groups: ["Astronomy"],
			recipe: ["astron Earth", "alc stibnite"],
		},
		"astronomical_neptune", {
			unicode: "2BC9",
			tags: ["astronomical Neptune", "астрономический Нептун"],
			groups: ["Astrology"],
			recipe: ["astron Neptune"],
		},
		"astronomical_uranus", {
			unicode: "26E2",
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
			unicode: "00A9",
			tags: ["копирайт", "copyright"],
			groups: ["Other Signs"],
			options: { fastKey: "2" },
			recipe: ["copy", "cri"],
		},
		"copyleft", {
			unicode: "1F12F",
			tags: ["копилефт", "copyleft"],
			groups: ["Other Signs"],
			recipe: ["cft"],
			symbol: { font: "Kurinto Sans" },
		},
		"registered", {
			unicode: "00AE",
			tags: ["зарегистрированный", "registered"],
			groups: ["Other Signs"],
			options: { fastKey: "c* 2", send: "Text" },
			recipe: ["reg"],
		},
		"trademark", {
			unicode: "2122",
			tags: ["торговый знак", "trademark"],
			groups: ["Other Signs"],
			options: { fastKey: "<+ 2" },
			recipe: ["TM", "tm"],
		},
		"servicemark", {
			unicode: "2120",
			tags: ["знак обслуживания", "servicemark"],
			groups: ["Other Signs"],
			options: { fastKey: "c*<+ 2" },
			recipe: ["SM", "sm"],
		},
		"sound_recording_copyright", {
			unicode: "2117",
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
		"ipa_s_modifiers", {
			unicode: "02B2",
			groups: ["IPA"],
			options: { noCalc: True, altLayoutKey: "+>+ a-z" },
			symbol: { alt: "◌ᵃ◌ᵇ◌ᶜ◌ᵈ◌ᵉ◌ᶠ◌ᵍ◌ʰ◌ʲ◌ᵏ◌ˡ" },
		},
		;
		;
		; * Etc.
		;
		;
		"replacment_character", {
			titles: Map("ru-RU", "Заменяющий символ", "en-US", "Replacement character"),
			unicode: "FFFD",
			options: { noCalc: True },
			recipe: ["null"]
		},
		"object_replacement_character", {
			titles: Map("ru-RU", "Объекто-заменяющий символ", "en-US", "Object replacement character"),
			unicode: "FFFC",
			options: { noCalc: True },
			recipe: ["obj"]
		},
		"amogus", {
			titles: Map("ru-RU", "Амогус", "en-US", "Amogus"),
			tags: ["амогус", "член экипажа", "amogus", "crewmate"],
			unicode: "0D9E",
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
				titles: Map("ru-RU", "Селектор варианта " index, "en-US", "Variation selector " index),
				unicode: "" unicodeValue "",
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
				titles: Map(
					"en-US", "Emoji Modifier Fitzpatrick " index,
					"ru-RU", "Модификатор Фицпатрика " index
				),
				unicode: "" unicodeValue "",
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
				titles: Map(
					"en-US", "Emoji Component " title,
					"ru-RU", "Компонент эмодзи " title
				),
				unicode: "" unicodeValue "",
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