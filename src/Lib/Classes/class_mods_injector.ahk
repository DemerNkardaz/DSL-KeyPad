Class ModsInjector {
	static modsPath := A_ScriptDir "\Mods"
	static registryINI := this.modsPath "\mods.ini"
	static eventListeners := Map()
	static injectors := {
		pre_init: this.modsPath "\injector_pre_init.ahk",
		post_init: this.modsPath "\injector_post_init.ahk"
	}

	static __New() {
		this.Init()
		this.Build()
		SetTimer((*) => SetTimer(this.Watcher.Bind(this), 5000), -15000)

		local modKeys := this.Read()
	}

	static Init() {
		if !DirExist(this.modsPath)
			DirCreate(this.modsPath)

		if !FileExist(this.registryINI)
			FileAppend("[pre_init]`n`n[post_init]`n", this.registryINI, "UTF-16")

		for k, v in this.injectors.OwnProps()
			if !FileExist(v)
				FileAppend("", v, "UTF-8")
	}

	static GetActiveList() {
		local activeList := []
		local modKeys := this.Read()

		for sectionName, sectionData in modKeys {
			for key, value in sectionData.OwnProps() {
				if (value = 1) {
					activeList.Push(key)
				}
			}
		}

		return activeList
	}

	static Read() {
		if !FileExist(this.registryINI)
			FileAppend("[pre_init]`n`n[post_init]`n", this.registryINI, "UTF-16")

		local filePath := this.registryINI

		if !InStr(filePath, ".ini")
			filePath .= ".ini"

		local content := FileRead(filePath, "UTF-16")
		local lines := StrSplit(content, "`n", "`r`n")

		local iniMap := Map()
		local currentSection := ""

		for line in lines {
			local line := Trim(line)
			if (line = "" or SubStr(line, 1, 1) = ";")
				continue

			if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
				currentSection := SubStr(line, 2, -1)
				iniMap.Set(currentSection, {})
			}
			else if (currentSection != "" && InStr(line, "=")) {
				local parts := StrSplit(line, "=", "`t ")
				local key := Trim(parts[1])
				local value := Trim(parts[2])
				iniMap[currentSection].%key% := Number(value)
			}
		}

		return iniMap
	}

	static ReadModManifest(modFolder) {
		local filePath := this.modsPath "\" modFolder "\manifest.json"
		local requiredFields := Map(
			"title", modFolder,
			"version", "",
			"author", "",
			"description", "",
			"type", "pre_init",
			"homepage", "",
			"folder", modFolder
		)

		local output := JSON.LoadFile(filePath, "UTF-8")

		for key, defaultValue in requiredFields
			if !output.Has(key)
				output.Set(key, defaultValue)

		output["status"] := IniRead(this.registryINI, output["type"], modFolder, 1)

		return output
	}

	static Watcher() {
		return this.Build(False)
	}

	static Build(toReload := True) {
		local list := this.Read()
		local listPreInit := list.Has("pre_init") ? list["pre_init"].ObjKeys() : []
		local listPostInit := list.Has("post_init") ? list["post_init"].ObjKeys() : []
		local handling := Map("pre_init", [], "post_init", [])
		local hasDifference := False

		local preScriptContent := FileRead(this.injectors.pre_init, "UTF-8")
		local postScriptContent := FileRead(this.injectors.post_init, "UTF-8")

		local scriptContents := Map("pre_init", preScriptContent, "post_init", postScriptContent)

		for section, content in scriptContents {
			if list.Has(section) {
				for fileName, value in list[section].OwnProps() {
					local hasInclude := InStr(content, "#Include *i " fileName "\index.ahk")
					if (value = 0 && hasInclude) {
						hasDifference := True
						break
					}
					if (value = 1 && !hasInclude) {
						hasDifference := True
						break
					}
				}
			}
			if hasDifference
				break
		}

		Loop Files this.modsPath "\*", "FR" {
			if RegExMatch(A_LoopFileFullPath, "\\Mods\\(.*)\\(index.ahk)", &match) {
				local manifest := this.ReadModManifest(match[1])
				local typeInit := manifest["type"]
				local title := manifest["title"] " " manifest["version"]

				if (title = " ")
					title := match[1]

				if !(typeInit ~= "^(pre_init|post_init)$") {
					MsgBox("The value “" typeInit "” of “type” in modification “" title "” is not allowed.`n`nAllowed values: pre_init, post_init", , "Iconx")
					continue
				}

				handling[typeInit].Push(match[1])
			}
		}

		for section in ["pre_init", "post_init"] {
			local filesInFolder := handling[section]
			local filesInINI := list.Has(section) ? list[section].ObjKeys() : []

			for fileName in filesInFolder {
				if !filesInINI.HasValue(fileName) {
					hasDifference := True
					break
				}
			}

			if !hasDifference {
				for fileName in filesInINI {
					if !filesInFolder.HasValue(fileName) {
						hasDifference := True
						break
					}
				}
			}

			if hasDifference
				break
		}

		if hasDifference {
			try {
				local output := ""

				for section, files in handling {
					output .= "[" section "]`n"

					for fileName in files {
						local value := (list.Has(section) && list[section].HasOwnProp(fileName)) ? list[section].%fileName% : 1
						output .= fileName "=" value "`n"
					}
					output .= "`n"
				}

				FileDelete(this.registryINI)
				FileAppend(output, this.registryINI, "UTF-16")

				local newList := this.Read()

				for name, path in this.injectors.OwnProps() {
					local content := ""

					if newList.Has(name) {
						for key, value in newList[name].OwnProps() {
							if value > 0
								content .= "#Include *i " key "\index.ahk" "`n"
						}
					}

					FileDelete(path)
					FileAppend(content, path, "UTF-8")
				}

				if toReload
					Reload
			}
		}
	}
}

OnModSettingsChange(modPath, callback) {

	if !ModsInjector.eventListeners.Has(modPath)
		ModsInjector.eventListeners[modPath] := callback
	else
		throw Error("Handler already registered for this mod: " modPath)
}

TriggerModSettingsEvent(modPath) {
	if handler := ModsInjector.eventListeners.Get(modPath, (*) => [])
		handler.Call(modPath)
	else
		throw Error("No handler registered for mod: " modPath)
}