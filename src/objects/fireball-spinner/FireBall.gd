extends Node2D
class_name FireBall

var _showing:bool = false setget _set_showing, _get_showing
var _current_rotation_degrees = 0


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
	 
	
func rotate2(degrees:float) -> void:
	rotation_degrees = degrees	


# Remember the current rotation so it can be adjusted incrementally
func remember_current_rotation() -> void:
	_current_rotation_degrees = rotation_degrees
	
	
# Adjust the rotation of the fireball by the specified number of degrees
func adjust_rotation(degrees:float) -> void:
	rotation_degrees = _current_rotation_degrees + degrees
		
	
# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER) and _showing:
		# The body is the player so the player dies
		body.die()

