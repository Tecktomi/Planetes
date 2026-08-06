function gen_restriccion_texto(restricciones = array_create(0, control.null_planeta)){
	var output = "", cantidad = array_length(restricciones)
	if cantidad = 1
		output = "Sin pasar por"
	else if cantidad > 1
		output = "Sin pasar ni por"
	else return ""
	for(var a = 0; a < cantidad; a++){
		if a = 0
			output += $" {planeta_nombre(restricciones[a])}"
		else if a < cantidad - 1
			output += $", {planeta_nombre(restricciones[a])}"
		else
			output += $" ni {planeta_nombre(restricciones[a])}"
	}
	return output
}