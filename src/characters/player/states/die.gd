extends "./motion/motion.gd"
#extends "res://src/utility/state_machine/state.gd"

var finished = false

# Initialize the state. E.g. change the animation.
func enter():
	print("Die state:enter")
	velocity = Vector2(0,0)
	finished = false
	owner.set_dead(true)
	owner.emit_signal("start_die");
	yield(get_tree().create_timer(0.5), "timeout")
	finished = true
	
func update(_delta):
	.apply_gravity()
	move(velocity)
	
	var sprite = owner.get_node("AnimatedSprite")
	sprite.play("die")
	
	var deathEffect = owner.get_node("DeathEffect")
	deathEffect.play("default")
	
	if finished:
		owner.emit_signal("died")

func _on_animation_finished():
	pass
