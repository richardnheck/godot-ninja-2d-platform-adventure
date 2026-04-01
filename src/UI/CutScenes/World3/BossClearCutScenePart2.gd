########################################
# World 3 - Boss Clear Cut Scene (Part2)
########################################
class_name World3BossClearCutScenePart2

extends Node

onready var cut_scene_base = $CutSceneBase
onready var dialog1 = $MainControl/DialogBox1
onready var dialog2 = $MainControl/DialogBox2
onready var dialog3 = $MainControl/DialogBox3
onready var animation_player = $AnimationPlayer
onready var screen_shake = $ScreenShake


signal continue_sig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	animation_player.play("RESET")
	
	Game_AudioManager.play_bgm_world3_level_boss_outro()
	
	cut_scene_base.connect("on_continue", self, "_on_continue")
	
	# Set the camera for the screen shake
	screen_shake.set_camera_node("Camera2D")
	
	# Hide continue button
	show_continue_button(false)
	
	animation_player.play("main")
	
	
func _goto_next_scene() -> void:
	$CutSceneBase.goto_next_scene()

# Shake the screen when the boss hits the ground
func _shake_screen(intensity) -> void:
	screen_shake.screen_shake(15,intensity,100)		

func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")

func show_continue_button(show:bool) -> void:
	cut_scene_base.show_continue(show)

func _dim_bg_music() -> void:
	Game_AudioManager.fade_out_bgm(6)

func _play_altar_rumble_sfx():
	Game_AudioManager.sfx_env_altar_rumble.play()
	
func _play_light_pulse_sfx():
	Game_AudioManager.sfx_env_altar_light_beam_pulse.play()
