extends PathFollowEnemyBase

onready var path = $Path2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 100    	# Roughly speed of player. 
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.CONTINUOUS
	
	self.oscillation_amplitude = 5
	self.oscillation_frequency = 10
