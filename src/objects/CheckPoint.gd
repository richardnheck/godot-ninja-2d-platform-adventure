extends Area2D

signal reached

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		$Sound.play()
		emit_signal("reached")
