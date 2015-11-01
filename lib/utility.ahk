; Some handy functions

join(array, delim) {
    for i, v in array
        str .= (A_Index > 1 ? delim : "") v
    return str
}

; @param control Int Hwnd of UI control for binding callback on
; @param self Object The object that will be assigned to 'this' inside callback
; @param func Object Function to be called
setControlCallback(control, self, function) {
    if isObject(function) {
        ; Function passes is a reference (function object)
        ; Implicitly pass 'this' reference
        split := StrSplit(function.name, ".")
        fn := ObjBindMethod(self, split.pop())
    } else if StrLen(function) {
        ; function passes is a string - global scope function
        ; Explicitly pass 'this' reference
        fn := func(function).bind(self)
    }

	; Set gui control callback
	GuiControl +g, % control, % fn
}

; Look in program files [x86] for standard program pathing
searchProgramFiles(folder, file) {
    if not InStr(file, ".exe")
        file .= ".exe"

    ; Check volumes (doubt it's on Floppy1/2)
    for i, volume in ["C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] {
        ; Look in both x64 and x32 directories
        for j, arch in [" (x86)", ""] {
            ; Concat exe full pathing
            curfile := volume ":\Program Files" arch "\" folder "\" file
            if FileExist(curfile)
                return curfile
        }
    }

    ; You gone done Jerry'd
    return 0
}

; Search through a list of active windows and find a specific Windows' class
getWindowWithClass(title, pattern:="") {
    ; Get a list of windows with given title
    ; ID holds number of windows found, ID# is hwnd
    WinGet, ID, list, i)%title%

    Loop, % ID
    {
        curID := "ID" A_Index
        curHwnd := %curID%
        WinGetClass, className, % "ahk_id " curHwnd
        if (InStr(className, pattern))
            return curHwnd
    }

    return 0
}

getProcessId(name) {
    process, Exist, % name ".exe"
    return ErrorLevel
}

getProcessCmdLine(pid) {
    query := "Select * from Win32_Process where ProcessID = " pid
    for process in ComObjGet("winmgmts:").ExecQuery(query)
        return process.CommandLine
}

showAllProcessInfo() {
    ; Run WQL query to retrieve matching process(es)
    ; Or: "Select * from Win32_Process where CommandLine IS NOT NULL"
    query := "Select * from Win32_Process"
    desiredAttr := ["Name", "Description", "ProcessId", "CommandLine"]

    ; Iterate through each process object
    for process in ComObjGet("winmgmts:").ExecQuery() {
        for i, attr in desiredAttr
            str .= (A_Index > 1 ? "`r`n" : "") attr ": " process[attr]
        str .= "`r`n"
    }

    gui, add, edit, w600 h500, % str
    gui, show
}