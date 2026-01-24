class_name GameEndCutScene
extends Node

onready var animation_player = $AnimationPlayer
onready var cut_scene_base = $CutSceneBase

func _ready():
	show_continue_button(false)
	animation_player.play("RESET")
	animation_player.play("first-scene")
	
func _goto_next_scene() -> void:
	$CutSceneBase.goto_next_scene()

func show_continue_button(show:bool) -> void:
	cut_scene_base.show_continue(show)
