function menu_noticias(){
	with control{
		if (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 60 or mouse_x > room_width - 100 or mouse_y > room_height - 60)) or mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			mouse_clear(mb_left)
			show = 0
		}
		var ypos = 100
		draw_set_halign(fa_center)
		draw_text_pos(room_width / 2, ypos, "Noticias")
		ypos += text_y + 30
		if array_length(noticias) = 0
			draw_text(room_width / 2, ypos, "Sin noticias")
		draw_set_halign(fa_left)
		if mouse_check_button_pressed(mb_left)
			show_noticia = -1
		gui_scroll(120, ypos, room_width - 240, room_height - 80 - ypos, array_length(noticias), 18, function(a, ypos){
			if draw_text_boton(130, ypos, noticias[a].titulo, 1)
				show_noticia = a
			if draw_sprite_boton(spr_icon, 0, room_width - 200, ypos, 1)
				array_delete(noticias, a, 1)
			ypos += text_y
			if show_noticia = a{
				draw_text_pos(150, ypos, noticias[a].texto)
				draw_line(130, ypos, 130, ypos + text_y)
				ypos += text_y
			}
			return ypos
		}, , 0, 1)
	}
}