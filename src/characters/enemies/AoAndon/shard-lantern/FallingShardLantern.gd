class_name FallingShardLantern
extends RigidBody2D

# The spread (in degress) of the shards
export (int) var spread := 75

export (PackedScene) var bullet_scene = preload("res://src/characters/enemies/AoAndon/shard-lantern/shard/AoAndonShard.tscn")
export var shoot_rate := 2
export var delay_time := 0.00

onready var shoot_timer = $ShootTimer
onready var delay_timer := $DelayTimer
onready var lifetime_timer := $LifetimeTimer
onready var shoot_position := $ShootPosition
onready var sprite = $AnimatedSprite

# When lifetime is zero, lantern lives forever
var lifetime := 0

# Shoots up as it explodes
var shoot_direction:Vector2 = Vector2.UP

func _ready() -> void:					
	if lifetime > 0:
		lifetime_timer.wait_time = lifetime
		lifetime_timer.start()

# Shoot 3 shards in a spread
# Pause for a moment when shooting the shards
func _shoot():
	# Shoot three shards in a spread
	var actual_spread = spread + rand_range(-10,10)
	_add_bullet(shoot_direction.rotated(deg2rad(actual_spread/2)))
	_add_bullet(shoot_direction)
	_add_bullet(shoot_direction.rotated(deg2rad(-actual_spread/2)))

func _add_bullet(direction):
	var bullet = bullet_scene.instance()
	bullet.direction = direction
	Projectiles.add_child(bullet)
	bullet.global_position = shoot_position.global_position
	return bullet

func _on_LifetimeTimer_timeout():
	_shoot()
	# todo: do explosion
	yield(get_tree().create_timer(0.25), "timeout")
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
	
