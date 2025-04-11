Class Rules {
	static ValidateOnCaretPos() {
		useCaretPos := Cfg.Get("Validate_With_CaretPos", , False, "bool")
		return !useCaretPos || useCaretPos && Util.IsCaretPostExists()
	}
}