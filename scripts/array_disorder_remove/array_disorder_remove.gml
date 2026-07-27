function array_disorder_remove(array, struct, index){
	var len = array_length(array), temp_struct = array[len - 1], point = struct.pointer[index]
	temp_struct.pointer[index] = point
	array[point] = temp_struct
	array_pop(array)
}