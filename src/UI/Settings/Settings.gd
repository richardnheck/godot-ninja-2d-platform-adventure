#------------------------------
# Settings
#------------------------------
extends Control

signal on_closed
signal on_tab_changed

onready var level_checkpoints_button := $"%LevelCheckpointsOnOffButton"
onready var boss_level_checkpoints_button := $"%BossLevelCheckpointsOnOffButton"
onready var show_level_names_button := $"%ShowLevelNamesOnOffButton"
onready var show_level_timer_button := $"%ShowLevelTimerOnOffButton"
onready var resolution_option_button := $"%ResolutionOptionButton"
onready var window_type_option_button := $"%WindowTypeOptionButton"
onready var tab_container:TabContainer = $"%TabContainer"
onready var cut_scene_base:CutSceneBase = $"%CutSceneBase"
onready var player_animated_sprite:= $"%PlayerAnimatedSprite" 
onready var player_animated_texture_rect := $"%AnimatedTextureRect"

var resolutions = {
	"2560x1440": Vector2(2560, 1440), # 1440p
	"1920x1080": Vector2(1920, 1080), # 1080p
	"1366x768": Vector2(1366, 768),   # common laptop (close to 16:9)
	"1280x720": Vector2(1280, 720),   # 720p
	"960x540": Vector2(960, 540),
	"640x360": Vector2(640, 360),
	#"320x180": Vector2(320, 180)   # game base resolution
}

const TYPE_WINDOW = "Windowed"
const TYPE_BORDERLESS_WINDOW = "Borderless Window"
const TYPE_FULLSCREEN = "Fullscreen"

var window_types = [
	TYPE_WINDOW,
	TYPE_BORDERLESS_WINDOW,
	TYPE_FULLSCREEN
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_checkpoints_button.set_on(Settings.get_level_checkpoints_enabled())
	boss_level_checkpoints_button.set_on(Settings.get_boss_level_checkpoints_enabled())
	show_level_names_button.set_on(Settings.get_show_level_names_enabled())
	show_level_timer_button.set_on(Settings.get_show_level_timer_enabled())
	
	# Remove the display tab for html5 build as the size is dictated by the web embed size
	if Settings.is_html5_build():
		var tab_node = tab_container.get_tab_control(1)
		tab_container.remove_child(tab_node)
	
	_add_resolutions()
	_update_selected_resolution()
	
	_add_window_types()
	_update_selected_window_type()
	

func set_current_tab(tab_index:int) -> void:	
	tab_container.current_tab = tab_index
	

func _on_CloseButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

# Handle clicking on the hidding cheat/developer button
# Button must be clicked 5 times to enable the cheat mode
# It can be toggled on and off by further clicking
var cheat_count = 0
func _on_CheatButton_pressed() -> void:
	cheat_count = cheat_count + 1
	if cheat_count >= 5:
		# toggle cheat mode
		Settings.cheat_mode = not Settings.cheat_mode
		GameState.cheat(Settings.cheat_mode)
		if Settings.cheat_mode:
			Game_AudioManager.sfx_collectibles_demon_seal.play()
		else:
			Game_AudioManager.sfx_ui_basic_blip_select.play()


func _on_LevelCheckpointsOnOffButton_button_pressed(on):
	Settings.set_level_checkpoints_enabled(on)


func _on_BossLevelCheckpointsOnOffButton_button_pressed(on):
	Settings.set_boss_level_checkpoints_enabled(on)


func _on_ShowLevelNamesOnOffButton_button_pressed(on):
	Settings.set_show_level_names_enabled(on)

	
func _on_ShowLevelTimerOnOffButton_button_pressed(on):
	Settings.set_show_level_timer_enabled(on)

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


func _on_WindowTypeOptionButton_item_selected(index):
	var selected_window_type = window_type_option_button.get_item_text(index)
	if selected_window_type == TYPE_FULLSCREEN:
		OS.window_fullscreen = true
	elif selected_window_type == TYPE_WINDOW:
		OS.window_fullscreen = false
		OS.window_borderless = false
	elif selected_window_type == TYPE_BORDERLESS_WINDOW:
		OS.window_fullscreen = false
		OS.window_borderless = true
	
	resolution_option_button.disabled = selected_window_type == TYPE_FULLSCREEN

func _add_window_types():
	for window_type in window_types:
		window_type_option_button.add_item(window_type)
	
func _update_selected_window_type():
	var selected_window_type = TYPE_WINDOW
	if OS.window_fullscreen:
		selected_window_type = TYPE_FULLSCREEN
	elif OS.window_borderless:
		selected_window_type = TYPE_BORDERLESS_WINDOW
		
	window_type_option_button.selected = window_types.find(selected_window_type)
	resolution_option_button.disabled = selected_window_type == TYPE_FULLSCREEN


func _on_ShowCreditsButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	cut_scene_base.skip_to_scene_path = "res://src/UI/GameCreditsScreen/GameCreditsScene.tscn"
	cut_scene_base.goto_next_scene(false, self.get_tree().current_scene.filename )


func _on_TabContainer_tab_changed(tab):
	emit_signal("on_tab_changed", tab)

	
func _change_player_animation():
	if player_animated_texture_rect.animation == "talk":
		player_animated_texture_rect.animation="celebrate"
		player_animated_texture_rect.frames_per_second = 15
	elif player_animated_texture_rect.animation == "celebrate":
		player_animated_texture_rect.animation="run"
		player_animated_texture_rect.frames_per_second = 15
	elif player_animated_texture_rect.animation == "run":
		player_animated_texture_rect.animation="idle"
		player_animated_texture_rect.frames_per_second = 10
	elif player_animated_texture_rect.animation == "idle":
		player_animated_texture_rect.animation="talk"
		player_animated_texture_rect.frames_per_second = 5


func _on_AnimatedTextureRect_gui_input(event):
	
	if event is InputEventMouseButton:
		print(event.button_index)
		if event.button_index == BUTTON_LEFT and event.pressed:
			print(">>> Player pressed")
			_change_player_animation()
			
