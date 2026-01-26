##################################
# Game Credits Scene
##################################
class_name GameCreditsScene
extends Node

onready var animation_player = $AnimationPlayer
onready var cut_scene_base = $CutSceneBase

func _ready():
	show_continue_button(false)
	animation_player.play("RESET")

func _goto_next_scene() -> void:
	$CutSceneBase.goto_next_scene()
	
func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")

func show_continue_button(show:bool) -> void:
	cut_scene_base.show_continue(show)
