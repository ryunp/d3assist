class GUI_LV {
	hwnd := 0
	schema := [] ; Column scheme
	parentHwnd := 0

	__New(hwnd) {
		this.parentHwnd := hwnd
	}

	; Callback: must be a function object
	create(options) {
		Gui, % this.parentHwnd ":default"
		Gui, Add, ListView, % "+hwndhwnd " options, % this.getHeader()
		this.hwnd := hwnd
	}

	setCallback(self, func) {
		setControlCallback(this.hwnd, self, func)
	}

	setSchema(array) {
		this.schema := array
	}

	getSchema() {
		return this.schema
	}

	; Returns string of schema in header format
	getHeader() {
		header := ""
		for i, col in this.schema
			header .= (A_Index-1 ? "|" : "") col 
		return header
	}

	getNextSelected(row:=0) {
		this.setControlFocus()
		return LV_GetNext(row)
	}

	getFocused() {
		this.setControlFocus()
		return LV_GetNext("F")
	}

	GetText(row, col) {
		this.setControlFocus()
		LV_GetText(text, row, col)
		return text
	}
	
	; Take an array and pass as variadic parameters (flatten into args)
	addRow(cols) {
		this.setControlFocus()
		LV_Add("", cols*)
	}

	removeRow(row) {
		this.setControlFocus()
		LV_Delete(row)
	}

	updateCol(row, col, val) {
		this.setControlFocus()
		LV_Modify(row, "Col" col, val)
	}

	updatePadding() {
		this.setControlFocus()
		LV_ModifyCol()
	}

	clear() {
		this.setControlFocus()
		LV_Delete()
	}

	; Set the target of the next ui actions
	setControlFocus() {
		gui, % this.parentHwnd ":default"
		Gui, ListView, % this.hwnd
	}
}