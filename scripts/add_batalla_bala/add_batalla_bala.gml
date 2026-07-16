function add_batalla_bala(_x = 0, _y = 0, _hmove = 0, _vmove = 0, _vel = 0, _home = control.null_batalla_nave){
	var new_bala = {
		x : _x,
		y : _y,
		hmove : _hmove,
		vmove : _vmove,
		vel : _vel,
		home : _home,
		pointer : array_create(1, 0)
	}
	array_disorder_push(control.batalla_balas, new_bala, 0)
	return new_bala
}