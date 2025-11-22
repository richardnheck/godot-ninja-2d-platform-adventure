class_name AoAndonShardLantern
extends Node2D

signal destroyed

export var speed = 180

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction = Vector2.ZERO

# The direction the shards shoot
enum ShootDirection { UP, DOWN, LEFT, RIGHT}

export (ShootDirection) var shoot_direction := ShootDirection.LEFT

# The spread (in degress) of the shards
export (int) var spread := 45


export (PackedScene) var bullet_scene = preload("res://src/characters/enemies/AoAndon/shard-lantern/shard/AoAndonShard.tscn")

onready var life_timer = $LifeTimer
onready var shoot_position := $Area2D/ShootPosition
onready var sprite = $Area2D/AnimatedSprite
onready var explosion: = $Area2D/AnimatedSpriteExplosion


var can_seek:bool = true

export var steer_force = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if shoot_direction == ShootDirection.UP:
		direction = Vector2(0,-1)
	elif shoot_direction == ShootDirection.DOWN:
		direction = Vector2(0, 1)
	elif shoot_direction == ShootDirection.LEFT:
		direction = Vector2(-1, 0)
	elif shoot_direction == ShootDirection.RIGHT:
		direction = Vector2(1, 0)
		
	
var target = null
		
func fire(target_ref):
	target = target_ref
	
	if target:
		#rotation += rand_range(-0.09, 0.09)
		look_at(target.position)   
		velocity = transform.x * speed



var elapsed = 0.0
func _physics_process(delta):
	if not target:
		return
		
	if position.x > target.position.x and can_seek:	
		# If the missile reaches the player then stop seeking and start the life timer
		# so it explodes
		can_seek = false
		life_timer.start()
	
	if can_seek:
		acceleration += seek()
		
	#Attempt (this works but homing is too sensitive and increasing steer forces means the turns are slower but bigger
#	velocity += acceleration * delta
#	velocity = velocity.clamped(speed)
#	rotation = velocity.angle()
#	position += velocity * delta
	
	# Attempt #1
#	velocity = Vector2(speed, lerp(position.y, target.position.y, elapsed))
#	position += velocity * delta
#	rotation = velocity.angle()
#	elapsed += delta
	
	# Attempt #2 (this actually works quite well but rotation doesn't work easily)
	var follow_speed = 1
	position.y = lerp(position.y, target.position.y, delta * follow_speed ) 
	position.x += 3

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _on_LifeTimer_timeout() -> void:
	print("Shard Lantern: Life over")
	# Shoot the shard and then explode
	_shoot()
	_explode()


func _explode() -> void:
	explosion.play("explode")
	yield(explosion, "animation_finished")
	print("explode finished")
	emit_signal("destroyed")
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
	

# Shoot 3 shards in a spread
# Pause for a moment when shooting the shards
func _shoot():
	if Engine.editor_hint:
		# Don't shoot in the editor
		return

	# Shoot three shards in a spread
	_add_bullet(direction.rotated(deg2rad(spread/2)))
	_add_bullet(direction)
	_add_bullet(direction.rotated(deg2rad(-spread/2)))
#	yield(get_tree().create_timer(0.25), "timeout")
#	unpause_following_path()

func _add_bullet(direction):
	var bullet = bullet_scene.instance()
	bullet.direction = direction
	Projectiles.add_child(bullet)
	bullet.global_position = shoot_position.global_position
	return bullet

# Called when it should be removed forcibly once it has been launched as opposed to 
# exploding normally.  This occurs in the boss level when transitioning to the second phase
# and we don't want stray homing lanterns to still be able to kill the player
func force_die():
	print(">>>> force die()")
	queue_free()
