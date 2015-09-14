class PluginSetting_Window {
	hwnd := 0
	title := "settings"
	plugin := {}
	parentHwnd := 0

	__New(plugin) {
		this.plugin := plugin
		this.title := plugin.name " Settings"
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
}