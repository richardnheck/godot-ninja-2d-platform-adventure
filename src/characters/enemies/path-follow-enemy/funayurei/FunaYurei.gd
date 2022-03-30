extends PathFollowEnemyBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 20
	self.tween_transition_type = TransitionType.TRANS_SINE
	self.follow_path_type = FollowPathType.PING_PONG
	
	self.oscillation_amplitude = 30
	self.oscillation_frequency = 4
