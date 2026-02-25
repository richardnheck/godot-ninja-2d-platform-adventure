extends Area2D
class_name Checkpoint

signal reached

var _on:bool = false

onready var collision_shape := $CollisionShape2D

# The id of the checkpoint
# Ensure that this value is unique when using multiple checkpoints
export var id:String = '1'

func _ready() -> void:
	set_on(Constants.NO_CHECKPOINT)

func show_checkpoint(value:bool) -> void:
	self.visible = value
	collision_shape.disabled = not value
		

func set_on(checkpoint_id:String) -> void:
	_on = (id == checkpoint_id)
	if _on:
		$AnimatedSprite.play("on")
	else:
		$AnimatedSprite.play("off")	


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER) and !_on:
		set_on(id)
		Game_AudioManager.sfx_env_check_point.play()
		emit_signal("reached", id)
