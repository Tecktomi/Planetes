function mision_terminar(mision = control.null_mision){
	with control{
		var empresa = mision.contratado, planeta = mision.contratista, index = mision.index
		if empresa = jugador{
			var temp_text = arquetipo_exito[mision.contratista.arquetipo]
			if index = mis_espiar_empresas{
				temp_text += "\nInformación obtenida:\n"
				for(var c = array_length(mision.data.empresas) - 1; c >= 0; c--){
					var temp_empresa = mision.data.empresas[c], recurso = irandom(recurso_max - 1)
					if irandom(1){
						temp_text += $"La empresa {temp_empresa.nombre} compra {recurso_nombre[recurso]} en {planeta_nombre(temp_empresa.recurso_compra_lugar[recurso])} a ${temp_empresa.recurso_compra_precio[recurso]}\n"
						if temp_empresa.recurso_compra_precio[recurso] < empresa.recurso_compra_precio[recurso]{
							empresa.recurso_compra_precio[recurso] = temp_empresa.recurso_compra_precio[recurso]
							empresa.recurso_compra_lugar[recurso] = temp_empresa.recurso_compra_lugar[recurso]
						}
					}
					else{
						temp_text += $"La empresa {temp_empresa.nombre} vende {recurso_nombre[recurso]} en {planeta_nombre(temp_empresa.recurso_venta_lugar[recurso])} a ${temp_empresa.recurso_venta_precio[recurso]}\n"
						if temp_empresa.recurso_venta_precio[recurso] > empresa.recurso_venta_precio[recurso]{
							empresa.recurso_venta_precio[recurso] = temp_empresa.recurso_venta_precio[recurso]
							empresa.recurso_venta_lugar[recurso] = temp_empresa.recurso_venta_lugar[recurso]
						}
					}
				}
			}
			else if index = mis_espiar_planeta{
				temp_text += $"\nInformación obtenida: Producción anual en {planeta_nombre(mision.data.destino)}"
				for(var c = 0; c < recurso_max; c++)
					if irandom(1)
						temp_text += $"\n{recurso_nombre[c]}: {floor(100 * mision.data.destino.recurso_fabrica[c])}%"
			}
			else if index = mis_electronicos and irandom(1)
				mision.contratista.estado = 4
			add_noticia("Misión cumplida", temp_text)
			misiones_cumplidas++
		}
		empresa.dinero += mision.paga
		array_disorder_remove(mision.nave_asignada.misiones, mision, 1)
		var len = array_length(empresa.misiones), pos = mision.pointer[0]
		empresa.misiones[pos] = empresa.misiones[len - 1]
		empresa.misiones[pos].pointer[0] = pos
		array_pop(empresa.misiones)
	}
}