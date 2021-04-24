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
var sfx_thud:AudioStreamPlayer2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = start_direction
	sfx_thud =  Game_AudioManager.sfx_env_spikey_rock_thud.duplicate()
	add_child(sfx_thud)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if up_down:
		vel.y += gravity * direction;
		vel = move_and_slide(vel, Vector2.UP)
		if is_on_floor() or is_on_ceiling():
			_play_thud_sound()
			direction *= -1
	else:
		vel.x += gravity * direction;
		vel = move_and_slide(vel, Vector2.UP)
		if is_on_wall():
			_play_thud_sound()
			direction *= -1

func handle_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

func _on_TopSpikesArea_body_entered(body: Node) -> void:
	handle_body_entered(body)


func _on_BottomSpikesArea_body_entered(body: Node) -> void:
	handle_body_entered(body)

func _play_thud_sound() -> void:
	sfx_thud.play()
