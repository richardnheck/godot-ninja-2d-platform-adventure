extends CanvasLayer


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://src/UI/MainScreen/MainScreen.tscn")
