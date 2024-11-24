; Code parts get from https://github.com/Axlefublr/lib-v2/tree/main

Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })

_ArrayToString(this, char := ", ") {
	for index, value in this {
		if index = this.Length {
			str .= value
			break
		}
		str .= value char
	}
	return str
}

_ArrayHasValue(this, valueToFind) {
	for index, value in this {
		if value = valueToFind
			return true
	}
	return false
}