function delete_empresa(empresa = control.null_empresa){
	with control{
		if empresa = jugador{
			show_message("HAS perdido")
			game_end()
		}
		else
			add_noticia("Ha quebrado una empresa", $"Ha quebrado la empresa {empresa.nombre}")
		array_disorder_remove(empresas, empresa, 0)
		for(var a = array_length(imperios) - 1; a >= 0; a--){
			ds_map_destroy(empresa.relacion_imperio)
			ds_map_delete(imperios[a].relacion_empresa, empresa.index)
			ds_map_destroy(empresa.relacion_imperio_piso)
			ds_map_delete(imperios[a].relacion_empresa_piso, empresa.index)
		}
		ds_grid_destroy(empresa.fabricas)
		delete empresa
	}
}