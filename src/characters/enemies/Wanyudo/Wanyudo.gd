extends PathFollowEnemyBase

signal phase_changed(phase)

onready var path = $Path2D
onready var homing_fireball_spawner = $Area2D/HomingFireballSpawner
onready var normal_fireball_spawner = $Area2D/NormalFireballSpawner
onready var mini_wanyudo_spawn_timer = $MiniWanyudoSpawnTimer

# Phase1 - Boss follows a path and throws homing fireball missiles
const STATE_PHASE1:String = "phase1"

# Phase2 - Boss hovers above player and shoots fireballs down at the player
const STATE_PHASE2_TRANSITION:String = "phase2_transition"
const STATE_PHASE2:String = "phase2"

var state = STATE_PHASE1

var player = null
var ceiling_position:Position2D = null

const SPEED:int = 65

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# override defaults
	self.speed = self.SPEED    	# 75 = good speed   (100 = speed of player)
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.ONCE		# Stop when it reaches the end of the path
	
	self.oscillation_amplitude = 5
	self.oscillation_frequency = 10
		
	# Connect to the event indicating when the fireball is destroyed
	# NB: We don't need to do this for normal fireballs as the spawner handles the shoot timing
	homing_fireball_spawner.connect("fireball_destroyed", self, "_on_fireball_destroyed")
	self.connect("phase_changed", homing_fireball_spawner, "_on_phase_changed")
		
	# Initially homing fireballs are the default
	homing_fireball_spawner.enabled = true
	normal_fireball_spawner.enabled = false
	
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
			homing_fireball_spawner.enabled = false
			
			# Enable the normal fireball spawner and it will control the shooting
			normal_fireball_spawner.enabled = true
		elif player and player.position.x > boss_pos + 100:
			if not tween.is_active():
				# Player is ahead so continue following the path and start shooting again
				homing_fireball_spawner.enabled = true
				normal_fireball_spawner.enabled = false
				
				start_following_path(current_offset)
				yield(get_tree().create_timer(1), "timeout")
				_shoot_fireball()
			

# Set the reference to the player
func set_player(player_ref) -> void:
	print("setting player")
	player = player_ref
	homing_fireball_spawner.set_target(player)
	normal_fireball_spawner.set_target(player)
	

# Go to the next phase
func goto_next_phase() -> void:
	print("Wanyudo: transition to next state")
	
	# Phase 2 transition
	# Stop firing fireballs
	state = STATE_PHASE2_TRANSITION
	homing_fireball_spawner.enabled = false
	normal_fireball_spawner.enabled = false
	
#	# Phase 2 
	# In this phase Wanyudo continues along path, but now spawns
	# mini wanyudo's that fall above the player
	state = STATE_PHASE2
	
	print(">>>> Emitting phase_changed")
	emit_signal("phase_changed", state)
	
	# Start spawning mini wanyudo's via the array spawner
	_spawn_falling_mini_wanyudo_array()
	self.mini_wanyudo_spawn_timer.start()
	
	# Readjust the position now that it is no longer following the path
	# Get the position of the last point
#	var numPoints = path.curve.get_point_count()
#	var pointPosition = path.curve.get_point_position(numPoints-1)
#	var globalPointPosition = pointPosition + path.position
#	var pos = globalPointPosition.x
	
#	var pos = 3352		# TODO: Get position of last point in curve instead of hardcoding (above code doesn't work)
#	position.x = pos   		
#	path_follow_2d.unit_offset = 0		# reset the offset from following the path
#	homing_fireball_spawner.enabled = false
#	normal_fireball_spawner.enabled = true
	
	# Wait a few moments before firing the first fireballs
#	yield(get_tree().create_timer(1), "timeout")
	
#	_shoot_fireball()
	

var follow_speed = 1	    # speed of follow. The higher the value the faster he follows
var position_offset = 50    # Set a larger value for Wanyudo to be ahead of player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:	
		STATE_PHASE2:
			pass
			# Follow the player and hover above
#			position.x = lerp(position.x, player.position.x + position_offset, delta * follow_speed ) 
#			position.y = lerp(position.y, 14, delta) + 0.75 * cos(time_passed * oscillation_frequency)
#
#			time_passed += delta


# Shoot a fireball
func _shoot_fireball() -> void:
	if state == STATE_PHASE1:
		# Shoot homing fireballs when the boss is chasing the plaer
		# If the player is behind the boss then shoot normal fireballs to kill
		# the player quickly as it means they have lost
		if following_path:
			print_debug("Shoot Homing fireball")
			homing_fireball_spawner.shoot()
		else:
			print_debug("Shoot normal fireball")
			normal_fireball_spawner.shoot()					
	elif state == STATE_PHASE2:
		pass
	
# Shoot another fireball once the previous fireball lifetime runs out	
func _on_fireball_destroyed(): 
	_shoot_fireball()
	

# Set the position of the ceiling
# This position is used to place the mini wanyudo array in the scene
func set_ceiling_position(ceiling_pos):
	ceiling_position = ceiling_pos;	
	
func _spawn_falling_mini_wanyudo_array() -> void:
	var array_instance = preload("res://src/characters/enemies/Wanyudo/FallingMiniWanyudoArray.tscn").instance()
	array_instance.connect("finished", self, "_on_falling_spikes_finished")
	var spikes_width = array_instance.get_width()
	
	
	# get the distance to the player
	var distance_to_player = position.distance_to(player.position)
	print(distance_to_player)
	# place the spikes array directly over the player
	var spikes_offset = distance_to_player
	if player.position.x < position.x:
		# player is behind boss so adjust offset to be in other direction
		spikes_offset *= -1

	# Place so around the player
	# Also place the spikes array on the ceiling
	array_instance.global_position = Vector2(global_position.x + spikes_offset, ceiling_position.global_position.y)
	
	# Using viewport (NB: only works when stretch mode = Viewport)
	#var viewport_height = get_viewport().size.y
	#spikes_instance.global_position = Vector2(global_position.x + spikes_offset, ground_global_position.y - viewport_height + (3*16))
	
	# add the instance and trigger the spikes
	get_parent().add_child(array_instance)

		
func _on_falling_spikes_finished():
	pass
	#if current_state == STATE_UP_DOWN_SLAM:
	#	emit_signal("state_cycle_finished", STATE_UP_DOWN_SLAM)
		#_spawn_falling_spikes_array()	


func _on_MiniWanyudoSpawnTimer_timeout():
	_spawn_falling_mini_wanyudo_array()
