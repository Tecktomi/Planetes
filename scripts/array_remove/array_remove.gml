function array_remove(arreglo, elemento){
	var a = array_get_index(arreglo, elemento)
	if a = -1
		show_error($"Intentando obtener {string_struct(elemento)} desde {string_struct(arreglo)}", true)
	array_delete(arreglo, a, 1)
}