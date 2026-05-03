##################################
# Game End Cut Scene
##################################
class_name GameEndCutScene
extends Control

onready var animation_player = $AnimationPlayer
onready var cut_scene_base = $CutSceneBase
onready var dialog1 = $"%DialogBox1"
onready var dialog2 = $"%DialogBox2"
onready var dialog3 = $"%DialogBox3"
onready var dialog4 = $"%DialogBox4"

signal continue_sig

var light_pulse_sfx:AudioStreamPlayer

func _ready():
	# Duplicate so we can play at a quieter volume without changing the default volume
	light_pulse_sfx = Game_AudioManager.sfx_env_altar_light_beam_pulse.duplicate()
	light_pulse_sfx.volume_db = -15
	add_child(light_pulse_sfx)

	show_continue_button(false)
	animation_player.play("RESET")
	cut_scene_base.connect("on_continue", self, "_on_continue")
	
	animation_player.play("first-scene")
	yield(animation_player, "animation_finished")
	animation_player.play("last-scene")
	Game_AudioManager.play_story_outro(false)  # fade in 
	
func _start_dialog() -> void:
	# Show dialog 1 and wait for continue
	dialog1.show()
	show_continue_button(true)
	yield(self, "continue_sig")
	
	# Show dialog 2 and wait for continue
	dialog1.hide()
	dialog2.show()
	yield(self, "continue_sig")
	
	# Show dialog 3 and wait for continue
	dialog2.hide()
	dialog3.show()
	yield(self, "continue_sig")
	
	# Show dialog 4 and wait for continue
	dialog3.hide()
	dialog4.show()
	yield(self, "continue_sig")
	
	dialog4.hide()
	cut_scene_base.show_continue(false)
	cut_scene_base.show_skip(false)
	
	animation_player.play("the-end")
	yield(animation_player, "animation_finished")
	
	_goto_next_scene()

func _goto_next_scene() -> void:
	var show_loading_message = false
	var source_scene_path:String = ""
	var stop_bgm_on_html5:bool = false	 # In this case we a playing the same bgm music in the next scene so don't stop it on html5
	$CutSceneBase.goto_next_scene(show_loading_message, source_scene_path, stop_bgm_on_html5)
	
func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")

func show_continue_button(show:bool) -> void:
	cut_scene_base.show_continue(show)

func _play_rumble_sfx() -> void:
	var sfx:AudioStreamPlayer = Game_AudioManager.sfx_env_long_explosion_rumble.duplicate()
	sfx.volume_db = -9
	add_child(sfx) 
	sfx.play()

func _play_light_pulse_sfx() -> void:
	light_pulse_sfx.play()
