function scr_batalla(){
	with control{
		for(var a = array_length(batalla_naves) - 1; a >= 0; a--)
			with batalla_naves[a]{
				if control.batalla_loser = self{
					if control.batalla_step > 120
						draw_sprite(spr_explosion, (180 - control.batalla_step) / 10, x, y)
					continue
				}
				draw_sprite_ext(spr_nave, 0, x, y, 2, 2, dir, c_white, 1)
				x += vel * cos(degtorad(dir))
				y -= vel * sin(degtorad(dir))
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
					if distance_sqr(x, y, temp_asteroide.x, temp_asteroide.y) < 255{
						hp -= 30
						if hp <= 0{
							control.batalla_step = 180
							control.batalla_loser = self
						}
						array_disorder_remove(control.batalla_asteroides, temp_asteroide, 0)
						break
					}
				}
			}
		for(var a = array_length(batalla_asteroides) - 1; a >= 0; a--)
			with batalla_asteroides[a]{
				draw_sprite_ext(spr_asteroides, tipo, x, y, 1, 1, angle, c_white, 1)
				x += hmove
				y += vmove
				angle += rot
			}
		draw_set_color(c_yellow)
		for(var a = array_length(batalla_balas) - 1; a >= 0; a--)
			with batalla_balas[a]{
				var flag = false
				draw_line(x, y, x + 4 * hmove, y + 4 * vmove)
				repeat(vel){
					x += hmove
					y += vmove
					for(var b = array_length(control.batalla_naves) - 1; b >= 0; b--){
						var temp_nave = control.batalla_naves[b]
						if temp_nave != home and distance_sqr(x, y, temp_nave.x, temp_nave.y) < 255{
							temp_nave.hp -= 20
							if temp_nave.hp <= 0{
								control.batalla_step = 180
								control.batalla_loser = temp_nave
							}
							flag = true
							break
						}
					}
					for(var b = array_length(control.batalla_asteroides) - 1; b >= 0; b--){
						var temp_asteroide = control.batalla_asteroides[b]
						if distance_sqr(x, y, temp_asteroide.x, temp_asteroide.y) < 255{
							array_disorder_remove(control.batalla_asteroides, temp_asteroide, 0)
							flag = true
							break
						}
					}
					if flag
						break
				}
				if x < 0 or y < 0 or x > room_width or y > room_height or flag{
					array_disorder_remove(control.batalla_balas, self, 0)
					continue
				}
			}
		if batalla_step = 0{
			draw_set_color(c_white)
			draw_set_alpha(0.5)
			//Control manual
			with batalla_naves[0]{
				if mouse_check_button(mb_any){
					draw_line(x, y, mouse_x, mouse_y)
					diff = angle_difference(point_direction(x, y, mouse_x, mouse_y), dir)
				}
				if keyboard_check_pressed(vk_space)
					add_batalla_bala(x, y, cos(degtorad(dir)), -sin(degtorad(dir)), 15, self)
				if mouse_check_button(mb_left)
					vel += 0.4 / max(1, sqrt(abs(diff / 20)))
			}
			draw_set_alpha(1)
			//IA
			for(var a = array_length(batalla_naves) - 1; a > 0; a--)
				with batalla_naves[a]{
					var target = control.batalla_naves[0]
					diff = angle_difference(point_direction(x, y, target.x, target.y), dir)
					if --step <= 0 and abs(diff) < 3{
						add_batalla_bala(x, y, cos(degtorad(dir)), -sin(degtorad(dir)), 15, self)
						step = 15
					}
					vel += 0.4 / max(1, sqrt(abs(diff / 20)))
				}
			//Generación de asteroides
			if random(1) < 0.01{
				if irandom(1){
					if irandom(1)
						add_batalla_asteroide(random(room_width), 0, random_range(-1, 1), random_range(0.5, 1))
					else
						add_batalla_asteroide(random(room_width), room_height, random_range(-1, 1), random_range(-0.5, -1))
				}
				else{
					if irandom(1)
						add_batalla_asteroide(0, random(room_height), random_range(0.5, 1), random_range(-1, 1))
					else
						add_batalla_asteroide(room_width, random(room_height), random_range(-0.5, -1), random_range(-1, 1))
				}
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