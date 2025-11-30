class_name CameraManager
extends Node2D

onready var camera:Camera2D = $"%Camera2D"
onready var camera_offset:= $Pivot/CameraOffset
onready var yoffset_tween:= $YOffsetTween

const DEFAULT_Y_OFFSET = -16  # This is the value set in the "CameraOffset" y position in the editor

var y_offset_tween_values = [0,0]

func _ready():
	pass # Replace with function body.
	
		
func get_camera() -> Camera2D:
	return camera


func set_camera_y_offset(new_offset):
	y_offset_tween_values = [Vector2(camera_offset.position.x, DEFAULT_Y_OFFSET), Vector2(camera_offset.position.x,new_offset)]
	yoffset_tween.interpolate_property(camera_offset,"position", y_offset_tween_values[0], y_offset_tween_values[1], 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	yoffset_tween.start()


func restore_camera_y_offset():
	y_offset_tween_values.invert()
	yoffset_tween.interpolate_property(camera_offset,"position", y_offset_tween_values[0], y_offset_tween_values[1], 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	yoffset_tween.start()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
