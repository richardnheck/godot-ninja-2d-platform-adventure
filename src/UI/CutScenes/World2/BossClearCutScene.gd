##################################
# World 2 - Boss Clear Cut Scene
##################################
extends Node

onready var cut_scene_base:CutSceneBase = $CutSceneBase
onready var boss = $Boss
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var text_animation_player:AnimationPlayer = $TextAnimationPlayer
onready var screen_shake = $ScreenShake
onready var stage_clear_text = $StageClearText
onready var tween = $Tween
onready var fade_screen = $FadeScreen
onready var demon_seal = $"%DemonSeal"
onready var player_for_cutscene = $"%PlayerForCutscene"

func _ready() -> void:
	# Randomize the random number generator's seed
	randomize()
	
	animation_player.play("RESET")
	
	# Stop the current background music
	Game_AudioManager.stop_bgm()
	
	# Hide explosions
	var explosions = get_tree().get_nodes_in_group("explosion")
	for explosion in explosions:
		explosion.visible = false
	
	cut_scene_base.show_continue(false)
	Actions.use_cutscene_actions()
	screen_shake.set_camera_node("Camera2D")
	stage_clear_text.visible = false

	animation_player.play("walk_in")	

func play_bgm() -> void:
	Game_AudioManager.play_cave_level_boss_outro()	

func play_explosion_sfx() -> void: 
	Game_AudioManager.sfx_env_cave_boss_cutscene_crash.play()			
	
func do_boss_fly_in() -> void:
	animation_player.play("boss_fly_in")

func do_boss_wall_bounce_fx() -> void:
	Game_AudioManager.sfx_env_cave_boss_cutscene_slam.play()
	screen_shake.screen_shake(1,3,100)


func do_boss_anger_fit() -> void:
	animation_player.play("boss_angry")
	yield(animation_player, "animation_finished")
	do_boss_explosion()

func do_boss_explosion() -> void:
	animation_player.play("explode_boss")
	yield(animation_player, "animation_finished")
	yield(get_tree().create_timer(0.5), "timeout")
	do_grab_talisman()
	
func do_explosion(explosionNumber:int) -> void:
	var explosion:AnimatedSprite = get_node("Boss/Explosions/Explosion" + str(explosionNumber))	
	explosion.visible = true
	explosion.play()
	play_explosion_sfx()
	
func do_grab_talisman() -> void:
	animation_player.play("grab_talisman")
	
func trigger_talisman() -> void:
	demon_seal.grab_seal()
	
func do_ending() -> void:
	yield(get_tree().create_timer(1), "timeout")
	show_text()
	player_for_cutscene.animation = "celebrate"
	Game_AudioManager.stop_bgm()
	yield(get_tree().create_timer(2.5), "timeout")
	fade_screen.go_to_scene("res://src/UI/WorldSelectScreen/WorldSelect.tscn")
		
		
func show_text() -> void:
	text_animation_player.play("show")
	
func hover_text() -> void:
	text_animation_player.play("hover")
		
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	pass
