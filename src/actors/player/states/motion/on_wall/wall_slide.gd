extends "../motion.gd"

var wall_slide_gravity = 3 # the specific gravity for wall sliding
var wall_clamp_time = 0.2  # time to clamp on wall before sliding
var sliding = false

func enter():
	speed = 0.0
	velocity = Vector2()

	sliding = false	
	owner.get_node("AnimatedSprite").play("jump_down")
	yield(get_tree().create_timer(wall_clamp_time), "timeout")
	sliding = true
	

func handle_input(event):
#	if !event.is_action_pressed(Actions.JUMP):
#		print("not pressing jump")
#		emit_signal("finished", "move")
	return .handle_input(event)


func update(_delta):
	var input_direction = get_input_direction()
	
	if Input.is_action_pressed(Actions.JUMP):
		if sliding and next_to_wall():
			velocity.y += wall_slide_gravity
			move(velocity)
						
		detect_and_transition_to_wall_jump(input_direction)
			
		if owner.is_on_floor() or not next_to_wall():
			goto_move_state()
	else:
		# No longer holding jump so end slide
		goto_move_state()
		

func goto_move_state():
	emit_signal("finished", "move")
