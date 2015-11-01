#include launcher.ahk

class Launcher_BNet extends Launcher {
	exeSwitchAliases := {"diablo3": ["d3", "diablo3", "diablo 3", "diablo III"]
	, "wow": ["wow", "World of warcraft"]}

	__New() {
		base.__New("Battle.net", "qt")
	}

	show() {
		this.process.start(join(this.exeSwitches, " "))
	}

	play() {
		this.start()
		WinWait, % this.window.getTitle()
		msgbox % "Window found:`r`n`r`n" this.getInfo()

		this.selectPlayButton()
		click
	}

	selectPlayButton() {
		CoordMode, Mouse, Screen
		pos := this.window.getOrigin()
		dim := this.window.getDimensions()
		buttonYOffset := 65

		MouseMove, % (pos.x + 300), % (pos.y + dim.height - buttonYOffset)
	}

	findExe() {
		path := searchProgramFiles(this.window.getTitle(), this.window.getTitle())

		if not (path)
			InputBox, userPath, % "Doh", "Unable to find EXE in standard places`r`nEnter path to EXE"

		return path
	}

	setGame(game) {
		this.setExeSwitch(game)
	}

	setExeSwitch(game) {
		for gameID, aliases in this.exeSwitchAliases
			for idx, alias in aliases
				if (game = alias) {
					this.exeSwitches.push("--exec=""launch_uid " gameID """")
					return 1
				}
		return 0
	}
}