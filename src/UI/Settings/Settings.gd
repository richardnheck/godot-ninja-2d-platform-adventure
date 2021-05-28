extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_CloseButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	visible = false
