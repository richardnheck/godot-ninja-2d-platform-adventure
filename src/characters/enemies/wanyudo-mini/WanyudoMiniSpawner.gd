class_name WanyudoMiniSpawner
extends Node2D

enum MODE { TIMED }

export (PackedScene) var bullet_scene
export var shoot_rate := 0.25
export var delay_time := 0.00
var mode = MODE.TIMED
export (Vector2) var direction := Vector2.RIGHT
export var impulse := 370

onready var _shoot_timer := $ShootTimer
onready var _delay_timer := $DelayTimer
onready var _shoot_position := $ShootPosition


func _ready():
	if mode == MODE.TIMED:
		_shoot_timer.wait_time = shoot_rate
		if delay_time == 0:
			_shoot()
		else:
			_delay_timer.wait_time = delay_time
			_delay_timer.start()
	else:
		_shoot_timer.wait_time = shoot_rate
	randomize()

func _physics_process(delta: float) -> void:
	var angle = Vector2(abs(direction.x), direction.y).angle()
	rotation = angle

	match mode:
		MODE.TIMED:
			pass


func _shoot() -> void:
	_shoot_timer.wait_time = shoot_rate
	_shoot_timer.start()

	var bullet = bullet_scene.instance()	
	bullet.direction = direction
	Projectiles.add_child(bullet)
	bullet.global_position = _shoot_position.global_position

	if "impulse" in bullet:
		bullet.impulse = impulse
	

func _can_shoot() -> bool:
	return _shoot_timer.is_stopped()


func _on_ShootTimer_timeout() -> void:
	if mode == MODE.TIMED:
		_shoot()


func _on_DelayTimer_timeout() -> void:
	_shoot()
