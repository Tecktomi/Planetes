function draw_circle_punteo(x, y, r){
	for(var a = 0; a < 2 * pi; a += pi / 16)
		draw_line(x + r * cos(a), y + r * sin(a), x + r * cos(a + pi / 32), y + r * sin(a + pi / 32))
}