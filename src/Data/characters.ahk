GeneratedEntries() {
	local output := []

	output.Push(
		"misc_crlf_emspace", Map(
			"unicode", (*) => ChrLib.GetValue("carriage_return", "unicode"),
			"sequence", [(*) => ChrLib.GetValue("carriage_return", "unicode"), (*) => ChrLib.GetValue("new_line", "unicode"), (*) => ChrLib.GetValue("emsp", "unicode")],
			"groups", ["Misc"],
			"options", Map("noCalc", True, "fastKey", "Enter")
		),
		"misc_lf_emspace", Map(
			"unicode", (*) => ChrLib.GetValue("new_line", "unicode"),
			"sequence", [(*) => ChrLib.GetValue("new_line", "unicode"), (*) => ChrLib.GetValue("emsp", "unicode")],
			"groups", ["Misc"],
			"options", Map("noCalc", True, "fastKey", "<+ Enter")
		)
	)

	return output
}