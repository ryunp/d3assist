class Log {
	logbook := []
	output := {}

	__New() {
	}

	setOutput(output) {
		this.output := output
	}

	; Add entry to log
	add(text) {
		; Get timestamp
		FormatTime, timstamp

		; Add entry to our log records
		entry := {"text": text, "timestamp": timestamp}
		this.logbook.push(entry)

		;msgbox % "added (" this.logbook.MaxIndex() ")`r`n" text
		this.updateLogDisplay(entry)
	}

	; Add entry to control displaying the data
	updateLogDisplay(entry) {
		; Format timestamp
		FormatTime, timstamp, % entry.timestamp, HH:mm:ss

		; Grab current logbuffer
		GuiControlGet, data,, % this.output

		; Append latest entry to top
		GuiControl, , % this.output, % "[" timstamp "] " entry.text "`r`n" data 
	}
}