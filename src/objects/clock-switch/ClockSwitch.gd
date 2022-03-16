tool
extends Node2D
class_name ClockSwitch

signal switched(active)

#
export(int, 1, 1000) var sending_channel:int = 1 setget _set_sending_channel

# true means active, false means inactive
export(bool) var start_state:bool = true setget _set_start_state

# 
export(float, 0.5,10,0.5) var on_seconds:float = 1 setget _set_on_seconds

#  
export(float, 0.5,10,0.5) var off_seconds:float = 1 setget _set_off_seconds

#
export(bool) var invisible:bool = true setget _set_invisible

onready var on_timer:Timer = $OnTimer
onready var off_timer:Timer = $OffTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.editor_hint:
		$Sprite.visible = not invisible
		$SendingChannelLabel.visible = not invisible 
	else:
		$Sprite.visible = true
	
	on_timer.wait_time = on_seconds
	off_timer.wait_time = off_seconds
	
	if start_state == true: 
		# active
		on_timer.start()
		emit_signal("switched", true)
		


func _set_sending_channel(value) -> void:
	sending_channel = value
	$SendingChannelLabel.text = String(value)
	update()

func _set_start_state(value) -> void:
	start_state = value
	update()

func _set_on_seconds(value) -> void:
	on_seconds = value
	update()

func _set_off_seconds(value) -> void:
	off_seconds = value
	update()

func _set_invisible(value) -> void:
	invisible = value
	update()


func _on_OnTimer_timeout() -> void:
	off_timer.start()
	emit_signal("switched", false)


func _on_OffTimer_timeout() -> void:
	on_timer.start()
	emit_signal("switched", true)
