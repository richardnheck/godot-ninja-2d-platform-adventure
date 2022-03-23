extends Node2D

enum TransitionType {
	TRANS_LINEAR = 0, #The animation is interpolated linearly.
	TRANS_SINE = 1 #The animation is interpolated using a sine function.
}

enum FollowPathType {
	PING_PONG = 0, 
	CONTINUOUS = 1 
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

onready var tween = $Tween
onready var path2d = $Path2D
onready var path_follow_2d = $Path2D/PathFollow2D
onready var animated_sprite = $Area2D/AnimatedSprite
onready var oscillation_tween = $OscillationTween

onready var tween_values = [0, 1]

var start:bool = true

# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:		
	tween.connect("tween_completed", self, "_on_tween_completed")
	
	
	
	if delay > 0:
		# Wait for the delay period before starting the movement
		animated_sprite.playing = false
		yield(get_tree().create_timer(delay), "timeout")
		animated_sprite.playing = true
		_start_tween()
	else:
		# Start the movement immediately
		_start_tween()

#-------------
# Oscillation experiment
var frequency = 5.0
var amplitude = 20.0
var time_passed:float = 0.0
#------------
func _process(delta: float) -> void:
	
	#-------------
	# Oscillation experiment
	if oscillation_amplitude > 0:
		time_passed += delta
		var vert_offset = amplitude * 4
		#self.position.y = amplitude * cos(path_follow_2d.unit_offset*frequency) + vert_offset
		self.position.y = amplitude * cos(time_passed*frequency) + vert_offset
	#-------------
	

func _start_tween():
	print("start tween")
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


func _on_DelayTimer_timeout() -> void:
	_start_tween()
