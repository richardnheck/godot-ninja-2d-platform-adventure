extends Node2D

func _ready():
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	queue_free()
