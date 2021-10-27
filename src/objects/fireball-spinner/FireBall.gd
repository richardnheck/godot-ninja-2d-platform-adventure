extends Node2D
class_name FireBall

var _showing:bool = false setget _set_showing, _get_showing

onready var animation_player:AnimationPlayer = $AnimationPlayer

onready var tween:Tween = $Tween
onready var tween2:Tween = $Tween2

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


# Change the direction of the fireball so it smoothly rotates to the opposite direction
func change_direction(clockwise: bool, swing_time: float) -> void:
	# Set the tween length based on the time in takes to complete a full swing
	# This value has been tweaked until the rotation speeds looks natural
	var tween_length = swing_time / 4.0;
	
	# Rotate the first 90 degrees
	var tween_values = []
	if clockwise:
		tween_values = [rotation_degrees , rotation_degrees - 90]
	else:
		tween_values = [rotation_degrees , rotation_degrees + 90]
	
	tween.interpolate_property(self, "rotation_degrees", tween_values[0], tween_values[1], tween_length, Tween.TRANS_LINEAR)
	tween.start()	
	
	yield(tween, "tween_completed")

	# Rotate the last 90 degrees so the fireball is in the opposite direction
	if clockwise:
		tween_values = [rotation_degrees , rotation_degrees - 90]
	else:
		tween_values = [rotation_degrees , rotation_degrees + 90]
		
	tween.interpolate_property(self, "rotation_degrees", tween_values[0], tween_values[1], tween_length, Tween.TRANS_LINEAR)
	tween.start()	
	
	
# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER) and _showing:
		# The body is the player so the player dies
		body.die()

