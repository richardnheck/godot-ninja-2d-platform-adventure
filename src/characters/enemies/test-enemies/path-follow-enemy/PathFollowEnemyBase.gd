extends Node2D

enum TransitionType {
	TRANS_LINEAR = 0, #The animation is interpolated linearly.
	TRANS_SINE = 1 #The animation is interpolated using a sine function.
}

enum FollowPathType {
	PING_PONG = 0, 
	CONTINUOUS = 1 
}

# Time to move along path in one direction
export(float) var time: float = 1.0

# Export the tween type
export(TransitionType) var tween_transition_type = TransitionType.TRANS_SINE

export(FollowPathType) var follow_path_type = FollowPathType.PING_PONG

onready var tween = $Tween
onready var path_follow_2d = $Path2D/PathFollow2D
onready var animated_sprite = $Area2D/AnimatedSprite
onready var tween_values = [0, 1]

# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.connect("tween_completed", self, "_on_tween_completed")
	_start_tween()


func _start_tween():
	tween.interpolate_property(path_follow_2d, "unit_offset", tween_values[0], tween_values[1], time, tween_transition_type, Tween.EASE_IN_OUT)
	tween.start()	


func _on_tween_completed(object: Object, key: NodePath) -> void:
	if follow_path_type == FollowPathType.PING_PONG:
		tween_values.invert()
		animated_sprite.flip_h = not animated_sprite.flip_h 
		_start_tween()
	else:
		_start_tween()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
