function add_empresa(){
	with control{
		var empresa = {
			index : counter_empresa++,
			nombre : "",
			naves : array_create(0, null_nave),
			//0: empresas
			pointer : array_create(1, 0),
			dinero : 0,
			recurso_compra_precio : array_create(recurso_max, infinity),
			recurso_compra_lugar : array_create(recurso_max, null_planeta),
			recurso_venta_precio : array_create(recurso_max, 0),
			recurso_venta_lugar : array_create(recurso_max, null_planeta),
			misiones : array_create(0, null_mision),
			misiones_index : array_create(mision_max, array_create(0, null_mision)),
			riesgo : random_range(0.95, 1.05),
			oficina_bool : array_create(planeta_total, false),
			oficina : array_create(planeta_total, null_oficina),
			ultima_falla : array_create(mision_max, -infinity),
			fabricas : ds_grid_create(planeta_total, recurso_max),
			relacion_imperio : ds_map_create(),
			relacion_imperio_piso : ds_map_create()
		}
		for(var a = array_length(imperios) - 1; a >= 0; a--){
			ds_map_add(empresa.relacion_imperio, imperios[a].index, 0)
			ds_map_add(imperios[a].relacion_empresa, empresa.index, 0)
			ds_map_add(empresa.relacion_imperio_piso, imperios[a].index, 0)
			ds_map_add(imperios[a].relacion_empresa_piso, empresa.index, 0)
		}
		ds_grid_clear(empresa.fabricas, 0)
		array_disorder_push(empresas, empresa, 0)
		return empresa
	}
}