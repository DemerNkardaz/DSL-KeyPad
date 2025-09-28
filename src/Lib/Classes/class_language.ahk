Class Language {
	static optionsFile := App.paths.loc "\locale.options.ini"
	static supported := Map()
	static links := Map()

	static __New() {
		this.Init()
	}

	static Init() {
		languages := Util.INIGetSections([this.optionsFile])

		for i, iso in languages {
			data := {
				parent: IniRead(this.optionsFile, iso, "parent", ""),
				title: IniRead(this.optionsFile, iso, "title", ""),
				code: IniRead(this.optionsFile, iso, "code", ""),
				locale: IniRead(this.optionsFile, iso, "is_locale", False),
				bindings: IniRead(this.optionsFile, iso, "is_bindings", False),
				altInput: IniRead(this.optionsFile, iso, "alt_input", ""),
				index: i,
			}

			data.code := data.code != "" ? Number(data.code) : ""
			data.locale := data.locale = "True" ? True : False
			data.bindings := data.bindings = "True" ? True : False

			this.supported.Set(iso, data)
			if data.code != ""
				this.links.Set(data.code, iso)
		}
	}

	static GetSupported(by := "locale", get := "key", useIndex := False) {
		output := useIndex ? Map() : []

		for key, value in this.supported
			if value.%by% && !(value.code is String)
				if useIndex
					output.Set(value.index, get = "key" ? key : value.title)
				else
					output.Push(get = "key" ? key : value.title)

		return useIndex ? output.Values() : output
	}

	static Validate(input, extraRule?) {
		if input is Number && this.links.Has(input)
			input := this.links.Get(input)

		if input is String && input != "" {
			extraRuleValidate := (!IsSet(extraRule) || IsSet(extraRule) && (HasProp(this.supported[input], extraRule) ? this.supported[input].%extraRule% : False))

			if this.supported.Has(input) && extraRuleValidate
				return True
		}

		return False
	}

	static Set(value) {
		if this.Validate(value, "locale") {
			Cfg.Set(value, "User_Language")
		}
	}

	static Get(language := "", getTitle := False, endLen := 0) {
		local userLanguage := language != "" ? language : Cfg.Get("User_Language")
		userLanguage := !IsSpace(userLanguage) ? userLanguage : this.GetSys()

		if this.Validate(userLanguage) {
			return getTitle ? this.supported.Get(userLanguage).title : endLen > 0 ? SubStr(userLanguage, 1, endLen) : userLanguage
		} else {
			return getTitle ? this.supported.Get("en-US").title : endLen > 0 ? SubStr("en-US", 1, endLen) : "en-US"
		}
	}

	static GetLanguageBlock(input, &output?) {
		output := False
		if input is Number && this.links.Has(input)
			input := this.links.Get(input)

		if input is String && input != ""
			if this.supported.Has(input)
				output := [input, this.supported.Get(input)]

		return output
	}

	static GetSys(endLen := 0) {
		regVal := RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName")
		return endLen > 0 ? SubStr(RegRead("HKEY_CURRENT_USER\Control Panel\International", "LocaleName"), 1, endLen) : regVal
	}
}