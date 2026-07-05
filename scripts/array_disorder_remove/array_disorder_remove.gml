function array_disorder_remove(arreglo, elemento, index){
	var len = array_length(arreglo), ultimo_elemento = arreglo[len - 1], pos = elemento.pointer[index]
	ultimo_elemento.pointer[index] = pos
	arreglo[pos] = ultimo_elemento
	array_pop(arreglo)
}