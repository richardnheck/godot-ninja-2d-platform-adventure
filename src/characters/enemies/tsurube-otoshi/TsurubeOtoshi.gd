#------------------
# CaveLevelMiniBoss
#------------------
extends KinematicBody2D


# Exports
export var gravity = 7
export var jump_power = 200
export var horizontal_jump_velocity = 50
export var horizontal_direction = 1

export(int) var vertical_direction = 1

onready var jump_timer = $JumpTimer
onready var pause_timer = $PauseTimer
onready var main_sprite = $SpriteMain

var velocity = Vector2(0,0)

var vertical_speed = 200

# Jump state settings
var do_jump = false
var landing = false

# Up down state settings
var paused = false

enum State { 
	JUMP = 1
}

export(State) var current_state = State.JUMP

var state_changed = false

onready var collision_cooloff_timer = $CoolOffTimer

var player:KinematicBody2D = null
var ground_global_position:Vector2 = Vector2.ZERO

var raycast_dist = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast_dist = abs($RayCastWall.cast_to.x)
	ground_global_position = global_position
	
	$RayCastWall.scale.x *= horizontal_direction
		
	if current_state == State.JUMP:
		# wait a bit before starting
		yield(get_tree().create_timer(1.5), "timeout")
		do_jump = true
		jump_timer.start()


func set_state(state):
	current_state = state


func set_player(player_ref):
	player = player_ref;
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("scalex=", self.scale.x, "horizon dir=", horizontal_direction)
	#if self.scale.x != horizontal_direction:
	#	print("flipping x scale")
	#	self.scale.x *= horizontal_direction
	
	match current_state:	
		State.JUMP:
			if do_jump:
				velocity.y = -jump_power
				velocity.x = horizontal_direction * horizontal_jump_velocity
				jump_timer.start()
				do_jump = false
				landing = true	
			
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
			velocity.y += gravity
			
			if is_on_floor():
				if landing:
					_on_land()
					landing = false
			
			if $RayCastWall.is_colliding():
				if collision_cooloff_timer.is_stopped():
					print("is colliding")
					horizontal_direction *= -1	
					$RayCastWall.cast_to.x = raycast_dist*horizontal_direction
					
					print("horiz dir=", horizontal_direction)
					print("scale.x", scale.x)
					collision_cooloff_timer.start()
			
func _on_land():
	#slam_sound.play()
	_flash_sprite()
	_shake_screen()
	velocity.x = 0
	
func _shake_screen() -> void:
	var screen_shake_node = get_parent().get_node("ScreenShake")
	if screen_shake_node:
		screen_shake_node.screen_shake(0.5,2,100)		
	
func _flash_sprite():
	main_sprite.hide()
	yield(get_tree().create_timer(0.1), "timeout")
	main_sprite.show()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_JumpTimer_timeout() -> void:
	do_jump = true


func _on_PauseTimer_timeout() -> void:
	paused = false
