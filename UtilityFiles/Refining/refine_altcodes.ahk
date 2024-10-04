#Requires Autohotkey v2
#SingleInstance Force

GetCharacterUnicode(Symbol) {
  Code := Ord(Symbol)

  if (Code >= 0xD800 && Code <= 0xDBFF) {
    nextSymbol := SubStr(Symbol, 2, 1)
    NextCode := Ord(nextSymbol)

    if (NextCode >= 0xDC00 && NextCode <= 0xDFFF) {
      HighSurrogate := Code - 0xD800
      LowSurrogate := NextCode - 0xDC00
      FullCodePoint := (HighSurrogate << 10) + LowSurrogate + 0x10000
      return Format("{:06X}", FullCodePoint)
    }
  }

  return Format("{:04X}", Code)
}

GetList := FileRead("alt_codes_list_source.txt", "UTF-8")

total_i := 0
for line in StrSplit(GetList, "`n") {
  total_i++
}

curr_i := 0
for line in StrSplit(GetList, "`n") {
  curr_i++
  RegExMatch(line, '^(.+)\t(.+)', &match)
  match1 := match[1]
  match2 := match[2]
  match1 := GetCharacterUnicode(match1)
  endLine := curr_i < total_i ? "`n" : ""
  FileAppend(match1 "`t" match2 endLine, "alt_codes_list.txt", "UTF-8")
}

Exit