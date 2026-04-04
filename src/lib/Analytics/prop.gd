class_name TaloProp
	
var key: String
var value

static func to_array_key(key: String) -> String:
	return key if key.ends_with("[]") else key + "[]"

func _init(key: String, value):
	self.key = key
	self.value = str(value) if value != null else value

func to_dictionary() -> Dictionary:
	return { key = key, value = value }
