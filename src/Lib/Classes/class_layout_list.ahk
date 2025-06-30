Class LayoutList {
	static GetKeyCodes(keyNames*) {
		list := MapMerge(this.default, this.latin, this.cyrillic, this.hellenic)
		output := []

		isInt := keyNames[1] = "int"

		if isInt
			keyNames.RemoveAt(1)

		for k, v in list {
			if keyNames.HasValue(k)
				output.Push(isInt ? Number("0x" SubStr(v, 3)) : v)
		}

		return output
	}

	static default := Map(
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
		"Left", "SC14B",
		"Up", "SC148",
		"Right", "SC14D",
		"Down", "SC150",
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
	)
	static latin := Map(
		"Semicolon", "SC027",
		"Apostrophe", "SC028",
		"LeftBracket", "SC01A",
		"RightBracket", "SC01B",
		"Tilde", "SC029",
		"HyphenMinus", "SC00C",
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
		Chr(0x00DE), "SC99F", ; Thorn
		Chr(0x01F7), "SC99E", ; Wynn
		Chr(0xA768), "SC99D", ; Vend
		Chr(0x01B7), "SC99C", ; Ezh
		Chr(0x021C), "SC99B", ; Yogh
		Chr(0x1E9E), "SC99A", ; Eszett
		Chr(0x0194), "SC999", ; Gamma
	)
	static cyrillic := Map(
		"Ж", "SC027",
		"Э", "SC028",
		"Х", "SC01A",
		"Ъ", "SC01B",
		"Ё", "SC029",
		"ДефисоМинус", "SC00C",
		"Равно", "SC00D",
		"Б", "SC033",
		"Ю", "SC034",
		"Точка", "SC035",
		"ОбратныйСлэш", "SC02B",
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
		"Запятая", "SC90F",
		"Слэш", "SC90E",
		"Тильда", "SC90D",
		"Апостроф", "SC90C",
		"ТочкаСЗапятой", "SC90B",
		"ЛеваяКВСкобка", "SC90A",
		"ПраваяКВСкобка", "SC909",
		Chr(0x0406), "SC99F", ; Decimal I
		Chr(0x0462), "SC99E", ; Yat
		Chr(0x046A), "SC99D", ; Big Yus
		Chr(0x0466), "SC99C", ; Small Yus
		Chr(0x0470), "SC99B", ; Psi
		Chr(0x046E), "SC99A", ; Ksi
		Chr(0x0460), "SC999", ; Omega
		Chr(0x0472), "SC998", ; Fita
		Chr(0x051C), "SC997", ; We
		Chr(0x051A), "SC998", ; Qa
		Chr(0xA65E), "SC997", ; Yn
	)
	static hellenic := Map(
		"ΑνωΤελεια", "SC027",
		"Αποστροφη", "SC028",
		"ΑριστερηΑγκυλη", "SC01A",
		"ΔεξιαΑγκυλη", "SC01B",
		"Περισπωμενη", "SC029",
		"HyphenMinus", "SC00C",
		"Ισον", "SC00D",
		"Κομμα", "SC033",
		"Τελεια", "SC034",
		"Σολιδος", "SC035",
		"ΠισωΣολιδος", "SC02B",
		"Α", "SC01E",
		"Β", "SC030",
		"Ψ", "SC02E",
		"Δ", "SC020",
		"Ε", "SC012",
		"Φ", "SC021",
		"Γ", "SC022",
		"Η", "SC023",
		"Ι", "SC017",
		"Ξ", "SC024",
		"Κ", "SC025",
		"Λ", "SC026",
		"Μ", "SC032",
		"Ν", "SC031",
		"Ο", "SC018",
		"Π", "SC019",
		"Ϟ", "SC010",
		"Ρ", "SC013",
		"Σ", "SC01F",
		"Τ", "SC014",
		"Θ", "SC016",
		"Ω", "SC02F",
		"Ϝ", "SC011",
		"Χ", "SC02D",
		"Υ", "SC015",
		"Ζ", "SC02C",
	)
	layout := Map()

	__New(base, input := Map()) {
		this.layout := Map()

		for key, scanCode in LayoutList.default {
			this.layout.Set(key, scanCode)
		}

		for key, scanCode in LayoutList.%base% {
			this.layout.Set(key, scanCode)
		}

		if input.Count > 0 {
			for key, scanCode in input {
				for subKey, subScanCode in this.layout {
					if subScanCode = scanCode {
						this.layout.Delete(subKey)
					}
				}
				this.layout.Set(key, scanCode)
			}
		}

		return this
	}
}