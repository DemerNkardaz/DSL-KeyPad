Class InputScriptProcessor {

	static options := {
		interceptionInputMode: "",
	}

	static locLib := {
		lat: {
			slash: "reverse_solidus",
			q: "lat_[c,s]_let_q",
			p: "lat_[c,s]_let_p",
			c: "lat_[c,s]_let_c",
			c_car: "lat_[c,s]_let_c__caron",
			a: "lat_[c,s]_let_a",
			a_acu: "lat_[c,s]_let_a__acute",
			a_bre: "lat_[c,s]_let_a__breve",
			a_bre_acu: "lat_[c,s]_let_a__breve__acute",
			a_bre_gra: "lat_[c,s]_let_a__breve__grave",
			a_bre_til: "lat_[c,s]_let_a__breve__tilde_above",
			a_bre_dot_bel: "lat_[c,s]_let_a__breve__dot_below",
			a_bre_hoo_abo: "lat_[c,s]_let_a__breve__hook_above",
			a_dia: "lat_[c,s]_let_a__diaeresis",
			a_cir: "lat_[c,s]_let_a__circumflex",
			a_cir_acu: "lat_[c,s]_let_a__circumflex__acute",
			a_cir_gra: "lat_[c,s]_let_a__circumflex__grave",
			a_cir_til: "lat_[c,s]_let_a__circumflex__tilde_above",
			a_cir_dot_bel: "lat_[c,s]_let_a__circumflex__dot_below",
			a_cir_hoo_abo: "lat_[c,s]_let_a__circumflex__hook_above",
			a_car: "lat_[c,s]_let_a__caron",
			a_gra: "lat_[c,s]_let_a__grave",
			a_til: "lat_[c,s]_let_a__tilde_above",
			a_dot_bel: "lat_[c,s]_let_a__dot_below",
			a_hoo_abo: "lat_[c,s]_let_a__hook_above",
			a_mac: "lat_[c,s]_let_a__macron",
			;
			b: "lat_[c,s]_let_b",
			b_sto: "lat_[c,s]_let_b__stroke_short",
			;
			d: "lat_[c,s]_let_d",
			d_sto: "lat_[c,s]_let_d__stroke_short",
			;
			n: "lat_[c,s]_let_n",
			n_til: "lat_[c,s]_let_n__tilde_above",
			;
			e: "lat_[c,s]_let_e",
			e_acu: "lat_[c,s]_let_e__acute",
			e_bre: "lat_[c,s]_let_e__breve",
			e_cir: "lat_[c,s]_let_e__circumflex",
			e_dia: "lat_[c,s]_let_e__diaeresis",
			e_cir_acu: "lat_[c,s]_let_e__circumflex__acute",
			e_cir_gra: "lat_[c,s]_let_e__circumflex__grave",
			e_cir_til: "lat_[c,s]_let_e__circumflex__tilde_above",
			e_cir_dot_bel: "lat_[c,s]_let_e__circumflex__dot_below",
			e_cir_hoo_abo: "lat_[c,s]_let_e__circumflex__hook_above",
			e_car: "lat_[c,s]_let_e__caron",
			e_gra: "lat_[c,s]_let_e__grave",
			e_til: "lat_[c,s]_let_e__tilde_above",
			e_dot_bel: "lat_[c,s]_let_e__dot_below",
			e_hoo_abo: "lat_[c,s]_let_e__hook_above",
			e_mac: "lat_[c,s]_let_e__macron",
			;
			i: "lat_[c,s]_let_i",
			i_acu: "lat_[c,s]_let_i__acute",
			i_bre: "lat_[c,s]_let_i__breve",
			i_dia: "lat_[c,s]_let_i__diaeresis",
			i_cir: "lat_[c,s]_let_i__circumflex",
			i_car: "lat_[c,s]_let_i__caron",
			i_gra: "lat_[c,s]_let_i__grave",
			i_til: "lat_[c,s]_let_i__tilde_above",
			i_dot_bel: "lat_[c,s]_let_i__dot_below",
			i_hoo_abo: "lat_[c,s]_let_i__hook_above",
			i_mac: "lat_[c,s]_let_i__macron",
			;
			o: "lat_[c,s]_let_o",
			o_acu: "lat_[c,s]_let_o__acute",
			o_bre: "lat_[c,s]_let_o__breve",
			o_dia: "lat_[c,s]_let_o__diaeresis",
			o_cir: "lat_[c,s]_let_o__circumflex",
			o_cir_acu: "lat_[c,s]_let_o__circumflex__acute",
			o_cir_gra: "lat_[c,s]_let_o__circumflex__grave",
			o_cir_til: "lat_[c,s]_let_o__circumflex__tilde_above",
			o_cir_dot_bel: "lat_[c,s]_let_o__circumflex__dot_below",
			o_cir_hoo_abo: "lat_[c,s]_let_o__circumflex__hook_above",
			o_hor: "lat_[c,s]_let_o__horn",
			o_hor_acu: "lat_[c,s]_let_o__horn__acute",
			o_hor_gra: "lat_[c,s]_let_o__horn__grave",
			o_hor_til: "lat_[c,s]_let_o__horn__tilde_above",
			o_hor_dot_bel: "lat_[c,s]_let_o__horn__dot_below",
			o_hor_hoo_abo: "lat_[c,s]_let_o__horn__hook_above",
			o_car: "lat_[c,s]_let_o__caron",
			o_gra: "lat_[c,s]_let_o__grave",
			o_til: "lat_[c,s]_let_o__tilde_above",
			o_dot_bel: "lat_[c,s]_let_o__dot_below",
			o_hoo_abo: "lat_[c,s]_let_o__hook_above",
			o_mac: "lat_[c,s]_let_o__macron",
			;
			u: "lat_[c,s]_let_u",
			u_acu: "lat_[c,s]_let_u__acute",
			u_bre: "lat_[c,s]_let_u__breve",
			u_dia: "lat_[c,s]_let_u__diaeresis",
			u_dia_mac: "lat_[c,s]_let_u__diaeresis__macron",
			u_dia_acu: "lat_[c,s]_let_u__diaeresis__acute",
			u_dia_gra: "lat_[c,s]_let_u__diaeresis__grave",
			u_dia_car: "lat_[c,s]_let_u__diaeresis__caron",
			u_cir: "lat_[c,s]_let_u__circumflex",
			u_hor: "lat_[c,s]_let_u__horn",
			u_hor_acu: "lat_[c,s]_let_u__horn__acute",
			u_hor_gra: "lat_[c,s]_let_u__horn__grave",
			u_hor_til: "lat_[c,s]_let_u__horn__tilde_above",
			u_hor_dot_bel: "lat_[c,s]_let_u__horn__dot_below",
			u_hor_hoo_abo: "lat_[c,s]_let_u__horn__hook_above",
			u_car: "lat_[c,s]_let_u__caron",
			u_gra: "lat_[c,s]_let_u__grave",
			u_til: "lat_[c,s]_let_u__tilde_above",
			u_dot_bel: "lat_[c,s]_let_u__dot_below",
			u_hoo_abo: "lat_[c,s]_let_u__hook_above",
			u_mac: "lat_[c,s]_let_u__macron",
			;
			y: "lat_[c,s]_let_y",
			y_acu: "lat_[c,s]_let_y__acute",
			y_dia: "lat_[c,s]_let_y__diaeresis",
			y_cir: "lat_[c,s]_let_y__circumflex",
			y_gra: "lat_[c,s]_let_y__grave",
			y_til: "lat_[c,s]_let_y__tilde_above",
			y_dot_bel: "lat_[c,s]_let_y__dot_below",
			y_hoo_abo: "lat_[c,s]_let_y__hook_above",
			y_mac: "lat_[c,s]_let_y__macron",
		},
		cyr: {}
	}

	static GenerateSequences(libLink, ending?, replaceWith?) {
		output := Map()
		if IsObject(libLink) {
			tempArray := []
			for i, key in libLink {
				if Mod(i, 3) = 1 {
					link := libLink[i]
					ending := libLink[i + 1]
					replaceWith := libLink[i + 2]

					output := MapMerge(output, this.GenerateSequences(link, ending, replaceWith))
				}
			}

		} else {
			RegExMatch(libLink, "^(.*?):(.*?)(?:\[(.*?)\])?$", &match)

			category := match[1]
			libChar := match[2]
			inputVariations := match[3] = "" ? [""] : StrSplit(match[3], ", ")

			if ending is String
				ending := [StrLower(ending), StrUpper(ending)]


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

				return this.GenerateSequences(deployedArray)
			} else {

				for variation in inputVariations {
					var := variation != "" ? "_" variation : ""
					sequenceIn := [this.locLib.%category%.%libChar%%var%[2], this.locLib.%category%.%libChar%%var%[1]]

					if !IsObject(replaceWith) {
						variationsReplace := (InStr(replaceWith, "[*]") ? StrReplace(replaceWith, "[*]", "_" variation) : replaceWith)
						sequenceOut := [this.locLib.%category%.%variationsReplace%[2], this.locLib.%category%.%variationsReplace%[1]]
					} else {
						sequenceOut := replaceWith
					}

					SetSequences(sequenceIn, ending, sequenceOut)
				}
			}

		}

		SetSequences(seqIn, seqEnd, seqOut) {
			output.Set(
				seqIn[1] seqEnd[1], seqOut[1],
				seqIn[2] seqEnd[2], seqOut[2],
				seqIn[1] "\" seqEnd[1], seqIn[1] seqEnd[1],
				seqIn[2] "\" seqEnd[2], seqIn[2] seqEnd[2],
			)
		}

		return output
	}

	static scriptSequences := {}

	static __New() {
		this.Init()
		this.SetSequences()
	}

	static Init() {
		for scriptType, entries in this.locLib.OwnProps() {
			for k, v in entries.OwnProps() {
				if v is String && RegExMatch(v, "\[(.*?)\]", &match) {
					split := StrSplit(match[1], ",")
					inter := []

					for each in split
						inter.Push(ChrLib.Get(RegExReplace(v, "\[(.*?)\]", each)))

					this.locLib.%scriptType%.%k% := inter
				}
			}
		}
	}

	static SetSequences() {
		raw := {
			vietNam: Map(
				"Advanced", MapMerge(
					this.GenerateSequences([
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
						"lat:e[bre, cir, car]", [["w", "W"], ["e", "E"], ["``", "``"]], "e[*]",
						"lat:e[cir, bre, acu, gra, til, hoo_abo, dot_bel]", ["z", "Z"], ["e", "E"],
						"lat:e[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "e[*]",
						;
						"lat:e_cir[acu, gra, til, dot_bel, hoo_abo]", ["z", "Z"], "e_cir",
						"lat:e_cir[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "e_cir[*]",
						;
						"lat:i[bre, acu, gra, til, hoo_abo, dot_bel]", ["z", "Z"], ["i", "I"],
						"lat:i[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "i[*]",
						;
						"lat:o[hor, cir, bre, car]", [["w", "W"], ["o", "O"], ["q", "Q"], ["``", "``"]], "o[*]",
						"lat:o[cir, hor, acu, gra, til, hoo_abo, dot_bel, bre]", ["z", "Z"], ["o", "O"],
						"lat:o[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "o[*]",
						;
						"lat:o_hor[acu, gra, til, dot_bel, hoo_abo]", ["z", "Z"], "o_hor",
						"lat:o_hor[acu, gra, til, dot_bel, hoo_abo]", ["o", "O"], "o_cir[*]",
						"lat:o_hor[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "o_hor[*]",
						;
						"lat:o_cir[acu, gra, til, dot_bel, hoo_abo]", ["z", "Z"], "o_cir",
						"lat:o_cir[acu, gra, til, dot_bel, hoo_abo]", ["w", "W"], "o_hor[*]",
						"lat:o_cir[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "o_cir[*]",
						;
						"lat:u[hor, bre]", [["w", "W"], ["q", "Q"]], "u[*]",
						"lat:u[hor, acu, gra, til, hoo_abo, dot_bel, bre]", ["z", "Z"], ["u", "U"],
						"lat:u[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "u[*]",
						;
						"lat:u_hor[acu, gra, til, dot_bel, hoo_abo]", ["z", "Z"], "u_hor",
						"lat:u_hor[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "u_hor[*]",
						;
						"lat:y[acu, gra, til, hoo_abo, dot_bel]", ["z", "Z"], ["y", "Y"],
						"lat:y[acu, gra, til, dot_bel, hoo_abo]", [["s", "S"], ["f", "F"], ["x", "X"], ["j", "J"], ["r", "R"]], "y[*]",
						;
					]),
				),
				"Default", MapMerge(
					this.GenerateSequences([
						"lat:a", "W", "a_bre",
						"lat:a", "A", "a_cir",
						"lat:a", "F", "a_gra",
						"lat:a", "S", "a_acu",
						"lat:a", "X", "a_til",
						"lat:a", "J", "a_dot_bel",
						"lat:a", "R", "a_hoo_abo",
						"lat:a", "1", "a_cir_acu",
						"lat:a", "2", "a_cir_gra",
						"lat:a", "3", "a_cir_hoo_abo",
						"lat:a", "4", "a_cir_dot_bel",
						"lat:a", "5", "a_cir_til",
						"lat:q", "1", "a_bre_acu",
						"lat:q", "2", "a_bre_gra",
						"lat:q", "3", "a_bre_hoo_abo",
						"lat:q", "4", "a_bre_dot_bel",
						"lat:q", "5", "a_bre_til",
						;
						"lat:d", "D", "d_sto",
						;
						"lat:e", "E", "e_cir",
						"lat:e", "F", "e_gra",
						"lat:e", "S", "e_acu",
						"lat:e", "X", "e_til",
						"lat:e", "J", "e_dot_bel",
						"lat:e", "R", "e_hoo_abo",
						"lat:e", "1", "e_cir_acu",
						"lat:e", "2", "e_cir_gra",
						"lat:e", "3", "e_cir_hoo_abo",
						"lat:e", "4", "e_cir_dot_bel",
						"lat:e", "5", "e_cir_til",
						;
						"lat:i", "F", "i_gra",
						"lat:i", "S", "i_acu",
						"lat:i", "X", "i_til",
						"lat:i", "J", "i_dot_bel",
						"lat:i", "R", "i_hoo_abo",
						;
						"lat:o", "W", "o_hor",
						"lat:o", "O", "o_cir",
						"lat:o", "F", "o_gra",
						"lat:o", "S", "o_acu",
						"lat:o", "X", "o_til",
						"lat:o", "J", "o_dot_bel",
						"lat:o", "R", "o_hoo_abo",
						"lat:o", "1", "o_cir_acu",
						"lat:o", "2", "o_cir_gra",
						"lat:o", "3", "o_cir_hoo_abo",
						"lat:o", "4", "o_cir_dot_bel",
						"lat:o", "5", "o_cir_til",
						"lat:p", "1", "o_hor_acu",
						"lat:p", "2", "o_hor_gra",
						"lat:p", "3", "o_hor_hoo_abo",
						"lat:p", "4", "o_hor_dot_bel",
						"lat:p", "5", "o_hor_til",
						;
						"lat:u", "W", "u_hor",
						"lat:u", "F", "u_gra",
						"lat:u", "S", "u_acu",
						"lat:u", "X", "u_til",
						"lat:u", "J", "u_dot_bel",
						"lat:u", "R", "u_hoo_abo",
						"lat:u", "1", "u_hor_acu",
						"lat:u", "2", "u_hor_gra",
						"lat:u", "3", "u_hor_hoo_abo",
						"lat:u", "4", "u_hor_dot_bel",
						"lat:u", "5", "u_hor_til",
						;
						"lat:y", "F", "y_gra",
						"lat:y", "S", "y_acu",
						"lat:y", "X", "y_til",
						"lat:y", "J", "y_dot_bel",
						"lat:y", "R", "y_hoo_abo",
						;*
						;* Gia-Rai (Jarai) Extensions
						;*
						"lat:b", "B", "b_sto",
						"lat:c", "``", "c_car",
						"lat:e", "W", "e_bre",
						"lat:e", "``", "e_car",
						"lat:i", "W", "i_bre",
						"lat:n", "N", "n_til",
						"lat:o", "Q", "o_bre",
						"lat:o", "``", "o_car",
						"lat:o", "8", "o_dia",
						"lat:u", "Q", "u_bre",
						"lat:u", "8", "u_dia",
					]),
					Map(
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
					)
				),
				"Extended", this.GenerateSequences([
					"lat:a_cir", "S", "a_cir_acu",
					"lat:a_cir", "F", "a_cir_gra",
					"lat:a_cir", "R", "a_cir_hoo_abo",
					"lat:a_cir", "J", "a_cir_dot_bel",
					"lat:a_cir", "X", "a_cir_til",
					"lat:a_bre", "S", "a_bre_acu",
					"lat:a_bre", "F", "a_bre_gra",
					"lat:a_bre", "R", "a_bre_hoo_abo",
					"lat:a_bre", "J", "a_bre_dot_bel",
					"lat:a_bre", "X", "a_bre_til",
					"lat:e_cir", "S", "e_cir_acu",
					"lat:e_cir", "F", "e_cir_gra",
					"lat:e_cir", "R", "e_cir_hoo_abo",
					"lat:e_cir", "J", "e_cir_dot_bel",
					"lat:e_cir", "X", "e_cir_til",
					"lat:o_cir", "S", "o_cir_acu",
					"lat:o_cir", "F", "o_cir_gra",
					"lat:o_cir", "R", "o_cir_hoo_abo",
					"lat:o_cir", "J", "o_cir_dot_bel",
					"lat:o_cir", "X", "o_cir_til",
					"lat:o_hor", "S", "o_hor_acu",
					"lat:o_hor", "F", "o_hor_gra",
					"lat:o_hor", "R", "o_hor_hoo_abo",
					"lat:o_hor", "J", "o_hor_dot_bel",
					"lat:o_hor", "X", "o_hor_til",
					"lat:u_hor", "S", "u_hor_acu",
					"lat:u_hor", "F", "u_hor_gra",
					"lat:u_hor", "R", "u_hor_hoo_abo",
					"lat:u_hor", "J", "u_hor_dot_bel",
					"lat:u_hor", "X", "u_hor_til",
				]),
			),
			pinYin: Map(
				"Advanced", this.GenerateSequences([
					"lat:a[mac, gra, acu, car]", ["z", "Z"], ["a", "A"],
					"lat:a[mac, gra, acu, car]", [["a", "A"], ["f", "F"], ["s", "S"], ["v", "V"]], "a[*]",
					"lat:e[mac, gra, acu, car]", ["z", "Z"], ["e", "E"],
					"lat:e[mac, gra, acu, car]", [["e", "E"], ["f", "F"], ["s", "S"], ["v", "V"]], "e[*]",
					"lat:i[mac, gra, acu, car]", ["z", "Z"], ["i", "I"],
					"lat:i[mac, gra, acu, car]", [["i", "I"], ["f", "F"], ["s", "S"], ["v", "V"]], "i[*]",
					"lat:o[mac, gra, acu, car]", ["z", "Z"], ["o", "O"],
					"lat:o[mac, gra, acu, car]", [["o", "O"], ["f", "F"], ["s", "S"], ["v", "V"]], "o[*]",
					"lat:u[mac, gra, acu, car, dia]", ["z", "Z"], ["u", "U"],
					"lat:u[mac, gra, acu, car]", [["u", "U"], ["f", "F"], ["s", "S"], ["v", "V"]], "u[*]",
					"lat:u_dia[mac, gra, acu, car]", ["z", "Z"], "u_dia",
					"lat:u_dia[mac, gra, acu, car]", [["u", "U"], ["f", "F"], ["s", "S"], ["v", "V"]], "u_dia[*]",
				]),
				"Default", this.GenerateSequences([
					"lat:a", "A", "a_mac",
					"lat:a", "F", "a_gra",
					"lat:a", "S", "a_acu",
					"lat:a", "V", "a_car",
					;
					"lat:e", "E", "e_mac",
					"lat:e", "F", "e_gra",
					"lat:e", "S", "e_acu",
					"lat:e", "V", "e_car",
					;
					"lat:i", "I", "i_mac",
					"lat:i", "F", "i_gra",
					"lat:i", "S", "i_acu",
					"lat:i", "V", "i_car",
					;
					"lat:o", "O", "o_mac",
					"lat:o", "F", "o_gra",
					"lat:o", "S", "o_acu",
					"lat:o", "V", "o_car",
					;
					"lat:u", "U", "u_mac",
					"lat:u", "F", "u_gra",
					"lat:u", "S", "u_acu",
					"lat:u", "V", "u_car",
					"lat:u", "1", "u_dia_mac",
					"lat:u", "2", "u_dia_gra",
					"lat:u", "3", "u_dia_acu",
					"lat:u", "4", "u_dia_car",
					"lat:u", "8", "u_dia",
					"lat:u_dia", "U", "u_dia_mac",
					"lat:u_dia", "F", "u_dia_gra",
					"lat:u_dia", "S", "u_dia_acu",
					"lat:u_dia", "V", "u_dia_car",
					;
				]),
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
		for script, entries in raw.OwnProps() {
			if !this.scriptSequences.HasOwnProp(script)
				this.scriptSequences.%script% := Map("Escaped", Map(), "Default", Map())

			for group, groupEntries in entries
				for k, v in groupEntries
					this.scriptSequences.%script%[InStr(k, "\") ? "Escaped" : "Default"].Set(k, v)
		}
	}

	__New(mode := "vietNam", reloadHs := False) {
		currentAlt := Scripter.selectedMode.Get("Alternative Modes")

		if currentAlt != "" {
			nameTitle := Locale.Read(Scripter.GetData(, currentAlt).locale)
			IPSTitle := Locale.Read("script_processor_mode_" mode)
			MsgBox(Locale.ReadInject("script_processor_warning_alt_mode_active", [IPSTitle, nameTitle]), App.Title(), "Icon!")
			return
		}

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


		!reloadHs && ShowInfoMessage(Locale.ReadInject("script_mode_" (isEnabled ? "" : "de") "activated", [Locale.Read("script_" this.mode)]), , , , True, True)
	}

	static InH := InputHook("V")
	static inputLogger := ""

	static blockHandler := 1

	static SequenceBridge(IPS, g, k, v) {
		IPS.backspaceLock := True
		IPS.blockHandler := g = "Escaped" ? 3 : 1

		Send(Util.StrRepeat("{Backspace}", StrLen(k)))

		SendText(v)
		IPS.InH.Stop()
		IPS.inputLogger := v
		IPS.InH.Start()
		IPS.backspaceLock := False
	}

	static SequenceHandler(input := "", backspaceOn := False) {
		IPS := InputScriptProcessor

		if IPS.blockHandler >= 2 {
			IPS.blockHandler--
			return
		} else {
			inputCut := (str, len := 7) => StrLen(str) > len ? SubStr(str, StrLen(str) - (len - 1)) : str
			forbiddenChars := "[`n|`r|\x{0000}-\x{0020}|,|.]"

			if StrLen(input) > 0 && IPS.options.interceptionInputMode != "" {
				if !RegExMatch(input, forbiddenChars) {
					IPS.inputLogger .= input
					IPS.inputLogger := inputCut(IPS.inputLogger)

					for group in ["Escaped", "Default"] {
						for k, v in IPS.scriptSequences.%IPS.options.interceptionInputMode%.Get(group) {
							if IPS.inputLogger ~= RegExEscape(k) "$" {
								IPS.SequenceBridge(IPS, group, k, v)
								break 2
							}
						}
					}

				} else {
					IPS.inputLogger := ""
				}

				suggestions := IPS.GetSuggestions(IPS.inputLogger)
				Util.CaretTooltip(IPS.inputLogger (suggestions != "" ? "`n" ChrCrafter.FormatSuggestions(suggestions) : ""))

			} else {
				IPS.InH.Stop()
				IPS.inputLogger := ""
				Tooltip()
			}
		}
		return
	}

	static GetSuggestions(input) {
		IPS := InputScriptProcessor
		output := ""
		if input != "" {
			for subMap, entries in IPS.scriptSequences.%IPS.options.interceptionInputMode% {
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
		found := False
		while !found && (StrLen(cutA) > 1) {
			if !IsObject(entries) {
				if partial && RegExMatch(entries, "^" RegExEscape(cutA)) || (cutA == entries) {
					foundKey := cutA
					foundValue := entries
					found := True
					break
				}
			} else {
				if entries.Has(cutA) {
					foundKey := cutA
					foundValue := entries.Get(cutA)
					found := True
					break
				}
			}
			cutA := SubStr(cutA, 2)
		}

		return found
	}

	static backspaceLock := False
	static Backspacer(ih, vk, sc) {
		IPS := InputScriptProcessor
		backspaceCode := "14"
		resetKeys := [
			"331", "336", "328", "333", ; Arrows
			"327", "335", "329", "337", ; Home End PgUp PgDn
		]

		if StrLen(IPS.inputLogger) > 0 && sc = backspaceCode && !InputScriptProcessor.backspaceLock {
			IPS.inputLogger := SubStr(IPS.inputLogger, 1, -1)

			Util.CaretTooltip(IPS.inputLogger)
		} else if resetKeys.HasValue(sc) {
			IPS.inputLogger := ""
			Tooltip()
		}

		return
	}

	static InitHook() {
		this.InH.Start()
		this.InH.NotifyNonText := True
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