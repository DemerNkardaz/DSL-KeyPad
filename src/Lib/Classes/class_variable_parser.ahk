Class VariableParser {
	static Parse(str) {
		local output := ""
		local pattern := "(?<!\\)<%\s([^<%]+)\s%/>"
		local pos := 1
		local hasOnlyOneVariable := false
		local varCount := 0

		local tempPos := 1
		while (tempPos <= StrLen(str)) {
			local tempMatch := ""
			local tempMatchPos := RegExMatch(str, pattern, &tempMatch, tempPos)
			if (tempMatchPos) {
				varCount++
				tempPos := tempMatchPos + tempMatch.Len
			} else {
				break
			}
		}

		local fullVariablePattern := "^<%\s([^<%]+)\s%/>$"
		local fullMatch := ""
		if (RegExMatch(str, fullVariablePattern, &fullMatch)) {
			hasOnlyOneVariable := true
		}

		while (pos <= StrLen(str)) {
			local match := ""
			local matchPos := RegExMatch(str, pattern, &match, pos)

			if (matchPos) {
				local varReference := match[1]
				local resolvedValue := This.ResolveVariableReference(varReference)

				if (hasOnlyOneVariable && varCount = 1 && (resolvedValue is Func)) {
					return resolvedValue
				}

				output .= SubStr(str, pos, matchPos - pos)

				if (resolvedValue is Func) {
					output .= "[Function Object]"
				} else {
					output .= resolvedValue
				}

				pos := matchPos + match.Len
			} else {
				output .= SubStr(str, pos)
				break
			}
		}

		return output
	}

	static ResolveVariableReference(varReference) {
		local arrowPattern := "^\([^)]*\)\s*=>\s*(.+)$"
		local arrowMatch := ""

		if (RegExMatch(varReference, arrowPattern, &arrowMatch)) {
			return This.CreateArrowFunction(varReference)
		}

		local funcPattern := "^(.+)\(([^)]*)\)$"
		local funcMatch := ""

		if (RegExMatch(varReference, funcPattern, &funcMatch)) {
			local funcPath := funcMatch[1]
			local argsStr := funcMatch[2]
			local args := This.ParseFunctionArgs(argsStr)

			try {
				local dotPos := InStr(funcPath, ".", false, -1)

				if (dotPos) {
					local objPath := SubStr(funcPath, 1, dotPos - 1)
					local methodName := SubStr(funcPath, dotPos + 1)

					local obj := This.ResolveVariableReference(objPath)

					if (obj && obj.HasMethod && obj.HasMethod(methodName)) {
						return obj.%methodName%(args*)
					} else {
						return "[Error: Method '" . methodName . "' not found in object]"
					}
				} else {
					try {
						if (%funcPath% is Func) {
							return %funcPath%(args*)
						}
					} catch {
					}

					try {
						local classRef := %funcPath%
						if (classRef && classRef.Prototype) {
							return classRef(args*)
						}
					} catch {
					}

					return "[Error: Function or Class '" funcPath "' not found]"
				}
			} catch as e {
				return "[Error calling function: " e.message "]"
			}
		}

		if (InStr(varReference, "[")) {
			return This.ResolveComplexReference(varReference)
		}

		local dotPattern := "^([a-zA-Z_][a-zA-Z0-9_]*)\.(.+)$"
		local dotMatch := ""

		if (RegExMatch(varReference, dotPattern, &dotMatch)) {
			local rootVar := dotMatch[1]
			local propertyPath := dotMatch[2]

			try {
				local value := %rootVar%
				return This.ResolveNestedProperty(value, propertyPath)
			} catch {
				return "[Error: Cannot access " rootVar "." propertyPath "]"
			}
		}

		try {
			local value := %varReference%
			if (value && value.Prototype) {
				return value
			}
			return value
		} catch {
			return "[Error: Variable '" varReference "' not found]"
		}
	}

	static CreateArrowFunction(arrowFuncStr) {
		local arrowPattern := "^\(([^)]*)\)\s*=>\s*(.+)$"
		local arrowMatch := ""

		if (RegExMatch(arrowFuncStr, arrowPattern, &arrowMatch)) {
			local paramsStr := arrowMatch[1]
			local body := arrowMatch[2]

			local params := []
			if (Trim(paramsStr) != "") {
				local paramParts := This.SplitAdvanced(paramsStr, ",")
				for (param in paramParts) {
					params.Push(Trim(param))
				}
			}

			output(*) {
				try {
					if (InStr(body, ".") || InStr(body, "[") || InStr(body, "(")) {
						return This.ResolveVariableReference(body)
					} else {
						try {
							return %body%
						} catch {
							try {
								return This.ResolveVariableReference(body)
							} catch {
								return body
							}
						}
					}
				} catch as e {
					return "[Error in arrow function: " e.message "]"
				}
			}
			return output
		}

		return "[Error: Invalid arrow function syntax]"
	}

	static ResolveComplexReference(varReference) {
		local current := ""
		local remaining := varReference
		local result := ""

		local firstVarMatch := ""
		if (RegExMatch(remaining, "^([a-zA-Z_][a-zA-Z0-9_]*)", &firstVarMatch)) {
			current := %firstVarMatch[1]%
			remaining := SubStr(remaining, StrLen(firstVarMatch[1]) + 1)
		} else {
			return "[Error: Invalid variable reference]"
		}

		while (remaining) {
			if (SubStr(remaining, 1, 1) = ".") {
				remaining := SubStr(remaining, 2)
				local propMatch := ""
				if (RegExMatch(remaining, "^([a-zA-Z_][a-zA-Z0-9_]*)", &propMatch)) {
					try {
						current := current.%propMatch[1]%
						remaining := SubStr(remaining, StrLen(propMatch[1]) + 1)
					} catch {
						return "[Error: Cannot access property '" propMatch[1] "']"
					}
				} else {
					return "[Error: Invalid property name]"
				}
			} else if (SubStr(remaining, 1, 1) = "[") {
				local bracketEnd := This.FindMatchingBracket(remaining, 1)
				if (bracketEnd = -1) {
					return "[Error: Unmatched brackets]"
				}

				local key := SubStr(remaining, 2, bracketEnd - 2)
				key := RegExReplace(key, "^[`"\']|[`"\']$", "")

				try {
					current := current[key]
					remaining := SubStr(remaining, bracketEnd + 1)
				} catch {
					return "[Error: Cannot access key '" key "']"
				}
			} else {
				return "[Error: Unexpected character in reference]"
			}
		}

		return current
	}

	static FindMatchingBracket(str, startPos) {
		local depth := 0
		local len := StrLen(str)

		Loop len - startPos + 1 {
			local char := SubStr(str, startPos + A_Index - 1, 1)
			if (char = "[") {
				depth++
			} else if (char = "]") {
				depth--
				if (depth = 0) {
					return startPos + A_Index - 1
				}
			}
		}

		return -1
	}

	static ParseFunctionArgs(argsStr) {
		local args := []

		if (!argsStr || Trim(argsStr) = "") {
			return args
		}

		local argParts := This.SplitAdvanced(argsStr, ",")

		for (part in argParts) {
			local trimmed := Trim(part)
			local parsedArg := This.ParseSingleArgument(trimmed)
			args.Push(parsedArg)
		}

		return args
	}

	static SplitAdvanced(str, delimiter) {
		local parts := []
		local current := ""
		local depth := 0
		local inQuotes := false
		local quoteChar := ""
		local i := 1

		while (i <= StrLen(str)) {
			local char := SubStr(str, i, 1)

			if ((char = '"' || char = "'") && !inQuotes) {
				inQuotes := true
				quoteChar := char
				current .= char
			} else if (char = quoteChar && inQuotes) {
				inQuotes := false
				quoteChar := ""
				current .= char
			} else if (inQuotes) {
				current .= char
			}
			else if (char = "[" || char = "{" || char = "(") {
				depth++
				current .= char
			} else if (char = "]" || char = "}" || char = ")") {
				depth--
				current .= char
			}
			else if (char = delimiter && depth = 0) {
				if (Trim(current) != "") {
					parts.Push(current)
				}
				current := ""
			} else {
				current .= char
			}

			i++
		}

		if (Trim(current) != "") {
			parts.Push(current)
		}

		return parts
	}

	static ParseSingleArgument(arg) {
		local trimmed := Trim(arg)

		if (RegExMatch(trimmed, "^\[.*\]$")) {
			return This.ParseArrayLiteral(trimmed)
		}

		if (RegExMatch(trimmed, "^\{.*\}$")) {
			return This.ParseObjectLiteral(trimmed)
		}

		if (RegExMatch(trimmed, "^[a-zA-Z_][a-zA-Z0-9_]*(\.[a-zA-Z_][a-zA-Z0-9_]*)*(\[[^\]]+\])*$")) {
			try {
				return This.ResolveVariableReference(trimmed)
			} catch {
			}
		}

		if (RegExMatch(trimmed, "^[`"\'].*[`"\']$")) {
			return SubStr(trimmed, 2, StrLen(trimmed) - 2)
		}

		if (IsNumber(trimmed)) {
			return Number(trimmed)
		}

		return trimmed
	}

	static ParseArrayLiteral(arrayStr) {
		local content := SubStr(arrayStr, 2, StrLen(arrayStr) - 2)
		local result := []

		if (Trim(content) = "") {
			return result
		}

		local elements := This.SplitAdvanced(content, ",")

		for (element in elements) {
			result.Push(This.ParseSingleArgument(element))
		}

		return result
	}

	static ParseObjectLiteral(objStr) {
		local content := SubStr(objStr, 2, StrLen(objStr) - 2)
		local result := {}

		if (Trim(content) = "") {
			return result
		}

		local pairs := This.SplitAdvanced(content, ",")

		for (pair in pairs) {
			local colonPos := InStr(pair, ":")
			if (colonPos) {
				local key := Trim(SubStr(pair, 1, colonPos - 1))
				local value := Trim(SubStr(pair, colonPos + 1))

				if (RegExMatch(key, "^[`"\'].*[`"\']$")) {
					key := SubStr(key, 2, StrLen(key) - 2)
				}

				result[key] := This.ParseSingleArgument(value)
			}
		}

		return result
	}

	static ResolveNestedProperty(obj, propertyPath) {
		local current := obj
		local parts := StrSplit(propertyPath, ".")

		for (part in parts) {
			if (current && current.HasProp && current.HasProp(part)) {
				current := current.%part%
			} else if (current && current.HasMethod && current.HasMethod(part)) {
				current := current.%part%
			} else {
				throw Error("Property '" part "' not found")
			}
		}

		return current
	}
}