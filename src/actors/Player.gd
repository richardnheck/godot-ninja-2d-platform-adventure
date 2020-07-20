extends KinematicBody2D

#-----------------------------
# Exports
#-----------------------------
# Wall slide speed factor (max = 1)
# The smaller the number the slower the slide. When equal to 1 the slide is the same as falling
export var speed: = 30		# in x direction
export var wall_jump_speed = 100 # in x direction
export var wall_slide_speed = 100
export var jump_power = 700
export var wall_jump_power = 400
export var stopping_friction = 0.6
export var running_friction = 0.9
export var gravity: = 50

#-----------------------------
# References
#-----------------------------
onready var die_sound: = $AudioStreamDie
onready var hit_sound: = $AudioStreamHit
onready var collision_shape = $CollisionShape2D
onready var sprite = $AnimatedSprite

#-----------------------------
# Variables
#-----------------------------
# Movement
var vel = Vector2()
var direction: = Vector2.ZERO
var snap_vector = Constants.SNAP_DIRECTION * Constants.SNAP_LENGTH

# Special movement states and flags
# Double jump
var double_jump_enabled = false
var jumps_left = 2			

# Dash
var dash_direction = Vector2(1,0)
var can_dash = false
var dashing = false

# Game states
var teleporting: = false
var dead: = false


func _physics_process(delta: float) -> void:
	run(delta)
	jump()
	#dash()
	friction()
	gravity()
	handle_animation(get_direction())
	vel = move_and_slide(vel, Vector2.UP)
	

func run(delta):
	if Input.is_action_pressed(Actions.MOVE_RIGHT):
		vel.x += speed
		#sprite.flip_h = false
	if Input.is_action_pressed(Actions.MOVE_LEFT):
		vel.x -= speed
		#sprite.flip_h = true
		
func jump():
	var dir = get_direction()
	
	# I can jump when I'm on floor or next to the wall
	if is_on_floor() or next_to_wall():
		jumps_left = 2 if double_jump_enabled else 1
	
	if Input.is_action_just_pressed(Actions.JUMP) and jumps_left > 0:
		if vel.y > 0: vel.y = 0 # if I'm falling - ignore fall velocity
		
		var pressing_against_wall = (next_to_left_wall() and dir.x < 0) or (next_to_right_wall() and dir.x > 0)
		#if is_on_floor() or pressing_against_wall:
			# not next to a wall so jump normally
		
		if next_to_wall(): 
			if is_on_floor():
				# normal jump
				vel.y -= jump_power
			else:
				vel.y -= wall_jump_power				
			
		else:
			# normal jump
			vel.y -= jump_power

		jumps_left -= 1		
		
		# Jump away from the wall
		if not is_on_floor() and next_to_left_wall():
			vel.x += wall_jump_speed
		if not is_on_floor() and next_to_right_wall():
			vel.x -= wall_jump_speed
	
	# If I'm still going up and have released the jump button - cut off the jump and start falling down
	if Input.is_action_just_released(Actions.JUMP) and vel.y < 0:
		vel.y = 0

		
func friction():
	# When I hold the key
	var running = Input.is_action_pressed(Actions.MOVE_LEFT) or Input.is_action_pressed(Actions.MOVE_RIGHT)
	if not running and is_on_floor():
		vel.x *= stopping_friction
	else:
		vel.x *= running_friction

func gravity():
	if not dashing:
		vel.y += gravity
	if vel.y > 500: 
		vel.y = 500 # clamp falling speed
	
	# Wall slide if next to left wall and player is pressing left
	if next_to_left_wall() and get_direction().x < 0 and vel.y > wall_slide_speed:
		vel.y = wall_slide_speed 
		
	# Wall slide if next to right wall and player is pressing right
	if next_to_right_wall() and get_direction().x > 0 and vel.y > wall_slide_speed:
		vel.y = wall_slide_speed 
	#if next_to_wall() and vel.y > 100: 
		


func handle_animation(direction):
	# Handle sprite animation
	#print(direction.x)	
	if direction.x == 1:
		#if sprite.flip_h:
		sprite.flip_h = false
		#if sprite.scale.x < 0:
		#	sprite.scale.x *= -1;	
	elif direction.x == -1:
		#if not sprite.flip_h:
		sprite.flip_h = true
		#if sprite.scale.x > 0:
		#	print("flip")
		#	sprite.scale.x *= -1;	

	if is_on_floor():
		#print (abs(vel.x))
		if int(vel.x) != 0: 
			if sprite.animation != "run":
				sprite.play("run")
		else:
			if sprite.animation != "idle":
				sprite.play("idle")	
	else:
		if vel.y < 0:
			sprite.play("jump_up")
		elif vel.y > 0:
			sprite.play("jump_down")	


func get_direction() -> Vector2:
	var x = Input.get_action_strength(Actions.MOVE_RIGHT)	- Input.get_action_strength(Actions.MOVE_LEFT)
	var y = 0.0
	if Input.is_action_just_pressed(Actions.JUMP) and (is_on_floor() or next_to_wall()):# I can jump when I'm on floor or next to the wall
		y = -1.0
	else:
		y =  1.0
	
	return Vector2(x, y)
	

func teleport():
	teleporting = true
	hide()
	

func die():
	dead = true
	collision_shape.set_deferred("disabled", true)
	die_sound.play()
	hide()
	yield(die_sound,"finished")
	#PlayerData.deaths += 1
	#get_tree().reload_current_scene()


func next_to_wall():
	return next_to_left_wall() or next_to_right_wall()

	
func next_to_left_wall():
	return $LeftWallRaycast1.is_colliding() or $LeftWallRaycast2.is_colliding()


func next_to_right_wall():
	return $RightWallRaycast1.is_colliding() or $RightWallRaycast2.is_colliding()


func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	pass

	
func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()
