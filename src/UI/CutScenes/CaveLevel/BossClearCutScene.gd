extends Node

onready var player:Player = $Player
onready var boss:RigidBody2D = $Boss
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var text_animation_player:AnimationPlayer = $TextAnimationPlayer
onready var screen_shake = $ScreenShake
onready var stage_clear_text = $StageClearText
onready var tween = $Tween

var _move_player_right:bool = false
var _move_player_left:bool = false
var _move_boss_right:bool = false


func _ready() -> void:
	Actions.use_cutscene_actions()
	screen_shake.set_camera_node("Camera2D")
	stage_clear_text.visible = false
	animation_player.play("walk_in")	
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _move_player_right:
		player.move_right()
	elif _move_player_left:
		player.move_left()
	else:
		player.move_stop()
		
	if _move_boss_right:
		boss.linear_velocity = Vector2(90,0)
	
		
func do_boss_walk_in() -> void:
	animation_player.play("boss_walk_in")
	
func do_boss_jump() -> void:
	move_boss_stop()
	boss.apply_central_impulse( Vector2(45,-200))
	yield(get_tree().create_timer(4), "timeout")
	boss.queue_free()
	do_ending()
	
func do_ending() -> void:
	screen_shake.screen_shake(2,4,100)		
	yield(get_tree().create_timer(1), "timeout")
	show_text()
	player.celebrate()
	yield(get_tree().create_timer(4), "timeout")		
	get_tree().change_scene("res://src/UI/TemporaryEndScene.tscn")
		
		
func show_text() -> void:
	text_animation_player.play("show")
	
func hover_text() -> void:
	text_animation_player.play("hover")

func move_player_right() -> void:
	_move_player_right = true
	_move_player_left = false
	
func move_player_left() -> void:
	_move_player_left = true
	_move_player_right = false
	
func move_player_stop() -> void:
	_move_player_left = false
	_move_player_right = false
	
func look_player_left() -> void:
	move_player_left()
	yield(get_tree().create_timer(0.05), "timeout")
	move_player_stop()

func move_boss_right() -> void:
	_move_boss_right = true

func move_boss_stop() -> void:
	boss.linear_velocity = Vector2(0,0)
	_move_boss_right = false

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print(anim_name + " animation finished")
