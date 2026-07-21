function add_mision(index, planeta = control.null_planeta, empresa = control.null_empresa){
	with control{
		var mision = {
			index : real(index),
			nombre : "",
			contratista : planeta,
			contratado : empresa,
			fecha : 0,
			status : false,
			paga : mision_paga[index],
			data : {},
			//0: empresa.misiones, 1: nave.misiones, 2.empresa.mision_index
			pointer : array_create(3, 0),
			restricciones : array_create(0, null_planeta),
			restricciones_texto : "",
			//Para los NPC
			nave_asignada : null_nave
		}
		array_disorder_push(empresa.misiones, mision, 0)
		array_disorder_push(empresa.misiones_index[index], mision, 2)
		return mision
	}
}