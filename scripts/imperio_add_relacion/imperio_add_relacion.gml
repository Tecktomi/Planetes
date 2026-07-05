function imperio_add_relacion(cantidad, imperio_a = control.null_imperio, imperio_b = control.null_imperio){
	with control{
		var index_a = imperio_a.index, index_b = imperio_b.index
		if index_a = index_b or imperio_a.eliminado or imperio_b.eliminado
			exit
		imperio_a.relacion_imperio[? index_b] += real(cantidad)
		imperio_b.relacion_imperio[? index_a] += real(cantidad)
		if imperio_a.relacion_imperio[? index_b] <= -5{
			imperio_a.relacion_imperio[? index_b] = -2
			imperio_b.relacion_imperio[? index_a] = -2
			if irandom(1)
				return imperio_ceder_planeta(imperio_a, imperio_b, array_choose(imperio_b.planetas))
			else
				return imperio_ceder_planeta(imperio_b, imperio_a, array_choose(imperio_a.planetas))
		}
		else if imperio_a.relacion_imperio[? index_b] >= 5{
			imperio_a.relacion_imperio[? index_b] = 2
			imperio_b.relacion_imperio[? index_a] = 2
		}
		return false
	}
}