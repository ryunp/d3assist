; Seperating UI callbacks may be nice, but we shall see. ObjBindMethod works
;   well to keep functions organized in the UI class.

/*
; Moved to UI class function
Gui_hPluginLVEvent(ui) {
	; Set default UI for operations
	Gui, % ui.hwndMain ":Default"

	; Check for correct UI control
	if (A_GuiControl = "Gui_PluginLV") {
		; Check for focused item
	  	row := LV_GetNext("F")
	  	if (row) {
	  		; Get row info
			LV_GetText(pActive, row, 1)
  			LV_GetText(pName row, 2)
  			LV_GetText(pHK, row, 3)
  			
  			; Respond to event
		  	if (A_GuiEvent = "c") {
		  		; "c" = click
	  			GuiControl, , % ui.hwndHotkeyInput, % pHK
	  		} else if (A_GuiEvent = "A") {
		    	; "A" = double click
  				ui.hPluginToggle()
		  	} else if (A_GuiEvent = "RightClick") {
		        ; "S" = selected
		        ;msgbox % LV_GetCount("S")
		    }		    
		}
	}
}


; Moved to UI class function
Gui_Handler_HotkeyChange() {
	row := LV_GetNext()
	GuiControlGet, inHK, , % ui.hwndHotkeyInput
	LV_GetText(pName, row, 2)
	LV_GetText(pHK, row, 3)

	plugins.updateHotkey(pName, inHK)
	ui.updatePluginsListView()
}

; Moved to UI class function
Gui_Handler_PluginToggle() {
	; Set default UI for operations
	Gui, % ui.hwndMain ":Default"

	; See what user selected	
	row := LV_GetNext()

	while (row) {
		LV_GetText(pActive, row, 1)
		LV_GetText(pName, row, 2)

		; Disable/Enable plugin 
		pActive ? plugins.disable(pName) : plugins.enable(pName)

		; Check for more selections
		row := LV_GetNext(row)
	} 
}
*/