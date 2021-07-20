extends Node2D

onready var collision_shape = $CollisionShape2D
onready var effect_animation = $EffectAnimation
onready var sprite = $AnimatedSprite

onready var tween_values = [null, null]

func _ready():
	_start_tween()


func _start_tween():
	if tween_values[0] == null:
		tween_values[0] = global_position
		tween_values[1] = Vector2(global_position.x, global_position.y - 4)
	$Tween.interpolate_property(self, "position", tween_values[0], tween_values[1], 1.5, Tween.TRANS_SINE)    
	$Tween.start()


func _on_tween_completed(object, key):
	tween_values.invert()
	_start_tween()

func _on_body_entered(body) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		emit_signal("demon_seal_grabbed")
		collision_shape.set_deferred("disabled", true)
		sprite.visible = false
		effect_animation.play()
		Game_AudioManager.sfx_collectibles_demon_seal.play()

func _on_EffectAnimation_animation_finished() -> void:
	queue_free()
