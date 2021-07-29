extends Node


onready var area2D:Area2D = $Area2D
onready var animatedSprite:AnimatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	area2D.connect("body_entered", self, "_on_body_entered")
	
	# Start animation at a random time
	var t = rand_range(0,2)
	yield(get_tree().create_timer(t),"timeout")
	animatedSprite.playing = true

# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
