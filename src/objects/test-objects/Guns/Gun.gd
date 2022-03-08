class_name Gun
extends Node2D

enum MODE { NORMAL, AUTOMATIC, CHARGE, TIMED }

export (PackedScene) var bullet_scene
export var shoot_rate := 0.25
export var delay_time := 0.00
export (MODE) var mode := MODE.NORMAL
export var max_charge_time := 2.0
export var spread_angle := 0.0
export (Vector2) var direction := Vector2.RIGHT
export var impulse := 370

var charge_time := 0.0
var is_charging := false

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
		MODE.NORMAL:
			if Input.is_action_just_pressed("shoot") and _can_shoot():
				_shoot()
		MODE.AUTOMATIC:
			if Input.is_action_pressed("shoot") and _can_shoot():
				_shoot()
		MODE.CHARGE:
			if Input.is_action_pressed("shoot") and _can_shoot():
				is_charging = true
			if Input.is_action_just_released("shoot") and is_charging:
				is_charging = false
				_shoot()
			if is_charging:
				charge_time = min(charge_time + delta, max_charge_time)


func _shoot() -> void:
	print("Shoot")
	_shoot_timer.wait_time = shoot_rate
	_shoot_timer.start()

	var bullet = bullet_scene.instance()
	print(bullet)
	#bullet.direction = direction.rotated(rand_range(-spread_angle, spread_angle))
	bullet.direction = direction
	print("bullet direction", bullet.direction)
	Projectiles.add_child(bullet)
	bullet.global_position = _shoot_position.global_position

	if "charge" in bullet:
		print("charge", charge_time)
		bullet.charge = charge_time / max_charge_time

	if "impulse" in bullet:
		bullet.impulse = impulse
		
	charge_time = 0.0
	


func _can_shoot() -> bool:
	return _shoot_timer.is_stopped()


func _on_ShootTimer_timeout() -> void:
	print("timeout")
	if mode == MODE.TIMED:
		_shoot()


func _on_DelayTimer_timeout() -> void:
	_shoot()
