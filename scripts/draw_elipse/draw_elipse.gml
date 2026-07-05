function draw_elipse(x, y, r1, r2, angle = 0, presicion = 16, outline = false){
	var b = 2 * pi / presicion, cosr = cos(angle), sinr = sin(angle)
	if outline{
		for(var a = 0; a < 2 * pi;){
			var px1 = r1 * cos(a), py1 = r2 * sin(a)
			a += b
			var px2 = r1 * cos(a), py2 = r2 * sin(a)
			var rx1 = px1 * cosr - py1 * sinr, ry1 = px1 * sinr + py1 * cosr;
	        var rx2 = px2 * cosr - py2 * sinr,  ry2 = px2 * sinr + py2 * cosr;
			draw_line(x + rx1, y + ry1, x + rx2, y + ry2)
		}
	}
	else
		for(var a = 0; a < 2 * pi; a += b){
			var px1 = r1 * cos(a), py1 = r2 * sin(a), px2 = r1 * cos(a + b), py2 = r2 * sin(a + b)
			var rx1 = px1 * cosr - py1 * sinr, ry1 = px1 * sinr + py1 * cosr;
	        var rx2 = px2 * cosr - py2 * sinr,  ry2 = px2 * sinr + py2 * cosr;
			draw_triangle(x, y, x + rx1, y + ry1, x + rx2, y + ry2, false)
		}
}