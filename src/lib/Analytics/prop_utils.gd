class_name TaloPropUtils

static func serialise_dictionary(props: Dictionary) -> Array:
	var ret: Array = []
	for key in props.keys():
		var val = props.get(key)
		if key.ends_with("[]") and val is Array:
			if val.is_empty():
				ret.push_back({ key = key, value = null })
			else:
				for v in val:
					ret.push_back({ key = key, value = str(v) })
		else:
			# keep null values as-is to indicate that the prop should be deleted
			ret.push_back({ key = key, value = null if val == null else str(val) })
	return ret

static func dictionary_to_props(props: Dictionary) -> Array:
	var ret: Array = []
	for key in props.keys():
		var val = props.get(key)
		if key.ends_with("[]") and val is Array:
			for v in val:
				ret.push_back(TaloProp.new(key, str(v)))
		else:
			ret.push_back(TaloProp.new(key, val))
	return ret

static func props_to_dictionary(props: Array) -> Dictionary:
	var ret: Dictionary = {}
	for prop in props:
		if prop.key.ends_with("[]"):
			if !ret.has(prop.key):
				ret[prop.key] = []
			if prop.value != null:
				ret[prop.key].push_back(prop.value)
		else:
			ret[prop.key] = prop.value
	return ret

static func serialise_props(props: Array) -> Array:
	var ret: Array = []
	var mapped_props:Array = [] 
	for prop in props:
		mapped_props.append(prop.to_dictionary())
	return mapped_props
