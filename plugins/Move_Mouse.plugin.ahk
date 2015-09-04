class Plugin_Move_Mouse extends Plugin {
	; See Plugin_Template.ahk for information on how to build a plugin

	__New() {
		settings := {name: "Move Mouse"
			, description: "Simply move the mouse from left to right"
			, hotkey: "^4"}

		; This will merge with the default plugin settings ()
		base.updateSettings(settings)
	}
	
	run() {
		; Set coord relativity
		CoordMode, Mouse, Screen

		; Mouse move speed (higher is slower: 1-100)
		speed = 50

		; Start at middle left
		MouseMove, 0 , % A_ScreenHeight/2, % speed

		; Go to middle right
		MouseMove, % A_ScreenWidth, % A_ScreenHeight/2, % speed
	}
}