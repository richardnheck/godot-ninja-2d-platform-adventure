extends Node2D
class_name PathFollowEnemyBase

enum TransitionType {
	TRANS_LINEAR = 0, 	#The animation is interpolated linearly.
	TRANS_SINE = 1, 		#The animation is interpolated using a sine function.
	TRANS_QUINT = 2, # The animation is interpolated with a quintic (to the power of 5) function.
	TRANS_QUART = 3,  # The animation is interpolated with a quartic (to the power of 4) function.
	TRANS_QUAD = 4,  # The animation is interpolated with a quadratic (to the power of 2) function.
	TRANS_EXPO = 5,  # The animation is interpolated with an exponential (to the power of x) function.
	TRANS_ELASTIC = 6, # The animation is interpolated with elasticity, wiggling around the edges.
	TRANS_CUBIC = 7,  # The animation is interpolated with a cubic (to the power of 3) function.
	TRANS_CIRC = 8,  # The animation is interpolated with a function using square roots.
	TRANS_BOUNCE = 9,  # The animation is interpolated by bouncing at the end.
	TRANS_BACK = 10  # The animation is interpolated backing out at ends.
}

enum FollowPathType {
	PING_PONG = 0, 		  # Goes back and forth on the path
	CONTINUOUS = 1,	  # Follows the path then resets back to the start and continues
	ONCE = 2			  # Follows the path and stops when it reaches the end
}

# Speed of movement (pixels/sec)
# Based on length on the length of the Path 2D curve
export(float) var speed: float = 32

# The Tween Transition Type
export(TransitionType) var tween_transition_type = TransitionType.TRANS_SINE

# The Follow Path Type (ping-pong or continuous)
export(FollowPathType) var follow_path_type = FollowPathType.PING_PONG

# The offset 0-1 along the path. 0.5 starts half way
export(float, 0, 1, 0.1) var offset = 0

# The delay before enemy starts moving
export(float) var delay:float = 0

export(float) var oscillation_amplitude:float = 0
export(float) var oscillation_frequency:float = 0

onready var tween = $Tween
onready var path2d = $Path2D
onready var path_follow_2d = $Path2D/PathFollow2D
onready var animated_sprite = $Area2D/AnimatedSprite
onready var oscillation_tween = $OscillationTween

onready var tween_values = [0, 1]

var current_tween_offset = 0;

var start:bool = true

# For oscillation
var time_passed:float = 0.0
var initial_position_y:float

# Indicates whether object is following the path
var following_path = true

# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:		
	initial_position_y = self.position.y
	
	tween.connect("tween_completed", self, "_on_tween_completed")
	
	if delay > 0:
		# Wait for the delay period before starting the movement
		animated_sprite.playing = false
		yield(get_tree().create_timer(delay), "timeout")
		animated_sprite.playing = true
		call_deferred("start_tween")
	else:
		# Start the movement immediately though defer to allow for sub classes to override exported vars
		call_deferred("_start_tween")


# Stop following the path
func stop_following_path() -> void:
	following_path = false
	tween.stop_all()


# Start following path at a specified offset
func start_following_path(start_offset):
	offset = start_offset
	start = true     # Set start so the position is initialized based on an offset
	following_path = true
	call_deferred("_start_tween")


func _process(delta: float) -> void:
	_check_position()
	
	#-------------
	# Vertical Oscillation
	if oscillation_amplitude > 0:
		time_passed += delta
		self.position.y = initial_position_y + oscillation_amplitude * cos(time_passed * oscillation_frequency)
	#-------------
	
func _check_position() -> void:
	pass	
	

func _start_tween():
	if path2d.curve:
		var curve_length = path2d.curve.get_baked_length() 
		
		# Calculate time to travel the length of path 2d curve
		var time = curve_length / speed
		
		# Apply the offset only for the start movement
		var tween_offset = 0
		if start:
			start = false
			if offset < 1:
				tween_offset = offset
				
				time = (curve_length - offset*curve_length) / speed
			else:
				# When offset = 1 it means start from the other end
				tween_values.invert()
				
				# Need to flip the sprite as we are starting from the other end in the opposite direction
				animated_sprite.flip_h = true
				
		tween.interpolate_property(path_follow_2d, "unit_offset", tween_values[0] + tween_offset, tween_values[1], time, tween_transition_type, Tween.EASE_IN_OUT)
		tween.start()	
	

# Get the current offset of the tween
func _get_current_offset() -> int:
	return path_follow_2d.unit_offset;


func _on_tween_completed(object: Object, key: NodePath) -> void:
	if follow_path_type == FollowPathType.PING_PONG:
		tween_values.invert()
		animated_sprite.flip_h = not animated_sprite.flip_h 
		_start_tween()
	elif follow_path_type == FollowPathType.CONTINUOUS:
		_start_tween()
	elif follow_path_type == FollowPathType.ONCE:
		following_path = false


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_DelayTimer_timeout() -> void:
	_start_tween()
