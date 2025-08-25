Class ChrLegendStore {
	static storedData := Map()
	static storedGroups := Map()

	static __New() {
		this.Fill()
		return
	}

	static Fill() {
		local pathsArray := []

		Loop Files App.paths.loc "\CharacterLegend\*", "FR"
			if A_LoopFileFullPath ~= "i)\.(ini|json)$"
				pathsArray.Push(A_LoopFileFullPath)

		local activeMods := ModsInjector.GetActiveList()

		if activeMods.Length > 0
			for folderName in activeMods
				if DirExist(ModsInjector.modsPath "\" folderName "\Locale") && DirExist(ModsInjector.modsPath "\" folderName "\Locale\CharacterLegend")
					Loop Files ModsInjector.modsPath "\" folderName "\Locale\*", "FR"
						if A_LoopFileFullPath ~= "i)\.(ini|json)$" && A_LoopFileFullPath ~= "CharacterLegend"
							pathsArray.Push(A_LoopFileFullPath)

		this.storedData := this.ProcessSources(pathsArray*)
		return
	}

	static ProcessSources(sourcesPaths*) {
		local bufferArray := []
		for path in sourcesPaths {
			SplitPath(path, , , &fileExt, &fileName)
			local data := fileExt = "json" ? JSON.LoadFile(path, "UTF-8") : Util.INIToMap(path)
			bufferArray.Push(Map(fileName, data))

			if data.Has("legend") && data["legend"].Has("group") {
				if !this.storedGroups.Has(data["legend"]["group"])
					this.storedGroups.Set(data["legend"]["group"], [])

				this.storedGroups[data["legend"]["group"]].Push(fileName)
			}

			if ChrLib.entries.HasOwnProp(fileName)
				ChrLib.entries.%fileName%["options"]["legend"] := True
		}

		return this.MergeLegends(bufferArray*)
	}

	static MergeLegends(maps*) {
		local output := Map()

		for i, mapToMerge in maps {
			if mapToMerge.Count = 0
				continue

			for key, val in mapToMerge {
				if output.Has(key) && output[key] is Map && val is Map
					output[key] := this.MergeLegends(output[key], val)
				else if val is String {
					local intermediate := val
					while (RegExMatch(intermediate, "(?<!\\)%\[(.*)\]%", &match))
						intermediate := StrReplace(intermediate, match[0], VariableParser.Parse(match[0]))
				} else
					output.Set(key, val)
			}
		}
		return output
	}

	static Keys() {
		return this.storedData.Keys()
	}
}