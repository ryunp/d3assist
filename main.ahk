; Author: ryunp[aulAgmailDcom]
; Date: 08/24/15
; Version: 0.75.BETA.Mark2.theThird.twiceRemoved.Anal
; Licensing: #teamRyan

;-------------------------------------------------------------------------------
; DEPENDENCIES 
;-------------------------------------------------------------------------------
#Include lib\utility.ahk
#Include lib\game_launcher.ahk
#include lib\plugin_loader.ahk
#include lib\plugin_settings.ahk
#include lib\plugin_settingsWindow.ahk
#include lib\plugin_manager.ahk
#include lib\config_manager.ahk
#Include lib\log_manager.ahk
#include lib\app_window.ahk
#include plugins.ahk
 

;-------------------------------------------------------------------------------
; SETUP ENVIRONMENT
;-------------------------------------------------------------------------------
;SetTitleMatchMode, Regex ; Need for case-insensitive searches via 'i)'

; Globals objects used throughout includes (I know; I cried as well)
;global api := new API()
global logManager := new Log_Manager()
global appWindow := new App_Window("Super Pooper 9000")
global pluginManager := new Plugin_Manager()
global configManager := new Config_Manager("plugins.config.json")
global launcher := new Launcher()


pluginManager.loadAvailable()
configManager.load()
appWindow.create()
appWindow.setPluginsLV()
setAppMenu()
setSysTray()

appWindow.show()
OnExit, Exit
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
	launcher.show()
return

!4:: ; - get ready to click play
	launcher.show()
	launcher.waitForWindow()
	launcher.hoverPlayButton()
return

; F12 - Quit program
~F12::ExitApp

!5::
	CoordMode, mouse, Screen
	MouseGetPos, mX, mY
	launcher.show()
	launcher.waitForWindow()
	launcher.hoverPlayButton()
	MouseMove, mX, mY
return

setAppMenu() {
	gui, % appWindow.hwnd ":default"
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


Exit:
	configManager.save()
	ExitApp
return