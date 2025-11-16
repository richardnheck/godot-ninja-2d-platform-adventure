extends "../motion.gd"

export var jump_power = 340

export(float) var base_max_horizontal_speed = 125

var enter_velocity = Vector2()
var max_horizontal_speed = 0.0
var spring_impulse = Vector2.ZERO

var reset_falling_velocity = false

# These variables are required to manage successful transitioning from one jump state
# to another. This occurs when a player jumps on to a spring or bouncy platform
var initialized = false
var entered = false

func initialize(speed, velocity, impulse:Vector2 = Vector2.ZERO):
	enter_velocity = velocity
	spring_impulse = impulse
	initialized = true
	entered = false		# new state being initialized but so it is not entered yet

func enter():
	entered = true
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	# NB: Only the y component of spring impulse is implemented for now
	velocity.y = -jump_power - spring_impulse.y

	if _is_player_jump():
		# A player triggered jump so call owner to handle additional jump animations and sound
		owner.on_jump()
	
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

	if _is_player_jump():
		# The jump is a player triggered jump and not a spring
		# If I'm still going up and have released the jump button - cut off the jump and start falling down
		if Input.is_action_just_released(Actions.get_action_jump()) and velocity.y < 0:
			velocity.y = velocity.y * 0.5
	
	move(velocity)
	
	# When a kinematic body is on a moving body its velocity is set that moving body
	# In the case of falling platforms, this means that the jump height is reduced the longer
	# player is on the platform.  To compensate for this, we need to set the velocity in the 
	# update() method as it doesn't work when setting it on entering the state as this is not
	# connected to the physics update
	if !reset_falling_velocity:
		velocity.y = -jump_power - spring_impulse.y
		reset_falling_velocity = true
		
	# Handle animation	
	# ------------------------
	var sprite = owner.get_node("AnimatedSprite")
	if velocity.y < 0:
		sprite.play("jump_up")
	elif velocity.y > 30:	# any smaller and the player will jitter between jump and idle animation on vertical moving platforms
		sprite.play("jump_down")	
	
	
	# Handle state transitions	
	# ------------------------
	if _is_player_jump():
		# Can only air jump from a player triggered jump and not from a spring or bouncy platform
		detect_and_transition_to_air_jump()
	
	detect_and_transition_to_wall_slide()
	detect_and_transition_to_wall_jump(input_direction)
	
	# Keep this up to date for jump detection even though we are currently jumping
	# This is to subsequent states (idle or move) via their initialise() method
	jumpPressedRemember -= _delta	
	
	detect_and_transition_to_ground(input_direction)
	
func exit():
	if initialized and entered:
		print("jump: exit")
		# The state was run to completion so it is safe to exit
		# Reset the spring impulse after the jump
		spring_impulse = Vector2.ZERO
		initialized = false
		entered = false
		reset_falling_velocity = false

# Determine if the jump was triggered by the player
func _is_player_jump() -> bool:
	return spring_impulse == Vector2.ZERO
