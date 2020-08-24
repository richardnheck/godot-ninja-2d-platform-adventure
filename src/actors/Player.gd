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
export var speed: = 135		# in x direction
export var wall_jump_speed = 100 # in x direction
export var wall_slide_speed = 50
export var jump_power = 290
export var wall_jump_power = 290
export var gravity: = 13

export var stopping_friction = 0.6
export var running_friction = 0.9


#-----------------------------
# References
#-----------------------------
onready var die_sound: = $AudioStreamDie
onready var hit_sound: = $AudioStreamHit
onready var collision_shape = $CollisionShape2D
onready var collision_shape_jump = $CollisionShape2DJump
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
var wall_jumping = false
var jumpPressedRememberTime = 0.2
var jumpPressedRemember = 0
var groundedRememberTime = 0.1
var groundedRemember = 0


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
	gravity()
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
	
	var dir = get_direction()
		
	if Input.is_action_just_pressed(Actions.JUMP):# and jumps_left > 0:
		jumpPressedRemember = jumpPressedRememberTime
		
	# Handle normal jump
	if (jumpPressedRemember > 0) and (groundedRemember > 0):
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
	

func wall_jump(dir):
	wallJumpCoolDownTimer.start()
	wall_jumping = true
	vel.y= -wall_jump_power
	vel.x+= dir.x * wall_jump_speed	

		
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
	if direction.x == 1:
		sprite.flip_h = false
	elif direction.x == -1:
		sprite.flip_h = true

	print(vel.y)
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
