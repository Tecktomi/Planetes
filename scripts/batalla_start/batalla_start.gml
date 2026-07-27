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
			var loser = (random(pirata.armas) > random(victima.armas) ? pirata : victima)
			relacion_add(pirata.empresa, planeta.imperio, rel_pirateria, 1)
			delete_nave(loser)
			return (loser = victima)
		}
		return false
	}
}