extends AnimatedSprite

signal captured

onready var audioPlayer = $AudioStreamPlayer2D

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The player has captured the key
		emit_signal("captured")
		audioPlayer.play()
		set_physics_process(false)
		visible = false
		yield(audioPlayer, "finished")
		queue_free()		
