Class KbdMonitor {
	static disabledBy := False

	static __New() {
		SetTimer((*) => this.Check(), 1000)
		return
	}

	static Disabled(by := "") {
		return by != "" && this.disabledBy is String && this.disabledBy = by ? True : this.disabledBy is String ? this.disabledBy : False
	}

	static Check() {
		if A_IsPaused
			return

		layoutHex := Keyboard.CurrentLayout()
		langBlock := Language.GetLanguageBlock(layoutHex)

		Keyboard.activeLanguage := langBlock ? langBlock[1] : "0x" Format("{:X}", layoutHex)

		local isLanguageLayoutValid := Language.Validate(layoutHex, "bindings")
		local disableTimer := Cfg.Get("Binds_Autodisable_Timer", , 1, "int")
		local disableType := Cfg.Get("Binds_Autodisable_Type", , "hour")
		try {
			disableType := %disableType%
		} catch {
			disableType := hour
		}

		this.Toggle(isLanguageLayoutValid && A_TimeIdle <= disableTimer * disableType)

		if (!this.Disabled()) && isLanguageLayoutValid
			&& Cfg.Get("Alt_Input_Autoactivation", , False, "bool")
			&& langBlock {

			if !["^en", "^ru", "^vi"].HasRegEx(langBlock[1])
				&& Scripter.selectedMode.Get("Alternative Modes") = ""
				&& !TelexScriptProcessor.GetActiveMode()
				&& langBlock[2].altInput != ""
				&& Scripter.Has(langBlock[2].altInput) {
				Scripter.activatedViaMonitor := True
				Scripter.ToggleSelectedOption(langBlock[2].altInput)
			} else if Scripter.activatedViaMonitor
				&& langBlock[2].altInput = "" {
				Scripter.activatedViaMonitor := False
				Scripter.ToggleSelectedOption(Scripter.selectedMode.Get("Alternative Modes"))
			}
		}

		TrayMenu.TrayIconSwitch()
	}

	static Toggle(enable := True, rule := "Monitor") {
		if A_IsPaused
			return

		local wasDisabled := this.Disabled()
		local currentRule := this.disabledBy

		if (currentRule is String) && (currentRule != rule)
			return

		if enable {
			this.disabledBy := False
		} else {
			this.disabledBy := rule
		}

		local isDisabled := this.Disabled()
		local stateChanged := (wasDisabled != False) != (isDisabled != False)

		if stateChanged {
			Suspend(isDisabled ? 1 : 0)
			TrayMenu.SetTray()
		}

		return True
	}
}