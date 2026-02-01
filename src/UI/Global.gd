extends Node

var _previous_scene_path:String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_previous_scene(scene_path) -> void:
	_previous_scene_path = scene_path
		
func get_previous_scene() -> String:
	return _previous_scene_path
