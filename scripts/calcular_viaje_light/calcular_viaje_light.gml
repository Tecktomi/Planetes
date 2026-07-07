function calcular_viaje_light(origen = control.null_planeta, destino = control.null_planeta){
	var xx = origen.x, yy = origen.y
	var angle = destino.fase, diff = destino.anno, radio = destino.radio
	var center_x = room_width / 2, center_y = room_height / 2
	var salto = 512
	//Luna
	if destino.luna_bool{
		var angle_luna = destino.luna.fase, diff_luna = destino.luna.anno, radio_luna = destino.luna.radio
		for(var dis = 0; dis < 3000; dis += salto){
			var current_angle_luna = angle_luna + diff_luna * dis
			var center_x_luna = center_x + (cos(current_angle_luna) + EXCENTRICIDAD) * radio_luna
			var center_y_luna = center_y + sin(current_angle_luna) * radio_luna * 0.9
			var current_angle = angle + diff * dis
			var xxx = center_x_luna + cos(current_angle) * radio
			var yyy = center_y_luna + sin(current_angle) * radio
			if distance(xx, yy, xxx, yyy) < dis{
				if salto = 1
					return {
						dis : dis,
						x : xxx,
						y : yyy,
						viaje_x : array_create(dis, 0),
						viaje_y : array_create(dis, 0),
						origen_x : origen.x,
						origen_y : origen.y
					}
				dis -= salto
				salto = salto >> 1
			}
		}
	}
	//Planeta
	else{
		for(var dis = 0; dis < 3000; dis += salto){
			var current_angle = angle + diff * dis
			var xxx = center_x + (cos(current_angle) + EXCENTRICIDAD) * radio
			var yyy = center_y + sin(current_angle) * radio * 0.9
			if distance(xx, yy, xxx, yyy) < dis{
				if salto = 1
					return {
						dis : dis,
						x : xxx,
						y : yyy,
						viaje_x : array_create(dis, 0),
						viaje_y : array_create(dis, 0),
						origen_x : origen.x,
						origen_y : origen.y
					}
				dis -= salto
				salto = salto >> 1
			}
		}
	}
	return control.null_viaje
}