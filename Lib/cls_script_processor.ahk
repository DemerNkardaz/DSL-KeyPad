Class InputScriptProcessor {

	static options := {
		interceptionInputMode: "",
	}


	static locLib := {
		lat: {
			c: {
				a_acu: GetChar("lat_c_let_a_acute"),
				a_bre: GetChar("lat_c_let_a_breve"),
				a_bre_acu: GetChar("lat_c_let_a_breve_acute"),
				a_bre_gra: GetChar("lat_c_let_a_breve_grave"),
				a_bre_til: GetChar("lat_c_let_a_breve_tilde"),
				a_bre_dot_bel: GetChar("lat_c_let_a_breve_dot_below"),
				a_bre_hoo_abo: GetChar("lat_c_let_a_breve_hook_above"),
				a_cir: GetChar("lat_c_let_a_circumflex"),
				a_cir_acu: GetChar("lat_c_let_a_circumflex_acute"),
				a_cir_gra: GetChar("lat_c_let_a_circumflex_grave"),
				a_cir_til: GetChar("lat_c_let_a_circumflex_tilde"),
				a_cir_dot_bel: GetChar("lat_c_let_a_circumflex_dot_below"),
				a_cir_hoo_abo: GetChar("lat_c_let_a_circumflex_hook_above"),
				a_gra: GetChar("lat_c_let_a_grave"),
				a_til: GetChar("lat_c_let_a_tilde"),
				a_dot_bel: GetChar("lat_c_let_a_dot_below"),
				a_hoo_abo: GetChar("lat_c_let_a_hook_above"),
				;
				b_sto: GetChar("lat_c_let_b_stroke_short"),
				;
				d_sto: GetChar("lat_c_let_d_stroke_short"),
				;
				e_acu: GetChar("lat_c_let_e_acute"),
				e_bre: GetChar("lat_c_let_e_breve"),
				e_bre_acu: GetChar("lat_c_let_e_breve_acute"),
				e_bre_gra: GetChar("lat_c_let_e_breve_grave"),
				e_bre_til: GetChar("lat_c_let_e_breve_tilde"),
				e_bre_dot_bel: GetChar("lat_c_let_e_breve_dot_below"),
				e_bre_hoo_abo: GetChar("lat_c_let_e_breve_hook_above"),
				e_cir: GetChar("lat_c_let_e_circumflex"),
				e_cir_acu: GetChar("lat_c_let_e_circumflex_acute"),
				e_cir_gra: GetChar("lat_c_let_e_circumflex_grave"),
				e_cir_til: GetChar("lat_c_let_e_circumflex_tilde"),
				e_cir_dot_bel: GetChar("lat_c_let_e_circumflex_dot_below"),
				e_cir_hoo_abo: GetChar("lat_c_let_e_circumflex_hook_above"),
				e_gra: GetChar("lat_c_let_e_grave"),
				e_til: GetChar("lat_c_let_e_tilde"),
				e_dot_bel: GetChar("lat_c_let_e_dot_below"),
				e_hoo_abo: GetChar("lat_c_let_e_hook_above"),
			},
			s: {
				a_acu: GetChar("lat_s_let_a_acute"),
				a_bre: GetChar("lat_s_let_a_breve"),
				a_bre_acu: GetChar("lat_s_let_a_breve_acute"),
				a_bre_gra: GetChar("lat_s_let_a_breve_grave"),
				a_bre_til: GetChar("lat_s_let_a_breve_tilde"),
				a_bre_dot_bel: GetChar("lat_s_let_a_breve_dot_below"),
				a_bre_hoo_abo: GetChar("lat_s_let_a_breve_hook_above"),
				a_cir: GetChar("lat_s_let_a_circumflex"),
				a_cir_acu: GetChar("lat_s_let_a_circumflex_acute"),
				a_cir_gra: GetChar("lat_s_let_a_circumflex_grave"),
				a_cir_til: GetChar("lat_s_let_a_circumflex_tilde"),
				a_cir_dot_bel: GetChar("lat_s_let_a_circumflex_dot_below"),
				a_cir_hoo_abo: GetChar("lat_s_let_a_circumflex_hook_above"),
				a_gra: GetChar("lat_s_let_a_grave"),
				a_til: GetChar("lat_s_let_a_tilde"),
				a_dot_bel: GetChar("lat_s_let_a_dot_below"),
				a_hoo_abo: GetChar("lat_s_let_a_hook_above"),
				;
				b_sto: GetChar("lat_s_let_b_stroke_short"),
				;
				d_sto: GetChar("lat_s_let_d_stroke_short"),
				;
				e_acu: GetChar("lat_s_let_e_acute"),
				e_bre: GetChar("lat_s_let_e_breve"),
				e_bre_acu: GetChar("lat_s_let_e_breve_acute"),
				e_bre_gra: GetChar("lat_s_let_e_breve_grave"),
				e_bre_til: GetChar("lat_s_let_e_breve_tilde"),
				e_bre_dot_bel: GetChar("lat_s_let_e_breve_dot_below"),
				e_bre_hoo_abo: GetChar("lat_s_let_e_breve_hook_above"),
				e_cir: GetChar("lat_s_let_e_circumflex"),
				e_cir_acu: GetChar("lat_s_let_e_circumflex_acute"),
				e_cir_gra: GetChar("lat_s_let_e_circumflex_grave"),
				e_cir_til: GetChar("lat_s_let_e_circumflex_tilde"),
				e_cir_dot_bel: GetChar("lat_s_let_e_circumflex_dot_below"),
				e_cir_hoo_abo: GetChar("lat_s_let_e_circumflex_hook_above"),
				e_gra: GetChar("lat_s_let_e_grave"),
				e_til: GetChar("lat_s_let_e_tilde"),
				e_dot_bel: GetChar("lat_s_let_e_dot_below"),
				e_hoo_abo: GetChar("lat_s_let_e_hook_above"),
			},
		},
	}

	static autoDiacritics := Map()

	static generateSequences(libLink, ending?, replaceWith?) {
		output := Map()
		if IsObject(libLink) {
			tempArray := []
			for i, key in libLink {
				if Mod(i, 3) = 1 {
					link := libLink[i]
					ending := libLink[i + 1]
					replaceWith := libLink[i + 2]

					output := MapMerge(output, this.generateSequences(link, ending, replaceWith))
				}
			}

		} else {
			RegExMatch(libLink, "^(.*?):(.*?)(?:\[(.*?)\])?$", &match)

			category := match[1]
			libChar := match[2]
			inputVariations := match[3] = "" ? [""] : StrSplit(match[3], ", ")

			if IsObject(ending[1]) {
				deployedArray := []
				pairs := []

				for i, endingEntry in ending {
					for j, variation in inputVariations {
						if i = j {
							pairs.Push(endingEntry, variation)
						}
					}
				}

				for i, pair in pairs {
					if Mod(i, 2) == 1 {
						pairEnding := pairs[i]
						pairVariation := pairs[i + 1]


						refinedLibLink := RegExReplace(libLink, pairVariation ",?\s?", "")
						refinedLibLink := StrReplace(refinedLibLink, ", ]", "]")

						deployedArray.Push(refinedLibLink, pairEnding, (InStr(replaceWith, "[*]") ? StrReplace(replaceWith, "[*]", "_" pairVariation) : replaceWith))
					}
				}

				return this.generateSequences(deployedArray)
			} else {

				for variation in inputVariations {
					sequenceIn := [this.locLib.%category%.s.%libChar%_%variation%, this.locLib.%category%.c.%libChar%_%variation%]

					if !IsObject(replaceWith) {
						variationsReplace := (InStr(replaceWith, "[*]") ? StrReplace(replaceWith, "[*]", "_" variation) : replaceWith)
						sequenceOut := [this.locLib.%category%.s.%variationsReplace%, this.locLib.%category%.c.%variationsReplace%]
					} else {
						sequenceOut := replaceWith
					}

					setSequences(sequenceIn, ending, sequenceOut)
				}
			}

		}

		setSequences(seqIn, seqEnd, seqOut) {
			output.Set(
				seqIn[1] seqEnd[1], seqOut[1],
				seqIn[2] seqEnd[2], seqOut[2],
				seqIn[1] "\" seqEnd[1], seqOut[1],
				seqIn[2] "\" seqEnd[2], seqOut[2],
			)
		}

		return output
	}

	static scriptSequences := {
		vietNam: Map(
			"Advanced", MapMerge(
				this.generateSequences([
					"lat:a[bre, cir]", [["w", "W"], ["a", "A"]], "a[*]",
					"lat:a[cir, bre, acu, gra, til, hoo_abo, dot_bel]", ["z", "Z"], ["a", "A"],
					"lat:a[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "a[*]",
					;
					"lat:a_bre[acu, gra, til, dot_bel, hoo_abo]", ["z", "Z"], "a_bre",
					"lat:a_bre[acu, gra, til, dot_bel, hoo_abo]", ["a", "A"], "a_cir[*]",
					"lat:a_bre[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "a_bre[*]",
					;
					"lat:a_cir[acu, gra, til, dot_bel, hoo_abo]", ["z", "Z"], "a_cir",
					"lat:a_cir[acu, gra, til, dot_bel, hoo_abo]", ["w", "W"], "a_bre[*]",
					"lat:a_cir[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "a_cir[*]",
					;
					"lat:e[bre, cir]", [["w", "W"], ["e", "E"]], "e[*]",
					"lat:e[cir, bre, acu, gra, til, hoo_abo, dot_bel]", ["z", "Z"], ["e", "E"],
					"lat:e[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "e[*]",
					;
					"lat:e_cir[acu, gra, til, dot_bel, hoo_abo]", ["z", "Z"], "e_cir",
					"lat:e_cir[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "e_cir[*]",
				]),
				Map(
					;* Advanced A
				),
			),
			"Default", Map(
				;
				"aa", this.locLib.lat.s.a_cir,
				"AA", this.locLib.lat.c.a_cir,
				"af", this.locLib.lat.s.a_gra,
				"AF", this.locLib.lat.c.a_gra,
				"as", this.locLib.lat.s.a_acu,
				"AS", this.locLib.lat.c.a_acu,
				"aw", this.locLib.lat.s.a_bre,
				"AW", this.locLib.lat.c.a_bre,
				"ax", this.locLib.lat.s.a_til,
				"AX", this.locLib.lat.c.a_til,
				"aj", this.locLib.lat.s.a_dot_bel,
				"AJ", this.locLib.lat.c.a_dot_bel,
				"ar", this.locLib.lat.s.a_hoo_abo,
				"AR", this.locLib.lat.c.a_hoo_abo,
				;
				"a1", this.locLib.lat.s.a_cir_acu,
				"A1", this.locLib.lat.c.a_cir_acu,
				"a2", this.locLib.lat.s.a_cir_gra,
				"A2", this.locLib.lat.c.a_cir_gra,
				"a3", this.locLib.lat.s.a_cir_hoo_abo,
				"A3", this.locLib.lat.c.a_cir_hoo_abo,
				"a4", this.locLib.lat.s.a_cir_dot_bel,
				"A4", this.locLib.lat.c.a_cir_dot_bel,
				"a5", this.locLib.lat.s.a_cir_til,
				"A5", this.locLib.lat.c.a_cir_til,
				;
				"q1", this.locLib.lat.s.a_bre_acu,
				"Q1", this.locLib.lat.c.a_bre_acu,
				"q2", this.locLib.lat.s.a_bre_gra,
				"Q2", this.locLib.lat.c.a_bre_gra,
				"q3", this.locLib.lat.s.a_bre_hoo_abo,
				"Q3", this.locLib.lat.c.a_bre_hoo_abo,
				"q4", this.locLib.lat.s.a_bre_dot_bel,
				"Q4", this.locLib.lat.c.a_bre_dot_bel,
				"q5", this.locLib.lat.s.a_bre_til,
				"Q5", this.locLib.lat.c.a_bre_til,
				;
				"dd", Chr(0x0111),
				"DD", Chr(0x0110),
				;
				"ee", Chr(0x00EA),
				"EE", Chr(0x00CA),
				"ef", Chr(0x00E8),
				"EF", Chr(0x00C8),
				"es", Chr(0x00E9),
				"ES", Chr(0x00C9),
				"ex", Chr(0x1EBD),
				"EX", Chr(0x1EBC),
				"ej", Chr(0x1EB9),
				"EJ", Chr(0x1EB8),
				"er", Chr(0x1EBB),
				"ER", Chr(0x1EBA),
				;
				;Chr(0x00EA) "s", Chr(0x1EBF),
				;Chr(0x00CA) "S", Chr(0x1EBE),
				;Chr(0x00EA) "f", Chr(0x1EC1),
				;Chr(0x00CA) "F", Chr(0x1EC0),
				;Chr(0x00EA) "r", Chr(0x1EC3),
				;Chr(0x00CA) "R", Chr(0x1EC2),
				;Chr(0x00EA) "j", Chr(0x1EC7),
				;Chr(0x00CA) "J", Chr(0x1EC6),
				;Chr(0x00EA) "x", Chr(0x1EC5),
				;Chr(0x00CA) "X", Chr(0x1EC4),
				;
				"e1", Chr(0x1EBF),
				"E1", Chr(0x1EBE),
				"e2", Chr(0x1EC1),
				"E2", Chr(0x1EC0),
				"e3", Chr(0x1EC3),
				"E3", Chr(0x1EC2),
				"e4", Chr(0x1EC7),
				"E4", Chr(0x1EC6),
				"e5", Chr(0x1EC5),
				"E5", Chr(0x1EC4),
				;
				"if", Chr(0x00EC),
				"IF", Chr(0x00CC),
				"is", Chr(0x00ED),
				"IS", Chr(0x00CD),
				"ix", Chr(0x0129),
				"IX", Chr(0x0128),
				"ij", Chr(0x1ECB),
				"IJ", Chr(0x1ECA),
				"ir", Chr(0x1EC9),
				"IR", Chr(0x1EC8),
				;
				"oo", Chr(0x00F4),
				"OO", Chr(0x00D4),
				"of", Chr(0x00F2),
				"OF", Chr(0x00D2),
				"os", Chr(0x00F3),
				"OS", Chr(0x00D3),
				"ow", Chr(0x01A1),
				"OW", Chr(0x01A0),
				"ox", Chr(0x00F5),
				"OX", Chr(0x00D5),
				"oj", Chr(0x1ECD),
				"OJ", Chr(0x1ECC),
				"or", Chr(0x1ECF),
				"OR", Chr(0x1ECE),
				;
				Chr(0x00F4) "s", Chr(0x1ED1),
				Chr(0x00D4) "S", Chr(0x1ED0),
				Chr(0x00F4) "f", Chr(0x1ED3),
				Chr(0x00D4) "F", Chr(0x1ED2),
				Chr(0x00F4) "r", Chr(0x1ED5),
				Chr(0x00D4) "R", Chr(0x1ED4),
				Chr(0x00F4) "j", Chr(0x1ED9),
				Chr(0x00D4) "J", Chr(0x1ED8),
				Chr(0x00F4) "x", Chr(0x1ED7),
				Chr(0x00D4) "X", Chr(0x1ED6),
				;
				Chr(0x01A1) "s", Chr(0x1EDB),
				Chr(0x01A0) "S", Chr(0x1EDA),
				Chr(0x01A1) "f", Chr(0x1EDD),
				Chr(0x01A0) "F", Chr(0x1EDC),
				Chr(0x01A1) "r", Chr(0x1EDF),
				Chr(0x01A0) "R", Chr(0x1EDE),
				Chr(0x01A1) "j", Chr(0x1EE3),
				Chr(0x01A0) "J", Chr(0x1EE2),
				Chr(0x01A1) "x", Chr(0x1EE1),
				Chr(0x01A0) "X", Chr(0x1EE0),
				;
				"o1", Chr(0x1ED1),
				"O1", Chr(0x1ED0),
				"o2", Chr(0x1ED3),
				"O2", Chr(0x1ED2),
				"o3", Chr(0x1ED5),
				"O3", Chr(0x1ED4),
				"o4", Chr(0x1ED9),
				"O4", Chr(0x1ED8),
				"o5", Chr(0x1ED7),
				"O5", Chr(0x1ED6),
				;
				"p1", Chr(0x1EDB),
				"P1", Chr(0x1EDA),
				"p2", Chr(0x1EDD),
				"P2", Chr(0x1EDC),
				"p3", Chr(0x1EDF),
				"P3", Chr(0x1EDE),
				"p4", Chr(0x1EE3),
				"P4", Chr(0x1EE2),
				"p5", Chr(0x1EE1),
				"P5", Chr(0x1EE0),
				;
				"uf", Chr(0x00F9),
				"UF", Chr(0x00D9),
				"us", Chr(0x00FA),
				"US", Chr(0x00DA),
				"uw", Chr(0x01B0),
				"UW", Chr(0x01AF),
				"ux", Chr(0x0169),
				"UX", Chr(0x0168),
				"uj", Chr(0x1EE5),
				"UJ", Chr(0x1EE4),
				"ur", Chr(0x1EE7),
				"UR", Chr(0x1EE6),
				;
				Chr(0x01B0) "s", Chr(0x1EE9),
				Chr(0x01AF) "S", Chr(0x1EE8),
				Chr(0x01B0) "f", Chr(0x1EEB),
				Chr(0x01AF) "F", Chr(0x1EEA),
				Chr(0x01B0) "r", Chr(0x1EED),
				Chr(0x01AF) "R", Chr(0x1EEC),
				Chr(0x01B0) "j", Chr(0x1EF1),
				Chr(0x01AF) "J", Chr(0x1EF0),
				Chr(0x01B0) "x", Chr(0x1EEF),
				Chr(0x01AF) "X", Chr(0x1EEE),
				;
				"u1", Chr(0x1EE9),
				"U1", Chr(0x1EE8),
				"u2", Chr(0x1EEB),
				"U2", Chr(0x1EEA),
				"u3", Chr(0x1EED),
				"U3", Chr(0x1EEC),
				"u4", Chr(0x1EF1),
				"U4", Chr(0x1EF0),
				"u5", Chr(0x1EEF),
				"U5", Chr(0x1EEE),
				;
				"yf", Chr(0x1EF3),
				"YF", Chr(0x1EF2),
				"ys", Chr(0x00FD),
				"YS", Chr(0x00DD),
				"yx", Chr(0x1EF9),
				"YX", Chr(0x1EF8),
				"yj", Chr(0x1EF5),
				"YJ", Chr(0x1EF4),
				"yr", Chr(0x1EF7),
				"YR", Chr(0x1EF6),
				;*
				;* Gia-Rai (Jarai) Extensions
				;*
				"cz", Chr(0x010D),
				"CZ", Chr(0x010C),
				;
				"bb", Chr(0x0180),
				"BB", Chr(0x0243),
				;
				"ew", Chr(0x0115),
				"EW", Chr(0x0114),
				"ez", Chr(0x011B),
				"EZ", Chr(0x011A),
				;
				"iw", Chr(0x012D),
				"IW", Chr(0x012C),
				;
				"nn", Chr(0x00F1),
				"NN", Chr(0x00D1),
				;
				"oq", Chr(0x014F),
				"OQ", Chr(0x014E),
				"oz", Chr(0x01D2),
				"OZ", Chr(0x01D1),
				"o8", Chr(0x00F6),
				"O8", Chr(0x00D6),
				;
				"uq", Chr(0x016D),
				"UQ", Chr(0x016C),
				"u8", Chr(0x00FC),
				"U8", Chr(0x00DC),
				;
				"uow", Chrs(0x01B0, 0x01A1),
				"UOW", Chrs(0x01AF, 0x01A0),
				"Uow", Chrs(0x01AF, 0x01A1),
				;
				"uocw", Chrs(0x01B0, 0x00F4) "c",
				"UOCW", Chrs(0x01AF, 0x00D4) "C",
				"Uocw", Chrs(0x01AF, 0x00F4) "c",
				;
				Chrs(0x01B0, 0x00F4) "cs", Chrs(0x01B0, 0x1ED1) "c",
				Chrs(0x01AF, 0x00D4) "CS", Chrs(0x01AF, 0x1ED0) "C",
				Chrs(0x01AF, 0x00F4) "cs", Chrs(0x01AF, 0x1ED1) "c",
				;
				Chrs(0x01B0, 0x00F4) "cf", Chrs(0x01B0, 0x1ED3) "c",
				Chrs(0x01AF, 0x00D4) "CF", Chrs(0x01AF, 0x1ED2) "C",
				Chrs(0x01AF, 0x00F4) "cs", Chrs(0x01AF, 0x1ED3) "c",
				;
				Chrs(0x01B0, 0x00F4) "cr", Chrs(0x01B0, 0x1ED5) "c",
				Chrs(0x01AF, 0x00D4) "CR", Chrs(0x01AF, 0x1ED4) "C",
				Chrs(0x01AF, 0x00F4) "cs", Chrs(0x01AF, 0x1ED5) "c",
				;
				Chrs(0x01B0, 0x00F4) "cj", Chrs(0x01B0, 0x1ED9) "c",
				Chrs(0x01AF, 0x00D4) "CJ", Chrs(0x01AF, 0x1ED8) "C",
				Chrs(0x01AF, 0x00F4) "cs", Chrs(0x01AF, 0x1ED9) "c",
				;
				Chrs(0x01B0, 0x00F4) "cx", Chrs(0x01B0, 0x1ED7) "c",
				Chrs(0x01AF, 0x00D4) "CX", Chrs(0x01AF, 0x1ED6) "C",
				Chrs(0x01AF, 0x00F4) "cs", Chrs(0x01AF, 0x1ED7) "c",
				;
				"uoc1", Chrs(0x01B0, 0x1ED1) "c",
				"UOC1", Chrs(0x01AF, 0x1ED0) "C",
				"Uoc1", Chrs(0x01AF, 0x1ED1) "c",
				;
				"uoc2", Chrs(0x01B0, 0x1ED3) "c",
				"UOC2", Chrs(0x01AF, 0x1ED2) "C",
				"Uoc2", Chrs(0x01AF, 0x1ED3) "c",
				;
				"uoc3", Chrs(0x01B0, 0x1ED5) "c",
				"UOC3", Chrs(0x01AF, 0x1ED4) "C",
				"Uoc3", Chrs(0x01AF, 0x1ED5) "c",
				;
				"uoc4", Chrs(0x01B0, 0x1ED9) "c",
				"UOC4", Chrs(0x01AF, 0x1ED8) "C",
				"Uoc4", Chrs(0x01AF, 0x1ED9) "c",
				;
				"uoc5", Chrs(0x01B0, 0x1ED7) "c",
				"UOC5", Chrs(0x01AF, 0x1ED6) "C",
				"Uoc5", Chrs(0x01AF, 0x1ED7) "c",
				;
				;
				"upcw", Chrs(0x01B0, 0x01A1) "c",
				"UPCW", Chrs(0x01AF, 0x01A0) "C",
				"Upcw", Chrs(0x01AF, 0x01A1) "c",
				;
				Chrs(0x01B0, 0x01A1) "cs", Chrs(0x01B0, 0x1EDB) "c",
				Chrs(0x01AF, 0x01A0) "CS", Chrs(0x01AF, 0x1EDA) "C",
				Chrs(0x01AF, 0x01A1) "cs", Chrs(0x01AF, 0x1EDB) "c",
				;
				Chrs(0x01B0, 0x01A1) "cf", Chrs(0x01B0, 0x1EDD) "c",
				Chrs(0x01AF, 0x01A0) "CF", Chrs(0x01AF, 0x1EDC) "C",
				Chrs(0x01AF, 0x01A1) "cs", Chrs(0x01AF, 0x1EDD) "c",
				;
				Chrs(0x01B0, 0x01A1) "cr", Chrs(0x01B0, 0x1EDF) "c",
				Chrs(0x01AF, 0x01A0) "CR", Chrs(0x01AF, 0x1EDE) "C",
				Chrs(0x01AF, 0x01A1) "cs", Chrs(0x01AF, 0x1EDF) "c",
				;
				Chrs(0x01B0, 0x01A1) "cj", Chrs(0x01B0, 0x1EE3) "c",
				Chrs(0x01AF, 0x01A0) "CJ", Chrs(0x01AF, 0x1EE2) "C",
				Chrs(0x01AF, 0x01A1) "cs", Chrs(0x01AF, 0x1EE3) "c",
				;
				Chrs(0x01B0, 0x01A1) "cx", Chrs(0x01B0, 0x1EE1) "c",
				Chrs(0x01AF, 0x01A0) "CX", Chrs(0x01AF, 0x1EE0) "C",
				Chrs(0x01AF, 0x01A1) "cs", Chrs(0x01AF, 0x1EE1) "c",
				;
				"upc1", Chrs(0x01B0, 0x1EDB) "c",
				"UPC1", Chrs(0x01AF, 0x1EDA) "C",
				"Upc1", Chrs(0x01AF, 0x1EDB) "c",
				;
				"upc2", Chrs(0x01B0, 0x1EDD) "c",
				"UPC2", Chrs(0x01AF, 0x1EDC) "C",
				"Upc2", Chrs(0x01AF, 0x1EDD) "c",
				;
				"upc3", Chrs(0x01B0, 0x1EDF) "c",
				"UPC3", Chrs(0x01AF, 0x1EDE) "C",
				"Upc3", Chrs(0x01AF, 0x1EDF) "c",
				;
				"upc4", Chrs(0x01B0, 0x1EE3) "c",
				"UPC4", Chrs(0x01AF, 0x1EE2) "C",
				"Upc4", Chrs(0x01AF, 0x1EE3) "c",
				;
				"upc5", Chrs(0x01B0, 0x1EE1) "c",
				"UPC5", Chrs(0x01AF, 0x1EE0) "C",
				"Upc5", Chrs(0x01AF, 0x1EE1) "c",
				;
				;
				"uongw", Chrs(0x01B0, 0x01A1) "ng",
				"UONGW", Chrs(0x01AF, 0x01A0) "NG",
				"Uongw", Chrs(0x01AF, 0x01A1) "ng",
				;
				Chrs(0x01B0, 0x01A1) "ngs", Chrs(0x01B0, 0x1EDB) "ng",
				Chrs(0x01AF, 0x01A0) "NGS", Chrs(0x01AF, 0x1EDA) "NG",
				Chrs(0x01AF, 0x01A1) "ngs", Chrs(0x01AF, 0x1EDB) "ng",
				;
				Chrs(0x01B0, 0x01A1) "ngf", Chrs(0x01B0, 0x1EDD) "ng",
				Chrs(0x01AF, 0x01A0) "NGF", Chrs(0x01AF, 0x1EDC) "NG",
				Chrs(0x01AF, 0x01A1) "ngf", Chrs(0x01AF, 0x1EDD) "ng",
				;
				Chrs(0x01B0, 0x01A1) "ngr", Chrs(0x01B0, 0x1EDF) "ng",
				Chrs(0x01AF, 0x01A0) "NGR", Chrs(0x01AF, 0x1EDE) "NG",
				Chrs(0x01AF, 0x01A1) "ngr", Chrs(0x01AF, 0x1EDF) "ng",
				;
				Chrs(0x01B0, 0x01A1) "ngj", Chrs(0x01B0, 0x1EE3) "ng",
				Chrs(0x01AF, 0x01A0) "NGJ", Chrs(0x01AF, 0x1EE2) "NG",
				Chrs(0x01AF, 0x01A1) "ngj", Chrs(0x01AF, 0x1EE3) "ng",
				;
				Chrs(0x01B0, 0x01A1) "ngx", Chrs(0x01B0, 0x1EE1) "ng",
				Chrs(0x01AF, 0x01A0) "NGX", Chrs(0x01AF, 0x1EE0) "NG",
				Chrs(0x01AF, 0x01A1) "ngx", Chrs(0x01AF, 0x1EE1) "ng",
				;
				"uong1", Chrs(0x01B0, 0x1EDB) "ng",
				"UONG1", Chrs(0x01AF, 0x1EDA) "NG",
				"Uong1", Chrs(0x01AF, 0x1EDB) "ng",
				;
				"uong2", Chrs(0x01B0, 0x1EDD) "ng",
				"UONG2", Chrs(0x01AF, 0x1EDC) "NG",
				"Uong2", Chrs(0x01AF, 0x1EDD) "ng",
				;
				"uong3", Chrs(0x01B0, 0x1EDF) "ng",
				"UONG3", Chrs(0x01AF, 0x1EDE) "NG",
				"Uong3", Chrs(0x01AF, 0x1EDF) "ng",
				;
				"uong4", Chrs(0x01B0, 0x1EE3) "ng",
				"UONG4", Chrs(0x01AF, 0x1EE2) "NG",
				"Uong4", Chrs(0x01AF, 0x1EE3) "ng",
				;
				"uong5", Chrs(0x01B0, 0x1EE1) "ng",
				"UONG5", Chrs(0x01AF, 0x1EE0) "NG",
				"Uong5", Chrs(0x01AF, 0x1EE1) "ng",
			),
			"Extended", Map(
				;* Extended A
				this.locLib.lat.s.a_cir "s", this.locLib.lat.s.a_cir_acu,
				this.locLib.lat.c.a_cir "S", this.locLib.lat.c.a_cir_acu,
				this.locLib.lat.s.a_cir "f", this.locLib.lat.s.a_cir_gra,
				this.locLib.lat.c.a_cir "F", this.locLib.lat.c.a_cir_gra,
				this.locLib.lat.s.a_cir "r", this.locLib.lat.s.a_cir_hoo_abo,
				this.locLib.lat.c.a_cir "R", this.locLib.lat.c.a_cir_hoo_abo,
				this.locLib.lat.s.a_cir "j", this.locLib.lat.s.a_cir_dot_bel,
				this.locLib.lat.c.a_cir "J", this.locLib.lat.c.a_cir_dot_bel,
				this.locLib.lat.s.a_cir "x", this.locLib.lat.s.a_cir_til,
				this.locLib.lat.c.a_cir "X", this.locLib.lat.c.a_cir_til,
				;
				this.locLib.lat.s.a_bre "s", this.locLib.lat.s.a_bre_acu,
				this.locLib.lat.c.a_bre "S", this.locLib.lat.c.a_bre_acu,
				this.locLib.lat.s.a_bre "f", this.locLib.lat.s.a_bre_gra,
				this.locLib.lat.c.a_bre "F", this.locLib.lat.c.a_bre_gra,
				this.locLib.lat.s.a_bre "r", this.locLib.lat.s.a_bre_hoo_abo,
				this.locLib.lat.c.a_bre "R", this.locLib.lat.c.a_bre_hoo_abo,
				this.locLib.lat.s.a_bre "j", this.locLib.lat.s.a_bre_dot_bel,
				this.locLib.lat.c.a_bre "J", this.locLib.lat.c.a_bre_dot_bel,
				this.locLib.lat.s.a_bre "x", this.locLib.lat.s.a_bre_til,
				this.locLib.lat.c.a_bre "X", this.locLib.lat.c.a_bre_til,
				;
				;
				this.locLib.lat.s.e_cir "s", this.locLib.lat.s.e_cir_acu,
				this.locLib.lat.c.e_cir "S", this.locLib.lat.c.e_cir_acu,
				this.locLib.lat.s.e_cir "f", this.locLib.lat.s.e_cir_gra,
				this.locLib.lat.c.e_cir "F", this.locLib.lat.c.e_cir_gra,
				this.locLib.lat.s.e_cir "r", this.locLib.lat.s.e_cir_hoo_abo,
				this.locLib.lat.c.e_cir "R", this.locLib.lat.c.e_cir_hoo_abo,
				this.locLib.lat.s.e_cir "j", this.locLib.lat.s.e_cir_dot_bel,
				this.locLib.lat.c.e_cir "J", this.locLib.lat.c.e_cir_dot_bel,
				this.locLib.lat.s.e_cir "x", this.locLib.lat.s.e_cir_til,
				this.locLib.lat.c.e_cir "X", this.locLib.lat.c.e_cir_til,
				;
			),
		),
		pinYin: Map(
			"Advanced", Map(),
			"Default", Map(
				"aa", Chr(0x0101),
				"AA", Chr(0x0100),
				"af", Chr(0x00E0),
				"AF", Chr(0x00C0),
				"as", Chr(0x00E1),
				"AS", Chr(0x00C1),
				"av", Chr(0x01CE),
				"AV", Chr(0x01CD),
				;
				"ee", Chr(0x0113),
				"EE", Chr(0x0112),
				"ef", Chr(0x00E8),
				"EF", Chr(0x00C8),
				"es", Chr(0x00E9),
				"ES", Chr(0x00C9),
				"ev", Chr(0x011B),
				"EV", Chr(0x011A),
				;
				"ii", Chr(0x012B),
				"II", Chr(0x012A),
				"if", Chr(0x00EC),
				"IF", Chr(0x00CC),
				"is", Chr(0x00ED),
				"IS", Chr(0x00CD),
				"iv", Chr(0x01D0),
				"IV", Chr(0x01CF),
				;
				"oo", Chr(0x014D),
				"OO", Chr(0x014C),
				"of", Chr(0x00F2),
				"OF", Chr(0x00D2),
				"os", Chr(0x00F3),
				"OS", Chr(0x00D3),
				"ov", Chr(0x01D2),
				"OV", Chr(0x01D1),
				;
				"uu", Chr(0x016B),
				"UU", Chr(0x016A),
				"uf", Chr(0x00F9),
				"UF", Chr(0x00D9),
				"us", Chr(0x00FA),
				"US", Chr(0x00DA),
				"uv", Chr(0x01D4),
				"UV", Chr(0x01D3),
				;
				Chr(0x00FC) "s", Chr(0x01D8),
				Chr(0x00DC) "S", Chr(0x01D7),
				Chr(0x00FC) "f", Chr(0x01DC),
				Chr(0x00DC) "F", Chr(0x01DB),
				Chr(0x00FC) "v", Chr(0x01DA),
				Chr(0x00DC) "V", Chr(0x01D9),
				Chr(0x00FC) "u", Chr(0x01D6),
				Chr(0x00DC) "U", Chr(0x01D5),
				;
				"u1", Chr(0x01D8),
				"U1", Chr(0x01D7),
				"u2", Chr(0x01DC),
				"U2", Chr(0x01DB),
				"u3", Chr(0x01DA),
				"U3", Chr(0x01D9),
				"u4", Chr(0x01D6),
				"U4", Chr(0x01D5),
				"u8", Chr(0x00FC),
				"U8", Chr(0x00DC),
			),
		),
		karaShiki: Map(
			"Advanced", Map(),
			"Default", Map(
				"ее", Chrs(0x0451, 0x0304),
				"ЕЕ", Chrs(0x0401, 0x0304),
				"ии", Chr(0x04E3),
				"ИИ", Chr(0x04E3),
				"оо", Chrs(0x043E, 0x0304),
				"ОО", Chrs(0x041E, 0x0304),
				"сс", Chr(0x04AB),
				"СС", Chr(0x04AA),
				"уу", Chr(0x04EF),
				"УУ", Chr(0x04EE),
				"уй", Chr(0x045E),
				"УЙ", Chr(0x040E),
				"юю", Chrs(0x044E, 0x0304),
				"ЮЮ", Chrs(0x042E, 0x0304),
				;
				;
				"aa", Chr(0x0101),
				"AA", Chr(0x0100),
				;
				"ee", Chr(0x0113),
				"EE", Chr(0x0112),
				;
				"oo", Chr(0x014D),
				"OO", Chr(0x014C),
				"ov", Chr(0x00F4),
				"OV", Chr(0x00D4),
				;
				"ii", Chr(0x012B),
				"II", Chr(0x012A),
				"iq", Chr(0x012D),
				"IQ", Chr(0x012C),
				;
				"uq", Chr(0x016D),
				"UQ", Chr(0x016C),
				"uu", Chr(0x016B),
				"UU", Chr(0x016A),
			),
		),
	}

	__New(mode := "vietNam", reloadHs := False) {
		this.mode := mode
		this.previousMode := InputScriptProcessor.options.interceptionInputMode
		this.RegistryHotstrings(reloadHs)
	}

	RegistryHotstrings(reloadHs) {
		Tooltip()

		InputScriptProcessor.options.interceptionInputMode := reloadHs
			? this.mode
				: (this.mode != InputScriptProcessor.options.interceptionInputMode ? this.mode : "")

		isEnabled := (InputScriptProcessor.options.interceptionInputMode != "" ? True : False)

		if this.mode != "" {
			InputScriptProcessor.InitHook()
		}


		!reloadHs && ShowInfoMessage(SetStringVars((ReadLocale("script_mode_" (isEnabled ? "" : "de") "activated")), ReadLocale("script_" this.mode)), , , Cfg.SkipGroupMessage, True, True)
	}

	static InH := InputHook("V")
	static inputLogger := ""

	static SequenceHandler(input := "", backspaceOn := False) {
		IPS := InputScriptProcessor

		inputCut := (str, len := 7) => StrLen(str) > len ? SubStr(str, StrLen(str) - (len - 1)) : str
		forbiddenChars := "[`n|\s]"

		if StrLen(input) > 0 && IPS.options.interceptionInputMode != "" {
			if !RegExMatch(input, forbiddenChars) {
				IPS.inputLogger .= input
				IPS.inputLogger := inputCut(IPS.inputLogger)

				;try {
				for subMap, entries in IPS.scriptSequences.%IPS.options.interceptionInputMode% {
					if !Cfg.Get("Advanced_Mode", "ScriptProcessor", False, "bool") && subMap = "Advanced"
						continue

					IPS.EntriesComparator(IPS.inputLogger, entries, &foundKey, &foundValue)

					if IsSet(foundKey) {
						try {
							IPS.backspaceLock := True

							Loop StrLen(foundKey) - (InStr(foundKey, "\") ? 1 : 0) {
								Send("{Backspace}")
							}

							SendText(foundValue)
							IPS.InH.Stop()
							IPS.inputLogger := foundValue
							IPS.InH.Start()
							IPS.backspaceLock := False
							break
						}
					}
				}
				;}
			} else {
				IPS.inputLogger := ""
			}
			suggestions := IPS.GetSuggestions(IPS.inputLogger)
			CaretTooltip(IPS.inputLogger (suggestions != "" ? "`n" Ligaturiser.FormatSuggestions(suggestions) : ""))
		} else {
			IPS.InH.Stop()
			IPS.inputLogger := ""
			Tooltip()
		}

		return
	}

	static GetSuggestions(input) {
		IPS := InputScriptProcessor
		output := ""
		if input != "" {
			for subMap, entries in IPS.scriptSequences.%IPS.options.interceptionInputMode% {
				if !Cfg.Get("Advanced_Mode", "ScriptProcessor", False, "bool") && subMap = "Advanced"
					continue
				for key, value in entries {
					if (RegExMatch(key, "^" RegExEscape(input))) {
						output .= RegExReplace(key, "^" RegExEscape(input), "-") "(" value "), "
					} else if IPS.EntriesComparator(input, key, &a, &b, True) {
						output .= RegExReplace(b, "^" RegExEscape(a), "-") "(" value "), "
					}
				}
			}
		}

		return output
	}

	static EntriesComparator(a, entries, &foundKey := "", &foundValue := "", partial := False) {
		cutA := a
		while (StrLen(cutA) > 0) {
			if !IsObject(entries) {
				if partial && RegExMatch(entries, "^" RegExEscape(cutA)) || (cutA == entries) {
					foundKey := cutA
					foundValue := entries
					return True
				}
			} else {
				for key, value in entries {
					if (cutA == key) {
						foundKey := key
						foundValue := value
						return
					}
				}
			}
			cutA := SubStr(cutA, 2)
		}
	}

	static backspaceLock := False
	static Backspacer(ih, vk, sc) {
		IPS := InputScriptProcessor
		backspaceCode := "14"

		if StrLen(IPS.inputLogger) > 0 && sc = backspaceCode && !InputScriptProcessor.backspaceLock {
			IPS.inputLogger := SubStr(IPS.inputLogger, 1, -1)
			CaretTooltip(IPS.inputLogger)
		}

		return
	}

	static InitHook() {
		this.InH.Start()
		;this.InH.NotifyNonText := True
		this.InH.KeyOpt("{Backspace}", "N")
		this.InH.OnChar := this.SequenceHandler
		this.InH.OnKeyDown := ObjBindMethod(this, "Backspacer")

		return
	}

	static TelexReturn(input) {
		output := input

		for key, value in this.scriptSequences.%this.options.interceptionInputMode% {
			isValid := input == key || InStr(input, "\") && (key == (SubStr(input, 1, 1) SubStr(input, 3)))
			if isValid {
				getValue := input == key ? value : key
				output := getValue
				break
			}
		}
		return output
	}
}