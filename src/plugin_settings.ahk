class Plugin_Settings {
	settings := {"test": 2}
	descriptions := {"test": "something"}

	__New() {
	}

	add(key, value, description) {
		this.settings[key] := value
		this.descriptions[key] := description
	}

	get(key) {
		return this.settings[key]
	}

	set(key, value) {
		this.settings[key] := value
	}

	getDescription(key) {
		return this.descriptions[key]
	}

	getData() {
		return this.settings
	}

	print() {
		str := ""
		
		for setting, value in this.settings
			str .= (A_Index ? "`r`n" : "") setting " = " value ", " this.descriptions[setting]

		msgbox % str
	}
}