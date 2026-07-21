function add_nave(empresa = control.null_empresa, modelo = 0){
	with control{
		var nave = {
			index : counter_nave++,
			origen : null_planeta,
			destino : null_planeta,
			//0: naves, 1: empresa.naves
			pointer : array_create(2, 0),
			empresa : empresa,
			viaje : null_viaje,
			viaje_bool : false,
			viaje_pos : 0,
			recurso : array_create(recurso_max, 0),
			recurso_total : 0,
			misiones : array_create(0, null_mision),
			modelo : modelo,
			hp : nave_hp[modelo],
			armas : 1
		}
		array_disorder_push(naves, nave, 0)
		array_disorder_push(empresa.naves, nave, 1)
		return nave
	}
}