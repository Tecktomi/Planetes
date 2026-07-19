function draw_planeta(planeta = control.null_planeta, xx = 0, yy = 0, _display_relacion = true, _display_nombre = true, _display_oficina = true, _display_sombra = false){
	with control{
		if _display_relacion and not planeta.gigante and gui_draw_relacion{
			if jugador.relacion_imperio[? planeta.imperio.index] != 0{
				draw_set_color(make_color_hsv(clamp(40 + 20 * jugador.relacion_imperio[? planeta.imperio.index], 0, 80), 255, 255))
				draw_set_alpha(0.05)
				for(var a = 0; a < min(4 * abs(jugador.relacion_imperio[? planeta.imperio.index]), 20); a++)
					draw_circle(xx, yy, 10 + 2 * a, false)
				draw_set_alpha(1)
			}
		}
		var r = planeta.size / zoom
		draw_set_color(planeta.color)
		draw_circle(xx, yy, r, false)
		draw_set_color(c_white)
		draw_circle(xx, yy, r, true)
		if _display_nombre{
			var dis = distance_sqr(mouse_x, mouse_y, xx, yy)
			if dis < DIS_PLANET_NAME{
				if input_layer = 0 and dis < min_dis and nave_select.origen != planeta{
					min_dis = dis
					planeta_mouse = planeta
				}
				draw_set_alpha(1 - dis / DIS_PLANET_NAME)
				draw_text(xx, yy + 15, planeta.nombre)
				draw_set_alpha(1)
			}
		}
		if _display_oficina{
			if jugador.oficina_bool[planeta.index]{
				draw_set_color(c_green)
				draw_circle(xx + 15, yy - 15, 3, false)
				draw_set_color(c_white)
			}
		}
		if _display_sombra{
			if planeta.luna_bool
				draw_set_alpha(clamp(4900 / sqr(planeta.luna.radio), 0.1, 1))
			else
				draw_set_alpha(clamp(4900 / sqr(planeta.radio), 0.1, 1))
			draw_set_color(c_black)
			var angle = degtorad(point_direction(xx, yy, RW2, RH2)), size = planeta.size
			for(var a = angle + pi / 2; a < angle + 3 * pi / 2; a += pi / 16)
				draw_triangle(xx, yy, xx + size * cos(a) / zoom, yy - size * sin(a) / zoom, xx + size * cos(a + pi / 16) / zoom, yy - size * sin(a + pi / 16) / zoom, false)
			draw_set_alpha(1)
			draw_set_color(c_white)
		}
	}
}