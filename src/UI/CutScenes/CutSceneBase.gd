extends CanvasLayer
class_name CutSceneBase

signal on_continue

onready var fadeScreenScene = preload("res://src/UI/FadeScreen/FadeScreen.tscn")
onready var screenShakeScene = preload("res://src/objects/camera-effects/ScreenShake.tscn")

var fadeScreen:FadeScreen
var screenShake:ScreenShake

export (String) var skip_to_scene_path

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
	

func _on_SkipButton_button_down() -> void:
	self.goto_next_scene()


func _on_ContinueButton_button_up() -> void:
	emit_signal("on_continue")

