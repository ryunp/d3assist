#include lib/json_parser.ahk

class Config_Manager {
	buffer := {}
	json := new json()

	__New(file) {
		this.file := file
	}

	save() {
		this.updateBuffer()
		this.flush()
	}

	load() {
		string := FileOpen(this.file, "r").read()
		this.buffer := json.toObj(string)
		this.mergeData()
	}

	updateBuffer() {
		for i, plugin in pluginManager.getList() {
			data := {"active": plugin.isActive()
				, "hotkey": plugin.getHotkey()
				, "settings": plugin.getSettingData()}

			this.buffer[plugin.getName()] := data
		}
	}

	flush() {
		FileOpen(this.file, "w").write(json.fromObj(this.buffer))
		this.buffer := {}
	}

	mergeData() {
		for i, plugin in pluginManager.getList() {
			data := this.buffer[plugin.getName()]

			if(data.active)
				plugin.setActive(data.active)

			if (data.hotkey)
				plugin.setHotkey(data.hotkey)
			
			for setting, value in data.settings {
				if value
					plugin.setSetting(setting, value)
			}

			if plugin.isActive()
				pluginManager.enable(plugin.getName())
		}
	}
}