function batalla_end(nave = control.null_nave){
	with control{
		add_batalla_efecto(nave.x, nave.y, spr_explosion, 30)
		batalla_step = 180
		batalla_loser = nave
		batalla_pirata.relacion_imperio[? batalla_planeta.imperio.index] -= arquetipo_pirateria[batalla_planeta.arquetipo]
		for(var b = array_length(jugador.misiones) - 1; b >= 0; b--){
			var mision = jugador.misiones[b]
			if not mision.status and mision.index = mis_pirateria and mision.data.destino = batalla_planeta
				mision_cumplir(mision)
		}
	}
}