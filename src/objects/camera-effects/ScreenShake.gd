extends Node2D
class_name ScreenShake

var current_shake_priority = 0

func _ready():
	pass


func screen_shake(shake_length, shake_power, shake_priority):
	if shake_priority > current_shake_priority:
		current_shake_priority = shake_priority
		$Tween.interpolate_method(self, "_move_camera", Vector2(shake_power, shake_power), Vector2(0,0), shake_length, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
		$Tween.start()

func _move_camera(vector:Vector2):
	get_parent().get_node("Player/Camera2D").offset = Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y))

func _on_Tween_tween_completed(object, key):
	current_shake_priority = 0
