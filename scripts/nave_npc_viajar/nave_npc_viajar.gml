function nave_npc_viajar(nave = control.null_nave, planeta = control.null_planeta){
	with control{
		var empresa = nave.empresa, viajando_mision = false, viajar = true
		//Detectar si tiene misiones pendientes
		if array_length(nave.misiones) > 0{
			var mision = nave.misiones[0]
			if mision.status{
				nave.destino = mision.contratista
				viajando_mision = true
			}
			else{
				//Viajar simple
				if tag_mision_planeta[mision.index] and planeta != mision.data.destino{
					nave.destino = mision.data.destino
					viajando_mision = true
				}
				//Viajar múltiples
				else if tag_mision_multiple[mision.index] and planeta != mision.data.destinos[0]{
					nave.destino = mision.data.destinos[0]
					viajando_mision = true
				}
				//No viajar
				if tag_mision_espiar[mision.index] and planeta = mision.data.destino
					viajar = false
			}
		}
		if viajar{
			if not viajando_mision{
				var _min_dis = infinity
				repeat(IA_INTENTOS_VIAJES){
					var temp_destino = array_choose(planetas_no_gigantes)
					var temp_viaje = calcular_viaje_light(planeta, temp_destino)
					if temp_viaje.dis < _min_dis{
						_min_dis = temp_viaje.dis
						nave.destino = temp_destino
						nave.viaje = temp_viaje
					}
				}
			}
			else
				nave.viaje = calcular_viaje_light(planeta, nave.destino)
			nave.viaje_bool = true
		}
	}
}