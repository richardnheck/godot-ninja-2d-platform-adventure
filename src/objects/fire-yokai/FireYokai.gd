extends AnimatedSprite
class_name FireYokai

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func trigger():
	var sprite = self
	$Tween.interpolate_property(self, "position", sprite.global_position, Vector2(sprite.global_position.x, sprite.global_position.y - 100), 1.5, Tween.TRANS_QUINT, Tween.EASE_IN)    
	$Tween.start()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
