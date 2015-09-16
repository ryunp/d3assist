class Plugin_Manager {
	pluginsDir := "plugins"
	pluginsFile := "plugins.ahk"
	plugins := {}

	get(name) {
		return this.plugins[name]
	}

	enable(name) {
		plugin := this.get(name)
		plugin.enable()
		hotkey, % plugin.getHotkey(), % plugin, On
		logManager.add(plugin.getName() " enabled")
	}

	disable(name) {
		plugin := this.plugins[name]
		plugin.disable()
		hotkey, % plugin.getHotkey(), Off
		logManager.add(plugin.getName() " disabled")
	}

	toggle(name) {
		if (this.plugins[name].active)
			this.disable(name)
		else
			this.enable(name)
	}

	getList() {
		list := []
		for k, plugin in this.plugins
			list.push(plugin)
		return list
	}

	getPluginsDir() {
		return this.pluginsDir
	}

	updateHotkey(name, key) {
		plugin := this.plugins[name]

		logManager.add(plugin.getName() " hotkey updated from " plugin.getHotkey() " to " key)

		; Disable current hotkey trigger (old binding stays)
		curKey := plugin.getHotkey()
		hotkey, % curKey, % plugin, Off

		plugin.setHotkey(key)
		hotkey, % key, % plugin, % (plugin.isActive() ? "On" : "Off")
	}

	loadAvailable() {
		loader := new Plugin_Loader(this.pluginsFile)

		for i, className in loader.getPluginClasses() {
			plugin := new %className%
			this.plugins[plugin.getName()] := plugin
			plugin.setSettingsWindowParent(appWindow.hwnd)
		}
	}
}