Class BindingUserDefined {
	static storedData := Map()

	static __New() {
		BindingUserDefined()
		return
	}

	__New() {
		this.Reg()
		return
	}

	Reg() {
		handled := []

		Loop Files App.PATHS.BINDS "\*.json" {
			local data := JSON.LoadFile(A_LoopFileFullPath, "UTF-8")
			if !data.Has("info") || !data.Has("binds")
				|| (!data["info"].Has("name") || data["info"].Get("name") = "") {
				data := unset
				MsgBox("Invalid bindings file: " A_LoopFileFullPath)
				continue
			}

			local name := data["info"].Get("name")

			if !handled.HasValue(name)
				handled.Push(name)
			this.UserBindsHandler(data["binds"], name)

		}

		BindReg.userBindings := handled

		currentBindings := Cfg.Get("Active_User_Bindings", , "None")
		if !BindReg.userBindings.HasValue(currentBindings) && currentBindings != "None" {
			Cfg.Set("None", "Active_User_Bindings")
		}
	}

	UserBindsHandler(bindsMap := Map(), name := "") {
		if bindsMap.Count > 0 && StrLen(name) > 0 {
			interMap := Map("Flat", Map(), "Moded", Map())

			for combo, reference in bindsMap {
				Util.StrBind(combo, &keyRef, &modRef, &rulRef)
				interRef := reference

				if reference is Array
					interRef := reference

				if StrLen(modRef) > 0 {
					if !interMap["Moded"].Has(keyRef) {
						interMap["Moded"][keyRef] := Map()
					}
					interMap["Moded"][keyRef].Set(modRef rulRef, interRef)
				} else {
					interMap["Flat"].Set(keyRef rulRef, interRef)
				}
			}

			BindReg.Set(name, "User", interMap)
		}
	}

	static Update() {
		BindingUserDefined()
		return
	}
}