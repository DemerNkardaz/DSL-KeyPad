Class KbdLayoutReg {
	static storedData := Map()
	static layoutTypes := ["latin", "cyrillic", "hellenic"]
	static layoutNames := Map("latin", [], "cyrillic", [], "hellenic", [])

	static __New() {
		for each in this.layoutTypes {
			this.storedData.Set(each, Map())
			local data := JSON.LoadFile(App.paths.data "\keyboard_layouts_" each ".json", "UTF-8")

			for item, keys in data {
				this.layoutNames[each].Push(item)
				KbdLayoutReg(each, item, KbdLayout(each, keys).layout)
				if keys.Has("binds")
					BindReg.Set(item, "Layout Specified", keys["binds"])
			}

			data := unset
		}
		return
	}

	static Get(targetType, layoutName) {
		return this.storedData[targetType].Get(layoutName)
	}

	static Check(targetType, layoutName) {
		return this.storedData[targetType].Has(layoutName)
	}

	__New(targetType, layoutName, source*) {
		this.targetType := targetType
		this.script := layoutName
		this.Merge(source*)
	}

	Merge(source*) {
		if !KbdLayoutReg.storedData.Has(this.targetType)
			KbdLayoutReg.storedData.Set(this.targetType, Map())
		if !KbdLayoutReg.storedData[this.targetType].Has(this.script)
			KbdLayoutReg.storedData[this.targetType].Set(this.script, Map())

		this.MergeInto(KbdLayoutReg.storedData[this.targetType][this.script], source*)
	}

	MergeInto(targetMap, maps*) {
		for i, mapToMerge in maps {
			if (mapToMerge.Count = 0)
				continue

			for newKey, newVal in mapToMerge {
				if (targetMap.Has(newKey) && targetMap[newKey] is Map && newVal is Map) {
					this.MergeInto(targetMap[newKey], newVal)
				} else {
					targetMap.Set(newKey, newVal)
				}
			}
		}
	}
}