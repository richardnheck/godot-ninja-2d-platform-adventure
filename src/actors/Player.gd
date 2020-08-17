extends KinematicBody2D

#-----------------------------
# Signals
#-----------------------------
signal collided
signal died

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
onready var wallJumpCoolDownTimer = $WallJumpCoolDownTimer 

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
var wall_jumping = false

# Dash
var dash_direction = Vector2(1,0)
var can_dash = false
var dashing = false

# Game states
var teleporting: = false
var dead: = false


func _physics_process(delta: float) -> void:
	if dead:
		return
		
	run(delta)
	jump()
	#dash()
	friction()
	gravity()
	handle_animation(get_direction())
	
	# Must have  infinite_inertia set to false so player can't affect rigid bodies
	vel = move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
		
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal('collided', collision)
	
	
func run(delta):
	if Input.is_action_pressed(Actions.MOVE_RIGHT):
		vel.x += speed
		vel.x = clamp(vel.x, 100, 150)
		#sprite.flip_h = false
	if Input.is_action_pressed(Actions.MOVE_LEFT):
		vel.x -= speed
		vel.x = clamp(vel.x, -150, -100)
		#sprite.flip_h = true
		
# Jump and wall jump by holding down jump and pressing left or right on wall to jump
func jump():
	var dir = get_direction()
	
	# I can jump when I'm on floor or next to the wall
	if is_on_floor() or next_to_wall():
		jumps_left = 2 if double_jump_enabled else 1
		
	if Input.is_action_just_pressed(Actions.JUMP) and jumps_left > 0:
		print("jump pressed")
		if vel.y > 0: vel.y = 0 # if I'm falling - ignore fall velocity

		if is_on_floor():
			# Normal jump
			vel.y -= jump_power
	
	# Handle wall jump
	if Input.is_action_pressed(Actions.JUMP):
		# Wall jump occurs when user holds down jump
		if not wall_jumping:
			if (next_to_left_wall() and (dir.x == 1)) or (next_to_right_wall() and (dir.x == -1)):
				wall_jump(dir)				
	
	jumps_left -= 1				#	
		
	# If I'm still going up and have released the jump button - cut off the jump and start falling down
	if Input.is_action_just_released(Actions.JUMP) and vel.y < 0:
		vel.y = vel.y * 0.5

func wall_jump(dir):
	wallJumpCoolDownTimer.start()
	wall_jumping = true
	vel.y= -wall_jump_power
	vel.x+= dir.x * 100	

func old_jump(delta):
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
				# Wall jump if not pressing against wall and pressing a direction
				# This means you can't just jump vertically up the wall				
				if !pressing_against_wall and abs(vel.x) > 0:
					vel.y -= wall_jump_power	
				
#				if (next_to_left_wall() and abs(vel.x) < 30)  or (next_to_right_wall() and abs(vel.x) < 30):
#					vel.y -= 200	
#				else:
#					vel.y -= wall_jump_power				

		else:
			# normal jump
			vel.y -= jump_power

		jumps_left -= 1		
		
		# Jump away from the wall
#		if not is_on_floor() and next_to_left_wall():
#			#vel.x += wall_jump_speed
#			#vel.x = clamp(vel.x, 125, 225)
#		if not is_on_floor() and next_to_right_wall():
#			vel.x -= wall_jump_speed
#			#vel.x = clamp(vel.x, -225, -125)
		
		print(vel.x)
	
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
	
	if next_to_wall() and  Input.is_action_pressed(Actions.JUMP) and vel.y > wall_slide_speed:
		vel.y = wall_slide_speed 
#	# Wall slide if next to left wall and player is pressing left
#	if next_to_left_wall() and get_direction().x < 0 and vel.y > wall_slide_speed:
#		vel.y = wall_slide_speed 
#
#	# Wall slide if next to right wall and player is pressing right
#	if next_to_right_wall() and get_direction().x > 0 and vel.y > wall_slide_speed:
#		vel.y = wall_slide_speed 
#	#if next_to_wall() and vel.y > 100: 
		


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
	set_physics_process(false)
	die_sound.play()
	hide()
	yield(die_sound,"finished")
	emit_signal("died")
	#PlayerData.deaths += 1
	#get_tree().reload_current_scene()

func celebrate():
	$AnimatedSprite.play("celebrate")


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


func _on_WallJumpCoolDownTimer_timeout() -> void:
	wall_jumping = false


func _on_VisibilityNotifier2D_screen_exited() -> void:
	die()
