##################################
# World 1 - Boss Clear Cut Scene
##################################
extends Node

onready var cut_scene_base:CutSceneBase = $CutSceneBase
onready var player_for_cutscene = $"%PlayerForCutscene"
onready var boss:RigidBody2D = $Boss
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var text_animation_player:AnimationPlayer = $TextAnimationPlayer
onready var screen_shake = $ScreenShake
onready var stage_clear_text = $StageClearText
onready var tween = $Tween
onready var fade_screen = $FadeScreen
onready var demon_seal:DemonSeal = $"%DemonSeal"

var _move_boss_right:bool = false


func _ready() -> void:
	# Stop the current background music
	Game_AudioManager.stop_bgm()
	
	cut_scene_base.show_continue(false)
	Actions.use_cutscene_actions()
	screen_shake.set_camera_node("Camera2D")
	stage_clear_text.visible = false
	animation_player.play("walk_in")	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
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

func trigger_talisman() -> void:
	demon_seal.grab_seal()
	
func do_ending() -> void:
	yield(get_tree().create_timer(1), "timeout")
	show_text()
	player_for_cutscene.animation = "celebrate"
	yield(get_tree().create_timer(2.8), "timeout")
	Game_AudioManager.stop_bgm()
	yield(get_tree().create_timer(1), "timeout")
	cut_scene_base.goto_next_scene()
		
		
func show_text() -> void:
	text_animation_player.play("show")
	
func hover_text() -> void:
	text_animation_player.play("hover")
		
func look_player_left() -> void:
	player_for_cutscene.flip_h = true

func move_boss_right() -> void:
	_move_boss_right = true

func move_boss_stop() -> void:
	boss.linear_velocity = Vector2(0,0)
	_move_boss_right = false

func play_boss_fall() -> void:
	Game_AudioManager.sfx_env_cave_boss_cutscene_fall.play()
	
func _trigger_platform_explosions() -> void:
	var platforms = get_tree().get_nodes_in_group("platform")
	for platform in platforms:
		platform.trigger_crumble() 
		yield(get_tree().create_timer(0.2), "timeout")
		
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	pass
