; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Repair_Gear extends Plugin {
	name := "Repair Gear"
	description := "Repairs all gear"
	hotkey := "^2"
	configuration := {}
	
	run() {
		msgbox % this.name " placeholder action!"
	}

	; buildSettingsWindow() {
		
	; }
}