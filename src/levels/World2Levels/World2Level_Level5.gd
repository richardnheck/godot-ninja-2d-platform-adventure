extends LevelBase

func _ready():
	# Always set the y offset of the camera to be down for this level
	# It is easier to do it in a script here than adding camera adjust areas
	# at the start and at the checkpoints, so camera is set properly if player respawns
	var camera_manager:CameraManager = player.get_node("CameraManager")
	camera_manager.set_y_offset_type(CameraManager.yOffsetType.OFFSET_DOWN)
