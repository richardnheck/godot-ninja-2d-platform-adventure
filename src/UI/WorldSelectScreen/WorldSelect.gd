extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game_AudioManager.play_bgm_main_theme_skip_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	

func _on_World1Button_button_up() -> void:
	Game_AudioManager.sfx_ui_general_select.play()
	get_tree().change_scene("res://src/UI/LevelSelectScreens/CaveLevelSelect.tscn")

