Class CodePagesStore {
	static dumpPath := A_ScriptDir "\Data\Dumps\dump__code_pages.json"
	static storedData := Map()

	static regionalPages := {
		generic: Map(
			"en-US", 850,
			"ru-RU", 866,
			"el-GR", 737,
			"vi-VN", 1258,
		),
		atZero: Map(
			"en-US", 1252,
			"ru-RU", 1251,
			"el-GR", 1253,
			"vi-VN", 1258,
		),
	}

	static pages := []

	static __New() {
		for page in ArrayMerge([437],
			this.regionalPages.generic.Values(),
			this.regionalPages.atZero.Values()) {
			if !this.pages.HasValue(page)
				this.pages.Push(page)
		}

		if FileExist(this.dumpPath)
			this.storedData := JSON.LoadFile(this.dumpPath, "UTF-8")
		else
			this.FillAndDump()

		local keys := this.storedData.Keys()
		if keys.Length != this.pages.Length
			this.FillAndDump()

		return
	}

	static FillAndDump() {
		this.FillDictionary()
		JSON.DumpFile(this.storedData, this.dumpPath, , "UTF-8")
		return
	}

	static FillDictionary() {
		for page in this.pages {
			dict := Map()
			Loop 256 {
				b := A_Index - 1
				buf := Buffer(1)
				NumPut("UChar", b, buf)
				char := StrGet(buf, 1, "CP" page)
				dict[char] := "" b
			}
			this.storedData["" page] := dict
		}
		return
	}

	static GetAltCode(char, page) {
		if this.storedData["" page].Has(char)
			return this.storedData["" page][char]
		else
			return -1
	}
}