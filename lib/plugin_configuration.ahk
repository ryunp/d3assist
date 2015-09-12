class Plugin_Configuration {
	this.hwnd := 0
	this.plugin := {}
	this.title := ""

	__New(plugin) {

	}

	init() {

	}

	show() {

	}

	hide() {

	}

	create() {
		Gui, New, +Hwndhwnd, % this.title

		Gui, Add, text, section, % this.plugin.getName()
		Gui, Add, text, ys, Speed:
		Gui, Add, edit, +hwndhwnd, % this.plugin.getConfiguration().speed
	}
}