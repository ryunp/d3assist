#include panel.ahk
#include cell_matrix.ahk

class Inventory extends Panel {
	items := {}
	hotkey := 0

	__New() {
		matrix := {"rows": 6, "cols": 10}
		cells := {"width": 47.4, "height": 47, "padding": 3}
		this.items := new Cell_Matrix(matrix, cells)
		this.setMatrixOrigin()
		this.setOpenPixel(0.75, 0.805556, 0x000000)
		this.setButton(0.614062, 0.952778)
	}

	open() {
		if this.isOpen()
			return 0

		this.hotkey ? this.useHotkey() : this.clickButton()

		return 1
	}

	close() {
		if not this.isOpen()
			return 0

		this.hotkey ? this.useHotkey() : this.clickButton()

		return 1
	}

	useHotkey() {
		SendInput, % this.hotkey
	}

	clickButton() {
		posX := this.button.x * A_ScreenWidth
		posY := this.button.y * A_ScreenHeight
		ControlClick, % "x" posX " y" posY, A,,,, NA
	}

	isOpen() {
		posX := this.openPixel.x * A_ScreenWidth
		posY := this.openPixel.y * A_ScreenHeight
		PixelGetColor, testColor, % posX, % posY, RGB

		if (this.openPixel.color = testColor)
			return 1

		return 0
	}

	moveCell(cell1, cell2) {
		start := this.items.getCenter(cell1)
		end := this.items.getCenter(cell2)

		mousemove, % start.x, % start.y
		SendInput, {Click}
		mousemove, % end.x, % end.y
		SendInput, {Click}
	}

	setMatrixOrigin() {
		this.items.setOrigin(A_ScreenWidth * 0.731771, A_ScreenHeight * 0.519445)
	}

}

F1::
	a := new Inventory()
return

F2::
	tooltip, % "opening: " a.open()
return

F3::
	tooltip, % "closing: " a.close()
return

F4::
	origin := a.items.getOrigin()
	rows := a.items.matrix.rows
	cols := a.items.matrix.cols

	loop, % rows
	{
		row := A_Index - 1
		loop, % cols
		{
			col := A_Index - 1
			idx := row * cols + col
			cell := a.items.getCellCenter(idx)
			MouseMove, % origin.x + cell.x, % origin.y + cell.y
			sleep 500
		}
	}
return

F8::
	ExitApp
return