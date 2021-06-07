extends Area2D

signal reached

var _on:bool = false

func _ready() -> void:
	set_on(false)


func set_on(on:bool) -> void:
	_on = on
	if on:
		$AnimatedSprite.play("on")
	else:
		$AnimatedSprite.play("off")	


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER) and !_on:
		set_on(true)
		Game_AudioManager.sfx_env_check_point.play()
		emit_signal("reached")
