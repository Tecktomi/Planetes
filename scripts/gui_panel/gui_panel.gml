function gui_panel(x, y, w, h, back = control.gui_panel_back, front = control.gui_panel_front, hover_color = control.gui_panel_hover, this_input_layer = 0, boton = mb_none, hover_function_bool = false, hover_function = function(param){}, hover_function_param = {}){
	var color = draw_get_color()
	var xx = draw_get_halign() = fa_left ? 0 : (draw_get_halign() = fa_center ? w / 2 : w)
	var yy = draw_get_valign() = fa_top ? 0 : (draw_get_valign() = fa_middle ? h / 2 : h)
	x = clamp(x, xx, room_width + xx - w)
	y = clamp(y, yy, room_height + yy - h)
	var hover = (mouse_x > x - xx and mouse_y > y - yy and mouse_x < x + w - xx and mouse_y < y + h - yy and control.input_layer = this_input_layer and boton != mb_none)
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_roundrect(x - 2 - xx, y - 2 - yy, x + w + 2 - xx, y + h + 2 - yy, false)
	draw_set_alpha(1)
	draw_set_color(hover ? hover_color : back)
	draw_roundrect(x - xx, y - yy, x + w - xx, y + h - yy, false)
	draw_set_color(front)
	draw_roundrect(x - xx, y - yy, x + w - xx, y + h - yy, true)
	draw_set_color(color)
	if hover{
		cursor = cr_handpoint
		if mouse_check_button_pressed(boton){
			mouse_clear(boton)
			return true
		}
		if hover_function_bool
			hover_function(hover_function_param)
	}
	return false
}