function mision_aceptar(index, planeta = control.null_planeta, empresa = control.jugador, nave = control.nave_select){
	with control{
		var mision = add_mision(index, planeta, empresa)
		//Transportista
		if index = mis_viajar{
			var temp_array_planetas = array_create(0, null_planeta), a = weighted_choose(arquetipo_relacion_positiva[planeta.arquetipo])
			for(var c = 0; c < array_length(planetas_arquetipo[a]); c++)
				if planetas_arquetipo[a, c] != planeta
					array_push(temp_array_planetas, planetas_arquetipo[a, c])
			if array_length(temp_array_planetas) = 0{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			var destino = array_choose(temp_array_planetas)
			mision.data = {
				destino : destino,
				process : 0
			}
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 3 * temp_viaje.dis
			mision.paga += 3 * destino.luna_externa
			mision.nombre = $"Viajar a {planeta_nombre(destino)}"
		}
		//Compra
		else if index = mis_desabastecer{
			var temp_array_planetas = array_create(0, null_planeta)
			for(var c = 0; c < array_length(planetas_no_gigantes); c++){
				var temp_planeta = planetas_no_gigantes[c]
				if temp_planeta != planeta
					array_push(temp_array_planetas, temp_planeta)
			}
			var destino = array_choose(temp_array_planetas), b = irandom(recurso_max - 1), recurso = -1
			for(var a = 0; a < recurso_max; a++)
				if destino.recurso[(a + b) mod recurso_max] > 0
					recurso = (a + b) mod recurso_max
			if recurso = -1{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			mision.data = {
				destino : destino,
				recurso : recurso
			}
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 8 * temp_viaje.dis + 400
			mision.paga += 3 * destino.luna_externa
			mision.nombre = $"Compra todo el {recurso_nombre[recurso]} de {planeta_nombre(destino)}"
		}
		//Informacion
		else if index = mis_recoger_informacion{
			var temp_array_planetas = array_create(0, null_planeta)
			for(var c = 0; c < array_length(planetas_no_gigantes); c++){
				var temp_planeta = planetas_no_gigantes[c]
				if temp_planeta != planeta
					array_push(temp_array_planetas, temp_planeta)
			}
			var destinos = array_create(0, null_planeta)
			repeat(3){
				if array_length(temp_array_planetas) = 0{
					array_disorder_remove(empresa.misiones, mision, 0)
					return undefined
				}
				var c = irandom(array_length(temp_array_planetas) - 1)
				array_push(destinos, temp_array_planetas[c])
				array_delete(temp_array_planetas, c, 1)
			}
			mision.data = {
				destinos : destinos
			}
			var tiempo = 200
			for(var a = 0; a < 3; a++)
				tiempo += calcular_viaje_light(planeta, destinos[a]).dis
			mision.fecha = 4 * tiempo
			mision.paga += 3 * (destinos[0].luna_externa + destinos[1].luna_externa + destinos[2].luna_externa)
			mision.nombre = $"Visita {planeta_nombre(destinos[0])}, {planeta_nombre(destinos[1])} y {planeta_nombre(destinos[2])}"
		}
		//Saturar mercado
		else if index = mis_saturar_mercado{
			var temp_array_planetas = array_create(0, null_planeta), a = weighted_choose(arquetipo_relacion_negativa[planeta.arquetipo])
			for(var c = 0; c < array_length(planetas_arquetipo[a]); c++)
				if planetas_arquetipo[a, c] != planeta
					array_push(temp_array_planetas, planetas_arquetipo[a, c])
			if array_length(temp_array_planetas) = 0{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			var destino = array_choose(temp_array_planetas), b = irandom(recurso_max - 1), recurso = -1
			for(a = 0; a < recurso_max; a++)
				if destino.recurso[(a + b) mod recurso_max] < 10
					recurso = (a + b) mod recurso_max
			if recurso = -1{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			if empresa = jugador
				var precio = precio_recurso(recurso, destino, false, max(15, destino.recurso[recurso] + 5))
			else
				precio = precio_recurso(recurso, destino, false, max(10, destino.recurso[recurso] + 3))
			mision.data = {
				destino : destino,
				recurso : recurso,
				precio : precio
			}
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 10 * temp_viaje.dis + 500
			mision.paga += 3 * destino.luna_externa
			mision.nombre = $"Baja el precio de venta de {recurso_nombre[recurso]} en {planeta_nombre(destino)} a ${precio}"
			nave.recurso[recurso] += 5
		}
		//Acumular
		else if index = mis_llenar_bodega{
			var recurso = irandom(recurso_max - 1)
			if empresa = jugador
				var cantidad = max(round(50 / precio_recurso(recurso, planeta)), planeta.recurso[recurso] + 1)
			else
				cantidad = round(15 / precio_recurso(recurso, planeta))
			mision.data = {
				recurso : recurso,
				cantidad : cantidad
			}
			mision.fecha = dia + irandom_range(1600, 1800)
			mision.nombre = $"Acumula {cantidad} de {recurso_nombre[recurso]} en tu nave"
		}
		//Espiar
		else if index = mis_espiar_empresas{
			var temp_array_planetas = array_create(0, null_planeta), a = weighted_choose(arquetipo_relacion_negativa[planeta.arquetipo])
			for(var c = 0; c < array_length(planetas_arquetipo[a]); c++)
				if planetas_arquetipo[a, c] != planeta
					array_push(temp_array_planetas, planetas_arquetipo[a, c])
			if array_length(temp_array_planetas) = 0{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			var destino = array_choose(temp_array_planetas)
			var cantidad = irandom_range(3, 5)
			mision.data = {
				destino : destino,
				cantidad : cantidad,
				empresas : array_create(0, null_empresa)
			}
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 6 * temp_viaje.dis + 500
			mision.nombre = $"Viaja a {planeta_nombre(destino)} y espera a que {cantidad} naves pasen por ahí"
			mision.paga += cantidad + 3 * destino.luna_externa
		}
		//Investigar
		else if index = mis_espiar_planeta{
			var temp_array_planetas = array_create(0, null_planeta), a = weighted_choose(arquetipo_relacion_negativa[planeta.arquetipo])
			for(var c = 0; c < array_length(planetas_arquetipo[a]); c++)
				if planetas_arquetipo[a, c] != planeta
					array_push(temp_array_planetas, planetas_arquetipo[a, c])
			if array_length(temp_array_planetas) = 0{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			var destino = array_choose(temp_array_planetas)
			mision.data = {
				destino : destino,
				cantidad : irandom_range(300, 500)
			}
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 8 * temp_viaje.dis + 500
			mision.paga += 3 * destino.luna_externa
			mision.nombre = $"Viaja a {destino.nombre}, una vez ahí, quédate {mision.data.cantidad} días sin que nadie te vea"
		}
		//Obtener electrónicos
		else if index = mis_electronicos{
			var temp_array_planetas = array_create(0, null_planeta)
			for(var c = 0; c < array_length(planetas_no_gigantes); c++){
				var temp_planeta = planetas_no_gigantes[c]
				if temp_planeta != planeta and temp_planeta.recurso[rec_electronicos] >= 1
					array_push(temp_array_planetas, temp_planeta)
			}
			var destinos = array_create(0, null_planeta)
			repeat(3){
				if array_length(temp_array_planetas) = 0{
					array_disorder_remove(empresa.misiones, mision, 0)
					return undefined
				}
				var c = irandom(array_length(temp_array_planetas) - 1)
				array_push(destinos, temp_array_planetas[c])
				array_delete(temp_array_planetas, c, 1)
			}
			mision.data = {
				destinos : destinos
			}
			var tiempo = 500
			for(var a = 0; a < 3; a++)
				tiempo += calcular_viaje_light(planeta, destinos[a]).dis
			mision.fecha = 4 * tiempo
			mision.paga += 3 * (destinos[0].luna_externa + destinos[1].luna_externa + destinos[2].luna_externa)
			mision.nombre = $"Tráenos electrónicos de {planeta_nombre(destinos[0])}, {planeta_nombre(destinos[1])} y {planeta_nombre(destinos[2])}"
		}
		//Salvar fauna
		else if index = mis_salvar_fauna{
			var flag = false
			for(var c = 0; c < array_length(planetas_no_gigantes); c++)
				if empresa.oficina_bool[c]
					flag = true
			mision.data = {
				cantidad : irandom_range(800, 1000)
			}
			mision.fecha = dia + irandom_range(1600, 1800)
			mision.nombre = $"Lleva 5 animales a una oficina comercial y déjalos ahí {mision.data.cantidad} días"
			mision.paga += min(5, nave.recurso[rec_fauna]) * precio_recurso(rec_fauna, planeta)
			if not flag{
				empresa.dinero += 15
				mision.paga -= 15
			}
			nave.recurso[rec_fauna] = max(5, nave.recurso[rec_fauna])
		}
		//Entregar comida
		else if index = mis_comida{
			var temp_array_planetas = array_create(0, null_planeta)
			for(var c = 0; c < array_length(planetas_no_gigantes); c++){
				var temp_planeta = planetas_no_gigantes[c]
				if temp_planeta != planeta and (temp_planeta.recurso[rec_comida] < 4 or temp_planeta.estado = ESCASEZ)
					array_push(temp_array_planetas, temp_planeta)
			}
			var destinos = array_create(0, null_planeta)
			repeat(3){
				if array_length(temp_array_planetas) = 0{
					array_disorder_remove(empresa.misiones, mision, 0)
					return undefined
				}
				var c = irandom(array_length(temp_array_planetas) - 1)
				array_push(destinos, temp_array_planetas[c])
				array_delete(temp_array_planetas, c, 1)
			}
			mision.data = {
				destinos : destinos
			}
			var tiempo = 500
			for(var a = 0; a < 3; a++)
				tiempo += calcular_viaje_light(planeta, destinos[a]).dis
			mision.fecha = 4 * tiempo
			mision.paga += 3 * (destinos[0].luna_externa + destinos[1].luna_externa + destinos[2].luna_externa)
			mision.nombre = $"Lleva al menos 4 de {recurso_nombre[rec_comida]} a {planeta_nombre(destinos[0])}, {planeta_nombre(destinos[1])} y {planeta_nombre(destinos[2])}"
		}
		//Fallar misión
		if index = mis_fallar{
			var temp_array_planetas = array_create(0, null_planeta), a = weighted_choose(arquetipo_relacion_negativa[planeta.arquetipo])
			for(var c = 0; c < array_length(planetas_arquetipo[a]); c++)
				if planetas_arquetipo[a, c] != planeta and array_length(planetas_arquetipo[a, c].misiones) > 0
					array_push(temp_array_planetas, planetas_arquetipo[a, c])
			if array_length(temp_array_planetas) = 0{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			var destino = array_choose(temp_array_planetas)
			mision.data = {
				destino : destino
			}
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 10 * temp_viaje.dis + 1000
			mision.nombre = $"Falla en una misión del planeta {planeta_nombre(destino)}"
			mision.paga += 3 * destino.luna_externa
		}
		//Armas encubiertas
		else if index = mis_armas{
			var temp_array_planetas = array_create(0, null_planeta), a = weighted_choose(arquetipo_relacion_negativa[planeta.arquetipo])
			for(var c = 0; c < array_length(planetas_arquetipo[a]); c++)
				if planetas_arquetipo[a, c] != planeta and in(planeta.estado, 1, 6, 7)
					array_push(temp_array_planetas, planetas_arquetipo[a, c])
			if array_length(temp_array_planetas) = 0{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			var destino = array_choose(temp_array_planetas)
			mision.data = {
				destino : destino,
				cantidad : 5
			}
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 6 * temp_viaje.dis + 500
			mision.nombre = $"Lleva 5 {recurso_nombre[rec_armas]} a una oficina comercial en {planeta_nombre(destino)} y déjalas ahí, sin pasar por el mercado"
			mision.paga += min(5, nave.recurso[rec_armas]) * precio_recurso(rec_armas, planeta) + 3 * destino.luna_externa
			if not empresa.oficina_bool[destino.index]{
				empresa.dinero += 15
				mision.paga -= 15
			}
			nave.recurso[rec_fauna] = max(5, nave.recurso[rec_armas])
		}
		//Artefacto
		else if index = mis_artefacto{
			var temp_array_planetas = array_create(0, null_planeta)
			array_copy(temp_array_planetas, 0, planetas_gigantes, 0, array_length(planetas_gigantes))
			if planeta.luna_externa
				array_remove(temp_array_planetas, planeta.luna)
			var destino = array_choose(temp_array_planetas)
			mision.nombre = $"Busca el artefacto perdido entre las lunas de {destino.nombre}"
			var temp_viaje = calcular_viaje_light(planeta, destino)
			mision.fecha = dia + 6 * temp_viaje.dis + 500
			destino = array_choose(destino.lunas)
			mision.data = {
				destino : destino
			}
		}
		//Viaje express
		else if index = mis_viaje_express{
			var temp_array_planetas = array_create(0, null_planeta), destino = null_planeta, cantidad
			for(var c = 0; c < array_length(planetas_no_gigantes); c++){
				var temp_planeta = planetas_no_gigantes[c]
				if temp_planeta != planeta
					array_push(temp_array_planetas, temp_planeta)
			}
			temp_array_planetas = array_shuffle(temp_array_planetas)
			while array_length(temp_array_planetas) > 0{
				var temp_planeta = array_pop(temp_array_planetas)
				var r1 = planeta.luna_bool ? planeta.luna.radio - planeta.radio : planeta.radio
				var r2 = temp_planeta.luna_bool ? temp_planeta.luna.radio - temp_planeta.radio : temp_planeta.radio
				var viaje = calcular_viaje_light(planeta, temp_planeta)
				if abs(r1 - r2) < 3 * viaje.dis{
					cantidad = floor(abs(r1 - r2) * 1.1)
					destino = temp_planeta
					break
				}
			}
			if destino = null_planeta{
				array_disorder_remove(empresa.misiones, mision, 0)
				return undefined
			}
			mision.data = {
				destino : destino,
				cantidad : cantidad
			}
			mision.nombre = $"Viaja a {planeta_nombre(destino)} cuando el viaje a este dure menos de {cantidad} días"
			mision.fecha = dia + 300 + 8 * cantidad
			mision.paga += 3 * destino.luna_externa
		}
		//Restricciones
		var cantidad = irandom(clamp(ceil(empresa.relacion_imperio[? planeta.imperio.index]), 0, 5))
		if cantidad = 1
			mision.restricciones_texto += "\nSin pasar por"
		else if cantidad > 1
			mision.restricciones_texto += "\nSin pasar ni por"
		for(var c = 0; c < cantidad; c++){
			var destino = null_planeta
			if tag_mision_multiple[index]{
				var temp_array_planetas = array_create(0, null_planeta)
				for(var d = 0; d < array_length(planetas_no_gigantes); d++){
					var temp_planeta = planetas_no_gigantes[d]
					if not (planeta = temp_planeta or array_contains(mision.data.destinos, temp_planeta) or array_contains(mision.restricciones, temp_planeta))
						array_push(temp_array_planetas, temp_planeta)
				}
				if array_length(temp_array_planetas) = 0{
					cantidad = c
					break
				}
				destino = array_choose(temp_array_planetas)
			}
			else if not in(index, mis_llenar_bodega, mis_salvar_fauna){
				var temp_array_planetas = array_create(0, null_planeta)
				for(var d = 0; d < array_length(planetas_no_gigantes); d++){
					var temp_planeta = planetas_no_gigantes[d]
					if not (planeta = temp_planeta or mision.data.destino = temp_planeta or array_contains(mision.restricciones, temp_planeta))
						array_push(temp_array_planetas, temp_planeta)
				}
				if array_length(temp_array_planetas) = 0{
					cantidad = c
					break
				}
				destino = array_choose(temp_array_planetas)
			}
			else if index = mis_artefacto{
				var temp_array_planetas = array_create(0, null_planeta)
				for(var d = 0; d < array_length(planetas_no_gigantes); d++){
					var temp_planeta = planetas_no_gigantes[d]
					if not (planeta = temp_planeta or mision.data.destino = temp_planeta or array_contains(mision.restricciones, temp_planeta) or temp_planeta.luna = planeta.luna)
						array_push(temp_array_planetas, temp_planeta)
				}
				if array_length(temp_array_planetas) = 0{
					cantidad = c
					break
				}
				destino = array_choose(temp_array_planetas)
			}
			else{
				var temp_array_planetas = array_create(0, null_planeta)
				for(var d = 0; d < array_length(planetas_no_gigantes); d++){
					var temp_planeta = planetas_no_gigantes[d]
					if not (planeta = temp_planeta or array_contains(mision.restricciones, temp_planeta))
						array_push(temp_array_planetas, temp_planeta)
				}
				if array_length(temp_array_planetas) = 0{
					cantidad = c
					break
				}
				destino = array_choose(temp_array_planetas)
			}
			array_push(mision.restricciones, destino)
			if c = 0
				mision.restricciones_texto += $" {planeta_nombre(destino)}"
			else if c < cantidad - 1
				mision.restricciones_texto += $", {planeta_nombre(destino)}"
			else
				mision.restricciones_texto += $" ni {planeta_nombre(destino)}"
			if c = cantidad - 1
				mision.restricciones_texto += "  "
		}
		mision.paga += cantidad
		if empresa != jugador
			mision.fecha += 300
		planeta.misiones[input_data] = planeta.misiones[array_length(planeta.misiones) - 1]
		array_pop(planeta.misiones)
		mision.nave_asignada = nave
		array_disorder_push(nave.misiones, mision, 1)
		return mision
	}
}