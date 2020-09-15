extends KinematicBody2D

onready var run_and_jump_timer = $RunAndJumpTimer

var velocity = Vector2(40,0)
var speed = 60
var direction = 1
var vertical_direction = 1
var vertical_speed = 200

# Jump state settings
export var gravity = 10;
export var jump_power = 200
var do_jump = false
var landing = false

const STATE_UP_DOWN = "updown"
const STATE_JUMP = "jump"
const STATE_RUN = "run"
const STATE_RUN_AND_JUMP = "run_and_jump"


var current_state = STATE_RUN_AND_JUMP
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_jump = true
	run_and_jump_timer.start()


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
					# Shake the screen
					get_parent().get_node("ScreenShake").screen_shake(0.5,2,100)	
					
					# Spawn slam blast
					var slam_blast = preload("res://src/actors/cave-level-boss/SlamBlast.tscn").instance()
					slam_blast.global_position = global_position + Vector2(0, 32)
					
					get_parent().add_child(slam_blast)		
					
					landing = false
			
#	if is_on_floor():
#		get_parent().get_node("ScreenShake").screen_shake(0.5,2,100)	
#	if is_on_wall():
#    if direction == left:
#        direction = right
#    elif direction == right:
#        direction = left

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()



func _on_RunAndJumpTimer_timeout() -> void:
	do_jump = true
