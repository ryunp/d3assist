; Author: ryunp[aulAgmailDcom]
; Date: 08/24/15
; Version: 0.75.BETA.Mark2.theThird.twiceRemoved.Anal
; Licensing: #teamRyan
; Description: A plugin manager. The plugins will help reduce common
;   and repetitive tasks that cause high cognitive resource drain. I imagine
;   this application like a character attribute: you gain varying -% CRD
;   (Cognitive Resource Drain) for each plugins effectiveness.

;-------------------------------------------------------------------------------
; DEPENDENCIES
;-------------------------------------------------------------------------------
#Include lib\utility.ahk
#Include lib\log.ahk
#Include lib\game_launcher.ahk
#include lib\plugin_manager.ahk
#include lib\ui.ahk
#include plugins.ahk
 
;-------------------------------------------------------------------------------
; SETUP ENVIRONMENT
;-------------------------------------------------------------------------------
;SetTitleMatchMode, Regex ; Need for case-insensitive searches via 'i)'

; Globals objects used throughout includes (I know; I cried as well)
;global api := new API()
global log := new Log()
global ui := new UI("Super Pooper 9000")
global plugins := new Plugin_Manager()
global launcher := new Launcher()

; Initialization
ui.init()
;api.init()
plugins.init()
ui.populatePluginsList(plugins.getAll())

; Setup application menu
setAppMenu()

; Setup system tray menu
setSysTray()

; Dadoy
ui.show()

;-------------------------------------------------------------------------------
return  ; AUTOEXEC END
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; APP HOTKEYS 
;-------------------------------------------------------------------------------
!1:: ; - show fukin GUI
	ui.show()
return
 
!2:: ; - hide fukin GUI
	ui.hide()
return

!3:: ; - show Launcher
	launcher.show()
return

!4:: ; - get ready to click play
	launcher.show()
	launcher.hoverPlayButton()
return

; F12 - Quit program
~F12::ExitApp

!5::
	Launcher.play()
	; StartD3() {
	; 	CoordMode, mouse, Screen
	; 	MouseGetPos, mX, mY
	; 	launcher.play()
	; 	;sleep 300
	; 	MouseMove, mX, mY
	; }
return

setAppMenu() {
	Menu, FileMenu, Add, E&xit, Exit

	fn := func("menuAbout")
	Menu, HelpMenu, Add, &About, % fn

	Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the two sub-menus that were created above.
	Menu, MyMenuBar, Add, &Help, :HelpMenu
	Gui, Menu, MyMenuBar
}

; Quick and dirty function down here, all alone. :(
setSysTray() {
	; Bind function to variable (object)
	fnStart := ObjBindMethod(ui, "StartD3")
	fnShow := ObjBindMethod(ui, "show")

	; Main SysTray Menu
	Menu, tray, NoStandard				; Clear current standard menu items
	Menu, Tray, Add, StartD3, % fnStart	    ; call function object (pointer)
	Menu, Tray, Add, ShowUI, % fnShow	    ; call function object (pointer)
	Menu, tray, Add						; Seperator
	Menu, tray, Standard				; Add standard menu items back on (bottom)
}


menuAbout() {
	msgbox % ("Double clicking on plugin also toggles."
			. "`r`n`r`n"
			. "To create new plugin, copy one of the basic plugin files and change:`r`n"
			. "1) Settings info in __New()`r`n"
			. "2) Class name to: 'Plugin_<name in settings with underscores>'`r`n"
			. "3) File name to: '<name in settings with underscores>.plugin.ahk'`r`n"
			. "4) Alter run() bl ock code`r`n"
			. "Run 'bootstrap.ahk' if plugins are added/removed from plugins folder`r`n"
			. "If any errors make sure the name is not misspelled between in 1-3`r`n"
			. "`r`n"
			. "ryunp")
}

MenuHandler:
return

Exit:
	ExitApp
return