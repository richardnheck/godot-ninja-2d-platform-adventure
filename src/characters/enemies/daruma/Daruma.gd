#------------------
# Daruma
#------------------
extends KinematicBody2D
class_name Daruma

# Exports
export var gravity = 7
export var jump_power = 200
export var horizontal_jump_velocity = 0
export(int,-1,1) var horizontal_direction = 1
export(float,0,5) var wait_time = 0.5		# wait time before starting to jump

onready var sprite_main = $AnimatedSprite
onready var sprite_flash = $SpriteFlash
onready var landing_dust_scene = preload("res://src/characters/player/effects/landing-dust/LandingDust.tscn")

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

var slam_sound:AudioStreamPlayer2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slam_sound =  Game_AudioManager.sfx_env_cave_mini_boss_slam.duplicate()
	add_child(slam_sound)
	
	set_sprite_animation("ground")
	raycast_wall_dist = abs($RayCastWall.cast_to.x)
	raycast_floor_dist = abs($RayCastFloor.position.x)
	
	# Set direction according to current direction set by horizontal_direction
	_init_character_direction()
	
	if current_state == State.JUMP:
		# wait a bit before starting
		yield(get_tree().create_timer(wait_time), "timeout")
		do_jump = true
		jump_timer.start()
	
	initialized = true

func set_state(state):
	current_state = state


func set_player(player_ref):
	player = player_ref;

func _process(delta):
	_look_at_player()	

# Make the npc look in the direction of the player
func _look_at_player() -> void:
	if player:
		sprite_main.flip_h = player.global_position < self.global_position	

func _physics_process(delta: float) -> void:
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
		_init_character_direction()
		collision_cooloff_timer.start()

func _on_land():
	# Ensure character stops moving when they land
	velocity.x = 0
	_shake_screen()
	slam_sound.play()
	set_sprite_animation("land")	
	
	# Show some animated dust just on landing
	var instance = landing_dust_scene.instance()
	instance.set_scale(Vector2(2,1.5))
	instance.position = position
	get_parent().add_child(instance)
	
	yield(sprite_main, "animation_finished")
	set_sprite_animation("ground")

	
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
	set_sprite_animation("jump")	
	yield(get_tree().create_timer(0.3), "timeout") 
	do_jump = true
