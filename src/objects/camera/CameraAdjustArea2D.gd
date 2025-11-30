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

export (CameraAdjustType) var camera_adjust_type = CameraAdjustType.Y_OFFSET
export (Mode) var mode = Mode.SET_ON_ENTER_RESET_ON_EXIT


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if mode != Mode.SET_ON_ENTER_RESET_ON_EXIT:
		return
		
	var camera_manager = _get_camera_manager(body)
	if camera_manager:
		camera_manager.set_y_offset_type(CameraManager.yOffsetType.OFFSET_DOWN)


func _on_Area2D_body_exited(body):
	if mode != Mode.SET_ON_ENTER_RESET_ON_EXIT:
		return
		
	var camera_manager = _get_camera_manager(body)
	if camera_manager:
		camera_manager.reset_y_offset_type()
	

# Get the camera manager from the player
func _get_camera_manager(body) -> CameraManager:
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as Player
		return player.get_camera_manager()
	else:
		return null
