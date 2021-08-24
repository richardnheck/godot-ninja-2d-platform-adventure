# ==========================================================
# GLOBAL SETTINGS
# ==========================================================
extends Node

signal controls_changed

var touch_screen_controls_visible:bool = true setget set_touch_screen_controls_visible, get_touch_screen_controls_visible
var cheat_mode:bool = false setget set_cheat_mode, get_cheat_mode

func set_touch_screen_controls_visible(new_value) -> void: 
	touch_screen_controls_visible = new_value
	emit_signal("controls_changed")

func get_touch_screen_controls_visible() -> bool:
	return touch_screen_controls_visible 
	
	
func set_cheat_mode(new_value) -> void: 
	cheat_mode = new_value

func get_cheat_mode() -> bool:
	return cheat_mode
		

# Determine if build is HTML5
func is_html5_build() -> bool:
	var is_html5 = OS.get_name() == "HTML5"
	print("isHtml5 build", is_html5)
	return is_html5


# Determine device has touch screen
func has_touchscreen() -> bool:
	return OS.has_touchscreen_ui_hint()
	
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set touch screen controls to visible at start if device has a touch screen
	touch_screen_controls_visible = has_touchscreen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
