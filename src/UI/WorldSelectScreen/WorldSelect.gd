extends Control

onready var world1_button = $"%World1Button"
onready var world2_button = $"%World2Button"
onready var world3_button = $"%World3Button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Preload the mainscreen to prevent HTML5 audio stutter when transitioning
	preload("res://src/UI/MainScreen/MainScreen.tscn")
	
	Game_AudioManager.play_bgm_main_theme_skip_start()
	
	# Get the current player progress of the game
	# This is the maximum level that the player has reached
	var current_level = GameState.progress["current_level"]
	var current_world = LevelData.get_world(current_level)
	
	world1_button.disabled = false	# World 1 button is always enabled
	world2_button.disabled = current_world < LevelData.WORLD2
	world3_button.disabled = current_world < LevelData.WORLD3

func _on_World1Button_button_up() -> void:
	_play_world_button_click_sound()
	get_tree().change_scene("res://src/UI/LevelSelectScreens/CaveLevelSelect.tscn")

func _on_World2Button_pressed() -> void:
	print_debug("world 2 button")
	_play_world_button_click_sound()
	get_tree().change_scene("res://src/UI/LevelSelectScreens/World2LevelSelect.tscn")

func _on_World3Button_pressed() -> void:
	print_debug("world 3 button")
	_play_world_button_click_sound()
	get_tree().change_scene("res://src/UI/LevelSelectScreens/World3LevelSelect.tscn")

func _play_world_button_click_sound():
	Game_AudioManager.sfx_ui_world_select.play()
