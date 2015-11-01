; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Item_Swap extends Plugin {
	name := "Nemesis Swap"
	description := "Swaps Nemesis bracers"
	hotkey := "^2"

	initSettings(settings) {
		this.settings.add("cellNum", 51, "Cell to right click")
	}
	
	buildSettingsWindow(window) {
		this.settingsWindow.addEditBox("Cell Number", "cellNum")
	}
	run() {
		game.inventory.use(this.settings.get("cellNum"))
		game.inventory.move(this.settings.get(""))
	}

}


