class Plugin_Loader {
	file := ""

	__New(file) {
		this.file := file
	}


	; Returns an array of plugin objects
	getPlugins() {
		pluginFiles := this.getPluginFiles()
		pluginList := []

		; Collect class names from plugin files
		for i, file in pluginFiles {
			className := this.getPluginClass(file)
			
			; Dynamically create new object 
			plugin := new %className%

			; Add to hash with name as key
			pluginList.push(plugin)
		}

		return pluginList
	}
	
	; Returns an array of strings for each plugin file found
	getPluginFiles() {
	; Open plugins file
		fh := FileOpen(this.file, "r")

		; List to hold plugin names
		found := []

		; Search for plugin files
		while (line := fh.ReadLine()) {
			; Skip comment lines
			if not (substr(line,1,1) = ";") {
				; 'Options)': [i] Match case-insensitive, [O] return matching Object
				RegExMatch(line, "iO)#include\s*(\w*\\.*.plugin.ahk)", match)

				; Check that it found a matching string
				if (match.pos) 
					found.push(match.value(1))
			}
		}
		; Close file handle
		fh.close()

		; Return the list of plugin files
		return found
	}

	getPluginClass(file) {
		className := ""

		fh := FileOpen(file, "r")
		while (line := fh.ReadLine()) {
			; 'Options)': [i] Match case-insensitive, [O] return matching Object
			RegExMatch(line, "iO)class ([^\s]*) ", match)

			; Check that it found a matching string
			if (match.pos) 
				className := match.value(1)

		}
		fh.close()

		return className
	}

	__Call(method, params*) {
	}
}