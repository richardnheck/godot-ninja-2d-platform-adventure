extends TextureButton

func _on_button_up() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
