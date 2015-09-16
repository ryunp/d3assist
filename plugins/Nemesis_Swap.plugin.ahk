; See Plugin_Template.ahk for information on how to build a plugin

class Plugin_Nemesis_Swap extends Plugin {
	name := "Nemesis Swap"
	description := "Swaps Nemesis bracers"
	hotkey := "^1"

	run() {
		msgbox % this.name " placeholder action! " this.localFunc()
	}

	localFunc() {
		return "waaaaaaat"
	}

}