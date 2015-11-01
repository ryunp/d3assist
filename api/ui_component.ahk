class UI_Component {
	name := ""
	origin := {"x": 0, "y": 0}
	dimensions := {"width": 0, "height": 0}

	__New(name:="default", x:=0, y:=0, w:=0, h:=0) {
		this.name := name
		this.origin := {"x": x, "y": y}
		this.dimensions := {"width": w, "height": h}
	}

	;;
	; Getters
	;;

	getName() {
		return this.name
	}

	getCenter() {
		return {"x": this.origin.x + this.dimensions.width/2
			, "y": this.origin.y + htis.dimensions.height/2}
	}

	getOrigin() {
		return this.origin
	}

	getDimensions() {
		return this.dimensions
	}

	;;
	; Setters
	;;

	setName(newName) {
		this.name := newName
	}

	setOrigin(x,y) {
		this.origin.x := x
		this.origin.y := y
	}

	setDimensions(w,h) {
		this.dimensions.width := w
		this.dimensions.height := h
	}
}