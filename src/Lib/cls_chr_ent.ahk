Class ChrEntry {
	data {
		get {
			return {
				index: 0,
				proxy: "",
				unicode: "",
				unicodeBlock: "",
				sequence: [],
				result: [],
				entity: "",
				altCode: "",
				altCodePages: [],
				LaTeX: [],
				LaTeXPackage: "",
				titles: Map(),
				tags: [],
				groups: [],
				alterations: {},
				options: {
					noCalc: False,
					suggestionsAtEnd: False,
					secondName: False,
					useLetterLocale: False,
					layoutTitles: False,
					referenceLocale: "",
					useSelfPrefixesOnReferenceLocale: True,
					localeCombineAnd: False,
					legend: "",
					altLayoutKey: "",
					showOnAlt: "",
					altSpecialKey: "",
					fastKey: "",
					specialKey: "",
					numericValue: 0,
					send: "",
				},
				recipe: [],
				recipeAlt: [],
				symbol: {
					category: "",
					letter: "",
					afterLetter: "",
					beforeLetter: "",
					scriptAdditive: "",
					tagAdditive: [],
					set: "",
					alt: "",
					customs: "",
					font: "",
				},
				data: { script: "", case: "", type: "", letter: "", endPart: "", postfixes: [] },
				variant: "",
				variantPos: 1,
				isXCompose: False,
			}
		}
	}

	__New() {

	}

	Get(attributes := {}) {
		local root := this.data
		attributes := this.Proxying(&root, &attributes)

		for key, value in attributes.OwnProps() {
			if value is Array {
				root.%key% := []
				root.%key% := value.Clone()
			} else if value is Map {
				root.%key% := value.Clone()
			} else if value is Object {
				if !root.HasOwnProp(key)
					root.%key% := {}
				for subKey, subValue in value.OwnProps() {
					root.%key%.%subKey% := subValue
				}
			} else {
				root.%key% := value
			}
		}

		if StrLen(root.proxy) > 0
			root.options.noCalc := True

		return root
	}

	Proxying(&root, &attributes) {
		if attributes.HasOwnProp("proxy") && StrLen(attributes.proxy) > 0 {
			local proxyName := attributes.proxy
			local proxyEntry := ChrLib.GetEntry(proxyName)

			if !proxyEntry
				return attributes


			local blacklist := ["groups", "options", "recipe", "recipeAlt", "symbol", "data", "titles", "tags"]

			for key, value in proxyEntry.OwnProps() {
				if blacklist.Has(key) && attributes.HasOwnProp(key)
					continue

				if value is Array {
					root.%key% := value.Clone()
				} else if value is Map {
					root.%key% := value.Clone()
				} else if value is Object {
					root.%key% := {}
					for subKey, subValue in value.OwnProps() {
						root.%key%.%subKey% := subValue
					}
				} else {
					root.%key% := value
				}
			}

			for key, value in attributes.OwnProps() {
				if value is Array {
					root.%key% := value.Clone()
				} else if value is Map && root.Has(key) {
					for subKey, subValue in value
						root.%key%.Set(subKey, subValue)
				} else if value is Object && root.HasOwnProp(key) {
					for subKey, subValue in value.OwnProps() {
						root.%key%.%subKey% := subValue
					}
				} else {
					root.%key% := value
				}
			}

			return root
		}

		return attributes
	}

	__Delete() {
		; DllCall("GlobalFree", "Ptr", this.memAdress)
		ClassClear(this)
	}
}