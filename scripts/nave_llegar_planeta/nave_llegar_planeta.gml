function nave_llegar_planeta(nave = control.null_nave){
	with control{
		var planeta = nave.destino, empresa = nave.empresa
		nave.viaje_bool = false
		nave.origen = planeta
		//Misiones
		for(var b = array_length(empresa.misiones) - 1; b >= 0; b--){
			var mision = empresa.misiones[b]
			if not mision.status{
				if not is_undefined(mision_on_viaje[mision.index])
					mision_on_viaje[mision.index](mision, planeta)
				//Restricciones
				if in(mision.restricciones, planeta)
					mision_fallar(mision, $"Has pasado por {planeta_nombre(planeta)}")
			}
			//Regresar por la paga
			else if mision.contratista = planeta{
				mision_terminar(mision)
				if tutorial = 13 and empresa = jugador
					tutorial++
			}
		}
		nave.viaje_pos = 0
		if empresa = jugador{
			pasar_dia_bool = false
			last_path_index = (++last_path_index) mod 5
			last_path[last_path_index] = planeta
			if array_contains(planetas_gigantes, planeta){
				subsistema = planeta
				subsistema_vista = false
			}
			else if planeta.luna_bool and array_contains(planetas_gigantes, planeta.luna)
				subsistema = planeta.luna
			else
				subsistema = null_planeta
			if tutorial = 6
				tutorial++
			if tutorial = 11 and planeta = jugador.misiones[0].data.destino.luna
				tutorial++
		}
		//Empresas al llegar a un planeta
		else{
			//Entrar en batalla
			if batalla and nave_select_bool and not nave_select.viaje_bool and nave.destino = nave_select.origen
				batalla_start(nave.destino, nave, jugador)
			var mision = (array_length(nave.misiones) = 0 ? null_mision : nave.misiones[0]), mision_index = mision.index
			var flag_saturar_2 = (mision_index = mis_saturar_mercado and mision.data.destino = planeta)
			var flag_comida_2 = (mision_index = mis_comida and array_contains(mision.data.destinos, planeta))
			var flag_desabastecer_2 = (mision_index = mis_desabastecer and mision.data.destino = planeta)
			var flag_bodega_2 = (mision_index = mis_llenar_bodega)
			var flag_electronicos_2 = (mision_index = mis_electronicos and array_contains(mision.data.destinos, planeta))
			//Comerciar
			for(var b = 0; b < recurso_max; b++){
				var flag_saturar = (flag_saturar_2 and b = mision.data.recurso)
				var flag_comida = (flag_comida_2 and b = rec_comida)
				var flag_desabastecer = (flag_desabastecer_2 and b = mision.data.recurso)
				var flag_bodega = (flag_bodega_2 and b = mision.data.recurso)
				var flag_electronicos = (flag_electronicos_2 and b = rec_electronicos)
				var precio_venta = precio_recurso(b, planeta, false)
				if empresa.recurso_venta_lugar[b] = planeta and precio_venta < empresa.recurso_venta_precio[b]
					empresa.recurso_venta_precio[b] = 0
				//Vender
				if precio_venta > empresa.recurso_venta_precio[b] or flag_comida or flag_saturar{
					empresa.recurso_venta_precio[b] = precio_venta
					empresa.recurso_venta_lugar[b] = planeta
					if not flag_bodega or flag_comida or flag_saturar
						while nave.recurso[b] > 0 and (precio_venta > empresa.recurso_compra_precio[b] or flag_comida or flag_saturar){
							comprar_recurso(b, -1, planeta, nave)
							precio_venta = precio_recurso(b, planeta, false)
							//Misión vender comida
							if flag_comida and planeta.recurso[b] >= 4{
								flag_comida = false
								array_remove(mision.data.destinos, planeta)
								if array_length(mision.data.destinos) = 0
									mision_cumplir(mision)
							}
							//Misión de saturar el mercado
							if flag_saturar and precio_recurso(b, planeta, false) <= mision.data.precio{
								flag_saturar = false
								nave.recursos_acumulados[b] = false
								mision_cumplir(mision)
							}
						}
				}
				var precio_compra = precio_recurso(b, planeta, true)
				if empresa.recurso_compra_lugar[b] = planeta and precio_compra > empresa.recurso_compra_precio[b]
					empresa.recurso_compra_precio[b] = infinity
				//Comprar
				if precio_compra < empresa.recurso_compra_precio[b] or flag_desabastecer or flag_bodega or flag_electronicos{
					empresa.recurso_compra_precio[b] = precio_compra
					empresa.recurso_compra_lugar[b] = planeta
					if not flag_saturar
						while planeta.recurso[b] >= 1 and empresa.dinero >= precio_compra and (precio_compra < empresa.recurso_venta_precio[b] or flag_bodega or flag_desabastecer or flag_electronicos){
							comprar_recurso(b, 1, planeta, nave)
							precio_compra = precio_recurso(b, planeta, true)
							//Misión desabastecer
							if flag_desabastecer and planeta.recurso[mision.data.recurso] <= 1{
								flag_desabastecer = false
								mision_cumplir(mision)
							}
							//Misión bodega
							if flag_bodega and nave.recurso[mision.data.recurso] >= mision.data.cantidad{
								flag_bodega = false
								mision_cumplir(mision)
							}
							//Misión comprar electrónicos
							if flag_electronicos{
								flag_electronicos = false
								array_remove(mision.data.destinos, planeta)
								if array_length(mision.data.destinos) = 0
									mision_cumplir(mision)
							}
						}
				}
			}
			//Tomar misiones
			var temp_reputacion = empresa.relacion_imperio[? planeta.imperio.index]
			if array_length(nave.misiones) = 0 and array_length(planeta.misiones) > 0 and temp_reputacion >= -0.5{
				input_data = irandom(array_length(planeta.misiones) - 1)
				var b = planeta.misiones[input_data]
				if tag_mision_ia[b] and temp_reputacion >= mision_reputacion[b] and dia - empresa.ultima_falla[b] > 1500
					mision_aceptar(b, planeta, empresa, nave)
			}
			nave_npc_viajar(nave, planeta)
		}
		//Misiones de espionaje
		for(var c = array_length(empresas) - 1; c >= 0; c--){
			empresa = empresas[c]
			for(var b = array_length(empresa.misiones_index[mis_espiar_empresas]) - 1; b >= 0; b--){
				var mision = empresa.misiones_index[mis_espiar_empresas, b]
				mision_on_especial[mis_espiar_empresas](mision, planeta, empresa, nave)
			}
			for(var b = array_length(empresa.misiones_index[mis_espiar_planeta]) - 1; b >= 0; b--){
				var mision = empresa.misiones_index[mis_espiar_planeta, b]
				mision_on_especial[mis_espiar_planeta](mision, planeta, empresa, nave)
			}
		}
	}
}