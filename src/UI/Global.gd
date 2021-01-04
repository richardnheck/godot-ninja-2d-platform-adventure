extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func play_game_start_sound() -> void:
	get_node("GameStartSound").play()
	
func play_general_select_sound() -> void:
	get_node("GeneralSelectSound").play()

func play_pause_sound() -> void:
	get_node("PauseSound").play()
	
func play_basic_blip_sound() -> void:
	get_node("BasicBlipSound").play()

	

	
