extends Node2D
class_name FireBall

var _showing:bool = false setget _set_showing, _get_showing

onready var animation_player:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = _showing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Set whether the fireball is showing (when showing fireball is visible)
func _set_showing(value:bool) -> void:
	_showing = value
	visible = value	


func _get_showing() -> bool:
	return _showing


func show_fireball(value:bool) -> void:
	_showing = value
	visible = value	


func rotate_fireball(clockwise: bool) -> void:
	if clockwise:
		rotation_degrees = 0
	else:
		rotation_degrees = 180

# TODO (maybe useful)
# ------------------------------------------
# How to make child node ignore parent rotation?
# There's the built-in node type RemoteTransform2D, which pushes its own Transform2D to another node. 
# You can configure whether you want to push translation, rotation and/or scale separately. 
# So instead of a child of the rotated parent, make your other node a sibling and have the RemoteTransform2D 
# push its transform to it. No code needed!	
#https://godotengine.org/qa/107461/how-the-f-remote-transform-2d-work-lol
		
# Doesn't work
#func rotate_fireball(ease_output: float, clockwise: bool) -> void:
#	if ease_output <= 0.1:
#		rotation_degrees = (ease_output * 2) * 90
#	elif ease_output >= 0.9:
#		rotation_degrees = (ease_output * 2 - 1) * 90


#func change_direction(clockwise: bool) -> void:
#	print("change_direction", clockwise)
#	if clockwise:
#		animation_player.play("Rotate")
#	else:
#		animation_player.play_backwards("Rotate")

	
# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER) and _showing:
		# The body is the player so the player dies
		body.die()

