# ==========================================================
# GLOBAL SETTINGS
# ==========================================================
extends Node

signal controls_changed

var touch_screen_controls_visible:bool = true setget set_touch_screen_controls_visible, get_touch_screen_controls_visible
var cheat_mode:bool = false setget set_cheat_mode, get_cheat_mode
var level_checkpoints_enabled:bool = true setget set_level_checkpoints_enabled
var boss_level_checkpoints_enabled:bool = true setget set_boss_level_checkpoints_enabled
var show_level_names_enabled:bool = false setget set_show_level_names_enabled

func set_touch_screen_controls_visible(new_value) -> void: 
	touch_screen_controls_visible = new_value
	emit_signal("controls_changed")

func get_touch_screen_controls_visible() -> bool:
	return touch_screen_controls_visible 

	
func set_level_checkpoints_enabled(new_value) -> void: 
	level_checkpoints_enabled = new_value
	emit_signal("controls_changed")

func get_level_checkpoints_enabled() -> bool:
	return level_checkpoints_enabled


func set_boss_level_checkpoints_enabled(new_value) -> void: 
	boss_level_checkpoints_enabled = new_value
	emit_signal("controls_changed")

func get_boss_level_checkpoints_enabled() -> bool:
	return boss_level_checkpoints_enabled


func set_show_level_names_enabled(new_value) -> void: 
	show_level_names_enabled = new_value
	emit_signal("controls_changed")

func get_show_level_names_enabled() -> bool:
	return show_level_names_enabled
	
	
func set_cheat_mode(new_value) -> void: 
	cheat_mode = new_value

func get_cheat_mode() -> bool:
	return cheat_mode
		

# Determine if build is HTML5
func is_html5_build() -> bool:
	var is_html5 = OS.get_name() == "HTML5"
	print("isHtml5 build: ", is_html5)
	return is_html5


# Determine device has touch screen
func has_touchscreen() -> bool:
	return OS.has_touchscreen_ui_hint()
	
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("OS name: ", OS.get_name())
	print("hasTouchScreen: ", has_touchscreen())
	# Set touch screen controls to visible at start if device has a touch screen
	touch_screen_controls_visible = has_touchscreen() and self.is_html5_build()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
