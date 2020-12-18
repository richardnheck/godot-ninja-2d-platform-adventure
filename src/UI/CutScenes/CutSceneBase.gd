extends CanvasLayer
class_name CutSceneBase

signal on_continue

onready var fadeScreenScene = preload("res://src/UI/FadeScreen/FadeScreen.tscn")
onready var screenShakeScene = preload("res://src/objects/camera-effects/ScreenShake.tscn")
onready var skip_button = $Control/SkipButton
onready var continue_button = $Control/ContinueButton

var fadeScreen:FadeScreen
var screenShake:ScreenShake

export (String, FILE) var skip_to_scene_path

func _get_configuration_warning() -> String:
	return "skip_to_scene_path must be set" if skip_to_scene_path == "" else ""

func _ready() -> void:
	fadeScreen = fadeScreenScene.instance()
	add_child(fadeScreen)
	
	# Add the screen shake scene
	screenShake = screenShakeScene.instance()
	add_child(screenShake)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func goto_next_scene() -> void:
	fadeScreen.go_to_scene(skip_to_scene_path)
	
# Show/Hide the continue button/message
func show_continue(visible)->void:
	continue_button.visible = visible


func _on_SkipButton_button_down() -> void:
	self.goto_next_scene()


func _on_ContinueButton_button_up() -> void:
	self.do_continue()

func _on_ClickRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			self.do_continue()

func do_continue():
	emit_signal("on_continue")
