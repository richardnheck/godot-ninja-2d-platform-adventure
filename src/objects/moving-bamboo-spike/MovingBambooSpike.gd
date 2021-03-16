extends Area2D

onready var tween = $Tween
onready var collisionShape = $CollisionShape2D
onready var sprite = $CollisionShape2D/Sprite
onready var initialDelayTimer = $InitialDelayTimer

onready var tween_values = [Vector2(0,8), Vector2(0,-6)]

export var initial_delay:float = 0		# initial delay in seconds


func _ready():
	if initial_delay > 0:
		initialDelayTimer.start()
	else:	
		_start_tween()


func _start_tween():
	$Tween.interpolate_property(collisionShape, "position", tween_values[0], tween_values[1], 1.5,
	 Tween.TRANS_QUINT, tween.EASE_IN)    
	$Tween.start()


func _on_tween_completed(object, key):
	tween_values.invert()
	_start_tween()


func _on_InitialDelayTimer_timeout() -> void:
	_start_tween()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
