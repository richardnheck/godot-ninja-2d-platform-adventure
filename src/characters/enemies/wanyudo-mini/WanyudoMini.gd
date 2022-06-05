extends RigidBody2D


onready var lifetime_timer = $LifetimeTimer
onready var animated_sprite = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.bounce = 0.7

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

# TODO
#const Explosion := preload("Explosion.tscn")

var impulse:float = 0 setget set_impulse
var direction := Vector2.RIGHT setget set_direction

onready var _sprite := $Sprite


func _on_Timer_timeout():
#	var explosion = Explosion.instance()
#	Projectiles.add_child(explosion)
#	explosion.global_position = global_position
#	queue_free()
	pass


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction


func set_impulse(new_impulse: float) -> void:
	impulse = new_impulse
	apply_central_impulse(direction * impulse)


func die() -> void:
	_do_death()
	

func _on_LifetimeTimer_timeout() -> void:
	_do_death()


func _do_death() -> void:
	# TODO: Implement death animation (explosion)
	queue_free()


var flash_on = false
func _on_FlashTimer_timeout() -> void:
	pass
#	if flash_on:
#		animated_sprite.get_canvas_item().modulate(Color(0,0,0,1))
#	else:
#		animated_sprite.get_canvas_item().modulate(Color(255,255,255,1))
#
#	flash_on = not flash_on
