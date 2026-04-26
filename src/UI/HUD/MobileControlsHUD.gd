extends CanvasLayer

onready var scene_tree: = get_tree()
onready var pause_overlay:ColorRect = $PauseOverlay
onready var left_touch_screen_button = $Control/HBoxContainerLeft/LeftTouchScreenButton
onready var right_touch_screen_button = $Control/HBoxContainerLeft/RightTouchScreenButton
onready var jump_touch_screen_button = $Control/HBoxContainerRight/JumpTouchScreenButton
onready var pause_button = $Control/PauseButton
onready var hud_key = $Control/Key
onready var level_timer := $"%LevelTimer"
onready var show_level_timer_button = $"%ShowLevelTimerOnOffButton"

var paused: = false setget set_paused

func _ready() -> void:
	# Ensure that the pause overlay is always hidden
	pause_overlay.visible = false
	
	# Listen for control changes in the settings
	Settings.connect("controls_changed", self, "_on_controls_changed")
	
	# Update controls from settings to get initial values
	_on_controls_changed()
	
	# Listen for key status changes in LevelData
	hud_key.visible = LevelData.has_key 	# default value in LevelData
	LevelData.connect("key_status_changed", self, "_on_key_status_changed")
	
	#timer_label.visible = Settings.get_show_level_timer_enabled()
	#time_status_label.visible = false
# 
# Handle when controls in the settings are changed
#	
func _on_controls_changed() -> void:
	var controls_visible = Settings.touch_screen_controls_visible
	_show_touch_screen_controls(controls_visible)

# Handle when the key status has changed
func _on_key_status_changed(has_key: bool) -> void:
	# Show the hud key if the player has the key
	hud_key.visible = has_key

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()


func set_paused(value:bool) -> void:
	print ("set_paused: " + str(value))
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	
	if paused:
		# Set the current level select screen	
		var backButton = get_node("%BigBackButton")
		backButton.next_scene_path = LevelData.get_current_world_level_select_scene()
	
		# update controls that rely on the settings
		# NB: Volume sliders are components that update their own values so not required here
		show_level_timer_button.set_on(Settings.get_show_level_timer_enabled())	
	
func _on_PauseButton_pressed() -> void:
	Game_AudioManager.sfx_ui_pause.play()
	
	# Hide the pause button so it does confuse user when pause screen is showing
	pause_button.visible = false
		
	# Pause	
	self.paused = true


func _on_CloseButton_pressed() -> void:
	_on_PausedPlayButton_pressed()

# Set the time status indicating difference in time from their current best time
func set_level_time_status(message:String) -> void:
	level_timer.set_status(message)

# Get the current formatted time shown by the level timer
func get_level_time_formatted() -> String:
	return level_timer.get_time_formatted()

func _show_touch_screen_controls(controls_visible:bool):
	left_touch_screen_button.visible = controls_visible
	right_touch_screen_button.visible = controls_visible
	jump_touch_screen_button.visible = controls_visible
	
	
func _on_PausedPlayButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()	
	
	# Show the pause button again when leaving pause
	pause_button.visible = true
	
	# Unpause
	self.paused = false


func _on_RetryButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	self.paused = false
	scene_tree.reload_current_scene()
	LevelData.is_reload = false


func _on_LeftTouchArea2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass


func _on_JumpButtonArea2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass


func _on_JumpButtonArea2D_mouse_entered() -> void:
	pass


func _on_TextureRect_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):
		var ev = InputEventAction.new()
		ev.action = "jump"
		ev.pressed = true
		Input.parse_input_event(ev)
	if (event is InputEventMouseButton && !event.pressed):
		var ev = InputEventAction.new()
		ev.action = "jump"
		ev.pressed = false
		Input.parse_input_event(ev)


func _on_LeftButton_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):
		var ev = InputEventAction.new()
		ev.action = "move_left"
		ev.pressed = true
		Input.parse_input_event(ev)
	if (event is InputEventMouseButton && !event.pressed):
		var ev = InputEventAction.new()
		ev.action = "move_left"
		ev.pressed = false
		Input.parse_input_event(ev)

func _on_RightButton_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):
		var ev = InputEventAction.new()
		ev.action = "move_right"
		ev.pressed = true
		Input.parse_input_event(ev)
	if (event is InputEventMouseButton && !event.pressed):
		var ev = InputEventAction.new()
		ev.action = "move_right"
		ev.pressed = false
		Input.parse_input_event(ev)

func _on_ShowLevelTimerOnOffButton_button_pressed(on):
	Settings.set_show_level_timer_enabled(on)
	level_timer.visible = on
