class_name ZenchuuNoHikari
extends PathFollowEnemyBase

onready var sprite = $Area2D/AnimatedSprite

enum Orientation {
	VERTICAL_BOTTOM_UP = 0,
	VERTICAL_TOP_DOWN = 1,
}

export(int) var path_length = 100
export(Orientation) var orientation = Orientation.VERTICAL_TOP_DOWN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 30
	self.tween_transition_type = TransitionType.TRANS_QUAD
	self.follow_path_type = FollowPathType.PING_PONG
		
	var half_length_straight = path_length / 2  # this is for vertical and horizontal curves
	
	var curve = Curve2D.new()
	if orientation == Orientation.VERTICAL_BOTTOM_UP:
		curve.add_point(Vector2(0, half_length_straight))
		curve.add_point(Vector2(0,-half_length_straight))
	elif orientation == Orientation.VERTICAL_TOP_DOWN:
		curve.add_point(Vector2(0, -half_length_straight))
		curve.add_point(Vector2(0,half_length_straight))
	self.path2d.set_curve(curve) 

func _on_tween_completed(object: Object, key: NodePath) -> void:
	# For vertical paths don't horizontally flip the sprite, but instead vertically flip it
	._on_tween_completed(object,key)
	animated_sprite.flip_h = false
	animated_sprite.flip_v = not animated_sprite.flip_v
	if animated_sprite.flip_v:
		animated_sprite.offset.y = -20
	else:
		animated_sprite.offset.y = 0
