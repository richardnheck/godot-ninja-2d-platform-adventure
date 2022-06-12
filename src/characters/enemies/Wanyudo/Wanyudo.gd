extends PathFollowEnemyBase

onready var path = $Path2D

onready var homing_fireball_spawner = $Area2D/HomingFireballSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 1    	# 100 = roughly speed of player. 
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.CONTINUOUS
	
	self.oscillation_amplitude = 5
	self.oscillation_frequency = 10

var player = null

func set_player(player_ref) -> void:
	player = player_ref
	homing_fireball_spawner.set_target(player)
