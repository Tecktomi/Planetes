function add_imperio(){
	with control{
		var imperio = {
			index : counter_imperio++,
			nombre : gen_nombre(),
			arquetipo : 0,
			planetas : array_create(0, null_planeta),
			relacion_imperio : ds_map_create(),
			relacion_empresa : ds_map_create(),
			relacion_empresa_motivo : array_create(relacion_motivo_max),
			eliminado : false
		}
		for(var a = array_length(imperios) - 1; a >= 0; a--){
			var temp_imperio = imperios[a]
			ds_map_add(imperio.relacion_imperio, temp_imperio.index, 0)
			ds_map_add(temp_imperio.relacion_imperio, imperio.index, 0)
		}
		for(var b = 0; b < relacion_motivo_max; b++){
			var temp_map = ds_map_create()
			ds_map_add(temp_map, 0, 0)
			ds_map_clear(temp_map)
			imperio.relacion_empresa_motivo[b] = temp_map
		}
		for(var a = array_length(empresas) - 1; a >= 0; a--){
			var empresa = empresas[a]
			ds_map_add(imperio.relacion_empresa, empresa.index, 0)
			ds_map_add(empresa.relacion_imperio, imperio.index, 0)
			for(var b = 0; b < relacion_motivo_max; b++){
				ds_map_add(imperio.relacion_empresa_motivo[b], empresa.index, 0)
				ds_map_add(empresa.relacion_imperio_motivo[b], imperio.index, 0)
			}
		}
		array_push(imperios, imperio)
		return imperio
	}
}