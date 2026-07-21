function menu_principal(planeta = control.null_planeta){
	with control{
		var index = planeta.index
		if (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 60 or mouse_x > room_width - 100 or mouse_y > room_height - 60)) or mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			mouse_clear(mb_left)
			input_layer = 0
			show = MENU_NULL
			if tutorial = 4
				tutorial++
		}
		draw_set_halign(fa_center)
		if tutorial != -1 and in(tutorial, 1, 4, 7, 8)
			draw_text_background(RW2, 60, tutorial_text[tutorial, 0], fa_center)
		var ypos = 100
		draw_text_pos(room_width / 2, ypos, planeta.nombre)
		ypos += text_y + 30
		draw_set_halign(fa_left)
		var temp_array = [0, 1, 2, 2, 0, 1, 1, 2, 0], a = jugador.relacion_imperio[? planeta.imperio.index]
		draw_text_pos(120, ypos, text_wrap(arquetipo_saludo[planeta.arquetipo,  a > 1.5 ? 0 : (a < -0.5 ? 2 : 1)], room_width - 300))
		ypos += text_y + 10
		draw_text_pos(120, ypos, text_wrap(arquetipo_dialogo[planeta.arquetipo, temp_array[planeta.estado]], room_width - 300))
		ypos += text_y + 30
		draw_set_halign(fa_center)
		if draw_text_boton(room_width / 2, ypos, "Mercado", 1){
			show = MENU_MERCADO
			if tutorial = 1
				tutorial++
		}
		ypos += text_y + 10
		if jugador.relacion_imperio[? planeta.imperio.index] >= -0.5{
			a = 0
			for(var b = array_length(planeta.misiones) - 1; b >= 0; b--)
				a += (jugador.relacion_imperio[? planeta.imperio.index] >= mision_reputacion[planeta.misiones[b]])
			if draw_text_boton(room_width / 2, ypos, $"Misiones ({a})", 1){
				show = MENU_MISIONES
				if tutorial = 8
					tutorial++
			}
			ypos += text_y + 10
		}
		if draw_text_boton(room_width / 2, ypos, $"Noticias ({array_length(noticias)})", 1){
			show = MENU_NOTICIAS
			show_noticia = -1
		}
		ypos += text_y + 10
		if draw_text_boton(room_width / 2, ypos, jugador.oficina_bool[index] ? "Abrir oficina" : "Construir oficiana $20", 1) and (jugador.oficina_bool[index] or jugador.dinero >= 20){
			if jugador.oficina_bool[index] 
				show = MENU_OFICINA
			else{
				show = MENU_CONFIRMAR_CONSTRUIR_OFICINA
				input_layer = 2
			}
		}
		//Reparar
		ypos += text_y + 10
		if draw_text_boton(room_width / 2, ypos, "Taller", 1)
			show = MENU_TALLER
		//Confirmar construir oficina
		if show = MENU_CONFIRMAR_CONSTRUIR_OFICINA{
			draw_set_color(c_ltgray)
			draw_rectangle(250, 200, room_width - 250, room_height - 200, false)
			draw_set_color(c_black)
			draw_rectangle(250, 200, room_width - 250, room_height - 200, true)
			draw_set_halign(fa_center)
			ypos = 220
			draw_text_pos(room_width / 2, ypos, "¿Construir oficina comercial aquí?")
			ypos += text_y + 10
			draw_text(room_width / 2, ypos, text_wrap("La oficina comercial permite comprar, almacenar y vender automáticamente mercancias aquí", room_width - 550))
			draw_set_halign(fa_right)
			if mouse_check_button_pressed(mb_left) and (mouse_x < 250 or mouse_y < 200 or mouse_x > room_width - 250 or mouse_y > room_height - 200) or draw_text_boton(room_width - 270, room_height - 250, "No", 2){
				mouse_clear(mb_left)
				input_layer = 1
				show = MENU_PRINCIPAL
			}
			draw_set_halign(fa_left)
			if draw_text_boton(270, room_height - 250, "Sí", 2){
				jugador.oficina_bool[index] = true
				jugador.dinero -= 20
				jugador.oficina[index] = add_oficina(planeta, jugador)
				input_layer = 1
				show = MENU_OFICINA
			}
		}
	}
}