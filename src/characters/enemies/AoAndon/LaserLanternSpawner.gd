class_name LaserLanternSpawner
extends Node2D

signal spawned_object

enum MODE { TIMED }

# The lifetime in seconds to set for the laser lantern
export var lantern_lifetime := 3.0

export (PackedScene) var object_scene

export var delay_time := 0.00
export (Vector2) var direction := Vector2.RIGHT

onready var _delay_timer := $DelayTimer
onready var _shoot_position := $ShootPosition

func _ready():
	if delay_time > 0:
		_delay_timer.wait_time = delay_time
		_delay_timer.start()
	else:
		_spawn()
	randomize()


func _spawn() -> void:
	var laser:LaserLantern = object_scene.instance()
	laser.target_position = Vector2(0, 300)
	laser.lifetime = lantern_lifetime
	Projectiles.add_child(laser)
	laser.global_position = _shoot_position.global_position
	emit_signal("spawned_object")
	

func _on_DelayTimer_timeout() -> void:
	_spawn()
