class Plugin_Repair_Gear extends Plugin {
	; See Plugin_Template.ahk for information on how to build a plugin

	__New() {
		settings := {name: "Repair Gear"
			, description: "Repairs all gear"
			, hotkey: "^2"}

		; This will merge with the default plugin settings ()
		base.updateSettings(settings)
	}
		
	run() {
		msgbox % this.name " placeholder action!"
	}
}