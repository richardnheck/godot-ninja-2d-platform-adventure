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
export var speed_old: = 30		# in x direction
export var speed: = 125		# in x direction
export var wall_jump_speed = 155 # in x direction
export var wall_slide_speed = 50
export var jump_power = 320
export var wall_jump_power = 295
export var gravity: = 15

export var stopping_friction = 0.6
export var running_friction = 0.9


#-----------------------------
# References
#-----------------------------
onready var die_sound: = $AudioStreamDie
onready var land_sound: = $AudioStreamLand
onready var hit_sound: = $AudioStreamHit
onready var collision_shape = $CollisionShape2D
onready var collision_shape_jump = $CollisionShape2DJump
onready var sprite = $AnimatedSprite
onready var wallJumpCoolDownTimer = $WallJumpCoolDownTimer 
onready var wall_clamp_timer = $WallClampTimer;

#-----------------------------
# Variables
#-----------------------------
# Movement
var vel = Vector2()
var direction: = Vector2.ZERO
var snap_vector = Constants.SNAP_DIRECTION * Constants.SNAP_LENGTH

# Special movement states and flags
var wall_jumping = false
var jumpPressedRememberTime = 0.2
var jumpPressedRemember = 0
var groundedRememberTime = 0.1
var groundedRemember = 0
var falling = false
var jumping = false
var wall_sliding = false
var wall_slide_initial_speed = 1
var wall_slide_gravity = 3


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
	jump(delta)
	#dash()
	friction()
	gravity(delta)
	handle_animation(get_direction())
	
	# Must have  infinite_inertia set to false so player can't affect rigid bodies
	vel = move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
		
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal('collided', collision)
	

func _get_run_direction() -> float:
	return Input.get_action_strength(Actions.MOVE_RIGHT) - Input.get_action_strength(Actions.MOVE_LEFT)
	
	
func run(delta):
	var direction = _get_run_direction()
	if !wall_jumping:
		vel.x = speed * direction
	else:
		vel.x = wall_jump_speed * direction
	
func run_old(delta):
	if Input.is_action_pressed(Actions.MOVE_RIGHT):
		vel.x += speed
		vel.x = clamp(vel.x, 100, 150)
	if Input.is_action_pressed(Actions.MOVE_LEFT):
		vel.x -= speed
		vel.x = clamp(vel.x, -150, -100)
	
# Jump and wall jump by holding down jump and pressing left or right on wall to jump
func jump(delta):
	jumpPressedRemember -= delta
	groundedRemember -= delta
	
	if is_on_floor():
		groundedRemember = groundedRememberTime
		if jumping or falling:
			# Player has landed
			land_sound.play()
			
			# Show some animated just on landing
			var landing_dust_scene = preload("res://src/objects/effects/LandingDust.tscn").instance()
			landing_dust_scene.global_position = global_position
			get_parent().add_child(landing_dust_scene)		
			
			jumping = false
			falling = false
	
	var dir = get_direction()
		
	if Input.is_action_just_pressed(Actions.JUMP):# and jumps_left > 0:
		jumpPressedRemember = jumpPressedRememberTime
		
	# Handle normal jump
	if (jumpPressedRemember > 0) and (groundedRemember > 0):
		jumping = true  # set that player is jumping
		jumpPressedRemember = 0
		groundedRemember = 0
		vel.y = -jump_power
	
	# Handle wall jump
	if Input.is_action_pressed(Actions.JUMP):
		# Wall jump occurs when user holds down jump
		if not wall_jumping:
			if (next_to_left_wall() and (dir.x == 1)) or (next_to_right_wall() and (dir.x == -1)):
				wall_jump(dir)				
	
	# If I'm still going up and have released the jump button - cut off the jump and start falling down
	if Input.is_action_just_released(Actions.JUMP) and vel.y < 0:
		vel.y = vel.y * 0.5
	
	if jumping and Input.is_action_just_released(Actions.JUMP):
		ready_to_dash = true

var ready_to_dash = false

func wall_jump(dir):
	wallJumpCoolDownTimer.start()
	wall_jumping = true
	
	vel.y= -wall_jump_power
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
	landing_dust_scene.global_position = Vector2(global_position.x+offset, global_position.y-16)
	landing_dust_scene.rotation_degrees = rotation
	landing_dust_scene.scale = Vector2(0.5,2)
	get_parent().add_child(landing_dust_scene)		
#	
	#if(vel.y < 60):
#		# Full wall jump power because we have slid down to fast
#		# ie. full power if roughly still clamped to the wall
#		vel.y= -wall_jump_power
#	else:
#		# Have started sliding so wall jump power is no longer maximum
#		# This means you wall jump sideways
#		vel.y = -wall_jump_power * 0.7
		
	vel.x+= dir.x * wall_jump_speed	

		
func friction():
	# When I hold the key
	var running = Input.is_action_pressed(Actions.MOVE_LEFT) or Input.is_action_pressed(Actions.MOVE_RIGHT)
	if not running and is_on_floor():
		vel.x *= stopping_friction
	else:
		vel.x *= running_friction

var wall_clamped = false

func gravity(delta):
	if next_to_wall() and  Input.is_action_pressed(Actions.JUMP) and vel.y >= wall_slide_initial_speed:
		if !wall_sliding:
			# starting wall slide
			wall_clamped = true
			wall_sliding = true
			vel.y = wall_slide_initial_speed
			wall_clamp_timer.start()
	else:
		wall_sliding = false
		
	# Add gravity	
	if not dashing and not wall_sliding:
		vel.y += gravity
	
	# Add wall sliding gravity
	if wall_sliding and !wall_clamped:
		vel.y += wall_slide_gravity
	
	if vel.y > 500: 
		vel.y = 500 # clamp falling speed
	
	if vel.y > 250 and !jumping:
		# Set falling so we can know when to play landed sound
		falling = true
	
		
		#vel = vel.linear_interpolate(Vector2(0, 50), delta *100)
#	# Wall slide if next to left wall and player is pressing left
#	if next_to_left_wall() and get_direction().x < 0 and vel.y > wall_slide_speed:
#		vel.y = wall_slide_speed 
#
#	# Wall slide if next to right wall and player is pressing right
#	if next_to_right_wall() and get_direction().x > 0 and vel.y > wall_slide_speed:
#		vel.y = wall_slide_speed 
#	#if next_to_wall() and vel.y > 100: 
		
func dash():
	if is_on_floor():
		can_dash = true # recharges when player touches the floor
		ready_to_dash = false

	if Input.is_action_pressed(Actions.MOVE_RIGHT):
		dash_direction = Vector2(1,0)
	if Input.is_action_pressed(Actions.MOVE_LEFT):
		dash_direction = Vector2(-1,0)

	if ready_to_dash and Input.is_action_just_pressed(Actions.JUMP) and can_dash:
		
		vel = dash_direction.normalized() * 1000
		can_dash = false
		
		dashing = true # turn off gravity while dashing
		yield(get_tree().create_timer(0.5), "timeout")
		dashing = false
		

func handle_animation(direction):
	# Handle sprite animation
	if direction.x == 1:
		sprite.flip_h = false
	elif direction.x == -1:
		sprite.flip_h = true

	if is_on_floor():
		if int(vel.x) != 0: 
			if sprite.animation != "run":
				print("run")
				sprite.play("run")
		else:
			if sprite.animation != "idle":
				sprite.play("idle")	
	else:
		if vel.y < 0:
			sprite.play("jump_up")
		elif vel.y > 30:	# any smaller and the player will jitter between jump and idle animation on vertical moving platforms
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


func _on_WallClampTimer_timeout() -> void:
	wall_clamped = false
