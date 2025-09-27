extends "./motion/motion.gd"
#extends "res://src/utility/state_machine/state.gd"
var splash_scene = preload("res://src/objects/water-splash/WaterSplash.tscn")

var finished = false

# Initialize the state. E.g. change the animation.
func enter():
	print("Die by water state:enter")
	velocity = Vector2(0,0)
	finished = false
	owner.set_dead(true)
	
	var sprite = owner.get_node("AnimatedSprite") as AnimatedSprite
	sprite.visible = false
	var splash_instance = splash_scene.instance()
	splash_instance.global_position = sprite.global_position + Vector2(16,25) #offset is roughly the player size
	get_parent().add_child(splash_instance)
	
	owner.emit_signal("start_die");
	yield(get_tree().create_timer(0.5), "timeout")
	finished = true
	
func update(_delta):
	.apply_gravity()
	move(velocity)
	
	
#	sprite.play("die")
#
#	var deathEffect = owner.get_node("DeathEffect")
#	deathEffect.play("default")
	
	if finished:
		owner.emit_signal("died")

func _on_animation_finished():
	pass
