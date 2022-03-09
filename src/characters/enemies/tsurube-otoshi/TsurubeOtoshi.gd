#------------------
# Tsurube Otoshi
#------------------
extends KinematicBody2D


# Exports
export var gravity = 7
export var jump_power = 200
export var horizontal_jump_velocity = 40
export(int,-1,1) var horizontal_direction = 1

onready var sprite_main = $SpriteMain
onready var sprite_flash = $SpriteFlash

onready var jump_timer = $JumpTimer
onready var collision_cooloff_timer = $CoolOffTimer

# Velocity variables
var velocity = Vector2(0,0)

# Jump state settings
var do_jump = false
var landing = false

# Up down state settings
var paused = false

enum State { 
	JUMP = 1
}

export(State) var current_state = State.JUMP

var player:KinematicBody2D = null

var raycast_wall_dist = null
var raycast_floor_dist = null
var initialized = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast_wall_dist = abs($RayCastWall.cast_to.x)
	raycast_floor_dist = abs($RayCastFloor.position.x)
	
	# Set direction according to current direction set by horizontal_direction
	_init_character_direction()
	
	if current_state == State.JUMP:
		# wait a bit before starting
		yield(get_tree().create_timer(1.5), "timeout")
		do_jump = true
		jump_timer.start()
	
	initialized = true

func set_state(state):
	current_state = state


func set_player(player_ref):
	player = player_ref;
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
				if not $RayCastFloor.is_colliding() or $RayCastWall.is_colliding():
					_change_direction()
				#if $RayCastWall.is_colliding():
			#	_change_direction()
				if landing:
					_on_land()
					landing = false
					
			

func _init_character_direction() -> void:
	$RayCastWall.cast_to.x = raycast_wall_dist*horizontal_direction
	$RayCastFloor.position.x = raycast_floor_dist*horizontal_direction
	
	if initialized:
		# small delay so sprite changes direction a small moment after landing
		# We don't want this delay when setting up the character at the start i.e when not initialized yet
		yield(get_tree().create_timer(0.4), "timeout") 
	
	sprite_main.flip_h = horizontal_direction == -1
	sprite_flash.flip_h = horizontal_direction == -1

func _change_direction() -> void:
	if collision_cooloff_timer.is_stopped():
		horizontal_direction *= -1
		print("Change direction to ", horizontal_direction)	
		_init_character_direction()
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
	sprite_main.hide()
	yield(get_tree().create_timer(0.1), "timeout")
	sprite_main.show()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_JumpTimer_timeout() -> void:
	do_jump = true
