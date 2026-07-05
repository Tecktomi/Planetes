function draw_end(){
	with control{
		if window_get_cursor != cursor
			window_set_cursor(cursor)
		if draw_background_text != ""{
			draw_set_color(c_black)
			var halign = draw_get_halign()
			draw_set_halign(draw_background_halign)
			draw_text_background(draw_background_x, draw_background_y, draw_background_text)
			draw_set_halign(halign)
		}

	}
}