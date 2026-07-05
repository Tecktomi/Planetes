function text_wrap(str, max_width){
    var trozos = string_split(str, " ", true), temp_text = "", line_width = 0
		for(var b = 0; b < array_length(trozos); b++){
			if line_width > max_width{
				temp_text += "\n"
				line_width = 0
			}
			temp_text += trozos[b] + " "
			line_width += string_width(trozos[b] + " ")
		}
	return string_trim(temp_text)
}