class Plugin_Loader {
	file := ""

	__New(file) {
		this.file := file
	}
	
	getPluginClasses() {
		classList := []

		for i, fileName in this.getPluginFileNames()
			classList.push(this.parsePluginClass(fileName))

		return classList
	}
	
	getPluginFileNames() {
	; Open plugins file
		fh := FileOpen(this.file, "r")
		fileNames := []

		while (line := fh.ReadLine()) {
			; Skip comment lines
			if not (substr(line,1,1) = ";") {
				; '?)': i = Match case-insensitive, O = Return matching Object
				RegExMatch(line, "iO)#include\s*(\w*\\.*.plugin.ahk)", match)
				if (match.pos) 
					fileNames.push(match.value(1))
			}
		}

		fh.close()
		return fileNames
	}

	parsePluginClass(file) {
		className := ""
		fh := FileOpen(file, "r")

		while (line := fh.ReadLine()) {
			; 'Options)': [i] Match case-insensitive, [O] return matching Object
			RegExMatch(line, "iO)class ([^\s]*) ", match)

			; Check that it found a matching string
			if (match.pos) {
				className := match.value(1)
				break
			}
		}

		fh.close()
		return className
	}
}