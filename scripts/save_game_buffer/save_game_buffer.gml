function save_game_buffer(){
	var buffer = buffer_create(8192, buffer_grow, 1)
	buffer_write(buffer, buffer_u32, VERSION)
	with control{
		//PLANETAS
		var len_p = array_length(planetas)
		buffer_write(buffer, buffer_u8, len_p)
		for(var a = 0; a < len_p; a++){
			var planeta = planetas[a]
			buffer_write(buffer, buffer_u8, real(planeta.index))
			buffer_write(buffer, buffer_u16, real(planeta.radio))
			buffer_write(buffer, buffer_f64, real(planeta.fase))
			buffer_write(buffer, buffer_u8, real(planeta.size))
			buffer_write(buffer, buffer_string, string(planeta.nombre))
			buffer_write(buffer, buffer_u8, real(planeta.luna.index))
			for(var b = 0; b < recurso_max; b++){
				buffer_write(buffer, buffer_u8, real(planeta.recurso[b]))
				buffer_write(buffer, buffer_f64, real(planeta.recurso_precio[b]))
				buffer_write(buffer, buffer_f64, real(planeta.recurso_fabrica[b]))
			}
			var len = array_length(planeta.misiones)
			buffer_write(buffer, buffer_u8, len)
			for(var b = 0; b < len; b++)
				buffer_write(buffer, buffer_u8, planeta.misiones[b])
			buffer_write(buffer, buffer_u8, real(planeta.estado))
			buffer_write(buffer, buffer_u8, real(planeta.estado_repeat))
			buffer_write(buffer, buffer_u8, real(planeta.infrastructura))
			buffer_write(buffer, buffer_u8, real(planeta.fabricas))
			for(var b = 0; b < infrastructura_max; b++)
				buffer_write(buffer, buffer_u8, real(planeta.infrastructura_owner[b].pointer[0]))
			for(var b = 0; b < 3; b++)
				buffer_write(buffer, buffer_u8, real(planeta.capacidad[b]))
			buffer_write(buffer, buffer_bool, bool(planeta.gigante))
			buffer_write(buffer, buffer_u8, real(planeta.imperio.pointer[0]))
			buffer_write(buffer, buffer_u8, real(planeta.tipo))
		}
		//Imperios
		var len_i = array_length(imperios), len_e = array_length(empresas)
		buffer_write(buffer, buffer_u8, len_i)
		for(var a = 0; a < len_i; a++){
			var imperio = imperios[a]
			buffer_write(buffer, buffer_u8, real(imperio.index))
			buffer_write(buffer, buffer_string, string(imperio.nombre))
			buffer_write(buffer, buffer_u8, real(imperio.arquetipo))
			for(var b = 0; b < len_i; b++) if a != b{
				buffer_write(buffer, buffer_u8, real(imperios[b].index))
				buffer_write(buffer, buffer_f64, real(imperio.relacion_imperio[? imperios[b].index]))
			}
			for(var b = 0; b < len_e; b++){
				buffer_write(buffer, buffer_u8, real(empresas[b].index))
				for(var c = 0; c < relacion_motivo_max; c++)
					buffer_write(buffer, buffer_f64, real(imperio.relacion_empresa_motivo[c][? empresas[b].index]))
			}
			buffer_write(buffer, buffer_u8, a)
		}
		//Empresas
		buffer_write(buffer, buffer_u8, len_e)
		for(var a = 0; a < len_e; a++){
			var empresa = empresas[a]
			buffer_write(buffer, buffer_u8, real(empresa.index))
			buffer_write(buffer, buffer_string, string(empresa.nombre))
			buffer_write(buffer, buffer_f64, real(empresa.dinero))
			for(var b = 0; b < recurso_max; b++){
				buffer_write(buffer, buffer_f64, real(empresa.recurso_compra_precio[b]))
				buffer_write(buffer, buffer_u8, real(empresa.recurso_compra_lugar[b].index))
				buffer_write(buffer, buffer_f64, real(empresa.recurso_venta_precio[b]))
				buffer_write(buffer, buffer_u8, real(empresa.recurso_venta_lugar[b].index))
			}
			#region Misiones
				var len = array_length(empresa.misiones)
				buffer_write(buffer, buffer_u8, len)
				for(var b = 0; b < len; b++){
					var mision = empresa.misiones[b]
					buffer_write(buffer, buffer_u8, real(mision.index))
					if empresa = jugador
						buffer_write(buffer, buffer_string, string(mision.nombre))
					buffer_write(buffer, buffer_u8, real(mision.contratista.index))
					//mision.contratado = empresa
					buffer_write(buffer, buffer_u16, real(mision.fecha))
					buffer_write(buffer, buffer_bool, bool(mision.status))
					buffer_write(buffer, buffer_u16, real(mision.paga))
					//DATA
					mision_data_func[mision.index](mision.data, buffer)
					for(var c = 0; c < 3; c++)
						buffer_write(buffer, buffer_u8, real(mision.pointer[c]))
					var len2 = array_length(mision.restricciones)
					buffer_write(buffer, buffer_u8, len2)
					for(var c = 0; c < len2; c++)
						buffer_write(buffer, buffer_u8, real(mision.restricciones[c].index))
					buffer_write(buffer, buffer_u16, real(mision.nave_asignada.pointer[0]))
				}
			#endregion
			buffer_write(buffer, buffer_f64, real(empresa.riesgo))
			#region Oficinas
				for(var b = 0; b < len_p; b++){
					var oficina = empresa.oficina[b]
					if oficina != null_oficina{
						buffer_write(buffer, buffer_u8, real(oficina.planeta.index))
						for(var c = 0; c < recurso_max; c++){
							buffer_write(buffer, buffer_u8, real(oficina.recurso[c]))
							buffer_write(buffer, buffer_u8, real(oficina.precio_compra[c]))
							buffer_write(buffer, buffer_u8, real(oficina.precio_venta[c]))
						}
					}
				}
			#endregion
			for(var b = 0; b < mision_max; b++)
				buffer_write(buffer, buffer_u64, real(empresa.ultima_falla[b]))
			var seek = buffer_tell(buffer), e = 0
			buffer_write(buffer, buffer_u16, 0)//holder
			for(var b = 0; b < len_p; b++)
				for(var c = 0; c < recurso_max; c++){
					var d = real(empresa.fabricas[# b, c])
					if d > 0{
						buffer_write(buffer, buffer_u8, b)
						buffer_write(buffer, buffer_u8, c)
						buffer_write(buffer, buffer_u8, d)
						e++
					}
				}
			var seek_end = buffer_tell(buffer)
			buffer_seek(buffer, buffer_seek_start, seek)
			buffer_write(buffer, buffer_u16, e)
			buffer_seek(buffer, buffer_seek_start, seek_end)
			buffer_write(buffer, buffer_f64, real(empresa.pirata))
			buffer_write(buffer, buffer_u8, real(empresa.imperio_favorito.index))
			buffer_write(buffer, buffer_u8, a)
		}
		//Naves
		var len_n = array_length(naves)
		buffer_write(buffer, buffer_u16, len_n)
		for(var a = 0; a < len_n; a++){
			var nave = naves[a]
			buffer_write(buffer, buffer_u8, real(nave.origen.index))
			buffer_write(buffer, buffer_u8, real(nave.destino.index))
			for(var b = 0; b < 3; b++)
				buffer_write(buffer, buffer_u16, real(nave.pointer[b]))
			buffer_write(buffer, buffer_u8, real(nave.empresa.pointer[0]))
			buffer_write(buffer, buffer_bool, bool(nave.viaje_bool))
			if nave.viaje_bool{
				var viaje = nave.viaje
				buffer_write(buffer, buffer_u16, real(viaje.dis))
				buffer_write(buffer, buffer_u16, real(viaje.x))
				buffer_write(buffer, buffer_u16, real(viaje.y))
				buffer_write(buffer, buffer_u16, real(viaje.origen_x))
				buffer_write(buffer, buffer_u16, real(viaje.origen_y))
				buffer_write(buffer, buffer_u16, real(nave.viaje_pos))
			}
			for(var b = 0; b < recurso_max; b++)
				buffer_write(buffer, buffer_u8, real(nave.recurso[b]))
			buffer_write(buffer, buffer_u8, real(nave.modelo))
			buffer_write(buffer, buffer_u8, real(nave.hp))
			buffer_write(buffer, buffer_u8, real(nave.armas))
			buffer_write(buffer, buffer_u16, real(nave.pirata_step))
		}
		//Noticias
		var len = array_length(noticias)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var noticia = noticias[a]
			buffer_write(buffer, buffer_u16, real(noticia.fecha))
			buffer_write(buffer, buffer_string, string(noticia.titulo))
			buffer_write(buffer, buffer_string, string(noticia.texto))
		}
	}
	return buffer
}