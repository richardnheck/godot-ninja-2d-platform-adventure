##################################
# World 2 - Boss Clear Cut Scene
##################################
extends Node

onready var cut_scene_base:CutSceneBase = $CutSceneBase
onready var player:Player = $Player
onready var boss = $Boss
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var text_animation_player:AnimationPlayer = $TextAnimationPlayer
onready var screen_shake = $ScreenShake
onready var stage_clear_text = $StageClearText
onready var tween = $Tween
onready var fade_screen = $FadeScreen

var _move_player_right:bool = false
var _move_player_left:bool = false


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
	
	# temp
	animation_player.play("walk_in")	
	player.get_camera_manager().get_camera().current = false  # make sure the player's camera is not used
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _move_player_right:
		player.move_right()
	elif _move_player_left:
		player.move_left()
	else:
		player.move_stop()

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
	
func do_ending() -> void:
	yield(get_tree().create_timer(1), "timeout")
	show_text()
	player.celebrate()
	Game_AudioManager.stop_bgm()
	yield(get_tree().create_timer(2), "timeout")
	fade_screen.go_to_scene("res://src/UI/WorldSelectScreen/WorldSelect.tscn")
		
		
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
		
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print(anim_name + " animation finished")

# This Stop Point Area ensures that the player stops at the exact spot
# This is required because on HTML5 build it can walk further and therefore
# be off the screen when player collects the gem
func _on_StopPointArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		move_player_stop()
		$StopPointArea2D/CollisionShape2D.set_deferred("disabled", true)
