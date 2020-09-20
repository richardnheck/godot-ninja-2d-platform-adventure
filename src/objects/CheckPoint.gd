extends Area2D

signal reached

var on:bool = false

func _ready() -> void:
	on = false
	$AnimatedSprite.play("off")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER) and !on:
		on = true
		$AnimatedSprite.play("on")
		$Sound.play()
		emit_signal("reached")
