Class KbdLayoutUserDefined {
	static __New() {
		KbdLayoutUserDefined()
		return
	}

	layoutNames := Map("latin", [], "cyrillic", [], "hellenic", [])

	__New() {
		this.Reg()
		return
	}

	Reg() {
		handled := Map("latin", [], "cyrillic", [], "hellenic", [])

		Loop Files App.PATHS.LAYOUTS "\*.json" {
			local data := JSON.LoadFile(A_LoopFileFullPath, "UTF-8")

			if !data.Has("info") || !data.Has("keys")
				|| (!data["info"].Has("name") || data["info"].Get("name") = "")
				|| (!data["info"].Has("type") || data["info"].Get("type") = "") {
				data := unset
				MsgBox("Invalid layout file: " A_LoopFileFullPath)
				continue
			}

			local scriptName := data["info"].Get("name")
			local scriptType := data["info"].Get("type")
			if handled[scriptType].HasValue(scriptName)
				continue
			local layoutBase := KbdLayout(scriptType).layout
			local outputLayout := Map("keys", Map())


			for key, value in data["keys"]
				outputLayout["keys"][key] := RegExMatch(value, "i)^SC[0-9A-F]{3}$") ? value : layoutBase[value]

			KbdLayoutReg(scriptType, scriptName, outputLayout["keys"])
			handled[scriptType].Push(scriptName)

			if data.Has("binds")
				BindReg.Set(scriptName, "Layout Specified", data["binds"])
		}

		this.layoutNames := handled

		for script in handled.Keys() {
			for k, v in KbdLayoutReg.storedData[script] {
				if KbdLayoutReg.layoutNames[script].HasValue(k)
					continue
				if !this.layoutNames[script].HasValue(k)
					KbdLayoutReg.storedData[script].Delete(k)
			}
		}

		return
	}

	static Update() {
		KbdLayoutUserDefined()
		return Event.Trigger("Layouts Storage", "Updated")
	}
}