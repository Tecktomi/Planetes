function delete_imperio(imperio = control.null_imperio){
	with control{
		array_disorder_remove(imperios, imperio, 0)
		ds_map_destroy(imperio.relacion_imperio)
		ds_map_destroy(imperio.relacion_empresa)
		for(var a = array_length(imperios) - 1; a >= 0; a--)
			ds_map_delete(imperios[a].relacion_imperio, imperio.index)
		for(var a = array_length(empresas) - 1; a >= 0; a--){
			var empresa = empresas[a]
			ds_map_delete(empresa.relacion_imperio, imperio.index)
			for(var b = 0; b < relacion_motivo_max; b++)
				ds_map_delete(empresa.relacion_imperio_motivo[b], imperio.index)
		}
		if array_length(imperio.planetas) > 0
			show_error($"El imperio {imperio.nombre} fue eliminado pero aún tenía planetas asociados", true)
	}
}