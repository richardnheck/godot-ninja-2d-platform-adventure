tool  # Make a tool so the path is visible
class_name ShardLantern
extends PathFollowEnemyBase

enum MODE { TIMED }

# The direction the shards shoot
enum ShootDirection { UP, DOWN, LEFT, RIGHT}

# Movement Orientation
enum Orientation {
	STATIONARY = 0
	VERTICAL_BOTTOM_UP = 1
	VERTICAL_TOP_DOWN = 2,
	HORIZONTAL_LEFT_RIGHT = 3,
	HORIZONTAL_RIGHT_LEFT = 3,
}

export(Orientation) var orientation = Orientation.VERTICAL_TOP_DOWN
export(int) var path_length = 100
export (ShootDirection) var shoot_direction := ShootDirection.RIGHT

# The spread (in degress) of the shards
export (int) var spread := 45

export (PackedScene) var bullet_scene = preload("res://src/characters/enemies/path-follow-enemy/shard-lantern/shard/Shard.tscn")
export var shoot_rate := 2
export var delay_time := 0.00
export (MODE) var mode := MODE.TIMED

onready var shoot_timer = $ShootTimer
onready var delay_timer := $DelayTimer
onready var shoot_position := $Area2D/ShootPosition
onready var sprite = $Area2D/AnimatedSprite

var direction:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 30
	self.tween_transition_type = TransitionType.TRANS_SINE
	self.follow_path_type = FollowPathType.PING_PONG
	
	self.oscillation_amplitude = 0
	self.oscillation_frequency = 0
	
	if shoot_direction == ShootDirection.UP:
		direction = Vector2(0,-1)
	elif shoot_direction == ShootDirection.DOWN:
		direction = Vector2(0, 1)
	elif shoot_direction == ShootDirection.LEFT:
		direction = Vector2(-1, 0)
	elif shoot_direction == ShootDirection.RIGHT:
		direction = Vector2(1, 0)
			
	var half_length_straight = path_length/2  # this is for verical and horizontal curves
	
	var curve = Curve2D.new()
	if orientation == Orientation.VERTICAL_BOTTOM_UP:
		curve.add_point(Vector2(0, half_length_straight))
		curve.add_point(Vector2(0,-half_length_straight))
	elif orientation == Orientation.VERTICAL_TOP_DOWN:
		curve.add_point(Vector2(0, -half_length_straight))
		curve.add_point(Vector2(0,half_length_straight))
	elif orientation == Orientation.HORIZONTAL_LEFT_RIGHT:
		curve.add_point(Vector2(-half_length_straight,0))
		curve.add_point(Vector2(half_length_straight, 0))
	elif orientation == Orientation.HORIZONTAL_RIGHT_LEFT:
		curve.add_point(Vector2(half_length_straight,0))
		curve.add_point(Vector2(-half_length_straight, 0))
	elif orientation == Orientation.STATIONARY:
		self.stop_following_path()
		pass
	self.path2d.set_curve(curve) 
	
	_initialize_gun()


func _initialize_gun() -> void:
	if mode == MODE.TIMED:
		shoot_timer.wait_time = shoot_rate
		if delay_time == 0:
			yield(get_tree().create_timer(0), "timeout")	# Need to wait for the next frame for something to be ready, otherwise it doesn't work
			_shoot()
		else:
			delay_timer.wait_time = delay_time
			delay_timer.start()
	else:
		shoot_timer.wait_time = shoot_rate
	randomize()

# Shoot 3 shards in a spread
# Pause for a moment when shooting the shards
func _shoot():
	if Engine.editor_hint:
		# Don't shoot in the editor
		return

#	pause_following_path()
#	yield(get_tree().create_timer(0.25), "timeout")
			
	shoot_timer.wait_time = shoot_rate
	shoot_timer.start()

	# Shoot three shards in a spread
	_add_bullet(direction.rotated(deg2rad(spread/2)))
	_add_bullet(direction)
	_add_bullet(direction.rotated(deg2rad(-spread/2)))
#	yield(get_tree().create_timer(0.25), "timeout")
#	unpause_following_path()

func _add_bullet(direction):
	var bullet = bullet_scene.instance()
	bullet.direction = direction
	Projectiles.add_child(bullet)
	bullet.global_position = shoot_position.global_position
	return bullet

func _can_shoot() -> bool:
	return shoot_timer.is_stopped()


func _on_ShootTimer_timeout() -> void:
	if mode == MODE.TIMED:
		_shoot()


func _on_DelayTimer_timeout() -> void:
	_shoot()
