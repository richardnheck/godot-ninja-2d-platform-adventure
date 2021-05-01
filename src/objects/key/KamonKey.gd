extends AnimatedSprite

signal captured

onready var collisionShape = $Area2D/CollisionShape2D

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The player has captured the key
		collisionShape.set_deferred("disabled", true)
		emit_signal("captured")
		Game_AudioManager.sfx_collectibles_key.play()
		visible = false
		queue_free()		
