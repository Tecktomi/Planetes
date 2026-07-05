function mision_fallar(mision = control.null_mision, motivo = ""){
	with control{
		var empresa = mision.contratado, planeta = mision.contratista, index = mision.index
		array_disorder_remove(empresa.misiones, mision, 0)
		array_disorder_remove(mision.nave_asignada.misiones, mision, 1)
		empresa.relacion_imperio[? planeta.imperio.index] -= mision_penalizacion[index]
		for(var d = array_length(empresa.misiones) - 1; d >= 0; d--)
			if empresa.misiones[d].index = mis_fallar and not empresa.misiones[d].status and empresa.misiones[d].data.destino = planeta
				mision_cumplir(empresa.misiones[d])
		if index = mis_llenar_bodega
			mision.nave_asignada.recursos_acumulados[mision.data.recurso] = false
		if empresa = jugador{
			misiones_falladas++
			add_noticia("Has fallado una misión", $"{motivo != "" ? motivo + "\n" : ""}{arquetipo_fallo[planeta.arquetipo]}")
		}
		empresa.ultima_falla[index] = dia
	}
}