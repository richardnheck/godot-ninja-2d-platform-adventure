class_name HomingFireball
extends Area2D

export var speed = 100

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction = Vector2.ZERO

export var steer_force = 10.0

var target = null
		
#func fire(_transform):
func fire(target_ref):
	print(">>>FIRE")
	#global_transform = _transform
	target = target_ref
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
