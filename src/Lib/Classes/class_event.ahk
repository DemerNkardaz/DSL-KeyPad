Class Event {
	static eventListeners := Map(
		"app_class", Map(
			"initialized", [],
		),
		"chr_lib", Map(
			"starts_reg", [],
			"ends_reg", [],
			"common_library_ends_reg", [],
		),
		"on_chr", Map(
			"send", [],
			"caps_send", [],
			"lang_send", [],
			"lang_call", [],
			"time_send", [],
			"default_send", [],
		),
	)

	static Create(evenName, labels*) {
		if this.eventListeners.Has(evenName)
			throw "Event '" evenName "' already exists."

		local eventMap := Map(evenName, [])
		for label in labels
			eventMap[label] := []

		this.eventListeners[evenName] := eventMap
		return
	}


	static OnEvent(eventName, label, action) {
		if !this.eventListeners.Has(eventName)
			throw "Event '" eventName "' does not exist."

		this.eventListeners[eventName][label].Push(action)
		return
	}

	static Trigger(eventName, label, args*) {
		if this.eventListeners[eventName][label].Length > 0
			for action in this.eventListeners[eventName][label] {
				try {
					action.Call(args*)
				} catch as e {
					MsgBox("Error in event handler for " eventName " - " label ": " e.Message)
				}
			}
		return
	}
}

; Event.OnEvent("on_chr", "send", (combo, &output, &inputType) => (
; 	; Example handler for character sending
; 	Tooltip("Character sent: " combo "`nOutput: " output "`nInput Type: " inputType),
; 	output = "Ă" && output := "Ắ"
; ))

; Event.OnEvent("chr_reg", "starts", (rawEntries, typeOfInit, *) => (
; 	MsgBox("Character registration starts!`n" typeOfInit "`n`n" rawEntries[1]),
; 	rawEntries[1] = "acute" && rawEntries.InsertAt(1, "acute_modified", rawEntries[2])
; ))
; Event.OnEvent("chr_reg", "ends", (*) => (MsgBox("Character registration ends!`n")))
; Event.OnEvent("app_class", "initialized", (*) => (MsgBox("Application initialized!")))
