#include os_window.ahk

/*
0x250996
Diablo III, D3 Splash Window Class
574,327
770x423

0x260996
Diablo III, D3 Main Window Class
0,0
1920x1080
*/

class Game {
	title := ""
	window := {}

	__New(title) {
		this.title := title
		this.window := new OS_Window(title)
	}

	;;
	; Getters
	;;

	getGameTitle() {
		return this.title
	}
	
	getWindowTitle() {
		return this.window.getTitle()
	}

	getInfo() {
		return "window`r`n" this.window.getInfo() "`r`n`r`n"
		. "process`r`n" this.window.process.getInfo()
	}

	;;
	; Setters
	;;

	setWindowClass(class) {
		this.window.setClass(class)
	}
}