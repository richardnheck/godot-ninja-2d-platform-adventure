extends Node2D
class_name MiniBossSlamBlast


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var velocity = 3
export(int) var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_direction(dir):
	direction = dir
	if(direction == -1):
		$Area2D/AnimatedSprite.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Area2D.position.x += velocity * direction
#	pass


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
