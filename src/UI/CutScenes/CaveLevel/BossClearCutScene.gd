extends Node

onready var player:Player = $Player
onready var boss:RigidBody2D = $Boss
onready var animation_player:AnimationPlayer = $AnimationPlayer

var _move_right:bool = false
var _move_left:bool = false

func _ready() -> void:
	
	
	Actions.use_cutscene_actions()
	
	animation_player.play("walk_in")	
	#do_boss_walk_in()#yield(get_tree().create_timer(1), "timeout")

func _physics_process(delta: float) -> void:
	if set_pos:
		boss.set_global_position(boss.position)
		set_pos = false
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _move_right:
		player.move_right()
	elif _move_left:
		player.move_left()
	else:
		player.move_stop()

func do_boss_walk_in() -> void:
	animation_player.play("boss_walk_in")

var set_pos = false

func do_boss_jump() -> void:
	print("boss jump")
	print(boss.position)
	boss.set_global_position(boss.position)
	boss.apply_central_impulse( Vector2(100,-350))
	

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
	move_left()
	yield(get_tree().create_timer(0.05), "timeout")
	move_stop()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print(anim_name + " animation finished")
