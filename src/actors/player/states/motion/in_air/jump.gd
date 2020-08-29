extends "../motion.gd"

export var jump_power = 320

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

func initialize(speed, velocity):
	pass
#	horizontal_speed = speed
#	max_horizontal_speed = speed if speed > 0.0 else base_max_horizontal_speed
#	enter_velocity = velocity

func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	velocity.y = -jump_power
	
#	horizontal_velocity = enter_velocity if input_direction else Vector2()
#	vertical_speed = 600.0

func update(delta):
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
	
	
	
	var sprite = owner.get_node("AnimatedSprite")
	if velocity.y < 0:
		sprite.play("jump_up")
	elif velocity.y > 30:	# any smaller and the player will jitter between jump and idle animation on vertical moving platforms
		sprite.play("jump_down")	
	
	
	
	# Exit jump state if on the floor
	if owner.is_on_floor(): 
		emit_signal("finished", "move")

func move(vel):	
	velocity = owner.move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
