class Plugin_Salvage_Junk extends Plugin {
	; See Plugin_Template.ahk for information on how to build a plugin

	__New() {
		settings := {name: "Salvage Junk"
			, description: "Salvages white, blue, yellow items"
			, hotkey: "^3"}

		; This will merge with the default plugin settings ()
		base.updateSettings(settings)
	}
	
	run() {
		msgbox % this.name " placeholder action!"
	}
}