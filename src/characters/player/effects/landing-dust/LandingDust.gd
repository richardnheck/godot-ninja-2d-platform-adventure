extends AnimatedSprite


func _ready() -> void:
	print("landing dust...")
	# Play the animation
	play()

func _on_animation_finished() -> void:
	queue_free()
