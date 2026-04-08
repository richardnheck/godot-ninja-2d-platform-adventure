class_name TaloEntityWithProps
	
var props: Array = []

func _init(props: Array = []) -> void:
	self.props = props

func get_prop(prop_name:String) -> TaloProp:
	for prop in props:
		if prop.key == prop_name:
			return prop
			
	return null
