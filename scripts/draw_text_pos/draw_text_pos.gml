function draw_text_pos(x, y, text){
	with control{
		draw_text(x, y, text)
		text_x = string_width(text)
		text_y = string_height(text)
	}
}