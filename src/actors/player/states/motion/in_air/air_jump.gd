extends "../motion.gd"

export var jump_power = 300

export(float) var base_max_horizontal_speed = 125

#export(float) var air_acceleration = 10.0
#export(float) var air_deceleration = 20.0
#export(float) var air_steering_power = 0.5

#export(float) var gravity = 15

var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
#var horizontal_speed = 0.0
#var horizontal_velocity = Vector2()

#var vertical_speed = 0.0
#var height = 0.0

func initialize(_speed, _velocity):
	velocity = _velocity
	speed = _speed
#	horizontal_speed = speed
#	max_horizontal_speed = speed if speed > 0.0 else base_max_horizontal_speed
#	enter_velocity = velocity

func enter():
	print("enter air jump")
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	#velocity.y = -jump_power
	velocity.y = -jump_power
	
#	horizontal_velocity = enter_velocity if input_direction else Vector2()
#	vertical_speed = 600.0

func handle_input(event):
	return .handle_input(event)
	

func update(_delta):
	# Handle movement	
	# ------------------------
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	# Horizontal movement
	speed = horizontal_speed
	velocity.x = horizontal_speed * input_direction.x
	
	# Vertical movement
	.apply_gravity()
	
	# If I'm still going up and have released the jump button - cut off the jump and start falling down
	if Input.is_action_just_released(Actions.JUMP) and velocity.y < 0:
		velocity.y = velocity.y * 0.5
	
	move(velocity)
	
	# Handle animation	
	# ------------------------
	var sprite = owner.get_node("AnimatedSprite")
	if velocity.y < 0:
		sprite.play("jump_up")
	elif velocity.y > 30:	# any smaller and the player will jitter between jump and idle animation on vertical moving platforms
		sprite.play("jump_down")	
	
	
	# Handle state transitions	
	# ------------------------
	detect_and_transition_to_wall_slide()
	detect_and_transition_to_wall_jump(input_direction)
	
	# Keep this up to date for jump detection even though we are currently jumping
	# This is to subsequent states (idle or move) via their initialise() method
	jumpPressedRemember -= _delta	
	
	detect_and_transition_to_ground(input_direction)
	
	
