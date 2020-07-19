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


func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	hit_sound.play()
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()

func _physics_process(delta: float) -> void:
	if not teleporting and not dead:
		# Handle the snap vector
		if Input.is_action_pressed("jump"):
			# Set to zero to allow for the player to jump and not be snapped to the ground
			snap_vector = Vector2.ZERO
		else:
			# Reset it back to the default
			snap_vector = SNAP_DIRECTION * SNAP_LENGTH
			
		var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
		var direction: = get_direction()
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
		
		# With this code the Player simple slides of MovingPlatform
		#_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		
		# Moves the body while keeping it attached to slopes
		# This is required to work with the MovingPlatform scene that uses paths
		# Otherwise the player moves a little bit on the platform
		_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL)
		
		
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
			if abs(_velocity.x) > 0:
				sprite.play("run")
			else:
				sprite.play("idle")
		else:
			if _velocity.y < 0:
				sprite.play("jump_up")
			elif _velocity.y > 0:
				sprite.play("jump_down")	


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right")	- Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
		var out: = linear_velocity 
		out.x = speed.x * direction.x
		out.y += gravity * get_physics_process_delta_time()
		if direction.y == -1.0:
			out.y = speed.y * direction.y
		if is_jump_interrupted:
			out.y = 0.0
		return out

func calculate_stomp_velocity(
	linear_velocity: Vector2,
	impulse: float
) -> Vector2:
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
