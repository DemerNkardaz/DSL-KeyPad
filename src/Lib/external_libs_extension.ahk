class JSONExt extends JSON {
	static Dump(obj, pretty := 0, escape := False) {
		local originalEscapeUnicode := this.lib.bEscapeUnicode
		if !escape
			this.lib.bEscapeUnicode := 0

		result := super.Dump(obj, pretty)

		if !escape
			this.lib.bEscapeUnicode := originalEscapeUnicode

		return result
	}
}