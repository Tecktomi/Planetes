function add_planeta(gigante = false){
	with control{
		var planeta = {
			index : counter_planeta++,
			x : 0,
			y : 0,
			radio : 0,
			fase : random(360),
			anno : 0,
			size : 0,
			nombre : gen_nombre(),
			color : c_black,
			luna_bool : false,
			luna : null_planeta,
			lunas : array_create(0, null_planeta),
			recurso : array_create(recurso_max, 0),
			recurso_precio : array_create(recurso_max, 0),
			recurso_fabrica : array_create(recurso_max, 0),
			misiones : array_create(0, 0),
			arquetipo : 0,
			estado : 0,
			estado_repeat : 0,
			infrastructura : 4,
			fabricas : 4,
			infrastructura_bool : array_create(array_length(infrastructura_nombre), false),
			infrastructura_owner : array_create(array_length(infrastructura_nombre), null_empresa),
			capacidad: [3, 3, 3],
			gigante : gigante,
			luna_externa : false,
			tipo : 0
		}
		array_push(planetas, planeta)
		return planeta
	}
}