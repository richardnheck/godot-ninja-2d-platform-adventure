extends KinematicBody2D

onready var run_and_jump_timer = $RunAndJumpTimer
onready var slam_run_timer = $SlamRunTimer
onready var touch_floor_cooloff_timer = $TouchFloorCoolOffTimer
onready var animated_sprite = $AnimatedSprite

signal state_cycle_finished

var velocity = Vector2(40,0)
var speed = 80
var direction = 1
var vertical_direction = 1
var vertical_speed = 200

var speed_updown_slam = 10
var vertical_speed_updown_slam = 350

# Jump state settings
export var gravity = 10;
export var jump_power = 200
var do_jump = false
var landing = false

const STATE_IDLE = "idle"
const STATE_UP_DOWN = "updown"
const STATE_UP_DOWN_SLAM = "updown_slam"
const STATE_JUMP = "jump"
const STATE_RUN = "run"
const STATE_RUN_AND_JUMP = "run_and_jump"

var slam_count = 0
var slam_mode = MODE_SLAM
const MODE_SLAM = "slam"
const MODE_RUN = "run"

var previous_state = null
var current_state = null
var state_changed = false
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var player:KinematicBody2D = null
var ground_global_position:Vector2 = Vector2.ZERO
var can_change_direction = false   # Indicates whether enemy can change direction
var ceiling_position:Position2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boss Ready")
	
	ground_global_position = global_position
	
	set_state(STATE_IDLE)
	
	# wait a bit before starting
	yield(get_tree().create_timer(1.5), "timeout")
	
	do_jump = true
	run_and_jump_timer.start()

func set_state(state):
	if state != current_state:
		previous_state = current_state
		current_state = state
		state_changed = true


func set_player(player_ref):
	player = player_ref;

# Set the position of the ceiling
# This position is used to place the spikes array in the scene
func set_ceiling_position(ceiling_pos):
	ceiling_position = ceiling_pos;
	
func _just_entered_state():
	return state_changed
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_direction()
	
	match current_state:
		STATE_IDLE:
			$AnimatedSprite.play("asleep")								
		STATE_RUN:
			$AnimatedSprite.play("awake")
			velocity = move_and_slide(Vector2(speed * direction, 0), Vector2.UP, false, 4, PI/4, false)
		STATE_RUN_AND_JUMP:
			$AnimatedSprite.play("awake")
			if do_jump:
				velocity.y = -jump_power
				$RunAndJumpTimer.start()
				do_jump = false
				landing = true	
			
			velocity.x = speed * direction
			
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
			velocity.y += gravity
			
			if is_on_floor():
				if landing:
					Game_AudioManager.sfx_env_cave_boss_slam.play()
					emit_signal("state_cycle_finished", STATE_RUN_AND_JUMP)
					landing = false

var new_direction = 0

func _update_direction() -> void:
	_apply_direction_change_if_possible()
	
	var direction_before = direction
	var tmp_direction = direction
	var ap = position.direction_to(player.position)
	if ap.x > 0:
		tmp_direction = 1
		#set_sprite_animation("look-right")
	elif ap.x < 0:
		tmp_direction = -1
		#set_sprite_animation("look-left")
	else:
		tmp_direction = 0
		
	if tmp_direction != direction_before:
		if $ChangeDirectionCoolOffTimer.is_stopped():
			new_direction = tmp_direction
		
			# The direction needs to be changed
			# Start cool timer to prevent direction from being changed immediately
			can_change_direction = false
			$ChangeDirectionCoolOffTimer.start()
	


func _apply_direction_change_if_possible() -> void:
	if can_change_direction:
		# Apply the direction change
		direction = new_direction	
		if direction == 1:
			set_sprite_animation("look-right")
		elif direction == -1:
			set_sprite_animation("look-left")
	

func _on_ChangeDirectionCoolOffTimer_timeout() -> void:
	print("change direction timeout")
	can_change_direction = true

	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_RunAndJumpTimer_timeout() -> void:
	pass
	#do_jump = true


func _on_SlamRunTimer_timeout() -> void:
	slam_count = 0
	slam_mode = MODE_SLAM


func _on_TouchFloorCoolOffTimer_timeout() -> void:
	slam_count = slam_count + 1
	
	if slam_count == 1:
		pass
		

	if slam_count == 3:
		slam_count = 0
		slam_mode = MODE_RUN
		slam_run_timer.start()

func set_sprite_animation(animation) -> void:
	animated_sprite.animation = animation


func _on_DetectionArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		set_state(STATE_RUN)


func _on_DetectionArea2D_body_exited(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		set_state(STATE_IDLE)
