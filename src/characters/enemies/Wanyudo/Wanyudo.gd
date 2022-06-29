extends PathFollowEnemyBase

onready var path = $Path2D

onready var fireball_spawner = $Area2D/HomingFireballSpawner

# Phase1 - Boss follows a path and throws homing fireball missiles
const STATE_PHASE1:String = "phase1"

# Phase2 - Boss hovers above player and shoots fireballs down at the player
const STATE_PHASE2:String = "phase2"

var state = STATE_PHASE1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = 80    	# 100 = roughly speed of player. 
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.CONTINUOUS
	
	self.oscillation_amplitude = 5
	self.oscillation_frequency = 10
	
	# TEMP code to develop phase 2
	if state == STATE_PHASE2:
		# Need to delay a bit otherwise it is stopped but then started again
		yield(get_tree().create_timer(0.1), "timeout")
		goto_next_phase()

var player = null

# Set the reference to the player
func set_player(player_ref) -> void:
	player = player_ref
	fireball_spawner.set_target(player)


# Go to the next phase
func goto_next_phase() -> void:
	print("Wanyudo: transition to next state")
	state = STATE_PHASE2
	
	# When in Phase 2 do not follow the path any longer
	stop_following_path()
	
	# Make the fireballs not homing missiles
	# They are just fired at the player's current position
	fireball_spawner.homing = false
	

var follow_speed = 1   # speed of follow. The higher the value the faster he follows
var position_offset = 50    # Set a larger value for Wanyudo to be ahead of player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:	
		STATE_PHASE2:
			# This works quite well
			position.x = lerp(position.x, player.position.x + position_offset, delta * follow_speed ) 
			position.y = oscillation_amplitude * cos(time_passed * oscillation_frequency)
			
			# Doesn't work, must stays in middle at start and doesn't follow screen
			#var center = get_viewport_rect().size * Vector2(0.5, 0.5)
			#position.y = 0
			#position.x = center.x
			
			#position.x = (get_viewport_rect().size.x / 2) + cos(time_passed * 0.5) * 100
			#position.x = player.get_node("Pivot/CameraOffset/Camera2D").position.x
			time_passed += delta
			
			
