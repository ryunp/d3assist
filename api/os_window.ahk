#include os_process.ahk

class OS_Window {
	title := ""
	class := ""
	process := {}

	__New(title, class:="") {
		this.title := title
		this.class := class
		this.process := new OS_Process(title ".exe")
	}

	show() {
		WinActivate, % "ahk_id " this.getHwnd()
	}

	hide() {
		WinHide, % "ahk_id " this.getHwnd()
	}

	close() {
		WinClose, % "ahk_id " this.getHwnd()
	}

	getTitle() {
		return this.title
	}

	getOrigin() {
		WinGetPos, wX, wY,,, % "ahk_id " this.getHwnd()
		return {"x": wX, "y": wY}
	}

	getDimensions() {
		WinGetPos,,, wW, wH, % "ahk_id " this.getHwnd()
		return {"width": wW, "height": wH}
	}

	getHwnd() {
		return WinExist("ahk_class i)" this.class)
	}


	getClass() {
		return this.class
	}

	setClass(class) {
		this.class := class
	}

	exists() {
		return (this.getHwnd() ? 1 : 0)
	}

	isMinimized() {
		; -1 = minimized, 0 = neither, 1 = maximized
		WinGet, state, MinMax, % this.title
		return (state = -1 ? 1 : 0)
	}

	getInfo() {
		return "title: " this.title "`r`n"
			. "class: " this.class "`r`n"
			. "window: " this.getHwnd() "`r`n"
			. "process: " this.process.getPid()
	}
}