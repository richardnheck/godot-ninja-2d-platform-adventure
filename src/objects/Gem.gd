extends Area2D

onready var sprite = $Sprite
onready var tween = $Tween
onready var effectAnimation = $EffectAnimation
onready var effectSound = $EffectSound
onready var collisionShape = $CollisionShape2D


signal gem_grabbed

func _ready():
	pass
#	tween.interpolate_property(
#		sprite, "scale", 
#		1, 2, 5,
#		Tween.TRANS_QUAD, Tween.EASE_IN)
#	tween.start()

func _on_Gem_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		emit_signal("gem_grabbed")
		collisionShape.set_deferred("disabled", true)
		sprite.visible = false
		effectAnimation.play()
		effectSound.play()


func _on_EffectAnimation_animation_finished() -> void:
	queue_free()
