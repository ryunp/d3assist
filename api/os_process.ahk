#include ..\lib\utility.ahk

class OS_Process {
	name := ""
	path := ""

	__New(name) {
		this.name := (InStr(name, ".exe") ? name : name ".exe")
	}

	;;
	; Actions
	;;

	start(args) {
		run, % this.getPath() " " join(args, " ")
	}

	kill() {
		if this.getPid()
			process, Close, % this.getPid()
	}

	;;
	; Getters
	;;

	isRunning() {
		return (this.getPid() ? 1 : 0)
	}

	getName() {
		return this.name
	}

	getPid() {
		process, Exist, % this.name
		return ErrorLevel
	}

	getPath() {
		return this.path
	}

	getInfo() {
		return "pid: " this.getPid() "`r`n"
			. "name: " this.getName() "`r`n"
			. "path: " this.getPath() "`r`n"
			. "running: " this.isRunning()
	}

	;;
	; Setters
	;;

	setPath(newPath) {
		this.path := newPath
	}

	capturePath() {
		query := "Select * from Win32_Process where ProcessID = " this.getPid()
		    for process in ComObjGet("winmgmts:").ExecQuery(query)
		    	this.path := process.ExecutablePath ;CommandLine
	    
	    return (this.path ? 1 : 0)
	}
}