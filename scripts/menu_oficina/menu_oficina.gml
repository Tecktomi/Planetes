function menu_oficina(planeta = control.null_planeta){
	with control{
		if not jugador.oficina_bool[planeta.index]{
			input_layer = 0
			show = 0
			exit
		}
		var oficina = jugador.oficina[planeta.index], deslizador_counter = 0
		if (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 60 or mouse_x > room_width - 100 or mouse_y > room_height - 60)) or mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			mouse_clear(mb_left)
			show = 0
		}
		var ypos = 100
		draw_set_halign(fa_center)
		draw_text_pos(room_width / 2, ypos, "Oficina")
		ypos += text_y + 30
		draw_set_halign(fa_left)
		var max_xpos = 0, prev_ypos = ypos, xpos = 0
		//Inventario Oficina
		for(var a = 0; a < recurso_max; a++){
			xpos = 120
			draw_text_pos(xpos, ypos, $"{recurso_nombre[a]}: {round(oficina.recurso[a])}")
			max_xpos = max(max_xpos, text_x)
			ypos += text_y
		}
		xpos += max_xpos + 10
		ypos = prev_ypos
		draw_text_pos(xpos, ypos - text_y, "comprar a menos de|")
		max_xpos = text_x
		//Precio compra
		for(var a = 0; a < recurso_max; a++){
			if keyboard_check(vk_lshift) and deslizador_counter = deslizante_id{
				var proporcion = oficina.precio_compra[a] / (recurso_precio[a] / 10)
				for(var b = 0; b < recurso_max; b++)
					oficina.precio_compra[b] = proporcion * (recurso_precio[b] / 10)
			}
			oficina.precio_compra[a] = draw_deslizante(xpos, ypos + text_y / 2, xpos + 100, ypos + text_y / 2, oficina.precio_compra[a], 0, recurso_precio[a] / 10, deslizador_counter++, 1)
			draw_text_pos(xpos + 110, ypos, $"${oficina.precio_compra[a]}")
			max_xpos = max(max_xpos, 110 + text_x)
			ypos += text_y
		}
		xpos += 10 + max_xpos
		ypos = prev_ypos
		draw_text_pos(xpos, ypos - text_y, "vender a más de|")
		max_xpos = text_x
		//Precio_venta
		for(var a = 0; a < recurso_max; a++){
			if keyboard_check(vk_lshift) and deslizador_counter = deslizante_id{
				var proporcion = oficina.precio_venta[a] / (recurso_precio[a] / 10)
				for(var b = 0; b < recurso_max; b++)
					oficina.precio_venta[b] = proporcion * (recurso_precio[b] / 10)
			}
			oficina.precio_venta[a] = draw_deslizante(xpos, ypos + text_y / 2, xpos + 100, ypos + text_y / 2, oficina.precio_venta[a], 0, recurso_precio[a] / 10, deslizador_counter++, 1)
			draw_text_pos(xpos + 110, ypos, $"${oficina.precio_venta[a]}")
			ypos += text_y
			max_xpos = max(max_xpos, 110 + text_x)
		}
		xpos += 10 + max_xpos
		ypos = prev_ypos
		draw_text(xpos, ypos - text_y, "mover a la nave")
		var last_xpos = xpos
		for(var a = 0; a < recurso_max; a++){
			xpos = last_xpos
			if nave_select.recurso[a] > 0{
				if draw_text_boton(xpos, ypos, "<--", 1){
					nave_select.recurso[a]--
					oficina.recurso[a]++
					for(var b = array_length(jugador.misiones) - 1; b >= 0; b--){
						var mision = jugador.misiones[b]
						if not mision.status{
							if mision.index = mis_armas and mision.data.destino = planeta{
								mision.nombre = $"Lleva {max(0, --mision.data.cantidad)} {recurso_nombre[rec_armas]} a una oficina comercial en {planeta_nombre(mision.data.destino)} y déjalas ahí, sin pasar por el mercado"
								if mision.data.cantidad <= 0 and oficina.recurso[rec_armas] >= 5{
									oficina.recurso[rec_armas] -= 5
									mision_cumplir(mision)
								}
							}
						}
					}
				}
				xpos += text_x
			}
			draw_text_pos(xpos, ypos, $"|{nave_select.recurso[a]}|")
			xpos += text_x
			if oficina.recurso[a] > 0 and draw_text_boton(xpos, ypos, "-->", 1){
				nave_select.recurso[a]++
				oficina.recurso[a]--
			}
			ypos += text_y
		}
		draw_set_halign(fa_center)
		if draw_text_boton(room_width / 2, room_height - 100, "Fábricas", 1)
			show = 8
	}
}