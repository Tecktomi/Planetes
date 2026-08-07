function load_game_buffer(buffer){
	if VERSION != buffer_read(buffer, buffer_u32)
		return false
	with control{
		clear_game()
		//Punteros
		map_planetas = ds_map_create()
		var len_p = buffer_read(buffer, buffer_u8)
		repeat(len_p){
			var planeta = add_planeta(buffer_read(buffer, buffer_bool))
			planeta.index = real(buffer_read(buffer, buffer_u8))
			ds_map_add(map_planetas, planeta.index, planeta)
		}
		map_imperios = ds_map_create()
		var len_i = buffer_read(buffer, buffer_u8)
		repeat(len_i){
			var imperio = add_imperio()
			imperio.index = real(buffer_read(buffer, buffer_u8))
			ds_map_add(map_imperios, imperio.index, imperio)
			imperio.arquetipo = real(buffer_read(buffer, buffer_u8))
		}
		map_empresas = ds_map_create()
		var len_e = buffer_read(buffer, buffer_u8)
		repeat(len_e){
			var empresa = add_empresa()
			empresa.index = real(buffer_read(buffer, buffer_u8))
			ds_map_add(map_empresas, empresa.index, empresa)
		}
		map_naves = ds_map_create()
		var len_n = buffer_read(buffer, buffer_u16)
		repeat(len_n){
			var empresa = map_empresas[? real(buffer_read(buffer, buffer_u8))]
			var modelo = real(buffer_read(buffer, buffer_u8))
			var armas = real(buffer_read(buffer, buffer_u8))
			var nave = add_nave(empresa, modelo, armas)
			nave.index = real(buffer_read(buffer, buffer_u16))
			ds_map_add(map_naves, nave.index, nave)
		}
		//Planetas
		for(var a = 0; a < len_p; a++){
			var planeta = planetas[a]
			planeta.radio = real(buffer_read(buffer, buffer_u16))
			planeta.anno = 10 / power(planeta.radio, 1.5)
			planeta.fase = real(buffer_read(buffer, buffer_f64))
			planeta.size = real(buffer_read(buffer, buffer_u8))
			planeta.nombre = string(buffer_read(buffer, buffer_string))
			var r = real(buffer_read(buffer, buffer_u8))
			var g = real(buffer_read(buffer, buffer_u8))
			var b = real(buffer_read(buffer, buffer_u8))
			planeta.color = make_color_rgb(r, g, b)
			var luna = real(buffer_read(buffer, buffer_u8))
			if luna = 0{
				planeta.luna = null_planeta
				array_push(planetas_terrestres_gigantes, planeta)
				planeta.x = RW2 + (cos(planeta.fase) + EXCENTRICIDAD) * planeta.radio
				planeta.y = RH2 + sin(planeta.fase) * planeta.radio * 0.9
				if not planeta.gigante{
					array_push(planetas_terrestres, planeta)
					array_push(planetas_internos, planeta)
				}
			}
			else{
				var planeta_madre = map_planetas[? luna]
				planeta.luna = planeta_madre
				array_push(planeta_madre.lunas, planeta)
				planeta.x = planeta_madre.x + cos(planeta.fase) * planeta.radio
				planeta.y = planeta_madre.y + sin(planeta.fase) * planeta.radio
				if not planeta_madre.gigante
					array_push(planetas_internos, planeta)
			}
			planeta.luna_bool = (luna > 0)
			if planeta.gigante
				array_push(planetas_gigantes, planeta)
			else
				array_push(planetas_no_gigantes, planeta)
			var c = real(buffer_read(buffer, buffer_u8))
			planeta.imperio = (c = 0 ? null_imperio : map_imperios[? c])
			planeta.arquetipo = planeta.imperio.arquetipo
			array_push(planetas_arquetipo[planeta.imperio.arquetipo], planeta)
			for(var b = 0; b < recurso_max; b++){
				planeta.recurso[b] = real(buffer_read(buffer, buffer_u16))
				planeta.recurso_precio[b] = real(buffer_read(buffer, buffer_f64))
				planeta.recurso_fabrica[b] = real(buffer_read(buffer, buffer_f64))
			}
			var len = real(buffer_read(buffer, buffer_u8))
			for(var b = 0; b < len; b++)
				planeta.misiones[b] = real(buffer_read(buffer, buffer_u8))
			planeta.estado = real(buffer_read(buffer, buffer_u8))
			planeta.estado_repeat = real(buffer_read(buffer, buffer_u8))
			planeta.infrastructura = real(buffer_read(buffer, buffer_u8))
			planeta.fabricas = real(buffer_read(buffer, buffer_u8))
			for(var b = 0; b < infrastructura_max; b++){
				c = real(buffer_read(buffer, buffer_u8))
				planeta.infrastructura_owner[b] = (c = 0 ? null_empresa : map_empresas[? c])
			}
			for(var b = 0; b < 3; b++)
				planeta.capacidad[b] = real(buffer_read(buffer, buffer_u8))
			planeta.tipo = real(buffer_read(buffer, buffer_u8))
		}
		//Imperios
		for(var a = 0; a < len_i; a++){
			var imperio = imperios[a]
			imperio.nombre = string(buffer_read(buffer, buffer_string))
			for(var b = 0; b < len_i; b++) if a != b{
				var c = buffer_read(buffer, buffer_u8)
				imperio.relacion_imperio[? c] = real(buffer_read(buffer, buffer_f64))
			}
			for(var b = 0; b < len_e; b++){
				var c = real(buffer_read(buffer, buffer_u8)), d = 0
				for(var e = 0; e < relacion_motivo_max; e++){
					var f = real(buffer_read(buffer, buffer_f64))
					imperio.relacion_empresa_motivo[e][? c] = f
					d += f
				}
				imperio.relacion_empresa[? c] = d
			}
		}
		//Empresas
		jugador = map_empresas[? real(buffer_read(buffer, buffer_u8))]
		for(var a = 0; a < len_e; a++){
			var empresa = empresas[a]
			empresa.nombre = string(buffer_read(buffer, buffer_string))
			empresa.dinero = real(buffer_read(buffer, buffer_f64))
			for(var b = 0; b < recurso_max; b++){
				empresa.recurso_compra_precio[b] = real(buffer_read(buffer, buffer_f64))
				empresa.recurso_compra_lugar[b] = map_planetas[? real(buffer_read(buffer, buffer_u8))]
				empresa.recurso_venta_precio[b] = real(buffer_read(buffer, buffer_f64))
				empresa.recurso_venta_lugar[b] = map_planetas[? real(buffer_read(buffer, buffer_u8))]
			}
			var len = real(buffer_read(buffer, buffer_u8))
			for(var b = 0; b < len; b++){
				var index = real(buffer_read(buffer, buffer_u8))
				var nombre = (empresa = jugador ? string(buffer_read(buffer, buffer_string)) : "")
				var planeta = map_planetas[? real(buffer_read(buffer, buffer_u8))]
				var mision = add_mision(index, planeta, empresa)
				mision.nombre = nombre
				mision.fecha = real(buffer_read(buffer, buffer_u16))
				mision.status = bool(buffer_read(buffer, buffer_bool))
				mision.paga = real(buffer_read(buffer, buffer_u16))
				mision_data_load[index](mision.data, buffer)
				for(var c = 0; c < 3; c++)
					mision.pointer[c] = real(buffer_read(buffer, buffer_u8))
				var len2 = real(buffer_read(buffer, buffer_u8))
				for(var c = 0; c < len2; c++)
					mision.restricciones[c] = map_planetas[? real(buffer_read(buffer, buffer_u8))]
				mision.nave_asignada = map_naves[? real(buffer_read(buffer, buffer_u8))]
			}
			empresa.riesgo = real(buffer_read(buffer, buffer_f64))
			for(var b = 0; b < len_p; b++) if bool(buffer_read(buffer, buffer_bool)){
				var planeta = map_planetas[? real(buffer_read(buffer, buffer_u8))]
				var oficina = add_oficina(planeta, empresa)
				for(var c = 0; c < recurso_max; c++){
					oficina.recurso[c] = real(buffer_read(buffer, buffer_u16))
					oficina.precio_compra[c] = real(buffer_read(buffer, buffer_u8))
					oficina.precio_venta[c] = real(buffer_read(buffer, buffer_u8))
				}
			}
			for(var b = 0; b < mision_max; b++)
				empresa.ultima_falla[b] = real(buffer_read(buffer, buffer_u64))
			len = real(buffer_read(buffer, buffer_u16))
			for(var b = 0; b < len; b++){
				var c = real(buffer_read(buffer, buffer_u8))
				var recurso = real(buffer_read(buffer, buffer_u8))
				empresa.fabricas[# c, recurso] = real(buffer_read(buffer, buffer_u8))
			}
			empresa.pirata = real(buffer_read(buffer, buffer_f64))
			empresa.imperio_favorito = map_imperios[? real(buffer_read(buffer, buffer_u8))]
		}
		//Naves
		for(var a = 0; a < len_n; a++){
			var nave = naves[a]
			nave.origen = map_planetas[? real(buffer_read(buffer, buffer_u8))]
			nave.destino = map_planetas[? real(buffer_read(buffer, buffer_u8))]
			for(var b = 0; b < 3; b++)
				nave.pointer[b] = real(buffer_read(buffer, buffer_u16))
			nave.viaje_bool = bool(buffer_read(buffer, buffer_u8))
			if nave.viaje_bool{
				var dis = real(buffer_read(buffer, buffer_u16))
				var xx = real(buffer_read(buffer, buffer_u16))
				var yy = real(buffer_read(buffer, buffer_u16))
				var origen_x = real(buffer_read(buffer, buffer_u16))
				var origen_y = real(buffer_read(buffer, buffer_u16))
				nave.viaje = {
					dis : dis,
					x : xx,
					y : yy,
					origen_x : origen_x,
					origen_y : origen_y
				}
				nave.viaje_pos = real(buffer_read(buffer, buffer_u16))
			}
			for(var b = 0; b < recurso_max; b++)
				nave.recurso[b] = real(buffer_read(buffer, buffer_u16))
			nave.hp = real(buffer_read(buffer, buffer_u16))
			nave.pirata_step = real(buffer_read(buffer, buffer_u16))
		}
		//Noticias
		var len = real(buffer_read(buffer, buffer_u16))
		for(var a = 0; a < len; a++){
			var fecha = real(buffer_read(buffer, buffer_u16))
			var titulo = string(buffer_read(buffer, buffer_string))
			var texto = string(buffer_read(buffer, buffer_string))
			var noticia = {
				fecha : fecha,
				titulo : titulo,
				texto : texto
			}
			array_push(noticias, noticia)
		}
		//Globales
		dia = real(buffer_read(buffer, buffer_u16))
		nave_select = map_naves[? real(buffer_read(buffer, buffer_u8))]
		for(var a = 0; a < recurso_max; a++)
			recurso_multiplicador[a] = real(buffer_read(buffer, buffer_f64))
		miedo_pirata = real(buffer_read(buffer, buffer_f64))
		len = real(buffer_read(buffer, buffer_u8))
		for(var a = 0; a < len; a++)
			last_path[a] = map_planetas[? real(buffer_read(buffer, buffer_u8))]
		last_path_index = real(buffer_read(buffer, buffer_u8))
	}
	return true
}