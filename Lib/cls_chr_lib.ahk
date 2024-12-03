class ChrLib {

	static entries := {}

	static AddEntry(entryName, entry) {
		this.entries.%entryName% := entry
	}

	static AddEntries(arguments*) {
		for i, entry in arguments {
			if (Mod(i, 2) = 1) {
				entryName := arguments[i]
				entryValue := arguments[i + 1]

				this.AddEntry(entryName, entryValue)
			}
		}

		return
	}

	static GetEntry(entryName) {
		return this.entries.%entryName%
	}

	static GetValue(entryName, value) {
		return this.entries.%entryName%.%value%
	}

	static Get(entryName, extraRules := False) {
		entry := this.GetEntry(entryName)
		output := ""

		if (extraRules && StrLen(AlterationActiveName) > 0) && HasProp(entry, "alterations") && HasProp(entry.alterations, AlterationActiveName) {
			output .= Util.UnicodeToChar(entry.alterations.%AlterationActiveName%)

		} else if HasProp(entry, "sequence") {
			output .= Util.UnicodeToChar(entry.sequence)

		} else {
			output .= Util.UnicodeToChar(entry.unicode)
		}


		return output
	}

	static ConvertLegacyMap(legacyMap) {
		for entry, value in legacyMap {
		}
	}
}

; TODO НЕ ЗАБЫТЬ НАПИСАТЬ КОНВЕРТЕР ИЗ ЛЕГАСИ КАРТЫ СИМВОЛОВ В НОВЫЙ ФОРМАТ ВМЕСТО РУЧНОЙ ПЕРЕПИСИ БИБЛИОТЕКИ СИМВОЛОВ. КОНВЕРТЕР ЧИТАЕТ ПЕРЕМЕННУЮ CHARACTERS И СОЗДАЁТ НОВЫЙ ФАЙЛ, ГДЕ ВСЕ СИМВОЛЫ ПЕРЕВЕДЕНЫ В НОВЫЙ ФОРМАТ.


ChrLib.AddEntry(
	"minus_sign", {
		unicode: "{U+2212}",
		modifierForm: "{U+02D7}",
		sequence: ["{U+22f23}", "{U+55F0}", "{U+76EA}", "ACDE"],
		tags: ["minus", "минус"],
		group: [["Dashes", "Smelting Special", "Special Fast Primary", "Special Fast"], "9"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [-]",
		alt_special: "[Num-]",
		recipe: "m-",
	}
)

;MsgBox(ChrLib.Get("minus_sign"))

ChrLib.AddEntry(
	"concept_c_letter_tse", {
		titles: Map("ru", "", "en", ""),
		unicode: "{U+0426}", html: "fills automatically", altCode: "fills automatically", LaTeX: ["\^", "\hat"],
		sequence: ["{U+0426}", "{U+0426}", "{U+0426}"],
		tags: ["concept", "концепт"],
		groups: ["Concept Entry"],
		alterations: {
			modifier: "{U+02D7}",
			combining: "{U+02D7}",
			uncombined: "{U+02D7}",
			subscript: "{U+02D7}",
			italic: "{U+02D7}",
			italicBold: "{U+02D7}",
			bold: "{U+02D7}",
			script: "{U+02D7}",
			fraktur: "{U+02D7}",
			scriptBold: "{U+02D7}",
			frakturBold: "{U+02D7}",
			doubleStruck: "{U+02D7}",
			doubleStruckBold: "{U+02D7}",
			doubleStruckItalic: "{U+02D7}",
			doubleStruckItalicBold: "{U+02D7}",
			sansSerif: "{U+02D7}",
			sansSerifItalic: "{U+02D7}",
			sansSerifItalicBold: "{U+02D7}",
			sansSerifBold: "{U+02D7}",
			monospace: "{U+02D7}",
			smallCapital: "{U+02D7}",
		},
		options: {
			noCalc: True,
			titlesAlt: True,
			isFastKey: True,
			isAltLayout: True,
			groupKey: "9",
			fastKey: "<+ [-]",
			specialKey: "[Num-]",
			altLayoutKey: "[A]",
		},
		symbol: {
			letter: "Ц",
			set: Chr(0x0426),
			alt: "[" Chr(0x0426) "]",
			category: "Entry Concept",
			customs: "s72 underline",
			font: "Cambria",
		},
		recipe: ["m-"],
	}
)

ChrLib.AddEntries(
	"minusdot", {
		unicode: "{U+2238}",
		tags: ["dot minus", "минус с точкой"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["-.", Chr(0x2212) "."],
	},
	"minustilde", {
		unicode: "{U+2242}",
		tags: ["minus tilde", "тильда с минусом"],
		group: [["Special Characters", "Smelting Special"]],
		recipe: ["~-", "~" Chr(0x2212)],
		;test: ChrLib.GetValue("minusdot", "recipe")[1],
	},
)
/*

MsgBox(ChrLib.GetValue("minus_sign", "unicode") "`n" ChrLib.GetValue("minusdot", "unicode") " " ChrLib.GetValue("minustilde", "unicode") "`n" ChrLib.GetValue("minustilde", "unicode") "`n")


for entry, value in ChrLib.entries.OwnProps() {
	msgbox(entry "`n" value.unicode)
}
*/
