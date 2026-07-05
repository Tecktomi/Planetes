function draw_text_boton(x, y, text, this_input_layer = 0, boton = mb_left, box = false, box_color = c_ltgray, text_color = c_black, box_color_hover = c_gray, borde = 4){
	with control{
		var width = string_width(text), height = string_height(text)
		var xx = draw_get_halign() = fa_left ? 0 : (draw_get_halign() = fa_center ? width / 2 : width)
		var yy = draw_get_valign() = fa_top ? 0 : (draw_get_valign() = fa_middle ? height / 2 : height)
		var hover = (mouse_x > x - xx and mouse_y > y - yy and mouse_x < x - xx + width and mouse_y < y - yy + height and input_layer = this_input_layer)
		if box{
			draw_set_color(hover ? box_color_hover : box_color)
			draw_roundrect(x - xx - borde, y - yy - borde, x + width - xx + borde, y + height - yy + borde, false)
			draw_set_color(text_color)
		}
		draw_text_pos(x, y, text)
		if box
			draw_roundrect(x - xx - borde, y - yy - borde, x + width - xx + borde, y + height - yy + borde, true)
		if hover{
			cursor = cr_handpoint
			if mouse_check_button_pressed(boton){
				mouse_clear(boton)
				return true
			}
		}
		return false
	}
}