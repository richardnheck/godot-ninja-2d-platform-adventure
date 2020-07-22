extends Node2D


onready var key = $InteractiveProps/KamonKey
onready var door = $InteractiveProps/Door
onready var endTimer = $EndTimer
onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door.close()


func _on_Key_captured() -> void:
	door.open()

func _on_Door_player_entered() -> void:
	# Disable player physics 
	player.set_physics_process(false)
	player.celebrate()
	endTimer.start()


func _on_EndTimer_timeout() -> void:
	get_tree().reload_current_scene()


