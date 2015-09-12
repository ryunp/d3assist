; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Move_Mouse extends Plugin {
	name := "Move Mouse"
	description := "Simply move the mouse from left to right"
	hotkey := "^4"
	configuration := {"speed": 50}
	
	run() {
		; Set coord relativity
		CoordMode, Mouse, Screen

		; Start at middle left
		MouseMove, 0 , % A_ScreenHeight/2, % this.configuration.speed

		; Go to middle right
		MouseMove, % A_ScreenWidth, % A_ScreenHeight/2, % this.configuration.speed
	}
}