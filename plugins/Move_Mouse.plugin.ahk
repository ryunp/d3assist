; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Move_Mouse extends Plugin {
	name := "Move Mouse"
	description := "Simply move the mouse from left to right"
	hotkey := "^4"

	initSettings(settings) {
		settings.add("speed", 50, "1-100, lower is faster")
		settings.add("distance", 500, "Pixels to travel")
	}
	
	buildSettingsWindow(window) {
		window.addEditBox("Speed", "speed")
		window.addEditBox("Distance","distance")
	}

	run() {
		; Set coord relativity
		CoordMode, Mouse, Screen

		; Start at middle left
		MouseMove, 0 , % A_ScreenHeight/2, 0

		; Go to middle right
		MouseMove, % this.settings.get("distance"), % A_ScreenHeight/2, % this.settings.get("speed")
	}

}