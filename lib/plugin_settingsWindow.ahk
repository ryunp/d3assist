class Plugin_SettingsWindow {
	hwnd := 0
	parentHwnd := 0
	title := ""
	plugin := {}
	inputControls := {}

	__New(plugin) {
		this.plugin := plugin
		this.title := plugin.getName() " Settings"
		this.create()
	}

	setParent(hwnd) {
		this.parentHwnd := hwnd
		Gui, % this.hwnd ":+Owner" this.parentHwnd
	}

	getHwnd() {
		return this.hwnd
	}

	show() {
		Gui, % this.hwnd ":show"
	}

	hide() {
		Gui, % this.hwnd ":hide"
	}

	create() {
		Gui, New, +hwndTMPHWND ToolWindow, % this.title
		this.hwnd := TMPHWND
	}

	addEditBox(label, setting) {
		; Add label text before input box
		this.addControl("text", "xm section", label ":")
		
		; Add input box to change setting value
		hwnd := this.addControl("edit", "ys", this.plugin.getSetting(setting))

		; Save input box handle reference
		this.inputControls[setting] := hwnd

		this.addControl("text", "ys", this.plugin.getSettingDescription(setting))
	}

	addControl(type, options:="", text:="") {
		; Set this plugin's GUI window to use for future operations
		Gui, % this.hwnd ":default"

		; Add the control
		Gui, Add, % type, % "+hwndNewHwnd " options, % text
		
		return NewHwnd
	}

	addHeader(header) {
		this.addControl("text", "center", header)
	}

	addFooter() {
		hwnd := this.addControl("button", "section xs", "Save")
		this.addControlCallback(hwnd, "hSave")

		hwnd := this.addControl("button", "ys", "Cancel")
		this.addControlCallback(hwnd, "hCancel")
	}

	addControlCallback(control, function) {
		; Set function object's THIS to the current plugin instance for function call
		fn := ObjBindMethod(this, function)

		; Add callback to control
		GuiControl +g, % control, % fn
	}


	hSave() {
		updated := []
		; gather all input control data to merge back into plugin's settings
		for setting, hwnd in this.inputControls {
			GuiControlGet, value, , % hwnd
			if (value != this.plugin.getSetting(setting)) {
				this.plugin.setSetting(setting, value)
				updated.push(setting)
			}
		}
		for i,v in updated
			str .= (A_Index-1 ? ", " : "" ) v

		logManager.add(this.plugin.getName() " updated: " str)

		this.hide()
	}

	hCancel() {
		this.hide()
	}
}