Class Locale {
	static localeObj := Map()
	static localesPath := A_ScriptDir "\Locale\"

	static __New() {
		this.Fill()
	}

	static Fill() {
		this.localeObj := Map()
		local pathsArray := []

		for lang, value in Language.supported {
			if value.locale {
				local iniPath := App.paths.loc "\locale_" lang ".ini"
				local jsonPath := App.paths.loc "\locale_" lang ".json"

				if FileExist(iniPath)
					pathsArray.Push(App.paths.loc "\locale_" lang ".ini")

				if FileExist(jsonPath)
					pathsArray.Push(App.paths.loc "\locale_" lang ".json")
			}
		}

		Loop Files App.paths.loc "\Automated\*", "FR"
			if A_LoopFileFullPath ~= "i)\.(ini|json)$"
				pathsArray.Push(A_LoopFileFullPath)

		local activeMods := ModsInjector.GetActiveList()

		if activeMods.Length > 0
			for folderName in activeMods
				if DirExist(ModsInjector.modsPath "\" folderName "\Locale")
					Loop Files ModsInjector.modsPath "\" folderName "\Locale\*", "FR"
						if A_LoopFileFullPath ~= "i)\.(ini|json)$" && !(A_LoopFileFullPath ~= "CharacterLegend")
							pathsArray.Push(A_LoopFileFullPath)

		this.localeObj := this.ParseSourceFiles(pathsArray)
		return
	}

	static ParseSourceFiles(pathsArray) {
		local bufferArray := []

		for path in pathsArray {
			if path ~= "i)\.(ini)$"
				bufferArray.Push(Util.INIToMap(path))
			else if path ~= "i)\.(json)$" {
				bufferArray.Push(JSON.LoadFile(path, "UTF-8"))
			}
		}

		return this.MergeLocales(bufferArray*)
	}

	static MergeLocales(maps*) {
		local output := Map()

		for i, mapToMerge in maps {
			if mapToMerge.Count = 0
				continue

			for key, val in mapToMerge {
				if output.Has(key) && output[key] is Map {
					if val is String
						output[key].Set("__self", val)
					else if val is Map
						output[key] := this.MergeLocales(output[key], val)
				} else if output.Has(key) && output[key] is String && val is Map {
					local tempMap := Map()
					tempMap.Set("__self", output[key])
					output[key] := this.MergeLocales(tempMap, val)
				} else {
					output.Set(key, val)
				}
			}
		}
		return output
	}

	static OpenDir(*) {
		Run(this.localesPath)
	}

	static HandleString(str) {
		str := StrReplace(str, "\R2", "`r`n`r`n", True)
		str := StrReplace(str, "\R", "`r`n", True)
		str := StrReplace(str, "\r", "`r", True)
		str := StrReplace(str, "\n", "`n")
		str := StrReplace(str, "\t", "`t")

		return str
	}


	static Read(entryName, inSection := "", validate := False, &output?, strInjections := []) {
		intermediate := ""
		section := Language.Validate(inSection) ? inSection : Language.Get()

		intermediate := this.ReadStr(section, entryName)

		while (RegExMatch(intermediate, "\{@([a-zA-Z-]*)(?::([^\}]+))?\}", &match)) {
			langCode := (match[1] != "" ? match[1] : section)
			customEntry := (match[2] != "" ? match[2] : entryName)
			replacement := this.ReadStr(langCode, customEntry)
			intermediate := StrReplace(intermediate, match[0], replacement)
		}

		while (RegExMatch(intermediate, "\{U\+(.*?)\}", &match)) {
			Unicode := StrSplit(match[1], ",")
			replacement := Util.UnicodeToChars(Unicode*)
			intermediate := StrReplace(intermediate, match[0], replacement)
		}
		while (RegExMatch(intermediate, "(?<!\\)%(.*)%", &match))
			intermediate := StrReplace(intermediate, match[0], VariableParser.Parse(match[0]))

		while (RegExMatch(intermediate, "\{var:([^\}]+)\}", &match)) {
			variableName := match[1]
			parts := StrSplit(variableName, ".")
			ref := %parts[1]%
			if (parts.Length > 1) {
				Loop parts.Length - 1 {
					ref := ref.%parts[A_Index + 1]%
				}
			}
			replacement := ref
			intermediate := StrReplace(intermediate, match[0], replacement)
		}

		intermediate := this.HandleString(intermediate)

		if validate {
			output := intermediate
			return StrLen(intermediate) > 0
		} else {
			intermediate := !IsSpace(intermediate) ? intermediate : "KEY (" entryName "): NOT FOUND in " section
			return strInjections ? Util.StrVarsInject(intermediate, strInjections*) : intermediate
		}
	}


	static ReadStr(section, entry) {
		if RegExMatch(entry, "^(.*?\.)?([^.<]*)<([^>]*)>(.*)$", &multiMatch) {
			local i := 0
			local starter := multiMatch[1]
			local firstKey := starter multiMatch[2]
			local secondKey := starter multiMatch[4]
			local interKey := multiMatch[3]
			local outputString := ""

			for each in [firstKey, interKey, secondKey]
				if each != "" {
					outputString .= (i > 0 ? " " : "") this.ReadStr(section, each)
					i++
				}

			return outputString
		} else if RegExMatch(entry, "\+", &multiMatch) {
			local i := 0
			local split := StrSplit(entry, "+")
			local outputString := ""

			for each in split
				if each != "" {
					outputString .= (i > 0 ? " " : "") this.ReadStr(section, each)
					i++
				}
			return outputString
		}

		local str := this.GetEntry(&section, &entry)
		local output := ""

		if str is String
			return str

		if str is Map && str.Has("__self")
			output := str.Get("__self")

		if str is Array
			output := str.ToString("")

		return output
	}

	static GetEntry(&section, &entry) {
		if RegExMatch(entry, "[.:]") {
			local split := RegExSplit(entry, "[.:]")

			if !this.localeObj.Has(section)
				return ""

			local current := this.localeObj[section]

			for index, key in split {
				if current.HasProp("Has") && current.Has(key) {
					current := current[key]
				} else {
					if this.localeObj.Has(section) && this.localeObj[section].Has(entry)
						return this.localeObj[section][entry]
					return ""
				}
			}
			return current

		} else if this.localeObj.Has(section) && this.localeObj[section].Has(entry) {
			return this.localeObj[section][entry]
		}
		return ""
	}


	static ReadNoLinks(entryName, inSection := "") {
		baseString := this.Read(entryName, inSection)
		result := baseString

		while (RegExMatch(result, "<a [^>]*>(.*?)</a>", &match)) {
			linkText := match[1]
			result := StrReplace(result, match[0], linkText)
		}

		return result
	}

	static ReadInject(entryName, strInjections := [], inSection := "", validate := False) {
		return this.Read(entryName, inSection, validate, , strInjections)
	}

	static ReadMulti(entryNames*) {
		output := ""

		for entryName in entryNames {
			output .= " " this.Read(entryName)
		}

		return output
	}
	static VariantSelect(str, i) {
		output := str
		if (RegExMatch(str, "\$\((.*?)\)", &match)) {
			split := StrSplit(match[1], "|")
			if (i > 0 && i <= split.Length) {
				beforePart := SubStr(str, 1, match.Pos(0) - 1)
				afterPart := SubStr(str, match.Pos(0) + match.Len(0))
				output := beforePart split[i] afterPart
			}
		}
		return output
	}
}