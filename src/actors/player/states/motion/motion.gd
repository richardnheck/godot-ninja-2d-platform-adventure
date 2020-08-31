extends "res://src/utility/state_machine/state.gd"
# Collection of important methods to handle direction and animation.

export(float) var horizontal_speed = 125

# warning-ignore-all:unused_class_variable
var speed = 0.0
var velocity = Vector2()

func handle_input(event):
	pass
	#if event.is_action_pressed("simulate_damage"):
	#	emit_signal("finished", "stagger")


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

func detectAndTransitionToWallSlide():
	if Input.is_action_pressed(Actions.JUMP) and !owner.is_on_floor():
			# Wall jump occurs when user holds down jump
			if next_to_left_wall() or next_to_right_wall():
				# Transition to wall slide state
				emit_signal("finished", "wall_slide")
