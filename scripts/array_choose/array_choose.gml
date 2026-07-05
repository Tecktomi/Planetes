function array_choose(arreglo){
	var len = array_length(arreglo)
	if len = -1
		show_error("Eligiendo de un arreglo vacío", true)
	return arreglo[irandom(len - 1)]
}