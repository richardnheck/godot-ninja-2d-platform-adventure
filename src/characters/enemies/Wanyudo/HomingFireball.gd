class_name HomingFireball
extends Area2D

export var speed = 180

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction = Vector2.ZERO

var can_seek:bool = true

export var steer_force = 50.0

onready var life_timer = $LifeTimer
onready var explosion: = $AnimatedSpriteExplosion

var target = null
		
func fire(target_ref):
	target = target_ref
	#rotation += rand_range(-0.09, 0.09)
	look_at(target.position)   
	velocity = transform.x * speed

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

var elapsed = 0.0
func _physics_process(delta):
	if position.x > target.position.x and can_seek:	
		# If the missile reaches the player then stop seeking and start the life timer
		# so it explodes
		can_seek = false
		life_timer.start()
	
	if can_seek:
		acceleration += seek()
		
	
	# Attempt #1
#	velocity = Vector2(speed, lerp(position.y, target.position.y, elapsed*3))
#	position += velocity * delta
#	rotation = velocity.angle()
#	elapsed += delta

	#Attempt #2
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta


func _on_LifeTimer_timeout() -> void:
	print("missile life over")
	_explode()


func _explode() -> void:
	explosion.play("explode")
	yield(explosion, "animation_finished")
	queue_free()
