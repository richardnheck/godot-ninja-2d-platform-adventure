extends CanvasLayer

signal continue_sig

# Declare member variables here. Examples:
var continue_flag: bool = false


onready var cut_scene_base = $CutSceneBase
onready var player:Player = $Player
onready var animation_player = $AnimationPlayer
onready var dialog1 = $Control/DialogBox1
onready var dialog2 = $Control/DialogBox2

var _move_player_right:bool = false
var _move_player_left:bool = false

var dialog_index = 0
var dialogs = null
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.use_cutscene_actions()
	cut_scene_base.show_continue(false)
	cut_scene_base.connect("on_continue", self, "handle_continue")
	
	dialogs = [ dialog1, dialog2]
	
	# hide all dialogs
	for i in range(0, dialogs.size()):
		dialogs[i].hide()
	
	animation_player.play("walk-in")	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _move_player_right:
		player.move_right()
	elif _move_player_left:
		player.move_left()
	else:
		player.move_stop()

func start_dialog():
	player.talk()
	dialogs[dialog_index].show()
	cut_scene_base.show_continue(true)
	
func handle_continue() -> void:
	if dialog_index < dialogs.size():
		# Show next dialog 
		dialogs[dialog_index].hide()
		dialog_index = dialog_index + 1
		if dialog_index < dialogs.size():
			dialogs[dialog_index].show()
		else:
			start_walk_out()
	else:
		# No more dialog to show so move on
		start_walk_out()
		
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
