class Random_Number extends Plugin {
	name := "Randdom Number"
	description := "A random number generator"
	hotkey := "^6"

	initSettings(settings) {
		settings.add("random", 100, "Random number between 0 and 100")
	}
	
	buildSettingsWindow(window) {
		window.addEditBox("Random Num","random")
	}

	run() {
		Random, rand, 0, 100
		this.settings.set("random", rand)
	}

}