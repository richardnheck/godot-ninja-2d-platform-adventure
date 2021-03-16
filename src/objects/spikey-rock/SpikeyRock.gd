extends KinematicBody2D

# Exports
# ------------------------------------------------------
export var start_direction = 1
export var up_down = true

# Node References
# ------------------------------------------------------
onready var sprite: = $Sprite

# Variables
# ------------------------------------------------------
var vel:Vector2 = Vector2.ZERO
var direction = 1
 
var gravity:= 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = start_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if up_down:
		vel.y += gravity * direction;
		vel = move_and_slide(vel, Vector2.UP)
		if is_on_floor() or is_on_ceiling():
			direction *= -1
	else:
		vel.x += gravity * direction;
		vel = move_and_slide(vel, Vector2.UP)
		if is_on_wall():
			direction *= -1

func handle_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

func _on_TopSpikesArea_body_entered(body: Node) -> void:
	handle_body_entered(body)


func _on_BottomSpikesArea_body_entered(body: Node) -> void:
	handle_body_entered(body)

