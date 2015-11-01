class Plugin_SettingsWindow {
	title := ""
	hwnd := 0
	parentHwnd := 0
	plugin := {}
	settingsControls := {}

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
		this.updateControls()
		CoordMode, Mouse, Screen
		MouseGetPos, mX, mY
		Gui, % this.hwnd ":show", % "X" mX " Y" mY
		GuiControl, Focus, % this.cancelBtn
	}

	hide() {
		Gui, % this.hwnd ":hide"
	}

	create() {
		Gui, New, +hwndhwnd ToolWindow -Caption +Border, % this.title
		this.hwnd := hwnd
	}

	addEditBox(label, setting) {
		; Add label text before input box
		this.addControl("text", "xm section", label ":")
		
		; Add input box to change setting value
		hwnd := this.addControl("edit", "ys", this.plugin.getSetting(setting))

		; Save input box handle reference
		this.settingsControls[setting] := {"hwnd": hwnd, "label": label}

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
		this.saveBtn := hwnd

		hwnd := this.addControl("button", "ys", "Cancel")
		this.addControlCallback(hwnd, "hCancel")
		this.cancelBtn := hwnd
	}

	addControlCallback(control, function) {
		; Set function object's THIS to the current plugin instance for function call
		fn := ObjBindMethod(this, function)

		; Add callback to control
		GuiControl +g, % control, % fn
	}

	updateControls() {
		for setting, keys in this.settingsControls
			GuiControl, , % keys.hwnd, % this.plugin.getSetting(setting)
	}

	hSave() {
		updated := []
		; gather all input control data to merge back into plugin's settings
		for setting, keys in this.settingsControls {
			GuiControlGet, value, , % keys.hwnd
			if (value != this.plugin.getSetting(setting)) {
				this.plugin.setSetting(setting, value)
				updated.push(setting)
			}
		}
		for i,setting in updated
			str .= (A_Index-1 ? ", " : "" ) this.settingsControls[setting].label

		if str
			logManager.add(this.plugin.getName() " updated: " str)

		this.hide()
	}

	hCancel() {
		this.hide()
	}
}