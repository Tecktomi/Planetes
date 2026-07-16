function add_batalla_nave(_nave = control.null_nave, _x = 0, _y = 0, _dir = 0, _vel = 0, _hp = 0){
	with control{
		var new_nave = {
			nave : _nave,
			x : _x,
			y : _y,
			dir : _dir,
			vel : _vel,
			hp : _hp,
			step : 0,
			diff : 0
		}
		return new_nave
	}
}