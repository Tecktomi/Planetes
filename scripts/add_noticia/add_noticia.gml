function add_noticia(titulo, texto){
	with control{
		var noticia = {
			fecha : dia,
			titulo : $"Día {dia}: {titulo}",
			texto : string(texto)
		}
		array_push(noticias, noticia)
		step_noticia = 300
		return noticia
	}
}