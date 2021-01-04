extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	

func _on_World1Button_button_up() -> void:
	Global.play_general_select_sound()
	get_tree().change_scene("res://src/UI/LevelSelectScreens/CaveLevelSelect.tscn")
