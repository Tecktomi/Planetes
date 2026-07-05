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
				planeta.x = room_width / 2 + (cos(planeta.fase) + excentricidad) * planeta.radio
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
							mision.nombre = $"Quédate en {planeta_nombre(mision.data.destino)} {--mision.data.cantidad} días sin que nadie te vea"
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
							mision.nombre = $"Lleva 5 animales a una oficina comercial y déjalos ahí {--mision.data.cantidad} días"
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
					if estado = 0{
						temp_array = [0, 0, 1, 4]
						if arquetipo = 4 {repeat(estado_repeat) array_push(temp_array, 1)}
					}
					//Tensión
					else if estado = 1{
						temp_array = [0, 1, 2, 6]
						repeat(planeta.estado_repeat) array_push(temp_array, 2, 6)
						if arquetipo = 1 {repeat(estado_repeat) array_push(temp_array, 8)}
						else if arquetipo = 3 {repeat(estado_repeat) array_push(temp_array, 0, 6)}
						else if arquetipo = 4 {repeat(estado_repeat) array_push(temp_array, 2)}
					}
					//Guerra
					else if estado = 2{
						temp_array = [1, 2, 3, 7]
						repeat(planeta.estado_repeat) array_push(temp_array, 8)
						if arquetipo = 3 {repeat(estado_repeat) array_push(temp_array, 1)}
						else if arquetipo = 4 {repeat(estado_repeat) array_push(temp_array, 7)}
					}
					//Escasez
					else if estado = 3{
						temp_array = [0, 1, 6]
						repeat(planeta.estado_repeat) array_push(temp_array, 8)
						if arquetipo = 0 {repeat(estado_repeat) array_push(temp_array, 7)}
						else if arquetipo = 1 {repeat(estado_repeat) array_push(temp_array, 8)}
						else if arquetipo = 2 {repeat(estado_repeat) array_push(temp_array, 8)}
						else if arquetipo = 3 {repeat(estado_repeat) array_push(temp_array, 0)}
					}
					//Crecimiento
					else if estado = 4{
						temp_array = [0, 4, 5]
						if arquetipo = 0 {repeat(estado_repeat) array_push(temp_array, 5)}
						else if arquetipo = 2 {repeat(estado_repeat) array_push(temp_array, 6)}
					}
					//Burbuja
					else if estado = 5{
						temp_array = [3, 4, 6]
						if arquetipo = 0 {repeat(estado_repeat) array_push(temp_array, 4)}
					}
					//Protestas
					else if estado = 6{
						temp_array = [0, 2, 7, 8]
						if arquetipo = 2 {repeat(estado_repeat) array_push(temp_array, 0)}
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
					else if estado = 7{
						temp_array = [1, 6, 7]
						repeat(planeta.estado_repeat) array_push(temp_array, 8)
						if arquetipo = 0 {repeat(estado_repeat) array_push(temp_array, 3, 4)}
						else if arquetipo = 1 {repeat(estado_repeat) array_push(temp_array, 8)}
						else if arquetipo = 2 {repeat(estado_repeat) array_push(temp_array, 6)}
						else if arquetipo = 4 {repeat(estado_repeat) array_push(temp_array, 2)}
					}
					//Reformas
					else if estado = 8{
						temp_array = [0, 1, 4, 5, 6]
						if arquetipo = 1 {repeat(estado_repeat) array_push(temp_array, 0)}
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