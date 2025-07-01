Class KbdLayout {
	layout := Map()

	__New(base, layoutData := Map("keys", Map()), path?) {
		local defaultMappingData := JSON.LoadFile(App.paths.data "\keyboard_default_mapping.json", "UTF-8")
		local targetLayoutData := IsSet(path) ? JSON.LoadFile(path, "UTF-8") : layoutData
		this.layout := Map()

		for key, scanCode in defaultMappingData["default"]
			this.layout.Set(key, scanCode)

		for key, scanCode in defaultMappingData[base]
			this.layout.Set(key, scanCode)

		if targetLayoutData["keys"].Count > 0 {
			for key, scanCode in targetLayoutData["keys"] {
				for subKey, subScanCode in this.layout
					if subScanCode = scanCode
						this.layout.Delete(subKey)

				this.layout.Set(key, scanCode)
			}
		}

		defaultMappingData := unset
		targetLayoutData := unset
		return this
	}
}