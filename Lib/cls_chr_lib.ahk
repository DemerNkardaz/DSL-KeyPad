class ChrLib {

	static entries := {}

	static AddEntry(entryName, entry) {
		ChrLib.entries.%entryName% := entry
	}

	static AddEntries(arguments*) {
		for i, entry in arguments {
			if (Mod(i, 2) = 1) {
				entryName := arguments[i]
				entryValue := arguments[i + 1]

				ChrLib.AddEntry(entryName, entryValue)
			}
		}
	}

	static GetEntry(entryName) {
		return ChrLib.entries.%entryName%
	}

	static GetValue(entryName, value) {
		return ChrLib.entries.%entryName%.%value%
	}
}


ChrLib.AddEntry(
	"minus_sign", {
		unicode: "{U+2212}",
		modifierForm: "{U+02D7}",
		tags: ["minus", "минус"],
		group: [["Dashes", "Smelting Special", "Special Fast Primary", "Special Fast"], "9"],
		show_on_fast_keys: True,
		alt_on_fast_keys: "<+ [-]",
		alt_special: "[Num-]",
		recipe: "m-",
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
	},
)

;MsgBox(ChrLib.GetValue("minus_sign", "unicode") "`n" ChrLib.GetValue("minusdot", "unicode") " " ChrLib.GetValue("minustilde", "unicode"))
