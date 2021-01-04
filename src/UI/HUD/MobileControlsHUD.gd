extends CanvasLayer

onready var scene_tree: = get_tree()
onready var pause_overlay:ColorRect = $PauseOverlay

var paused: = false setget set_paused

func _ready() -> void:
	pass
	#ause_overlay.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()

func set_paused(value:bool) -> void:
	print ("set_paused: " + str(value))
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	
func _on_PauseButton_button_up() -> void:
	Global.play_pause_sound()	
	self.paused = true


func _on_PausedPlayButton_button_up() -> void:
	Global.play_basic_blip_sound()
	self.paused = false


func _on_RetryButton_button_up() -> void:
	Global.play_basic_blip_sound()
	self.paused = false
	scene_tree.reload_current_scene()


func _on_LeftTouchArea2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print(event) # Replace with function body.


func _on_JumpButtonArea2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("viewport: ", viewport)
	print("event: ", event)
	print("shape_idx: ", shape_idx)
	print("============")
	if (event is InputEventMouseButton && event.pressed):
		print("pressed")


func _on_JumpButtonArea2D_mouse_entered() -> void:
	print("jump mouse entered")


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
