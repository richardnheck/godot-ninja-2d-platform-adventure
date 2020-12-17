extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CutSceneBase.connect("on_continue", self, "_on_continue")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_continue()->void:
	$CutSceneBase.goto_next_scene()
