class Launcher {
	winTitle := "Battle.net"
	winClass := "qt"
	pid := 0
	execPath := ""
	execSwitch := ""
	running := 0

	getInfo() {
		return ("winTitle = " this.winTitle "`r`n"
			. "winClass = " this.winClass "`r`n"
			. "pid = " this.pid "`r`n"
			. "execPath = " this.execPath "`r`n"
			. "execSwitch = " this.execSwitch "`r`n"
			. "running = " this.running "`r`n")
	}

	__New(game:="d3") {
		this.setExecSwitch(game)
		this.updateRuntimeInfo()
	}
		
	show() {
		this.updateRuntimeInfo()

		if (this.execPath) {
			if (this.running) {
				if not (WinExist(this.winTitle))
		        	TrayTip, % "Launcher", % "Reopening Launcher"
			} else
				TrayTip, % "Launcher", % "Starting " this.execPath

			run, % this.execPath " " this.execSwitch
		} else {
			msgbox % "Cannot start launcher without Executable location."
		}
	}

	play() {
		this.show()

		; Wait for it to be shown
		WinWait, % this.winTitle,, 10
		;sleep 300

		this.hoverPlayButton()

		TrayTip, Hell Senses Your Presence..., LOLOLANALRAPE MORE LACUNI/REAPER GRIFTS WITHOUT STONESINGER
		
		click
	}

	exit() {
		;??
	}

	updateRuntimeInfo() {
		pidCheck := getProcessId(this.winTitle)

		if (this.pid != pidCheck)
			this.pid := pidCheck
		
		this.running := (this.pid ? 1 : 0)

		if not (this.execPath) 
			this.setExecPath()
	}

	setExecSwitch(game) {
		switchAliases := {"wow": ["wow", "World of warcraft"]
			, "diablo3": ["d3", "diablo3", "diablo 3", "diablo III"]}

		for gameID, aliases in switchAliases
			for idx, alias in aliases
				if (game = alias)
					this.execSwitch := "--exec=""launch_uid " gameID """"
	}

	setExecPath() { 
	    if (this.running)
	    	this.execPath := this.getExecPathFromProcess()
	    else {
	    	this.execPath := this.findExecPath()
	    }

	    if not this.execPath
	    	msgbox % "Cannot find any executable file"
	}

	findExecPath() {
		return searchProgramFiles(this.winTitle, this.winTitle)
	}

	getExecPathFromProcess() {
	    pid := getProcessId(this.winTitle)

        ; Get the command used to launch the executable
        pCmdLine := getProcessCmdLine(pid)

        ; Strip down to the dir containing executable
        dir := this.parseCmdLine(pCmdLine)
        exe := dir "\" this.winTitle ".exe"

	    if FileExist(exe)
	        return dir "\" this.winTitle ".exe"
	    else
	    	return 0
    }

    parseCmdLine(path) {
	    ; Strip exe file in string (battle.net specific)
        ; Strange pathing, as the exe is used as an archive containing files
        ; ex: "D:\Program Files (x86)\Battle.net\Battle.net.6119\Battle.net"
	    pattern := "iO)""(.*)[\\/](.*)[\\/]([^\\/]*)"""
	    RegExMatch(path, pattern, match)
	    
	    if (this.DEBUG) {
		    msgbox % "path: "path "`r`n"
			    . "pattern:  " pattern "`r`n"
			    . "match1: " match.value(1) "`r`n"
			    . "match2: " match.value(2) "`r`n"
			    . "match3: " match.value(3)
		}

	    ; Return the path or 0

	    return match.value(1)
	}

	hoverPlayButton() {
		CoordMode, mouse, Screen

		; Get window info
		WinGetPos,X,Y,W,H, % this.winTitle

		; Move mouse to the Play button
		MouseMove, X + 300, % Y + H - 65
	}

	waitForWindow() {
		WinWaitActive, % this.winTitle
	}

	__Call(method, args*) {
		;msgbox % method
	}
}