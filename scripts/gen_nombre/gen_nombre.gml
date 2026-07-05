function gen_nombre(){
	var output = ""
	repeat(irandom_range(2, 4)){
		output += choose("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "x", "y", "z")
		output += choose("a", "e", "i", "o", "u")
	}
	output = string_upper(string_char_at(output, 0)) + string_delete(output, 0, 1)
	return output
}