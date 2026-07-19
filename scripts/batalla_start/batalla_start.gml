function batalla_start(planeta = control.null_planeta, nave = control.null_nave, pirata = control.null_empresa){
	with control{
		batalla_planeta = planeta
		batalla_pirata = pirata
		batalla_naves = [
			add_batalla_nave(nave_select,,,,, nave_select.hp, false),
			add_batalla_nave(nave, 600, 400, 120, 0.5, nave.hp / 2, true)]
	}
}