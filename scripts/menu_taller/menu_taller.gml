function menu_taller(planeta = control.null_planeta){
	with control{
		if (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 60 or mouse_x > room_width - 100 or mouse_y > room_height - 60)) or mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			mouse_clear(mb_left)
			show = MENU_PRINCIPAL
		}
		var ypos = 100
		draw_set_halign(fa_center)
		draw_text(RW2, ypos, "Taller")
		ypos += text_y * 1.2
		//Reparar
		draw_set_halign(fa_left)
		if nave_select.hp < nave_hp[nave_select.modelo] and jugador.relacion_imperio[? planeta.imperio.index] > 0{
			var precio = ceil(nave_hp[nave_select.modelo] - nave_select.hp)
			if draw_text_boton(130, ypos, $"Reparar ${precio}", 1) and jugador.dinero >= precio{
				nave_select.hp = nave_hp[nave_select.modelo]
				jugador.dinero -= precio
			}
			ypos += text_y * 1.2
		}
		//Nave
		draw_sprite_ext(spr_nave, nave_select.modelo, RW2 - sprite_get_width(spr_nave) * 4 - 20, ypos + sprite_get_height(spr_nave) * 4, 8, 8, 0, c_white, 1)
		draw_text_pos(RW2 + 20, ypos, $"Nombre: {nave_nombre[nave_select.modelo]}")
		ypos += text_y * 1.1
		draw_text_pos(RW2 + 20, ypos, $"Salud: {nave_select.hp}/{nave_hp[nave_select.modelo]}")
		ypos += text_y * 1.1
		draw_text_pos(RW2 + 20, ypos, $"Velocidad: {floor(10 * nave_vel[nave_select.modelo])}")
		ypos += text_y * 1.1
		draw_text_pos(RW2 + 20, ypos, $"Carga: {nave_select.recurso_total}/{nave_carga[nave_select.modelo] - 5 * nave_select.armas}")
		ypos += text_y * 1.1
		draw_text_pos(RW2 + 20, ypos, $"Armamento: {nave_select.armas}/{floor(nave_carga[nave_select.modelo] / 5)}")
		ypos += text_y * 1.1
		//Equipar armas
		if jugador.relacion_imperio[? planeta.imperio.index] > -2{
			var precio = 100 - 20 * (planeta.arquetipo = MILITAR)
			if nave_select.armas < floor(nave_carga[nave_select.modelo] / 5){
				if draw_text_boton(130, ypos, $"Comprar armas ${precio}", 1) and jugador.dinero >= precio{
					jugador.dinero -= precio
					nave_select.armas++
				}
				ypos += text_y * 1.2
			}
			if nave_select.armas > 0{
				precio = floor(precio * 0.8)
				if draw_text_boton(130, ypos, $"Vender armas ${precio}", 1){
					jugador.dinero += precio
					nave_select.armas--
				}
			}
		}
	}
}