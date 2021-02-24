extends Node

onready var player:Player = $Player
onready var boss:RigidBody2D = $BossRigidBody
onready var animation_player:AnimationPlayer = $AnimationPlayer

var _move_right:bool = false
var _move_left:bool = false

func _ready() -> void:
	Actions.use_cutscene_actions()
	
	#animation_player.play("walk_in")	
	yield(get_tree().create_timer(1), "timeout")
	$Sprite.position = boss.get_global_transform().origin
	boss.apply_impulse(boss.get_global_transform().origin, Vector2(100,-350))
	#boss.apply_central_impulse(Vector2(0,500))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _move_right:
		player.move_right()
	elif _move_left:
		player.move_left()
	else:
		player.move_stop()

func move_right() -> void:
	_move_right = true
	_move_left = false
	
func move_left() -> void:
	_move_left = true
	_move_right = false
	
func move_stop() -> void:
	_move_left = false
	_move_right = false
	
func look_left() -> void:
	print("look left")
	move_left()
	yield(get_tree().create_timer(0.05), "timeout")
	move_stop()
