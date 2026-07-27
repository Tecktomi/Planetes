function weighted_array_choose(array_elem = [], array_val = array_create(0, 0)){
	var len = array_length(array_val)
	if len = 0
		show_error("weighted_array_choose en arreglo vacío", true)
	if array_length(array_elem) != len
		show_error("weighted_array_choose con arreglos de distinto tamaño", true)
	var total = 0
	for(var a = 0; a < len; a++)
		total += array_val[a]
	var b = random(total)
	for(var a = 0; a < len; a++){
		b -= array_val[a]
		if b <= 0
			return array_elem[a]
	}
}