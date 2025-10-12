extends KinematicBody2D
class_name Platform

var _showing:bool = false setget set_showing, get_showing
var _current_rotation_degrees = 0

onready var collision_shape:CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_showing(_showing)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Setter for showing
# Sets whether the fireball is showing (when showing fireball is visible)
func set_showing(value:bool) -> void:
	_showing = value
	visible = value
	if is_instance_valid(collision_shape):
		collision_shape.set_deferred("disabled", not value)	


# Getter for showing
func get_showing() -> bool:
	return _showing


# Show/hide the fireball
func show_platform(value:bool) -> void:
	set_showing(value)
		
	 
# Remember the current rotation so it can be adjusted incrementally
func remember_current_rotation() -> void:
	_current_rotation_degrees = rotation_degrees
	
	
# Adjust the rotation of the platform by the specified number of degrees
func adjust_rotation(degrees:float) -> void:
	print_debug("adjust_rotation:" + str(degrees))
	rotation_degrees = _current_rotation_degrees + degrees
		
	
# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		pass #body.die()

