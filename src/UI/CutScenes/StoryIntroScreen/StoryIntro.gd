extends Node

# local signal to yield on
signal continue_sig

# Declare member variables here. Examples:
var continue_flag: bool = false


onready var cut_scene_base = $CutSceneBase
onready var player:Player = $Player
onready var animation_player = $AnimationPlayer
onready var dialog1 = $Control/DialogBox1
onready var dialog2 = $Control/DialogBox2
onready var dialog3 = $Control/DialogBox3

var _move_player_right:bool = false
var _move_player_left:bool = false

var dialog_index = 0
var dialogs = null
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.use_cutscene_actions()
	cut_scene_base.show_continue(false)
	
	cut_scene_base.connect("on_continue", self, "_on_continue")
	
	# make sure the player's camera is not used
	player.get_node("Camera2D").current = false 
	
	player.connect("screen_exited", self, "_on_player_screen_exited")
	
	dialogs = [ dialog1, dialog2, dialog3]
	
	# hide all dialogs
	for i in range(0, dialogs.size()):
		dialogs[i].hide()
	
	# wait a bit before starting walk in
	yield(get_tree().create_timer(0.25), "timeout")
	animation_player.play("walk-in")	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		if _move_player_right:
			player.move_right()
		elif _move_player_left:
			player.move_left()
		else:
			player.move_stop()

func start_dialog():
	player.talk()

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
	
func _on_player_screen_exited() -> void:
	player.queue_free()
	
	# Goto the next scene
	cut_scene_base.goto_next_scene()
	
func _on_continue()->void:
	if cut_scene_base.is_continue_button_showing():
		emit_signal("continue_sig")
		
func start_walk_out():
	player.move()
	animation_player.play("walk-out")
	
func jump():
	animation_player.play("jump")
	player.jump()
			
func move_player_right():
	_move_player_right = true
	_move_player_left = false

func move_player_left():
	_move_player_right = false
	_move_player_left = true
	
func move_player_stop():
	_move_player_right = false
	_move_player_left = false
			
func goto_next_scene()->void:
	cut_scene_base.goto_next_scene()
