
extends Node2D

export (int, 32,64) var length = 64
export var delay_time := 0.0
export var on_time := 1.0
export var off_time := 1.0
export (bool) var show_base_left = true
export (bool) var show_base_right = true

onready var on_timer:= $OnTimer
onready var off_timer:= $OffTimer
onready var electricity_area2d := $ElectricityArea2D
onready var base_left := $BaseLeftSprite
onready var base_right := $BaseRightSprite
onready var collision_shape := $ElectricityArea2D/CollisionShape2D
onready var sprite32 := $ElectricityArea2D/ElectricityAnimatedSprite32
onready var sprite64 := $ElectricityArea2D/ElectricityAnimatedSprite64
onready var left_marker_line2d := $LeftMarkerLine2D

var _initialised = false

var sfx_electricity_pulse: AudioStreamPlayer2D = null

func _ready():
	sfx_electricity_pulse = Game_AudioManager.sfx_env_electricity_pulse.duplicate()
	add_child(sfx_electricity_pulse)
	
	if not Engine.editor_hint:
		left_marker_line2d.visible = false
		
	on_timer.wait_time = on_time
	off_timer.wait_time = off_time
	
	base_left.position.x = -(length / 2) + 8
	base_left.visible = show_base_left
	base_right.position.x = (length / 2) - 8
	base_right.visible = show_base_right
	collision_shape.scale.x = length / 64.0
	
	sprite32.visible = length == 32
	sprite64.visible = length == 64
	
	# Electicity is off by default
	_enable(false)
		
	
func _initialise():
	if delay_time > 0:
		yield(get_tree().create_timer(delay_time), "timeout")
		
	# Start the electricity cycle
	_enable(true)
	on_timer.start()
	_initialised = true
	

func _enable(enable:bool):
	if enable:
		sfx_electricity_pulse.play()
	else:
		sfx_electricity_pulse.stop()
		
	electricity_area2d.visible = enable
	electricity_area2d.monitoring = enable
	sprite32.playing = enable and length == 32	
	sprite64.playing = enable and length == 64
		

func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_OnTimer_timeout():
	# On cycle has finished
	_enable(false)
	off_timer.start()


func _on_OffTimer_timeout():
	# Off cycle has finished
	_enable(true)
	on_timer.start()


func _on_VisibilityNotifier2D_screen_entered():
	_initialise()


func _on_VisibilityNotifier2D_screen_exited():
	pass # Replace with function body.
