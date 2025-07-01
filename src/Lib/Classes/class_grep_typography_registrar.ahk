Class GREPTypographyReg {
	__New(paths := GREPTypography.dictionariesPaths) {
		local data := Map()
		local dataToMerge := Map()

		for each in paths {
			local JSONData := JSON.LoadFile(each, "UTF-8")
			this.MergeData(data, JSONData)
			JSONData := unset
		}

		for languageCode, set in data {
			if !dataToMerge.Has(languageCode)
				dataToMerge.Set(languageCode, Map())

			for setName, rules in set {
				if !dataToMerge[languageCode].Has(setName)
					dataToMerge[languageCode].Set(setName, [])

				Loop rules.Length // 2 {
					local pattern := rules[A_Index * 2 - 1]
					local replace := rules[A_Index * 2]

					dataToMerge[languageCode][setName].Push(VariableParser.Parse(pattern), VariableParser.Parse(replace))
				}
			}
		}

		this.MergeData(GREPTypography.dictionaries, dataToMerge)
		data := unset
		dataToMerge := unset
		return
	}

	MergeData(to, with) {
		for key, value in with {
			if value is Map {
				if !to.Has(key)
					to.Set(key, Map())
				this.MergeData(to[key], value)
			} else if value is Array {
				if !to.Has(key)
					to.Set(key, [])
				for each in value
					to[key].Push(each)
			} else {
				to.Set(key, value)
			}
		}
		return
	}
}