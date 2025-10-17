extends PathFollowEnemyBase

# Fix to ensure head is facing in the correct direction if the path starts
# from right to left
export(bool) var flip_sprite = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 40
	self.tween_transition_type = TransitionType.TRANS_SINE
	self.follow_path_type = FollowPathType.PING_PONG
	
	self.oscillation_amplitude = 5
	self.oscillation_frequency = 10
	
	animated_sprite.flip_h = flip_sprite
