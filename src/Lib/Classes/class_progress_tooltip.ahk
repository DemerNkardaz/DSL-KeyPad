Class DottedProgressTooltip {
	increment := 0

	__New(maxIncrement := 4, &triggerEnds := False) {
		this.maxIncrement := maxIncrement
		this.tooltipCall := this.Tooltip.Bind(this, &triggerEnds)
		this.Timer(&triggerEnds)
	}

	Tooltip(&triggerEnds) {
		if triggerEnds {
			ToolTip(Chr(0x2705))
			SetTimer(this.tooltipCall, 0)
			SetTimer(ToolTip.Bind(""), -500)
			return
		}

		this.increment := Mod(this.increment + 1, this.maxIncrement + 1)

		ToolTip(Chr(0x2B1C) " " Util.StrRepeat(".", this.increment))
	}

	Timer(&triggerEnds) {
		SetTimer(this.tooltipCall, 100, 0)
	}
}