extends AnimatedSprite


func _ready() -> void:
	# Play the animation
	play()

func _on_animation_finished() -> void:
	queue_free()
