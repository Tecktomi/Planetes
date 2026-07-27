function menu_mercado(planeta = control.null_planeta){
	with control{
		if (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 60 or mouse_x > room_width - 100 or mouse_y > room_height - 60)) or mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			mouse_clear(mb_left)
			show = MENU_PRINCIPAL
			if tutorial = 3
				tutorial++
		}
		var ypos = 100
		draw_set_halign(fa_center)
		if in(tutorial, 2, 3, 7)
			draw_text_background(RW2, 60, tutorial_text[tutorial, 0], fa_center)
		draw_text_pos(RW2, ypos, $"Mercado ${jugador.dinero}")
		ypos += text_y + 30
		draw_set_halign(fa_left)
		var max_xpos = 0, prev_ypos = ypos, xpos = 0, recursos_comercializables = array_create(recurso_max, false)
		//Inventario Planeta
		for(var a = 0; a < recurso_max; a++){
			if nave_select.recurso[a] > 0 or planeta.recurso[a] >= 1{
				recursos_comercializables[a] = true
				xpos = 120
				draw_text_pos(xpos, ypos, $"{recurso_nombre[a]}: {floor(planeta.recurso[a])}")
				max_xpos = max(max_xpos, text_x)
				ypos += text_y
			}
		}
		xpos += max_xpos + 10
		max_xpos = 0
		ypos = prev_ypos
		//Comprar
		for(var a = 0; a < recurso_max; a++){
			if recursos_comercializables[a]{
				var precio_compra = precio_recurso(a, planeta)
				if planeta.recurso[a] >= 1 and nave_select.recurso_total < nave_select.bodega and draw_text_boton(xpos, ypos, $"|Comprar ${precio_compra}|", 1) and jugador.dinero > precio_compra{
					comprar_recurso(a, 1, planeta, nave_select)
					//Misiones
					for(var b = 0; b < misiones_on_compra_max; b++){
						var bb = misiones_on_compra[b]
						for(var c = array_length(jugador.misiones_index[bb]) - 1; c >= 0; c--){
							var mision = jugador.misiones_index[bb, c]
							mision_on_compra[bb](mision, planeta, a)
						}
					}
					if tutorial = 2
						tutorial++
				}
				max_xpos = max(max_xpos, text_x)
				ypos += text_y
			}
		}
		xpos += max_xpos + 10
		max_xpos = 0
		ypos = prev_ypos
		//Vender
		for(var a = 0; a < recurso_max; a++){
			if recursos_comercializables[a]{
				var precio_venta = precio_recurso(a, planeta, false)
				if nave_select.recurso[a] > 0 and draw_text_boton(xpos, ypos, $"|Vender ${precio_venta}|", 1){
					comprar_recurso(a, -1, planeta, nave_select)
					//Misiones
					for(var b = 0; b < misiones_on_venta_max; b++){
						var bb = misiones_on_venta[b]
						for(var c = array_length(jugador.misiones_index[bb]) - 1; c >= 0; c--){
							var mision = jugador.misiones_index[bb, c]
							mision_on_venta[bb](mision, planeta, a)
						}
					}
					if tutorial = 7{
						tutorial++
						planeta.misiones = array_create(0, 0)
						array_push(planeta.misiones, mis_artefacto)
					}
				}
				max_xpos = max(max_xpos, text_x)
				ypos += text_y
			}
		}
		xpos += max_xpos + 10
		max_xpos = 0
		ypos = prev_ypos
		//Inventario Nave
		for(var a = 0; a < recurso_max; a++){
			if recursos_comercializables[a]{
				draw_text_pos(xpos, ypos, nave_select.recurso[a])
				max_xpos = max(max_xpos, text_x)
				ypos += text_y
			}
		}
	}
}