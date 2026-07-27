function batalla_start(planeta = control.null_planeta, pirata = control.null_nave, victima = control.null_nave){
	with control{
		if pirata.empresa = jugador or victima.empresa = jugador{
			show = MENU_BATALLA
			input_layer = 1
			batalla_planeta = planeta
			batalla_pirata = pirata
			batalla_naves = [
				add_batalla_nave(pirata),
				add_batalla_nave(victima, 600, 400, 30, 4)]
		}
		else{
			miedo_pirata++
			//Pelear
			if victima.armas > pirata_arma_min and irandom(1){
				var loser = (random(pirata.armas) > random(victima.armas) ? pirata : victima)
				relacion_add(pirata.empresa, planeta.imperio, rel_pirateria, arquetipo_pirateria[planeta.arquetipo])
				delete_nave(loser)
				return (loser = victima)
			}
			//Rendirse
			else{
				var diff = pirata.bodega - pirata.recurso_total
				for(var a = 0; a < recurso_max; a++){
					var b = victima.recurso[a]
					if diff < b{
						pirata.recurso[a] += diff
						pirata.recurso_total += diff
						victima.recurso[a] -= diff
						victima.recurso_total -= diff
						break
					}
					else{
						pirata.recurso[a] += b
						pirata.recurso_total += b
						victima.recurso[a] = 0
						victima.recurso_total -= b
						diff -= b
					}
				}
			}
		}
		return false
	}
}