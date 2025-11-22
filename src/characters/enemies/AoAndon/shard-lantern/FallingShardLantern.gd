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
onready var sprite_explosion = $AnimatedSpriteExplosion
onready var collision = $Area2D/CollisionShape2D

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
	_explode()

func _explode():
	# Stop falling
	linear_velocity = Vector2.ZERO
	gravity_scale = 0
	
	# disable collision detection so don't detect shards
	collision.disabled = true
	
	lifetime_timer.stop()	# stop lifetime timer as we may be exploding before lifetime is over (i.e. hit a trap)
	
	# handle visual animations
	sprite_explosion.visible = true
	sprite_explosion.play("default")
	sprite.visible = false

	# fire shards	
	_shoot()
	
func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
	elif body.is_in_group(Constants.GROUP_TRAP):
		# Hit a trap so explode
		_explode()


func _on_AnimatedSpriteExplosion_animation_finished():
	queue_free()


func _on_Area2D_area_entered(area):
	print("fallingShardLantern Hit" + str(area))
	print(str(area.get_groups()))
	if area.is_in_group(Constants.GROUP_TRAP):
		_explode()
