extends Area2D


onready var tween = $Tween
onready var effectAnimation = $EffectAnimation
onready var effectSound = $EffectSound
onready var collisionShape = $CollisionShape2D
onready var sprite = $CollisionShape2D/Sprite

onready var tween_values = [Vector2(0,0), Vector2(0,-4)]

signal gem_grabbed


func _ready():
	_start_tween()

func _start_tween():
	$Tween.interpolate_property(collisionShape, "position", tween_values[0], tween_values[1], 1,
	 Tween.TRANS_SINE)    
	$Tween.start()

func _on_tween_completed(object, key):
	tween_values.invert()
	_start_tween()


#func _ready():
	#tween.interpolate_property(sprite, "Transform/Scale", 1, 2, 5, Tween.TRANS_QUAD, Tween.EASE_IN)
	#tween.interpolate_property(self, "position", Vector2(0,0), Vector2(0,0), 1, Tween.TRANS_SINE, Tween.EASE_IN)
	#tween.start()

func _on_Gem_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		emit_signal("gem_grabbed")
		collisionShape.set_deferred("disabled", true)
		sprite.visible = false
		effectAnimation.play()
		effectSound.play()


func _on_EffectAnimation_animation_finished() -> void:
	queue_free()
