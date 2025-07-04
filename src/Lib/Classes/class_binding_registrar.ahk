Class BindReg {
	static storedData := Map()
	static userBindings := []

	static __New() {
		this.storedData := JSON.LoadFile(dataDir "\binds.json", "UTF-8")["entries"]
	}

	static Get(name, inRoot := "", &varReference := Map()) {
		if (inRoot != "")
			varReference := this.storedData[inRoot][name]
		else
			varReference := this.storedData[name]
		return varReference
	}

	static Set(name, inRoot := "", value := Map()) {
		if (inRoot != "")
			this.storedData[inRoot].Set(name, value)
		else
			this.storedData.Set(name, value)
	}

	static Has(name, inRoot := "") {
		if (inRoot != "")
			return this.storedData[inRoot].Has(name)
		else
			return this.storedData.Has(name)
	}

	__New(source*) {
		this.Merge(source*)
		return Event.Trigger("Binding Storage", "Item Registered")
	}

	Merge(source*) {
		this.MergeInto(BindReg.storedData, source*)
		return
	}

	MergeInto(targetMap, maps*) {
		for i, mapToMerge in maps {
			if mapToMerge.Count = 0
				continue

			; local prehandlerMap := this.RecursiveBreaksHandler(mapToMerge)

			for newKey, newVal in mapToMerge {
				local newKeyBase := RegExMatch(newKey, "^([^:]+)", &baseMatch) ? baseMatch[1] : newKey

				local keyToRemove := ""
				for existingKey in targetMap {
					local existingKeyBase := RegExMatch(existingKey, "^([^:]+)", &existingBaseMatch) ? existingBaseMatch[1] : existingKey

					if (existingKeyBase = newKeyBase) {
						if (InStr(newKey, ":") > 0) {
							keyToRemove := existingKey
							break
						}
					}
				}

				if (keyToRemove != "")
					targetMap.Delete(keyToRemove)

				if targetMap.Has(newKey) && targetMap[newKey] is Map && newVal is Map
					this.MergeInto(targetMap[newKey], newVal)
				else
					targetMap.Set(newKey, newVal)
			}
		}
	}

	; RecursiveBreaksHandler(targetMap) {
	; 	local result := Map()
	; 	for key, value in targetMap {
	; 		if value is String && value ~= "[`r`n`t]"
	; 			result[key] := MyRecipes.FormatResult(value)
	; 		else if value is Array {
	; 			local arr := []
	; 			for _, item in value {
	; 				if item is String && item ~= "[`r`n`t]"
	; 					arr.Push(MyRecipes.FormatResult(item))
	; 				else if item is Map || item is Array
	; 					arr.Push(this.RecursiveBreaksHandler(item))
	; 				else
	; 					arr.Push(item)
	; 			}
	; 			result[key] := arr
	; 		}
	; 		else if value is Map
	; 			result[key] := this.RecursiveBreaksHandler(value)
	; 		else
	; 			result[key] := value
	; 	}
	; 	return result
	; }

}