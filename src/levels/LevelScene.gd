extends LevelBase


func _on_Key_captured() -> void:
	door.open()

func _on_Door_player_entered() -> void:
	# Disable player physics 
	player.set_physics_process(false)
	player.celebrate()
	endTimer.start()


func _on_EndTimer_timeout() -> void:
	goto_next_level()

