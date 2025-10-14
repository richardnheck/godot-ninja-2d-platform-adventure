extends RigidBody2D
class_name Tofu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Tofu has hit player so kill player
		body.die()
	elif body is TileMap:
		# Tofu has hit ground so remove
		yield(get_tree().create_timer(0.2), "timeout")
		#queue_free()
