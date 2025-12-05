class_name OneEyedSpikey
extends SimpleEnemy

enum Direction {
	UP_DOWN,
	LEFT_RIGHT
}

export var float_offset:int = 50
export (Direction) var direction := Direction.UP_DOWN;

onready var tween_values = [Vector2.ZERO, Vector2.ZERO]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.connect("tween_completed", self, "_on_tween_completed")
	_start_tween()

# -----------------------------------------------------------------------
# Tween 1 - Hover
# -----------------------------------------------------------------------
func _start_tween():
	if(tween_values[0] == Vector2.ZERO):
		if direction == Direction.UP_DOWN:
			tween_values = [self.global_position, Vector2(self.global_position.x, self.global_position.y - float_offset)]
		else:
			tween_values = [self.global_position, Vector2(self.global_position.x - float_offset, self.global_position.y)]	
	tween.interpolate_property(self, "position", tween_values[0], tween_values[1], 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()	

func _on_tween_completed(object: Object, key: NodePath) -> void:
	tween_values.invert()
	_start_tween()
