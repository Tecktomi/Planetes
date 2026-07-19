function nave_llegar_planeta(nave = control.null_nave){
	with control{
		var planeta = nave.destino, empresa = nave.empresa
		nave.viaje_bool = false
		nave.origen = planeta
		//Misiones
		for(var b = array_length(empresa.misiones) - 1; b >= 0; b--){
			var mision = empresa.misiones[b]
			if not mision.status{
				//Viajar
				if mision.index = mis_viajar{
					if mision.data.destino = planeta{
						if mision.data.process++ = 0{
							do mision.data.destino = array_choose(planetas_no_gigantes)
							until not (in(mision.data.destino, mision.contratista, planeta) or array_contains(mision.restricciones, mision.data.destino))
							mision.nombre = string(mision_texto[mision.index, 1], planeta_nombre(mision.data.destino))
							temp_viaje = calcular_viaje_light(planeta, mision.data.destino)
							mision.fecha += 3 * temp_viaje.dis
							mision.paga += 3 * mision.data.destino.luna_externa
						}
						else
							mision_cumplir(mision)
					}
				}
				//Explorar
				else if mision.index = mis_recoger_informacion{
					if array_contains(mision.data.destinos, planeta){
						array_remove(mision.data.destinos, planeta)
						var len = array_length(mision.data.destinos)
						if len = 2
							mision.nombre = string(mision_texto[mision.index, 1], planeta_nombre(mision.data.destinos[0]), planeta_nombre(mision.data.destinos[1]))
						else if len = 1
							mision.nombre = string(mision_texto[mision.index, 2], planeta_nombre(mision.data.destinos[0]))
						else
							mision_cumplir(mision)
					}
				}
				//Espiar
				else if mision.index = mis_espiar_empresas
					mision.nombre = string(mision_texto[mision.index, (mision.data.destino = planeta) ? 1 : 0], planeta_nombre(mision.data.destino), mision.data.cantidad)
				//Artefacto
				else if mision.index = mis_artefacto{
					if mision.data.destino = planeta{
						if empresa = jugador{
							add_noticia("Artefacto encontrado", "Artefacto encontrado")
							if tutorial = 12
								tutorial++
						}
						mision_cumplir(mision)
					}
				}
				//Viaje Express
				else if mision.index = mis_viaje_express{
					if nave.viaje_pos > mision.data.cantidad
						mision_fallar(mision, "Tu viaje ha sido demasiado largo")
					else if planeta = mision.data.destino
						mision_cumplir(mision)
				}
				//Piratería
				else if mision.index = mis_pirateria
					mision.nombre = string(mision_texto[mision.index, (mision.data.destino = planeta) ? 1 : 0], planeta_nombre(mision.data.destino))
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
			for(var b = array_length(empresa.misiones) - 1; b >= 0; b--){
				var mision = empresa.misiones[b]
				if not mision.status and mision.nave_asignada.origen = planeta and not mision.nave_asignada.viaje_bool and nave.empresa != empresa{
					if mision.index = mis_espiar_empresas and mision.data.destino = planeta{
						if not array_contains(mision.data.empresas, nave.empresa)
							array_push(mision.data.empresas, nave.empresa)
						mision.nombre = string(mision_texto[mision.index, 1], planeta_nombre(mision.data.destino), --mision.data.cantidad)
						if mision.data.cantidad <= 0{
							mision_cumplir(mision)
							if empresa = jugador
								pasar_dia_bool = false
							else
								nave_npc_viajar(mision.nave_asignada, planeta)
						}
					}
					if mision.index = mis_espiar_planeta and mision.data.destino = planeta{
						if empresa = jugador{
							mision_fallar(mision, "Alguien te ha visto")
							pasar_dia_bool = false
						}
						else{
							nave.destino = array_choose(planetas_no_gigantes)
							nave.viaje = calcular_viaje_light(planeta, nave.destino)
							nave.viaje_bool = true
						}
					}
				}
			}
		}
	}
}