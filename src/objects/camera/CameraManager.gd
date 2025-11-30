class_name CameraManager
extends Node2D

enum yOffsetType {
	OFFSET_DOWN,   	# y offset shifted so player can see more below
	OFFSET_UP,	   	# y offset shifted so player can see more above
	OfFSET_NONE		# y offset is balanced equally for seeing above and below 
}

onready var camera:Camera2D = $"%Camera2D"
onready var pivot:Position2D = $Pivot
onready var camera_offset:= $Pivot/CameraOffset
onready var yoffset_tween:= $YOffsetTween
onready var player = $'..'

# This affects the speed at which the camera switches positions to make the camera offset
# in front of the player depending on their direction
const CAMERA_WEIGHT = 1.4
const CAMERA_POSITION_OFFSET = 48 
const PLAYER_VELOCITY_THRESHOLD = 100

# A history of the players velocity to be able to determine when best to
# adjust the camera xoffset automatically 
const HISTORY_SIZE = 20 # The number of velocity frames to store
var velocity_history = []

const Y_OFFSET_UP = -16.0  # This is the default value set in the "CameraOffset" y position in the editor
const Y_OFFSET_DOWN = 32.0
const Y_OFFSET_NONE = 0.0 

var y_offset_tween_values = [0.0,0.0]

func _ready():
	pass # Replace with function body.
	

func _physics_process(delta: float) -> void:
	velocity_history.append(_get_player_velocity())
	
	if velocity_history.size() > HISTORY_SIZE:
		velocity_history.remove(0)
	
	_update_pivot_position(delta)


func get_camera() -> Camera2D:
	return camera


# Set the type of y offset to apply to the camera
func set_y_offset_type(type:int):
	var y_offset = 0.0
	match type:
		yOffsetType.OFFSET_UP:
			y_offset = Y_OFFSET_UP
		yOffsetType.OFFSET_DOWN:
			y_offset = Y_OFFSET_DOWN
		yOffsetType.NONE:
			y_offset = Y_OFFSET_NONE
		_:
			y_offset = Y_OFFSET_NONE
	
	_set_camera_y_offset(y_offset)
	
# Reset the y offset back to the default
func reset_y_offset_type():
	_reset_camera_y_offset()


func _set_camera_y_offset(new_offset):
	print("set_camera_y_offset", new_offset)
	y_offset_tween_values = [Vector2(camera_offset.position.x, Y_OFFSET_UP), Vector2(camera_offset.position.x, new_offset)]
	print("y_offset_tween_values", str(y_offset_tween_values))
	yoffset_tween.interpolate_property(camera_offset,"position", y_offset_tween_values[0], y_offset_tween_values[1], 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	yoffset_tween.start()


func _reset_camera_y_offset():
	print("reset_camera_y_offset")
	y_offset_tween_values.invert()
	print("y_offset_tween_values", str(y_offset_tween_values))
	yoffset_tween.interpolate_property(camera_offset,"position", y_offset_tween_values[0], y_offset_tween_values[1], 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	yoffset_tween.start()
	
	# Momentarily disable drag v_margin to allow camera to adjust
	# This is required otherwise the camera does adjust upward enough until they jump
	camera.drag_margin_v_enabled=false
	yield(get_tree().create_timer(1), "timeout")
	camera.drag_margin_v_enabled=true	
	
func _on_YOffsetTween_tween_completed(object, key):
	pass
		
	

func _update_pivot_position(delta):
	var avg_velocity := _calculate_average_velocity()
	if(abs(avg_velocity.x) > PLAYER_VELOCITY_THRESHOLD):
		var nextpos = CAMERA_POSITION_OFFSET if player.look_direction.x == 1 else -CAMERA_POSITION_OFFSET*2
		pivot.position.x = floor(lerp(pivot.position.x, nextpos, delta * CAMERA_WEIGHT ))

func _get_player_velocity():
	if !player:
		return 0
		
	var current_state = player.get_current_state()
	if current_state != null:
		return current_state.velocity if current_state.velocity != null else 0
	else:
		return 0


func _calculate_average_velocity() -> Vector2:
	if velocity_history.empty():
		return Vector2.ZERO

	var total_velocity = Vector2.ZERO
	for v in velocity_history:
		total_velocity += v

	return total_velocity / velocity_history.size()

