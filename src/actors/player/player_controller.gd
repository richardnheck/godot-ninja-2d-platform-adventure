extends KinematicBody2D
# The Player is a KinematicBody2D, in other words a physics-driven object.
# It can move, collide with the world, etc...
# The player has a state machine, but the body and the state machine are separate.

#-----------------------------
# References
#-----------------------------
onready var die_sound: = $AudioStreamDie
onready var land_sound: = $AudioStreamLand
onready var hit_sound: = $AudioStreamHit
onready var collision_shape = $CollisionShape2D
onready var sprite = $AnimatedSprite


#-----------------------------
# Signals
#-----------------------------
signal direction_changed(new_direction)
signal collided
signal died

var dead: = false

var look_direction = Vector2.RIGHT setget set_look_direction


func celebrate():
	$AnimatedSprite.play("celebrate")


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
	print("Player:die()")
	set_dead(true)
	$StateMachine._change_state("die")

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	collision_shape.set_deferred("disabled", true)
	
#func die():
#	dead = true
#	collision_shape.set_deferred("disabled", true)
#	set_physics_process(false)
#	die_sound.play()
#	hide()
#	yield(die_sound,"finished")
#	emit_signal("died")



func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)
