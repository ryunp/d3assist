num := 733
offset := 20
divisor := num - offset
maxRange := num + offset
dividend := 768

while (divisor < maxRange) {
	table .= Format((divisor = num ? ">" : " ") "{:-6d} {:-6d} {:-6.5f}`n"
		, divisor, dividend, divisor / dividend)
	divisor++
}

;gui, add, edit, , % table

F1::
	xRatio := (1181/1920)
	yRatio := (1025/1080)
	xPos := xRatio * A_ScreenWidth
	yPos := yRatio * A_ScreenHeight
	PixelGetColor, c, % xPos, % yPos, RGB
	MouseMove, % xPos, % yPos

	gui, add, edit, , % c
	gui show
	;0xD69221
return

F2::
	WinGetPos, winX, winY, winW, winH, A
	MouseGetPos, mX, mY

	xRatio := mX/winW
	yRatio := mY/winH

	; Move mouse out of way
	MouseMove, 0, 0

	PixelGetColor, c, % mX, % mY, RGB
	sleep 100

	MouseMove, % mX, % mY
	
	output := "Coords: " mX " , " mY "`r`nRatios: " xRatio " x " yRatio "`r`nColor: " c

	clipboard := output
return
/*

Coords: 1440 , 870
Ratios: 0.750000 x 0.805556
Color: 0x000000

Coords: 1426.000000 , 875.000000
Ratios: 0.742708 x 0.810185
Color: 0x000000

Coords: 1179.000000 , 1029.000000
Ratios: 0.614062 x 0.952778
Color: 0xA56910

*/
