; Some handy functions


; This one is a gnar gnar. Mainly used to provide a callback to a function
;   that is within the class that is setting the callback. This is essentially
;   the same mechanics JavaScript has with how 'this' works in callbacks
; @param control Int Hwnd of UI control for binding callback on
; @param self Object The object that will be assigned to 'this' inside callback
; @param func Object Function to be called
setControlCallback(control, self, function) {
    if isObject(function) {
        ; Function passes is a reference (function object)
        ; Implicitly pass reference to UI ('this' inside function)
        split := StrSplit(function.name, ".")
        fn := ObjBindMethod(self, split.pop())
    } else if StrLen(function) {
        ; function passes is a string - global scope function
        ; Explicitly pass reference to UI (parameter of function)
        fn := func(function).bind(self)
    }

	; Set gui control callback
	GuiControl +g, % control, % fn
}

; Look in program files [x86] for standard program pathing
searchProgramFiles(folder, file) {
    ; Check volumes (doubt it's on Floppy1/2)
    for i, volume in ["C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] {
        ; Look in both x64 and x32 directories
        for j, arch in [" (x86)", ""] {
            ; Concat exe full pathing
            curfile := volume ":\Program Files" arch "\" folder "\" file ".exe"

            ;msgbox % curfile
            ; Ricktastic?
            if FileExist(curfile) {
                return curfile
            }
        }
    }

    ; You gone done Jerry'd
    return 0
}

; Search through a list of active windows and find a specific Windows' class
getWindowWithClass(title, pattern:="") {
    ; Get a list of windows with given title
    ;  Note: This command is fucking old school, left over from the old days
    WinGet, id, list, i)%title%

    ; Loop through each window. 'id' holds number of windows found. id# (index)
    ;  holds the actual window hwnd. This is remnants of pre-object/function AHK
    Loop, %id%
    {
        ; Set window hwnd to current index in list of found windows (*pointer!)
        thisID := id%A_Index%

        ; Snag it's native Windows' class name (Some deep Windows shit)
        WinGetClass, thisClass, ahk_id %thisID%

        ; Check if it's what we are looking for
        if (instr(thisClass, pattern))
            return thisID
    }

    return 0
}

getProcessId(name) {
    process, Exist, % name ".exe"
    return ErrorLevel
}

getProcessCmdLine(PID) {
    ; Get WMI service object.
    wmi := ComObjGet("winmgmts:")
    
    ; Run WQL query to retrieve matching process(es).
    query := wmi.ExecQuery("Select * from Win32_Process where ProcessID = " PID)
    
    ; There should only be one result formatted {obj, type} (don't need type)
    for process, IGNORE_ME in query
        break

    ; return the command used to start the process
    return process.CommandLine
}

; Super cool. Simply call the function. AHK can do some rad things
showAllProcessInfo() {
    ; Get WMI service object.
    wmi := ComObjGet("winmgmts:")
    
    ; Run WQL query to retrieve matching process(es)
    ; Or: "Select * from Win32_Process where CommandLine IS NOT NULL"
    query := wmi.ExecQuery("Select * from Win32_Process")

    ; Set an array of attributes I want to pull from the Win32_Process class
    ; See references URL
    attribs := ["Name", "Description", "ProcessId", "CommandLine"]

    ; Loop through each process object
    for process, IGNORE_ME in query {
        ; For each object, loop through our defined attributes
        for idx, attr in attribs {
            ; Concatenate each attribute to a growing string variable
            s .= attr ": " process[attr] "`r`n"
        }
        ; Newline after each process' attribute data for visual orgasm
        s .= "`r`n"
    }

    ; Create and show a UI window to display data
    gui, add, edit, w600 h500, % s
    gui, show
}