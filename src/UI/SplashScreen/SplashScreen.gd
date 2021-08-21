extends CanvasLayer

onready var fade_screen = $FadeScreen

func _ready() -> void:
	# Preload the mainscreen to prevent HTML5 audio stutter when transitioning
	preload("res://src/UI/MainScreen/MainScreen.tscn")
	
	fade_screen.fade_in_current_scene();
	Game_AudioManager.play_bgm_main_theme()


func _on_Timer_timeout() -> void:
	fade_screen.go_to_scene("res://src/UI/MainScreen/MainScreen.tscn")
