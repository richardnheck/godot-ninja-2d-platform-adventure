class_name LanternSpawner
extends Node2D

signal spawned_object

# The lifetime in seconds to set for the lantern lantern
export var lantern_lifetime := 3.0

export (PackedScene) var object_scene

export var delay_time := 0.00
export (Vector2) var direction := Vector2.RIGHT

onready var _delay_timer := $DelayTimer
onready var _shoot_position := $ShootPosition
onready var _animated_sprite := $AnimatedSprite

func _ready():
	pass
		
# Called by the spawner		
func set_ready():
	_animated_sprite.play("Spawn")
	if delay_time > 0:
		_delay_timer.wait_time = delay_time
		_delay_timer.start()
	else:
		_spawn()
	randomize()


func _spawn() -> void:
	_animated_sprite.play("Spawn")
	var lantern:FallingShardLantern = object_scene.instance()
	lantern.lifetime = lantern_lifetime
	lantern.spread = 120
	Projectiles.add_child(lantern)
	lantern.global_position = _shoot_position.global_position
	emit_signal("spawned_object")
	

func _on_DelayTimer_timeout() -> void:
	_spawn()
