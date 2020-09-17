extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_JumpButtonArea2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("viewport: ", viewport)
	print("event: ", event)
	print("shape_idx: ", shape_idx)
	print("============")
	if (event is InputEventMouseButton && event.pressed):
		print("pressed")

