extends Node

# local signal to yield on
signal continue_sig

# Declare member variables here. Examples:
var continue_flag: bool = false


onready var cut_scene_base = $CutSceneBase
onready var animation_player = $AnimationPlayer
onready var dialog1 = $Control/DialogBox1
onready var dialog2 = $Control/DialogBox2
onready var dialog3 = $Control/DialogBox3
onready var fade_screen

var dialog_index = 0
var dialogs = null
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game_AudioManager.play_story_intro()
	Actions.use_cutscene_actions()
	cut_scene_base.show_continue(false)
	
	cut_scene_base.connect("on_continue", self, "_on_continue")
	
	dialogs = [ dialog1, dialog2, dialog3]
	
	# hide all dialogs
	for i in range(0, dialogs.size()):
		dialogs[i].hide()
	
	# wait a bit before starting walk in
	yield(get_tree().create_timer(0.25), "timeout")
	animation_player.play("walk-in")
	
	# indicate in game state that player has watched the story intro
	# even if they haven't watched it to the end
	GameState.set_has_watched_story_intro(true)	

func start_dialog():
	# Show dialog 1 and wait for continue
	dialog1.show()
	cut_scene_base.show_continue(true)
	yield(self, "continue_sig")
	
	# Show dialog 2 and wait for continue
	dialog1.hide()
	dialog2.show()
	yield(self, "continue_sig")
	
	# Show dialog 3 and wait for continue
	dialog2.hide()
	dialog3.show()
	yield(self, "continue_sig")
	
	# Walk player out
	dialog3.hide()
	cut_scene_base.show_continue(true)
	start_walk_out()
	
func _goto_next_scene() -> void:
	# Goto the next scene
	var show_loading_message = Settings.is_html5_build()		# Show additional loading message for slow devices on HTML5 build
	cut_scene_base.goto_next_scene(show_loading_message)
	
func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")
		
func start_walk_out():
	animation_player.play("walk-out")
	
func jump():
	animation_player.play("jump")
