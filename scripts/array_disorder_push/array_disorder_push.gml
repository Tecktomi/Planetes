function array_disorder_push(arreglo, elemento, index){
	elemento.pointer[index] = array_length(arreglo)
	array_push(arreglo, elemento)
}