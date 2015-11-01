#include ui_component.ahk

class Panel extends UI_Component {
	openPixel := 0
	button := 0

	setOpenPixel(x, y, color) {
		this.openPixel := {"x": x, "y": y, "color": color}
	}

	setButton(x, y) {
		this.button := {"x": x, "y": y}
	}
}
