class Plugin_Multiple_Presses extends Plugin {
	; See Plugin_Template.ahk for information on how to build a plugin

	__New() {
		; Plugin settings
		settings := {name: "Multiple Presses"
			, description: "Tracks multiple presses"
			, hotkey: "^5"}

		; This will overwrite the default plugin settings
		base.updateSettings(settings)

		; Define variables that you want to persist
		this.pressCount := 0
		this.pressesString := ["Single", "Double", "Tripple","Quadrupal","KILLER COMBO"]
		this.timeStart := 0
		this.deltaMax := 400 ; (ms) Maximum time between presses
		this.timeEach := []
		this.callback := ObjBindMethod(this, "hMultipleActivations")
		this.stats := ""
		this.report := ""
	}
		
	run() {
		if (A_PriorHotkey != this.hotkey or A_TimeSincePriorHotkey > this.deltaMax) {
		    ; First press of series
		    KeyWait, % this.hotkey

		    ; Reset variables
		    this.pressCount := 0
		    this.timeEach := []
		    this.timeStart := A_TickCount
		    this.stats := ""
		}
		
		; Key pressed, increment press count
		this.pressCount++

		; Calc diff from start
		timeDelta := A_TickCount - this.timeStart
		
		; Record each presses time
		this.timeEach[this.pressCount] := A_TickCount - this.timeStart

		; Determind word for amount of presses
		if (this.pressCount < this.pressesString.MaxIndex())
			pressWord := this.pressesString[this.pressCount]
		else
			pressWord := this.pressesString[this.pressesString.MaxIndex()]

		; Concatenate each press' data to an output
		cur := this.timeEach[this.pressCount]
		prev := (this.pressCount - 1 > 0 ? this.timeEach[this.pressCount - 1] : 0 )
		this.stats .= "[" this.pressCount "] " pressWord " = " cur - prev "`r`n"

		; Update output
	    this.report := ("You pressed '" this.hotkey "' " this.pressCount
	    	. " times in " timeDelta "ms.`r`n" this.stats)

	    ; Delegate # of presses response using "BoundFunc" object
	    ; See: http://ahkscript.org/docs/objects/Functor.htm
	    fn := this.callback

	    ; A negative timer means call only once (multiple presses refreshes)
		SetTimer, % fn, % -this.deltaMax
	}

	hMultipleActivations() {
		; Shorten reference
		count := this.pressCount

		; Check multiplicity
		if (count < 6) {
			msgbox % ("Custom functionality delegated for " count " clicks`r`n"
				. this.report)
		} else 
			msgbox % "Woah there turbo`r`n" this.report

		fn := ObjBindMethod(this, "clearTT")
		SetTimer, % fn, -5000
	}

	clearTT() {
		tooltip
	}
}