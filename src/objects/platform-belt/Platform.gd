class_name PlatformForBelt
extends RigidBody2D
#extends KinematicBody2D

export(float) var speed = 1 setget set_speed
export(Vector2) var direction = Vector2.DOWN setget set_direction

onready var collision_shape = $CollisionShape2D

var velocity = Vector2()


func set_direction(value) -> void:
	direction = value
	if is_instance_valid(collision_shape):
		if value == Vector2.DOWN:
			# Hack: when platform is moving down adjust the extents so the player looks to be on the 
			# platform.  In the up direction it is fine
			collision_shape.shape.extents.y = 7.5
			collision_shape.position.y = 0.5
		elif value == Vector2.UP:
			# Hack: for some reason when adjusting the "down" collision shape this
			# somehow affects the up ones but if it is commented out then it is perfect
			# but with the code in I need to adjust the collision shape up for the player
			# to be on the platform WTF!!!!
			collision_shape.position.y = -0.25


func set_speed(value) -> void:
	speed = value
	

func _ready():
	pass


func _physics_process(delta:float) -> void:
	# for rigidbody (as kinematic body)  
	position += direction * speed * delta

	# For kinematic body
	#velocity = direction * speed
	#move_and_slide_with_snap(velocity, Vector2(0,0))






