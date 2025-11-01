tool
extends PathFollowEnemyBase
class_name ChochinObake

enum Orientation {
	VERTICAL_BOTTOM_UP = 0,
	VERTICAL_TOP_DOWN = 1,
	HORIZONTAL_LEFT_RIGHT = 2,
	HORIZONTAL_RIGHT_LEFT = 3,
	ANGLE_45_BOTTOM_UP = 4,   
	ANGLE_45_TOP_DOWN = 5,
	ANGLE_135_BOTTOM_UP = 6,
	ANGLE_135_TOP_DOWN = 7 
}

export(Orientation) var orientation = Orientation.HORIZONTAL_LEFT_RIGHT
export(int) var path_length = 64

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	# override defaults
	self.speed = 40
	self.tween_transition_type = TransitionType.TRANS_SINE
	self.follow_path_type = FollowPathType.PING_PONG
	
	self.oscillation_amplitude = 2
	self.oscillation_frequency = 5
		
	# The aim is to give a path of roughly 64 pixels in length
	var half_length_straight = path_length / 2  # this is for verical and horizontal curves
	
	var hypotenuse = path_length / 2
	var half_length_45_degrees = hypotenuse / sqrt(2)
	
	var curve = Curve2D.new()
	if orientation == Orientation.HORIZONTAL_LEFT_RIGHT:
		curve.add_point(Vector2(-half_length_straight,0))
		curve.add_point(Vector2(half_length_straight, 0))
	elif orientation == Orientation.HORIZONTAL_RIGHT_LEFT:
		curve.add_point(Vector2(half_length_straight,0))
		curve.add_point(Vector2(-half_length_straight, 0))
	elif orientation == Orientation.VERTICAL_BOTTOM_UP:
		curve.add_point(Vector2(0, half_length_straight))
		curve.add_point(Vector2(0,-half_length_straight))
	elif orientation == Orientation.VERTICAL_TOP_DOWN:
		curve.add_point(Vector2(0, -half_length_straight))
		curve.add_point(Vector2(0,half_length_straight))
	elif orientation == Orientation.ANGLE_45_BOTTOM_UP:
		curve.add_point(Vector2(-half_length_45_degrees, half_length_45_degrees))
		curve.add_point(Vector2(half_length_45_degrees, -half_length_45_degrees))
	elif orientation == Orientation.ANGLE_45_TOP_DOWN:
		curve.add_point(Vector2(half_length_45_degrees, -half_length_45_degrees))
		curve.add_point(Vector2(-half_length_45_degrees, half_length_45_degrees))
	elif orientation == Orientation.ANGLE_135_BOTTOM_UP:
		curve.add_point(Vector2(half_length_45_degrees, half_length_45_degrees))
		curve.add_point(Vector2(-half_length_45_degrees, -half_length_45_degrees))
	elif orientation == Orientation.ANGLE_135_TOP_DOWN:
		curve.add_point(Vector2(-half_length_45_degrees, -half_length_45_degrees))
		curve.add_point(Vector2(half_length_45_degrees, half_length_45_degrees))	
	self.path2d.set_curve(curve) 
