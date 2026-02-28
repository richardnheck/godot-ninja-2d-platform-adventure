class_name AreaBullet
extends Area2D

export var speed := 3500

var damage := 1
var direction := Vector2.RIGHT setget set_direction
onready var collision_shape = $CollisionShape2D
onready var ball_sprite = $AnimatedSprite
var explosion:AnimatedSprite = null
var sfx_explosion:AudioStreamPlayer2D = null

var exploding = false

func _ready() -> void:
	sfx_explosion = Game_AudioManager.sfx_env_canon_ball_explosion.duplicate()
	add_child(sfx_explosion)
	
	explosion = get_node("ExplosionAnimatedSprite")
	set_as_toplevel(true)
	connect("body_entered", self, "hit_body")
	
	ball_sprite.rotation = -direction.angle()   # don't rotate the sprite
	


func _physics_process(delta: float) -> void:
	if !exploding:
		global_position += speed * delta * direction.normalized()
	


func hit_body(body) -> void:
	if body.has_method("die"):
		body.die()
	_destroy()


func _destroy() -> void:
	if explosion:
		do_explosion()
	else:
		queue_free()


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = new_direction.angle()
	#if is_instance_valid(ball_sprite):
	#	ball_sprite.rotation = -rotation   # don't rotate the sprite (this doesn't seem to work)
	

func do_explosion() -> void:
	sfx_explosion.play()
	exploding = true
	collision_shape.set_deferred("disabled", true)
	$AnimatedSprite.visible = false
	explosion.visible = true
	explosion.global_position = global_position
	explosion.play()

func _on_ExplosionAnimatedSprite_animation_finished() -> void:
	queue_free()


func _on_ExplosionAnimatedSprite2_animation_finished():
	queue_free()
