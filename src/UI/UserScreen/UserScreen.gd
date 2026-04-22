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
	if Settings.is_mobile():
		display_name_line_edit.virtual_keyboard_enabled = false
	
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
	
	# First determine if the player display name is already in use
	var user := GameState.user
	var players = yield(Analytics.get_players_by_display_name(display_name_line_edit.text),"completed")
	var display_name_in_use = true
	if players.size() == 0:
		# No players found with the display name
		display_name_in_use = false
	elif players.size() > 0:
		# Players found with the display name
		# Check whether it is the display name for this user or another
		var player = players[0]
		var player_identifier = player.aliases[0].identifier
		display_name_in_use = player_identifier != user.identifier
	
	if !display_name_in_use:
		# Display name not in use so update it
		yield(Analytics.update_player_display_name(display_name_line_edit.text),"completed")
		_show_display_name_message("Updated!")
		_show_overlay(false)
	else:
		# Display name in use so inform use that it is taken
		_show_display_name_message("Name taken!")
		_show_overlay(false)


func _show_display_name_message(message:String):
	display_name_message_label.text = message
	yield(get_tree().create_timer(1.5), "timeout")
	display_name_message_label.text = ""

func _show_overlay(show:bool):
	overlay.visible = show

func _on_DisplayNameLineEdit_focus_entered():
	if Settings.is_mobile():
		display_name_line_edit.release_focus()
		# Virtual Keyboard doesn't work on mobile so use a javascript popup prompt instead
		display_name_line_edit.text = JavaScript.eval("prompt('%s', '%s');" % ["Enter display name:", display_name_line_edit.text],true)
	
