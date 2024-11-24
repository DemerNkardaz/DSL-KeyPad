Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })

_ArrayMaxIndex(this) {
	indexes := 0
	for i, v in this {
		indexes++
	}

	return indexes
}