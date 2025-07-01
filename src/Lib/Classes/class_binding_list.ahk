Class BindList {
	mapping := Map()

	__New(mapping := Map(), modMapping := Map()) {
		KeyboardBinder.CurrentLayouts(&latinLayout, &cyrillicLayout, &hellenicLayout)
		local useRemap := Cfg.Get("Layout_Remapping", , False, "bool")

		this.mapping := mapping.Clone()

		if modMapping.Count > 0 {
			for letterKey, binds in modMapping {
				if binds.Has("SwitchLayout") && binds.Get("SwitchLayout") {
					set := binds.Get("Default")
					for each in [latinLayout, cyrillicLayout, hellenicLayout] {
						if binds.Has(each) {
							set := binds.Get(each)
							break
						}
					}
					binds := set
					modMapping.Set(letterKey, set)
				}

				if binds is Object && !(binds is Map || binds is Array || binds is Func)
					&& binds.HasOwnProp("Get") {
					blacklist := binds.HasOwnProp("blacklist") ? binds.blacklist : []
					binds := binds.Get()

					if blacklist.Length > 0 {
						for modifier in blacklist {
							if binds.Has(modifier) {
								binds.Delete(modifier)
							}
						}
					}
				}

				for modifier, value in binds {
					if RegExMatch(modifier, "^\[lazy\](.+)$", &lazyMatch) {
						binds.Delete(modifier)
						if !useRemap
							continue
						if binds.Has(lazyMatch[1])
							binds.Delete(lazyMatch[1])
						modifier := lazyMatch[1]
					}

					if value is Object && !(value is Map || value is Array || value is Func)
						&& value.HasOwnProp("Get") {
						value := value.Get()
					}

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

		if this.mapping.Count > 0 {
			for letterKey, bind in this.mapping {
				if RegExMatch(letterKey, "^\[lazy\](.+)$", &lazyMatch) {
					if this.mapping.Has(lazyMatch[1])
						this.mapping.Delete(lazyMatch[1])
					this.mapping.Delete(letterKey)
					letterKey := lazyMatch[1]
					if useRemap
						this.mapping.Set(letterKey, bind)
				}
			}
		}


		return this
	}

	static __New() {
		for key, value in BindReg.Get("Keyboard Default", , &bindings)["Flat"] {
			if value is Array && value.Length == 2 {
				if !bindings["Moded"].Has(key)
					bindings["Moded"][key] := Map()
				bindings["Moded"][key].Set("+", [value[2], value[1]])
			}
		}
	}

	static Get(bindingsName := "Common", fromSub := "", mapping := Map()) {
		if mapping.Count == 0
			mapping := BindReg.storedData.DeepClone()

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
					for key, value in mapping[fromSub][bindingsName]["Flat"] {
						if !InStr(key, ":") {
							valB := value
							mapping[fromSub][bindingsName]["Flat"].Delete(key)
							mapping[fromSub][bindingsName]["Flat"].Set(key ":Caps", valB)
						}
					}

					for parent, bindKey in mapping[fromSub][bindingsName]["Moded"] {
						for key, value in bindKey {
							if !InStr(key, ":") {
								valB := value
								mapping[fromSub][bindingsName]["Moded"][parent].Delete(key)
								mapping[fromSub][bindingsName]["Moded"][parent].Set(key ":Caps", valB)
							}
						}
					}

					for i, keyName in keyNamesArray {
						if mapping[fromSub][bindingsName]["Flat"].Has(keyName) {
							otherI := (i = 1) ? 2 : 1
							otherKeyName := keyNamesArray[otherI]


						} else if mapping[fromSub][bindingsName]["Moded"].Has(keyName) {
							otherI := (i = 1) ? 2 : 1
							otherKeyName := keyNamesArray[otherI]

							; mapping[fromSub][bindingsName]["Moded"].Set(otherKeyName, mapping[fromSub][bindingsName]["Moded"].Get(keyName))
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

	static Gets(bindingsNames := [], fromSub := "", mapping := BindReg.storedData.DeepClone()) {
		local interArray := []

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
			output := output.DeepMergeBinds(inter)
		}

		return output
	}
}