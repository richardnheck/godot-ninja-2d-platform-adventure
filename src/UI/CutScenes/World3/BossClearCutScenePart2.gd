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
	
	Game_AudioManager.play_cave_level_boss_intro()
	
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

