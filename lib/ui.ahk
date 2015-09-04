; UI's are a real pain to deal with when trying to objectify functionality.
;   Callbacks can get really messed up, just look at all the issues people have
;   with JavaScript. So building some sort of architecture was a lot of
;   shooting from the hip. And ragefails. Yeehaw

#include lib\UI_LV.ahk

class UI {
	; Instance vars
	hwnd_main := 0
	title := "ui"
	LV_Plugins := {}

	; Constructor
	__New(name) {
		this.title := name
	}

	; New UI and components
	init() {
		;;
		; New GUI window
		;;
		Gui, New, +hwndhwnd, % this.title
		this.hwndMain := hwnd

		; Set properties
		Gui, font, s9

		; Game client actions
		gui, add, button, +hwndhwnd Section, Open Launcher
		setControlCallback(hwnd, launcher, launcher.show)
		gui, add, button, +hwndhwnd ys, Start Diablo III
		setControlCallback(hwnd, this, this.hStartD3)
		gui, add, Button, +hwndhwnd ys, Plugins Dir
		setControlCallback(hwnd, this, this.hOpenPluginsDir)

		; ListView for plugin display
		this.LV_Plugins := new UI_LV(this)
		this.LV_Plugins.setSchema(["?", "Name", "Hotkey", "Description"])
		this.LV_Plugins.create("AltSubmit Section xs w500 r6")
		this.LV_Plugins.setCallback(this, this.hLV_PluginsEvent)
		
		; Hotkey alteration components
		Gui, add, button, +hwndhwnd Section, On/Off
		setControlCallback(hwnd, this, this.hPluginToggle)

		Gui, add, text, ys, Hotkey:
		Gui, add, hotkey, +hwndhwnd ys w150
		this.hwndHotkeyInput := hwnd

		Gui, add, button, +hwndhwnd ys, Apply
		setControlCallback(hwnd, this, this.hHotkeyChange)

		; Reporting box (log window)
		gui, add, Edit, +hwndhwnd xs w500 r3
		log.setOutput(hwnd)
	}

	; Show the main GUI window
	show() {
		Gui, % this.hwndMain ":show"
	}

	; Hide the main GUI window
	hide() {
		Gui, % this.hwndMain ":hide"
	}

	; Adds plugins to ListView
	; @param pluginList Array List of plugin objects to add
	populatePluginsList(pluginList) {
		for i, plugin in pluginList {
			this.LV_Plugins.addRow([plugin.active, plugin.name, plugin.hotkey, plugin.description])
		}

		; Adjust cell widths
		this.LV_Plugins.updatePadding()
	}

	; Update row data
	; @param row Array Column data to update
	updateAll() {
		; Get list view info
		rows := LV_GetCount()
		cols := LV_GetCount("Column")

		; Iterate over rows
		loop, % rows
		{
			; Save current row
			curRow := A_Index

			; Get plugin name of row
			LV_GetText(pName, A_Index, 2)

			; Pull correct plugin for comparison
			plugin := plugins.get(pName)

			; Save a col scheme array for comparison
			pluginCols := [plugin.active, plugin.name, plugin.hotkey, plugin.description]

			; Go through each column
			loop, % cols
			{
				; Get the data for current column
				LV_GetText(field, curRow, A_Index )
				
				; Compare to plugin's data
				if not (field = pluginCols[A_Index]) {
					;msgbox % "Found change in " plugin.name "`r`n" . "col: " A_Index "`r`n" . "registry: " pluginCols[A_Index] "`r`n" . "view: " field
					LV_Modify(curRow, "Col" A_Index, pluginCols[A_Index])
				}
			}
		}
	}

	;---------------------------------------------------------------------------
	; Callback Handlers
	;---------------------------------------------------------------------------

	hStartD3() {
		CoordMode, mouse, Screen
		MouseGetPos, mX, mY
		launcher.play()
		sleep 300
		MouseMove, mX, mY
		Click
	}

	; COUPLING DETECTED
	hOpenPluginsDir() {
		run, % "explorer " A_ScriptDir "\" plugins.getPluginsDir()
	}
	
	hHotkeyChange() {
		row := this.LV_Plugins.getNextSelected()

		; Get the hotkey input, plugin name
		GuiControlGet, inHK, , % this.hwndHotkeyInput
		pName := this.LV_Plugins.getText(row, 2)
		curHK := this.LV_Plugins.getText(row, 3)

		; Only change if different
		if not (curHK = inHK) {
			plugins.updateHotkey(pName, inHK)
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
			plugins.toggle(pName)

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
