class_name HomingFireball
extends Area2D

signal destroyed

export var speed = 180

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction = Vector2.ZERO

var can_seek:bool = true

export var steer_force = 20.0

onready var life_timer = $LifeTimer
onready var explosion: = $AnimatedSpriteExplosion

var target = null
		
func fire(target_ref):
	target = target_ref
	#rotation += rand_range(-0.09, 0.09)
	look_at(target.position)   
	velocity = transform.x * speed



var elapsed = 0.0
func _process(delta):
	if position.x > target.position.x and can_seek:	
		# If the missile reaches the player then stop seeking and start the life timer
		# so it explodes
		can_seek = false
		life_timer.start()
	
	if can_seek:
		acceleration += seek()
		
	#Attempt (this works but homing is too sensitive and increasing steer forces means the turns are slower but bigger
#	velocity += acceleration * delta
#	velocity = velocity.clamped(speed)
#	rotation = velocity.angle()
#	position += velocity * delta
	
	# Attempt #1
#	velocity = Vector2(speed, lerp(position.y, target.position.y, elapsed))
#	position += velocity * delta
#	rotation = velocity.angle()
#	elapsed += delta
	
	# Attempt #2 (this actually works quite well but rotation doesn't work easily)
	var follow_speed = 1
	position.y = lerp(position.y, target.position.y, delta * follow_speed ) 
	position.x += 3

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _on_LifeTimer_timeout() -> void:
	print("missile life over")
	_explode()


func _explode() -> void:
	explosion.play("explode")
	yield(explosion, "animation_finished")
	emit_signal("destroyed")
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
