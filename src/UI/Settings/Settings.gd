#------------------------------
# Settings
#------------------------------
extends Control

onready var level_checkpoints_button := $"%LevelCheckpointsOnOffButton"
onready var boss_level_checkpoints_button := $"%BossLevelCheckpointsOnOffButton"
onready var show_level_names_button := $"%ShowLevelNamesOnOffButton"
onready var resolution_option_button := $"%ResolutionOptionButton"

var resolutions = {
	"2560x1440": Vector2(2560, 1440), # 1440p
	"1920x1080": Vector2(1920, 1080), # 1080p
	"1366x768": Vector2(1366, 768),   # common laptop (close to 16:9)
	"1280x720": Vector2(1280, 720),   # 720p
	"960x540": Vector2(960, 540),
	"640x360": Vector2(640, 360),
	"320x180": Vector2(320, 180)   # game base resolution
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_checkpoints_button.set_on(Settings.get_level_checkpoints_enabled())
	boss_level_checkpoints_button.set_on(Settings.get_boss_level_checkpoints_enabled())
	show_level_names_button.set_on(Settings.get_show_level_names_enabled())
	_add_resolutions()
	_update_selected_resolution()


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

# Add the resolution items to the resolutions option button
func _add_resolutions():
	for resolution in resolutions:
		resolution_option_button.add_item(resolution)

# Handle when a resolution is selected
func _on_ResolutionOptionButton_item_selected(index):
	var key = resolution_option_button.get_item_text(index)
	OS.window_size = resolutions[key]
	_center_window()

# Center the window on the screen
func _center_window():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_real_window_size()
	OS.set_window_position((screen_size - window_size) / 2)

func _update_selected_resolution():
	var window_size = OS.window_size
	var window_size_string = str(window_size.x) + "x" + str(window_size.y)
	print(window_size_string)
	var resolutions_index = resolutions.keys().find(window_size_string)
	print("index", resolutions_index)
	resolution_option_button.selected = resolutions_index 
