function menu_mercado(planeta = control.null_planeta){
	with control{
		if (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 60 or mouse_x > room_width - 100 or mouse_y > room_height - 60)) or mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			mouse_clear(mb_left)
			show = 0
			if tutorial = 3
				tutorial++
		}
		var ypos = 100
		draw_set_halign(fa_center)
		if in(tutorial, 2, 3, 7)
			draw_text_background(RW2, 60, tutorial_text[tutorial, 0], fa_center)
		draw_text_pos(room_width / 2, ypos, $"Mercado ${jugador.dinero}")
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
				if planeta.recurso[a] >= 1 and draw_text_boton(xpos, ypos, $"|Comprar ${precio_compra}|", 1) and jugador.dinero > precio_compra{
					comprar_recurso(a, 1, planeta, nave_select)
					for(var b = array_length(jugador.misiones) - 1; b >= 0; b--){
						var mision = jugador.misiones[b]
						if not mision.status{
							if mision.index = mis_desabastecer and mision.data.destino = planeta and mision.data.recurso = a and floor(planeta.recurso[a]) = 0
								mision_cumplir(mision)
							else if mision.index = mis_llenar_bodega and mision.data.recurso = a and nave_select.recurso[a] >= mision.data.cantidad
								mision_cumplir(mision)
							else if mision.index = mis_electronicos and a = rec_electronicos and array_contains(mision.data.destinos, planeta){
								array_remove(mision.data.destinos, planeta)
								var len = array_length(mision.data.destinos)
								if len = 2
									mision.nombre = $"Tráenos {recurso_nombre[rec_electronicos]} de {planeta_nombre(mision.data.destinos[0])} y {planeta_nombre(mision.data.destinos[1])}"
								else if len = 1
									mision.nombre = $"Tráenos {recurso_nombre[rec_electronicos]} de {planeta_nombre(mision.data.destinos[0])}"
								else if len = 0
									mision_cumplir(mision)
							}
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
					for(var b = array_length(jugador.misiones) - 1; b >= 0; b--){
						var mision = jugador.misiones[b]
						if not mision.status{
							if mision.index = mis_saturar_mercado and mision.data.destino = planeta and mision.data.recurso = a and precio_recurso(a, planeta, false) <= mision.data.precio
								mision_cumplir(mision)
							if mision.index = mis_comida and a = rec_comida and array_contains(mision.data.destinos, planeta) and planeta.recurso[rec_comida] >= 4{
								if planeta.estado = ESCASEZ and irandom(1)
									planeta.estado = ESTABLE
								array_remove(mision.data.destinos, planeta)
								var len = array_length(mision.data.destinos)
								if len = 2
									mision.nombre = $"Lleva al menos 4 de {recurso_nombre[rec_comida]} a {planeta_nombre(mision.data.destinos[0])} y {planeta_nombre(mision.data.destinos[1])}"
								else if len = 1
									mision.nombre = $"Lleva al menos 4 de {recurso_nombre[rec_comida]} a {planeta_nombre(mision.data.destinos[0])}"
								else if len = 0
									mision_cumplir(mision)
							}
							if mision.index = mis_armas and a = rec_armas
								mision_fallar(mision, "Has vendido las armas en el mercado local")
							if mision.index = mis_salvar_fauna and a = rec_fauna
								mision_fallar(mision, "Has vendido la fauna en el mercado local")
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