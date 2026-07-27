function delete_nave(nave = control.null_nave){
	with control{
		if not nave.alive
			exit
		nave.alive = false
		array_disorder_remove(naves, nave, 0)
		array_disorder_remove(nave.empresa.naves, nave, 1)
		if nave.pirata_step > 0
			array_disorder_remove(naves_piratas, nave, 2)
		if array_length(nave.empresa.naves) = 0
			delete_empresa(nave.empresa)
		delete nave
	}
}