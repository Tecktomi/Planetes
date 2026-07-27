function relacion_add(empresa = control.jugador, imperio = control.null_imperio, motivo = 0, valor = 0){
	with control{
		valor = min(valor, abs(relacion_valor[motivo]) - empresa.relacion_imperio_motivo[motivo][? imperio.index])
		empresa.relacion_imperio_motivo[motivo][? imperio.index] += valor
		empresa.relacion_imperio[? imperio.index] += valor * sign(relacion_valor[motivo])
		imperio.relacion_empresa_motivo[motivo][? empresa.index] = empresa.relacion_imperio_motivo[motivo][? imperio.index]
		imperio.relacion_empresa[? empresa.index] = empresa.relacion_imperio[? imperio.index]
	}
}