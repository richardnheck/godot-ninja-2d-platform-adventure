tool
extends KinematicBody2D
class_name Hannya

enum Direction {
	LEFT = -1,		# Towards Screen left
	RIGHT = 1		# Towards Screen right
}

export(Direction) var direction = Direction.RIGHT setget _set_direction

onready var trigger_collision_shape := $TriggerArea2D/CollisionShape2D
onready var telegraph_tween:= $TelegraphTween
onready var animated_sprite:=$AnimatedSprite 

var telegraph_tween_values = [Vector2.ZERO, Vector2.ZERO]

# The time in seconds to telegraph attack before flying
const telegraph_time:= 0.20

# The distance in pixels of the telegraph (i.e. move back before attacking)
const telegraph_distance:= 10

# When triggered, the Hannya flies across the screen at high speed
var triggered = false

const speed = 390
var velocity = Vector2()

func _set_direction(value) -> void:
	direction = value
	
func _ready() -> void:
	print_debug("Hannya")
	print_debug(str(global_position))
	
	# set the direction of the Hannya
	self.scale.x = -direction
	
		
func _physics_process(delta:float) -> void:
	if triggered:
		velocity.x = direction * speed
		move_and_slide(velocity, Vector2())


func _on_VisibilityNotifier2D_screen_exited():
	# if triggered and off the screen then remove
	if triggered:
		print_debug("Hannya removed!")
		queue_free()


func _on_TriggerArea2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		if not triggered:
			# Trigger the telegraph before the attack
			# set the telegraph tween value to move the sprite backwards before attacking
			telegraph_tween_values = [position, Vector2(position.x + (-direction * telegraph_distance), position.y)]
			telegraph_tween.interpolate_property(self, "position", telegraph_tween_values[0], telegraph_tween_values[1], telegraph_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			telegraph_tween.start()
		


func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_TelegraphTween_tween_completed(object, key):
	# telegraph has finished so trigger the main fast surge attack
	triggered = true
	animated_sprite.animation = "attack"
