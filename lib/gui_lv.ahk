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
			header .= col "|"

		return SubStr(header, 1, -1)
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
	; @param cols Array of column data: []
	addRow(cols) {
		this.setControlFocus()

		; Add column data (flatten array into args)
		LV_Add("", cols*)
	}

	; Removes specified row
	removeRow(row) {
		this.setControlFocus()
		LV_Delete(row)
	}

	; Update a specific column
	updateCol(row, col, val) {
		this.setControlFocus()

		LV_Modify(row, "Col" col, val)
	}

	updatePadding() {
		this.setControlFocus()

		LV_ModifyCol()
	}

	; Remove all listed items
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