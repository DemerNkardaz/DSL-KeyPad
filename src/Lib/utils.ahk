Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })
Array.Prototype.DefineProp("ToFlat", { Call: _ArrayToFlat })
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })
Array.Prototype.DefineProp("HasRegEx", { Call: _ArrayHasRegEx })
Array.Prototype.DefineProp("Contains", { Call: _ArrayContains })
Array.Prototype.DefineProp("MaxIndex", { Call: _ArrayMaxIndex })
Array.Prototype.DefineProp("RemoveValue", { Call: _ArrayRemoveValue })
Array.Prototype.DefineProp("SortLen", { Call: _ArraySortLen })
Array.Prototype.DefineProp("MergeWith", { Call: _ArrayMergeWith })
Array.Prototype.DefineProp("Clear", { Call: _ArrayClear })
Array.Prototype.DefineProp("ToLower", { Call: _ArrayToLower })
Array.Prototype.DefineProp("ToUpper", { Call: _ArrayToUpper })
Array.Prototype.DefineProp("Slice", { Call: _ArraySlice })
Array.Prototype.DefineProp("DeepClone", { Call: _ArrayDeepClone })
Array.Prototype.DefineProp("StringsPrepend", { Call: _ArrayStringsPrepend })
Array.Prototype.DefineProp("StringsAppend", { Call: _ArrayStringsAppend })
Array.Prototype.DefineProp("StringsToNumbers", { Call: _ArrayStringsToNumbers })
Array.Prototype.DefineProp("ToMap", { Call: _ArrayToMap })
Array.Prototype.DefineProp("ToObject", { Call: _ArrayToObject })

Map.Prototype.DefineProp("Keys", { Call: _MapKeys })
Map.Prototype.DefineProp("Values", { Call: _MapValues })
Map.Prototype.DefineProp("ToArray", { Call: _MapToArray })
Map.Prototype.DefineProp("MergeWith", { Call: _MapMergeWith })
Map.Prototype.DefineProp("DeepMergeWith", { Call: _MapDeepMergeWith })
Map.Prototype.DefineProp("DeepMergeBinds", { Call: _MapDeepMergeBinds })
Map.Prototype.DefineProp("DeepClone", { Call: _MapDeepClone })
Map.Prototype.DefineProp("GetRef", { Call: _MapGetRef })
Array.Prototype.DefineProp("DraftMap", { Call: _ArrayToDraftMap })
Object.Prototype.DefineProp("MaxIndex", { Call: _ObjMaxIndex })
Object.Prototype.DefineProp("ObjKeys", { Call: _ObjKeys })
Object.Prototype.DefineProp("DeepClone", { Call: _ObjDeepClone })

_ArrayToDraftMap(this, defaultValue) {
	local output := Map()
	for item in this
		output.Set(item, defaultValue)

	return output
}

ObjGet(this, j) {
	local i := 0
	for k, v in this.OwnProps() {
		if i = j {
			return v
		}
		i++
	}
	return
}

_ArrayDeepClone(this) {
	local output := []
	for item in this {
		if item is String {
			output.Push(item)
		} else if item is Array {
			output.Push(item.Clone())
		} else if item is Map {
			output.Push(item.DeepClone())
		} else if item is Object {
			output.Push(item.DeepClone())
		} else {
			output.Push(item)
		}
	}
	return output
}

_ObjDeepClone(this) {
	local output := {}

	for k, v in this.OwnProps() {
		if v is String {
			output.DefineProp(k, { value: v })
		} else if v is Array {
			output.DefineProp(k, { value: v.Clone() })
		} else if v is Map {
			output.DefineProp(k, { value: v.DeepClone() })
		} else if v is Object {
			output.DefineProp(k, { value: v.DeepClone() })
		} else {
			output.DefineProp(k, { value: v })
		}
	}

	return output
}

_ObjMaxIndex(this) {
	return ObjOwnPropCount(this)
}

_ObjKeys(this) {
	local keys := []
	for k, v in this.OwnProps() {
		keys.Push(k)
	}
	return keys
}

_ArrayClear(this) {
	this.Length := 0
	return this
}

_ArrayStringsPrepend(this, value, maxAffected := this.Length) {
	for i, item in this {
		if i > maxAffected
			break

		this[i] := value item
	}
	return this
}

_ArrayStringsAppend(this, value, maxAffected := this.Length) {
	for i, item in this {
		if i > maxAffected
			break

		this[i] := item value
	}
	return this
}

_ArrayStringsToNumbers(this) {
	for i, item in this {
		if item is String && item ~= "([0-9]+(\.[0-9]+)?|0x[0-9a-f]+)"
			this[i] = Number(item)
	}
	return this
}

_ArrayToMap(this, defaultValue?) {
	local output := Map()

	if IsSet(defaultValue) {
		for item in this {
			if defaultValue is Array || defaultValue is Map || defaultValue is Object
				output.Set(item, defaultValue.Clone())
			else
				output.Set(item, defaultValue)
		}
	} else {
		Loop this.Length // 2 {
			local i := A_Index * 2 - 1
			local v := i + 1
			output.Set(this[i], this[v])
		}
	}

	return output
}

_ArrayToObject(this) {
	local output := {}
	for item in this {
		output.%item% := %item%
	}
	return output
}

_ArrayMergeWith(this, arrays*) {
	for arr in arrays {
		for item in arr {
			this.Push(item)
		}
	}
	return
}

_ArrayToFlat(this) {
	local result := []
	for item in this {
		if item is Array {
			for subItem in item {
				result.Push(subItem)
			}
		} else {
			result.Push(item)
		}
	}
	return result
}

_ArrayToLower(this) {
	local result := []
	for item in this
		if item is String
			result.Push(StrLower(item))

	return result
}

_ArrayToUpper(this) {
	local result := []
	for item in this
		if item is String
			result.Push(StrUpper(item))

	return result
}

_ArraySlice(this, start := 1, length := this.Length, &totalLength := 0) {
	local result := []

	for index, value in this {
		if index < start
			continue
		if result.Length >= length
			break

		result.Push(value)
	}

	totalLength := result.Length
	return result
}

_ArrayToString(this, separator := ", ", bounds := "") {
	local str := ""
	for index, value in this {
		if index = this.Length {
			if value is Array {
				str .= (bounds is Array ? bounds[1] : bounds) value.ToString(separator, bounds) (bounds is Array ? bounds[2] : bounds)
			} else {
				str .= (bounds is Array ? bounds[1] : bounds) value (bounds is Array ? bounds[2] : bounds)
			}
			break
		}
		if value is Array {
			str .= (bounds is Array ? bounds[1] : bounds) value.ToString(separator, bounds) (bounds is Array ? bounds[2] : bounds) separator
		} else {
			str .= (bounds is Array ? bounds[1] : bounds) value (bounds is Array ? bounds[2] : bounds) separator
		}
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

_ArrayHasRegEx(this, valueToFind, &indexID?, boundRegEx := [], skipValues := []) {
	for index, value in this {
		if skipValues.Length > 0 && skipValues.HasValue(value) {
			continue
		} else if value is String && (value = valueToFind ||
			(valueToFind ~= "[" RegExEscape(regExChars) "]" && value ~= valueToFind) ||
			(value ~= "[" RegExEscape(regExChars) "]" && valueToFind ~= value) ||
			boundRegEx.Length = 2 && valueToFind ~= boundRegEx[1] value boundRegEx[2]
		) {
			indexID := index
			return true
		}
	}
	return false
}

RegExMatchArray(arr, valueToFind) {
	for item in arr {
		if item ~= valueToFind
			return True
	}
	return False
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

_ArrayMaxIndex(this) {
	local indexes := 0
	for i, v in this {
		indexes++
	}

	return indexes
}

_ArrayRemoveValue(this, valueToRemove) {
	for index, value in this {
		if value = valueToRemove {
			this.RemoveAt(index)
			break
		}
	}
	return
}

_ArraySortLen(this) {
	local sorted := this.Clone()

	for i, _ in sorted {
		for j, _ in sorted {
			if (StrLen(sorted[i]) > StrLen(sorted[j])) {
				local temp := sorted[i]
				sorted[i] := sorted[j]
				sorted[j] := temp
			}
		}
	}
	return sorted
}


ArrayMergeTo(&targetArray, Arrays*) {
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			targetArray.Push(element)
		}
	}
	return
}

ArrayMerge(Arrays*) {
	local tempArray := []
	for arrayItem in Arrays {
		if !IsObject(arrayItem)
			continue
		for element in arrayItem {
			tempArray.Push(element)
		}
	}
	return tempArray
}

ArraySlice(this, start, end := this.Length) {
	local result := []
	for index, value in this {
		if index >= start && index <= end {
			result.Push(value)
		}
	}
	return result

}

RegExEscape(str) {
	local newStr := ""
	for k, char in StrSplit(str) {
		if InStr(regExChars, char) {
			newStr .= "\" char
		} else {
			newStr .= char
		}
	}
	return newStr
}

RegExSplit(str, pattern, omitEmpty := false) {
	splits := []
	pos := 1
	while RegExMatch(str, pattern, &match, pos) {
		part := SubStr(str, pos, match.Pos(0) - pos)
		if (!omitEmpty || part != "")
			splits.Push(part)
		pos := match.Pos(0) + match.Len(0)
	}
	if (pos <= StrLen(str)) {
		part := SubStr(str, pos)
		if (!omitEmpty || part != "")
			splits.Push(part)
	} else if (!omitEmpty && RegExMatch(str, pattern "$")) {
		splits.Push("")
	}
	return splits
}


_MapKeys(this, t := "k", names?) {
	local keys := []
	for k, v in this {
		if IsSet(names) {
			if names.HasValue(k)
				keys.Push(%t%)
		} else
			keys.Push(%t%)
	}
	return keys
}

_MapValues(this, names?) {
	return _MapKeys(this, "v", names?)
}

_MapToArray(this) {
	local arr := []
	for k, v in this {
		arr.Push(k, v)
	}
	return arr
}

_MapMergeWith(this, maps*) {
	for mapIdx, mapToMerge in maps {
		for key, val in mapToMerge {
			if this.Has(key) && this[key] is Map {
				this[key].MergeWith(val)
			} else {
				this.Set(key, val)
			}
		}
	}
	return this
}

_MapDeepClone(this) {
	local result := Map()
	for key, value in this {
		if value is Map
			result[key] := value.DeepClone()
		else
			result[key] := value
	}
	return result
}

_MapDeepMergeWith(this, maps*) {
	for mapIdx, mapToMerge in maps {
		if mapToMerge.Count = 0
			continue

		for key, val in mapToMerge {
			if this.Has(key) && this[key] is Map {
				this[key].DeepMergeWith(val)
			} else {
				this.Set(key, val)
			}
		}
	}
	return this
}

_MapDeepMergeBinds(this, maps*) {
	for mapIdx, mapToMerge in maps {
		if mapToMerge.Count = 0
			continue
		for newKey, newVal in mapToMerge {
			local newKeyBase := RegExMatch(newKey, "^([^:]+)", &baseMatch) ? baseMatch[1] : newKey

			local keyToRemove := ""
			for existingKey in this {
				local existingKeyBase := RegExMatch(existingKey, "^([^:]+)", &existingBaseMatch) ? existingBaseMatch[1] : existingKey

				if (existingKeyBase = newKeyBase) {
					if (InStr(newKey, ":") > 0) {
						keyToRemove := existingKey
						break
					}
				}
			}

			if (keyToRemove != "") {
				this.Delete(keyToRemove)
			}

			if this.Has(newKey) && this[newKey] is Map && newVal is Map {
				this[newKey].DeepMergeBinds(newVal)
			} else {
				this.Set(newKey, newVal)
			}
		}
	}
	return this
}

_MapGetRef(this, &key, &output := "") {
	if this.Has(key)
		output := this.Get(key)
	return this.Get(key)
}

MapMergeTo(TargetMap, MapObjects*) {
	for mapObj in MapObjects {
		if !IsObject(mapObj)
			continue
		for entry, value in mapObj {
			TargetMap[entry] := value
		}
	}
	return
}

MapMerge(MapObjects*) {
	local tempMap := Map()
	for mapObj in MapObjects {
		for entry, value in mapObj {
			tempMap[entry] := value
		}
	}
	return tempMap
}


Chrs(chrCodes*) {
	local output := ""

	for code in chrCodes {
		if code is Array {
			local charCode := code[1]
			local charRepeats := code.Has(2) ? code[2] : 1

			Loop charRepeats
				output .= Chr(charCode)
		} else {
			output .= Chr(code)
		}
	}

	return output
}

GetKeyScanCode() {
	local IB := InputBox("Scan code get", "Scan code", "w350 h110", "")

	if IB.Result = "Cancel"
		return
	else {
		local promptValue := IB.Value
		local scanCode := GetKeySC(promptValue)
		scanCode := Format("{:X}", scanCode)
		scanCode := StrLen(scanCode) == 1 ? "00" scanCode : StrLen(scanCode) == 2 ? "0" scanCode : scanCode
		scanCode := "SC" scanCode
		SendText(scanCode)
	}
	return
}

ContainsEmoji(StringInput) {
	static emojisPattern := "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{1F700}-\x{1F77F}\x{1F900}-\x{1F9FF}\x{2700}-\x{27BF}\x{1F1E6}-\x{1F1FF}]"
	return RegExMatch(StringInput, emojisPattern)
}

Range(start, end, step := 1) {
	local result := []
	if step > 0 {
		loop (end - start + 1) // step {
			result.Push(start + (A_Index - 1) * step)
		}
	} else {
		loop (start - end + 1) // Abs(step) {
			result.Push(start + (A_Index - 1) * step)
		}
	}
	return result
}

ModPath(modName) {
	return A_ScriptDir "\Mods\" modName
}

ArrayPrefix(prefix, stringsArray) {
	local output := []

	for each in stringsArray
		output.Push(prefix each)

	return output
}