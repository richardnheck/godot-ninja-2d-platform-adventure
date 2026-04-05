extends "./motion/motion.gd"
#extends "res://src/utility/state_machine/state.gd"

# Initialize the state. E.g. change the animation.
func enter():
	velocity = Vector2(0,0)
	var collision_shape = owner.get_node("CollisionShape2D") as CollisionShape2D
	collision_shape.disabled = true
	
	owner.set_dead(true)
	owner.emit_signal("start_die");
	
	var animation_player = owner.get_node("AnimationPlayer") as AnimationPlayer
	animation_player.play("death-bubble-appear")	
	yield(get_tree().create_timer(0.6), "timeout")
	owner.emit_signal("died")

func handle_input(event):
	pass
	
#func update(_delta):
#	.apply_gravity()
#	velocity.x = 0
#	move(velocity)
#
#	var sprite = owner.get_node("AnimatedSprite")
#	sprite.play("die")
#
#	var deathEffect = owner.get_node("DeathEffect")
#	deathEffect.play("default")
#
#	if finished:
#		owner.emit_signal("died")

func _on_animation_finished():
	pass
