extends Node


onready var cut_scene_base = $CutSceneBase
onready var dialog1 = $MainControl/DialogBox1
onready var dialog2 = $MainControl/DialogBox2
onready var dialog3 = $MainControl/DialogBox3
onready var animationPlayer = $AnimationPlayer
onready var screen_shake = $ScreenShake
onready var boss_animated_sprite = $Boss/AnimatedSprite

signal continue_sig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game_AudioManager.play_cave_level_boss_intro()
	
	cut_scene_base.connect("on_continue", self, "_on_continue")
	
	# Set the camera for the screen shake
	screen_shake.set_camera_node("Camera2D")
	
	# Hide continue button
	show_continue_button(false)
	
	# Hide dialogs
	dialog1.hide()
	dialog2.hide()
	dialog3.hide()
	
	# Walk player in to middle of the screen under boss
	_walk_in()
	
	
		
func _walk_in() -> void:
	animationPlayer.play("walk-in")
	
func _start_dialog() -> void:
	# Show dialog 1 and wait for continue
	dialog1.show()
	show_continue_button(true)
	yield(self, "continue_sig")
	
	# Show dialog 2 and wait for continue
	dialog1.hide()
	dialog2.show()
	yield(self, "continue_sig")
	
	# Walk player out
	dialog2.hide()
	show_continue_button(false)
	boss_animated_sprite.animation = "awake"
	yield(get_tree().create_timer(0.3), "timeout")
	
	_walk_out()

func _walk_out() -> void:
	animationPlayer.play("walk-out")
	
func _goto_next_scene() -> void:
	
	$CutSceneBase.goto_next_scene()

func _shake_screen() -> void:
	# Play the boss slam sound
	Game_AudioManager.sfx_env_cave_boss_cutscene_slam.play()
	
	# Shake the screen
	screen_shake.screen_shake(2,4,100)		

func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")

func show_continue_button(show:bool) -> void:
	cut_scene_base.show_continue(show)
	
	
