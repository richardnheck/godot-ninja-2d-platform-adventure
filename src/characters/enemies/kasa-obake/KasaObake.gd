#------------------
# Kasa Obake
#------------------
class_name KasaObake
extends KinematicBody2D


# Exports
export var gravity = 500
export var jump_power = 180
export var horizontal_jump_velocity = 50
export(int,-1,1) var horizontal_direction = 1

onready var sprite_main = $AnimatedSprite
onready var sprite_flash = $SpriteFlash
onready var landing_dust_scene = preload("res://src/characters/player/effects/landing-dust/LandingDust.tscn")

onready var jump_timer = $JumpTimer
onready var collision_cooloff_timer = $CoolOffTimer

var sfx_jump:AudioStreamPlayer2D = null

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
	sfx_jump = Game_AudioManager.sfx_env_kasa_obake_jump.duplicate()
	add_child(sfx_jump)
	
	set_sprite_animation("ground")
	raycast_wall_dist = abs($RayCastWall.cast_to.x)
	raycast_floor_dist = abs($RayCastFloor.position.x)
	
	# Set direction according to current direction set by horizontal_direction
	_init_character_direction()
	
	if current_state == State.JUMP:
		# wait a bit before starting the jump
		yield(get_tree().create_timer(1), "timeout")
		_jump() 	# jump straight away
	
	initialized = true

func set_state(state):
	current_state = state


func set_player(player_ref):
	player = player_ref;
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match current_state:	
		State.JUMP:
			if do_jump:
				sfx_jump.play()
				velocity.y = -jump_power
				velocity.x = horizontal_direction * horizontal_jump_velocity
				jump_timer.start()
				do_jump = false
				landing = true

			
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)	
			velocity.y += gravity * delta
			
			if velocity.y > 20 and landing:
				# kasaobake is in falling phase of jump
				set_sprite_animation("fall")
			
			if is_on_floor():
				if not $RayCastFloor.is_colliding() or $RayCastWall.is_colliding():
					_change_direction()
		
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
		_init_character_direction()
		collision_cooloff_timer.start()

func _on_land():
	# Ensure character stops moving when they land
	velocity.x = 0
	
	set_sprite_animation("land")
	
	# Show some animated dust just on landing
	var instance = landing_dust_scene.instance()
	instance.set_scale(Vector2(1,0.75))
	instance.position = position
	get_parent().add_child(instance)

	
func _shake_screen() -> void:
	var screen_shake_node = get_parent().get_node("ScreenShake")
	if screen_shake_node:
		screen_shake_node.screen_shake(0.5,2,100)		

	
func _flash_sprite():
	sprite_main.hide()
	yield(get_tree().create_timer(0.1), "timeout")
	sprite_main.show()


func set_sprite_animation(animation) -> void:
	sprite_main.animation = animation
	sprite_main.play(animation)
			
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_JumpTimer_timeout() -> void:
	_jump()

func _jump() -> void:
	set_sprite_animation("jump")	
	yield(get_tree().create_timer(0.3), "timeout")
	do_jump = true
