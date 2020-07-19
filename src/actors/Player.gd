extends Actor

var direction: = Vector2.ZERO

export var stomp_impulse: = 1000.0

onready var die_sound: = $AudioStreamDie
onready var hit_sound: = $AudioStreamHit
onready var collision_shape = $CollisionShape2D
onready var sprite = $AnimatedSprite

const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 16.0
var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

var teleporting: = false
var dead: = false


var jump_power = 700
var stopping_friction = 0.6
var running_friction = 0.9

var vel = Vector2()

var jumps_left = 2
var dash_direction = Vector2(1,0)
var can_dash = false
var dashing = false

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	hit_sound.play()
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()

func _physics_process(delta: float) -> void:
	run(delta)
	jump()
	#dash()
	friction()
	gravity()
	handle_animation(get_direction())
	vel = move_and_slide(vel, Vector2.UP)
	
#	if not teleporting and not dead:
#		# Handle the snap vector
#		if Input.is_action_pressed("jump"):
#			# Set to zero to allow for the player to jump and not be snapped to the ground
#			snap_vector = Vector2.ZERO
#		else:
#			# Reset it back to the default
#			snap_vector = SNAP_DIRECTION * SNAP_LENGTH
#
#
#
#
#		#var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
#		#var direction: = get_direction()
#		#_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
#
#		# With this code the Player simple slides of MovingPlatform
#		#_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
#
#		# Moves the body while keeping it attached to slopes
#		# This is required to work with the MovingPlatform scene that uses paths
#		# Otherwise the player moves a little bit on the platform
#		#_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL)
#
#
#		# Handle sprite animation
#		#print(direction.x)	
#		if direction.x == 1:
#			#if sprite.flip_h:
#			sprite.flip_h = false
#			#if sprite.scale.x < 0:
#			#	sprite.scale.x *= -1;	
#		elif direction.x == -1:
#			#if not sprite.flip_h:
#			sprite.flip_h = true
#			#if sprite.scale.x > 0:
#			#	print("flip")
#			#	sprite.scale.x *= -1;	
#
#		if is_on_floor():
#			if abs(_velocity.x) > 0:
#				sprite.play("run")
#			else:
#				sprite.play("idle")
#		else:
#			if _velocity.y < 0:
#				sprite.play("jump_up")
#			elif _velocity.y > 0:
#				sprite.play("jump_down")	


func run(delta):
	if Input.is_action_pressed("move_right"):
		print(speed.x)
		vel.x += speed.x
		#sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		vel.x -= speed.x
		#sprite.flip_h = true
		
func jump():
	# I can jump when I'm on floor or next to the wall
	if is_on_floor() or next_to_wall():
		jumps_left = 2 # Recharge double-jump. 
	
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		if vel.y > 0: vel.y = 0 # if I'm falling - ignore fall velocity
		vel.y -= jump_power
		jumps_left -= 1
		# Jump away from the wall
		if not is_on_floor() and next_to_left_wall():
			vel.x += jump_power
		if not is_on_floor() and next_to_right_wall():
			vel.x -= jump_power
	
	# If I'm still going up and have released the jump button - cut off the jump and start falling down
	if Input.is_action_just_released("jump") and vel.y < 0:
		vel.y = 0

		
func friction():
	# When I hold the key
	var running = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
	if not running and is_on_floor():
		vel.x *= stopping_friction
	else:
		vel.x *= running_friction

func gravity():
	if not dashing:
		vel.y += gravity
	if vel.y > 500: 
		vel.y = 500 # clamp falling speed
	if next_to_wall() and vel.y > 100: 
		vel.y = 100 # wall slide


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
	var x = Input.get_action_strength("move_right")	- Input.get_action_strength("move_left")
	var y = 0.0
	if Input.is_action_just_pressed("jump") and (is_on_floor() or next_to_wall()):# I can jump when I'm on floor or next to the wall
		y = -1.0
	else:
		y =  1.0
	
	return Vector2(x, y)
	

func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, is_jump_interrupted: bool) -> Vector2:
		var out: = linear_velocity 

		print(direction.x)
		
		if direction.x == 1.0:
			out.x += 5 
		if direction.x == -1.0:
			out.x -=5
		
		out.y += gravity * get_physics_process_delta_time()
				
		if direction.y == -1.0:
			# Jumping
			out.y = speed.y * direction.y
			
#			# Handle wall jump#			
			# Jump away from the wall
			if not is_on_floor() and next_to_left_wall():
				print("next to left wall")
				out.x += 100

#
#				print(speed.x)
#			elif not is_on_floor() and next_to_right_wall():
#		#		out.x -= jump_power
#				pass
#			else:
#				out.y = speed.y * direction.y
		elif direction.y == 1.0:
			if is_jump_interrupted:
				out.y = 0.0
			if next_to_wall():
				# Do wall slide
				out.y = out.y * wall_slide_speed_factor
		
		#if next_to_wall():
		#	print (out.x)
		return out

func calculate_stomp_velocity(linear_velocity: Vector2,	impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out

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
