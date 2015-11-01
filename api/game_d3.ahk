#include game.ahk
#include launcher_bnet.ahk

class Game_D3 extends Game {
	launcher := {}

	__New() {
		this.base.__New("Diablo III")

		this.launcher := new Launcher_BNet()
		launcher.setGame("Diablo III")
	}


}