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
	self.paused = true


func _on_PausedPlayButton_button_up() -> void:
	self.paused = false


func _on_RetryButton_button_up() -> void:
	self.paused = false
	scene_tree.reload_current_scene()
