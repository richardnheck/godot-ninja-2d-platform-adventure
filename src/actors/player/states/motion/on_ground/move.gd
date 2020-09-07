extends "on_ground.gd"

#export(float) var max_walk_speed = 450
#export(float) var max_run_speed = 700

func enter():
	speed = 0.0
	velocity = Vector2()

	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimatedSprite").play("run")

func initialize(_jumpPressedRemember):
	jumpPressedRemember = _jumpPressedRemember


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	var input_direction = get_input_direction()
	
	update_look_direction(input_direction)
	apply_gravity()

	speed = horizontal_speed
	velocity.x = speed * input_direction.x
	move(velocity)
	
	if owner.is_on_floor():
		owner.get_node("AnimatedSprite").play("run")
	else:
		owner.get_node("AnimatedSprite").play("jump_down")
#	speed = max_run_speed if Input.is_action_pressed("run") else max_walk_speed
#	var collision_info = move(speed, input_direction)
#	if not collision_info:
#		return
#	if speed == max_run_speed and collision_info.collider.is_in_group("environment"):
#		return null
	if owner.is_on_floor() and !input_direction:
		emit_signal("finished", "idle")
		
	detectAndTransitionToJump(_delta)
