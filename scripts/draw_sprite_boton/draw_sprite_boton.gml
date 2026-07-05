function draw_sprite_boton(sprite, subindex, x, y, this_input_layer = 0, boton = mb_left){
	with control{
		draw_sprite(sprite, subindex, x, y)
		if mouse_x > x and mouse_y > y and mouse_x < x + sprite_get_width(sprite) and mouse_y < y + sprite_get_height(sprite) and input_layer = this_input_layer{
			cursor = cr_handpoint
			if mouse_check_button_pressed(boton){
				mouse_clear(boton)
				return true
			}
		}
		return false
	}
}