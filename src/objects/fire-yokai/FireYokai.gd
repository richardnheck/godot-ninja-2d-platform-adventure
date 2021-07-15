extends AnimatedSprite
class_name FireYokai

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func trigger():
	# Fly it off the screen upwards
	var sprite = self
	$Tween.interpolate_property(self, "position", sprite.global_position, Vector2(sprite.global_position.x, sprite.global_position.y - 100), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)    
	$Tween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	# When tween ends remove object from scene
	queue_free()
