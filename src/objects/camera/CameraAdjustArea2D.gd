class_name CameraAdjustArea
extends Area2D

enum CameraAdjustType {
	X_OFFSET = 0,		# Adjust only camera x offset
	Y_OFFSET = 1,   	# Adjust only camera y offset
	X_AND_Y_OFFSET = 2  # Adjust both camera x and y offset
}

enum Mode {
	SET_ON_ENTER_RESET_ON_EXIT = 0	
}

enum yOffsetOption {
	UP,		# Set the y offset up (for climbing sections)
	DOWN	# Set the y offset down (for descending sections)
}

enum xOffsetOption {
	MEDIUM,	 # Medium distance in front of player
	NONE	 # No offset to prevent major camera swings due to auto camera adjustment that moves the offset to work no matter what direction the player is looking
}

export (CameraAdjustType) var camera_adjust_type = CameraAdjustType.Y_OFFSET
export (Mode) var mode = Mode.SET_ON_ENTER_RESET_ON_EXIT

# What to set the camera y offset on entering the area
export (yOffsetOption) var y_offset_on_enter = yOffsetOption.DOWN

# What to set the camera x offset on entering the area
export (xOffsetOption) var x_offset_on_enter = xOffsetOption.MEDIUM	 # This is the camera default


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if mode != Mode.SET_ON_ENTER_RESET_ON_EXIT:
		return
		
	var camera_manager = _get_camera_manager(body)
	if camera_manager:
		if camera_adjust_type == CameraAdjustType.Y_OFFSET or camera_adjust_type == CameraAdjustType.X_AND_Y_OFFSET:
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
			var camera_x_offset_type
			match(x_offset_on_enter):
				xOffsetOption.MEDIUM:
					camera_x_offset_type = CameraManager.xOffsetType.OFFSET_MEDIUM
				_:
					camera_x_offset_type = CameraManager.xOffsetType.OFFSET_NONE
			camera_manager.set_x_offset_type(camera_x_offset_type)


func _on_Area2D_body_exited(body):
	if mode != Mode.SET_ON_ENTER_RESET_ON_EXIT:
		return
		
	var camera_manager = _get_camera_manager(body)
	if camera_manager:
		if camera_adjust_type == CameraAdjustType.Y_OFFSET or camera_adjust_type == CameraAdjustType.X_AND_Y_OFFSET:
			camera_manager.reset_y_offset_type()
		if camera_adjust_type == CameraAdjustType.X_OFFSET or camera_adjust_type == CameraAdjustType.X_AND_Y_OFFSET:
			camera_manager.reset_x_offset_type()
	

# Get the camera manager from the player
func _get_camera_manager(body) -> CameraManager:
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as Player
		return player.get_camera_manager()
	else:
		return null
