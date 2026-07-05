function weighted_choose(arreglo){
	var a = 0
	for(var b = array_length(arreglo) - 1; b >= 0; b--)
		a += arreglo[b]
	if a = 0
		show_error("Weighted_choose en un arreglo vacío", true)
	a = random(a)
	for(var b = array_length(arreglo) - 1; b >= 0; b--){
		a -= arreglo[b]
		if a <= 0
			return b
	}
}