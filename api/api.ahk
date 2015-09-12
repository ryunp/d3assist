; Abstract collection for game API's
class API {
	inventory := new Inventory()
	storage := new Storage()
	blacksmith := new Blacksmith()
	mystic := new Mystic()
	jewler := new Jewler()
	cube := new Cube()
}


class Inventory extends Panel {
	matrix := {}
	

	__New() {

	}

	init() {
		cell := {"width": 47.4, "height": 47, "padding": 3}
		settings := {"size": 60, "rows": 6, "cols": 10}

		this.matrix := new ItemMatrix()

		matrix.setCellProperties(cell)
		matrix.setMatrixProperties(matrix)
	}




}

resoultionSettings := {}

class PanelTab {
	name := "", position := 0
	width := 0, height := 0

	__New(pos, name, x, y, w, h) {
		this.name := pos
		this.position := name
		this.x := x
		this.y := y
		this.width := w
		this.height := h
	}

	getName() {
		return this.name
	}

	getXY(){
		return {"x": this.x, "y": this.y}
	}

	getCenter(){
		return {"x": this.x + this.width/2, "y": this.y + this.height/2}
	}
}

class Panel {
	x := 0, y := 0
	tabs := []

	open() {
		;
	}

	close() {
		;
	}

	isOpen() {
		;
	}

	openTab(num) {
		tab := this.tabs[num].center()
		MouseClick, Left, % tab.x, % tab.y
		
	}

	addTab(tab) {
		this.tabs.push(tab)

	}
}

class ItemMatrix {
	x := 0, y := 0
	cell := {"width": 0, "height": 0, "padding": 0}
	settings := {"size": 0, "rows": 0, "cols": 0}

	__New() {

	}

	setCellProperties(cell) {
		for k,v in cell
			if this.cell.HasKey(k)
				this.cell[k] := v
	}

	setMatrixProperties(matrix){
		for k,v in settings
			if this.settings.HasKey(k)
				this.settings[k] := v
	}

	get(cell) {
		return {"x": this.calcX(cell)
			, "y": this.calcY(cell)
			, "width": this.calcWidth(cell)
			, "height": this.cell.height}
	}

	getCenter(cell) {
		return {"x": round(this.calcX(cell) + this.calcWidth(cell)/2)
			, "y": round(this.calcY(cell) + this.cell.height/2)}
	}

	; Get the x position of the cell in whole integers
	calcX(idx) {
		col := mod(idx, this.settings.cols)
		return this.cell.width*col + this.cell.padding*col
	}

	calcY(idx) {
		row := floor(idx / this.settings.cols)
		return this.cell.height*row + this.cell.padding*row
	}

	; Get the width of the cell in whole integers
	calcWidth(idx) {
		; Calculate cell X location
		x := this.calcX(idx)

		; Calculate cell ending x location
		xPrime := x + this.cell.width

		; Return difference (rounded for non-fractional pixel positioning)
		return round(xPrime) - round(x)
	}
}


/*
cell := {"width": 47.4, "height": 47, "padding": 3}
settings := {"size": 60, "rows": 6, "cols": 10}
cells := new ItemMatrix(cell, settings)

c := cells.getCenter(19)
msgbox % c.x ", " c.y


table := Format("{:6s}", "")
loop, 10
{
	table .= Format("{:-6.1f} ", cells.get(A_Index-1).x)
}
table .= "`r`n"
loop, 60
{
	if (mod(A_Index-1, 10) = 0) {
		if (A_Index-1 != 0)
			table .= "`r`n"
		table .= Format("{:-5i} ", cells.get(A_Index-1).y)
	}
	table .= Format("{:-6i} ", cells.get(A_Index-1).width)
}

gui, add, edit,, % table
gui, show

/*
      0.0    50.4   100.8  151.2  201.6  252.0  302.4  352.8  403.2  453.6  
0     47     48     47     48     47     47     48     47     48     47     
50    47     48     47     48     47     47     48     47     48     47     
100   47     48     47     48     47     47     48     47     48     47     
150   47     48     47     48     47     47     48     47     48     47     
200   47     48     47     48     47     47     48     47     48     47     
250   47     48     47     48     47     47     48     47     48     47

*/