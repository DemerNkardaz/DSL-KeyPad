Class XComposeToEntriesParser {
	output := []

	__New(filePath) {
		SplitPath(filePath, &fileName, , , &fileNameNoExt)
		this.filePath := filePath
		this.fileName := fileName
		this.fileNameNoExt := fileNameNoExt
		this.content := FileRead(filePath, "UTF-8")
		this.replacesData := JSON.LoadFile(App.paths.data "\xcompose_parse_replaces.json", "UTF-8")
		this.Parse()
		return
	}

	Parse() {
		local split := StrSplit(this.content, "`n", "`r")
		for i, line in split {
			local label := ""
			if RegExMatch(line, '#\s*(?:U\+?[0-9A-Fa-f]{4,6}\s+)*(?<label>.+)', &m)
				label := m["label"]

			local line := RegExReplace(line, "[`t\s]+")
			if (line == "" || SubStr(line, 1, 1) == "#" || !(line ~= "^\<"))
				continue

			while (RegExMatch(line, "\<(.*?)\>", &match))
				if RegExMatch(match[1], "U([0-9A-Fa-f]{1,6})|\\u\{([0-9A-Fa-f]{1,6})\}|x([0-9A-Fa-f]{1,6})", &unicodeMatch) {
					local hexValue := unicodeMatch[1] || unicodeMatch[2] || unicodeMatch[3]
					line := StrReplace(line, match[0], Chr(Number("0x" hexValue)))
				} else if this.replacesData.Has(match[1])
					line := StrReplace(line, match[0], this.replacesData[match[1]])
				else
					line := StrReplace(line, match[0], match[1])


			if RegExMatch(line, '^(?<sequence>.*):"(?<result>(?:[^"\\]|\\.)*)"', &match)
				if match["sequence"] != "" && match["result"] != "" {
					local result := StrReplace(match["result"], '\"', '"')
					local sequence := match["sequence"]
					local resultOrded := ""
					local sequenceOrded := ""

					Loop Parse, result {
						if (A_Index > 10)
							break
						resultOrded .= Format("{:X}", Ord(SubStr(result, A_Index, 1)))
					}

					Loop Parse, sequence {
						if (A_Index > 10)
							break
						sequenceOrded .= Format("{:X}", Ord(SubStr(sequence, A_Index, 1)))
					}

					local cutPath := StrReplace(this.filePath, App.paths.profile "\")

					local section := "xcompose_s" sequenceOrded "_r" resultOrded (StrLen(this.fileNameNoExt) == 0 ? "" : "__file_" this.fileNameNoExt)
					this.output.Push(section, Map(
						"name", "[XCompose] " label,
						"recipe", [sequence],
						"result", [result],
						"tags", label != "" ? [label] : [],
						"groups", ["Custom Composes", "XCompose"],
						"filePath", cutPath,
						"isXCompose", True
					))
				}
		}
		return
	}
}