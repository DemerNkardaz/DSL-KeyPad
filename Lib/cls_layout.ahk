Class BindList {
	mapping := []

	__New(mapping := [], modMapping := []) {

		this.mapping := mapping.Clone()

		if modMapping.Length > 0 {
			Loop modMapping.Length // 2 {
				index := A_Index * 2 - 1
				letterKey := modMapping[index]
				binds := modMapping[index + 1]

				for modifier, value in binds {
					this.mapping.Push(modifier "[" letterKey "]", value)
				}
			}
		}

		return this
	}

}

Class KeyboardBinder {

	static layouts := {
		winDefault: Map(
			"Space", "SC039",
			"Tab", "SC00F",
			"Numpad0", "SC052",
			"Numpad1", "SC04F",
			"Numpad2", "SC050",
			"Numpad3", "SC051",
			"Numpad4", "SC04B",
			"Numpad5", "SC04C",
			"Numpad6", "SC04D",
			"Numpad7", "SC047",
			"Numpad8", "SC048",
			"Numpad9", "SC049",
			"NumpadMult", "SC037",
			"NumpadAdd", "SC04E",
			"NumpadSub", "SC04A",
			"NumpadDot", "SC053",
			"NumpadDiv", "SC135",
			"NumpadEnter", "SC11C",
			"PgUp", "SC149",
			"PgDn", "SC151",
			"End", "SC14F",
			"Home", "SC147",
			"Ins", "SC152",
			"Del", "SC153",
			"Shift", "SC02A",
			"Ctrl", "SC01D",
			"Alt", "SC038",
			"LShift", "SC02A",
			"RShift", "SC036",
			"LCtrl", "SC01D",
			"RCtrl", "SC11D",
			"RAlt", "SC138",
			"Backspace", "SC00E",
			"Enter", "SC01C",
			"ArrLeft", "SC14B",
			"ArrUp", "SC148",
			"ArrRight", "SC14D",
			"ArrDown", "SC150",
			"F1", "SC03B",
			"F2", "SC03C",
			"F3", "SC03D",
			"F4", "SC03E",
			"F5", "SC03F",
			"F6", "SC040",
			"F7", "SC041",
			"F8", "SC042",
			"F9", "SC043",
			"F10", "SC044",
			"F11", "SC057",
			"F12", "SC058",
			;
			"0", "SC00B",
			"1", "SC002",
			"2", "SC003",
			"3", "SC004",
			"4", "SC005",
			"5", "SC006",
			"6", "SC007",
			"7", "SC008",
			"8", "SC009",
			"9", "SC00A",
		),
		latin: Map(
			"QWERTY", Map(
				"Semicolon", "SC027",
				"Apostrophe", "SC028",
				"LSquareBracket", "SC01A",
				"RSquareBracket", "SC01B",
				"Tilde", "SC029",
				"Minus", "SC00C",
				"Equals", "SC00D",
				"Comma", "SC033",
				"Dot", "SC034",
				"Slash", "SC035",
				"Backslash", "SC02B",
				"A", "SC01E",
				"B", "SC030",
				"C", "SC02E",
				"D", "SC020",
				"E", "SC012",
				"F", "SC021",
				"G", "SC022",
				"H", "SC023",
				"I", "SC017",
				"J", "SC024",
				"K", "SC025",
				"L", "SC026",
				"M", "SC032",
				"N", "SC031",
				"O", "SC018",
				"P", "SC019",
				"Q", "SC010",
				"R", "SC013",
				"S", "SC01F",
				"T", "SC014",
				"U", "SC016",
				"V", "SC02F",
				"W", "SC011",
				"X", "SC02D",
				"Y", "SC015",
				"Z", "SC02C",
			),
			"Dvorak", Map(
				"Semicolon", "SC02C",
				"Apostrophe", "SC010",
				"LSquareBracket", "SC00C",
				"RSquareBracket", "SC00D",
				"Tilde", "SC029",
				"Minus", "SC028",
				"Equals", "SC01B",
				"Comma", "SC011",
				"Dot", "SC012",
				"Slash", "SC01A",
				"Backslash", "SC02B",
				"A", "SC01E",
				"B", "SC031",
				"C", "SC017",
				"D", "SC023",
				"E", "SC020",
				"F", "SC015",
				"G", "SC016",
				"H", "SC024",
				"I", "SC022",
				"J", "SC02E",
				"K", "SC02F",
				"L", "SC019",
				"M", "SC032",
				"N", "SC026",
				"O", "SC01F",
				"P", "SC013",
				"Q", "SC02D",
				"R", "SC018",
				"S", "SC027",
				"T", "SC025",
				"U", "SC021",
				"V", "SC034",
				"W", "SC033",
				"X", "SC030",
				"Y", "SC014",
				"Z", "SC035",
			),
			"Colemak", Map(
				"Semicolon", "SC019",
				"Apostrophe", "SC028",
				"LSquareBracket", "SC01A",
				"RSquareBracket", "SC01B",
				"Tilde", "SC029",
				"Minus", "SC00C",
				"Equals", "SC00D",
				"Comma", "SC033",
				"Dot", "SC034",
				"Slash", "SC035",
				"Backslash", "SC02B",
				"A", "SC01E",
				"B", "SC030",
				"C", "SC02E",
				"D", "SC022",
				"E", "SC025",
				"F", "SC012",
				"G", "SC014",
				"H", "SC023",
				"I", "SC026",
				"J", "SC015",
				"K", "SC031",
				"L", "SC016",
				"M", "SC032",
				"N", "SC024",
				"O", "SC027",
				"P", "SC013",
				"Q", "SC010",
				"R", "SC01F",
				"S", "SC020",
				"T", "SC021",
				"U", "SC017",
				"V", "SC02F",
				"W", "SC011",
				"X", "SC02D",
				"Y", "SC018",
				"Z", "SC02C",
			),
		),
		cyrillic: Map(
			"ЙЦУКЕН", Map(
				"Ж", "SC027",
				"Э", "SC028",
				"Х", "SC01A",
				"Ъ", "SC01B",
				"Ё", "SC029",
				"Минус", "SC00C",
				"Равно", "SC00D",
				"Б", "SC033",
				"Ю", "SC034",
				"Точка", "SC035",
				"Обратный слэш", "SC02B",
				"Ф", "SC01E",
				"И", "SC030",
				"С", "SC02E",
				"В", "SC020",
				"У", "SC012",
				"А", "SC021",
				"П", "SC022",
				"Р", "SC023",
				"Ш", "SC017",
				"О", "SC024",
				"Л", "SC025",
				"Д", "SC026",
				"Ь", "SC032",
				"Т", "SC031",
				"Щ", "SC018",
				"З", "SC019",
				"Й", "SC010",
				"К", "SC013",
				"Ы", "SC01F",
				"Е", "SC014",
				"Г", "SC016",
				"М", "SC02F",
				"Ц", "SC011",
				"Ч", "SC02D",
				"Н", "SC015",
				"Я", "SC02C",
			),
			"Диктор", Map(),
			"ЙІУКЕН (1907)", Map(),
		),
	}

	static modifiers := [
		"!", "<!", ">!",
		"+", "<+", ">+",
		"^", "<^", ">^",
		"#", "<#", ">#",
		"^!", "<^>!", ">^>!", "<^<!", ">^<!",
		"^+", "<^>+", ">^>+", "<^<+", ">^<+",
		"^#", "<^>#", ">^>#", "<^<#", ">^<#",
		"<^>^", ">^<^", "<^<^", ">^<^",
		"<+>+", ">+<+", "<+<+", ">+<+",
		"^!+", "<^>!+", ">^>!+", "<^<!+", ">^<!+",
		"<^>!<+", ">^>!<+", "<^<!<+", ">^<!<+",
		"<^>!>+", ">^>!>+", "<^<!>+", ">^<!>+",
		"<^>!<+>+", ">^>!<+>+", "<^<!<+>+", ">^<!<+>+",
		"<^>!<!<+", ">^>!<!<+", "<^<!<!<+", ">^<!<!<+",
		"<^>!<!>+", ">^>!<!>+", "<^<!<!>+", ">^<!<!>+",
		"<^>!<!<+>+", ">^>!<!<+>+", "<^<!<!<+>+", ">^<!<!<+>+",
	]


	static __New() {

	}

	static GetCurrentLayoutMap() {
		layout := Map()
		latinLayout := Cfg.Get("Layout_Latin")
		cyrillicLayout := Cfg.Get("Layout_Cyrillic")

		latinLayout := KeyboardBinder.layouts.latin.Has(latinLayout) ? latinLayout : "QWERTY"
		cyrillicLayout := KeyboardBinder.layouts.cyrillic.Has(cyrillicLayout) ? cyrillicLayout : "ЙЦУКЕН"

		latinLayout := KeyboardBinder.layouts.latin[latinLayout]
		cyrillicLayout := KeyboardBinder.layouts.cyrillic[cyrillicLayout]


		for key, scanCode in KeyboardBinder.layouts.winDefault {
			layout[scanCode] := [key]
		}

		for keySet in [latinLayout, cyrillicLayout] {
			for key, scanCode in keySet {
				if !layout.Has(scanCode) {
					layout[scanCode] := [key]
				} else {
					layout[scanCode].Push(key)
				}
			}
		}
		return layout
	}

	static Registration(bindingsArray := []) {
		bindings := this.FormatBindings(bindingsArray)
		processed := Map()


		for combo, value in bindings {
			if value.Length = 1 && Util.IsString(value[1]) {
				processed.Set(combo, (K) => BindHandler.Send(K, value[1]))
			} else if value.Length = 1 && Util.IsArray(value[1]) {
				processed.Set(combo, (K) => BindHandler.CapsSend(K, value[1]))
			} else if value.Length = 2 {
				processed.Set(combo, (K) => BindHandler.LangSend(K, {
					en: value[1],
					ru: value[2],
				}))
			} else if Util.IsFunc(value) {
				processed.Set(combo, value)
			} else {
				MsgBox("Invalid binding format for combo: " combo)
			}
		}

	}

	static FormatBindings(bindingsArray := []) {
		layout := this.GetCurrentLayoutMap()
		output := Map()

		if bindingsArray.Length > 0 {
			Loop bindingsArray.Length // 2 {
				index := A_Index * 2 - 1
				combo := bindingsArray[index]
				binds := bindingsArray[index + 1]


				for scanCode, keyNamesArray in layout {
					if RegExMatch(combo, "(?:\[(?<modKey>[a-zA-Zа-яА-ЯёЁ0-9]+)\]|(?<key>[a-zA-Zа-яА-ЯёЁ0-9]+))", &match) {
						keyLetter := match["modKey"] != "" ? match["modKey"] : match["key"]
						if keyNamesArray.HasValue(keyLetter) {
							interCombo := RegExReplace(combo, keyLetter, scanCode)
							interCombo := RegExReplace(interCombo, "\[(.*?)\]", "$1")
							if !output.Has(interCombo) {
								output.Set(interCombo, [binds])
							} else {
								output[interCombo].Push(binds)
							}
						}
					}
				}
			}
		}


		return output
	}


}

Class BindHandler {

	static Send(combo := "", characterNames*) {
		Keyboard.CheckLayout(&lang)
		if Language.Validate(lang, "bindings") {
			output := ""

			keysValidation := "SC(14B|148|14D|150|04A)"
			chrValidation := "(" Chr(0x00AE) ")"

			InputType := (RegExMatch(combo, keysValidation) || RegExMatch(output, chrValidation) || Cfg.Get("Input_Mode") != "Unicode") ? "Text" : "Input"

			Send%inputType%(output)
		}
	}

	static CapsSend(combo := "", charactersPair := [], reverse := False) {
		capsOn := reverse ? !GetKeyState("CapsLock", "T") : GetKeyState("CapsLock", "T")
		this.Send(combo, charactersPair[capsOn ? 1 : 0])
	}

	static LangSend(combo := "", charactersPair := {}, reverse := False) {
		Keyboard.CheckLayout(&lang)

		if Language.Validate(lang, "bindings") {
			if charactersPair.HasOwnProp(lang) {
				if Util.IsArray(charactersPair.%lang%) {
					this.CapsSend(combo, charactersPair.%lang%, reverse)
				} else {
					this.Send(combo, charactersPair)
				}
			}
		}
	}
}

defaultBinds := BindList([
	"NumpadSub", "minus",
	;"NumpadDiv", "division",
	;"NumpadMult", "multiplication",
], [
	"A", Map(
		"<^>!", ["lat_c_let_a__acute", "lat_s_let_a__acute"],
		"<^>!<!", ["lat_c_let_a__circumflex__acute", "lat_s_let_a__circumflex__acute"]
	),
	"Ф", Map("<^>!", ["lat_c_let_a__breve_acute", "lat_c_let_a__breve_acute"]),
])

; MsgBox(ChrLib.FormatEntry({ binds: KeyboardBinder.FormatBindings(defaultBinds.mapping) }))
; MsgBox(KeyboardBinder.FormatBindings(defaultBinds.mapping).Get("<^>!SC01E")[1].ToString() " — " KeyboardBinder.FormatBindings(defaultBinds.mapping).Get("<^>!SC01E")[2].ToString())
;MsgBox(KeyboardBinder.FormatBindings(defaultBinds.mapping).Get("<^>!SC01E").ToString())
;KeyboardBinder.Registration(defaultBinds)


; TODO Как-то реализовать сбор всех хоткеев, сравнивать скан-коды для биндов разных языков и собирать готовый HotKey() с валидным биндами на правильные скан-коды
;*	Сначала создать общую со всеми скан-кодами, затем, определяя текущий сканд-код, указанный в «key», добавлять в значения значение в созданной карте
;*	После сбора всех совпадения — регистрация HotKey с правильной функцией вставки символа в зависимости от языка
;*	Сначала карта заполняется сканд-кодами, а затем вставляются подходящие бинды и в конце регистрируется HotKey

;*	Совпадение в случае стандартной QWERTY/ЙЦУКЕН
;*	Латинская «T» с запятой — на букве T, а кириллическая «Ять» — на букве Е; (с AltGr)

;*	Map("SC014", Map("<^>!", {latin: ["lat_c_let_t_comma_below", "lat_s_let_t_comma_below"], cyrillic: ["cyr_c_let_yat", "cyr_s_let_yat"]}))
;*	=> HotKey("<^>!SC014", (K) => LangSeparatedKey(K, ["lat_c_let_a_breve", "lat_s_let_a_breve"], ["cyr_c_let_fita", "cyr_s_let_fita"], True), "On")

;*	Совпадение в случае Colemak/Диктор
;*	Тот же ска-код, но другие символы: «G» с краткой и „»“ кавычка; (с AltGr)

;*	Map("SC014", Map("<^>!", {latin: ["lat_c_let_g_breve", "lat_s_let_g_breve"], cyrillic: ["cyr_c_let_yat", "cyr_s_let_yat"]}))
;*	=> HotKey("<^>!SC014", (K) => LangSeparatedKey(K, ["lat_c_let_g_breve", "lat_s_let_g_breve"], "france_right", True), "On")

;*	Реализовать возможность создавать кастомные раскладки через создание .ini файлов в «Layouts\» директории
;*	[Setup]
;*	Title=Тестовая раскладка
;*	Type=Cyrillic
;*	[Keys]
;*	А=SC016
;*	Ф=SC02C
;*	...


justBindConcept := Map(
	;
	Map("modifier", "<^>!", "latin", { type: "caps", characters: ["lat_c_let_a_breve", "lat_s_let_a_breve"], key: "A" }),
	Map("modifier", "<^>!", "cyrllic", { type: "caps", characters: ["cyr_c_let_fita", "cyr_s_let_fita"], key: "Ф" }),
)