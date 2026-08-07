function clear_game(){
	with control{
		for(var a = array_length(imperios) - 1; a >= 0; a--){
			var imperio = imperios[a]
			ds_map_destroy(imperio.relacion_empresa)
			ds_map_destroy(imperio.relacion_imperio)
			for(var b = 0; b < relacion_motivo_max; b++)
				ds_map_destroy(imperio.relacion_empresa_motivo[b])
		}
		for(var a = array_length(empresas) - 1; a >= 0; a--){
			var empresa = empresas[a]
			ds_grid_destroy(empresa.fabricas)
			ds_map_destroy(empresa.relacion_imperio)
			for(var b = 0; b < relacion_motivo_max; b++)
				ds_map_destroy(empresa.relacion_imperio_motivo[b])
		}
		planetas = array_create(0, null_planeta)
		planetas_terrestres = array_create(0, null_planeta)
		planetas_gigantes = array_create(0, null_planeta)
		planetas_no_gigantes = array_create(0, null_planeta)
		planetas_terrestres_gigantes = array_create(0, null_planeta)
		planetas_internos = array_create(0, null_planeta)
		for(var a = 0; a < arquetipo_max; a++)
			planetas_arquetipo[a] = array_create(0, null_planeta)
		imperios = array_create(0, null_imperio)
		empresas = array_create(0, null_empresa)
		naves = array_create(0, null_nave)
		naves_piratas = array_create(0, null_nave)
		subsistema_vista = false
		subsistema = null_planeta
		show = MENU_NULL
	}
}