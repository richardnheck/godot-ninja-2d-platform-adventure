extends "../motion.gd"

export var wall_jump_power = 295
export var wall_jump_horizontal_speed = 155


func initialize(speed, velocity):
	pass

func enter():
	# Set the horizontal speed for wall jump
	horizontal_speed = wall_jump_horizontal_speed
	
	velocity.y = -wall_jump_power
	
	# Show some animated effect when walljumping
	var landing_dust_scene = preload("res://src/objects/effects/LandingDust.tscn").instance()
	var rotation = 0
	var offset = 0
	if next_to_left_wall(): 
		rotation = -120
		offset = -4
	if next_to_right_wall(): 
		rotation = 120
		offset = 4
	landing_dust_scene.global_position = Vector2(owner.global_position.x+offset, owner.global_position.y-16)
	landing_dust_scene.rotation_degrees = rotation
	landing_dust_scene.scale = Vector2(0.5,2)
	get_parent().add_child(landing_dust_scene)	
	

func update(delta):
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
	detect_and_transition_to_ground(input_direction)
