Class ChrBlock {
	langToLocale := [
		"en", "latin",
		"ru", "cyrillic",
		"el", "greek",
		"vi", "vietnamese",
	]

	GetBlock(input := "0000", isFor := "Unicode", &outputVar := { block: "Unknown", name: "Unknown" }) {
		if input = ""
			return
		if isFor = "Unicode" {
			for block, name in characters.blocksData["Unicode"] {
				split := StrSplit(block, "...")
				startBlockNum := Number("0x" split[1])
				endBlockNum := Number("0x" split[2])
				inputNum := Number("0x" input)

				if inputNum >= startBlockNum && inputNum <= endBlockNum {
					outputVar := { block: block, name: name }
					return outputVar
				}
			}
		} else if isFor = "Altcode" {
			for pageRange, name in characters.blocksData["Code Pages"] {
				split := StrSplit(pageRange, "...")
				startPageNum := Number(split[1])
				endPageNum := Number(split[2])
				inputNum := CharacterInserter.HexToDec(input)

				if input ~= "^0" && pageRange ~= "^01" && inputNum >= 128 {
					if inputNum >= startPageNum && inputNum <= endPageNum {
						outputVar := { pageRange: pageRange, name: name }
						return outputVar
					}
				} else {
					if inputNum >= startPageNum && inputNum <= endPageNum && !(pageRange ~= "^01") {
						outputVar := { pageRange: pageRange, name: name }
						return outputVar
					}
				}
			}
		}
		return outputVar
	}

	GetTooltip(input := "0000", isFor := "Unicode") {
		blockData := this.GetBlock(input, isFor)
		if isFor = "Unicode" {
			if blockData.block != "Unknown"
				return "[ U+" StrReplace(blockData.block, "...", "–U+") " ] " blockData.name
		} else if isFor = "Altcode" {
			Keyboard.CheckLayout(&lang)

			tooltips := Map(
				"default", (name, pageRange) => "[ ALT+" StrReplace(pageRange, "...", "–ALT+") " ] " name,
				"localised", (name, pageRange) => (
					"[ ALT+"
					StrReplace(pageRange, "...", "–ALT+")
					" ] "
					(name.HasRegEx("^" SubStr(lang, 1, 2), &i) ? name[i + 1] : name[1])
					"`n[ "
					Locale.Read("symbol_" (
						this.langToLocale.HasRegEx("^" SubStr(lang, 1, 2), &i)
							? this.langToLocale[i + 1]
						: this.langToLocale[1]
					))
					" ]"
				)
			)

			if blockData.pageRange != "Unknown" {
				if blockData.name is Object {
					return tooltips.Get("localised")(blockData.name, blockData.pageRange)
				} else
					return tooltips.Get("default")(blockData.name, blockData.pageRange)
			}
		}
		return "Unknown"
	}
}