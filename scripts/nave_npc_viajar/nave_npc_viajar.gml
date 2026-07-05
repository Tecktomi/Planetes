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
				if tag_mision_espiar[mision.index] and planeta = mision.data.destino
					viajar = false
			}
		}
		if viajar{
			if not viajando_mision
				nave.destino = array_choose(planetas_no_gigantes)
			nave.viaje = calcular_viaje_light(planeta, nave.destino)
			nave.viaje_bool = true
		}
	}
}