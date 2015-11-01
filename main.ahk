; Author: ryunp[aulAgmailDcom]
; Date: 08/24/15
; Version: 0.75.BETA.Mark2.theThird.twiceRemoved.Anal
; Licensing: #teamRyan

;-------------------------------------------------------------------------------
; DEPENDENCIES 
;-------------------------------------------------------------------------------
; Set dir \src
#Include %A_ScriptDir%\src
#include plugin_loader.ahk
#include plugin_settings.ahk
#include plugin_settingsWindow.ahk
#include plugin_manager.ahk
#include config_manager.ahk
#Include log_manager.ahk
#include app_window.ahk

; Set dir \lib
#Include %A_ScriptDir%\lib
#Include utility.ahk
#include HotkeyGUI2.ahk

; Set dir \api
#Include %A_ScriptDir%\api
#Include game_d3.ahk
;#Include launcher_bnet.ahk

; Set dir back to root
#include %A_ScriptDir%
#include plugins.ahk
 

;-------------------------------------------------------------------------------
; SETUP ENVIRONMENT
;-------------------------------------------------------------------------------
SetTitleMatchMode, Regex ; Need for case-insensitive searches via 'i)'
CoordMode, mouse, Screen

; Globals objects
global logManager := new Log_Manager()
global appWindow := new App_Window("Super Pooper 9000")
global pluginManager := new Plugin_Manager()
global configManager := new Config_Manager("plugins.config.json")
global game := new Game_D3()
;global launcher := new Launcher_BNet("Diablo III")

; Initializations
appWindow.create() 
pluginManager.loadAvailable()
configManager.load() 
appWindow.setPluginsLV()
setAppMenu()
setSysTray()
appWindow.show()
msgbox % game.launcher.getInfo()


OnExit, ExitAction
;-------------------------------------------------------------------------------
return  ; AUTOEXEC END
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; APP HOTKEYS 
;-------------------------------------------------------------------------------
!1:: ; - show fukin GUI
	appWindow.show()
return
 
!2:: ; - hide fukin GUI
	appWindow.hide()
return

!3:: ; - show Launcher
	game.launcher.show()
return

!4:: ; - get ready to click play
	game.launcher.selectPlayButton()
return

; F12 - Quit program
~F12::ExitApp

!5::
	CoordMode, mouse, Screen
	MouseGetPos, mX, mY
	game.launcher.show()
	game.launcher.selectPlayButton()
	MouseMove, mX, mY
return

^LButton::
	msgbox CTRL + LBUTTON
return

setAppMenu() {
	gui, % appWindow.hwnd ":default"
	Menu, FileMenu, Add, E&xit, ExitAction

	fn := func("menuAbout")
	Menu, HelpMenu, Add, &About, % fn

	Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the two sub-menus that were created above.
	Menu, MyMenuBar, Add, &Help, :HelpMenu
	Gui, Menu, MyMenuBar
}


; Quick and dirty function down here, all alone. :(
setSysTray() {
	; Bind function to variable (object)
	fnStart := ObjBindMethod(launcher, "play")
	fnShow := ObjBindMethod(appWindow, "show")

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


ExitAction:
	configManager.save()
	ExitApp
return