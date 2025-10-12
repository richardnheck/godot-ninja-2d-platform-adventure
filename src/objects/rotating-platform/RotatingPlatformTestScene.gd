extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



#func _process(delta: float) -> void:
#	pass


func _on_Button_pressed() -> void:
	get_tree().reload_current_scene()
