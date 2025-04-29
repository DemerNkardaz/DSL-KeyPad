Class Dev {
	static SetSrc() {
		gitPath := Cfg.Get("Git_Path", "Dev")

		if StrLen(gitPath) > 0 && RegExMatch(gitPath, "i)^[a-z]:\\") {
			DirCopy(App.paths.dir, gitPath "\src", True)
		}
	}
}