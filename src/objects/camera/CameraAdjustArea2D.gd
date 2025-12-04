class_name CameraAdjustArea
extends Area2D

enum CameraAdjustType {
	X_OFFSET = 0,		# Adjust only camera x offset
	Y_OFFSET = 1,   	# Adjust only camera y offset
	X_AND_Y_OFFSET = 2  # Adjust both camera x and y offset
}

enum Mode {
	SET_ON_ENTER_RESET_ON_EXIT,
	SET_ON_ENTER,	 # Set the camera offset on enter but don't reset on exit
	RESET_ON_EXIT	 # Only reset the camera on exit
}

enum yOffsetOption {
	UP,		# Set the y offset up (for climbing sections)
	DOWN	# Set the y offset down (for descending sections)
}

enum xOffsetOption {
	MEDIUM,	 # Medium distance in front of player
	NONE	 # No offset to prevent major camera swings due to auto camera adjustment that moves the offset to work no matter what direction the player is looking
}

enum AreaEdge {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM,
	UNKNOWN
}

export (CameraAdjustType) var camera_adjust_type = CameraAdjustType.Y_OFFSET
export (Mode) var mode = Mode.SET_ON_ENTER_RESET_ON_EXIT
export (bool) var trigger_enter_once = true
export (bool) var trigger_exit_once = false

# Specify which edge triggers an enter
export (AreaEdge) var enter_edge = AreaEdge.UNKNOWN	 # Defaults to no specific edge

# Specify which edge triggers an exit
export (AreaEdge) var exit_edge = AreaEdge.UNKNOWN	 # Defaults to no specific edge


# What to set the camera y offset on entering the area
export (yOffsetOption) var y_offset_on_enter = yOffsetOption.DOWN

# What to set the camera x offset on entering the area
export (xOffsetOption) var x_offset_on_enter = xOffsetOption.MEDIUM	 # This is the camera default

onready var collision_shape = get_node("CollisionShape2D")

var entered = false
var exitted = false

# The global positions of the edges of the collision shape rectangle
# Used for detecting which edge an area was entered and for triggering enter
# and exit on specific edges
var left_edge_x = 0
var right_edge_x = 0
var top_edge_y = 0
var bottom_edge_y = 0

# Need quite a broad threshold in pixels due to speed at which body crosses the edge
# NB: Due to threshold size make sure collision shape is positioned and large enough so that
# the body can clearly enter from a single edge 
const edge_proximity_threshold = 40 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the extents (half size) of the rectangle and its global position
	# to determine the position of the areas edges
	var rectangle_shape = collision_shape.shape
	if rectangle_shape is RectangleShape2D:
		var extents = rectangle_shape.extents
		left_edge_x = collision_shape.global_position.x - extents.x
		right_edge_x = collision_shape.global_position.x + extents.x
		top_edge_y = collision_shape.global_position.y - extents.y
		bottom_edge_y = collision_shape.global_position.y + extents.y


func _on_Area2D_body_entered(body):
	if !_body_is_player(body):
		return	
	
	var edge_crossed = _get_edge_crossed(body)
	if enter_edge != AreaEdge.UNKNOWN and enter_edge != edge_crossed:
		# entry did not occur on the specified edge
		return
			
	if trigger_enter_once and entered:
		return
	
	print(">> Area entered!")
		 
	entered = true
	if mode != Mode.SET_ON_ENTER_RESET_ON_EXIT and mode != Mode.SET_ON_ENTER:
		return
	
	if mode == Mode.SET_ON_ENTER and entered and exitted:
		# For set on enter without reset, don't set again if player has already entered and exitted
		return			
		
	var camera_manager = _get_camera_manager(body)
	if camera_manager:
		if camera_adjust_type == CameraAdjustType.Y_OFFSET or camera_adjust_type == CameraAdjustType.X_AND_Y_OFFSET:
			print('Camera Area Entered', body.global_position)
			
			var camera_y_offset_type
			match(y_offset_on_enter):
				yOffsetOption.DOWN:
					camera_y_offset_type = CameraManager.yOffsetType.OFFSET_DOWN
				yOffsetOption.UP:
					camera_y_offset_type = CameraManager.yOffsetType.OFFSET_UP
				_:
					camera_y_offset_type = CameraManager.yOffsetType.OFFSET_NONE	
			camera_manager.set_y_offset_type(camera_y_offset_type)
			
		if camera_adjust_type == CameraAdjustType.X_OFFSET or camera_adjust_type == CameraAdjustType.X_AND_Y_OFFSET:
			print('Camera Area Entered', body.global_position)
			var camera_x_offset_type
			match(x_offset_on_enter):
				xOffsetOption.MEDIUM:
					camera_x_offset_type = CameraManager.xOffsetType.OFFSET_MEDIUM
				_:
					camera_x_offset_type = CameraManager.xOffsetType.OFFSET_NONE
			camera_manager.set_x_offset_type(camera_x_offset_type)


func _on_Area2D_body_exited(body):
	if !_body_is_player(body):
		return
		
	var edge_crossed = _get_edge_crossed(body)
	if enter_edge != AreaEdge.UNKNOWN and exit_edge != edge_crossed:
		# exit did not occur on the specified edge
		return
		
	if trigger_exit_once and exitted:
		return
		
	print(">> Area exitted!")		
		
	exitted = true
	if mode != Mode.SET_ON_ENTER_RESET_ON_EXIT and mode != Mode.RESET_ON_EXIT:
		return
		
	var camera_manager = _get_camera_manager(body)
	if camera_manager:
		print('Camera Area Exitted', body.global_position)
		if camera_adjust_type == CameraAdjustType.Y_OFFSET or camera_adjust_type == CameraAdjustType.X_AND_Y_OFFSET:
			camera_manager.reset_y_offset_type()
		if camera_adjust_type == CameraAdjustType.X_OFFSET or camera_adjust_type == CameraAdjustType.X_AND_Y_OFFSET:
			camera_manager.reset_x_offset_type()


# Determine the edge of the area2d rectangle collision shape that
# the body crossed
func _get_edge_crossed(body) -> int:
	var global_position = body.global_position
	if abs(global_position.x - left_edge_x) <= edge_proximity_threshold:
		print("Crossed left edge")
		return AreaEdge.LEFT
	elif abs(global_position.x - right_edge_x) <= edge_proximity_threshold:
		print("Crossed right edge")
		return AreaEdge.RIGHT	
	elif abs(global_position.y - bottom_edge_y) <= edge_proximity_threshold:
		print("Crossed bottom edge")
		return AreaEdge.BOTTOM	
	elif abs(global_position.y - top_edge_y) <= edge_proximity_threshold:
		print("Crossed top edge")
		return AreaEdge.TOP	
	else:
		print("Crossed unknown edge")
		return AreaEdge.UNKNOWN
	

func _body_is_player(body):
	return body.is_in_group(Constants.GROUP_PLAYER)


# Get the camera manager from the player
func _get_camera_manager(body) -> CameraManager:
	if _body_is_player(body):
		var player = body as Player
		return player.get_camera_manager()
	else:
		return null
