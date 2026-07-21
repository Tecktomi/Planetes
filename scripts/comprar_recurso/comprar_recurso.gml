function comprar_recurso(recurso, cantidad, planeta = control.null_planeta, nave = control.null_nave){
	with control{
		nave.empresa.dinero -= cantidad * precio_recurso(recurso, planeta, cantidad > 0)
		planeta.recurso[recurso] -= cantidad
		nave.recurso[recurso] += cantidad
		nave.recurso_total += cantidad
	}
}