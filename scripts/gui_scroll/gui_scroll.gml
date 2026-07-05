function gui_scroll(x, y, width, height, elementos, max_show, funcion, data = {}, id = 0, this_input_layer = 0){
	if elementos > max_show{
		deslizante_pos[id] = round(draw_deslizante(x, y, x, y + height, deslizante_pos[id], 0, elementos - max_show, id, this_input_layer))
		if mouse_x > min(x, x + width) and mouse_y > y and mouse_x < max(x, x + width) and mouse_y < y + height{
			if mouse_wheel_up()
				deslizante_pos[id] = max(--deslizante_pos[id], 0)
			if mouse_wheel_down()
				deslizante_pos[id] = min(++deslizante_pos[id], elementos - max_show)
		}
	}
	var ypos = y
	for(var a = deslizante_pos[id]; a < min(deslizante_pos[id] + max_show, elementos); a++)
		ypos = funcion(a, ypos, data)
}