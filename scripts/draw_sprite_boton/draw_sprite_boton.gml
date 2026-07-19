function draw_sprite_boton(sprite, subindex, x, y, xscale = 1, yscale = 1, this_input_layer = 0, boton = mb_left){
	with control{
		draw_sprite_ext(sprite, subindex, x, y, xscale, yscale, 0, c_white, 1)
		if input_layer = this_input_layer and mouse_x > x and mouse_y > y and mouse_x < x + sprite_get_width(sprite) * xscale and mouse_y < y + sprite_get_height(sprite) * yscale{
			cursor = cr_handpoint
			if mouse_check_button_pressed(boton){
				mouse_clear(boton)
				return true
			}
		}
		return false
	}
}