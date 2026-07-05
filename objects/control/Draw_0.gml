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
		draw_circle(rw2, rh2, a * 2, false)
	draw_set_alpha(1)
	background = sprite_create_from_surface(surf, 0, 0, room_width, room_height, false, false, 0, 0)
	surface_reset_target()
	surface_free(surf)
}
var min_dis = 255, max_viaje = infinity
draw_sprite_stretched(background, 0, -room_width * (5 - zoom) / 60, -room_height * (5 - zoom) / 60, room_width * (1 + (5 - zoom) / 30), room_height * (1 + (5 - zoom) / 30))
planeta_mouse = null_planeta
planeta_mouse_bool = false
//Vista sistema solar
if subsistema_vista{
	draw_set_color(c_yellow)
	draw_circle(rw2, rh2, 40 / zoom, false)
	draw_set_halign(fa_center)
	//Planetas exteriores
	for(var a = array_length(planetas_terrestres_gigantes) - 1; a >= 0; a--){
		var planeta = planetas_terrestres_gigantes[a]
		var xx = rw2 + (planeta.x - rw2) / zoom, yy = rh2 + (planeta.y - rh2) / zoom
		draw_set_color(planeta.color)
		draw_circle(xx, yy, planeta.size / zoom, false)
		draw_set_color(c_white)
		draw_circle(xx, yy, planeta.size / zoom, true)
		var dis = distance_sqr(mouse_x, mouse_y, xx, yy)
		if dis < 10_000{
			if input_layer = 0 and dis < min_dis and nave_select.origen != planeta{
				min_dis = dis
				planeta_mouse = planeta
			}
			draw_set_alpha(1 - dis / 10_000)
			draw_text(xx, yy + 15, planeta.nombre)
			draw_set_alpha(1)
		}
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
	if zoom < 4.99
		zoom = (19 * zoom + 5) / 20
	else
		zoom = 5
	if abs(camx - rw2) > 0.01{
		camx = (19 * camx + rw2) / 20
		camy = (19 * camy + rh2) / 20
	}
	else{
		camx = rw2
		camy = rh2
	}
}
//Vista detalle
else{
	//Planetas internos
	if subsistema = null_planeta{
		draw_set_color(c_yellow)
		draw_circle(rw2, rh2, 40 / zoom, false)
		draw_set_halign(fa_center)
		//Planetas gigantes
		if zoom > 1
			for(var a = array_length(planetas_gigantes) - 1; a >= 0; a--){
				var planeta = planetas_gigantes[a]
				var xx = rw2 + (planeta.x - rw2) / zoom, yy = rh2 + (planeta.y - rh2) / zoom
				draw_set_color(planeta.color)
				draw_circle(xx, yy, planeta.size / zoom, false)
				draw_set_color(c_white)
				draw_circle(xx, yy, planeta.size / zoom, true)
			}
		//Planetas interiores
		for(var a = array_length(planetas_internos) - 1; a >= 0; a--){
			var planeta = planetas_internos[a]
			var xx = rw2 + (planeta.x - rw2) / zoom, yy = rh2 + (planeta.y - rh2) / zoom, size = planeta.size / zoom * 2
			if jugador.relacion_imperio[? planeta.imperio.index] != 0{
				draw_set_color(make_color_hsv(clamp(40 + 20 * jugador.relacion_imperio[? planeta.imperio.index], 0, 80), 255, 255))
				draw_set_alpha(0.05)
				for(var b = 0; b < min(4 * abs(jugador.relacion_imperio[? planeta.imperio.index]), 20); b++)
					draw_circle(xx, yy, 10 + 2 * b, false)
				draw_set_alpha(1)
			}
			draw_set_color(planeta.color)
			draw_circle(xx, yy, planeta.size / zoom, false)
			//draw_sprite_stretched(spr_planeta_rocoso, 0, xx - size / 2, yy - size / 2, size, size)
			draw_set_color(c_white)
			draw_circle(xx, yy, planeta.size / zoom, true)
			var dis = distance_sqr(mouse_x, mouse_y, xx, yy)
			if dis < 10_000{
				if input_layer = 0 and dis < min_dis and nave_select.origen != planeta{
					min_dis = dis
					planeta_mouse = planeta
				}
				draw_set_alpha(1 - dis / 10_000)
				draw_text(xx, yy + 15, planeta.nombre)
				draw_set_alpha(1)
			}
			if jugador.oficina_bool[planeta.index]{
				draw_set_color(c_green)
				draw_circle(xx + 15, yy - 15, 3, false)
				draw_set_color(c_white)
			}
			if planeta.luna_bool
				draw_set_alpha(4900 / sqr(planeta.luna.radio))
			else
				draw_set_alpha(4900 / sqr(planeta.radio))
			draw_set_color(c_black)
			var angle = degtorad(point_direction(xx, yy, rw2, rh2)), size = planeta.size
			for(var b = angle + pi / 2; b < angle + 3 * pi / 2; b += pi / 16)
				draw_triangle(xx, yy, xx + size * cos(b) / zoom, yy - size * sin(b) / zoom, xx + size * cos(b + pi / 16) / zoom, yy - size * sin(b + pi / 16) / zoom, false)
			draw_set_alpha(1)
			draw_set_color(c_white)
		}
		if abs(camx - rw2) > 0.01{
			camx = (19 * camx + rw2) / 20
			camy = (19 * camy + rh2) / 20
		}
		else{
			camx = rw2
			camy = rh2
		}
	}
	//Lunas gigantes gaseosos
	else if subsistema.gigante{
		draw_set_halign(fa_center)
		draw_set_color(subsistema.color)
		draw_circle(rw2, rh2, subsistema.size / zoom, false)
		draw_set_color(c_white)
		draw_text(rw2, 40, $"Sistema planetario de {subsistema.nombre}")
		draw_circle(rw2, rh2, subsistema.size / zoom, true)
		for(var a = array_length(subsistema.lunas) - 1; a >= 0; a--){
			var planeta = subsistema.lunas[a]
			var xx = rw2 + (planeta.x - camx) / zoom, yy = rh2 + (planeta.y - camy) / zoom
			if jugador.relacion_imperio[? planeta.imperio.index] != 0{
				draw_set_color(make_color_hsv(clamp(40 + 20 * jugador.relacion_imperio[? planeta.imperio.index], 0, 80), 255, 255))
				draw_set_alpha(0.05)
				for(var b = 0; b < min(4 * abs(jugador.relacion_imperio[? planeta.imperio.index]), 20); b++)
					draw_circle(xx, yy, 10 + 2 * b, false)
				draw_set_alpha(1)
			}
			draw_set_color(planeta.color)
			draw_circle(xx, yy, planeta.size / zoom, false)
			draw_set_color(c_white)
			draw_circle(xx, yy, planeta.size / zoom, true)
			var dis = distance_sqr(mouse_x, mouse_y, xx, yy)
			if dis < 10_000{
				if input_layer = 0 and dis < min_dis and nave_select.origen != planeta{
					min_dis = dis
					planeta_mouse = planeta
				}
				draw_set_alpha(1 - dis / 10_000)
				draw_text(xx, yy + 15, planeta.nombre)
				draw_set_alpha(1)
			}
			if jugador.oficina_bool[planeta.index]{
				draw_set_color(c_green)
				draw_circle(xx + 15, yy - 15, 3, false)
				draw_set_color(c_white)
			}
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
				draw_arrow(rw2 + (planeta_a.x - camx) / zoom, rh2 + (planeta_a.y - camy) / zoom, rw2 + (planeta_b.x - camx) / zoom, rh2 + (planeta_b.y - camy) / zoom, 8)
		}
		draw_set_alpha(1)
	}
	//Dibujar naves
	for(var a = array_length(naves) - 1; a >= 0; a--){
		var nave = naves[a]
		if nave.viaje_bool{
			var temp_viaje = nave.viaje
			draw_point(
				rw2 + (temp_viaje.origen_x + (temp_viaje.x - temp_viaje.origen_x) * nave.viaje_pos / temp_viaje.dis - camx) / zoom,
				rh2 + (temp_viaje.origen_y + (temp_viaje.y - temp_viaje.origen_y) * nave.viaje_pos / temp_viaje.dis - camy) / zoom)
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
		if mision.status{
			draw_set_color(c_green)
			draw_circle(rw2 + (mision.contratista.x - camx) / zoom, rh2 + (mision.contratista.y - camy) / zoom, (mision.contratista.gigante ? 102 : 22) / zoom, true)
		}
		else{
			draw_set_color(c_red)
			for(var b = array_length(mision.restricciones) - 1; b >= 0; b--){
				var planeta = mision.restricciones[b]
				draw_circle(rw2 + (planeta.x - camx) / zoom, rh2 + (planeta.y - camy) / zoom, (planeta.gigante ? 96 : 16) / zoom, true)
			}
			if mision.index = mis_espiar_planeta{
				for(var b = array_length(naves) - 1; b >= 0; b--){
					var nave = naves[b]
					if nave.destino = mision.data.destino and nave.viaje_bool and nave.empresa != jugador{
						var temp_viaje = nave.viaje
						draw_circle(
							rw2 + (temp_viaje.origen_x + (temp_viaje.x - temp_viaje.origen_x) * nave.viaje_pos / temp_viaje.dis - camx) / zoom,
							rh2 + (temp_viaje.origen_y + (temp_viaje.y - temp_viaje.origen_y) * nave.viaje_pos / temp_viaje.dis - camy) / zoom, 2, false)
					}
				}
			}
			draw_set_color(c_aqua)
			if mision.index = mis_espiar_empresas{
				for(var b = array_length(naves) - 1; b >= 0; b--){
					var nave = naves[b]
					if nave.destino = mision.data.destino and nave.viaje_bool and nave.empresa != jugador{
						var temp_viaje = nave.viaje
						draw_circle(
							rw2 + (temp_viaje.origen_x + (temp_viaje.x - temp_viaje.origen_x) * nave.viaje_pos / temp_viaje.dis - camx) / zoom,
							rh2 + (temp_viaje.origen_y + (temp_viaje.y - temp_viaje.origen_y) * nave.viaje_pos / temp_viaje.dis - camy) / zoom, 2, false)
					}
				}
			}
			if tag_mision_planeta[mision.index]{
				var planeta = mision.data.destino
				draw_circle(rw2 + (planeta.x - camx) / zoom, rh2 + (planeta.y - camy) / zoom, (planeta.gigante ? 98 : 18) / zoom, true)
			}
			if mision.index = mis_artefacto{
				var planeta = mision.data.destino.luna
				draw_circle_punteo(rw2 + (planeta.x - camx) / zoom, rh2 + (planeta.y - camy) / zoom, 200 / zoom)
			}
			if tag_mision_multiple[mision.index]{
				for(var b = array_length(mision.data.destinos) - 1; b >= 0; b--){
					var planeta = mision.data.destinos[b]
					draw_circle(rw2 + (planeta.x - camx) / zoom, rh2 + (planeta.y - camy) / zoom, (planeta.gigante ? 98 : 18) / zoom, true)
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
if min_dis < 255 and not nave_select.viaje_bool{
	if nave_select_bool and not nave_select.viaje_bool and planeta_mouse != viaje_planeta{
		viaje = calcular_viaje(nave_select.origen, planeta_mouse)
		viaje_bool = true
		viaje_planeta = planeta_mouse
	}
	planeta_mouse_bool = true
}
if planeta_mouse_bool
	draw_circle(rw2 + (planeta_mouse.x - camx) / zoom, rh2 + (planeta_mouse.y - camy) / zoom, (planeta_mouse.gigante ? 100 : 20) / zoom, true)
//Noticias
if step_noticia > 0{
	draw_set_alpha(min(--step_noticia / 150, 1))
	draw_set_halign(fa_center)
	draw_set_valign(fa_bottom)
	draw_text(rw2, room_height - 100, text_wrap(noticias[array_length(noticias) - 1].texto, 400))
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_alpha(1)
}
//Menú del planeta
if nave_select_bool and not nave_select.viaje_bool{
	var planeta = nave_select.origen, index = planeta.index
	draw_circle(rw2 + (planeta.x - camx) / zoom, rh2 + (planeta.y - camy) / zoom, (planeta.gigante ? 100 : 20) / zoom, true)
	//Viajar
	if viaje_bool and planeta_mouse_bool{
		draw_set_halign(fa_center)
		if viaje.dis > max_viaje{
			draw_text(rw2 + (planeta.x - camx) / zoom, rh2 + (planeta.y - camy) / zoom + 20, "!!Viaje demasiado largo!!")
			draw_set_color(c_orange)
		}
		var dis = array_length(viaje.viaje_x)
		for(var a = 1; a < dis; a++)
			draw_line(rw2 + (viaje.viaje_x[a - 1] - camx) / zoom, rh2 + (viaje.viaje_y[a - 1] - camy) / zoom, rw2 + (viaje.viaje_x[a] - camx) / zoom, rh2 + (viaje.viaje_y[a] - camy) / zoom)
		draw_arrow(rw2 + (planeta.x - camx) / zoom, rh2 + (planeta.y - camy) / zoom, rw2 + (viaje.x - camx) / zoom, rh2 + (viaje.y - camy) / zoom, 8)
		draw_set_color(c_white)
		draw_text(rw2 + (viaje.viaje_x[dis / 2] - camx) / zoom, rh2 + (viaje.viaje_y[dis / 2] - camy) / zoom, $"{viaje.dis} días")
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
			if draw_text_boton(rw2, room_height - 100, "Abrir comunicación",,, true){
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
if tutorial != -1{
	if tutorial = 0
		draw_text_background(rw2, 60, "Bienvenido a PLANETES\nHaz clic en abrir comunicación", fa_center)
	if tutorial = 5
		draw_text_background(rw2, 60, "Ahora haz clic en otro planeta para viajar a él", fa_center)
	if tutorial = 6
		draw_text_background(rw2, 60, "Mantén presionada la barra espaciadadora para adelantar el tiempo", fa_center)
	if tutorial = 7
		draw_text_background(rw2, 60, "Perfecto, ahora vende aquí algo de lo que hayas comprado", fa_center)
	if tutorial = 10
		if subsistema_vista
			draw_text_background(rw2, 60, $"Este es el sistema estelar, tu misión te pide ir a {jugador.misiones[0].data.destino.luna.nombre}", fa_center)
		else
			draw_text_background(rw2, 60, $"Esta misión pide viajar a {jugador.misiones[0].data.destino.luna.nombre} que está muy lejos\nGira la rueda del mouse para ver el sistema estelar completo", fa_center)
	if tutorial = 11
		draw_text_background(rw2, 60, "El viaje puede ser largo\nShift + Espacio para adelantar el tiempo más rápido", fa_center)
	if tutorial = 12
		draw_text_background(rw2, 60, "Aquí solo debes buscar el artefacto, en alguna de estas lunas debe estar", fa_center)
	if tutorial = 13
		draw_text_background(rw2, 60, "¡Bien hecho!\nCuando termines una misión recuerda siempre volver al planeta de origen", fa_center)
	if tutorial = 14{
		draw_text_background(rw2, 60, "Eso es todo por ahora\nExplora todos los mundos que quieras, comercia, cumple misiones y\ncorónate como el mayor mercader el sistema estelar", fa_center)
		if tutorial_step++ = 600{
			tutorial = -1
			ini_open("tutorial.ini")
			ini_write_real("Global", "tutorial", -1)
			ini_close()
		}
	}
}
draw_end()
//draw_relaciones_imperios(rw2, rh2)
