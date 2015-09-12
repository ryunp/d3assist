; UI's are a real pain to deal with when trying to objectify functionality.
;   Callbacks can get really messed up, just look at all the issues people have
;   with JavaScript. So building some sort of architecture was a lot of
;   shooting from the hip. And ragefails. Yeehaw

#include lib\gui_lv.ahk

class App_Window {
	; Instance vars
	hwnd := 0
	title := "ui"
	LV_Plugins := {}

	; Constructor
	__New(name) {
		this.title := name
	}

	; New UI and components
	build() {
		;;
		; New GUI window
		;;
		Gui, New, +hwndTMPHWND, % this.title
		this.hwnd := TMPHWND

		; Set properties
		Gui, font, s9

		; Game client actions
		gui, add, button, +hwndTMPHWND Section, Open Launcher
		setControlCallback(TMPHWND, launcher, launcher.show)
		gui, add, button, +hwndTMPHWND ys, Start Diablo III
		setControlCallback(TMPHWND, this, this.hStartD3)
		gui, add, Button, +hwndTMPHWND ys, Plugins Dir
		setControlCallback(TMPHWND, this, this.hOpenPluginsDir)

		; ListView for plugin display
		this.LV_Plugins := new GUI_LV(this)
		this.LV_Plugins.setSchema(["Active", "Name", "Hotkey", "Description"])
		this.LV_Plugins.create("AltSubmit Section xs w500 r6")
		this.LV_Plugins.setCallback(this, this.hLV_PluginsEvent)
		
		; Hotkey alteration components
		Gui, add, button, +hwndTMPHWND Section, On/Off
		setControlCallback(TMPHWND, this, this.hPluginToggle)

		Gui, add, text, ys, Hotkey:
		Gui, add, hotkey, +hwndTMPHWND ys w150
		this.hwndHotkeyInput := TMPHWND

		Gui, add, button, +hwndTMPHWND ys, Apply
		setControlCallback(TMPHWND, this, this.hHotkeyChange)

		; Reporting box (log window)
		gui, add, Edit, +hwndTMPHWND xs w500 r3
		logManager.setOutput(TMPHWND)
	}

	; Show the main GUI window
	show() {
		Gui, % this.hwnd ":show"
	}

	; Hide the main GUI window
	hide() {
		Gui, % this.hwnd ":hide"
	}

	; Adds plugins to ListView
	; @param pluginList Array List of plugin objects to add
	populatePluginsList(pluginList) {
		LV_delete()
		
		for i, plugin in pluginList {
			cols := []

			for i, item in this.LV_Plugins.getSchema()
				cols.push(plugin[item])

			this.LV_Plugins.addRow(cols)
		}

		; Adjust cell widths
		this.LV_Plugins.updatePadding()
	}


	;---------------------------------------------------------------------------
	; Callback Handlers ( COUPLING WITH PLUGIN MANAGER )
	;---------------------------------------------------------------------------

	hStartD3() {
		CoordMode, mouse, Screen
		MouseGetPos, mX, mY
		launcher.play()
		sleep 300
		MouseMove, mX, mY
	}

	hOpenPluginsDir() {
		run, % "explorer " A_ScriptDir "\" pluginManager.getPluginsDir()
	}
	
	hHotkeyChange() {
		row := this.LV_Plugins.getNextSelected()

		; Get the hotkey input, plugin name
		GuiControlGet, inHK, , % this.hwndHotkeyInput
		pName := this.LV_Plugins.getText(row, 2)
		curHK := this.LV_Plugins.getText(row, 3)

		; Only change if different
		if not (curHK = inHK) {
			pluginManager.updateHotkey(pName, inHK)
			this.LV_Plugins.updateCol(row, 3, inHK)
		}
	}

	hPluginToggle() {
		row := this.LV_Plugins.getNextSelected()
		while (row) {
			; Gather plugin active state and name
			pActive := this.LV_Plugins.getText(row, 1)
			pName := this.LV_Plugins.getText(row, 2)

			;msgbox % A_thisfunc ": " row ", "  pName ", " pActive

			; Toggle active
			pluginManager.toggle(pName)

			; Update LV
			this.LV_Plugins.updateCol(row, 1, !pActive)

			row := this.LV_Plugins.getNextSelected(row)
		}
	}

	hLV_PluginsEvent() {
		; Check for focused item	  	
	  	if (row := this.LV_Plugins.getFocused()) {
	  		; Get row info
			pActive := this.LV_Plugins.getText(row, 1)
  			pName := this.LV_Plugins.getText(row, 2)
  			pHK := this.LV_Plugins.getText(row, 3)
  			
  			; Respond to event
		  	if (A_GuiEvent = "c") {
		  		; "c" = click
	  			GuiControl, , % this.hwndHotkeyInput, % pHK
	  		} else if (A_GuiEvent = "A") {
		    	; "A" = double click
  				this.hPluginToggle()
		  	} else if (A_GuiEvent = "RightClick") {
		        ;show context menu
		    }		    
		}
	}
}
