GeneratedEntries() {
	local output := []

	output.Push(
		"misc_crlf_emspace", Map(
			"unicode", (*) => ChrLib.GetValue("carriage_return", "unicode"),
			"sequence", [(*) => ChrLib.GetValue("carriage_return", "unicode"), (*) => ChrLib.GetValue("new_line", "unicode"), (*) => ChrLib.GetValue("emsp", "unicode")],
			"groups", ["Misc"],
			"options", Map("noCalc", True, "fastKey", "Enter")
		),
		"misc_lf_emspace", Map(
			"unicode", (*) => ChrLib.GetValue("new_line", "unicode"),
			"sequence", [(*) => ChrLib.GetValue("new_line", "unicode"), (*) => ChrLib.GetValue("emsp", "unicode")],
			"groups", ["Misc"],
			"options", Map("noCalc", True, "fastKey", "<+ Enter")
		)
	)

	Loop 256 {
		local index := A_Index
		local unicodeValue := ""

		if (index <= 16) {
			unicodeValue := Format("FE{:02X}", index - 1)
		} else {
			local offset := index - 17
			unicodeValue := Format("E01{:02X}", offset)
		}

		output.Push(
			"variantion_selector_" index, Map(
				"titles", Map("ru-RU", "Селектор варианта " index, "en-US", "Variation selector " index),
				"tags", ["Variation selector " index, "Селектор варианта " index],
				"unicode", "" unicodeValue "",
				"options", Map("noCalc", True, "suggestionsAtEnd", True),
				"recipe", ["vs" index],
				"symbol", Map("alt", "<VARIATION SELECTOR-" index ">")
			)
		)
	}

	Loop 5 {
		local index := A_Index
		local unicodeValue := Format("{:X}", 0x1F3FA + index)

		if index > 1
			index++

		output.Push(
			"emoji_modifier_fitzpatrick_" index, Map(
				"titles", Map(
					"en-US", "Emoji Modifier Fitzpatrick " index,
					"ru-RU", "Модификатор Фицпатрика " index
				),
				"unicode", "" unicodeValue "",
				"tags", ["Emoji Modifier Fitzpatrick " index, "Модификатор Фицпатрика " index],
				"options", Map("noCalc", True, "suggestionsAtEnd", True),
				"recipe", ["ftz" index],
				"symbol", Map("alt", "<EMOJI MODIFIER FITZPATRICK TYPE-" (index = 1 ? "1-2" : index) ">")
			)
		)
	}

	local emoji_hairs := Map(
		1, ["red_hair", "rh"],
		2, ["curly_hair", "ch"],
		3, ["bald", "ba"],
		4, ["white_hair", "wh"],
	)

	Loop 4 {
		local index := A_Index
		local unicodeValue := Format("{:X}", 0x1F9AF + index)
		local entryPost := emoji_hairs[index][1]
		local title := StrReplace(Util.StrUpper(entryPost, 1), "_", " ")

		output.Push(
			"emoji_component_" entryPost, Map(
				"titles", Map(
					"en-US", "Emoji Component " title,
					"ru-RU", "Компонент эмодзи " title
				),
				"unicode", "" unicodeValue "",
				"tags", ["Emoji Component " title, "Компонент эмодзи " title],
				"options", Map("noCalc", True, "suggestionsAtEnd", True),
				"recipe", ["ecmp " emoji_hairs[index][2], "ecmp " StrReplace(entryPost, "_", " ")],
				"symbol", Map("alt", "<EMOJI COMPONENT " StrUpper(title) ">")
			)
		)
	}

	return output
}