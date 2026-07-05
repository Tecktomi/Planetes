function draw_deslizante(x1, y1, x2, y2, val, val_min, val_max, id, this_input_layer = 0){
	with control{
		var horizontal
		if x1 = x2{
			if y1 = y2
				show_error("Deslizante nulo", true)
			else
				horizontal = false
		}
		else if y1 = y2
			horizontal = true
		else
			show_error("Deslizante diagonal", true)
		draw_line(x1, y1, x2, y2)
		if horizontal
			draw_circle(x1 + (x2 - x1) * (val - val_min) / (val_max - val_min), y1, 4, false)
		else
			draw_circle(x1, y1 + (y2 - y1) * (val - val_min) / (val_max - val_min), 4, false)
		if input_layer = this_input_layer and mouse_x > x1 - 5 and mouse_y > y1 - 5 and mouse_x <  x2 + 5 and mouse_y < y2 + 5{
			cursor = cr_handpoint
			if mouse_check_button_pressed(mb_left)
				deslizante_id = id
		}
		if deslizante_id = id{
			cursor = cr_handpoint
			if mouse_check_button_released(mb_left)
				deslizante_id = -1
			if horizontal
				return clamp((mouse_x - x1) / (x2 - x1) * (val_max - val_min) + val_min, val_min, val_max)
			else
				return clamp((mouse_y - y1) / (y2 - y1) * (val_max - val_min) + val_min, val_min, val_max)
		}
		return real(val)
	}
}