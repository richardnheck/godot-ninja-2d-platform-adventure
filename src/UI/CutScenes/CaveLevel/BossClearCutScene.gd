extends Node

onready var player:Player = $Player2

var move_right:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputMap.erase_action("move_left")
	InputMap.erase_action("move_right")
	yield(get_tree().create_timer(2), "timeout")
	InputMap.load_from_globals()
	
	player.disable_input(true)
	move_right = true	
	yield(get_tree().create_timer(0.5), "timeout")
	move_right = false	
	player.move_stop()
	
	# This stops jump from working but not move
	get_tree().get_root().set_disable_input(true)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_right:
		player.move_right()
			

