extends KinematicBody2D
class_name Player

# The Player is a KinematicBody2D, in other words a physics-driven object.
# It can move, collide with the world, etc...
# The player has a state machine, but the body and the state machine are separate.

#-----------------------------
# References
#-----------------------------
onready var collision_shape = $CollisionShape2D
onready var sprite = $AnimatedSprite
onready var landing_dust_scene = preload("res://src/characters/player/effects/landing-dust/LandingDust.tscn")
onready var air_jump_effect_scene = preload("res://src/characters/player/effects/air-jump/AirJumpEffect.tscn")
onready var jump_effect_scene = preload("res://src/characters/player/effects/jump/JumpEffect.tscn")
#-----------------------------
# Signals
#-----------------------------
signal direction_changed(new_direction)
signal collided
signal start_die
signal died
signal screen_exited

var dead: = false
var sfx_die:AudioStreamPlayer

var look_direction = Vector2.RIGHT setget set_look_direction

func _ready() -> void:
	print("Player ready")
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")

	# Add the die sound to the player so the sound is cleared when player is removed
	# Need to do this because the visiblity notifier fires annoyingly and triggers the die
	# sound when using the global sound
	sfx_die = Game_AudioManager.sfx_character_player_die.duplicate()
	add_child(sfx_die)		

func _on_VisibilityNotifier2D_screen_exited() -> void:	
	if !dead:
		emit_signal("screen_exited")
		die()


func take_damage(attacker, amount, effect = null):
	pass
#	if is_a_parent_of(attacker):
#		return
#	$States/Stagger.knockback_direction = (attacker.global_position - global_position).normalized()
#	$Health.take_damage(amount, effect)

# Start the dieing process
func die():
	if not dead:

		set_dead(true)
		$StateMachine._change_state("die")
		sfx_die.play()

	
func celebrate():
	$StateMachine._change_state("celebrate")
	

func set_dead(value):
	dead = true
	set_process_input(not value)
	set_physics_process(not value)
	
	
func is_dead() -> bool:
	return dead

func do_landing():
	# Player has landed
	Game_AudioManager.sfx_character_player_land.play()
	
	# Show some animated dust just on landing
	var instance = landing_dust_scene.instance()
	instance.global_position = global_position
	get_parent().add_child(instance)		
	
	
func on_jump():
	Game_AudioManager.sfx_character_player_jump.play()
	
	# Show an effect when jumping
	var instance = jump_effect_scene.instance()
	instance.global_position = Vector2(global_position.x+8, global_position.y)
	get_parent().add_child(instance)		
	
	
func on_wall_jump():
	Game_AudioManager.sfx_character_player_jump.play()

	
func on_air_jump():
	Game_AudioManager.sfx_character_player_air_jump.play()
	
	# Show an effect when air jumping
	var instance = air_jump_effect_scene.instance()
	instance.global_position = global_position
	get_parent().add_child(instance)		
	
	
func on_wall_land():
	Game_AudioManager.sfx_character_player_land.play()


func on_wall_slide_start():
	pass
	#Game_AudioManager.sfx_character_player_wall_slide.play()
	
	
func on_wall_slide_end():
	pass
	#Game_AudioManager.sfx_character_player_wall_slide.stop()


func set_look_direction(value):
	#print("look_direction" + str(value))
	look_direction = value
	
	emit_signal("direction_changed", value)

#----------------------------------------------
# Functions for CutScenes
#----------------------------------------------
func move_right():
	_move_right(true)


func move_left():
	_move_left(true)


func move_stop():
	_move_right(false)
	_move_left(false)
	
func jump():
	_jump(true)

	
func talk():
	$StateMachine._change_state("talk")

func move():
	$StateMachine._change_state("move")


func _move_right(pressed):
	var ev = InputEventAction.new()
	ev.action = Actions.MOVE_RIGHT_CUTSCENE
	ev.pressed = pressed
	Input.parse_input_event(ev)
	#$StateMachine._change_state("move")


func _move_left(pressed):
	var ev = InputEventAction.new()
	ev.action = Actions.MOVE_LEFT_CUTSCENE
	ev.pressed = pressed
	Input.parse_input_event(ev)
	#$StateMachine._change_state("move")

func _jump(pressed):
	var ev = InputEventAction.new()
	ev.action = Actions.JUMP_CUTSCENE
	ev.pressed = pressed
	Input.parse_input_event(ev)
