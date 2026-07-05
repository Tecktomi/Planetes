function draw_relaciones_imperios(x, y){
	with control{
		var len = array_length(imperios), angle = 2 * pi / len
		for(var a = 0; a < len; a++){
			for(var b = 0; b < len; b++)
				if a != b{
					var c = imperios[a].relacion_imperio[? imperios[b].index]
					if c != 0{
						draw_set_alpha(abs(c) / 10)
						if c > 0
							draw_set_color(make_color_hsv(120, 127 + 31 * c, 255))
						else
							draw_set_color(make_color_hsv(0, 127 - 31 * c, 255))
						draw_line(x + 100 * cos(a * angle), y + 100 * sin(a * angle), x + 100 * cos(b * angle), y + 100 * sin(b * angle))
					}
				}
		}
		draw_set_alpha(1)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		for(var a = 0; a < len; a++){
			draw_set_color(make_color_hsv(a * 255 / len, 127, 255))
			draw_circle(x + 100 * cos(a * angle), y + 100 * sin(a * angle), 15, false)
			draw_set_color(c_white)
			draw_circle(x + 100 * cos(a * angle), y + 100 * sin(a * angle), 15, true)
			draw_text(x + 100 * cos(a * angle), y + 100 * sin(a * angle), array_length(imperios[a].planetas))
		}
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
	}
}