function menu_fabricas(planeta = control.null_planeta){
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
			show = 5
		}
		var ypos = 100
		draw_set_halign(fa_center)
		draw_text_pos(room_width / 2, ypos, "Edificios")
		var max_capacidad = planeta.capacidad[0] + planeta.capacidad[1] + planeta.capacidad[2], xpos = room_width / 2 - 10 * max_capacidad
		for(var a = 0; a < 3; a++)
			repeat(planeta.capacidad[a]){
				draw_sprite(spr_capacidad, a, xpos, ypos + 20)
				xpos += 20
			}
		ypos += text_y + 10
		var prev_ypos = ypos
		//Fábricas
		draw_set_halign(fa_left)
		draw_text_pos(130, ypos, "Fábricas")
		ypos += text_y
		gui_scroll(120, ypos, 220, 380, recurso_max, 6, function(a, ypos, data){
			with control{
				var planeta = data.planeta, agrado = arquetipo_recurso_frecuencia[planeta.arquetipo, a]
				var comprable = jugador.dinero >= recurso_fabrica_precio[a] and planeta.capacidad[0] >= recurso_fabrica_capacidad[a, 0] and planeta.capacidad[1] >= recurso_fabrica_capacidad[a, 1] and planeta.capacidad[2] >= recurso_fabrica_capacidad[a, 2] and agrado > 1
				var color = comprable ? (agrado = 2 ? 3 : 2) : 1
				if gui_panel(130, ypos, 200, 60, gui_panel_back_array[color],, gui_panel_hover_array[color], 1, mb_left, true, function(data){
					var temp_text = ""
					if not data.dinero
						temp_text += "\nDinero insuficiente"
					if data.agrado = 1
						temp_text += "\nEstá prohibido en este planeta"
					else if data.agrado = 2
						temp_text += "\nNo será del agrado de los locales"
					if not data.capacidad_0
						temp_text += $"\nInsuficiente {control.capacidad_nombre[0]}"
					if not data.capacidad_1
						temp_text += $"\nInsuficiente {control.capacidad_nombre[1]}"
					if not data.capacidad_2
						temp_text += $"\nInsuficiente {control.capacidad_nombre[2]}"
					temp_text = string_trim(temp_text)
					if temp_text != ""{
						draw_background_x = mouse_x
						draw_background_y = mouse_y
						draw_background_text = temp_text
					}
				}, {
					dinero : jugador.dinero >= recurso_fabrica_precio[a],
					agrado : agrado,
					capacidad_0 : planeta.capacidad[0] >= recurso_fabrica_capacidad[a, 0],
					capacidad_1 : planeta.capacidad[1] >= recurso_fabrica_capacidad[a, 1],
					capacidad_2 : planeta.capacidad[2] >= recurso_fabrica_capacidad[a, 2]
				}) and comprable{
					ds_grid_add(jugador.fabricas, planeta.index, a, 1)
					jugador.dinero -= recurso_fabrica_precio[a]
					jugador.relacion_imperio_piso[? planeta.imperio.index] += (arquetipo_recurso_frecuencia[planeta.arquetipo, a] - 3) / 2
					for(var b = 0; b < 3; b++)
						planeta.capacidad[b] -= recurso_fabrica_capacidad[a, b]
				}
				draw_text_pos(135, ypos, recurso_nombre[a])
				ypos += text_y
				draw_text_pos(135, ypos, $"${recurso_fabrica_precio[a]}")
				if jugador.fabricas[# planeta.index, a] > 0{
					draw_set_halign(fa_right)
					draw_set_font(ft_letra_grande)
					draw_text(320, ypos, $"X{jugador.fabricas[# planeta.index, a]}")
					draw_set_font(ft_letra)
					draw_set_halign(fa_left)
				}
				ypos += text_y
				var xpos = 135
				for(var b = 0; b < 3; b++)
					repeat(recurso_fabrica_capacidad[a, b]){
						draw_sprite(spr_capacidad, b, xpos, ypos)
						xpos += 20
					}
				return ypos + 25
			}
		}, {planeta : planeta}, 0, 1)
		//INFRASTRUCTURA
		ypos = prev_ypos
		draw_set_halign(fa_right)
		draw_text_pos(room_width - 130, ypos, "Infrastructura")
		ypos += text_y
		gui_scroll(room_width - 120, ypos, -220, 380, infrastructura_max, 6, function(a, ypos, data){
			with control{
				var planeta = data.planeta
				var comprable = jugador.dinero >= infrastructura_precio[a], color = planeta.infrastructura_bool[a] ? 2 : (comprable ? 0 : 1)
				if gui_panel(room_width - 130, ypos, 200, 60, gui_panel_back_array[color],, gui_panel_hover_array[color], 1, mb_left, true, function(data){
					if not data.comprable{
						draw_background_x = mouse_x
						draw_background_y = mouse_y
						draw_background_text = "Dinero insuficiente"
					}
				}, {
					comprable : comprable
				}) and comprable and not planeta.infrastructura_bool[a]{
					jugador.relacion_imperio_piso[? planeta.imperio.index] += 0.2
					jugador.dinero -= infrastructura_precio[a]
					planeta.infrastructura_bool[a] = true
					planeta.infrastructura_owner[a] = jugador
					planeta.capacidad[infrastructura_capacidad_id[a]] += infrastructura_capacidad_num[a]
				}
				draw_text_pos(room_width - 135, ypos, infrastructura_nombre[a])
				ypos += text_y
				draw_text_pos(room_width - 135, ypos, $"${infrastructura_precio[a]}")
				ypos += text_y
				var xpos = room_width - 155
				repeat(infrastructura_capacidad_num[a]){
					draw_sprite(spr_capacidad, infrastructura_capacidad_id[a], xpos, ypos)
					xpos -= 20
				}
				return ypos + 25
			}
		}, {planeta : planeta}, 1, 1)
	}
}