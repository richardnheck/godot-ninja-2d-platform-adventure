class_name Shard
extends Area2D

onready var spike_collision_shape: CollisionShape2D = $CollisionShape2D
onready var animated_sprite := $AnimatedSprite
onready var explosion_animated_sprite: = $ExplosionAnimatedSprite

export var speed := 150
var direction := Vector2.RIGHT setget set_direction

var vel:Vector2 = Vector2.ZERO
var exploding := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = new_direction.angle()
	

func _physics_process(delta: float) -> void:
	if !exploding:
		global_position += speed * delta * direction.normalized()
		

func _on_HitZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER) and !exploding:
		body.die()		
		_explode()
		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _explode():
	exploding = true
	animated_sprite.visible = false
	#Game_AudioManager.sfx_env_crumbling_platform_explode.play()
	explosion_animated_sprite.play("explode")
	yield(explosion_animated_sprite, "animation_finished")
	queue_free()

func _on_Shard_body_entered(body):
	if body is TileMap:
		_explode()
