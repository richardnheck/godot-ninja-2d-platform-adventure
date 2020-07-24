extends AnimatedSprite

signal captured

onready var audioPlayer = $AudioStreamPlayer2D
onready var collisionShape = $Area2D/CollisionShape2D

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The player has captured the key
		collisionShape.set_deferred("disabled", true)
		emit_signal("captured")
		audioPlayer.play()
		visible = false
		yield(audioPlayer, "finished")
		queue_free()		
