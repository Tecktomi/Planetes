function delete_imperio(imperio = control.null_imperio){
	with control{
		array_remove(imperios, imperio)
		ds_map_destroy(imperio.relacion_imperio)
		ds_map_destroy(imperio.relacion_empresa)
		ds_map_destroy(imperio.relacion_empresa_piso)
		for(var a = array_length(imperios) - 1; a >= 0; a--)
			ds_map_delete(imperios[a].relacion_imperio, imperio.index)
		for(var a = array_length(empresas) - 1; a >= 0; a--){
			ds_map_delete(empresas[a].relacion_imperio, imperio.index)
			ds_map_delete(empresas[a].relacion_imperio_piso, imperio.index)
		}
		if array_length(imperio.planetas) > 0
			show_error($"El imperio {imperio.nombre} fue eliminado pero aún tenía planetas asociados", true)
	}
}