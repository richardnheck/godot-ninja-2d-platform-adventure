extends RigidBody2D


onready var lifetime_timer = $LifetimeTimer
onready var flash_timer = $FlashTimer
onready var animated_sprite = $AnimatedSprite
onready var flames_animated_sprite = $FlamesAnimatedSprite
onready var explosion_animated_sprite = $ExplosionAnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosion_animated_sprite.visible = false
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

func _process(delta):
	# Undo the parent's rotation by applying a negative rotation to the child
	flames_animated_sprite.rotation = -global_rotation # For a 2D rotation

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

func _on_LifetimeTimer_timeout() -> void:
	_start_flashing()

func _start_flashing() -> void:
	flash_timer.start()
	animated_sprite.play("flash")

func _do_death() -> void:
	animated_sprite.visible = false
	flames_animated_sprite.visible = false
	explosion_animated_sprite.visible = true
	explosion_animated_sprite.play()
	
func _on_ExplosionAnimatedSprite_animation_finished():
	queue_free()


var flash_on = false
func _on_FlashTimer_timeout() -> void:
	_do_death()
#	if flash_on:
#		animated_sprite.get_canvas_item().modulate(Color(0,0,0,1))
#	else:
#		animated_sprite.get_canvas_item().modulate(Color(255,255,255,1))
#
#	flash_on = not flash_on


