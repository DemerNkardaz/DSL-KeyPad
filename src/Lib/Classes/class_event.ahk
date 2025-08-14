Class Event {
	/**
	 * 
	 **/
	static eventListeners := Map(
		"Application Class", Map(
			"Initialized", [],
		),
		"Application", Map(
			"Initialized", [],
		),
		"Character Library", Map(
			"Registration Starts", [],
			"Registration Ends", [],
			"Default Ready", [],
		),
		"Chracter", Map(
			"Send", [],
			"CapsLock Send", [],
			"Language Send", [],
			"Language Call", [],
			"Time Send", [],
			"Default Send", [],
		),
		"Compose Mode", Map(
			"Started", [],
			"Ended", [],
			"Iteration Started", [],
		),
		"Input Mode", Map(
			"Changed", [],
		),
		"UI Instance [Panel]", Map(
			"Created", [],
			"Destroyed", [],
			"Shown", [],
			"Cache Loaded", [],
		),
		"UI Data", Map(
			"Changed", [],
		),
		"UI Language", Map(
			"Switched", [],
		),
		"Binding Storage", Map(
			"Initialized", [],
			"Item Registered", [],
			"Updated", [],
		),
		"Scripter Storage", Map(
			"Initialized", [],
			"Item Registered", [],
			"Updated", [],
		),
		"Layouts Storage", Map(
			"Initialized", [],
			"Item Registered", [],
			"Updated", [],
		),
		"Scripter", Map(
			"On Option Selected", [],
		),
		"Favorites", Map(
			"Changed", [],
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
	 * @returns {Integer} 
	 * 
	 **/

	/**
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
	 * Event.OnEvent("Chracter", "Send", MyEvent)
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
		if !this.CheckEventExistence(eventClass, eventName, &message)
			return Util.MsgError(message)

		this.eventListeners[eventClass][eventName].Push(action)
		return this.eventListeners[eventClass][eventName].Length
	}

	static ClearEvent(eventClass, eventName, actionIndex) {
		if !this.CheckEventExistence(eventClass, eventName, &message)
			return Util.MsgError(message)

		return this.eventListeners[eventClass][eventName].Delete(actionIndex)
	}

	static ReplaceEvent(eventClass, eventName, actionIndex, newAction) {
		if !this.CheckEventExistence(eventClass, eventName, &message)
			return Util.MsgError(message)

		if !this.eventListeners[eventClass][eventName].Has(actionIndex)
			return Util.MsgError("Action with index " actionIndex " does not exist in event " eventName " of class " eventClass ".")

		this.eventListeners[eventClass][eventName][actionIndex] := newAction
		return
	}

	static Trigger(eventClass, eventName, args*) {
		if !this.CheckEventExistence(eventClass, eventName, &message)
			return Util.MsgError(message)

		local listeners := this.eventListeners[eventClass][eventName]

		if listeners.Length > 0
			for i, action in listeners {
				if listeners.Has(i) && action is Func {
					local maxParams := this.GetFunctionMaxParams(action)

					local trimmedArgs := []
					local argCount := Min(args.Length, maxParams)

					Loop argCount {
						trimmedArgs.Push(args[A_Index])
					}

					action.Call(trimmedArgs*)
				}
			}
		return
	}

	static TriggerMulti(arrays*) {
		for each in arrays
			this.Trigger(each*)
		return
	}


	static CheckEventExistence(eventClass, eventName, &message := "") {
		if !this.eventListeners.Has(eventClass) || !this.eventListeners[eventClass].Has(eventName) {
			local messageOutputs := [
				"Error during checking of event existence`n",
				!this.eventListeners.Has(eventClass)
					? Format("Event class with name “{}” does not exist.", eventClass)
				: Format("Event “{}” does not exist in class “{}”.", eventName, eventClass),
				"Create a new or use existing one."
			]

			message := messageOutputs.ToString("`n")
			return False
		}

		return True
	}

	static GetFunctionMaxParams(function) {
		if function.HasProp("MaxParams")
			return function.MaxParams

		if function.HasProp("MinParams")
			return function.MinParams + 5

		return 10
	}
}