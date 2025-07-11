class UIMyRecipes {
	static __New() {
		globalInstances.MyRecipesGUI := this()
		return
	}

	setCached := False
	title := ""

	w := 800
	h := 600

	xPos := (A_ScreenWidth - this.w) / 2
	yPos := (A_ScreenHeight - this.h) / 2

	lvW := this.w - 20
	lvH := this.h - 80
	lvX := (this.w - this.lvW) / 2
	lvY := 10

	columns := ["dictionary.name", "dictionary.recipe", "dictionary.result", "dictionary.entry", "dictionary.file"]
	columnWidths := [this.lvW * 0.35, this.lvW * 0.26, this.lvW * 0.36, 0, 0]

	grpBoxX := this.lvX
	grpBoxY := (this.lvY + this.lvH) + 1
	grpBoxW := this.lvW
	grpBoxH := this.h - this.grpBoxY - 5

	btnW := 128
	btnH := 32
	btnY := this.grpBoxY + (this.grpBoxH - this.btnH) // 2
	btnX(multi := 1) => (this.grpBoxX + 10 + (this.btnW * (multi - 1)))

	mainFileLast := 0
	selectedRow := 0

	__New() {
		Event.OnEvent("UI Data", "Changed", () => this.setCached := False)
		Event.OnEvent("UI Language", "Switched", () => this.setCached := False)
		return
	}

	Constructor() {
		this.title := App.Title("+status+version") " — " Locale.Read("gui.recipes")

		local recipesWindow := Gui()
		recipesWindow.Title := this.title

		local localizedCols := []
		for column in this.columns
			localizedCols.Push(Locale.Read(column))

		local recipesLV := recipesWindow.AddListView(Format("vRecipesLV w{} h{} x{} y{} +NoSort -Multi", this.lvW, this.lvH, this.lvX, this.lvY), localizedCols)

		for i, _ in this.columnWidths
			recipesLV.ModifyCol(i, this.columnWidths[i])

		this.Fill(recipesLV)

		local grpBox := recipesWindow.AddGroupbox(Format("vGrpBox w{} h{} x{} y{}", this.grpBoxW, this.grpBoxH, this.grpBoxX, this.grpBoxY))

		local createButton := recipesWindow.AddButton(Format("vCreateBtn w{} h{} x{} y{}", this.btnW, this.btnH, this.btnX(), this.btnY), "+")
		local deleteButton := recipesWindow.AddButton(Format("vDeleteBtn w{} h{} x{} y{}", this.btnW, this.btnH, this.btnX(2), this.btnY), Chr(0x2212))
		local updateButton := recipesWindow.AddButton(Format("vUpdateBtn w{} h{} x{} y{}", this.btnW, this.btnH, this.btnX(3), this.btnY))
		GuiButtonIcon(updateButton, ImageRes, 229)

		createButton.SetFont("s16")
		deleteButton.SetFont("s16")

		recipesLV.OnEvent("Click", (LV, rowNumber) => this.selectedRow := rowNumber)
		recipesLV.OnEvent("DoubleClick", (LV, rowNumber) => this.ItemEdit(recipesWindow, LV, rowNumber))
		createButton.OnEvent("Click", (btn, inf) => this.ItemEdit(recipesWindow, recipesLV))
		deleteButton.OnEvent("Click", (btn, inf) => this.ItemDelete(recipesLV))

		updateButton.OnEvent("Click", (*) => (
			MyRecipes.Update(),
			recipesLV.Delete(),
			this.Fill(recipesLV)
		))

		return recipesWindow
	}

	Fill(LV) {
		local data := MyRecipesStore.GetAll("IndexList AsArray")
		local languageCode := Language.Get()

		Loop data.Length // 2 {
			local index := A_Index * 2 - 1
			local recipeName := data[index]
			local recipeEntry := data[index + 1]

			local title := recipeEntry.Has("titles") && recipeEntry["titles"].Has(languageCode) ? recipeEntry["titles"][languageCode] : recipeEntry.Has("name") ? recipeEntry["name"] : recipeName
			local filePath := recipeEntry["filePath"]

			if filePath = MyRecipes.file
				this.mainFileLast++

			LV.Add(,
				title,
				UIMyRecipes.ResultRecipeStrHandle(recipeEntry["recipe"]),
				UIMyRecipes.ResultRecipeStrHandle(recipeEntry["result"], True),
				recipeName,
				filePath
			)
		}

		return
	}


	Show(X?, Y?) {
		if this.title != "" && WinExist(this.title) {
			WinActivate(this.title)
		} else {

			if !this.setCached
				this.GUI := this.Constructor()
			this.GUI.Show(Format("w{} h{} x{} y{}", this.w, this.h, IsSet(X) ? X : this.xPos, IsSet(Y) ? Y : this.yPos))

			this.setCached := True
		}
		return
	}

	ItemEdit(parentGUI, LV, rowNumber?) {
		if !IsSet(rowNumber)
			return UIMyRecipes.Editor(parentGUI, LV)

		local recipeName := LV.GetText(rowNumber, 4)
		local filePath := LV.GetText(rowNumber, 5)

		if RegExMatch(filePath, "i)(xcompose|\\)", &match) {
			MsgBox(Locale.Read("gui.recipes.warnings." (match[1] = "xcompose" ? "xcompose_break" : "autoimported_edit_unable")) "`n`n" Chr(0x2026) "\User\profile-" App.profileName "\" filePath, App.Title("+status+version"), "Icon!")
			return
		}

		return UIMyRecipes.Editor(parentGUI, LV, rowNumber, recipeName, filePath)
	}

	ItemDelete(LV) {
		local recipeName := LV.GetText(this.selectedRow, 4)
		local MB := MsgBox(Locale.ReadInject("gui.recipes.warnings.remove_confirm", [recipeName]), App.Title(), 4)

		if MB = "No" {
			return
		} else if MB = "Yes" {
			MyRecipesStore.Delete(recipeName)
			ChrLib.RemoveEntry(recipeName)
			LV.Delete(this.selectedRow)
			this.selectedRow := 0
			this.mainFileLast--

			MyRecipesStore.DumpDefault()
		}
		return
	}

	static ResultRecipeStrHandle(str, setShort := False) {
		local output := str is Array ? str.ToString() : str

		output := ChrRecipeHandler.MakeStr(output)
		if setShort
			output := Util.StrFormattedReduce(output, 20)

		return output
	}

	Class Editor {
		title := ""

		defW := 300
		defH := 500
		w := this.defW
		h := this.defH

		CalcSizes() {

			this.grpBoxW := this.w - 20
			this.grpBoxH := this.h - 20
			this.grpBoxX := (this.w - this.grpBoxW) / 2
			this.grpBoxY := (this.h - this.grpBoxH) / 2

			this.btnW := 100
			this.btnH := 32
			this.btnY := this.grpBoxY + this.grpBoxH - this.btnH - 10

			this.fieldW := this.grpBoxW - 20
			this.fieldH := 24
			this.fieldX := this.grpBoxX + (this.grpBoxW - this.fieldW) / 2

			this.fieldTitleW := this.fieldW
			this.fieldTitleH := 14
			this.fieldTitleX := this.fieldX

			this.fieldTitleY := this.grpBoxY + 20
			this.fieldY := (this.fieldTitleY + this.fieldTitleH) + 6

			this.fieldStep := 30

		}

		btnX(multi := 1) => (this.grpBoxX + 10 + (this.btnW * (multi - 1)))

		incrementField(stepsCount := 1, extraHeight := 1, verticalExpand := False) {
			local x := this.fieldX
			local y := this.fieldY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
			local w := this.fieldW
			local h := (this.fieldH * (extraHeight)) + (verticalExpand ? (this.h - this.defH) : 0)
			local field := [x, y, w, h]

			local x := this.fieldTitleX
			local y := this.fieldTitleY + (stepsCount - 1) * (this.fieldH + this.fieldStep)
			local w := this.fieldTitleW
			local h := this.fieldTitleH
			local fieldTitle := [x, y, w, h]
			return [field, fieldTitle]
		}

		Resize(editorWindow, MinMax, W, H) {
			this.w := W
			this.h := H
			this.CalcSizes()

			editorWindow["EditorGrpBox"].Move(this.grpBoxX, this.grpBoxY, this.grpBoxW, this.grpBoxH)
			editorWindow["SectionTitle"].Move(this.incrementField(1)[2]*)
			editorWindow["SectionField"].Move(this.incrementField(1)[1]*)
			editorWindow["NameTitle"].Move(this.incrementField(2)[2]*)
			editorWindow["NameField"].Move(this.incrementField(2)[1]*)
			editorWindow["RecipeTitle"].Move(this.incrementField(3)[2]*)
			editorWindow["RecipeField"].Move(this.incrementField(3)[1]*)
			editorWindow["TagsTitle"].Move(this.incrementField(4)[2]*)
			editorWindow["TagsField"].Move(this.incrementField(4)[1]*)
			editorWindow["ResultTitle"].Move(this.incrementField(5)[2]*)
			editorWindow["ResultField"].Move(this.incrementField(5, 6, True)[1]*)
			editorWindow["SaveBtn"].Move(this.btnX(1), this.btnY, this.btnW, this.btnH)
			editorWindow["CancelBtn"].Move(this.btnX(2), this.btnY, this.btnW, this.btnH)

			return
		}

		__New(parentGUI, LV, rowNumber?, recipeName?, filePath?) {
			this.CalcSizes()

			this.rowNumber := IsSet(rowNumber) ? rowNumber : False
			this.LV := LV

			this.recipeName := IsSet(recipeName) ? recipeName : ""
			this.filePath := IsSet(filePath) ? App.paths.profile "\" filePath : MyRecipes.filePath

			parentGUI.GetPos(&parentX, &parentY, &parentW, &parentH)

			this.xPos := parentX + ((parentW - this.w) / 2)
			this.yPos := parentY + ((parentH - this.h) / 2)

			this.Show()
			return
		}

		Constructor() {
			this.title := App.Title("+status+version") " — " Locale.Read("gui.recipes.create_or_edit")

			local editorWindow := Gui()
			editorWindow.Title := this.title
			editorWindow.Opt("+Resize +MinSize" this.defW "x" this.defH)
			editorWindow.OnEvent("Size", this.Resize.Bind(this))

			local grpBox := editorWindow.AddGroupBox(Format("vEditorGrpBox x{} y{} w{} h{}", this.grpBoxX, this.grpBoxY, this.grpBoxW, this.grpBoxH), Locale.Read("gui.recipes.create_or_edit." (this.recipeName != "" ? "edit" : "create")) " " this.recipeName)

			local sectionTitle := editorWindow.AddText(Format("vSectionTitle x{} y{} w{} h{}", this.incrementField(1)[2]*), Locale.Read("dictionary.entry_name+gui.recipes.create_or_edit.name_restrictions"))
			local sectionField := editorWindow.AddEdit(Format("vSectionField x{} y{} w{} h{} Limit48 -Multi", this.incrementField(1)[1]*), this.recipeName)

			local nameTitle := editorWindow.AddText(Format("vNameTitle x{} y{} w{} h{}", this.incrementField(2)[2]*), Locale.Read("gui.recipes.create_or_edit.name"))
			local nameField := editorWindow.AddEdit(Format("vNameField x{} y{} w{} h{} -Multi", this.incrementField(2)[1]*))

			local recipeTitle := editorWindow.AddText(Format("vRecipeTitle x{} y{} w{} h{}", this.incrementField(3)[2]*), Locale.Read("dictionary.recipe"))
			local recipeField := editorWindow.AddEdit(Format("vRecipeField x{} y{} w{} h{} -Multi", this.incrementField(3)[1]*))

			local tagsTitle := editorWindow.AddText(Format("vTagsTitle x{} y{} w{} h{}", this.incrementField(4)[2]*), Locale.Read("dictionary.tags"))
			local tagsField := editorWindow.AddEdit(Format("vTagsField x{} y{} w{} h{} -Multi", this.incrementField(4)[1]*))

			local resultTitle := editorWindow.AddText(Format("vResultTitle x{} y{} w{} h{}", this.incrementField(5)[2]*), (Locale.Read("gui.recipes.create_or_edit.result")))
			local resultField := editorWindow.AddEdit(Format("vResultField x{} y{} w{} h{} Multi WantTab", this.incrementField(5, 6)[1]*))

			if this.recipeName != "" {
				local recipeEntry := MyRecipesStore.Get(this.recipeName)
				nameField.Value := recipeEntry["name"]
				recipeField.Value := recipeEntry["recipeRaw"]
				tagsField.Value := recipeEntry["tagsRaw"]
				resultField.Value := recipeEntry["result"][1]

				local chrsCount := Util.StrDigitFormat(StrLen(resultField.Value))
				local pagesCount := Util.StrPagesCalc(resultField.Value)
				resultTitle.Text := Locale.ReadInject("gui.recipes.create_or_edit.result<>overflow_properties", [chrsCount, pagesCount])
			}


			local saveButton := editorWindow.AddButton(Format("vSaveBtn x{} y{} w{} h{}", this.btnX(1), this.btnY, this.btnW, this.btnH), Locale.Read("dictionary.save"))
			local cancelButton := editorWindow.AddButton(Format("vCancelBtn x{} y{} w{} h{}", this.btnX(2), this.btnY, this.btnW, this.btnH), Locale.Read("dictionary.cancel"))

			saveButton.OnEvent("Click", (*) => this.RecipeSave())
			cancelButton.OnEvent("Click", (*) => WinExist(this.title) && WinClose(this.title))
			resultField.OnEvent("Change", UpdateResultTitle)
			return editorWindow

			UpdateResultTitle(field, info) {
				local chrsCount := Util.StrDigitFormat(StrLen(resultField.Value))
				local pagesCount := Util.StrPagesCalc(resultField.Value)
				resultTitle.Text := Locale.ReadInject("gui.recipes.create_or_edit.result<>overflow_properties", [chrsCount, pagesCount])
				return
			}
		}

		Show() {
			if this.title != "" && WinExist(this.title)
				WinActivate(this.title)
			else {
				this.GUI := this.Constructor()
				this.GUI.Show(Format("x{} y{} w{} h{}", this.xPos, this.yPos, this.w, this.h))
			}

			return
		}

		RecipeSave() {
			if this.CollectData(&collectedData) {
				local newRecipeName := collectedData[1]

				if this.recipeName = "" && (MyRecipesStore.Has(newRecipeName) || ChrLib.entries.HasOwnProp(newRecipeName)) {
					return MsgBox(Locale.ReadInject("gui.recipes.warnings.exists" (!MyRecipesStore.Has(newRecipeName) ? "_internal" : ""), [newRecipeName]), App.Title(), "Icon!")
				}

				if this.recipeName != "" && newRecipeName != this.recipeName {
					MyRecipesStore.Rename(this.recipeName, newRecipeName)
					ChrLib.RenameEntry(this.recipeName, newRecipeName)
				}

				MyRecipesReg(collectedData)
				local newEntry := MyRecipesStore.Get(newRecipeName)
				local entryToBeRegistered := newEntry.Clone()

				if ChrLib.entries.HasOwnProp(newRecipeName)
					entryToBeRegistered.Set("index", ChrLib.entries.%newRecipeName%.Get("index"))

				ChrReg([newRecipeName, entryToBeRegistered], "Custom")

				local languageCode := Language.Get()
				local title := newEntry.Has("titles") && newEntry["titles"].Has(languageCode) ? newEntry["titles"][languageCode] : newEntry.Has("name") ? newEntry["name"] : newRecipeName

				globalInstances.MyRecipesGUI.mainFileLast++
				local lastIndex := globalInstances.MyRecipesGUI.mainFileLast

				local data := [
					title,
					UIMyRecipes.ResultRecipeStrHandle(newEntry["recipe"]),
					UIMyRecipes.ResultRecipeStrHandle(newEntry["result"], True),
					newRecipeName,
					newEntry["filePath"]
				]

				if this.rowNumber || lastIndex
					this.LV.%!this.rowNumber ? "Insert" : "Modify"%(!this.rowNumber ? lastIndex : this.rowNumber, , data*)
				else
					this.LV.Add(, data*)

				MyRecipesStore.DumpDefault()
			}
			return
		}

		CollectData(&collectedData) {
			if (this.GUI["SectionField"].Value = "" || this.GUI["NameField"].Value = "" || this.GUI["RecipeField"].Value = "" || this.GUI["ResultField"].Value = "")
				return False
			local data := Map(
				"name", this.GUI["NameField"].Value,
				"recipe", this.GUI["RecipeField"].Value,
				"result", [this.GUI["ResultField"].Value],
			)
			if this.GUI["TagsField"].Value != ""
				data.Set("tags", this.GUI["TagsField"].Value)

			collectedData := [this.GUI["SectionField"].Value, data]
			return True
		}
	}
}