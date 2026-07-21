function scr_batalla(){
	with control{
		var jugx = batalla_naves[0].x, jugy = batalla_naves[0].y
		if jugx - batalla_sidex < batalla_camx
			batalla_camx = jugx - batalla_sidex
		if jugy - batalla_sidey < batalla_camy
			batalla_camy = jugy - batalla_sidey
		if jugx + batalla_sidex - room_width > batalla_camx
			batalla_camx = jugx + batalla_sidex - room_width
		if jugy + batalla_sidey - room_height > batalla_camy
			batalla_camy = jugy + batalla_sidey - room_height
		if is_undefined(batalla_background){
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
				var a = irandom(room_width), b = irandom(room_height), c = irandom_range(60, 160)
				draw_circle(a, b, c, false)
				var amin = (a - c < 0), bmin = (b - c < 0), amax = (a + c > room_width), bmax = (b + c > room_height)
				if amin{
					draw_circle(a + room_width, b, c, false)
					if bmin
						draw_circle(a + room_width, b + room_height, c, false)
					else if bmax
						draw_circle(a + room_width, b - room_height, c, false)
				}
				else if amax{
					draw_circle(a - room_width, b, c, false)
					if bmin
						draw_circle(a - room_width, b + room_height, c, false)
					else if bmax
						draw_circle(a - room_width, b - room_height, c, false)
				}
				if bmin
					draw_circle(a, b + room_height, c, false)
				else if bmax
					draw_circle(a, b - room_height, c, false)
				
			}
			draw_set_alpha(1)
			batalla_background = sprite_create_from_surface(surf, 0, 0, room_width, room_height, false, false, 0, 0)
			surface_reset_target()
			surface_free(surf)
		}
		draw_sprite(batalla_background, 0, -batalla_camx + room_width * floor(batalla_camx / room_width), -batalla_camy + room_height * floor(batalla_camy / room_height))
		draw_sprite(batalla_background, 0, -batalla_camx + room_width * (1 + floor(batalla_camx / room_width)), -batalla_camy + room_height * floor(batalla_camy / room_height))
		draw_sprite(batalla_background, 0, -batalla_camx + room_width * floor(batalla_camx / room_width), -batalla_camy + room_height * (1 + floor(batalla_camy / room_height)))
		draw_sprite(batalla_background, 0, -batalla_camx + room_width * (1 + floor(batalla_camx / room_width)), -batalla_camy + room_height * (1 + floor(batalla_camy / room_height)))
		draw_set_color(c_red)
		for(var a = array_length(batalla_naves) - 1; a >= 0; a--)
			with batalla_naves[a]{
				if control.batalla_loser = self
					continue
				x += vel * cos(degtorad(dir))
				y -= vel * sin(degtorad(dir))
				var xx = x - control.batalla_camx, yy = y - control.batalla_camy
				if xx < 0 or yy < 0 or xx > room_width or yy > room_height{
					var _jugx = control.batalla_naves[0].x - control.batalla_camx, _jugy = control.batalla_naves[0].y - control.batalla_camy
					var _angle = degtorad(point_direction(xx, yy, _jugx, _jugy)), cosa = cos(_angle), sina = sin(_angle)
					draw_line(_jugx - 10 * cosa, _jugy + 10 * sina, _jugx - 30 * cosa, _jugy + 30 * sina)
				}
				else{
					draw_sprite_ext(spr_nave, nave.modelo, xx, yy, 2, 2, dir, c_white, 1)
					if hp <= 30 and control.image_index % 2{
						var b = random_range(-1, 1)
						array_push(control.batalla_humo, {
							x : x,
							y : y,
							hmove : b,
							vmove : sqrt(1 - sqr(b)) * (2 * irandom(1) - 1),
							step : 60
						})
					}
				}
				if abs(vel) > 0.01
					vel *= 0.95
				else
					vel = 0
				if abs(diff) < 3
					dir += diff
				else
					dir += diff / 20
				for(var b = array_length(control.batalla_asteroides) - 1; b >= 0; b--){
					var temp_asteroide = control.batalla_asteroides[b]
					if distance_sqr(x, y, temp_asteroide.x, temp_asteroide.y) < batalla_hitbox{
						hp -= 30
						if hp <= 0
							batalla_end(self)
						add_batalla_efecto(temp_asteroide.x, temp_asteroide.y, spr_explosion, 30)
						array_disorder_remove(control.batalla_asteroides, temp_asteroide, 0)
						break
					}
				}
			}
		for(var a = array_length(batalla_asteroides) - 1; a >= 0; a--)
			with batalla_asteroides[a]{
				var xx = x - control.batalla_camx, yy = y - control.batalla_camy
				draw_sprite_ext(spr_asteroides, tipo, xx, yy, 1, 1, angle, c_white, 1)
				x += hmove
				y += vmove
				angle += rot
				if xx < -batalla_asteroide_disx
					x += room_width + 2 * batalla_asteroide_disx
				else if xx > room_width + batalla_asteroide_disx
					x -= room_width + 2 * batalla_asteroide_disx
				if yy < -batalla_asteroide_disy
					y += room_height + 2 * batalla_asteroide_disy
				else if yy > room_height + batalla_asteroide_disy
					y -= room_height + 2 * batalla_asteroide_disy
			}
		draw_set_color(c_white)
		for(var a = array_length(batalla_humo) - 1; a >= 0; a--)
			with batalla_humo[a]{
				x += hmove
				y += vmove
				hmove *= 0.9
				vmove *= 0.9
				if --step = 0
					array_remove(control.batalla_humo, self)
				else{
					draw_set_color(make_color_hsv(0, 0, 255 - 4 * step))
					draw_set_alpha(step / 180)
				}
				draw_circle(x - control.batalla_camx, y - control.batalla_camy, 16 - step / 8, false)
			}
		draw_set_color(c_yellow)
		draw_set_alpha(1)
		for(var a = array_length(batalla_balas) - 1; a >= 0; a--)
			with batalla_balas[a]{
				var flag = false
				draw_line(x - control.batalla_camx, y - control.batalla_camy, x + 4 * hmove - control.batalla_camx, y + 4 * vmove - control.batalla_camy)
				repeat(vel){
					x += hmove
					y += vmove
					for(var b = array_length(control.batalla_naves) - 1; b >= 0; b--){
						var temp_nave = control.batalla_naves[b]
						if temp_nave != home and distance_sqr(x, y, temp_nave.x, temp_nave.y) < batalla_hitbox{
							temp_nave.hp -= 20
							if temp_nave.hp <= 0
								batalla_end(temp_nave)
							flag = true
							break
						}
					}
					for(var b = array_length(control.batalla_asteroides) - 1; b >= 0; b--){
						var temp_asteroide = control.batalla_asteroides[b]
						if distance_sqr(x, y, temp_asteroide.x, temp_asteroide.y) < batalla_hitbox{
							add_batalla_efecto(temp_asteroide.x, temp_asteroide.y, spr_explosion, 30)
							array_disorder_remove(control.batalla_asteroides, temp_asteroide, 0)
							flag = true
							break
						}
					}
					if flag
						break
				}
				if --step = 0 or flag{
					array_disorder_remove(control.batalla_balas, self, 0)
					continue
				}
			}
		for(var a = array_length(batalla_efectos) - 1; a >= 0; a--)
			with batalla_efectos[a]{
				draw_sprite(efecto, subsprite, x - control.batalla_camx, y - control.batalla_camy)
				subsprite += vel
				if --step = 0
					array_disorder_remove(control.batalla_efectos, self, 0)
			}
		if batalla_step = 0{
			draw_set_color(c_white)
			draw_set_alpha(0.5)
			//Controles
			for(var a = array_length(batalla_naves) - 1; a >= 0; a--)
				with batalla_naves[a]{
					if ia{
						var target = control.batalla_naves[0]
						var _dis = distance_sqr(x, y, target.x, target.y)
						diff = angle_difference(point_direction(x, y, target.x, target.y), dir)
						if --step <= 0 and abs(diff) < 1 and _dis < batalla_dis_bala{
							add_batalla_bala(x, y, cos(degtorad(dir)), -sin(degtorad(dir)), 20, self)
							if nave.armas > 1
								add_batalla_bala(x + 3 * sin(degtorad(dir)), y + 3 * cos(degtorad(dir)), cos(degtorad(dir)), -sin(degtorad(dir)), 20, self)
							if nave.armas > 2
								add_batalla_bala(x - 3 * sin(degtorad(dir)), y + 3 * cos(degtorad(dir)), cos(degtorad(dir)), -sin(degtorad(dir)), 20, self)
							step = 25
						}
						if _dis > batalla_dis_freno
							vel += 0.8 * control.nave_vel[nave.modelo] / max(1, sqrt(abs(diff / 20)))
					}
					else{
						if mouse_check_button(mb_any){
							draw_line(x - control.batalla_camx, y - control.batalla_camy, mouse_x, mouse_y)
							diff = angle_difference(point_direction(x - control.batalla_camx, y - control.batalla_camy, mouse_x, mouse_y), dir)
							if mouse_check_button(mb_left)
								vel += control.nave_vel[nave.modelo] / max(1, sqrt(abs(diff / 20)))
						}
						if keyboard_check_pressed(vk_space){
							add_batalla_bala(x, y, cos(degtorad(dir)), -sin(degtorad(dir)), 20, self)
							if nave.armas > 1
								add_batalla_bala(x + 3 * sin(degtorad(dir)), y + 3 * cos(degtorad(dir)), cos(degtorad(dir)), -sin(degtorad(dir)), 20, self)
							if nave.armas > 2
								add_batalla_bala(x - 3 * sin(degtorad(dir)), y + 3 * cos(degtorad(dir)), cos(degtorad(dir)), -sin(degtorad(dir)), 20, self)
						}
						if keyboard_check(ord("W"))
							vel += 0.1
					}
				}
			draw_set_alpha(1)
			//Generación de asteroides
			if random(1) < 0.01{
				var _angle = random(360), cosa = cos(_angle), sina = sin(_angle), _vel = random_range(0.5, 1.5)
				add_batalla_asteroide(jugx + room_width * cosa, jugy - room_width * sina, -_vel * cosa, _vel * sina)
			}
		}
		else if --batalla_step = 0{
			for(var a = array_length(batalla_naves) - 1; a >= 0; a--){
				var _batalla_nave = batalla_naves[a]
				if _batalla_nave = batalla_loser
					continue
				_batalla_nave.nave.hp = _batalla_nave.hp
			}
			delete_nave(batalla_loser.nave)
			batalla = false
			batalla_planeta = null_planeta
		}
	}
}