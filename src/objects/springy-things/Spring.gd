extends Area2D

const impulse = 135

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		if body.has_method("spring"):
			body.spring(Vector2(0, impulse))
