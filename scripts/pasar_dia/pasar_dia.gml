function pasar_dia(){
	with control{
		dia++
		viaje_planeta = null_planeta
		for(var a = array_length(planetas) - 1; a >= 0; a--){
			var planeta = planetas[a]
			planeta.fase += planeta.anno
			if planeta.luna_bool{
				planeta.x = planeta.luna.x + cos(planeta.fase) * planeta.radio
				planeta.y = planeta.luna.y + sin(planeta.fase) * planeta.radio
			}
			else{
				planeta.x = room_width / 2 + (cos(planeta.fase) + EXCENTRICIDAD) * planeta.radio
				planeta.y = room_height / 2 + sin(planeta.fase) * planeta.radio * 0.9
			}
		}
		for(var a = array_length(naves) - 1; a >= 0; a--){
			var nave = naves[a], empresa = nave.empresa
			//Viajando
			if nave.viaje_bool{
				var temp_viaje = nave.viaje
				//Llega a destino
				if ++nave.viaje_pos >= temp_viaje.dis
					nave_llegar_planeta(nave)
			}
			else{
				for(var b = array_length(empresa.misiones) - 1; b >= 0; b--){
					var mision = empresa.misiones[b]
					if not mision.status and tag_mision_espiar[mision.index] and nave.origen = mision.data.destino{
						mision.fecha++
						if mision.index = mis_espiar_planeta{
							mision.nombre = string(mision_texto[mision.index, 1], planeta_nombre(mision.data.destino), --mision.data.cantidad)
							if mision.data.cantidad <= 0{
								mision_cumplir(mision)
								if empresa = jugador
									pasar_dia_bool = false
								else
									nave_npc_viajar(mision.nave_asignada, nave.origen)
							}
						}
					}
				}
			}
		}
		for(var a = array_length(empresas) - 1; a >= 0; a--){
			var empresa = empresas[a]
			for(var b = array_length(empresa.misiones) - 1; b >= 0; b--){
				var mision = empresa.misiones[b]
				if dia >= mision.fecha
					mision_fallar(mision, "Se te ha acabado el plazo")
				if mision.index = mis_salvar_fauna{
					for(var c = array_length(planetas_no_gigantes) - 1; c >= 0; c--)
						if empresa.oficina_bool[c] and empresa.oficina[c].recurso[rec_fauna] >= 5{
							mision.fecha++
							mision.nombre = string(mision_texto[mision.index, 1], --mision.data.cantidad)
							if mision.data.cantidad <= 0
								mision_cumplir(mision)
							break
						}
				}
			}
		}
		//Eventos anuales
		if (dia mod 300) = 0{
			for(var a = array_length(empresas) - 1; a >= 0; a--){
				var empresa = empresas[a], temp_text = ""
				for(var b = 0; b < recurso_max; b++){
					empresa.recurso_venta_precio[b] *= empresa.riesgo
					empresa.recurso_compra_precio[b] /= empresa.riesgo
				}
				for(var b = 0; b < planeta_max; b++){
					var planeta = planetas_no_gigantes[b], imperio = planeta.imperio
					empresa.relacion_imperio[? imperio.index] = (empresa.relacion_imperio[? imperio.index] * 9 + empresa.relacion_imperio_piso[? imperio.index]) / 10
					if empresa.relacion_imperio[? imperio.index] < -(4 - in(planeta.estado, 2, 3, 6, 7)) and empresa.oficina_bool[b]{
						empresa.oficina_bool[b] = false
						var oficina = empresa.oficina[b]
						for(var c = 0; c < recurso_max; c++){
							planeta.recurso[c] += oficina.recurso[c]
							ds_grid_set(empresa.fabricas, b, c, 0)
						}
						empresa.oficina[b] = null_oficina
						if empresa = jugador
							add_noticia("Expropiación", $"{planeta_nombre(planeta)} ha decidido expropiar tu oficina comercial debido a lo mala de las relaciones")
					}
					//Oficinas
					if empresa.oficina_bool[b]{
						var oficina = empresa.oficina[b], temp_dinero = empresa.dinero
						for(var c = 0; c < recurso_max; c++){
							var precio_compra = precio_recurso(c, planeta)
							while planeta.recurso[c] >= 1 and empresa.dinero >= precio_compra and precio_compra <= oficina.precio_compra[c]{
								planeta.recurso[c]--
								oficina.recurso[c]++
								empresa.dinero -= precio_compra
								precio_compra = precio_recurso(c, planeta)
							}
							var precio_venta = precio_recurso(c, planeta, false)
							while oficina.recurso[c] > 0 and precio_venta >= oficina.precio_venta[c]{
								planeta.recurso[c]++
								oficina.recurso[c]--
								empresa.dinero += precio_venta
								precio_venta = precio_recurso(c, planeta, false)
							}
							empresa.dinero -= empresa.fabricas[# b, c] * recurso_fabrica_mantenimiento[c]
						}
						for(var c = array_length(infrastructura_nombre) - 1; c >= 0; c--)
							if planeta.infrastructura_bool[c] and planeta.infrastructura_owner[c] = empresa
								empresa.dinero -= infrastructura_mantenimiento[c]
						if empresa.dinero != temp_dinero
							temp_text += $"{planeta_nombre(planeta)}: {empresa.dinero - temp_dinero > 0 ? "+" : ""}${empresa.dinero - temp_dinero}\n"
					}
				}
				if temp_text != ""
					add_noticia("Resultados oficinas", temp_text)
			}
			for(var a = 0; a < recurso_max; a++)
				recurso_multiplicador[a] = clamp(recurso_multiplicador[a] * random_range(0.95, 1.05), 0.9, 1.1)
			for(var a = array_length(planetas_no_gigantes) - 1; a >= 0; a--){
				var planeta = planetas_no_gigantes[a]
				for(var b = 0; b < recurso_max; b++){
					planeta.recurso_precio[b] = clamp(planeta.recurso_precio[b] * random_range(0.95, 1.05), 0.9, 1.1)
					var consumo = planeta.recurso[b] * (1 - arquetipo_recurso_consumo[planeta.arquetipo, b]) * recurso_estado[b, planeta.estado]
					if b = rec_radioisotopos and planeta.infrastructura_bool[infra_planta_nuclear]
						consumo += 0.5
					if b = rec_hidrocarburo and planeta.infrastructura_bool[infra_central_electrica]
						consumo += 0.5
					planeta.recurso[b] -= consumo
					planeta.recurso[b] += planeta.recurso_fabrica[b] * recurso_estado[b, planeta.estado]
				}
				for(var c = array_length(empresas) - 1; c >= 0; c--){
					var empresa = empresas[c]
					if empresa.oficina_bool[a]{
						var oficina = empresa.oficina[a]
						for(var b = 0; b < recurso_max; b++)
							if empresa.fabricas[# a, b] > 0{
								var eficiencia = min(1, planeta.infrastructura / planeta.fabricas)
								for(var d = array_length(recurso_fabrica_consumo[b]) - 1; d >= 0; d--)
									eficiencia = min(eficiencia, oficina.recurso[recurso_fabrica_consumo[b, d]] / empresa.fabricas[# a, b])
								if eficiencia > 0{
									for(var d = array_length(recurso_fabrica_consumo[b]) - 1; d >= 0; d--)
										oficina.recurso[recurso_fabrica_consumo[b, d]] -= empresa.fabricas[# a, b] * eficiencia
									oficina.recurso[b] += empresa.fabricas[# a, b] * eficiencia
								}
							}
					}
				}
				//Misiones
				if irandom(1){
					if irandom(array_length(planeta.misiones)) = 0
						array_push(planeta.misiones, weighted_choose(arquetipo_mision_frecuencia[planeta.arquetipo]))
					if irandom(1){
						var len = array_length(planeta.misiones), c = irandom(len - 1)
						planeta.misiones[c] = planeta.misiones[len - 1]
						array_pop(planeta.misiones)
					}
				}
				//Estado político
				var b = planeta.estado
				if random(1) < 0.3{
					var estado = planeta.estado, temp_array = array_create(0, 0), arquetipo = planeta.arquetipo, estado_repeat = floor(planeta.estado_repeat / 3)
					//Estable
					if estado = ESTABLE{
						temp_array = [ESTABLE, ESTABLE, TENSION, CRECIMIENTO]
						if arquetipo = MILITAR {repeat(estado_repeat) array_push(temp_array, TENSION)}
					}
					//Tensión
					else if estado = TENSION{
						temp_array = [ESTABLE, TENSION, GUERRA, PROTESTAS]
						repeat(planeta.estado_repeat) array_push(temp_array, GUERRA, PROTESTAS)
						if arquetipo = TECNOCRATA {repeat(estado_repeat) array_push(temp_array, REFORMAS)}
						else if arquetipo = DIPLOMATICO {repeat(estado_repeat) array_push(temp_array, TENSION, PROTESTAS)}
						else if arquetipo = MILITAR {repeat(estado_repeat) array_push(temp_array, GUERRA)}
					}
					//Guerra
					else if estado = GUERRA{
						temp_array = [TENSION, GUERRA, ESCASEZ, DICTADURA]
						repeat(planeta.estado_repeat) array_push(temp_array, REFORMAS)
						if arquetipo = DIPLOMATICO {repeat(estado_repeat) array_push(temp_array, TENSION)}
						else if arquetipo = MILITAR {repeat(estado_repeat) array_push(temp_array, DICTADURA)}
					}
					//Escasez
					else if estado = ESCASEZ{
						temp_array = [ESTABLE, TENSION, PROTESTAS]
						repeat(planeta.estado_repeat) array_push(temp_array, REFORMAS)
						if arquetipo = MERCANTIL {repeat(estado_repeat) array_push(temp_array, DICTADURA)}
						else if in(arquetipo, TECNOCRATA, ECOLOGISTA) {repeat(estado_repeat) array_push(temp_array, REFORMAS)}
						else if arquetipo = DIPLOMATICO {repeat(estado_repeat) array_push(temp_array, ESTABLE)}
					}
					//Crecimiento
					else if estado = CRECIMIENTO{
						temp_array = [ESTABLE, CRECIMIENTO, BURBUJA]
						if arquetipo = MERCANTIL {repeat(estado_repeat) array_push(temp_array, CRECIMIENTO)}
						else if arquetipo = ECOLOGISTA {repeat(estado_repeat) array_push(temp_array, BURBUJA)}
					}
					//Burbuja
					else if estado = BURBUJA{
						temp_array = [ESCASEZ, CRECIMIENTO, PROTESTAS]
						if arquetipo = MERCANTIL {repeat(estado_repeat) array_push(temp_array, ESCASEZ)}
					}
					//Protestas
					else if estado = PROTESTAS{
						temp_array = [ESTABLE, GUERRA, PROTESTAS, DICTADURA]
						if arquetipo = ECOLOGISTA {repeat(estado_repeat) array_push(temp_array, ESTABLE)}
						//Independencia
						if random(1) > (9 + array_length(imperios)) / (9 + array_length(planeta.imperio)) / (1 + 2 * (arquetipo != planeta.imperio.arquetipo)){
							var imperio = add_imperio(), prev_imperio = planeta.imperio
							imperio.arquetipo = planeta.arquetipo
							imperio_ceder_planeta(imperio, prev_imperio, planeta)
							imperio_add_relacion(-3, prev_imperio, imperio)
							for(var c = array_length(imperios) - 2; c >= 0; c--){
								var temp_imperio = imperios[c]
								if temp_imperio.index != prev_imperio.index{
									var d = temp_imperio.relacion_imperio[? prev_imperio.index]
									if d < -2
										imperio_add_relacion(1, temp_imperio, imperio)
									else if d > 2
										imperio_add_relacion(-1, temp_imperio, imperio)
								}
							}
							add_noticia("Independencia", $"El planeta {planeta_nombre(planeta)} ha declarado su independencia del imperio {prev_imperio.nombre}")
							show_debug_message($"Día {dia}: Independencia de {imperio.nombre} sobre {prev_imperio.nombre}")
						}
					}
					//Dictadura
					else if estado = DICTADURA{
						temp_array = [TENSION, PROTESTAS, DICTADURA]
						repeat(planeta.estado_repeat) array_push(temp_array, REFORMAS)
						if arquetipo = MERCANTIL {repeat(estado_repeat) array_push(temp_array, ESCASEZ, CRECIMIENTO)}
						else if arquetipo = TECNOCRATA {repeat(estado_repeat) array_push(temp_array, REFORMAS)}
						else if arquetipo = ECOLOGISTA {repeat(estado_repeat) array_push(temp_array, PROTESTAS)}
						else if arquetipo = MILITAR {repeat(estado_repeat) array_push(temp_array, GUERRA)}
					}
					//Reformas
					else if estado = REFORMAS{
						temp_array = [ESTABLE, TENSION, CRECIMIENTO, BURBUJA, PROTESTAS]
						if arquetipo = TECNOCRATA {repeat(estado_repeat) array_push(temp_array, ESTABLE)}
					}
					planeta.estado = array_choose(temp_array)
				}
				if b = planeta.estado
					planeta.estado_repeat++
				else
					planeta.estado_repeat = 0
			}
			//Relacion entre imperios
			for(var a = array_length(imperios) - 1; a >= 0; a--){
				var imperio = imperios[a]
				for(var b = array_length(imperio.planetas) - 1; b >= 0; b--){
					var planeta = imperio.planetas[b]
					if in(planeta.estado, 2, 7)
						imperio_add_relacion(-1, imperio, array_choose(imperios))
					else if in(planeta.estado, 4, 8)
						imperio_add_relacion(1, imperio, array_choose(imperios))
				}
				var imperio_b = array_choose(imperios)
				if imperio.index != imperio_b.index{
					var c = imperio.relacion_imperio[? imperio_b.index]
					if c < -2{
						for(var b = array_length(imperios) - 1; b >= 0; b--)
							if b != a and imperios[b].index != imperio_b.index
								if imperio_b.relacion_imperio[? imperios[b].index] < -2
									imperio_add_relacion(0.5, imperio, imperios[b])
								else if imperio_b.relacion_imperio[? imperios[b].index] > 2
									imperio_add_relacion(-0.5, imperio, imperios[b])
					}
					else if c > 2{
						for(var b = array_length(imperios) - 1; b >= 0; b--)
							if b != a and imperios[b].index != imperio_b.index
								if imperio_b.relacion_imperio[? imperios[b].index] < -2
									imperio_add_relacion(-0.5, imperio, imperios[b])
								else if imperio_b.relacion_imperio[? imperios[b].index] > 2
									imperio_add_relacion(0.5, imperio, imperios[b])
					}
				}
				imperio_b = array_choose(imperios)
				if imperio.index != imperio_b.index
					imperio_add_relacion((arquetipo_relacion_positiva[imperio.arquetipo, imperio_b.arquetipo] - 2) / 2, imperio, imperio_b)
				imperio_b = array_choose(imperios)
				if imperio.index != imperio_b.index
					if array_length(imperio.planetas) * 1.5 < array_length(imperio_b.planetas)
						imperio_add_relacion(-0.5, imperio, imperio_b)
				imperio_add_relacion(irandom_range(-1, 1), imperio, array_choose(imperios))
			}
			if array_length(imperios_eliminados) > 0{
				for(var a = array_length(imperios_eliminados) - 1; a >= 0; a--){
					show_debug_message($"Día {dia}: Se ha eliminado el imperio {imperios_eliminados[a].nombre}")
					delete_imperio(imperios_eliminados[a])
				}
				imperios_eliminados = array_create(0, null_imperio)
			}
		}
	}
}