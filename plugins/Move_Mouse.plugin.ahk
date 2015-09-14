; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Move_Mouse extends Plugin {
	name := "Move Mouse"
	description := "Simply move the mouse from left to right"
	hotkey := "^4"
	configuration := {"speed": 50}
	settingWindow := {}
	
	run() {
		; Set coord relativity
		CoordMode, Mouse, Screen

		; Start at middle left
		MouseMove, 0 , % A_ScreenHeight/2, % this.configuration.speed

		; Go to middle right
		MouseMove, % A_ScreenWidth, % A_ScreenHeight/2, % this.configuration.speed
	}

	buildSettingsWindow() {
		gui, % this.settingWindow.hwnd ":Default"

		Gui, add, text, section, Speed:
		Gui, add, edit, +hwndTMPHWND ys, % this.configuration.speed
		this.hControl_speed := TMPHWND
		
		gui, add, button, +hwndTMPHWND section xs, Save
		fn := ObjBindMethod(this, "hSave")
		GuiControl +g, % TMPHWND, % fn

		gui, add, button, +hwndTMPHWND ys, Cancel
		fn := ObjBindMethod(this, "hCancel")
		GuiControl +g, % TMPHWND, % fn
	}

	hSave() {
		GuiControlGet, speed, , % this.hControl_speed
		this.configuration.speed := speed
		logManager.add(this.name " settings adjusted")
		this.settingWindow.hide()
	}

	hCancel() {
		this.settingWindow.hide()
	}
}