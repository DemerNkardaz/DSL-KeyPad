Class BindList {
	mapping := []

	__New(mapping := Map(), modMapping := Map()) {
		this.mapping := mapping.Clone()

		if modMapping.Count > 0 {
			for letterKey, binds in modMapping {
				for modifier, value in binds {
					rule := ""
					if RegExMatch(modifier, ":(.*?)$", &ruleMatch) {
						rule := ":" ruleMatch[1]
						modifier := RegExReplace(modifier, ":(.*?)$", "")
					}
					entryKey := modifier "[" letterKey "]" rule
					this.mapping.Set(entryKey, value)
				}
			}
		}
		return this
	}

	static __New() {
		for key, value in bindingMaps["keyboardDefault"]["Flat"] {
			if Util.IsArray(value) && value.Length == 2 {
				if !bindingMaps["keyboardDefault"]["Moded"].Has(key)
					bindingMaps["keyboardDefault"]["Moded"][key] := Map()

				bindingMaps["keyboardDefault"]["Moded"][key].Set("+", [value[2], value[1]])
			}
		}
	}

	static Get(bindingsName := "common", fromSub := "") {
		mapping := bindingMaps.DeepClone()

		if bindingsName = "common" && mapping.Has(bindingsName) && StrLen(fromSub) == 0 {
			letterI_Option := Cfg.Get("I_Dot_Shift_I_Dotless", "Characters", "Default")

			if letterI_Option = "Separated" {
				mapping["common"]["Moded"]["I"].Set("<+", ["lat_c_let_i", "lat_s_let_i_dotless"])
				mapping["common"]["Flat"].Set("I", ["lat_c_let_i__dot_above", "lat_s_let_i"])
			} else if letterI_Option = "Hybrid" {
				mapping["common"]["Moded"]["I"].Set("<+", ["lat_c_let_i__dot_above", "lat_s_let_i_dotless"])
			}
		}

		if StrLen(fromSub) > 0 && mapping.Has(fromSub) && mapping[fromSub].Has(bindingsName)
			mapping[fromSub][bindingsName] := BindList(mapping[fromSub][bindingsName]["Flat"], mapping[fromSub][bindingsName]["Moded"])
		else if mapping.Has(bindingsName)
			mapping[bindingsName] := BindList(mapping[bindingsName]["Flat"], mapping[bindingsName]["Moded"])

		if bindingsName = "common" && mapping.Has(bindingsName) && StrLen(fromSub) == 0 {
			mapping["diacritic"] := BindList(mapping["diacritic"]["Flat"], mapping["diacritic"]["Moded"])
			mapping["common"].mapping := mapping["common"].mapping.MergeWith(mapping["diacritic"].mapping)
		}

		return (StrLen(fromSub) > 0 && mapping.Has(fromSub) && mapping[fromSub].Has(bindingsName)) ? mapping[fromSub][bindingsName].mapping : mapping.Has(bindingsName) ? mapping[bindingsName].mapping : Map()
	}
}