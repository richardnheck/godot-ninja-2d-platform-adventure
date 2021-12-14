extends RigidBody2D

export var max_impulse := 2000.0

var direction := Vector2.RIGHT setget set_direction
var impulse := 1000.0 setget set_impulse

onready var _sprite := $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node) -> void:
	print("body entered")
	if body.is_in_group(Constants.GROUP_PLAYER):
		print("body entered")
		body.die()


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction


func set_impulse(new_impulse: float) -> void:
	apply_central_impulse(direction * new_impulse)


func _on_Timer_timeout() -> void:
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
