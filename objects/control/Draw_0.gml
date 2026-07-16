draw_init()
if is_undefined(background){
	var surf = surface_create(room_width, room_height)
	surface_set_target(surf)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_color(c_white)
	repeat(400)
		draw_point(irandom(room_width), irandom(room_height))
	draw_set_alpha(0.01)
	repeat(100){
		draw_set_color(make_color_hsv(irandom_range(127, 191), 255, 255))
		draw_circle(irandom(room_width), irandom(room_height), irandom_range(60, 160), false)
	}
	draw_set_color(c_white)
	for(var a = 25; a < 50; a++)
		draw_circle(RW2, RH2, a * 2, false)
	draw_set_alpha(1)
	background = sprite_create_from_surface(surf, 0, 0, room_width, room_height, false, false, 0, 0)
	surface_reset_target()
	surface_free(surf)
}
var max_viaje = infinity, var_zoom = ZOOM_MAX - zoom
draw_sprite_stretched(background, 0, -room_width * var_zoom / 60, -room_height * var_zoom / 60, room_width * (1 + var_zoom / 30), room_height * (1 + var_zoom / 30))
//Batallas
if batalla_planeta != null_planeta{
	scr_batalla()
	draw_end()
	exit
}
min_dis = DIS_PLANET_CLIC
planeta_mouse = null_planeta
planeta_mouse_bool = false
//Vista sistema solar
if subsistema_vista{
	draw_set_color(c_yellow)
	draw_circle(RW2, RH2, 40 / zoom, false)
	draw_set_halign(fa_center)
	//Planetas exteriores
	for(var a = array_length(planetas_terrestres_gigantes) - 1; a >= 0; a--){
		var planeta = planetas_terrestres_gigantes[a]
		draw_planeta(planeta, RW2 + (planeta.x - RW2) / zoom, RH2 + (planeta.y - RH2) / zoom, false)
	}
	if mouse_wheel_up() and show = -1{
		subsistema_vista = false
		if array_contains(planetas_gigantes, nave_select.origen)
			subsistema = nave_select.origen
		else if nave_select.origen.luna_bool and array_contains(planetas_gigantes, nave_select.origen.luna)
			subsistema = nave_select.origen.luna
		else
			subsistema = null_planeta
	}
	if zoom < ZOOM_MAX - 0.01
		zoom = (19 * zoom + ZOOM_MAX) / 20
	else
		zoom = ZOOM_MAX
	if abs(camx - RW2) > 0.01{
		camx = (19 * camx + RW2) / 20
		camy = (19 * camy + RH2) / 20
	}
	else{
		camx = RW2
		camy = RH2
	}
}
//Vista detalle
else{
	//Planetas internos
	if subsistema = null_planeta{
		draw_set_color(c_yellow)
		draw_circle(RW2, RH2, 40 / zoom, false)
		draw_set_halign(fa_center)
		//Planetas gigantes
		if zoom > 1
			for(var a = array_length(planetas_gigantes) - 1; a >= 0; a--){
				var planeta = planetas_gigantes[a]
				draw_planeta(planeta, RW2 + (planeta.x - RW2) / zoom, RH2 + (planeta.y - RH2) / zoom, false, false, false)
			}
		//Planetas interiores
		for(var a = array_length(planetas_internos) - 1; a >= 0; a--){
			var planeta = planetas_internos[a]
			draw_planeta(planeta, RW2 + (planeta.x - RW2) / zoom, RH2 + (planeta.y - RH2) / zoom,,,, true)
		}
		if abs(camx - RW2) > 0.01{
			camx = (19 * camx + RW2) / 20
			camy = (19 * camy + RH2) / 20
		}
		else{
			camx = RW2
			camy = RH2
		}
	}
	//Lunas gigantes gaseosos
	else if subsistema.gigante{
		draw_set_halign(fa_center)
		draw_planeta(subsistema, RW2, RH2, false)
		draw_text(RW2, 40, $"Sistema planetario de {subsistema.nombre}")
		for(var a = array_length(subsistema.lunas) - 1; a >= 0; a--){
			var planeta = subsistema.lunas[a]
			draw_planeta(planeta, RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom)
		}
		if abs(camx - subsistema.x) > 0.01{
			camx = (19 * camx + subsistema.x) / 20
			camy = (19 * camy + subsistema.y) / 20
		}
		else{
			camx = subsistema.x
			camy = subsistema.y
		}
	}
	//Path
	if not nave_select.viaje_bool{
		draw_set_alpha(0.5)
		for(var a = 0; a < 5; a++){
			var b = (a + last_path_index) mod 5, planeta_a = last_path[b], planeta_b = last_path[(b + 1) mod 5]
			if planeta_a != null_planeta and planeta_b != null_planeta and b != last_path_index
				draw_arrow(RW2 + (planeta_a.x - camx) / zoom, RH2 + (planeta_a.y - camy) / zoom, RW2 + (planeta_b.x - camx) / zoom, RH2 + (planeta_b.y - camy) / zoom, 8)
		}
		draw_set_alpha(1)
	}
	//Dibujar naves
	for(var a = array_length(naves) - 1; a >= 0; a--){
		var nave = naves[a]
		if nave.viaje_bool{
			var temp_viaje = nave.viaje, _viajado = nave.viaje_pos / temp_viaje.dis
			draw_point(
				RW2 + (temp_viaje.origen_x + (temp_viaje.x - temp_viaje.origen_x) * _viajado - camx) / zoom,
				RH2 + (temp_viaje.origen_y + (temp_viaje.y - temp_viaje.origen_y) * _viajado - camy) / zoom)
		}
	}
	if mouse_wheel_down() and show = -1
		subsistema_vista = true
	if zoom > 1.002
		zoom = (19 * zoom + 1) / 20
	else
		zoom = 1
}
//Dibujar misiones activas
if array_length(jugador.misiones) > 0{
	var temp_text = ""
	for(var a = 0; a < array_length(jugador.misiones); a++){
		var mision = jugador.misiones[a], time = mision.fecha - dia
		temp_text += $"{mision.nombre}{mision.restricciones_texto}\n{time > 1000 ? ">" + string(100 * floor(time / 100)) : string(time)} dias restantes  \n"
		//Misión cumplida
		if mision.status{
			draw_set_color(c_green)
			draw_circle(RW2 + (mision.contratista.x - camx) / zoom, RH2 + (mision.contratista.y - camy) / zoom, (mision.contratista.gigante ? 102 : 22) / zoom, true)
		}
		else{
			//Restricciones
			draw_set_color(c_red)
			for(var b = array_length(mision.restricciones) - 1; b >= 0; b--){
				var planeta = mision.restricciones[b]
				draw_circle(RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom, (planeta.gigante ? 96 : 16) / zoom, true)
			}
			//Naves que debes evitar
			if mision.index = mis_espiar_planeta{
				for(var b = array_length(naves) - 1; b >= 0; b--){
					var nave = naves[b]
					if nave.destino = mision.data.destino and nave.viaje_bool and nave.empresa != jugador{
						var temp_viaje = nave.viaje, _viajado = nave.viaje_pos / temp_viaje.dis
						draw_circle(
							RW2 + (temp_viaje.origen_x + (temp_viaje.x - temp_viaje.origen_x) * _viajado - camx) / zoom,
							RH2 + (temp_viaje.origen_y + (temp_viaje.y - temp_viaje.origen_y) * _viajado - camy) / zoom, 2, false)
					}
				}
			}
			draw_set_color(c_aqua)
			//Naves que debes espiar
			if mision.index = mis_espiar_empresas{
				for(var b = array_length(naves) - 1; b >= 0; b--){
					var nave = naves[b]
					if nave.destino = mision.data.destino and nave.viaje_bool and nave.empresa != jugador{
						var temp_viaje = nave.viaje, _viajado = nave.viaje_pos / temp_viaje.dis
						draw_circle(
							RW2 + (temp_viaje.origen_x + (temp_viaje.x - temp_viaje.origen_x) * _viajado - camx) / zoom,
							RH2 + (temp_viaje.origen_y + (temp_viaje.y - temp_viaje.origen_y) * _viajado - camy) / zoom, 2, false)
					}
				}
			}
			//Destino único
			if tag_mision_planeta[mision.index]{
				var planeta = mision.data.destino
				draw_circle(RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom, (planeta.gigante ? 98 : 18) / zoom, true)
			}
			//Destino en una zona
			if mision.index = mis_artefacto{
				var planeta = mision.data.destino.luna
				draw_circle_punteo(RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom, 200 / zoom)
			}
			//Destino múltiple
			if tag_mision_multiple[mision.index]{
				for(var b = array_length(mision.data.destinos) - 1; b >= 0; b--){
					var planeta = mision.data.destinos[b]
					draw_circle(RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom, (planeta.gigante ? 98 : 18) / zoom, true)
				}
			}
			else if mision.index = mis_viaje_express
				max_viaje = min(max_viaje, mision.data.cantidad)
		}
		draw_set_color(c_white)
	}
	draw_set_halign(fa_right)
	draw_set_color(c_white)
	draw_text(room_width - 10, 10, temp_text)
}
//Pasar el mouse sobre un planeta
if min_dis < DIS_PLANET_CLIC and not nave_select.viaje_bool{
	if nave_select_bool and not nave_select.viaje_bool and planeta_mouse != viaje_planeta{
		viaje = calcular_viaje(nave_select.origen, planeta_mouse)
		viaje_bool = true
		viaje_planeta = planeta_mouse
	}
	planeta_mouse_bool = true
}
if planeta_mouse_bool
	draw_circle(RW2 + (planeta_mouse.x - camx) / zoom, RH2 + (planeta_mouse.y - camy) / zoom, (planeta_mouse.gigante ? 100 : 20) / zoom, true)
//Noticias
if step_noticia > 0{
	draw_set_alpha(min(--step_noticia / 150, 1))
	draw_set_halign(fa_center)
	draw_set_valign(fa_bottom)
	draw_text(RW2, room_height - 100, text_wrap(noticias[array_length(noticias) - 1].texto, 400))
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_alpha(1)
}
//Menú del planeta
if nave_select_bool and not nave_select.viaje_bool{
	var planeta = nave_select.origen, index = planeta.index
	draw_circle(RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom, (planeta.gigante ? 100 : 20) / zoom, true)
	//Viajar
	if viaje_bool and planeta_mouse_bool{
		draw_set_halign(fa_center)
		if viaje.dis > max_viaje{
			draw_text(RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom + 20, "!!Viaje demasiado largo!!")
			draw_set_color(c_orange)
		}
		var dis = array_length(viaje.viaje_x)
		for(var a = 1; a < dis; a++)
			draw_line(RW2 + (viaje.viaje_x[a - 1] - camx) / zoom, RH2 + (viaje.viaje_y[a - 1] - camy) / zoom, RW2 + (viaje.viaje_x[a] - camx) / zoom, RH2 + (viaje.viaje_y[a] - camy) / zoom)
		draw_arrow(RW2 + (planeta.x - camx) / zoom, RH2 + (planeta.y - camy) / zoom, RW2 + (viaje.x - camx) / zoom, RH2 + (viaje.y - camy) / zoom, 8)
		draw_set_color(c_white)
		draw_text(RW2 + (viaje.viaje_x[dis / 2] - camx) / zoom, RH2 + (viaje.viaje_y[dis / 2] - camy) / zoom, $"{viaje.dis} días")
		draw_set_halign(fa_left)
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			nave_select.destino = planeta_mouse
			viaje_bool = false
			nave_select.viaje = viaje
			nave_select.viaje_bool = true
			nave_select.viaje_pos = 0
			if tutorial = 5
				tutorial++
			if tutorial = 10 and planeta_mouse = jugador.misiones[0].data.destino.luna
				tutorial++
		}
	}
	//Comunicación
	if not planeta.gigante{
		if show = -1{
			draw_set_halign(fa_center)
			if draw_text_boton(RW2, room_height - 100, "Abrir comunicación",,, true){
				input_layer = 1
				show = 0
				if tutorial = 0
					tutorial++
			}
		}
		else{
			gpu_set_scissor(100, 60, room_width - 200, room_height - 120)
			draw_set_color(gui_back)
			draw_roundrect(100, 60, room_width - 100, room_height - 60, false)
			draw_set_color(gui_panel_front)
			draw_roundrect(100, 60, room_width - 100, room_height - 60, true)
			if in(show, 0, 7)
				menu_principal(planeta)
			else if show = 1
				menu_mercado(planeta)
			else if in(show, 2, 3, 6)
				menu_misiones(planeta)
			else if show = 4
				menu_noticias()
			else if show = 5
				menu_oficina(planeta)
			else if show = 8
				menu_fabricas(planeta)
			gpu_set_scissor(0, 0, room_width, room_height)
		}
	}
}
//Input
if keyboard_check(vk_space) and pasar_dia_bool
	repeat(1 + 39 * keyboard_check(vk_shift)){
		pasar_dia()
		if not pasar_dia_bool
			break
	}
if keyboard_check_pressed(vk_space)
	pasar_dia_bool = true
if keyboard_check_pressed(ord("R"))
	game_restart()
if keyboard_check_pressed(vk_escape)
	game_end()
if keyboard_check_pressed(vk_f4)
	window_set_fullscreen(not window_get_fullscreen())
if keyboard_check_pressed(ord("G"))
	batalla = not batalla
if tutorial != -1{
	if tutorial = 10
		draw_text_background(RW2, 60, string(tutorial_text[tutorial, (not subsistema_vista)], jugador.misiones[0].data.destino.luna.nombre), fa_center)
	else{
		draw_text_background(RW2, 60, tutorial_text[tutorial, 0], fa_center)
		if tutorial = 14 and tutorial_step++ = 600{
			tutorial = -1
			ini_open("tutorial.ini")
			ini_write_real("Global", "tutorial", -1)
			ini_close()
		}
	}
}
draw_end()
