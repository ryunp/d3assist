; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Salvage_Junk extends Plugin {
	name := "Salvage Junk"
	description := "Salvages white, blue, yellow items"
	hotkey := "^3"
	
	run() {
		msgbox % this.name " placeholder action!"
	}

	; buildSettingsWindow() {
		
	; }
}