extends KinematicBody2D
class_name Player

# The Player is a KinematicBody2D, in other words a physics-driven object.
# It can move, collide with the world, etc...
# The player has a state machine, but the body and the state machine are separate.

#-----------------------------
# References
#-----------------------------
onready var die_sound: = $AudioStreamDie
onready var collision_shape = $CollisionShape2D
onready var sprite = $AnimatedSprite
onready var landing_dust_scene = preload("res://src/objects/effects/LandingDust.tscn")
onready var air_jump_effect_scene = preload("res://src/objects/effects/AirJumpEffect.tscn")

#-----------------------------
# Signals
#-----------------------------
signal direction_changed(new_direction)
signal collided
signal start_die
signal died

var dead: = false

var look_direction = Vector2.RIGHT setget set_look_direction


func _on_VisibilityNotifier2D_screen_exited() -> void:
	die()

func take_damage(attacker, amount, effect = null):
	pass
#	if is_a_parent_of(attacker):
#		return
#	$States/Stagger.knockback_direction = (attacker.global_position - global_position).normalized()
#	$Health.take_damage(amount, effect)

# Start the dieing process
func die():
	set_dead(true)
	$StateMachine._change_state("die")
	
	die_sound.play()
	
	# TODO: If I use this then it plays die on scene reload as well
	#Game_AudioManager.sfx_character_player_die.play()

	
func celebrate():
	$StateMachine._change_state("celebrate")


func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	collision_shape.set_deferred("disabled", true)

func do_landing():
	# Player has landed
	#land_sound.play()
	Game_AudioManager.sfx_character_player_land.play()
	
	# Show some animated dust just on landing
	var instance = landing_dust_scene.instance()
	instance.global_position = global_position
	get_parent().add_child(instance)		
	
func on_jump():
	Game_AudioManager.sfx_character_player_jump.play()
	#jump_sound.play()
	
func on_wall_jump():
	Game_AudioManager.sfx_character_player_jump.play()
	#jump_sound.play()
	
func on_air_jump():
	Game_AudioManager.sfx_character_player_air_jump.play()
	#air_jump_sound.play()
	
	# Show an effect when air jumping
	var instance = air_jump_effect_scene.instance()
	instance.global_position = global_position
	instance.play()
	get_parent().add_child(instance)		
	
func on_wall_land():
	Game_AudioManager.sfx_character_player_land.play()
	#land_sound.play()

func on_wall_slide_start():
	Game_AudioManager.sfx_character_player_wall_slide.play()
	#wall_slide_sound.play()
	
func on_wall_slide_end():
	Game_AudioManager.sfx_character_player_wall_slide.stop()
	#wall_slide_sound.stop()
#func die():
#	dead = true
#	collision_shape.set_deferred("disabled", true)
#	set_physics_process(false)
#	die_sound.play()
#	hide()
#	yield(die_sound,"finished")
#	emit_signal("died")


func set_look_direction(value):
	print("look_direction" + str(value))
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

