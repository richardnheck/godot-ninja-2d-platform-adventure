########################################
# World 3 - Boss Clear Cut Scene (Part1)
########################################
class_name World3BossClearCutScenePart1

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
	
	Game_AudioManager.play_cave_level_boss_intro()
	
	cut_scene_base.connect("on_continue", self, "_on_continue")
	
	# Set the camera for the screen shake
	screen_shake.set_camera_node("Camera2D")
	
	# Hide continue button
	show_continue_button(false)
	
	# Walk player in
	_walk_in()
		
func _walk_in() -> void:
	animation_player.play("walk-in")
	
func _start_dialog() -> void:
	# Show dialog 1 and wait for continue
	dialog1.show()
	show_continue_button(true)
	yield(self, "continue_sig")
	dialog1.hide()
	show_continue_button(false)
	do_grab_talisman()
	
func do_grab_talisman() -> void:
	animation_player.play("grab_talisman")
	yield(animation_player, "animation_finished")
	_start_dialog2()
	
func _start_dialog2() -> void:
	dialog2.show()
	show_continue_button(true)
	yield(self, "continue_sig")
	dialog2.hide()
	show_continue_button(false)
	do_enter_boss()
	
func do_enter_boss() -> void:
	animation_player.play("enter-boss")
	
func _goto_next_scene() -> void:
	$CutSceneBase.goto_next_scene()

# Shake the screen when the boss hits the ground
func _shake_screen() -> void:
	# Play the boss slam sound
	Game_AudioManager.stop_bgm()
	Game_AudioManager.sfx_env_cave_boss_cutscene_slam.play()
	
	# Shake the screen
	screen_shake.screen_shake(2,4,100)		

func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")

func show_continue_button(show:bool) -> void:
	cut_scene_base.show_continue(show)

