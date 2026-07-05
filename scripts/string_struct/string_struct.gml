function string_struct(variable, iter = 2){
	var temp_text = "", jump = 2 * (2 - iter) * " "
	if is_struct(variable){
		if iter = 0
			return "struct{...}"
		var variables = struct_get_names(variable), len = array_length(variables)
		temp_text = "{"
		for(var a = 0; a < len; a++){
			var valor = struct_get(variable, variables[a])
			temp_text += $"\n{jump}{variables[a]}: {string_struct(valor, iter - 1)}"
			temp_text += (a = (len - 1)) ? "}" : ", "
		}
	}
	else if is_array(variable){
		if iter = 0
			return "array[...]"
		var len = array_length(variable)
		temp_text = "["
		for(var a = 0; a < len; a++){
			var valor = variable[a]
			temp_text += $"\n{jump}{string_struct(valor, iter - 1)}"
			temp_text += (a = (len - 1)) ? "]" : ", "
		}
	}
	else if is_bool(variable)
		temp_text = variable ? "True" : "False"
	else
		temp_text = string(variable)
	return temp_text
}