class_name LongMovingSpike
extends Node2D

onready var tween = $Tween
onready var collisionShape = $CollisionShape2D
onready var sprite_handle = $MovingPart/HandleArea2D/SpriteHandle
onready var handle_area2D = $MovingPart/HandleArea2D
onready var moving_part = $MovingPart
onready var initialDelayTimer = $InitialDelayTimer
onready var sound = $AudioStreamPlayer2D
onready var tween_values = [Vector2(0,0), Vector2(0,-46)]

export var initial_delay:float = 0		# initial delay in seconds

var spike_moving_out = true;

func _ready():
	# disable handle area collisions when retracted 
	handle_area2D.monitoring = false
	
	if initial_delay > 0:
		initialDelayTimer.start()
	else:	
		_start_tween()


func _start_tween():
	$Tween.interpolate_property(moving_part, "position", tween_values[0], tween_values[1], 1.5,
	 Tween.TRANS_QUINT, tween.EASE_IN)    
	$Tween.start()


func _on_tween_completed(object, key):
	if spike_moving_out:
		sound.play()
	tween_values.invert()
	_start_tween()
	spike_moving_out = !spike_moving_out


func _on_InitialDelayTimer_timeout() -> void:
	_start_tween()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_Tween_tween_step(object, key, elapsed, value):
	# hide the handle and disable collisions when the blade retracts to the base
	# this is so we don't need too much wall behind the long spike
	# just one tile is sufficent
	if value.y >= -16:
		sprite_handle.visible = false
		handle_area2D.monitoring = false
	else:
		sprite_handle.visible = true
		handle_area2D.monitoring = true
