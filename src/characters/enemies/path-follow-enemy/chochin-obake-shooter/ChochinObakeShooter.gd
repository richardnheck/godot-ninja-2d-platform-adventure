extends PathFollowEnemyBase
class_name ChochinObakeShooter

onready var shoot_timer = $ShootTimer
onready var sprite = $Area2D/AnimatedSprite

enum Orientation {
	HORIZONTAL_LEFT_RIGHT = 0,
	HORIZONTAL_RIGHT_LEFT = 1,
}

export(int) var path_length = 100
export(Orientation) var orientation = Orientation.HORIZONTAL_LEFT_RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 30
	self.tween_transition_type = TransitionType.TRANS_SINE
	self.follow_path_type = FollowPathType.PING_PONG
	
	self.oscillation_amplitude = 2
	self.oscillation_frequency = 5
		
	var half_length_straight = path_length/2  # this is for verical and horizontal curves
	
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
	self.path2d.set_curve(curve) 


func _on_ShootTimer_timeout():
	_drop_candle()

func _drop_candle():
	var candle = preload("res://src/characters/enemies/path-follow-enemy/chochin-obake-shooter/falling-candle/FallingCandle.tscn").instance()
	candle.global_position = Vector2(sprite.global_position.x-8, sprite.global_position.y)
	get_parent().add_child(candle)
	if candle.has_method("trigger"):
		candle.trigger()
