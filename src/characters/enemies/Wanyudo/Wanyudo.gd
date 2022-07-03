extends PathFollowEnemyBase

onready var path = $Path2D

onready var fireball_spawner = $Area2D/HomingFireballSpawner

# Phase1 - Boss follows a path and throws homing fireball missiles
const STATE_PHASE1:String = "phase1"

# Phase2 - Boss hovers above player and shoots fireballs down at the player
const STATE_PHASE2_TRANSITION:String = "phase2_transition"
const STATE_PHASE2:String = "phase2"

var state = STATE_PHASE1

var player = null

const SPEED:int = 75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = self.SPEED    	# 75 = good speed   (100 = speed of player)
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.ONCE		# Stop when it reaches the end of the path
	
	self.oscillation_amplitude = 5
	self.oscillation_frequency = 10
	
	# Connect to the event indicating when the fireball is destroyed
	fireball_spawner.connect("fireball_destroyed", self, "_on_fireball_destroyed")
	
	# Delay initially before shooting the first fireball
	if state == STATE_PHASE1:
		yield(get_tree().create_timer(0.3), "timeout")
		_shoot_fireball()
	

var current_offset = 0
func _check_position() -> void:
	if state == STATE_PHASE1:
		# Since Wanyudo is a path follow enemy its actual position is the Area2D which has its
		# postion changed by the path.
		var boss_pos = self.get_node("Area2D").position.x
		if player and player.position.x < boss_pos - 5:
			# Prevent the boss from continuing if it passes the player
			# In this case stop following the path
			current_offset = _get_current_offset()
			stop_following_path()
		elif player and player.position.x > boss_pos + 100:
			if not tween.is_active():
				# Player is ahead so continue following the path and start shooting again
				start_following_path(current_offset)
				yield(get_tree().create_timer(1), "timeout")
				_shoot_fireball()
			

# Set the reference to the player
func set_player(player_ref) -> void:
	player = player_ref
	fireball_spawner.set_target(player)


# Go to the next phase
func goto_next_phase() -> void:
	print("Wanyudo: transition to next state")
	
	# Phase 2 transition
	# Wanyudo goes to the near end of the path and then floats
	# down above the player
	state = STATE_PHASE2_TRANSITION
	stop_following_path()     	# stop following initially
	yield(get_tree().create_timer(0.3), "timeout")
	start_following_path(0.96)	# start following path from near the end
	yield(get_tree().create_timer(1), "timeout")

#	# When in Phase 2 do not follow the path any longer
#	# Make the fireballs not homing missiles
#	# They are just fired at the player's current position
	state = STATE_PHASE2
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


# Shoot a fireball
func _shoot_fireball() -> void:
	# Only shoot a fireball when the boss is chasing the plaer
	# If the player is behind the boss the don't try and shoot the player	
	if following_path:
		fireball_spawner.shoot()					
	
	
# Shoot another fireball once the previous fireball lifetime runs out	
func _on_fireball_destroyed(): 
	_shoot_fireball()
