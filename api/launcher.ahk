#include os_window.ahk
#include os_process.ahk

class Launcher {
	process := {}
	window := {}
	exeSwitches := []
	
	__New(winTitle, winClass:="") {
		; Checks for running processes when made
		this.process := new OS_Process(winTitle ".exe")
		this.window := new OS_Window(winTitle, winClass)

		; Attempt to find process on creation
		this.setPathing()
	}

	start() {
		this.process.start(join(this.exeSwitches, " "))
	}

	exit() {
		this.process.kill()
	}

	show() {
		this.window.show()		
	}

	close() {
		this.window.exit()
	}

	getTitle() {
		return this.window.getTitle()
	}

	setPathing() {
		if not this.process.capturePath()
			this.process.setPath(searchProgramFiles(this.window.getTitle(), this.process.getName()))
	}

	getSwitches() {
		return "[" join(this.exeSwitches, ", ") "]"
	}
	
	getInfo() {
		return ("----Launcher----`r`n"
			. "exeSwitch = " this.getSwitches() "`r`n"
			. "----Window----`r`n"
			. this.window.getInfo() "`r`n"
			. "----Process----`r`n"
			. this.process.getInfo())
	}
}