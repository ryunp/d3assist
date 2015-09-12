#include lib/json_parser.ahk

class Config_Manager {
	__New(file) {
		this.file := file
	}

	init() {

	}

	setPluginsConfig() {
		json := new json()
		pluginList := pluginManager.getList()
		buffer := {}

		for i, plugin in pluginList {
			data := {"active": plugin.active
				, "hotkey": plugin.hotkey
				, "configuration": plugin.configuration}
			buffer[plugin.name] := data
		}
		string := json.write(buffer)
		FileOpen(this.file, "w").write(string)
	}

	getPluginsConfig() {
		json := new json()
		string := FileOpen(this.file, "r").read()
		return (string ? json.read(string) : 0)
	}
}