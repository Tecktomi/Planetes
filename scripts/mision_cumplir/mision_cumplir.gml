function mision_cumplir(mision = control.null_mision){
	with control{
		var empresa = mision.contratado, planeta = mision.contratista, index = mision.index
		if mision.nave_asignada.origen = planeta and not mision.nave_asignada.viaje_bool
			mision_terminar(mision)
		else{
			mision.status = true
			mision.nombre = $"Ahora vuelve a {planeta_nombre(planeta)}"
			mision.fecha = max(mision.fecha, dia + 1000)
		}
		for(var d = array_length(empresa.misiones) - 1; d >= 0; d--)
			if empresa.misiones[d].index = mis_fallar and not empresa.misiones[d].status and empresa.misiones[d].data.destino = planeta
				mision_fallar(empresa.mision, "Se supone que debías fallar, no tener éxito")
		empresa.relacion_imperio[? planeta.imperio.index] += mision_recompensa[index]
		//Efectos de las misiones
		if in(index, mis_desabastecer, mis_saturar_mercado, mis_espiar_planeta, mis_armas)
			empresa.relacion_imperio[? planeta.imperio.index]--
		if index = mis_armas and in(mision.data.destino.estado, TENSION, PROTESTAS, DICTADURA) and irandom(1)
			mision.data.destino.estado = GUERRA
		if index = mis_desabastecer and in(mision.data.destino.estado, BURBUJA, DICTADURA) and irandom(1){
			var estado = mision.data.destino.estado
			if estado = BURBUJA
				mision.data.destino.estado = ESCASEZ
			else if estado = DICTADURA
				mision.data.destino.estado = PROTESTAS
		}
		if index = mis_saturar_mercado and in(mision.data.destino.estado, TENSION, CRECIMIENTO, BURBUJA) and irandom(1){
			var estado = mision.data.destino.estado
			if estado = TENSION
				mision.data.destino.estado = CRECIMIENTO
			else if estado = CRECIMIENTO
				mision.data.destino.estado = BURBUJA
			else if estado = BURBUJA
				mision.data.destino.estado = ESCASEZ
		}
		if index = mis_salvar_fauna
			mision.nave_asignada.origen.recurso_fabrica[rec_fauna] += 0.1
	}
}