; Base class (object) for custom plugins. This object contains functionality
;   that is relied upon by the plugin manager. I'm using some interesting 
;   meta-functionality that helps proxy access to settings, and callbacks.
;   Take care not to fuck shit up, dude. GL, HF, nr20

class Plugin {
	; Default settings
	name := "Plugin Template"
	description := "Abstract class for building a plugin"
	hotkey := "/dev/null"
	active := 0
	configuration := {}
	settingWindow := {}

	; Constructor
	__New() {
		this.settingWindow := new PluginSetting_Window(this)
		this.buildSettingsWindow()
		;this.settingWindow.show()
	}

	; Each plugin should create their own run() function which will be
	; be called on hotkey usage
	run() {
		; OVERRIDE ME
	}
	
	; Custom settings UI for each plugin to create
	buildSettingsWindow() {
		Gui, add, edit, r5 w400 h400, This is some default stuff
	}



	; Updates state
	enable() {
		this.active := 1
	}
	disable() {
		this.active := 0
	}

	getName() {
		return this.name
	}
	setName(name) {
		this.name := name
	}

	getDescription() {
		return this.description
	}
	setDescription(text) {
		this.description := text
	}

	getHotkey() {
		return this.hotkey
	}
	setHotkey(key) {
		this.hotkey := key
	}

	getActive() {
		return this.active
	}
	setActive(state) {
		this.active := state
	}

	getConfiguration() {
		return this.configuration
	}

	; Not calling functions directly, do not need?. REMOVE? TEST!
	__Call(method, args*) {
		if (method == "") {
			;msgbox % "this.() or %this%(): " method ", " args
			return this.Call(args*)
		} else if isObject(method) {
			;msgbox % "Obj.this(): " method ", " args
			return this.Call(method, args*)
		} else {
			;msgbox % "this.Method(): " method ", " args
		}
	}

	; Callbacks (hotkey,timer, etc) call this function implicitly
	; Using as abstract proxy for the custom plugin's functionality
	Call() {
		log.add(this.name " used")
		this.run()
	}

}