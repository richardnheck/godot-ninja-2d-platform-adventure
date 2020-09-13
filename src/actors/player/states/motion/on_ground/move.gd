extends "on_ground.gd"

#export(float) var max_walk_speed = 450
#export(float) var max_run_speed = 700
var just_landed = false
var on_ground = true

func enter():
	.enter()
	just_landed = false
	
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
		if not on_ground:
			just_landed = true
			on_ground = true
		else:
			just_landed = false
			
		owner.get_node("AnimatedSprite").play("run")
	else:
		on_ground = false
		owner.get_node("AnimatedSprite").play("jump_down")
#	
	if just_landed:
		owner.do_landing()	
		
		
	if owner.is_on_floor() and !input_direction:
		emit_signal("finished", "idle")
		
	detect_and_transition_to_jump(_delta)
	detect_and_transition_to_wall_slide()
