extends Node2D

export var delay_time := 0
export var on_time := 1
export var off_time := 1

onready var on_timer:= $OnTimer
onready var off_timer:= $OffTimer
onready var electricity_area2d := $ElectricityArea2D


func _ready():
	on_timer.wait_time = on_time
	off_timer.wait_time = off_time
	
	# Electicity is off by default
	_enable(false)
	
	if delay_time > 0:
		yield(get_tree().create_timer(delay_time), "timeout")
		
	# Start the electricity cycle
	_enable(true)
	on_timer.start()
	

func _enable(enable:bool):
	electricity_area2d.visible = enable
	electricity_area2d.monitoring = enable
		

func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_OnTimer_timeout():
	print_debug("on timeout")
	# On cycle has finished
	_enable(false)
	off_timer.start()


func _on_OffTimer_timeout():
	print_debug("off timeout")
	# Off cycle has finished
	_enable(true)
	on_timer.start()
