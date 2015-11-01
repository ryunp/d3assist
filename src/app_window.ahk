#include gui_lv.ahk

class App_Window {
	hwnd := 0
	title := "ui"
	LV_Plugins := {}

	__New(name) {
		this.title := name
	}

	create() {
		; New GUI window
		Gui, New, +hwndTMPHWND, % this.title
		this.hwnd := TMPHWND

		; Set properties
		Gui, font, s9

		; Game client actions
		gui, add, button, +hwndTMPHWND Section, Open Launcher
		setControlCallback(TMPHWND, this, this.hOpenLauncher)
		gui, add, button, +hwndTMPHWND ys, Start Diablo III
		setControlCallback(TMPHWND, this, this.hStartD3)
		gui, add, Button, +hwndTMPHWND ys, Plugins Dir
		setControlCallback(TMPHWND, this, this.hOpenPluginsDir)

		; ListView for plugin display
		this.LV_Plugins := new GUI_LV(this.hwnd)
		this.LV_Plugins.setSchema(["Active", "Name", "Hotkey", "Description"])
		this.LV_Plugins.create("AltSubmit Section xs w500 r6")
		this.LV_Plugins.setCallback(this, this.hLV_PluginsEvent)
		
		; Hotkey alteration components
		Gui, add, button, +hwndTMPHWND Section, On/Off
		setControlCallback(TMPHWND, this, this.hPluginToggle)
		Gui, add, button, +hwndTMPHWND ys, Change Hotkey
		setControlCallback(TMPHWND, this, this.hHotkeyChange)

		; Reporting box (log window)
		gui, add, Edit, +hwndTMPHWND xs w500 r3
		logManager.setOutput(TMPHWND)
	}

	show() {
		Gui, % this.hwnd ":show"
	}

	hide() {
		Gui, % this.hwnd ":hide"
	}

	getHwnd() {
		return this.hwnd
	}

	setPluginsLV() {
		LV_delete()
		for i, plugin in pluginManager.getList() {
			cols := []
			for i, item in this.LV_Plugins.getSchema()
				cols.push(plugin[item])
			this.LV_Plugins.addRow(cols)
		}
		this.LV_Plugins.updatePadding()
	}


	;---------------------------------------------------------------------------
	; Callback Handlers
	;---------------------------------------------------------------------------

	hStartD3() {
		CoordMode, mouse, Screen
		MouseGetPos, mX, mY
		game.launcher.play()
		sleep 300
		MouseMove, mX, mY
	}
	hOpenLauncher() {
		game.launcher.show()
	}

	hOpenPluginsDir() {
		run, % "explorer " A_ScriptDir "\" pluginManager.getPluginsDir()
	}
	
	hHotkeyChange() {
		row := this.LV_Plugins.getNextSelected()
		if not row
			return

		; Get the hotkey input, plugin name
		hotkeyInput := HotkeyGUI(this.hwnd, , , True)
		if not hotkeyInput
			return
			
		nameLV := this.LV_Plugins.getText(row, 2)
		hotkeyLV := this.LV_Plugins.getText(row, 3)

		; Only change if different
		if not (hotkeyLV = hotkeyInput) {
			pluginManager.updateHotkey(nameLV, hotkeyInput)
			this.LV_Plugins.updateCol(row, 3, hotkeyInput)
		}
	}

	hPluginToggle() {
		row := this.LV_Plugins.getNextSelected()
		while (row) {
			activeLV := this.LV_Plugins.getText(row, 1)
			nameLV := this.LV_Plugins.getText(row, 2)

			pluginManager.toggle(nameLV)
			this.LV_Plugins.updateCol(row, 1, !activeLV)
			row := this.LV_Plugins.getNextSelected(row)
		}
	}

	hLV_PluginsEvent() {  	
	  	if (row := this.LV_Plugins.getFocused()) {
	  		; Get selection info
			activeLV := this.LV_Plugins.getText(row, 1)
  			nameLV := this.LV_Plugins.getText(row, 2)
  			hotkeyLV := this.LV_Plugins.getText(row, 3)
  			
  			; Respond to events
		  	if (A_GuiEvent = "c") {
		  		; "c" = click
	  			GuiControl, , % this.hwndHotkeyInput, % hotkeyLV

	  		} else if (A_GuiEvent = "A") {
		    	; "A" = double click
  				this.hPluginToggle()

		  	} else if (A_GuiEvent = "RightClick") {
		        pluginManager.get(nameLV).showSettingsWindow()

		    }		    
		}
	}
}
