function batalla_end(nave = control.null_nave){
	with control{
		add_batalla_efecto(nave.x, nave.y, spr_explosion, 30)
		batalla_step = 180
		batalla_loser = nave
		var empresa_winner
		for(var a = array_length(batalla_naves) - 1; a >= 0; a--){
			var batalla_nave = batalla_naves[a]
			batalla_nave.nave.hp = batalla_nave.hp
			if batalla_nave.nave != batalla_loser
				empresa_winner = batalla_nave.nave.empresa
		}
		var pirata_empresa = batalla_pirata.empresa
		relacion_add(pirata_empresa, batalla_planeta.imperio, rel_pirateria, arquetipo_pirateria[batalla_planeta.arquetipo])
		if pirata_empresa = empresa_winner
			for(var a = array_length(pirata_empresa.misiones_index[mis_pirateria]) - 1; a >= 0; a--){
				var mision = pirata_empresa.misiones_index[mis_pirateria, a]
				if not mision.status and mision.data.destino = batalla_planeta
					mision_cumplir(mision)
			}
		if pirata_empresa = batalla_loser.nave.empresa
			for(var a = array_length(pirata_empresa.misiones_index[mis_pirateria]) - 1; a >= 0; a--){
				var mision = pirata_empresa.misiones_index[mis_pirateria, a]
				if not mision.status and mision.data.destino = batalla_planeta
					mision_fallar(mision, "Te han destruido a ti")
			}
	}
}