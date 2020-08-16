tool
extends TextureButton

export(String, FILE) var next_scene_path:String = ""

func _on_button_up() -> void:
	get_tree().paused = false	
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "next_scene_path must be set" if next_scene_path == "" else ""
