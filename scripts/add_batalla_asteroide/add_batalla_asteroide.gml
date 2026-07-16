function add_batalla_asteroide(_x = 0, _y = 0, _hmove = 0, _vmove = 0){
	with control{
		var new_asteroide = {
			x : _x,
			y : _y,
			hmove : _hmove,
			vmove : _vmove,
			rot : random_range(-1, 1),
			angle : random(360),
			tipo : irandom(4),
			pointer : array_create(1, 0)
		}
		array_disorder_push(batalla_asteroides, new_asteroide, 0)
		return new_asteroide
	}
}