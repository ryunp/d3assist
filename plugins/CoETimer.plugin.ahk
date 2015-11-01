; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_CoE_Timer extends Plugin {
	name := "CoE Timer"
	description := "Keeps track of Convention of Elements timer"
	hotkey := "^1"
	
	initLocal() {
		this.timerCallBack := ObjBindMethod(this, "hTimer")
		this.hud := new this._hud()
	}

	initSettings(settings) {
		settings.add("hud_x", 1000, "HUD X pos")
		settings.add("hud_y", 1000, "HUD Y pos")
		settings.add("class_type", "Witch Doctor", "Character Class")
	}
	
	buildSettingsWindow(window) {
		window.addEditBox("X coord", "hud_x")
		window.addEditBox("Y coord", "hud_y")
		window.addEditBox("Class", "class_type")
	}	

	run() {
		this.TOGGLE := !this.TOGGLE

		if this.TOGGLE {
			this.start()
		} else {
			this.stop()
		}

	}

	enableAction() {
		;msgbox CoE Ena
	}

	disableAction() {
		this.stop()
	}

	start() {
		fn := this.timerCallBack
		SetTimer, % fn, % 1000
	}

	stop() {
		fn := this.timerCallBack
		setTimer, % fn, Off
	}

	hTimer() {
		TrayTip, % this.name, % this.hud.getText() ", "
			. this.hud.getColor() ", "
			. mod(floor(A_TickCount/1000), 16)
	}

	class _hud {
		text := "Hud"
		position := {"x": 0, "y": 0}
		color := "#00BAFF"

		getText() {
			return this.text
		}
		getColor() {
			return this.color
		}
		getPosition() {
			return this.position
		}
	}
}


