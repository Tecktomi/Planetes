function check_orbit(luna_bool = false, luna = null_planeta, radio = 0, gigante = false){
	if luna_bool{
		for(var a = array_length(luna.lunas) - 2; a >= 0; a--){
			var planeta = luna.lunas[a]
			if abs(planeta.radio - radio) < 5
				return false
		}
	}
	else{
		if gigante{
			for(var a = array_length(planetas_gigantes) - 2; a >= 0; a--){
				var planeta = planetas_gigantes[a]
				if abs(planeta.radio - radio) < 100
					return false
			}
		}
		else{
			for(var a = array_length(planetas_terrestres) - 2; a >= 0; a--){
				var planeta = planetas_terrestres[a]
				if abs(planeta.radio - radio) < 25
					return false
			}
		}
	}
	return true
}