extends Node

onready var cut_scene_base:CutSceneBase = $CutSceneBase
onready var player:Player = $Player
onready var boss:RigidBody2D = $Boss
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var text_animation_player:AnimationPlayer = $TextAnimationPlayer
onready var screen_shake = $ScreenShake
onready var stage_clear_text = $StageClearText
onready var tween = $Tween
onready var fade_screen = $FadeScreen

var _move_player_right:bool = false
var _move_player_left:bool = false
var _move_boss_right:bool = false


func _ready() -> void:
	# Stop the current background music
	Game_AudioManager.stop_bgm()
	
	cut_scene_base.show_continue(false)
	Actions.use_cutscene_actions()
	screen_shake.set_camera_node("Camera2D")
	stage_clear_text.visible = false
	animation_player.play("walk_in")	
	player.get_node("Camera2D").current = false  # make sure the player's camera is not used
	
		
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

func play_bgm() -> void:
	Game_AudioManager.play_cave_level_boss_outro()	
		
func do_boss_walk_in() -> void:
	animation_player.play("boss_walk_in")
	
func do_boss_jump() -> void:
	# Move the boss
	move_boss_stop()
	
	# Apply an impulse to make the boss jump
	boss.apply_central_impulse( Vector2(45,-200))
	
	# Wait long enough for the boss to have fallen down the gap
	yield(get_tree().create_timer(4), "timeout")
	boss.queue_free()
	
	# Boss lands so play a crash sound and shake the screen
	Game_AudioManager.sfx_env_cave_boss_cutscene_crash.play()
	screen_shake.screen_shake(2,4,100)
	
	# Wait a few moments after crash before walking to grab talisman
	yield(get_tree().create_timer(2), "timeout")
	do_grab_talisman()

func do_grab_talisman() -> void:
	animation_player.play("grab_talisman")
	
func do_ending() -> void:
	yield(get_tree().create_timer(1), "timeout")
	show_text()
	player.celebrate()
	yield(get_tree().create_timer(2.8), "timeout")
	Game_AudioManager.stop_bgm()
	yield(get_tree().create_timer(1), "timeout")
	# Show the temporary end scene for the demo		
	fade_screen.go_to_scene("res://src/UI/TemporaryEndScene.tscn")
		
		
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

func play_boss_fall() -> void:
	Game_AudioManager.sfx_env_cave_boss_cutscene_fall.play()
	
		
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print(anim_name + " animation finished")

# This Stop Point Area ensures that the player stops at the exact spot
# This is required because on HTML5 build it can walk further and therefore
# be off the screen when player collects the gem
func _on_StopPointArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		move_player_stop()
		$StopPointArea2D/CollisionShape2D.set_deferred("disabled", true)
