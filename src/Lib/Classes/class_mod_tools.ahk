Class ModTools {
	__New(relativePath := A_LineFile) {
		this.origin := this.GetOrigin(relativePath)
		this.dirName := RegExReplace(this.origin, ".*\\", "")
		this.Cfg := ModTools.__ModTools_Cfg(this.origin)

		return Event.Trigger("Mod", "Registered", this.dirName, this)
	}

	GetOrigin(relativePath) {
		return this.__ExtractOriginPath(relativePath)
	}

	__ExtractOriginPath(filePath) {
		filePath := StrReplace(filePath, "/", "\")

		local modsPos := InStr(filePath, "\Mods\")
		if (modsPos = 0) {
			return A_ScriptDir
		}

		local afterMods := SubStr(filePath, modsPos + 6)

		local nextSeparator := InStr(afterMods, "\")

		if (nextSeparator = 0) {
			modName := RegExReplace(afterMods, "\\.*$", "")
			return SubStr(filePath, 1, modsPos + 5 + StrLen(modName))
		}

		modName := SubStr(afterMods, 1, nextSeparator - 1)
		return SubStr(filePath, 1, modsPos + 5 + StrLen(modName))
	}

	Class __ModTools_Cfg {
		__New(origin) {
			this.origin := origin
			this.ini := this.SettingsPath()
		}

		SettingsPath(relativePath := this.origin) {
			return relativePath "\config.ini"
		}

		Set(value, entry, section := "Settings", options := "", filePath := this.ini) {
			return Cfg.Set(value, entry, section, options, filePath)
		}

		Get(entry, section := "Settings", default := "", options := "", filePath := this.ini) {
			return Cfg.Get(entry, section, default, options, filePath)
		}

		SwitchSet(valuesVariants, entry, section := "Settings", options := "", filePath := this.ini) {
			return Cfg.SwitchSet(valuesVariants, entry, section, options, filePath)
		}
	}
}