extends "on_ground.gd"

func enter():
	owner.get_node("AnimatedSprite").play("idle")


func initialize(_jumpPressRemember:float):
	jumpPressedRemember = _jumpPressRemember
	

func handle_input(event):
	return .handle_input(event)


func update(_delta):
	.apply_gravity()
	move(velocity)
	owner.get_node("AnimatedSprite").play("idle")
	
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "move")
	
	detect_and_transition_to_jump(_delta)
