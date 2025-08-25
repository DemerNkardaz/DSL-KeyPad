Class ScripterStore {
	static storedData := Map("Alternative Modes", [], "Glyph Variations", [], "TELEX", [])
	static valuesIndex := Map("Alternative Modes", Map(), "Glyph Variations", Map(), "TELEX", Map())

	static __New() {
		local alternativeModes := JSON.LoadFile(App.paths.data "\scripter_alternative_modes.json", "UTF-8")
		local glyphVariations := JSON.LoadFile(App.paths.data "\scripter_glyph_variations.json", "UTF-8")
		local telex := JSON.LoadFile(App.paths.data "\scripter_telex.json", "UTF-8")
		ScripterStore("Alternative Modes", alternativeModes)
		ScripterStore("Glyph Variations", glyphVariations)
		ScripterStore("TELEX", telex)
		return Event.Trigger("Scripter Storage", "Initialized")
	}

	static Get(target, name) {
		local index := this.valuesIndex[target][name]
		return ScripterStore.storedData[target][index]
	}

	static Has(target, name) {
		return this.valuesIndex[target].Has(name)
	}

	__New(target := "Alternative Modes", source*) {
		this.target := target
		this.Merge(source*)
		this.RegenerateValuesIndex()
		return Event.Trigger("Scripter Storage", "Item Registered")
	}

	RegenerateValuesIndex() {
		ScripterStore.valuesIndex := Map("Alternative Modes", Map(), "Glyph Variations", Map(), "TELEX", Map())
		for target, modesArayy in ScripterStore.storedData {
			Loop modesArayy.Length // 2 {
				local index := A_Index * 2 - 1
				local dataIndex := index + 1
				local name := modesArayy[index]

				ScripterStore.valuesIndex[target][name] := dataIndex
			}
		}
		return
	}

	Merge(source*) {
		this.MergeInto(ScripterStore.storedData[this.target], source*)
		return
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
		return
	}

	HandleValue(value) {
		if value is Array {
			for i, item in value
				while (RegExMatch(value[i], "(?<!\\)<%\s(.*)\s%/>", &match))
					value[i] := StrReplace(value[i], match[0], VariableParser.Parse(match[0]))
		} else if value is String
			while (RegExMatch(value, "(?<!\\)<%\s(.*)\s%/>", &match))
				value := StrReplace(value, match[0], VariableParser.Parse(match[0]))
		return value
	}
}