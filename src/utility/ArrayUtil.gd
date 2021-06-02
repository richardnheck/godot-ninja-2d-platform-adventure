extends Node


static func filter(input: Array, function: FuncRef) -> Array:
	var result = []
	for element in input:
		if function.call_func(element):
			result.append(element)
	return result	
