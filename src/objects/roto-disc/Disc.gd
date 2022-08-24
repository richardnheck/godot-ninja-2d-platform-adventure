extends Node2D
class_name Disc

var _showing:bool = false setget set_showing, get_showing

onready var collision_shape:CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_showing(_showing)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Setter for showing
# Sets whether the object is showing (when showing fireball is visible)
func set_showing(value:bool) -> void:
	_showing = value
	visible = value
	if is_instance_valid(collision_shape):
		collision_shape.set_deferred("disabled", not value)	

# Getter for showing
func get_showing() -> bool:
	return _showing

# Show/hide the object
func show_object(value:bool) -> void:
	set_showing(value)		
	
# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

