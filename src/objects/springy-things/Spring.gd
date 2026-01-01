extends Area2D

const impulse = 135

onready var animated_sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.animation = "default"

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		if body.has_method("spring"):
			body.spring(Vector2(0, impulse))
			animated_sprite.play("launch")


func _on_AnimatedSprite_animation_finished():
	animated_sprite.animation = "default"
