; Replies on base plugin class to be iherited for usage. Prototyping more so.

class Plugin_Manager {
	pluginsDir := "plugins"
	pluginsFile := "plugins.ahk"
	collection := {}

	; Constructor
	__New() {
	}

	; Register all plugins
	init() {
		this.loadAll()
	}

	; Parse the dynamically loaded plugin names as strings to dynamically
	; create new objects
	loadAll() {
		; Scan file where plugins were detected and #included for plugin names
		names := this.parsePluginsFile()

		; Create a plugin object for each found
		for i, name in names {
			; Adjust plugin pathing ('plugin' prefix)
			className := "Plugin_" . name

			; Dynamically create new object 
			plugin := new %className%

			; Add to hash with name as key
			this.collection[plugin.name] := plugin

			; Set plugin's API reference
			;plugin.setAPI(api)
		}
	}

	; Retrieve plugin
	get(name) {
		return this.collection[name]
	}

	; Returns hash of plugin objects
	getAll() {
		all := []
		for k, plugin in this.collection
			all.push(plugin)
		return all
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
		log.add(plugin.name " enabled")
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
		log.add(plugin.name " disabled")
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
		log.add(plugin.name " hotkey updated from " plugin.hotkey " to " key)

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

	; Parse the dynamically created plugin include file to determine which
	; plugins have been loaded
	parsePluginsFile() {
		; Open plugins file
		fh := FileOpen(this.pluginsFile, "r")

		; List to hold plugin names
		found := []

		; Search for plugin files
		while (line := fh.ReadLine()) {
			; Skip comment lines
			if not (substr(line,1,1) = ";") {
				; 'Options)': [i] Match case-insensitive, [O] return matching Object
				RegExMatch(line, "iO)#include\s*\w*\\(.*).plugin.ahk", match)

				; Check that it found a matching string
				if (match.pos) {
					; Add plugin name to array of names
					found.push(match.value(1))
				}
			}
		}
		; Close file handle
		fh.close()

		; Return the list of plugin names
		return found
	}

	getPluginsDir() {
		return this.pluginsDir
	}
}