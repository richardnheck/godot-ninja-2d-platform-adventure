tool
class_name RedCreepyCrawly
extends PathFollowEnemyBase

onready var area2d = $Area2D
onready var collision_shape = $Area2D/CollisionShape2D

enum Orientation {
	HORIZONTAL_LEFT_RIGHT = 0,
	HORIZONTAL_RIGHT_LEFT = 1,
}

export(int) var path_length = 100
export(Orientation) var orientation = Orientation.HORIZONTAL_LEFT_RIGHT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 40
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.PING_PONG
		
	var half_length_straight = path_length/2  # this is for verical and horizontal curves
	
	var curve = Curve2D.new()
	if orientation == Orientation.HORIZONTAL_LEFT_RIGHT:
		animated_sprite.flip_h = not animated_sprite.flip_h
		curve.add_point(Vector2(-half_length_straight,0))
		curve.add_point(Vector2(half_length_straight, 0))
	elif orientation == Orientation.HORIZONTAL_RIGHT_LEFT:
		curve.add_point(Vector2(half_length_straight,0))
		curve.add_point(Vector2(-half_length_straight, 0))

	self.path2d.set_curve(curve)
