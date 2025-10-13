tool
extends KinematicBody2D
class_name Hannya

enum Direction {
	LEFT = -1,		# Towards Screen left
	RIGHT = 1		# Towards Screen right
}

export(Direction) var direction = Direction.RIGHT setget _set_direction

onready var trigger_collision_shape := $TriggerArea2D/CollisionShape2D

# When triggered, the Hannya flies across the screen at high speed
var triggered = false

const speed = 350
var velocity = Vector2()

func _set_direction(value) -> void:
	direction = value
	
func _ready() -> void:
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
		triggered = true


func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
