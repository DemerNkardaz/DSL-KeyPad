; Code parts get from https://github.com/Axlefublr/lib-v2/tree/main

Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })
Array.Prototype.DefineProp("Contains", { Call: _ArrayContains })

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

_ArrayHasValue(this, valueToFind, &indexID?) {
	for index, value in this {
		if value = valueToFind {
			indexID := index
			return true
		}
	}
	return false
}

_ArrayContains(this, valueToFind, &indexID?) {
	for index, value in this {
		if value == valueToFind {
			indexID := index
			return true
		}
	}
	return false
}