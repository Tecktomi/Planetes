function reparar_nave(nave = control.null_nave){
	return ceil(nave.hp - control.nave_hp[nave.modelo])
}