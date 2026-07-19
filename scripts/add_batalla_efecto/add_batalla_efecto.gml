function add_batalla_efecto(_x = 0, _y = 0, _efecto = spr_icon, _step = 0){
	with control{
		var batalla_efecto = {
			x : _x,
			y : _y,
			efecto : _efecto,
			subsprite : 0,
			vel : sprite_get_number(_efecto) / _step,
			step : _step,
			pointer : array_create(1, 0)
		}
		array_disorder_push(batalla_efectos, batalla_efecto, 0)
		return batalla_efecto
	}
}