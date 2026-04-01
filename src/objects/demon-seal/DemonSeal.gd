class_name DemonSeal
extends Node2D

onready var collision_shape = $CollisionShape2D
onready var effect_animation = $EffectAnimation
onready var sprite = $AnimatedSprite
onready var placed_effect_animation = $PlacedEffectAnimation

onready var tween_values = [null, null]

enum Colour { 
	BLUE = 0,
	GREEN = 1,
	RED = 2
}

export(Colour) var colour = Colour.BLUE setget set_colour
export(bool) var hover = true setget set_hover

func set_colour(value):
	colour = value
	
func set_hover(value):
	hover = value

func _ready():
	effect_animation.visible = false
	placed_effect_animation.visible = false
	
	if colour == Colour.GREEN:
		sprite.animation = "green"
	elif colour == Colour.RED:
		sprite.animation = "red"
	elif colour == Colour.BLUE:
		sprite.animation = "blue"
		
	if hover:	
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
	print("body grabbed seal")
	if body.is_in_group(Constants.GROUP_PLAYER):
		grab_seal()

func grab_seal() -> void:
	emit_signal("demon_seal_grabbed")
	collision_shape.set_deferred("disabled", true)
	sprite.visible = false
	effect_animation.visible = true
	effect_animation.play()
	Game_AudioManager.sfx_collectibles_demon_seal.play()

func _on_EffectAnimation_animation_finished() -> void:
	queue_free()

# Called from cutscene when placed on the altar
func place() -> void:
	# Make visible when placed
	self.visible = true
		
	# Show placed effect
	placed_effect_animation.visible = true
	placed_effect_animation.play()
	Game_AudioManager.sfx_collectibles_place_demon_seal.play()
	
