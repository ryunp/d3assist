; Base class (object) for custom plugins. This object contains functionality
;   that is relied upon by the plugin manager. I'm using some interesting 
;   meta-functionality that helps proxy access to settings, and callbacks.
;   Take care not to fuck shit up, dude. GL, HF, nr20

class Plugin {
	; Default settings
	settings := {name: "Plugin Template"
		, description: "Abstract class for building a plugin"
		, hotkey: "/dev/null"
		, active: 0}

	; Each plugin should create their own run() function which will be
	; be called on hotkey activation
	run() {
		msgbox % "Plugin did not correctly override the " A_ThisFunc "() method"
	}

	; Updates state
	enable() {
		this.settings.active := 1
	}
	disable() {
		this.settings.active := 0
	}

	setHotkey(key) {
		this.settings.hotkey := key
	}

	; Only update keys that exist in base settings
	updateSettings(settings) {
		for k,v in settings
			if this.settings.HasKey(k)
				this.settings[k] := v
	}
	
	; Return a string of all plugin settings
	printSettings() {
		str := ""
		for k,v in this.settings
			str .= k " = " v "`r`n"
		return substr(str, 1, -2)
	}

	; Constructor !This should not be instantiated!
	__New(settings) {
		msgbox % "Nope.avi, Goodbye"
		ExitApp
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

	; @help: Meta-Function
	; Proxy use of GETTING <plugin>.settings.X to <plugin>.X
	__Get(key) {
		if (this.settings.HasKey(key))
			return this.settings[key]
	}

	; @help: Dynamic Properties
	; Proxy use of SETTING <plugin>.settings.hotkey to <plugin>.hotkey

	; Callbacks (hotkey,timer, etc) call this function implicitly
	; Using as abstract proxy for the custom plugin's functionality
	Call() {
		log.add(this.settings.name " used")
		this.run()
	}

}