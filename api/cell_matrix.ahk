#include ui_component.ahk

class Cell_Matrix extends UI_Component {
	cells := {"width": 0, "height": 0, "padding": 0}
	matrix := {"rows": 0, "cols": 0}

	__New(matrix, cells) {
		msgbox NEW CELLS
		this.matrix := matrix
		this.cells := cells

	}

	setCellProperties(settings) {
		for k,v in settings
			if this.cells.HasKey(k)
				this.cells[k] := v
	}

	setMatrixProperties(settings){
		for k,v in settings
			if this.matrix.HasKey(k)
				this.matrix[k] := v
	}

	getCell(idx) {
		return {"x": this.getCellX(idx)
			, "y": this.getCellY(idx)
			, "width": this.getCellWidth(idx)
			, "height": this.cells.height}
	}

	getCellCenter(idx) {
		return {"x": round(this.getCellX(idx) + this.getCellWidth(idx)/2)
			, "y": round(this.getCellY(idx) + this.cells.height/2)}
	}

	; Get the x position of the cell in whole integers
	getCellX(idx) {
		col := mod(idx, this.matrix.cols)
		result := this.cells.width*col + this.cells.padding*col
		return result
	}

	getCellY(idx) {
		row := floor(idx / this.matrix.cols)
		result := this.cells.height*row + this.cells.padding*row
		return result
	}

	; Get the width of the cell in whole integers
	getCellWidth(idx) {
		x := this.getCellX(idx)

		; Calc the x ending position
		xPrime := x + this.cells.width

		; Return difference (rounded for non-fractional pixel positioning)
		return round(xPrime) - round(x)
	}
}