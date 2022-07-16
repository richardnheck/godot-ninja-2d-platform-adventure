class_name NormalFireball
extends Area2D

signal destroyed

export var speed = 180

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction = Vector2.ZERO

onready var life_timer = $LifeTimer
onready var explosion: = $AnimatedSpriteExplosion

var target:Player = null
		
func fire(target_ref:Player):
	target = target_ref
	
	if target:
		# Get the player velocity so we can aim at the player when they are moving
		var player_velocity = target.get_node('StateMachine').current_state.velocity
		var x_offset = player_velocity.x
		
		direction = position.direction_to(target.position + Vector2(x_offset,0))

var elapsed = 0.0
func _process(delta):	
	global_position += speed * delta * direction.normalized()#	
	# Attempt #2 (this actually works quite well but rotation doesn't work easily)
	#	var follow_speed = 1
	#	position.y = lerp(position.y, target.position.y, delta * follow_speed ) 
	#	position.x += 3
	


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
