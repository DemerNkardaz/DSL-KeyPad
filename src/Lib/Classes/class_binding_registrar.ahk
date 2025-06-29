Class BindReg {
	static storedData := Map()

	static __New() {
		this.storedData := JSON.LoadFile(dataDir "\binds.json", "UTF-8")["entries"]
	}

	__New(source*) {
		this.Merge(source*)
	}

	Merge(source*) {
		this.MergeInto(BindReg.storedData, source*)
	}

	MergeInto(targetMap, maps*) {
		for i, mapToMerge in maps {
			if mapToMerge.Count = 0
				continue
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
}