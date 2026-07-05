function add_imperio(){
	with control{
		var imperio = {
			index : counter_imperio++,
			nombre : gen_nombre(),
			arquetipo : 0,
			planetas : array_create(0, null_planeta),
			relacion_imperio : ds_map_create(),
			relacion_empresa : ds_map_create(),
			relacion_empresa_piso : ds_map_create(),
			eliminado : false
		}
		for(var a = array_length(imperios) - 1; a >= 0; a--){
			var temp_imperio = imperios[a]
			ds_map_add(imperio.relacion_imperio, temp_imperio.index, 0)
			ds_map_add(temp_imperio.relacion_imperio, imperio.index, 0)
		}
		for(var a = array_length(empresas) - 1; a >= 0; a--){
			var empresa = empresas[a]
			ds_map_add(imperio.relacion_empresa, empresa.index, 0)
			ds_map_add(empresa.relacion_imperio, imperio.index, 0)
			ds_map_add(imperio.relacion_empresa_piso, empresa.index, 0)
			ds_map_add(empresa.relacion_imperio_piso, imperio.index, 0)
		}
		array_push(imperios, imperio)
		return imperio
	}
}