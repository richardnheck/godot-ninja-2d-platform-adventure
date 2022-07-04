class_name NormalFireball
extends Area2D

signal destroyed

export var speed = 180

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction = Vector2.ZERO

onready var life_timer = $LifeTimer
onready var explosion: = $AnimatedSpriteExplosion

var target = null
		
func fire(target_ref):
	target = target_ref
	
	if target:
		look_at(target.position)   
		velocity = transform.x * speed



var elapsed = 0.0
func _process(delta):
	
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
