##################################
# Game Credits Scene
##################################
class_name GameCreditsScene
extends Node

onready var animation_player = $AnimationPlayer
onready var cut_scene_base = $CutSceneBase
onready var back_button = $"%BackButton"

func _ready():
	Game_AudioManager.play_story_outro(false)	# Don't fade in music if scene loaded directly
	
	var previous_scene = Global.get_previous_scene()
	if "GameEndCutScene" in previous_scene or previous_scene == "":
		# This is show after the final game end so back button navigates home
		# As fallback if previous scene not set for some reason then go home as well
		back_button.next_scene_path = "res://src/UI/MainScreen/MainScreen.tscn"
	else:
		back_button.next_scene_path = Global.get_previous_scene()
		
	show_continue_button(false)
	animation_player.play("RESET")
	

func _goto_next_scene() -> void:
	$CutSceneBase.goto_next_scene()
	
func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")

func show_continue_button(show:bool) -> void:
	cut_scene_base.show_continue(show)
