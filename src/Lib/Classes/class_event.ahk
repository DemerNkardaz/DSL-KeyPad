Class Event {
	/**
	 * @method {@link Event.Trigger()} =>
	 * 
	 * @event \<on_compose_mode\> \<starts\> => @references @instance of {@link ChrCrafter} & @type {Object} 
	 * @property {String} Object.input
	 * @property {Boolean} Object.pauseOn
	 * 
	 * @event \<on_compose_mode\> \<ends\> => @references @instance of {@link ChrCrafter} & @param {Object}
	 **/
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
		"on_compose_mode", Map(
			"starts", [],
			"ends", [],
			"iteration_starts", [],
		),
	)

	static Create(eventClass, eventNames*) {
		if this.eventListeners.Has(eventClass)
			throw "Event '" eventClass "' already exists."

		local eventMap := Map(eventClass, [])
		for label in eventNames
			eventMap[label] := []

		this.eventListeners[eventClass] := eventMap
		return
	}
	/**
	 * @method OnEvent binds an action to an @event [eventClass][eventName]
	 * 
	 * @param {String} eventClass — name of the event class that @contains <eventNames*>
	 * @param {String} eventName — name of the event to listen to
	 * @param {Callback} action — action which will be called when the event is triggered
	 * @type {(eventClass: String, eventName: String, action: Callback) => Void}
	 * 
	 * @throws {Error} when the specified event class does not exist
	 * @returns {Void}
	 * 
	 * Example of binding on event that triggers when @method {@link BindHandler.Send}(combo, characterNames*) sends an output:
	 * 
	 * Stores last sent @output in a @static @variable
	 * 
	 * Disables Timer that clears the static variable
	 * 
	 * @IF “Compose” @instance is active => @returns {Void}
	 * 
	 * @IF next character is “Combining Acute Accent” {@link https://en.wiktionary.org/wiki/%CC%81} =>
	 * Replaces “A with Breve” {@link https://en.wiktionary.org/wiki/%C4%82} with “A with Breve & Acute” {@link https://en.wiktionary.org/wiki/%E1%BA%AE}
	 * 
	 * @returns {Timer} which will clear static variable after 5 seconds
	 * 
	 * @example
	 * Event.OnEvent("on_chr", "send", MyEvent)
	 * MyEvent(&output) {
	 * 	static storage := ""
	 * 	static clear := _Clear.Bind()
	 * 
	 * 	SetTimer(clear, 0)
	 * 
	 * 	if globalInstances.crafter.isComposeInstanceActive
	 * 		return
	 * 
	 * 	if storage == Chr(0x0102) && output == Chr(0x0301)
	 * 		SendEvent("{BackSpace}"), output := Chr(0x1EAE)
	 * 
	 * 	storage := output
	 * 	return SetTimer(clear, -5000)
	 * 
	 * 	static _Clear() => storage := ""
	 * }
	 **/
	static OnEvent(eventClass, eventName, action) {
		if !this.eventListeners.Has(eventClass)
			throw "Event '" eventClass "' does not exist."

		this.eventListeners[eventClass][eventName].Push(action)
		return
	}

	static Trigger(eventClass, eventName, args*) {
		if this.eventListeners[eventClass][eventName].Length > 0
			for action in this.eventListeners[eventClass][eventName] {
				local maxParams := this.GetFunctionMaxParams(action)

				local trimmedArgs := []
				local argCount := Min(args.Length, maxParams)

				Loop argCount {
					trimmedArgs.Push(args[A_Index])
				}

				action.Call(trimmedArgs*)
			}
		return
	}

	static GetFunctionMaxParams(function) {
		if function.HasProp("MaxParams")
			return function.MaxParams

		if function.HasProp("MinParams")
			return function.MinParams + 5

		return 10
	}
}


; Event.OnEvent("on_chr", "send", MyEvent)
; MyEvent(&output) {
; 	static storage := ""
; 	static clear := _Clear.Bind()

; 	SetTimer(clear, 0)

; 	if globalInstances.crafter.isComposeInstanceActive
; 		return

; 	if storage == Chr(0x0102) && output == Chr(0x0301)
; 		SendEvent("{BackSpace}"), output := Chr(0x1EAE)

; 	storage := output
; 	return SetTimer(clear, -5000)

; 	static _Clear() => storage := ""
; }

; Event.OnEvent("on_chr", "send", (&combo, &output, &inputType) => (
; 	Tooltip("Character sent: " combo "`nOutput: " output "`nInput Type: " inputType)
; 	; output = "Ă" && output := "Ắ"
; ))

; Event.OnEvent("chr_lib", "starts_reg", (rawEntries, typeOfInit) => (
; 	MsgBox("Character registration starts!`n" typeOfInit "`n`n" rawEntries[1]),
; 	rawEntries[1] = "acute" && rawEntries.InsertAt(1, "acute_modified", rawEntries[2])
; ))
; Event.OnEvent("chr_lib", "ends_reg", (*) => (MsgBox("Character registration ends!`n")))
; Event.OnEvent("app_class", "initialized", (*) => (MsgBox("Application initialized!")))
