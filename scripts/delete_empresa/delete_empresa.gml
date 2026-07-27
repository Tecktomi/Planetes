function delete_empresa(empresa = control.null_empresa){
	with control{
		if not empresa.alive
			exit
		empresa.alive = false
		if empresa = jugador{
			show_message("Has perdido")
			game_end()
		}
		else
			add_noticia("Ha quebrado una empresa", $"Ha quebrado la empresa {empresa.nombre}")
		array_disorder_remove(empresas, empresa, 0)
		var index = empresa.index
		for(var a = array_length(imperios) - 1; a >= 0; a--){
			var imperio = imperios[a]
			ds_map_destroy(empresa.relacion_imperio)
			ds_map_delete(imperio.relacion_empresa, index)
			for(var b = 0; b < relacion_motivo_max; b++){
				ds_map_destroy(empresa.relacion_imperio_motivo[b])
				ds_map_delete(imperio.relacion_empresa_motivo[b], index)
			}
		}
		ds_grid_destroy(empresa.fabricas)
		delete empresa
	}
}