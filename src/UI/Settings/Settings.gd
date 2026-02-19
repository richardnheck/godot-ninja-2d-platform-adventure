extends Control

onready var level_checkpoints_button := $"%LevelCheckpointsOnOffButton"
onready var boss_level_checkpoints_button := $"%BossLevelCheckpointsOnOffButton"
onready var show_level_names_button := $"%ShowLevelNamesOnOffButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_checkpoints_button.set_on(Settings.get_level_checkpoints_enabled())
	boss_level_checkpoints_button.set_on(Settings.get_boss_level_checkpoints_enabled())
	show_level_names_button.set_on(Settings.get_show_level_names_enabled())


func _on_CloseButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	visible = false


func _on_CheatButton_pressed() -> void:
	# toggle cheat mode
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	Settings.cheat_mode = not Settings.cheat_mode
	GameState.cheat(Settings.cheat_mode)


func _on_LevelCheckpointsOnOffButton_button_pressed(on):
	Settings.set_level_checkpoints_enabled(on)


func _on_BossLevelCheckpointsOnOffButton_button_pressed(on):
	Settings.set_boss_level_checkpoints_enabled(on)


func _on_ShowLevelNamesOnOffButton_button_pressed(on):
	Settings.set_show_level_names_enabled(on)
