Class ScripterStore {
	static storedData := Map("Alternative Modes", [], "Glyph Variations", [])

	static __New() {
		local alternativeModes := JSON.LoadFile(App.paths.data "\alternative_modes.json", "UTF-8")
		local glyphVariations := JSON.LoadFile(App.paths.data "\glyph_variations.json", "UTF-8")
		ScripterStore("Alternative Modes", alternativeModes)
		ScripterStore("Glyph Variations", glyphVariations)
	}

	__New(target := "Alternative Modes", source*) {
		this.target := target
		this.Merge(source*)
	}

	Merge(source*) {
		this.MergeInto(ScripterStore.storedData[this.target], source*)
	}

	MergeInto(targetArray, arrays*) {
		for each in arrays {
			Loop each.Length // 2 {
				local i := A_Index * 2 - 1
				local name := each[i]
				local data := each[i + 1]

				for k, v in data
					data.Set(k, this.HandleValue(v))

				targetArray.Push(name, data)
			}
		}
	}

	HandleValue(value) {
		if value is Array {
			for i, item in value
				while (RegExMatch(value[i], "(?<!\\)%(.*)%", &match))
					value[i] := StrReplace(value[i], match[0], VariableParser.Parse(match[0]))
		} else if value is String
			while (RegExMatch(value, "(?<!\\)%(.*)%", &match))
				value := StrReplace(value, match[0], VariableParser.Parse(match[0]))
		return value
	}
}