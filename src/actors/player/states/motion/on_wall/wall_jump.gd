extends "../motion.gd"

export var wall_jump_power = 295
export var wall_jump_horizontal_speed = 155

onready var air_jump_effect_scene = preload("res://src/objects/effects/AirJumpEffect.tscn")


func initialize(speed, velocity):
	pass

func enter():
	# Set the horizontal speed for wall jump
	horizontal_speed = wall_jump_horizontal_speed
	
	velocity.y = -wall_jump_power
	
	owner.on_wall_jump()
	
	var instance = air_jump_effect_scene.instance()
	var rotation = 0
	var offset = 0
	if next_to_left_wall(): 
		rotation = 90
		offset = -20
	if next_to_right_wall(): 
		rotation = -90
		offset = 22
	instance.global_position = Vector2(owner.global_position.x+offset, owner.global_position.y-16)
	instance.rotation_degrees = rotation
	instance.play()
	get_parent().add_child(instance)	
	

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
	if Input.is_action_just_released(Actions.get_action_jump()) and velocity.y < 0:
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
	detect_and_transition_to_ground(input_direction)
