extends KinematicBody2D

onready var run_and_jump_timer = $RunAndJumpTimer

var velocity = Vector2(40,0)
var speed = 60
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

const STATE_UP_DOWN = "updown"
const STATE_UP_DOWN_SLAM = "updown_slam"
const STATE_JUMP = "jump"
const STATE_RUN = "run"
const STATE_RUN_AND_JUMP = "run_and_jump"


var previous_state = null
var current_state = null
var state_changed = false
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_state(STATE_RUN_AND_JUMP)
	set_state(STATE_RUN)
	do_jump = true
	run_and_jump_timer.start()

func set_state(state):
	previous_state = current_state
	current_state = state
	state_changed = true

func _just_entered_state():
	return state_changed
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		STATE_UP_DOWN:
			var velx = speed * direction
			var vely = vertical_speed * vertical_direction
			velocity.x = velx
			velocity.y = vely
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
		
			if is_on_ceiling() or is_on_floor():
				vertical_direction = vertical_direction * -1;
		STATE_UP_DOWN_SLAM:
			if _just_entered_state():
				print("spawning spikes")
				state_changed = false
				_spawn_falling_spikes_array()
				
			var velx = speed_updown_slam * direction
			var vely = vertical_speed_updown_slam * vertical_direction
			velocity.x = velx
			velocity.y = vely
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
		
			if is_on_ceiling() or is_on_floor():
				vertical_direction = vertical_direction * -1;
				_shake_screen()
		STATE_RUN:
			velocity = move_and_slide(Vector2(speed * direction, 0), Vector2.UP, false, 4, PI/4, false)
		STATE_RUN_AND_JUMP:
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
					_shake_screen()
					_spawn_slam_blast()
					landing = false

func _shake_screen() -> void:
	get_parent().get_node("ScreenShake").screen_shake(0.5,2,100)		


func _spawn_slam_blast() -> void:
	var instance = preload("res://src/actors/cave-level-boss/SlamBlast.tscn").instance()
	instance.global_position = global_position + Vector2(0, 32)
	get_parent().add_child(instance)		

func _spawn_falling_spikes_array() -> void:
	var instance = preload("res://src/actors/cave-level-boss/BossFallingSpikeArray.tscn").instance()
	var viewport_height = get_viewport().size.y
	
#	var space_state = get_world_2d().direct_space_state
#	var result = space_state.intersect_ray(global_position, global_position + Vector2(500, 0),[self])  # use global coordinates, not local to node
#	if result:
#		print("Hit at point: ", result.position)
#		print(result.collider)
	print("global_position=" + str(global_position))
	instance.global_position = Vector2(global_position.x+100, 100)
	get_parent().add_child(instance)
	instance.trigger()		
		
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()



func _on_RunAndJumpTimer_timeout() -> void:
	do_jump = true
