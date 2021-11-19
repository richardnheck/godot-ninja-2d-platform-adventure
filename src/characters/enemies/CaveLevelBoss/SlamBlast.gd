extends Area2D
class_name SlamBlast

onready var animated_sprite = $AnimatedSprite

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var velocity = 3
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += velocity * direction
#	pass

func set_direction(dir:int) -> void:
	direction = dir
	if (direction > 0):
		self.scale.x = 1
	else:
		# flip the direction horizontally
		self.scale.x = -1

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
