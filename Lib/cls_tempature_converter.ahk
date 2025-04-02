Class TemperatureConversion {
	#Requires Autohotkey v2.0+

	static scales := {
		C: [GetChar("celsius"), GetChar("degree") "C"],
		F: [GetChar("fahrenheit"), GetChar("degree") "F"],
		K: [GetChar("kelvin"), "K"],
		RA: "R",
		N: "N",
		D: "D",
		H: "H",
		L: "L",
		W: "W",
		ME: "Me",
		RO: "R" GetChar("lat_s_let_o_solidus_long"),
		RE: "R" GetChar("lat_s_let_e_acute"),
	}

	static typographyTypes := Map(
		"Deutsch", [".,", (T) => RegExReplace(T, "\.,", ".")],
		"Canada", ["..", (T) => RegExReplace(T, "\.\.", ".")],
		"Switzerland-Comma", ["''", (T) => RegExReplace(T, "\'\'", ".")],
		"Switzerland-Dot", ["'", (T) => RegExReplace(T, "\'", ".")],
		"Russian", [",", (T) => RegExReplace(T, ",", ".")],
	)

	static __New() {
		this.RegistryHotstrings()
	}

	static RegistryHotstrings() {
		hsKeys := [
			'cd', 'cf', 'ck', 'cn', 'cra', "cl", "cw", "cro", "cre", 'ch', ; Celsius
			'fc', 'fd', 'fk', 'fn', 'fra', 'fl', 'fw', 'fro', 'fre', ; Fahrenheit
			'kc', 'kd', 'kf', 'kn', 'kra', 'kl', 'kw', 'kro', 'kre', ; Kelvin
			'nc', 'nd', 'nf', 'nk', 'nra', 'nl', 'nw', 'nro', 'nre', ; Newton
			'rac', 'rad', 'raf', 'rak', 'ran', 'ral', 'raw', 'raro', 'rare', ; Rankine
			'dc', 'df', 'dk', 'dn', 'dra', 'dl', 'dw', 'dro', 'dre', ; Delisle
			'lc', 'lf', 'lk', 'ln', 'lra', 'ld', 'lw', 'lro', 'lre', ; Leiden
			'wc', 'wf', 'wk', 'wn', 'wra', 'wd', 'wl', 'wro', 'wre', ; Wedgwood
			'roc', 'rof', 'rok', 'ron', 'rora', 'rod', 'rol', 'row', 'rore', ; Romer
			'rec', 'ref', 'rek', 'ren', 'rera', 'red', 'rel', 'rew', 'rero', ; Reaumur
			'hc', ; Hooke
			'mec', 'cme', 'mek', 'kme', ; Special Custom, Mercuric
		]

		callback := ObjBindMethod(this, 'Converter')

		for hsKey in hsKeys {
			HotString(":C?0:ct" hsKey, callback)
		}
	}

	static Converter(conversionType) {
		hwnd := WinActive('A')

		conversionFromTo := RegExReplace(conversionType, "^.*t", "")

		labelFrom := (RegExMatch(conversionFromTo, "^(ra|ro|re|me)")) ? SubStr(conversionFromTo, 1, 2) : SubStr(conversionFromTo, 1, 1)
		labelTo := (RegExMatch(conversionFromTo, "(ra|ro|re|me)$")) ? SubStr(conversionFromTo, -2) : SubStr(conversionFromTo, -1, 1)


		conversionLabel := "[" (IsObject(this.scales.%labelFrom%) ? this.scales.%labelFrom%[2] : GetChar("degree") this.scales.%labelFrom%) " " GetChar("arrow_right") " " (IsObject(this.scales.%labelTo%) ? this.scales.%labelTo%[2] : GetChar("degree") this.scales.%labelTo%) "]"

		CaretTooltip(conversionLabel)
		numberValue := this.GetNumber(conversionLabel)

		try {
			regionalType := "English"
			for region, value in this.typographyTypes {
				if InStr(numberValue, value[1]) {
					numberValue := value[2](numberValue)
					regionalType := region
					break
				}
			}

			numberValue := %conversionFromTo%(StrReplace(numberValue, GetChar("minus"), "-"))

			(SubStr(numberValue, 1, 1) = "-") ? (numberValue := SubStr(numberValue, 2), negativePoint := True) : (negativePoint := False)

			temperatureValue := this.PostFormatting(numberValue, labelTo, negativePoint, regionalType)

			if !WinActive('ahk_id ' hwnd) {
				WinActivate('ahk_id ' hwnd)
				WinWaitActive(hwnd)
			}

			SendText(temperatureValue)
		} catch {
			SendText(RegExReplace(conversionType, "^.*?:.*?:", ""))
		}
		return

		; Celsius
		CF(G) => (G * 9 / 5) + 32
		CK(G) => G + 273.15
		CRA(G) => (G + 273.15) * 1.8
		CN(G) => G * 33 / 100
		CD(G) => (100 - G) * 3 / 2
		CH(G) => G * 5 / 12
		CL(G) => G + 253
		CW(G) => (G / 24.857191) - 10.821818
		CRO(G) => (G / 1.904762) + 7.5
		CRE(G) => G / 1.25

		; Fahrenheit
		FC(G) => (G - 32) * 5 / 9
		FK(G) => (G - 32) * 5 / 9 + 273.15
		FRA(G) => G + 459.67
		FN(G) => (G - 32) * 11 / 60
		FD(G) => (212 - G) * 5 / 6
		FL(G) => (G / 1.8) + 235.222222
		FW(G) => (G / 44.742943) - 11.537015
		FRO(G) => (G / 3.428571) - 1.833333
		FRE(G) => (G / 2.25) - 14.222222

		; Kelvin
		KC(G) => G - 273.15
		KF(G) => (G - 273.15) * 9 / 5 + 32
		KRA(G) => G * 1.8
		KN(G) => (G - 273.15) * 33 / 100
		KD(G) => (373.15 - G) * 3 / 2
		KL(G) => G - 20.15
		KW(G) => (G / 24.857191) - 21.81059
		KRO(G) => (G / 1.904762) - 135.90375
		KRE(G) => (G / 1.25) - 218.52

		; Rankine
		RAC(G) => (G / 1.8) - 273.15
		RAF(G) => G - 459.67
		RAK(G) => G / 1.8
		RAN(G) => (G / 1.8 - 273.15) * 33 / 100
		RAD(G) => (671.67 - G) * 5 / 6
		RAL(G) => (G / 1.8) - 20.15
		RAW(G) => (G / 44.742943) - 21.81059
		RARO(G) => (G / 3.428571) - 135.90375
		RARE(G) => (G / 2.25) - 218.52

		; Newton
		NC(G) => G * 100 / 33
		NF(G) => (G * 60 / 11) + 32
		NK(G) => (G * 100 / 33) + 273.15
		NRA(G) => (G * 100 / 33 + 273.15) * 1.8
		ND(G) => (33 - G) * 50 / 11
		NL(G) => (3.030303 * G) + 253
		NW(G) => (G / 8.202873) - 10.821818
		NRO(G) => (1.590909 * G) + 7.5
		NRE(G) => 2.424242 * G

		; Delisle
		DC(G) => 100 - (G * 2 / 3)
		DF(G) => 212 - (G * 6 / 5)
		DK(G) => 373.15 - (G * 2 / 3)
		DRA(G) => 671.67 - (G * 6 / 5)
		DN(G) => 33 - (G * 11 / 50)
		DL(G) => (-G / 1.5) + 353
		DW(G) => (-G / 37.285786) - 6.798838
		DRO(G) => (-G / 2.857143) + 60
		DRE(G) => (-G / 1.875) + 80

		; Hooke
		HC(G) => (G * 12 / 5)

		; Leiden
		LC(G) => G - 253
		LF(G) => (1.8 * G) - 423.4
		LK(G) => G + 20.15
		LRA(G) => (1.8 * G) + 36.27
		LN(G) => (G / 3.030303) - 83.49
		LD(G) => (-1.5 * G) + 529.5
		LW(G) => (G / 24.857191) - 21
		LRO(G) => (G / 1.904762) - 125.325
		LRE(G) => (G / 1.25) - 202.4

		; Wedgwood
		WC(G) => (24.857191 * G) + 269
		WF(G) => (44.742943 * G) + 516.2
		WK(G) => (24.857191 * G) + 542.15
		WRA(G) => (44.742943 * G) + 975.87
		WD(G) => (-37.285786 * G) - 253.5
		WN(G) => (8.202873 * G) + 88.77
		WL(G) => (24.857191 * G) + 522
		WRO(G) => (13.050025 * G) + 148.725
		WRE(G) => (19.885753 * G) + 215.2

		; Romer
		ROC(G) => (1.904762 * G) - 14.285714
		ROF(G) => (3.428571 * G) + 6.285714
		ROK(G) => (1.904762 * G) + 258.864286
		RORA(G) => (3.428571 * G) + 465.955714
		RON(G) => (G / 1.590909) - 4.714286
		ROD(G) => (-2.857143 * G) + 171.428571
		ROL(G) => (1.904762 * G) + 238.7142861
		ROW(G) => (G / 13.050025) - 11.39653
		RORE(G) => (1.52381 * G) - 11.428571

		; Reaumur
		REC(G) => 1.25 * G
		REF(G) => (2.25 * G) + 32
		REK(G) => (1.25 * G) + 273.15
		RERA(G) => (2.25 * G) + 491.67
		REN(G) => G / 2.424242
		RED(G) => (-1.875 * G) + 150
		REL(G) => (1.25 * G) + 253
		REW(G) => (G / 19.885753) - 10.821818
		RERO(G) => (G / 1.52381) + 7.5

		; Special Custom, Mercuric
		MEC(G) => (G / 100) * 395.56 - 38.83
		MEK(G) => (G / 100) * 395.56 + 234.32
		CME(G) => (G + 38.83) * 100 / 395.56
		KME(G) => (G - 234.32) * 100 / 395.56
	}
	static GetNumber(conversionLabel) {
		static validator := "v1234567890,.-'" GetChar("minus")
		static expression := "^[1234567890,.'\- " GetChar("minus") "]+$"

		numberValue := ""

		PH := InputHook("L0", "{Escape}")
		PH.Start()

		Loop {
			IH := InputHook("L1", "{Escape}{Backspace}{Insert}")
			IH.Start(), IH.Wait()

			if (IH.EndKey = "Escape") {
				numberValue := ""
				break
			} else if (IH.EndKey = "Backspace") {
				if StrLen(numberValue) > 0
					numberValue := SubStr(numberValue, 1, -1)
			} else if (IH.EndKey = "Insert") {
				ClipWait(0.5, 1)
				if RegExMatch(A_Clipboard, expression) {
					numberValue .= A_Clipboard
				}
			} else if InStr(validator, IH.Input) {
				numberValue .= IH.Input
			} else break

			CaretTooltip(conversionLabel " " numberValue)
		}

		ToolTip()

		PH.Stop()

		return numberValue
	}

	static PostFormatting(temperatureValue, scale, negativePoint := False, regionalType := "English") {
		chars := {
			numberSpace: GetChar(Cfg.Get("Num_Space_Type", "TemperatureCalc", "thinspace")),
			degreeSpace: GetChar(Cfg.Get("Deg_Space_Type", "TemperatureCalc", "narrow_no_break_space")),
		}

		useUnicode := Cfg.Get("Dedicated_Unicode_Chars", "TemperatureCalc", True)
		extendedFormatOn := Cfg.Get("Format_Extended", "TemperatureCalc", True)
		formatMinAt := Integer(Cfg.Get("Format_Min_At", "TemperatureCalc", 5))
		roundValueTo := Integer(Cfg.Get("Round_Value_To", "TemperatureCalc", 2))

		if !(GetKeyState("CapsLock", "T"))
			temperatureValue := Round(temperatureValue, Integer(roundValueTo))

		if (Mod(temperatureValue, 1) = 0)
			temperatureValue := Round(temperatureValue)

		if (regionalType = "Russian" || regionalType = "Deutsch" || regionalType = "Switzerland-Comma")
			temperatureValue := RegExReplace(temperatureValue, "\.", ",")

		integerPart := RegExReplace(temperatureValue, "(\..*)|([,].*)", "")

		if (extendedFormatOn && StrLen(integerPart) >= formatMinAt) {
			decimalSeparators := Map(
				"English", ",",
				"Deutsch", ".",
				"Russian", chars.numberSpace,
				"Canada", chars.numberSpace,
				"Switzerland-Comma", GetChar("quote_right_single"),
				"Switzerland-Dot", GetChar("quote_right_single"),
			)

			integerPart := RegExReplace(integerPart, "\B(?=(\d{3})+(?!\d))", decimalSeparators[regionalType])
			temperatureValue := RegExReplace(temperatureValue, "^\d+", integerPart)
		}

		temperatureValue := (negativePoint ? GetChar("minus") : "") temperatureValue chars.degreeSpace (IsObject(this.scales.%scale%) ? (useUnicode ? this.scales.%scale%[1] : this.scales.%scale%[2]) : GetChar("degree") this.scales.%scale%)
		return temperatureValue
	}
}