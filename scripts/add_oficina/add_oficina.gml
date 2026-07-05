function add_oficina(planeta = control.null_planeta, empresa = control.null_empresa){
	with control{
		var oficina = {
			planeta : planeta,
			empresa : empresa,
			recurso : array_create(recurso_max, 0),
			precio_compra : array_create(recurso_max, 0),
			precio_venta : array_create(recurso_max, 0),
		}
		for(var a = 0; a < recurso_max; a++)
			oficina.precio_venta[a] = recurso_precio[a] / 10
		empresa.oficina_bool[planeta.index] = true
		empresa.oficina[planeta.index] = oficina
		return oficina
	}
}