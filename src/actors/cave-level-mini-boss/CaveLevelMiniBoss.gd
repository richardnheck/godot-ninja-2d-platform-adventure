#------------------
# CaveLevelMiniBoss
#------------------
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
export var jump_power = 300
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

var player:KinematicBody2D = null
var ground_global_position:Vector2 = Vector2.ZERO

var MiniBossSlamBlastScene = preload("res://src/actors/cave-level-mini-boss/MiniBossSlamBlast.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Mini Boss Ready")
	
	ground_global_position = global_position
	
	set_state(STATE_RUN_AND_JUMP)
	
	do_jump = true
	run_and_jump_timer.start()

func set_state(state):
	previous_state = current_state
	current_state = state
	state_changed = true

func set_player(player_ref):
	player = player_ref;
	
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
				
				
			var velx = speed_updown_slam * direction
			var vely = vertical_speed_updown_slam * vertical_direction
			velocity.x = velx
			velocity.y = vely
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
		
			if is_on_ceiling() or is_on_floor():
				vertical_direction = vertical_direction * -1;
				_shake_screen()
		
		STATE_RUN_AND_JUMP:
			if do_jump:
				velocity.y = -jump_power
				$RunAndJumpTimer.start()
				do_jump = false
				landing = true	
			
			velocity.x = 0
			
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
			velocity.y += gravity
			
			if is_on_floor():
				if landing:
					_shake_screen()
					_spawn_slam_blast()
					landing = false

func _shake_screen() -> void:
	var screen_shake_node = get_parent().get_node("ScreenShake")
	if screen_shake_node:
		screen_shake_node.screen_shake(0.5,2,100)		


func _spawn_slam_blast() -> void:
	# Rightwards blast
	var instance = MiniBossSlamBlastScene.instance() 
	instance.scale = Vector2(0.5,0.5)
	instance.global_position = global_position
	(instance as MiniBossSlamBlast).set_direction(1)  # rightwards
	get_parent().add_child(instance)		
	
	# Leftwards blast
	var instance2 = MiniBossSlamBlastScene.instance()
	instance2.scale = Vector2(0.5,0.5)
	instance2.global_position = global_position + Vector2(-32,0)
	get_parent().add_child(instance2)		
	(instance2 as MiniBossSlamBlast).set_direction(-1) # leftwards
	

		
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

func _on_RunAndJumpTimer_timeout() -> void:
	do_jump = true
