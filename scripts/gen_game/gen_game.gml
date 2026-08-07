function gen_game(){
	with control{
		imperios_max = 10
		var imperios_peso = array_create(imperios_max, 6)
		for(var a = 0; a < imperios_max; a++){
			var imperio = add_imperio()
			imperio.arquetipo = array_length(imperios) mod arquetipo_max
		}
		var colores_hielo = [ #273346, #246480, #3C4D78, #BEB8AF, #8090A0, #93959C, #757C87, #786881]
		var colores_silicio = [ #351C08, #5D432E, #612706, #51473C, #6B514A, #89674C, #89674C, #9E6D48, #B48762, #938884, #917B5E, #C8965B, #9C8760, #DCC8A5]
		var colores_metalico = [ #784A41, #533F51, #40272B, #8A4A41, #D06E61, #8C481C, #921909, #6F796B]
		var planetas_terrestres_sin_lunas = array_create(0, null_planeta)
		planeta_max = 13
		repeat(planeta_max){
			var planeta = add_planeta(), b = weighted_choose(imperios_peso)
			imperios_peso[b]--
			var imperio = imperios[b]
			planeta.imperio = imperio
			array_push(imperio.planetas, planeta)
			planeta.arquetipo = imperio.arquetipo
			array_push(planetas_arquetipo[planeta.arquetipo], planeta)
			if array_length(planetas_terrestres) > 5{
				planeta.luna = array_choose(planetas_terrestres_sin_lunas)
				planeta.luna_bool = true
				array_push(planeta.luna.lunas, planeta)
				if array_length(planeta.luna.lunas) = 2
					array_remove(planetas_terrestres_sin_lunas, planeta.luna)
			}
			if planeta.luna_bool{
				planeta.radio = 15 + 20 * array_length(planeta.luna.lunas)
				planeta.x = planeta.luna.x + cos(planeta.fase) * planeta.radio
				planeta.y = planeta.luna.y + sin(planeta.fase) * planeta.radio
				planeta.size = irandom_range(3, 6)
				planeta.tipo = weighted_choose([planeta.luna.radio / 70 - 1, 1, 2 - planeta.luna.radio / 320])
			}
			else{
				array_push(planetas_terrestres, planeta)
				array_push(planetas_terrestres_gigantes, planeta)
				array_push(planetas_terrestres_sin_lunas, planeta)
				do planeta.radio = random_range(70, 320)
				until check_orbit(,, planeta.radio)
				planeta.x = RW2 + (cos(planeta.fase) + EXCENTRICIDAD) * planeta.radio
				planeta.y = RH2 + sin(planeta.fase) * planeta.radio * 0.9
				planeta.size = irandom_range(8, 15)
				planeta.tipo = weighted_choose([planeta.radio / 70 - 1, 1, 2 - planeta.radio / 320])
			}
			planeta.anno = 10 / power(planeta.radio, 1.5)
			b = 0
			for(var a = 0; a < recurso_max; a++){
				planeta.recurso[a] = irandom(recurso_inicial[a] * arquetipo_recurso_frecuencia[planeta.arquetipo, a])
				planeta.recurso_precio[a] = random_range(0.9, 1.1)
				planeta.recurso_fabrica[a] = random(arquetipo_recurso_frecuencia[planeta.arquetipo, a] / 2)
				b += planeta.recurso_fabrica[a]
			}
			//Composición
			if planeta.tipo = 0{
				planeta.recurso_fabrica[rec_hidrocarburo]++
				planeta.color = array_choose(colores_hielo)
			}
			else if planeta.tipo = 1{
				planeta.recurso_fabrica[rec_comida]++
				planeta.color = array_choose(colores_silicio)
			}
			else if planeta.tipo = 2{
				planeta.recurso_fabrica[rec_metales]++
				planeta.color = array_choose(colores_metalico)
			}
			b = planeta.infrastructura / b
			for(var a = 0; a < recurso_max; a++)
				planeta.recurso_fabrica[a] *= b
			array_push(planetas_no_gigantes, planeta)
			array_push(planetas_internos, planeta)
			array_push(planeta.misiones, weighted_choose(arquetipo_mision_frecuencia[planeta.arquetipo]))
		}
		//Gigantes gaseosos
		planeta_total = planeta_max + 4
		repeat(4){
			var planeta = add_planeta(true)
			array_push(planetas_gigantes, planeta)
			array_push(planetas_terrestres_gigantes, planeta)
			planeta.radio = 500 + 250 * array_length(planetas_gigantes)
			planeta.x = RW2 + (cos(planeta.fase) + EXCENTRICIDAD) * planeta.radio
			planeta.y = RH2 + sin(planeta.fase) * planeta.radio * 0.9
			planeta.size = irandom_range(25, 40)
			planeta.tipo = 3
			planeta.color = make_color_hsv(random(255), 127, 127)
			planeta.anno = 10 / power(planeta.radio, 1.5)
			//Lunas de los gigantes
			var a = 4
			planeta_total += a
			repeat(a){
				var luna = add_planeta(), b = weighted_choose(imperios_peso)
				imperios_peso[b]--
				var imperio = imperios[b]
				luna.imperio = imperio
				array_push(imperio.planetas, luna)
				luna.arquetipo = imperio.arquetipo
				array_push(planetas_arquetipo[luna.arquetipo], luna)
				luna.luna = planeta
				luna.luna_bool = true
				luna.luna_externa = true
				array_push(planeta.lunas, luna)
				luna.radio = 30 + 25 * array_length(planeta.lunas)
				luna.x = planeta.x + cos(luna.fase) * luna.radio
				luna.y = planeta.y + sin(luna.fase) * luna.radio
				luna.size = irandom_range(3, 6)
				luna.tipo = weighted_choose([luna.radio / 750, 1, 1 - luna.radio / 1500])
				luna.anno = 10 / power(luna.radio, 1.5)
				b = 0
				for(var c = 0; c < recurso_max; c++){
					luna.recurso[c] = irandom(recurso_inicial[c] * arquetipo_recurso_frecuencia[luna.arquetipo, c])
					luna.recurso_precio[c] = random_range(0.9, 1.1)
					luna.recurso_fabrica[c] = random(arquetipo_recurso_frecuencia[luna.arquetipo, c] / 2)
					b += luna.recurso_fabrica[c]
				}
				//Composición
				if luna.tipo = 0{
					luna.recurso_fabrica[rec_hidrocarburo]++
					luna.color = array_choose(colores_hielo)
				}
				else if luna.tipo = 1{
					luna.recurso_fabrica[rec_comida]++
					luna.color = array_choose(colores_silicio)
				}
				else if luna.tipo = 2{
					luna.recurso_fabrica[rec_metales]++
					luna.color = array_choose(colores_metalico)
				}
				b = luna.infrastructura / b
				for(var c = 0; c < recurso_max; c++)
					luna.recurso_fabrica[c] *= b
				array_push(luna.misiones, weighted_choose(arquetipo_mision_frecuencia[luna.arquetipo]))
				array_push(planetas_no_gigantes, luna)
			}
		}
		repeat(7){
			var planeta = array_choose(planetas_no_gigantes)
			planeta.recurso_fabrica[rec_radioisotopos]++
		}
		for(var a = array_length(imperios) - 1; a >= 0; a--){
			var imperio = imperios[a]
			if array_length(imperio.planetas) = 0
				delete_imperio(imperio)
		}
		//Jugador
		jugador = add_empresa()
		jugador.dinero = 1000
		nave_select = add_nave(jugador)
		nave_select_bool = true
		nave_select.origen = array_choose(planetas_terrestres)
		last_path = array_create(5, null_planeta)
		last_path[0] = nave_select.origen
		last_path_index = 0
		//Empresas
		repeat(5){
			var empresa = add_empresa()
			repeat(3){
				var nave = add_nave(empresa, irandom(array_length(nave_nombre) - 1))
				nave.destino = planetas_no_gigantes[irandom(array_length(planetas_no_gigantes) - 1)]
				nave.viaje_bool = true
			}
			empresa.nombre = $"Empresa {array_length(empresas) - 1}"
			empresa.dinero = irandom_range(100, 150)
		}
	}
}