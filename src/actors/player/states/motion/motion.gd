extends "res://src/utility/state_machine/state.gd"
# Collection of important methods to handle direction and animation.

export(float) var horizontal_speed = 125

# warning-ignore-all:unused_class_variable
var speed = 0.0
var velocity = Vector2()

var groundedRememberTime = 0.15
var groundedRemember = 0
var jumpPressedRememberTime = 0.2
var jumpPressedRemember = 0

func handle_input(event):
	if event.is_action_pressed(Actions.JUMP):
		jumpPressedRemember = jumpPressedRememberTime
	return .handle_input(event)


func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = Input.get_action_strength(Actions.MOVE_RIGHT) - Input.get_action_strength(Actions.MOVE_LEFT)
	#input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#	if Input.is_action_just_pressed(Actions.JUMP) and (owner.is_on_floor()):  #????or next_to_wall()):# I can jump when I'm on floor or next to the wall
#		input_direction.y = -1.0
#	else:
#		input_direction.y =  1.0

	return input_direction


func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
		
	# Handle sprite direction
	var sprite = owner.get_node("AnimatedSprite")
	if direction.x == 1:
		sprite.flip_h = false
	elif direction.x == -1:
		sprite.flip_h = true


func apply_gravity():
	velocity.y += 15;


func move(vel):	
	velocity = owner.move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
	for i in owner.get_slide_count():
		var collision = owner.get_slide_collision(i)
		if collision:
			owner.emit_signal('collided', collision)
	return velocity


# Helpers
# ----------------------------------------------------------------
func next_to_wall():
	return next_to_left_wall() or next_to_right_wall()

	
func next_to_left_wall():
	var leftWallRaycast1 = owner.get_node("LeftWallRaycast1")
	var leftWallRaycast2 = owner.get_node("LeftWallRaycast2")
	return leftWallRaycast1.is_colliding() or leftWallRaycast2.is_colliding()


func next_to_right_wall():
	var rightWallRaycast1 = owner.get_node("RightWallRaycast1")
	var rightWallRaycast2 = owner.get_node("RightWallRaycast2")
	return rightWallRaycast1.is_colliding() or rightWallRaycast2.is_colliding()


func detect_and_transition_to_wall_slide():
	if Input.is_action_pressed(Actions.JUMP) and !owner.is_on_floor() and velocity.y > 0:
			# Wall slide occurs when user holds down jump against a wall and they are travelling downwards
			if next_to_left_wall() or next_to_right_wall():
				# Transition to wall slide state
				emit_signal("finished", "wall_slide")

func detect_and_transition_to_wall_jump(input_direction):
		# Wall Jump is triggered when user presses away from the wall while holding jump
		if Input.is_action_pressed(Actions.JUMP) and (next_to_left_wall() and (input_direction.x == 1)) or (next_to_right_wall() and (input_direction.x == -1)):			
			print("goto wall jump")
			emit_signal("finished", "wall_jump") 


func detect_and_transition_to_jump(_delta):
	if detect_jump(_delta):
		emit_signal("finished", "jump")


func detect_and_transition_to_air_jump() -> bool:
	if Input.is_action_just_pressed(Actions.JUMP):
		emit_signal("finished", "air_jump") 
		return true
	else:
		return false


func detect_and_transition_to_ground(input_direction):
	if owner.is_on_floor():
		owner.do_landing()
		# Exit jump state if on the floor
		if !input_direction: 
			# No directional user input so transition to idle
			emit_signal("finished", "idle")
		else: 
			# There is directional user input so transition to move
			emit_signal("finished", "move")


func detect_jump(_delta) -> bool:
	jumpPressedRemember -= _delta
	groundedRemember -= _delta

	if owner.is_on_floor():
		groundedRemember = groundedRememberTime

	if (jumpPressedRemember > 0) and (groundedRemember > 0):
		# Transition to jump state
		jumpPressedRemember = 0
		groundedRemember = 0
		return true
	else:
		return false	
