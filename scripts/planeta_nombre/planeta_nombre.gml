function planeta_nombre(planeta = control.null_planeta){
	var temp_text = planeta.nombre
	if planeta.luna_externa
		temp_text += $", luna de {planeta.luna.nombre}"
	return temp_text
}