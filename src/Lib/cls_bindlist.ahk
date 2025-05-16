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
		for key, value in bindingMaps["Keyboard Default"]["Flat"] {
			if value is Array && value.Length == 2 {
				if !bindingMaps["Keyboard Default"]["Moded"].Has(key)
					bindingMaps["Keyboard Default"]["Moded"][key] := Map()

				bindingMaps["Keyboard Default"]["Moded"][key].Set("+", [value[2], value[1]])
			}
		}
	}

	static Get(bindingsName := "Common", fromSub := "", mapping := Map()) {
		if mapping.Count == 0
			mapping := bindingMaps.DeepClone()

		if bindingsName = "Common" && mapping.Has(bindingsName) && StrLen(fromSub) == 0 {
			letterI_Option := Cfg.Get("I_Dot_Shift_I_Dotless", "Characters", "Default")

			if letterI_Option = "Separated" {
				mapping["Common"]["Moded"]["I"].Set("<+", ["lat_c_let_i", "lat_s_let_i_dotless"])
				mapping["Common"]["Flat"].Set("I", ["lat_c_let_i__dot_above", "lat_s_let_i"])
			} else if letterI_Option = "Hybrid" {
				mapping["Common"]["Moded"]["I"].Set("<+", ["lat_c_let_i__dot_above", "lat_s_let_i_dotless"])
			}
		}

		if (fromSub = "Script Specified"
			&& mapping.Has(fromSub)
			&& mapping[fromSub].Has(bindingsName)
			&& mapping[fromSub][bindingsName].Has("ForceSingle")
			&& mapping[fromSub][bindingsName].Get("ForceSingle")) {
			layout := KeyboardBinder.GetCurrentLayoutMap()

			for scanCode, keyNamesArray in layout {
				if keyNamesArray.Length = 2 {
					for i, keyName in keyNamesArray {
						if mapping[fromSub][bindingsName]["Flat"].Has(keyName) {
							otherI := (i = 1) ? 2 : 1
							otherKeyName := keyNamesArray[otherI]

							mapping[fromSub][bindingsName]["Flat"].Set(otherKeyName, mapping[fromSub][bindingsName]["Flat"].Get(keyName))

						} else if mapping[fromSub][bindingsName]["Moded"].Has(keyName) {
							otherI := (i = 1) ? 2 : 1
							otherKeyName := keyNamesArray[otherI]

							mapping[fromSub][bindingsName]["Moded"].Set(otherKeyName, mapping[fromSub][bindingsName]["Moded"].Get(keyName))
						}
					}
				}
			}

			mapping[fromSub][bindingsName].Delete("ForceSingle")
		}

		if StrLen(fromSub) > 0 && mapping.Has(fromSub) && mapping[fromSub].Has(bindingsName)
			mapping[fromSub][bindingsName] := BindList(mapping[fromSub][bindingsName]["Flat"], mapping[fromSub][bindingsName]["Moded"])
		else if mapping.Has(bindingsName)
			mapping[bindingsName] := BindList(mapping[bindingsName]["Flat"], mapping[bindingsName]["Moded"])

		if bindingsName = "Common" && mapping.Has(bindingsName) && StrLen(fromSub) == 0 {
			mapping["Diacritic"] := BindList(mapping["Diacritic"]["Flat"], mapping["Diacritic"]["Moded"])
			mapping["Common"].mapping := mapping["Common"].mapping.MergeWith(mapping["Diacritic"].mapping)
		}

		return (StrLen(fromSub) > 0 && mapping.Has(fromSub) && mapping[fromSub].Has(bindingsName)) ? mapping[fromSub][bindingsName].mapping : mapping.Has(bindingsName) ? mapping[bindingsName].mapping : Map()
	}

	static Gets(bindingsNames := [], fromSub := "", mapping := bindingMaps.DeepClone()) {
		interArray := []
		for bindingsName in bindingsNames {
			if bindingsName = ""
				continue

			if InStr(bindingsName, ":") {
				currentName := RegExReplace(bindingsName, ":(.*?)$", "")
				currentFromSub := RegExReplace(bindingsName, "(.*?):", "")
				interArray.Push(BindList.Get(currentName, currentFromSub, mapping))
			} else
				interArray.Push(BindList.Get(bindingsName, fromSub, mapping))
		}

		output := interArray[1]

		for i, inter in interArray {
			if i = 1
				continue
			output := output.DeepMergeWith(inter)
		}

		return output
	}
}