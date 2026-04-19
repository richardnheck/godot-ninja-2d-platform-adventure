#------------------------------
# UserScreen
#------------------------------
extends Control

signal on_closed

onready var display_name_line_edit = $"%DisplayNameLineEdit"
onready var display_name_message_label = $"%DisplayNameMessageLabel"
onready var update_display_name_button = $"%UpdateButton"
onready var overlay = $"%OverlayColorRect"

# Called when the node enters the scene tree for the first time.
# Things that don't change can be initialized here
func _ready() -> void:
	_show_overlay(false)
	
# Handle when the scene becomes visible
func _on_Settings_visibility_changed():
	if is_visible_in_tree():
		_initialize()

# Initialize the settings
func _initialize():
	_show_overlay(false)
	_show_display_name_message("")
	display_name_line_edit.text = GameState.get_player_display_name()
	
func _on_CloseButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

func _on_UpdateButton_pressed():
	_show_overlay(true)
	yield(Analytics.update_player_display_name(display_name_line_edit.text),"completed")
	_show_overlay(false)
	_show_display_name_message("Updated!")
	yield(get_tree().create_timer(1.5), "timeout")
	_show_display_name_message("")
	

func _show_display_name_message(message:String):
	display_name_message_label.text = message

func _show_overlay(show:bool):
	overlay.visible = show
