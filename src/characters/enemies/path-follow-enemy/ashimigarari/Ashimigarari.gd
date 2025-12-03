tool
class_name Ashimigarari
extends PathFollowEnemyBase

onready var area2d = $Area2D
onready var collision_shape = $Area2D/CollisionShape2D

enum Orientation {
	HORIZONTAL_LEFT_RIGHT = 0,
	HORIZONTAL_RIGHT_LEFT = 1,
	VERTICAL_BOTTOM_UP = 2,
	VERTICAL_TOP_DOWN = 3,
}

enum HorizontalWallDirection {
	UP,
	DOWN	
}

enum VerticalWallDirection {
	LEFT,
	RIGHT
}


export(int) var path_length = 100
export(Orientation) var orientation = Orientation.HORIZONTAL_LEFT_RIGHT
export(HorizontalWallDirection) var horizontal_wall_direction = HorizontalWallDirection.DOWN   # default is ground
export(VerticalWallDirection) var vertical_wall_direction = VerticalWallDirection.RIGHT   # default is right wall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 25
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.PING_PONG
		
	var half_length_straight = path_length/2  # this is for verical and horizontal curves
	
	var curve = Curve2D.new()
	if orientation == Orientation.HORIZONTAL_LEFT_RIGHT:
		collision_shape.rotation_degrees = 90
		if horizontal_wall_direction == HorizontalWallDirection.UP:
			animated_sprite.flip_v = true
			
		curve.add_point(Vector2(-half_length_straight,0))
		curve.add_point(Vector2(half_length_straight, 0))
	elif orientation == Orientation.HORIZONTAL_RIGHT_LEFT:
		collision_shape.rotation_degrees = 90
		if horizontal_wall_direction == HorizontalWallDirection.UP:
			animated_sprite.flip_v = true
		
		animated_sprite.flip_h = not animated_sprite.flip_h
		curve.add_point(Vector2(half_length_straight,0))
		curve.add_point(Vector2(-half_length_straight, 0))
	elif orientation == Orientation.VERTICAL_BOTTOM_UP:
		animated_sprite.rotation_degrees = 90
		animated_sprite.flip_h = false
		if vertical_wall_direction == VerticalWallDirection.RIGHT:
			animated_sprite.flip_v = true
			
		curve.add_point(Vector2(0, half_length_straight))
		curve.add_point(Vector2(0,-half_length_straight))
	elif orientation == Orientation.VERTICAL_TOP_DOWN:
		animated_sprite.rotation_degrees = 90
		if vertical_wall_direction == VerticalWallDirection.RIGHT:
			animated_sprite.flip_v = true
		
		curve.add_point(Vector2(0, -half_length_straight))
		curve.add_point(Vector2(0,half_length_straight))	
	self.path2d.set_curve(curve)
