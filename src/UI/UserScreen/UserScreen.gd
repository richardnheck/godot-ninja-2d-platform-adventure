#------------------------------
# UserScreen
#------------------------------
extends Control

signal on_closed

onready var display_name_line_edit = $"%DisplayNameLineEdit"
onready var display_name_message_label = $"%DisplayNameMessageLabel"
onready var update_display_name_button = $"%UpdateButton"
onready var overlay = $"%OverlayColorRect"
onready var onscreen_keyboard = $"%OnscreenKeyboard"

# onscreen keyboard for mobile 
var keyboard_enabled = false
var keyboard_visible = false


# Called when the node enters the scene tree for the first time.
# Things that don't change can be initialized here
func _ready() -> void:
	_show_overlay(false)
	if Settings.is_mobile():
		# On mobile the onscreen keyboard is not shown automatically
		# The display name input cannot accept focus and so the keyboard
		# is toggled when the user clicks on the input
		keyboard_enabled = true
		onscreen_keyboard.autoShow = false
		display_name_line_edit.focus_mode = Control.FOCUS_NONE
	else:
		# For non mobile devices user will enter text in the input normally
		keyboard_enabled = false
		onscreen_keyboard.autoShow = false
		
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
	if display_name_line_edit.text.length() == 0:
		_show_display_name_message("A display name is required")
		return
	_show_overlay(true)
	_show_onscreen_keyboard(false)
	
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

# The onscreen keyboard addon calls get_tree().input_event(inputEventKey) whenever
# key is pressed.  This function handles the input and manually updates the display
# name input.  We need to do this as the display name input is no longer being focussed
# to prevent the virtual keyboard appearing on mobile devices
func _unhandled_input(event):
	# Check if it's a key press and not already handled
	if event is InputEventKey and event.pressed:	
		if event.scancode == KEY_BACKSPACE:
			display_name_line_edit.text = display_name_line_edit.text.left(display_name_line_edit.text.length() - 1)
			display_name_line_edit.caret_position = display_name_line_edit.text.length()
		elif event.scancode == KEY_ENTER:
			_toggle_onscreen_keyboard()
		else:
			var character = char(event.unicode)
			display_name_line_edit.text += character
			# Move caret to the end
			display_name_line_edit.caret_position = display_name_line_edit.text.length() 

func _toggle_onscreen_keyboard() -> void:
	_show_onscreen_keyboard(!keyboard_visible)
	
func _show_onscreen_keyboard(show:bool) -> void:
	if !keyboard_enabled:
		return 
		
	if show:
		onscreen_keyboard.show()
	else:
		onscreen_keyboard.hide()
	
func _on_DisplayNameLineEdit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			yield(get_tree().create_timer(0.1), "timeout")
			if display_name_line_edit.text != "":
				_toggle_onscreen_keyboard()
			else:
				# Don't toggle the keyboard if the text input is empty (most likely due to clear button pressed)
				# Keep it open
				_show_onscreen_keyboard(true)
	
			
func _on_OnscreenKeyboard_visibilityChanged(visible):
	keyboard_visible = visible

