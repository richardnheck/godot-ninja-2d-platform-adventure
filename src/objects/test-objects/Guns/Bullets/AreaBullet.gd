class_name AreaBullet
extends Area2D

export var speed := 3500

var damage := 1
var direction := Vector2.RIGHT setget set_direction
onready var collision_shape = $CollisionShape2D
var explosion:AnimatedSprite = null

func _ready() -> void:
	explosion = get_node("ExplosionAnimatedSprite")
	set_as_toplevel(true)
	connect("body_entered", self, "hit_body")


func _physics_process(delta: float) -> void:
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

func do_explosion() -> void:
	collision_shape.set_deferred("disabled", true)
	$AnimatedSprite.visible = false
	explosion.visible = true
	explosion.global_position = global_position + Vector2(0,-10)
	explosion.play()

func _on_ExplosionAnimatedSprite_animation_finished() -> void:
	queue_free()


func _on_ExplosionAnimatedSprite2_animation_finished():
	queue_free()
