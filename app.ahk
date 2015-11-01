; Needs to be run first to update any plugin file changes. Will run the main
;   script file upon parsing/writing completion.

; Set some variables
pluginsFile := "plugins.ahk"
pluginsDir := "plugins"
pluginFileFormat := "*.plugin.ahk"
mainExecutable := "main.ahk"


; Gather plugin files
lines := "; Note: This file is dynamically created on every bootup.`r`n`r`n"
	. "; Template for all plugins (required for plugin inheritance)`r`n"

; First add the plugin template
lines .= "#Include src\plugin.base.ahk`r`n`r`n"

; Second add all the plugins themselves
lines .= "; Dynamically loaded plugins:`r`n"
Loop, Files, % pluginsDir "\\" pluginFileFormat
	lines .= "#Include " pluginsDir  "\" A_LoopFileName "`r`n"

; Write plugins string to plugin file
FileOpen(pluginsFile, "w").write(lines).close()

; Open main script
run, %mainExecutable%