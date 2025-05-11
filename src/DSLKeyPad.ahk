/* ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 * ▓ Creator: Yalla Nkardaz (Ялла Нкардаз де Тудерий) aka Demer Nkardaz
 * ▓ Title:   DSL KeyPad (Diacritics-Spaces-Letters KeyPad)
 * ▓ Version: 0.1.1
 * ▓ Description: Multilingual input tool for typing languages based on
 *                Latin & Cyrillic scripts, special characters, and historical
 *                scripts (Old Turkic, Permic, Hungarian, Italic, Runic,
 *                Phoenician, Glagolitic, etc.).
 * ▓ Repository: https://github.com/DemerNkardaz/DSL-KeyPad
 * ▓ License:    MIT
 * ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
*/

#SingleInstance Force
SetKeyDelay(0, 50)
A_HotkeyInterval := 1000
A_MaxHotkeysPerInterval := 50

#Include <External\prt_array>
#Include <External\fnc_clip_send>
#Include <External\fnc_gui_button_icon>
#Include <def_vars>
#Include <utils>
#Include <chr_alt_codes>
#Include <chr_latex_codes>
#Include <chr_entities>
#Include <cls_chr_block>
#Include <cls_util>
#Include <cls_unicode_web_resource>
#Include <chr_lib>

#Include <cls_app>
#Include <cls_chr_lib>
#Include <cls_update>
#Include <cls_cfg>
#Include <cls_fonts>
#Include <cls_language>
#Include <cls_chr_crafter>
#Include <cls_chr_inserter>
#Include <cls_script_processor>
#Include <cls_favorites>

#Include <cls_rules>
#Include <chr_bindlist>
#Include <cls_my_recipes>
#Include <cls_chr_recipe_handler>
#Include <cls_auxiliary>
#Include <cls_chr_legend>
#Include <cls_panel>
#Include <cls_key_event>
#Include <cls_bindlist>
#Include <cls_layout>
#Include <cls_long_press>
#Include <hotstrings>
#Include <cls_tempature_converter>
#Include <supplement_python>
#Include <cls_dev>
#Include <stc_bindings>

ChrLib.CountOfUpdate()
App.SetTrayItems()

GREPizeSelection(GetCollaborative := False) {
	CustomAfterStartEmdash := (Cfg.Get("Paragraph_After_Start_Emdash", "CustomRules", "") != "") ? Cfg.Get("Paragraph_After_Start_Emdash", "CustomRules", "") : "ensp"
	CustomDialogue := (Cfg.Get("GREP_Dialog_Attribution", "CustomRules", "") != "") ? Cfg.Get("GREP_Dialog_Attribution", "CustomRules", "") : "no_break_space"
	CustomThisEmdash := (Cfg.Get("GREP_ThisEmdash", "CustomRules", "") != "") ? Cfg.Get("GREP_ThisEmdash", "CustomRules", "") : "no_break_space"
	CustomInitials := (Cfg.Get("GREP_Initials", "CustomRules", "") != "") ? Cfg.Get("GREP_Initials", "CustomRules", "") : "thinspace"

	Punctuations := "[" ChrLib.Get("reversed_question", "inverted_exclamation", "inverted_question", "double_exclamation", "double_exclamation_question", "double_question", "double_question_exclamation", "interrobang", "interrobang_inverted") ".,!?…”’»›“]"

	GREPRules := Map(
		"start_emdash", {
			grep: "^" ChrLib.Get("emdash") "\s",
			replace: ChrLib.Get("emdash", CustomAfterStartEmdash)
		},
		"dialogue_emdash", {
			grep: "(?<=" Punctuations ")\s" ChrLib.Get("emdash") "\s",
			replace: ChrLib.Get(CustomDialogue "[1,3]", "emdash")
		},
		"this_emdash", {
			grep: "(?<!" Punctuations ")\s" ChrLib.Get("emdash") "\s",
			replace: ChrLib.Get(CustomThisEmdash, "emdash", "space")
		},
		"nums", {
			grep: "(?<=\d)\s(?=\d{3})",
			replace: ChrLib.Get("no_break_space")
		},
		"paragraph_end", {
			grep: "(?<=[а-яА-ЯёЁa-zA-Z])\s(?=[а-яА-ЯёЁa-zA-Z]{1,12}[" Punctuations "]*$)",
			replace: ChrLib.Get("no_break_space")
		},
		"initials", {
			grep: "([A-ZА-ЯЁ]\.)\s([A-ZА-ЯЁ]\.)\s([A-ZА-ЯЁ][a-zа-яё]+)",
			replace: "$1" . ChrLib.Get(CustomInitials) . "$2" . ChrLib.Get(CustomInitials) . "$3"
		},
		"initials_reversed", {
			grep: "([A-ZА-ЯЁ][a-zа-яё]+)\s([A-ZА-Яё]\.)\s([A-ZА-ЯЁ]\.)",
			replace: "$1" . ChrLib.Get(CustomInitials) . "$2" . ChrLib.Get(CustomInitials) . "$3"
		},
		"single_letter", {
			grep: "(?<![а-яА-ЯёЁa-zA-Z])([а-яА-ЯёЁa-zA-Z])\s",
			replace: "$1" ChrLib.Get("no_break_space")
		},
		"russian_conjunctions", {
			grep: "\s(бы|ли|то|же)(?![а-яА-Я])",
			replace: ChrLib.Get("no_break_space") "$1"
		},
		"russian_conjunctions_2", {
			grep: "\s(из|до|для|на|но|не|ни|то|по|со|Из|До|Для|На|Но|Не|Ни|То|По|Со)\s",
			replace: ChrLib.Get("space") "$1" ChrLib.Get("no_break_space")
		},
	)

	BackupClipboard := A_Clipboard
	if !GetCollaborative {
		PromptValue := ""
		A_Clipboard := ""

		Send("^c")
		ClipWait(0.50, 1)
		PromptValue := A_Clipboard
		A_Clipboard := ""
	} else {
		PromptValue := ParagraphizeSelection(True)
		Sleep 100
	}

	if (PromptValue != "") {
		TotalLines := 0
		SplittedLines := StrSplit(PromptValue, "`r`n")
		ModifiedValue := ""

		for index in SplittedLines {
			TotalLines++
		}

		CurrentLine := 0
		for _, rule in GREPRules {
			for i, line in SplittedLines {
				SplittedLines[i] := RegExReplace(line, rule.grep, rule.replace)
			}
		}

		for line in SplittedLines {
			CurrentLine++
			EndLine := CurrentLine < TotalLines ? "`r`n" : ""
			ModifiedValue .= line . EndLine
		}

		A_Clipboard := ModifiedValue
		ClipWait(0.250, 1)
		Sleep 1000
		Send("^v")
	}

	Sleep 1000
	A_Clipboard := BackupClipboard
}

ParagraphizeSelection(SendCollaborative := False) {
	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	ClipWait(0.50, 1)
	PromptValue := A_Clipboard
	A_Clipboard := ""

	if (PromptValue != "") {
		CustomParagraphBeginning := (Cfg.Get("Paragraph_Beginning", "CustomRules", "") != "") ? Cfg.Get("Paragraph_Beginning", "CustomRules", "") : "emsp"
		CustomAfterStartEmdash := (Cfg.Get("Paragraph_After_Start_Emdash", "CustomRules", "") != "") ? Cfg.Get("Paragraph_After_Start_Emdash", "CustomRules", "") : "ensp"

		blockRules := [CustomParagraphBeginning, CustomAfterStartEmdash]

		for i, blockRule in blockRules {
			if blockRule = "noad" {
				blockRules[i] := ""
			}
		}

		CustomParagraphBeginning := blockRules[1]
		CustomAfterStartEmdash := blockRules[2]

		TotalLines := 0
		ModifiedValue := ""
		SplittedLines := StrSplit(PromptValue, "`r`n")

		for index in SplittedLines {
			TotalLines++
		}

		CurrentLine := 0
		for line in SplittedLines {
			CurrentLine++
			EndLine := CurrentLine < TotalLines ? "`r`n" : ""
			LocalModify := RegExReplace(
				line, "^" . ChrLib.Get("emdash") . "\s+",
				ChrLib.Get("emdash") . ChrLib.Get(CustomAfterStartEmdash)
			)
			ModifiedValue .= ChrLib.Get(CustomParagraphBeginning) . LocalModify . EndLine

		}

		if !SendCollaborative {
			A_Clipboard := ModifiedValue
			ClipWait(0.250, 1)
			Sleep 1000
			Send("^v")
		} else {
			A_Clipboard := BackupClipboard
			return ModifiedValue
		}

		;SendText(ModifiedValue)
	}

	Sleep 1000
	A_Clipboard := BackupClipboard
}

QuotatizeSelection(Mode) {
	RegEx := "[a-zA-Zа-яА-ЯёЁ0-9.,:;!?()\`"'-+=/\\]"

	quote_angle_left_double := ChrLib.Get("quote_angle_left_double")
	quote_angle_right_double := ChrLib.Get("quote_angle_right_double")
	quote_low_9_double := ChrLib.Get("quote_low_9_double")
	quote_left_double := ChrLib.Get("quote_left_double")
	quote_right_double := ChrLib.Get("quote_right_double")
	quote_left := ChrLib.Get("quote_left")
	quote_right := ChrLib.Get("quote_right")


	BackupClipboard := A_Clipboard
	PromptValue := ""
	A_Clipboard := ""

	Send("^c")
	ClipWait(0.5, 0)
	PromptValue := A_Clipboard
	if !RegExMatch(PromptValue, RegEx) {
		A_Clipboard := BackupClipboard
		if Mode = "France" {
			SendText(quote_angle_left_double quote_angle_right_double)
		} else if Mode = "Paw" {
			SendText(quote_low_9_double quote_left_double)
		} else if Mode = "Double" {
			SendText(quote_left_double quote_right_double)
		} else if Mode = "Single" {
			SendText(quote_left quote_right)
		}
		return
	}
	A_Clipboard := ""

	if RegExMatch(PromptValue, RegEx) {


		TempSpace := ""
		CheckFor := [
			SpaceKey,
			ChrLib.Get("emsp"),
			ChrLib.Get("ensp"),
			ChrLib.Get("emsp13"),
			ChrLib.Get("emsp14"),
			ChrLib.Get("thinspace"),
			ChrLib.Get("emsp16"),
			ChrLib.Get("narrow_no_break_space"),
			ChrLib.Get("hairspace"),
			ChrLib.Get("punctuation_space"),
			ChrLib.Get("figure_space"),
			ChrLib.Get("tabulation"),
			ChrLib.Get("no_break_space"),
		]

		for space in CheckFor {
			if (PromptValue ~= space . "$") {
				TempSpace := space
				PromptValue := RegExReplace(PromptValue, space . "$", "")
				break
			}
		}

		if Mode = "France" {
			PromptValue := RegExReplace(PromptValue, RegExEscape(quote_angle_left_double), quote_low_9_double)
			PromptValue := RegExReplace(PromptValue, RegExEscape(quote_angle_right_double), quote_left_double)

			PromptValue := quote_angle_left_double . PromptValue . quote_angle_right_double
		} else if Mode = "Paw" {
			PromptValue := quote_low_9_double . PromptValue . quote_left_double
		} else if Mode = "Double" {
			PromptValue := RegExReplace(PromptValue, RegExEscape(quote_left_double), quote_left)
			PromptValue := RegExReplace(PromptValue, RegExEscape(quote_right_double), quote_right)

			PromptValue := quote_left_double . PromptValue . quote_right_double
		} else if Mode = "Single" {
			PromptValue := quote_left . PromptValue . quote_right
		}

		A_Clipboard := PromptValue . TempSpace
		ClipWait(0.250, 0)
		Sleep 250
		Send("^v")
	}

	Sleep 500
	A_Clipboard := BackupClipboard
	return
}

ShowInfoMessage("tray_app_started")

ShowEntryPreview() {
	IB := InputBox("", "", "w256 h92")
	if IB.Result = "Cancel"
		return
	else {
		ChrLib.EntryPreview(IB.Value)
	}
}

<^>^Home:: ShowEntryPreview()