function menu_misiones(planeta = control.null_planeta){
	with control{
		if (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 60 or mouse_x > room_width - 100 or mouse_y > room_height - 60)) or mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			mouse_clear(mb_left)
			show = 0
		}
		var ypos = 100
		draw_set_halign(fa_center)
		if tutorial = 9
			draw_text_background(RW2, 60, tutorial_text[tutorial, 0], fa_center)
		draw_text_pos(room_width / 2, ypos, "Misiones")
		ypos += text_y + 30
		if array_length(planeta.misiones) = 0
			draw_text(room_width / 2, ypos, "Sin misiones aun")
		draw_set_halign(fa_left)
		for(var a = array_length(planeta.misiones) - 1; a >= 0; a--){
			if jugador.relacion_imperio[? planeta.imperio.index] >= mision_reputacion[planeta.misiones[a]]{
				if draw_text_boton(120, ypos, mision_nombre[planeta.misiones[a]], 1){
					input_layer = 2
					show = 3
					input_data = a
				}
				ypos += text_y
			}
		}
		//Confirmar
		if show = 3{
			draw_set_color(c_ltgray)
			draw_rectangle(250, 120, room_width - 250, room_height - 120, false)
			draw_set_color(c_black)
			draw_rectangle(250, 120, room_width - 250, room_height - 120, true)
			if mouse_check_button_pressed(mb_left) and (mouse_x < 250 or mouse_y < 120 or mouse_x > room_width - 250 or mouse_y > room_height - 120){
				mouse_clear(mb_left)
				input_layer = 1
				show = 2
			}
			var b = planeta.misiones[input_data]
			draw_set_halign(fa_center)
			draw_text(room_width / 2, 140, $"Tomar mision {mision_nombre[b]}?")
			draw_text(room_width / 2, 180, mision_descripcion[planeta.arquetipo, b])
			draw_set_halign(fa_right)
			if draw_text_boton(room_width - 270, room_height - 150, "Cancelar", 2){
				input_layer = 1
				show = 2
			}
			draw_set_halign(fa_left)
			if draw_text_boton(270, room_height - 150, "Aceptar", 2){
				var mision = mision_aceptar(b, planeta)
				if is_undefined(mision){
					input_layer = 3
					show = 6
				}
				else{
					input_layer = 1
					show = 2
					if tutorial = 9{
						tutorial++
						input_layer = 0
						show = -1
					}
				}
			}
		}
		//Mensaje no se puede tomar la misión
		if show = 6{
			draw_set_color(c_ltgray)
			draw_rectangle(250, 200, room_width - 250, room_height - 200, false)
			draw_set_color(c_black)
			draw_rectangle(250, 200, room_width - 250, room_height - 200, true)
			draw_set_halign(fa_center)
			draw_text(room_width / 2, 220, $"No se pudo tomar esta misión por ahora\nIntenta más tarde")
			if mouse_check_button_pressed(mb_left) and (mouse_x < 250 or mouse_y < 200 or mouse_x > room_width - 250 or mouse_y > room_height - 200) or draw_text_boton(room_width / 2, room_height - 250, "Okey", 3){
				mouse_clear(mb_left)
				input_layer = 1
				show = 2
			}
		}
	}
}