; Replies on base plugin class to be iherited for usage. Prototyping more so.

#include lib/plugin_loader.ahk

class Plugin_Manager {
	pluginsDir := "plugins"
	pluginsFile := "plugins.ahk"
	collection := {}

	; Constructor
	__New() {
	}

	; Register all plugins
	loadAvailable() {
		loader := new Plugin_Loader(this.pluginsFile)
		for i, plugin in loader.getPlugins() {
			this.collection[plugin.name] := plugin

			; Set plugin's API reference
			;plugin.setAPI(api)
		}
	}

	; Merge saved config data with live data
	mergeConfig(pluginHash) {
		for pluginName, dataHash in pluginHash {
			; Skip if plugin is not installed
			if not (plugin := this.collection[pluginName])
				continue

			; Merge the relevant data into live object
			for setting, value in dataHash {
				plugin[setting] := value
			}

			; Activate if need be
			if plugin.active
				this.enable(plugin.name)
		}
	}

	; Retrieve plugin
	get(name) {
		return this.collection[name]
	}

	getList() {
		collection := []
		for k, plugin in this.collection
			collection.push(plugin)
		return collection
	}

	; Activate a plugin by name
	enable(name) {
		; Shorten plugin object reference
		plugin := this.collection[name]
		
		; Set plugin state
		plugin.enable()
		
		; Set OS hotkey state
		hotkey, % plugin.hotkey, % plugin, On
		
		; Log event
		logManager.add(plugin.name " enabled")
	}

	; Disable a plugin by name
	disable(name) {
		; Shorten plugin object reference
		plugin := this.collection[name]

		; Set object state
		plugin.disable()

		; Set OS hotkey state
		hotkey, % plugin.hotkey, Off

		; Log event
		logManager.add(plugin.name " disabled")
	}

	; Toggle plugin on/off
	toggle(name) {
		; Absolutely no clue what this does, should ask stackoverflow
		if (this.collection[name].active)
			this.disable(name)
		else
			this.enable(name)
	}

	; Update a plugin's hotkey both in app and system
	updateHotkey(name, key) {
		; Shorten plugin object reference
		plugin := this.collection[name]

		; Log event
		logManager.add(plugin.name " hotkey updated from " plugin.hotkey " to " key)

		; Set OS hotkey state
		hotkey, % plugin.hotkey, % plugin, Off

		; Change plugin property
		plugin.setHotkey(key)

		; Set OS hotkey state
		hotkey, % plugin.hotkey, % plugin, % (plugin.active ? "On" : "Off")
	}

	; UNUSED
	; Disable in system and remove a plugin from runtime
	delete(name) {
		; Disable hotkey in OS
		this.disable(name)

		; Remove from internal collections
		this.collection.delete(name)
	}

	getPluginsDir() {
		return this.pluginsDir
	}
}