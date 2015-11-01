class Plugin {
	; Default settings
	name := "Plugin Template"
	description := "Abstract class for building a plugin"
	hotkey := "/dev/null"
	active := 0
	settings := {}
	settingsWindow := {}

	; Constructor / Delegation of customizations
	; Acting as an integrated factory for compisition
	__New() {
		this.settings := new Plugin_Settings(this)
		this.settingsWindow := new Plugin_SettingsWindow(this)
		this.settingsWindow.setParent(appWindow.getHwnd())

		; Add author defined settings
		this.initLocal()
		this.initSettings(this.settings)

		; Build plugin settings window components
		this.settingsWindow.addHeader()
		this.buildSettingsWindow(this.settingsWindow)
		this.settingsWindow.addFooter()
	}
 	
	;;
 	; Overriden methods
 	;;
	initSettings(settings) {
		this.settings.add("default", 69, "default setting")
	}
	buildSettingsWindow(window) {
		this.window.addControl("edit", "w200 r3", "Default control")
	}
	run() {
		msgbox % this.name " activated"
	}

	;;
	; Getters
	;;
	getName() {
		return this.name
	}
	getDescription() {
		return this.description
	}
	getHotkey() {
		return this.hotkey
	}
	isActive() {
		return this.active
	}
	getSetting(setting) {
		return this.settings.get(setting)
	}
	getSettingDescription(setting) {
		return this.settings.getDescription(setting)
	}
	getSettingData() {
		return this.settings.getData()
	}


	;;
	; Setters
	;;
	setActive(state) {
		this.active := state
	}
	setHotkey(key) {
		this.hotkey := key
	}
	setSetting(setting, value) {
		this.settings.set(setting, value)
	}


	;;
	; Misc
	;;
	enable() {
		this.active := 1
		if &this.enableAction
			this.enableAction()
	}
	disable() {
		this.active := 0
		if &this.disableAction
			this.disableAction()
	}
	showSettingsWindow() {
		this.settingsWindow.show()
	}
	hideSettingsWindow() {
		this.settingsWindow.hide()
	}


	;;
	; Function Object calling overrides
	;;
	; Expression or paren activation calls this function. 
	__Call(method, args*) {
		if (method == "") {
			;msgbox % "thisObj.() or %thisObj%(): " method ", " args
			return this.Call(args*)
		} else if isObject(method) {
			;msgbox % "aObj.thisObj(): " method ", " args
			return this.Call(method, args*)
		} else {
			;msgbox % "thisObj.Method(): " method ", " args
		}
	}

	; Callbacks (hotkey, timer, etc) call this function implicitly.
	Call() {
		logManager.add(this.name " used")
		this.run()
	}

}