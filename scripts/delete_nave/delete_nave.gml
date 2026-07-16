function delete_nave(nave = control.null_nave){
	with control{
		array_disorder_remove(naves, nave, 0)
		array_disorder_remove(nave.empresa.naves, nave, 1)
		if array_length(nave.empresa.naves) = 0
			delete_empresa(nave.empresa)
		delete nave
	}
}