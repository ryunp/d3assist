;#include ../lib/inventory.ahk
; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Nemesis_Swap extends Plugin {
	__New() {
		settings := {name: "Nemesis Swap"
			, description: "Swaps Nemesis bracers"
			, hotkey: "^1"}

		; This will merge with the default plugin settings
		base.updateSettings(settings)
	}

	run() {
		msgbox % this.name " placeholder action! " this.localFunc()
	}

	localFunc() {
		return "waaaaaaat"
	}
}