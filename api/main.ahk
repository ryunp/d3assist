#include ..\lib\utility.ahk
#include game.ahk
#include launcher_bnet.ahk

SetTitleMatchMode, Regex ; Need for case-insensitive searches via 'i)'
CoordMode, Mouse, Screen

gameTitle := "Diablo III"
d3 := new Game(gameTitle)
d3.setWindowClass("D3 Main Window Class")
d3.inventory := new Inventory()
launcher := new Launcher_BNet()
launcher.setGame(gameTitle)


return

F1:: 
	launcher.start()
return

F2::
	d3.inventory.use(51)
return

F3::
	msgbox % launcher.getInfo()
return

F4::
	msgbox % d3.getInfo()
return

F12::
	ExitApp
return