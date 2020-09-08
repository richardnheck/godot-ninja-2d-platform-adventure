extends "res://src/utility/state_machine/state.gd"

# Initialize the state. E.g. change the animation.
func enter():
	owner.set_physics_process(false)
	pass
	
func update(_delta):
	var sprite = owner.get_node("AnimatedSprite")
	sprite.play("celebrate")

func _on_animation_finished(_anim_name):
	pass
