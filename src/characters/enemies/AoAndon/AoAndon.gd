class_name AoAndon
extends PathFollowEnemyBase

signal phase_changed(phase)

onready var path = $Path2D
onready var homing_shard_lantern_spawner = $Area2D/HomingShardLanternSpawner
onready var normal_fireball_spawner = $Area2D/NormalFireballSpawner
onready var lantern_spawn_timer = $LanternSpawnTimer

# Phase1 - Boss follows a path and throws homing lantern shard lanterns
const STATE_PHASE1:String = "phase1"

# Phase2 - Boss spawns laser lanterns above the player at intervals
const STATE_PHASE2_TRANSITION:String = "phase2_transition"
const STATE_PHASE2:String = "phase2"

var state = STATE_PHASE1

var player = null
var ceiling_position:Position2D = null

const SPEED:int = 75

# The delay to wait after a homing lantern finishes before spawning a new one
const SHOOT_DELAY:float = 1.0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	
	# override defaults
	self.speed = self.SPEED    	# 75 = good speed   (100 = speed of player)
	self.tween_transition_type = TransitionType.TRANS_LINEAR
	self.follow_path_type = FollowPathType.ONCE		# Stop when it reaches the end of the path
	
	self.oscillation_amplitude = 5
	self.oscillation_frequency = 10
 
	# Connect to the event indicating when the lantern is destroyed
	# NB: We don't need to do this for normal lanterns as the spawner handles the shoot timing
	homing_shard_lantern_spawner.connect("lantern_destroyed", self, "_on_lantern_destroyed")
	self.connect("phase_changed", homing_shard_lantern_spawner, "_on_phase_changed")
		
	# Initially homing lanterns are the default
	homing_shard_lantern_spawner.enabled = true
	normal_fireball_spawner.enabled = false
	
	# Delay initially before shooting the first lantern
	if state == STATE_PHASE1:
		yield(get_tree().create_timer(0.3), "timeout")
		
		####### TESTING ##########
		self.start_following_path(0.402)	
		yield(get_tree().create_timer(0), "timeout")
		####### TESTING ##########	
	
		_shoot_lantern()
		
var current_offset = 0
func _check_position() -> void:
	if state == STATE_PHASE1:
		# Since AoAndon is a path follow enemy its actual position is the Area2D which has its
		# postion changed by the path.
		var boss_pos = self.get_node("Area2D").position.x
		if player and player.position.x < boss_pos - 5:
			# Prevent the boss from continuing if it passes the player
			# In this case stop following the path
			current_offset = _get_current_offset()
			stop_following_path()
			homing_shard_lantern_spawner.enabled = false
			
			# Enable the normal lantern spawner and it will control the shooting
			normal_fireball_spawner.enabled = true
		elif player and player.position.x > boss_pos + 100:
			if not tween.is_active():
				# Player is ahead so continue following the path and start shooting again
				homing_shard_lantern_spawner.enabled = true
				normal_fireball_spawner.enabled = false
				
				start_following_path(current_offset)
				yield(get_tree().create_timer(1), "timeout")
				_shoot_lantern()
			

# Set the reference to the player
func set_player(player_ref) -> void:
	print("setting player")
	player = player_ref
	homing_shard_lantern_spawner.set_target(player)
	normal_fireball_spawner.set_target(player)
	

# Go to the next phase
func goto_next_phase() -> void:
	print("AoAndon: transition to next state")
	
	# Phase 2 transition
	# Stop firing lanterns
	state = STATE_PHASE2_TRANSITION
	homing_shard_lantern_spawner.enabled = false
	normal_fireball_spawner.enabled = false
	
#	# Phase 2 
	# In this phase AoAndon continues along path, but now spawns
	# laser lanterns above the player
	state = STATE_PHASE2
	
	emit_signal("phase_changed", state)
	
	# Start lanterns via the array spawner
	_spawn_lantern_array()
	self.lantern_spawn_timer.start()
	

var follow_speed = 1	    # speed of follow. The higher the value the faster he follows
var position_offset = 50    # Set a larger value for AoAndon to be ahead of player

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


# Shoot a lantern
func _shoot_lantern() -> void:
	if state == STATE_PHASE1:
		# Shoot homing lanterns when the boss is chasing the plaer
		# If the player is behind the boss then shoot normal lanterns to kill
		# the player quickly as it means they have lost
		if following_path:
			print_debug("Shoot Homing lantern")
			homing_shard_lantern_spawner.shoot()
		else:
			print_debug("Shoot normal lantern")
			normal_fireball_spawner.shoot()					
	elif state == STATE_PHASE2:
		pass
	
# Shoot another lantern once the previous lantern lifetime runs out	
func _on_lantern_destroyed(): 
	yield(get_tree().create_timer(SHOOT_DELAY), "timeout")
	_shoot_lantern()
	

# Set the position of the ceiling
# This position is used to place the mini wanyudo array in the scene
func set_ceiling_position(ceiling_pos):
	ceiling_position = ceiling_pos;	
	
func _spawn_lantern_array() -> void:
	var array_instance = preload("res://src/characters/enemies/AoAndon/LanternArray.tscn").instance()
	array_instance.connect("finished", self, "_on_laser_lanterns_finished")
	var array_width = array_instance.get_width()
	
	
	# get the distance to the player
	var distance_to_player = position.distance_to(player.position)
	print(distance_to_player)
	
	# place the array directly over the player with a little randomness
	var random_offset = rng.randf_range(-10.0, 15.0)  # more in front of player
	var array_offset = distance_to_player + random_offset
	if player.position.x < position.x:
		# player is behind boss so adjust offset to be in other direction
		array_offset *= -1

	# Place so around the player
	# Also place the spikes array on the ceiling
	array_instance.global_position = Vector2(global_position.x + array_offset, ceiling_position.global_position.y)
	
	# Using viewport (NB: only works when stretch mode = Viewport)
	#var viewport_height = get_viewport().size.y
	#spikes_instance.global_position = Vector2(global_position.x + array_offset, ground_global_position.y - viewport_height + (3*16))
	
	# add the instance and trigger the spikes
	get_parent().add_child(array_instance)

		
func _on_laser_lanterns_finished():
	pass
	#if current_state == STATE_UP_DOWN_SLAM:
	#	emit_signal("state_cycle_finished", STATE_UP_DOWN_SLAM)
		#_spawn_falling_spikes_array()	


func _on_LaserLanternSpawnTimer_timeout():
	_spawn_lantern_array()
