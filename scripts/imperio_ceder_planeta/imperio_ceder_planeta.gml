function imperio_ceder_planeta(imperio_ganador = control.null_imperio, imperio_perdedor = control.null_imperio, planeta = control.null_planeta){
	with control{
		if imperio_perdedor = imperio_ganador
			show_error("No puede pasar de un imperio al mismo imperio", true)
		if planeta.imperio != imperio_perdedor
			show_error($"El planeta {planeta_nombre(planeta)} no es parte del imperio {imperio_perdedor.nombre}", true)
		planeta.imperio = imperio_ganador
		array_push(imperio_ganador.planetas, planeta)
		array_remove(imperio_perdedor.planetas, planeta)
		if array_length(imperio_perdedor.planetas) = 0{
			add_noticia("Imperio destruido", $"El imperio {imperio_perdedor.nombre} ha sido destruido por el imperio {imperio_ganador.nombre}")
			array_push(imperios_eliminados, imperio_perdedor)
			imperio_perdedor.eliminado = true
			return true
		}
		else
			add_noticia("Planeta cedido", $"EL imperio {imperio_ganador.nombre} ha capturado el planeta {planeta_nombre(planeta)} al imperio {imperio_perdedor.nombre}")
		return false
	}
}