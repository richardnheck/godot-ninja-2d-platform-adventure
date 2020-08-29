extends "on_ground.gd"

func enter():
	owner.get_node("AnimatedSprite").play("idle")


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	.apply_gravity()
	move(velocity)
	owner.get_node("AnimatedSprite").play("idle")
	
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "move")

func move(vel):	
	velocity = owner.move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
