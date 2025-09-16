Class ModTools {
	__New(relativePath := A_LineFile) {
		this.origin := this.GetOrigin(relativePath)
		this.dirName := RegExReplace(this.origin, ".*\\", "")

		this.paths := {
			data: this.origin "\Data",
			locale: this.origin "\Locale",
			lib: this.origin "\Lib",
			resources: this.origin "\Resources",
		}

		this.config := ModTools.__ModTools_Cfg(this.origin)

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

	static FormatManifest(data, locales) {
		local replaceNewLines := (str) => StrReplace(str, "`n", "\n")

		for key, value in data {
			if value is String
				data[key] := replaceNewLines(value)
			else if value is Map
				for subKey, subValue in value
					if subValue is String
						data[key][subKey] := replaceNewLines(subValue)
		}

		local manifest := Format((
			'`t"title": "{}",`r`n'
			'`t"version": "{}",`r`n'
			'`t"type": "{}",`r`n'
			'`t"description": "{}",`r`n'
			'`t"author": "{}",`r`n'
			'`t"homepage": "{}"'
		), data.Get("title", ""), data.Get("version", ""), data.Get("type", ""),
			data.Get("description", ""), data.Get("author", ""), data.Get("homepage", ""))

		if IsSet(locales) && locales is Map && locales.Count > 0 {
			local localeKeysOrder := ["title", "version", "author", "description", "homepage"]
			local localeEntries := []

			for languageCode, localeKeys in locales {
				local keyEntries := []
				for eachKey in localeKeysOrder {
					if localeKeys.Has(eachKey) {
						keyEntries.Push(Format('`t`t"{}": "{}"', eachKey, localeKeys[eachKey]))
					}
				}

				if keyEntries.Length > 0 {
					local localeBlock := Format('`t"{}": {`r`n{}`r`n`t}',
						languageCode, keyEntries.ToString(",`r`n"))
					localeEntries.Push(localeBlock)
				}
			}

			if localeEntries.Length > 0 {
				manifest .= ",`r`n" localeEntries.ToString(",`r`n")
			}
		}

		return Format('{`r`n{}`r`n}', manifest)
	}

	static CreateManifest(data, locales) {
		local filePath := App.paths.mods "\" data["folder"] "\manifest.json"
		if !FileExist(filePath) {
			local manifest := this.FormatManifest(data, locales)
			FileAppend(manifest, filePath, "UTF-8")
		}
	}

	static FormatIndexFile(data) {
		local indexCode := Format((
			'Class Mod__{} {`r`n'
			'`tstatic tools := ModTools(A_LineFile)`r`n`r`n'
			'`tstatic __New() {`r`n'
			'`t}'
			'`r`n}'
		), RegExReplace(data.Get("folder"), "\s", ""))

		return indexCode
	}

	static CreateIndexFile(data) {
		local filePath := App.paths.mods "\" data["folder"] "\index.ahk"
		if !FileExist(filePath) {
			local indexCode := this.FormatIndexFile(data)
			FileAppend(indexCode, filePath, "UTF-8")
		}
		return
	}

	static CreateMod(data := Map("folder", "My Mod", "title", "My Mod", "version", "1.0.0", "author", "", "description", "", "type", "pre_init", "homepage", ""), locales := Map()) {
		local modPath := App.paths.mods "\" data["folder"]
		local defaultPaths := [modPath, modPath "\Data", modPath "\Locale", modPath "\Lib", modPath "\Resources"]

		for path in defaultPaths
			if !DirExist(path)
				DirCreate(path)

		this.CreateManifest(data, locales)
		this.CreateIndexFile(data)

		return
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

; ModTools.CreateMod(Map("folder", "My Mod", "title", "My Mod", "version", "1.0.0", "author", "Mod’s author", "description", "My Mod’s description", "type", "pre_init", "homepage", ""), Map(
; 	"ru-RU", Map(
; 		"title", "Мой Мод",
; 		"author", "Автор Мода",
; 		"description", "Описание моего мода"
; 	),
; 	"ja-JP", Map(
; 		"title", "私のモッド",
; 		"author", "モッドの作者",
; 		"description", "私のモッドの説明"
; 	)
; ))
