function precio_recurso(recurso, planeta = control.null_planeta, compra = true, cantidad = -1){
	if compra
		var mul = 1.1
	else
		mul = 0.9
	if cantidad = -1
		cantidad = planeta.recurso[recurso]
	return mul * control.recurso_precio[recurso] / (10 + cantidad) * planeta.recurso_precio[recurso] * recurso_multiplicador[recurso] / sqrt(1 + planeta.recurso_fabrica[recurso]) 
}