randomize()
draw_set_font(ft_letra)
cursor = cr_default
//Definiciones
#region Macros
	#macro DIS_PLANET_NAME 10_000
	#macro DIS_PLANET_CLIC 255
	#macro ZOOM_MAX 5
	#macro EXCENTRICIDAD sqrt(0.19)
	#macro IA_INTENTOS_VIAJES 10
	#macro RW2 room_width / 2
	#macro RH2 room_height / 2
#endregion
#region Estados
	estado_nombre = ["Estable", "Tensión", "Guerra", "Escasez", "Crecimiento", "Burbuja", "Protestas", "Dictadura", "Reformas"]
	estado_color = [c_gray, make_color_rgb(127, 63, 63), make_color_rgb(127, 0, 0), make_color_rgb(127, 127, 63), make_color_rgb(63, 255, 63), make_color_rgb(63, 255, 255), make_color_rgb(191, 63, 127), make_color_rgb(63, 0, 63), make_color_rgb(255, 191, 31)]
	estado_max = array_length(estado_nombre)
	#macro ESTABLE 0
	#macro TENSION 1
	#macro GUERRA 2
	#macro ESCASEZ 3
	#macro CRECIMIENTO 4
	#macro BURBUJA 5
	#macro PROTESTAS 6
	#macro DICTADURA 7
	#macro REFORMAS 8
#endregion
#region Recursos
	recurso_nombre = array_create(0, "")
	recurso_precio = array_create(0, 0)
	recurso_inicial = array_create(0, 0)
	recurso_estado = array_create(0, array_create(0, 0))
	recurso_fabrica_precio = array_create(0, 0)
	recurso_fabrica_consumo = array_create(0, array_create(0, 0))
	recurso_fabrica_mantenimiento = array_create(0, 0)
	recurso_fabrica_capacidad = array_create(0, array_create(0, 0))
	function def_recurso(nombre, precio = 50, inicial = 20, estado = array_create(estado_max, 0), fabrica_precio = 0, fabrica_mantenimiento = 0, fabrica_consumo = array_create(0, 0), fabrica_capacidad = [0, 0, 0]){
		array_push(recurso_nombre, string(nombre))
		array_push(recurso_precio, precio)
		array_push(recurso_inicial, inicial)
		array_push(recurso_estado, estado)
		array_push(recurso_fabrica_precio, fabrica_precio)
		array_push(recurso_fabrica_consumo, fabrica_consumo)
		array_push(recurso_fabrica_mantenimiento, fabrica_mantenimiento)
		array_push(recurso_fabrica_capacidad, fabrica_capacidad)
		return array_length(recurso_nombre) - 1
	}
	rec_comida = def_recurso("Comida", 30, 8,				[1.0, 1.1, 1.2, 0.8, 1.2, 0.9, 0.9, 0.8, 1.0], 30, 1, [],			[0, 3, 0])
	rec_hidrocarburo = def_recurso("Hidrocarburos", 40, 8,	[1.0, 1.0, 0.8, 0.7, 1.2, 1.3, 0.8, 1.3, 0.8], 35, 1.5, [],			[1, 1, 2])
	rec_metales = def_recurso("Metales", 50, 8,				[1.0, 1.0, 1.2, 0.8, 1.2, 0.9, 0.8, 1.3, 1.2], 45, 1.5, [],			[1, 2, 1])
	rec_plastico = def_recurso("Plástico", 50, 6,			[1.0, 0.8, 0.6, 0.6, 1.4, 1.5, 0.8, 1.0, 1.2], 60, 1, [1],			[2, 0, 3])
	rec_electronicos = def_recurso("Electrónicos", 80, 6,	[1.0, 0.8, 0.5, 0.4, 1.2, 1.4, 0.8, 0.8, 1.2], 100, 2, [2, 3],		[3, 1, 1])
	rec_armas = def_recurso("Armas", 150, 4,				[1.0, 1.6, 2.0, 0.5, 0.5, 0.5, 0.8, 1.5, 0.6], 110, 2, [1, 2, 2],	[2, 1, 3])
	rec_fauna = def_recurso("Fauna exótica", 120, 4,		[1.0, 0.5, 0.2, 0.3, 1.2, 1.5, 0.6, 1.5, 1.2], 90, 2, [0, 0],		[1, 3, 0])
	rec_farmacos = def_recurso("Fármacos", 80, 4,			[1.0, 1.2, 1.3, 0.5, 1.2, 1.3, 0.8, 0.5, 1.0], 120, 2, [0],			[2, 0, 2])
	rec_radioisotopos = def_recurso("Radioisótopos", 100, 3,[1.0, 1.2, 1.3, 0.6, 1.3, 1.4, 0.6, 1.3, 0.6], 120, 3, [],			[2, 2, 2])
	recurso_max = array_length(recurso_nombre)
#endregion
#region Arquetipos
	arquetipo_nombre = ["Mercantil", "Tecnócrata", "Ecologistas", "Diplomático", "Militar"]
	#macro MERCANTIL 0
	#macro TECNOCRATA 1
	#macro ECOLOGISTA 2
	#macro DIPLOMATICO 3
	#macro MILITAR 4
	arquetipo_max = array_length(arquetipo_nombre)
	arquetipo_recurso_frecuencia = [
		[2, 2, 1, 2, 3, 2, 2, 2, 2],
		[1, 2, 3, 2, 3, 2, 1, 1, 3],
		[3, 1, 2, 1, 1, 1, 3, 3, 1],
		[2, 3, 2, 3, 1, 1, 2, 2, 1],
		[2, 2, 2, 1, 1, 3, 1, 2, 3]]
	arquetipo_recurso_consumo = [
		[0.90, 0.90, 0.95, 0.85, 0.85, 0.95, 0.90, 0.90, 0.85],
		[0.95, 0.85, 0.85, 0.90, 0.85, 0.95, 0.95, 0.80, 0.95],
		[0.85, 0.95, 0.90, 0.95, 0.90, 0.90, 0.80, 0.85, 0.85],
		[0.90, 0.90, 0.90, 0.90, 0.90, 0.95, 0.90, 0.95, 0.85],
		[0.90, 0.90, 0.85, 0.95, 0.95, 0.80, 0.95, 0.95, 0.90]]
	arquetipo_exito = [
		"La operación se completó con resultados aceptables. Los márgenes fueron los esperados.",
		"Los datos obtenidos son coherentes y útiles. El procedimiento fue un éxito.",
		"La situación quedó bajo control. Has ayudado a restaurar el equilibrio.",
		"La misión se resolvió sin incidentes. Las relaciones permanecen estables.",
		"Nos has sido útil. Siempre es bueno resultarle útil al imperio."]
	arquetipo_fallo = [
		"Los números no cierran. Esta vez el mercado no jugó a nuestro favor.",
		"La información es incompleta o inconsistente. El experimento no produjo resultados válidos.",
		"La intervención fue innecesaria o tardía. El equilibrio se vio comprometido.",
		"El asunto no se manejó con el cuidado necesario. Las consecuencias no nos favorecen.",
		"Un error. Ten por seguro de que ha quedado registrado."]
	//From [a -> b] (1 : bien, 2 : neutral, 3 : mal)
	arquetipo_relacion_negativa = [
		[3, 2, 1, 2, 2],
		[2, 1, 1, 2, 3],
		[1, 1, 2, 3, 1],
		[3, 2, 2, 3, 1],
		[2, 3, 1, 2, 1]]
	arquetipo_relacion_positiva = array_create(arquetipo_max)
	for(var a = 0; a < arquetipo_max; a++){
		arquetipo_relacion_positiva[a] = array_create(arquetipo_max, 0)
		arquetipo_exito[a] = text_wrap(arquetipo_exito[a], 400)
		arquetipo_fallo[a] = text_wrap(arquetipo_fallo[a], 400)
		for(var b = 0; b < arquetipo_max; b++)
			array_set(arquetipo_relacion_positiva[a], b, 4 - arquetipo_relacion_negativa[a, b])
	}
	arquetipo_pirateria = [2, 1, 1, 2, 2]
	#region Frases de Arquetipos
	arquetipo_saludo = [[
		"Es un placer recibir a alguien con tu reputación. Espero que podamos hacer buenos tratos.",
		"Bienvenido a nuestro planeta. Nuestros mercados están siempre abiertos a nuevas visitas.",
		"Hola tú. Tu infamia te precede, espero que vengas con intenciones de reivindicación."
		],[
		"Alguien como tú siempre es bienvenido a nuestro mundo, alguien que parece comprender la correcta forma de pensar.",
		"Saludos visitante, bienvenido a este santuario de conocimiento al que llamamos hogar.",
		"No tenemos registros muy positivos sobre ti, espero que hayas venido a generarlos."
		],[
		"Un amigo! Siempre son bienvenidos quienes caminan en equilibrio como tú.",
		"Bienvenido a nuestro mundo. Nos alegra recibir todo tipo de visitas.",
		"Espero que tu visita sea breve."
		],[
		"",
		"Bienvenido a nuestro mundo. Nos alegra recibir todo tipo de visitas.",
		"Tu llegada genera inquietud. La estabilidad de nuestras relaciones no está garantizada."
		],[
		"Bienvenido, aliado. Has demostrado ser una fuerza confiable en momentos críticos.",
		"Nave identificada. Mantente dentro de los protocolos durante tu permanencia.",
		"Intruso detectado. No pongas a prueba nuestra paciencia ni nuestra capacidad de respuesta."
		]]
	arquetipo_dialogo = [[
		"Los mercados están en movimiento y el dinero circula con bastante libertad. Si tienes negocios en mente, este es un buen momento para hablarlos.",
		"Puede que notes cierta inquietud en el ambiente, ya sabes cómo son estas cosas cuando el mercado se recalienta. Nada fuera de control… todavía.",
		"No te mentiré: el comercio atraviesa tiempos difíciles y cada acuerdo se negocia con cautela. Aun así, siempre hay margen para quien sabe dónde mirar."
		],[
		"Nuestros sistemas funcionan dentro de parámetros óptimos y los indicadores son alentadores. Estamos listos para optimizar cualquier operación que propongas.",
		"Algunas variables se están desviando de lo previsto y los modelos requieren ajustes constantes. Agradeceremos directrices claras antes de proceder.",
		"La situación es inestable y muchos sistemas operan de forma degradada. Actuamos según protocolos de contingencia hasta recibir nuevas órdenes."
		],[
		"El planeta se encuentra en un momento de equilibrio, y eso nos permite planificar con calma. Esperamos que tus decisiones respeten este delicado balance.",
		"Quizás percibas cierta preocupación entre nuestra gente; el entorno está bajo presión y cada acción cuenta. Procederemos con cuidado.",
		"La situación ambiental es crítica y las prioridades han cambiado. Antes de avanzar, necesitamos saber qué rumbo deseas tomar."
		],[
		"Las relaciones se mantienen estables y el clima político es favorable. Estamos abiertos a discutir cualquier iniciativa que traigas.",
		"El ambiente es delicado y las palabras pesan más de lo habitual. Te escuchamos, con la esperanza de evitar decisiones precipitadas.",
		"El diálogo se ha deteriorado y las tensiones dominan la escena. Aun así, tu presencia abre una oportunidad para redefinir el rumbo."
		],[
		"La situación está bajo control y las fuerzas permanecen disciplinadas. Esperamos tus órdenes para proceder.",
		"Las tropas están en alerta y cualquier movimiento puede cambiar el equilibrio. Será mejor actuar con decisión.",
		"El planeta se encuentra en estado de movilización y los recursos están comprometidos. Dinos qué deseas."
		]]
	#endregion
	#region Filosofía
	arquetipo_filosofia = [[
		]]
	#endregion
#endregion
#region Misiones
	mision_nombre = array_create(0, "")
	mision_paga = array_create(0, 0)
	mision_reputacion = array_create(0, 0)
	mision_penalizacion = array_create(0, 0)
	mision_recompensa = array_create(0, 0)
	function def_mision(nombre, paga = 0, rep_min = 0, rep_fallo = 0, rep_exito = 0){
		array_push(mision_nombre, string(nombre))
		array_push(mision_paga, paga)
		array_push(mision_reputacion, rep_min)
		array_push(mision_penalizacion, rep_fallo)
		array_push(mision_recompensa, rep_exito)
		return array_length(mision_nombre) - 1
	}
	mis_viajar = def_mision("Viajar", 5, -1, 1, 0.5)
	mis_desabastecer = def_mision("Desabastecer", 20, 0, 1, 1)
	mis_recoger_informacion = def_mision("Recoger información", 15, -1, 1, 1)
	mis_saturar_mercado = def_mision("Saturar mercado", 10, 0, 3, 2)
	mis_llenar_bodega = def_mision("Llenar bodega", 15, 0, 1, 0.5)
	mis_espiar_empresas = def_mision("Espiar empresas", 10, 1, 1, 1.5)
	mis_espiar_planeta = def_mision("Investigar encubierto", 20, 1, 2, 2)
	mis_electronicos = def_mision("Conseguir electrónicos", 25, 0, 3, 2)
	mis_salvar_fauna = def_mision("Salvar fauna salvaje", 10, 0, 3, 2)
	mis_comida = def_mision("Entregar comida", 15, 0, 3, 2)
	mis_fallar = def_mision("Fallar misión", 20, 1, 1, 2)
	mis_armas = def_mision("Economía de guerra", 20, 0, 3, 2)
	mis_artefacto = def_mision("Encontrar artefacto", 15, 0, 1, 1)
	mis_viaje_express = def_mision("Viaje express", 10, -1, 2, 1)
	mis_pirateria = def_mision("Piratería", 20, 4, 2, 2)
	mision_max = array_length(mision_nombre)
	arquetipo_mision_frecuencia = [
		[3, 3, 2, 3, 2, 1, 2, 0, 0, 0, 2, 0, 3, 1, 2],
		[3, 1, 2, 0, 2, 3, 2, 3, 0, 0, 1, 0, 1, 2, 1],
		[2, 2, 2, 0, 3, 2, 1, 0, 3, 0, 1, 0, 2, 3, 1],
		[4, 2, 2, 0, 1, 2, 3, 0, 0, 3, 0, 0, 2, 2, 0],
		[2, 3, 2, 0, 1, 2, 3, 0, 0, 0, 2, 3, 2, 1, 3]]
	mision_texto = [
		["Viajar a {0}", "Ahora viaja a {0}"],
		["Compra todo el {0} de {1}"],
		["Visita {0}, {1} y {2}", "Visita {0} y {1}", "Visita {0}"],
		["Baja el precio de venta de {0} en {1} a ${2}"],
		["Acumula {0} de {1} en tu nave"],
		["Viaja a {0} y espera a que {1} naves pasen por ahí", "Quédate en {0} y espera a que {1} naves pasen por ahí"],
		["Viaja a {0}, una vez ahí, quédate {1} días sin que nadie te vea", "Quédate en {0} {1} días sin que nadie te vea"],
		["Tráenos electrónicos de {0}, {1} y {2}", "Tráenos electrónicos de {0} y {1}", "Tráenos electrónicos de {0}"],
		["Lleva 5 animales a una oficina comercial y déjalos ahí {0} días", "Deja los animales en la oficina comercial por {0} días"],
		["Lleva al menos 4 de comida a {0}, {1} y {2}", "Lleva al menos 4 de comida a {0} y {1}", "Lleva al menos 4 de comida a {0}"],
		["Falla en una misión del planeta {0}"],
		["Lleva {0} armas a una oficina comercial en {1} y déjalas ahí, sin pasar por el mercado","Lleva {0} armas más a la oficina comercial en {1} y déjalas ahí, sin pasar por el mercado"],
		["Busca el artefacto perdido entre las lunas de {0}"],
		["Viaja a {0} cuando el viaje a este dure menos de {1} días"],
		["Viaja a {0}, una vez ahí, asalta a la primera nave que llegue", "Quédate en {0} y asalta a la primera nave que llegue"]
	]
	#region tag_mision_multiple
		tag_mision_multiple = array_create(mision_max, false)
		tag_mision_multiple[mis_recoger_informacion] = true
		tag_mision_multiple[mis_electronicos] = true
		tag_mision_multiple[mis_comida] = true
	#endregion
	#region tag_mision_planeta
		tag_mision_planeta = array_create(mision_max, false)
		tag_mision_planeta[mis_viajar] = true
		tag_mision_planeta[mis_desabastecer] = true
		tag_mision_planeta[mis_saturar_mercado] = true
		tag_mision_planeta[mis_espiar_empresas] = true
		tag_mision_planeta[mis_espiar_planeta] = true
		tag_mision_planeta[mis_fallar] = true
		tag_mision_planeta[mis_armas] = true
		tag_mision_planeta[mis_viaje_express] = true
		tag_mision_planeta[mis_pirateria] = true
	#endregion
	#region tag_mision_espiar
		tag_mision_espiar = array_create(mision_max, false)
		tag_mision_espiar[mis_espiar_empresas] = true
		tag_mision_espiar[mis_espiar_planeta] = true
	#endregion
	#region tag_mision_ia
		tag_mision_ia = array_create(mision_max, true)
		tag_mision_ia[mis_armas] = false
		tag_mision_ia[mis_salvar_fauna] = false
		tag_mision_ia[mis_fallar] = false
		tag_mision_ia[mis_viaje_express] = false
		tag_mision_ia[mis_pirateria] = false
	#endregion
#endregion
#region Descripciones de misiones
	mision_descripcion = [[
		"Toda ruta es una oportunidad. Lleva la carga donde mejor rinda y vuelve con beneficios claros.",
		"Un mercado saturado es un mercado perdido. Compra todo antes de que alguien más lo haga.",
		"Los precios no se explican solos. Visita a nuestros vecinos y trae datos confiables.",
		"Cuando hay demasiado producto, los márgenes desaparecen. Asegúrate de que eso ocurra allí.",
		"Un almacén lleno es capital inmóvil. Llénalo, sí, pero solo mientras tenga sentido.",
		"Algunas empresas juegan sucio. Averigua si están alterando el mercado más de la cuenta.",
		"La producción es la clave para el comercio. Averigua qué producen nuestros vecinos.",
		"",
		"",
		"",
		"Nuestra competencia se está desarrollando demasiado rápido, hazles perder el tiempo.",
		"",
		"Hay rumores de un posible... tesoro perdido. Naturalmente estamos interesados, imagina lo que podría llegar a costar.",
		"Acabamos de sacar un nuevo moledo telésfera que queremos patentar, pero debemos asegurarnos de que el viaje sea lo más corto posible para evitar que nos roben la idea. Espera a que la órbita pase lo más cerca posible y ve.",
		"Verás... A veces el miedo puede ser un potente insentivo para invertir en seguridad, por lo que necesitamos amm... Emocionar... A cierto público."
		], [
	    "El traslado de recursos es un proceso logístico. Optimízalo y completa la ruta asignada.",
	    "Necesitamos datos empíricos sobre la reacción de un mercado ante la ausencia total de un recurso.",
	    "La observación directa es imprescindible. Registra actividad, precios y movimientos locales.",
	    "",
	    "Requerimos una prueba de capacidad máxima de almacenamiento. Llena la nave según protocolo.",
	    "Algunas empresas muestran patrones anómalos. Obtén información para su posterior análisis.",
		"El desarrollo requiere industrias, nosotros requerimos saber qué tan desarrollados están nuestros vecinos.",
		"La tecnología lo es todo, tráenos los aparatos de nuestros vecinos para asegurarnos de estar por encima.",
		"",
		"",
		"Las ideas arcaicas caen desde adentro. Infíltrate y hazles perder tiempo y recursos.",
		"",
		"Nos gustaría que buscaras una pieza de tecnología antigua para investigarla y reirnos un poco de lo subdesarrollados que eran.",
		"Necesitamos llevar un nuevo calibrador de neutrinos, aquí funciona bien, pero si se expone al espacio interplanetario, se desconfigurará. Optimiza la ruta para exponerlo lo menos posible a los vientos solares.",
		"Nuestros informes hablan de un lugar donde se trafican datos de manera ilegal, tienes que detener esto."
		], [
	    "A veces hay que empujar un poco las cosas en pro de mantener el equilibrio en el cosmos.",
	    "Nuestros recursos no deben caer en manos equivocadas. Elimina su disponibilidad en ese mundo.",
	    "Necesitamos conocer las formas de vida con las que nos relacionamos, hazles una visita.",
	    "",
	    "Mantén esos recursos bajo tu control por ahora. No deben circular todavía.",
	    "Algunas empresas interfieren con el equilibrio. Confirma si representan una amenaza.",
		"Me temo que hay lugares donde no se respeta el equilibrio, ve y documenta sus crímenes sin que te vean.",
		"",
		"Estos especímenes en peligro de extinción necesitan un lugar donde reproducirse en paz.",
		"",
		"EL sabotaje es la única opción. Ve y falla una misión para quienes interrumpen el equilibrio",
		"",
		"Se dice que existe un cuarzo perdido que permite conectar con la Pachamama directamente, tráelo por el bien de la vida.",
		"Las formas de vida más delicadas no pueden ser transportadas en gravedad 0 por mucho tiempo, lleva este Snurfit sano y salvo a su planeta estando lo menos posible viajando",
		"Hay crímenes en contra de la vida cometiéndose en cierto planeta, hay que hacer algo."
		], [
	    "Una entrega puntual puede evitar muchos conflictos. Viaja y regresa sin incidentes.",
	    "Un desequilibrio temporal puede facilitar futuras negociaciones. Ocúpate del suministro.",
	    "El diálogo empieza con conocimiento. Preséntate en nuestros sistemas vecinos.",
	    "",
	    "Necesitamos asegurar ciertos bienes antes de avanzar. Mantén la carga contigo.",
	    "La estabilidad regional es prioritaria. Verifica que ninguna empresa esté alterándola.",
		"Haz una visita diplomática encubierta a nuestra embajada en el país de nuestros vecinos.",
		"",
		"",
		"El hambre siempre ha sido la mayor causa de conflictos, ayúdanos a controlarla para mantener la paz.",
		"Lo único que el mal necesita para triunfar es que el bien no haga nada. Ve y haz algo por la paz.",
		"",
		"Tengo entendido que todo el mudno anda buscando algo por allá afuera, sea lo que sea, nosotros también lo queremos.",
		"La Estatua de Hielo de la Amistad debe ser llevada pronto al gran banquete, aquí la tenemos en un congelador a salvo, te lo pasaríamos, pero no le hace el enchufe a tu nave",
		""
		], [
		"La logística es la columna vertebral del Imperio. Asegúrate de cumplir con ese peso.",
		"Los recursos son para quienes sean fuertes y puedan defenderlos. Nuestros vecinos parecen débiles.",
		"Un gran imperio debe tener un ojo siempre sobre sus dominios. Sé ese ojo sobre nuestros vecinos.",
		"",
		"El Imperio requiere sacar de circulación ciertos bienes por un momento.",
		"Los enemigos del Imperio pueden estar en todos lados, ve y verifica este planeta.",
		"Necesitamos que instales un amm... dispositivo... Asegúrate de que nadie te vea.",
		"",
		"",
		"",
		"Los enemigos del Imperio están por todos lados. Gánate su confianza y deja que sea el principio de su fin.",
		"Necesitamos suministrar armas a la guerrilla por medio de una oficina comercial, asegúrate de que no pasen por el mercado.",
		"Quiero un nuevo trofeo que colgar de mi pared, he escuchado que te los puedes encontrar botados por los bordes del sistema.",
		"Queremos llevar este pastel que suena como reloj a un amigo nuestro, aquí está seguro, pero te recomiendo mucho que no lo tengas demasiado tiempo dentro de tu nave.",
		"¿Quieres ayudar al equilibrio? A veces se necesita ensuciar las manos para poner la maquinaría en marcha."
	]]
	for(var a = 0; a < mision_max; a++)
		for(var b = 0; b < arquetipo_max; b++)
			array_set(mision_descripcion[b], a, text_wrap(mision_descripcion[b, a], 400))
#endregion
#region Infrastructura
	capacidad_nombre = ["Capacidad energética", "Capacidad logística", "Capacidad poblacional"]
	infrastructura_nombre = array_create(0, "")
	infrastructura_precio = array_create(0, 0)
	infrastructura_mantenimiento = array_create(0, 0)
	infrastructura_capacidad_id = array_create(0, 0)
	infrastructura_capacidad_num = array_create(0, 0)
	function def_infrastructura(nombre, precio = 0, mantenimiento = 0, capacidad_id = 0, capacidad_num = 0){
		array_push(infrastructura_nombre, string(nombre))
		array_push(infrastructura_precio, precio)
		array_push(infrastructura_mantenimiento, mantenimiento)
		array_push(infrastructura_capacidad_id, capacidad_id)
		array_push(infrastructura_capacidad_num, capacidad_num)
		return array_length(infrastructura_nombre) - 1
	}
	infra_central_electrica = def_infrastructura("Central Eléctrica", 60, 2, 0, 2)
	infra_planta_nuclear = def_infrastructura("Planta nuclear", 110, 3, 0, 4)
	infra_parque_solar = def_infrastructura("Parque solar", 40, 0, 0, 1)
	infra_carreteras = def_infrastructura("Carreteras", 40, 1, 1, 1)
	infra_riel_magnetico = def_infrastructura("Riel magnético", 60, 2, 1, 2)
	infra_puerto_drones = def_infrastructura("Puerto de Drones", 90, 3, 1, 3)
	infra_viviendas = def_infrastructura("Viviendas sociales", 40, 2, 2, 2)
	infra_centro_urbano = def_infrastructura("Centro urbano", 50, 3, 2, 3)
	infra_plazas = def_infrastructura("Plazas y parques", 30, 1, 2, 1)
	infrastructura_max = array_length(infrastructura_nombre)
#endregion
#region GUI
	gui_back = #E6E8EB
	gui_panel_front = #1F2933
	gui_panel_back = #F2F4F7
	gui_panel_hover = #C5CAD3
	gui_panel_back_red = #D64545
	gui_panel_hover_red = #C53737
	gui_panel_back_green = #4CAF50
	gui_panel_hover_green = #43A047
	gui_panel_back_yellow = #F4B400
	gui_panel_hover_yellow = #E2A200
	gui_panel_back_array = [gui_panel_back, gui_panel_back_red, gui_panel_back_green, gui_panel_back_yellow]
	gui_panel_hover_array = [gui_panel_hover, gui_panel_hover_red, gui_panel_hover_green, gui_panel_hover_yellow]
	deslizante_id = -1
	deslizante_pos = array_create(2, 0)
	draw_background_x = -1
	draw_background_y = -1
	draw_background_text = ""
	draw_background_halign = fa_center
	gui_draw_path = false
	gui_draw_relacion = true
#endregion
#region Tutorial
	ini_open("tutorial.ini")
	tutorial = ini_read_real("Global", "tutorial", 0)
	ini_close()
	tutorial_step = 0
	tutorial_text = [
		["Bienvenido a PLANETES\nHaz clic en abrir comunicación"],
		["Aquí puedes interactuar con el planeta\nHaz clic en Mercado"],
		["Aquí puedes comprar y vender mercancías\nCompra algo para cargarlo a tu nave"],
		["Perfecto, ahora haz clic derecho para salir del mercado"],
		["Perfecto, ahora haz clic derecho para salir del mercado"],
		["Ahora haz clic en otro planeta para viajar a él"],
		["Mantén presionada la barra espaciadadora para adelantar el tiempo"],
		["Perfecto, ahora vende aquí algo de lo que hayas comprado"],
		["Ahora vamos a buscar una misión\nHaz clic en Misiones"],
		[ $"Aquí se muestran todas las misiones que este planeta ofrece por ahora\nToma la misión {mision_nombre[mis_artefacto]}"],
		["Este es el sistema estelar, tu misión te pide ir a {0}",
			"Esta misión pide viajar a {0} que está muy lejos\nGira la rueda del mouse para ver el sistema estelar completo"],
		["El viaje puede ser largo\nShift + Espacio para adelantar el tiempo más rápido"],
		["Aquí solo debes buscar el artefacto, en alguna de estas lunas debe estar"],
		["¡Bien hecho!\nCuando termines una misión recuerda siempre volver al planeta de origen"],
		["Eso es todo por ahora\nExplora todos los mundos que quieras, comercia, cumple misiones y\ncorónate como el mayor mercader el sistema estelar"]]
#endregion
null_viaje = {
	dis : 0,
	x : 0,
	y : 0,
	viaje_x : array_create(0, 0),
	viaje_y : array_create(0, 0),
	origen_x : 0,
	origen_y : 0
}
null_planeta = {
	index : -1,
	x : 0,
	y : 0,
	radio : 0,
	fase : 0,
	anno : 0,
	size : 0,
	nombre : "",
	color : c_black,
	luna_bool : false,
	luna : undefined,
	lunas : undefined,
	recurso : array_create(0, 0),
	recurso_precio : array_create(recurso_max, 0),
	recurso_fabrica : array_create(recurso_max, 0),
	misiones : array_create(0, 0),
	arquetipo : 0,
	estado : 0,
	estado_repeat : 0,
	infrastructura : 0,
	fabricas : 0,
	infrastructura_bool : array_create(0, false),
	infrastructura_owner : undefined,
	capacidad : array_create(0, 0),
	gigante : false,
	luna_externa : false,
	imperio : undefined,
	tipo : 0
}
null_planeta.luna = null_planeta
null_planeta.lunas = array_create(0, null_planeta)
planetas = array_create(0, null_planeta)
null_nave = {
	index : -1,
	origen : null_planeta,
	destino : null_planeta,
	pointer : array_create(2, 0),
	empresa : undefined,
	viaje : null_viaje,
	viaje_bool : false,
	viaje_pos : 0,
	recurso : array_create(0, 0),
	misiones : undefined,
	modelo : 0,
	hp : 0
}
naves = array_create(0, null_nave)
null_empresa = {
	index : -1,
	nombre : "",
	naves : array_create(0, null_nave),
	pointer : array_create(1, 0),
	dinero : 0,
	recurso_compra_precio : array_create(0, 0),
	recurso_compra_lugar : array_create(0, null_planeta),
	recurso_venta_precio : array_create(0, 0),
	recurso_venta_lugar : array_create(0, null_planeta),
	misiones : undefined,
	riesgo : 0,
	oficina_bool : array_create(0, false),
	oficina : undefined,
	ultima_falla : array_create(0, 0),
	fabricas : ds_grid_create(0, 0),
	relacion_imperio : ds_map_create(),
	relacion_imperio_piso : ds_map_create()
}
ds_map_add(null_empresa.relacion_imperio, 0, 0)
ds_map_clear(null_empresa.relacion_imperio)
ds_map_add(null_empresa.relacion_imperio_piso, 0, 0)
ds_map_clear(null_empresa.relacion_imperio_piso)
ds_grid_clear(null_empresa.fabricas, 0)
null_nave.empresa = null_empresa
null_planeta.infrastructura_owner = array_create(0, null_empresa)
empresas = array_create(0, null_empresa)
null_mision = {
	index : -1,
	nombre : "",
	contratista : null_planeta,
	contratado : null_empresa,
	fecha : 0,
	status : false,
	paga : 0,
	data : {},
	//0: empresa.misiones
	pointer : array_create(1, 0),
	restricciones : array_create(0, null_planeta),
	restricciones_texto : "",
	//Para los NPC
	nave_asignada : null_nave
}
null_empresa.misiones = array_create(0, null_mision)
null_nave.misiones = array_create(0, null_mision)
null_noticia = {
	fecha : 0,
	titulo : "",
	texto : ""
}
noticias = array_create(0, null_noticia)
null_oficina = {
	planeta : null_planeta,
	empresa : null_empresa,
	recurso : array_create(0, 0),
	precio_compra : array_create(0, 0),
	precio_venta : array_create(0, 0)
}
null_empresa.oficina = array_create(0, null_oficina)
null_imperio = {
	index : -1,
	nombre : "",
	arquetipo : 0,
	planetas : array_create(0, null_planeta),
	relacion_imperio : ds_map_create(),
	relacion_empresa : ds_map_create(),
	relacion_empresa_piso : ds_map_create(),
	eliminado : false
}
ds_map_add(null_imperio.relacion_imperio, 0, 0)
ds_map_clear(null_imperio.relacion_imperio)
ds_map_add(null_imperio.relacion_empresa, 0, 0)
ds_map_clear(null_imperio.relacion_empresa)
ds_map_add(null_imperio.relacion_empresa_piso, 0, 0)
ds_map_clear(null_imperio.relacion_empresa_piso)
null_planeta.imperio = null_imperio
imperios = array_create(0, null_imperio)
//Variables
estado_diplomatico = 0
planetas_arquetipo = array_create(arquetipo_max)
for(var a = 0; a < arquetipo_max; a++)
	planetas_arquetipo[a] = array_create(0, null_planeta)
planetas_terrestres = array_create(0, null_planeta)
var planetas_terrestres_sin_lunas = array_create(0, null_planeta)
planetas_gigantes = array_create(0, null_planeta)
planetas_no_gigantes = array_create(0, null_planeta)
planetas_terrestres_gigantes = array_create(0, null_planeta)
planetas_internos = array_create(0, null_planeta)
planeta_mouse = null_planeta
planeta_mouse_bool = false
min_dis = infinity
planeta_select_bool = true
viaje = null_viaje
viaje_bool = false
viaje_planeta = null_planeta
pasar_dia_bool = true
text_x = 0
text_y = 0
dia = 0
input_layer = 0
input_data = 0
show = -1
show_empresa = 0
recurso_multiplicador = array_create(recurso_max, 0)
for(var a = 0; a < recurso_max; a++)
	recurso_multiplicador[a] = random_range(0.9, 1.1)
step_noticia = 0
show_noticia = -1
background = undefined
misiones_cumplidas = 0
misiones_falladas = 0
subsistema_vista = false
subsistema = null_planeta
zoom = 1
camx = RW2
camy = RH2
counter_planeta = 0
counter_nave = 0
counter_empresa = 0
counter_imperio = 0
#region Batalla
	nave_nombre = ["SP-crusaider", "KZ-1", "TK-32"]
	nave_hp = [100, 70, 400]
	nave_vel = [0.3, 0.5, 0.2]
	batalla = false
	batalla_planeta = null_planeta
	batalla_pirata = null_empresa
	null_batalla_nave = {
		nave : null_nave,
		x : 0,
		y : 0,
		dir : 0,
		vel : 0,
		hp : 0,
		step : 0,
		diff : 0,
		ia : true
	}
	batalla_naves = array_create(0, null_batalla_nave)
	null_batalla_bala = {
		x : 0,
		y : 0,
		hmove : 0,
		vmove : 0,
		vel : 0,
		step : 0,
		home : null_batalla_nave,
		pointer : array_create(0, 0)
	}
	batalla_balas = array_create(0, null_batalla_bala)
	null_batalla_asteroide = {
		x : 0,
		y : 0,
		hmove : 0,
		vmove : 0,
		rot : 0,
		angle : 0,
		tipo : 0,
		pointer : array_create(0, 0)
	}
	batalla_asteroides = array_create(0, null_batalla_asteroide)
	null_batalla_efecto = {
		x : 0,
		y : 0,
		efecto : spr_icon,
		subsprite : 0,
		vel : 0,
		step : 0,
		pointer : array_create(1, 0)
	}
	batalla_efectos = array_create(0, null_batalla_efecto)
	batalla_humo = array_create(0, {
		x : 0,
		y : 0,
		hmove : 0,
		vmove : 0,
		step : 0
	})
	batalla_step = 0
	batalla_loser = null_batalla_nave
	batalla_camx = 0
	batalla_camy = 0
	batalla_background = undefined
	#macro batalla_dis_freno 10_000 //100^2
	#macro batalla_hitbox 625 // 25^2
	#macro batalla_sidex 320
	#macro batalla_sidey 240
	#macro batalla_asteroide_disx 400
	#macro batalla_asteroide_disy 300
	#macro batalla_dis_bala 250_000 // 500^2
#endregion
imperios_eliminados = array_create(0, null_imperio)
//Imperios
imperios_max = 10
var imperios_peso = array_create(imperios_max, 6)
for(var a = 0; a < imperios_max; a++){
	var imperio = add_imperio()
	imperio.arquetipo = array_length(imperios) mod arquetipo_max
}
//Planetas
var colores_hielo = [ #273346, #246480, #3C4D78, #BEB8AF, #8090A0, #93959C, #757C87, #786881]
var colores_silicio = [ #351C08, #5D432E, #612706, #51473C, #6B514A, #89674C, #89674C, #9E6D48, #B48762, #938884, #917B5E, #C8965B, #9C8760, #DCC8A5]
var colores_metalico = [ #784A41, #533F51, #40272B, #8A4A41, #D06E61, #8C481C, #921909, #6F796B]
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
		planeta.size = random_range(3, 6)
		planeta.tipo = weighted_choose([planeta.luna.radio / 70 - 1, 1, 2 - planeta.luna.radio / 320])
	}
	else{
		array_push(planetas_terrestres, planeta)
		array_push(planetas_terrestres_gigantes, planeta)
		array_push(planetas_terrestres_sin_lunas, planeta)
		do planeta.radio = random_range(70, 320)
		until check_orbit(,, planeta.radio)
		planeta.x = room_width / 2 + (cos(planeta.fase) + EXCENTRICIDAD) * planeta.radio
		planeta.y = room_height / 2 + sin(planeta.fase) * planeta.radio * 0.9
		planeta.size = random_range(8, 15)
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
	planeta.x = room_width / 2 + (cos(planeta.fase) + EXCENTRICIDAD) * planeta.radio
	planeta.y = room_height / 2 + sin(planeta.fase) * planeta.radio * 0.9
	planeta.size = random_range(25, 40)
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
		luna.size = random_range(3, 6)
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
